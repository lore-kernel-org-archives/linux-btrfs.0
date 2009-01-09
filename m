From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 09 Jan 2009 15:28:21 -0800
Message-ID: <1231543701.2081.185.camel@entropy>
References: <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com>
	 <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
	 <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>
	 <20090109153508.GA4671@elte.hu>
	 <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
	 <1231532276.2081.12.camel@entropy>
	 <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
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
In-Reply-To: <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-01-09 at 12:29 -0800, Linus Torvalds wrote:
> 
> On Fri, 9 Jan 2009, Nicholas Miell wrote:
> > 
> > Maybe the kernel's backtrace code should be fixed instead of blaming
> > gcc.
> 
> And maybe people who don't know what they are talking about shouldn't 
> speak?

I may not know what I'm talking about, but you don't have to be rude
about it, at least not until I've made a nuisance of myself, and a
single mail surely isn't yet a nuisance.

> You just loaded the whole f*cking debug info just to do that exact 
> analysis. Guess how big it is for the kernel?

It's huge, I know. My understanding is that the DWARF size could be
reduced rather dramatically if redundant DIEs were coalesced into a
single entry. Even then it would still be too large to load into the
kernel for runtime stack trace generation, but that's what the offline
analysis of crash dumps is for.

> Did you even read this discussion? 

No, I didn't read most of the discussion, I only started skimming it
after I saw the gcc people talking negatively about the latest brouhaha.
(And this thread being an offshoot of a large thread that is itself an
offshoot of another large thread certainly didn't help me find the
relevant parts of the discussion, either). So I'm sorry that I missed
whatever comments you made on the subject

(As an aside, I'm amazed that anything works at all when the kernel,
compiler and runtime library people all seem to mutually loathe each
other to the point of generally refusing to communicate at all.)

> Did you see my comments about why 
> kernel backtrace debugging is different from regular user mode debugging?

I think I found the mail in question[1], and after reading it, I found
that it touches on one of the things I was thinking about while looking
through the thread.

The majority of code built by gcc was, is and always will be userspace
code. The kernel was, is and always will be of minor importance to gcc.
gcc will never be perfect for kernel use.

So take your complaint about gcc's decision to inline functions called
once. Ignore for the moment the separate issue of stack growth and let's
talk about what it does to debugging, which was the bulk of your
complaint that I originally responded to.

In the general case is it does nothing at all to debugging (beyond the
usual weird control flow you get from any optimized code) -- the
compiler generates line number information for the inlined functions,
the debugger interprets that information, and your backtrace is
accurate.

It is only in the specific case of the kernel's broken backtrace code
that this becomes an issue. It's failure to function correctly is the
direct result of a failure to keep up with modern compiler changes that
everybody else in the toolchain has dealt with.

So putting "helpfully" in sarcastic quotes or calling what gcc does a
gcc problem is outright wrong. For most things, gcc's behavior does
actually help, and it is a kernel's problem (by virtue of the kernel
being different and strange), not gcc's.

The question then becomes, how does the kernel deal with the fact that
it is of minor importance to gcc and significantly different from the
bulk of gcc's consumers to the point where those differences become
serious problems?

I think that the answer to that is that the kernel should do its best to
be as much like userspace apps as it can, because insisting on special
treatment doesn't seem to be working.

In this specific case, that would mean make kernel debugging as much
like userspace debugging as you can -- stop pretending that stack traces
generated by the kernel at runtime are adequate, get kernel crash dumps
enabled and working 100% of the time, and then use a debugger to examine
the kernel's core dump and find your stack trace.

As an added bonus, real crash dumps aren't limited just to backtraces,
so you'd have even more information to work with to find the root cause
of the failure.





[1] Message ID: alpine.LFD.2.00.0901090947080.6528@localhost.localdomain
-- 
Nicholas Miell <nmiell@comcast.net>

