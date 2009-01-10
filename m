From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 16:05:26 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091535330.6528@localhost.localdomain>
References: <20090108141808.GC11629@elte.hu>  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>  <1231434515.14304.27.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com>  <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>  <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>  <20090109153508.GA4671@elte.hu>  <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
  <1231532276.2081.12.camel@entropy>  <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain> <1231543701.2081.185.camel@entropy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Nicholas Miell <nmiell@comcast.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231543701.2081.185.camel@entropy>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Nicholas Miell wrote:
> 
> So take your complaint about gcc's decision to inline functions called
> once.

Actually, the "called once" really is a red herring. The big complaint is 
"too aggressively when not asked for". It just so happens that the called 
once logic is right now the main culprit.

> Ignore for the moment the separate issue of stack growth and let's
> talk about what it does to debugging, which was the bulk of your
> complaint that I originally responded to.

Actually, stack growth is the one that ends up being a correctness issue. 
But:

> In the general case is it does nothing at all to debugging (beyond the
> usual weird control flow you get from any optimized code) -- the
> compiler generates line number information for the inlined functions,
> the debugger interprets that information, and your backtrace is
> accurate.

The thng is, we do not use line number information, and never will - 
because it's too big. MUCH too big.

We do end up saving function start information (although even that is 
actually disabled if you're doing embedded development), so that we can at 
least tell which function something happened in.

> It is only in the specific case of the kernel's broken backtrace code
> that this becomes an issue. It's failure to function correctly is the
> direct result of a failure to keep up with modern compiler changes that
> everybody else in the toolchain has dealt with.

Umm. You can say that. But the fact is, most others care a whole lot 
_less_ about those "modern compiler changes". In user space, when you 
debug something, you generally just stop optimizing. In the kernel, we've 
tried to balance the "optimize vs debug info" thing.

> I think that the answer to that is that the kernel should do its best to
> be as much like userspace apps as it can, because insisting on special
> treatment doesn't seem to be working.

The problem with that is that the kernel _isn't_ a normal app. An it 
_definitely_ isn't a normal app when it comes to debugging.

You can hand-wave and talk about it all you want, but it's just not going 
to happen. A kernel is special. We don't get dumps, and only crazy people 
even ask for them. 

The fact that you seem to think that we should get them just shows that 
you either don't udnerstand the problems, or you live in some sheltered 
environment wher crash-dumps _could_ work, but also by definition those 
environments aren't where they buy kernel developers anything.

The thing is, a crash dump in a "enterprise environment" (and that is the 
only kind where you can reasonably dump more than the minimal stuff we do 
now) is totally useless - because such kernels are usually at least a year 
old, often more. As such, debug information from enterprise users is 
almost totally worthless - if we relied on it, we'd never get anything 
done.

And outside of those kinds of very rare niches, big kernel dumps simply 
are not an option. Writing to disk when things go hay-wire in the kernel 
is the _last_ thing you must ever do. People can't have dedicated dump 
partitions or network dumps.

That's the reality. I'm not making it up. We can give a simple trace, and 
yes, we can try to do some off-line improvement on it (and kerneloops.org 
to some degree does), but that's just about it.

But debugging isn't even the only issue. It's just that debuggability is 
more important than a DUBIOUS improvement in code quality. See? Note the 
DUBIOUS.

Let's take a very practical example on a number that has been floated 
around here: letting gcc do inlining decisions apparently can help for up 
to about 4% of code-size. Fair enough - I happen to believe that we could 
cut that down a bit by just doing things manually with a checker, but 
that's neither here nor there.

What's the cost/benefit of that 4%? Does it actually improve performance? 
Especially if you then want to keep DWARF unwind information in memory in 
order to fix up some of the problems it causes? At that point, you lost 
all the memory you won, and then some.

Does it help I$ utilization (which can speed things up a lot more, and is 
probably the main reason -Os actually tends to perform better)? Likely 
not. Sure, shrinking code is good for I$, but on the other hand inlining 
can actually be bad for I$ density because if you inline a function that 
doesn't get called, you now fragmented your footprint a lot more.

So aggressively inlining has to be shown to be a real _win_.

You try to say "well, do better debug info", but that turns inlining into 
a _loss_, so then the proper response is "don't inline".

So when is inlining a win?

It's a win when the thing you inline is clearly not bigger than the call 
site. Then it's totally unambiguous.

It's also often a win if it's a unconditional call from a single site, and 
you only inline one such, so that you avoid all of the downsides (you may 
be able to _shrink_ stack usage, and you're hopefully making I$ accesses 
_denser_ rather than fragmenting it).

And if you can seriously simplify the code by taking advantage of constant 
arguments, it can be an absolutely _huge_ win. Except as we've seen in 
this discussion, gcc currently doesn't apparently even consider this case 
before it does the inlining decision.

But if we're just looking at code-size, then no, it's _not_ a win. Code 
size can be a win (4% denser I$ is good), but a lot of the cases I've seen 
(which is often the _bad_ cases, since I end up looking at them because we 
are chasing bugs due to things like stack usage), it's actually just 
fragmenting the function and making everybody lose.

Oh, and yes, it does depend on architectures. Some architectures suck at 
function calls. That's why being able to trust the compiler _would_ be a 
good thing, no question about that. But yes, we do need to be able to 
trust it to make sense.

			Linus
