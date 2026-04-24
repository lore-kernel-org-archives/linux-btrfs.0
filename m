Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9750733A9F8
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020745; cv=none; b=Fjc12LzaiSt417XztMH6ObnnUl7+ssIegsywbFyUJ1ZVRg9RfXiP9/X7L4n1wPkeozoF2XLga7ginBSiY+MDTeqpt6c4zJhenD2ULj0h/mXpFyoZygnQG1DfDDtrC69YzcZVE9Pd4MK45k1+rlL2/3eWkrFftWBg/Ozk+QL80qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020745; c=relaxed/simple;
	bh=uOURIQ6T7Y1nk4dowZ1QAxjNFk2bBWCFYbY83XrEBPQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrZXUsmzuOwUnuxnQ4HdGXp87Jarru2kkj9jOodf2BTmHs66iAR8oogQg70fH40STKMQjxhXazH62e1H3T5PamDILwv3TKJU7dpHpPh3gCxmHPaSCBMUTVziGsIHNKTONcxlsrOgrE2fQTG7m2N0B2JIQXUoBYRN54xZsN03QHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CWoNXJrQ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CWoNXJrQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CWoNXJrQ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CWoNXJrQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E47E86A8A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=11d00CdXzCxc0vtVxXLX1t0sWxfFaszww02mFfXsX2w=;
	b=CWoNXJrQV3WdA/09VCZrCUaKYXh7bQafSJF1+0ORb991BYZfUa5DN+2R5GN/Yi3sqKLNbS
	E+Fv2QSx2YUpY8Hki5TYSijAXStAJfoqtv+BsNnJf6r63Q567E+qGhX9vqUf/rdJCDapgZ
	3oXtUauORqZ1Rjk3YinYt2nIBE6mbc8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=11d00CdXzCxc0vtVxXLX1t0sWxfFaszww02mFfXsX2w=;
	b=CWoNXJrQV3WdA/09VCZrCUaKYXh7bQafSJF1+0ORb991BYZfUa5DN+2R5GN/Yi3sqKLNbS
	E+Fv2QSx2YUpY8Hki5TYSijAXStAJfoqtv+BsNnJf6r63Q567E+qGhX9vqUf/rdJCDapgZ
	3oXtUauORqZ1Rjk3YinYt2nIBE6mbc8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1A74593A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6B9NIzkv62m2HQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 5/5] btrfs: introduce support for huge folios
Date: Fri, 24 Apr 2026 18:21:34 +0930
Message-ID: <e7b1aec5bb5007590500947bff923789d1d3ad71.1777019132.git.wqu@suse.com>
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

With all the previous preparations, it's finally time to enable the
huge folio support.

This will enlarge the bitmap size for each sub-bitmap inside
btrfs_folio_state, and there are some special call sites that need
extra mention:

- The max folio size
  Here we define a local MAX_BLOCKS_PER_FOLIO using BTRFS_MAX_FOLIO_SIZE
  (2M) and the minimum and most common fs block size
  BTRFS_MIN_BLOCKSIZE (4K).

  This will ensure we have a large enough but not too large folio for
  btrfs.
  This limit applies to all systems regardless of page size.

  For 64K page size, this will slightly reduce the max folio size, from
  the original 4MiB (with 64K page size) to the current 2MiB, and still
  not reaching huge folios (order 9, with 64K page size it is 32MiB).

  However, in reality folios larger than 2MiB are rarely any better for IO
  performance. Meanwhile, excessively large folios can cause other
  problems like stalling the IO pipeline for too long.
  So although the max folio size is reduced on 64K page sized systems,
  it shouldn't cause any huge problems.

  For 4K page size, this will increase the max folio size from 256K to
  2MiB, which means finally there is huge folio support.

- btrfs_bio_ctrl::submit_bitmap
  This will be enlarged to contain MAX_BLOCKS_PER_FOLIO, and this will
  be on-stack memory.
  This will increase on-stack memory usage by 48 bytes.

- Local @delalloc_bitmap inside writepage_delalloc()
  Unfortunately we cannot afford to handle an allocation error here, thus
  again we use on-stack memory.
  Thus this will increase on-stack memory usage by 56 bytes again.

So unfortunately this means during the delalloc window, the writeback path
will have +104 bytes for on-stack memory usage, and for other cases the
writeback path will have +48 bytes on-stack memory usage.

The +48 bytes (btrfs_bio_ctrl::submit_bitmap) can be removed
after we have reworked the compression submission, so the current
on-stack submit_bitmap is mostly a workaround until then.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c   |  2 +-
 fs/btrfs/extent_io.c | 44 ++++++++++++++------------------------------
 fs/btrfs/fs.h        |  4 ++++
 fs/btrfs/subpage.c   |  6 +++---
 4 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c67faf61ed9a..9b72878c08cf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3394,7 +3394,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->sectorsize = sectorsize;
 	fs_info->sectorsize_bits = ilog2(sectorsize);
 	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
