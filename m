Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57DC395D99
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782977841; cv=none; b=dPRedeb0D+aWq/oc2hWZhRVMJfsMw6D02WP440E5yv+TYrn4JD1ZZ65iZmCcHOO01XXqE9opKBJMyjX+zZj5V/uEZJ1wMLQcbuewOmlc5ExVTnNb+59GeRBTuX5bCJRBAEQhpicwKlzuphYNfYl7mFUxkBafTTYaDDNstto5v5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782977841; c=relaxed/simple;
	bh=m9Mhq8cCJdiCGfteyLOjY65C6zRDshcejXVnHFnHkQ4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eh37z9H6OHfAOS0rVSsMKOcHHx92j/Rwx9QgOyx5iHdO1/hDm+iRCscefKXaZUNepAYYNyANQ1iOyalFcnva9uz66yOrvjxD1/tJRmy4x3Wak7J5WYJySa9ZszuRl9sGMq2kh0RdZRNzeAoYDzgu6y1wPfzsT7TqaADJxT+msuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Kt0IcWts; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Kt0IcWts; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Kt0IcWts";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Kt0IcWts"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C8FD7759F7
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782977835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52L94n9nZjKTHRoZK+XyzUdlCw9GMGBHwWZtRdsa4j0=;
	b=Kt0IcWtsUOAWHjSqnSHz5/mGvn++sIK7w/tsmkx1vFTZJ78nuv/WD3K0SiykgMJSKReDuF
	L54hpnkUNneKbYvxf9aeW8W2yiGZqRjJaVb9T9stdwssFSJ50kmnxh2KMN3XBMINYjmK+F
	MEpgDbbUEbUjf1Tx7ogilAF87DpCCTw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782977835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52L94n9nZjKTHRoZK+XyzUdlCw9GMGBHwWZtRdsa4j0=;
	b=Kt0IcWtsUOAWHjSqnSHz5/mGvn++sIK7w/tsmkx1vFTZJ78nuv/WD3K0SiykgMJSKReDuF
	L54hpnkUNneKbYvxf9aeW8W2yiGZqRjJaVb9T9stdwssFSJ50kmnxh2KMN3XBMINYjmK+F
	MEpgDbbUEbUjf1Tx7ogilAF87DpCCTw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D101E779AA
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:37:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EJknICoVRmrOCQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 07:37:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: enhance btrfs_data_csum_ok() to use bio for page iteration
Date: Thu,  2 Jul 2026 17:06:48 +0930
Message-ID: <024628f5abbd24ab6841dfbc3675cefc5f2a6158.1782977445.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782977445.git.wqu@suse.com>
References: <cover.1782977445.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Currently btrfs_data_csum_ok() requires a @paddr[] array to iterate all
possible pages for bs > ps cases.

However for all btrfs_data_csum_ok() call sites, we already have a
btrfs_bio, and the bio infrastructure has many flexible ways to iterate
multiple pages already.

Change btrfs_data_csum_ok() to make full use of btrfs_bio by:

- Change the parameter list to require a @bvec_iter pointer
  And remove @bio_offset, which can be calculated through @bvec_iter and
  bbio->saved_iter.

  Also remove paddrs[], we will iterate all the pages using bio
  interfaces.

- Make the same parameter changes to repair_one_sector()

- Use bio interfaces to iterate pages from a bio

- Rename the function to btrfs_bio_data_csum_ok()

- Remove on-stack paddrs[] array usage

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/bio.c         | 79 +++++++++++++++---------------------------
 fs/btrfs/btrfs_inode.h |  4 +--
 fs/btrfs/inode.c       | 49 ++++++++++++++++++++------
 3 files changed, 69 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 9d0f72cc37ca..de021a9640df 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -180,29 +180,13 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 	struct btrfs_failed_bio *fbio = repair_bbio->private;
 	struct btrfs_inode *inode = repair_bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	/*
-	 * We can not move forward the saved_iter, as it will be later
-	 * utilized by repair_bbio again.
-	 */
-	struct bvec_iter saved_iter = repair_bbio->saved_iter;
-	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	const u32 nr_steps = repair_bbio->saved_iter.bi_size / step;
 	int mirror = repair_bbio->mirror_num;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
-	phys_addr_t paddr;
-	unsigned int slot = 0;
 
-	/* Repair bbio should be eaxctly one block sized. */
+	/* Repair bbio should be exactly one block sized. */
 	ASSERT(repair_bbio->saved_iter.bi_size == fs_info->sectorsize);
 
