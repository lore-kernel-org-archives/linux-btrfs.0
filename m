From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 09 Jan 2009 18:12:44 -0800
Message-ID: <1231553564.2081.287.camel@entropy>
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
	 <1231543701.2081.185.camel@entropy>
	 <alpine.LFD.2.00.0901091535330.6528@localhost.localdomain>
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
In-Reply-To: <alpine.LFD.2.00.0901091535330.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-01-09 at 16:05 -0800, Linus Torvalds wrote:
> 
> On Fri, 9 Jan 2009, Nicholas Miell wrote:
> 
> > In the general case is it does nothing at all to debugging (beyond the
> > usual weird control flow you get from any optimized code) -- the
> > compiler generates line number information for the inlined functions,
> > the debugger interprets that information, and your backtrace is
> > accurate.
> 
> The thng is, we do not use line number information, and never will - 
> because it's too big. MUCH too big.
> 

It's only too big if you always keep it in memory, and I wasn't
suggesting that.

My point was that you can get completely accurate stack traces in the
face of gcc's inlining, and that blaming gcc because you can't get good
stack traces because the kernel's debugging infrastructure isn't up to
snuff isn't exactly fair.

> We do end up saving function start information (although even that is 
> actually disabled if you're doing embedded development), so that we can at 
> least tell which function something happened in.
> 
> > It is only in the specific case of the kernel's broken backtrace code
> > that this becomes an issue. It's failure to function correctly is the
> > direct result of a failure to keep up with modern compiler changes that
> > everybody else in the toolchain has dealt with.
> 
> Umm. You can say that. But the fact is, most others care a whole lot 
> _less_ about those "modern compiler changes". In user space, when you 
> debug something, you generally just stop optimizing. In the kernel, we've 
> tried to balance the "optimize vs debug info" thing.

The bulk of the libraries that your userspace app links to are
distro-built with full optimization and figuring out why an optimized
build crashed does come up from time to time, so those changes still
matter.

> > I think that the answer to that is that the kernel should do its best to
> > be as much like userspace apps as it can, because insisting on special
> > treatment doesn't seem to be working.
> 
> The problem with that is that the kernel _isn't_ a normal app. An it 
> _definitely_ isn't a normal app when it comes to debugging.
> 
> You can hand-wave and talk about it all you want, but it's just not going 
> to happen. A kernel is special. We don't get dumps, and only crazy people 
> even ask for them.
>
> The fact that you seem to think that we should get them just shows that 
> you either don't udnerstand the problems, or you live in some sheltered 
> environment wher crash-dumps _could_ work, but also by definition those 
> environments aren't where they buy kernel developers anything.
> 
> The thing is, a crash dump in a "enterprise environment" (and that is the 
> only kind where you can reasonably dump more than the minimal stuff we do 
> now) is totally useless - because such kernels are usually at least a year 
> old, often more. As such, debug information from enterprise users is 
> almost totally worthless - if we relied on it, we'd never get anything 
> done.
> 
> And outside of those kinds of very rare niches, big kernel dumps simply 
> are not an option. Writing to disk when things go hay-wire in the kernel 
> is the _last_ thing you must ever do. People can't have dedicated dump 
> partitions or network dumps.
> 
> That's the reality. I'm not making it up. We can give a simple trace, and 
> yes, we can try to do some off-line improvement on it (and kerneloops.org 
> to some degree does), but that's just about it.
>

And this is where we disagree. I believe that crash dumps should be the
norm and all the reasons you have against crash dumps in general are in
fact reasons against Linux's sub-par implementation of crash dumps in
specific.

I can semi-reliably panic my kernel, and it's fairly recent, too
(2.6.27.9-159.fc10.x86_64). Naturally, I run X, so the result of a panic
is a frozen screen, blinking keyboard lights, the occasional endless
audio loop, and no useful information whatsoever. I looked into kdump,
only to discover that it doesn't work (but it could, it's a simple
matter of fixing the initrd's script to support LVM), but I've already
found a workaround, and after fiddling with kdump, I just don't care
anymore

So, here I am, a non-enterprise end user with a non-stale kernel who'd
love to be able to give you a crash dump (or, more likely, a stack trace
created from that crash dump), but I can't because Linux crash dumps are
stuck in the enterprise ghetto.

You're right, the bulk of the people who do use kdump these days are
enterprise people running ancient enterprise kernels, but that has more
to do with kdump being an unusable bastard red-headed left-handed
stepchild that you only use if you can't avoid it than it has to do with
the crash dump concept being useless.

Hell, I'd be happy if I could get the the normal panic text written to
disk, but since the hard part is the actual writing to disk, there's no
reason not to do the full crash dump if you can.


-- 
Nicholas Miell <nmiell@comcast.net>

