Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A63D391E4B;
	Mon, 18 May 2026 05:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081538; cv=none; b=RwckNZNhRp3O+WCZ28zeYjfi7EXgtZRCwnHEbeQyN7MhX1U0dOwzo9IB9fxiXd/f/IxFMTbXnxi/YO8PXOMPWwnUymjtiSCFgulD008vK3/pAQKwLSqYDsd2xpnlKkj+Q8GHgqRDkTZkhvhruJzDk4zB3l6bIz9yxAucM2q3yv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081538; c=relaxed/simple;
	bh=rFac2kfGtPMSu+/TKQF8IBWeXEuyNi9WE6m7liAhpPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/W1e7cxaXpwJXbkb9w6WsJzF2lyEQZwd+s+TvJpcsLLGBCuc5s22S+yMyTgZFNwszrnu224CooB3KH4YmkkoWBGM90T5T3cY7qE43K6fhnxsG/JRiJlcFqSIImhQ3dcHzDTYcwx/756aSYZ6FNnWmlfDSGdcb74GIu0fciyJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I68cdNPp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I68cdNPp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DrUpOJ8CgNR60MONr3H/wsCATAigDUTZyaRi0sndY9s=; b=I68cdNPpPfiTHOeUPkg95J4FvE
	HeOl6Kj7ewiSkp/T5xezI3swE2uAUQc1PsX4qdeYeXx75Lcos9sI5N5qrZ/JVy/AHdimDMavDwRYx
	wIGZnmQnahNYjyOiHFnEF2le3E3mGO+2TuJ8Jf2j83NK9+hPFvgDxM/R+y5KhWaBJxmPErJ8GNVfP
	1U857K8YdtHbdmkwABC5B0zUNM/tFR6Fb4WAPbAGGGTtOcbQhkqAjgAJQsG3jycOoN+zG49XeAdWn
	p2tPHCO7G16tOEMIrPBfdjJ2YD9ctDvcj/1koqYxHnmi01gcIBFr7ht7cmQSxKrRn0DQbmjoxpyn0
	hTdc5tCQ==;
Received: from [2001:4bb8:2d1:6fdb:d67d:128c:34ba:85b8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqN5-0000000EFTx-1r7p;
	Mon, 18 May 2026 05:18:31 +0000
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
Subject: [PATCH 01/18] raid6: turn the userspace test harness into a kunit test
Date: Mon, 18 May 2026 07:17:44 +0200
Message-ID: <20260518051804.462141-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518051804.462141-1-hch@lst.de>
References: <20260518051804.462141-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the raid6 code can be compiled as userspace code to run the
test suite.  Convert that to be a kunit case with minimal changes to
avoid mutating global state so that we can drop this requirement.

Note that this is not a good kunit test case yet and will need a lot more
work, but that is deferred until the raid6 code is moved to it's new
place, which is easier if the userspace makefile doesn't need adjustments
for the new location first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
---
 include/linux/raid/pq.h |   3 -
 lib/Kconfig             |  11 +++
 lib/raid6/Makefile      |   2 +-
 lib/raid6/algos.c       |   5 +-
 lib/raid6/recov.c       |  34 ---------
 lib/raid6/test/Makefile | 155 +--------------------------------------
 lib/raid6/test/test.c   | 158 +++++++++++++++++++++-------------------
 7 files changed, 101 insertions(+), 267 deletions(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 2467b3be15c9..08c5995ea980 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -144,7 +144,6 @@ extern const struct raid6_calls raid6_neonx8;
 /* Algorithm list */
 extern const struct raid6_calls * const raid6_algos[];
 extern const struct raid6_recov_calls *const raid6_recov_algos[];
-int raid6_select_algo(void);
 
 /* Return values from chk_syndrome */
 #define RAID6_OK	0
@@ -165,8 +164,6 @@ extern void (*raid6_2data_recov)(int disks, size_t bytes, int faila, int failb,
 		       void **ptrs);
 extern void (*raid6_datap_recov)(int disks, size_t bytes, int faila,
 			void **ptrs);
-void raid6_dual_recov(int disks, size_t bytes, int faila, int failb,
-		      void **ptrs);
 
 /* Some definitions to allow code to be compiled for testing in userspace */
 #ifndef __KERNEL__
diff --git a/lib/Kconfig b/lib/Kconfig
index 00a9509636c1..bffe015a6c10 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -11,6 +11,17 @@ menu "Library routines"
 config RAID6_PQ
 	tristate
 
+config RAID6_PQ_KUNIT_TEST
+	tristate "KUnit tests for RAID6 PQ functions" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on RAID6_PQ
+	default KUNIT_ALL_TESTS
+	help
+	  Unit tests for the RAID6 PQ library functions.
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions.  If unsure, say N.
+
 config RAID6_PQ_BENCHMARK
 	bool "Automatically choose fastest RAID6 PQ functions"
 	depends on RAID6_PQ
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 5be0a4e60ab1..6fd048c127b6 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
+obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o test/
 
 raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
 		   int8.o
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..5a9f4882e18d 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #endif
+#include <kunit/visibility.h>
 
 struct raid6_calls raid6_call;
 EXPORT_SYMBOL_GPL(raid6_call);
@@ -86,6 +87,7 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_intx1,
 	NULL
 };
+EXPORT_SYMBOL_IF_KUNIT(raid6_algos);
 
 void (*raid6_2data_recov)(int, size_t, int, int, void **);
 EXPORT_SYMBOL_GPL(raid6_2data_recov);
@@ -119,6 +121,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 	&raid6_recov_intx1,
 	NULL
 };
