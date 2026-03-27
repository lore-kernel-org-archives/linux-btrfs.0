Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D2A391828;
	Fri, 27 Mar 2026 06:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592482; cv=none; b=Xcs+n95NJqcJPv5W3Ma1Bhd6PC07CXPXiV25a1hL3t1dQW4eq9W4k+KlyU7niayttEhKag83CnneFFCuj7ONBz4xo6GmhpQtHt+4VGiEVRvS/hLNObZ6Ln2Nwm9fpIN6Rt30x7gIQyoddigckIxKQswV3K5RG5IhjaAAymjigNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592482; c=relaxed/simple;
	bh=K55LekOhxqjt8nbC5Wqu//mt5xHWqPz0Yhrr/6rEUm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1nIRotkJrRjZSCh2Hd+6Y0KeBPPBADyBz+joLXVIBtAuGBTU+ym4rbN6p2Ubwhah56HnpezSLgsyofr+oevgBsHLhUV28oeSODH+Neju/izz5IH+By1EXEbuGjKdmkYsfNI18Oan3a3FVgCxq2OP5RBW48jAg1fM1X8N/a6USI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JS2Fu46O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JS2Fu46O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VU1JeGqI6k2uvXecj1efLpuQZv7vmGIDPw6I2na0LZU=; b=JS2Fu46O1tnrljzebI8oIVG7HC
	wEeWlxq684ElYXvTTNbX61KKoSygqlE+wmDYJHfyib36ewfzBMnlxNeRCPAosQMiE6jNPIDVFaM04
	FHiT5qnjp6YLfJsXEBaVbxQt2iMrRco2qemTa6QX9xJ9hGOracLbWLR1A12ukaHH+rph1FAIeqGbA
	A1i5ZoowqSt3bC9xxv49DWQgajcb8SWk7sIFxLRPOG1d+t0CF7FxLcHLgRzSdwB4MoZnqvRXO7Ix/
	JV06AGQN4g1REQ7FmYLZK0bvuwjWfnV2+AL3MjujKhVmwDHwzLPs1vKEMMGQnSwNcdSQo5JkNm+qE
	ibKvBXyw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Z3-00000006mQy-1JhN;
	Fri, 27 Mar 2026 06:21:01 +0000
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
Subject: [PATCH 15/28] powerpc: move the XOR code to lib/raid/
Date: Fri, 27 Mar 2026 07:16:47 +0100
Message-ID: <20260327061704.3707577-16-hch@lst.de>
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

Move the optimized XOR into lib/raid and include it it in xor.ko
instead of always building it into the main kernel image.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/include/asm/xor.h                | 17 +----
 arch/powerpc/include/asm/xor_altivec.h        | 22 ------
 arch/powerpc/lib/Makefile                     |  5 --
 arch/powerpc/lib/xor_vmx_glue.c               | 63 -----------------
 lib/raid/xor/Makefile                         |  5 ++
 .../lib => lib/raid/xor/powerpc}/xor_vmx.c    |  0
 .../lib => lib/raid/xor/powerpc}/xor_vmx.h    |  0
 lib/raid/xor/powerpc/xor_vmx_glue.c           | 67 +++++++++++++++++++
 8 files changed, 74 insertions(+), 105 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/xor_altivec.h
 delete mode 100644 arch/powerpc/lib/xor_vmx_glue.c
 rename {arch/powerpc/lib => lib/raid/xor/powerpc}/xor_vmx.c (100%)
 rename {arch/powerpc/lib => lib/raid/xor/powerpc}/xor_vmx.h (100%)
 create mode 100644 lib/raid/xor/powerpc/xor_vmx_glue.c

diff --git a/arch/powerpc/include/asm/xor.h b/arch/powerpc/include/asm/xor.h
index 30224c5279c4..3293ac87181c 100644
--- a/arch/powerpc/include/asm/xor.h
+++ b/arch/powerpc/include/asm/xor.h
@@ -8,24 +8,11 @@
 #ifndef _ASM_POWERPC_XOR_H
 #define _ASM_POWERPC_XOR_H
 
-#ifdef CONFIG_ALTIVEC
-
-#include <asm/cputable.h>
 #include <asm/cpu_has_feature.h>
-#include <asm/xor_altivec.h>
-
-static struct xor_block_template xor_block_altivec = {
-	.name = "altivec",
-	.do_2 = xor_altivec_2,
-	.do_3 = xor_altivec_3,
-	.do_4 = xor_altivec_4,
-	.do_5 = xor_altivec_5,
-};
-#endif /* CONFIG_ALTIVEC */
-
-/* Also try the generic routines. */
 #include <asm-generic/xor.h>
 
