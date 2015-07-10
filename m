Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29076 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750701AbbGJELJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 00:11:09 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6A49OQZ016303
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 12:09:24 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [RFC PATCH 2/2] btrfs: scrub: Add support partial csum
Date: Fri, 10 Jul 2015 12:09:03 +0800
Message-ID: <1436501343-2605-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436501343-2605-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436501343-2605-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Add scrub support for partial csum.
The only challenge is that, scrub is done in unit of bio(or page size
yet), but partial csum is done in unit of 1/8 of nodesize.

So here a new function scrub_check_node_checksum and a new tree block
csum check loop is introduced to do partial csum check while reading the
tree block.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 207 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 206 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ab58115..0610474 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -307,6 +307,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work);
 static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 static void scrub_put_ctx(struct scrub_ctx *sctx);
+static int scrub_check_fsid(u8 fsid[], struct scrub_page *spage);
 
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
@@ -878,6 +879,91 @@ static inline void scrub_put_recover(struct scrub_recover *recover)
 }
 
 /*
+ * Page_bad arg should be a page include leaf header
+ *
+ * Return 0 if this header seems correct,
+ * Return 1 on other cases
+ */
+static int scrub_check_head(struct scrub_page *spage, u8 *csum)
+{
+	void *mapped_buffer;
+	struct btrfs_header *h;
+
+	mapped_buffer = kmap_atomic(spage->page);
+	h = (struct btrfs_header *)mapped_buffer;
+
+	if (spage->logical != btrfs_stack_header_bytenr(h))
+		goto header_err;
+	if (!scrub_check_fsid(h->fsid, spage))
+		goto header_err;
+	if (memcmp(h->chunk_tree_uuid,
+		   spage->dev->dev_root->fs_info->chunk_tree_uuid,
+		   BTRFS_UUID_SIZE))
+		goto header_err;
+	if (spage->generation != btrfs_stack_header_generation(h))
+		goto header_err;
+
+	if (csum)
+		memcpy(csum, h->csum, sizeof(h->csum));
+
+	kunmap_atomic(mapped_buffer);
+	return 0;
+
+header_err:
+	kunmap_atomic(mapped_buffer);
+	return 1;
+}
+
+/*
+ * return 1 if checksum ok, 0 on other case
+ */
+static int scrub_check_node_checksum(struct scrub_block *sblock,
+				     int part,
+				     u8 *csum)
+{
+	int offset;
+	int len;
+	u32 crc = ~(u32)0;
+
+	if (part == 0) {
+		offset = BTRFS_CSUM_SIZE;
+		len = sblock->sctx->nodesize - BTRFS_CSUM_SIZE;
+	} else if (part == 1) {
+		offset = BTRFS_CSUM_SIZE;
+		len = sblock->sctx->nodesize * 2 / 8 - BTRFS_CSUM_SIZE;
+	} else {
+		offset = part * sblock->sctx->nodesize / 8;
+		len = sblock->sctx->nodesize / 8;
+	}
+
+	while (len > 0) {
+		int page_num = offset / PAGE_SIZE;
+		int page_data_offset = offset - page_num * PAGE_SIZE;
+		int page_data_len = min(len,
+					(int)(PAGE_SIZE - page_data_offset));
+		u8 *mapped_buffer;
+
+		WARN_ON(page_num >= sblock->page_count);
+
+		if (sblock->pagev[page_num]->io_error)
+			return 0;
+
+		mapped_buffer = kmap_atomic(
+				      sblock->pagev[page_num]->page);
+
+		crc = btrfs_csum_data(mapped_buffer + page_data_offset, crc,
+				      page_data_len);
+
+		offset += page_data_len;
+		len -= page_data_len;
+
+		kunmap_atomic(mapped_buffer);
+	}
+	btrfs_csum_final(crc, (char *)&crc);
+	return (crc == ((u32 *)csum)[part]);
+}
+
+/*
  * scrub_handle_errored_block gets called when either verification of the
  * pages failed or the bio failed to read, e.g. with EIO. In the latter
  * case, this function handles all pages in the bio, even though only one
@@ -905,6 +991,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	int success;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
+	u8 node_csum[BTRFS_CSUM_SIZE];
+	int get_right_sum = 0;
+	int per_page_recover_start = 0;
 
 	BUG_ON(sblock_to_check->page_count < 1);
 	fs_info = sctx->dev_root->fs_info;
@@ -1151,11 +1240,125 @@ nodatasum_case:
 	 * area are unreadable.
 	 */
 	success = 1;
