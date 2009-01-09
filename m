From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 17:42:12 -0800
Message-ID: <4966AB74.2090104@zytor.com>
References: <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231366716.11687.377.camel@twins> <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090108190038.GH496@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
>> I'll try to annotate the inline asms (there's not _that_ many of them), 
>> and measure what the size impact is.
> 
> You can just use the patch I submitted and that you rejected for
> most of them :)

I just ran a sample build for x86-64 with gcc 4.3.0, these all
allyesconfig builds (modulo the inlining option):

: voreg 64 ; size o.*/vmlinux
   text    data     bss     dec     hex     filename
57590217 24940519 15560504 98091240 5d8c0e8 o.andi/vmlinux
59421552 24912223 15560504 99894279 5f44407 o.noopt/vmlinux
57700527 24950719 15560504 98211750 5da97a6 o.opty/vmlinux

A 3% code size difference even on allyesconfig (1.8 MB!) is nothing to
sneeze at.  As shown by the delta from Andi's patch, these small
assembly stubs really do need to be annotated, since gcc simply has no
way to do anything sane with them -- it just doesn't know.

Personally, I'd like to see __asm_inline as opposed to __always_inline
for these, though, as a documentation issue: __always_inline implies to
me that this function needs to be inlined for correctness, and this
could be highly relevant if someone, for example, recodes the routine in
C or decides to bloat it out (e.g. paravirt_ops).

It's not a perfect solution even then, because gcc may choose to not
inline a higher level of inline functions for the same bogus reason.
There isn't much we can do about that, though, unless gcc either
integrates the assembler, or gives us some way of injecting the actual
weight of the asm statement...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

