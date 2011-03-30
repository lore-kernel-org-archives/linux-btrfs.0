From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 30 Mar 2011 07:59:13 -0400
Message-ID: <1301485909-sup-4022@think>
References: <20110323153727.GB12003@htj.dyndns.org> <20110324094119.GD12038@htj.dyndns.org> <20110324094151.GE12038@htj.dyndns.org> <20110325101238.GC1409@htj.dyndns.org> <20110329163702.GE29865@htj.dyndns.org> <1301485262-sup-5247@think> <1301485924.4859.181.camel@twins>
Content-Type: text/plain; charset=UTF-8
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1301485924.4859.181.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Peter Zijlstra's message of 2011-03-30 07:52:04 -0400:
> On Wed, 2011-03-30 at 07:46 -0400, Chris Mason wrote:
> > 
> > In this case, the only thing we're really missing is a way to mutex_lock
> > without the cond_resched() 
> 
> So you're trying to explicitly avoid a voluntary preemption point? Seems
> like a bad idea, normally people add those :-)

Yeah, but the btrfs fast path (when we're able to spin today) looks like
this:

spin_lock(parent)
binary search, select slot
pull block for that slot out of cache
spin_lock(child)
spin_unlock(parent)

If we switch it all to mutexes:

mutex_lock(parent)
binary search, select slot
pull block for that slot out of cache
mutex_lock(child)
mutex_unlock(parent)

Most of the spinning vs blocking benefits in btrfs came from doing
special things (like dropping the parent lock) when we know we're going
to block with the parent lock held.  Surprise blocking in mutex_lock
isn't great.

It would probably be enough to just move the cond_resched() after the
spinning portion of the mutex_lock()

-chris
