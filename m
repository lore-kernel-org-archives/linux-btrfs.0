From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 07 Jan 2009 17:57:22 +0100
Message-ID: <1231347442.11687.344.camel@twins>
References: <87r63ljzox.fsf@basil.nowhere.org>
	 <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
	 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
	 <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
	 <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
	 <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>
	 <1231278275.11687.111.camel@twins>
	 <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
	 <1231279660.11687.121.camel@twins>
	 <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
	 <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 08:25 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Jan 2009, Peter Zijlstra wrote:
> >
> > Change mutex contention behaviour such that it will sometimes busy wait on
> > acquisition - moving its behaviour closer to that of spinlocks.
> 
> Ok, this one looks _almost_ ok.
> 
> The only problem is that I think you've lost the UP case. 
> 
> In UP, you shouldn't have the code to spin, and the "spin_or_schedule()" 
> should fall back to just the schedule case.
> 
> It migth also be worthwhile to try to not set the owner, and re-organize 
> that a bit (by making it a inline function that sets the owner only for 
> CONFIG_SMP or lockdep/debug). 

As you wish ;-)

---
Subject: mutex: implement adaptive spinning
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 6 Jan 2009 12:32:12 +0100

Change mutex contention behaviour such that it will sometimes busy wait on
acquisition - moving its behaviour closer to that of spinlocks.

This concept got ported to mainline from the -rt tree, where it was originally
implemented for rtmutexes by Steven Rostedt, based on work by Gregory Haskins.

Testing with Ingo's test-mutex application (http://lkml.org/lkml/2006/1/8/50)
gave a 8% boost for VFS scalability on my testbox:

  # echo MUTEX_SPIN > /debug/sched_features
  # ./test-mutex V 16 10
  2 CPUs, running 16 parallel test-tasks.
  checking VFS performance.

  avg ops/sec:                74910

  # echo NO_MUTEX_SPIN > /debug/sched_features
  # ./test-mutex V 16 10
  2 CPUs, running 16 parallel test-tasks.
  checking VFS performance.

  avg ops/sec:                68804

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

 # echo NO_MUTEX_SPIN > /debug/sched_features

This command re-enables spinning again (this is also the default):

 # echo MUTEX_SPIN > /debug/sched_features

There's also a few new statistic fields in /proc/sched_debug
(available if CONFIG_SCHED_DEBUG=y and CONFIG_SCHEDSTATS=y):

 # grep mtx /proc/sched_debug
  .mtx_spin                      : 2387
  .mtx_sched                     : 2283
  .mtx_spin                      : 1277
  .mtx_sched                     : 1700

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-and-signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mutex.h   |    6 ++--
 include/linux/sched.h   |    2 +
 kernel/mutex-debug.c    |   10 -------
 kernel/mutex-debug.h    |   13 +++------
 kernel/mutex.c          |   66 +++++++++++++++++++++++++++++++++++++++++-------
 kernel/mutex.h          |   13 ++++++++-
 kernel/sched.c          |   63 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_debug.c    |    2 +
 kernel/sched_features.h |    1 
 9 files changed, 146 insertions(+), 30 deletions(-)

Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
@@ -50,8 +50,10 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
+	struct task_struct	*owner;
+#endif
 #ifdef CONFIG_DEBUG_MUTEXES
-	struct thread_info	*owner;
 	const char 		*name;
 	void			*magic;
 #endif
