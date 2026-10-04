Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861B42868B4
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Oct 2026 22:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791154232; cv=none; b=rAyxc3LibGJfHJ6UQ3Ko/k1xounmoUNfIQ+lmUsSbM62d287BORgyEVjojXycgTB2F6aIKChKbkSlU3FGeptk7tVnxsSbb3IVjnO/RiY+s5T9lUXg6sdrFEcJYzeB8yELxU64Bb1SoZCjb6xqkcAMEQjZuTIUeqzXLDlh0ZIoj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791154232; c=relaxed/simple;
	bh=3d4ETrg93qfUx049doZ8MlKliz4hq55eokpNbc8q9j4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLGj9U8/TDr1tb19fF6mH7OZ+nuLvPDzBOxjUP5EFmpWbKgn73J4wmVBMchJXVULD37kcYyQmDT9J1nETgzTOTUNkbZg9pVntsSafwS9zgNfKM3zDtohZ6ZHB/3EjORfH7X3V0zSJwLIiAcMe9fm9cGGJarf9erAAUoOeBmbbZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RD2GxU5B; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kBcNRjPR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RD2GxU5B";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kBcNRjPR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C0E41F449
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Oct 2026 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791154224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TohEO2SR1z4emoiv7QbEOwxHe1schEFuJU5eoYVuWag=;
	b=RD2GxU5BkQ2ghzcW573Tfac1OOQTvu/OXQM+I3QhHGA9jVHa4FuwbFHShSTy+b0Ft4N5Uh
	I9UUTq4GVblVEwW8U20k3xg8vnYrcy9wH8gJCGSJhcSV+AMtdb6qWm9J70ZM7OT4aDxf6k
	A5sC3CaW/r0B8PFDgVKkO8v4JMLSuKo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=kBcNRjPR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791154220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TohEO2SR1z4emoiv7QbEOwxHe1schEFuJU5eoYVuWag=;
	b=kBcNRjPRxkOD43DO0WbY8b448lsA9HmTM2TlZ477WohEgr6HbLVV50gV7pH/hBpu7fTyjT
	1Mn+7CY/vDHcW8b6JLF0Nyz68p1YYH7EDG/mWO+vt+tHZcD5SMYy4rAsS2BIyMWTJElCKT
	jIh8ZCgJhF95YsHEowzY8wXId+J5XyY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05497139D8
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Oct 2026 22:50:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CriGCibYwmqLWgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2026 22:50:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: write back a folio extent-by-extent instead of block-by-block
Date: Mon,  5 Oct 2026 09:19:41 +1030
Message-ID: <4ab62fa0af8b3bc054cb5e1d4a9b85a1590e91b2.1791154046.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791154046.git.wqu@suse.com>
References: <cover.1791154046.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4C0E41F449
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The current dirty folio writeback is still based on a block-by-block
iteration. For a large folio (can be as large as 2M for 4K page size,
EXPERIMENTAL builds), this means we will do 512 checks for each block.

For non-experimental builds, we can still do 64 block checks for a large
folio.

Meanwhile for a lot of cases, the whole folio may belong to a single
ordered extent, thus we can submit the full folio in just one go,
without checking each block.

Optimize the folio writeback behavior to do an extent-by-extent
submission, this is done by:

- Introduce a helper, truncate_ordered_extents_beyond_eof()
  The old code simplified the beyond-EOF OE truncation a lot, now
  we need to iterate through all OEs beyond the EOF and truncate them.

  Since we need to iterate all the OEs, it's not a good idea to nest the
  loop inside the existing location.

  Use a dedicated truncate_ordered_extents_beyond_eof() to do the
  iteration.

- Introduce a helper, find_next_write_range()
  This is to iterate the btrfs_bio::submit_bitmap, to find the next
  contig range.

  The helper will return a bool to indicate if the range should be
  submitted.
  If not, the caller is responsible to skip to the next range.

