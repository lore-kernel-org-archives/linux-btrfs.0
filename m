Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214038B150;
	Wed, 11 Mar 2026 07:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212965; cv=none; b=tZgQXGbPQ0La9gVbnS0scKtwCarsVT4uHtgQt3cK4h9allbLlLtYqgG5CQnakhJ5aim0rSZPVxCVVWbtdcTh/cXs47VabimecRwsLWuszgvUhwgzUe1VE41V64f36qJIQsCZ9Wlw64Lde3Tl3c0h1UQENyZNq3NXCmjNAuSkhzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212965; c=relaxed/simple;
	bh=RxAF7+tN8BMhfFT6xSwBZFg3fxVjVemh29lGh/mshww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4xU5BPORBWglxCUsKGG8N+lJYFEASGmB+UAa8oYxAs3lqVsdp3nG8sdoNNpRM1vy/4dI3apR4TxAf5+Zk9yZyYZTH7njGhaTCyHfcb3B1qbsBT6W4eEd7aPD9LGJxxQlvAuka46Ay5sUjAOjpVIwZTeQBN4s2FtBRQQiJd0y80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T+jPrS3h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T+jPrS3h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I7HxBRGLlHgcS9t0hCIRTtjojLrzR9Us3UVKz6liQ6k=; b=T+jPrS3hnXVkunWjZEcQqDEXC8
	w797xO2WXkjlJwTgb7/uiwqlhV7gf1qWKcUkS8BGPcTsDLZCt6h4T85GhXzwWiUIqTorlpc3qTb4V
	zpR3BYfnoZX1FvgW72sq5yzSLg6cZqdOzYPAwlB+0hOn+4Crot3mVVc7XxGOe+TFufG7HCcawd8kL
	Nglu2LIZ+zR7jhEtYnoSiqoIspexOEfNDSuALLqelApBnuQ7bbG90qKRwLOiLgzyEmrJfmgNvwqGb
	Kwd4NYQj7phKj1tyPzwHimNxNQYyHAfRAQ4XFe7VQ3CAy2oliooWNCX/XX8VGrKJ6Wnvq7513htN9
	AUCs95tA==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Dgo-0000000B0i6-3C2P;
	Wed, 11 Mar 2026 07:09:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
Subject: [PATCH 20/27] xor: make xor.ko self-contained in lib/raid/
Date: Wed, 11 Mar 2026 08:03:52 +0100
Message-ID: <20260311070416.972667-21-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311070416.972667-1-hch@lst.de>
References: <20260311070416.972667-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the asm/xor.h headers to lib/raid/xor/$(SRCARCH)/xor_arch.h and
include/linux/raid/xor_impl.h to lib/raid/xor/xor_impl.h so that the
xor.ko module implementation is self-contained in lib/raid/.

