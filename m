From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 08:34:34 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901090828510.6528@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>  <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins> <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
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
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Steven Rostedt wrote:
> 
> I was going to say a while ago...
> In PREEMPT=y the need_resched() is not needed at all. If you have 
> preemption enabled, you will get preempted in that loop. No need for the 
> need_resched() in the outer loop. Although I'm not sure how it would even 
> hit the "need_resched". If it was set, then it is most likely going to be 
> cleared when coming back from being preempted.

No, no, you miss the point entirely.

It's not about correctness.

Remember: the whole (and only) point of spinning is about performance.

And the thing is, we should only spin if it makes sense. So the

	if (need_resched())
		break;

is not there because of any "ok, I need to sleep now", it's there because 
of something TOTALLY DIFFERENT, namely "ok, it makes no sense to spin now, 
since I should be sleeping".

See? WE DO NOT WANT TO BE PREEMPTED in this region, because that totally 
destroys the whole point of the spinning. If we go through the scheduler, 
then we should go through the scheduler AND GO TO SLEEP, so that we don't 
go through the scheduler any more than absolutely necessary.

So this code - by design - is always only going to get worse if you have 
involuntary preemption. The preemption is going to do _two_ bad things:

 - it's going to call the scheduler at the wrong point, meaning that we 
   now scheduler _more_ (or at least not less) than if we didn't have that 
   spin-loop in the first place.

 - .. and to make things worse, since it scheduled "for us", it is going 
   to clear that "need_resched()" flag, so we'll _stay_ in the bad 
   spinning loop too long!

So quite frankly, if you have CONFIG_PREEMPT, then the spinning really is 
the wrong thing to do, or the whole mutex slow-path thing should be done 
with preemption disabled so that we only schedule where we _should_ be 
scheduling.

			Linus
