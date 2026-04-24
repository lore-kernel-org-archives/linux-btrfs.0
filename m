Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C5633A9F8
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020733; cv=none; b=ZEMGiZ8G4Mn1nKMCJ+id8HtX8wKyPxH15BWgZVh06Hb6cJT3/CzzFyQYSJfv+QIWWBCBEi5N2XQyMEMd+nUlrXumEHGTlnYGo/crVI2d1qS8rcX2rPKOBMuPdnBTbWViY6R8N1dMrEbRXk9qjFTkbmNbnceeXAmfLzsAgyv78/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020733; c=relaxed/simple;
	bh=QQUkvjTwH2xriHI6aItTK2Sj8oa0xjW9tFN6i/IFmzg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A13beHidn3unItPqrnOdDT9FS3Nl1VIvvR5YDRs1knsO8Vvo4vSVdw9MDrXMwZ9pFUmU41elFeKefmDn/xpaLKXpxWiAHikwVov8RuoOtWg00t1V2iLIf+ZxJh49dH54E0ZPUvo+0ylG9hPj92Ta4f5zeKxU4bj3pv6d9RZuK2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dVsVbbas; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dVsVbbas; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dVsVbbas";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dVsVbbas"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 968076A8A2
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2eKcEs1E9JwIlJTeI+ZIxOZwOFB8P/zWLLBxMh/nVk=;
	b=dVsVbbasnjX0JlpsvTDnyrESHJUo7jvB/6R2/iq4FboV9VLspJRzVbT+kp4lqoIJnnuswy
	YN1DfARF77jzqvqXRSu4JDK9+icok5vXxHlbI5OdPSxuYnLN3jjjgpCXTfQ4SXuOBEwpis
	xeF/BE5tQL4ckrEQxtbkofqbER6WNoY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2eKcEs1E9JwIlJTeI+ZIxOZwOFB8P/zWLLBxMh/nVk=;
	b=dVsVbbasnjX0JlpsvTDnyrESHJUo7jvB/6R2/iq4FboV9VLspJRzVbT+kp4lqoIJnnuswy
	YN1DfARF77jzqvqXRSu4JDK9+icok5vXxHlbI5OdPSxuYnLN3jjjgpCXTfQ4SXuOBEwpis
	xeF/BE5tQL4ckrEQxtbkofqbER6WNoY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9344B593A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cOA6EDYv62m2HQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 3/5] btrfs: migrate btrfs_bio_ctrl::submit_bitmap to support larger bitmaps
Date: Fri, 24 Apr 2026 18:21:32 +0930
Message-ID: <155060dc6485432ed47180b023ca3a298f513dae.1777019132.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777019132.git.wqu@suse.com>
References: <cover.1777019132.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

[CURRENT LIMIT]
Btrfs currently only supports sub-bitmaps (e.g. dirty bitmap) no larger
than BITS_PER_LONG.

One call site that utilizes this limit is btrfs_bio_ctrl::submit_bitmap,
which makes it very simple and straightforward to just grab an unsigned
long value and assign it to submit_bitmap.

Unfortunately that limit prevents us from supporting huge folios, which
means order 9 and for 4K page size and block size, it means 512 blocks
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

- @range_bit inside extent_writepage_io()
  Which is only utilized to truncate the bitmap.
  Since we do not want to allocate new memory just for such temporary
  usage, change the original bitmap_set() and bitmap_and() into a loop
  to clear unrelated bits from the submit bitmap.

- Getting dirty subpage bitmap inside writepage_delalloc()
  Since we're passing an unsigned long pointer now, we need to go with
  different handling (bs == ps, blocks_per_folio <= BITS_PER_LONG,
  blocks_per_folio > BITS_PER_LONG).

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 82 +++++++++++++++++++++++++++++++-------------
 fs/btrfs/subpage.c   | 29 +++++++++++-----
 fs/btrfs/subpage.h   |  7 ++--
 3 files changed, 83 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 13b726831aa0..b8dfd8770365 100644
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
@@ -1447,9 +1453,9 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	int ret = 0;
 
 	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
-	bio_ctrl->submit_bitmap = btrfs_get_subpage_dirty_bitmap_value(fs_info, folio);
+	btrfs_copy_subpage_dirty_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
 
-	for_each_set_bitrange(start_bit, end_bit, &bio_ctrl->submit_bitmap,
+	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 			      blocks_per_folio) {
 		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 		u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
@@ -1525,7 +1531,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 					     btrfs_ino(inode),
 					     folio_pos(folio),
 					     blocks_per_folio,
-					     &bio_ctrl->submit_bitmap,
+					     bio_ctrl->submit_bitmap,
 					     found_start, found_len, ret);
 		} else {
 			/*
@@ -1550,7 +1556,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 						 fs_info->sectorsize_bits;
 			unsigned int end_bit = (min(page_end + 1, found_start + found_len) -
 						page_start) >> fs_info->sectorsize_bits;
-			bitmap_clear(&bio_ctrl->submit_bitmap, start_bit, end_bit - start_bit);
+			bitmap_clear(bio_ctrl->submit_bitmap, start_bit, end_bit - start_bit);
 		}
 		/*
 		 * Above btrfs_run_delalloc_range() may have unlocked the folio,
@@ -1571,7 +1577,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 				fs_info->sectorsize_bits,
 				blocks_per_folio);
 
-		for_each_set_bitrange(start_bit, end_bit, &bio_ctrl->submit_bitmap,
+		for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 				      bitmap_size) {
 			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
@@ -1597,7 +1603,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	 * If all ranges are submitted asynchronously, we just need to account
 	 * for them here.
 	 */
-	if (bitmap_empty(&bio_ctrl->submit_bitmap, blocks_per_folio)) {
+	if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
 		wbc->nr_to_write -= delalloc_to_write;
 		return 1;
 	}
@@ -1718,7 +1724,6 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 						  loff_t i_size)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	unsigned long range_bitmap = 0;
 	bool submitted_io = false;
 	int found_error = 0;
 	const u64 end = start + len;