As this remove the asm-generic mechanism a new kconfig symbol is
added to indicate that a architecture-specific implementations
exists, and xor_arch.h should be included.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/alpha/Kconfig                             |  1 +
 arch/arm/Kconfig                               |  1 +
 arch/arm64/Kconfig                             |  1 +
 arch/loongarch/Kconfig                         |  1 +
 arch/powerpc/Kconfig                           |  1 +
 arch/riscv/Kconfig                             |  1 +
 arch/s390/Kconfig                              |  1 +
 arch/sparc/Kconfig                             |  1 +
 arch/um/Kconfig                                |  1 +
 arch/um/include/asm/xor.h                      |  8 --------
 arch/x86/Kconfig                               |  1 +
 include/asm-generic/Kbuild                     |  1 -
 include/asm-generic/xor.h                      | 11 -----------
 lib/raid/Kconfig                               |  4 ++++
 lib/raid/xor/Makefile                          |  6 ++++++
 lib/raid/xor/alpha/xor.c                       |  4 ++--
 .../asm/xor.h => lib/raid/xor/alpha/xor_arch.h |  2 --
 lib/raid/xor/arm/xor-neon-glue.c               |  4 ++--
 lib/raid/xor/arm/xor-neon.c                    |  2 +-
 lib/raid/xor/arm/xor.c                         |  4 ++--
 .../asm/xor.h => lib/raid/xor/arm/xor_arch.h   |  2 --
 lib/raid/xor/arm64/xor-neon-glue.c             |  4 ++--
 lib/raid/xor/arm64/xor-neon.c                  |  4 ++--
 .../asm/xor.h => lib/raid/xor/arm64/xor_arch.h |  3 ---
 .../xor.h => lib/raid/xor/loongarch/xor_arch.h |  7 -------
 lib/raid/xor/loongarch/xor_simd_glue.c         |  4 ++--
 .../xor.h => lib/raid/xor/powerpc/xor_arch.h   |  7 -------
 lib/raid/xor/powerpc/xor_vmx_glue.c            |  4 ++--
 lib/raid/xor/riscv/xor-glue.c                  |  4 ++--
 .../asm/xor.h => lib/raid/xor/riscv/xor_arch.h |  2 --
 lib/raid/xor/s390/xor.c                        |  4 ++--
 .../asm/xor.h => lib/raid/xor/s390/xor_arch.h  |  6 ------
 lib/raid/xor/sparc/xor-sparc32.c               |  4 ++--
 lib/raid/xor/sparc/xor-sparc64-glue.c          |  4 ++--
 .../asm/xor.h => lib/raid/xor/sparc/xor_arch.h |  9 ---------
 lib/raid/xor/um/xor_arch.h                     |  2 ++
 lib/raid/xor/x86/xor-avx.c                     |  4 ++--
 lib/raid/xor/x86/xor-mmx.c                     |  4 ++--
 lib/raid/xor/x86/xor-sse.c                     |  4 ++--
 .../asm/xor.h => lib/raid/xor/x86/xor_arch.h   |  7 -------
 lib/raid/xor/xor-32regs-prefetch.c             |  3 +--
 lib/raid/xor/xor-32regs.c                      |  3 +--
 lib/raid/xor/xor-8regs-prefetch.c              |  3 +--
 lib/raid/xor/xor-8regs.c                       |  3 +--
 lib/raid/xor/xor-core.c                        | 18 +++++++++++-------
 .../linux/raid => lib/raid/xor}/xor_impl.h     |  6 ++++++
 46 files changed, 72 insertions(+), 109 deletions(-)
 delete mode 100644 arch/um/include/asm/xor.h
 delete mode 100644 include/asm-generic/xor.h
 rename arch/alpha/include/asm/xor.h => lib/raid/xor/alpha/xor_arch.h (90%)
 rename arch/arm/include/asm/xor.h => lib/raid/xor/arm/xor_arch.h (87%)
 rename arch/arm64/include/asm/xor.h => lib/raid/xor/arm64/xor_arch.h (89%)
 rename arch/loongarch/include/asm/xor.h => lib/raid/xor/loongarch/xor_arch.h (85%)
 rename arch/powerpc/include/asm/xor.h => lib/raid/xor/powerpc/xor_arch.h (77%)
 rename arch/riscv/include/asm/xor.h => lib/raid/xor/riscv/xor_arch.h (84%)
 rename arch/s390/include/asm/xor.h => lib/raid/xor/s390/xor_arch.h (71%)
 rename arch/sparc/include/asm/xor.h => lib/raid/xor/sparc/xor_arch.h (81%)
 create mode 100644 lib/raid/xor/um/xor_arch.h
 rename arch/x86/include/asm/xor.h => lib/raid/xor/x86/xor_arch.h (89%)
 rename {include/linux/raid => lib/raid/xor}/xor_impl.h (80%)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 6c7dbf0adad6..8b9d7005bcd5 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -40,6 +40,7 @@ config ALPHA
 	select MMU_GATHER_NO_RANGE
 	select MMU_GATHER_RCU_TABLE_FREE
 	select SPARSEMEM_EXTREME if SPARSEMEM
+	select XOR_BLOCKS_ARCH
 	select ZONE_DMA
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ec33376f8e2b..92917231789d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -159,6 +159,7 @@ config ARM
 	select HAVE_ARCH_VMAP_STACK if MMU && ARM_HAS_GROUP_RELOCS
 	select TRACE_IRQFLAGS_SUPPORT if !CPU_V7M
 	select USE_OF if !(ARCH_FOOTBRIDGE || ARCH_RPC || ARCH_SA1100)
+	select XOR_BLOCKS_ARCH
 	# Above selects are sorted alphabetically; please add new ones
 	# according to that.  Thanks.
 	help
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..0ee65af90085 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -285,6 +285,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select VMAP_STACK
+	select XOR_BLOCKS_ARCH
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d211c6572b0a..f262583b07a4 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -215,6 +215,7 @@ config LOONGARCH
 	select USE_PERCPU_NUMA_NODE_ID
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
+	select XOR_BLOCKS_ARCH
 	select ZONE_DMA32
 
 config 32BIT
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ad7a2fe63a2a..c28776660246 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -328,6 +328,7 @@ config PPC
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
 	select VDSO_GETRANDOM
