From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Sat, 10 Jan 2009 01:37:09 +0100
Message-ID: <20090110003709.GT26290@one.firstfloor.org>
References: <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain> <1231532276.2081.12.camel@entropy> <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain> <1231543701.2081.185.camel@entropy> <alpine.LFD.2.00.0901091535330.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nicholas Miell <nmiell@comcast.net>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
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

> What's the cost/benefit of that 4%? Does it actually improve performance? 
> Especially if you then want to keep DWARF unwind information in memory in 
> order to fix up some of the problems it causes? At that point, you lost 

dwarf unwind information has nothing to do with this, it doesn't tell
you anything about inlining or not inlining.  It just gives you
finished frames after all of that has been done.

Full line number information would help, but I don't think anyone 
proposed to keep that in memory.

> Does it help I$ utilization (which can speed things up a lot more, and is 
> probably the main reason -Os actually tends to perform better)? Likely 
> not. Sure, shrinking code is good for I$, but on the other hand inlining 
> can actually be bad for I$ density because if you inline a function that 
> doesn't get called, you now fragmented your footprint a lot more.

Not sure that is always true; the gcc basic block reordering 
based on its standard branch prediction heuristics (e.g. < 0 or
== NULL unlikely or the unlikely macro) might well put it all out of line.

-Andi