@@ -1746,14 +1751,18 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 		return -EUCLEAN;
 	}
 
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
@@ -1813,6 +1822,32 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
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
+static void bio_ctrl_release_submit_bitmap(struct btrfs_fs_info *fs_info,
+					   struct folio *folio,
+					   struct btrfs_bio_ctrl *bio_ctrl)
+{
+	ASSERT(btrfs_blocks_per_folio(fs_info, folio) <= BITS_PER_LONG);
+
+	bio_ctrl->submit_bitmap = NULL;
+}
+
 /*
  * the writepage semantics are similar to regular writepage.  extent
  * records are inserted to lock ranges in the tree, and as dirty areas
@@ -1847,12 +1882,7 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
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
@@ -1877,21 +1907,25 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 		goto done;
 
 	ret = writepage_delalloc(inode, folio, bio_ctrl);
-	if (ret == 1)
+	if (ret == 1) {
+		bio_ctrl_release_submit_bitmap(fs_info, folio, bio_ctrl);
 		return 0;
+	}
 	if (ret)
 		goto done;
 
 	ret = extent_writepage_io(inode, folio, folio_pos(folio),
 				  folio_size(folio), bio_ctrl, i_size);
-	if (ret == 1)
+	if (ret == 1) {
+		bio_ctrl_release_submit_bitmap(fs_info, folio, bio_ctrl);
 		return 0;
+	}
 	if (unlikely(ret < 0))
 		btrfs_err_rl(fs_info,
 "failed to submit blocks, root=%lld inode=%llu folio=%llu submit_bitmap=%*pbl: %d",
 			     btrfs_root_id(inode->root), btrfs_ino(inode),
 			     folio_pos(folio), blocks_per_folio,
-			     &bio_ctrl->submit_bitmap, ret);
+			     bio_ctrl->submit_bitmap, ret);
 
 	bio_ctrl->wbc->nr_to_write--;
 
@@ -1903,6 +1937,7 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 	 * submitted ranges inside the folio.
 	 */
 	btrfs_folio_end_lock_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
+	bio_ctrl_release_submit_bitmap(fs_info, folio, bio_ctrl);
 	ASSERT(ret <= 0);
 	return ret;
 }
@@ -2638,7 +2673,7 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 		 * Set the submission bitmap to submit all sectors.
 		 * extent_writepage_io() will do the truncation correctly.
 		 */
-		bio_ctrl.submit_bitmap = (unsigned long)-1;
+		bio_ctrl_init_submit_bitmap(fs_info, folio, &bio_ctrl);
 		ret = extent_writepage_io(BTRFS_I(inode), folio, cur, cur_len,
 					  &bio_ctrl, i_size);
 		if (ret == 1)
@@ -2650,6 +2685,7 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 		if (ret < 0)
 			found_error = true;
 next_page:
+		bio_ctrl_release_submit_bitmap(fs_info, folio, &bio_ctrl);
 		folio_put(folio);
 		cur = cur_end + 1;
 	}
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 2116a6b4a476..41b369db0839 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -276,7 +276,7 @@ void btrfs_folio_end_lock(const struct btrfs_fs_info *fs_info,
 }
 
 void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
-				 struct folio *folio, unsigned long bitmap)
+				 struct folio *folio, unsigned long *bitmap)
 {
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
@@ -298,7 +298,7 @@ void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
 	}
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	for_each_set_bit(bit, &bitmap, blocks_per_folio) {
+	for_each_set_bit(bit, bitmap, blocks_per_folio) {
 		if (test_and_clear_bit(bit + start_bit, bfs->bitmaps))
 			cleared++;
 	}
@@ -794,24 +794,35 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
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
index 9e92877e7251..b45694eecb41 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -131,7 +131,7 @@ void btrfs_folio_end_lock(const struct btrfs_fs_info *fs_info,
 void btrfs_folio_set_lock(const struct btrfs_fs_info *fs_info,
 			  struct folio *folio, u64 start, u32 len);
 void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
-				 struct folio *folio, unsigned long bitmap);
+				 struct folio *folio, unsigned long *bitmap);
 /*
  * Template for subpage related operations.
  *
@@ -200,8 +200,9 @@ bool btrfs_subpage_clear_and_test_dirty(const struct btrfs_fs_info *fs_info,
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
2.53.0