+	select XOR_BLOCKS_ARCH
 	#
 	# Please keep this list sorted alphabetically.
 	#
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 90c531e6abf5..03ac092adb41 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -227,6 +227,7 @@ config RISCV
 	select UACCESS_MEMCPY if !MMU
 	select VDSO_GETRANDOM if HAVE_GENERIC_VDSO && 64BIT
 	select USER_STACKTRACE_SUPPORT
+	select XOR_BLOCKS_ARCH
 	select ZONE_DMA32 if 64BIT
 
 config RUSTC_SUPPORTS_RISCV
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index edc927d9e85a..163df316ee0e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -287,6 +287,7 @@ config S390
 	select VDSO_GETRANDOM
 	select VIRT_CPU_ACCOUNTING
 	select VMAP_STACK
+	select XOR_BLOCKS_ARCH
 	select ZONE_DMA
 	# Note: keep the above list sorted alphabetically
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 8699be91fca9..fbdc88910de1 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -50,6 +50,7 @@ config SPARC
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
 	select TRACE_IRQFLAGS_SUPPORT
+	select XOR_BLOCKS_ARCH
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 098cda44db22..77f752fc72d5 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -43,6 +43,7 @@ config UML
 	select THREAD_INFO_IN_TASK
 	select SPARSE_IRQ
 	select MMU_GATHER_RCU_TABLE_FREE
+	select XOR_BLOCKS_ARCH
 
 config MMU
 	bool
diff --git a/arch/um/include/asm/xor.h b/arch/um/include/asm/xor.h
deleted file mode 100644
index 99e5c7e1f475..000000000000
--- a/arch/um/include/asm/xor.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_UM_XOR_H
-#define _ASM_UM_XOR_H
-
-#include <asm/cpufeature.h>
-#include <../../x86/include/asm/xor.h>
-
-#endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..19783304e34c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -336,6 +336,7 @@ config X86
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
 	select ARCH_SUPPORTS_SCHED_MC		if SMP
 	select HAVE_SINGLE_FTRACE_DIRECT_OPS	if X86_64 && DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+	select XOR_BLOCKS_ARCH
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 9aff61e7b8f2..2c53a1e0b760 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -65,4 +65,3 @@ mandatory-y += vermagic.h
 mandatory-y += vga.h
 mandatory-y += video.h
 mandatory-y += word-at-a-time.h
-mandatory-y += xor.h
diff --git a/include/asm-generic/xor.h b/include/asm-generic/xor.h
deleted file mode 100644
index fc151fdc45ab..000000000000
--- a/include/asm-generic/xor.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * include/asm-generic/xor.h
- *
- * Generic optimized RAID-5 checksumming functions.
- */
-
-extern struct xor_block_template xor_block_8regs;
-extern struct xor_block_template xor_block_32regs;
-extern struct xor_block_template xor_block_8regs_p;
-extern struct xor_block_template xor_block_32regs_p;
diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
index 01b73a1c303f..4359971ebd04 100644
--- a/lib/raid/Kconfig
+++ b/lib/raid/Kconfig
@@ -2,3 +2,7 @@
 
 config XOR_BLOCKS
 	tristate
+
+# selected by architectures that provide an optimized XOR implementation
+config XOR_BLOCKS_ARCH
+	bool
diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 9358d8503080..7b748ddda9d4 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+ccflags-y			+= -I $(src)
+
 obj-$(CONFIG_XOR_BLOCKS)	+= xor.o
 
 xor-y				+= xor-core.o
@@ -8,6 +10,10 @@ xor-y				+= xor-32regs.o
 xor-y				+= xor-8regs-prefetch.o
 xor-y				+= xor-32regs-prefetch.o
 
+ifeq ($(CONFIG_XOR_BLOCKS_ARCH),y)
+CFLAGS_xor-core.o		+= -I$(src)/$(SRCARCH)
+endif
+
 xor-$(CONFIG_ALPHA)		+= alpha/xor.o
 xor-$(CONFIG_ARM)		+= arm/xor.o
 ifeq ($(CONFIG_ARM),y)