+
+	/*
+	 * maybe some mirror's head is broken
+	 * we select to use right head for checksum
+	 */
+	for (mirror_index = 0; mirror_index < BTRFS_MAX_MIRRORS &&
+	     sblocks_for_recheck[mirror_index].page_count > 0;
+	     mirror_index++) {
+		if (scrub_check_head(sblocks_for_recheck[mirror_index].pagev[0],
+				     node_csum) == 0) {
+			get_right_sum = 1;
+			break;
+		}
+	}
+
 	for (page_num = 0; page_num < sblock_bad->page_count;
 	     page_num++) {
 		struct scrub_page *page_bad = sblock_bad->pagev[page_num];
 		struct scrub_block *sblock_other = NULL;
 
+		if (is_metadata && get_right_sum) {
+			/*
+			 * For tree block which may support partial csum
+			 *
+			 * | page | page | page | page | page | page |
+			 * |   checksum  |   checksum  |   checksum  |
+			 *               ^      ^
+			 *               |      |
+			 *               |      page_num
+			 *               |
+			 *               per_page_recover_start
+			 *
+			 * |<-  done   ->|
+			 */
+			int start_csum_part;
+			int next_csum_part;
+			int sub_page_num;
+
+			/*
+			 * Don't worry that start_csum_part is rounded in
+			 * calculate, because per_page_recover_start should
+			 * always align with checksum
+			 */
+			start_csum_part = per_page_recover_start * 8 *
+				sblock_to_check->sctx->sectorsize /
+				sblock_to_check->sctx->nodesize;
+			start_csum_part = start_csum_part ? : 1;
+			next_csum_part = (page_num  + 1) * 8 *
+				sblock_to_check->sctx->sectorsize /
+				sblock_to_check->sctx->nodesize;
+			next_csum_part = next_csum_part ? : 1;
+
+			if (next_csum_part == start_csum_part) {
+				/* this page hasn't wrap to next checksum */
+				continue;
+			}
+
+			/*
+			 * to find which mirror have right data for current
+			 * csum parts
+			 */
+			for (mirror_index = 0;
+			     mirror_index < BTRFS_MAX_MIRRORS &&
+			     sblocks_for_recheck[mirror_index].page_count > 0;
+			     mirror_index++) {
+				int csum_part;
+
+				for (csum_part = start_csum_part;
+				     csum_part < next_csum_part; csum_part++) {
+					if (!scrub_check_node_checksum(
+							sblocks_for_recheck +
+							mirror_index, csum_part,
+							node_csum)) {
+						break;
+					}
+				}
+				if (csum_part == next_csum_part) {
+					/*
+					 * all part of the mirror has right csum
+					 */
+					sblock_other = sblocks_for_recheck +
+						       mirror_index;
+					break;
+				}
+			}
+
+			if (sctx->is_dev_replace) {
+				if (!sblock_other)
+					sblock_other = sblock_bad;
+
+				for (sub_page_num = per_page_recover_start;
+				     sub_page_num <= page_num; sub_page_num++) {
+					if (scrub_write_page_to_dev_replace(
+							sblock_other,
+							sub_page_num) != 0) {
+						btrfs_dev_replace_stats_inc(
+							&sctx->dev_root->
+							fs_info->dev_replace.
+							num_write_errors);
+						success = 0;
+					}
+				}
+			} else if (sblock_other) {
+				for (sub_page_num = per_page_recover_start;
+				     sub_page_num <= page_num; sub_page_num++) {
+					if (!scrub_repair_page_from_good_copy(
+							sblock_bad,
+							sblock_other,
+							sub_page_num, 0))
+						page_bad->io_error = 0;
+					else
+						success = 0;
+				}
+			}
+
+			per_page_recover_start = page_num  + 1;
+
+			continue;
+		}
 		/* skip no-io-error page in scrub */
 		if (!page_bad->io_error && !sctx->is_dev_replace)
 			continue;
@@ -1321,6 +1524,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
 	u64 length = original_sblock->page_count * PAGE_SIZE;
 	u64 logical = original_sblock->pagev[0]->logical;
+	u64 generation = original_sblock->pagev[0]->generation;
 	struct scrub_recover *recover;
 	struct btrfs_bio *bbio;
 	u64 sublen;
@@ -1387,7 +1591,7 @@ leave_nomem:
 			scrub_page_get(page);
 			sblock->pagev[page_index] = page;
 			page->logical = logical;
-
+			page->generation = generation;
 			scrub_stripe_index_and_offset(logical,
 						      bbio->map_type,
 						      bbio->raid_map,
@@ -1839,6 +2043,7 @@ static int scrub_checksum(struct scrub_block *sblock)
 	WARN_ON(sblock->page_count < 1);
 	flags = sblock->pagev[0]->flags;
 	ret = 0;
+
 	if (flags & BTRFS_EXTENT_FLAG_DATA)
 		ret = scrub_checksum_data(sblock);
 	else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
-- 
2.4.5

