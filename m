Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BE53E1229;
	Tue, 24 Mar 2026 06:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334621; cv=none; b=gbNrq51nI4qzPwyRsZxarJMtE1ApbQADktp1jrqBALlycxCXg6lTmaaMSXGgdX7jihmtIaAp4kR0t4greTXnKWnl7yw6YEjjbn7CDiQoJSnddId94yO9FMLoFSUwD9LNa4VLS/g79xnjlFLIOfZBXDM0Sb6LouQjWPIg9T2Jn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334621; c=relaxed/simple;
	bh=R4dO2QIvM+XsnHHNMGMUXer83TDy8y1v9813h5+KEdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKaG9+7kMAIn6Pr+1Y45O2KqZstWNbiBAIEl3SUFibyBepU1+fNk2WSJakm/iL1gBnagIF2eTAe4oSo5K2+ytlrSKhz2CXNgW9Sn/5lZ+oslN76ptrk3jsezIor3qQXVETIYkfuoTxB7wBYMovo5TbJvkru/OQ9NBvhsBPfNOB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lMK0GivL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lMK0GivL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GVH3tLIGJ82mMtEAgO0BTCqgGbCAcEJyJKCZVP8l0x8=; b=lMK0GivL3D6AsJ3aoN/KM1vNAP
	HBvVpJPH6UrVENkJMiZlfg6N5PoD8YE80rHFBObTdyehJSyFifQFHsaX5Gd1/PHTIMWzaBgaC9wD4
	K/LBCKaN0oB0hIST6bW83iG0rs3WW2FHROFkaSw8+QdK7ahBCEqxP/BKlpzXhg6zSs+XSXUZX3eru
	mkRUwaD0dTjQE//QveR1qy3oHbzW8V+0AOVi0Ggn5tcWWNlX+O1ZbmDy+i9cT3Hl6iMbEtkJPbWp4
	cb8EDRwNInRcavc/mFRZq8gvBeJsEYLhbSB/edN/IYGEydmoy8NP8l5cwd5ddXnVnaHUWir0dgA+6
	MovoZA7A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vTw-00000000n3d-1n8u;
	Tue, 24 Mar 2026 06:43:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/17] raid6: hide internals
Date: Tue, 24 Mar 2026 07:40:43 +0100
Message-ID: <20260324064115.3217136-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324064115.3217136-1-hch@lst.de>
References: <20260324064115.3217136-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split out two new headers from the public pq.h:

 - lib/raid/raid6/algos.h contains the algorithm lists private to
   lib/raid/raid6
 - include/linux/raid/pq_tables.h contains the tables also used by
   async_tx providers.