+EXPORT_SYMBOL_IF_KUNIT(raid6_recov_algos);
 
 #ifdef __KERNEL__
 #define RAID6_TIME_JIFFIES_LG2	4
@@ -239,7 +242,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 /* Try to pick the best algorithm */
 /* This code uses the gfmul table as convenient data set to abuse */
 
-int __init raid6_select_algo(void)
+static int __init raid6_select_algo(void)
 {
 	const int disks = RAID6_TEST_DISKS;
 
diff --git a/lib/raid6/recov.c b/lib/raid6/recov.c
index b5e47c008b41..8d113196632e 100644
--- a/lib/raid6/recov.c
+++ b/lib/raid6/recov.c
@@ -99,37 +99,3 @@ const struct raid6_recov_calls raid6_recov_intx1 = {
 	.name = "intx1",
 	.priority = 0,
 };
-
-#ifndef __KERNEL__
-/* Testing only */
-
-/* Recover two failed blocks. */
-void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, void **ptrs)
-{
-	if ( faila > failb ) {
-		int tmp = faila;
-		faila = failb;
-		failb = tmp;
-	}
-
-	if ( failb == disks-1 ) {
-		if ( faila == disks-2 ) {
-			/* P+Q failure.  Just rebuild the syndrome. */
-			raid6_call.gen_syndrome(disks, bytes, ptrs);
-		} else {
-			/* data+Q failure.  Reconstruct data from P,
-			   then rebuild syndrome. */
-			/* NOT IMPLEMENTED - equivalent to RAID-5 */
-		}
-	} else {
-		if ( failb == disks-2 ) {
-			/* data+P failure. */
-			raid6_datap_recov(disks, bytes, faila, ptrs);
-		} else {
-			/* data+data failure. */
-			raid6_2data_recov(disks, bytes, faila, failb, ptrs);
-		}
-	}
-}
-
-#endif
diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 09bbe2b14cce..520381ea71d7 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -1,156 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-#
-# This is a simple Makefile to test some of the RAID-6 code
-# from userspace.
-#
 
-pound := \#
+obj-$(CONFIG_RAID6_PQ_KUNIT_TEST)	+= raid6_kunit.o
 
