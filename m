Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14568 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932345AbbKMCxr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 21:53:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAD2r2XX031969
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 10:53:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: find-root: Add support to search chunk root
Date: Fri, 13 Nov 2015 10:53:41 +0800
Message-ID: <1447383221-20729-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support to search chunk root, as we only need to search tree roots
in system chunk, which should be very easy to add, just iterate in
system chunks.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 find-root.c | 18 ++++++++++++------
 volumes.c   |  6 +++---
 volumes.h   | 16 ++++++++++++++--
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/find-root.c b/find-root.c
index 55e7942..5e97c80 100644
--- a/find-root.c
+++ b/find-root.c
@@ -108,8 +108,8 @@ int btrfs_find_root_search(struct btrfs_root *chunk_root,
 {
 	struct btrfs_fs_info *fs_info = chunk_root->fs_info;
 	struct extent_buffer *eb;
-	u64 metadata_offset = 0;
-	u64 metadata_size = 0;
+	u64 chunk_offset = 0;
+	u64 chunk_size = 0;
 	u64 offset = 0;
 	u32 leafsize = chunk_root->leafsize;
 	int suppress_errors = 0;
@@ -118,15 +118,21 @@ int btrfs_find_root_search(struct btrfs_root *chunk_root,
 	suppress_errors = fs_info->suppress_check_block_errors;
 	fs_info->suppress_check_block_errors = 1;
 	while (1) {
-		ret = btrfs_next_metadata(&fs_info->mapping_tree,
-					  &metadata_offset, &metadata_size);
+		if (filter->objectid != BTRFS_CHUNK_TREE_OBJECTID)
+			ret = btrfs_next_metadata(&fs_info->mapping_tree,
+						  &chunk_offset,
+						  &chunk_size);
+		else
+			ret = btrfs_next_system(&fs_info->mapping_tree,
+						&chunk_offset,
+						&chunk_size);
 		if (ret) {
 			if (ret == -ENOENT)
 				ret = 0;
 			break;
 		}
-		for (offset = metadata_offset;
-		     offset < metadata_offset + metadata_size;
+		for (offset = chunk_offset;
+		     offset < chunk_offset + chunk_size;
 		     offset += chunk_root->leafsize) {
 			eb = read_tree_block(chunk_root, offset, leafsize, 0);
 			if (!eb || IS_ERR(eb))
diff --git a/volumes.c b/volumes.c
index 83ddd16..3dc9099 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1175,8 +1175,8 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	return ret;
 }
 
-int btrfs_next_metadata(struct btrfs_mapping_tree *map_tree, u64 *logical,
-			u64 *size)
+int btrfs_next_chunk(struct btrfs_mapping_tree *map_tree, u64 *logical,
+		     u64 *size, u64 type)
 {
 	struct cache_extent *ce;
 	struct map_lookup *map;
@@ -1189,7 +1189,7 @@ int btrfs_next_metadata(struct btrfs_mapping_tree *map_tree, u64 *logical,
 			return -ENOENT;
 
 		map = container_of(ce, struct map_lookup, ce);
-		if (map->type & BTRFS_BLOCK_GROUP_METADATA) {
+		if (map->type & type) {
 			*logical = ce->start;
 			*size = ce->size;
 			return 0;
diff --git a/volumes.h b/volumes.h
index 4ecb993..68f5144 100644
--- a/volumes.h
+++ b/volumes.h
@@ -167,8 +167,20 @@ int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_multi_bio **multi_ret, int mirror_num,
 		    u64 **raid_map_ret);
-int btrfs_next_metadata(struct btrfs_mapping_tree *map_tree, u64 *logical,
-			u64 *size);
+int btrfs_next_chunk(struct btrfs_mapping_tree *map_tree, u64 *logical,
+		     u64 *size, u64 type);
+static inline int btrfs_next_metadata(struct btrfs_mapping_tree *map_tree,
+				      u64 *logical, u64 *size)
+{
+	return btrfs_next_chunk(map_tree, logical, size,
+				BTRFS_BLOCK_GROUP_METADATA);
+}
+static inline int btrfs_next_system(struct btrfs_mapping_tree *map_tree,
+				    u64 *logical, u64 *size)
+{
+	return btrfs_next_chunk(map_tree, logical, size,
+				BTRFS_BLOCK_GROUP_SYSTEM);
+}
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
-- 
2.6.2

