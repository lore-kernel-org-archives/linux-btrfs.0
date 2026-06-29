Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302533343B
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 02:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782700758; cv=none; b=j12UyUoGJgJgDfDaINz+Z3B5PsxD1AxcTyf5Ideki0oPN4yDVwNCIoay6zyXcupVISb3iIshFnAJdh8yy7YP8VP05B5VaswUWbLRbEt+7G5oIwDmM4x7HjvrLUrmz+4k5El8sLArjTDR6dWSHupisowkEz13seNA5UblSpCBxug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782700758; c=relaxed/simple;
	bh=ARQgQi8QHRkUt4tpuApWPLiM3dT8EsiLh0JZGiMzVyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QcEfilqvLwAKr5HjKXI3CkhY28wNlmdE+rpa0RQALFTgl7BdO93VT3jVQW5Qo1GBU88FGKG7Aqm8v17C8txRCH/AhVg00mkkzBhi1/bTdzp+0oPon+Ss+EzM0bYNRdiZN6+ohDBgCAIU4mH96yWe3m53QuWuUu94v0MUr6m05OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qDIRAkqP; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qDIRAkqP"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ca06ad2d11so2667635ad.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 19:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782700754; x=1783305554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KNTC1FLkJjz1ad93Znd800b/zEVFRKc//JlZGoUiWD8=;
        b=qDIRAkqPa6Diz/6nmVuMTCjAtQd9xcLCx7OI3SN7UY9JwjDSEwP37mtIywsVuV3FBn
         Sy0CfFuKEYEYzBZqF6QjZYaNwwN52/PkWDb8/A8w9wSTNFz3bTVKr0uZsrZfql2bzPRu
         2TnL6mv6QGDHU6D2aauRgZqq8V6wOx0DJH8rWX5ni8rvgIPPLDj+OEh970aFKiB6cKub
         HWaeS8tIXC6jaWR76sp+dF+HxU3X+0xLbz+FQfLXfmqURVUYmIxQYtOckfTqmqYwnPQf
         +O4QJuX5Pasde1TVjd0w0zXwWyOTP6l2lbakUK4do5ref2mi3NeTowJEKdwDh4enG/Om
         YAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782700754; x=1783305554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNTC1FLkJjz1ad93Znd800b/zEVFRKc//JlZGoUiWD8=;
        b=DU/IeCkAjt++5d6ilTRJcfL+d9ScjsN+stsYrNAP4bUy/mu8985n+6vVWOh+V2JXbw
         tCbsGbTNvsQQDiWqg057HWOKuQ9lr6hWddA8o6ddK9Xcqn4R3Un+4wgVPgsSarlvGlz5
         vcbynC4JaNYJ9wmc2eg6Ab02YmkjEFanNgjZLO9qFHXway2vV81ZLtesAD5W+PMZq1Ci
         AUAP4QPP/pnEOP2h3CqvrwsCp4ixOb+7fg8Dkvn/QU8X8GfTyk7qhfn6XPI9vEaMoVEk
         nEZ13tTQ0NAG8dU+ADbMT/CJvOmfYU0vmnyEWl787LjA1tmfIVnRg10Md2thUNWioKkw
         EdgQ==
X-Gm-Message-State: AOJu0YyKYoGqOcrrV1hzNFc+eNeHq+EEIA0FU0O8aUoQrtfcXuvpRG31
	P5Uc4ph7ZUw3wtK5IkIWCbYGNK+KOok7e/Fh6IJRzZSPBmMr7212flnIz8m19A==
X-Gm-Gg: AfdE7ckgS+PpLjZUCTbYcfpNBsiabBp8bJGc1TlJilLFgONr1xIBF+4ikUV7t0ShCmU
	kqDijtP73S/qTk3SchOtblzf5rXh1ioUW8f+Uxuv5pxerKIrGChAfjNf+iRTCR8GyTHoUbQEpDJ
	cBACjT1otooXSXLRSTIOba1cq1ihs0xV2aONn+gxLm/8lNzK30fhZYds1Bmj8hPsscOCP9yhpQO
	qrqmHaTN3KCXY2UEraWl5tXlM2aw/IDMy6EKaILiDqJQUuD5v0ZO+qQ70yun5xuXj6HaHeTYmNp
	kEjz7oJmE0zPV7xSR+bfhVMTArmPImPLe7APfFlisPbUJKFhF3ibdp28OKaqr0QK0KTfdZa+fS5
	8pAZGho4QDrrvGFvx+6cOjhRKsem1N1N7IHmMZC7tkA81luA+xgKS1z8gOY3uDFUFGa6a5q5+yg
	07ucVVy8ExwtYTCphRNDh8YdDFP7KuEhEn2EYO9E5/9vzsFvrdV40fjSS8P+RyYf3rSu11F3IQS
	YdJP7DKVDP2KF++4N1n
X-Received: by 2002:a17:903:124c:b0:2c9:a5e9:c26e with SMTP id d9443c01a7336-2c9a5e9c44fmr77824955ad.13.1782700754128;
        Sun, 28 Jun 2026 19:39:14 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c8255602fcsm49666395ad.60.2026.06.28.19.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 19:39:13 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] btrfs: raid56: use async_tx API for parity operations
Date: Sun, 28 Jun 2026 19:39:12 -0700
Message-ID: <20260629023912.2102700-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the kmap-local + synchronous library call + kunmap-local
pattern in raid56 compute and recovery paths with the async_tx API
(async_xor_offs, async_gen_syndrome, async_raid6_datap_recov,
async_raid6_2data_recov, async_memcpy).  The async_tx API provides
DMA offloading when a suitable engine is available and falls back to
the same software implementations (xor_gen, raid6_gen_syndrome, etc.)
otherwise.

