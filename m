Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621F39DBFF;
	Fri, 27 Mar 2026 06:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592535; cv=none; b=HnoonwZE4d9msVxgt0FvewoALLq5PdQfza1b0ZCc2+fg3SXSnZVUdIElARA4hJ1FU8MpD2DADbtdzdwlsbG+IFU4qx445gZPVwzkECMTjYEU9kaY90zNAj4V5/v1TTRX4eXjJnQ3AMzTDuJhAyuGD5fWTuhqwpvFLtH662d4U08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592535; c=relaxed/simple;
	bh=4CQ0E/MDGIIyFwOFRKSq8Gd6DvIjRLvEY3SEoA1gZDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQJ2t1R4a+SelSY71tjNWOSl7sABlqf3mbXyvu+VxoNBvr1ozDZV0DJoSE/C01ss/ZmajswKACWuyEQbMucouhPZcx+98I8/BL1XRQbXTj4t7RK6++XZmBla1SKjGo6ZvRHrOy8ndsiD0cXII2PLH9HmQ782JOKVjRGHwn5d69M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4XhU/9rC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4XhU/9rC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L+6ojMJfwCWhLFRB0GPni+uSlsd8H4EJEa7++qGwg4w=; b=4XhU/9rCyLY9fimUyUdKcmGMp5
	YF1YVjyokj6W9Q31s7V3S5N6iBkGZjQrkc02H8uylN5H/FLCjfOI7RElSw2i6AZR32AZ3ZCUJ4Xxx
	LFIUSTAuC8axWqfUb/mrMbqGpUG4TU5D5F2psW0P+siigIogzc1AmrneGYBf3UFtla3QQuTcSi1Mp
	QcRaTgo7zKYkvwiE/qoGqBAypjDJcgjvGxgJZEoP/GK7mQtldSwfdRsLwIwciBl+ozydv2FV8F0dG
	gjmUSWsyvnaDEa1ZYV8LfIMmIRQh0NPBwUrZg4UgxORw3L62aoFoZl6KL3Tc5h2f9qRfofWaY/5Ft
	N6Tc/fXg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Zt-00000006n7i-1XIT;
	Fri, 27 Mar 2026 06:21:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 19/28] x86: move the XOR code to lib/raid/
Date: Fri, 27 Mar 2026 07:16:51 +0100
Message-ID: <20260327061704.3707577-20-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327061704.3707577-1-hch@lst.de>
References: <20260327061704.3707577-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the optimized XOR code out of line into lib/raid.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/include/asm/xor.h                    | 518 ++----------------
 arch/x86/include/asm/xor_64.h                 |  32 --
 lib/raid/xor/Makefile                         |   2 +
 .../xor_avx.h => lib/raid/xor/x86/xor-avx.c   |  14 +-
 .../xor_32.h => lib/raid/xor/x86/xor-mmx.c    |  60 +-
 lib/raid/xor/x86/xor-sse.c                    | 476 ++++++++++++++++
 6 files changed, 522 insertions(+), 580 deletions(-)
 delete mode 100644 arch/x86/include/asm/xor_64.h
 rename arch/x86/include/asm/xor_avx.h => lib/raid/xor/x86/xor-avx.c (95%)
 rename arch/x86/include/asm/xor_32.h => lib/raid/xor/x86/xor-mmx.c (90%)
 create mode 100644 lib/raid/xor/x86/xor-sse.c

diff --git a/arch/x86/include/asm/xor.h b/arch/x86/include/asm/xor.h
index 33f5620d8d69..d1aab8275908 100644
--- a/arch/x86/include/asm/xor.h
+++ b/arch/x86/include/asm/xor.h
@@ -2,498 +2,42 @@
 #ifndef _ASM_X86_XOR_H
 #define _ASM_X86_XOR_H
 
-/*
- * Optimized RAID-5 checksumming functions for SSE.
- */
-
-/*
- * Cache avoiding checksumming functions utilizing KNI instructions
- * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
- */
+#include <asm/cpufeature.h>
+#include <asm-generic/xor.h>
 
