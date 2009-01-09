From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 09 Jan 2009 11:47:42 +0100
Message-ID: <1231498062.11687.608.camel@twins>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Mason <chris.mason@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>,
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 11:54 -0800, Linus Torvalds wrote:

> I was pretty sure that adding the unlocked loop should provably not change 
> the mutex lock semantics. Why? Because it's just basically equivalent to 
> just doing the mutex_trylock() without really changing anything really 
> fundamental in the mutex logic.
> 
> And that argument is sadly totally bogus. 

It fails for the RT case, yes. It should still be true for regular tasks
- if the owner tracking was accurate.

> The thing is, we used to have this guarantee that any contention would 
> always go into the slowpath, and then in the slow-path we serialize using 
> the spinlock. 
> 
> So I think the bug is still there, we just hid it better by breaking out 
> of the loop with that "if (need_resched())" always eventually triggering. 
> And it would be ok if it really is guaranteed to _eventually_ trigger, and 
> I guess with timeslices it eventually always will, but I suspect we could 
> have some serious latency spikes.

Yes, the owner getting preempted after acquiring the lock, but before
setting the owner can give some nasties :-(

I initially did that preempt_disable/enable around the fast path, but I
agree that slowing down the fast path is unwelcome.

Alternatively we could go back to block on !owner, with the added
complexity of not breaking out of the spin on lock->owner != owner
when !lock->owner, so that the premature owner clearing of the unlock
fast path will not force a schedule right before we get a chance to
acquire the lock.

Let me do that..

> The problem? Setting "lock->count" to 0. That will mean that the next 
> "mutex_unlock()" will not necessarily enter the slowpath at all, and won't 
> necessarily wake things up like it should.

That's exactly what __mutex_fastpath_trylock() does (or can do,
depending on the implementation), so if regular mutexes are correct in
the face of a trylock stealing the lock in front of a woken up waiter,
then we're still good.

That said, I'm not seeing how mutexes aren't broken already.

say A locks it: counter 1->0
then B contends: counter 0->-1, added to wait list
then C contentds: counter -1, added to wait list
then A releases: counter -1->1, wake someone up, say B
then D trylocks: counter 1->0
so B is back to wait list
then D releases, 0->1, no wakeup

Aaah, B going back to sleep sets it to -1

Therefore, I think we're good.
