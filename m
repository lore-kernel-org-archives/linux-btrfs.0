From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Tue, 13 Jan 2009 19:33:10 +0100
Message-ID: <20090113183310.GA10065@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231867314.7141.16.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-01-13 at 08:49 -0800, Linus Torvalds wrote:
> > 
> > So do a v10, and ask people to test.

below is the v8 -> v10 delta patch - for all who'd like to review the 
changes.

	Ingo

------------>
>From d154179e2d4d4667bcbf22920eeab563bc042e6a Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 13 Jan 2009 18:21:54 +0100
Subject: [PATCH] mutex: implement adaptive spinning, v10

Change mutex contention behaviour such that it will sometimes busy wait on
acquisition - moving its behaviour closer to that of spinlocks.

This concept got ported to mainline from the -rt tree, where it was originally
implemented for rtmutexes by Steven Rostedt, based on work by Gregory Haskins.

Testing with Ingo's test-mutex application (http://lkml.org/lkml/2006/1/8/50)
gave a 304% boost for VFS scalability on my testbox:

 # ./test-mutex-shm V 16 10 | grep "^avg ops"
 avg ops/sec:               298932

 # ./test-mutex-shm V 16 10 | grep "^avg ops"
 avg ops/sec:               98287

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

Changes since -v9:
 - cmpxchg acquire in the spin loop

Changes since -v8:
 - dropped the fairness

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mutex.h |    5 --
 include/linux/sched.h |    3 +-
 kernel/mutex.c        |  168 +++++++++++++++++++++----------------------------
 kernel/sched.c        |   21 ++-----
 4 files changed, 79 insertions(+), 118 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index b374c64..3069ec7 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -52,7 +52,6 @@ struct mutex {
 	struct list_head	wait_list;
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct thread_info	*owner;
-	int			waiters;
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
@@ -70,10 +69,6 @@ struct mutex {
 struct mutex_waiter {
 	struct list_head	list;
 	struct task_struct	*task;
-	struct mutex		*lock;
-#ifdef CONFIG_SMP
-	int			spin;
-#endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	void			*magic;
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dae1a3c..c34b137 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -330,8 +330,7 @@ extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex_waiter *waiter,
-			       struct thread_info *owner);
+extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 332bb2e..0d5336d 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -96,10 +96,8 @@ void inline __sched mutex_lock(struct mutex *lock)
 	 * The locking fastpath is the 1->0 transition from
 	 * 'unlocked' into 'locked' state.
 	 */
-	preempt_disable();
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
 	mutex_set_owner(lock);
-	preempt_enable();
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -124,7 +122,6 @@ void __sched mutex_unlock(struct mutex *lock)
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
-	preempt_disable();
 #ifndef CONFIG_DEBUG_MUTEXES
 	/*
 	 * When debugging is enabled we must not clear the owner before time,
@@ -134,97 +131,93 @@ void __sched mutex_unlock(struct mutex *lock)
 	mutex_clear_owner(lock);
 #endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
-	preempt_enable();
 }
 
 EXPORT_SYMBOL(mutex_unlock);
 
-#ifdef CONFIG_SMP
-static void mutex_spin_or_schedule(struct mutex_waiter *waiter,
-				   unsigned long *flags)
+/*
+ * Lock a mutex (possibly interruptible), slowpath:
+ */
+static inline int __sched
+__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
+	       	unsigned long ip)
 {
-	struct mutex *lock = waiter->lock;
+	struct task_struct *task = current;
+	struct mutex_waiter waiter;
+	unsigned long flags;
 
-	waiter->spin = !lock->waiters;
-	if (!waiter->spin)
-		goto sleep;
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
 
-	spin_unlock_mutex(&lock->wait_lock, *flags);
-	while (waiter->spin && !lock->waiters) {
+	for (;;) {
 		struct thread_info *owner;
 
-		/* Busy wait on the owner, if any. */
-		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(waiter, owner))
+		/*
+		 * If there are pending waiters, join them.
+		 */
+		if (!list_empty(&lock->wait_list))
 			break;
 
-		cpu_relax();
-	}
-	spin_lock_mutex(&lock->wait_lock, *flags);
-
-	if (!waiter->spin) {
-		__set_task_state(waiter->task, TASK_RUNNING);
-		return;
-	}
-	waiter->spin = 0;
-sleep:
-	/*
-	 * Stop all other spinners.
-	 */
-	lock->waiters++;
-	spin_unlock_mutex(&lock->wait_lock, *flags);
-
-	__schedule();
-
-	spin_lock_mutex(&lock->wait_lock, *flags);
-	lock->waiters--;
-}
+		/*
+		 * If there's an owner, wait for it to either
+		 * release the lock or go to sleep.
+		 */
+		owner = ACCESS_ONCE(lock->owner);
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
 
-static void mutex_wake_up(struct mutex_waiter *waiter)
-{
-	if (waiter->spin)
-		waiter->spin = 0;
-	else
-		wake_up_process(waiter->task);
-}
-#else
-static void mutex_spin_or_schedule(struct mutex_waiter *waiter,
-				   unsigned long *flags)
-{
-	struct mutex *lock = waiter->lock;
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(task)))
+			break;
 
