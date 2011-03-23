From: Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 23 Mar 2011 16:37:27 +0100
Message-ID: <20110323153727.GB12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.m
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, guys.

I've been playing with locking in btrfs which has developed custom
locking to avoid excessive context switches in its btree
implementation.

Generally, doing away with the custom implementation and just using
the mutex adaptive owner spinning seems better; however, there's an
interesting distinction in the custom implemention of trylock.  It
distinguishes between simple trylock and tryspin, where the former
just tries once and then fail while the latter does some spinning
before giving up.

Currently, mutex_trylock() doesn't use adaptive spinning.  It tries
just once.  I got curious whether using adaptive spinning on
mutex_trylock() would be beneficial and it seems so, at least for
btrfs anyway.

The following results are from "dbench 50" run on an opteron two
socket eight core machine with 4GiB of memory and an OCZ vertex SSD.
During the run, disk stays mostly idle and all CPUs are fully occupied
and the difference in locking performance becomes quite visible.

IMPLE is with the locking simplification patch[1] applied.  i.e. it
basically just uses mutex.  SPIN is with the patch at the end of this
message applied on top - mutex_trylock() uses adaptive spinning.

        USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
 SIMPLE 61107  354977    217  8099529  845.100 MB/sec
 SPIN   63140  364888    214  6840527  879.077 MB/sec

I've been running various different configs from yesterday and the
adaptive spinning trylock consistently posts higher throughput.  The
amount of difference varies but it outperforms consistently.

In general, I think using adaptive spinning on trylock makes sense as
trylock failure usually leads to costly unlock-relock sequence.

Also, contrary to the comment, the adaptive spinning doesn't seem to
check whether there are pending waiters or not.  Is this intended or
the test got lost somehow?

Thanks.

NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/mutex.c |   98 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 37 deletions(-)

Index: work/kernel/mutex.c
===================================================================
--- work.orig/kernel/mutex.c
+++ work/kernel/mutex.c
@@ -126,39 +126,33 @@ void __sched mutex_unlock(struct mutex *
 
 EXPORT_SYMBOL(mutex_unlock);
 
-/*
- * Lock a mutex (possibly interruptible), slowpath:
+/**
+ * mutex_spin - optimistic spinning on mutex
+ * @lock: mutex to spin on
+ *
+ * This function implements optimistic spin for acquisition of @lock when
+ * we find that there are no pending waiters and the lock owner is
+ * currently running on a (different) CPU.
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
 
@@ -177,12 +171,8 @@ __mutex_lock_common(struct mutex *lock,
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
@@ -190,7 +180,7 @@ __mutex_lock_common(struct mutex *lock,
 		 * we're an RT task that will live-lock because we won't let
 		 * the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(task)))
+		if (!owner && (need_resched() || rt_task(current)))
 			break;
 
 		/*
@@ -202,6 +192,30 @@ __mutex_lock_common(struct mutex *lock,
 		cpu_relax();
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
@@ -430,6 +444,15 @@ static inline int __mutex_trylock_slowpa
 	unsigned long flags;
 	int prev;
 
+	preempt_disable();
+
+	if (mutex_spin(lock)) {
+		mutex_set_owner(lock);
+		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		preempt_enable();
+		return 1;
+	}
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
@@ -443,6 +466,7 @@ static inline int __mutex_trylock_slowpa
 		atomic_set(&lock->count, 0);
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
+	preempt_enable();
 
 	return prev == 1;
 }