Step-loop operations inside each vertical stripe are chained as DMA
dependency chains with ASYNC_TX_FENCE.  The chains are then extended
across all sectors in a stripe so that the DMA engine can pipeline
the entire stripe's parity computation before the CPU waits for
completion.  For RMW writes, all sectors' parity generation is
issued as a single chain; for recovery reads, the recovery chains
for every sector are submitted together, then the CPU verifies
checksums and marks uptodate bits after a single wait.

Each DMA chain is fully waited on before the caller touches any
buffer pages, so there is never an in-flight DMA operation during
cleanup.  For the typical stripe size of 4 KiB--64 KiB, per-operation
overhead from DMA submission may outweigh the offload benefit, making
the software fallback (which runs synchronously, returning NULL) the
common fast path.  This trade-off is inherent in the async_tx API's
unified interface, but on platforms with a DMA engine (e.g. Marvell
mv_xor) and larger sectors the batching provides measurable offload.

Also select ASYNC_RAID6_RECOV and ASYNC_MEMCPY in Kconfig so that
the async_tx function implementations are linked; previously the
code used the synchronous RAID6_PQ / XOR_BLOCKS libraries directly,
but async_tx functions require their own Kconfig symbols.

Converted functions:
  - generate_pq_vertical_step() / generate_pq_vertical()
  - recover_vertical_step() / recover_vertical() / recover_sectors()
  - verify_one_parity_step() / verify_one_parity_sector()
  - finish_parity_scrub()
  - recover_scrub_rbio()
  - memcpy_from_bio_to_stripe()
  - raid56_parity_cache_data_folios()

Removed the now-unused btrfs_raid_bio::finish_pointers field and
the no-longer-needed #include <linux/raid/pq.h> and
#include <linux/raid/xor.h>.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 fs/btrfs/Kconfig  |   4 +-
 fs/btrfs/raid56.c | 654 ++++++++++++++++++++++++++++++++--------------
 fs/btrfs/raid56.h |   3 -
 3 files changed, 454 insertions(+), 207 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 43dd8ef763b8..8223b40d8ecb 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -15,7 +15,9 @@ config BTRFS_FS
 	select ZSTD_DECOMPRESS
 	select FS_IOMAP
 	select RAID6_PQ
-	select XOR_BLOCKS
+	select ASYNC_RAID6_RECOV
+	select ASYNC_MEMCPY
+	select ASYNC_XOR
 	select XXHASH
 	depends on PAGE_SIZE_LESS_THAN_256KB
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 00a01b97cc0c..6e98e46df752 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -8,11 +8,10 @@
 #include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/raid/pq.h>
 #include <linux/hash.h>
 #include <linux/list_sort.h>
-#include <linux/raid/xor.h>
 #include <linux/mm.h>
+#include <linux/async_tx.h>
 #include "messages.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -154,7 +153,6 @@ static void free_raid_bio_pointers(struct btrfs_raid_bio *rbio)
 	kfree(rbio->stripe_pages);
 	kfree(rbio->bio_paddrs);
 	kfree(rbio->stripe_paddrs);
-	kfree(rbio->finish_pointers);
 }
 
 static void free_raid_bio(struct btrfs_raid_bio *rbio)
@@ -231,18 +229,33 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 static void memcpy_from_bio_to_stripe(struct btrfs_raid_bio *rbio, unsigned int sector_nr)
 {
 	const u32 step = min(rbio->bioc->fs_info->sectorsize, PAGE_SIZE);
+	struct dma_async_tx_descriptor *tx = NULL;
 
 	ASSERT(sector_nr < rbio->nr_sectors);
 	for (int i = 0; i < rbio->sector_nsteps; i++) {
 		unsigned int index = sector_nr * rbio->sector_nsteps + i;
 		phys_addr_t dst = rbio->stripe_paddrs[index];
 		phys_addr_t src = rbio->bio_paddrs[index];
+		struct async_submit_ctl submit;
 
 		ASSERT(dst != INVALID_PADDR);
 		ASSERT(src != INVALID_PADDR);
 
-		memcpy_page(phys_to_page(dst), offset_in_page(dst),
-			    phys_to_page(src), offset_in_page(src), step);
+		init_async_submit(&submit, ASYNC_TX_FENCE, tx, NULL, NULL, NULL);
+		tx = async_memcpy(phys_to_page(dst), phys_to_page(src),
+				  offset_in_page(dst), offset_in_page(src),
+				  step, &submit);
+	}
+	/*
+	 * All steps are chained via ASYNC_TX_FENCE.  issue_pending and
+	 * dma_wait_for_async_tx on the last descriptor walk the entire
+	 * chain, so earlier descriptors are submitted and waited on too.
+	 * If every step completed synchronously, tx is NULL and no wait
+	 * is needed.
+	 */
+	if (tx) {
+		async_tx_issue_pending(tx);
+		dma_wait_for_async_tx(tx);
 	}
 }
 
@@ -1079,12 +1092,11 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	rbio->stripe_paddrs = kzalloc_objs(phys_addr_t,
 					   num_sectors * sector_nsteps,
 					   GFP_NOFS);
-	rbio->finish_pointers = kcalloc(real_stripes, sizeof(void *), GFP_NOFS);
 	rbio->error_bitmap = bitmap_zalloc(num_sectors, GFP_NOFS);
 	rbio->stripe_uptodate_bitmap = bitmap_zalloc(num_sectors, GFP_NOFS);
 
 	if (!rbio->stripe_pages || !rbio->bio_paddrs || !rbio->stripe_paddrs ||
-	    !rbio->finish_pointers || !rbio->error_bitmap || !rbio->stripe_uptodate_bitmap) {
+	    !rbio->error_bitmap || !rbio->stripe_uptodate_bitmap) {
 		free_raid_bio_pointers(rbio);
 		kfree(rbio);
 		return ERR_PTR(-ENOMEM);
@@ -1385,49 +1397,98 @@ static inline void *kmap_local_paddr(phys_addr_t paddr)
 	return kmap_local_page(phys_to_page(paddr)) + offset_in_page(paddr);
 }
 
