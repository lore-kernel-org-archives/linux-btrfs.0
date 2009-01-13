From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Tue, 13 Jan 2009 17:40:54 +0100
Message-ID: <1231864854.7141.8.camel@twins>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>,
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
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231863710.7141.3.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-13 at 17:21 +0100, Peter Zijlstra wrote:
> On Tue, 2009-01-13 at 08:16 -0800, Linus Torvalds wrote:
> > 
> > On Tue, 13 Jan 2009, Peter Zijlstra wrote:
> > > 
> > > Change mutex contention behaviour such that it will sometimes busy wait on
> > > acquisition - moving its behaviour closer to that of spinlocks.
> > 
> > Okey, dokey. Looks reasonable, but I wonder if this part came from v8 and 
> > wasn't intentional:
> > 
> > > +		if (atomic_xchg(&lock->count, -1) == 1) {
> > > +			lock_acquired(&lock->dep_map, ip);
> > > +			mutex_set_owner(lock);
> > > +			preempt_enable();
> > > +			return 0;
> > > +		}
> > 
> > Now you're forcing the slow-path on unlock. Maybe it was intentional, 
> > maybe it wasn't. Did you perhaps mean
> > 
> > 	if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> > 
> > here? I thought we agreed it was safe, if only because it should be 
> > equivalent to just having done "mutex_trylock()" instead of a "real" lock 
> > sequence.
> 
> Yes, that was an 'accident' from -v8, yes we did think the cmpxchg was
> good, however I did get some spurious lockups on -v7, and I only noticed
> the thing after I'd done most of the testing, so I decided to let it be
> for now.
> 
> Let me put the cmpxchg back in and see if this is all still good (only
> 3*2*2 configs to test :-).

Ok, tested only 1, but that was the one I remember lockups from -- and
that seems to be good with the cmpxchg.

Do you fancy me sending v10 or will you make that change locally?
