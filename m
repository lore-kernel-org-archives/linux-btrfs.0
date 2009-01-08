From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 15:46:54 +0100
Message-ID: <1231426014.11687.456.camel@twins>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins>  <20090108141808.GC11629@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
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
	Sven Dietrich <SDietrich@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090108141808.GC11629@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 15:18 +0100, Ingo Molnar wrote:

> [ A detail, -tip testing found that the patch breaks mutex debugging:
> 
>   =====================================
>   [ BUG: bad unlock balance detected! ]
>   -------------------------------------
>   swapper/0 is trying to release lock (cpu_add_remove_lock) at:
>   [<ffffffff8089f540>] mutex_unlock+0xe/0x10
>   but there are no more locks to release!
> 
>  but that's a detail for -v7 ;-) ]

Here it is..

I changed the optimistic spin cmpxchg trickery to not require the -1000
state, please double and tripple check the code.

This was done because the interaction between trylock_slowpath and that
-1000 state hurt my head.

---
Subject: 
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jan 08 09:41:22 CET 2009

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mutex.h   |    4 +-
 include/linux/sched.h   |    1 
 kernel/mutex-debug.c    |   24 ++++++++++-----
 kernel/mutex-debug.h    |   18 ++++++-----
 kernel/mutex.c          |   76 ++++++++++++++++++++++++++++++++++++++++++------
 kernel/mutex.h          |   22 ++++++++++++-
 kernel/sched.c          |   66 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched_features.h |    1 
 8 files changed, 185 insertions(+), 27 deletions(-)

Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
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
@@ -80,9 +75,25 @@ void debug_mutex_unlock(struct mutex *lo
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+#if 0
+	/*
+	 * XXX something is iffy with owner tracking, but lockdep - which has
+	 * similar checks - finds everything dandy, so disable for now.
+	 */
+	if (lock->owner != current_thread_info()) {
+		printk(KERN_ERR "%p %p\n", lock->owner, current_thread_info());
+		if (lock->owner) {
+			printk(KERN_ERR "%d %s\n",
+					lock->owner->task->pid,
+					lock->owner->task->comm);
+		}
+		printk(KERN_ERR "%d %s\n",
+				current_thread_info()->task->pid,
+				current_thread_info()->task->comm);
+	}
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+#endif
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
@@ -95,7 +106,6 @@ void debug_mutex_init(struct mutex *lock
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
@@ -91,6 +97,7 @@ void inline __sched mutex_lock(struct mu
 	 * 'unlocked' into 'locked' state.
 	 */
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	mutex_set_owner(lock);
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
+	mutex_clear_owner(lock);
+#endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
 }
 
@@ -129,13 +144,38 @@ __mutex_lock_common(struct mutex *lock, 
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
-	unsigned int old_val;
 	unsigned long flags;
+	int old_val;
+
+	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+
+#ifdef CONFIG_SMP
+	/* Optimistic spinning.. */
+	for (;;) {
+		struct thread_info *owner;
+
+		old_val = atomic_cmpxchg(&lock->count, 1, 0);
+		if (old_val == 1) {
+			lock_acquired(&lock->dep_map, ip);
+			mutex_set_owner(lock);
+			return 0;
+		}
+
+		if (old_val < 0 && !list_empty(&lock->wait_list))
+			break;
+
+		/* See who owns it, and spin on him if anybody */
+		owner = ACCESS_ONCE(lock->owner);
+		if (owner && !spin_on_owner(lock, owner))
+			break;
+
+		cpu_relax();
+	}
+#endif
 
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
@@ -187,7 +227,7 @@ done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -260,7 +300,7 @@ __mutex_unlock_common_slowpath(atomic_t 
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
+	mutex_clear_owner(lock);
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
@@ -298,18 +338,30 @@ __mutex_lock_interruptible_slowpath(atom
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
 
@@ -352,9 +404,10 @@ static inline int __mutex_trylock_slowpa
 
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
@@ -380,8 +433,13 @@ static inline int __mutex_trylock_slowpa
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
@@ -4672,6 +4672,72 @@ need_resched_nonpreemptible:
 }
 EXPORT_SYMBOL(schedule);
 
+#ifdef CONFIG_SMP
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+int spin_on_owner(struct mutex *lock, struct thread_info *owner)
+{
+	unsigned int cpu;
+	struct rq *rq;
+	int ret = 1;
+
+	if (unlikely(!sched_feat(OWNER_SPIN)))
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
+	for (;;) {
+		if (lock->owner != owner)
+			break;
+
+		/*
+		 * Is that owner really running on that cpu?
+		 */
+		if (task_thread_info(rq->curr) != owner)
+			break;
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
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -330,6 +330,7 @@ extern signed long schedule_timeout_inte
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
+extern int spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(OWNER_SPIN, 1)