- Open-code submit_write_sector()
  Now we need to split the write range according to the OE boundary,
  there is no benefit to use submit_write_sector() for the extent based
  iteration.

  Open-code it so we have better control on each range to submit.

- Do extent-by-extent iteration for extent_writepage_io()
  If we reached EOF, truncate_ordered_extents_beyond_eof() will handle
  the OE truncation.

  The range is provided by find_next_write_range(), and truncated by the
  following factors:
  * writeback_bio_size limit
    If the current write can be merged into the existing bio, we need to
    take the existing bio size into consideration.

  * i_size boundary
    If the range crosses i_size, the one part inside i_size will be
    handled as usual. The remaining beyond EOF range is handled in the
    next iteration.

  * Ordered extent boundary

There is also a micro benchmark, showing the best case scenario.

The workload is a very simple xfs_io write, looped 16 times:

 xfs_io -f -c "pwrite -b 2m 0 1G" -c sync $mnt/foobar

The target device is virtio based, with unsafe cache mode, and the host
has more than enough memory to fully contain the file.

This will make the system use the largest page cache folio size
(2M on x86_64).

The benchmark is measuring the runtime of extent_writepage_io(), the
unit is nanoseconds:

Before:

 @extent_writepage_io_ns:
 [32K, 64K)          1786 |@@@@@@@@@@@@@@@@@                                   |
 [64K, 128K)         5196 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
 [128K, 256K)         253 |@@                                                  |
 [256K, 512K)         603 |@@@@@@                                              |
 [512K, 1M)           191 |@                                                   |
 [1M, 2M)              71 |                                                    |
 [2M, 4M)              61 |                                                    |
 [4M, 8M)              31 |                                                    |

 @extent_writepage_io_stats: { .count = 8192, .average = 177055, .total = 1450438916 }

After:

 @extent_writepage_io_ns:
 [512, 1K)             22 |                                                    |
 [1K, 2K)            2411 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        |
 [2K, 4K)            2838 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
 [4K, 8K)            1681 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      |
 [8K, 16K)            335 |@@@@@@                                              |
 [16K, 32K)           754 |@@@@@@@@@@@@@                                       |
 [32K, 64K)            99 |@                                                   |
 [64K, 128K)           25 |                                                    |
 [128K, 256K)           3 |                                                    |
 [256K, 512K)          16 |                                                    |
 [512K, 1M)             2 |                                                    |
 [1M, 2M)               0 |                                                    |
 [2M, 4M)               3 |                                                    |
 [4M, 8M)               3 |                                                    |

 @extent_writepage_io_stats: { .count = 8192, .average = 9917, .total = 81241427 }

There is a 94.4% reduction in the extent_writepage_io() runtime.
The improvement in distribution is more obvious, previously we do not have any
runtime below 32K ns, but now over 99% go below 32K ns.

Note that this microbenchmark won't reflect real world workloads, as IO is
rarely bottlenecked by CPU.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 263 ++++++++++++++++++++++++++-----------------
 1 file changed, 157 insertions(+), 106 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 05e6a97dc15d..1e1aa0e57901 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1811,99 +1811,60 @@ static struct btrfs_ordered_extent *get_oe_from_bbio(const struct btrfs_bio *bbi
 	return oe;
 }
 
-/*
- * Return 0 if we have submitted or queued the sector for submission.
- * Return <0 for critical errors, and the involved sector will be cleaned up.
- *
- * Caller should make sure filepos < i_size and handle filepos >= i_size case.
- */
-static int submit_write_sector(struct btrfs_inode *inode,
-			       struct folio *folio,
-			       u64 filepos, struct btrfs_bio_ctrl *bio_ctrl,
-			       loff_t i_size)
+static void truncate_ordered_extents_beyond_eof(struct btrfs_inode *inode,
+						u64 file_offset, u32 len)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct btrfs_ordered_extent *oe;
-	u64 block_start;
-	u64 disk_bytenr;
-	u64 extent_offset;
-	const u32 sectorsize = fs_info->sectorsize;
-	int ret;
+	u64 cur = file_offset;
+	const u64 next_off = file_offset + len;
 
