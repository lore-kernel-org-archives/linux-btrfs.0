From: Ingo Molnar <mingo@elte.hu>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
	implement adaptive spinning
Date: Mon, 19 Jan 2009 01:13:45 +0100
Message-ID: <20090119001345.GA9880@elte.hu>
References: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	David Woodhouse <dwmw2@infradead.org>,
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
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Bernd Schmidt <bernds_cb1@t-online.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756341AbZASAO2@vger.kernel.org>
In-Reply-To: <496BBE27.2020206@t-online.de>
List-ID: <linux-btrfs.vger.kernel.org>


* Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> Linus Torvalds wrote:
> > But you'll need some background to it:
> 
> You paint a somewhat one-sided picture bordering on FUD.
> 
> > Type-based aliasing is _stupid_.
> 
> Type-based aliasing is simply an application of the language definition, 
> and depending on the compiled application and/or target architecture, it 
> can be essential for performance.
> [...]
>
> So, to summarize: strict aliasing works for nearly every application 
> these days, there's a compiler switch for the rest to turn it off, it 
> can be a serious performance improvement, and the compiler warns about 
> dangerous constructs.  That makes the issue a little less black and 
> white than "type based aliasing is stupid".

i did some size measurements. Latest kernel, gcc 4.3.2, x86 defconfig, 
vmlinux built with strict-aliasing optimizations and without.

The image sizes are:

     text    data     bss     dec     hex filename
  6997984 1635900 1322376 9956260  97eba4 vmlinux.gcc.-fno-strict-aliasing
  6985962 1635884 1322376 9944222  97bc9e vmlinux.gcc.strict-aliasing

that's 0.17% of a size win only.

The cost? More than _300_ new "type-punned" warnings during the kernel 
build (3000 altogether, including duplicates that trigger in multiple 
object files) - more than _1000_ new warnings (more than 10,000 total) in 
an allyesconfig build.

That is a _ton_ of effort for a ~0.1% category win. Often in historic code 
that has been working well and now got broken by gcc.

I think this feature has been over-sold while it under-performs. You also 
significantly weakened the utility of the C language for lowlevel 
hardware-conscious programming as a result (which is the strongest side of 
C by far).

Type based aliasing should at most have been an opt-in for code that 
cares, not a turned-on-by-default feature for everyone.

You already dismissed concerns in this thread by suggesting that Linux is 
just one of many projects, but that way you dismiss 1) the largest OSS 
project by linecount 2) one of the most performance-optimized pieces of 
OSS software in existence.

I.e. you dismiss what should have been GCC's strongest supporter, ally, 
test-field and early prototype tester. A lot of folks in the kernel look 
at the assembly level on a daily basis, they run the latest hardware and 
they see where GCC messes up. By dismissing Linux you cut yourself off 
from a lot of development power, you cut yourself off from a lot of 
enthusiasm and you miss out on a lot of dynamism that would naturally help 
GCC too.

I.e. almost by definition you cannot possibly be interested in writing the 
best compiler on the planet.

	Ingo
