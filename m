From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 19:46:30 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
References: <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231366716.11687.377.camel@twins> <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
 <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu>
 <496648C7.5050700@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>,
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
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <496648C7.5050700@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 8 Jan 2009, H. Peter Anvin wrote:
> 
> Right.   gcc simply doesn't have any way to know how heavyweight an
> asm() statement is

I don't think that's relevant.

First off, gcc _does_ have a perfectly fine notion of how heavy-weight an 
"asm" statement is: just count it as a single instruction (and count the 
argument setup cost that gcc _can_ estimate).

That would be perfectly fine. If people use inline asms, they tend to use 
it for a reason.

However, I doubt that it's the inline asm that was the biggest reason why 
gcc decided not to inline - it was probably the constant "switch()" 
statement. The inline function actually looks pretty large, if it wasn't 
for the fact that we have a constant argument, and that one makes the 
switch statement go away.

I suspect gcc has some pre-inlining heuristics that don't take constant 
folding and simplifiation into account - if you look at just the raw tree 
of the function without taking the optimization into account, it will look 
big.

			Linus