-	btrfs_bio_for_each_block(paddr, &repair_bbio->bio, &saved_iter, step) {
-		ASSERT(slot < nr_steps);
-		paddrs[slot] = paddr;
-		slot++;
-	}
-
 	if (repair_bbio->bio.bi_status ||
-	    !btrfs_data_csum_ok(repair_bbio, dev, 0, paddrs)) {
+	    !btrfs_bio_data_csum_ok(repair_bbio, &repair_bbio->saved_iter, dev)) {
 		bio_reset(&repair_bbio->bio, NULL, REQ_OP_READ);
 		repair_bbio->bio.bi_iter = repair_bbio->saved_iter;
 
@@ -236,25 +220,21 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
  * read succeeded to restore the redundancy.
  */
 static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
-						  u32 bio_offset,
-						  phys_addr_t paddrs[],
+						  const struct bvec_iter *orig_iter,
 						  struct btrfs_failed_bio *fbio)
 {
 	struct btrfs_inode *inode = failed_bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	const u32 sectorsize = fs_info->sectorsize;
-	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	const u32 nr_steps = sectorsize / step;
-	/*
-	 * For bs > ps cases, the saved_iter can be partially moved forward.
-	 * In that case we should round it down to the block boundary.
-	 */
-	const u64 logical = round_down(failed_bbio->saved_iter.bi_sector << SECTOR_SHIFT,
-				       sectorsize);
 	struct btrfs_bio *repair_bbio;
 	struct bio *repair_bio;
+	struct bvec_iter iter = *orig_iter;
+	const u32 sectorsize = fs_info->sectorsize;
+	const u32 bio_offset = ((iter.bi_sector - failed_bbio->saved_iter.bi_sector) <<
+				SECTOR_SHIFT);
+	const u64 logical = iter.bi_sector << SECTOR_SHIFT;
 	int num_copies;
 	int mirror;
+	u32 cur = 0;
 
 	btrfs_debug(fs_info, "repair read error: read error at %llu",
 		    failed_bbio->file_offset + bio_offset);
@@ -275,17 +255,22 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
 
 	atomic_inc(&fbio->repair_count);
 
-	repair_bio = bio_alloc_bioset(NULL, nr_steps, REQ_OP_READ, GFP_NOFS,
+	repair_bio = bio_alloc_bioset(NULL, max(1, sectorsize >> PAGE_SHIFT),
+				      REQ_OP_READ, GFP_NOFS,
 				      &btrfs_repair_bioset);
 	repair_bio->bi_iter.bi_sector = logical >> SECTOR_SHIFT;
-	for (int i = 0; i < nr_steps; i++) {
+	while (cur < sectorsize) {
+		struct page *page = bio_iter_page(&failed_bbio->bio, iter);
+		const u32 pg_off = bio_iter_offset(&failed_bbio->bio, iter);
+		const u32 cur_len = min(bio_iter_len(&failed_bbio->bio, iter),
+					sectorsize - cur);
 		int ret;
 
-		ASSERT(offset_in_page(paddrs[i]) + step <= PAGE_SIZE);
+		ret = bio_add_page(repair_bio, page, cur_len, pg_off);
+		ASSERT(ret == cur_len);
 
-		ret = bio_add_page(repair_bio, phys_to_page(paddrs[i]), step,
-				   offset_in_page(paddrs[i]));
-		ASSERT(ret == step);
+		bio_advance_iter_single(&failed_bbio->bio, &iter, cur_len);
+		cur += cur_len;
 	}
 
 	repair_bbio = btrfs_bio(repair_bio);
@@ -303,18 +288,16 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	const u32 sectorsize = fs_info->sectorsize;
-	const u32 step = min(sectorsize, PAGE_SIZE);
-	const u32 nr_steps = sectorsize / step;
-	struct bvec_iter *iter = &bbio->saved_iter;
+	struct bvec_iter iter;
 	blk_status_t status = bbio->bio.bi_status;
 	struct btrfs_failed_bio *fbio = NULL;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
-	phys_addr_t paddr;
-	u32 offset = 0;
 
 	/* Read-repair requires the inode field to be set by the submitter. */
 	ASSERT(inode);
 
+	/* The original bbio should be sectorsize aligned. */
+	ASSERT(IS_ALIGNED(bbio->saved_iter.bi_size, sectorsize));
+
 	/*
 	 * Hand off repair bios to the repair code as there is no upper level
 	 * submitter for them.
@@ -327,16 +310,10 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 	/* Clear the I/O error. A failed repair will reset it. */
 	bbio->bio.bi_status = BLK_STS_OK;
 
-	btrfs_bio_for_each_block(paddr, &bbio->bio, iter, step) {
-		paddrs[(offset / step) % nr_steps] = paddr;
-		offset += step;
-
-		if (IS_ALIGNED(offset, sectorsize)) {
-			if (status ||
-			    !btrfs_data_csum_ok(bbio, dev, offset - sectorsize, paddrs))
-				fbio = repair_one_sector(bbio, offset - sectorsize,
-							 paddrs, fbio);
-		}
+	for (iter = bbio->saved_iter; iter.bi_size;
+	     bio_advance_iter(&bbio->bio, &iter, sectorsize)) {
+		if (status || !btrfs_bio_data_csum_ok(bbio, &iter, dev))
+			fbio = repair_one_sector(bbio, &iter, fbio);
 	}
 	if (bbio->csum != bbio->csum_inline)
 		kvfree(bbio->csum);
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 7fdc6c3fd066..940cc1b24d1b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -513,8 +513,8 @@ void btrfs_calculate_block_csum_pages(struct btrfs_fs_info *fs_info,
 				      const phys_addr_t paddrs[], u8 *dest);
 int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8 *csum,
 			   const u8 * const csum_expected);
-bool btrfs_data_csum_ok(struct btrfs_bio *bbio, struct btrfs_device *dev,
-			u32 bio_offset, const phys_addr_t paddrs[]);
+bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
+			    struct btrfs_device *dev);
 noinline int can_nocow_extent(struct btrfs_inode *inode, u64 offset, u64 *len,
 			      struct btrfs_file_extent *file_extent,
 			      bool nowait);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b47e2aa5071d..9c960cf7ccbe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3347,27 +3347,31 @@ int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8
  * different noncontiguous pages.
  *
  * @bbio:	btrfs_io_bio which contains the csum
- * @dev:	device the sector is on
- * @bio_offset:	offset to the beginning of the bio (in bytes)
- * @paddrs:	physical addresses which back the fs block
+ * @orig_iter:	bvec iter pointing to the start of the block
+ * @dev:	device the sector is on (optional)
  *
  * Check if the checksum on a data block is valid.  When a checksum mismatch is
  * detected, report the error and fill the corrupted range with zero.
  *
  * Return %true if the sector is ok or had no checksum to start with, else %false.
  */
-bool btrfs_data_csum_ok(struct btrfs_bio *bbio, struct btrfs_device *dev,
-			u32 bio_offset, const phys_addr_t paddrs[])
+bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
+			    const struct bvec_iter *orig_iter,
+			    struct btrfs_device *dev)
 {
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct bvec_iter iter = *orig_iter;
+	struct btrfs_csum_ctx cctx;
 	const u32 blocksize = fs_info->sectorsize;
-	const u32 step = min(blocksize, PAGE_SIZE);
-	const u32 nr_steps = blocksize / step;
+	const u32 bio_offset = (iter.bi_sector - bbio->saved_iter.bi_sector) << SECTOR_SHIFT;
 	u64 file_offset = bbio->file_offset + bio_offset;
 	u64 end = file_offset + blocksize - 1;
 	u8 *csum_expected;
 	u8 csum[BTRFS_CSUM_SIZE];
+	u32 cur = 0;
+
+	ASSERT(iter.bi_sector >= bbio->saved_iter.bi_sector);
 
 	if (!bbio->csum)
 		return true;
@@ -3383,7 +3387,22 @@ bool btrfs_data_csum_ok(struct btrfs_bio *bbio, struct btrfs_device *dev,
 
 	csum_expected = bbio->csum + (bio_offset >> fs_info->sectorsize_bits) *
 				fs_info->csum_size;
-	btrfs_calculate_block_csum_pages(fs_info, paddrs, csum);
+	btrfs_csum_init(&cctx, fs_info->csum_type);
+	while (cur < blocksize) {
+		struct page *page = bio_iter_page(&bbio->bio, iter);
+		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
+		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), blocksize - cur);
+		void *kaddr;
+
+		kaddr = kmap_local_page(page) + pg_off;
+		btrfs_csum_update(&cctx, kaddr, cur_len);
+		kunmap_local(kaddr);
+
+		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
+		cur += cur_len;
+	}
+	btrfs_csum_final(&cctx, csum);
+
 	if (unlikely(memcmp(csum, csum_expected, fs_info->csum_size) != 0))
 		goto zeroit;
 	return true;
@@ -3393,8 +3412,18 @@ bool btrfs_data_csum_ok(struct btrfs_bio *bbio, struct btrfs_device *dev,
 				    bbio->mirror_num);
 	if (dev)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS);
-	for (int i = 0; i < nr_steps; i++)
-		memzero_page(phys_to_page(paddrs[i]), offset_in_page(paddrs[i]), step);
+	cur = 0;
+	iter = *orig_iter;
+	while (cur < blocksize) {
+		struct page *page = bio_iter_page(&bbio->bio, iter);
+		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
+		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), blocksize - cur);
+
+		memzero_page(page, pg_off, cur_len);
+
+		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
+		cur += cur_len;
+	}
 	return false;
 }
 
-- 
2.54.0