@@ -67,8 +69,8 @@ struct mutex {
 struct mutex_waiter {
 	struct list_head	list;
 	struct task_struct	*task;
-#ifdef CONFIG_DEBUG_MUTEXES
 	struct mutex		*lock;
+#ifdef CONFIG_DEBUG_MUTEXES
 	void			*magic;
 #endif
 };
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -329,6 +329,8 @@ extern signed long schedule_timeout(sign
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+extern void mutex_spin_or_schedule(struct mutex_waiter *waiter,
+				   struct task_struct *owner, int cpu);
 asmlinkage void schedule(void);
 
 struct nsproxy;
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
@@ -80,9 +74,8 @@ void debug_mutex_unlock(struct mutex *lo
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	DEBUG_LOCKS_WARN_ON(lock->owner != current);
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
@@ -95,7 +88,6 @@ void debug_mutex_init(struct mutex *lock
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
@@ -35,6 +27,11 @@ extern void debug_mutex_unlock(struct mu
 extern void debug_mutex_init(struct mutex *lock, const char *name,
 			     struct lock_class_key *key);
 
+static inline void mutex_set_owner(struct mutex *lock, struct task_struct *owner)
+{
+	lock->owner = owner;
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
+	mutex_set_owner(lock, NULL);
 
 	debug_mutex_init(lock, name, key);
 }
@@ -91,6 +97,7 @@ void inline __sched mutex_lock(struct mu
 	 * 'unlocked' into 'locked' state.
 	 */
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	mutex_set_owner(lock, current);
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -115,6 +122,14 @@ void __sched mutex_unlock(struct mutex *
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
+#ifndef CONFIG_DEBUG_MUTEXES
+	/*
+	 * When debugging is enabled we must not clear the owner before time,
+	 * the slow path will always be taken, and that clears the owner field
+	 * after verifying that it was indeed current.
+	 */
+	mutex_set_owner(lock, NULL);
+#endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
 }
 
@@ -141,6 +156,7 @@ __mutex_lock_common(struct mutex *lock, 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
+	waiter.lock = lock;
 
 	old_val = atomic_xchg(&lock->count, -1);
 	if (old_val == 1)
@@ -149,6 +165,11 @@ __mutex_lock_common(struct mutex *lock, 
 	lock_contended(&lock->dep_map, ip);
 
 	for (;;) {
+#ifdef CONFIG_SMP
+		int cpu = 0;
+		struct task_struct *l_owner;
+#endif
+
 		/*
 		 * Lets try to take the lock again - this is needed even if
 		 * we get here for the first time (shortly after failing to
@@ -175,19 +196,28 @@ __mutex_lock_common(struct mutex *lock, 
 			debug_mutex_free_waiter(&waiter);
 			return -EINTR;
 		}
-		__set_task_state(task, state);
 
-		/* didnt get the lock, go to sleep: */
+		__set_task_state(task, state);
+#ifdef CONFIG_SMP
+		l_owner = ACCESS_ONCE(lock->owner);
+		if (l_owner)
+			cpu = task_cpu(l_owner);
+		spin_unlock_mutex(&lock->wait_lock, flags);
+		mutex_spin_or_schedule(&waiter, l_owner, cpu);
+		spin_lock_mutex(&lock->wait_lock, flags);
+#else
 		spin_unlock_mutex(&lock->wait_lock, flags);
 		schedule();
 		spin_lock_mutex(&lock->wait_lock, flags);
+#endif
 	}
+	__set_task_state(task, TASK_RUNNING);
 
 done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	mutex_set_owner(lock, task);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -260,7 +290,7 @@ __mutex_unlock_common_slowpath(atomic_t 
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
+	mutex_set_owner(lock, NULL);
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
@@ -298,18 +328,30 @@ __mutex_lock_interruptible_slowpath(atom
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
+		mutex_set_owner(lock, current);
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
+		mutex_set_owner(lock, current);
+
+	return ret;
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -352,9 +394,10 @@ static inline int __mutex_trylock_slowpa
 
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
-		debug_mutex_set_owner(lock, current_thread_info());
+		mutex_set_owner(lock, current);
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 	}
+
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -380,8 +423,13 @@ static inline int __mutex_trylock_slowpa
  */
 int __sched mutex_trylock(struct mutex *lock)
 {
-	return __mutex_fastpath_trylock(&lock->count,
-					__mutex_trylock_slowpath);
+	int ret;
+
+	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
+	if (ret)
+		mutex_set_owner(lock, current);
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_trylock);
Index: linux-2.6/kernel/mutex.h
===================================================================
--- linux-2.6.orig/kernel/mutex.h
+++ linux-2.6/kernel/mutex.h
@@ -16,8 +16,17 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#define debug_mutex_set_owner(lock, new_owner)		do { } while (0)
-#define debug_mutex_clear_owner(lock)			do { } while (0)
+#ifdef CONFIG_SMP
+static inline void mutex_set_owner(struct mutex *lock, struct task_struct *owner)
+{
+	lock->owner = owner;
+}
+#else
+static inline void mutex_set_owner(struct mutex *lock, struct task_struct *owner)
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
@@ -631,6 +631,10 @@ struct rq {
 
 	/* BKL stats */
 	unsigned int bkl_count;
+
+	/* mutex spin stats */
+	unsigned int mtx_spin;
+	unsigned int mtx_sched;
 #endif
 };
 
@@ -4596,6 +4600,65 @@ pick_next_task(struct rq *rq, struct tas
 	}
 }
 
+#ifdef CONFIG_SMP
+void mutex_spin_or_schedule(struct mutex_waiter *waiter,
+			    struct task_struct *owner, int cpu)
+{
+	struct task_struct *task = waiter->task;
+	struct mutex *lock = waiter->lock;
+	struct rq *rq;
+	int spin = 0;
+
+	if (likely(sched_feat(MUTEX_SPIN) && owner)) {
+		rq = cpu_rq(cpu);
+		spin = (rq->curr == owner);
+	}
+
+	if (!spin) {
+		schedstat_inc(cpu_rq(raw_smp_processor_id()), mtx_sched);
+		schedule();
+		return;
+	}
+
+	schedstat_inc(cpu_rq(raw_smp_processor_id()), mtx_spin);
+	for (;;) {
+		struct task_struct *l_owner;
+
+		/* Stop spinning when there's a pending signal. */
+		if (signal_pending_state(task->state, task))
+			break;
+
+		/* Mutex got unlocked, try to acquire. */
+		if (!mutex_is_locked(lock))
+			break;
+
+		/*
+		 * Owner changed, bail to re-assess state.
+		 *
+		 * We ignore !owner because that would break us out of
+		 * the spin too early -- see mutex_unlock() -- and make
+		 * us schedule -- see the !owner case on top -- at the
+		 * worst possible moment.
+		 */
+		l_owner = ACCESS_ONCE(lock->owner);
+		if (l_owner && l_owner != owner)
+			break;
+
+		/* Owner stopped running, bail to re-assess state. */
+		if (rq->curr != owner)
+			break;
+
+		/*
+		 * cpu_relax() provides a compiler barrier that ensures we
+		 * reload everything every time. SMP barriers are not strictly
+		 * required as the worst case is we'll spin a bit more before
+		 * we observe the right values.
+		 */
+		cpu_relax();
+	}
+}
+#endif
+
 /*
  * schedule() is the main scheduler function.
  */
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -288,6 +288,8 @@ static void print_cpu(struct seq_file *m
 
 	P(bkl_count);
 
+	P(mtx_spin);
+	P(mtx_sched);
 #undef P
 #endif
 	print_cfs_stats(m, cpu);
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(MUTEX_SPIN, 1)

