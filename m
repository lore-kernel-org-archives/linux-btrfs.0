From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 16:37:02 +0100
Message-ID: <1231774622.4371.96.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Subject: mutex: implement adaptive spinning
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jan 12 14:01:47 CET 2009

Change mutex contention behaviour such that it will sometimes busy wait on
acquisition - moving its behaviour closer to that of spinlocks.

This concept got ported to mainline from the -rt tree, where it was originally
implemented for rtmutexes by Steven Rostedt, based on work by Gregory Haskins.

Testing with Ingo's test-mutex application (http://lkml.org/lkml/2006/1/8/50)
gave a 345% boost for VFS scalability on my testbox:

 # ./test-mutex-shm V 16 10 | grep "^avg ops"
 avg ops/sec:               296604

 # ./test-mutex-shm V 16 10 | grep "^avg ops"
 avg ops/sec:               85870

The key criteria for the busy wait is that the lock owner has to be running on
a (different) cpu. The idea is that as long as the owner is running, there is a
fair chance it'll release the lock soon, and thus we'll be better off spinning
instead of blocking/scheduling.

Since regular mutexes (as opposed to rtmutexes) do not atomically track the
owner, we add the owner in a non-atomic fashion and deal with the races in
the slowpath.

Furthermore, to ease the testing of the performance impact of this new code,
there is means to disable this behaviour runtime (without having to reboot
the system), when scheduler debugging is enabled (CONFIG_SCHED_DEBUG=y),
by issuing the following command:

 # echo NO_OWNER_SPIN > /debug/sched_features

This command re-enables spinning again (this is also the default):

 # echo OWNER_SPIN > /debug/sched_features

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Changes since -v7:
 - made all the mutex ops fully non-preemptible
   - this fixes the getting preempted with owner=null issues
 - implemented FIFO fairness using the wait_list
 - fixed owner tracking issues

Dmitry noted that since we now have FIFO order, we need not put all
spinners to rest when one falls into schedule, but only those behind
it in the queue -- I haven't yet implemented this, but it should be
doable without a list-walk.

PREEMPT_NONE, PREEMPT_VOLUNTARY work as advertised
PREEMPT=y still seems to madly over-preempt or something.

 include/linux/mutex.h   |   10 ++-
 include/linux/sched.h   |    3 
 kernel/mutex-debug.c    |    9 --
 kernel/mutex-debug.h    |   18 +++--
 kernel/mutex.c          |  154 ++++++++++++++++++++++++++++++++++++++++++------
 kernel/mutex.h          |   22 ++++++
 kernel/sched.c          |   82 ++++++++++++++++++++++++-
 kernel/sched_features.h |    1 
 8 files changed, 257 insertions(+), 42 deletions(-)

Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
@@ -50,8 +50,11 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_MUTEXES
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct thread_info	*owner;
+	int			waiters;
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
 	void			*magic;
 #endif
