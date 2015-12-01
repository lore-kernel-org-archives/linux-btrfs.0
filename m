Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16800 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755111AbbLAHOS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:18 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id DCF3440444C9
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:01 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 05/25] btrfs-progs: convert: Introduce new function to remove reserved ranges
Date: Tue,  1 Dec 2015 15:11:25 +0800
Message-Id: <1448953905-28673-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce functions to remove reserved ranges for later btrfs-convert
rework.

The reserved ranges includes:
1. [0,1M)
2. [btrfs_sb_offset(1), +BTRFS_STRIP_LEN)
3. [btrfs_sb_offset(2), +BTRFS_STRIP_LEN)

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 65841bd..2fef1ed 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2521,6 +2521,123 @@ static int convert_open_fs(const char *devname,
 }
 
 /*
+ * Remove one reserve range from given cache tree
+ * if min_stripe_size is non-zero, it will ensure for split case,
+ * all its split cache extent is no smaller than @min_strip_size / 2.
+ */
+static int wipe_one_reserved_range(struct cache_tree *tree,
+				   u64 start, u64 len, u64 min_stripe_size,
+				   int ensure_size)
+{
+	struct cache_extent *cache;
+	int ret;
+
+	BUG_ON(ensure_size && min_stripe_size == 0);
+	/*
+	 * The logical here is simplified to handle special cases only
+	 * So we don't need to consider merge case for ensure_size
+	 */
+	BUG_ON(min_stripe_size && (min_stripe_size < len * 2 ||
+	       min_stripe_size / 2 < BTRFS_STRIPE_LEN));
+
+	/* Also, wipe range should already be aligned */
+	BUG_ON(start != round_down(start, BTRFS_STRIPE_LEN) ||
+	       start + len != round_up(start + len, BTRFS_STRIPE_LEN));
+
+	min_stripe_size /= 2;
+
+	cache = lookup_cache_extent(tree, start, len);
+	if (!cache)
+		return 0;
+
+	if (start <= cache->start) {
+		/*
+		 *	|--------cache---------|
+		 * |-wipe-|
+		 */
+		BUG_ON(start + len <= cache->start);
+
+		/*
+		 * The wipe size is smaller than min_stripe_size / 2,
+		 * so the result length should still meet min_stripe_size
+		 * And no need to do alignment
+		 */
+		cache->size -= (start + len - cache->start);
+		if (cache->size == 0) {
+			remove_cache_extent(tree, cache);
+			free(cache);
+			return 0;
+		}
+
+		BUG_ON(ensure_size && cache->size < min_stripe_size);
+
+		cache->start = start + len;
+		return 0;
+	} else if (start > cache->start && start + len < cache->start +
+		   cache->size) {
+		/*
+		 * |-------cache-----|
+		 *	|-wipe-|
+		 */
+		u64 old_len = cache->size;
+		u64 insert_start = start + len;
+		u64 insert_len;
+
+		cache->size = start - cache->start;
+		if (ensure_size)
+			cache->size = max(cache->size, min_stripe_size);
+		cache->start = start - cache->size;
+
+		/* And insert the new one */
+		insert_len = old_len - start - len;
+		if (ensure_size)
+			insert_len = max(insert_len, min_stripe_size);
+
+		ret = add_merge_cache_extent(tree, insert_start, insert_len);
+		return ret;
+	}
+	/*
+	 * |----cache-----|
+	 *		|--wipe-|
+	 * Wipe len should be small enough and no need to expand the
+	 * remaining extent
+	 */
+	cache->size = start - cache->start;
+	BUG_ON(ensure_size && cache->size < min_stripe_size);
+	return 0;
+}
+
+/*
+ * Remove reserved ranges from given cache_tree
+ *
+ * It will remove the following ranges
+ * 1) 0~1M
+ * 2) 2nd superblock, +64K(make sure chunks are 64K aligned)
+ * 3) 3rd superblock, +64K
+ *
+ * @min_stripe must be given for safety check
+ * and if @ensure_size is given, it will ensure affected cache_extent will be
+ * larger than min_stripe_size
+ */
+static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
+				int ensure_size)
+{
+	int ret;
+
+	ret = wipe_one_reserved_range(tree, 0, 1024 * 1024, min_stripe_size,
+				      ensure_size);
+	if (ret < 0)
+		return ret;
+	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(1),
+			BTRFS_STRIPE_LEN, min_stripe_size, ensure_size);
+	if (ret < 0)
+		return ret;
+	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(2),
+			BTRFS_STRIPE_LEN, min_stripe_size, ensure_size);
+	return ret;
+}
+
+/*
  * Read used space
  */
 static int convert_read_used_space(struct btrfs_convert_context *cctx)
-- 
2.6.2



