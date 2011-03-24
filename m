From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] Subject: mutex: Separate out mutex_spin()
Date: Thu, 24 Mar 2011 10:41:19 +0100
Message-ID: <20110324094119.GD12038@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.m
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110323153727.GB12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Separate out mutex_spin() out of __mutex_lock_common().  The fat
comment is converted to docbook function description.

While at it, drop the part of comment which explains that adaptive
spinning considers whether there are pending waiters, which doesn't
match the code.

This patch is to prepare for using adaptive spinning in
mutex_trylock() and doesn't cause any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <20110323153727.GB12003@htj.dyndns.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
Here are split patches with SOB.  Ingo, it's probably best to route
this through -tip, I suppose?

Thanks.

 kernel/mutex.c |   87 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 50 insertions(+), 37 deletions(-)

Index: work/kernel/mutex.c
===================================================================
--- work.orig/kernel/mutex.c
+++ work/kernel/mutex.c
@@ -126,39 +126,32 @@ void __sched mutex_unlock(struct mutex *
 
 EXPORT_SYMBOL(mutex_unlock);
 
-/*
- * Lock a mutex (possibly interruptible), slowpath:
+/**
+ * mutex_spin - optimistic spinning on mutex
+ * @lock: mutex to spin on
+ *
+ * This function implements optimistic spin for acquisition of @lock when
+ * the lock owner is currently running on a (different) CPU.
+ *
+ * The rationale is that if the lock owner is running, it is likely to
+ * release the lock soon.
+ *
+ * Since this needs the lock owner, and this mutex implementation doesn't
+ * track the owner atomically in the lock field, we need to track it
+ * non-atomically.
+ *
+ * We can't do this for DEBUG_MUTEXES because that relies on wait_lock to
+ * serialize everything.
+ *
+ * CONTEXT:
+ * Preemption disabled.
+ *
+ * RETURNS:
+ * %true if @lock is acquired, %false otherwise.
  */
-static inline int __sched
-__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-	       	unsigned long ip)
+static inline bool mutex_spin(struct mutex *lock)
 {
-	struct task_struct *task = current;
-	struct mutex_waiter waiter;
-	unsigned long flags;
-
-	preempt_disable();
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	/*
-	 * Optimistic spinning.
-	 *
-	 * We try to spin for acquisition when we find that there are no
-	 * pending waiters and the lock owner is currently running on a
-	 * (different) CPU.
-	 *
-	 * The rationale is that if the lock owner is running, it is likely to
-	 * release the lock soon.
-	 *
-	 * Since this needs the lock owner, and this mutex implementation
-	 * doesn't track the owner atomically in the lock field, we need to
-	 * track it non-atomically.
-	 *
-	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
-	 * to serialize everything.
-	 */
-
 	for (;;) {
 		struct thread_info *owner;
 
@@ -177,12 +170,8 @@ __mutex_lock_common(struct mutex *lock,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
-			lock_acquired(&lock->dep_map, ip);
-			mutex_set_owner(lock);
-			preempt_enable();
-			return 0;
-		}
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1)
+			return true;
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -190,7 +179,7 @@ __mutex_lock_common(struct mutex *lock,
 		 * we're an RT task that will live-lock because we won't let
 		 * the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(task)))
+		if (!owner && (need_resched() || rt_task(current)))
 			break;
 
 		/*
@@ -202,6 +191,30 @@ __mutex_lock_common(struct mutex *lock,
 		arch_mutex_cpu_relax();
 	}
 #endif
+	return false;
+}
+
+/*
+ * Lock a mutex (possibly interruptible), slowpath:
+ */
+static inline int __sched
+__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
+	       	unsigned long ip)
+{
+	struct task_struct *task = current;
+	struct mutex_waiter waiter;
+	unsigned long flags;
+
+	preempt_disable();
+	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+
+	if (mutex_spin(lock)) {
+		lock_acquired(&lock->dep_map, ip);
+		mutex_set_owner(lock);
+		preempt_enable();
+		return 0;
+	}
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
