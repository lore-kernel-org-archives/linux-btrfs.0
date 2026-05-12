Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD4733DED5;
	Tue, 12 May 2026 05:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563474; cv=none; b=fYSnevJ5tlBsP8hbqO60/x4pStyPe82WGzycSKcLflleiKV+8dFcCtb4XH19m7xPr8tXiOiA6sogHk+in/B+GWotfvXSZcyk22UoiMsUkdqTo2bpfB9MR41HYooK5wQoSMZ4WenlULEB7u8KvNXsy/thmdCR3jAsBxhcTJpknD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563474; c=relaxed/simple;
	bh=tlr9tmsF1UaTOyjU5gr3TKD92FYp4B4w7OcFvGhFNuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd1H+Ci10uTyWG4VyJUtVxonIkR0As7hJUUeRYcLWIiENEvuIVzliYJhYztflWNQnmTEu7NjV45+jmGHIACzasVHoaCPRw/lwU0+csTT4yaWXxko0EJrVtO3F27g0JXfC1ws/n2ytGRfGvdddg6dg1haltcXm7udDMldtB3Flg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oIieckFB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oIieckFB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=geqc96SELgbz2znYeMENdveDPnpttdiIfioEj3emgdc=; b=oIieckFBBIzjjYlWK2v7afryWQ
	QxAXpY054M7qrl5h9YjqIT0er1mVZsdjwPevo9cwBKX2z+vpjKwDAkdwsJxiduE+yTc/iZkEjFtac
	fquBP8Dy/o3ngYCqZIAmELgsrQIBgqUjcXfu/hAQxNs8yWCl9ZIPPnK68F0x8gZWKOOylnIVQxi5X
	WOJo+J6oSCzo6eWYDZqbBVxu52geeu2SwYGDN2dXs8NwJXtbIMcp7DLx2qXivCnnJBPG5iTOXgfQF
	0fXtEUHpF/u4VWJ09uoy+uxA6ElN4ZrMd6gCvnHSk/7JughsZZ/Bi+aBLZxPf8XVHKfiAICC43u3x
	XgszlDAA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfbC-0000000FbY0-0qyj;
	Tue, 12 May 2026 05:24:06 +0000
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
Subject: [PATCH 08/19] raid6: improve the public interface
Date: Tue, 12 May 2026 07:20:48 +0200
Message-ID: <20260512052230.2947683-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512052230.2947683-1-hch@lst.de>
References: <20260512052230.2947683-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Stop directly calling into function pointers from users of the RAID6 PQ
API, and provide exported functions with proper documentation and
API guarantees asserts where applicable instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/crypto/async-tx-api.rst         |   4 +-
 crypto/async_tx/async_pq.c                    |   6 +-
 crypto/async_tx/async_raid6_recov.c           |   4 +-
 drivers/md/raid5.c                            |   4 +-
 fs/btrfs/raid56.c                             |   8 +-
 include/linux/raid/pq.h                       |  28 ++--
 lib/raid/raid6/algos.c                        | 139 +++++++++++++++++-
 lib/raid/raid6/arm/recov_neon.c               |   4 +-
 .../raid6/loongarch/recov_loongarch_simd.c    |   8 +-
 lib/raid/raid6/recov.c                        |   4 +-
 lib/raid/raid6/riscv/recov_rvv.c              |   4 +-
 lib/raid/raid6/s390/recov_s390xc.c            |   4 +-
 lib/raid/raid6/x86/recov_avx2.c               |   4 +-
 lib/raid/raid6/x86/recov_avx512.c             |   4 +-
 lib/raid/raid6/x86/recov_ssse3.c              |   4 +-
 15 files changed, 181 insertions(+), 48 deletions(-)

diff --git a/Documentation/crypto/async-tx-api.rst b/Documentation/crypto/async-tx-api.rst
index f88a7809385e..49fcfc66314a 100644
--- a/Documentation/crypto/async-tx-api.rst
+++ b/Documentation/crypto/async-tx-api.rst
@@ -82,9 +82,9 @@ xor_val   xor a series of source buffers and set a flag if the
 pq	  generate the p+q (raid6 syndrome) from a series of source buffers
 pq_val    validate that a p and or q buffer are in sync with a given series of
 	  sources
-datap	  (raid6_datap_recov) recover a raid6 data block and the p block
+datap	  (raid6_recov_datap) recover a raid6 data block and the p block
 	  from the given sources
-2data	  (raid6_2data_recov) recover 2 raid6 data blocks from the given
+2data	  (raid6_recov_2data) recover 2 raid6 data blocks from the given
 	  sources
 ========  ====================================================================
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 0ce6f07b4e0d..f3574f80d1df 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -131,11 +131,11 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		}
 	}
 	if (submit->flags & ASYNC_TX_PQ_XOR_DST) {
-		BUG_ON(!raid6_call.xor_syndrome);
+		BUG_ON(!raid6_can_xor_syndrome());
 		if (start >= 0)
-			raid6_call.xor_syndrome(disks, start, stop, len, srcs);
+			raid6_xor_syndrome(disks, start, stop, len, srcs);
 	} else
