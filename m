From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4][RFC]: mutex: implement adaptive spinning
Date: Wed, 07 Jan 2009 16:54:40 +0100
Message-ID: <1231343680.11687.307.camel@twins>
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
	 <alpine.DEB.1.10.0901071014120.32756@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901071014120.32756@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 10:22 -0500, Steven Rostedt wrote:
> Peter, nice work!

Thanks!

> > +	}
> > +
> > +	if (!spin) {
> > +		schedstat_inc(this_rq(), mtx_sched);
> > +		__set_task_state(task, state);
> 
> I still do not know why you set state here instead of in the mutex code.
> Yes, you prevent changing the state if we do not schedule, but there's 
> nothing wrong with setting it before hand. We may even be able to cache 
> the owner and keep the locking of the wait_lock out of here. But then I 
> see that it may be used to protect the sched_stat counters.

I was about to say because we need task_rq(owner) and can only deref
owner while holding that lock, but I found a way around it by using
task_cpu() which is exported.

Compile tested only so far...

---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -329,8 +329,8 @@ extern signed long schedule_timeout(sign
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
-extern void mutex_spin_or_schedule(struct mutex_waiter *waiter, long state,
-				   unsigned long *flags);
+extern void mutex_spin_or_schedule(struct mutex_waiter *waiter,
+				   struct task_struct *owner, int cpu);
 asmlinkage void schedule(void);
 
 struct nsproxy;
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -12,7 +12,8 @@
  *
  *  - Adaptive spinning for mutexes by Peter Zijlstra. (Ported to mainline
  *    from the -rt tree, where it was originally implemented for rtmutexes
- *    by Steven Rostedt, based on work by Gregory Haskins.)
+ *    by Steven Rostedt, based on work by Gregory Haskins, Peter Morreale
+ *    and Sven Dietrich.
  *
  * Also see Documentation/mutex-design.txt.
  */
@@ -157,6 +158,9 @@ __mutex_lock_common(struct mutex *lock, 
 	lock_contended(&lock->dep_map, ip);
 
 	for (;;) {
+		int cpu = 0;
+		struct task_struct *l_owner;
+
 		/*
 		 * Lets try to take the lock again - this is needed even if
 		 * we get here for the first time (shortly after failing to
@@ -184,8 +188,15 @@ __mutex_lock_common(struct mutex *lock, 
 			return -EINTR;
 		}
 
-		mutex_spin_or_schedule(&waiter, state, &flags);
+		__set_task_state(task, state);
+		l_owner = ACCESS_ONCE(lock->owner);
+		if (l_owner)
+			cpu = task_cpu(l_owner);
+		spin_unlock_mutex(&lock->wait_lock, flags);
+		mutex_spin_or_schedule(&waiter, l_owner, cpu);
+		spin_lock_mutex(&lock->wait_lock, flags);
 	}
+	__set_task_state(task, TASK_RUNNING);
 
 done:
 	lock_acquired(&lock->dep_map, ip);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4600,42 +4600,37 @@ pick_next_task(struct rq *rq, struct tas
 	}
 }
 
-#ifdef CONFIG_DEBUG_MUTEXES
-# include "mutex-debug.h"
-#else
-# include "mutex.h"
-#endif
-
-void mutex_spin_or_schedule(struct mutex_waiter *waiter, long state,
-			    unsigned long *flags)
+void mutex_spin_or_schedule(struct mutex_waiter *waiter,
+			    struct task_struct *owner, int cpu)
 {
-	struct mutex *lock = waiter->lock;
 	struct task_struct *task = waiter->task;
-	struct task_struct *owner = lock->owner;
+	struct mutex *lock = waiter->lock;
 	struct rq *rq;
 	int spin = 0;
 
 	if (likely(sched_feat(MUTEX_SPIN) && owner)) {
-		rq = task_rq(owner);
+		rq = cpu_rq(cpu);
 		spin = (rq->curr == owner);
 	}
 
 	if (!spin) {
+		preempt_disable();
 		schedstat_inc(this_rq(), mtx_sched);
-		__set_task_state(task, state);
-		spin_unlock_mutex(&lock->wait_lock, *flags);
+		preempt_enable();
+
 		schedule();
-		spin_lock_mutex(&lock->wait_lock, *flags);
 		return;
 	}
 
+	preempt_disable();
 	schedstat_inc(this_rq(), mtx_spin);
-	spin_unlock_mutex(&lock->wait_lock, *flags);
+	preempt_enable();
+
 	for (;;) {
 		struct task_struct *l_owner;
 
 		/* Stop spinning when there's a pending signal. */
-		if (signal_pending_state(state, task))
+		if (signal_pending_state(task->state, task))
 			break;
 
 		/* Mutex got unlocked, try to acquire. */
@@ -4666,7 +4661,6 @@ void mutex_spin_or_schedule(struct mutex
 		 */
 		cpu_relax();
 	}
-	spin_lock_mutex(&lock->wait_lock, *flags);
 }
 
 /*

