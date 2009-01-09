From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
	impact
Date: Fri, 9 Jan 2009 14:00:57 +0100
Message-ID: <20090109130057.GA31845@elte.hu>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 8 Jan 2009, H. Peter Anvin wrote:
> > 
> > Right.  gcc simply doesn't have any way to know how heavyweight an 
> > asm() statement is
> 
> I don't think that's relevant.
> 
> First off, gcc _does_ have a perfectly fine notion of how heavy-weight 
> an "asm" statement is: just count it as a single instruction (and count 
> the argument setup cost that gcc _can_ estimate).
> 
> That would be perfectly fine. If people use inline asms, they tend to 
> use it for a reason.
> 
> However, I doubt that it's the inline asm that was the biggest reason 
> why gcc decided not to inline - it was probably the constant "switch()" 
> statement. The inline function actually looks pretty large, if it wasn't 
> for the fact that we have a constant argument, and that one makes the 
> switch statement go away.
> 
> I suspect gcc has some pre-inlining heuristics that don't take constant 
> folding and simplifiation into account - if you look at just the raw 
> tree of the function without taking the optimization into account, it 
> will look big.

Yeah. In my tests GCC 4.3.2 does properly inline that particular asm.

But because we cannot really trust GCC in this area yet (or at all), today 
i've conducted extensive tests measuring GCC's interaction with inlined 
asm statements. I built hundreds of vmlinux's and distilled the numbers. 
Here are my findings.

