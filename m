From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v11][RFC] mutex: implement adaptive spinning
Date: Wed, 14 Jan 2009 18:22:36 +0100
Message-ID: <1231953757.14825.33.camel@laptop>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114171800.GA18621@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
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
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114171800.GA18621@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-14 at 18:18 +0100, Nick Piggin wrote:

> > @@ -173,21 +237,21 @@ __mutex_lock_common(struct mutex *lock, 
> >  			spin_unlock_mutex(&lock->wait_lock, flags);
> >  
> >  			debug_mutex_free_waiter(&waiter);
> > +			preempt_enable();
> >  			return -EINTR;
> >  		}
> >  		__set_task_state(task, state);
> >  
> >  		/* didnt get the lock, go to sleep: */
> >  		spin_unlock_mutex(&lock->wait_lock, flags);
> > -		schedule();
> > +		__schedule();
> 
> Why does this need to do a preempt-disabled schedule? After we schedule
> away, the next task can do arbitrary things or reschedule itself, so if
> we have not anticipated such a condition here, then I can't see what
> __schedule protects. At least a comment is in order?

From:
http://programming.kicks-ass.net/kernel-patches/mutex-adaptive-spin/mutex-preempt.patch

Subject: mutex: preemption fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jan 14 15:36:26 CET 2009

The problem is that dropping the spinlock right before schedule is a voluntary
preemption point and can cause a schedule, right after which we schedule again.

Fix this inefficiency by keeping preemption disabled until we schedule, do this
by explicitly disabling preemption and providing a schedule() variant that
assumes preemption is already disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Pity to add the call overhead to schedule just for this case.

Good point, seeing any way around that?

>  BTW. __schedule shouldn't need to be asmlinkage?

TBH I've no clue, probably not, Ingo?

