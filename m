Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5523D649D
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 11:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782990839; cv=none; b=d7eDV+ar4y4JMlEm4AVq/rdAE02Q/LWW7UGRqb8of3VWpPoQ3s/0o78eyYZW2zG87WidreN5pJJEZjg+Upmbya/1VdWgv8/8uyqQKepOlvwlyQUtzumqx30InxPZZydDmURtRr10rB54CoCxmwG4ZWHFgLOuqwMah52sOXdhFV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782990839; c=relaxed/simple;
	bh=D1AOWtOwNpvFof6pv//JfFURI4XU2byWp8zFMrFDeUo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za5qBUdB8ZbSy5J/5OHi8vVTFeL0y/m1h06Wv81cVzLpxCCornqk52aHXTRtD/gQgMJV3+RqOzFqlkA5fUoXTE/HWFfkged2ORUSxJgQV/+kbmGm66A9ChIz8cmbxqi3G55GywDp2QGeIQsmisKY4swWiTK9o2V2M8jKG94DovI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k25oFKpO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k25oFKpO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k25oFKpO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k25oFKpO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 560937416B
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 11:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782990836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jScngd1ZEBETQ5PShB+YBxsphNiRt/DegbHtWoiJ2bE=;
	b=k25oFKpOLzl0Zi3bl9s7F96FYfok0OtyBWghtLZQh38IX5c+Rq27MHhYhv6pfkn4b+vL13
	ZOzUI4OCGXraKApK1WeHgLDPOAk8+6+ASykAW0vtHo2S9wNCcfIO1VayN+u6rDj2Rz54P1
	ecZ/iK+2nwoMTubcEfG2xgvU2qVDl+o=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782990836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jScngd1ZEBETQ5PShB+YBxsphNiRt/DegbHtWoiJ2bE=;
	b=k25oFKpOLzl0Zi3bl9s7F96FYfok0OtyBWghtLZQh38IX5c+Rq27MHhYhv6pfkn4b+vL13
	ZOzUI4OCGXraKApK1WeHgLDPOAk8+6+ASykAW0vtHo2S9wNCcfIO1VayN+u6rDj2Rz54P1
	ecZ/iK+2nwoMTubcEfG2xgvU2qVDl+o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E1D6779AA
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 11:13:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KLUjBPNHRmrYZgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 11:13:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: replace btrfs_repair_io_failure() to use bio for page iteration
Date: Thu,  2 Jul 2026 20:43:33 +0930
Message-ID: <92a550c7634676991131efeb20112f53a51ef73d.1782990655.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782990655.git.wqu@suse.com>
References: <cover.1782990655.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
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

Currently btrfs_repair_io_failure() uses a @paddrs[] array to iterate
pages.

Such a parameter is required for bs > ps cases, so that one fs block may
cross several pages.

However there is a much simpler and existing way to iterate pages: bio
and bvec_iter.

This changes btrfs_repair_io_failure() by:

- Use a const @bvec_iter pointer to locate where the pages are
- Extract file offset/logical from the @bbio
- Require no @step parameter
  Above features allow us to shorten the parameter list.

- Rename the function to btrfs_repair_bbio_failure()

- Change the caller in btrfs_repair_eb_io_failure() to allocate a bbio
  Unlike the data read path, we do not have a handy bbio in that case.
  So we need to allocate one just for btrfs_repair_bbio_failure().

- Change the error reporting in btrfs_repair_bbio_failure() to include
  root id and use inode number directly
  Now for btree inode we will report a proper inode number (1).

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/bio.c     | 61 ++++++++++++++++++++++++++--------------------
 fs/btrfs/bio.h     |  5 ++--
 fs/btrfs/disk-io.c | 25 +++++++++++++------
 3 files changed, 55 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index cc0bd03048ba..9d0f72cc37ca 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -186,7 +186,6 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 	 */
 	struct bvec_iter saved_iter = repair_bbio->saved_iter;
 	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	const u64 logical = repair_bbio->saved_iter.bi_sector << SECTOR_SHIFT;
 	const u32 nr_steps = repair_bbio->saved_iter.bi_size / step;
 	int mirror = repair_bbio->mirror_num;
 	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
@@ -220,9 +219,8 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 
 	do {
 		mirror = prev_repair_mirror(fbio, mirror);
-		btrfs_repair_io_failure(fs_info, btrfs_ino(inode),
-				  repair_bbio->file_offset, fs_info->sectorsize,
-				  logical, paddrs, step, mirror);
+		btrfs_repair_bbio_failure(repair_bbio, &repair_bbio->saved_iter,
+					  fs_info->sectorsize, mirror);
 	} while (mirror != fbio->bbio->mirror_num);
 
 done:
@@ -925,21 +923,23 @@ void btrfs_submit_bbio(struct btrfs_bio *bbio, int mirror_num)
  * The I/O is issued synchronously to block the repair read completion from
  * freeing the bio.
  *
- * @ino:	Offending inode number
- * @fileoff:	File offset inside the inode
+ * @bbio:	Original bbio where the repair is needed
+ * @orig_iter:	Points to where the repair start is
  * @length:	Length of the repair write
- * @logical:	Logical address of the range
- * @paddrs:	Physical address array of the content
- * @step:	Length of for each paddrs
  * @mirror_num: Mirror number to write to. Must not be zero
  */
