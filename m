Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273C3A0B1D;
	Mon, 18 May 2026 05:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081689; cv=none; b=SJdQHgjQ99eqxhCdeDQAZo4J7x+bxH6d5me0JNeXQcOiO2V0Q/MpxqY7pF+zuo48lDszrauZCcShe8XoESJFkFjg2Th2j6/jLtzifqkgZWevmoLRzxPxM1dmpltjNLPvWiDbYMDlhjWmXj6PquIT8hj4ERBZhpHCkCBtNLlosNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081689; c=relaxed/simple;
	bh=C7rjyipGz0TUsLXdOeH6ZEHe1hF2PvMT8fGp+VuXsSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wcg2c9IHJeT4BvAcfTM70S5OkMtQ8ly+AI0USsd2+UJ7wuw4TzeJEBoAsCVJpYutY/LD+GyNdrFogsvHJVclzbw/jpCRPi31QTMtGSNifSNUtXHA05mbCKh5owZ3s7L+8b9xA5l//SSHybCCsBdl9ltbcU6ydN+S75od+FirG0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=alT7uO0d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="alT7uO0d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yC8VYGTT7Bg7wfZS0SEiMkPiv5BSoy0nPjUFrQ4vges=; b=alT7uO0dQXQ1vOll5NXMzMuPr+
	HPQbgeOa0Y3awT6gSoL6grEDUpIuHWuLzIy92JDBfKEE86tGLHkXO/4/nAeYP4hH9VcDlbktPHG05
	mSllqtukEwaQ/RR3qume5/iLmHTLPfXc0AWyEnMVTRR61aDvJl8+Q+Ib5qoPkdlXid5vg16BfAeOh
	2+UsjW16gAf3B/gVvaUSpfgi+OtG/AJZ0DDCAQiNEEX4hb6JgEtnsSV0/STcUvt+HwuX8tM4AIF+f
	gzJ/G2rpix2+OdbY/mEBRgn104UjxUnUTU7Ay+StCXv/RpjtkRNegaqdCjMfS0KpjeFFMgwPNZl1l
	lx8y7APw==;
Received: from [2001:4bb8:2d1:6fdb:d67d:128c:34ba:85b8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqPG-0000000EGxe-2HfK;
	Mon, 18 May 2026 05:20:47 +0000
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
Subject: [PATCH 10/18] raid6: rework registration of optimized algorithms
Date: Mon, 18 May 2026 07:17:53 +0200
Message-ID: <20260518051804.462141-11-hch@lst.de>
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

Replace the static array of algorithms with a call to an architecture
helper to register algorithms.  This serves two purposes:  it avoid
having to register all algorithms in a single central place, and it
removes the need for the priority field by just registering the
algorithms that the architecture considers suitable for the currently
running CPUs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
---
 lib/raid/Kconfig                              |  11 +
 lib/raid/raid6/Makefile                       |   4 +
 lib/raid/raid6/algos.c                        | 303 ++++++++----------
 lib/raid/raid6/algos.h                        |  67 +---
 lib/raid/raid6/arm/neon.c                     |   6 -
 lib/raid/raid6/arm/pq_arch.h                  |  21 ++
 lib/raid/raid6/arm/recov_neon.c               |   7 -
 lib/raid/raid6/arm64/pq_arch.h                |   1 +
 lib/raid/raid6/loongarch/loongarch_simd.c     |  12 -
 lib/raid/raid6/loongarch/pq_arch.h            |  23 ++
 .../raid6/loongarch/recov_loongarch_simd.c    |  14 -
 lib/raid/raid6/powerpc/altivec.uc             |  10 -
 lib/raid/raid6/powerpc/pq_arch.h              |  32 ++
 lib/raid/raid6/powerpc/vpermxor.uc            |  11 -
 lib/raid/raid6/recov.c                        |   2 -
 lib/raid/raid6/riscv/pq_arch.h                |  21 ++
 lib/raid/raid6/riscv/recov_rvv.c              |   2 -
 lib/raid/raid6/riscv/rvv.h                    |   6 -
 lib/raid/raid6/s390/pq_arch.h                 |  15 +
 lib/raid/raid6/s390/recov_s390xc.c            |   2 -
 lib/raid/raid6/s390/s390vx.uc                 |   7 -
 lib/raid/raid6/tests/raid6_kunit.c            |  23 +-
 lib/raid/raid6/x86/avx2.c                     |  14 -
 lib/raid/raid6/x86/avx512.c                   |  19 --
 lib/raid/raid6/x86/mmx.c                      |   8 -
 lib/raid/raid6/x86/pq_arch.h                  |  96 ++++++
 lib/raid/raid6/x86/recov_avx2.c               |   8 -
 lib/raid/raid6/x86/recov_avx512.c             |  12 -
 lib/raid/raid6/x86/recov_ssse3.c              |   9 -
 lib/raid/raid6/x86/sse1.c                     |  12 -
 lib/raid/raid6/x86/sse2.c                     |  15 -
 31 files changed, 384 insertions(+), 409 deletions(-)
 create mode 100644 lib/raid/raid6/arm/pq_arch.h
 create mode 100644 lib/raid/raid6/arm64/pq_arch.h
 create mode 100644 lib/raid/raid6/loongarch/pq_arch.h
 create mode 100644 lib/raid/raid6/powerpc/pq_arch.h
 create mode 100644 lib/raid/raid6/riscv/pq_arch.h
 create mode 100644 lib/raid/raid6/s390/pq_arch.h
 create mode 100644 lib/raid/raid6/x86/pq_arch.h

diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
index e39f6d667792..978cd6ba08ac 100644
--- a/lib/raid/Kconfig
+++ b/lib/raid/Kconfig
@@ -32,6 +32,17 @@ config XOR_KUNIT_TEST
 config RAID6_PQ
 	tristate
 
+# selected by architectures that provide an optimized PQ implementation
+config RAID6_PQ_ARCH
+	depends on RAID6_PQ
+	default y if KERNEL_MODE_NEON		# arm32/arm64
+	default y if LOONGARCH
+	default y if ALTIVEC			# powerpc
+	default y if RISCV_ISA_V
+	default y if S390
+	default y if X86
+	bool
+
 config RAID6_PQ_KUNIT_TEST
 	tristate "KUnit tests for RAID6 PQ functions" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/raid/raid6/Makefile b/lib/raid/raid6/Makefile
index 90de3dce152e..1d79b76b320e 100644
--- a/lib/raid/raid6/Makefile
+++ b/lib/raid/raid6/Makefile
@@ -4,6 +4,10 @@ ccflags-y			+= -I $(src)
 
 ccflags-y			+= -I $(src)
 
+ifeq ($(CONFIG_RAID6_PQ_ARCH),y)
+CFLAGS_algos.o			+= -I$(src)/$(SRCARCH)
+endif
+
 obj-$(CONFIG_RAID6_PQ)		+= raid6_pq.o tests/
 
 raid6_pq-y			+= algos.o tables.o
diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index d83ca4dac864..30d7cb34874f 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -17,6 +17,9 @@
 #include <kunit/visibility.h>
 #include "algos.h"
 
+#define RAID6_MAX_ALGOS		16
+static const struct raid6_calls *raid6_algos[RAID6_MAX_ALGOS];
+static unsigned int raid6_nr_algos;
 static const struct raid6_recov_calls *raid6_recov_algo;
 
 /* Selected algorithm */
@@ -97,71 +100,6 @@ bool raid6_can_xor_syndrome(void)
 }
 EXPORT_SYMBOL_GPL(raid6_can_xor_syndrome);
 