+extern struct xor_block_template xor_block_altivec;
+
 #define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
diff --git a/arch/powerpc/include/asm/xor_altivec.h b/arch/powerpc/include/asm/xor_altivec.h
deleted file mode 100644
index 294620a25f80..000000000000
--- a/arch/powerpc/include/asm/xor_altivec.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_POWERPC_XOR_ALTIVEC_H
-#define _ASM_POWERPC_XOR_ALTIVEC_H
-
-#ifdef CONFIG_ALTIVEC
-void xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2);
-void xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3);
-void xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4);
-void xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4,
-		   const unsigned long * __restrict p5);
-
-#endif
-#endif /* _ASM_POWERPC_XOR_ALTIVEC_H */
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index f14ecab674a3..002edc3f01d5 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -73,9 +73,4 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
 
-obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
-CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
-# Enable <altivec.h>
-CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
-
 obj-$(CONFIG_PPC64) += $(obj64-y)
diff --git a/arch/powerpc/lib/xor_vmx_glue.c b/arch/powerpc/lib/xor_vmx_glue.c
deleted file mode 100644
index 35d917ece4d1..000000000000
--- a/arch/powerpc/lib/xor_vmx_glue.c
+++ /dev/null
@@ -1,63 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Altivec XOR operations
- *
- * Copyright 2017 IBM Corp.
- */
-
-#include <linux/preempt.h>
-#include <linux/export.h>
-#include <linux/sched.h>
-#include <asm/switch_to.h>
-#include <asm/xor_altivec.h>
-#include "xor_vmx.h"
-
-void xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_2(bytes, p1, p2);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_2);
-
-void xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_3(bytes, p1, p2, p3);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_3);
-
-void xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_4(bytes, p1, p2, p3, p4);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_4);
-
-void xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4,
-		   const unsigned long * __restrict p5)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_5(bytes, p1, p2, p3, p4, p5);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_5);
diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index e8868f5fc396..006b44ce46bf 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -16,6 +16,7 @@ endif
 xor-$(CONFIG_ARM64)		+= arm64/xor-neon.o arm64/xor-neon-glue.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd_glue.o
+xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vmx.o powerpc/xor_vmx_glue.o
 
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
@@ -23,3 +24,7 @@ CFLAGS_REMOVE_arm/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
 
 CFLAGS_arm64/xor-neon.o		+= $(CC_FLAGS_FPU)
 CFLAGS_REMOVE_arm64/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
+
+CFLAGS_powerpc/xor_vmx.o	+= -mhard-float -maltivec \
+				   $(call cc-option,-mabi=altivec) \
+				   -isystem $(shell $(CC) -print-file-name=include)
diff --git a/arch/powerpc/lib/xor_vmx.c b/lib/raid/xor/powerpc/xor_vmx.c
similarity index 100%
rename from arch/powerpc/lib/xor_vmx.c
rename to lib/raid/xor/powerpc/xor_vmx.c
diff --git a/arch/powerpc/lib/xor_vmx.h b/lib/raid/xor/powerpc/xor_vmx.h
similarity index 100%
rename from arch/powerpc/lib/xor_vmx.h
rename to lib/raid/xor/powerpc/xor_vmx.h
diff --git a/lib/raid/xor/powerpc/xor_vmx_glue.c b/lib/raid/xor/powerpc/xor_vmx_glue.c
new file mode 100644
index 000000000000..c41e38340700
--- /dev/null
+++ b/lib/raid/xor/powerpc/xor_vmx_glue.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Altivec XOR operations
+ *
+ * Copyright 2017 IBM Corp.
+ */
+
+#include <linux/preempt.h>
+#include <linux/sched.h>
+#include <linux/raid/xor_impl.h>
+#include <asm/switch_to.h>
+#include <asm/xor.h>
+#include "xor_vmx.h"
+
+static void xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_2(bytes, p1, p2);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+static void xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_3(bytes, p1, p2, p3);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+static void xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_4(bytes, p1, p2, p3, p4);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+static void xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_5(bytes, p1, p2, p3, p4, p5);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+struct xor_block_template xor_block_altivec = {
+	.name = "altivec",
+	.do_2 = xor_altivec_2,
+	.do_3 = xor_altivec_3,
+	.do_4 = xor_altivec_4,
+	.do_5 = xor_altivec_5,
+};
-- 
2.47.3

