From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 14:56:23 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901061451200.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins>
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
In-Reply-To: <1231281801.11687.125.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 6 Jan 2009, Peter Zijlstra wrote:
> > 
> > In fact, I suspect that's the real bug you're hitting: you're enabling 
> > preemption while holding a spinlock. That is NOT a good idea.
> 
> spinlocks also fiddle with preempt_count, that should all work out -
> although granted, it does look funny.

It most certainly doesn't always work out.

For example, the irq-disabling ones do *not* fiddle with preempt_count, 
because they disable preemption by just disabling interrupts. So doing 
preempt_enable() inside such a spinlock is almost guaranteed to lock up: 
because the preempt_enable() will now potentially call the scheduler with 
a spinlock held and with interrupts disabled.

That, in turn, can cause any number of problems - deadlocks with other 
processes that then try to take the spinlock that didn't get released, but 
also deadlocks with interrupts, since the scheduler will enable interrupts 
again.

So mixing preemption and spinlocks is almost always a bug. Yes, _some_ 
cases work out ok, but I'd call those the odd ones.

			Linus
