Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14410 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161342AbbKTD0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:26:54 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdF022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:26:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/25] btrfs-progs: utils: Introduce function to calculate the available space
Date: Fri, 20 Nov 2015 11:24:10 +0800
Message-Id: <1447989869-24739-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, calculate_available_space() to get available
space for convert.

Unlike old implement, this function will do the new work:
1) batch used ext* data space.
   To ensure data chunks will recovery them all.
   And restore the result into mkfs_cfg->convert_data_chunks for later
   user.

2) avoid SB and reserved space
   Both batched data space or free space will not cover reserved space,
   like sb or the first 1M.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h | 12 +++++++++++
 2 files changed, 87 insertions(+)

diff --git a/utils.c b/utils.c
index 5ab5ede..42e333b 100644
--- a/utils.c
+++ b/utils.c
@@ -291,6 +291,81 @@ static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
 	return ret;
 }
 
+static int calculate_available_space(struct cache_tree *used,
+				     struct cache_tree *free,
+				     struct btrfs_mkfs_config *cfg)
+{
+	struct cache_extent *cache;
+	u64 cur_off = 0;
+	/* Twice minimal chunk size */
+	u64 min_stripe_size = 2 * 16 * 1024 * 1024;
+	int ret;
+
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
+		ret = add_merge_cache_extent(&cfg->convert_data_chunks,
+					     cur_off, cur_len);
+		if (ret < 0)
+			goto out;
+		cur_off += cur_len;
+	}
+
+	/* remove reserved ranges and keep the size of chunks */
+	ret = wipe_reserved_ranges(&cfg->convert_data_chunks, min_stripe_size,
+				   1);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Now calculate the free space cache tree
+	 * Always round up the start for insert, to avoid metadta extent cross
+	 * stripe boundary
+	 */
+	cur_off = 0;
+	for (cache = first_cache_extent(&cfg->convert_data_chunks); cache;
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
+	if (cfg->num_bytes > cur_off) {
+		u64 len = cfg->num_bytes - cur_off;
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
+
 /*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
  */
diff --git a/utils.h b/utils.h
index dff2633..6ac1ba8 100644
--- a/utils.h
+++ b/utils.h
@@ -31,6 +31,8 @@
 		(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF		\
 		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
+#define BTRFS_CONVERT_META_GROUP_SIZE (32 * 1024 * 1024)
+
 /*
  * Avoid multi-device features (RAID56) and mixed block groups
  */
@@ -125,6 +127,14 @@ struct btrfs_mkfs_config {
 	struct cache_tree convert_used;
 
 	/*
+	 * Ranges that should be covered by data chunk
+	 * For convert use only.
+	 *
+	 * Optimized version of convert_used, without tiny chunks.
+	 */
+	struct cache_tree convert_data_chunks;
+
+	/*
 	 * Super block bytenr.
 	 * For normal mkfs case, it shouldn't be used as mkfs doesn't support
 	 * change super block bytenr anymore.
@@ -139,11 +149,13 @@ static inline void init_mkfs_config(struct btrfs_mkfs_config *cfg)
 {
 	memset(cfg, 0, sizeof(*cfg));
 	cache_tree_init(&cfg->convert_used);
+	cache_tree_init(&cfg->convert_data_chunks);
 }
 
 static inline void free_mkfs_config(struct btrfs_mkfs_config *cfg)
 {
 	free_extent_cache_tree(&cfg->convert_used);
+	free_extent_cache_tree(&cfg->convert_data_chunks);
 }
 
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
-- 
2.6.2