@@ -67,8 +70,11 @@ struct mutex {
 struct mutex_waiter {
 	struct list_head	list;
 	struct task_struct	*task;
-#ifdef CONFIG_DEBUG_MUTEXES
 	struct mutex		*lock;
+#ifdef CONFIG_SMP
+	int			spin;
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
 	void			*magic;
 #endif
 };
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -328,7 +328,10 @@ extern signed long schedule_timeout(sign
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
+extern int mutex_spin_on_owner(struct mutex_waiter *waiter,
+			       struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
Index: linux-2.6/kernel/mutex-debug.c
===================================================================
--- linux-2.6.orig/kernel/mutex-debug.c
+++ linux-2.6/kernel/mutex-debug.c
@@ -26,11 +26,6 @@
 /*
  * Must be called with lock->wait_lock held.
  */
-void debug_mutex_set_owner(struct mutex *lock, struct thread_info *new_owner)
-{
-	lock->owner = new_owner;
-}
-
 void debug_mutex_lock_common(struct mutex *lock, struct mutex_waiter *waiter)
 {
 	memset(waiter, MUTEX_DEBUG_INIT, sizeof(*waiter));
@@ -59,7 +54,6 @@ void debug_mutex_add_waiter(struct mutex
 
 	/* Mark the current thread as blocked on the lock: */
 	ti->task->blocked_on = waiter;
-	waiter->lock = lock;
 }
 
 void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
@@ -82,7 +76,7 @@ void debug_mutex_unlock(struct mutex *lo
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	mutex_clear_owner(lock);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
@@ -95,7 +89,6 @@ void debug_mutex_init(struct mutex *lock
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->owner = NULL;
 	lock->magic = lock;
 }
 
Index: linux-2.6/kernel/mutex-debug.h
===================================================================
--- linux-2.6.orig/kernel/mutex-debug.h
+++ linux-2.6/kernel/mutex-debug.h
@@ -13,14 +13,6 @@
 /*
  * This must be called with lock->wait_lock held.
  */
-extern void
-debug_mutex_set_owner(struct mutex *lock, struct thread_info *new_owner);
-
-static inline void debug_mutex_clear_owner(struct mutex *lock)
-{
-	lock->owner = NULL;
-}
-
 extern void debug_mutex_lock_common(struct mutex *lock,
 				    struct mutex_waiter *waiter);
 extern void debug_mutex_wake_waiter(struct mutex *lock,
@@ -35,6 +27,16 @@ extern void debug_mutex_unlock(struct mu
 extern void debug_mutex_init(struct mutex *lock, const char *name,
 			     struct lock_class_key *key);
 
+static inline void mutex_set_owner(struct mutex *lock)
+{
+	lock->owner = current_thread_info();
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+	lock->owner = NULL;
+}
+
 #define spin_lock_mutex(lock, flags)			\
 	do {						\
 		struct mutex *l = container_of(lock, struct mutex, wait_lock); \
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -10,6 +10,11 @@
  * Many thanks to Arjan van de Ven, Thomas Gleixner, Steven Rostedt and
  * David Howells for suggestions and improvements.
  *
+ *  - Adaptive spinning for mutexes by Peter Zijlstra. (Ported to mainline
+ *    from the -rt tree, where it was originally implemented for rtmutexes
+ *    by Steven Rostedt, based on work by Gregory Haskins, Peter Morreale
+ *    and Sven Dietrich.
+ *
  * Also see Documentation/mutex-design.txt.
  */
 #include <linux/mutex.h>
@@ -46,6 +51,7 @@ __mutex_init(struct mutex *lock, const c
 	atomic_set(&lock->count, 1);
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
+	mutex_clear_owner(lock);
 
 	debug_mutex_init(lock, name, key);
 }
@@ -90,7 +96,10 @@ void inline __sched mutex_lock(struct mu
 	 * The locking fastpath is the 1->0 transition from
 	 * 'unlocked' into 'locked' state.
 	 */
+	preempt_disable();
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	mutex_set_owner(lock);
+	preempt_enable();
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -115,11 +124,86 @@ void __sched mutex_unlock(struct mutex *
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
+	preempt_disable();
+#ifndef CONFIG_DEBUG_MUTEXES
+	/*
+	 * When debugging is enabled we must not clear the owner before time,
+	 * the slow path will always be taken, and that clears the owner field
+	 * after verifying that it was indeed current.
+	 */
+	mutex_clear_owner(lock);
+#endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
+	preempt_enable();
 }
 
 EXPORT_SYMBOL(mutex_unlock);
 
+#ifdef CONFIG_SMP
+static void mutex_spin_or_schedule(struct mutex_waiter *waiter,
+				   unsigned long *flags)
+{
+	struct mutex *lock = waiter->lock;
+
+	waiter->spin = !lock->waiters;
+	if (!waiter->spin)
+		goto sleep;
+
+	spin_unlock_mutex(&lock->wait_lock, *flags);
+	while (waiter->spin && !lock->waiters) {
+		struct thread_info *owner;
+
+		/* Busy wait on the owner, if any. */
+		owner = ACCESS_ONCE(lock->owner);
+		if (owner && !mutex_spin_on_owner(waiter, owner))
+			break;
+
+		cpu_relax();
+	}
+	spin_lock_mutex(&lock->wait_lock, *flags);
+
+	if (!waiter->spin) {
+		__set_task_state(waiter->task, TASK_RUNNING);
+		return;
+	}
+	waiter->spin = 0;
+sleep:
+	/*
+	 * Stop all other spinners.
+	 */
+	lock->waiters++;
+	spin_unlock_mutex(&lock->wait_lock, *flags);
+
+	__schedule();
+
+	spin_lock_mutex(&lock->wait_lock, *flags);
+	lock->waiters--;
+}
+
+static void mutex_wake_up(struct mutex_waiter *waiter)
+{
+	if (waiter->spin)
+		waiter->spin = 0;
+	else
+		wake_up_process(waiter->task);
+}
+#else
+static void mutex_spin_or_schedule(struct mutex_waiter *waiter,
+				   unsigned long *flags)
+{
+	struct mutex *lock = waiter->lock;
+
+	spin_unlock_mutex(&lock->wait_lock, *flags);
+	__schedule();
+	spin_lock_mutex(&lock->wait_lock, *flags);
+}
+
+static void mutex_wake_up(struct mutex_waiter *waiter)
+{
+	wake_up_process(waiter->task);
+}
+#endif
+
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
@@ -129,7 +213,6 @@ __mutex_lock_common(struct mutex *lock, 
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
-	unsigned int old_val;
 	unsigned long flags;
 
 	spin_lock_mutex(&lock->wait_lock, flags);
@@ -141,9 +224,9 @@ __mutex_lock_common(struct mutex *lock, 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
+	waiter.lock = lock;
 
-	old_val = atomic_xchg(&lock->count, -1);
-	if (old_val == 1)
+	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
 
 	lock_contended(&lock->dep_map, ip);
@@ -158,8 +241,7 @@ __mutex_lock_common(struct mutex *lock, 
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		old_val = atomic_xchg(&lock->count, -1);
-		if (old_val == 1)
+		if (atomic_xchg(&lock->count, -1) == 1)
 			break;
 
 		/*
@@ -178,16 +260,14 @@ __mutex_lock_common(struct mutex *lock, 
 		__set_task_state(task, state);
 
 		/* didnt get the lock, go to sleep: */
-		spin_unlock_mutex(&lock->wait_lock, flags);
-		schedule();
-		spin_lock_mutex(&lock->wait_lock, flags);
+		mutex_spin_or_schedule(&waiter, &flags);
 	}
 
 done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -205,7 +285,9 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
+	preempt_disable();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
+	preempt_enable();
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -213,16 +295,28 @@ EXPORT_SYMBOL_GPL(mutex_lock_nested);
 int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	preempt_disable();
+	ret = __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	preempt_enable();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
 int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	preempt_disable();
+	ret = __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	preempt_enable();
+
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -257,11 +351,9 @@ __mutex_unlock_common_slowpath(atomic_t 
 
 		debug_mutex_wake_waiter(lock, waiter);
 
-		wake_up_process(waiter->task);
+		mutex_wake_up(waiter);
 	}
 
-	debug_mutex_clear_owner(lock);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
 
@@ -298,18 +390,34 @@ __mutex_lock_interruptible_slowpath(atom
  */
 int __sched mutex_lock_interruptible(struct mutex *lock)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_fastpath_lock_retval
+	preempt_disable();
+	ret =  __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_interruptible_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
+	preempt_enable();
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
 
 int __sched mutex_lock_killable(struct mutex *lock)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_fastpath_lock_retval
+	preempt_disable();
+	ret = __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_killable_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
+	preempt_enable();
+
+	return ret;
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -352,9 +460,10 @@ static inline int __mutex_trylock_slowpa
 
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
-		debug_mutex_set_owner(lock, current_thread_info());
+		mutex_set_owner(lock);
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 	}
+
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -380,8 +489,15 @@ static inline int __mutex_trylock_slowpa
  */
 int __sched mutex_trylock(struct mutex *lock)
 {
-	return __mutex_fastpath_trylock(&lock->count,
-					__mutex_trylock_slowpath);
+	int ret;
+
+	preempt_disable();
+	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
+	if (ret)
+		mutex_set_owner(lock);
+	preempt_enable();
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_trylock);
Index: linux-2.6/kernel/mutex.h
===================================================================
--- linux-2.6.orig/kernel/mutex.h
+++ linux-2.6/kernel/mutex.h
@@ -16,8 +16,26 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#define debug_mutex_set_owner(lock, new_owner)		do { } while (0)
-#define debug_mutex_clear_owner(lock)			do { } while (0)
+#ifdef CONFIG_SMP
+static inline void mutex_set_owner(struct mutex *lock)
+{
+	lock->owner = current_thread_info();
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+	lock->owner = NULL;
+}
+#else
+static inline void mutex_set_owner(struct mutex *lock)
+{
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+}
+#endif
+
 #define debug_mutex_wake_waiter(lock, waiter)		do { } while (0)
 #define debug_mutex_free_waiter(waiter)			do { } while (0)
 #define debug_mutex_add_waiter(lock, waiter, ti)	do { } while (0)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4535,15 +4535,13 @@ pick_next_task(struct rq *rq, struct tas
 /*
  * schedule() is the main scheduler function.
  */
-asmlinkage void __sched schedule(void)
+asmlinkage void __sched __schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
 	int cpu;
 
-need_resched:
-	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	rcu_qsctr_inc(cpu);
@@ -4600,13 +4598,91 @@ need_resched_nonpreemptible:
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
+}
 
+asmlinkage void __sched schedule(void)
+{
+need_resched:
+	preempt_disable();
+	__schedule();
 	preempt_enable_no_resched();
 	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
 		goto need_resched;
 }
 EXPORT_SYMBOL(schedule);
 
+#ifdef CONFIG_SMP
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+int mutex_spin_on_owner(struct mutex_waiter *waiter, struct thread_info *owner)
+{
+	struct mutex *lock = waiter->lock;
+	unsigned int cpu;
+	struct rq *rq;
+	int ret = 1;
+
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
+
+	preempt_disable();
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * Need to access the cpu field knowing that
+	 * DEBUG_PAGEALLOC could have unmapped it if
+	 * the mutex owner just released it and exited.
+	 */
+	if (probe_kernel_address(&owner->cpu, cpu))
+		goto out;
+#else
+	cpu = owner->cpu;
+#endif
+
+	/*
+	 * Even if the access succeeded (likely case),
+	 * the cpu field may no longer be valid.
+	 */
+	if (cpu >= nr_cpumask_bits)
+		goto out;
+
+	/*
+	 * We need to validate that we can do a
+	 * get_cpu() and that we have the percpu area.
+	 */
+	if (!cpu_online(cpu))
+		goto out;
+
+	rq = cpu_rq(cpu);
+
+	while (waiter->spin && !lock->waiters) {
+		/*
+		 * Owner changed, break to re-assess state.
+		 */
+		if (lock->owner != owner)
+			break;
+
+		/*
+		 * Is that owner really running on that cpu?
+		 */
+		if (task_thread_info(rq->curr) != owner) {
+			ret = 0;
+			break;
+		}
+
+		if (need_resched()) {
+			ret = 0;
+			break;
+		}
+
+		cpu_relax();
+	}
+out:
+	preempt_enable_no_resched();
+	return ret;
+}
+#endif
+
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(OWNER_SPIN, 1)


