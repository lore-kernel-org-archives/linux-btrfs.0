From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 14:22:37 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231279660.11687.121.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 6 Jan 2009, Peter Zijlstra wrote:
> 
> One of the things the previous patch did wrong was that it never tracked
> the owner in the mutex fast path -- I initially didn't notice because I
> had all debugging infrastructure enabled, and that short circuits all
> the fast paths.

Why even worry?

Just set the owner non-atomically. We can consider a NULL owner in the 
slow-path to be a "let's schedule" case. After all, it's just a 
performance tuning thing after all, and the window is going to be very 
small, so it won't even be relevant from a performance tuning angle.

So there's _no_ reason why the fast-path can't just set owner, and no 
reason to disable preemption.

I also think the whole preempt_disable/enable around the 
mutex_spin_or_schedule() is pure garbage.

In fact, I suspect that's the real bug you're hitting: you're enabling 
preemption while holding a spinlock. That is NOT a good idea.

So 

 - remove all the "preempt_disable/enable" crud. It's wrong.

 - remove the whole

	+       if (!owner)
	+               return;

   thing. It's also wrong. Just go to the schedule case for that.

It all looks like unnecessary complexity that you added, and I think 
_that_ is what bites you.

Aim for _simple_. Not clever. Not complex. What you should aim for is to 
keep the _exact_ same code that we had before in mutex, and the absolute 
*only* change is replacing that "unlock+schedule()+relock" sequence with 
"mutex_spin_or_schedule()".

That should be your starting point.

Yeah, you'll need to set the owner for the fast case, but there are no 
locking or preemption issues there. Just forget them. You're confusing 
yourself and the code by trying to look for problems that aren't 
relevant.

			Linus
