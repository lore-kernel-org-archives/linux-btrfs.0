From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v4][RFC]: mutex: implement adaptive spinning
Date: Wed, 07 Jan 2009 13:03:03 +0100
Message-ID: <1231329783.11687.287.camel@twins>
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
Mime-Version: 1.0
Content-Type: text/plain
Cc: paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231283778.11687.136.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

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
 include/linux/mutex.h   |    4 +-
 include/linux/sched.h   |    2 +
 kernel/mutex-debug.c    |   10 +------
 kernel/mutex-debug.h    |    8 -----
 kernel/mutex.c          |   46 ++++++++++++++++++++++--------
 kernel/mutex.h          |    2 -
 kernel/sched.c          |   73 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_debug.c    |    2 +
 kernel/sched_features.h |    1 +
 9 files changed, 115 insertions(+), 33 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 7a0e5c4..c007b4e 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -50,8 +50,8 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
+	struct task_struct	*owner;
 #ifdef CONFIG_DEBUG_MUTEXES
-	struct thread_info	*owner;
 	const char 		*name;
 	void			*magic;
 #endif
@@ -67,8 +67,8 @@ struct mutex {
 struct mutex_waiter {
 	struct list_head	list;
 	struct task_struct	*task;
-#ifdef CONFIG_DEBUG_MUTEXES
 	struct mutex		*lock;
+#ifdef CONFIG_DEBUG_MUTEXES
 	void			*magic;
 #endif
 };
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cae9b8..d8fa96b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -328,6 +328,8 @@ extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+extern void mutex_spin_or_schedule(struct mutex_waiter *waiter, long state,
+				   unsigned long *flags);
 asmlinkage void schedule(void);
 
 struct nsproxy;
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index 1d94160..0564680 100644
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
@@ -80,9 +74,8 @@ void debug_mutex_unlock(struct mutex *lock)
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	/* DEBUG_LOCKS_WARN_ON(lock->owner != current); */
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
@@ -95,7 +88,6 @@ void debug_mutex_init(struct mutex *lock, const char *name,
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->owner = NULL;
 	lock->magic = lock;
 }
 
diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
index babfbdf..42eab06 100644
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
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 4f45d4b..089b46b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -10,6 +10,10 @@
  * Many thanks to Arjan van de Ven, Thomas Gleixner, Steven Rostedt and
  * David Howells for suggestions and improvements.
  *
+ *  - Adaptive spinning for mutexes by Peter Zijlstra. (Ported to mainline
+ *    from the -rt tree, where it was originally implemented for rtmutexes
+ *    by Steven Rostedt, based on work by Gregory Haskins.)
+ *
  * Also see Documentation/mutex-design.txt.
  */
 #include <linux/mutex.h>
@@ -46,6 +50,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	atomic_set(&lock->count, 1);
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
+	lock->owner = NULL;
 
 	debug_mutex_init(lock, name, key);
 }
@@ -91,6 +96,7 @@ void inline __sched mutex_lock(struct mutex *lock)
 	 * 'unlocked' into 'locked' state.
 	 */
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	lock->owner = current;
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -115,6 +121,7 @@ void __sched mutex_unlock(struct mutex *lock)
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
+	lock->owner = NULL;
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
 }
 
@@ -141,6 +148,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
+	waiter.lock = lock;
 
 	old_val = atomic_xchg(&lock->count, -1);
 	if (old_val == 1)
@@ -175,19 +183,15 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			debug_mutex_free_waiter(&waiter);
 			return -EINTR;
 		}
-		__set_task_state(task, state);
 
-		/* didnt get the lock, go to sleep: */
-		spin_unlock_mutex(&lock->wait_lock, flags);
-		schedule();
-		spin_lock_mutex(&lock->wait_lock, flags);
+		mutex_spin_or_schedule(&waiter, state, &flags);
 	}
 
 done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	lock->owner = task;
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -260,7 +264,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
+	lock->owner = NULL;
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
@@ -298,18 +302,30 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
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
+		lock->owner = current;
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
+		lock->owner = current;
+
+	return ret;
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -352,9 +368,10 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
-		debug_mutex_set_owner(lock, current_thread_info());
+		lock->owner = current;
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 	}
+
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -380,8 +397,13 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
  */
 int __sched mutex_trylock(struct mutex *lock)
 {
-	return __mutex_fastpath_trylock(&lock->count,
-					__mutex_trylock_slowpath);
+	int ret;
+
+	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
+	if (ret)
+		lock->owner = current;
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_trylock);
diff --git a/kernel/mutex.h b/kernel/mutex.h
index a075daf..55e1986 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -16,8 +16,6 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#define debug_mutex_set_owner(lock, new_owner)		do { } while (0)
-#define debug_mutex_clear_owner(lock)			do { } while (0)
 #define debug_mutex_wake_waiter(lock, waiter)		do { } while (0)
 #define debug_mutex_free_waiter(waiter)			do { } while (0)
 #define debug_mutex_add_waiter(lock, waiter, ti)	do { } while (0)
diff --git a/kernel/sched.c b/kernel/sched.c
index 2e3545f..c189597 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -631,6 +631,10 @@ struct rq {
 
 	/* BKL stats */
 	unsigned int bkl_count;
+
+	/* mutex spin stats */
+	unsigned int mtx_spin;
+	unsigned int mtx_sched;
 #endif
 };
 
@@ -4527,6 +4531,75 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 	}
 }
 
+#ifdef CONFIG_DEBUG_MUTEXES
+# include "mutex-debug.h"
+#else
+# include "mutex.h"
+#endif
+
+void mutex_spin_or_schedule(struct mutex_waiter *waiter, long state,
+			    unsigned long *flags)
+{
+	struct mutex *lock = waiter->lock;
+	struct task_struct *task = waiter->task;
+	struct task_struct *owner = lock->owner;
+	struct rq *rq;
+	int spin = 0;
+
+	if (likely(sched_feat(MUTEX_SPIN) && owner)) {
+		rq = task_rq(owner);
+		spin = (rq->curr == owner);
+	}
+
+	if (!spin) {
+		schedstat_inc(this_rq(), mtx_sched);
+		__set_task_state(task, state);
+		spin_unlock_mutex(&lock->wait_lock, *flags);
+		schedule();
+		spin_lock_mutex(&lock->wait_lock, *flags);
+		return;
+	}
+
+	schedstat_inc(this_rq(), mtx_spin);
+	spin_unlock_mutex(&lock->wait_lock, *flags);
+	for (;;) {
+		struct task_struct *l_owner;
+
+		/* Stop spinning when there's a pending signal. */
+		if (signal_pending_state(state, task))
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
+	spin_lock_mutex(&lock->wait_lock, *flags);
+}
+
 /*
  * schedule() is the main scheduler function.
  */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4293cfa..3dec83a 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -288,6 +288,8 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 	P(bkl_count);
 
+	P(mtx_spin);
+	P(mtx_sched);
 #undef P
 #endif
 	print_cfs_stats(m, cpu);
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..f548627 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(MUTEX_SPIN, 1)