-static void generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsigned int sector_nr,
-				      unsigned int step_nr)
+/*
+ * The page/offset array model used by the async_tx helpers below replaces the
+ * old kmap-local pointer array.  Each entry in pages[] + offsets[] represents
+ * what was previously a single kmap_local_paddr() return value.
+ *
+ * For example, the old pattern:
+ *   pointers[i] = kmap_local_paddr(paddr);
+ *   raid6_gen_syndrome(..., pointers);
+ *   kunmap_local(pointers[i]);
+ *
+ * becomes:
+ *   pages[i] = phys_to_page(paddr);
+ *   offsets[i] = offset_in_page(paddr);
+ *   async_gen_syndrome(pages, offsets, ...);
+ *
+ * The async_tx API handles any necessary kmap internally.
+ */
+
+/*
+ * Maximum number of sectors per stripe.
+ * BTRFS_STRIPE_LEN (64 KiB) divided by the minimum sector size (PAGE_SIZE,
+ * typically 4 KiB) gives at most 16 entries.  If stripe length ever changes,
+ * update this to BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits.
+ */
+#define RECOVER_MAX_STRIPE_SECTORS 16
+static struct dma_async_tx_descriptor *
+generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsigned int sector_nr,
+			  unsigned int step_nr,
+			  struct page **pages, unsigned int *offsets,
+			  struct dma_async_tx_descriptor *depend_tx)
 {
-	void **pointers = rbio->finish_pointers;
 	const u32 step = min(rbio->bioc->fs_info->sectorsize, PAGE_SIZE);
-	int stripe;
 	const bool has_qstripe = rbio->bioc->map_type & BTRFS_BLOCK_GROUP_RAID6;
+	struct async_submit_ctl submit;
+	struct dma_async_tx_descriptor *tx;
+	int stripe;
 
-	/* First collect one sector from each data stripe */
-	for (stripe = 0; stripe < rbio->nr_data; stripe++)
-		pointers[stripe] = kmap_local_paddr(
-				sector_paddr_in_rbio(rbio, stripe, sector_nr, step_nr, 0));
+	for (stripe = 0; stripe < rbio->nr_data; stripe++) {
+		phys_addr_t paddr = sector_paddr_in_rbio(rbio, stripe, sector_nr, step_nr, 0);
 
-	/* Then add the parity stripe */
-	pointers[stripe++] = kmap_local_paddr(rbio_pstripe_paddr(rbio, sector_nr, step_nr));
+		pages[stripe] = phys_to_page(paddr);
+		offsets[stripe] = offset_in_page(paddr);
+	}
+
+	{
+		phys_addr_t paddr = rbio_pstripe_paddr(rbio, sector_nr, step_nr);
+
+		pages[stripe] = phys_to_page(paddr);
+		offsets[stripe] = offset_in_page(paddr);
+	}
+	stripe++;
 
 	if (has_qstripe) {
-		/*
-		 * RAID6, add the qstripe and call the library function
-		 * to fill in our p/q
-		 */
-		pointers[stripe++] = kmap_local_paddr(
-				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
+		phys_addr_t paddr = rbio_qstripe_paddr(rbio, sector_nr, step_nr);
+
+		pages[stripe] = phys_to_page(paddr);
+		offsets[stripe] = offset_in_page(paddr);
 
 		assert_rbio(rbio);
-		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
+		init_async_submit(&submit, ASYNC_TX_FENCE, depend_tx, NULL, NULL, NULL);
+		tx = async_gen_syndrome(pages, offsets, rbio->real_stripes, step, &submit);
 	} else {
-		/* raid5 */
-		memcpy(pointers[rbio->nr_data], pointers[0], step);
-		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
-				step);
+		init_async_submit(&submit, ASYNC_TX_FENCE | ASYNC_TX_XOR_ZERO_DST,
+				  depend_tx, NULL, NULL, NULL);
+		tx = async_xor_offs(pages[rbio->nr_data], offsets[rbio->nr_data],
+				    pages, offsets, rbio->nr_data, step, &submit);
 	}
-	for (stripe = stripe - 1; stripe >= 0; stripe--)
-		kunmap_local(pointers[stripe]);
+	return tx;
 }
 
-/* Generate PQ for one vertical stripe. */
-static void generate_pq_vertical(struct btrfs_raid_bio *rbio, int sectornr)
+/*
+ * Generate PQ for one vertical stripe, chaining into @depend_tx.
+ * The caller must issue_pending + wait for the returned descriptor
+ * (which may be NULL if the operation completed synchronously),
+ * then call generate_pq_vertical_finish() to mark parity uptodate.
+ */
+static struct dma_async_tx_descriptor *
+generate_pq_vertical(struct btrfs_raid_bio *rbio, int sectornr,
+		     struct page **pages, unsigned int *offsets,
+		     struct dma_async_tx_descriptor *depend_tx)
 {
-	const bool has_qstripe = (rbio->bioc->map_type & BTRFS_BLOCK_GROUP_RAID6);
+	struct dma_async_tx_descriptor *tx = depend_tx;
 
 	for (int i = 0; i < rbio->sector_nsteps; i++)
-		generate_pq_vertical_step(rbio, sectornr, i);
+		tx = generate_pq_vertical_step(rbio, sectornr, i, pages, offsets, tx);
+
+	return tx;
+}
+
+static void generate_pq_vertical_finish(struct btrfs_raid_bio *rbio, int sectornr)
+{
+	const bool has_qstripe = (rbio->bioc->map_type & BTRFS_BLOCK_GROUP_RAID6);
 
 	set_bit(rbio_sector_index(rbio, rbio->nr_data, sectornr),
 		rbio->stripe_uptodate_bitmap);
@@ -1910,39 +1971,33 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 	return 0;
 }
 
