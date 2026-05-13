Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0B63630A4
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778647013; cv=none; b=iFEnzD7yMgE1RnCAhYxXkt595s6D4XEHGbtgXKLHvmaGTotsuv7mYxwRgMQBWoszOBI1nudP5M4nj2/WnDH5JOGNByE5k5So5sSmCCRIB39VqPfiQ2pvP7y1j4YFQd3AT2EkEzNn/7+jOcFzER1VO84a0iY0LVvU87hskDp5RmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778647013; c=relaxed/simple;
	bh=wVVGGlxRmEBMGpML7WQw3KWrMd1pHvyyUz0GMEXLcIs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXn1i0QsGLD/gaiWL3gNHoHW8EvwE3b4FPOGIBeMynHz7DhTjJmBUR21sAiK2lEq6QgedNr7w/m1iueVBC06P6lRQKNC+qTB5NrI2OdrTeSGhBI6A+EDnUH+rUpNewEy2KdYTras2CF9jtfiiqbLkspciT7SvY51eDNm5MrADio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dSW3jM1m; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dSW3jM1m; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dSW3jM1m";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dSW3jM1m"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F3556706A
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LaHUFGsZ14cmQmfAPiyNakShPERPBmpoqHEzNp/5ugw=;
	b=dSW3jM1mb9fVqFNok+CeiNb3oKzHaXA5k5wSEc+0OTGGDFfWN6Us3F6UrKIGRQpC9iTBmi
	TSOVEsmexgEECvTr6vA+emepUHE9nxfb2B67gXkxkXn9grUl0EazO9caiPh6gzz0LSsjNN
	pHeao10X7JWkkU4frdTBCapQ0iLzOag=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=dSW3jM1m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LaHUFGsZ14cmQmfAPiyNakShPERPBmpoqHEzNp/5ugw=;
	b=dSW3jM1mb9fVqFNok+CeiNb3oKzHaXA5k5wSEc+0OTGGDFfWN6Us3F6UrKIGRQpC9iTBmi
	TSOVEsmexgEECvTr6vA+emepUHE9nxfb2B67gXkxkXn9grUl0EazO9caiPh6gzz0LSsjNN
	pHeao10X7JWkkU4frdTBCapQ0iLzOag=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DE11593A9
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oFSYBOD/A2r1SQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: introduce support for huge folios
Date: Wed, 13 May 2026 14:06:21 +0930
Message-ID: <a0d30bcff9ed7b9bd865c7813a4687bc069fc585.1778646753.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -3.01
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0F3556706A
X-Spam-Level: 

With all the previous preparations, it's finally time to enable the
huge folio support.

- The max folio size
  Here we define BTRFS_MAX_FOLIO_SIZE, which is fixed at 2MiB.

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
  baseline (before the first patch in the series).

- Local @delalloc_bitmap inside writepage_delalloc()
  Unfortunately we cannot afford to handle an allocation error here, thus
  again we use on-stack memory.
  Thus this will increase on-stack memory usage by 56 bytes again.

So unfortunately this means during the delalloc window, the writeback path
will have +112 bytes on-stack memory usage, and for other cases the
writeback path will have +56 bytes on-stack memory usage.

The +56 bytes (btrfs_bio_ctrl::submit_bitmap) can be removed
after we have reworked the compression submission, so the current
on-stack submit_bitmap is mostly a workaround until then.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c   | 11 ++++++++++-
 fs/btrfs/extent_io.c | 23 ++++++++++-------------
 fs/btrfs/fs.h        | 16 ++++++++++++++++
 fs/btrfs/subpage.c   |  7 ++++---
 4 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 982df3e31311..ff0ef9dd95f4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3345,6 +3345,15 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
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
@@ -3467,7 +3476,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->sectorsize = sectorsize;
 	fs_info->sectorsize_bits = ilog2(sectorsize);
 	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
-	fs_info->block_max_order = ilog2((BITS_PER_LONG << fs_info->sectorsize_bits) >> PAGE_SHIFT);
+	fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
 	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
 	fs_info->stripesize = stripesize;
 	fs_info->fs_devices->fs_info = fs_info;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index de0f37663790..b03eb211def7 100644
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
 
@@ -1473,7 +1468,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	const u64 page_start = folio_pos(folio);
 	const u64 page_end = page_start + folio_size(folio) - 1;
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	unsigned long delalloc_bitmap = 0;
+	unsigned long delalloc_bitmap[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)] = { 0 };
 	/*
 	 * Save the last found delalloc end. As the delalloc end can go beyond
 	 * page boundary, thus we cannot rely on subpage bitmap to locate the
@@ -1516,7 +1511,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
-		set_delalloc_bitmap(folio, &delalloc_bitmap, delalloc_start,
+		set_delalloc_bitmap(folio, delalloc_bitmap, delalloc_start,
 				    min(delalloc_end, page_end) + 1 - delalloc_start);
 		last_delalloc_end = delalloc_end;
 		delalloc_start = delalloc_end + 1;
@@ -1542,7 +1537,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			found_len = last_delalloc_end + 1 - found_start;
 			found = true;
 		} else {
-			found = find_next_delalloc_bitmap(folio, &delalloc_bitmap,
+			found = find_next_delalloc_bitmap(folio, delalloc_bitmap,
 					delalloc_start, &found_start, &found_len);
 		}
 		if (!found)
@@ -1864,13 +1859,15 @@ static void bio_ctrl_init_submit_bitmap(struct btrfs_fs_info *fs_info,
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
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 76250e40fcc9..e18607170e01 100644
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
index df923009060d..56060acac2e9 100644
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
2.54.0

