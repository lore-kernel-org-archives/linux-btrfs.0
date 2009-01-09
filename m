From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 09 Jan 2009 08:34:57 -0800
Message-ID: <49677CB1.3030701@zytor.com>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: jim owens <jowens@hp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109153508.GA4671@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

Ingo Molnar wrote:
> 
> My goal is to make the kernel smaller and faster, and as far as the 
> placement of 'inline' keywords goes, i dont have too strong feelings about 
> how it's achieved: they have a certain level of documentation value 
> [signalling that a function is _intended_ to be lightweight] but otherwise 
> they are pretty neutral attributes to me.
> 

As far as naming is concerned, gcc effectively supports four levels,
which *currently* map onto macros as follows:

__always_inline		Inline unconditionally
inline			Inlining hint
<nothing>		Standard heuristics
noinline		Uninline unconditionally

A lot of noise is being made about the naming of the levels (and I
personally believe we should have a different annotation for "inline
unconditionally for correctness" and "inline unconditionally for
performance", as a documentation issue), but those are the four we get.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