-const struct raid6_calls * const raid6_algos[] = {
-#if defined(__i386__) && !defined(__arch_um__)
-	&raid6_avx512x2,
-	&raid6_avx512x1,
-	&raid6_avx2x2,
-	&raid6_avx2x1,
-	&raid6_sse2x2,
-	&raid6_sse2x1,
-	&raid6_sse1x2,
-	&raid6_sse1x1,
-	&raid6_mmxx2,
-	&raid6_mmxx1,
-#endif
-#if defined(__x86_64__) && !defined(__arch_um__)
-	&raid6_avx512x4,
-	&raid6_avx512x2,
-	&raid6_avx512x1,
-	&raid6_avx2x4,
-	&raid6_avx2x2,
-	&raid6_avx2x1,
-	&raid6_sse2x4,
-	&raid6_sse2x2,
-	&raid6_sse2x1,
-#endif
-#ifdef CONFIG_ALTIVEC
-	&raid6_vpermxor8,
-	&raid6_vpermxor4,
-	&raid6_vpermxor2,
-	&raid6_vpermxor1,
-	&raid6_altivec8,
-	&raid6_altivec4,
-	&raid6_altivec2,
-	&raid6_altivec1,
-#endif
-#if defined(CONFIG_S390)
-	&raid6_s390vx8,
-#endif
-#ifdef CONFIG_KERNEL_MODE_NEON
-	&raid6_neonx8,
-	&raid6_neonx4,
-	&raid6_neonx2,
-	&raid6_neonx1,
-#endif
-#ifdef CONFIG_LOONGARCH
-#ifdef CONFIG_CPU_HAS_LASX
-	&raid6_lasx,
-#endif
-#ifdef CONFIG_CPU_HAS_LSX
-	&raid6_lsx,
-#endif
-#endif
-#ifdef CONFIG_RISCV_ISA_V
-	&raid6_rvvx1,
-	&raid6_rvvx2,
-	&raid6_rvvx4,
-	&raid6_rvvx8,
-#endif
-	&raid6_intx8,
-	&raid6_intx4,
-	&raid6_intx2,
-	&raid6_intx1,
-	NULL
-};
-EXPORT_SYMBOL_IF_KUNIT(raid6_algos);
-
 /**
  * raid6_recov_2data - recover two missing data disks
  * @disks:	number of "disks" to operate on including parity
@@ -215,119 +153,57 @@ void raid6_recov_datap(int disks, size_t bytes, int faila, void **ptrs)
 }
 EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
-const struct raid6_recov_calls *const raid6_recov_algos[] = {
-#ifdef CONFIG_X86
-	&raid6_recov_avx512,
-	&raid6_recov_avx2,
-	&raid6_recov_ssse3,
-#endif
-#ifdef CONFIG_S390
-	&raid6_recov_s390xc,
-#endif
-#if defined(CONFIG_KERNEL_MODE_NEON)
-	&raid6_recov_neon,
-#endif
-#ifdef CONFIG_LOONGARCH
-#ifdef CONFIG_CPU_HAS_LASX
-	&raid6_recov_lasx,
-#endif
-#ifdef CONFIG_CPU_HAS_LSX
-	&raid6_recov_lsx,
-#endif
-#endif
-#ifdef CONFIG_RISCV_ISA_V
-	&raid6_recov_rvv,
-#endif
-	&raid6_recov_intx1,
-	NULL
-};
-EXPORT_SYMBOL_IF_KUNIT(raid6_recov_algos);
-
 #define RAID6_TIME_JIFFIES_LG2	4
 #define RAID6_TEST_DISKS	8
 #define RAID6_TEST_DISKS_ORDER	3
 
-static inline const struct raid6_recov_calls *raid6_choose_recov(void)
+static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
+		const int disks)
 {
-	const struct raid6_recov_calls *const *algo;
-	const struct raid6_recov_calls *best;
-
-	for (best = NULL, algo = raid6_recov_algos; *algo; algo++)
-		if (!best || (*algo)->priority > best->priority)
-			if (!(*algo)->valid || (*algo)->valid())
-				best = *algo;
+	/* work on the second half of the disks */
+	int start = (disks >> 1) - 1, stop = disks - 3;
+	const struct raid6_calls *best = NULL;
+	unsigned long bestgenperf = 0;
+	unsigned int i;
 
