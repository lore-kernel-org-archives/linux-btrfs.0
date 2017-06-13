Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752572AbdFMJT6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:58 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 19/19] btrfs-progs: Refactor chunk creation functions to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:35 +0800
Message-ID: <20170613091935.23277-20-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

4 functions are involved in this refactor: btrfs_make_block_group()
btrfs_make_block_groups(), btrfs_alloc_chunk, btrfs_alloc_data_chunk().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c |  4 ++--
 ctree.h        |  4 ++--
 extent-tree.c  | 45 +++++++++++++++++++++------------------------
 mkfs/main.c    | 32 ++++++++++++++++++--------------
 volumes.c      |  8 ++++----
 volumes.h      |  4 ++--
 6 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 103cd5cd..4f65765d 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1024,12 +1024,12 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
 
 			len = min(max_chunk_size,
 				  cache->start + cache->size - cur);
-			ret = btrfs_alloc_data_chunk(trans, extent_root,
+			ret = btrfs_alloc_data_chunk(trans, fs_info,
 					&cur_backup, len,
 					BTRFS_BLOCK_GROUP_DATA, 1);
 			if (ret < 0)
 				break;
-			ret = btrfs_make_block_group(trans, extent_root, 0,
+			ret = btrfs_make_block_group(trans, fs_info, 0,
 					BTRFS_BLOCK_GROUP_DATA,
 					BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					cur, len);
diff --git a/ctree.h b/ctree.h
index cf337ae5..48ae8903 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2498,11 +2498,11 @@ struct btrfs_block_group_cache *
 btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 		      u64 chunk_objectid, u64 chunk_offset, u64 size);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 bytes_used,
+			   struct btrfs_fs_info *fs_info, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root);
+			    struct btrfs_fs_info *fs_info);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr, u64 num,
 			     int alloc, int mark_free);
