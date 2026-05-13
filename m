Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F143890FD
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778647024; cv=none; b=hexaJSdPclm0FgPLyrWesQmnQe1yq0qIFebR9j3YioTOwUtZXGxVOGwiDnh4ho3vDIuiVu33C+IR79bDjiwvprd14UEqZ+pb0KMotbjJVeExDPpAJyu2YjAdEpmoTz3OyrxJKvx3y2MW1WBLKHp05Z3mljLD1uvN0zqdqa8mJXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778647024; c=relaxed/simple;
	bh=ExdKQ+mRjH+y4UZ/duGeE5b/ofpl276AXWyRW/hWQ2I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAMkND+owCWGKeueWkjWy3tgo0CJErGzKugf9+G0fn7xH4qwMCOyrEo94NbQsRIFu2ozK2NfvaGD0iG7f+n4ngfRzkb5z08cYZ5XTHBUzA2snV5TYiMmc3RyQQ09VD07nQL8FNeW1YSQkr4eKR8IpycHLJFzxre+4vkXv++s7Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aoW12Cdf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aoW12Cdf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aoW12Cdf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aoW12Cdf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0287623C5
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B1ktSGHAzjGqxuGh+/P5J+Oy5HgZYt3Ik6LomBl7I24=;
	b=aoW12CdfsUZCinjQppTdKco/0Zd8AAFPnLDjWsQtTiBQ/3wuYhCpuUsQfJL4Nt9emR5h1p
	pK+lZ57UZWhjjPXgnPgm7J/WrMAPeP7UB9lZ/iauorxAxa7Ol6B5L1jg3AvtwpDmnj08Ex
	3FtziCmOepTNizEDpGavcVQZGoWvGQA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=aoW12Cdf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B1ktSGHAzjGqxuGh+/P5J+Oy5HgZYt3Ik6LomBl7I24=;
	b=aoW12CdfsUZCinjQppTdKco/0Zd8AAFPnLDjWsQtTiBQ/3wuYhCpuUsQfJL4Nt9emR5h1p
	pK+lZ57UZWhjjPXgnPgm7J/WrMAPeP7UB9lZ/iauorxAxa7Ol6B5L1jg3AvtwpDmnj08Ex
	3FtziCmOepTNizEDpGavcVQZGoWvGQA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A57A593A9
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0EqiM97/A2r1SQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:46 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: migrate btrfs_bio_ctrl::submit_bitmap to support larger bitmaps
Date: Wed, 13 May 2026 14:06:20 +0930
Message-ID: <b45a03f8f2c9bafec46de4b1e0e1ce8f8c24f14a.1778646753.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778646753.git.wqu@suse.com>
References: <cover.1778646753.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: D0287623C5
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

[CURRENT LIMIT]
Btrfs currently only supports sub-bitmaps (e.g. dirty bitmap) no larger
than BITS_PER_LONG.

One call site that utilizes this limit is btrfs_bio_ctrl::submit_bitmap,
which makes it very simple and straightforward to just grab an unsigned
long value and assign it to submit_bitmap.

Unfortunately that limit prevents us from supporting huge folios.
For 4K page size and block size, a huge folio (order 9) means 512 blocks
inside a 2M folio.

[ENHANCEMENT]
Instead of using a fixed unsigned long value, change
btrfs_bio_ctrl::submit_bitmap to an unsigned long pointer.

And for cases where an unsigned long can hold the whole bitmap,
introduce @submit_bitmap_value, and just point that pointer to that
unsigned long.

Then update all direct users of bio_ctrl->submit_bitmap to use the
pointer version.

There are several call sites that get extra changes:

- @range_bitmap inside extent_writepage_io()
  Which is only utilized to truncate the bitmap.
  Since we do not want to allocate new memory just for such temporary
  usage, change the original bitmap_set() and bitmap_and() into
  bitmap_clear() for the ranges outside of the target range.