The public include/linux/pq.h is now limited to the public interface for
the consumers of the RAID6 PQ API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/async_tx/async_pq.c                    |  1 +
 crypto/async_tx/async_raid6_recov.c           |  1 +
 drivers/dma/bcm-sba-raid.c                    |  1 +
 include/linux/raid/pq.h                       | 96 ++-----------------
 include/linux/raid/pq_tables.h                | 19 ++++
 lib/raid/raid6/Makefile                       |  2 +
 lib/raid/raid6/algos.c                        |  3 +-
 lib/raid/raid6/algos.h                        | 82 ++++++++++++++++
 lib/raid/raid6/arm/neon.c                     |  2 +-
 lib/raid/raid6/arm/recov_neon.c               |  2 +
 lib/raid/raid6/int.uc                         |  2 +-
 lib/raid/raid6/loongarch/loongarch_simd.c     |  2 +-
 .../raid6/loongarch/recov_loongarch_simd.c    |  2 +
 lib/raid/raid6/mktables.c                     |  2 +-
 lib/raid/raid6/powerpc/altivec.uc             |  2 +-
 lib/raid/raid6/powerpc/vpermxor.uc            |  2 +-
 lib/raid/raid6/recov.c                        |  2 +
 lib/raid/raid6/riscv/recov_rvv.c              |  2 +
 lib/raid/raid6/riscv/rvv.h                    |  2 +-
 lib/raid/raid6/s390/recov_s390xc.c            |  2 +
 lib/raid/raid6/s390/s390vx.uc                 |  2 +-
 lib/raid/raid6/tests/raid6_kunit.c            |  2 +-
 lib/raid/raid6/x86/avx2.c                     |  3 +-
 lib/raid/raid6/x86/avx512.c                   |  3 +-
 lib/raid/raid6/x86/mmx.c                      |  3 +-
 lib/raid/raid6/x86/recov_avx2.c               |  2 +
 lib/raid/raid6/x86/recov_avx512.c             |  2 +
 lib/raid/raid6/x86/recov_ssse3.c              |  2 +
 lib/raid/raid6/x86/sse1.c                     |  3 +-
 lib/raid/raid6/x86/sse2.c                     |  3 +-
 30 files changed, 151 insertions(+), 103 deletions(-)
 create mode 100644 include/linux/raid/pq_tables.h
 create mode 100644 lib/raid/raid6/algos.h

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index f3574f80d1df..27f99349e310 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/raid/pq.h>
+#include <linux/raid/pq_tables.h>
 #include <linux/async_tx.h>
 #include <linux/gfp.h>
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 305ea1421a3e..e53870d84bc5 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/raid/pq.h>
+#include <linux/raid/pq_tables.h>
 #include <linux/async_tx.h>
 #include <linux/dmaengine.h>
 
diff --git a/drivers/dma/bcm-sba-raid.c b/drivers/dma/bcm-sba-raid.c
index ed037fa883f6..0de03611252e 100644
--- a/drivers/dma/bcm-sba-raid.c
+++ b/drivers/dma/bcm-sba-raid.c
@@ -40,6 +40,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/raid/pq.h>
+#include <linux/raid/pq_tables.h>
 
 #include "dmaengine.h"
 
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 425a227591c0..1b4da8b98828 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -1,15 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- linux-c -*- ------------------------------------------------------- *
+/*
+ * Copyright 2003 H. Peter Anvin - All Rights Reserved
  *
- *   Copyright 2003 H. Peter Anvin - All Rights Reserved
- *
- * ----------------------------------------------------------------------- */
-
-#ifndef LINUX_RAID_RAID6_H
-#define LINUX_RAID_RAID6_H
+ * Public interface to the RAID6 P/Q calculation and recovery library.
+ */
+#ifndef LINUX_RAID_PQ_H
+#define LINUX_RAID_PQ_H
 