-# Adjust as desired
-CC       = gcc
-OPTFLAGS = -O2
-CFLAGS   = -I.. -I ../../../include -g $(OPTFLAGS)
-LD       = ld
-AWK      = awk -f
-AR       = ar
-RANLIB   = ranlib
-OBJS     = int1.o int2.o int4.o int8.o int16.o int32.o recov.o algos.o tables.o
-
-ARCH := $(shell uname -m 2>/dev/null | sed -e /s/i.86/i386/)
-ifeq ($(ARCH),i386)
-        CFLAGS += -DCONFIG_X86_32
-        IS_X86 = yes
-endif
-ifeq ($(ARCH),x86_64)
-        CFLAGS += -DCONFIG_X86_64
-        IS_X86 = yes
-endif
-
-ifeq ($(ARCH),arm)
-        CFLAGS += -I../../../arch/arm/include -mfpu=neon
-        HAS_NEON = yes
-endif
-ifeq ($(ARCH),aarch64)
-        CFLAGS += -I../../../arch/arm64/include
-        HAS_NEON = yes
-endif
-
-ifeq ($(findstring riscv,$(ARCH)),riscv)
-        CFLAGS += -I../../../arch/riscv/include -DCONFIG_RISCV=1
-        HAS_RVV = yes
-endif
-
-ifeq ($(findstring ppc,$(ARCH)),ppc)
-        CFLAGS += -I../../../arch/powerpc/include
-        HAS_ALTIVEC := $(shell printf '$(pound)include <altivec.h>\nvector int a;\n' |\
-                         gcc -c -x c - >/dev/null && rm ./-.o && echo yes)
-endif
-
-ifeq ($(ARCH),loongarch64)
-        CFLAGS += -I../../../arch/loongarch/include -DCONFIG_LOONGARCH=1
-        CFLAGS += $(shell echo 'vld $$vr0, $$zero, 0' |         \
-                    gcc -c -x assembler - >/dev/null 2>&1 &&    \
-                    rm ./-.o && echo -DCONFIG_CPU_HAS_LSX=1)
-        CFLAGS += $(shell echo 'xvld $$xr0, $$zero, 0' |        \
-                    gcc -c -x assembler - >/dev/null 2>&1 &&    \
-                    rm ./-.o && echo -DCONFIG_CPU_HAS_LASX=1)
-endif
-
-ifeq ($(IS_X86),yes)
-        OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o avx512.o recov_avx512.o
-        CFLAGS += -DCONFIG_X86
-else ifeq ($(HAS_NEON),yes)
-        OBJS   += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
-        CFLAGS += -DCONFIG_KERNEL_MODE_NEON=1
-else ifeq ($(HAS_ALTIVEC),yes)
-        CFLAGS += -DCONFIG_ALTIVEC
-        OBJS += altivec1.o altivec2.o altivec4.o altivec8.o \
-                vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
-else ifeq ($(ARCH),loongarch64)
-        OBJS += loongarch_simd.o recov_loongarch_simd.o
-else ifeq ($(HAS_RVV),yes)
-        OBJS   += rvv.o recov_rvv.o
-        CFLAGS += -DCONFIG_RISCV_ISA_V=1
-endif
-
-.c.o:
-	$(CC) $(CFLAGS) -c -o $@ $<
-
-%.c: ../%.c
-	cp -f $< $@
-
-%.uc: ../%.uc
-	cp -f $< $@
-
-all: raid6.a raid6test
-
-raid6.a: $(OBJS)
-	rm -f $@
-	$(AR) cq $@ $^
-	$(RANLIB) $@
-
-raid6test: test.c raid6.a
-	$(CC) $(CFLAGS) -o raid6test $^
-
-neon1.c: neon.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=1 < neon.uc > $@
-
-neon2.c: neon.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=2 < neon.uc > $@
-
-neon4.c: neon.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=4 < neon.uc > $@
-
-neon8.c: neon.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=8 < neon.uc > $@
-
-altivec1.c: altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=1 < altivec.uc > $@
-
-altivec2.c: altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=2 < altivec.uc > $@
-
-altivec4.c: altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=4 < altivec.uc > $@
-
-altivec8.c: altivec.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=8 < altivec.uc > $@
-
-vpermxor1.c: vpermxor.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=1 < vpermxor.uc > $@
-
-vpermxor2.c: vpermxor.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=2 < vpermxor.uc > $@
-
-vpermxor4.c: vpermxor.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=4 < vpermxor.uc > $@
-
-vpermxor8.c: vpermxor.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=8 < vpermxor.uc > $@
-
-int1.c: int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=1 < int.uc > $@
-
-int2.c: int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=2 < int.uc > $@
-
-int4.c: int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=4 < int.uc > $@
-
-int8.c: int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=8 < int.uc > $@
-
-int16.c: int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=16 < int.uc > $@
-
-int32.c: int.uc ../unroll.awk
-	$(AWK) ../unroll.awk -vN=32 < int.uc > $@
-
-tables.c: mktables
-	./mktables > tables.c
-
-clean:
-	rm -f *.o *.a mktables mktables.c *.uc int*.c altivec*.c vpermxor*.c neon*.c tables.c raid6test
-
-spotless: clean
-	rm -f *~
+raid6_kunit-y += test.o
diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index 841a55242aba..9db287b4a48f 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -1,43 +1,37 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- linux-c -*- ------------------------------------------------------- *
- *
- *   Copyright 2002-2007 H. Peter Anvin - All Rights Reserved
- *
- * ----------------------------------------------------------------------- */
-
 /*
- * raid6test.c
+ * Copyright 2002-2007 H. Peter Anvin - All Rights Reserved
  *
- * Test RAID-6 recovery with various algorithms
+ * Test RAID-6 recovery algorithms.
  */
 
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
+#include <kunit/test.h>
+#include <linux/prandom.h>
 #include <linux/raid/pq.h>
 
