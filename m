From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 15:23:54 -0800
Message-ID: <20090107232354.GM6900@linux.vnet.ibm.com>
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Gregory Haskins <ghaskins@novell.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49652C7C.3000909@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 07, 2009 at 05:28:12PM -0500, Gregory Haskins wrote:
> Andi Kleen wrote:
> >> I appreciate this is sample code, but using __get_user() on
> >> non-userspace pointers messes up architectures which have separate
> >> user/kernel spaces (eg the old 4G/4G split for x86-32).  Do we have an
> >> appropriate function for kernel space pointers? 
> >>     
> >
> > probe_kernel_address().
> >
> > But it's slow.
> >
> > -Andi
> >
> >   
> 
> Can I ask a simple question in light of all this discussion? 
> 
> "Is get_task_struct() really that bad?"
> 
> I have to admit you guys have somewhat lost me on some of the more
> recent discussion, so its probably just a case of being naive on my
> part...but this whole thing seems to have become way more complex than
> it needs to be.  Lets boil this down to the core requirements:  We need
> to know if the owner task is still running somewhere in the system as a
> predicate to whether we should sleep or spin, period.  Now the question
> is how to do that.
> 
> The get/put task is the obvious answer to me (as an aside, we looked at
> task->oncpu rather than the rq->curr stuff which I believe was better),
> and I am inclined to think that is perfectly reasonable way to do this: 
> After all, even if acquiring a reference is somewhat expensive (which I
> don't really think it is on a modern processor), we are already in the
> slowpath as it is and would sleep otherwise.
> 
> Steve proposed a really cool trick with RCU since we know that the task
> cannot release while holding the lock, and the pointer cannot go away
> without waiting for a grace period.  It turned out to introduce latency
> side-effects so it  ultimately couldn't be used (and this was in no way
> a knock against RCU or you, Paul..just wasn't the right tool for the job
> it turned out).

Too late...

I already figured out a way to speed up preemptable RCU's read-side
primitives (to about as fast as CONFIG_PREEMPT RCU's read-side primitives)
and also its grace-period latency.  And it is making it quite clear that
it won't let go of my brain until I implement it...  ;-)

							Thanx, Paul

> Ok, so onto other ideas.  What if we simply look at something like a
> scheduling sequence id.  If we know (within the wait-lock) that task X
> is the owner and its on CPU A, then we can simply monitor if A context
> switches.  Having something like rq[A]->seq++ every time we schedule()
> would suffice and you wouldnt need to hold a task reference...just note
> A=X->cpu from inside the wait-lock.  I guess the downside there is
> putting that extra increment in the schedule() hotpath even if no-one
> cares, but I would surmise that should be reasonably cheap when no-one
> is pulling the cacheline around other than A (i.e. no observers).
> 
> But anyway, my impression from observing the direction this discussion
> has taken is that it is being way way over optimized before we even know
> if a) the adaptive stuff helps, and b) the get/put-ref hurts.  Food for
> thought.
> 
> -Greg
> 
> 
> 


