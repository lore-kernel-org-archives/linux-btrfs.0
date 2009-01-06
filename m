From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 06 Jan 2009 23:43:21 +0100
Message-ID: <1231281801.11687.125.camel@twins>
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
In-Reply-To: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 14:22 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Jan 2009, Peter Zijlstra wrote:
> > 
> > One of the things the previous patch did wrong was that it never tracked
> > the owner in the mutex fast path -- I initially didn't notice because I
> > had all debugging infrastructure enabled, and that short circuits all
> > the fast paths.
> 
> Why even worry?

Wrong mind-set, as you rightly point out below.

> Just set the owner non-atomically. We can consider a NULL owner in the 
> slow-path to be a "let's schedule" case. After all, it's just a 
> performance tuning thing after all, and the window is going to be very 
> small, so it won't even be relevant from a performance tuning angle.
> 
> So there's _no_ reason why the fast-path can't just set owner, and no 
> reason to disable preemption.

Agreed, when viewed from that angle all the little races don't matter.

> I also think the whole preempt_disable/enable around the 
> mutex_spin_or_schedule() is pure garbage.
> 
> In fact, I suspect that's the real bug you're hitting: you're enabling 
> preemption while holding a spinlock. That is NOT a good idea.

spinlocks also fiddle with preempt_count, that should all work out -
although granted, it does look funny.



Indeed, the below does boot -- which means I get to sleep now ;-)

---
 include/linux/mutex.h |    4 +--
 include/linux/sched.h |    1 
 kernel/mutex-debug.c  |   10 --------
 kernel/mutex-debug.h  |    8 ------
 kernel/mutex.c        |   62 +++++++++++++++++++++++++++++++++++---------------
 kernel/mutex.h        |    2 -
 kernel/sched.c        |   44 +++++++++++++++++++++++++++++++++++
 7 files changed, 92 insertions(+), 39 deletions(-)

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
@@ -329,6 +329,7 @@ extern signed long schedule_timeout(sign
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+extern void mutex_spin_or_schedule(struct mutex_waiter *, long state, unsigned long *flags);
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
+	/* DEBUG_LOCKS_WARN_ON(lock->owner != current); */
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
@@ -91,6 +92,7 @@ void inline __sched mutex_lock(struct mu
 	 * 'unlocked' into 'locked' state.
 	 */
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	lock->owner = current;
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -115,6 +117,7 @@ void __sched mutex_unlock(struct mutex *
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
+	lock->owner = NULL;
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
 }
 
@@ -127,7 +130,7 @@ static inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	       	unsigned long ip)
 {
-	struct task_struct *task = current;
+	struct task_struct *owner, *task = current;
 	struct mutex_waiter waiter;
 	unsigned int old_val;
 	unsigned long flags;
@@ -141,6 +144,7 @@ __mutex_lock_common(struct mutex *lock, 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
+	waiter.lock = lock;
 
 	old_val = atomic_xchg(&lock->count, -1);
 	if (old_val == 1)
@@ -175,19 +179,14 @@ __mutex_lock_common(struct mutex *lock, 
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
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -206,6 +205,7 @@ mutex_lock_nested(struct mutex *lock, un
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
+	lock->owner = current;
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -213,16 +213,28 @@ EXPORT_SYMBOL_GPL(mutex_lock_nested);
 int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	ret =  __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	if (!ret)
+		lock->owner = current;
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
+	ret = __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	if (!ret)
+		lock->owner = current;
+
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -260,8 +272,6 @@ __mutex_unlock_common_slowpath(atomic_t 
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
 
@@ -298,18 +308,30 @@ __mutex_lock_interruptible_slowpath(atom
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
 
@@ -351,10 +373,9 @@ static inline int __mutex_trylock_slowpa
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
-	if (likely(prev == 1)) {
-		debug_mutex_set_owner(lock, current_thread_info());
+	if (likely(prev == 1))
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-	}
+
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -380,8 +401,13 @@ static inline int __mutex_trylock_slowpa
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
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4596,6 +4596,50 @@ pick_next_task(struct rq *rq, struct tas
 	}
 }
 
+#ifdef CONFIG_DEBUG_MUTEXES
+# include "mutex-debug.h"
+#else
+# include "mutex.h"
+#endif
+
+void mutex_spin_or_schedule(struct mutex_waiter *waiter, long state, unsigned long *flags)
+{
+	struct mutex *lock = waiter->lock;
+	struct task_struct *task = waiter->task;
+	struct task_struct *owner = lock->owner;
+	struct rq *rq;
+
+	if (!owner)
+		goto do_schedule;
+
+	rq = task_rq(owner);
+
+	if (rq->curr != owner) {
+do_schedule:
+		__set_task_state(task, state);
+		spin_unlock_mutex(&lock->wait_lock, *flags);
+		schedule();
+	} else {
+		spin_unlock_mutex(&lock->wait_lock, *flags);
+		for (;;) {
+			/* Stop spinning when there's a pending signal. */
+			if (signal_pending_state(state, task))
+				break;
+
+			/* Owner changed, bail to revalidate state */
+			if (lock->owner != owner)
+				break;
+
+			/* Owner stopped running, bail to revalidate state */
+			if (rq->curr != owner)
+				break;
+
+			cpu_relax();
+		}
+	}
+	spin_lock_mutex(&lock->wait_lock, *flags);
+}
+
 /*
  * schedule() is the main scheduler function.
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

