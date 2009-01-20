From: Ingo Molnar <mingo@elte.hu>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
	implement adaptive spinning
Date: Tue, 20 Jan 2009 23:05:16 +0100
Message-ID: <20090120220516.GA10483@elte.hu>
References: <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de> <20090120123824.GD7790@elte.hu> <1232480940.22233.1435.camel@macbook.infradead.org> <20090120210515.GC19710@elte.hu> <alpine.LFD.2.00.0901210814130.2892@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901210814130.2892@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 20 Jan 2009, Ingo Molnar wrote:
> > 
> > (Different-type pointer uses are a common pattern: we have a lot of 
> > places where we have pointers to structures with different types so 
> > strict-aliasing optimization opportunities apply quite broadly 
> > already.)
> 
> Yes and no.
> 
> It's true that the kernel in general uses mostly pointers through 
> structures that can help the type-based thing.
> 
> However, the most common and important cases are actually the very same 
> structures. In particular, things like <linux/list.h>. Same "struct 
> list", often embedded into another case of the same struct.
> 
> And that's where "restrict" can actually help. It might be interesting 
> to see, for example, if it makes any difference to add a "restrict" 
> qualifier to the "new" pointer in __list_add(). That might give the 
> compiler the ability to schedule the stores to next->prev and prev->next 
> differently, and maybe it could matter?
> 
> It probably is not noticeable. The big reason for wanting to do alias 
> analysis tends to not be thatt kind of code at all, but the cases where 
> you can do much bigger simplifications, or on in-order machines where 
> you really want to hoist things like FP loads early and FP stores late, 
> and alias analysis (and here type-based is more reasonable) shows that 
> the FP accesses cannot alias with the integer accesses around it.

Hm, GCC uses __restrict__, right?

The patch below makes no difference at all on an x86 defconfig:

  vmlinux:
     text	   data	    bss	    dec	    hex	filename
  7253544	1641812	1324296	10219652	 9bf084	vmlinux.before
  7253544	1641812	1324296	10219652	 9bf084	vmlinux.after

not a single instruction was changed:

 --- vmlinux.before.asm
 +++ vmlinux.after.asm
 @@ -1,5 +1,5 @@
 
 -vmlinux.before:     file format elf64-x86-64
 +vmlinux.after:     file format elf64-x86-64

I'm wondering whether there's any internal tie-up between alias analysis 
and the __restrict__ keyword - so if we turn off aliasing optimizations 
the __restrict__ keyword's optimizations are turned off as well.

Nope, with aliasing optimizations turned back on there's still no change 
on the x86 defconfig:

     text	   data	    bss	    dec	    hex	filename
  7240893	1641796	1324296	10206985	 9bbf09	vmlinux.before
  7240893	1641796	1324296	10206985	 9bbf09	vmlinux.after

GCC 4.3.2. Maybe i missed something obvious?

	Ingo

---
 include/linux/list.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/include/linux/list.h
===================================================================
--- linux.orig/include/linux/list.h
+++ linux/include/linux/list.h
@@ -38,7 +38,7 @@ static inline void INIT_LIST_HEAD(struct
  * the prev/next entries already!
  */
 #ifndef CONFIG_DEBUG_LIST
-static inline void __list_add(struct list_head *new,
+static inline void __list_add(struct list_head * __restrict__ new,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
@@ -48,7 +48,7 @@ static inline void __list_add(struct lis
 	prev->next = new;
 }
 #else
-extern void __list_add(struct list_head *new,
+extern void __list_add(struct list_head * __restrict__ new,
 			      struct list_head *prev,
 			      struct list_head *next);
 #endif