-/*
- * Based on
- * High-speed RAID5 checksumming functions utilizing SSE instructions.
- * Copyright (C) 1998 Ingo Molnar.
- */
+extern struct xor_block_template xor_block_pII_mmx;
+extern struct xor_block_template xor_block_p5_mmx;
+extern struct xor_block_template xor_block_sse;
+extern struct xor_block_template xor_block_sse_pf64;
+extern struct xor_block_template xor_block_avx;
 
 /*
- * x86-64 changes / gcc fixes from Andi Kleen.
- * Copyright 2002 Andi Kleen, SuSE Labs.
+ * When SSE is available, use it as it can write around L2.  We may also be able
+ * to load into the L1 only depending on how the cpu deals with a load to a line
+ * that is being prefetched.
+ *
+ * When AVX2 is available, force using it as it is better by all measures.
  *
- * This hasn't been optimized for the hammer yet, but there are likely
- * no advantages to be gotten from x86-64 here anyways.
+ * 32-bit without MMX can fall back to the generic routines.
  */
-
-#include <asm/fpu/api.h>
-
-#ifdef CONFIG_X86_32
-/* reduce register pressure */
-# define XOR_CONSTANT_CONSTRAINT "i"
-#else
-# define XOR_CONSTANT_CONSTRAINT "re"
-#endif
-
-#define OFFS(x)		"16*("#x")"
-#define PF_OFFS(x)	"256+16*("#x")"
-#define PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
-#define LD(x, y)	"	movaps "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
-#define ST(x, y)	"	movaps %%xmm"#y", "OFFS(x)"(%[p1])	;\n"
-#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
-#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
-#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
-#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
-#define XO1(x, y)	"	xorps "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
-#define XO2(x, y)	"	xorps "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
-#define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
-#define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
-#define NOP(x)
-
-#define BLK64(pf, op, i)				\
-		pf(i)					\
-		op(i, 0)				\
-			op(i + 1, 1)			\
-				op(i + 2, 2)		\
-					op(i + 3, 3)
-
-static void
-xor_sse_2(unsigned long bytes, unsigned long * __restrict p1,
-	  const unsigned long * __restrict p2)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)					\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-		PF1(i)					\
-				PF1(i + 2)		\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_2_pf64(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)			\
-		BLK64(PF0, LD, i)	\
-		BLK64(PF1, XO1, i)	\
-		BLK64(NOP, ST, i)	\
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_3(unsigned long bytes, unsigned long * __restrict p1,
-	  const unsigned long * __restrict p2,
-	  const unsigned long * __restrict p3)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       add %[inc], %[p3]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	if (boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+		xor_force(&xor_block_avx);
+	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
+		xor_register(&xor_block_sse);
+		xor_register(&xor_block_sse_pf64);
+	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
+		xor_register(&xor_block_pII_mmx);
+		xor_register(&xor_block_p5_mmx);
+	} else {
+		xor_register(&xor_block_8regs);
+		xor_register(&xor_block_8regs_p);
+		xor_register(&xor_block_32regs);
+		xor_register(&xor_block_32regs_p);
+	}
 }
 
