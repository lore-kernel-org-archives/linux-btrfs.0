From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 30 Mar 2011 13:29:38 +0200
Message-ID: <1301484578.4859.178.camel@twins>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325101238.GC1409@htj.dyndns.org>
	 <20110329163702.GE29865@htj.dyndns.org>
	 <20110329170949.GF29865@htj.dyndns.org> <1301420253.2250.430.camel@laptop>
	 <20110330081716.GE17523@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110330081716.GE17523@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-03-30 at 10:17 +0200, Tejun Heo wrote:
> Hey, Peter.
> 
> On Tue, Mar 29, 2011 at 07:37:33PM +0200, Peter Zijlstra wrote:
> > On Tue, 2011-03-29 at 19:09 +0200, Tejun Heo wrote:
> > > Here's the combined patch I was planning on testing but didn't get to
> > > (yet).  It implements two things - hard limit on spin duration and
> > > early break if the owner also is spinning on a mutex.
> > 
> > This is going to give massive conflicts with
> > 
> >  https://lkml.org/lkml/2011/3/2/286
> >  https://lkml.org/lkml/2011/3/2/282
> > 
> > which I was planning to stuff into .40
> 
> I see.  Adapting shouldn't be hard.  The patch is in proof-of-concept
> stage anyway.
> 
> > > + * Forward progress is guaranteed regardless of locking ordering by never
> > > + * spinning longer than MAX_MUTEX_SPIN_NS.  This is necessary because
> > > + * mutex_trylock(), which doesn't have to follow the usual locking
> > > + * ordering, also uses this function.
> > 
> > While that puts a limit on things it'll still waste time. I'd much
> > rather pass an trylock argument to mutex_spin_on_owner() and then bail
> > on owner also spinning.
> 
> Do we guarantee or enforce that the lock ownership can't be
> transferred to a different task?  If we do, the recursive spinning
> detection is enough to guarantee forward progress.

The only way to switch owner is for the current owner to release and a
new owner to acquire the lock. Also we already bail the spin loop when
owner changes.

> > > +		if (task_thread_info(rq->curr) != owner ||
> > > +		    rq->spinning_on_mutex || need_resched() ||
> > > +		    local_clock() > start + MAX_MUTEX_SPIN_NS) {
> > 
> > While we did our best with making local_clock() cheap, I'm still fairly
> > uncomfortable with putting it in such a tight loop.
> 
> That's one thing I didn't really understand.  It seems the spinning
> code tried to be light on CPU cycle usage, but we're wasting CPU
> cycles there anyway.  If the spinning can become smarter using some
> CPU cycles, isn't that a gain?  Why is the spinning code optimizing
> for less CPU cycles?

Loop exit latency mostly, the lighter the loop, the faster you're
through the less time you waste once the condition is true, but yeah,
what you say is true too, its a balance game as always.

> Also, it would be great if you can share what you're using for locking
> performance measurements.  My attempts with dbench didn't end too
> well. :-(

The thing I used for the initial implementation is mentioned in the
changelog (0d66bf6d3):

    Testing with Ingo's test-mutex application (http://lkml.org/lkml/2006/1/8/50)
    gave a 345% boost for VFS scalability on my testbox:
    
     # ./test-mutex-shm V 16 10 | grep "^avg ops"
     avg ops/sec:               296604
    
     # ./test-mutex-shm V 16 10 | grep "^avg ops"
     avg ops/sec:               85870

I've no idea how heavy that is on trylock though, you'd have to look at
that.

Chris did some improvements using dbench in ac6e60ee4 but clearly that
isn't working for you.
