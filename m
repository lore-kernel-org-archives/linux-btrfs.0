From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 10:59:48 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
References: <1231441350.14304.48.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>  <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231513614.442.11.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>


On Fri, 9 Jan 2009, Peter Zijlstra wrote:

> On Fri, 2009-01-09 at 11:47 +0100, Peter Zijlstra wrote:
> 
> > > So I think the bug is still there, we just hid it better by breaking out 
> > > of the loop with that "if (need_resched())" always eventually triggering. 
> > > And it would be ok if it really is guaranteed to _eventually_ trigger, and 
> > > I guess with timeslices it eventually always will, but I suspect we could 
> > > have some serious latency spikes.
> > 
> > Yes, the owner getting preempted after acquiring the lock, but before
> > setting the owner can give some nasties :-(
> > 
> > I initially did that preempt_disable/enable around the fast path, but I
> > agree that slowing down the fast path is unwelcome.
> > 
> > Alternatively we could go back to block on !owner, with the added
> > complexity of not breaking out of the spin on lock->owner != owner
> > when !lock->owner, so that the premature owner clearing of the unlock
> > fast path will not force a schedule right before we get a chance to
> > acquire the lock.
> > 
> > Let me do that..
> 
> Ok a few observations..
> 
> Adding that need_resched() in the outer loop utterly destroys the
> performance gain for PREEMPT=y. Voluntary preemption is mostly good, but
> somewhat unstable results.

I was going to say a while ago...
In PREEMPT=y the need_resched() is not needed at all. If you have 
preemption enabled, you will get preempted in that loop. No need for the 
need_resched() in the outer loop. Although I'm not sure how it would even 
hit the "need_resched". If it was set, then it is most likely going to be 
cleared when coming back from being preempted.

> 
> Adding that blocking on !owner utterly destroys everything.

I was going to warn you about that ;-)

Without the check for !owner, you are almost guaranteed to go to sleep 
every time. Here's why:

You are spinning and thus have a hot cache on that CPU.

The owner goes to unlock but will be in a cold cache. It sets lock->owner 
to NULL, but is still in cold cache so it is a bit slower.

Once the spinner sees the NULL, it shoots out of the spin but sees the 
lock is still not available then goes to sleep. All before the owner could 
release it. This could probably happen at every contention. Thus, you lose 
the benefit of spinning. You probably make things worse because you add a 
spin before every sleep.

-- Steve