diff --git a/lib/raid/xor/alpha/xor.c b/lib/raid/xor/alpha/xor.c
index 0964ac420604..90694cc47395 100644
--- a/lib/raid/xor/alpha/xor.c
+++ b/lib/raid/xor/alpha/xor.c
@@ -2,8 +2,8 @@
 /*
  * Optimized XOR parity functions for alpha EV5 and EV6
  */
-#include <linux/raid/xor_impl.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 extern void
 xor_alpha_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/arch/alpha/include/asm/xor.h b/lib/raid/xor/alpha/xor_arch.h
similarity index 90%
rename from arch/alpha/include/asm/xor.h
rename to lib/raid/xor/alpha/xor_arch.h
index e517be577a09..0dcfea578a48 100644
--- a/arch/alpha/include/asm/xor.h
+++ b/lib/raid/xor/alpha/xor_arch.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 
 #include <asm/special_insns.h>
-#include <asm-generic/xor.h>
 
 extern struct xor_block_template xor_block_alpha;
 extern struct xor_block_template xor_block_alpha_prefetch;
@@ -10,7 +9,6 @@ extern struct xor_block_template xor_block_alpha_prefetch;
  * Force the use of alpha_prefetch if EV6, as it is significantly faster in the
  * cold cache case.
  */
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	if (implver() == IMPLVER_EV6) {
diff --git a/lib/raid/xor/arm/xor-neon-glue.c b/lib/raid/xor/arm/xor-neon-glue.c
index c7b162b383a2..7afd6294464b 100644
--- a/lib/raid/xor/arm/xor-neon-glue.c
+++ b/lib/raid/xor/arm/xor-neon-glue.c
@@ -2,8 +2,8 @@
 /*
  *  Copyright (C) 2001 Russell King
  */
-#include <linux/raid/xor_impl.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 extern struct xor_block_template const xor_block_neon_inner;
 
diff --git a/lib/raid/xor/arm/xor-neon.c b/lib/raid/xor/arm/xor-neon.c
index c9d4378b0f0e..806a42c5952c 100644
--- a/lib/raid/xor/arm/xor-neon.c
+++ b/lib/raid/xor/arm/xor-neon.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
-#include <linux/raid/xor_impl.h>
+#include "xor_impl.h"
 
 #ifndef __ARM_NEON__
 #error You should compile this file with '-march=armv7-a -mfloat-abi=softfp -mfpu=neon'
diff --git a/lib/raid/xor/arm/xor.c b/lib/raid/xor/arm/xor.c
index 2263341dbbcd..5bd5f048bbe9 100644
--- a/lib/raid/xor/arm/xor.c
+++ b/lib/raid/xor/arm/xor.c
@@ -2,8 +2,8 @@
 /*
  *  Copyright (C) 2001 Russell King
  */
-#include <linux/raid/xor_impl.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 #define __XOR(a1, a2) a1 ^= a2
 
diff --git a/arch/arm/include/asm/xor.h b/lib/raid/xor/arm/xor_arch.h
similarity index 87%
rename from arch/arm/include/asm/xor.h
rename to lib/raid/xor/arm/xor_arch.h
index 989c55872ef6..5a7eedb48fbb 100644
--- a/arch/arm/include/asm/xor.h
+++ b/lib/raid/xor/arm/xor_arch.h
@@ -2,13 +2,11 @@
 /*
  *  Copyright (C) 2001 Russell King
  */
-#include <asm-generic/xor.h>
 #include <asm/neon.h>
 
 extern struct xor_block_template xor_block_arm4regs;
 extern struct xor_block_template xor_block_neon;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	xor_register(&xor_block_arm4regs);
diff --git a/lib/raid/xor/arm64/xor-neon-glue.c b/lib/raid/xor/arm64/xor-neon-glue.c
index 08c3e3573388..3db0a318cf5b 100644
--- a/lib/raid/xor/arm64/xor-neon-glue.c
+++ b/lib/raid/xor/arm64/xor-neon-glue.c
@@ -4,9 +4,9 @@
  * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
  */
 
-#include <linux/raid/xor_impl.h>
 #include <asm/simd.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 #include "xor-neon.h"
 
 #define XOR_TEMPLATE(_name)						\
diff --git a/lib/raid/xor/arm64/xor-neon.c b/lib/raid/xor/arm64/xor-neon.c
index 61194c292917..61f00c4fee49 100644
--- a/lib/raid/xor/arm64/xor-neon.c
+++ b/lib/raid/xor/arm64/xor-neon.c
@@ -4,10 +4,10 @@
  * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
  */
 
-#include <linux/raid/xor_impl.h>
 #include <linux/cache.h>
 #include <asm/neon-intrinsics.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 #include "xor-neon.h"
 
 void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/arch/arm64/include/asm/xor.h b/lib/raid/xor/arm64/xor_arch.h
similarity index 89%
rename from arch/arm64/include/asm/xor.h
rename to lib/raid/xor/arm64/xor_arch.h
index 4782c760bcac..5dbb40319501 100644
--- a/arch/arm64/include/asm/xor.h
+++ b/lib/raid/xor/arm64/xor_arch.h
@@ -3,14 +3,11 @@
  * Authors: Jackie Liu <liuyun01@kylinos.cn>
  * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
  */
-
-#include <asm-generic/xor.h>
 #include <asm/simd.h>
 
 extern struct xor_block_template xor_block_neon;
 extern struct xor_block_template xor_block_eor3;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	xor_register(&xor_block_8regs);
diff --git a/arch/loongarch/include/asm/xor.h b/lib/raid/xor/loongarch/xor_arch.h
similarity index 85%
rename from arch/loongarch/include/asm/xor.h
rename to lib/raid/xor/loongarch/xor_arch.h
index 7e32f72f8b03..fe5e8244fd0e 100644
--- a/arch/loongarch/include/asm/xor.h
+++ b/lib/raid/xor/loongarch/xor_arch.h
@@ -2,9 +2,6 @@
 /*
  * Copyright (C) 2023 WANG Xuerui <git@xen0n.name>
  */
-#ifndef _ASM_LOONGARCH_XOR_H
-#define _ASM_LOONGARCH_XOR_H
-
 #include <asm/cpu-features.h>
 
 /*
@@ -15,12 +12,10 @@
  * the scalar ones, maybe for errata or micro-op reasons. It may be
  * appropriate to revisit this after one or two more uarch generations.
  */
-#include <asm-generic/xor.h>
 
 extern struct xor_block_template xor_block_lsx;
 extern struct xor_block_template xor_block_lasx;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	xor_register(&xor_block_8regs);
@@ -36,5 +31,3 @@ static __always_inline void __init arch_xor_init(void)
 		xor_register(&xor_block_lasx);
 #endif
 }
