Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC361F92E
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776129437; cv=none; b=XrssTUlQFwRqTzPEmDDfXNMZfkkl04uORq9vZc59mf9UOyU4H40VefdgDoBV9PZn9FSysO9D8+nSZt0gLN4JzHZHAqty1x4sNw3TyVvURK3nh6NpRpm+94rjECcE0hOk7SY76h/mAXmggv3RqAwuAqfX2kLgX7iQlLcXNSkplko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776129437; c=relaxed/simple;
	bh=Njap4++hESmHrL4Hnuf7xa5ZeRtVBrZXBE7/QT+o4tA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM6ryQmOjAN952vYfxoO6kH4v2QLvQZT8cbDdDgdSQ4geSLBJha0CZSWmn4+dPvQtc3cv4G26d5R7E2Xc7k4jg+90rI51JTfbqw3dTLsMHIyPnzD3rwA67kpeyFP+YudKxkK/E1eMUcgjeKUvA8EgdTlq7N/3EixnZZQqut3IBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nto9LYY0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nto9LYY0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nto9LYY0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nto9LYY0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 092385BE19
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776129423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ks3+jSDno3tVxFua2Q/nbaCdKLiGqc9rduY+Gyt8deg=;
	b=nto9LYY09lnM65nEVl72sKHfv265vFryYXCH7WedkY+nZ5WHgZzg+rObsB4kEN7RW85NK+
	ztwYdlBQvSaJy8mLROBI9k+W0qFxY3AMKMWIUiNNmFT0FF55yyWqoQSeN/XSQT7Hvc2EXd
	hSjE6OVZsGYEZm+KDo5XsU1P89dut68=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776129423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ks3+jSDno3tVxFua2Q/nbaCdKLiGqc9rduY+Gyt8deg=;
	b=nto9LYY09lnM65nEVl72sKHfv265vFryYXCH7WedkY+nZ5WHgZzg+rObsB4kEN7RW85NK+
	ztwYdlBQvSaJy8mLROBI9k+W0qFxY3AMKMWIUiNNmFT0FF55yyWqoQSeN/XSQT7Hvc2EXd
	hSjE6OVZsGYEZm+KDo5XsU1P89dut68=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48ED64B1A3
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AHaBA46V3WmEbgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: remove folio checked subpage bitmap tracking
Date: Tue, 14 Apr 2026 10:46:42 +0930
Message-ID: <b289d7c0d53fa5a5d8da52a9c95678b778a632e4.1776129347.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776129347.git.wqu@suse.com>
References: <cover.1776129347.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
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

The folio checked flag is only utilized by the COW fixup mechanism
inside btrfs.

Since the COW fixup is already removed from non-experimental builds,
there is no need to keep the checked subpage bitmap.

This will saves us some space for large folios, for example for a single
256K sized large folio on 4K page sized systems:

 Old bitmap size = 6 * (256K / 4K / 8) = 48 bytes
 New bitmap size = 5 * (256K / 4K / 8) = 40 bytes

This will be more obvious when we're going to support huge folios (order
= 9).

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/defrag.c           |  1 -
 fs/btrfs/file.c             | 12 +-----------
 fs/btrfs/free-space-cache.c |  4 ----
 fs/btrfs/inode.c            |  3 ---
 fs/btrfs/reflink.c          |  1 -
 fs/btrfs/subpage.c          | 39 ++-----------------------------------
 fs/btrfs/subpage.h          |  5 +----
 7 files changed, 4 insertions(+), 61 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4..af40ad62009a 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1179,7 +1179,6 @@ static int defrag_one_locked_target(struct btrfs_inode *inode,
 		if (start >= folio_next_pos(folio) ||
 		    start + len <= folio_pos(folio))
 			continue;
-		btrfs_folio_clamp_clear_checked(fs_info, folio, start, len);
 		btrfs_folio_clamp_set_dirty(fs_info, folio, start, len);
 	}
 	btrfs_delalloc_release_extents(inode, len);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cf1cb5c4db75..a6f641a41d99 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -49,14 +49,6 @@ static void btrfs_drop_folio(struct btrfs_fs_info *fs_info, struct folio *folio,
 	u64 block_len = round_up(pos + copied, fs_info->sectorsize) - block_start;
 
 	ASSERT(block_len <= U32_MAX);
-	/*
-	 * Folio checked is some magic around finding folios that have been
-	 * modified without going through btrfs_dirty_folio().  Clear it here.
-	 * There should be no need to mark the pages accessed as
-	 * prepare_one_folio() should have marked them accessed in
-	 * prepare_one_folio() via find_or_create_page()
-	 */
-	btrfs_folio_clamp_clear_checked(fs_info, folio, block_start, block_len);
 	folio_unlock(folio);
 	folio_put(folio);
 }
