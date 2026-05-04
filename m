Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879272F746D
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777938604; cv=none; b=jvzxdFah3rqxoay3B7XioWIbUhfsmVCuJcTK11uar7K9jB4v471wP8UaCyMzIMO8drvCE5aZR8MRYKKpRsuHiuh/53F+mlau3zBbdbTOvCGqUVbj+iEtWfrb52JRSE9YoUnEicblYHkfNAl6Kl0rrUOLS5yK3y1ffqFkUbxFepE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777938604; c=relaxed/simple;
	bh=Bh+HKMuVVBvXHJ29VPIlaOLJmtwnXRNHCRUDSCZ5QrE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlOKG+8xOC+aqwNGEq5ysqxagiXFuZu3goiHm2JVr21dQODxi+sijv/VBR7N0E+vRmqerSwvnCHo3pBM9DBmY6aklEjAOFHes62d3fl+9kGJQWMLlQVbVW6TLr+gWq72PFML/k2y2li0gSMKd4qGrrtuiI8rR36Qe5ADBEEJrQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m8HS1+Qq; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m8HS1+Qq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m8HS1+Qq";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m8HS1+Qq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 763F06B683
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPwva9fSCk2BhF17vIeYPqKZY0ciZAN9f1eEjzuJDRU=;
	b=m8HS1+QqvV0zu5FSaEtNVBV7yTZxTB9F6jVU/iOIFeGVrDPT7DwiCP1xSQfmfesD5X8vdR
	xG63GS9Ocsv+NaZZqTy6zt/KaiC49YahtyoxRWkBIxyZRhZzzfD4s4anhnorTCOW0jN573
	3knFfmJ3wyLXGtCjPfLAiIUSfYJ1bmk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPwva9fSCk2BhF17vIeYPqKZY0ciZAN9f1eEjzuJDRU=;
	b=m8HS1+QqvV0zu5FSaEtNVBV7yTZxTB9F6jVU/iOIFeGVrDPT7DwiCP1xSQfmfesD5X8vdR
	xG63GS9Ocsv+NaZZqTy6zt/KaiC49YahtyoxRWkBIxyZRhZzzfD4s4anhnorTCOW0jN573
	3knFfmJ3wyLXGtCjPfLAiIUSfYJ1bmk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4D6A593A3
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OHusHZow+WmKAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 23:49:46 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 4/4] btrfs: remove folio ordered flag and subpage bitmap
Date: Tue,  5 May 2026 09:19:24 +0930
Message-ID: <abaceba41efbbb58282be1201fe60c1ae62161d8.1777937175.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777937175.git.wqu@suse.com>
References: <cover.1777937175.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	TO_DN_NONE(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Btrfs has an internal flag/subpage bitmap called ordered, which is to
indicate that a block has corresponding ordered extent covering it.

However this requires extra synchronization between the inode ordered
tree, and the folio flag/subpage bitmap, not to mention we need to
maintain the extra folio flag with subpage bitmap.

As a step to align btrfs_folio_state more close to iomap_folio_state,
remove the btrfs specific ordered flag/bitmap.

This will also save us 64 bytes for the bitmap of a huge folio.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c |  6 ------
 fs/btrfs/extent_io.h |  1 -
 fs/btrfs/fs.h        |  8 --------
 fs/btrfs/inode.c     | 31 ++-----------------------------
 fs/btrfs/subpage.c   | 41 ++---------------------------------------
 fs/btrfs/subpage.h   | 12 +++---------
 6 files changed, 7 insertions(+), 92 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d178f48ee5f0..8a0da0b1aaf2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -251,8 +251,6 @@ static void process_one_folio(struct btrfs_fs_info *fs_info,
 	ASSERT(end + 1 - start != 0 && end + 1 - start < U32_MAX);
 	len = end + 1 - start;
 
-	if (page_ops & PAGE_SET_ORDERED)
-		btrfs_folio_clamp_set_ordered(fs_info, folio, start, len);
 	if (page_ops & PAGE_START_WRITEBACK) {
 		btrfs_folio_clamp_clear_dirty(fs_info, folio, start, len);
 		btrfs_folio_clamp_set_writeback(fs_info, folio, start, len);
@@ -531,7 +529,6 @@ static void end_bbio_data_write(struct btrfs_bio *bbio)
 		u32 len = fi.length;
 
 		bio_size += len;
-		btrfs_folio_clear_ordered(fs_info, folio, start, len);
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
 
@@ -1597,7 +1594,6 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
 
-			btrfs_folio_clear_ordered(fs_info, folio, start, len);
 			btrfs_mark_ordered_io_finished(inode, start, len, false);
 		}
 		return ret;
@@ -1674,7 +1670,6 @@ static int submit_one_sector(struct btrfs_inode *inode,
 		 * ordered extent.
 		 */
 		btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
-		btrfs_folio_clear_ordered(fs_info, folio, filepos, sectorsize);
 		btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
 		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
 
@@ -1797,7 +1792,6 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			spin_unlock(&inode->ordered_tree_lock);
 			btrfs_put_ordered_extent(ordered);
 
-			btrfs_folio_clear_ordered(fs_info, folio, cur, fs_info->sectorsize);
 			btrfs_mark_ordered_io_finished(inode, cur, fs_info->sectorsize, true);
 			/*
 			 * This range is beyond i_size, thus we don't need to
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 29c57623385d..2324c14a5ecd 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -55,7 +55,6 @@ enum {
 	/* Page starts writeback, clear dirty bit and set writeback bit */
 	ENUM_BIT(PAGE_START_WRITEBACK),
 	ENUM_BIT(PAGE_END_WRITEBACK),
-	ENUM_BIT(PAGE_SET_ORDERED),
 };
 
 /*
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 9997bbc1d1e5..e18607170e01 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1213,14 +1213,6 @@ static inline void btrfs_force_shutdown(struct btrfs_fs_info *fs_info)
 	}
 }
 
-/*
- * We use folio flag owner_2 to indicate there is an ordered extent with
- * unfinished IO.
- */
-#define folio_test_ordered(folio)	folio_test_owner_2(folio)
-#define folio_set_ordered(folio)	folio_set_owner_2(folio)
-#define folio_clear_ordered(folio)	folio_clear_owner_2(folio)
-
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 
 #define EXPORT_FOR_TESTS
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61cec1a66baf..8c4d6e427faa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -401,28 +401,6 @@ void btrfs_inode_unlock(struct btrfs_inode *inode, unsigned int ilock_flags)
 static inline void btrfs_cleanup_ordered_extents(struct btrfs_inode *inode,
 						 u64 offset, u64 bytes)
 {
-	pgoff_t index = offset >> PAGE_SHIFT;
-	const pgoff_t end_index = (offset + bytes - 1) >> PAGE_SHIFT;
-	struct folio *folio;
-
-	while (index <= end_index) {
-		folio = filemap_get_folio(inode->vfs_inode.i_mapping, index);
-		if (IS_ERR(folio)) {
-			index++;
-			continue;
-		}
-
-		index = folio_next_index(folio);
-		/*
-		 * Here we just clear all Ordered bits for every page in the
-		 * range, then btrfs_mark_ordered_io_finished() will handle
-		 * the ordered extent accounting for the range.
-		 */
-		btrfs_folio_clamp_clear_ordered(inode->root->fs_info, folio,
-						offset, bytes);
-		folio_put(folio);
-	}
-
 	return btrfs_mark_ordered_io_finished(inode, offset, bytes, false);
 }
 
@@ -1406,7 +1384,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	 * setup for writepage.
 	 */
 	page_ops = ((flags & COW_FILE_RANGE_KEEP_LOCKED) ? 0 : PAGE_UNLOCK);
-	page_ops |= PAGE_SET_ORDERED;
 
 	/*
 	 * Relocation relies on the relocated extents to have exactly the same
@@ -1972,8 +1949,7 @@ static int nocow_one_range(struct btrfs_inode *inode, struct folio *locked_folio
 		goto error;
 	extent_clear_unlock_delalloc(inode, file_pos, end, locked_folio, cached,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
-				     EXTENT_CLEAR_DATA_RESV,
-				     PAGE_SET_ORDERED);
+				     EXTENT_CLEAR_DATA_RESV, 0);
 	return ret;
 
 error:
@@ -7600,10 +7576,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 		 * The range is dirty meaning it has not been submitted.
 		 * Here we need to truncate the OE range as the range will never
 		 * be submitted.
-		 */
-		btrfs_folio_clear_ordered(fs_info, folio, cur, range_len);
-
-		/*
+		 *
 		 * IO on this page will never be started, so we need to account
 		 * for any ordered extents now. Don't clear EXTENT_DELALLOC_NEW
 		 * here, must leave that up for the ordered extent completion.
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index ea202698fa10..29b34ec31d18 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -451,35 +451,6 @@ void btrfs_subpage_clear_writeback(const struct btrfs_fs_info *fs_info,
 	spin_unlock_irqrestore(&bfs->lock, flags);
 }
 
-void btrfs_subpage_set_ordered(const struct btrfs_fs_info *fs_info,
-			       struct folio *folio, u64 start, u32 len)
-{
-	struct btrfs_folio_state *bfs = folio_get_private(folio);
-	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
-							ordered, start, len);
-	unsigned long flags;
-
-	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
-	folio_set_ordered(folio);
-	spin_unlock_irqrestore(&bfs->lock, flags);
-}
-
-void btrfs_subpage_clear_ordered(const struct btrfs_fs_info *fs_info,
-				 struct folio *folio, u64 start, u32 len)
-{
-	struct btrfs_folio_state *bfs = folio_get_private(folio);
-	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
-							ordered, start, len);
-	unsigned long flags;
-
-	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
-	if (subpage_test_bitmap_all_zero(fs_info, folio, ordered))
-		folio_clear_ordered(folio);
-	spin_unlock_irqrestore(&bfs->lock, flags);
-}
-
 /*
  * Unlike set/clear which is dependent on each page status, for test all bits
  * are tested in the same way.
@@ -503,7 +474,6 @@ bool btrfs_subpage_test_##name(const struct btrfs_fs_info *fs_info,	\
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(uptodate);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(dirty);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(writeback);
-IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(ordered);
 
 /*
  * Note that, in selftests (extent-io-tests), we can have empty fs_info passed
@@ -599,8 +569,6 @@ IMPLEMENT_BTRFS_PAGE_OPS(dirty, folio_mark_dirty, folio_clear_dirty_for_io,
 			 folio_test_dirty);
 IMPLEMENT_BTRFS_PAGE_OPS(writeback, folio_start_writeback, folio_end_writeback,
 			 folio_test_writeback);
-IMPLEMENT_BTRFS_PAGE_OPS(ordered, folio_set_ordered, folio_clear_ordered,
-			 folio_test_ordered);
 
 #define DEFINE_GET_SUBPAGE_BITMAP(name)						\
 static inline unsigned long get_bitmap_value_##name(				\
@@ -633,7 +601,6 @@ static inline unsigned long *get_bitmap_pointer_##name(				\
 DEFINE_GET_SUBPAGE_BITMAP(uptodate);
 DEFINE_GET_SUBPAGE_BITMAP(dirty);
 DEFINE_GET_SUBPAGE_BITMAP(writeback);
-DEFINE_GET_SUBPAGE_BITMAP(ordered);
 DEFINE_GET_SUBPAGE_BITMAP(locked);
 
 #define SUBPAGE_DUMP_BITMAP(fs_info, folio, name, start, len)			\
@@ -761,37 +728,33 @@ void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 		unsigned long uptodate;
 		unsigned long dirty;
 		unsigned long writeback;
-		unsigned long ordered;
 		unsigned long locked;
 
 		spin_lock_irqsave(&bfs->lock, flags);
 		uptodate = get_bitmap_value_uptodate(fs_info, folio);
 		dirty = get_bitmap_value_dirty(fs_info, folio);
 		writeback = get_bitmap_value_writeback(fs_info, folio);
-		ordered = get_bitmap_value_ordered(fs_info, folio);
 		locked = get_bitmap_value_locked(fs_info, folio);
 
 		spin_unlock_irqrestore(&bfs->lock, flags);
 
 		btrfs_warn(fs_info,
-"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl ordered=%*pbl locked=%*pbl",
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl locked=%*pbl",
 			    start, len, folio_pos(folio),
 			    blocks_per_folio, &uptodate,
 			    blocks_per_folio, &dirty,
 			    blocks_per_folio, &writeback,
-			    blocks_per_folio, &ordered,
 			    blocks_per_folio, &locked);
 		return;
 	}
 
 	spin_lock_irqsave(&bfs->lock, flags);
 	btrfs_warn(fs_info,
-"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl ordered=%*pbl locked=%*pbl",
+"start=%llu len=%u page=%llu, bitmaps uptodate=%*pbl dirty=%*pbl writeback=%*pbl locked=%*pbl",
 		    start, len, folio_pos(folio),
 		    blocks_per_folio, get_bitmap_pointer_uptodate(fs_info, folio),
 		    blocks_per_folio, get_bitmap_pointer_dirty(fs_info, folio),
 		    blocks_per_folio, get_bitmap_pointer_writeback(fs_info, folio),
-		    blocks_per_folio, get_bitmap_pointer_ordered(fs_info, folio),
 		    blocks_per_folio, get_bitmap_pointer_locked(fs_info, folio));
 	spin_unlock_irqrestore(&bfs->lock, flags);
 }
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index b45694eecb41..dd3ece30ba5f 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -14,15 +14,15 @@ struct folio;
 /*
  * Extra info for subpage bitmap.
  *
- * For subpage we pack all uptodate/dirty/writeback/ordered bitmaps into
+ * For subpage we pack all uptodate/dirty/writeback/locked bitmaps into
  * one larger bitmap.
  *
  * This structure records how they are organized in the bitmap:
  *
- * /- uptodate          /- dirty        /- ordered
+ * /- uptodate          /- dirty        /- locked
  * |			|		|
  * v			v		v
- * |u|u|u|u|........|u|u|d|d|.......|d|d|o|o|.......|o|o|
+ * |u|u|u|u|........|u|u|d|d|.......|d|d|l|l|.......|l|l|
  * |< sectors_per_page >|
  *
  * Unlike regular macro-like enums, here we do not go upper-case names, as
@@ -40,11 +40,6 @@ enum {
 	 */
 	btrfs_bitmap_nr_writeback,
 
-	/*
-	 * The ordered flags shows if the range has an ordered extent.
-	 */
-	btrfs_bitmap_nr_ordered,
-
 	/*
 	 * The locked bit is for async delalloc range (compression), currently
 	 * async extent is queued with the range locked, until the compression
@@ -179,7 +174,6 @@ bool btrfs_meta_folio_test_##name(struct folio *folio, const struct extent_buffe
 DECLARE_BTRFS_SUBPAGE_OPS(uptodate);
 DECLARE_BTRFS_SUBPAGE_OPS(dirty);
 DECLARE_BTRFS_SUBPAGE_OPS(writeback);
-DECLARE_BTRFS_SUBPAGE_OPS(ordered);
 
 /*
  * Helper for error cleanup, where a folio will have its dirty flag cleared,
-- 
2.54.0

