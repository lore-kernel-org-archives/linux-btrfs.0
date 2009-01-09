From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 11:44:40 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901091142060.17378@gandalf.stny.rr.com>
References: <1231441350.14304.48.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>  <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins> <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
 <alpine.LFD.2.00.0901090828510.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901090828510.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


On Fri, 9 Jan 2009, Linus Torvalds wrote:

> 
> 
> On Fri, 9 Jan 2009, Steven Rostedt wrote:
> > 
> > I was going to say a while ago...
> > In PREEMPT=y the need_resched() is not needed at all. If you have 
> > preemption enabled, you will get preempted in that loop. No need for the 
> > need_resched() in the outer loop. Although I'm not sure how it would even 
> > hit the "need_resched". If it was set, then it is most likely going to be 
> > cleared when coming back from being preempted.
> 
> No, no, you miss the point entirely.

No I did not miss your point. I was commenting on the current code ;-)

> So quite frankly, if you have CONFIG_PREEMPT, then the spinning really is 
> the wrong thing to do, or the whole mutex slow-path thing should be done 
> with preemption disabled so that we only schedule where we _should_ be 
> scheduling.

I agree here. I was going to recommend to add a preempt_disable in the 
spinner. And keep the need_resched test. Then we should not allow 
preemption until we get all the way to the point of the schedule in the 
contention case, or when we get the lock.

When we get to the schedule() it then needs to be a:

	preempt_enable_no_resched();
	schedule();

-- Steve

