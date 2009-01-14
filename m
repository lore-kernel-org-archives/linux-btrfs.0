From: Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 19:33:19 +0100
Message-ID: <20090114183319.GA18630@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
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
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231952436.14825.28.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>


* Peter Zijlstra <peterz@infradead.org> wrote:

> Full series, including changelogs available at:
> 
>  http://programming.kicks-ass.net/kernel-patches/mutex-adaptive-spin/
> 
> and should shortly appear in a git tree near Ingo :-)

Linus,

Please pull the adaptive-mutexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git adaptive-mutexes-for-linus

We dropped two fresh patches from v11 for the time being: the two debug 
patches, they had test failures [they triggered mutex debugging false 
positives].

So this tree is v10 (which got a lot of testing already) plus Chris's 
performance patch. It passes all x86 runtime tests here.

The cross build matrix looks good too:

 testing 10 architectures.
 [ syncing linus ... ]
 testing      alpha:  -git:  pass (  21),  -tip:  pass (  21)
 testing        arm:  -git:  pass (   5),  -tip:  pass (   5)
 testing   blackfin:  -git:  pass (  20),  -tip:  pass (  20)
 testing       cris:  -git:  pass (  32),  -tip:  pass (  32)
 testing       ia64:  -git:  pass ( 153),  -tip:  pass ( 153)
 testing       m32r:  -git:  pass (  21),  -tip:  pass (  21)
 testing       m68k:  -git:  pass (  34),  -tip:  pass (  34)
 testing       mips:  -git:  pass (   4),  -tip:  pass (   4)
 testing    powerpc:  -git:  pass (  11),  -tip:  pass (  11)
 testing      sparc:  -git:  pass (   0),  -tip:  pass (   0)

Passes all and no new warnings.

So in theory this is good enough as a pre-rc2 pull too, should you feel 
tempted ;-)

 Thanks,

	Ingo

------------------>
Chris Mason (1):
      mutex: adaptive spinnning, performance tweaks

Peter Zijlstra (3):
      mutex: small cleanup
      mutex: preemption fixes
      mutex: implement adaptive spinning


 include/linux/mutex.h   |    5 +-
 include/linux/sched.h   |    2 +
 kernel/mutex-debug.c    |    9 +---
 kernel/mutex-debug.h    |   18 ++++---
 kernel/mutex.c          |  121 ++++++++++++++++++++++++++++++++++++++++-------
 kernel/mutex.h          |   22 ++++++++-
 kernel/sched.c          |   71 ++++++++++++++++++++++++++-
 kernel/sched_features.h |    1 +
 8 files changed, 209 insertions(+), 40 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 7a0e5c4..3069ec7 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -50,8 +50,10 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_MUTEXES
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct thread_info	*owner;
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
 	void			*magic;
 #endif
@@ -68,7 +70,6 @@ struct mutex_waiter {
 	struct list_head	list;
 	struct task_struct	*task;
 #ifdef CONFIG_DEBUG_MUTEXES
-	struct mutex		*lock;
 	void			*magic;
 #endif
 };
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cae9b8..c34b137 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -328,7 +328,9 @@ extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
+extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index 1d94160..50d022e 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
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
@@ -59,7 +54,6 @@ void debug_mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 
 	/* Mark the current thread as blocked on the lock: */
 	ti->task->blocked_on = waiter;
-	waiter->lock = lock;
 }
 
 void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
@@ -82,7 +76,7 @@ void debug_mutex_unlock(struct mutex *lock)
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	mutex_clear_owner(lock);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
@@ -95,7 +89,6 @@ void debug_mutex_init(struct mutex *lock, const char *name,
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->owner = NULL;
 	lock->magic = lock;
 }
 
diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
index babfbdf..6b2d735 100644
--- a/kernel/mutex-debug.h
+++ b/kernel/mutex-debug.h
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
@@ -35,6 +27,16 @@ extern void debug_mutex_unlock(struct mutex *lock);
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
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 4f45d4b..5d79781 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
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
@@ -46,6 +51,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	atomic_set(&lock->count, 1);
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
+	mutex_clear_owner(lock);
 
 	debug_mutex_init(lock, name, key);
 }
