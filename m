From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 11:59:46 -0800
Message-ID: <1231444786.5715.8.camel@brick>
References: <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090108183306.GA22916@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 19:33 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:

<snip>

> > 
> > Ingo - I think we need to remove that crap again. Because gcc gets the 
> > inlining horribly horribly wrong. As usual.
> 
> Apparently it messes up with asm()s: it doesnt know the contents of the 
> asm() and hence it over-estimates the size [based on string heuristics] 
> ...

<snip>

> That win is mixed in slowpath and fastpath as well.
> 
> I see three options:
> 
>  - Disable CONFIG_OPTIMIZE_INLINING=y altogether (it's already 
>    default-off)

I'd like to see this, leave all the heuristics out of it, if I say inline, I
don't mean _maybe_, I mean you'd better damn well inline it.  On the other
hand, alpha seems to be hand-disabling the inline means __always_inline
in their arch headers, so if this option is kept, it should be enabled
on alpha as that is the current state of play there and get rid of that
arch-private bit.

> 
>  - Change the asm() inline markers to something new like asm_inline, which
>    defaults to __always_inline.

I'd suggest just making inline always mean __always_inline.  And get to
work removing inline from functions in C files.  This is probably also the
better choice to keep older gccs producing decent code.

> 
>  - Just mark all asm() inline markers as __always_inline - realizing that 
>    these should never ever be out of line.
> 
> We might still try the second or third options, as i think we shouldnt go 
> back into the business of managing the inline attributes of ~100,000 
> kernel functions.

Or just make it clear that inline shouldn't (unless for a very good reason)
_ever_ be used in a .c file.

Cheers,

Harvey

