From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 18:46:28 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901071844160.23456@gandalf.stny.rr.com>
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <20090107223317.GB27629@elte.hu>
 <4965331E.8090202@novell.com> <alpine.DEB.1.10.0901071806240.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
	Andi Kleen <andi@firstfloor.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <peterz@infradead.org>,
	paulmck@linux.vnet.ibm.com, Chris Mason <chris.mason@oracle.com>,
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
In-Reply-To: <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, 7 Jan 2009, Linus Torvalds wrote:
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

True. I need to keep looking at the code that is posted. In -rt, we force 
the fast path into the slowpath as soon as another task fails to get the 
lock. Without that, as you pointed out, the code can be racy.

-- Steve

