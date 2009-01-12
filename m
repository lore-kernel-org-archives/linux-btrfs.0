From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 12:08:47 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901121200580.6528@localhost.localdomain>
References: <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
 <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
 <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
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
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Linus Torvalds wrote:
> 
> Type-based aliasing is unacceptably stupid to begin with, and gcc took 
> that stupidity to totally new heights by making it actually more important 
> than even statically visible aliasing.

Btw, there are good forms of type-based aliasing.

The 'restrict' keyword actually makes sense as a way to say "this pointer 
points to data that you cannot reach any other way". Of course, almost 
nobody uses it, and quite frankly, inlining can destroy that one too (a 
pointer that is restricted in the callEE is not necessarily restricted at 
all in the callER, and an inliner that doesn't track that subtle 
distinction will be very unhappy).

So compiler people usually don't much like 'restrict' - because it i very 
limited (you might even say restricted) in its meaning, and doesn't allow 
for nearly the same kind of wild optimizations than the insane standard C 
type-aliasing allows. 

The best option, of course, is for a compiler to handle just _static_ 
alias information that it can prove (whether by use of 'restrict' or by 
actually doing some fancy real analysis of its own allocations), and 
letting the hardware do run-time dynamic alias analysis.

I suspect gcc people were a bit stressed out by Itanium support - it's an 
insane architecture that basically requires an insane compiler for 
reasonable performance, and I think the Itanium people ended up 
brain-washing a lot of people who might otherwise have been sane.

So maybe I should blame Intel. Or HP. Because they almost certainly were 
at least a _part_ reason for bad compiler decisions.

			Linus
