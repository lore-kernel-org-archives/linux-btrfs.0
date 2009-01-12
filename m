From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 15:19:12 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901121515560.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org>
 <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <496B9890.1090002@zytor.com> <alpine.LFD.2.00.0901121143070.6528@localhost.localdomain>
 <20090112230117.GC26430@shareable.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Harvey Harrison <harvey.harrison@gmail.com>,
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
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090112230117.GC26430@shareable.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, 12 Jan 2009, Jamie Lokier wrote:
> 
> Sometimes code motion makes code faster and/or smaller but use more
> stack space.  If you want to keep the stack use down, it blocks some
> other optimisations.

Uhh. Yes. Compiling is an exercise in trade-offs.

That doesn't mean that you should try to find the STUPID trade-offs, 
though.

The thing is, there is no excuse for gcc's stupid alias analysis. Other 
compilers actually take advantage of things like the C standards type 
alias ambiguity by (a) realizing that it's insane as a general thing and 
(b) limiting it to the real special cases, like assuming that pointers to 
floats and pointers to integers do not alias.

That, btw, is where the whole concept comes from. It should be passed off 
as an "unsafe FP optimization", where it actually makes sense, exactly 
like a lot of other unsafe FP optimizations.

			Linus
