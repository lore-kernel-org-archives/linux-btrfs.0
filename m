Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbcA2FNj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:13:39 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 03/22] btrfs-progs: convert: Introduce function to calculate the available space
Date: Fri, 29 Jan 2016 13:03:13 +0800
Message-Id: <1454043812-7893-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, calculate_available_space() to get available
space cache_tree data_chunks cache_tree.

Unlike old implement, this function will do the new work:
1) batch used ext* data space.
   To ensure data chunks will recovery them all.
   And restore the result into mkfs_cfg->convert_data_chunks for later
   user.

2) avoid SB and reserved space at chunk level
   Both batched data space or free space will not cover reserved space,
   like sb or the first 1M.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 btrfs-convert.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 2fef1ed..8026907 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2637,12 +2637,100 @@ static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
 	return ret;
 }
 
+static int calculate_available_space(struct btrfs_convert_context *cctx)
+{
+	struct cache_tree *used = &cctx->used;
+	struct cache_tree *data_chunks = &cctx->data_chunks;
+	struct cache_tree *free = &cctx->free;
+	struct cache_extent *cache;
+	u64 cur_off = 0;
+	/*
+	 * Twice the minimal chunk size, to allow later wipe_reserved_ranges()
+	 * works without need to consider overlap
+	 */
+	u64 min_stripe_size = 2 * 16 * 1024 * 1024;
+	int ret;
+
+	/* Calculate data_chunks */
+	for (cache = first_cache_extent(used); cache;
+	     cache = next_cache_extent(cache)) {
+		u64 cur_len;
+
+		if (cache->start + cache->size < cur_off)
+			continue;
+		if (cache->start > cur_off + min_stripe_size)
+			cur_off = cache->start;
+		cur_len = max(cache->start + cache->size - cur_off,
+			      min_stripe_size);
+		ret = add_merge_cache_extent(data_chunks, cur_off, cur_len);
+		if (ret < 0)
+			goto out;
+		cur_off += cur_len;
+	}
+	/*
+	 * remove reserved ranges, so we won't ever bother relocating an old
+	 * filesystem extent to other place.
+	 */
+	ret = wipe_reserved_ranges(data_chunks, min_stripe_size, 1);
+	if (ret < 0)
+		goto out;
+
+	cur_off = 0;
+	/*
+	 * Calculate free space
+	 * Always round up the start bytenr, to avoid metadata extent corss
+	 * stripe boundary, as later mkfs_convert() won't have all the extent
+	 * allocation check
+	 */
+	for (cache = first_cache_extent(data_chunks); cache;
+	     cache = next_cache_extent(cache)) {
+		if (cache->start < cur_off)
+			continue;
+		if (cache->start > cur_off) {
+			u64 insert_start;
+			u64 len;
+
+			len = cache->start - round_up(cur_off,
+						      BTRFS_STRIPE_LEN);
+			insert_start = round_up(cur_off, BTRFS_STRIPE_LEN);
+
+			ret = add_merge_cache_extent(free, insert_start, len);
+			if (ret < 0)
+				goto out;
+		}
+		cur_off = cache->start + cache->size;
+	}
+	/* Don't forget the last range */
+	if (cctx->total_bytes > cur_off) {
+		u64 len = cctx->total_bytes - cur_off;
+		u64 insert_start;
+
+		insert_start = round_up(cur_off, BTRFS_STRIPE_LEN);
+
+		ret = add_merge_cache_extent(free, insert_start, len);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Remove reserved bytes */
+	ret = wipe_reserved_ranges(free, min_stripe_size, 0);
+out:
+	return ret;
+}
 /*
- * Read used space
+ * Read used space, and since we have the used space,
+ * calcuate data_chunks and free for later mkfs
  */
 static int convert_read_used_space(struct btrfs_convert_context *cctx)
 {
-	return cctx->convert_ops->read_used_space(cctx);
+	int ret;
+
+	ret = cctx->convert_ops->read_used_space(cctx);
+	if (ret)
+		return ret;
+
+	ret = calculate_available_space(cctx);
+	return ret;
 }
 
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
-- 
2.7.0



