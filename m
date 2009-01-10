From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Sat, 10 Jan 2009 02:08:51 +0100
Message-ID: <20090110010851.GU26290@one.firstfloor.org>
References: <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain> <1231532276.2081.12.camel@entropy> <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain> <1231543701.2081.185.camel@entropy> <alpine.LFD.2.00.0901091535330.6528@localhost.localdomain> <20090110003709.GT26290@one.firstfloor.org> <alpine.LFD.2.00.0901091630440.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Nicholas Miell <nmiell@comcast.net>,
	Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
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
In-Reply-To: <alpine.LFD.2.00.0901091630440.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

> I thought -Os actually disabled the basic-block reordering, doesn't it?

Not in current gcc head no (just verified by stepping through) 

> 
> And I thought it did that exactly because it generates bigger code and 
> much worse I$ patterns (ie you have a lot of "conditional branch to other 
> place and then unconditional branch back" instead of "conditional branch 
> over the non-taken code".
> 
> Also, I think we've had about as much good luck with guessing 
> "likely/unlikely" as we've had with "inline" ;)

That's true.

But if you look at the default heuristics that gcc has (gcc/predict.def
in the gcc sources) like == NULL, < 0, branch guarding etc.
I would expect a lot of them to DTRT for the kernel.

Honza at some point even fixed goto to be unlikely after I complained :)
 
> Sadly, apart from some of the "never happens" error cases, the kernel 
> doesn't tend to have lots of nice patterns. We have almost no loops (well, 
> there are loops all over, but most of them we hopefully just loop over 
> once or twice in any good situation), and few really predictable things.

That actually makes us well suited to gcc, it has a relatively poor
loop optimizer compared to other compilers ;-)

> Or rather, they can easily be very predictable under one particular load, 
> and the totally the other way around under another ..

Yes that is why we got good branch predictors in CPUs I guess.

-Andi
-- 
ak@linux.intel.com
