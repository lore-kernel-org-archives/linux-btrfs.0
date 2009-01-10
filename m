From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 20:05:27 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901092000130.6528@localhost.localdomain>
References: <20090108141808.GC11629@elte.hu>  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>  <1231434515.14304.27.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com>  <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>  <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>  <20090109153508.GA4671@elte.hu>  <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
  <1231532276.2081.12.camel@entropy>  <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain>  <1231543701.2081.185.camel@entropy>  <alpine.LFD.2.00.0901091535330.6528@localhost.localdomain> <1231553564.2081.287.camel@entropy>
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
In-Reply-To: <1231553564.2081.287.camel@entropy>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Nicholas Miell wrote:
> 
> It's only too big if you always keep it in memory, and I wasn't
> suggesting that.

Umm. We're talking kernel panics here. If it's not in memory, it doesn't 
exist as far as the kernel is concerned.

If it doesn't exist, it cannot be reported.

> My point was that you can get completely accurate stack traces in the
> face of gcc's inlining, and that blaming gcc because you can't get good
> stack traces because the kernel's debugging infrastructure isn't up to
> snuff isn't exactly fair.

No. I'm blaming inlining for making debugging harder.

And that's ok - IF IT IS WORTH IT.

It's not. Gcc inlining decisions suck. gcc inlines stuff that doesn't 
really help from being inlined, and doesn't inline stuff that _does_.

What's so hard to accept in that?

> And this is where we disagree. I believe that crash dumps should be the
> norm and all the reasons you have against crash dumps in general are in
> fact reasons against Linux's sub-par implementation of crash dumps in
> specific.

Good luck with that. Go ahead and try it.  You'll find it wasn't so easy 
after all.

> So, here I am, a non-enterprise end user with a non-stale kernel who'd
> love to be able to give you a crash dump (or, more likely, a stack trace
> created from that crash dump), but I can't because Linux crash dumps are
> stuck in the enterprise ghetto.

No, you're stuck because you apparently have your mind stuck on a 
crash-dump, and aren't willing to look at alternatives.

You could use a network console. Trust me - if you can't set up a network 
console, you have no business mucking around with crash dumps.

And if the crash is hard enough that you can't any output from that, 
again, a crash dump wouldn't exactly help, would it?

> Hell, I'd be happy if I could get the the normal panic text written to
> disk, but since the hard part is the actual writing to disk, there's no
> reason not to do the full crash dump if you can.

Umm. And why do you think the two have anything to do with each other?

Only insane people want the kernel to write to disk when it has problems. 
Sane people try to write to something that doesn't potentially overwrite 
their data. Like the network.

Which is there. Try it. Trust me, it's a _hell_ of a lot more likely to 
wotk than a crash dump.

			Linus
