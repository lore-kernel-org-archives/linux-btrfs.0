Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21484 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752730AbbKRHYj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:39 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoRv007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 02/22] btrfs-progs: extent-tree: Add add_merge_cache_extent function
Date: Wed, 18 Nov 2015 15:22:02 +0800
Message-Id: <1447831342-15056-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This add_merge_cache_extent() function will try to merge adjusted
cache_extent.

This is used for later btrfs-convert ext2 free space cache.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-cache.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 extent-cache.h |  8 ++++++++
 2 files changed, 65 insertions(+)

diff --git a/extent-cache.c b/extent-cache.c
index d80aead..38bed8b 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -282,3 +282,60 @@ void free_extent_cache_tree(struct cache_tree *tree)
 {
 	cache_tree_free_extents(tree, free_extent_cache);
 }
+
+int add_merge_cache_extent(struct cache_tree *tree, u64 start, u64 size)
+{
+	struct cache_extent *cache;
+	struct cache_extent *next = NULL;
+	struct cache_extent *prev = NULL;
+	int next_merged = 0;
+	int prev_merged = 0;
+	int ret = 0;
+
+	if (cache_tree_empty(tree))
+		goto insert;
+
+	cache = search_cache_extent(tree, start);
+	if (!cache) {
+		/*
+		 * Either the tree is completely empty, or the no range after
+		 * start.
+		 * Either way, the last cache_extent should be prev.
+		 */
+		prev = last_cache_extent(tree);
+	} else if (start <= cache->start) {
+		next = cache;
+		prev = prev_cache_extent(cache);
+	} else {
+		prev = cache;
+		next = next_cache_extent(cache);
+	}
+
+	/*
+	 * Ensure the range to be inserted won't cover with existings
+	 * Or we will need extra loop to do merge
+	 */
+	BUG_ON(next && start + size > next->start);
+	BUG_ON(prev && prev->start + prev->size > start);
+
+	if (next && start + size == next->start) {
+		next_merged = 1;
+		next->size = next->start + next->size - start;
+		next->start = start;
+	}
+	if (prev && prev->start + prev->size == start) {
+		prev_merged = 1;
+		if (next_merged) {
+			next->size = next->start + next->size - prev->start;
+			next->start = prev->start;
+			remove_cache_extent(tree, prev);
+			free(prev);
+		} else {
+			prev->size = start + size - prev->start;
+		}
+	}
+insert:
+	if (!prev_merged && !next_merged)
+		ret = add_cache_extent(tree, start, size);
+	return ret;
+}
diff --git a/extent-cache.h b/extent-cache.h
index 1ce68ef..f031fbf 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -110,4 +110,12 @@ int add_cache_extent2(struct cache_tree *tree,
 		      u64 objectid, u64 start, u64 size);
 int insert_cache_extent2(struct cache_tree *tree, struct cache_extent *pe);
 
+/*
+ * Insert a cache_extent range [start, start + size).
+ *
+ * This function may merge with existing cache_extent.
+ * NOTE: caller must ensure the inserted range won't cover with any existing
+ * range.
+ */
+int add_merge_cache_extent(struct cache_tree *tree, u64 start, u64 size);
 #endif
-- 
2.6.2