@@ -65,7 +57,7 @@ static void btrfs_drop_folio(struct btrfs_fs_info *fs_info, struct folio *folio,
  * After copy_folio_from_iter_atomic(), update the following things for delalloc:
  * - Mark newly dirtied folio as DELALLOC in the io tree.
  *   Used to advise which range is to be written back.
- * - Mark modified folio as Uptodate/Dirty and not needing COW fixup
+ * - Mark modified folio as Uptodate/Dirty
  * - Update inode size for past EOF write
  */
 int btrfs_dirty_folio(struct btrfs_inode *inode, struct folio *folio, loff_t pos,
@@ -107,7 +99,6 @@ int btrfs_dirty_folio(struct btrfs_inode *inode, struct folio *folio, loff_t pos
 		return ret;
 
 	btrfs_folio_clamp_set_uptodate(fs_info, folio, start_pos, num_bytes);
-	btrfs_folio_clamp_clear_checked(fs_info, folio, start_pos, num_bytes);
 	btrfs_folio_clamp_set_dirty(fs_info, folio, start_pos, num_bytes);
 
 	/*
@@ -1987,7 +1978,6 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	if (zero_start != fsize)
 		folio_zero_range(folio, zero_start, folio_size(folio) - zero_start);
 
-	btrfs_folio_clear_checked(fs_info, folio, page_start, fsize);
 	btrfs_folio_set_dirty(fs_info, folio, page_start, end + 1 - page_start);
 	btrfs_folio_set_uptodate(fs_info, folio, page_start, end + 1 - page_start);
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ab22e4f9ffdd..07567fd45634 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -433,10 +433,6 @@ static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
 
 	for (i = 0; i < io_ctl->num_pages; i++) {
 		if (io_ctl->pages[i]) {
-			btrfs_folio_clear_checked(io_ctl->fs_info,
-					page_folio(io_ctl->pages[i]),
-					page_offset(io_ctl->pages[i]),
-					PAGE_SIZE);
 			unlock_page(io_ctl->pages[i]);
 			put_page(io_ctl->pages[i]);
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 29a624a2c611..b13a0a322e23 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5033,8 +5033,6 @@ int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 e
 	folio_zero_range(folio, zero_start - folio_pos(folio),
 			 zero_end - zero_start + 1);
 
-	btrfs_folio_clear_checked(fs_info, folio, block_start,
-				  block_end + 1 - block_start);
 	btrfs_folio_set_dirty(fs_info, folio, block_start,
 			      block_end + 1 - block_start);
 
@@ -7651,7 +7649,6 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	 * did something wrong.
 	 */
 	ASSERT(!folio_test_ordered(folio));
-	btrfs_folio_clear_checked(fs_info, folio, folio_pos(folio), folio_size(folio));
 	if (!inode_evicting)
 		__btrfs_release_folio(folio, GFP_NOFS);
 	clear_folio_extent_mapped(folio);
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 49865a463780..14742abe0f92 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -141,7 +141,6 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
 		folio_zero_range(folio, datal, block_size - datal);
 
 	btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size);
-	btrfs_folio_clear_checked(fs_info, folio, file_offset, block_size);
 	btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);
 out_unlock:
 	if (!IS_ERR(folio)) {
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index f82e71f5d88b..8a09f34ea31e 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -508,35 +508,6 @@ void btrfs_subpage_clear_ordered(const struct btrfs_fs_info *fs_info,
 	spin_unlock_irqrestore(&bfs->lock, flags);
 }
 
-void btrfs_subpage_set_checked(const struct btrfs_fs_info *fs_info,
-			       struct folio *folio, u64 start, u32 len)
-{
-	struct btrfs_folio_state *bfs = folio_get_private(folio);
-	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
-							checked, start, len);
-	unsigned long flags;
-
-	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
-	if (subpage_test_bitmap_all_set(fs_info, folio, checked))
-		folio_set_checked(folio);
-	spin_unlock_irqrestore(&bfs->lock, flags);
-}
-
-void btrfs_subpage_clear_checked(const struct btrfs_fs_info *fs_info,
-				 struct folio *folio, u64 start, u32 len)
-{
-	struct btrfs_folio_state *bfs = folio_get_private(folio);
-	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
-							checked, start, len);
-	unsigned long flags;
-
-	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
-	folio_clear_checked(folio);
-	spin_unlock_irqrestore(&bfs->lock, flags);
-}
-
 /*
  * Unlike set/clear which is dependent on each page status, for test all bits
  * are tested in the same way.
@@ -561,7 +532,6 @@ IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(uptodate);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(dirty);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(writeback);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(ordered);
-IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(checked);
 
 /*
  * Note that, in selftests (extent-io-tests), we can have empty fs_info passed
@@ -659,8 +629,6 @@ IMPLEMENT_BTRFS_PAGE_OPS(writeback, folio_start_writeback, folio_end_writeback,
 			 folio_test_writeback);
 IMPLEMENT_BTRFS_PAGE_OPS(ordered, folio_set_ordered, folio_clear_ordered,
 			 folio_test_ordered);
-IMPLEMENT_BTRFS_PAGE_OPS(checked, folio_set_checked, folio_clear_checked,
-			 folio_test_checked);
 
 #define GET_SUBPAGE_BITMAP(fs_info, folio, name, dst)			\
 {									\
@@ -782,7 +750,6 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	unsigned long dirty_bitmap;
 	unsigned long writeback_bitmap;
 	unsigned long ordered_bitmap;
-	unsigned long checked_bitmap;
 	unsigned long locked_bitmap;
 	unsigned long flags;
 
@@ -795,20 +762,18 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 	GET_SUBPAGE_BITMAP(fs_info, folio, dirty, &dirty_bitmap);
 	GET_SUBPAGE_BITMAP(fs_info, folio, writeback, &writeback_bitmap);
 	GET_SUBPAGE_BITMAP(fs_info, folio, ordered, &ordered_bitmap);
-	GET_SUBPAGE_BITMAP(fs_info, folio, checked, &checked_bitmap);
 	GET_SUBPAGE_BITMAP(fs_info, folio, locked, &locked_bitmap);
 	spin_unlock_irqrestore(&bfs->lock, flags);
 
 	dump_page(folio_page(folio, 0), "btrfs folio state dump");
 	btrfs_warn(fs_info,
-"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl locked=%*pbl writeback=%*pbl ordered=%*pbl checked=%*pbl",
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl locked=%*pbl writeback=%*pbl ordered=%*pbl",
 		    start, len, folio_pos(folio),
 		    blocks_per_folio, &uptodate_bitmap,
 		    blocks_per_folio, &dirty_bitmap,
 		    blocks_per_folio, &locked_bitmap,
 		    blocks_per_folio, &writeback_bitmap,
-		    blocks_per_folio, &ordered_bitmap,
-		    blocks_per_folio, &checked_bitmap);
+		    blocks_per_folio, &ordered_bitmap);
 }
 
 void btrfs_get_subpage_dirty_bitmap(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index d81a0ade559f..fdea0b605bfc 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -41,11 +41,9 @@ enum {
 	btrfs_bitmap_nr_writeback,
 
 	/*
-	 * The ordered and checked flags are for COW fixup, already marked
-	 * deprecated, and will be removed eventually.
+	 * The ordered flags shows if the range has an ordered extent.
 	 */
 	btrfs_bitmap_nr_ordered,
-	btrfs_bitmap_nr_checked,
 
 	/*
 	 * The locked bit is for async delalloc range (compression), currently
@@ -182,7 +180,6 @@ DECLARE_BTRFS_SUBPAGE_OPS(uptodate);
 DECLARE_BTRFS_SUBPAGE_OPS(dirty);
 DECLARE_BTRFS_SUBPAGE_OPS(writeback);
 DECLARE_BTRFS_SUBPAGE_OPS(ordered);
-DECLARE_BTRFS_SUBPAGE_OPS(checked);
 
 /*
  * Helper for error cleanup, where a folio will have its dirty flag cleared,
-- 
2.53.0

