Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF99463
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777439084; cv=none; b=PgsqvwfMeAbeS0tR/CR+aZPbqhsjh+dtFwtnqt9VVyOzcChgyByswx0FJlkngxTNrV+cxIUWNQgSZDHjL6z2S05o7ubXEsweHCeZfo/uM5jm03BZP5woax8LcgsDqmm2S8AQ2FCCCFY0Kx4bnSzh4WKEHOUtZ0pgcIdHZiL/Q4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777439084; c=relaxed/simple;
	bh=Cz/q+/Lg5LV6gCiEifFNQUUSwMfFLlcQw8GmVCcYQ0s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abVlnfvI0iLtk+GT9Kk7SXKKRx1CnNcO0AMmcdLPG930YVYZXIrdueUU9EvIdQ1r4DhoGHJS1xiu4LTuShmrhZeFaf7W85hD8JuEICX6E7fxw3FU8DjYY2d/ZnvJcL4UA2B0QIxGzWVP0bq+HTzEjKcrvoAx0Ie3DeytCWdWAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KoZnC0J5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KoZnC0J5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KoZnC0J5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KoZnC0J5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A7565BCCA
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777439063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S2tmAtWirl9zvK9+tYCBLXq3Df4zVEDAZ06H5eBW61s=;
	b=KoZnC0J5Xr2r/O8YcZLhkE3X3+oIoo0Mesk77u+Lrm7s37PRE92RHe0f9BBJ5qSyP0/UAM
	QzePrHJIUzuXAGQyWRNHICqG2yFWZ98m5H11t1zsiuZVY/No8zPWBEAV+QnjATGE/lICcG
	f1NCFd5ckvd0D60o/4PCBWk0plUWJgw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KoZnC0J5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777439063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S2tmAtWirl9zvK9+tYCBLXq3Df4zVEDAZ06H5eBW61s=;
	b=KoZnC0J5Xr2r/O8YcZLhkE3X3+oIoo0Mesk77u+Lrm7s37PRE92RHe0f9BBJ5qSyP0/UAM
	QzePrHJIUzuXAGQyWRNHICqG2yFWZ98m5H11t1zsiuZVY/No8zPWBEAV+QnjATGE/lICcG
	f1NCFd5ckvd0D60o/4PCBWk0plUWJgw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 253DF593B0
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uI7TMFWR8WloAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: introduce support for huge folios
Date: Wed, 29 Apr 2026 14:33:52 +0930
Message-ID: <9d51538ca03c967f47ec3176980389bd8d06109c.1777438651.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777438651.git.wqu@suse.com>
References: <cover.1777438651.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2A7565BCCA

With all the previous preparations, it's finally time to enable the
huge folio support.

- The max folio size
  Here we define BTRFS_MAX_FOLIO_SIZE, which is fixed to 2MiB.

  This will ensure we have a large enough but not too large folio for
  btrfs.
  This limit applies to all systems regardless of page size.

  Then we also define BTRFS_MAX_BLOCKS_PER_FOLIO, which depends on
  CONFIG_BTRFS_EXPERIMENTAL.

  If it's an experimental build, BTRFS_MAX_BLOCKS_PER_FOLIO is 512,
  otherwise it's BITS_PER_LONG.

  The filemap max order will be calculated using both
  BTRFS_MAX_FOLIO_SIZE and BTRFS_MAX_BLOCKS_PER_FOLIO.

  E.g. for 64K page size with 64K fs block size, the limit will be
  BTRFS_MAX_FOLIO_SIZE (2M), which limits the filemap max order to 5.
  This will be lower than the old order (6), but folios larger than 2M
  are rarely any better for IO performance. Meanwhile excessively large
  folios can cause other problems like stalling the IO pipeline for too
  long.

  For 4K page size and 4K fs block size, the limit will be increased to
  2M from the old 256K.
  This new size is constrained by both BTRFS_MAX_FOLIO_SIZE (2M) and
  BTRFS_MAX_BLOCKS_PER_FOLIO (512 * 4K), allowing x86_64 to reach huge
  folio support, and the filemap max order will be 9.

- btrfs_bio_ctrl::submit_bitmap
  This will be enlarged to contain BTRFS_MAX_BLOCKS_PER_FOLIO bits, and
  this will be on-stack memory.
  This will increase on-stack memory usage by 56 bytes compared to the
  baseline (before any patch in the series).

