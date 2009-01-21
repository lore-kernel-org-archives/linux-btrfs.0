From: Andi Kleen <andi@firstfloor.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Wed, 21 Jan 2009 10:54:18 +0100
Message-ID: <20090121095418.GG15750@one.firstfloor.org>
References: <20090120005124.GD16304@wotan.suse.de> <20090120123824.GD7790@elte.hu> <1232480940.22233.1435.camel@macbook.infradead.org> <20090120210515.GC19710@elte.hu> <alpine.LFD.2.00.0901210814130.2892@localhost.localdomain> <20090120220516.GA10483@elte.hu> <20090121085402.GD15750@one.firstfloor.org> <20090121085208.GO24891@wotan.suse.de> <20090121092049.GE15750@one.firstfloor.org> <20090121092550.GP24891@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090121092550.GP24891@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

> The point is that the compiler is then free to do it. If things
> slow down after the compiler gets *more* information, then that
> is a problem with the compiler heuristics rather than the
> information we give it.

The point was the -Os disables it typically then.
(not always, compiler heuristics are far from perfect)

> 
>  
> > Then x86s tend to have very very fast L1 caches and
> > if something is not in L1 on reads then the cost of fetching
> > something for a read dwarfs the few cycles you can typically
> > get out of this.
> 
> Well most architectures have L1 caches of several cycles. And
> L2 miss typically means going to L2 which in some cases the
> compiler is expected to attempt to cover as much as possible
> (eg in-order architectures).

L2 cache is so much slower that scheduling a few instructions
more doesn't help much.

> stall, so you still want to get loads out early if possible.
> 
> Even a lot of OOOE CPUs I think won't have the best alias
> anaysis, so all else being equal, it wouldn't hurt them to
> move loads earlier.

Hmm, but if the load is nearby it won't matter if a 
store is in the middle, because the CPU will just execute
over it.

The real big win is if you do some computation inbetween,
but at least for typical list manipulation there isn't 
really any.

> > Also at least x86 gcc normally doesn't do scheduling 
> > beyond basic blocks, so any if () shuts it up.
> 
> I don't think any of this is a reason not to use restrict, though.
> But... there are so many places we could add it to the kernel, and
> probably so few where it makes much difference. Maybe it should be
> able to help some critical core code, though.

Frankly I think it would be another unlikely().

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