-
-#endif /* _ASM_LOONGARCH_XOR_H */
diff --git a/lib/raid/xor/loongarch/xor_simd_glue.c b/lib/raid/xor/loongarch/xor_simd_glue.c
index 11fa3b47ba83..b387aa0213b4 100644
--- a/lib/raid/xor/loongarch/xor_simd_glue.c
+++ b/lib/raid/xor/loongarch/xor_simd_glue.c
@@ -6,9 +6,9 @@
  */
 
 #include <linux/sched.h>
-#include <linux/raid/xor_impl.h>
 #include <asm/fpu.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 #include "xor_simd.h"
 
 #define MAKE_XOR_GLUE_2(flavor)							\
diff --git a/arch/powerpc/include/asm/xor.h b/lib/raid/xor/powerpc/xor_arch.h
similarity index 77%
rename from arch/powerpc/include/asm/xor.h
rename to lib/raid/xor/powerpc/xor_arch.h
index 3293ac87181c..3b00a4a2fd67 100644
--- a/arch/powerpc/include/asm/xor.h
+++ b/lib/raid/xor/powerpc/xor_arch.h
@@ -5,15 +5,10 @@
  *
  * Author: Anton Blanchard <anton@au.ibm.com>
  */
-#ifndef _ASM_POWERPC_XOR_H
-#define _ASM_POWERPC_XOR_H
-
 #include <asm/cpu_has_feature.h>
-#include <asm-generic/xor.h>
 
 extern struct xor_block_template xor_block_altivec;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	xor_register(&xor_block_8regs);
@@ -25,5 +20,3 @@ static __always_inline void __init arch_xor_init(void)
 		xor_register(&xor_block_altivec);
 #endif
 }