-	spin_unlock_mutex(&lock->wait_lock, *flags);
-	__schedule();
-	spin_lock_mutex(&lock->wait_lock, *flags);
-}
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+			lock_acquired(&lock->dep_map, ip);
+			mutex_set_owner(lock);
+			preempt_enable();
+			return 0;
+		}
 
-static void mutex_wake_up(struct mutex_waiter *waiter)
-{
-	wake_up_process(waiter->task);
-}
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		cpu_relax();
+	}
 #endif
 
-/*
- * Lock a mutex (possibly interruptible), slowpath:
- */
-static inline int __sched
-__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-	       	unsigned long ip)
-{
-	struct task_struct *task = current;
-	struct mutex_waiter waiter;
-	unsigned long flags;
-
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
-	waiter.lock = lock;
 
 	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
@@ -255,18 +248,21 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
 			debug_mutex_free_waiter(&waiter);
+			preempt_enable();
 			return -EINTR;
 		}
 		__set_task_state(task, state);
 
 		/* didnt get the lock, go to sleep: */
-		mutex_spin_or_schedule(&waiter, &flags);
+		spin_unlock_mutex(&lock->wait_lock, flags);
+		__schedule();
+		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
 done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
@@ -276,6 +272,7 @@ done:
 	spin_unlock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_free_waiter(&waiter);
+	preempt_enable();
 
 	return 0;
 }
@@ -285,9 +282,7 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	preempt_disable();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
-	preempt_enable();
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -295,28 +290,17 @@ EXPORT_SYMBOL_GPL(mutex_lock_nested);
 int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
-	int ret;
-
 	might_sleep();
-	preempt_disable();
-	ret = __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
-	preempt_enable();
-
-	return ret;
+	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
 int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
-	int ret;
-
 	might_sleep();
-	preempt_disable();
-	ret = __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
-	preempt_enable();
-
-	return ret;
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
+				   subclass, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -351,7 +335,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 
 		debug_mutex_wake_waiter(lock, waiter);
 
-		mutex_wake_up(waiter);
+		wake_up_process(waiter->task);
 	}
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
@@ -393,12 +377,10 @@ int __sched mutex_lock_interruptible(struct mutex *lock)
 	int ret;
 
 	might_sleep();
-	preempt_disable();
 	ret =  __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_interruptible_slowpath);
 	if (!ret)
 		mutex_set_owner(lock);
-	preempt_enable();
 
 	return ret;
 }
@@ -410,12 +392,10 @@ int __sched mutex_lock_killable(struct mutex *lock)
 	int ret;
 
 	might_sleep();
-	preempt_disable();
 	ret = __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_killable_slowpath);
 	if (!ret)
 		mutex_set_owner(lock);
-	preempt_enable();
 
 	return ret;
 }
@@ -491,11 +471,9 @@ int __sched mutex_trylock(struct mutex *lock)
 {
 	int ret;
 
-	preempt_disable();
 	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
 	if (ret)
 		mutex_set_owner(lock);
-	preempt_enable();
 
 	return ret;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 9dd69c9..8f097fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4611,17 +4611,14 @@ EXPORT_SYMBOL(schedule);
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
  */
-int mutex_spin_on_owner(struct mutex_waiter *waiter, struct thread_info *owner)
+int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 {
-	struct mutex *lock = waiter->lock;
 	unsigned int cpu;
 	struct rq *rq;
-	int ret = 1;
 
 	if (!sched_feat(OWNER_SPIN))
 		return 0;
 
-	preempt_disable();
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
 	 * Need to access the cpu field knowing that
@@ -4650,7 +4647,7 @@ int mutex_spin_on_owner(struct mutex_waiter *waiter, struct thread_info *owner)
 
 	rq = cpu_rq(cpu);
 
-	while (waiter->spin && !lock->waiters) {
+	for (;;) {
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
@@ -4660,21 +4657,13 @@ int mutex_spin_on_owner(struct mutex_waiter *waiter, struct thread_info *owner)
 		/*
 		 * Is that owner really running on that cpu?
 		 */
-		if (task_thread_info(rq->curr) != owner) {
-			ret = 0;
-			break;
-		}
-
-		if (need_resched()) {
-			ret = 0;
-			break;
-		}
+		if (task_thread_info(rq->curr) != owner || need_resched())
+			return 0;
 
 		cpu_relax();
 	}
 out:
-	preempt_enable_no_resched();
-	return ret;
+	return 1;
 }
 #endif
 