-	ASSERT(IS_ALIGNED(filepos, sectorsize));
+	while (cur < next_off) {
+		struct btrfs_ordered_extent *ordered;
 
-	/* @filepos >= i_size case should be handled by the caller. */
-	ASSERT(filepos < i_size);
-
-	/* Try to reuse the existing OE from bbio first. */
-	oe = get_oe_from_bbio(bio_ctrl->bbio, filepos);
-	if (!oe)
-		oe = btrfs_lookup_ordered_extent(inode, filepos);
-	if (unlikely(!oe)) {
-		/*
-		 * bio_ctrl may contain a bio crossing several folios.
-		 * Submit it immediately so that the bio has a chance
-		 * to finish normally, other than marked as error.
-		 */
-		submit_one_bio(bio_ctrl);
+		ordered = btrfs_lookup_first_ordered_range(inode, cur, next_off - cur);
+		if (!ordered)
+			break;
 
 		/*
-		 * When submission failed, we should still clear the folio dirty.
-		 * Or the folio will be written back again but without any
-		 * ordered extent.
+		 * The whole range [file_offset, file_offset + len) should all have
+		 * OE coverage.
+		 * Thus every found OE must cover @cur, there should be no gap.
 		 */
-		btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
-		btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
-		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
-
-		/*
-		 * Since there is no bio submitted to finish the ordered
-		 * extent, we have to manually finish this sector.
-		 */
-		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
-					       false);
-		btrfs_err_rl(fs_info,
-		"no ordered extent for root %lld ino %llu filepos %llu",
-			     btrfs_root_id(inode->root), btrfs_ino(inode),
-			     filepos);
-		return -EUCLEAN;
+		ASSERT(in_range(cur, ordered->file_offset, ordered->num_bytes));
+		spin_lock(&inode->ordered_tree_lock);
+		set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
+		ordered->truncated_len = min(ordered->truncated_len,
+					     cur - ordered->file_offset);
+		cur = ordered->file_offset + ordered->num_bytes;
+		spin_unlock(&inode->ordered_tree_lock);
+		btrfs_put_ordered_extent(ordered);
 	}
+}
 