-
-#endif /* _ASM_POWERPC_XOR_H */
diff --git a/lib/raid/xor/powerpc/xor_vmx_glue.c b/lib/raid/xor/powerpc/xor_vmx_glue.c
index c41e38340700..56e99ddfb64f 100644
--- a/lib/raid/xor/powerpc/xor_vmx_glue.c
+++ b/lib/raid/xor/powerpc/xor_vmx_glue.c
@@ -7,9 +7,9 @@
 
 #include <linux/preempt.h>
 #include <linux/sched.h>
-#include <linux/raid/xor_impl.h>
 #include <asm/switch_to.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 #include "xor_vmx.h"
 
 static void xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/lib/raid/xor/riscv/xor-glue.c b/lib/raid/xor/riscv/xor-glue.c
index 11666a4b6b68..060e5f22ebcc 100644
--- a/lib/raid/xor/riscv/xor-glue.c
+++ b/lib/raid/xor/riscv/xor-glue.c
@@ -3,11 +3,11 @@
  * Copyright (C) 2021 SiFive
  */
 
-#include <linux/raid/xor_impl.h>
 #include <asm/vector.h>
 #include <asm/switch_to.h>
 #include <asm/asm-prototypes.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 static void xor_vector_2(unsigned long bytes, unsigned long *__restrict p1,
 			 const unsigned long *__restrict p2)
diff --git a/arch/riscv/include/asm/xor.h b/lib/raid/xor/riscv/xor_arch.h
similarity index 84%
rename from arch/riscv/include/asm/xor.h
rename to lib/raid/xor/riscv/xor_arch.h
index 614d9209d078..9240857d760b 100644
--- a/arch/riscv/include/asm/xor.h
+++ b/lib/raid/xor/riscv/xor_arch.h
@@ -3,11 +3,9 @@
  * Copyright (C) 2021 SiFive
  */
 #include <asm/vector.h>
-#include <asm-generic/xor.h>
 
 extern struct xor_block_template xor_block_rvv;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	xor_register(&xor_block_8regs);
diff --git a/lib/raid/xor/s390/xor.c b/lib/raid/xor/s390/xor.c
index acbd268adfc8..c28cb56fec92 100644
--- a/lib/raid/xor/s390/xor.c
+++ b/lib/raid/xor/s390/xor.c
@@ -7,8 +7,8 @@
  */
 
 #include <linux/types.h>
-#include <linux/raid/xor_impl.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 static void xor_xc_2(unsigned long bytes, unsigned long * __restrict p1,
 		     const unsigned long * __restrict p2)
diff --git a/arch/s390/include/asm/xor.h b/lib/raid/xor/s390/xor_arch.h
similarity index 71%
rename from arch/s390/include/asm/xor.h
rename to lib/raid/xor/s390/xor_arch.h
index 4e2233f64da9..4a233ed2b97a 100644
--- a/arch/s390/include/asm/xor.h
+++ b/lib/raid/xor/s390/xor_arch.h
@@ -5,15 +5,9 @@
  * Copyright IBM Corp. 2016
  * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
  */
-#ifndef _ASM_S390_XOR_H
-#define _ASM_S390_XOR_H
-
 extern struct xor_block_template xor_block_xc;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	xor_force(&xor_block_xc);
 }
-
-#endif /* _ASM_S390_XOR_H */
diff --git a/lib/raid/xor/sparc/xor-sparc32.c b/lib/raid/xor/sparc/xor-sparc32.c
index b65a75a6e59d..307c4a84f535 100644
--- a/lib/raid/xor/sparc/xor-sparc32.c
+++ b/lib/raid/xor/sparc/xor-sparc32.c
@@ -5,8 +5,8 @@
  *
  * Copyright (C) 1999 Jakub Jelinek (jj@ultra.linux.cz)
  */
-#include <linux/raid/xor_impl.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 static void
 sparc_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/lib/raid/xor/sparc/xor-sparc64-glue.c b/lib/raid/xor/sparc/xor-sparc64-glue.c
index 3c67c8c3a0e8..5f90c2460b54 100644
--- a/lib/raid/xor/sparc/xor-sparc64-glue.c
+++ b/lib/raid/xor/sparc/xor-sparc64-glue.c
@@ -8,8 +8,8 @@
  * Copyright (C) 2006 David S. Miller <davem@davemloft.net>
  */
 
-#include <linux/raid/xor_impl.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 void xor_vis_2(unsigned long bytes, unsigned long * __restrict p1,
 	       const unsigned long * __restrict p2);
