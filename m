Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21484 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754620AbbKRHYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:42 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoS0007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 05/22] btrfs-progs: utils: Introduce new function to remove reserved ranges
Date: Wed, 18 Nov 2015 15:22:05 +0800
Message-Id: <1447831342-15056-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
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
 utils.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/utils.c b/utils.c
index 60235d8..5ab5ede 100644
--- a/utils.c
+++ b/utils.c
@@ -177,6 +177,121 @@ int test_uuid_unique(char *fs_uuid)
 }
 
 /*
+ * Remove one reserve range from given cache tree
+ * if min_stripe_size is non-zero, it will ensure for split case,
+ * all its split cache extent is no smaller than @min_strip_size / 2.
+ *
+ */
+static int wipe_one_reserved_range(struct cache_tree *tree,
+				   u64 start, u64 len, u64 min_stripe_size,
+				   int ensure_size)
+{
+	struct cache_extent *cache;
+	int ret;
+
+	/* The logical here is simplified to handle special cases only */
+	BUG_ON(min_stripe_size < len * 2 ||
+	       min_stripe_size / 2 < BTRFS_STRIPE_LEN);
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
+		 * 	|-wipe-|
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
+	} else {
+		/*
+		 * |----cache-----|
+		 * 		|--wipe-|
+		 * Wipe len should be small enough and no need to expand the
+		 * remaining extent
+		 */
+		cache->size = start - cache->start;
+		BUG_ON(ensure_size && cache->size < min_stripe_size);
+		return 0;
+	}
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
+	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(1), BTRFS_STRIPE_LEN,
+				      min_stripe_size, ensure_size);
+	if (ret < 0)
+		return ret;
+	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(2), BTRFS_STRIPE_LEN,
+				      min_stripe_size, ensure_size);
+	return ret;
+}
+
+/*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
  */
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
-- 
2.6.2

