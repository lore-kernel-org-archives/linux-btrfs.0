From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Wed, 21 Jan 2009 08:23:36 +1100 (EST)
Message-ID: <alpine.LFD.2.00.0901210814130.2892@localhost.localdomain>
References: <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de>
 <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de> <20090120123824.GD7790@elte.hu> <1232480940.22233.1435.camel@macbook.infradead.org> <20090120210515.GC19710@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Woodhouse <dwmw2@infradead.org>,
	Nick Piggin <npiggin@suse.de>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Andi Kleen <andi@firstfloor.org>,
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
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090120210515.GC19710@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 20 Jan 2009, Ingo Molnar wrote:
> 
> (Different-type pointer uses are a common pattern: we have a lot of places 
> where we have pointers to structures with different types so 
> strict-aliasing optimization opportunities apply quite broadly already.)

Yes and no.

It's true that the kernel in general uses mostly pointers through 
structures that can help the type-based thing.

However, the most common and important cases are actually the very same 
structures. In particular, things like <linux/list.h>. Same "struct list", 
often embedded into another case of the same struct.

And that's where "restrict" can actually help. It might be interesting to 
see, for example, if it makes any difference to add a "restrict" qualifier 
to the "new" pointer in __list_add(). That might give the compiler the 
ability to schedule the stores to next->prev and prev->next differently, 
and maybe it could matter? 

It probably is not noticeable. The big reason for wanting to do alias 
analysis tends to not be thatt kind of code at all, but the cases where 
you can do much bigger simplifications, or on in-order machines where you 
really want to hoist things like FP loads early and FP stores late, and 
alias analysis (and here type-based is more reasonable) shows that the FP 
accesses cannot alias with the integer accesses around it.

In x86, I doubt _any_ amount of alias analysis makes a hug difference (as 
long as the compiler at least doesn't think that local variable spills can 
alias with anything else). Not enough registers, and generally pretty 
aggressively OoO (with alias analysis in hardware) makes for a much less 
sensitive platform.

			Linus