-	extent_offset = filepos - oe->file_offset;
-	ASSERT(filepos < oe->file_offset + oe->num_bytes);
-	ASSERT(IS_ALIGNED(oe->file_offset, sectorsize));
-	ASSERT(IS_ALIGNED(oe->num_bytes, sectorsize));
-	ASSERT(oe->compress_type == BTRFS_COMPRESS_NONE);
-	ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
+static bool find_next_write_range(struct btrfs_fs_info *fs_info,
+				  struct folio *folio,
+				  unsigned long *submit_bitmap,
+				  u64 start, u32 *len_ret)
+{
+	const u64 fpos = folio_pos(folio);
+	const u64 fnext = folio_next_pos(folio);
+	const u32 blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
+	unsigned int start_bit = (start - fpos) >> fs_info->sectorsize_bits;
+	unsigned int next_bit;
+	bool ret;
 
-	block_start = oe->disk_bytenr + oe->offset;
-	disk_bytenr = block_start + extent_offset;
+	ASSERT(IS_ALIGNED(start, fs_info->sectorsize));
+	/* Search start should be inside the folio. */
+	ASSERT(start >= fpos && start < fnext);
 
-	btrfs_put_ordered_extent(oe);
-
-	btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
-	btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
-	/*
-	 * Above call should set the whole folio with writeback flag, even
-	 * just for a single subpage sector.
-	 * As long as the folio is properly locked and the range is correct,
-	 * we should always get the folio with writeback flag.
-	 */
-	ASSERT(folio_test_writeback(folio));
-
-	ret = submit_folio_blocks(bio_ctrl, disk_bytenr, folio,
-				  offset_in_folio(folio, filepos), sectorsize, 0);
-	if (unlikely(ret < 0)) {
-		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
-		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
-					       false);
-		btrfs_err_rl(fs_info,
-		"failed to queue sector for root %lld ino %llu filepos %llu: %pe",
-			     btrfs_root_id(inode->root),
-			     btrfs_ino(inode), filepos, ERR_PTR(ret));
-		return ret;
-	}
-	return 0;
+	ret = test_bit(start_bit, submit_bitmap);
+	if (ret)
+		next_bit = find_next_zero_bit(submit_bitmap, blocks_per_folio,
+					      start_bit);
+	else
+		next_bit = find_next_bit(submit_bitmap, blocks_per_folio,
+					 start_bit);
+	*len_ret = (next_bit - start_bit) << fs_info->sectorsize_bits;
+	return ret;
 }
 
 /*
@@ -1923,12 +1884,12 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	bool submitted_io = false;
 	int found_error = 0;
+	const u32 blocksize = fs_info->sectorsize;
 	const u64 end = start + len;
 	const u64 folio_start = folio_pos(folio);
 	const u64 folio_end = folio_start + folio_size(folio);
-	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
+	const u64 rounded_isize = round_up(i_size, blocksize);
 	u64 cur;
-	int bit;
 	int ret = 0;
 
 	ASSERT(start >= folio_start, "start=%llu folio_start=%llu", start, folio_start);
@@ -1954,27 +1915,28 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 
 	bio_ctrl->end_io_func = end_bbio_data_write;
 
-	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
-		cur = folio_pos(folio) + (bit << fs_info->sectorsize_bits);
+	cur = start;
+	while (cur < end) {
+		struct btrfs_ordered_extent *oe;
+		u64 block_start;
+		u64 disk_bytenr;
+		u64 extent_offset;
+		u32 cur_len;
+		u32 cur_bio_size = bio_ctrl->bbio ?
+				   bio_ctrl->bbio->bio.bi_iter.bi_size : 0;
+		bool dirty;
 
-		if (cur >= i_size) {
-			struct btrfs_ordered_extent *ordered;
+		dirty = find_next_write_range(fs_info, folio, bio_ctrl->submit_bitmap,
+					      cur, &cur_len);
+		if (!dirty) {
+			cur += cur_len;
+			continue;
+		}
 
-			ordered = btrfs_lookup_first_ordered_range(inode, cur,
-								   fs_info->sectorsize);
-			/*
-			 * We have just run delalloc before getting here, so
-			 * there must be an ordered extent.
-			 */
-			ASSERT(ordered != NULL);
-			spin_lock(&inode->ordered_tree_lock);
-			set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
-			ordered->truncated_len = min(ordered->truncated_len,
-						     cur - ordered->file_offset);
-			spin_unlock(&inode->ordered_tree_lock);
-			btrfs_put_ordered_extent(ordered);
-
-			btrfs_mark_ordered_io_finished(inode, cur, fs_info->sectorsize, true);
+		/* Beyond EOF, no need to submit IO. */
+		if (cur >= rounded_isize) {
+			truncate_ordered_extents_beyond_eof(inode, cur, cur_len);
+			btrfs_mark_ordered_io_finished(inode, cur, cur_len, true);
 			/*
 			 * This range is beyond i_size, thus we don't need to
 			 * bother writing back.
@@ -1983,15 +1945,104 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			 * writeback the sectors with subpage dirty bits,
 			 * causing writeback without ordered extent.
 			 */
-			btrfs_folio_clear_dirty(fs_info, folio, cur, fs_info->sectorsize);
+			btrfs_folio_clear_dirty(fs_info, folio, cur, cur_len);
+			cur += cur_len;
 			continue;
 		}