-int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
-			    u32 length, u64 logical, const phys_addr_t paddrs[],
-			    unsigned int step, int mirror_num)
+int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
+			      u32 length, int mirror_num)
 {
-	const u32 nr_steps = DIV_ROUND_UP_POW2(length, step);
+	struct btrfs_inode *inode = bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_io_stripe smap = { 0 };
-	struct bio *bio = NULL;
+	struct bvec_iter iter = *orig_iter;
+	struct bio *repair_bio = NULL;
+	const u64 logical = iter.bi_sector << SECTOR_SHIFT;
+	const u64 fileoff = bbio->file_offset +
+			    ((iter.bi_sector - bbio->saved_iter.bi_sector) << SECTOR_SHIFT);
+	u32 cur = 0;
 	int ret = 0;
 
 	BUG_ON(!mirror_num);
@@ -950,8 +950,9 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 	ASSERT(IS_ALIGNED(fileoff, fs_info->sectorsize));
 	/* Either it's a single data or metadata block. */
 	ASSERT(length <= BTRFS_MAX_BLOCKSIZE);
-	ASSERT(step <= length);
-	ASSERT(is_power_of_2(step));
+
+	/* Our current iter should not be before the original bbio saved_iter. */
+	ASSERT(iter.bi_sector >= bbio->saved_iter.bi_sector);
 
 	/*
 	 * The fs either mounted RO or hit critical errors, no need
@@ -979,15 +980,22 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 		goto out_counter_dec;
 	}
 
-	bio = bio_alloc(smap.dev->bdev, nr_steps, REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
-	bio->bi_iter.bi_sector = smap.physical >> SECTOR_SHIFT;
-	for (int i = 0; i < nr_steps; i++) {
-		ret = bio_add_page(bio, phys_to_page(paddrs[i]), step, offset_in_page(paddrs[i]));
-		/* We should have allocated enough slots to contain all the different pages. */
-		ASSERT(ret == step);
+	repair_bio = bio_alloc(smap.dev->bdev, max(1, length >> PAGE_SHIFT),
+			REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
+	repair_bio->bi_iter.bi_sector = smap.physical >> SECTOR_SHIFT;
+	while (cur < length) {
+		struct page *page = bio_iter_page(&bbio->bio, iter);
+		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
+		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), length - cur);
+
+		ret = bio_add_page(repair_bio, page, cur_len, pg_off);
+		ASSERT(ret == cur_len);
+		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
+		cur += cur_len;
 	}
-	ret = submit_bio_wait(bio);
-	bio_put(bio);
+
+	ret = submit_bio_wait(repair_bio);
+	bio_put(repair_bio);
 	if (ret) {
 		/* try to remap that extent elsewhere? */
 		btrfs_dev_stat_inc_and_print(smap.dev, BTRFS_DEV_STAT_WRITE_ERRS);
@@ -995,8 +1003,9 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 	}
 
 	btrfs_info_rl(fs_info,
-		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
-			     ino, fileoff, btrfs_dev_name(smap.dev),
+		"read error corrected: root %llu ino %llu off %llu (dev %s sector %llu)",
+			     btrfs_root_id(inode->root), btrfs_ino(inode), fileoff,
+			     btrfs_dev_name(smap.dev),
 			     smap.physical >> SECTOR_SHIFT);
 	ret = 0;
 
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 303ed6c7103d..b7bd377a0162 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -126,8 +126,7 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status);
 
 void btrfs_submit_bbio(struct btrfs_bio *bbio, int mirror_num);
 void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_replace);
-int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
-			    u32 length, u64 logical, const phys_addr_t paddrs[],
-			    unsigned int step, int mirror_num);
+int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
+			      u32 length, int mirror_num);
 
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 52593423bdc3..01b3287126ea 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -176,19 +176,24 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 				      int mirror_num)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
-	const u32 step = min(fs_info->nodesize, PAGE_SIZE);
-	const u32 nr_steps = eb->len / step;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
+	struct btrfs_bio *bbio;
+	int ret;
 
 	if (sb_rdonly(fs_info->sb))
 		return -EROFS;
 
+	/*
+	 * This bbio is only to queue all pages for btrfs_repair_bbio_failure().
+	 * Thus it will never get its endio called.
+	 */
+	bbio = btrfs_bio_alloc(max(1, fs_info->nodesize >> PAGE_SHIFT), REQ_OP_READ,
+			       BTRFS_I(fs_info->btree_inode), eb->start, NULL, NULL);
+	bbio->bio.bi_iter.bi_sector = eb->start >> SECTOR_SHIFT;
 	for (int i = 0; i < num_extent_pages(eb); i++) {
 		struct folio *folio = eb->folios[i];
 
 		/* No large folio support yet. */
 		ASSERT(folio_order(folio) == 0);
-		ASSERT(i < nr_steps);
 
 		/*
 		 * For nodesize < page size, there is just one paddr, with some
@@ -197,11 +202,17 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 		 * For nodesize >= page size, it's one or more paddrs, and eb->start
 		 * must be aligned to page boundary.
 		 */
-		paddrs[i] = page_to_phys(&folio->page) + offset_in_page(eb->start);
+		ret = bio_add_page(&bbio->bio, &folio->page, min(PAGE_SIZE, fs_info->nodesize),
+				   offset_in_page(eb->start));
+		ASSERT(ret == min(PAGE_SIZE, fs_info->nodesize));
 	}
+	/* Since the bbio is never submitted, we have to save the iter manually. */
+	bbio->saved_iter = bbio->bio.bi_iter;
 
-	return btrfs_repair_io_failure(fs_info, 0, eb->start, eb->len,
-				       eb->start, paddrs, step, mirror_num);
+	ret = btrfs_repair_bbio_failure(bbio, &bbio->saved_iter,
+					fs_info->nodesize, mirror_num);
+	bio_put(&bbio->bio);
+	return ret;
 }
 
 /*
-- 
2.54.0

