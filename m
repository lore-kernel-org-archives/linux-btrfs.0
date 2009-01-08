From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 10:41:11 -0800
Message-ID: <496648C7.5050700@zytor.com>
References: <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231366716.11687.377.camel@twins> <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20090108183306.GA22916@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

Ingo Molnar wrote:
> 
> Apparently it messes up with asm()s: it doesnt know the contents of the 
> asm() and hence it over-estimates the size [based on string heuristics] 
> ...
> 

Right.   gcc simply doesn't have any way to know how heavyweight an
asm() statement is, and it WILL do the wrong thing in many cases --
especially the ones which involve an out-of-line recovery stub.  This is
due to a fundamental design decision in gcc to not integrate the
compiler and assembler (which some compilers do.)

> Which is bad - asm()s tend to be the most important entities to inline - 
> all over our fastpaths .
> 
> Despite that messup it's still a 1% net size win:
> 
>       text    data     bss     dec     hex filename
>    7109652 1464684  802888 9377224  8f15c8 vmlinux.always-inline
>    7046115 1465324  802888 9314327  8e2017 vmlinux.optimized-inlining
> 
> That win is mixed in slowpath and fastpath as well.

The good part here is that the assembly ones really don't have much
subtlety -- a function call is at least five bytes, usually more once
you count in the register spill penalties -- so __always_inline-ing them
should still end up with numbers looking very much like the above.

> I see three options:
> 
>  - Disable CONFIG_OPTIMIZE_INLINING=y altogether (it's already 
>    default-off)
> 
>  - Change the asm() inline markers to something new like asm_inline, which
>    defaults to __always_inline.
> 
>  - Just mark all asm() inline markers as __always_inline - realizing that 
>    these should never ever be out of line.
> 
> We might still try the second or third options, as i think we shouldnt go 
> back into the business of managing the inline attributes of ~100,000 
> kernel functions.
> 
> I'll try to annotate the inline asms (there's not _that_ many of them), 
> and measure what the size impact is.

The main reason to do #2 over #3 would be for programmer documentation.
 There simply should be no reason to ever out-of-lining these.  However,
documenting the reason to the programmer is a valuable thing in itself.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