-static void recover_vertical_step(struct btrfs_raid_bio *rbio,
-				  unsigned int sector_nr,
-				  unsigned int step_nr,
-				  int faila, int failb,
-				  void **pointers, void **unmap_array)
+static struct dma_async_tx_descriptor *
+recover_vertical_step(struct btrfs_raid_bio *rbio,
+		      unsigned int sector_nr,
+		      unsigned int step_nr,
+		      int faila, int failb,
+		      struct page **pages, unsigned int *offsets,
+		      struct page **src_pages, unsigned int *src_offsets,
+		      struct dma_async_tx_descriptor *depend_tx)
 {
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	int stripe_nr;
+	struct async_submit_ctl submit;
+	struct dma_async_tx_descriptor *tx;
 
 	ASSERT(step_nr < rbio->sector_nsteps);
 	ASSERT(sector_nr < rbio->stripe_nsectors);
 
-	/*
-	 * Setup our array of pointers with sectors from each stripe
-	 *
-	 * NOTE: store a duplicate array of pointers to preserve the
-	 * pointer order.
-	 */
-	for (stripe_nr = 0; stripe_nr < rbio->real_stripes; stripe_nr++) {
+	for (int i = 0; i < rbio->real_stripes; i++) {
 		phys_addr_t paddr;
 
-		/*
-		 * If we're rebuilding a read, we have to use pages from the
-		 * bio list if possible.
-		 */
-		if (rbio->operation == BTRFS_RBIO_READ_REBUILD) {
-			paddr = sector_paddr_in_rbio(rbio, stripe_nr, sector_nr, step_nr, 0);
-		} else {
-			paddr = rbio_stripe_paddr(rbio, stripe_nr, sector_nr, step_nr);
-		}
-		pointers[stripe_nr] = kmap_local_paddr(paddr);
-		unmap_array[stripe_nr] = pointers[stripe_nr];
+		if (rbio->operation == BTRFS_RBIO_READ_REBUILD)
+			paddr = sector_paddr_in_rbio(rbio, i, sector_nr, step_nr, 0);
+		else
+			paddr = rbio_stripe_paddr(rbio, i, sector_nr, step_nr);
+
+		pages[i] = phys_to_page(paddr);
+		offsets[i] = offset_in_page(paddr);
 	}
 
 	/* All raid6 handling here */
@@ -1951,85 +2006,100 @@ static void recover_vertical_step(struct btrfs_raid_bio *rbio,
 		if (failb < 0) {
 			if (faila == rbio->nr_data)
 				/*
-				 * Just the P stripe has failed, without
-				 * a bad data or Q stripe.
-				 * We have nothing to do, just skip the
-				 * recovery for this stripe.
+				 * Only P stripe has failed without a bad data or
+				 * Q stripe.  No recovery needed for this step.
+				 * Returning NULL breaks the async_tx dependency
+				 * chain, but this path issues no DMA writes
+				 * (it is a pure no-op), so no ordering between
+				 * steps is required.
 				 */
-				goto cleanup;
-			/*
-			 * a single failure in raid6 is rebuilt
-			 * in the pstripe code below
-			 */
+				return NULL;
 			goto pstripe;
 		}
 
-		/*
-		 * If the q stripe is failed, do a pstripe reconstruction from
-		 * the xors.
-		 * If both the q stripe and the P stripe are failed, we're
-		 * here due to a crc mismatch and we can't give them the
-		 * data they want.
-		 */
 		if (failb == rbio->real_stripes - 1) {
 			if (faila == rbio->real_stripes - 2)
 				/*
-				 * Only P and Q are corrupted.
-				 * We only care about data stripes recovery,
-				 * can skip this vertical stripe.
+				 * Only P and Q are corrupted; data stripes are
+				 * intact.  No recovery needed for this step.
+				 * Safe to break the chain because this path
+				 * issues no DMA writes (pure no-op).
 				 */
-				goto cleanup;
-			/*
-			 * Otherwise we have one bad data stripe and
-			 * a good P stripe.  raid5!
-			 */
+				return NULL;
 			goto pstripe;
 		}
 
 		if (failb == rbio->real_stripes - 2) {
-			raid6_recov_datap(rbio->real_stripes, step,
-					  faila, pointers);
+			init_async_submit(&submit, ASYNC_TX_FENCE,
+					  depend_tx, NULL, NULL, NULL);
+			tx = async_raid6_datap_recov(rbio->real_stripes, step,
+						     faila, pages, offsets, &submit);
 		} else {
-			raid6_recov_2data(rbio->real_stripes, step,
-					  faila, failb, pointers);
+			init_async_submit(&submit, ASYNC_TX_FENCE,
+					  depend_tx, NULL, NULL, NULL);
+			tx = async_raid6_2data_recov(rbio->real_stripes, step,
+						     faila, failb, pages, offsets,
+						     &submit);
 		}
-	} else {
-		void *p;
+		return tx;
+	}
 
-		/* Rebuild from P stripe here (raid5 or raid6). */
-		ASSERT(failb == -1);
+	/* Rebuild from P stripe here (raid5 or raid6 single failure). */
+	ASSERT(failb == -1);
 pstripe:
-		/* Copy parity block into failed block to start with */
-		memcpy(pointers[faila], pointers[rbio->nr_data], step);
+	{
+		const unsigned int nr_data = rbio->nr_data;
+		int src_cnt = 0;
 
-		/* Rearrange the pointer array */
-		p = pointers[faila];
-		for (stripe_nr = faila; stripe_nr < rbio->nr_data - 1;
-		     stripe_nr++)
-			pointers[stripe_nr] = pointers[stripe_nr + 1];
-		pointers[rbio->nr_data - 1] = p;
+		/*
+		 * Build source list: P stripe + all non-failed data stripes.
+		 * The result is written into pages[faila].
+		 * The caller provides src_pages/src_offsets (sized for nr_data).
+		 */
+		src_pages[src_cnt] = pages[nr_data];
+		src_offsets[src_cnt] = offsets[nr_data];
+		src_cnt++;
+		for (int i = 0; i < nr_data; i++) {
+			if (i != faila) {
+				src_pages[src_cnt] = pages[i];
+				src_offsets[src_cnt] = offsets[i];
+				src_cnt++;
+			}
+		}
 
-		/* Xor in the rest */
-		xor_gen(p, pointers, rbio->nr_data - 1, step);
+		init_async_submit(&submit, ASYNC_TX_FENCE | ASYNC_TX_XOR_ZERO_DST,
+				  depend_tx, NULL, NULL, NULL);
+		tx = async_xor_offs(pages[faila], offsets[faila],
+				    src_pages, src_offsets, src_cnt,
+				    step, &submit);
+		return tx;
 	}
-
-cleanup:
-	for (stripe_nr = rbio->real_stripes - 1; stripe_nr >= 0; stripe_nr--)
-		kunmap_local(unmap_array[stripe_nr]);
 }
 
 /*
- * Recover a vertical stripe specified by @sector_nr.
- * @*pointers are the pre-allocated pointers by the caller, so we don't
- * need to allocate/free the pointers again and again.
+ * Per-sector issue step for vertical stripe recovery.
+ *
+ * Determines which stripes need recovery, then submits the async_tx chain
+ * (chained to @depend_tx for cross-sector batching).  Sets @faila and @failb
+ * for the subsequent finish step.
+ *
+ * Return value:
+ *   0  : success, @tx_ret describes pending work (or NULL for none)
+ *  -EIO: too many errors, no work submitted
  */
-static int recover_vertical(struct btrfs_raid_bio *rbio, int sector_nr,
-			    void **pointers, void **unmap_array)
+static int recover_vertical_submit(struct btrfs_raid_bio *rbio, int sector_nr,
+				   struct page **pages, unsigned int *offsets,
+				   struct page **src_pages, unsigned int *src_offsets,
+				   int *faila, int *failb,
+				   struct dma_async_tx_descriptor **tx_ret,
+				   struct dma_async_tx_descriptor *depend_tx)
 {
 	int found_errors;
-	int faila;
-	int failb;
-	int ret = 0;
+	struct dma_async_tx_descriptor *tx = depend_tx;
+
+	*tx_ret = NULL;
+	*faila = -1;
+	*failb = -1;
 
 	/*
 	 * Now we just use bitmap to mark the horizontal stripes in
@@ -2039,8 +2109,7 @@ static int recover_vertical(struct btrfs_raid_bio *rbio, int sector_nr,
 	    !test_bit(sector_nr, &rbio->dbitmap))
 		return 0;
 
-	found_errors = get_rbio_vertical_errors(rbio, sector_nr, &faila,
-						&failb);
+	found_errors = get_rbio_vertical_errors(rbio, sector_nr, faila, failb);
 	/*
 	 * No errors in the vertical stripe, skip it.  Can happen for recovery
 	 * which only part of a stripe failed csum check.
@@ -2051,9 +2120,27 @@ static int recover_vertical(struct btrfs_raid_bio *rbio, int sector_nr,
 	if (unlikely(found_errors > rbio->bioc->max_errors))
 		return -EIO;
 
-	for (int i = 0; i < rbio->sector_nsteps; i++)
-		recover_vertical_step(rbio, sector_nr, i, faila, failb,
-					    pointers, unmap_array);
+	for (int i = 0; i < rbio->sector_nsteps; i++) {
+		tx = recover_vertical_step(rbio, sector_nr, i,
+					   *faila, *failb,
+					   pages, offsets,
+					   src_pages, src_offsets,
+					   tx);
+	}
+	*tx_ret = tx;
+	return 0;
+}
+
+/*
+ * Finish step for recover_vertical_submit().
+ * Must be called after the DMA chain (if any) has completed.
+ * Verifies csums for the recovered stripes and sets the uptodate bits.
+ */
+static int recover_vertical_finish(struct btrfs_raid_bio *rbio, int sector_nr,
+				   int faila, int failb)
+{
+	int ret = 0;
+
 	if (faila >= 0) {
 		ret = verify_one_sector(rbio, faila, sector_nr);
 		if (ret < 0)
@@ -2073,22 +2160,61 @@ static int recover_vertical(struct btrfs_raid_bio *rbio, int sector_nr,
 	return ret;
 }
 
+/*
+ * Sequential wrapper: submit, wait, finish for one sector.
+ * Used by callers that do their own complex error filtering
+ * (e.g. scrub recovery) and cannot batch across sectors.
+ */
+static int recover_vertical(struct btrfs_raid_bio *rbio, int sector_nr,
+			    struct page **pages, unsigned int *offsets,
+			    struct page **src_pages, unsigned int *src_offsets)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	int faila, failb;
+	int ret;
+
+	ret = recover_vertical_submit(rbio, sector_nr, pages, offsets,
+				      src_pages, src_offsets,
+				      &faila, &failb, &tx, NULL);
+	if (ret < 0)
+		return ret;
+
+	if (tx) {
+		async_tx_issue_pending(tx);
+		dma_wait_for_async_tx(tx);
+	}
+
+	return recover_vertical_finish(rbio, sector_nr, faila, failb);
+}
+
 static int recover_sectors(struct btrfs_raid_bio *rbio)
 {
-	void **pointers = NULL;
-	void **unmap_array = NULL;
+	struct page **pages = NULL;
+	unsigned int *offsets = NULL;
+	struct page **src_pages = NULL;
+	unsigned int *src_offsets = NULL;
+	int faila_arr[RECOVER_MAX_STRIPE_SECTORS];
+	int failb_arr[RECOVER_MAX_STRIPE_SECTORS];
 	int sectornr;
 	int ret = 0;
 
+	ASSERT(rbio->stripe_nsectors <= RECOVER_MAX_STRIPE_SECTORS);
+
+	pages = kzalloc_objs(struct page *, rbio->real_stripes, GFP_NOFS);
+	offsets = kzalloc_objs(unsigned int, rbio->real_stripes, GFP_NOFS);
+	if (!pages || !offsets) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/*
-	 * @pointers array stores the pointer for each sector.
-	 *
-	 * @unmap_array stores copy of pointers that does not get reordered
-	 * during reconstruction so that kunmap_local works.
+	 * src_pages/src_offsets hold the pstripe source list:
+	 *   P stripe (1) + non-failed data stripes (at most nr_data - 1)
+	 * = at most nr_data entries.
 	 */
-	pointers = kzalloc_objs(void *, rbio->real_stripes, GFP_NOFS);
-	unmap_array = kzalloc_objs(void *, rbio->real_stripes, GFP_NOFS);
-	if (!pointers || !unmap_array) {
+	src_pages = kzalloc_objs(struct page *, rbio->nr_data, GFP_NOFS);
+	src_offsets = kzalloc_objs(unsigned int, rbio->nr_data, GFP_NOFS);
+	if (!src_pages || !src_offsets) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -2101,15 +2227,58 @@ static int recover_sectors(struct btrfs_raid_bio *rbio)
 
 	index_rbio_pages(rbio);
 
-	for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++) {
-		ret = recover_vertical(rbio, sectornr, pointers, unmap_array);
-		if (ret < 0)
-			break;
+	{
+		struct dma_async_tx_descriptor *tx = NULL;
+
+		/*
+		 * Phase 1: submit all sectors' recovery chains.
+		 *
+		 * pages[] / offsets[] are overwritten by each sector's submit
+		 * call.  This is safe because the async_tx API consumes the
+		 * arrays synchronously during each call: either the DMA prep
+		 * function converts page+offset to DMA addresses and stores
+		 * them in the hardware descriptor, or the synchronous fallback
+		 * reads the data immediately.  No async_tx function retains a
+		 * reference to the arrays after it returns.
+		 */
+		for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++) {
+			int f_a = -1, f_b = -1;
+
+			ret = recover_vertical_submit(rbio, sectornr, pages, offsets,
+						      src_pages, src_offsets,
+						      &f_a, &f_b, &tx, tx);
+			if (ret < 0) {
+				if (tx) {
+					async_tx_issue_pending(tx);
+					dma_wait_for_async_tx(tx);
+				}
+				goto out;
+			}
+			faila_arr[sectornr] = f_a;
+			failb_arr[sectornr] = f_b;
+		}
+
+		/* Phase 2: wait for all DMAs to complete. */
+		if (tx) {
+			async_tx_issue_pending(tx);
+			dma_wait_for_async_tx(tx);
+		}
+
+		/* Phase 3: verify recovered stripes and set uptodate bits. */
+		for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++) {
+			ret = recover_vertical_finish(rbio, sectornr,
+						      faila_arr[sectornr],
+						      failb_arr[sectornr]);
+			if (ret < 0)
+				goto out;
+		}
 	}
 
 out:
-	kfree(pointers);
-	kfree(unmap_array);
+	kfree(src_pages);
+	kfree(src_offsets);
+	kfree(pages);
+	kfree(offsets);
 	return ret;
 }
 
@@ -2436,6 +2605,8 @@ static bool need_read_stripe_sectors(struct btrfs_raid_bio *rbio)
 static void rmw_rbio(struct btrfs_raid_bio *rbio)
 {
 	struct bio_list bio_list;
+	struct page **pages = NULL;
+	unsigned int *offsets = NULL;
 	int sectornr;
 	int ret = 0;
 
@@ -2491,8 +2662,28 @@ static void rmw_rbio(struct btrfs_raid_bio *rbio)
 	else
 		clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
 
-	for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++)
-		generate_pq_vertical(rbio, sectornr);
+	pages = kzalloc_objs(struct page *, rbio->real_stripes, GFP_NOFS);
+	offsets = kzalloc_objs(unsigned int, rbio->real_stripes, GFP_NOFS);
+	if (!pages || !offsets) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	{
+		struct dma_async_tx_descriptor *tx = NULL;
+
+		/* Chain all sectors so a DMA engine can pipeline across them. */
+		for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++)
+			tx = generate_pq_vertical(rbio, sectornr, pages, offsets, tx);
+
+		if (tx) {
+			async_tx_issue_pending(tx);
+			dma_wait_for_async_tx(tx);
+		}
+
+		for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++)
+			generate_pq_vertical_finish(rbio, sectornr);
+	}
 
 	bio_list_init(&bio_list);
 	ret = rmw_assemble_write_bios(rbio, &bio_list);
