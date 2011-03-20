From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Sun, 20 Mar 2011 20:56:52 +0100
Message-ID: <20110320195652.GB12003@htj.dyndns.org>
References: <20110320174433.GA12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110320174433.GA12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

So, here's the patch to implement and use mutex_try_spin(), which
applies the same owner spin logic to try locking.  The result looks
pretty good.

I re-ran all three.  DFL is the current custom locking.  SIMPLE is
with only the previous patch applied.  SPIN is both the previous and
this patches applied.

       USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
DFL    14484  129368    390  1669102     171.955
SIMPLE 14483  128902    318  1187031     171.512
SPIN   14311  129222    347  1198166     174.904

DFL/SIMPLE results are more or less consistent with the previous run.
SPIN seems to consume a bit more cpu than SIMPLE but shows discernably
better throughput.  I'm running SPIN again just in case but the result
seems pretty consistent.

Thanks.

NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/btrfs/locking.h    |    2 -
 include/linux/mutex.h |    1 
 kernel/mutex.c        |   58 ++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 44 insertions(+), 17 deletions(-)

Index: work/fs/btrfs/locking.h
===================================================================
--- work.orig/fs/btrfs/locking.h
+++ work/fs/btrfs/locking.h
@@ -23,7 +23,7 @@
 
 static inline bool btrfs_try_spin_lock(struct extent_buffer *eb)
 {
-	return mutex_trylock(&eb->lock);
+	return mutex_tryspin(&eb->lock);
 }
 
 static inline void btrfs_tree_lock(struct extent_buffer *eb)
Index: work/include/linux/mutex.h
===================================================================
--- work.orig/include/linux/mutex.h
+++ work/include/linux/mutex.h
@@ -157,6 +157,7 @@ extern int __must_check mutex_lock_killa
  * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
 extern int mutex_trylock(struct mutex *lock);
+extern int mutex_tryspin(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
Index: work/kernel/mutex.c
===================================================================
--- work.orig/kernel/mutex.c
+++ work/kernel/mutex.c
@@ -126,20 +126,8 @@ void __sched mutex_unlock(struct mutex *
 
 EXPORT_SYMBOL(mutex_unlock);
 
-/*
- * Lock a mutex (possibly interruptible), slowpath:
- */
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
 	/*
 	 * Optimistic spinning.
@@ -158,7 +146,6 @@ __mutex_lock_common(struct mutex *lock,
 	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
 	 * to serialize everything.
 	 */
-
 	for (;;) {
 		struct thread_info *owner;
 
@@ -181,7 +168,7 @@ __mutex_lock_common(struct mutex *lock,
 			lock_acquired(&lock->dep_map, ip);
 			mutex_set_owner(lock);
 			preempt_enable();
-			return 0;
+			return true;
 		}
 
 		/*
@@ -190,7 +177,7 @@ __mutex_lock_common(struct mutex *lock,
 		 * we're an RT task that will live-lock because we won't let
 		 * the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(task)))
+		if (!owner && (need_resched() || rt_task(current)))
 			break;
 
 		/*
@@ -202,6 +189,26 @@ __mutex_lock_common(struct mutex *lock,
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
+	if (mutex_spin(lock))
+		return 0;
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
@@ -473,6 +480,25 @@ int __sched mutex_trylock(struct mutex *
 }
 EXPORT_SYMBOL(mutex_trylock);
 
+static inline int __mutex_tryspin_slowpath(atomic_t *lock_count)
+{
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	return __mutex_trylock_slowpath(lock_count) || mutex_spin(lock);
+}
+
+int __sched mutex_tryspin(struct mutex *lock)
+{
+	int ret;
+
+	ret = __mutex_fastpath_trylock(&lock->count, __mutex_tryspin_slowpath);
+	if (ret)
+		mutex_set_owner(lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(mutex_tryspin);
+
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
  * @cnt: the atomic which we are to dec