- Local @delalloc_bitmap inside writepage_delalloc()
  Unfortunately we cannot afford to handle an allocation error here, thus
  again we use on-stack memory.
  Thus this will increase on-stack memory usage by 56 bytes again.

So unfortunately this means during the delalloc window, the writeback path
will have +112 bytes for on-stack memory usage, and for other cases the
writeback path will have +56 bytes on-stack memory usage.

The +56 bytes (btrfs_bio_ctrl::submit_bitmap) can be removed
after we have reworked the compression submission, so the current
on-stack submit_bitmap is mostly a workaround until then.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c   | 11 ++++++++++-
 fs/btrfs/extent_io.c | 42 ++++++++++++------------------------------
 fs/btrfs/fs.h        | 16 ++++++++++++++++
 fs/btrfs/subpage.c   |  7 ++++---
 4 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 308955f0592a..48ddbeb18e3c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3272,6 +3272,15 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
 	return false;
 }
 
+static u32 calc_block_max_order(u32 sectorsize_bits)
+{
+	u32 max_size;
+
+	max_size = min(BTRFS_MAX_BLOCKS_PER_FOLIO << sectorsize_bits,
+		       BTRFS_MAX_FOLIO_SIZE);
+	return ilog2(round_up(max_size, PAGE_SIZE) >> PAGE_SHIFT);
+}
+
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
 	u32 sectorsize;
@@ -3394,7 +3403,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->sectorsize = sectorsize;
 	fs_info->sectorsize_bits = ilog2(sectorsize);
 	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
-	fs_info->block_max_order = ilog2((BITS_PER_LONG << fs_info->sectorsize_bits) >> PAGE_SHIFT);
+	fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
 	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
 	fs_info->stripesize = stripesize;
 	fs_info->fs_devices->fs_info = fs_info;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 71593d19c0a3..31a65c662b65 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -130,12 +130,7 @@ struct btrfs_bio_ctrl {
 	 * extent_writepage_io().
 	 * This is to avoid touching ranges covered by compression/inline.
 	 */
-	unsigned long *submit_bitmap;
-	/*
-	 * When blocks_per_folio <= BITS_PER_LONG, we can use the inline
-	 * one without allocating memory.
-	 */
-	unsigned long submit_bitmap_value;
+	unsigned long submit_bitmap[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)];
 
 	struct readahead_control *ractl;
 
@@ -1438,7 +1433,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	const u64 page_start = folio_pos(folio);
 	const u64 page_end = page_start + folio_size(folio) - 1;
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	unsigned long delalloc_bitmap = 0;
+	unsigned long delalloc_bitmap[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)] = { 0 };
 	/*
 	 * Save the last found delalloc end. As the delalloc end can go beyond
 	 * page boundary, thus we cannot rely on subpage bitmap to locate the
@@ -1481,7 +1476,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
-		set_delalloc_bitmap(folio, &delalloc_bitmap, delalloc_start,
+		set_delalloc_bitmap(folio, delalloc_bitmap, delalloc_start,
 				    min(delalloc_end, page_end) + 1 - delalloc_start);
 		last_delalloc_end = delalloc_end;
 		delalloc_start = delalloc_end + 1;
@@ -1507,7 +1502,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			found_len = last_delalloc_end + 1 - found_start;
 			found = true;
 		} else {
-			found = find_next_delalloc_bitmap(folio, &delalloc_bitmap,
+			found = find_next_delalloc_bitmap(folio, delalloc_bitmap,
 					delalloc_start, &found_start, &found_len);
 		}
 		if (!found)
@@ -1838,26 +1833,19 @@ static void bio_ctrl_init_submit_bitmap(struct btrfs_fs_info *fs_info,
 {
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
 
-	/* Only supported for blocks per folio <= BITS_PER_LONG for now. */
-	ASSERT(blocks_per_folio <= BITS_PER_LONG);
-	bio_ctrl->submit_bitmap_value = 0;
-	bio_ctrl->submit_bitmap = &bio_ctrl->submit_bitmap_value;
+	ASSERT(blocks_per_folio <= BTRFS_MAX_BLOCKS_PER_FOLIO);
+
 	/*
 	 * Default to unlock the whole folio.
 	 * The proper bitmap is not initialized until writepage_delalloc().
+	 *
+	 * We're safe just to set the bitmap range [0, blocks_per_folio), as
+	 * all later usage of the bitmap will follow the same range limit.
+	 * Any bits beyond blocks_per_folio will be ignored.
 	 */
 	bitmap_set(bio_ctrl->submit_bitmap, 0, blocks_per_folio);
 }
 
