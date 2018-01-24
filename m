Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46513 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752279AbeAXCao (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 23 Jan 2018 21:30:44 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: Remove unnecessary parameter for btrfs_add_block_group
Date: Wed, 24 Jan 2018 10:30:28 +0800
Message-Id: <20180124023028.23119-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@chunk_objectid of btrfs_make_block_group() function is always fixed to
BTRFS_FIRST_FREE_OBJECTID, so there is no need to pass it as parameter
explicitly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  Rebase to devel branch, as I introduced some conflict.
---
 cmds-check.c   |  5 ++---
 convert/main.c |  4 +---
 ctree.h        |  5 ++---
 extent-tree.c  | 14 +++++++-------
 mkfs/main.c    |  7 +------
 5 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5fc0ea9d4f4d..99fbafc5538c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13088,7 +13088,7 @@ static int repair_chunk_item(struct btrfs_trans_handle *trans,
 
 	if (err & REFERENCER_MISSING) {
 		ret = btrfs_make_block_group(trans, chunk_root->fs_info, 0,
-		     type, chunk_key.objectid, chunk_key.offset, length);
+					     type, chunk_key.offset, length);
 		if (ret) {
 			error("fail to add block group item[%llu %llu]",
 			      chunk_key.offset, length);
@@ -13680,8 +13680,7 @@ static int reset_block_groups(struct btrfs_fs_info *fs_info)
 
 		chunk = btrfs_item_ptr(leaf, path.slots[0], struct btrfs_chunk);
 		btrfs_add_block_group(fs_info, 0,
-				      btrfs_chunk_type(leaf, chunk),
-				      key.objectid, key.offset,
+				      btrfs_chunk_type(leaf, chunk), key.offset,
 				      btrfs_chunk_length(leaf, chunk));
 		set_extent_dirty(&fs_info->free_space_cache, key.offset,
 				 key.offset + btrfs_chunk_length(leaf, chunk));
diff --git a/convert/main.c b/convert/main.c
index 89f9261172ca..3cad37e94462 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -916,9 +916,7 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
 			if (ret < 0)
 				break;
 			ret = btrfs_make_block_group(trans, fs_info, 0,
-					BTRFS_BLOCK_GROUP_DATA,
-					BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-					cur, len);
+					BTRFS_BLOCK_GROUP_DATA, cur, len);
 			if (ret < 0)
 				break;
 			cur += len;
diff --git a/ctree.h b/ctree.h
index 7db0cd94ff07..a43c41f56924 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2529,11 +2529,10 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_root *root);
 struct btrfs_block_group_cache *
 btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
-		      u64 chunk_objectid, u64 chunk_offset, u64 size);
+		      u64 chunk_offset, u64 size);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info, u64 bytes_used,
-			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-			   u64 size);
+			   u64 type, u64 chunk_offset, u64 size);
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info);
 int btrfs_update_block_group(struct btrfs_root *root, u64 bytenr, u64 num,
diff --git a/extent-tree.c b/extent-tree.c
index edf659d5e4b8..94adb333a358 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1916,7 +1916,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	ret = btrfs_make_block_group(trans, fs_info, 0, space_info->flags,
-		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
+				     start, num_bytes);
 	BUG_ON(ret);
 	return 0;
 }
@@ -3310,7 +3310,7 @@ error:
 
 struct btrfs_block_group_cache *
 btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
-		      u64 chunk_objectid, u64 chunk_offset, u64 size)
+		      u64 chunk_offset, u64 size)
 {
 	int ret;
 	int bit = 0;
@@ -3326,7 +3326,8 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	btrfs_set_block_group_used(&cache->item, bytes_used);
-	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
+	btrfs_set_block_group_chunk_objectid(&cache->item,
+					     BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
@@ -3351,15 +3352,14 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info, u64 bytes_used,
-			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-			   u64 size)
+			   u64 type, u64 chunk_offset, u64 size)
 {
 	int ret;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_cache *cache;
 
-	cache = btrfs_add_block_group(fs_info, bytes_used, type,
-				      chunk_objectid, chunk_offset, size);
+	cache = btrfs_add_block_group(fs_info, bytes_used, type, chunk_offset,
+				      size);
 	ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
 				sizeof(cache->item));
 	BUG_ON(ret);
diff --git a/mkfs/main.c b/mkfs/main.c
index 9bb1f6029310..c6bd7dc6da5d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -72,7 +72,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 	 */
 	ret = btrfs_make_block_group(trans, fs_info, bytes_used,
 				     BTRFS_BLOCK_GROUP_SYSTEM,
-				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     BTRFS_BLOCK_RESERVED_1M_FOR_SUPER,
 				     BTRFS_MKFS_SYSTEM_GROUP_SIZE);
 	allocation->system += BTRFS_MKFS_SYSTEM_GROUP_SIZE;
@@ -93,7 +92,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_METADATA |
 					     BTRFS_BLOCK_GROUP_DATA,
-					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		if (ret)
 			return ret;
@@ -110,7 +108,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 			return ret;
 		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_METADATA,
-					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->metadata += chunk_size;
 		if (ret)
@@ -145,7 +142,6 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
 			return ret;
 		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_DATA,
-					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->data += chunk_size;
 		if (ret)
@@ -254,8 +250,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				     chunk_start, chunk_size);
+				     type, chunk_start, chunk_size);
 
 	type &= BTRFS_BLOCK_GROUP_TYPE_MASK;
 	if (type == BTRFS_BLOCK_GROUP_DATA) {
-- 
2.15.1

