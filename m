From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Wed, 07 Jan 2009 00:16:18 +0100
Message-ID: <1231283778.11687.136.camel@twins>
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
	 <1231281801.11687.125.camel@twins>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231281801.11687.125.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 23:43 +0100, Peter Zijlstra wrote:

> @@ -115,6 +117,7 @@ void __sched mutex_unlock(struct mutex *
>  	 * The unlocking fastpath is the 0->1 transition from 'locked'
>  	 * into 'unlocked' state:
>  	 */
> +	lock->owner = NULL;
>  	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
>  }
>  

> +void mutex_spin_or_schedule(struct mutex_waiter *waiter, long state, unsigned long *flags)
> +{
> +	struct mutex *lock = waiter->lock;
> +	struct task_struct *task = waiter->task;
> +	struct task_struct *owner = lock->owner;
> +	struct rq *rq;
> +
> +	if (!owner)
> +		goto do_schedule;
> +
> +	rq = task_rq(owner);
> +
> +	if (rq->curr != owner) {
> +do_schedule:
> +		__set_task_state(task, state);
> +		spin_unlock_mutex(&lock->wait_lock, *flags);
> +		schedule();
> +	} else {
> +		spin_unlock_mutex(&lock->wait_lock, *flags);
> +		for (;;) {
> +			/* Stop spinning when there's a pending signal. */
> +			if (signal_pending_state(state, task))
> +				break;
> +
> +			/* Owner changed, bail to revalidate state */
> +			if (lock->owner != owner)
> +				break;
> +
> +			/* Owner stopped running, bail to revalidate state */
> +			if (rq->curr != owner)
> +				break;
> +
> +			cpu_relax();
> +		}
> +	}
> +	spin_lock_mutex(&lock->wait_lock, *flags);
> +}

That's not going to work, we set owner to NULL, which means pending
spinners get schedule()ed out instead of racing to acquire.

I suppose the below would fix that... really sleep time now

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4626,8 +4626,8 @@ do_schedule:
 			if (signal_pending_state(state, task))
 				break;
 
-			/* Owner changed, bail to revalidate state */
-			if (lock->owner != owner)
+			/* Mutex got unlocked, race to acquire. */
+			if (!mutex_is_locked(lock))
 				break;
 
 			/* Owner stopped running, bail to revalidate state */