- Getting dirty subpage bitmap inside writepage_delalloc()
  Since we're passing an unsigned long pointer now, we need to go with
  different handling (bs == ps, blocks_per_folio <= BITS_PER_LONG,
  blocks_per_folio > BITS_PER_LONG).

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 63 +++++++++++++++++++++++++++++---------------
 fs/btrfs/subpage.c   | 29 +++++++++++++-------
 fs/btrfs/subpage.h   |  7 ++---
 3 files changed, 66 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1dfa3152e4bd..de0f37663790 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -130,7 +130,13 @@ struct btrfs_bio_ctrl {
 	 * extent_writepage_io().
 	 * This is to avoid touching ranges covered by compression/inline.
 	 */
-	unsigned long submit_bitmap;
+	unsigned long *submit_bitmap;
+	/*
+	 * When blocks_per_folio <= BITS_PER_LONG, we can use the inline
+	 * one without allocating memory.
+	 */
+	unsigned long submit_bitmap_value;
+
 	struct readahead_control *ractl;
 
 	/*
@@ -1492,9 +1498,9 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	int ret = 0;
 
 	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
-	bio_ctrl->submit_bitmap = btrfs_get_subpage_dirty_bitmap_value(fs_info, folio);
+	btrfs_copy_subpage_dirty_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
 
-	for_each_set_bitrange(start_bit, end_bit, &bio_ctrl->submit_bitmap,
+	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 			      blocks_per_folio) {
 		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 		u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
@@ -1570,7 +1576,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 					     btrfs_ino(inode),
 					     folio_pos(folio),
 					     blocks_per_folio,
-					     &bio_ctrl->submit_bitmap,
+					     bio_ctrl->submit_bitmap,
 					     found_start, found_len, ret);
 		} else {
 			/*
@@ -1595,7 +1601,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 						 fs_info->sectorsize_bits;
 			unsigned int end_bit = (min(page_end + 1, found_start + found_len) -
 						page_start) >> fs_info->sectorsize_bits;
-			bitmap_clear(&bio_ctrl->submit_bitmap, start_bit, end_bit - start_bit);
+			bitmap_clear(bio_ctrl->submit_bitmap, start_bit, end_bit - start_bit);
 		}
 		/*
 		 * Above btrfs_run_delalloc_range() may have unlocked the folio,
@@ -1616,7 +1622,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 				fs_info->sectorsize_bits,
 				blocks_per_folio);
 
-		for_each_set_bitrange(start_bit, end_bit, &bio_ctrl->submit_bitmap,
+		for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 				      bitmap_size) {
 			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
@@ -1641,7 +1647,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	 * If all ranges are submitted asynchronously, we just need to account
 	 * for them here.
 	 */
-	if (bitmap_empty(&bio_ctrl->submit_bitmap, blocks_per_folio)) {
+	if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
 		wbc->nr_to_write -= delalloc_to_write;
 		return 1;
 	}
@@ -1768,7 +1774,6 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 						  loff_t i_size)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	unsigned long range_bitmap = 0;
 	bool submitted_io = false;
 	int found_error = 0;
 	const u64 end = start + len;
@@ -1783,14 +1788,18 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	ASSERT(end <= folio_end, "start=%llu len=%u folio_start=%llu folio_size=%zu",
 	       start, len, folio_start, folio_size(folio));
 
-	bitmap_set(&range_bitmap, (start - folio_pos(folio)) >> fs_info->sectorsize_bits,
-		   len >> fs_info->sectorsize_bits);
-	bitmap_and(&bio_ctrl->submit_bitmap, &bio_ctrl->submit_bitmap, &range_bitmap,
-		   blocks_per_folio);
+	/* Truncate the submit bitmap to the current range. */
+	if (start > folio_start)
+		bitmap_clear(bio_ctrl->submit_bitmap, 0,
+			     (start - folio_start) >> fs_info->sectorsize_bits);
+	if (start + len < folio_end)
+		bitmap_clear(bio_ctrl->submit_bitmap,
+			     (end - folio_start) >> fs_info->sectorsize_bits,
+			     (folio_end - end) >> fs_info->sectorsize_bits);
 
 	bio_ctrl->end_io_func = end_bbio_data_write;
 
