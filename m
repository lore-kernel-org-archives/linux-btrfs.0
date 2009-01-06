From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 06 Jan 2009 12:40:31 +0100
Message-ID: <1231242031.11687.97.camel@twins>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090104184103.GE2002@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>

Subject: mutex: adaptive spin
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jan 06 12:32:12 CET 2009

Based on the code in -rt, provide adaptive spins on generic mutexes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mutex.h |    4 ++--
 include/linux/sched.h |    1 +
 kernel/mutex-debug.c  |   11 ++---------
 kernel/mutex-debug.h  |    8 --------
 kernel/mutex.c        |   46 +++++++++++++++++++++++++++++++++++++++-------
 kernel/mutex.h        |    2 --
 kernel/sched.c        |    5 +++++
 7 files changed, 49 insertions(+), 28 deletions(-)

Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
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
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -249,6 +249,7 @@ extern void init_idle(struct task_struct
 extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(void);
+extern int task_is_current(struct task_struct *p);
 extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_var_t nohz_cpu_mask;
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
@@ -80,9 +74,9 @@ void debug_mutex_unlock(struct mutex *lo
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	DEBUG_LOCKS_WARN_ON(lock->owner != current);
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	DEBUG_LOCKS_WARN_ON(lock->owner != current);
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
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -46,6 +46,7 @@ __mutex_init(struct mutex *lock, const c
 	atomic_set(&lock->count, 1);
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
+	lock->owner = NULL;
 
 	debug_mutex_init(lock, name, key);
 }
@@ -120,6 +121,28 @@ void __sched mutex_unlock(struct mutex *
 
 EXPORT_SYMBOL(mutex_unlock);
 
+#ifdef CONFIG_SMP
+static int adaptive_wait(struct mutex_waiter *waiter,
+			 struct task_struct *owner, long state)
+{
+	for (;;) {
+		if (signal_pending_state(state, waiter->task))
+			return 0;
+		if (waiter->lock->owner != owner)
+			return 0;
+		if (!task_is_current(owner))
+			return 1;
+		cpu_relax();
+	}
+}
+#else
+static int adaptive_wait(struct mutex_waiter *waiter,
+			 struct task_struct *owner, long state)
+{
+	return 1;
+}
+#endif
+
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
@@ -127,7 +150,7 @@ static inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	       	unsigned long ip)
 {
-	struct task_struct *task = current;
+	struct task_struct *owner, *task = current;
 	struct mutex_waiter waiter;
 	unsigned int old_val;
 	unsigned long flags;
@@ -141,6 +164,7 @@ __mutex_lock_common(struct mutex *lock, 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
+	waiter.lock = lock;
 
 	old_val = atomic_xchg(&lock->count, -1);
 	if (old_val == 1)
@@ -175,11 +199,19 @@ __mutex_lock_common(struct mutex *lock, 
 			debug_mutex_free_waiter(&waiter);
 			return -EINTR;
 		}
-		__set_task_state(task, state);
 
-		/* didnt get the lock, go to sleep: */
+		owner = lock->owner;
+		get_task_struct(owner);
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		schedule();
+
+		if (adaptive_wait(&waiter, owner, state)) {
+			put_task_struct(owner);
+			__set_task_state(task, state);
+			/* didnt get the lock, go to sleep: */
+			schedule();
+		} else
+			put_task_struct(owner);
+
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
@@ -187,7 +219,7 @@ done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	lock->owner = task;
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -260,7 +292,7 @@ __mutex_unlock_common_slowpath(atomic_t 
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
+	lock->owner = NULL;
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
@@ -352,7 +384,7 @@ static inline int __mutex_trylock_slowpa
 
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
-		debug_mutex_set_owner(lock, current_thread_info());
+		lock->owner = current;
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 	}
 	/* Set it back to 0 if there are no waiters: */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -697,6 +697,11 @@ int runqueue_is_locked(void)
 	return ret;
 }
 
+int task_is_current(struct task_struct *p)
+{
+	return task_rq(p)->curr == p;
+}
+
 /*
  * Debugging: various feature bits
  */
Index: linux-2.6/kernel/mutex.h
===================================================================
--- linux-2.6.orig/kernel/mutex.h
+++ linux-2.6/kernel/mutex.h
@@ -16,8 +16,6 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#define debug_mutex_set_owner(lock, new_owner)		do { } while (0)
-#define debug_mutex_clear_owner(lock)			do { } while (0)
 #define debug_mutex_wake_waiter(lock, waiter)		do { } while (0)
 #define debug_mutex_free_waiter(waiter)			do { } while (0)
 #define debug_mutex_add_waiter(lock, waiter, ti)	do { } while (0)