-#define NDISKS		16	/* Including P and Q */
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
+#define RAID6_KUNIT_SEED		42
 
-const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+#define NDISKS		16	/* Including P and Q */
 
-char *dataptrs[NDISKS];
-char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static struct rnd_state rng;
+static void *dataptrs[NDISKS];
+static char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
 static void makedata(int start, int stop)
 {
-	int i, j;
+	int i;
 
 	for (i = start; i <= stop; i++) {
-		for (j = 0; j < PAGE_SIZE; j++)
-			data[i][j] = rand();
-
+		prandom_bytes_state(&rng, data[i], PAGE_SIZE);
 		dataptrs[i] = data[i];
 	}
 }
 
-static char disk_type(int d)
+static char member_type(int d)
 {
 	switch (d) {
 	case NDISKS-2:
@@ -49,104 +43,118 @@ static char disk_type(int d)
 	}
 }
 
-static int test_disks(int i, int j)
+static void test_disks(struct kunit *test, const struct raid6_calls *calls,
+		const struct raid6_recov_calls *ra, int faila, int failb)
 {
-	int erra, errb;
-
 	memset(recovi, 0xf0, PAGE_SIZE);
 	memset(recovj, 0xba, PAGE_SIZE);
 
-	dataptrs[i] = recovi;
-	dataptrs[j] = recovj;
-
-	raid6_dual_recov(NDISKS, PAGE_SIZE, i, j, (void **)&dataptrs);
-
-	erra = memcmp(data[i], recovi, PAGE_SIZE);
-	errb = memcmp(data[j], recovj, PAGE_SIZE);
-
-	if (i < NDISKS-2 && j == NDISKS-1) {
-		/* We don't implement the DQ failure scenario, since it's
-		   equivalent to a RAID-5 failure (XOR, then recompute Q) */
-		erra = errb = 0;
+	dataptrs[faila] = recovi;
+	dataptrs[failb] = recovj;
+
+	if (failb == NDISKS - 1) {
+		/*
+		 * We don't implement the data+Q failure scenario, since it
+		 * is equivalent to a RAID-5 failure (XOR, then recompute Q).
+		 */
+		if (faila != NDISKS - 2)
+			goto skip;
+
+		/* P+Q failure.  Just rebuild the syndrome. */
+		calls->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
+	} else if (failb == NDISKS - 2) {
+		/* data+P failure. */
+		ra->datap(NDISKS, PAGE_SIZE, faila, dataptrs);
 	} else {
-		printf("algo=%-8s  faila=%3d(%c)  failb=%3d(%c)  %s\n",
-		       raid6_call.name,
-		       i, disk_type(i),
-		       j, disk_type(j),
-		       (!erra && !errb) ? "OK" :
-		       !erra ? "ERRB" :
-		       !errb ? "ERRA" : "ERRAB");
+		/* data+data failure. */
+		ra->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
 	}
 
-	dataptrs[i] = data[i];
-	dataptrs[j] = data[j];
-
-	return erra || errb;
+	KUNIT_EXPECT_MEMEQ_MSG(test, data[faila], recovi, PAGE_SIZE,
+		"algo=%-8s/%-8s faila miscompared: %3d[%c] (failb=%3d[%c])\n",
+	       calls->name, ra->name,
+	       faila, member_type(faila),
+	       failb, member_type(failb));
+	KUNIT_EXPECT_MEMEQ_MSG(test, data[failb], recovj, PAGE_SIZE,
+		"algo=%-8s/%-8s failb miscompared: %3d[%c] (faila=%3d[%c])\n",
+	       calls->name, ra->name,
+	       failb, member_type(failb),
+	       faila, member_type(faila));
+
+skip:
+	dataptrs[faila] = data[faila];
+	dataptrs[failb] = data[failb];
 }
 
-int main(int argc, char *argv[])
+static void raid6_test(struct kunit *test)
 {
 	const struct raid6_calls *const *algo;
 	const struct raid6_recov_calls *const *ra;
 	int i, j, p1, p2;
-	int err = 0;
-
-	makedata(0, NDISKS-1);
 
 	for (ra = raid6_recov_algos; *ra; ra++) {
 		if ((*ra)->valid  && !(*ra)->valid())
 			continue;
 
-		raid6_2data_recov = (*ra)->data2;
-		raid6_datap_recov = (*ra)->datap;
-
-		printf("using recovery %s\n", (*ra)->name);
-
 		for (algo = raid6_algos; *algo; algo++) {
-			if ((*algo)->valid && !(*algo)->valid())
-				continue;
+			const struct raid6_calls *calls = *algo;
 
-			raid6_call = **algo;
+			if (calls->valid && !calls->valid())
+				continue;
 
 			/* Nuke syndromes */
-			memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
+			memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
+			memset(data[NDISKS - 1], 0xee, PAGE_SIZE);
 
 			/* Generate assumed good syndrome */
-			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+			calls->gen_syndrome(NDISKS, PAGE_SIZE,
 						(void **)&dataptrs);
 
 			for (i = 0; i < NDISKS-1; i++)
 				for (j = i+1; j < NDISKS; j++)
-					err += test_disks(i, j);
+					test_disks(test, calls, *ra, i, j);
 
-			if (!raid6_call.xor_syndrome)
+			if (!calls->xor_syndrome)
 				continue;
 
 			for (p1 = 0; p1 < NDISKS-2; p1++)
 				for (p2 = p1; p2 < NDISKS-2; p2++) {
 
 					/* Simulate rmw run */
-					raid6_call.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					calls->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
 								(void **)&dataptrs);
 					makedata(p1, p2);
-					raid6_call.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					calls->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
                                                                 (void **)&dataptrs);
 
 					for (i = 0; i < NDISKS-1; i++)
 						for (j = i+1; j < NDISKS; j++)
-							err += test_disks(i, j);
+							test_disks(test, calls,
+									*ra, i, j);
 				}
 
 		}
-		printf("\n");
 	}
+}
 
-	printf("\n");
-	/* Pick the best algorithm test */
-	raid6_select_algo();
-
-	if (err)
-		printf("\n*** ERRORS FOUND ***\n");
+static struct kunit_case raid6_test_cases[] = {
+	KUNIT_CASE(raid6_test),
+	{},
+};
 
-	return err;
+static int raid6_suite_init(struct kunit_suite *suite)
+{
+	prandom_seed_state(&rng, RAID6_KUNIT_SEED);
+	makedata(0, NDISKS - 1);
+	return 0;
 }
+
+static struct kunit_suite raid6_test_suite = {
+	.name		= "raid6",
+	.test_cases	= raid6_test_cases,
+	.suite_init	= raid6_suite_init,
+};
+kunit_test_suite(raid6_test_suite);
+
+MODULE_DESCRIPTION("Unit test for the RAID P/Q library functions");
+MODULE_LICENSE("GPL");
-- 
2.53.0