diff --git a/extent-tree.c b/extent-tree.c
index 683cb583..75ed94ff 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1872,7 +1872,7 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 }
 
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *extent_root, u64 alloc_bytes,
+			  struct btrfs_fs_info *fs_info, u64 alloc_bytes,
 			  u64 flags)
 {
 	struct btrfs_space_info *space_info;
@@ -1881,10 +1881,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	u64 num_bytes;
 	int ret;
 
-	space_info = __find_space_info(extent_root->fs_info, flags);
+	space_info = __find_space_info(fs_info, flags);
 	if (!space_info) {
-		ret = update_space_info(extent_root->fs_info, flags,
-					0, 0, &space_info);
+		ret = update_space_info(fs_info, flags, 0, 0, &space_info);
 		BUG_ON(ret);
 	}
 	BUG_ON(!space_info);
@@ -1900,14 +1899,14 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	/*
 	 * Avoid allocating given chunk type
 	 */
-	if (extent_root->fs_info->avoid_meta_chunk_alloc &&
+	if (fs_info->avoid_meta_chunk_alloc &&
 	    (flags & BTRFS_BLOCK_GROUP_METADATA))
 		return 0;
-	if (extent_root->fs_info->avoid_sys_chunk_alloc &&
+	if (fs_info->avoid_sys_chunk_alloc &&
 	    (flags & BTRFS_BLOCK_GROUP_SYSTEM))
 		return 0;
 
-	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes,
+	ret = btrfs_alloc_chunk(trans, fs_info, &start, &num_bytes,
 	                        space_info->flags);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
@@ -1916,7 +1915,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 
 	BUG_ON(ret);
 
-	ret = btrfs_make_block_group(trans, extent_root, 0, space_info->flags,
+	ret = btrfs_make_block_group(trans, fs_info, 0, space_info->flags,
 		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
 	BUG_ON(ret);
 	return 0;
@@ -2676,12 +2675,12 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 
 	if (root->ref_cows) {
 		if (!(data & BTRFS_BLOCK_GROUP_METADATA)) {
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+			ret = do_chunk_alloc(trans, info,
 					     num_bytes,
 					     BTRFS_BLOCK_GROUP_METADATA);
 			BUG_ON(ret);
 		}
-		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+		ret = do_chunk_alloc(trans, info,
 				     num_bytes + SZ_2M, data);
 		BUG_ON(ret);
 	}
@@ -2692,7 +2691,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			       trans->alloc_exclude_start,
 			       trans->alloc_exclude_nr, data);
 	BUG_ON(ret);
-	clear_extent_dirty(&root->fs_info->free_space_cache,
+	clear_extent_dirty(&info->free_space_cache,
 			   ins->objectid, ins->objectid + ins->offset - 1);
 	return ret;
 }
@@ -3352,17 +3351,16 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 }
 
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 bytes_used,
+			   struct btrfs_fs_info *fs_info, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size)
 {
 	int ret;
-	struct btrfs_root *extent_root;
+	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_cache *cache;
 
-	cache = btrfs_add_block_group(root->fs_info, bytes_used, type,
+	cache = btrfs_add_block_group(fs_info, bytes_used, type,
 				      chunk_objectid, chunk_offset, size);
-	extent_root = root->fs_info->extent_root;
 	ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
 				sizeof(cache->item));
 	BUG_ON(ret);
@@ -3383,7 +3381,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
  * before doing any block allocation.
  */
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root)
+			    struct btrfs_fs_info *fs_info)
 {
 	u64 total_bytes;
 	u64 cur_start;
@@ -3395,15 +3393,14 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 	u64 chunk_objectid;
 	int ret;
 	int bit;
-	struct btrfs_root *extent_root;
+	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_cache *cache;
 	struct extent_io_tree *block_group_cache;
 
-	extent_root = root->fs_info->extent_root;
-	block_group_cache = &root->fs_info->block_group_cache;
+	block_group_cache = &fs_info->block_group_cache;
 	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
-	group_align = 64 * root->fs_info->sectorsize;
+	total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	group_align = 64 * fs_info->sectorsize;
 
 	cur_start = 0;
 	while (cur_start < total_bytes) {
@@ -3446,10 +3443,10 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 
 		cache->flags = group_type;
 
-		ret = update_space_info(root->fs_info, group_type, group_size,
+		ret = update_space_info(fs_info, group_type, group_size,
 					0, &cache->space_info);
 		BUG_ON(ret);
-		set_avail_alloc_bits(extent_root->fs_info, group_type);
+		set_avail_alloc_bits(fs_info, group_type);
 
 		set_extent_bits(block_group_cache, cur_start,
 				cur_start + group_size - 1,
@@ -3461,7 +3458,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 	/* then insert all the items */
 	cur_start = 0;
 	while(cur_start < total_bytes) {
-		cache = btrfs_lookup_block_group(root->fs_info, cur_start);
+		cache = btrfs_lookup_block_group(fs_info, cur_start);
 		BUG_ON(!cache);
 
 		ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
diff --git a/mkfs/main.c b/mkfs/main.c
index df2af474..2b109a53 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -67,6 +67,7 @@ struct mkfs_allocation {
 static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 				struct mkfs_allocation *allocation)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_trans_handle *trans;
 	u64 bytes_used;
 	u64 chunk_start = 0;
@@ -74,10 +75,10 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 	int ret;
 
 	trans = btrfs_start_transaction(root, 1);
-	bytes_used = btrfs_super_bytes_used(root->fs_info->super_copy);
+	bytes_used = btrfs_super_bytes_used(fs_info->super_copy);
 
 	root->fs_info->system_allocs = 1;
-	ret = btrfs_make_block_group(trans, root, bytes_used,
+	ret = btrfs_make_block_group(trans, fs_info, bytes_used,
 				     BTRFS_BLOCK_GROUP_SYSTEM,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
@@ -86,7 +87,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 		return ret;
 
 	if (mixed) {
-		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+		ret = btrfs_alloc_chunk(trans, fs_info,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA |
 					BTRFS_BLOCK_GROUP_DATA);
@@ -96,7 +97,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 		}
 		if (ret)
 			return ret;
-		ret = btrfs_make_block_group(trans, root, 0,
+		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_METADATA |
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
@@ -105,7 +106,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 			return ret;
 		allocation->mixed += chunk_size;
 	} else {
-		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+		ret = btrfs_alloc_chunk(trans, fs_info,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA);
 		if (ret == -ENOSPC) {
@@ -114,7 +115,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 		}
 		if (ret)
 			return ret;
-		ret = btrfs_make_block_group(trans, root, 0,
+		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_METADATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
@@ -134,12 +135,13 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
 		struct btrfs_root *root, int mixed,
 		struct mkfs_allocation *allocation)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 chunk_start = 0;
 	u64 chunk_size = 0;
 	int ret = 0;
 
 	if (!mixed) {
-		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+		ret = btrfs_alloc_chunk(trans, fs_info,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_DATA);
 		if (ret == -ENOSPC) {
@@ -148,7 +150,7 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
 		}
 		if (ret)
 			return ret;
-		ret = btrfs_make_block_group(trans, root, 0,
+		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
@@ -244,11 +246,12 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 			      struct mkfs_allocation *allocation)
 
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 chunk_start;
 	u64 chunk_size;
 	int ret;
 
-	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+	ret = btrfs_alloc_chunk(trans, fs_info,
 				&chunk_start, &chunk_size, type);
 	if (ret == -ENOSPC) {
 		error("not enough free space to allocate chunk");
@@ -257,7 +260,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
+	ret = btrfs_make_block_group(trans, fs_info, 0,
 				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, chunk_size);
 
@@ -984,6 +987,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 			 u64 size_of_data,
 			 struct mkfs_allocation *allocation)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 chunk_start;
 	u64 chunk_size;
 	u64 meta_type = BTRFS_BLOCK_GROUP_METADATA;
@@ -993,11 +997,11 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	int ret;
 
 	for (i = 0; i < num_of_meta_chunks; i++) {
-		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+		ret = btrfs_alloc_chunk(trans, fs_info,
 					&chunk_start, &chunk_size, meta_type);
 		if (ret)
 			return ret;
-		ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
+		ret = btrfs_make_block_group(trans, fs_info, 0,
 					     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
 		allocation->metadata += chunk_size;
@@ -1010,11 +1014,11 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	if (size_of_data < minimum_data_chunk_size)
 		size_of_data = minimum_data_chunk_size;
 
-	ret = btrfs_alloc_data_chunk(trans, root->fs_info->extent_root,
+	ret = btrfs_alloc_data_chunk(trans, fs_info,
 				     &chunk_start, size_of_data, data_type, 0);
 	if (ret)
 		return ret;
-	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
+	ret = btrfs_make_block_group(trans, fs_info, 0,
 				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, size_of_data);
 	allocation->data += size_of_data;
diff --git a/volumes.c b/volumes.c
index 2c1bb62e..79dad244 100644
--- a/volumes.c
+++ b/volumes.c
@@ -833,11 +833,11 @@ error:
 				/ sizeof(struct btrfs_stripe) + 1)
 
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *extent_root, u64 *start,
+		      struct btrfs_fs_info *info, u64 *start,
 		      u64 *num_bytes, u64 type)
 {
 	u64 dev_offset;
-	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct btrfs_root *extent_root = info->extent_root;
 	struct btrfs_root *chunk_root = info->chunk_root;
 	struct btrfs_stripe *stripes;
 	struct btrfs_device *device = NULL;
@@ -1099,11 +1099,11 @@ again:
  * occupied.
  */
 int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *extent_root, u64 *start,
+			   struct btrfs_fs_info *info, u64 *start,
 			   u64 num_bytes, u64 type, int convert)
 {
 	u64 dev_offset;
-	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct btrfs_root *extent_root = info->extent_root;
 	struct btrfs_root *chunk_root = info->chunk_root;
 	struct btrfs_stripe *stripes;
 	struct btrfs_device *device = NULL;
diff --git a/volumes.h b/volumes.h
index 68bd98ae..d35a4e65 100644
--- a/volumes.h
+++ b/volumes.h
@@ -207,10 +207,10 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *extent_root, u64 *start,
+		      struct btrfs_fs_info *fs_info, u64 *start,
 		      u64 *num_bytes, u64 type);
 int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *extent_root, u64 *start,
+			   struct btrfs_fs_info *fs_info, u64 *start,
 			   u64 num_bytes, u64 type, int convert);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       int flags);
-- 
2.13.1



