From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Tue, 29 Mar 2011 19:09:49 +0200
Message-ID: <20110329170949.GF29865@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
 <20110325101238.GC1409@htj.dyndns.org>
 <20110329163702.GE29865@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.m
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110329163702.GE29865@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here's the combined patch I was planning on testing but didn't get to
(yet).  It implements two things - hard limit on spin duration and
early break if the owner also is spinning on a mutex.

Thanks.

Index: work1/include/linux/sched.h
===================================================================
--- work1.orig/include/linux/sched.h
+++ work1/include/linux/sched.h
@@ -359,7 +359,7 @@ extern signed long schedule_timeout_inte
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern bool mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
Index: work1/kernel/sched.c
===================================================================
--- work1.orig/kernel/sched.c
+++ work1/kernel/sched.c
@@ -536,6 +536,10 @@ struct rq {
 	struct hrtimer hrtick_timer;
 #endif
 
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
+	bool spinning_on_mutex;
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 	/* latency stats */
 	struct sched_info rq_sched_info;
@@ -4021,16 +4025,44 @@ EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 /*
- * Look out! "owner" is an entirely speculative pointer
- * access and not reliable.
+ * Maximum mutex owner spin duration in nsecs.  Don't spin more then
+ * DEF_TIMESLICE.
+ */
+#define MAX_MUTEX_SPIN_NS	(DEF_TIMESLICE * 1000000000LLU / HZ)
+
+/**
+ * mutex_spin_on_owner - optimistic adaptive spinning on locked mutex
+ * @lock: the mutex to spin on
+ * @owner: the current owner (speculative pointer)
+ *
+ * The caller is trying to acquire @lock held by @owner.  If @owner is
+ * currently running, it might get unlocked soon and spinning on it can
+ * save the overhead of sleeping and waking up.
+ *
+ * Note that @owner is completely speculative and may be completely
+ * invalid.  It should be accessed very carefully.
+ *
+ * Forward progress is guaranteed regardless of locking ordering by never
+ * spinning longer than MAX_MUTEX_SPIN_NS.  This is necessary because
+ * mutex_trylock(), which doesn't have to follow the usual locking
+ * ordering, also uses this function.
+ *
+ * CONTEXT:
+ * Preemption disabled.
+ *
+ * RETURNS:
+ * %true if the lock was released and the caller should retry locking.
+ * %false if the caller better go sleeping.
  */
-int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+bool mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 {
+	unsigned long start;
 	unsigned int cpu;
 	struct rq *rq;
+	bool ret = true;
 
 	if (!sched_feat(OWNER_SPIN))
-		return 0;
+		return false;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
@@ -4039,7 +4071,7 @@ int mutex_spin_on_owner(struct mutex *lo
 	 * the mutex owner just released it and exited.
 	 */
 	if (probe_kernel_address(&owner->cpu, cpu))
-		return 0;
+		return false;
 #else
 	cpu = owner->cpu;
 #endif
@@ -4049,15 +4081,17 @@ int mutex_spin_on_owner(struct mutex *lo
 	 * the cpu field may no longer be valid.
 	 */
 	if (cpu >= nr_cpumask_bits)
-		return 0;
+		return false;
 
 	/*
 	 * We need to validate that we can do a
 	 * get_cpu() and that we have the percpu area.
 	 */
 	if (!cpu_online(cpu))
-		return 0;
+		return false;
 
+	this_rq()->spinning_on_mutex = true;
+	start = local_clock();
 	rq = cpu_rq(cpu);
 
 	for (;;) {
@@ -4070,21 +4104,30 @@ int mutex_spin_on_owner(struct mutex *lo
 			 * we likely have heavy contention. Return 0 to quit
 			 * optimistic spinning and not contend further:
 			 */
-			if (lock->owner)
-				return 0;
+			ret = !lock->owner;
 			break;
 		}
 
 		/*
-		 * Is that owner really running on that cpu?
+		 * Quit spinning if any of the followings is true.
+		 *
+		 * - The owner isn't running on that cpu.
+		 * - The owner also is spinning on a mutex.
+		 * - Someone else wants to use this cpu.
+		 * - We've been spinning for too long.
 		 */
-		if (task_thread_info(rq->curr) != owner || need_resched())
-			return 0;
+		if (task_thread_info(rq->curr) != owner ||
+		    rq->spinning_on_mutex || need_resched() ||
+		    local_clock() > start + MAX_MUTEX_SPIN_NS) {
+			ret = false;
+			break;
+		}
 
 		arch_mutex_cpu_relax();
 	}
 
-	return 1;
+	this_rq()->spinning_on_mutex = false;
+	return ret;
 }
 #endif
 
