Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46084 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbeASFiB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:38:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 14/16] btrfs-progs: check: Move reset_cached_block_groups to check/common.c
Date: Fri, 19 Jan 2018 13:37:29 +0800
Message-Id: <20180119053731.10795-15-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.c | 25 +++++++++++++++++++++++++
 check/common.h |  1 +
 check/main.c   | 27 ---------------------------
 3 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/check/common.c b/check/common.c
index 4cdc46b0ba7c..d6abf6d6733c 100644
--- a/check/common.c
+++ b/check/common.c
@@ -324,3 +324,28 @@ int check_child_node(struct extent_buffer *parent, int slot,
 	}
 	return ret;
 }
+
+void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group_cache *cache;
+	u64 start, end;
+	int ret;
+
+	while (1) {
+		ret = find_first_extent_bit(&fs_info->free_space_cache, 0,
+					    &start, &end, EXTENT_DIRTY);
+		if (ret)
+			break;
+		clear_extent_dirty(&fs_info->free_space_cache, start, end);
+	}
+
+	start = 0;
+	while (1) {
+		cache = btrfs_lookup_first_block_group(fs_info, start);
+		if (!cache)
+			break;
+		if (cache->cached)
+			cache->cached = 0;
+		start = cache->key.objectid + cache->key.offset;
+	}
+}
diff --git a/check/common.h b/check/common.h
index d200a0c90e38..09745af4932f 100644
--- a/check/common.h
+++ b/check/common.h
@@ -95,5 +95,6 @@ void reada_walk_down(struct btrfs_root *root, struct extent_buffer *node,
 		     int slot);
 int check_child_node(struct extent_buffer *parent, int slot,
 		     struct extent_buffer *child);
+void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
 
 #endif
diff --git a/check/main.c b/check/main.c
index af4e54857fbf..3c556db90c30 100644
--- a/check/main.c
+++ b/check/main.c
@@ -412,8 +412,6 @@ static void free_file_extent_holes(struct rb_root *holes)
 	}
 }
 
-static void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
-
 static void record_root_in_trans(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root)
 {
@@ -10196,31 +10194,6 @@ static int prune_corrupt_blocks(struct btrfs_fs_info *info)
 	return 0;
 }
 
-static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_block_group_cache *cache;
-	u64 start, end;
-	int ret;
-
-	while (1) {
-		ret = find_first_extent_bit(&fs_info->free_space_cache, 0,
-					    &start, &end, EXTENT_DIRTY);
-		if (ret)
-			break;
-		clear_extent_dirty(&fs_info->free_space_cache, start, end);
-	}
-
-	start = 0;
-	while (1) {
-		cache = btrfs_lookup_first_block_group(fs_info, start);
-		if (!cache)
-			break;
-		if (cache->cached)
-			cache->cached = 0;
-		start = cache->key.objectid + cache->key.offset;
-	}
-}
-
 static int check_extent_refs(struct btrfs_root *root,
 			     struct cache_tree *extent_cache)
 {
-- 
2.15.1