-#include <linux/blkdev.h>
-#include <linux/mm.h>
+#include <linux/types.h>
 
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
 void raid6_xor_syndrome(int disks, int start, int stop, size_t bytes,
@@ -21,82 +19,4 @@ void raid6_recov_2data(int disks, size_t bytes, int faila, int failb,
 void raid6_recov_datap(int disks, size_t bytes, int faila,
 		void **ptrs);
 
-/* Routine choices */
-struct raid6_calls {
-	void (*gen_syndrome)(int, size_t, void **);
-	void (*xor_syndrome)(int, int, int, size_t, void **);
-	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
-	const char *name;	/* Name of this routine set */
-	int priority;		/* Relative priority ranking if non-zero */
-};
-
-/* Various routine sets */
-extern const struct raid6_calls raid6_intx1;
-extern const struct raid6_calls raid6_intx2;
-extern const struct raid6_calls raid6_intx4;
-extern const struct raid6_calls raid6_intx8;
-extern const struct raid6_calls raid6_mmxx1;
-extern const struct raid6_calls raid6_mmxx2;
-extern const struct raid6_calls raid6_sse1x1;
-extern const struct raid6_calls raid6_sse1x2;
-extern const struct raid6_calls raid6_sse2x1;
-extern const struct raid6_calls raid6_sse2x2;
-extern const struct raid6_calls raid6_sse2x4;
-extern const struct raid6_calls raid6_altivec1;
-extern const struct raid6_calls raid6_altivec2;
-extern const struct raid6_calls raid6_altivec4;
-extern const struct raid6_calls raid6_altivec8;
-extern const struct raid6_calls raid6_avx2x1;
-extern const struct raid6_calls raid6_avx2x2;
-extern const struct raid6_calls raid6_avx2x4;
-extern const struct raid6_calls raid6_avx512x1;
-extern const struct raid6_calls raid6_avx512x2;
-extern const struct raid6_calls raid6_avx512x4;
-extern const struct raid6_calls raid6_s390vx8;
-extern const struct raid6_calls raid6_vpermxor1;
-extern const struct raid6_calls raid6_vpermxor2;
-extern const struct raid6_calls raid6_vpermxor4;
-extern const struct raid6_calls raid6_vpermxor8;
-extern const struct raid6_calls raid6_lsx;
-extern const struct raid6_calls raid6_lasx;
-extern const struct raid6_calls raid6_rvvx1;
-extern const struct raid6_calls raid6_rvvx2;
-extern const struct raid6_calls raid6_rvvx4;
-extern const struct raid6_calls raid6_rvvx8;
-
-struct raid6_recov_calls {
-	void (*data2)(int, size_t, int, int, void **);
-	void (*datap)(int, size_t, int, void **);
-	int  (*valid)(void);
-	const char *name;
-	int priority;
-};
-
-extern const struct raid6_recov_calls raid6_recov_intx1;
-extern const struct raid6_recov_calls raid6_recov_ssse3;
-extern const struct raid6_recov_calls raid6_recov_avx2;
-extern const struct raid6_recov_calls raid6_recov_avx512;
-extern const struct raid6_recov_calls raid6_recov_s390xc;
-extern const struct raid6_recov_calls raid6_recov_neon;
-extern const struct raid6_recov_calls raid6_recov_lsx;
-extern const struct raid6_recov_calls raid6_recov_lasx;
-extern const struct raid6_recov_calls raid6_recov_rvv;
-
-extern const struct raid6_calls raid6_neonx1;
-extern const struct raid6_calls raid6_neonx2;
-extern const struct raid6_calls raid6_neonx4;
-extern const struct raid6_calls raid6_neonx8;
-
-/* Algorithm list */
-extern const struct raid6_calls * const raid6_algos[];
-extern const struct raid6_recov_calls *const raid6_recov_algos[];
-
-/* Galois field tables */
-extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
-extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
-extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
-extern const u8 raid6_gflog[256]      __attribute__((aligned(256)));
-extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
-extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
-
-#endif /* LINUX_RAID_RAID6_H */
+#endif /* LINUX_RAID_PQ_H */
diff --git a/include/linux/raid/pq_tables.h b/include/linux/raid/pq_tables.h
new file mode 100644
index 000000000000..7b1ebe675677
--- /dev/null
+++ b/include/linux/raid/pq_tables.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright 2003 H. Peter Anvin - All Rights Reserved
+ *
+ * Galois field tables for the Linux RAID6 P/Q parity algorithm.
+ */
+#ifndef _LINUX_RAID_PQ_TABLES_H
+#define _LINUX_RAID_PQ_TABLES_H
+
+#include <linux/types.h>
+
+extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
+extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
+extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
+extern const u8 raid6_gflog[256]      __attribute__((aligned(256)));
+extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
+extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
+
+#endif /* _LINUX_RAID_PQ_TABLES_H */
diff --git a/lib/raid/raid6/Makefile b/lib/raid/raid6/Makefile
index f155eba06fe3..fc46c3e61c82 100644
--- a/lib/raid/raid6/Makefile
+++ b/lib/raid/raid6/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+ccflags-y			+= -I $(src)
+
 obj-$(CONFIG_RAID6_PQ)		+= raid6_pq.o tests/
 
 raid6_pq-y			+= algos.o tables.o
diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index 4958c58e3f69..406efdcc03b8 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -11,10 +11,11 @@
  * Algorithm list and algorithm selection for RAID-6
  */
 
-#include <linux/raid/pq.h>
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/raid/pq.h>
 #include <kunit/visibility.h>
+#include "algos.h"
 
 static const struct raid6_recov_calls *raid6_recov_algo;
 
diff --git a/lib/raid/raid6/algos.h b/lib/raid/raid6/algos.h
new file mode 100644
index 000000000000..e5f1098d2179
--- /dev/null
+++ b/lib/raid/raid6/algos.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright 2003 H. Peter Anvin - All Rights Reserved
+ */
+#ifndef _PQ_IMPL_H
+#define _PQ_IMPL_H
+
+#include <linux/raid/pq_tables.h>
+
+/* Routine choices */
+struct raid6_calls {
+	const char *name;
+	void (*gen_syndrome)(int disks, size_t bytes, void **ptrs);
+	void (*xor_syndrome)(int disks, int start, int stop, size_t bytes,
+			void **ptrs);
+	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
+	int priority;		/* Relative priority ranking if non-zero */
+};
+
+/* Various routine sets */
+extern const struct raid6_calls raid6_intx1;
+extern const struct raid6_calls raid6_intx2;
+extern const struct raid6_calls raid6_intx4;
+extern const struct raid6_calls raid6_intx8;
+extern const struct raid6_calls raid6_mmxx1;
+extern const struct raid6_calls raid6_mmxx2;
+extern const struct raid6_calls raid6_sse1x1;
+extern const struct raid6_calls raid6_sse1x2;
+extern const struct raid6_calls raid6_sse2x1;
+extern const struct raid6_calls raid6_sse2x2;
+extern const struct raid6_calls raid6_sse2x4;
+extern const struct raid6_calls raid6_altivec1;
+extern const struct raid6_calls raid6_altivec2;
+extern const struct raid6_calls raid6_altivec4;
+extern const struct raid6_calls raid6_altivec8;
+extern const struct raid6_calls raid6_avx2x1;
+extern const struct raid6_calls raid6_avx2x2;
+extern const struct raid6_calls raid6_avx2x4;
+extern const struct raid6_calls raid6_avx512x1;
+extern const struct raid6_calls raid6_avx512x2;
+extern const struct raid6_calls raid6_avx512x4;
+extern const struct raid6_calls raid6_s390vx8;
+extern const struct raid6_calls raid6_vpermxor1;
+extern const struct raid6_calls raid6_vpermxor2;
+extern const struct raid6_calls raid6_vpermxor4;
+extern const struct raid6_calls raid6_vpermxor8;
+extern const struct raid6_calls raid6_lsx;
+extern const struct raid6_calls raid6_lasx;
+extern const struct raid6_calls raid6_rvvx1;
+extern const struct raid6_calls raid6_rvvx2;
+extern const struct raid6_calls raid6_rvvx4;
+extern const struct raid6_calls raid6_rvvx8;
+
+struct raid6_recov_calls {
+	const char *name;
+	void (*data2)(int disks, size_t bytes, int faila, int failb,
+			void **ptrs);
+	void (*datap)(int disks, size_t bytes, int faila, void **ptrs);
+	int  (*valid)(void);
+	int priority;
+};
+
+extern const struct raid6_recov_calls raid6_recov_intx1;
+extern const struct raid6_recov_calls raid6_recov_ssse3;
+extern const struct raid6_recov_calls raid6_recov_avx2;
+extern const struct raid6_recov_calls raid6_recov_avx512;
+extern const struct raid6_recov_calls raid6_recov_s390xc;
+extern const struct raid6_recov_calls raid6_recov_neon;
+extern const struct raid6_recov_calls raid6_recov_lsx;
+extern const struct raid6_recov_calls raid6_recov_lasx;
+extern const struct raid6_recov_calls raid6_recov_rvv;
+
+extern const struct raid6_calls raid6_neonx1;
+extern const struct raid6_calls raid6_neonx2;
+extern const struct raid6_calls raid6_neonx4;
+extern const struct raid6_calls raid6_neonx8;
+
+/* Algorithm list */
+extern const struct raid6_calls * const raid6_algos[];
+extern const struct raid6_recov_calls *const raid6_recov_algos[];
+
+#endif /* _PQ_IMPL_H */
diff --git a/lib/raid/raid6/arm/neon.c b/lib/raid/raid6/arm/neon.c
index c21da59ab48f..bd4ec4c86ee8 100644
--- a/lib/raid/raid6/arm/neon.c
+++ b/lib/raid/raid6/arm/neon.c
@@ -5,8 +5,8 @@
  * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
-#include <linux/raid/pq.h>
 #include <asm/simd.h>
+#include "algos.h"
 
 /*
  * There are 2 reasons these wrappers are kept in a separate compilation unit
diff --git a/lib/raid/raid6/arm/recov_neon.c b/lib/raid/raid6/arm/recov_neon.c
index 21c26da6290a..2a2afbd9ead5 100644
--- a/lib/raid/raid6/arm/recov_neon.c
+++ b/lib/raid/raid6/arm/recov_neon.c
@@ -4,8 +4,10 @@
  * Copyright (C) 2017 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
 #include <asm/simd.h>
+#include "algos.h"
 #include "neon.h"
 
 static int raid6_has_neon(void)
diff --git a/lib/raid/raid6/int.uc b/lib/raid/raid6/int.uc
index 4f5f2869e21e..e63bd5a9c2ed 100644
--- a/lib/raid/raid6/int.uc
+++ b/lib/raid/raid6/int.uc
@@ -18,7 +18,7 @@
  * This file is postprocessed using unroll.awk
  */
 
-#include <linux/raid/pq.h>
+#include "algos.h"
 
 /*
  * This is the C data type to use
diff --git a/lib/raid/raid6/loongarch/loongarch_simd.c b/lib/raid/raid6/loongarch/loongarch_simd.c
index 1b4cd1512d05..f77d11ce676e 100644
--- a/lib/raid/raid6/loongarch/loongarch_simd.c
+++ b/lib/raid/raid6/loongarch/loongarch_simd.c
@@ -9,9 +9,9 @@
  * Copyright 2002-2004 H. Peter Anvin
  */
 
-#include <linux/raid/pq.h>
 #include <asm/cpu-features.h>
 #include <asm/fpu.h>
+#include "algos.h"
 
 /*
  * The vector algorithms are currently priority 0, which means the generic
diff --git a/lib/raid/raid6/loongarch/recov_loongarch_simd.c b/lib/raid/raid6/loongarch/recov_loongarch_simd.c
index 7d4d349322b3..0bbdc8b5c2e7 100644
--- a/lib/raid/raid6/loongarch/recov_loongarch_simd.c
+++ b/lib/raid/raid6/loongarch/recov_loongarch_simd.c
@@ -10,9 +10,11 @@
  * Author: Jim Kukunas <james.t.kukunas@linux.intel.com>
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
 #include <asm/cpu-features.h>
 #include <asm/fpu.h>
+#include "algos.h"
 
 /*
  * Unlike with the syndrome calculation algorithms, there's no boot-time
diff --git a/lib/raid/raid6/mktables.c b/lib/raid/raid6/mktables.c
index 3de1dbf6846c..97a17493bbd8 100644
--- a/lib/raid/raid6/mktables.c
+++ b/lib/raid/raid6/mktables.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 	uint8_t exptbl[256], invtbl[256];
 
 	printf("#include <linux/export.h>\n");
-	printf("#include <linux/raid/pq.h>\n");
+	printf("#include \"algos.h\"\n");
 
 	/* Compute multiplication table */
 	printf("\nconst u8  __attribute__((aligned(256)))\n"
diff --git a/lib/raid/raid6/powerpc/altivec.uc b/lib/raid/raid6/powerpc/altivec.uc
index 084ead768ddb..eb4a448cc88e 100644
--- a/lib/raid/raid6/powerpc/altivec.uc
+++ b/lib/raid/raid6/powerpc/altivec.uc
@@ -22,7 +22,7 @@
  * bracked this with preempt_disable/enable or in a lock)
  */
 
-#include <linux/raid/pq.h>
+#include "algos.h"
 
 #include <altivec.h>
 #include <asm/cputable.h>
diff --git a/lib/raid/raid6/powerpc/vpermxor.uc b/lib/raid/raid6/powerpc/vpermxor.uc
index bb2c3a316ae8..ec61f30bec11 100644
--- a/lib/raid/raid6/powerpc/vpermxor.uc
+++ b/lib/raid/raid6/powerpc/vpermxor.uc
@@ -20,11 +20,11 @@
  * This instruction was introduced in POWER8 - ISA v2.07.
  */
 
-#include <linux/raid/pq.h>
 #include <altivec.h>
 #include <asm/ppc-opcode.h>
 #include <asm/cputable.h>
 #include <asm/switch_to.h>
+#include "algos.h"
 
 typedef vector unsigned char unative_t;
 #define NSIZE sizeof(unative_t)
diff --git a/lib/raid/raid6/recov.c b/lib/raid/raid6/recov.c
index cc7e4dc1eaa6..735ab4013771 100644
--- a/lib/raid/raid6/recov.c
+++ b/lib/raid/raid6/recov.c
@@ -13,7 +13,9 @@
  * the syndrome.)
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
+#include "algos.h"
 
 /* Recover two failed data blocks. */
 static void raid6_2data_recov_intx1(int disks, size_t bytes, int faila,
diff --git a/lib/raid/raid6/riscv/recov_rvv.c b/lib/raid/raid6/riscv/recov_rvv.c
index 3ff39826e33f..02120d245e22 100644
--- a/lib/raid/raid6/riscv/recov_rvv.c
+++ b/lib/raid/raid6/riscv/recov_rvv.c
@@ -4,7 +4,9 @@
  * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
+#include "algos.h"
 #include "rvv.h"
 
 static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
diff --git a/lib/raid/raid6/riscv/rvv.h b/lib/raid/raid6/riscv/rvv.h
index 0d430a4c5f08..c293130d798b 100644
--- a/lib/raid/raid6/riscv/rvv.h
+++ b/lib/raid/raid6/riscv/rvv.h
@@ -7,8 +7,8 @@
  * Definitions for RISC-V RAID-6 code
  */
 
-#include <linux/raid/pq.h>
 #include <asm/vector.h>
+#include "algos.h"
 
 static int rvv_has_vector(void)
 {
diff --git a/lib/raid/raid6/s390/recov_s390xc.c b/lib/raid/raid6/s390/recov_s390xc.c
index 2bc4c85174de..e7b3409f21e2 100644
--- a/lib/raid/raid6/s390/recov_s390xc.c
+++ b/lib/raid/raid6/s390/recov_s390xc.c
@@ -6,7 +6,9 @@
  * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
+#include "algos.h"
 
 static inline void xor_block(u8 *p1, u8 *p2)
 {
diff --git a/lib/raid/raid6/s390/s390vx.uc b/lib/raid/raid6/s390/s390vx.uc
index 97c5d5d9dcf9..aba3515eacac 100644
--- a/lib/raid/raid6/s390/s390vx.uc
+++ b/lib/raid/raid6/s390/s390vx.uc
@@ -12,8 +12,8 @@
  */
 
 #include <linux/cpufeature.h>
-#include <linux/raid/pq.h>
 #include <asm/fpu.h>
+#include "algos.h"
 
 #define NSIZE 16
 
diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index 97e036b19049..1a6168096456 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -7,7 +7,7 @@
 
 #include <kunit/test.h>
 #include <linux/prandom.h>
-#include <linux/raid/pq.h>
+#include "../algos.h"
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index aab8b624c635..0bf831799082 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -13,8 +13,9 @@
  *
  */
 
-#include <linux/raid/pq.h>
+#include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 static const struct raid6_avx2_constants {
 	u64 x1d[4];
diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index 47636b16632f..98ed42fb0a46 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -17,8 +17,9 @@
  *
  */
 
-#include <linux/raid/pq.h>
+#include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 static const struct raid6_avx512_constants {
 	u64 x1d[8];
diff --git a/lib/raid/raid6/x86/mmx.c b/lib/raid/raid6/x86/mmx.c
index 22b9fdaa705f..052d9f010bfe 100644
--- a/lib/raid/raid6/x86/mmx.c
+++ b/lib/raid/raid6/x86/mmx.c
@@ -11,8 +11,9 @@
  * MMX implementation of RAID-6 syndrome functions
  */
 
-#include <linux/raid/pq.h>
+#include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 /* Shared with raid6/sse1.c */
 const struct raid6_mmx_constants {
diff --git a/lib/raid/raid6/x86/recov_avx2.c b/lib/raid/raid6/x86/recov_avx2.c
index bef82a38d8eb..06c6e05763bc 100644
--- a/lib/raid/raid6/x86/recov_avx2.c
+++ b/lib/raid/raid6/x86/recov_avx2.c
@@ -4,8 +4,10 @@
  * Author: Jim Kukunas <james.t.kukunas@linux.intel.com>
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 static int raid6_has_avx2(void)
 {
diff --git a/lib/raid/raid6/x86/recov_avx512.c b/lib/raid/raid6/x86/recov_avx512.c
index 06c70e771eaa..850bb962b514 100644
--- a/lib/raid/raid6/x86/recov_avx512.c
+++ b/lib/raid/raid6/x86/recov_avx512.c
@@ -6,8 +6,10 @@
  * Author: Megha Dey <megha.dey@linux.intel.com>
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 static int raid6_has_avx512(void)
 {
diff --git a/lib/raid/raid6/x86/recov_ssse3.c b/lib/raid/raid6/x86/recov_ssse3.c
index 5ca7d56f23d8..95589c33003a 100644
--- a/lib/raid/raid6/x86/recov_ssse3.c
+++ b/lib/raid/raid6/x86/recov_ssse3.c
@@ -3,8 +3,10 @@
  * Copyright (C) 2012 Intel Corporation
  */
 
+#include <linux/mm.h>
 #include <linux/raid/pq.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 static int raid6_has_ssse3(void)
 {
diff --git a/lib/raid/raid6/x86/sse1.c b/lib/raid/raid6/x86/sse1.c
index fad214a430d8..7004255a0bb1 100644
--- a/lib/raid/raid6/x86/sse1.c
+++ b/lib/raid/raid6/x86/sse1.c
@@ -16,8 +16,9 @@
  * worthwhile as a separate implementation.
  */
 
-#include <linux/raid/pq.h>
+#include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 /* Defined in raid6/mmx.c */
 extern const struct raid6_mmx_constants {
diff --git a/lib/raid/raid6/x86/sse2.c b/lib/raid/raid6/x86/sse2.c
index 1b28e858a1d4..f30be4ee14d0 100644
--- a/lib/raid/raid6/x86/sse2.c
+++ b/lib/raid/raid6/x86/sse2.c
@@ -12,8 +12,9 @@
  *
  */
 
-#include <linux/raid/pq.h>
+#include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
+#include "algos.h"
 
 static const struct raid6_sse_constants {
 	u64 x1d[2];
-- 
2.47.3

