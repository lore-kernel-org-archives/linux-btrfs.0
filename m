Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A04437467
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576778; cv=none; b=fpR4m/wWMFEyNnms7XUJtj9G/abcWvMQChgZq76bXMIUt/Xptm7eSV2Ng5s0DStbagBCg9Ni00U1z0gptI0FEtcbQ34Vh94GJJ04zKkhtfGXss0JtG7/tR5N78fXmXzxO9pTSmYkTR+JVCXJZPyUpE9oQfHzD1k10F2B69j4LrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576778; c=relaxed/simple;
	bh=BlOOA6bfbv42C1xw0QBmu0TS5wZssT+5b8+HO9tBxEU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbHRwKzDtebnii3GRUBF7KttmFrY2IX7zSMpo4Su0cw2BFo9D5QTE3ROpowQ6+sbl7QegO5OPU4+Pe+DijhYDxNMjTeZI+QJYHvv353jxm9ocv+kb4hhXn5O0G6riHESBx/hNcRO82zbiYi6y1F+IuTmHbYPnKG//xcD5niWeug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bfU5j44v; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=F4V0Ml+h; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bfU5j44v";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="F4V0Ml+h"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DE8791F7B6
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790576770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fYLryw7cxROTu/cUeZ3nuB1K2CbdbDnTpGHu7pRWs7Y=;
	b=bfU5j44vh1HDKPHsCW1PsOWJO/mV1hwV9h/o1amRUt+so8h1PBVjSf2hmN//vPTdv0GkYh
	cxwL5TmKJnk7SNODl4tzHnQZ0GK+6v8KO4fmguWwPFWZSoOJRS7vb0UGGvnRkMn2nnnX6O
	y4c+PQCwH912+/11agtElIt2/X+HRKs=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=F4V0Ml+h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790576765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fYLryw7cxROTu/cUeZ3nuB1K2CbdbDnTpGHu7pRWs7Y=;
	b=F4V0Ml+hhvKVHcsYkbkj9rctUhxFi63K2Z1bahft+9oScO5QnAG4Ve0WqYkl9kWJHErNsd
	qEkKlPvVU/oif8pv/viNrvmSVFy+pQwaVG1TPXFs8Zs3zfl8ts8LfKiLo/KSKAzaStr0Y7
	dgyDT1IFSF1PbhLPyoOSai4qHHjVxiU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92FA91340F
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jiQQNHkIumqheQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:04 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: read a folio extent-by-extent instead of block-by-block
Date: Mon, 28 Sep 2026 15:55:42 +0930
Message-ID: <d25071e07851da72d2de7f8a93932566cdd5cb3b.1790576583.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790576583.git.wqu@suse.com>
References: <cover.1790576583.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: DE8791F7B6
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

The current folio read is still based on a block-by-block iteration.
For a large folio (can be as large as 2M for 4K page size,
EXPERIMENTAL builds), this means we will do 512 checks for each block.

For non-experimental builds, we can still do 64 block checks for a large
folio.

Meanwhile for a lot of cases, the whole folio may belong to a single
extent map, thus we can submit the full folio in just one go,
without checking each block.

Optimize the folio read behavior to do an extent-by-extent
submission, this is done by:

- Introduce a btrfs_folio_find_next_read_range() helper
  This is just a wrapper to return the current contig range inside the
  uptodate sub-bitmap.

  This helper also returns if the range is uptodate or not.

- Change submit_one_block() to submit_folio_blocks()
  Which adds a new @len parameter.

- Change btrfs_do_readpage() to handle the extent range
  This includes clamping the read range to both the extent map and range
  end.

There is also a micro-benchmark, checking the runtime of
btrfs_do_readpage().

The workload is fio doing sequential buffered read with 64K blocksize:

 fio --name=buffered-seqread --rw=read --bs=64k --size=1G --direct=0 --ioengine=psync \
     --loops=16 --group_reporting --filename=/mnt/btrfs/foobar

The sequential buffered read is the best case scenario, as readahead
will try very hard with large folios passed in.

Before the patch:

 @dist:
 [256, 512)           989 |@@@@@@                                              |
 [512, 1K)            995 |@@@@@@                                              |
 [1K, 2K)             490 |@@@                                                 |
 [2K, 4K)              26 |                                                    |
 [4K, 8K)             269 |@                                                   |
 [8K, 16K)             63 |                                                    |
 [16K, 32K)           133 |                                                    |
 [32K, 64K)          7747 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
 [64K, 128K)          244 |@                                                   |
 [128K, 256K)           3 |                                                    |
 [256K, 512K)          28 |                                                    |
 [512K, 1M)            53 |                                                    |

 @stats: { .count = 11040, .average = 32897, .total = 363190054 }

