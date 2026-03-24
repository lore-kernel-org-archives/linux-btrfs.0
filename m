Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3F861FFE;
	Tue, 24 Mar 2026 06:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774333525; cv=none; b=V/X2HPlhH5vnUb4wBbtcmAgbj19aipeOeYoOIBhjfRtLmCM3V8WvGjF7GrPRHqNyWh+02zE+AzvH+u0Yaljf9xHN9Enl5tuGAvcZ9/yrvSAzHK7wrXdTxVgt7/Rr1SjWR8MKMBLd91hxgs58KP7hEDVPzxKw0mN4cn6n4DjMpH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774333525; c=relaxed/simple;
	bh=/HTOdZs8WE8YsSxEcjV/Hua2Yv3xcRbolGCvAxBVBFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqcck+qa6/IIOT9nBELvG557NPh6pQoiU56O0JZJonHQsr367aMMl0Vwd6Bi5Ylkll+z3n01hANkasPw8qe+3+1bwzQkP4glMl8ZO+ogV3aZ3vpoxLrkRgkKdvhusxeq+k7oOk1vUtKjM+mmQPBZRAqkdCvg6k4GjG9eIW1tiE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V/laOWlI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V/laOWlI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gjX5FBygeWMjPukwqXaKShwz3C1U1AWYRymWZAxycrE=; b=V/laOWlIFox7SOAsw7put/pupf
	ocCaNMiI2SmkhbkohPAdaeeAymEEkBbhxt6madJpdbOkfa4bhLFOqoi03lRhRidw5SoJQwWmC047d
	ubN8z9oOJLrtU51wjhP7VtNSCWVE/7C/0REScE1yQdmbGJpl0VUFkdBu941icuVQzrrhxVyemE+xG
	vtQbDe/mwJc6t7+ffbdgQARSdNaFqDV+3CCpZZbMfCfBPtI69q+qNq0TqLKL+XzTZH/FT1FmQ5y+Y
	WnvR5ras3fVtZOpISxh8PfhTk73l/Ttd6DhnITmMeG3wt6SBeiFpsjiwrktP3TThRDzd0qMoJcy7j
	kfUDP/4A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vCP-00000000i9X-1Xq5;
	Tue, 24 Mar 2026 06:25:09 +0000
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
Subject: [PATCH 13/26] loongarch: move the XOR code to lib/raid/
Date: Tue, 24 Mar 2026 07:21:49 +0100
Message-ID: <20260324062211.3216301-14-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324062211.3216301-1-hch@lst.de>
References: <20260324062211.3216301-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the optimized XOR into lib/raid and include it it in xor.ko
instead of always building it into the main kernel image.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/loongarch/include/asm/xor.h              | 24 ++----------
 arch/loongarch/include/asm/xor_simd.h         | 34 ----------------
 arch/loongarch/lib/Makefile                   |  2 -
 lib/raid/xor/Makefile                         |  2 +
 .../lib => lib/raid/xor/loongarch}/xor_simd.c |  0
 .../lib => lib/raid/xor/loongarch}/xor_simd.h |  0
 .../raid/xor/loongarch}/xor_simd_glue.c       | 39 +++++++++++--------
 .../raid/xor/loongarch}/xor_template.c        |  0
 8 files changed, 27 insertions(+), 74 deletions(-)
 delete mode 100644 arch/loongarch/include/asm/xor_simd.h
 rename {arch/loongarch/lib => lib/raid/xor/loongarch}/xor_simd.c (100%)
 rename {arch/loongarch/lib => lib/raid/xor/loongarch}/xor_simd.h (100%)
 rename {arch/loongarch/lib => lib/raid/xor/loongarch}/xor_simd_glue.c (64%)
 rename {arch/loongarch/lib => lib/raid/xor/loongarch}/xor_template.c (100%)

diff --git a/arch/loongarch/include/asm/xor.h b/arch/loongarch/include/asm/xor.h
index d17c0e3b047f..7e32f72f8b03 100644
--- a/arch/loongarch/include/asm/xor.h
+++ b/arch/loongarch/include/asm/xor.h
@@ -6,27 +6,6 @@
 #define _ASM_LOONGARCH_XOR_H
 
 #include <asm/cpu-features.h>