@@ -91,6 +97,7 @@ void inline __sched mutex_lock(struct mutex *lock)
 	 * 'unlocked' into 'locked' state.
 	 */
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	mutex_set_owner(lock);
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -115,6 +122,14 @@ void __sched mutex_unlock(struct mutex *lock)
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
+#ifndef CONFIG_DEBUG_MUTEXES
+	/*
+	 * When debugging is enabled we must not clear the owner before time,
+	 * the slow path will always be taken, and that clears the owner field
+	 * after verifying that it was indeed current.
+	 */
+	mutex_clear_owner(lock);
+#endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
 }
 
@@ -129,21 +144,75 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
-	unsigned int old_val;
 	unsigned long flags;
 
+	preempt_disable();
+	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+	/*
+	 * Optimistic spinning.
+	 *
+	 * We try to spin for acquisition when we find that there are no
+	 * pending waiters and the lock owner is currently running on a
+	 * (different) CPU.
+	 *
+	 * The rationale is that if the lock owner is running, it is likely to
+	 * release the lock soon.
+	 *
+	 * Since this needs the lock owner, and this mutex implementation
+	 * doesn't track the owner atomically in the lock field, we need to
+	 * track it non-atomically.
+	 *
+	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
+	 * to serialize everything.
+	 */
+
+	for (;;) {
+		struct thread_info *owner;
+
+		/*
+		 * If there's an owner, wait for it to either
+		 * release the lock or go to sleep.
+		 */
+		owner = ACCESS_ONCE(lock->owner);
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
+
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+			lock_acquired(&lock->dep_map, ip);
+			mutex_set_owner(lock);
+			preempt_enable();
+			return 0;
+		}
+
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(task)))
+			break;
+
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		cpu_relax();
+	}
+#endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	old_val = atomic_xchg(&lock->count, -1);
-	if (old_val == 1)
+	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
 
 	lock_contended(&lock->dep_map, ip);
@@ -158,8 +227,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		old_val = atomic_xchg(&lock->count, -1);
-		if (old_val == 1)
+		if (atomic_xchg(&lock->count, -1) == 1)
 			break;
 
 		/*
@@ -173,21 +241,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
 			debug_mutex_free_waiter(&waiter);
+			preempt_enable();
 			return -EINTR;
 		}
 		__set_task_state(task, state);
 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		schedule();
+		__schedule();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
 done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	mutex_remove_waiter(lock, &waiter, current_thread_info());
+	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -196,6 +265,7 @@ done:
 	spin_unlock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_free_waiter(&waiter);
+	preempt_enable();
 
 	return 0;
 }
@@ -222,7 +292,8 @@ int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
+				   subclass, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -260,8 +331,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
 
@@ -298,18 +367,30 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
  */
 int __sched mutex_lock_interruptible(struct mutex *lock)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_fastpath_lock_retval
+	ret =  __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_interruptible_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
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
+	ret = __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_killable_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -352,9 +433,10 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 
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
@@ -380,8 +462,13 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
  */
 int __sched mutex_trylock(struct mutex *lock)
 {
-	return __mutex_fastpath_trylock(&lock->count,
-					__mutex_trylock_slowpath);
+	int ret;
+
+	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
+	if (ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_trylock);
diff --git a/kernel/mutex.h b/kernel/mutex.h
index a075daf..67578ca 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 8be2c13..589e730 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4538,15 +4538,13 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
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
@@ -4603,13 +4601,80 @@ need_resched_nonpreemptible:
 
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
+int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+{
+	unsigned int cpu;
+	struct rq *rq;
+
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
+
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
+	for (;;) {
+		/*
+		 * Owner changed, break to re-assess state.
+		 */
+		if (lock->owner != owner)
+			break;
+
+		/*
+		 * Is that owner really running on that cpu?
+		 */
+		if (task_thread_info(rq->curr) != owner || need_resched())
+			return 0;
+
+		cpu_relax();
+	}
+out:
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..07bc02e 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(OWNER_SPIN, 1)
