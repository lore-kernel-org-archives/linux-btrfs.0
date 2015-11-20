Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38125 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934929AbbKTD0k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:26:40 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdA022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:25:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/25] btrfs-progs: extent-cache: Add comments for search/lookup functions
Date: Fri, 20 Nov 2015 11:24:05 +0800
Message-Id: <1447989869-24739-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are quite a lot search/lookup functions with different behavior,
add comments for them, as it will take extra time to view source to
understand the behavior difference.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-cache.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/extent-cache.h b/extent-cache.h
index cb1f77c..1ce68ef 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -45,11 +45,31 @@ struct cache_extent *last_cache_extent(struct cache_tree *tree);
 struct cache_extent *prev_cache_extent(struct cache_extent *pe);
 struct cache_extent *next_cache_extent(struct cache_extent *pe);
 
+/*
+ * Find a cache_extent which covers start.
+ *
+ * If not found, return next cache_extent if possible.
+ */
 struct cache_extent *search_cache_extent(struct cache_tree *tree, u64 start);
+
+/*
+ * Find a cahce_extent which restrictly covers start.
+ *
+ * If not found, return NULL.
+ */
 struct cache_extent *lookup_cache_extent(struct cache_tree *tree,
 					 u64 start, u64 size);
 
+/*
+ * Add an non-overlap extent into cache tree
+ *
+ * If [start, start+size) overlap with existing one, it will return -EEXIST.
+ */
 int add_cache_extent(struct cache_tree *tree, u64 start, u64 size);
+
+/*
+ * Same with add_cache_extent, but with cache_extent strcut.
+ */
 int insert_cache_extent(struct cache_tree *tree, struct cache_extent *pe);
 void remove_cache_extent(struct cache_tree *tree, struct cache_extent *pe);
 
@@ -71,8 +91,19 @@ static void free_##name##_tree(struct cache_tree *tree)		\
 
 void free_extent_cache_tree(struct cache_tree *tree);
 
+/*
+ * Search a cache_extent with same objectid, and covers start.
+ *
+ * If not found, return next if possible.
+ */
 struct cache_extent *search_cache_extent2(struct cache_tree *tree,
 					  u64 objectid, u64 start);
+/*
+ * Search a cache_extent with same objectid, and covers the range
+ * [start, start + size)
+ *
+ * If not found, return next cache_extent if possible.
+ */
 struct cache_extent *lookup_cache_extent2(struct cache_tree *tree,
 					  u64 objectid, u64 start, u64 size);
 int add_cache_extent2(struct cache_tree *tree,
-- 
2.6.2