-	fs_info->block_max_order = ilog2((BITS_PER_LONG << fs_info->sectorsize_bits) >> PAGE_SHIFT);
+	fs_info->block_max_order = ilog2(BTRFS_MAX_FOLIO_SIZE >> PAGE_SHIFT);
 	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
 	fs_info->stripesize = stripesize;
 	fs_info->fs_devices->fs_info = fs_info;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b8dfd8770365..afbf40382508 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -91,6 +91,8 @@ void btrfs_extent_buffer_leak_debug_check(struct btrfs_fs_info *fs_info)
 #define btrfs_leak_debug_del_eb(eb)			do {} while (0)
 #endif
 
+#define MAX_BLOCKS_PER_FOLIO	(BTRFS_MAX_FOLIO_SIZE / BTRFS_MIN_BLOCKSIZE)
+
 /*
  * Structure to record info about the bio being assembled, and other info like
  * how many bytes are there before stripe/ordered extent boundary.
@@ -130,12 +132,7 @@ struct btrfs_bio_ctrl {
 	 * extent_writepage_io().
 	 * This is to avoid touching ranges covered by compression/inline.
 	 */
-	unsigned long *submit_bitmap;
-	/*
-	 * When blocks_per_folio <= BITS_PER_LONG, we can use the inline
-	 * one without allocating memory.
-	 */
-	unsigned long submit_bitmap_value;
+	unsigned long submit_bitmap[BITS_TO_LONGS(MAX_BLOCKS_PER_FOLIO)];
 
 	struct readahead_control *ractl;
 
@@ -1428,7 +1425,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	const u64 page_start = folio_pos(folio);
 	const u64 page_end = page_start + folio_size(folio) - 1;
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	unsigned long delalloc_bitmap = 0;
+	unsigned long delalloc_bitmap[BITS_TO_LONGS(MAX_BLOCKS_PER_FOLIO)] = { 0 };
 	/*
 	 * Save the last found delalloc end. As the delalloc end can go beyond
 	 * page boundary, thus we cannot rely on subpage bitmap to locate the
@@ -1471,7 +1468,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
-		set_delalloc_bitmap(folio, &delalloc_bitmap, delalloc_start,
+		set_delalloc_bitmap(folio, delalloc_bitmap, delalloc_start,
 				    min(delalloc_end, page_end) + 1 - delalloc_start);
 		last_delalloc_end = delalloc_end;
 		delalloc_start = delalloc_end + 1;
@@ -1497,7 +1494,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			found_len = last_delalloc_end + 1 - found_start;
 			found = true;
 		} else {
-			found = find_next_delalloc_bitmap(folio, &delalloc_bitmap,
+			found = find_next_delalloc_bitmap(folio, delalloc_bitmap,
 					delalloc_start, &found_start, &found_len);
 		}
 		if (!found)
@@ -1828,26 +1825,19 @@ static void bio_ctrl_init_submit_bitmap(struct btrfs_fs_info *fs_info,
 {
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
 
-	/* Only supported for blocks per folio <= BITS_PER_LONG for now. */
-	ASSERT(blocks_per_folio <= BITS_PER_LONG);
-	bio_ctrl->submit_bitmap_value = 0;
-	bio_ctrl->submit_bitmap = &bio_ctrl->submit_bitmap_value;
+	ASSERT(blocks_per_folio <= MAX_BLOCKS_PER_FOLIO);
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
@@ -1907,19 +1897,15 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
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
@@ -1937,7 +1923,6 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 	 * submitted ranges inside the folio.
 	 */
 	btrfs_folio_end_lock_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
-	bio_ctrl_release_submit_bitmap(fs_info, folio, bio_ctrl);
 	ASSERT(ret <= 0);
 	return ret;
 }
@@ -2685,7 +2670,6 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 		if (ret < 0)
 			found_error = true;
 next_page:
-		bio_ctrl_release_submit_bitmap(fs_info, folio, &bio_ctrl);
 		folio_put(folio);
 		cur = cur_end + 1;
 	}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index e99db75dede6..5c152acf61d3 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -54,6 +54,10 @@ struct btrfs_space_info;
 #define BTRFS_MIN_BLOCKSIZE	(SZ_4K)
 #define BTRFS_MAX_BLOCKSIZE	(SZ_64K)
 
+/* The max folio size btrfs supports. */
+#define BTRFS_MAX_FOLIO_SIZE	(SZ_2M)
+static_assert(BTRFS_MAX_FOLIO_SIZE >= PAGE_SIZE);
+
 #define BTRFS_MAX_EXTENT_SIZE SZ_128M
 
 /*
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 41b369db0839..00b0a17445a5 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -13,9 +13,9 @@
  * - Metadata must be fully aligned to node size
  *   So when nodesize <= page size, the metadata can never cross folio boundaries.
  *
- * - Only support block per folio <= BITS_PER_LONG
- *   This is to make bitmap copying much easier, a single unsigned long can handle
- *   one bitmap.
+ * - Only support block per folio <= (BTRFS_MAX_FOLIO_SIZE / BTRFS_MIN_BLOCKSIZE)
+ *   This is to ensure we can afford an on-stack bitmap, without the need to allocate
+ *   bitmap memory at runtime.
  *
  * Implementation:
  *
-- 
2.53.0