-static void bio_ctrl_release_submit_bitmap(struct btrfs_fs_info *fs_info,
-					   struct folio *folio,
-					   struct btrfs_bio_ctrl *bio_ctrl)
-{
-	ASSERT(btrfs_blocks_per_folio(fs_info, folio) <= BITS_PER_LONG);
-
-	bio_ctrl->submit_bitmap = NULL;
-}
-
 /*
  * the writepage semantics are similar to regular writepage.  extent
  * records are inserted to lock ranges in the tree, and as dirty areas
@@ -1917,19 +1905,15 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 		goto done;
 
 	ret = writepage_delalloc(inode, folio, bio_ctrl);
-	if (ret == 1) {
-		bio_ctrl_release_submit_bitmap(fs_info, folio, bio_ctrl);
+	if (ret == 1)
 		return 0;
-	}
 	if (ret)
 		goto done;
 
 	ret = extent_writepage_io(inode, folio, folio_pos(folio),
 				  folio_size(folio), bio_ctrl, i_size);
-	if (ret == 1) {
-		bio_ctrl_release_submit_bitmap(fs_info, folio, bio_ctrl);
+	if (ret == 1)
 		return 0;
-	}
 	if (unlikely(ret < 0))
 		btrfs_err_rl(fs_info,
 "failed to submit blocks, root=%lld inode=%llu folio=%llu submit_bitmap=%*pbl: %d",
@@ -1947,7 +1931,6 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 	 * submitted ranges inside the folio.
 	 */
 	btrfs_folio_end_lock_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
-	bio_ctrl_release_submit_bitmap(fs_info, folio, bio_ctrl);
 	ASSERT(ret <= 0);
 	return ret;
 }
@@ -2695,7 +2678,6 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 		if (ret < 0)
 			found_error = true;
 next_page:
-		bio_ctrl_release_submit_bitmap(fs_info, folio, &bio_ctrl);
 		folio_put(folio);
 		cur = cur_end + 1;
 	}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index f821aa762613..9997bbc1d1e5 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -54,6 +54,22 @@ struct btrfs_space_info;
 #define BTRFS_MIN_BLOCKSIZE	(SZ_4K)
 #define BTRFS_MAX_BLOCKSIZE	(SZ_64K)
 
+/* The max folio size btrfs supports. */
+#define BTRFS_MAX_FOLIO_SIZE	(SZ_2M)
+static_assert(BTRFS_MAX_FOLIO_SIZE > PAGE_SIZE);
+
+/*
+ * The max number of blocks a huge folio can support.
+ *
+ * Depending on the fs block size, the real max blocks per folio
+ * may also be limited by the above BTRFS_MAX_FOLIO_SIZE.
+ */
+#ifdef CONFIG_BTRFS_EXPERIMENTAL
+#define BTRFS_MAX_BLOCKS_PER_FOLIO	(512)
+#else
+#define BTRFS_MAX_BLOCKS_PER_FOLIO	(BITS_PER_LONG)
+#endif
+
 #define BTRFS_MAX_EXTENT_SIZE SZ_128M
 
 /*
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 0bad087c445c..ea202698fa10 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -13,9 +13,10 @@
  * - Metadata must be fully aligned to node size
  *   So when nodesize <= page size, the metadata can never cross folio boundaries.
  *
- * - Only support blocks per folio <= BITS_PER_LONG
- *   This is to make bitmap copying much easier, a single unsigned long can handle
- *   one bitmap.
+ * - Only support blocks per folio <= min(BTRFS_MAX_FOLIO_SIZE / fs block size,
+ *					  BTRFS_MAX_BLOCKS_PER_FOLIO)
+ *   This is to ensure we can afford an on-stack bitmap, without the need to allocate
+ *   bitmap memory at runtime.
  *
  * Implementation:
  *
-- 
2.53.0

