From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 15:52:46 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901071551170.3057@localhost.localdomain>
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <20090107223317.GB27629@elte.hu>
 <4965331E.8090202@novell.com> <alpine.DEB.1.10.0901071806240.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain> <alpine.DEB.1.10.0901071844160.23456@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0901071846430.23456@gandalf.stny.rr.com>
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
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901071846430.23456@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 7 Jan 2009, Steven Rostedt wrote:

> 
> On Wed, 7 Jan 2009, Steven Rostedt wrote:
> > 
> > True. I need to keep looking at the code that is posted. In -rt, we force 
> > the fast path into the slowpath as soon as another task fails to get the 
> > lock. Without that, as you pointed out, the code can be racy.
> 
> I mean we force the fast unlock path into the slow path as soon as another 
> task fails to get the lock.

I think the mainline mutex code does that all right too - we keep the 
counter negative all the time when it has contention.

So the original model where the spinning was done only after we'd gotten 
the spinlock probably was correct. However, it _is_ a lot more expensive 
than the "optimistic spin" model.

		Linus
