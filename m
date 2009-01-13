From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 16:21:20 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901121602230.6528@localhost.localdomain>
References: <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
 <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
 <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andi Kleen <andi@firstfloor.org>,
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
To: Bernd Schmidt <bernds_cb1@t-online.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <496BBE27.2020206@t-online.de>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Bernd Schmidt wrote:
>
> Too lazy to construct one myself, I googled for examples, and here's a 
> trivial one that shows how it affects the ability of the compiler to 
> eliminate memory references:

Do you really think this is realistic or even relevant?

The fact is

 (a) most people use similar types, so your example of "short" vs "int" is 
     actually not very common. Type-based alias analysis is wonderful for 
     finding specific examples of something you can optimize, but it's not 
     actually all that wonderful in general. It _particularly_ isn't 
     wonderful once you start looking at the downsides.

     When you're adding arrays of integers, you're usually adding 
     integers. Not "short"s. The shorts may be a great example of a 
     special case, but it's a special case!

 (b) instructions with memory accesses aren't the problem - instructions 
     that take cache misses are. Your example is an excellent example of 
     that - eliding the simple load out of the loop makes just about 
     absolutely _zero_ difference in any somewhat more realistic scenario, 
     because that one isn't the one that is going to make any real 
     difference anyway.

The thing is, the way to optimize for modern CPU's isn't to worry 
over-much about instruction scheduling. Yes, it matters for the broken 
ones, but it matters in the embedded world where you still find in-order 
CPU's, and there the size of code etc matters even more.

> I'll grant you that if you're writing a kernel or maybe a malloc
> library, you have reason to be unhappy about it.  But that's what
> compiler switches are for: -fno-strict-aliasing allows you to write code
> in a superset of C.

Oh, I'd use that flag regardless yes. But what you didn't seem to react to 
was that gcc - for no valid reason what-so-ever - actually trusts (or at 
least trusted: I haven't looked at that code for years) provably true 
static alias information _less_ than the idiotic weaker type-based one.

You make all this noise about how type-based alias analysis improves code, 
but then you can't seem to just look at the example I gave you. Type-based 
alias analysis didn't improve code. It just made things worse, for no 
actual gain. Moving those accesses to the stack around just causes worse 
behavior, and a bigger stack frame, which causes more cache misses.

[ Again, I do admit that kernel code is "different": we tend to have a 
  cold stack, in ways that many other code sequences do not have. System 
  code tends to get a lot more I$ and D$ misses. Deep call-chains _will_ 
  take cache misses on the stack, simply because the user will do things 
  between system calls or page faults that almost guarantees that things 
  are not in L1, and often not in L2 either.

  Also, sadly, microbenchmarks often hide this, since they are often 
  exactly the unrealistic kinds of back-to-back system calls that almost 
  no real program ever has, since real programs actually _do_ something 
  with the data. ]

My point is, you're making all these arguments and avoiding looking at the 
downsides of what you are arguing for.

So we use -Os - because it generally generates better (and simpler) code. 
We use -fno-strict-alias for the same reason. 

			Linus