-static void
-xor_sse_3_pf64(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2,
-	       const unsigned long * __restrict p3)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)			\
-		BLK64(PF0, LD, i)	\
-		BLK64(PF1, XO1, i)	\
-		BLK64(PF2, XO2, i)	\
-		BLK64(NOP, ST, i)	\
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       add %[inc], %[p3]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_4(unsigned long bytes, unsigned long * __restrict p1,
-	  const unsigned long * __restrict p2,
-	  const unsigned long * __restrict p3,
-	  const unsigned long * __restrict p4)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       add %[inc], %[p3]       ;\n"
-	"       add %[inc], %[p4]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines), [p1] "+r" (p1),
-	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_4_pf64(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2,
-	       const unsigned long * __restrict p3,
-	       const unsigned long * __restrict p4)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)			\
-		BLK64(PF0, LD, i)	\
-		BLK64(PF1, XO1, i)	\
-		BLK64(PF2, XO2, i)	\
-		BLK64(PF3, XO3, i)	\
-		BLK64(NOP, ST, i)	\
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       add %[inc], %[p3]       ;\n"
-	"       add %[inc], %[p4]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines), [p1] "+r" (p1),
-	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_5(unsigned long bytes, unsigned long * __restrict p1,
-	  const unsigned long * __restrict p2,
-	  const unsigned long * __restrict p3,
-	  const unsigned long * __restrict p4,
-	  const unsigned long * __restrict p5)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		PF4(i)					\
-				PF4(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		XO4(i, 0)				\
-			XO4(i + 1, 1)			\
-				XO4(i + 2, 2)		\
-					XO4(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       add %[inc], %[p3]       ;\n"
-	"       add %[inc], %[p4]       ;\n"
-	"       add %[inc], %[p5]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
-	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_5_pf64(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2,
-	       const unsigned long * __restrict p3,
-	       const unsigned long * __restrict p4,
-	       const unsigned long * __restrict p5)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)			\
-		BLK64(PF0, LD, i)	\
-		BLK64(PF1, XO1, i)	\
-		BLK64(PF2, XO2, i)	\
-		BLK64(PF3, XO3, i)	\
-		BLK64(PF4, XO4, i)	\
-		BLK64(NOP, ST, i)	\
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       add %[inc], %[p1]       ;\n"
-	"       add %[inc], %[p2]       ;\n"
-	"       add %[inc], %[p3]       ;\n"
-	"       add %[inc], %[p4]       ;\n"
-	"       add %[inc], %[p5]       ;\n"
-	"       dec %[cnt]              ;\n"
-	"       jnz 1b                  ;\n"
-	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
-	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
-	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static struct xor_block_template xor_block_sse_pf64 = {
-	.name = "prefetch64-sse",
-	.do_2 = xor_sse_2_pf64,
-	.do_3 = xor_sse_3_pf64,
-	.do_4 = xor_sse_4_pf64,
-	.do_5 = xor_sse_5_pf64,
-};
-
-#undef LD
-#undef XO1
-#undef XO2
-#undef XO3
-#undef XO4
-#undef ST
-#undef NOP
-#undef BLK64
-#undef BLOCK
-
-#undef XOR_CONSTANT_CONSTRAINT
-
-#ifdef CONFIG_X86_32
-# include <asm/xor_32.h>
-#else
-# include <asm/xor_64.h>
-#endif
-
 #endif /* _ASM_X86_XOR_H */
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
deleted file mode 100644
index 2d2ceb241866..000000000000
--- a/arch/x86/include/asm/xor_64.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_X86_XOR_64_H
-#define _ASM_X86_XOR_64_H
-
-static struct xor_block_template xor_block_sse = {
-	.name = "generic_sse",
-	.do_2 = xor_sse_2,
-	.do_3 = xor_sse_3,
-	.do_4 = xor_sse_4,
-	.do_5 = xor_sse_5,
-};
-
-
-/* Also try the AVX routines */
-#include <asm/xor_avx.h>
-
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define arch_xor_init arch_xor_init
-static __always_inline void __init arch_xor_init(void)
-{
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
-		xor_force(&xor_block_avx);
-	} else {
-		xor_register(&xor_block_sse_pf64);
-		xor_register(&xor_block_sse);
-	}
-}
-
-#endif /* _ASM_X86_XOR_64_H */
diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 3db6c2b2f26a..05aca96041b3 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -21,6 +21,8 @@ xor-$(CONFIG_RISCV_ISA_V)	+= riscv/xor.o riscv/xor-glue.o
 xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
 xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
 xor-$(CONFIG_S390)		+= s390/xor.o
+xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
+xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o
 
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
diff --git a/arch/x86/include/asm/xor_avx.h b/lib/raid/xor/x86/xor-avx.c
similarity index 95%
rename from arch/x86/include/asm/xor_avx.h
rename to lib/raid/xor/x86/xor-avx.c
index c600888436bb..b49cb5199e70 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/lib/raid/xor/x86/xor-avx.c
@@ -1,18 +1,16 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _ASM_X86_XOR_AVX_H
-#define _ASM_X86_XOR_AVX_H
-
+// SPDX-License-Identifier: GPL-2.0-only
 /*
- * Optimized RAID-5 checksumming functions for AVX
+ * Optimized XOR parity functions for AVX
  *
  * Copyright (C) 2012 Intel Corporation
  * Author: Jim Kukunas <james.t.kukunas@linux.intel.com>
  *
  * Based on Ingo Molnar and Zach Brown's respective MMX and SSE routines
  */
