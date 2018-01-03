Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:52311 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeACHNX (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 3 Jan 2018 02:13:23 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/5] btrfs-progs: Remove unnecessary parameter for btrfs_add_block_group
Date: Wed,  3 Jan 2018 15:13:06 +0800
Message-Id: <20180103071306.11500-6-wqu@suse.com>
In-Reply-To: <20180103071306.11500-1-wqu@suse.com>
References: <20180103071306.11500-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@chunk_objectid of btrfs_make_block_group() function is always fixed to
BTRFS_FIRST_FREE_OBJECTID, so there is no need to pass it as parameter
explicitly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c   |  4 ++--
 convert/main.c |  4 +---
 ctree.h        |  5 ++---
 extent-tree.c  | 14 +++++++-------
 mkfs/main.c    | 14 ++++----------
 5 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a93ac2c88a38..635c1c44ff6f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13036,7 +13036,7 @@ static int repair_chunk_item(struct btrfs_trans_handle *trans,
 
 	if (err & REFERENCER_MISSING) {
 		ret = btrfs_make_block_group(trans, chunk_root->fs_info, 0,
-		     type, chunk_key.objectid, chunk_key.offset, length);
+					     type, chunk_key.offset, length);
 		if (ret) {
 			error("fail to add block group item[%llu %llu]",
 			      chunk_key.offset, length);
@@ -13637,7 +13637,7 @@ static int reset_block_groups(struct btrfs_fs_info *fs_info)
 		chunk = btrfs_item_ptr(leaf, path.slots[0], struct btrfs_chunk);
 		btrfs_add_block_group(fs_info, 0,
 				      btrfs_chunk_type(leaf, chunk),
-				      key.objectid, key.offset,
+				      key.offset,
 				      btrfs_chunk_length(leaf, chunk));
 		set_extent_dirty(&fs_info->free_space_cache, key.offset,
 				 key.offset + btrfs_chunk_length(leaf, chunk));
diff --git a/convert/main.c b/convert/main.c
index af2855316fee..4a510a786394 100644
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
index 61d9f9fc9dff..5a04c0f1c912 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2497,11 +2497,10 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info);
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
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
diff --git a/extent-tree.c b/extent-tree.c
index 58b64a21d226..db24da3a3a8c 100644
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
@@ -3312,7 +3312,7 @@ error:
 
 struct btrfs_block_group_cache *
 btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
-		      u64 chunk_objectid, u64 chunk_offset, u64 size)
+		      u64 chunk_offset, u64 size)
 {
 	int ret;
 	int bit = 0;
@@ -3328,7 +3328,8 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	btrfs_set_block_group_used(&cache->item, bytes_used);
-	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
+	btrfs_set_block_group_chunk_objectid(&cache->item,
+			BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
@@ -3353,15 +3354,14 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 
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
index a69a699fa3fd..938025bfd32e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -83,7 +83,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 	root->fs_info->system_allocs = 1;
 	ret = btrfs_make_block_group(trans, fs_info, bytes_used,
 				     BTRFS_BLOCK_GROUP_SYSTEM,
-				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
 	allocation->system += BTRFS_MKFS_SYSTEM_GROUP_SIZE;
 	if (ret)
@@ -103,7 +102,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_METADATA |
 					     BTRFS_BLOCK_GROUP_DATA,
-					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		if (ret)
 			return ret;
@@ -120,7 +118,6 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 			return ret;
 		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_METADATA,
-					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->metadata += chunk_size;
 		if (ret)
@@ -155,7 +152,6 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
 			return ret;
 		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_DATA,
-					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->data += chunk_size;
 		if (ret)
@@ -264,8 +260,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				     chunk_start, chunk_size);
+				     type, chunk_start, chunk_size);
 
 	type &= BTRFS_BLOCK_GROUP_TYPE_MASK;
 	if (type == BTRFS_BLOCK_GROUP_DATA) {
@@ -1012,8 +1007,8 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 		if (ret)
 			return ret;
 		ret = btrfs_make_block_group(trans, fs_info, 0,
-					     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-					     chunk_start, chunk_size);
+					     meta_type, chunk_start,
+					     chunk_size);
 		allocation->metadata += chunk_size;
 		if (ret)
 			return ret;
@@ -1029,8 +1024,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				     chunk_start, size_of_data);
+				     data_type, chunk_start, size_of_data);
 	allocation->data += size_of_data;
 	if (ret)
 		return ret;
-- 
2.15.1