-	for_each_set_bit(bit, &bio_ctrl->submit_bitmap, blocks_per_folio) {
+	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
 		cur = folio_pos(folio) + (bit << fs_info->sectorsize_bits);
 
 		if (cur >= i_size) {
@@ -1849,6 +1858,23 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	return found_error;
 }
 
+static void bio_ctrl_init_submit_bitmap(struct btrfs_fs_info *fs_info,
+					struct folio *folio,
+					struct btrfs_bio_ctrl *bio_ctrl)
+{
+	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
+
+	/* Only supported for blocks per folio <= BITS_PER_LONG for now. */
+	ASSERT(blocks_per_folio <= BITS_PER_LONG);
+	bio_ctrl->submit_bitmap_value = 0;
+	bio_ctrl->submit_bitmap = &bio_ctrl->submit_bitmap_value;
+	/*
+	 * Default to unlock the whole folio.
+	 * The proper bitmap is not initialized until writepage_delalloc().
+	 */
+	bitmap_set(bio_ctrl->submit_bitmap, 0, blocks_per_folio);
+}
+
 /*
  * the writepage semantics are similar to regular writepage.  extent
  * records are inserted to lock ranges in the tree, and as dirty areas
@@ -1883,12 +1909,7 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 	if (folio_contains(folio, end_index))
 		folio_zero_range(folio, pg_offset, folio_size(folio) - pg_offset);
 
-	/*
-	 * Default to unlock the whole folio.
-	 * The proper bitmap can only be initialized until writepage_delalloc().
-	 */
-	bio_ctrl->submit_bitmap = (unsigned long)-1;
-
+	bio_ctrl_init_submit_bitmap(fs_info, folio, bio_ctrl);
 	/*
 	 * If the page is dirty but without private set, it's marked dirty
 	 * without informing the fs.
@@ -1927,7 +1948,7 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 "failed to submit blocks, root=%lld inode=%llu folio=%llu submit_bitmap=%*pbl: %d",
 			     btrfs_root_id(inode->root), btrfs_ino(inode),
 			     folio_pos(folio), blocks_per_folio,
-			     &bio_ctrl->submit_bitmap, ret);
+			     bio_ctrl->submit_bitmap, ret);
 
 	bio_ctrl->wbc->nr_to_write--;
 
@@ -2674,7 +2695,7 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 		 * Set the submission bitmap to submit all sectors.
 		 * extent_writepage_io() will do the truncation correctly.
 		 */
-		bio_ctrl.submit_bitmap = (unsigned long)-1;
+		bio_ctrl_init_submit_bitmap(fs_info, folio, &bio_ctrl);
 		ret = extent_writepage_io(BTRFS_I(inode), folio, cur, cur_len,
 					  &bio_ctrl, i_size);
 		if (ret == 1)
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index fb56eaf52325..df923009060d 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -268,11 +268,11 @@ void btrfs_folio_end_lock(const struct btrfs_fs_info *fs_info,
 }
 
 void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
-				 struct folio *folio, unsigned long bitmap)
+				 struct folio *folio, unsigned long *bitmap)
 {
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	const unsigned int nbits = bitmap_weight(&bitmap, blocks_per_folio);
+	const unsigned int nbits = bitmap_weight(bitmap, blocks_per_folio);
 	unsigned long flags;
 	bool last = false;
 
@@ -731,24 +731,35 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	spin_unlock_irqrestore(&bfs->lock, flags);
 }
 
-unsigned long btrfs_get_subpage_dirty_bitmap_value(struct btrfs_fs_info *fs_info,
-						   struct folio *folio)
+void btrfs_copy_subpage_dirty_bitmap(struct btrfs_fs_info *fs_info,
+				     struct folio *folio,
+				     unsigned long *dst)
 {
 	struct btrfs_folio_state *bfs;
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
 	unsigned long flags;
 	unsigned long value;
 
-	if (blocks_per_folio == 1)
-		return 1;
+	if (blocks_per_folio == 1) {
+		value = 1;
+		bitmap_copy(dst, &value, 1);
+		return;
+	}
 
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
 	ASSERT(blocks_per_folio > 1);
-	ASSERT(blocks_per_folio <= BITS_PER_LONG);
 	bfs = folio_get_private(folio);
 
+	if (blocks_per_folio <= BITS_PER_LONG) {
+		spin_lock_irqsave(&bfs->lock, flags);
+		value = bitmap_read(bfs->bitmaps, btrfs_bitmap_nr_dirty * blocks_per_folio,
+				    blocks_per_folio);
+		spin_unlock_irqrestore(&bfs->lock, flags);
+		bitmap_copy(dst, &value, blocks_per_folio);
+		return;
+	}
 	spin_lock_irqsave(&bfs->lock, flags);
-	value = get_bitmap_value_dirty(fs_info, folio);
+	bitmap_copy(dst, get_bitmap_pointer_dirty(fs_info, folio),
+		    blocks_per_folio);
 	spin_unlock_irqrestore(&bfs->lock, flags);
-	return value;
 }
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index 756c05c89c11..c6d7394e6418 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -116,7 +116,7 @@ void btrfs_folio_end_lock(const struct btrfs_fs_info *fs_info,
 void btrfs_folio_set_lock(const struct btrfs_fs_info *fs_info,
 			  struct folio *folio, u64 start, u32 len);
 void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
-				 struct folio *folio, unsigned long bitmap);
+				 struct folio *folio, unsigned long *bitmap);
 /*
  * Template for subpage related operations.
  *
@@ -184,8 +184,9 @@ bool btrfs_subpage_clear_and_test_dirty(const struct btrfs_fs_info *fs_info,
 void btrfs_folio_assert_not_dirty(const struct btrfs_fs_info *fs_info,
 				  struct folio *folio, u64 start, u32 len);
 bool btrfs_meta_folio_clear_and_test_dirty(struct folio *folio, const struct extent_buffer *eb);
-unsigned long btrfs_get_subpage_dirty_bitmap_value(struct btrfs_fs_info *fs_info,
-						   struct folio *folio);
+void btrfs_copy_subpage_dirty_bitmap(struct btrfs_fs_info *fs_info,
+				     struct folio *folio,
+				     unsigned long *dst);
 void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 				      struct folio *folio, u64 start, u32 len);
 
-- 
2.54.0