-#include <asm/xor_simd.h>
-
-#ifdef CONFIG_CPU_HAS_LSX
-static struct xor_block_template xor_block_lsx = {
-	.name = "lsx",
-	.do_2 = xor_lsx_2,
-	.do_3 = xor_lsx_3,
-	.do_4 = xor_lsx_4,
-	.do_5 = xor_lsx_5,
-};
-#endif /* CONFIG_CPU_HAS_LSX */
-
-#ifdef CONFIG_CPU_HAS_LASX
-static struct xor_block_template xor_block_lasx = {
-	.name = "lasx",
-	.do_2 = xor_lasx_2,
-	.do_3 = xor_lasx_3,
-	.do_4 = xor_lasx_4,
-	.do_5 = xor_lasx_5,
-};
-#endif /* CONFIG_CPU_HAS_LASX */
 
 /*
  * For grins, also test the generic routines.
@@ -38,6 +17,9 @@ static struct xor_block_template xor_block_lasx = {
  */
 #include <asm-generic/xor.h>
 
+extern struct xor_block_template xor_block_lsx;
+extern struct xor_block_template xor_block_lasx;
+
 #define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
diff --git a/arch/loongarch/include/asm/xor_simd.h b/arch/loongarch/include/asm/xor_simd.h
deleted file mode 100644
index 471b96332f38..000000000000
--- a/arch/loongarch/include/asm/xor_simd.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Copyright (C) 2023 WANG Xuerui <git@xen0n.name>
- */
-#ifndef _ASM_LOONGARCH_XOR_SIMD_H
-#define _ASM_LOONGARCH_XOR_SIMD_H
-
-#ifdef CONFIG_CPU_HAS_LSX
-void xor_lsx_2(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2);
-void xor_lsx_3(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2, const unsigned long * __restrict p3);
-void xor_lsx_4(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2, const unsigned long * __restrict p3,
-	       const unsigned long * __restrict p4);
-void xor_lsx_5(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2, const unsigned long * __restrict p3,
-	       const unsigned long * __restrict p4, const unsigned long * __restrict p5);
-#endif /* CONFIG_CPU_HAS_LSX */
-
-#ifdef CONFIG_CPU_HAS_LASX
-void xor_lasx_2(unsigned long bytes, unsigned long * __restrict p1,
-	        const unsigned long * __restrict p2);
-void xor_lasx_3(unsigned long bytes, unsigned long * __restrict p1,
-	        const unsigned long * __restrict p2, const unsigned long * __restrict p3);
-void xor_lasx_4(unsigned long bytes, unsigned long * __restrict p1,
-	        const unsigned long * __restrict p2, const unsigned long * __restrict p3,
-	        const unsigned long * __restrict p4);
-void xor_lasx_5(unsigned long bytes, unsigned long * __restrict p1,
-	        const unsigned long * __restrict p2, const unsigned long * __restrict p3,
-	        const unsigned long * __restrict p4, const unsigned long * __restrict p5);
-#endif /* CONFIG_CPU_HAS_LASX */
-
-#endif /* _ASM_LOONGARCH_XOR_SIMD_H */
diff --git a/arch/loongarch/lib/Makefile b/arch/loongarch/lib/Makefile
index ccea3bbd4353..827a88529a42 100644
--- a/arch/loongarch/lib/Makefile
+++ b/arch/loongarch/lib/Makefile
@@ -8,6 +8,4 @@ lib-y	+= delay.o memset.o memcpy.o memmove.o \
 
 obj-$(CONFIG_ARCH_SUPPORTS_INT128) += tishift.o
 
-obj-$(CONFIG_CPU_HAS_LSX) += xor_simd.o xor_simd_glue.o
-
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 4ab0e7411ff7..e8868f5fc396 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -14,6 +14,8 @@ ifeq ($(CONFIG_ARM),y)
 xor-$(CONFIG_KERNEL_MODE_NEON)	+= arm/xor-neon.o arm/xor-neon-glue.o
 endif
 xor-$(CONFIG_ARM64)		+= arm64/xor-neon.o arm64/xor-neon-glue.o
+xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd.o
+xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd_glue.o
 
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
diff --git a/arch/loongarch/lib/xor_simd.c b/lib/raid/xor/loongarch/xor_simd.c
similarity index 100%
rename from arch/loongarch/lib/xor_simd.c
rename to lib/raid/xor/loongarch/xor_simd.c
diff --git a/arch/loongarch/lib/xor_simd.h b/lib/raid/xor/loongarch/xor_simd.h
similarity index 100%
rename from arch/loongarch/lib/xor_simd.h
rename to lib/raid/xor/loongarch/xor_simd.h
diff --git a/arch/loongarch/lib/xor_simd_glue.c b/lib/raid/xor/loongarch/xor_simd_glue.c
similarity index 64%
rename from arch/loongarch/lib/xor_simd_glue.c
rename to lib/raid/xor/loongarch/xor_simd_glue.c
index 393f689dbcf6..11fa3b47ba83 100644
--- a/arch/loongarch/lib/xor_simd_glue.c
+++ b/lib/raid/xor/loongarch/xor_simd_glue.c
@@ -5,24 +5,23 @@
  * Copyright (C) 2023 WANG Xuerui <git@xen0n.name>
  */
 