After the patch:

 [256, 512)          1788 |@@@@@@@@@@@@@@@@@                                   |
 [512, 1K)           5387 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
 [1K, 2K)            1599 |@@@@@@@@@@@@@@@                                     |
 [2K, 4K)              80 |                                                    |
 [4K, 8K)            1793 |@@@@@@@@@@@@@@@@@                                   |
 [8K, 16K)            334 |@@@                                                 |
 [16K, 32K)            26 |                                                    |
 [32K, 64K)            27 |                                                    |
 [64K, 128K)            2 |                                                    |
 [128K, 256K)           0 |                                                    |
 [256K, 512K)           7 |                                                    |
 [512K, 1M)             1 |                                                    |

 @stats: { .count = 11044, .average = 2432, .total = 26864686 }

The count doesn't change much, so the folio size passed in is almost the
same for both runs.
But average runtime changes from 32us to 2us for the best case
situation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 62 ++++++++++++++++++++++++++------------------
 fs/btrfs/subpage.c   | 49 ++++++++++++++++++++++++++++++++++
 fs/btrfs/subpage.h   |  4 +++
 3 files changed, 90 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 55e9144d4759..05e6a97dc15d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -110,14 +110,14 @@ struct btrfs_bio_ctrl {
 	 * make the decision when submitting the bio.
 	 *
 	 * The pattern between do_readpage(), submit_one_bio() and
-	 * submit_one_block() is quite subtle, so tracking this is tricky.
+	 * submit_folio_blocks() is quite subtle, so tracking this is tricky.
 	 *
 	 * As we process extent E, we might submit a bio with existing built up
 	 * extents before adding E to a new bio, or we might just add E to the
 	 * bio. As a result, E's generation could apply to the current bio or
 	 * to the next one, so we need to be careful to update the bio_ctrl's
 	 * generation with E's only when we are sure E is added to bio_ctrl->bbio
-	 * in submit_one_block().
+	 * in submit_folio_blocks().
 	 *
 	 * See the comment in btrfs_lookup_bio_sums() for more detail on the
 	 * need for this optimization.
@@ -800,6 +800,7 @@ static int alloc_new_bio(struct btrfs_inode *inode,
  * @disk_bytenr: logical bytenr where the read/write will be
  * @folio:	 the folio the block belongs to
  * @pg_offset:	 the offset inside the folio
+ * @len:	 the length of the range.
  * @read_em_generation: generation of the extent_map we are submitting
  *			(only used for read)
  *
@@ -811,16 +812,15 @@ static int alloc_new_bio(struct btrfs_inode *inode,
  * Return 0 if the block is queued or submitted.
  * Return <0 for error.
  */
-static int submit_one_block(struct btrfs_bio_ctrl *bio_ctrl,
-			    u64 disk_bytenr, struct folio *folio,
-			    unsigned long pg_offset, u64 read_em_generation)
+static int submit_folio_blocks(struct btrfs_bio_ctrl *bio_ctrl,
+			       u64 disk_bytenr, struct folio *folio,
+			       size_t pg_offset, size_t len, u64 read_em_generation)
 {
 	struct btrfs_inode *inode = folio_to_inode(folio);
 	const struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	const u32 blocksize = fs_info->sectorsize;
 	loff_t file_offset = folio_pos(folio) + pg_offset;
 
-	ASSERT(pg_offset + blocksize <= folio_size(folio));
+	ASSERT(pg_offset + len <= folio_size(folio));
 	ASSERT(bio_ctrl->end_io_func);
 
 	if (bio_ctrl->bbio &&
@@ -837,7 +837,7 @@ static int submit_one_block(struct btrfs_bio_ctrl *bio_ctrl,
 			return ret;
 	}
 
-	if (!bio_add_folio(&bio_ctrl->bbio->bio, folio, blocksize, pg_offset)) {
+	if (!bio_add_folio(&bio_ctrl->bbio->bio, folio, len, pg_offset)) {
 		/* bio full: move on to a new one */
 		submit_one_bio(bio_ctrl);
 		goto again;
@@ -848,10 +848,10 @@ static int submit_one_block(struct btrfs_bio_ctrl *bio_ctrl,
 	 * generation in the max generation calculation.
 	 */
 	bio_ctrl->generation = max(bio_ctrl->generation, read_em_generation);
-	bio_ctrl->next_file_offset += blocksize;
+	bio_ctrl->next_file_offset += len;
 
 	if (bio_ctrl->wbc)
-		wbc_account_cgroup_owner(bio_ctrl->wbc, folio, blocksize);
+		wbc_account_cgroup_owner(bio_ctrl->wbc, folio, len);
 
 	/*
 	 * len_to_oe_boundary defaults to U32_MAX, which isn't folio or sector
@@ -863,7 +863,7 @@ static int submit_one_block(struct btrfs_bio_ctrl *bio_ctrl,
 	 * extent size (128MiB).
 	 *
 	 * When len_to_oe_boundary is U32_MAX, decreasing the length by
-	 * blocksize will never make it reach 0, thus skipping the later
+	 * @len will never make it reach 0, thus skipping the later
 	 * submit_one_bio() call.  So if len_to_oe_boundary() is not tracking
 	 * an OE, do not decrease it.
 	 *
@@ -872,7 +872,7 @@ static int submit_one_block(struct btrfs_bio_ctrl *bio_ctrl,
 	 * extents.
 	 */
 	if (bio_ctrl->len_to_oe_boundary != U32_MAX)
-		bio_ctrl->len_to_oe_boundary -= blocksize;
+		bio_ctrl->len_to_oe_boundary -= len;
 
 	/* Ordered extent boundary: move on to a new bio. */
 	if (bio_ctrl->len_to_oe_boundary == 0)
@@ -1035,12 +1035,13 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
 	u64 start = folio_pos(folio);
 	const u64 end = start + folio_size(folio) - 1;
+	const u64 fnext = folio_next_pos(folio);
+	u64 cur = start;
 	u64 extent_offset;
 	u64 locked_end;
 	u64 last_byte = i_size_read(inode);
 	struct extent_map *em;
 	int ret = 0;
-	const size_t blocksize = fs_info->sectorsize;
 
 	if (bio_ctrl->ractl)
 		locked_end = readahead_pos(bio_ctrl->ractl) + readahead_length(bio_ctrl->ractl) - 1;
@@ -1062,24 +1063,29 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 	}
 	bio_ctrl->end_io_func = end_bbio_data_read;
 	begin_folio_read(fs_info, folio);
-	for (u64 cur = start; cur <= end; cur += blocksize) {
+	while (cur < fnext) {
 		enum btrfs_compression_type compress_type = BTRFS_COMPRESS_NONE;
-		unsigned long pg_offset = offset_in_folio(folio, cur);
 		bool force_bio_submit = false;
+		bool uptodate;
+		u32 cur_len;
+		unsigned int pg_offset;
 		u64 disk_bytenr;
 		u64 block_start;
 		u64 em_gen;
 
-		ASSERT(IS_ALIGNED(cur, fs_info->sectorsize));
 		if (cur >= last_byte) {
-			folio_zero_range(folio, pg_offset, end - cur + 1);
+			folio_zero_range(folio, offset_in_folio(folio, cur), end - cur + 1);
 			end_folio_read(vi, folio, true, cur, end - cur + 1);
 			break;
 		}
-		if (btrfs_folio_test_uptodate(fs_info, folio, cur, blocksize)) {
-			end_folio_read(vi, folio, true, cur, blocksize);
+		uptodate = btrfs_folio_find_next_read_range(fs_info, folio, cur, &cur_len);
+		if (uptodate) {
+			end_folio_read(vi, folio, true, cur, cur_len);
+			cur += cur_len;
 			continue;
 		}
+		pg_offset = offset_in_folio(folio, cur);
+
 		/*
 		 * Search extent map for the whole locked range.
 		 * This will allow btrfs_get_extent() to return a larger hole
@@ -1160,18 +1166,22 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		bio_ctrl->last_em_start = em->start;
 
 		em_gen = em->generation;
+		cur_len = min_t(u64, btrfs_extent_map_end(em) - cur, cur_len);
 		btrfs_free_extent_map(em);
 		em = NULL;
 
 		/* we've found a hole, just zero and go on */
 		if (block_start == EXTENT_MAP_HOLE) {
-			folio_zero_range(folio, pg_offset, blocksize);
-			end_folio_read(vi, folio, true, cur, blocksize);
+			folio_zero_range(folio, pg_offset, cur_len);
+			end_folio_read(vi, folio, true, cur, cur_len);
+			cur += cur_len;
 			continue;
 		}
 		/* the get_extent function already copied into the folio */
 		if (block_start == EXTENT_MAP_INLINE) {
-			end_folio_read(vi, folio, true, cur, blocksize);
+			ASSERT(cur_len == fs_info->sectorsize);
+			end_folio_read(vi, folio, true, cur, cur_len);
+			cur += cur_len;
 			continue;
 		}
 
@@ -1182,9 +1192,11 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 
 		if (force_bio_submit)
 			submit_one_bio(bio_ctrl);
-		ret = submit_one_block(bio_ctrl, disk_bytenr, folio, pg_offset, em_gen);
+		ret = submit_folio_blocks(bio_ctrl, disk_bytenr, folio,
+					  pg_offset, cur_len, em_gen);
 		/* Read submission should not fail. */
 		ASSERT(ret == 0);
+		cur += cur_len;
 	}
 	return 0;
 }
@@ -1879,8 +1891,8 @@ static int submit_write_sector(struct btrfs_inode *inode,
 	 */
 	ASSERT(folio_test_writeback(folio));
 
-	ret = submit_one_block(bio_ctrl, disk_bytenr, folio,
-			       offset_in_folio(folio, filepos), 0);
+	ret = submit_folio_blocks(bio_ctrl, disk_bytenr, folio,
+				  offset_in_folio(folio, filepos), sectorsize, 0);
 	if (unlikely(ret < 0)) {
 		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
 		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index ebf18efe1ea3..308e51719f3a 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -364,6 +364,55 @@ static void btrfs_folio_mark_dirty(struct folio *folio)
 	filemap_dirty_folio(mapping, folio);
 }
 
+/*
+ * Find the first contig range that covers @start in the uptodate-bitmap.
+ *
+ * @start:		The file offset to start the search.
+ * @len_ret:		The length in bytes of the found range.
+ *
+ * Return true if the range is uptodate, otherwise return false.
+ *
+ * This interface is a little weird, normally we should just locate the
+ * non-uptodate range to read, but the read path needs to unlock the uptodate
+ * range too, so we need to return every contig range in the uptodate sub-bitmap.
+ */
+bool btrfs_folio_find_next_read_range(struct btrfs_fs_info *fs_info,
+				      struct folio *folio,
+				      u64 start, u32 *len_ret)
+{
+	const u64 fpos = folio_pos(folio);
+	const u64 fnext = folio_next_pos(folio);
+	const u32 fsize = folio_size(folio);
+	const u32 blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
+	const unsigned int bitmap_end = blocks_per_folio * (btrfs_bitmap_nr_uptodate + 1);
+	struct btrfs_folio_state *bfs = folio_get_private(folio);
+	unsigned long flags;
+	unsigned int start_bit;
+	unsigned int next_bit;
+	bool ret;
+
+	ASSERT(IS_ALIGNED(start, fs_info->sectorsize));
+	/* Search start should be inside the folio. */
+	ASSERT(start >= fpos && start < fnext);
+
+	if (blocks_per_folio == 1) {
+		*len_ret = fsize;
+		return folio_test_uptodate(folio);
+	}
+	ASSERT(bfs);
+	start_bit = subpage_calc_start_bit(fs_info, folio, uptodate,
+					   start, fs_info->sectorsize);
+	spin_lock_irqsave(&bfs->lock, flags);
+	ret = test_bit(start_bit, bfs->bitmaps);
+	if (ret)
+		next_bit = find_next_zero_bit(bfs->bitmaps, bitmap_end, start_bit);
+	else
+		next_bit = find_next_bit(bfs->bitmaps, bitmap_end, start_bit);
+	spin_unlock_irqrestore(&bfs->lock, flags);
+	*len_ret = (next_bit - start_bit) << fs_info->sectorsize_bits;
+	return ret;
+}
+
 /*
  * The set helper of the dirty ops, so it only runs for folios without a
  * fixup bitmap: for those the folio flag is the whole fixup state, and this
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index 9b106a73d682..6669f1da9ef4 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -174,6 +174,10 @@ DECLARE_BTRFS_SUBPAGE_OPS(uptodate);
 DECLARE_BTRFS_SUBPAGE_OPS(dirty);
 DECLARE_BTRFS_SUBPAGE_OPS(writeback);
 
+bool btrfs_folio_find_next_read_range(struct btrfs_fs_info *fs_info,
+				      struct folio *folio,
+				      u64 start, u32 *len_ret);
+
 /*
  * Fixup bit helpers.
  *
-- 
2.55.0