-		ret = submit_write_sector(inode, folio, cur, bio_ctrl, i_size);
+
+		/*
+		 * The range covers the last byte. Limit the range to the
+		 * rounded_isize, and submit the range inside rounded_isize first.
+		 */
+		if (cur + cur_len > rounded_isize && cur < rounded_isize)
+			cur_len = min_t(u64, cur_len, rounded_isize - cur);
+
+		/* @cur >= i_size case should be handled. */
+		ASSERT(cur < i_size);
+
+		/* Try to reuse the existing OE from bbio first. */
+		oe = get_oe_from_bbio(bio_ctrl->bbio, cur);
+		if (!oe)
+			oe = btrfs_lookup_ordered_extent(inode, cur);
+		if (unlikely(!oe)) {
+			/* The next block may have valid OE, so only skip one block. */
+			cur_len = blocksize;
+			/*
+			 * bio_ctrl may contain a bio crossing several folios.
+			 * Submit it immediately so that the bio has a chance
+			 * to finish normally, rather than being marked as error.
+			 */
+			submit_one_bio(bio_ctrl);
+
+			/*
+			 * When submission failed, we should still clear the
+			 * folio dirty. Or the folio will be written back again
+			 * but without any ordered extent.
+			 */
+			btrfs_folio_clear_dirty(fs_info, folio, cur, cur_len);
+			btrfs_folio_set_writeback(fs_info, folio, cur, cur_len);
+			btrfs_folio_clear_writeback(fs_info, folio, cur, cur_len);
+
+			/*
+			 * Since there is no bio submitted to finish the ordered
+			 * extent, we have to manually finish this sector.
+			 */
+			btrfs_mark_ordered_io_finished(inode, cur, cur_len, false);
+			btrfs_err_rl(fs_info,
+			"no ordered extent for root %lld ino %llu filepos %llu",
+				     btrfs_root_id(inode->root), btrfs_ino(inode), cur);
+			if (!found_error)
+				found_error = -EUCLEAN;
+			cur += cur_len;
+			continue;
+		}
+
+		extent_offset = cur - oe->file_offset;
+		ASSERT(cur < oe->file_offset + oe->num_bytes);
+		ASSERT(IS_ALIGNED(oe->file_offset, blocksize));
+		ASSERT(IS_ALIGNED(oe->num_bytes, blocksize));
+		ASSERT(oe->compress_type == BTRFS_COMPRESS_NONE);
+		ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
+
+		block_start = oe->disk_bytenr + oe->offset;
+		disk_bytenr = block_start + extent_offset;
+
+		cur_len = min_t(u64, oe->file_offset + oe->num_bytes - cur,
+				cur_len);
+
+		if (bio_ctrl->bbio && !btrfs_bio_is_contig(bio_ctrl, disk_bytenr, cur))
+			cur_bio_size = 0;
+		/* Also limit cur_len according to writeback_bio_size. */
+		cur_len = min(round_down(fs_info->writeback_bio_size - cur_bio_size,
+					 blocksize), cur_len);
+		btrfs_put_ordered_extent(oe);
+
+		btrfs_folio_clear_dirty(fs_info, folio, cur, cur_len);
+		btrfs_folio_set_writeback(fs_info, folio, cur, cur_len);
+		/*
+		 * Above call should set the whole folio with writeback flag, even
+		 * just for a single subpage sector.
+		 * As long as the folio is properly locked and the range is correct,
+		 * we should always get the folio with writeback flag.
+		 */
+		ASSERT(folio_test_writeback(folio));
+
+		ret = submit_folio_blocks(bio_ctrl, disk_bytenr, folio,
+					  offset_in_folio(folio, cur),
+					  cur_len, 0);
 		if (unlikely(ret < 0)) {
+			btrfs_folio_clear_writeback(fs_info, folio, cur, cur_len);
+			btrfs_mark_ordered_io_finished(inode, cur, cur_len, false);
+			btrfs_err_rl(fs_info,
+			"failed to queue sector for root %lld ino %llu filepos %llu: %pe",
+				     btrfs_root_id(inode->root),
+				     btrfs_ino(inode), cur, ERR_PTR(ret));
 			if (!found_error)
 				found_error = ret;
+			cur += cur_len;
 			continue;
 		}
+		cur += cur_len;
 		submitted_io = true;
 	}
 
-- 
2.55.0