@@ -2515,6 +2706,8 @@ static void rmw_rbio(struct btrfs_raid_bio *rbio)
 		}
 	}
 out:
+	kfree(pages);
+	kfree(offsets);
 	rbio_orig_end_io(rbio, errno_to_blk_status(ret));
 }
 
@@ -2622,60 +2815,91 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 	return 0;
 }
 
-/* Return true if the content of the step matches the caclulated one. */
+/* Return true if the content of the step matches the calculated one. */
 static bool verify_one_parity_step(struct btrfs_raid_bio *rbio,
-				   void *pointers[], unsigned int sector_nr,
+				   struct page **pages, unsigned int *offsets,
+				   unsigned int sector_nr,
 				   unsigned int step_nr)
 {
 	const unsigned int nr_data = rbio->nr_data;
 	const bool has_qstripe = (rbio->real_stripes - rbio->nr_data == 2);
 	const u32 step = min(rbio->bioc->fs_info->sectorsize, PAGE_SIZE);
-	void *parity;
+	struct async_submit_ctl submit;
+	struct dma_async_tx_descriptor *tx;
+	void *scrub_kaddr, *calc_kaddr;
 	bool ret = false;
 
 	ASSERT(step_nr < rbio->sector_nsteps);
 
-	/* First collect one page from each data stripe. */
-	for (int stripe = 0; stripe < nr_data; stripe++)
-		pointers[stripe] = kmap_local_paddr(
-				sector_paddr_in_rbio(rbio, stripe, sector_nr,
-						     step_nr, 0));
+	/* Fill page/offset arrays for data stripes. */
+	for (int stripe = 0; stripe < nr_data; stripe++) {
+		phys_addr_t paddr = sector_paddr_in_rbio(rbio, stripe, sector_nr,
+							 step_nr, 0);
+		pages[stripe] = phys_to_page(paddr);
+		offsets[stripe] = offset_in_page(paddr);
+	}
+
+	ASSERT(rbio->scrubp >= nr_data);
+	ASSERT(rbio->scrubp < rbio->real_stripes);
+
+	/* The parity destination pages must be set by the caller. */
+	ASSERT(pages[nr_data]);
+	ASSERT(offsets[nr_data] == 0);
+	if (has_qstripe) {
+		ASSERT(pages[rbio->real_stripes - 1]);
+		ASSERT(offsets[rbio->real_stripes - 1] == 0);
+	}
 
 	if (has_qstripe) {
 		assert_rbio(rbio);
-		/* RAID6, call the library function to fill in our P/Q. */
-		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
+		init_async_submit(&submit, 0, NULL, NULL, NULL, NULL);
+		tx = async_gen_syndrome(pages, offsets, rbio->real_stripes,
+					step, &submit);
 	} else {
-		/* RAID5. */
-		memcpy(pointers[nr_data], pointers[0], step);
-		xor_gen(pointers[nr_data], pointers + 1, nr_data - 1, step);
+		init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL, NULL, NULL, NULL);
+		/*
+		 * async_xor_offs takes src_cnt = nr_data.  pages[0..nr_data-1]
+		 * are data sources; pages[nr_data] (the destination) is
+		 * excluded from the source list by the count.
+		 * ASYNC_TX_XOR_ZERO_DST zeroes the destination first, then
+		 * XORs all sources: dest = 0 ^ D0 ^ ... ^ D{n-1} = parity.
+		 */
+		tx = async_xor_offs(pages[rbio->nr_data], offsets[rbio->nr_data],
+				    pages, offsets, rbio->nr_data, step, &submit);
+	}
+	/* async_tx returns NULL when the operation completed synchronously. */
+	if (tx) {
+		async_tx_issue_pending(tx);
+		dma_wait_for_async_tx(tx);
 	}
 
 	/* Check scrubbing parity and repair it. */
