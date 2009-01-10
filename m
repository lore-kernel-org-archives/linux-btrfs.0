From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 16:41:33 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091630440.6528@localhost.localdomain>
References: <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
 <1231532276.2081.12.camel@entropy> <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain> <1231543701.2081.185.camel@entropy> <alpine.LFD.2.00.0901091535330.6528@localhost.localdomain> <20090110003709.GT26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nicholas Miell <nmiell@comcast.net>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090110003709.GT26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Sat, 10 Jan 2009, Andi Kleen wrote:
>
> > What's the cost/benefit of that 4%? Does it actually improve performance? 
> > Especially if you then want to keep DWARF unwind information in memory in 
> > order to fix up some of the problems it causes? At that point, you lost 
> 
> dwarf unwind information has nothing to do with this, it doesn't tell
> you anything about inlining or not inlining.  It just gives you
> finished frames after all of that has been done.
> 
> Full line number information would help, but I don't think anyone 
> proposed to keep that in memory.

Yeah, true. Although one of the reasons inlining actually ends up causing 
problems is because of the bigger stack frames. That leaves a lot of space 
for old stale function pointers to peek through.

With denser stack frames, the stack dumps look better, even without an 
unwinder.

> > Does it help I$ utilization (which can speed things up a lot more, and is 
> > probably the main reason -Os actually tends to perform better)? Likely 
> > not. Sure, shrinking code is good for I$, but on the other hand inlining 
> > can actually be bad for I$ density because if you inline a function that 
> > doesn't get called, you now fragmented your footprint a lot more.
> 
> Not sure that is always true; the gcc basic block reordering 
> based on its standard branch prediction heuristics (e.g. < 0 or
> == NULL unlikely or the unlikely macro) might well put it all out of line.

I thought -Os actually disabled the basic-block reordering, doesn't it?

And I thought it did that exactly because it generates bigger code and 
much worse I$ patterns (ie you have a lot of "conditional branch to other 
place and then unconditional branch back" instead of "conditional branch 
over the non-taken code".

Also, I think we've had about as much good luck with guessing 
"likely/unlikely" as we've had with "inline" ;)

Sadly, apart from some of the "never happens" error cases, the kernel 
doesn't tend to have lots of nice patterns. We have almost no loops (well, 
there are loops all over, but most of them we hopefully just loop over 
once or twice in any good situation), and few really predictable things.

Or rather, they can easily be very predictable under one particular load, 
and the totally the other way around under another ..

			Linus