-		raid6_call.gen_syndrome(disks, len, srcs);
+		raid6_gen_syndrome(disks, len, srcs);
 	async_tx_sync_epilog(submit);
 }
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index f2dc6af6e6a7..305ea1421a3e 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -418,7 +418,7 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
-		raid6_2data_recov(disks, bytes, faila, failb, ptrs);
+		raid6_recov_2data(disks, bytes, faila, failb, ptrs);
 
 		async_tx_sync_epilog(submit);
 
@@ -501,7 +501,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
-		raid6_datap_recov(disks, bytes, faila, ptrs);
+		raid6_recov_datap(disks, bytes, faila, ptrs);
 
 		async_tx_sync_epilog(submit);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d76e82f4506..ebcb19317670 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6955,7 +6955,7 @@ raid5_store_rmw_level(struct mddev  *mddev, const char *page, size_t len)
 	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
 
-	if (new != PARITY_DISABLE_RMW && !raid6_call.xor_syndrome)
+	if (new != PARITY_DISABLE_RMW && !raid6_can_xor_syndrome())
 		return -EINVAL;
 
 	if (new != PARITY_DISABLE_RMW &&
@@ -7646,7 +7646,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	conf->level = mddev->new_level;
 	if (conf->level == 6) {
 		conf->max_degraded = 2;
-		if (raid6_call.xor_syndrome)
+		if (raid6_can_xor_syndrome())
 			conf->rmw_level = PARITY_ENABLE_RMW;
 		else
 			conf->rmw_level = PARITY_DISABLE_RMW;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 08ee8f316d96..dabc9522e881 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1410,7 +1410,7 @@ static void generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsigned int
 				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
 
 		assert_rbio(rbio);
-		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
 	} else {
 		/* raid5 */
 		memcpy(pointers[rbio->nr_data], pointers[0], step);
@@ -1987,10 +1987,10 @@ static void recover_vertical_step(struct btrfs_raid_bio *rbio,
 		}
 
 		if (failb == rbio->real_stripes - 2) {
-			raid6_datap_recov(rbio->real_stripes, step,
+			raid6_recov_datap(rbio->real_stripes, step,
 					  faila, pointers);
 		} else {
-			raid6_2data_recov(rbio->real_stripes, step,
+			raid6_recov_2data(rbio->real_stripes, step,
 					  faila, failb, pointers);
 		}
 	} else {
@@ -2644,7 +2644,7 @@ static bool verify_one_parity_step(struct btrfs_raid_bio *rbio,
 	if (has_qstripe) {
 		assert_rbio(rbio);
 		/* RAID6, call the library function to fill in our P/Q. */
-		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
 	} else {
 		/* RAID5. */
 		memcpy(pointers[nr_data], pointers[0], step);
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index f27a866c287f..662c2669f63f 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -11,6 +11,25 @@
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 
+/*
+ * While the RAID6 algorithm could in theory support 3 devices by just copying
+ * the data disk to the two parity disks, this configuration is not only useless
+ * because it is a suboptimal version of 3-way mirroring, but also easy to get
+ * wrong in architecture-optimized implementations due to special casing, so
+ * don't support it.
+ */
+#define RAID6_MIN_DISKS		4
+
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
+void raid6_xor_syndrome(int disks, int start, int stop, size_t bytes,
+		void **ptrs);
+bool raid6_can_xor_syndrome(void);
+
+void raid6_recov_2data(int disks, size_t bytes, int faila, int failb,
+		void **ptrs);
+void raid6_recov_datap(int disks, size_t bytes, int faila,
+		void **ptrs);
+
 /* Routine choices */
 struct raid6_calls {
 	void (*gen_syndrome)(int, size_t, void **);
@@ -20,9 +39,6 @@ struct raid6_calls {
 	int priority;		/* Relative priority ranking if non-zero */
 };
 
-/* Selected algorithm */
-extern struct raid6_calls raid6_call;
-
 /* Various routine sets */
 extern const struct raid6_calls raid6_intx1;
 extern const struct raid6_calls raid6_intx2;
@@ -92,10 +108,4 @@ extern const u8 raid6_gflog[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
 
-/* Recovery routines */
-extern void (*raid6_2data_recov)(int disks, size_t bytes, int faila, int failb,
-		       void **ptrs);
-extern void (*raid6_datap_recov)(int disks, size_t bytes, int faila,
-			void **ptrs);
-
 #endif /* LINUX_RAID_RAID6_H */
diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index 985c60bb00a4..683b97cb94ad 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -16,8 +16,85 @@
 #include <linux/gfp.h>
 #include <kunit/visibility.h>
 
-struct raid6_calls raid6_call;
-EXPORT_SYMBOL_GPL(raid6_call);
+static const struct raid6_recov_calls *raid6_recov_algo;
+
+/* Selected algorithm */
+static struct raid6_calls raid6_call;
+
+/**
+ * raid6_gen_syndrome - generate RAID6 P/Q parity
+ * @disks:	number of "disks" to operate on including parity
+ * @bytes:	length in bytes of each vector
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Generate @bytes worth of RAID6 P and Q parity in @ptrs[@disks - 2] and
+ * @ptrs[@disks - 1] respectively from the memory pointed to by @ptrs[0] to
+ * @ptrs[@disks - 3].
+ *
+ * @disks must be at least 3, and the memory pointed to by each member of @ptrs
+ * must be at least 64-byte aligned.  @bytes must be non-zero and a multiple of
+ * 512.
+ *
+ * See https://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf for underlying
+ * algorithm.
+ */
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(disks < RAID6_MIN_DISKS);
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_gen_syndrome);
+
+/**
+ * raid6_xor_syndrome - update RAID6 P/Q parity
+ * @disks:	number of "disks" to operate on including parity
+ * @start:	first index into @disk to update
+ * @stop:	last index into @disk to update
+ * @bytes:	length in bytes of each vector
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Update @bytes worth of RAID6 P and Q parity in @ptrs[@disks - 2] and
+ * @ptrs[@disks - 1] respectively for the memory pointed to by
+ * @ptrs[@start..@stop].
+ *
+ * This is used to update parity in place using the following sequence:
+ *
+ * 1) call raid6_xor_syndrome(disk, start, stop, ...) for the existing data.
+ * 2) update the the data in @ptrs[@start..@stop].
+ * 3) call raid6_xor_syndrome(disk, start, stop, ...) for the new data.
+ *
+ * Data between @start and @stop that is not changed should be filled
+ * with a pointer to the kernel zero page.
+ *
+ * @disks must be at least 3, and the memory pointed to by each member of @ptrs
+ * must be at least 64-byte aligned.  @bytes must be non-zero and a multiple of
+ * 512.  @stop must be larger or equal to @start.
+ */
+void raid6_xor_syndrome(int disks, int start, int stop, size_t bytes,
+		void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(disks < RAID6_MIN_DISKS);
+	WARN_ON_ONCE(stop < start);
+
+	raid6_call.xor_syndrome(disks, start, stop, bytes, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_xor_syndrome);
+
+/*
+ * raid6_can_xor_syndrome - check if raid6_xor_syndrome() can be used
+ *
+ * Returns %true if raid6_can_xor_syndrome() can be used, else %false.
+ */
+bool raid6_can_xor_syndrome(void)
+{
+	return !!raid6_call.xor_syndrome;
+}
+EXPORT_SYMBOL_GPL(raid6_can_xor_syndrome);
 
 const struct raid6_calls * const raid6_algos[] = {
 #if defined(__i386__) && !defined(__arch_um__)
@@ -84,11 +161,58 @@ const struct raid6_calls * const raid6_algos[] = {
 };
 EXPORT_SYMBOL_IF_KUNIT(raid6_algos);
 
-void (*raid6_2data_recov)(int, size_t, int, int, void **);
-EXPORT_SYMBOL_GPL(raid6_2data_recov);
+/**
+ * raid6_recov_2data - recover two missing data disks
+ * @disks:	number of "disks" to operate on including parity
+ * @bytes:	length in bytes of each vector
+ * @faila:	first failed data disk index
+ * @failb:	second failed data disk index
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Rebuild @bytes of missing data in @ptrs[@faila] and @ptrs[@failb] from the
+ * data in the remaining disks and the two parities pointed to by the other
+ * indices between 0 and @disks - 1 in @ptrs.  @disks includes the data disks
+ * and the two parities.  @faila must be smaller than @failb.
+ *
+ * Memory pointed to by each pointer in @ptrs must be page aligned and is
+ * limited to %PAGE_SIZE.
+ */
+void raid6_recov_2data(int disks, size_t bytes, int faila, int failb,
+		void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(bytes > PAGE_SIZE);
+	WARN_ON_ONCE(failb <= faila);
+
+	raid6_recov_algo->data2(disks, bytes, faila, failb, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_recov_2data);
+
+/**
+ * raid6_recov_datap - recover a missing data disk and missing P-parity
+ * @disks:	number of "disks" to operate on including parity
+ * @bytes:	length in bytes of each vector
+ * @faila:	failed data disk index
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Rebuild @bytes of missing data in @ptrs[@faila] and the missing P-parity in
+ * @ptrs[@disks - 2] from the data in the remaining disks and the Q-parity
+ * pointed to by the other indices between 0 and @disks - 1 in @ptrs.  @disks
+ * includes the data disks and the two parities.
+ *
+ * Memory pointed to by each pointer in @ptrs must be page aligned and is
+ * limited to %PAGE_SIZE.
+ */
+void raid6_recov_datap(int disks, size_t bytes, int faila, void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(bytes > PAGE_SIZE);
 
-void (*raid6_datap_recov)(int, size_t, int, void **);
-EXPORT_SYMBOL_GPL(raid6_datap_recov);
+	raid6_recov_algo->datap(disks, bytes, faila, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
 const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #ifdef CONFIG_X86
@@ -133,8 +257,7 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 				best = *algo;
 
 	if (best) {
-		raid6_2data_recov = best->data2;
-		raid6_datap_recov = best->datap;
+		raid6_recov_algo = best;
 
 		pr_info("raid6: using %s recovery algorithm\n", best->name);
 	} else
diff --git a/lib/raid/raid6/arm/recov_neon.c b/lib/raid/raid6/arm/recov_neon.c
index 9993bda5d3a6..4eb0efb44750 100644
--- a/lib/raid/raid6/arm/recov_neon.c
+++ b/lib/raid/raid6/arm/recov_neon.c
@@ -35,7 +35,7 @@ static void raid6_2data_recov_neon(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dp;
@@ -69,7 +69,7 @@ static void raid6_datap_recov_neon(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dq;
diff --git a/lib/raid/raid6/loongarch/recov_loongarch_simd.c b/lib/raid/raid6/loongarch/recov_loongarch_simd.c
index 4d4563209647..7d4d349322b3 100644
--- a/lib/raid/raid6/loongarch/recov_loongarch_simd.c
+++ b/lib/raid/raid6/loongarch/recov_loongarch_simd.c
@@ -49,7 +49,7 @@ static void raid6_2data_recov_lsx(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dp;
@@ -201,7 +201,7 @@ static void raid6_datap_recov_lsx(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dq;
@@ -323,7 +323,7 @@ static void raid6_2data_recov_lasx(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dp;
@@ -440,7 +440,7 @@ static void raid6_datap_recov_lasx(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dq;
diff --git a/lib/raid/raid6/recov.c b/lib/raid/raid6/recov.c
index 211e1df28963..cc7e4dc1eaa6 100644
--- a/lib/raid/raid6/recov.c
+++ b/lib/raid/raid6/recov.c
@@ -37,7 +37,7 @@ static void raid6_2data_recov_intx1(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -75,7 +75,7 @@ static void raid6_datap_recov_intx1(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
diff --git a/lib/raid/raid6/riscv/recov_rvv.c b/lib/raid/raid6/riscv/recov_rvv.c
index f77d9c430687..3ff39826e33f 100644
--- a/lib/raid/raid6/riscv/recov_rvv.c
+++ b/lib/raid/raid6/riscv/recov_rvv.c
@@ -164,7 +164,7 @@ static void raid6_2data_recov_rvv(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dp;
@@ -199,7 +199,7 @@ static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dq;
diff --git a/lib/raid/raid6/s390/recov_s390xc.c b/lib/raid/raid6/s390/recov_s390xc.c
index 0f32217b7123..2bc4c85174de 100644
--- a/lib/raid/raid6/s390/recov_s390xc.c
+++ b/lib/raid/raid6/s390/recov_s390xc.c
@@ -40,7 +40,7 @@ static void raid6_2data_recov_s390xc(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -84,7 +84,7 @@ static void raid6_datap_recov_s390xc(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
diff --git a/lib/raid/raid6/x86/recov_avx2.c b/lib/raid/raid6/x86/recov_avx2.c
index 325310c81e1c..bef82a38d8eb 100644
--- a/lib/raid/raid6/x86/recov_avx2.c
+++ b/lib/raid/raid6/x86/recov_avx2.c
@@ -34,7 +34,7 @@ static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -199,7 +199,7 @@ static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
diff --git a/lib/raid/raid6/x86/recov_avx512.c b/lib/raid/raid6/x86/recov_avx512.c
index 08de77fcb8bd..06c70e771eaa 100644
--- a/lib/raid/raid6/x86/recov_avx512.c
+++ b/lib/raid/raid6/x86/recov_avx512.c
@@ -43,7 +43,7 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -241,7 +241,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
diff --git a/lib/raid/raid6/x86/recov_ssse3.c b/lib/raid/raid6/x86/recov_ssse3.c
index 002bef1e0847..5ca7d56f23d8 100644
--- a/lib/raid/raid6/x86/recov_ssse3.c
+++ b/lib/raid/raid6/x86/recov_ssse3.c
@@ -36,7 +36,7 @@ static void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila,
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -206,7 +206,7 @@ static void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila,
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
-- 
2.53.0