Firstly i've written 40 patches that gradually add an __asm_inline 
annotation to all inline functions of arch/x86/include/asm/*.h - i've 
annotated 224 inline functions that way.

Then i've conducted an x86 defconfig and an x86 allyesconfig test for each 
of the 40 patches.

Realizing that there's assymetry in the inlining practices of drivers and 
kernel code, i've also conducted a separate series of tests: measuring the 
size increase/decrease of the core kernel, kernel/built-in.o.

The first table containts the size numbers of kernel/built-in.o, on 
allyesconfig builds, and the size delta (and percentage):

 ( Object size tests on kernel: v2.6.28-7939-g2150edc
 (                       using: gcc (GCC) 4.3.2 20081007 (Red Hat 4.3.2-6)
 (                      target: kernel/ kernel/built-in.o
 (                      config: x86.64.allyes

                                 name     text-size    (   delta)  (      pct)
 -----------------------------------------------------------------------------
                  always-inline.patch:      1039591    (       0)  (   0.000%)
              optimize-inlining.patch:       967724    (  -71867)  (  -7.426%)

                   asm-inline-0.patch:       967724    (       0)  (   0.000%)
       asm-inline-bitops-simple.patch:       967691    (     -33)  (  -0.003%)
 asm-inline-bitops-constant-set.patch:       966947    (    -744)  (  -0.077%)
 asm-inline-bitops-test-and-set.patch:       966735    (    -212)  (  -0.022%)
          asm-inline-bitops-ffs.patch:       966735    (       0)  (   0.000%)
                   asm-inline-__ffs.h:       966735    (       0)  (   0.000%)
                   asm-inline-__fls.h:       966735    (       0)  (   0.000%)
                     asm-inline-fls.h:       966735    (       0)  (   0.000%)
                   asm-inline-fls64.h:       966735    (       0)  (   0.000%)
                    asm-inline-apic.h:       966735    (       0)  (   0.000%)
               asm-inline-atomic_32.h:       966735    (       0)  (   0.000%)
               asm-inline-atomic_64.h:       966735    (       0)  (   0.000%)
             asm-inline-checksum_32.h:       966735    (       0)  (   0.000%)
             asm-inline-checksum_64.h:       966735    (       0)  (   0.000%)
              asm-inline-cmpxchg_32.h:       966735    (       0)  (   0.000%)
              asm-inline-cmpxchg_64.h:       966735    (       0)  (   0.000%)
                    asm-inline-desc.h:       966735    (       0)  (   0.000%)
                   asm-inline-futex.h:       966735    (       0)  (   0.000%)
                    asm-inline-i387.h:       966735    (       0)  (   0.000%)
                      asm-inline-io.h:       966735    (       0)  (   0.000%)
                   asm-inline-io_32.h:       966735    (       0)  (   0.000%)
                   asm-inline-io_64.h:       966735    (       0)  (   0.000%)
                asm-inline-irqflags.h:       966735    (       0)  (   0.000%)
                   asm-inline-kexec.h:       966735    (       0)  (   0.000%)
                    asm-inline-kgdb.h:       966735    (       0)  (   0.000%)
                asm-inline-kvm_host.h:       966735    (       0)  (   0.000%)
                asm-inline-kvm_para.h:       966735    (       0)  (   0.000%)
            asm-inline-lguest_hcall.h:       966735    (       0)  (   0.000%)
                   asm-inline-local.h:       966735    (       0)  (   0.000%)
                     asm-inline-msr.h:       966735    (       0)  (   0.000%)
                asm-inline-paravirt.h:       966735    (       0)  (   0.000%)
                 asm-inline-pci_x86.h:       966735    (       0)  (   0.000%)
               asm-inline-processor.h:       966735    (       0)  (   0.000%)
                   asm-inline-rwsem.h:       966735    (       0)  (   0.000%)
                  asm-inline-signal.h:       966735    (       0)  (   0.000%)
                asm-inline-spinlock.h:       966735    (       0)  (   0.000%)
               asm-inline-string_32.h:       966735    (       0)  (   0.000%)
                    asm-inline-swab.h:       966735    (       0)  (   0.000%)
             asm-inline-sync_bitops.h:       966735    (       0)  (   0.000%)
                  asm-inline-system.h:       966735    (       0)  (   0.000%)
               asm-inline-system_64.h:       966735    (       0)  (   0.000%)
             asm-inline-thread_info.h:       966735    (       0)  (   0.000%)
                asm-inline-tlbflush.h:       966735    (       0)  (   0.000%)
                     asm-inline-xcr.h:       966735    (       0)  (   0.000%)
                   asm-inline-xsave.h:       966735    (       0)  (   0.000%)

[ The patch names reflect the include file names where i did the changes. ]

There are two surprising results:

Firstly, the CONFIG_OPTIMIZE_INLINING=y build is 7.4% more compact than 
the "always inline as instructed by kernel hackers" build:

              optimize-inlining.patch:       967724    (  -71867)  (  -7.426%)

Secondly: out of 40 patches, only three make an actual vmlinux object size 
difference (!):

       asm-inline-bitops-simple.patch:       967691    (     -33)  (  -0.003%)
 asm-inline-bitops-constant-set.patch:       966947    (    -744)  (  -0.077%)
 asm-inline-bitops-test-and-set.patch:       966735    (    -212)  (  -0.022%)

And those three have a combined effect of 0.1% - noise compared to the 
7.4% that inline optimization already brought us. [it's still worth 
improving.]

I have also conducted full x86.64.defconfig vmlinux builds for each of the 
patches, and tabulated the size changes:

 ( Object size tests on kernel: v2.6.28-7939-g2150edc
 (                       using: gcc (GCC) 4.3.2 20081007 (Red Hat 4.3.2-6)
 (                      target: vmlinux vmlinux
 (                      config: x86.64.defconfig

                                 name     text-size    (   delta)  (      pct)
 -----------------------------------------------------------------------------
                  always-inline.patch:      7045187    (       0)  (   0.000%)
              optimize-inlining.patch:      6987053    (  -58134)  (  -0.832%)

                   asm-inline-0.patch:      6987053    (       0)  (   0.000%)
       asm-inline-bitops-simple.patch:      6987053    (       0)  (   0.000%)
 asm-inline-bitops-constant-set.patch:      6961126    (  -25927)  (  -0.372%)
 asm-inline-bitops-test-and-set.patch:      6961126    (       0)  (   0.000%)
          asm-inline-bitops-ffs.patch:      6961126    (       0)  (   0.000%)
                   asm-inline-__ffs.h:      6961126    (       0)  (   0.000%)
                   asm-inline-__fls.h:      6961126    (       0)  (   0.000%)
                     asm-inline-fls.h:      6961126    (       0)  (   0.000%)
                   asm-inline-fls64.h:      6961126    (       0)  (   0.000%)
                    asm-inline-apic.h:      6961126    (       0)  (   0.000%)
               asm-inline-atomic_32.h:      6961126    (       0)  (   0.000%)
               asm-inline-atomic_64.h:      6961126    (       0)  (   0.000%)
             asm-inline-checksum_32.h:      6961126    (       0)  (   0.000%)
             asm-inline-checksum_64.h:      6961126    (       0)  (   0.000%)
              asm-inline-cmpxchg_32.h:      6961126    (       0)  (   0.000%)
              asm-inline-cmpxchg_64.h:      6961126    (       0)  (   0.000%)
                    asm-inline-desc.h:      6961126    (       0)  (   0.000%)
                   asm-inline-futex.h:      6961126    (       0)  (   0.000%)
                    asm-inline-i387.h:      6961126    (       0)  (   0.000%)
                      asm-inline-io.h:      6961126    (       0)  (   0.000%)
                   asm-inline-io_32.h:      6961126    (       0)  (   0.000%)
                   asm-inline-io_64.h:      6961126    (       0)  (   0.000%)
                asm-inline-irqflags.h:      6961126    (       0)  (   0.000%)
                   asm-inline-kexec.h:      6961126    (       0)  (   0.000%)
                    asm-inline-kgdb.h:      6961126    (       0)  (   0.000%)
                asm-inline-kvm_host.h:      6961126    (       0)  (   0.000%)
                asm-inline-kvm_para.h:      6961126    (       0)  (   0.000%)
            asm-inline-lguest_hcall.h:      6961126    (       0)  (   0.000%)
                   asm-inline-local.h:      6961126    (       0)  (   0.000%)
                     asm-inline-msr.h:      6961126    (       0)  (   0.000%)
                asm-inline-paravirt.h:      6961126    (       0)  (   0.000%)
                 asm-inline-pci_x86.h:      6961126    (       0)  (   0.000%)
               asm-inline-processor.h:      6961126    (       0)  (   0.000%)
                   asm-inline-rwsem.h:      6961126    (       0)  (   0.000%)
                  asm-inline-signal.h:      6961126    (       0)  (   0.000%)
                asm-inline-spinlock.h:      6961126    (       0)  (   0.000%)
               asm-inline-string_32.h:      6961126    (       0)  (   0.000%)
                    asm-inline-swab.h:      6961126    (       0)  (   0.000%)
             asm-inline-sync_bitops.h:      6961126    (       0)  (   0.000%)
                  asm-inline-system.h:      6961126    (       0)  (   0.000%)
               asm-inline-system_64.h:      6961126    (       0)  (   0.000%)
             asm-inline-thread_info.h:      6961126    (       0)  (   0.000%)
                asm-inline-tlbflush.h:      6961126    (       0)  (   0.000%)
                     asm-inline-xcr.h:      6961126    (       0)  (   0.000%)
                   asm-inline-xsave.h:      6961126    (       0)  (   0.000%)

This is a surprising result too: the manual annotation of asm inlines 
(totally against my expectations) made even less of a difference.

Here's the allyesconfig vmlinux builds as well:

 ( Object size tests on kernel: v2.6.28-7939-g2150edc
 (                       using: gcc (GCC) 4.3.2 20081007 (Red Hat 4.3.2-6)
 (                    building: vmlinux vmlinux
 (                      config: x86.64.allyes

                                 name     text-size    (   delta)  (      pct)
 
-----------------------------------------------------------------------------
                  always-inline.patch:     59089458    (       0)  (   0.000%)
              optimize-inlining.patch:     57363721    (-1725737)  (  -3.008%)
               asm-inline-combo.patch:     57254254    ( -109467)  (  -0.191%)

Similar pattern: optimize-inlining helps a lot, the manual annotations 
only a tiny bit more. [no finegrained results here - it would take me a 
week to finish a hundred allyesconfig builds. But the results line up with 
the kernel/built-in.o allyesconfig results.]

Another surprise to me was that according to the numbers the core kernel 
appears to be much worse with its inlining practices (at least in terms of 
absolute text size) than the full kernel.

I found these numbers hard to believe, so i double-checked them against 
source-level metrics: i compared the number of 'inline' keywords compared 
against object size, of kernel/built-in.o versus that of 
drivers/built-in.o. (on allyesconfig)

The results are:

                       nr-inlines     .o size      inline-frequency (bytes)

  kernel/built-in.o:          529      1177230     2225
 drivers/built-in.o:         9105     27933205     3067


i.e. in the driver space we get an inline function for every ~3K bytes of 
code, in the core kernel we get an inline function every ~2K bytes of 
code.

One interpretation of the numbers would be that core kernel hackers are 
more inline-happy, maybe because they think that their functions are more 
important to inline.

Which is generally a fair initial assumption, but according to the numbers 
it does not appear to pay off in practice as it does not result in a 
smaller kernel image. (Driver authors tend to be either more disciplined - 
or more lazy in that respect.)

One final note. One might ask, which one was this particular patch, which 
made the largest measurable impact on the allyesconfig build and which 
also showed up in the defconfig builds:

 asm-inline-bitops-constant-set.patch:      6961126    (  -25927)  (  -0.372%)

See that patch below, it is another surprise: a single inline function.
[ GCC uninlines this one as its inliner probably got lost in the 
  __builtin_constant_p() trick we are doing there. ]

It is a central bitop primitive (test_bit()), so it made a relatively 
large difference of 0.3% to the defconfig build.

So out of the 224 functions i annotated manually, only one was inlined 
incorrectly by GCC. (that matters to x86 defconfig)

Note that these numbers match hpa's 4.3.0 based allyesconfig numbers very 
closely:

 |  : voreg 64 ; size o.*/vmlinux
 |     text    data     bss     dec     hex     filename
 |  57590217 24940519 15560504 98091240 5d8c0e8 o.andi/vmlinux
 |  59421552 24912223 15560504 99894279 5f44407 o.noopt/vmlinux
 |  57700527 24950719 15560504 98211750 5da97a6 o.opty/vmlinux

So the conclusion: GCC 4.3.x appears to do an acceptable job at inlining 
(if not, i'd like to see the specific .config where it screws up). We've 
also seen a few clear examples of earlier GCC versions screwing up with 
inlining.

So my inclination would be: either mark CONFIG_OPTIMIZE_INLINING as 
CONFIG_BROKEN, or limit CONFIG_OPTIMIZE_INLINING to GCC 4.3.x and later 
versions only.

I'm no fan of the GCC inliner, but the latter seems to be the more 
rational choice to me - the size win from inline-optimization is 
significant: 1% for defconfig, 3% for allyesconfig and 7.5% for the core 
kernel (allyesconfig).

	Ingo

---------------------->
Subject: asm: inline bitops constant set
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Jan 09 11:43:20 CET 2009

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bitops.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/bitops.h
===================================================================
--- linux.orig/arch/x86/include/asm/bitops.h
+++ linux/arch/x86/include/asm/bitops.h
@@ -300,7 +300,8 @@ static inline int test_and_change_bit(in
 	return oldbit;
 }
 
-static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
+static __asm_inline int
+constant_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
