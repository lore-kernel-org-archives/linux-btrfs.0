Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A88B3B1B3
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 05:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782712272; cv=none; b=nhT8g+1+SuDks+v9pnQpUwXyNjdLkP1AWiNZA8Jk5+I5LCP2wDDspjJxKlijAmDv3lezoLsGaH/POPFBy4/C0g803xRP/6HoDHnaqqTyJwmPckhqzojTR1B6/PZJZZ9yUpx+xrzueaulmP2NKXYyc+cqxUy3t9StDwdOwJA4nYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782712272; c=relaxed/simple;
	bh=ZdkWHbQ/EpBjwZRo68kVtA/9/ysiuR+McuDTF9eqs4k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eIIWu1R04s9ul+VPxkGWHv8u+Eydj5ZRLxFIRx/WVsyiUcxa0X/+6OBJxU4fL4tITEOvk5lLPS52BHY+G2RylBCbXEjHp5DZtbb2jQ4lp16qGSDGn2XJIMi3xYBdj7E1SJGcgL8zYFr0x5XYx3QVKCauTuMoqA1b8mHr1j0dGRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XKF8HKDG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lebqjh2I; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XKF8HKDG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lebqjh2I"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E46BF75CF9
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 05:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782712268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QMO3rqaOGKaRhyBDbwe8FBtbLnlF9r/zV66Khh3eldM=;
	b=XKF8HKDGjl8zWPi1z6Z6bUu0V9eGutLqWjU9W4gh+nxXa9TEAKxEoJRpzdgmGCNtsPFvh9
	zRDpUdtIQxxyITuBwxr0kklv4mrroCQDq1EhWRsq+k18vKh38jWGsFOU+0jTLZgyntD4Ar
	c6+eOOYj6fnmFmHW72qY6GXhT5mpfks=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Lebqjh2I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782712267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QMO3rqaOGKaRhyBDbwe8FBtbLnlF9r/zV66Khh3eldM=;
	b=Lebqjh2IxBxBvo9TvHyeZ12YTRpDkAksI+wqZI2Ip2DWfsMwKiARBPDS8oV0ABFqQu57IM
	d2QHKFM7kxhosPCjkYfDGQasTdsIv8QIvRf/e5YYutty3oX2u3Uqrwh/mwAD3ok7MbVgp3
	OCBViRIvgG+69FOVRwUanl0memX5m7k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBB6C779A8
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 05:51:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BI/AJsoHQmrRAwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 05:51:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: use kvmalloc() for stripe buffer of scrub_stripe
Date: Mon, 29 Jun 2026 15:20:48 +0930
Message-ID: <ae19a873c0d3fc170ca206d3df26cbe4d42fce60.1782712192.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E46BF75CF9
X-Spam-Score: -3.01

Currently we're using scrub_stripe::folios[] to store all contents of a
stripe.

This means we need all the extra work to handle things like sub-page
cases, and also require larger folios to handle bs > ps cases.

On the other hand, it's not hard to allocate a 64K large folio to cover
the full stripe, getting rid of the cross-page handling.

Furthermore, even if that large folio allocation failed, we can still
use vmalloc() to allocate a virtually contiguous space and still get rid
of cross-page handling.

This patch will go with kvmalloc() to allocate 64K of memory for
the stripe buffer, thus getting rid of all the complex cross-page
handling.

The following aspects can be greatly simplified:

- Checksum verification for both data and metadata
  No more per-page iteration, all in one go.

- RAID56 data caching
  Just copy the buffer into the RAID56 pages.

- No more kaddr/paddr grabbing
  For most cases the virtual address is enough for csum calculation and
  io submission.
  There is only one location left with a kernel address requirement,
  that's calc_sector_number, which needs to compare against the bvec
  virtual address.

  Just open-code a simple vaddr->kaddr converter for that only caller.

- Bio assembly
  There is already the helper bio_add_vmalloc() to queue vmallocated
  memory into a bio.

Although it means we have something else to concern:

