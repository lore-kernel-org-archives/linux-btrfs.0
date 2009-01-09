From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 14:37:10 +0100
Message-ID: <20090109133710.GB31845@elte.hu>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
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
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4966AB74.2090104@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>


* H. Peter Anvin <hpa@zytor.com> wrote:

> Andi Kleen wrote:
> >> I'll try to annotate the inline asms (there's not _that_ many of them), 
> >> and measure what the size impact is.
> > 
> > You can just use the patch I submitted and that you rejected for
> > most of them :)
> 
> I just ran a sample build for x86-64 with gcc 4.3.0, these all
> allyesconfig builds (modulo the inlining option):
> 
> : voreg 64 ; size o.*/vmlinux
>    text    data     bss     dec     hex     filename
> 59421552 24912223 15560504 99894279 5f44407 o.noopt/vmlinux
> 57700527 24950719 15560504 98211750 5da97a6 o.opty/vmlinux
> 57590217 24940519 15560504 98091240 5d8c0e8 o.andi/vmlinux
> 
> A 3% code size difference even on allyesconfig (1.8 MB!) is nothing to 
> sneeze at.  As shown by the delta from Andi's patch, these small 
> assembly stubs really do need to be annotated, since gcc simply has no 
> way to do anything sane with them -- it just doesn't know.

I've done a finegrained size analysis today (see my other mail in this 
thread), and it turns out that on gcc 4.3.x the main (and pretty much 
only) inlining annotation that matters in arch/x86/include/asm/*.h is the 
onliner patch attached below, annotating constant_test_bit().

That change is included in Andi's patch too AFAICS - i.e. just that single 
hunk from Andi's patch would have given you 90% of the size win - an 
additional 0.17% size win to the 3.00% that CONFIG_OPTIMIZE_INLINING=y 
already brings.

The second patch below had some (much smaller, 0.01% ) impact too. All the 
other annotations i did to hundreds of inlined asm()s had no measurable 
effect on GCC 4.3.2. (i.e. gcc appears to inline single-statement asms 
correctly)

[ On older GCC it might matter more, but there we can/should turn off
  CONFIG_OPTIMIZE_INLINING. ]

> Personally, I'd like to see __asm_inline as opposed to __always_inline 
> for these, though, as a documentation issue: __always_inline implies to 
> me that this function needs to be inlined for correctness, and this 
> could be highly relevant if someone, for example, recodes the routine in 
> C or decides to bloat it out (e.g. paravirt_ops).

Yeah. I've implemented __asm_inline today. It indeed documents the reason 
for the annotation in a cleaner way than slapping __always_inline around 
and diluting the quality of __always_inline annotations.

> It's not a perfect solution even then, because gcc may choose to not 
> inline a higher level of inline functions for the same bogus reason. 
> There isn't much we can do about that, though, unless gcc either 
> integrates the assembler, or gives us some way of injecting the actual 
> weight of the asm statement...

Yeah.

	Ingo

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



 arch/x86/include/asm/bitops.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/arch/x86/include/asm/bitops.h
===================================================================
--- linux.orig/arch/x86/include/asm/bitops.h
+++ linux/arch/x86/include/asm/bitops.h
@@ -53,7 +53,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
+static __asm_inline void set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -75,7 +75,7 @@ static inline void set_bit(unsigned int 
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static __asm_inline void __set_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -90,7 +90,7 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static __asm_inline void clear_bit(int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -117,7 +117,7 @@ static inline void clear_bit_unlock(unsi
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static __asm_inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -152,7 +152,7 @@ static inline void __clear_bit_unlock(un
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static __asm_inline void __change_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -166,7 +166,7 @@ static inline void __change_bit(int nr, 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static __asm_inline void change_bit(int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "xorb %1,%0"
