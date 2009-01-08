From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 08:10:30 +0100
Message-ID: <1231398630.11687.382.camel@twins>
References: <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <20090107210923.GV2002@parisc-linux.org>
	 <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com>
	 <20090107223317.GB27629@elte.hu> <4965331E.8090202@novell.com>
	 <alpine.DEB.1.10.0901071806240.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
	Matthew Wilcox <matthew@wil.cx>, paulmck@linux.vnet.ibm.com,
	Chris Mason <chris.mason@oracle.com>,
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
In-Reply-To: <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 15:32 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Jan 2009, Steven Rostedt wrote:
> > 
> > What would be interesting is various benchmarks against all three.
> > 
> > 1) no mutex spinning.
> > 2) get_task_struct() implementation.
> > 3) spin_or_sched implementation.
> 
> One of the issues is that I cannot convince myself that (2) is even 
> necessarily correct. At least not without having all cases happen inder 
> the mutex spinlock - which they don't. Even with the original patch, the 
> uncontended cases set and cleared the owner field outside the lock.

Yes, 2 isn't feasible for regular mutexes as we have non-atomic owner
tracking.

I've since realized the whole rtmutex thing is fundamentally difference
on a few levels:

  a) we have atomic owner tracking (that's the lock itself, it holds the
task_pointer as a cookie), and 

  b) we need to do that whole enqueue on the waitlist thing because we
need to do the PI propagation and such to figure out if the current task
is even allowed to acquire -- that is, only the highest waiting and or
lateral steal candidates are allowed to spin acquire.


