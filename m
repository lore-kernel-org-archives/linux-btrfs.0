From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sun, 11 Jan 2009 01:54:58 +0100
Message-ID: <20090111005458.GA5363@elte.hu>
References: <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <1231549697.5700.7.camel@brick> <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain> <49682C05.7030407@zytor.com> <alpine.LFD.2.00.0901092119100.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
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
	Sven Dietrich <SDietrich@novell.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901092119100.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 9 Jan 2009, H. Peter Anvin wrote:
> > 
> > I was thinking about experimenting with this, to see what level of 
> > upside it might add.  Ingo showed me numbers which indicate that a 
> > fairly significant fraction of the cases where removing inline helps 
> > is in .h files, which would require code movement to fix.  Hence to 
> > see if it can be automated.
> 
> We _definitely_ have too many inline functions in headers. They usually 
> start out small, and then they grow. And even after they've grown big, 
> it's usually not at all clear exactly where else they should go, so even 
> when you realize that "that shouldn't be inlined", moving them and 
> making them uninlined is not obvious.
> 
> And quite often, some of them go away - or at least shrink a lot - when 
> some config option or other isn't set. So sometimes it's an inline 
> because a certain class of people really want it inlined, simply because 
> for _them_ it makes sense, but when you enable debugging or something, 
> it absolutely explodes.

IMO it's all quite dynamic when it comes to inlining.

Beyond the .config variances (which alone is enough degrees of freedom to 
make this non-static, it at least is a complexity we can control in the 
kernel to a certain degree) it also depends on the platform, the CPU type, 
the compiler version - factors which we dont (and probably dont want to) 
control.

There's also the in-source variance of how many times an inline function 
is used within a .c file, and that factor is not easily tracked. If it's 
used once in a single .c file it should be inlined even if it's large. If 
it's used twice in a .c file it might be put out of line. Transition 
between those states is not obvious in all cases.

There's certainly clear-cut cases: the very small/constant ones that must 
be short and inlined in any environment, and the very large/complex ones 
that must not be inlined under any circumstance.

But there's a lot of shades of grey inbetween - and that's where the size 
wins come from. I'm not sure we can (or should) generally expect kernel 
coders to continuously maintain the 30,000+ inline attributes in the 
kernel that involve 100,000+ functions:

 - Nothing breaks if it's there, nothing breaks if it's not there.
   It's a completely opaque, transparent entity that never pushes itself 
   to the foreground of human attention.

 - It's so easy to add an inline function call site to a .c file without 
   noticing that it should not be inlined anymore.

 - It's so easy to _remove_ a usage site from a .c file without noticing
   that something should be inlined. I.e. local changes will have an 
   effect on the inline attribute _elsewhere_ - and this link is not 
   obvious and not tooled when editing the code.

 - The mapping from C statements to assembly can be non-obvious even to
   experienced developers. Data type details (signed/unsigned, width,
   etc.) can push an inline function over the (very hard to define)
   boundary.

I.e. IMO it's all very dynamic, it's opaque, it's not visualized and it's 
hard to track - so it's very fundamentally not for humans to maintain 
[except for the really clear-cut cases].

Add to that that in _theory_ the decision to inline or not is boringly 
mechanic and tools ought to be able to do a near-perfect job with it and 
just adopt to whatever environment the kernel is in at a given moment when 
it's built.

GCC limps along with its annoyingly mis-designed inlining heuristics, 
hopefully LLVC will become a real compiler that is aware of little details 
like instruction size and has a built-in assembler ...

So IMO all the basic psychological mechanics are missing from the picture 
that would result in really good, "self-maintained" inline attributes.

We can try to inject the requirement to have good inline attributes as an 
external rule, as a principle we want to see met - but we cannot expect it 
to be followed really in its current form, as it goes subtly against the 
human nature on various levels.

	Ingo