-	parity = kmap_local_paddr(rbio_stripe_paddr(rbio, rbio->scrubp, sector_nr, step_nr));
-	if (memcmp(parity, pointers[rbio->scrubp], step) != 0)
-		memcpy(parity, pointers[rbio->scrubp], step);
+	scrub_kaddr = kmap_local_paddr(rbio_stripe_paddr(rbio, rbio->scrubp,
+							 sector_nr, step_nr));
+	calc_kaddr = kmap_local_page(pages[rbio->scrubp]);
+	if (memcmp(scrub_kaddr, (void *)((char *)calc_kaddr + offsets[rbio->scrubp]), step) != 0)
+		memcpy(scrub_kaddr, (void *)((char *)calc_kaddr + offsets[rbio->scrubp]), step);
 	else
 		ret = true;
-	kunmap_local(parity);
+	kunmap_local(calc_kaddr);
+	kunmap_local(scrub_kaddr);
 
-	for (int stripe = nr_data - 1; stripe >= 0; stripe--)
-		kunmap_local(pointers[stripe]);
 	return ret;
 }
 
 /*
- * The @pointers array should have the P/Q parity already mapped.
+ * The @pages and @offsets arrays should have the P/Q parity pages already set.
  */
 static void verify_one_parity_sector(struct btrfs_raid_bio *rbio,
-				     void *pointers[], unsigned int sector_nr)
+				     struct page **pages, unsigned int *offsets,
+				     unsigned int sector_nr)
 {
 	bool found_error = false;
 
 	for (int step_nr = 0; step_nr < rbio->sector_nsteps; step_nr++) {
 		bool match;
 
-		match = verify_one_parity_step(rbio, pointers, sector_nr, step_nr);
+		match = verify_one_parity_step(rbio, pages, offsets, sector_nr, step_nr);
 		if (!match)
 			found_error = true;
 	}
@@ -2686,17 +2910,17 @@ static void verify_one_parity_sector(struct btrfs_raid_bio *rbio,
 static int finish_parity_scrub(struct btrfs_raid_bio *rbio)
 {
 	struct btrfs_io_context *bioc = rbio->bioc;
-	void **pointers = rbio->finish_pointers;
 	unsigned long *pbitmap = &rbio->finish_pbitmap;
 	int nr_data = rbio->nr_data;
 	int sectornr;
 	bool has_qstripe;
-	struct page *page;
-	phys_addr_t p_paddr = INVALID_PADDR;
-	phys_addr_t q_paddr = INVALID_PADDR;
+	struct page **pages;
+	unsigned int *offsets;
+	struct page *p_page = NULL;
+	struct page *q_page = NULL;
 	struct bio_list bio_list;
 	bool is_replace = false;
-	int ret;
+	int ret = 0;
 
 	bio_list_init(&bio_list);
 
@@ -2723,40 +2947,46 @@ static int finish_parity_scrub(struct btrfs_raid_bio *rbio)
 	 */
 	clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
 
-	page = alloc_page(GFP_NOFS);
-	if (!page)
-		return -ENOMEM;
-	p_paddr = page_to_phys(page);
-	page = NULL;
-	pointers[nr_data] = kmap_local_paddr(p_paddr);
+	pages = kzalloc_objs(struct page *, rbio->real_stripes, GFP_NOFS);
+	offsets = kzalloc_objs(unsigned int, rbio->real_stripes, GFP_NOFS);
+	if (!pages || !offsets) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	p_page = alloc_page(GFP_NOFS);
+	if (!p_page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	pages[nr_data] = p_page;
+	offsets[nr_data] = 0;
 
 	if (has_qstripe) {
-		/* RAID6, allocate and map temp space for the Q stripe */
-		page = alloc_page(GFP_NOFS);
-		if (!page) {
-			__free_page(phys_to_page(p_paddr));
-			p_paddr = INVALID_PADDR;
-			return -ENOMEM;
+		q_page = alloc_page(GFP_NOFS);
+		if (!q_page) {
+			ret = -ENOMEM;
+			goto out;
 		}
-		q_paddr = page_to_phys(page);
-		page = NULL;
-		pointers[rbio->real_stripes - 1] = kmap_local_paddr(q_paddr);
+		pages[rbio->real_stripes - 1] = q_page;
+		offsets[rbio->real_stripes - 1] = 0;
 	}
 
 	bitmap_clear(rbio->error_bitmap, 0, rbio->nr_sectors);
 
-	/* Map the parity stripe just once */
-
+	/* Temporary parity destination pages are set once and reused for all sectors */
 	for_each_set_bit(sectornr, &rbio->dbitmap, rbio->stripe_nsectors)
-		verify_one_parity_sector(rbio, pointers, sectornr);
+		verify_one_parity_sector(rbio, pages, offsets, sectornr);
 
-	kunmap_local(pointers[nr_data]);
-	__free_page(phys_to_page(p_paddr));
-	p_paddr = INVALID_PADDR;
-	if (q_paddr != INVALID_PADDR) {
-		__free_page(phys_to_page(q_paddr));
-		q_paddr = INVALID_PADDR;
-	}
+out:
+	if (p_page)
+		__free_page(p_page);
+	if (q_page)
+		__free_page(q_page);
+	kfree(pages);
+	kfree(offsets);
+	if (ret)
+		return ret;
 
 	/*
 	 * time to start writing.  Make bios for everything from the
@@ -2809,20 +3039,28 @@ static inline int is_data_stripe(struct btrfs_raid_bio *rbio, int stripe)
 
 static int recover_scrub_rbio(struct btrfs_raid_bio *rbio)
 {
-	void **pointers = NULL;
-	void **unmap_array = NULL;
+	struct page **pages = NULL;
+	unsigned int *offsets = NULL;
+	struct page **src_pages = NULL;
+	unsigned int *src_offsets = NULL;
 	int sector_nr;
 	int ret = 0;
 
+	pages = kzalloc_objs(struct page *, rbio->real_stripes, GFP_NOFS);
+	offsets = kzalloc_objs(unsigned int, rbio->real_stripes, GFP_NOFS);
+	if (!pages || !offsets) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/*
-	 * @pointers array stores the pointer for each sector.
-	 *
-	 * @unmap_array stores copy of pointers that does not get reordered
-	 * during reconstruction so that kunmap_local works.
+	 * src_pages/src_offsets hold the pstripe source list:
+	 *   P stripe (1) + non-failed data stripes (at most nr_data - 1)
+	 * = at most nr_data entries.
 	 */
-	pointers = kzalloc_objs(void *, rbio->real_stripes, GFP_NOFS);
-	unmap_array = kzalloc_objs(void *, rbio->real_stripes, GFP_NOFS);
-	if (!pointers || !unmap_array) {
+	src_pages = kzalloc_objs(struct page *, rbio->nr_data, GFP_NOFS);
+	src_offsets = kzalloc_objs(unsigned int, rbio->nr_data, GFP_NOFS);
+	if (!src_pages || !src_offsets) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -2881,13 +3119,16 @@ static int recover_scrub_rbio(struct btrfs_raid_bio *rbio)
 			goto out;
 		}
 
-		ret = recover_vertical(rbio, sector_nr, pointers, unmap_array);
+		ret = recover_vertical(rbio, sector_nr, pages, offsets,
+				       src_pages, src_offsets);
 		if (ret < 0)
 			goto out;
 	}
 out:
-	kfree(pointers);
-	kfree(unmap_array);
+	kfree(src_pages);
+	kfree(src_offsets);
+	kfree(pages);
+	kfree(offsets);
 	return ret;
 }
 
@@ -3025,11 +3266,18 @@ void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
 	     cur_off < offset_in_full_stripe + BTRFS_STRIPE_LEN;
 	     cur_off += PAGE_SIZE) {
 		const unsigned int pindex = cur_off >> PAGE_SHIFT;
-		void *kaddr;
-
-		kaddr = kmap_local_page(rbio->stripe_pages[pindex]);
-		memcpy_from_folio(kaddr, data_folios[findex], foffset, PAGE_SIZE);
-		kunmap_local(kaddr);
+		struct dma_async_tx_descriptor *tx;
+		struct async_submit_ctl submit;
+
+		ASSERT(IS_ALIGNED(foffset, PAGE_SIZE));
+		init_async_submit(&submit, 0, NULL, NULL, NULL, NULL);
+		tx = async_memcpy(rbio->stripe_pages[pindex],
+				  folio_page(data_folios[findex], foffset >> PAGE_SHIFT),
+				  0, 0, PAGE_SIZE, &submit);
+		if (tx) {
+			async_tx_issue_pending(tx);
+			dma_wait_for_async_tx(tx);
+		}
 
 		foffset += PAGE_SIZE;
 		ASSERT(foffset <= folio_size(data_folios[findex]));
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 1f463ecf7e41..d8a63edd38b7 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -209,9 +209,6 @@ struct btrfs_raid_bio {
 	/* Each set bit means the corresponding sector in stripe_sectors[] is uptodate. */
 	unsigned long *stripe_uptodate_bitmap;
 
-	/* Allocated with real_stripes-many pointers for finish_*() calls */
-	void **finish_pointers;
-
 	/*
 	 * The bitmap recording where IO errors happened.
 	 * Each bit is corresponding to one sector in either bio_sectors[] or
-- 
2.54.0