diff --git a/arch/sparc/include/asm/xor.h b/lib/raid/xor/sparc/xor_arch.h
similarity index 81%
rename from arch/sparc/include/asm/xor.h
rename to lib/raid/xor/sparc/xor_arch.h
index f923b009fc24..af288abe4e91 100644
--- a/arch/sparc/include/asm/xor.h
+++ b/lib/raid/xor/sparc/xor_arch.h
@@ -3,16 +3,12 @@
  * Copyright (C) 1997, 1999 Jakub Jelinek (jj@ultra.linux.cz)
  * Copyright (C) 2006 David S. Miller <davem@davemloft.net>
  */
-#ifndef ___ASM_SPARC_XOR_H
-#define ___ASM_SPARC_XOR_H
-
 #if defined(__sparc__) && defined(__arch64__)
 #include <asm/spitfire.h>
 
 extern struct xor_block_template xor_block_VIS;
 extern struct xor_block_template xor_block_niagara;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	/* Force VIS for everything except Niagara.  */
@@ -28,12 +24,8 @@ static __always_inline void __init arch_xor_init(void)
 }
 #else /* sparc64 */
 
-/* For grins, also test the generic routines.  */
-#include <asm-generic/xor.h>
-
 extern struct xor_block_template xor_block_SPARC;
 
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	xor_register(&xor_block_8regs);
@@ -41,4 +33,3 @@ static __always_inline void __init arch_xor_init(void)
 	xor_register(&xor_block_SPARC);
 }
 #endif /* !sparc64 */
-#endif /* ___ASM_SPARC_XOR_H */
diff --git a/lib/raid/xor/um/xor_arch.h b/lib/raid/xor/um/xor_arch.h
new file mode 100644
index 000000000000..a33e57a26c5e
--- /dev/null
+++ b/lib/raid/xor/um/xor_arch.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <../x86/xor_arch.h>
diff --git a/lib/raid/xor/x86/xor-avx.c b/lib/raid/xor/x86/xor-avx.c
index b49cb5199e70..d411efa1ff43 100644
--- a/lib/raid/xor/x86/xor-avx.c
+++ b/lib/raid/xor/x86/xor-avx.c
@@ -8,9 +8,9 @@
  * Based on Ingo Molnar and Zach Brown's respective MMX and SSE routines
  */
 #include <linux/compiler.h>
-#include <linux/raid/xor_impl.h>
 #include <asm/fpu/api.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 #define BLOCK4(i) \
 		BLOCK(32 * i, 0) \
diff --git a/lib/raid/xor/x86/xor-mmx.c b/lib/raid/xor/x86/xor-mmx.c
index cf0fafea33b7..e48c58f92874 100644
--- a/lib/raid/xor/x86/xor-mmx.c
+++ b/lib/raid/xor/x86/xor-mmx.c
@@ -4,9 +4,9 @@
  *
  * Copyright (C) 1998 Ingo Molnar.
  */
-#include <linux/raid/xor_impl.h>
 #include <asm/fpu/api.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 #define LD(x, y)	"       movq   8*("#x")(%1), %%mm"#y"   ;\n"
 #define ST(x, y)	"       movq %%mm"#y",   8*("#x")(%1)   ;\n"
diff --git a/lib/raid/xor/x86/xor-sse.c b/lib/raid/xor/x86/xor-sse.c
index 0e727ced8b00..5993ed688c15 100644
--- a/lib/raid/xor/x86/xor-sse.c
+++ b/lib/raid/xor/x86/xor-sse.c
@@ -12,9 +12,9 @@
  * x86-64 changes / gcc fixes from Andi Kleen.
  * Copyright 2002 Andi Kleen, SuSE Labs.
  */
-#include <linux/raid/xor_impl.h>
 #include <asm/fpu/api.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
 
 #ifdef CONFIG_X86_32
 /* reduce register pressure */
diff --git a/arch/x86/include/asm/xor.h b/lib/raid/xor/x86/xor_arch.h
similarity index 89%
rename from arch/x86/include/asm/xor.h
rename to lib/raid/xor/x86/xor_arch.h
index d1aab8275908..99fe85a213c6 100644
--- a/arch/x86/include/asm/xor.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef _ASM_X86_XOR_H
-#define _ASM_X86_XOR_H
-
 #include <asm/cpufeature.h>
-#include <asm-generic/xor.h>
 
 extern struct xor_block_template xor_block_pII_mmx;
 extern struct xor_block_template xor_block_p5_mmx;