-
 #include <linux/compiler.h>
+#include <linux/raid/xor_impl.h>
 #include <asm/fpu/api.h>
+#include <asm/xor.h>
 
 #define BLOCK4(i) \
 		BLOCK(32 * i, 0) \
@@ -158,12 +156,10 @@ do { \
 	kernel_fpu_end();
 }
 
-static struct xor_block_template xor_block_avx = {
+struct xor_block_template xor_block_avx = {
 	.name = "avx",
 	.do_2 = xor_avx_2,
 	.do_3 = xor_avx_3,
 	.do_4 = xor_avx_4,
 	.do_5 = xor_avx_5,
 };
-
-#endif
diff --git a/arch/x86/include/asm/xor_32.h b/lib/raid/xor/x86/xor-mmx.c
similarity index 90%
rename from arch/x86/include/asm/xor_32.h
rename to lib/raid/xor/x86/xor-mmx.c
index ee32d08c27bc..cf0fafea33b7 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/lib/raid/xor/x86/xor-mmx.c
@@ -1,15 +1,12 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef _ASM_X86_XOR_32_H
-#define _ASM_X86_XOR_32_H
-
-/*
- * Optimized RAID-5 checksumming functions for MMX.
- */
-
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * High-speed RAID5 checksumming functions utilizing MMX instructions.
+ * Optimized XOR parity functions for MMX.
+ *
  * Copyright (C) 1998 Ingo Molnar.
  */
+#include <linux/raid/xor_impl.h>
+#include <asm/fpu/api.h>
+#include <asm/xor.h>
 
 #define LD(x, y)	"       movq   8*("#x")(%1), %%mm"#y"   ;\n"
 #define ST(x, y)	"       movq %%mm"#y",   8*("#x")(%1)   ;\n"
@@ -18,8 +15,6 @@
 #define XO3(x, y)	"       pxor   8*("#x")(%4), %%mm"#y"   ;\n"
 #define XO4(x, y)	"       pxor   8*("#x")(%5), %%mm"#y"   ;\n"
 
-#include <asm/fpu/api.h>
-
 static void
 xor_pII_mmx_2(unsigned long bytes, unsigned long * __restrict p1,
 	      const unsigned long * __restrict p2)
@@ -519,7 +514,7 @@ xor_p5_mmx_5(unsigned long bytes, unsigned long * __restrict p1,
 	kernel_fpu_end();
 }
 
-static struct xor_block_template xor_block_pII_mmx = {
+struct xor_block_template xor_block_pII_mmx = {
 	.name = "pII_mmx",
 	.do_2 = xor_pII_mmx_2,
 	.do_3 = xor_pII_mmx_3,
@@ -527,49 +522,10 @@ static struct xor_block_template xor_block_pII_mmx = {
 	.do_5 = xor_pII_mmx_5,
 };
 
-static struct xor_block_template xor_block_p5_mmx = {
+struct xor_block_template xor_block_p5_mmx = {
 	.name = "p5_mmx",
 	.do_2 = xor_p5_mmx_2,
 	.do_3 = xor_p5_mmx_3,
 	.do_4 = xor_p5_mmx_4,
 	.do_5 = xor_p5_mmx_5,
 };
-
-static struct xor_block_template xor_block_pIII_sse = {
-	.name = "pIII_sse",
-	.do_2 = xor_sse_2,
-	.do_3 = xor_sse_3,
-	.do_4 = xor_sse_4,
-	.do_5 = xor_sse_5,
-};
-
-/* Also try the AVX routines */
-#include <asm/xor_avx.h>
-
-/* Also try the generic routines.  */
-#include <asm-generic/xor.h>
-
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define arch_xor_init arch_xor_init
-static __always_inline void __init arch_xor_init(void)
-{
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
-		xor_force(&xor_block_avx);
-	} else if (boot_cpu_has(X86_FEATURE_XMM)) {
-		xor_register(&xor_block_pIII_sse);
-		xor_register(&xor_block_sse_pf64);
-	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
-		xor_register(&xor_block_pII_mmx);
-		xor_register(&xor_block_p5_mmx);
-	} else {
-		xor_register(&xor_block_8regs);
-		xor_register(&xor_block_8regs_p);
-		xor_register(&xor_block_32regs);
-		xor_register(&xor_block_32regs_p);
-	}
-}
-
-#endif /* _ASM_X86_XOR_32_H */
diff --git a/lib/raid/xor/x86/xor-sse.c b/lib/raid/xor/x86/xor-sse.c
new file mode 100644
index 000000000000..0e727ced8b00
--- /dev/null
+++ b/lib/raid/xor/x86/xor-sse.c
@@ -0,0 +1,476 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Optimized XOR parity functions for SSE.
+ *
+ * Cache avoiding checksumming functions utilizing KNI instructions
+ * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
+ *
+ * Based on
+ * High-speed RAID5 checksumming functions utilizing SSE instructions.
+ * Copyright (C) 1998 Ingo Molnar.
+ *
+ * x86-64 changes / gcc fixes from Andi Kleen.
+ * Copyright 2002 Andi Kleen, SuSE Labs.
+ */
+#include <linux/raid/xor_impl.h>
+#include <asm/fpu/api.h>
+#include <asm/xor.h>
+
+#ifdef CONFIG_X86_32
+/* reduce register pressure */
+# define XOR_CONSTANT_CONSTRAINT "i"
+#else
+# define XOR_CONSTANT_CONSTRAINT "re"
+#endif
+
+#define OFFS(x)		"16*("#x")"
+#define PF_OFFS(x)	"256+16*("#x")"
+#define PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
+#define LD(x, y)	"	movaps "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
+#define ST(x, y)	"	movaps %%xmm"#y", "OFFS(x)"(%[p1])	;\n"
+#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
+#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
+#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
+#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
+#define XO1(x, y)	"	xorps "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
+#define XO2(x, y)	"	xorps "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
+#define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
+#define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
+#define NOP(x)
+
+#define BLK64(pf, op, i)				\
+		pf(i)					\
+		op(i, 0)				\
+			op(i + 1, 1)			\
+				op(i + 2, 2)		\
+					op(i + 3, 3)
+
+static void
+xor_sse_2(unsigned long bytes, unsigned long * __restrict p1,
+	  const unsigned long * __restrict p2)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)					\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+		PF1(i)					\
+				PF1(i + 2)		\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_2_pf64(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_3(unsigned long bytes, unsigned long * __restrict p1,
+	  const unsigned long * __restrict p2,
+	  const unsigned long * __restrict p3)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_3_pf64(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2,
+	       const unsigned long * __restrict p3)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_4(unsigned long bytes, unsigned long * __restrict p1,
+	  const unsigned long * __restrict p2,
+	  const unsigned long * __restrict p3,
+	  const unsigned long * __restrict p4)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1),
+	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_4_pf64(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2,
+	       const unsigned long * __restrict p3,
+	       const unsigned long * __restrict p4)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1),
+	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_5(unsigned long bytes, unsigned long * __restrict p1,
+	  const unsigned long * __restrict p2,
+	  const unsigned long * __restrict p3,
+	  const unsigned long * __restrict p4,
+	  const unsigned long * __restrict p5)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		PF4(i)					\
+				PF4(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		XO4(i, 0)				\
+			XO4(i + 1, 1)			\
+				XO4(i + 2, 2)		\
+					XO4(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       add %[inc], %[p5]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
+	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_5_pf64(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2,
+	       const unsigned long * __restrict p3,
+	       const unsigned long * __restrict p4,
+	       const unsigned long * __restrict p5)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(PF4, XO4, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       add %[inc], %[p5]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
+	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+struct xor_block_template xor_block_sse = {
+	.name = "sse",
+	.do_2 = xor_sse_2,
+	.do_3 = xor_sse_3,
+	.do_4 = xor_sse_4,
+	.do_5 = xor_sse_5,
+};
+
+struct xor_block_template xor_block_sse_pf64 = {
+	.name = "prefetch64-sse",
+	.do_2 = xor_sse_2_pf64,
+	.do_3 = xor_sse_3_pf64,
+	.do_4 = xor_sse_4_pf64,
+	.do_5 = xor_sse_5_pf64,
+};
-- 
2.47.3

