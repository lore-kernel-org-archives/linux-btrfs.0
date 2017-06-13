Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17180 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752552AbdFMJTs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:48 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 03/19] btrfs-progs: Refactor btrfs_next_bg and its callers to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:19 +0800
Message-ID: <20170613091935.23277-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 find-root.c |  4 ++--
 volumes.c   |  5 +++--
 volumes.h   | 14 +++++++-------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/find-root.c b/find-root.c
index 1b41b217..1765adf8 100644
--- a/find-root.c
+++ b/find-root.c
@@ -118,11 +118,11 @@ int btrfs_find_root_search(struct btrfs_fs_info *fs_info,
 	fs_info->suppress_check_block_errors = 1;
 	while (1) {
 		if (filter->objectid != BTRFS_CHUNK_TREE_OBJECTID)
-			ret = btrfs_next_bg_metadata(&fs_info->mapping_tree,
+			ret = btrfs_next_bg_metadata(fs_info,
 						  &chunk_offset,
 						  &chunk_size);
 		else
-			ret = btrfs_next_bg_system(&fs_info->mapping_tree,
+			ret = btrfs_next_bg_system(fs_info,
 						&chunk_offset,
 						&chunk_size);
 		if (ret) {
diff --git a/volumes.c b/volumes.c
index 89e39e43..700def64 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1252,9 +1252,10 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	return ret;
 }
 
-int btrfs_next_bg(struct btrfs_mapping_tree *map_tree, u64 *logical,
-		     u64 *size, u64 type)
+int btrfs_next_bg(struct btrfs_fs_info *fs_info, u64 *logical,
+		  u64 *size, u64 type)
 {
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct cache_extent *ce;
 	struct map_lookup *map;
 	u64 cur = *logical;
diff --git a/volumes.h b/volumes.h
index 26d88813..6f164e7f 100644
--- a/volumes.h
+++ b/volumes.h
@@ -187,18 +187,18 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_multi_bio **multi_ret, int mirror_num,
 		    u64 **raid_map_ret);
-int btrfs_next_bg(struct btrfs_mapping_tree *map_tree, u64 *logical,
+int btrfs_next_bg(struct btrfs_fs_info *map_tree, u64 *logical,
 		     u64 *size, u64 type);
-static inline int btrfs_next_bg_metadata(struct btrfs_mapping_tree *map_tree,
-				      u64 *logical, u64 *size)
+static inline int btrfs_next_bg_metadata(struct btrfs_fs_info *fs_info,
+					 u64 *logical, u64 *size)
 {
-	return btrfs_next_bg(map_tree, logical, size,
+	return btrfs_next_bg(fs_info, logical, size,
 			BTRFS_BLOCK_GROUP_METADATA);
 }
-static inline int btrfs_next_bg_system(struct btrfs_mapping_tree *map_tree,
-				    u64 *logical, u64 *size)
+static inline int btrfs_next_bg_system(struct btrfs_fs_info *fs_info,
+				       u64 *logical, u64 *size)
 {
-	return btrfs_next_bg(map_tree, logical, size,
+	return btrfs_next_bg(fs_info, logical, size,
 			BTRFS_BLOCK_GROUP_SYSTEM);
 }
 int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
-- 
2.13.1