@@ -20,7 +16,6 @@ extern struct xor_block_template xor_block_avx;
  *
  * 32-bit without MMX can fall back to the generic routines.
  */
-#define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
@@ -39,5 +34,3 @@ static __always_inline void __init arch_xor_init(void)
 		xor_register(&xor_block_32regs_p);
 	}
 }
-
-#endif /* _ASM_X86_XOR_H */
diff --git a/lib/raid/xor/xor-32regs-prefetch.c b/lib/raid/xor/xor-32regs-prefetch.c
index 8666c287f777..2856a8e50cb8 100644
--- a/lib/raid/xor/xor-32regs-prefetch.c
+++ b/lib/raid/xor/xor-32regs-prefetch.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <linux/prefetch.h>
-#include <linux/raid/xor_impl.h>
-#include <asm-generic/xor.h>
+#include "xor_impl.h"
 
 static void
 xor_32regs_p_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/lib/raid/xor/xor-32regs.c b/lib/raid/xor/xor-32regs.c
index 58d4fac43eb4..cc44d64032fa 100644
--- a/lib/raid/xor/xor-32regs.c
+++ b/lib/raid/xor/xor-32regs.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-#include <linux/raid/xor_impl.h>
-#include <asm-generic/xor.h>
+#include "xor_impl.h"
 
 static void
 xor_32regs_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/lib/raid/xor/xor-8regs-prefetch.c b/lib/raid/xor/xor-8regs-prefetch.c
index 67061e35a0a6..1d53aec50d27 100644
--- a/lib/raid/xor/xor-8regs-prefetch.c
+++ b/lib/raid/xor/xor-8regs-prefetch.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <linux/prefetch.h>
-#include <linux/raid/xor_impl.h>
-#include <asm-generic/xor.h>
+#include "xor_impl.h"
 
 static void
 xor_8regs_p_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/lib/raid/xor/xor-8regs.c b/lib/raid/xor/xor-8regs.c
index 769f796ab2cf..72a44e898c55 100644
--- a/lib/raid/xor/xor-8regs.c
+++ b/lib/raid/xor/xor-8regs.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-#include <linux/raid/xor_impl.h>
-#include <asm-generic/xor.h>
+#include "xor_impl.h"
 
 static void
 xor_8regs_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index 01a42995b7a5..47e09ae954b2 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -9,10 +9,9 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/raid/xor.h>
-#include <linux/raid/xor_impl.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
-#include <asm/xor.h>
+#include "xor_impl.h"
 
 /* The xor routines to use.  */
 static struct xor_block_template *active_template;
@@ -141,16 +140,21 @@ static int __init calibrate_xor_blocks(void)
 	return 0;
 }
 
-static int __init xor_init(void)
-{
-#ifdef arch_xor_init
-	arch_xor_init();
+#ifdef CONFIG_XOR_BLOCKS_ARCH
+#include "xor_arch.h" /* $SRCARCH/xor_arch.h */
 #else
+static void __init arch_xor_init(void)
+{
 	xor_register(&xor_block_8regs);
 	xor_register(&xor_block_8regs_p);
 	xor_register(&xor_block_32regs);
 	xor_register(&xor_block_32regs_p);
-#endif
+}
+#endif /* CONFIG_XOR_BLOCKS_ARCH */
+
+static int __init xor_init(void)
+{
+	arch_xor_init();
 
 	/*
 	 * If this arch/cpu has a short-circuited selection, don't loop through
diff --git a/include/linux/raid/xor_impl.h b/lib/raid/xor/xor_impl.h
similarity index 80%
rename from include/linux/raid/xor_impl.h
rename to lib/raid/xor/xor_impl.h
index 6ed4c445ab24..44b6c99e2093 100644
--- a/include/linux/raid/xor_impl.h
+++ b/lib/raid/xor/xor_impl.h
@@ -24,6 +24,12 @@ struct xor_block_template {
 		     const unsigned long * __restrict);
 };
 
+/* generic implementations */
+extern struct xor_block_template xor_block_8regs;
+extern struct xor_block_template xor_block_32regs;
+extern struct xor_block_template xor_block_8regs_p;
+extern struct xor_block_template xor_block_32regs_p;
+
 void __init xor_register(struct xor_block_template *tmpl);
 void __init xor_force(struct xor_block_template *tmpl);
 
-- 
2.47.3