-#include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/raid/xor_impl.h>
 #include <asm/fpu.h>
-#include <asm/xor_simd.h>
+#include <asm/xor.h>
 #include "xor_simd.h"
 
 #define MAKE_XOR_GLUE_2(flavor)							\
-void xor_##flavor##_2(unsigned long bytes, unsigned long * __restrict p1,	\
+static void xor_##flavor##_2(unsigned long bytes, unsigned long * __restrict p1,\
 		      const unsigned long * __restrict p2)			\
 {										\
 	kernel_fpu_begin();							\
 	__xor_##flavor##_2(bytes, p1, p2);					\
 	kernel_fpu_end();							\
 }										\
-EXPORT_SYMBOL_GPL(xor_##flavor##_2)
 
 #define MAKE_XOR_GLUE_3(flavor)							\
-void xor_##flavor##_3(unsigned long bytes, unsigned long * __restrict p1,	\
+static void xor_##flavor##_3(unsigned long bytes, unsigned long * __restrict p1,\
 		      const unsigned long * __restrict p2,			\
 		      const unsigned long * __restrict p3)			\
 {										\
@@ -30,10 +29,9 @@ void xor_##flavor##_3(unsigned long bytes, unsigned long * __restrict p1,	\
 	__xor_##flavor##_3(bytes, p1, p2, p3);					\
 	kernel_fpu_end();							\
 }										\
-EXPORT_SYMBOL_GPL(xor_##flavor##_3)
 
 #define MAKE_XOR_GLUE_4(flavor)							\
-void xor_##flavor##_4(unsigned long bytes, unsigned long * __restrict p1,	\
+static void xor_##flavor##_4(unsigned long bytes, unsigned long * __restrict p1,\
 		      const unsigned long * __restrict p2,			\
 		      const unsigned long * __restrict p3,			\
 		      const unsigned long * __restrict p4)			\
@@ -42,10 +40,9 @@ void xor_##flavor##_4(unsigned long bytes, unsigned long * __restrict p1,	\
 	__xor_##flavor##_4(bytes, p1, p2, p3, p4);				\
 	kernel_fpu_end();							\
 }										\
-EXPORT_SYMBOL_GPL(xor_##flavor##_4)
 
 #define MAKE_XOR_GLUE_5(flavor)							\
-void xor_##flavor##_5(unsigned long bytes, unsigned long * __restrict p1,	\
+static void xor_##flavor##_5(unsigned long bytes, unsigned long * __restrict p1,\
 		      const unsigned long * __restrict p2,			\
 		      const unsigned long * __restrict p3,			\
 		      const unsigned long * __restrict p4,			\
@@ -55,18 +52,26 @@ void xor_##flavor##_5(unsigned long bytes, unsigned long * __restrict p1,	\
 	__xor_##flavor##_5(bytes, p1, p2, p3, p4, p5);				\
 	kernel_fpu_end();							\
 }										\
-EXPORT_SYMBOL_GPL(xor_##flavor##_5)
 
-#define MAKE_XOR_GLUES(flavor)		\
-	MAKE_XOR_GLUE_2(flavor);	\
-	MAKE_XOR_GLUE_3(flavor);	\
-	MAKE_XOR_GLUE_4(flavor);	\
-	MAKE_XOR_GLUE_5(flavor)
+#define MAKE_XOR_GLUES(flavor)				\
+	MAKE_XOR_GLUE_2(flavor);			\
+	MAKE_XOR_GLUE_3(flavor);			\
+	MAKE_XOR_GLUE_4(flavor);			\
+	MAKE_XOR_GLUE_5(flavor);			\
+							\
+struct xor_block_template xor_block_##flavor = {	\
+	.name = __stringify(flavor),			\
+	.do_2 = xor_##flavor##_2,			\
+	.do_3 = xor_##flavor##_3,			\
+	.do_4 = xor_##flavor##_4,			\
+	.do_5 = xor_##flavor##_5,			\
+}
+
 
 #ifdef CONFIG_CPU_HAS_LSX
 MAKE_XOR_GLUES(lsx);
-#endif
+#endif /* CONFIG_CPU_HAS_LSX */
 
 #ifdef CONFIG_CPU_HAS_LASX
 MAKE_XOR_GLUES(lasx);
-#endif
+#endif /* CONFIG_CPU_HAS_LASX */
diff --git a/arch/loongarch/lib/xor_template.c b/lib/raid/xor/loongarch/xor_template.c
similarity index 100%
rename from arch/loongarch/lib/xor_template.c
rename to lib/raid/xor/loongarch/xor_template.c
-- 
2.47.3