-	if (best) {
-		raid6_recov_algo = best;
+	for (i = 0; i < raid6_nr_algos; i++) {
+		const struct raid6_calls *algo = raid6_algos[i];
+		unsigned long perf = 0, j0, j1;
 
-		pr_info("raid6: using %s recovery algorithm\n", best->name);
-	} else
-		pr_err("raid6: Yikes! No recovery algorithm found!\n");
-
-	return best;
-}
+		preempt_disable();
+		j0 = jiffies;
+		while ((j1 = jiffies) == j0)
+			cpu_relax();
+		while (time_before(jiffies,
+				    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
+			algo->gen_syndrome(disks, PAGE_SIZE, *dptrs);
+			perf++;
+		}
+		preempt_enable();
 
-static inline const struct raid6_calls *raid6_choose_gen(
-	void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
-{
-	unsigned long perf, bestgenperf, j0, j1;
-	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
-	const struct raid6_calls *const *algo;
-	const struct raid6_calls *best;
-
-	for (bestgenperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
-		if (!best || (*algo)->priority >= best->priority) {
-			if ((*algo)->valid && !(*algo)->valid())
-				continue;
-
-			if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
-				best = *algo;
-				break;
-			}
-
-			perf = 0;
-
-			preempt_disable();
-			j0 = jiffies;
-			while ((j1 = jiffies) == j0)
-				cpu_relax();
-			while (time_before(jiffies,
-					    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
-				(*algo)->gen_syndrome(disks, PAGE_SIZE, *dptrs);
-				perf++;
-			}
-			preempt_enable();
-
-			if (perf > bestgenperf) {
-				bestgenperf = perf;
-				best = *algo;
-			}
-			pr_info("raid6: %-8s gen() %5ld MB/s\n", (*algo)->name,
-				(perf * HZ * (disks-2)) >>
-				(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
+		if (perf > bestgenperf) {
+			bestgenperf = perf;
+			best = algo;
 		}
+		pr_info("raid6: %-8s gen() %5ld MB/s\n", algo->name,
+			(perf * HZ * (disks-2)) >>
+			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
 	}
 
 	if (!best) {
 		pr_err("raid6: Yikes! No algorithm found!\n");
-		goto out;
+		return -EINVAL;
 	}
 
 	raid6_call = *best;
 
-	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
-		pr_info("raid6: skipped pq benchmark and selected %s\n",
-			best->name);
-		goto out;
-	}
-
 	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
 		best->name,
 		(bestgenperf * HZ * (disks - 2)) >>
 		(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
 
 	if (best->xor_syndrome) {
-		perf = 0;
+		unsigned long perf = 0, j0, j1;
 
 		preempt_disable();
 		j0 = jiffies;
@@ -346,8 +222,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
 	}
 
-out:
-	return best;
+	return 0;
 }
 
 
@@ -357,12 +232,17 @@ static inline const struct raid6_calls *raid6_choose_gen(
 static int __init raid6_select_algo(void)
 {
 	const int disks = RAID6_TEST_DISKS;
-
-	const struct raid6_calls *gen_best;
-	const struct raid6_recov_calls *rec_best;
 	char *disk_ptr, *p;
 	void *dptrs[RAID6_TEST_DISKS];
 	int i, cycle;
+	int error;
+
+	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos == 1) {
+		pr_info("raid6: skipped pq benchmark and selected %s\n",
+			raid6_algos[raid6_nr_algos - 1]->name);
+		raid6_call = *raid6_algos[raid6_nr_algos - 1];
+		return 0;
+	}
 
 	/* prepare the buffer and fill it circularly with gfmul table */
 	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
@@ -385,22 +265,109 @@ static int __init raid6_select_algo(void)
 		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
 
 	/* select raid gen_syndrome function */
-	gen_best = raid6_choose_gen(&dptrs, disks);
-
-	/* select raid recover functions */
-	rec_best = raid6_choose_recov();
+	error = raid6_choose_gen(&dptrs, disks);
 
 	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
 
-	return gen_best && rec_best ? 0 : -EINVAL;
+	return error;
 }
 
-static void raid6_exit(void)
+/*
+ * Register a RAID6 P/Q generation algorithm.  The most optimized/unrolled
+ * implementation should be registered last so it will be selected when the
+ * boot-time benchmark is disabled.
+ */
+void __init raid6_algo_add(const struct raid6_calls *algo)
 {
-	do { } while (0);
+	if (WARN_ON_ONCE(raid6_nr_algos == RAID6_MAX_ALGOS))
+		return;
+	raid6_algos[raid6_nr_algos++] = algo;
 }
 
-subsys_initcall(raid6_select_algo);
+void __init raid6_algo_add_default(void)
+{
+	raid6_algo_add(&raid6_intx1);
+	raid6_algo_add(&raid6_intx2);
+	raid6_algo_add(&raid6_intx4);
+	raid6_algo_add(&raid6_intx8);
+}
+
+void __init raid6_recov_algo_add(const struct raid6_recov_calls *algo)
+{
+	if (WARN_ON_ONCE(raid6_recov_algo))
+		return;
+	raid6_recov_algo = algo;
+}
+
+#ifdef CONFIG_RAID6_PQ_ARCH
+#include "pq_arch.h"
+#else
+static inline void arch_raid6_init(void)
+{
+	raid6_algo_add_default();
+}
+#endif /* CONFIG_RAID6_PQ_ARCH */
+
+static int __init raid6_init(void)
+{
+	/*
+	 * Architectures providing arch_raid6_init must add all PQ generation
+	 * algorithms they want to consider in arch_raid6_init(), including
+	 * the generic ones using raid6_algo_add_default() if wanted.
+	 */
+	arch_raid6_init();
+
+	/*
+	 * Architectures don't have to set a recovery algorithm, we'll just pick
+	 * the generic integer one if none was set.
+	 */
+	if (!raid6_recov_algo)
+		raid6_recov_algo = &raid6_recov_intx1;
+	pr_info("raid6: using %s recovery algorithm\n", raid6_recov_algo->name);
+
+	return raid6_select_algo();
+}
+
+static void __exit raid6_exit(void)
+{
+}
+
+subsys_initcall(raid6_init);
 module_exit(raid6_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RAID6 Q-syndrome calculations");
+
+#if IS_ENABLED(CONFIG_RAID6_PQ_KUNIT_TEST)
+const struct raid6_calls *raid6_algo_find(unsigned int idx)
+{
+	if (idx >= raid6_nr_algos) {
+		/*
+		 * Always include the simplest generic integer implementation in
+		 * the unit tests as a baseline.
+		 */
+		if (idx == raid6_nr_algos &&
+		    raid6_algos[0] != &raid6_intx1)
+			return &raid6_intx1;
+		return NULL;
+	}
+	return raid6_algos[idx];
+}
+EXPORT_SYMBOL_IF_KUNIT(raid6_algo_find);
+
+const struct raid6_recov_calls *raid6_recov_algo_find(unsigned int idx)
+{
+	switch (idx) {
+	case 0:
+		/* always test the generic integer implementation */
+		return &raid6_recov_intx1;
+	case 1:
+		/* test the optimized implementation if there is one */
+		if (raid6_recov_algo != &raid6_recov_intx1)
+			return raid6_recov_algo;
+		return NULL;
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL_IF_KUNIT(raid6_recov_algo_find);
+#endif /* CONFIG_RAID6_PQ_KUNIT_TEST */
diff --git a/lib/raid/raid6/algos.h b/lib/raid/raid6/algos.h
index e5f1098d2179..43f636be183f 100644
--- a/lib/raid/raid6/algos.h
+++ b/lib/raid/raid6/algos.h
@@ -5,6 +5,7 @@
 #ifndef _PQ_IMPL_H
 #define _PQ_IMPL_H
 
+#include <linux/init.h>
 #include <linux/raid/pq_tables.h>
 
 /* Routine choices */
@@ -13,70 +14,28 @@ struct raid6_calls {
 	void (*gen_syndrome)(int disks, size_t bytes, void **ptrs);
 	void (*xor_syndrome)(int disks, int start, int stop, size_t bytes,
 			void **ptrs);
-	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
-	int priority;		/* Relative priority ranking if non-zero */
 };
 
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
 struct raid6_recov_calls {
 	const char *name;
 	void (*data2)(int disks, size_t bytes, int faila, int failb,
 			void **ptrs);
 	void (*datap)(int disks, size_t bytes, int faila, void **ptrs);
-	int  (*valid)(void);
-	int priority;
 };
 
-extern const struct raid6_recov_calls raid6_recov_intx1;
-extern const struct raid6_recov_calls raid6_recov_ssse3;
-extern const struct raid6_recov_calls raid6_recov_avx2;
-extern const struct raid6_recov_calls raid6_recov_avx512;
-extern const struct raid6_recov_calls raid6_recov_s390xc;
-extern const struct raid6_recov_calls raid6_recov_neon;
-extern const struct raid6_recov_calls raid6_recov_lsx;
-extern const struct raid6_recov_calls raid6_recov_lasx;
-extern const struct raid6_recov_calls raid6_recov_rvv;
+void __init raid6_algo_add(const struct raid6_calls *algo);
+void __init raid6_algo_add_default(void);
+void __init raid6_recov_algo_add(const struct raid6_recov_calls *algo);
 
-extern const struct raid6_calls raid6_neonx1;
-extern const struct raid6_calls raid6_neonx2;
-extern const struct raid6_calls raid6_neonx4;
-extern const struct raid6_calls raid6_neonx8;
+/* for the kunit test */
+const struct raid6_calls *raid6_algo_find(unsigned int idx);
+const struct raid6_recov_calls *raid6_recov_algo_find(unsigned int idx);
 
-/* Algorithm list */
-extern const struct raid6_calls * const raid6_algos[];
-extern const struct raid6_recov_calls *const raid6_recov_algos[];
+/* generic implementations */
+extern const struct raid6_calls raid6_intx1;
+extern const struct raid6_calls raid6_intx2;
+extern const struct raid6_calls raid6_intx4;
+extern const struct raid6_calls raid6_intx8;
+extern const struct raid6_recov_calls raid6_recov_intx1;
 
 #endif /* _PQ_IMPL_H */
diff --git a/lib/raid/raid6/arm/neon.c b/lib/raid/raid6/arm/neon.c
index bd4ec4c86ee8..341c61af675e 100644
--- a/lib/raid/raid6/arm/neon.c
+++ b/lib/raid/raid6/arm/neon.c
@@ -42,15 +42,9 @@
 	struct raid6_calls const raid6_neonx ## _n = {			\
 		.gen_syndrome	= raid6_neon ## _n ## _gen_syndrome,	\
 		.xor_syndrome	= raid6_neon ## _n ## _xor_syndrome,	\
-		.valid		= raid6_have_neon,			\
 		.name		= "neonx" #_n,				\
 	}
 
-static int raid6_have_neon(void)
-{
-	return cpu_has_neon();
-}
-
 RAID6_NEON_WRAPPER(1);
 RAID6_NEON_WRAPPER(2);
 RAID6_NEON_WRAPPER(4);
diff --git a/lib/raid/raid6/arm/pq_arch.h b/lib/raid/raid6/arm/pq_arch.h
new file mode 100644
index 000000000000..3f876ea6749c
--- /dev/null
+++ b/lib/raid/raid6/arm/pq_arch.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <asm/neon.h>
+
+extern const struct raid6_calls raid6_neonx1;
+extern const struct raid6_calls raid6_neonx2;
+extern const struct raid6_calls raid6_neonx4;
+extern const struct raid6_calls raid6_neonx8;
+extern const struct raid6_recov_calls raid6_recov_neon;
+
+static __always_inline void __init arch_raid6_init(void)
+{
+	raid6_algo_add_default();
+	if (cpu_has_neon()) {
+		raid6_algo_add(&raid6_neonx1);
+		raid6_algo_add(&raid6_neonx2);
+		raid6_algo_add(&raid6_neonx4);
+		raid6_algo_add(&raid6_neonx8);
+		raid6_recov_algo_add(&raid6_recov_neon);
+	}
+}
diff --git a/lib/raid/raid6/arm/recov_neon.c b/lib/raid/raid6/arm/recov_neon.c
index e1d1d19fc9a8..1524050d09b7 100644
--- a/lib/raid/raid6/arm/recov_neon.c
+++ b/lib/raid/raid6/arm/recov_neon.c
@@ -10,11 +10,6 @@
 #include "algos.h"
 #include "arm/neon.h"
 
-static int raid6_has_neon(void)
-{
-	return cpu_has_neon();
-}
-
 static void raid6_2data_recov_neon(int disks, size_t bytes, int faila,
 		int failb, void **ptrs)
 {
@@ -87,7 +82,5 @@ static void raid6_datap_recov_neon(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_neon = {
 	.data2		= raid6_2data_recov_neon,
 	.datap		= raid6_datap_recov_neon,
-	.valid		= raid6_has_neon,
 	.name		= "neon",
-	.priority	= 10,
 };
diff --git a/lib/raid/raid6/arm64/pq_arch.h b/lib/raid/raid6/arm64/pq_arch.h
new file mode 100644
index 000000000000..27ff564d7594
--- /dev/null
+++ b/lib/raid/raid6/arm64/pq_arch.h
@@ -0,0 +1 @@
+#include "arm/pq_arch.h"
diff --git a/lib/raid/raid6/loongarch/loongarch_simd.c b/lib/raid/raid6/loongarch/loongarch_simd.c
index f77d11ce676e..c1eb53fafd27 100644
--- a/lib/raid/raid6/loongarch/loongarch_simd.c
+++ b/lib/raid/raid6/loongarch/loongarch_simd.c
@@ -26,11 +26,6 @@
 #ifdef CONFIG_CPU_HAS_LSX
 #define NSIZE 16
 
-static int raid6_has_lsx(void)
-{
-	return cpu_has_lsx;
-}
-
 static void raid6_lsx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 {
 	u8 **dptr = (u8 **)ptrs;
@@ -246,7 +241,6 @@ static void raid6_lsx_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_lsx = {
 	.gen_syndrome	= raid6_lsx_gen_syndrome,
 	.xor_syndrome	= raid6_lsx_xor_syndrome,
-	.valid		= raid6_has_lsx,
 	.name		= "lsx",
 };
 
@@ -256,11 +250,6 @@ const struct raid6_calls raid6_lsx = {
 #ifdef CONFIG_CPU_HAS_LASX
 #define NSIZE 32
 
-static int raid6_has_lasx(void)
-{
-	return cpu_has_lasx;
-}
-
 static void raid6_lasx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 {
 	u8 **dptr = (u8 **)ptrs;
@@ -414,7 +403,6 @@ static void raid6_lasx_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_lasx = {
 	.gen_syndrome	= raid6_lasx_gen_syndrome,
 	.xor_syndrome	= raid6_lasx_xor_syndrome,
-	.valid		= raid6_has_lasx,
 	.name		= "lasx",
 };
 #undef NSIZE
diff --git a/lib/raid/raid6/loongarch/pq_arch.h b/lib/raid/raid6/loongarch/pq_arch.h
new file mode 100644
index 000000000000..ae443a4d7b69
--- /dev/null
+++ b/lib/raid/raid6/loongarch/pq_arch.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <asm/cpu-features.h>
+
+extern const struct raid6_calls raid6_lsx;
+extern const struct raid6_calls raid6_lasx;
+
+extern const struct raid6_recov_calls raid6_recov_lsx;
+extern const struct raid6_recov_calls raid6_recov_lasx;
+
+static __always_inline void __init arch_raid6_init(void)
+{
+	raid6_algo_add_default();
+	if (IS_ENABLED(CONFIG_CPU_HAS_LSX) && cpu_has_lsx)
+		raid6_algo_add(&raid6_lsx);
+	if (IS_ENABLED(CONFIG_CPU_HAS_LASX) && cpu_has_lasx)
+		raid6_algo_add(&raid6_lasx);
+
+	if (IS_ENABLED(CONFIG_CPU_HAS_LASX) && cpu_has_lasx)
+		raid6_recov_algo_add(&raid6_recov_lasx);
+	else if (IS_ENABLED(CONFIG_CPU_HAS_LSX) && cpu_has_lsx)
+		raid6_recov_algo_add(&raid6_recov_lsx);
+}
diff --git a/lib/raid/raid6/loongarch/recov_loongarch_simd.c b/lib/raid/raid6/loongarch/recov_loongarch_simd.c
index 0bbdc8b5c2e7..87a2313bbb4f 100644
--- a/lib/raid/raid6/loongarch/recov_loongarch_simd.c
+++ b/lib/raid/raid6/loongarch/recov_loongarch_simd.c
@@ -24,11 +24,6 @@
  */
 
 #ifdef CONFIG_CPU_HAS_LSX
-static int raid6_has_lsx(void)
-{
-	return cpu_has_lsx;
-}
-
 static void raid6_2data_recov_lsx(int disks, size_t bytes, int faila,
 				  int failb, void **ptrs)
 {
@@ -291,18 +286,11 @@ static void raid6_datap_recov_lsx(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_lsx = {
 	.data2 = raid6_2data_recov_lsx,
 	.datap = raid6_datap_recov_lsx,
-	.valid = raid6_has_lsx,
 	.name = "lsx",
-	.priority = 1,
 };
 #endif /* CONFIG_CPU_HAS_LSX */
 
 #ifdef CONFIG_CPU_HAS_LASX
-static int raid6_has_lasx(void)
-{
-	return cpu_has_lasx;
-}
-
 static void raid6_2data_recov_lasx(int disks, size_t bytes, int faila,
 				   int failb, void **ptrs)
 {
@@ -509,8 +497,6 @@ static void raid6_datap_recov_lasx(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_lasx = {
 	.data2 = raid6_2data_recov_lasx,
 	.datap = raid6_datap_recov_lasx,
-	.valid = raid6_has_lasx,
 	.name = "lasx",
-	.priority = 2,
 };
 #endif /* CONFIG_CPU_HAS_LASX */
diff --git a/lib/raid/raid6/powerpc/altivec.uc b/lib/raid/raid6/powerpc/altivec.uc
index eb4a448cc88e..c5429fb71dd6 100644
--- a/lib/raid/raid6/powerpc/altivec.uc
+++ b/lib/raid/raid6/powerpc/altivec.uc
@@ -104,17 +104,7 @@ static void raid6_altivec$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	preempt_enable();
 }
 
-int raid6_have_altivec(void);
-#if $# == 1
-int raid6_have_altivec(void)
-{
-	/* This assumes either all CPUs have Altivec or none does */
-	return cpu_has_feature(CPU_FTR_ALTIVEC);
-}
-#endif
-
 const struct raid6_calls raid6_altivec$# = {
 	.gen_syndrome	= raid6_altivec$#_gen_syndrome,
-	.valid		= raid6_have_altivec,
 	.name		= "altivecx$#",
 };
diff --git a/lib/raid/raid6/powerpc/pq_arch.h b/lib/raid/raid6/powerpc/pq_arch.h
new file mode 100644
index 000000000000..ea1878777ff2
--- /dev/null
+++ b/lib/raid/raid6/powerpc/pq_arch.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <asm/cputable.h>
+
+extern const struct raid6_calls raid6_altivec1;
+extern const struct raid6_calls raid6_altivec2;
+extern const struct raid6_calls raid6_altivec4;
+extern const struct raid6_calls raid6_altivec8;
+extern const struct raid6_calls raid6_vpermxor1;
+extern const struct raid6_calls raid6_vpermxor2;
+extern const struct raid6_calls raid6_vpermxor4;
+extern const struct raid6_calls raid6_vpermxor8;
+
+static __always_inline void __init arch_raid6_init(void)
+{
+	raid6_algo_add_default();
+
+	/* This assumes either all CPUs have Altivec or none does */
+	if (cpu_has_feature(CPU_FTR_ALTIVEC)) {
+		raid6_algo_add(&raid6_altivec1);
+		raid6_algo_add(&raid6_altivec2);
+		raid6_algo_add(&raid6_altivec4);
+		raid6_algo_add(&raid6_altivec8);
+	}
+	if (cpu_has_feature(CPU_FTR_ALTIVEC_COMP) &&
+	    cpu_has_feature(CPU_FTR_ARCH_207S)) {
+		raid6_algo_add(&raid6_vpermxor1);
+		raid6_algo_add(&raid6_vpermxor2);
+		raid6_algo_add(&raid6_vpermxor4);
+		raid6_algo_add(&raid6_vpermxor8);
+	}
+}
diff --git a/lib/raid/raid6/powerpc/vpermxor.uc b/lib/raid/raid6/powerpc/vpermxor.uc
index ec61f30bec11..e8964361aaef 100644
--- a/lib/raid/raid6/powerpc/vpermxor.uc
+++ b/lib/raid/raid6/powerpc/vpermxor.uc
@@ -76,18 +76,7 @@ static void raid6_vpermxor$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	preempt_enable();
 }
 
-int raid6_have_altivec_vpermxor(void);
-#if $# == 1
-int raid6_have_altivec_vpermxor(void)
-{
-	/* Check if arch has both altivec and the vpermxor instructions */
-	return (cpu_has_feature(CPU_FTR_ALTIVEC_COMP) &&
-		cpu_has_feature(CPU_FTR_ARCH_207S));
-}
-#endif
-
 const struct raid6_calls raid6_vpermxor$# = {
 	.gen_syndrome	= raid6_vpermxor$#_gen_syndrome,
-	.valid		= raid6_have_altivec_vpermxor,
 	.name		= "vpermxor$#",
 };
diff --git a/lib/raid/raid6/recov.c b/lib/raid/raid6/recov.c
index 735ab4013771..76eb2aef3667 100644
--- a/lib/raid/raid6/recov.c
+++ b/lib/raid/raid6/recov.c
@@ -97,7 +97,5 @@ static void raid6_datap_recov_intx1(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_intx1 = {
 	.data2 = raid6_2data_recov_intx1,
 	.datap = raid6_datap_recov_intx1,
-	.valid = NULL,
 	.name = "intx1",
-	.priority = 0,
 };
diff --git a/lib/raid/raid6/riscv/pq_arch.h b/lib/raid/raid6/riscv/pq_arch.h
new file mode 100644
index 000000000000..82f1a188f8c4
--- /dev/null
+++ b/lib/raid/raid6/riscv/pq_arch.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <asm/vector.h>
+
+extern const struct raid6_calls raid6_rvvx1;
+extern const struct raid6_calls raid6_rvvx2;
+extern const struct raid6_calls raid6_rvvx4;
+extern const struct raid6_calls raid6_rvvx8;
+extern const struct raid6_recov_calls raid6_recov_rvv;
+
+static __always_inline void __init arch_raid6_init(void)
+{
+	raid6_algo_add_default();
+	if (has_vector()) {
+		raid6_algo_add(&raid6_rvvx1);
+		raid6_algo_add(&raid6_rvvx2);
+		raid6_algo_add(&raid6_rvvx4);
+		raid6_algo_add(&raid6_rvvx8);
+		raid6_recov_algo_add(&raid6_recov_rvv);
+	}
+}
diff --git a/lib/raid/raid6/riscv/recov_rvv.c b/lib/raid/raid6/riscv/recov_rvv.c
index 02120d245e22..2305940276dd 100644
--- a/lib/raid/raid6/riscv/recov_rvv.c
+++ b/lib/raid/raid6/riscv/recov_rvv.c
@@ -218,7 +218,5 @@ static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_rvv = {
 	.data2		= raid6_2data_recov_rvv,
 	.datap		= raid6_datap_recov_rvv,
-	.valid		= rvv_has_vector,
 	.name		= "rvv",
-	.priority	= 1,
 };
diff --git a/lib/raid/raid6/riscv/rvv.h b/lib/raid/raid6/riscv/rvv.h
index c293130d798b..3a7c2468b1ea 100644
--- a/lib/raid/raid6/riscv/rvv.h
+++ b/lib/raid/raid6/riscv/rvv.h
@@ -10,11 +10,6 @@
 #include <asm/vector.h>
 #include "algos.h"
 
-static int rvv_has_vector(void)
-{
-	return has_vector();
-}
-
 #define RAID6_RVV_WRAPPER(_n)						\
 	static void raid6_rvv ## _n ## _gen_syndrome(int disks,		\
 					size_t bytes, void **ptrs)	\
@@ -41,6 +36,5 @@ static int rvv_has_vector(void)
 	struct raid6_calls const raid6_rvvx ## _n = {			\
 		.gen_syndrome	= raid6_rvv ## _n ## _gen_syndrome,	\
 		.xor_syndrome	= raid6_rvv ## _n ## _xor_syndrome,	\
-		.valid		= rvv_has_vector,			\
 		.name		= "rvvx" #_n,				\
 	}
diff --git a/lib/raid/raid6/s390/pq_arch.h b/lib/raid/raid6/s390/pq_arch.h
new file mode 100644
index 000000000000..95d14c342306
--- /dev/null
+++ b/lib/raid/raid6/s390/pq_arch.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <linux/cpufeature.h>
+
+extern const struct raid6_calls raid6_s390vx8;
+extern const struct raid6_recov_calls raid6_recov_s390xc;
+
+static __always_inline void __init arch_raid6_init(void)
+{
+	if (cpu_has_vx())
+		raid6_algo_add(&raid6_s390vx8);
+	else
+		raid6_algo_add_default();
+	raid6_recov_algo_add(&raid6_recov_s390xc);
+}
diff --git a/lib/raid/raid6/s390/recov_s390xc.c b/lib/raid/raid6/s390/recov_s390xc.c
index e7b3409f21e2..08d56896e5ea 100644
--- a/lib/raid/raid6/s390/recov_s390xc.c
+++ b/lib/raid/raid6/s390/recov_s390xc.c
@@ -112,7 +112,5 @@ static void raid6_datap_recov_s390xc(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_s390xc = {
 	.data2 = raid6_2data_recov_s390xc,
 	.datap = raid6_datap_recov_s390xc,
-	.valid = NULL,
 	.name = "s390xc",
-	.priority = 1,
 };
diff --git a/lib/raid/raid6/s390/s390vx.uc b/lib/raid/raid6/s390/s390vx.uc
index aba3515eacac..e5cf9054be2a 100644
--- a/lib/raid/raid6/s390/s390vx.uc
+++ b/lib/raid/raid6/s390/s390vx.uc
@@ -121,15 +121,8 @@ static void raid6_s390vx$#_xor_syndrome(int disks, int start, int stop,
 	kernel_fpu_end(&vxstate, KERNEL_VXR);
 }
 
-static int raid6_s390vx$#_valid(void)
-{
-	return cpu_has_vx();
-}
-
 const struct raid6_calls raid6_s390vx$# = {
 	.gen_syndrome	= raid6_s390vx$#_gen_syndrome,
 	.xor_syndrome	= raid6_s390vx$#_xor_syndrome,
-	.valid		= raid6_s390vx$#_valid,
 	.name		= "vx128x$#",
-	.priority	= 1,
 };
diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index de6a866953c5..4dea1c5acc96 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -88,19 +88,20 @@ static void test_disks(struct kunit *test, const struct raid6_calls *calls,
 
 static void raid6_test(struct kunit *test)
 {
-	const struct raid6_calls *const *algo;
-	const struct raid6_recov_calls *const *ra;
 	int i, j, p1, p2;
+	unsigned int r, g;
 
-	for (ra = raid6_recov_algos; *ra; ra++) {
-		if ((*ra)->valid  && !(*ra)->valid())
-			continue;
+	for (r = 0; ; r++) {
+		const struct raid6_recov_calls *ra = raid6_recov_algo_find(r);
 
-		for (algo = raid6_algos; *algo; algo++) {
-			const struct raid6_calls *calls = *algo;
+		if (!ra)
+			break;
 
-			if (calls->valid && !calls->valid())
-				continue;
+		for (g = 0; ; g++) {
+			const struct raid6_calls *calls = raid6_algo_find(g);
+
+			if (!calls)
+				break;
 
 			/* Nuke syndromes */
 			memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
@@ -112,7 +113,7 @@ static void raid6_test(struct kunit *test)
 
 			for (i = 0; i < NDISKS-1; i++)
 				for (j = i+1; j < NDISKS; j++)
-					test_disks(test, calls, *ra, i, j);
+					test_disks(test, calls, ra, i, j);
 
 			if (!calls->xor_syndrome)
 				continue;
@@ -130,7 +131,7 @@ static void raid6_test(struct kunit *test)
 					for (i = 0; i < NDISKS-1; i++)
 						for (j = i+1; j < NDISKS; j++)
 							test_disks(test, calls,
-									*ra, i, j);
+									ra, i, j);
 				}
 
 		}
diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index 0bf831799082..7efd94e6a87a 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -24,11 +24,6 @@ static const struct raid6_avx2_constants {
 	  0x1d1d1d1d1d1d1d1dULL, 0x1d1d1d1d1d1d1d1dULL,},
 };
 
-static int raid6_have_avx2(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX);
-}
-
 /*
  * Plain AVX2 implementation
  */
@@ -131,10 +126,7 @@ static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_avx2x1 = {
 	.gen_syndrome	= raid6_avx21_gen_syndrome,
 	.xor_syndrome	= raid6_avx21_xor_syndrome,
-	.valid		= raid6_have_avx2,
 	.name		= "avx2x1",
-	/* Prefer AVX2 over priority 1 (SSE2 and others) */
-	.priority	= 2,
 };
 
 /*
@@ -262,10 +254,7 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_avx2x2 = {
 	.gen_syndrome	= raid6_avx22_gen_syndrome,
 	.xor_syndrome	= raid6_avx22_xor_syndrome,
-	.valid		= raid6_have_avx2,
 	.name		= "avx2x2",
-	/* Prefer AVX2 over priority 1 (SSE2 and others) */
-	.priority	= 2,
 };
 
 #ifdef CONFIG_X86_64
@@ -466,9 +455,6 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_avx2x4 = {
 	.gen_syndrome	= raid6_avx24_gen_syndrome,
 	.xor_syndrome	= raid6_avx24_xor_syndrome,
-	.valid		= raid6_have_avx2,
 	.name		= "avx2x4",
-	/* Prefer AVX2 over priority 1 (SSE2 and others) */
-	.priority	= 2,
 };
 #endif /* CONFIG_X86_64 */
diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index 98ed42fb0a46..0772e798b742 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -30,16 +30,6 @@ static const struct raid6_avx512_constants {
 	  0x1d1d1d1d1d1d1d1dULL, 0x1d1d1d1d1d1d1d1dULL,},
 };
 
-static int raid6_have_avx512(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) &&
-		boot_cpu_has(X86_FEATURE_AVX) &&
-		boot_cpu_has(X86_FEATURE_AVX512F) &&
-		boot_cpu_has(X86_FEATURE_AVX512BW) &&
-		boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		boot_cpu_has(X86_FEATURE_AVX512DQ);
-}
-
 static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 {
 	u8 **dptr = (u8 **)ptrs;
@@ -159,10 +149,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_avx512x1 = {
 	.gen_syndrome	= raid6_avx5121_gen_syndrome,
 	.xor_syndrome	= raid6_avx5121_xor_syndrome,
-	.valid		= raid6_have_avx512,
 	.name		= "avx512x1",
-	/* Prefer AVX512 over priority 1 (SSE2 and others) */
-	.priority	= 2,
 };
 
 /*
@@ -317,10 +304,7 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_avx512x2 = {
 	.gen_syndrome	= raid6_avx5122_gen_syndrome,
 	.xor_syndrome	= raid6_avx5122_xor_syndrome,
-	.valid		= raid6_have_avx512,
 	.name		= "avx512x2",
-	/* Prefer AVX512 over priority 1 (SSE2 and others) */
-	.priority	= 2,
 };
 
 #ifdef CONFIG_X86_64
@@ -556,9 +540,6 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_avx512x4 = {
 	.gen_syndrome	= raid6_avx5124_gen_syndrome,
 	.xor_syndrome	= raid6_avx5124_xor_syndrome,
-	.valid		= raid6_have_avx512,
 	.name		= "avx512x4",
-	/* Prefer AVX512 over priority 1 (SSE2 and others) */
-	.priority	= 2,
 };
 #endif
diff --git a/lib/raid/raid6/x86/mmx.c b/lib/raid/raid6/x86/mmx.c
index 052d9f010bfe..3228c335965a 100644
--- a/lib/raid/raid6/x86/mmx.c
+++ b/lib/raid/raid6/x86/mmx.c
@@ -22,12 +22,6 @@ const struct raid6_mmx_constants {
 	0x1d1d1d1d1d1d1d1dULL,
 };
 
-static int raid6_have_mmx(void)
-{
-	/* Not really "boot_cpu" but "all_cpus" */
-	return boot_cpu_has(X86_FEATURE_MMX);
-}
-
 /*
  * Plain MMX implementation
  */
@@ -70,7 +64,6 @@ static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_mmxx1 = {
 	.gen_syndrome	= raid6_mmx1_gen_syndrome,
-	.valid		= raid6_have_mmx,
 	.name		= "mmxx1",
 };
 
@@ -127,6 +120,5 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_mmxx2 = {
 	.gen_syndrome	= raid6_mmx2_gen_syndrome,
-	.valid		= raid6_have_mmx,
 	.name		= "mmxx2",
 };
diff --git a/lib/raid/raid6/x86/pq_arch.h b/lib/raid/raid6/x86/pq_arch.h
new file mode 100644
index 000000000000..28e395eb04d1
--- /dev/null
+++ b/lib/raid/raid6/x86/pq_arch.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <asm/cpufeature.h>
+
+extern const struct raid6_calls raid6_mmxx1;
+extern const struct raid6_calls raid6_mmxx2;
+extern const struct raid6_calls raid6_sse1x1;
+extern const struct raid6_calls raid6_sse1x2;
+extern const struct raid6_calls raid6_sse2x1;
+extern const struct raid6_calls raid6_sse2x2;
+extern const struct raid6_calls raid6_sse2x4;
+extern const struct raid6_calls raid6_avx2x1;
+extern const struct raid6_calls raid6_avx2x2;
+extern const struct raid6_calls raid6_avx2x4;
+extern const struct raid6_calls raid6_avx512x1;
+extern const struct raid6_calls raid6_avx512x2;
+extern const struct raid6_calls raid6_avx512x4;
+
+extern const struct raid6_recov_calls raid6_recov_ssse3;
+extern const struct raid6_recov_calls raid6_recov_avx2;
+extern const struct raid6_recov_calls raid6_recov_avx512;
+
+static inline int raid6_has_avx512(void)
+{
+	return boot_cpu_has(X86_FEATURE_AVX2) &&
+		boot_cpu_has(X86_FEATURE_AVX) &&
+		boot_cpu_has(X86_FEATURE_AVX512F) &&
+		boot_cpu_has(X86_FEATURE_AVX512BW) &&
+		boot_cpu_has(X86_FEATURE_AVX512VL) &&
+		boot_cpu_has(X86_FEATURE_AVX512DQ);
+}
+
+static inline bool raid6_has_avx2(void)
+{
+	return boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX);
+}
+
+static inline bool raid6_has_ssse3(void)
+{
+	return boot_cpu_has(X86_FEATURE_XMM) &&
+		boot_cpu_has(X86_FEATURE_XMM2) &&
+		boot_cpu_has(X86_FEATURE_SSSE3);
+}
+
+static inline bool raid6_has_sse2(void)
+{
+	return boot_cpu_has(X86_FEATURE_MMX) &&
+		    boot_cpu_has(X86_FEATURE_FXSR) &&
+		    boot_cpu_has(X86_FEATURE_XMM) &&
+		    boot_cpu_has(X86_FEATURE_XMM2);
+}
+
+static inline bool raid6_has_sse1_or_mmxext(void)
+{
+	return boot_cpu_has(X86_FEATURE_MMX) &&
+		(boot_cpu_has(X86_FEATURE_XMM) ||
+		 boot_cpu_has(X86_FEATURE_MMXEXT));
+}
+
+static __always_inline void __init arch_raid6_init(void)
+{
+	if (raid6_has_avx2()) {
+		if (raid6_has_avx512()) {
+			raid6_algo_add(&raid6_avx512x1);
+			raid6_algo_add(&raid6_avx512x2);
+			if (IS_ENABLED(CONFIG_X86_64))
+				raid6_algo_add(&raid6_avx512x4);
+		}
+		raid6_algo_add(&raid6_avx2x1);
+		raid6_algo_add(&raid6_avx2x2);
+		if (IS_ENABLED(CONFIG_X86_64))
+			raid6_algo_add(&raid6_avx2x4);
+	} else if (IS_ENABLED(CONFIG_X86_64) || raid6_has_sse2()) {
+		/* x86_64 can assume SSE2 as baseline */
+		raid6_algo_add(&raid6_sse2x1);
+		raid6_algo_add(&raid6_sse2x2);
+		if (IS_ENABLED(CONFIG_X86_64))
+			raid6_algo_add(&raid6_sse2x4);
+	} else {
+		raid6_algo_add_default();
+		if (raid6_has_sse1_or_mmxext()) {
+			raid6_algo_add(&raid6_sse1x1);
+			raid6_algo_add(&raid6_sse1x2);
+		} else if (boot_cpu_has(X86_FEATURE_MMX)) {
+			raid6_algo_add(&raid6_mmxx1);
+			raid6_algo_add(&raid6_mmxx2);
+		}
+	}
+
+	if (raid6_has_avx512())
+		raid6_recov_algo_add(&raid6_recov_avx512);
+	else if (raid6_has_avx2())
+		raid6_recov_algo_add(&raid6_recov_avx2);
+	else if (raid6_has_ssse3())
+		raid6_recov_algo_add(&raid6_recov_ssse3);
+}
diff --git a/lib/raid/raid6/x86/recov_avx2.c b/lib/raid/raid6/x86/recov_avx2.c
index 06c6e05763bc..a714a780a2d8 100644
--- a/lib/raid/raid6/x86/recov_avx2.c
+++ b/lib/raid/raid6/x86/recov_avx2.c
@@ -9,12 +9,6 @@
 #include <asm/fpu/api.h>
 #include "algos.h"
 
-static int raid6_has_avx2(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) &&
-		boot_cpu_has(X86_FEATURE_AVX);
-}
-
 static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
 		int failb, void **ptrs)
 {
@@ -305,11 +299,9 @@ static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_avx2 = {
 	.data2 = raid6_2data_recov_avx2,
 	.datap = raid6_datap_recov_avx2,
-	.valid = raid6_has_avx2,
 #ifdef CONFIG_X86_64
 	.name = "avx2x2",
 #else
 	.name = "avx2x1",
 #endif
-	.priority = 2,
 };
diff --git a/lib/raid/raid6/x86/recov_avx512.c b/lib/raid/raid6/x86/recov_avx512.c
index 850bb962b514..ec72d5a30c01 100644
--- a/lib/raid/raid6/x86/recov_avx512.c
+++ b/lib/raid/raid6/x86/recov_avx512.c
@@ -11,16 +11,6 @@
 #include <asm/fpu/api.h>
 #include "algos.h"
 
-static int raid6_has_avx512(void)
-{
-	return boot_cpu_has(X86_FEATURE_AVX2) &&
-		boot_cpu_has(X86_FEATURE_AVX) &&
-		boot_cpu_has(X86_FEATURE_AVX512F) &&
-		boot_cpu_has(X86_FEATURE_AVX512BW) &&
-		boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		boot_cpu_has(X86_FEATURE_AVX512DQ);
-}
-
 static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 				     int failb, void **ptrs)
 {
@@ -369,11 +359,9 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_avx512 = {
 	.data2 = raid6_2data_recov_avx512,
 	.datap = raid6_datap_recov_avx512,
-	.valid = raid6_has_avx512,
 #ifdef CONFIG_X86_64
 	.name = "avx512x2",
 #else
 	.name = "avx512x1",
 #endif
-	.priority = 3,
 };
diff --git a/lib/raid/raid6/x86/recov_ssse3.c b/lib/raid/raid6/x86/recov_ssse3.c
index 95589c33003a..700bd2c865ec 100644
--- a/lib/raid/raid6/x86/recov_ssse3.c
+++ b/lib/raid/raid6/x86/recov_ssse3.c
@@ -8,13 +8,6 @@
 #include <asm/fpu/api.h>
 #include "algos.h"
 
-static int raid6_has_ssse3(void)
-{
-	return boot_cpu_has(X86_FEATURE_XMM) &&
-		boot_cpu_has(X86_FEATURE_XMM2) &&
-		boot_cpu_has(X86_FEATURE_SSSE3);
-}
-
 static void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila,
 		int failb, void **ptrs)
 {
@@ -320,11 +313,9 @@ static void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila,
 const struct raid6_recov_calls raid6_recov_ssse3 = {
 	.data2 = raid6_2data_recov_ssse3,
 	.datap = raid6_datap_recov_ssse3,
-	.valid = raid6_has_ssse3,
 #ifdef CONFIG_X86_64
 	.name = "ssse3x2",
 #else
 	.name = "ssse3x1",
 #endif
-	.priority = 1,
 };
diff --git a/lib/raid/raid6/x86/sse1.c b/lib/raid/raid6/x86/sse1.c
index 7004255a0bb1..6ebdcf824e00 100644
--- a/lib/raid/raid6/x86/sse1.c
+++ b/lib/raid/raid6/x86/sse1.c
@@ -25,14 +25,6 @@ extern const struct raid6_mmx_constants {
 	u64 x1d;
 } raid6_mmx_constants;
 
-static int raid6_have_sse1_or_mmxext(void)
-{
-	/* Not really boot_cpu but "all_cpus" */
-	return boot_cpu_has(X86_FEATURE_MMX) &&
-		(boot_cpu_has(X86_FEATURE_XMM) ||
-		 boot_cpu_has(X86_FEATURE_MMXEXT));
-}
-
 /*
  * Plain SSE1 implementation
  */
@@ -86,9 +78,7 @@ static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_sse1x1 = {
 	.gen_syndrome	= raid6_sse11_gen_syndrome,
-	.valid		= raid6_have_sse1_or_mmxext,
 	.name		= "sse1x1",
-	.priority	= 1,	/* Has cache hints */
 };
 
 /*
@@ -148,7 +138,5 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_sse1x2 = {
 	.gen_syndrome	= raid6_sse12_gen_syndrome,
-	.valid		= raid6_have_sse1_or_mmxext,
 	.name		= "sse1x2",
-	.priority	= 1,	/* Has cache hints */
 };
diff --git a/lib/raid/raid6/x86/sse2.c b/lib/raid/raid6/x86/sse2.c
index f30be4ee14d0..7049c8512f35 100644
--- a/lib/raid/raid6/x86/sse2.c
+++ b/lib/raid/raid6/x86/sse2.c
@@ -22,15 +22,6 @@ static const struct raid6_sse_constants {
 	{ 0x1d1d1d1d1d1d1d1dULL, 0x1d1d1d1d1d1d1d1dULL },
 };
 
-static int raid6_have_sse2(void)
-{
-	/* Not really boot_cpu but "all_cpus" */
-	return boot_cpu_has(X86_FEATURE_MMX) &&
-		boot_cpu_has(X86_FEATURE_FXSR) &&
-		boot_cpu_has(X86_FEATURE_XMM) &&
-		boot_cpu_has(X86_FEATURE_XMM2);
-}
-
 /*
  * Plain SSE2 implementation
  */
@@ -136,9 +127,7 @@ static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_sse2x1 = {
 	.gen_syndrome	= raid6_sse21_gen_syndrome,
 	.xor_syndrome	= raid6_sse21_xor_syndrome,
-	.valid		= raid6_have_sse2,
 	.name		= "sse2x1",
-	.priority	= 1,	/* Has cache hints */
 };
 
 /*
@@ -266,9 +255,7 @@ static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_sse2x2 = {
 	.gen_syndrome	= raid6_sse22_gen_syndrome,
 	.xor_syndrome	= raid6_sse22_xor_syndrome,
-	.valid		= raid6_have_sse2,
 	.name		= "sse2x2",
-	.priority	= 1,	/* Has cache hints */
 };
 
 #ifdef CONFIG_X86_64
@@ -473,9 +460,7 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 const struct raid6_calls raid6_sse2x4 = {
 	.gen_syndrome	= raid6_sse24_gen_syndrome,
 	.xor_syndrome	= raid6_sse24_xor_syndrome,
-	.valid		= raid6_have_sse2,
 	.name		= "sse2x4",
-	.priority	= 1,	/* Has cache hints */
 };
 
 #endif /* CONFIG_X86_64 */
-- 
2.53.0