- Bio assembly
  If the memory is vmallocated, we need to use bio_add_vmalloc()
  Otherwise use the existing bio_add_page().

- Read endio
  For vmallocated memory, we need to call
  invalidate_kernel_vmap_range().

- Scrub bbio bvec size
  Since scrub_stripe::buffer is kvmallocated, we also need to enlarge
  the scrub bbio, to be able to handle the worst case, where all 64KiB is
  allocated by discontiguous physical pages.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Fix a potential double-free during release_scrub_stripe()
  Reported by sashiko.

- Enlarge the scrub bbio to be able to contain the full buffer
  Since the buffer is allocated by kvmalloc(), it's possible that not
  all pages are physically contiguous.

  In that case we have to enlarge the bbio to contain
  (BTRFS_STRIPE_LEN >> PAGE_SHIFT) bvecs.
---
 fs/btrfs/raid56.c |  18 ++----
 fs/btrfs/raid56.h |   2 +-
 fs/btrfs/scrub.c  | 160 ++++++++++++++++++++--------------------------
 3 files changed, 76 insertions(+), 104 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f7f7db40994c..0faff694eb78 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2996,13 +2996,11 @@ void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio)
  * This is due to the fact rbio has its own page management for its cache.
  */
 void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
-				     struct folio **data_folios, u64 data_logical)
+				     void *vaddr, u64 data_logical)
 {
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	const u64 offset_in_full_stripe = data_logical -
 					  rbio->bioc->full_stripe_logical;
-	unsigned int findex = 0;
-	unsigned int foffset = 0;
 	int ret;
 
 	/*
@@ -3025,18 +3023,10 @@ void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
 	     cur_off < offset_in_full_stripe + BTRFS_STRIPE_LEN;
 	     cur_off += PAGE_SIZE) {
 		const unsigned int pindex = cur_off >> PAGE_SHIFT;
-		void *kaddr;
 
-		kaddr = kmap_local_page(rbio->stripe_pages[pindex]);
-		memcpy_from_folio(kaddr, data_folios[findex], foffset, PAGE_SIZE);
-		kunmap_local(kaddr);
-
-		foffset += PAGE_SIZE;
-		ASSERT(foffset <= folio_size(data_folios[findex]));
-		if (foffset == folio_size(data_folios[findex])) {
-			findex++;
-			foffset = 0;
-		}
+		ASSERT(cur_off - offset_in_full_stripe + PAGE_SIZE <= BTRFS_STRIPE_LEN);
+		memcpy_to_page(rbio->stripe_pages[pindex], 0,
+			       vaddr + cur_off - offset_in_full_stripe, PAGE_SIZE);
 	}
 	bitmap_set(rbio->stripe_uptodate_bitmap,
 		   offset_in_full_stripe >> fs_info->sectorsize_bits,
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 1f463ecf7e41..8542648199f1 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -283,7 +283,7 @@ struct btrfs_raid_bio *raid56_parity_alloc_scrub_rbio(struct bio *bio,
 void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio);
 
 void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
-				     struct folio **data_folios, u64 data_logical);
+				     void *vaddr, u64 data_logical);
 
 int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info);
 void btrfs_free_stripe_hash_table(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d2f7ac5b6e96..d466203ed579 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -129,19 +129,17 @@ enum {
 	scrub_bitmap_nr_last,
 };
 
-#define SCRUB_STRIPE_MAX_FOLIOS		(BTRFS_STRIPE_LEN / PAGE_SIZE)
-
 /*
  * Represent one contiguous range with a length of BTRFS_STRIPE_LEN.
  */
 struct scrub_stripe {
 	struct scrub_ctx *sctx;
 	struct btrfs_block_group *bg;
-
-	struct folio *folios[SCRUB_STRIPE_MAX_FOLIOS];
 	struct scrub_sector_verification *sectors;
-
 	struct btrfs_device *dev;
+
+	void *buffer;
+
 	u64 logical;
 	u64 physical;
 
@@ -338,13 +336,10 @@ static void release_scrub_stripe(struct scrub_stripe *stripe)
 	if (!stripe)
 		return;
 
-	for (int i = 0; i < SCRUB_STRIPE_MAX_FOLIOS; i++) {
-		if (stripe->folios[i])
-			folio_put(stripe->folios[i]);
-		stripe->folios[i] = NULL;
-	}
+	kvfree(stripe->buffer);
 	kfree(stripe->sectors);
 	kfree(stripe->csums);
+	stripe->buffer = NULL;
 	stripe->sectors = NULL;
 	stripe->csums = NULL;
 	stripe->sctx = NULL;
@@ -354,9 +349,6 @@ static void release_scrub_stripe(struct scrub_stripe *stripe)
 static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 			     struct scrub_stripe *stripe)
 {
-	const u32 min_folio_shift = PAGE_SHIFT + fs_info->block_min_order;
-	int ret;
-
 	memset(stripe, 0, sizeof(*stripe));
 
 	stripe->nr_sectors = BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits;
@@ -367,11 +359,8 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 	atomic_set(&stripe->pending_io, 0);
 	spin_lock_init(&stripe->write_error_lock);
 
-	ASSERT(BTRFS_STRIPE_LEN >> min_folio_shift <= SCRUB_STRIPE_MAX_FOLIOS);
-	ret = btrfs_alloc_folio_array(BTRFS_STRIPE_LEN >> min_folio_shift,
-				      fs_info->block_min_order, stripe->folios,
-				      GFP_NOFS);
-	if (ret < 0)
+	stripe->buffer = kvmalloc(BTRFS_STRIPE_LEN, GFP_NOFS);
+	if (!stripe->buffer)
 		goto error;
 
 	stripe->sectors = kzalloc_objs(struct scrub_sector_verification,
@@ -682,32 +671,18 @@ static int fill_writer_pointer_gap(struct scrub_ctx *sctx, u64 physical)
 	return ret;
 }
 
-static void *scrub_stripe_get_kaddr(struct scrub_stripe *stripe, int sector_nr)
+/*
+ * Unlike the existing csum which is based on paddr, this version is fully on
+ * vaddr, so no extra per-page iteration needed.
+ */
+static void scrub_calc_vaddr_csum(struct btrfs_fs_info *fs_info,
+				  void *vaddr, unsigned int len, u8 *dest)
 {
-	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
-	const u32 min_folio_shift = PAGE_SHIFT + fs_info->block_min_order;
-	u32 offset = (sector_nr << fs_info->sectorsize_bits);
-	const struct folio *folio = stripe->folios[offset >> min_folio_shift];
+	struct btrfs_csum_ctx csum;
 
-	/* stripe->folios[] is allocated by us and no highmem is allowed. */
-	ASSERT(folio);
-	ASSERT(!folio_test_highmem(folio));
-	return folio_address(folio) + offset_in_folio(folio, offset);
-}
-
-static phys_addr_t scrub_stripe_get_paddr(struct scrub_stripe *stripe, int sector_nr)
-{
-	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
-	const u32 min_folio_shift = PAGE_SHIFT + fs_info->block_min_order;
-	u32 offset = (sector_nr << fs_info->sectorsize_bits);
-	const struct folio *folio = stripe->folios[offset >> min_folio_shift];
-
-	/* stripe->folios[] is allocated by us and no highmem is allowed. */
-	ASSERT(folio);
-	ASSERT(!folio_test_highmem(folio));
-	/* And the range must be contained inside the folio. */
-	ASSERT(offset_in_folio(folio, offset) + fs_info->sectorsize <= folio_size(folio));
-	return page_to_phys(folio_page(folio, 0)) + offset_in_folio(folio, offset);
+	btrfs_csum_init(&csum, fs_info->csum_type);
+	btrfs_csum_update(&csum, vaddr, len);
+	btrfs_csum_final(&csum, dest);
 }
 
 static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr)
@@ -715,19 +690,10 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
 	const u32 sectors_per_tree = fs_info->nodesize >> fs_info->sectorsize_bits;
 	const u64 logical = stripe->logical + (sector_nr << fs_info->sectorsize_bits);
-	void *first_kaddr = scrub_stripe_get_kaddr(stripe, sector_nr);
-	struct btrfs_header *header = first_kaddr;
-	struct btrfs_csum_ctx csum;
-	u8 on_disk_csum[BTRFS_CSUM_SIZE];
+	void *first_vaddr = stripe->buffer + (sector_nr << fs_info->sectorsize_bits);
+	struct btrfs_header *header = first_vaddr;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 
-	/*
-	 * Here we don't have a good way to attach the pages (and subpages)
-	 * to a dummy extent buffer, thus we have to directly grab the members
-	 * from pages.
-	 */
-	memcpy(on_disk_csum, header->csum, fs_info->csum_size);
-
 	if (logical != btrfs_stack_header_bytenr(header)) {
 		scrub_bitmap_set_meta_error(stripe, sector_nr, sectors_per_tree);
 		scrub_bitmap_set_error(stripe, sector_nr, sectors_per_tree);
@@ -759,23 +725,15 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 	}
 
 	/* Now check tree block csum. */
-	btrfs_csum_init(&csum, fs_info->csum_type);
-	btrfs_csum_update(&csum, first_kaddr + BTRFS_CSUM_SIZE,
-			  fs_info->sectorsize - BTRFS_CSUM_SIZE);
-
-	for (int i = sector_nr + 1; i < sector_nr + sectors_per_tree; i++) {
-		btrfs_csum_update(&csum, scrub_stripe_get_kaddr(stripe, i),
-				  fs_info->sectorsize);
-	}
-
-	btrfs_csum_final(&csum, calculated_csum);
-	if (memcmp(calculated_csum, on_disk_csum, fs_info->csum_size) != 0) {
+	scrub_calc_vaddr_csum(fs_info, first_vaddr + BTRFS_CSUM_SIZE,
+			      fs_info->nodesize - BTRFS_CSUM_SIZE, calculated_csum);
+	if (memcmp(calculated_csum, header->csum, fs_info->csum_size) != 0) {
 		scrub_bitmap_set_meta_error(stripe, sector_nr, sectors_per_tree);
 		scrub_bitmap_set_error(stripe, sector_nr, sectors_per_tree);
 		btrfs_warn_rl(fs_info,
 "scrub: tree block %llu mirror %u has bad csum, has " BTRFS_CSUM_FMT " want " BTRFS_CSUM_FMT,
 			      logical, stripe->mirror_num,
-			      BTRFS_CSUM_FMT_VALUE(fs_info->csum_size, on_disk_csum),
+			      BTRFS_CSUM_FMT_VALUE(fs_info->csum_size, header->csum),
 			      BTRFS_CSUM_FMT_VALUE(fs_info->csum_size, calculated_csum));
 		return;
 	}
@@ -801,9 +759,7 @@ static void scrub_verify_one_sector(struct scrub_stripe *stripe, int sector_nr)
 	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
 	struct scrub_sector_verification *sector = &stripe->sectors[sector_nr];
 	const u32 sectors_per_tree = fs_info->nodesize >> fs_info->sectorsize_bits;
-	phys_addr_t paddr = scrub_stripe_get_paddr(stripe, sector_nr);
 	u8 csum_buf[BTRFS_CSUM_SIZE];
-	int ret;
 
 	ASSERT(sector_nr >= 0 && sector_nr < stripe->nr_sectors);
 
@@ -846,8 +802,10 @@ static void scrub_verify_one_sector(struct scrub_stripe *stripe, int sector_nr)
 		return;
 	}
 
-	ret = btrfs_check_block_csum(fs_info, paddr, csum_buf, sector->csum);
-	if (ret < 0) {
+	scrub_calc_vaddr_csum(fs_info,
+			      stripe->buffer + (sector_nr << fs_info->sectorsize_bits),
+			      fs_info->sectorsize, csum_buf);
+	if (memcmp(csum_buf, sector->csum, fs_info->csum_size)) {
 		scrub_bitmap_set_bit_csum_error(stripe, sector_nr);
 		scrub_bitmap_set_bit_error(stripe, sector_nr);
 	} else {
@@ -872,10 +830,20 @@ static void scrub_verify_one_stripe(struct scrub_stripe *stripe, unsigned long b
 
 static int calc_sector_number(struct scrub_stripe *stripe, struct bio_vec *first_bvec)
 {
+	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
 	int i;
 
 	for (i = 0; i < stripe->nr_sectors; i++) {
-		if (scrub_stripe_get_kaddr(stripe, i) == bvec_virt(first_bvec))
+		const void *vaddr = stripe->buffer + (i << fs_info->sectorsize_bits);
+		void *kaddr;
+
+		if (is_vmalloc_addr(vaddr))
+			kaddr = page_address(vmalloc_to_page(vaddr));
+		else
+			kaddr = page_address(virt_to_page(vaddr));
+		kaddr += offset_in_page(vaddr);
+
+		if (kaddr == bvec_virt(first_bvec))
 			break;
 	}
 	ASSERT(i < stripe->nr_sectors);
@@ -897,6 +865,10 @@ static void scrub_repair_read_endio(struct btrfs_bio *bbio)
 
 	ASSERT(sector_nr < stripe->nr_sectors);
 
+	if (is_vmalloc_addr(stripe->buffer))
+		invalidate_kernel_vmap_range(
+			stripe->buffer + (sector_nr << fs_info->sectorsize_bits),
+			bio_size);
 	if (bbio->bio.bi_status) {
 		scrub_bitmap_set_io_error(stripe, sector_nr,
 					  bio_size >> fs_info->sectorsize_bits);
@@ -921,30 +893,36 @@ static void scrub_bio_add_sector(struct btrfs_bio *bbio, struct scrub_stripe *st
 				 int sector_nr)
 {
 	struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
-	void *kaddr = scrub_stripe_get_kaddr(stripe, sector_nr);
+	const u32 offset = sector_nr << fs_info->sectorsize_bits;
 	int ret;
 
-	ret = bio_add_page(&bbio->bio, virt_to_page(kaddr), fs_info->sectorsize,
-			   offset_in_page(kaddr));
-	/*
-	 * Caller should ensure the bbio has enough size.
-	 * And we cannot use __bio_add_page(), which doesn't do any merge.
-	 *
-	 * Meanwhile for scrub_submit_initial_read() we fully rely on the merge
-	 * to create the minimal amount of bio vectors, for fs block size < page
-	 * size cases.
-	 */
+	ASSERT(offset + fs_info->sectorsize <= BTRFS_STRIPE_LEN);
+
+	if (is_vmalloc_addr(stripe->buffer)) {
+		ret = bio_add_vmalloc(&bbio->bio, stripe->buffer + offset,
+				      fs_info->sectorsize);
+		ASSERT(ret == true);
+		return;
+	}
+	ret = bio_add_page(&bbio->bio, virt_to_page(stripe->buffer + offset),
+			   fs_info->sectorsize, offset_in_page(offset));
 	ASSERT(ret == fs_info->sectorsize);
 }
 
 static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
-					  unsigned int nr_vecs, blk_opf_t opf,
+					  blk_opf_t opf,
 					  u64 logical,
 					  btrfs_bio_end_io_t end_io, void *private)
 {
 	struct btrfs_bio *bbio;
 
-	bbio = btrfs_bio_alloc(nr_vecs, opf, BTRFS_I(fs_info->btree_inode),
+	/*
+	 * Stripe->buffer is allocated by kvmalloc(), which can be pages
+	 * at different physical addresses, we have to ensure the bbio
+	 * is larger enough to contain the full stripe.
+	 */
+	bbio = btrfs_bio_alloc(BTRFS_STRIPE_LEN >> PAGE_SHIFT, opf,
+			       BTRFS_I(fs_info->btree_inode),
 			       logical, end_io, private);
 	bbio->is_scrub = true;
 	bbio->bio.bi_iter.bi_sector = logical >> SECTOR_SHIFT;
@@ -976,7 +954,7 @@ static void scrub_stripe_submit_repair_read(struct scrub_stripe *stripe,
 		}
 
 		if (!bbio)
-			bbio = alloc_scrub_bbio(fs_info, stripe->nr_sectors, REQ_OP_READ,
+			bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
 						stripe->logical + (i << fs_info->sectorsize_bits),
 						scrub_repair_read_endio, stripe);
 
@@ -1245,6 +1223,7 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
 static void scrub_read_endio(struct btrfs_bio *bbio)
 {
 	struct scrub_stripe *stripe = bbio->private;
+	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
 	int sector_nr = calc_sector_number(stripe, bio_first_bvec_all(&bbio->bio));
 	int num_sectors;
 	const u32 bio_size = bio_get_size(&bbio->bio);
@@ -1252,6 +1231,10 @@ static void scrub_read_endio(struct btrfs_bio *bbio)
 	ASSERT(sector_nr < stripe->nr_sectors);
 	num_sectors = bio_size >> stripe->bg->fs_info->sectorsize_bits;
 
+	if (is_vmalloc_addr(stripe->buffer))
+		invalidate_kernel_vmap_range(
+			stripe->buffer + (sector_nr << fs_info->sectorsize_bits),
+			bio_size);
 	if (bbio->bio.bi_status) {
 		scrub_bitmap_set_io_error(stripe, sector_nr, num_sectors);
 		scrub_bitmap_set_error(stripe, sector_nr, num_sectors);
@@ -1349,7 +1332,7 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
 			bbio = NULL;
 		}
 		if (!bbio)
-			bbio = alloc_scrub_bbio(fs_info, stripe->nr_sectors, REQ_OP_WRITE,
+			bbio = alloc_scrub_bbio(fs_info, REQ_OP_WRITE,
 					stripe->logical + (sector_nr << fs_info->sectorsize_bits),
 					scrub_write_endio, stripe);
 		scrub_bio_add_sector(bbio, stripe, sector_nr);
@@ -1844,7 +1827,7 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 				continue;
 			}
 
-			bbio = alloc_scrub_bbio(fs_info, stripe->nr_sectors, REQ_OP_READ,
+			bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
 						logical, scrub_read_endio, stripe);
 		}
 
@@ -1869,7 +1852,6 @@ static void scrub_submit_initial_read(struct scrub_ctx *sctx,
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct btrfs_bio *bbio;
-	const u32 min_folio_shift = PAGE_SHIFT + fs_info->block_min_order;
 	unsigned int nr_sectors = stripe_length(stripe) >> fs_info->sectorsize_bits;
 	int mirror = stripe->mirror_num;
 
@@ -1882,7 +1864,7 @@ static void scrub_submit_initial_read(struct scrub_ctx *sctx,
 		return;
 	}
 
-	bbio = alloc_scrub_bbio(fs_info, BTRFS_STRIPE_LEN >> min_folio_shift, REQ_OP_READ,
+	bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
 				stripe->logical, scrub_read_endio, stripe);
 	/* Read the whole range inside the chunk boundary. */
 	for (unsigned int cur = 0; cur < nr_sectors; cur++)
@@ -2138,7 +2120,7 @@ static int scrub_raid56_cached_parity(struct scrub_ctx *sctx,
 	for (int i = 0; i < data_stripes; i++) {
 		struct scrub_stripe *stripe = &sctx->raid56_data_stripes[i];
 
-		raid56_parity_cache_data_folios(rbio, stripe->folios,
+		raid56_parity_cache_data_folios(rbio, stripe->buffer,
 				full_stripe_start + (i << BTRFS_STRIPE_LEN_SHIFT));
 	}
 	raid56_parity_submit_scrub_rbio(rbio);
-- 
2.54.0

