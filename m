Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27701 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755294AbbLAHOi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:38 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 95E4E40444DF
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:16 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 25/25] btrfs-progs: Cleanup old btrfs-convert
Date: Tue,  1 Dec 2015 15:11:45 +0800
Message-Id: <1448953905-28673-26-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup all the old btrfs-convert facilities, including:
1) btrfs_convert_operations->alloc/free/test_extents*
   No need to do non-standard extent allocation.
   After init_btrfs() everything can be done by normal routine.

   Now only 4 functions are needed in btrfs_convert_operations.
   1) open_fs
   2) read_used_space
   3) copy_inodes
   4) close_fs

2) fs_info->extent_ops
   Same as above.

3) Old init_btrfs(), create_image(), create_file_image_range()
   Replaced with newer and cleaner one.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 1425 ++-----------------------------------------------------
 ctree.h         |    8 -
 extent-tree.c   |   17 -
 3 files changed, 52 insertions(+), 1398 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 333f413..9c844c2 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -82,14 +82,6 @@ struct btrfs_convert_operations {
 	const char *name;
 	int (*open_fs)(struct btrfs_convert_context *cctx, const char *devname);
 	int (*read_used_space)(struct btrfs_convert_context *cctx);
-	int (*alloc_block)(struct btrfs_convert_context *cctx, u64 goal,
-			   u64 *block_ret);
-	int (*alloc_block_range)(struct btrfs_convert_context *cctx, u64 goal,
-			   int num, u64 *block_ret);
-	int (*test_block)(struct btrfs_convert_context *cctx, u64 block);
-	void (*free_block)(struct btrfs_convert_context *cctx, u64 block);
-	void (*free_block_range)(struct btrfs_convert_context *cctx, u64 block,
-			   int num);
 	int (*copy_inodes)(struct btrfs_convert_context *cctx,
 			 struct btrfs_root *root, int datacsum,
 			 int packing, int noxattr, struct task_ctx *p);
@@ -110,36 +102,6 @@ static void clean_convert_context(struct btrfs_convert_context *cctx)
 	free_extent_cache_tree(&cctx->free);
 }
 
-static inline int convert_alloc_block(struct btrfs_convert_context *cctx,
-				      u64 goal, u64 *ret)
-{
-	return  cctx->convert_ops->alloc_block(cctx, goal, ret);
-}
-
-static inline int convert_alloc_block_range(struct btrfs_convert_context *cctx,
-				      u64 goal, int num, u64 *ret)
-{
-	return  cctx->convert_ops->alloc_block_range(cctx, goal, num, ret);
-}
-
-static inline int convert_test_block(struct btrfs_convert_context *cctx,
-				     u64 block)
-{
-	return cctx->convert_ops->test_block(cctx, block);
-}
-
-static inline void convert_free_block(struct btrfs_convert_context *cctx,
-				      u64 block)
-{
-	cctx->convert_ops->free_block(cctx, block);
-}
-
-static inline void convert_free_block_range(struct btrfs_convert_context *cctx,
-				      u64 block, int num)
-{
-	cctx->convert_ops->free_block_range(cctx, block, num);
-}
-
 static inline int copy_inodes(struct btrfs_convert_context *cctx,
 			      struct btrfs_root *root, int datacsum,
 			      int packing, int noxattr, struct task_ctx *p)
@@ -285,152 +247,6 @@ static void ext2_close_fs(struct btrfs_convert_context *cctx)
 	ext2fs_close(cctx->fs_data);
 }
 
-static int ext2_alloc_block(struct btrfs_convert_context *cctx,
-			    u64 goal, u64 *block_ret)
-{
-	ext2_filsys fs = cctx->fs_data;
-	blk_t block;
-
-	if (!ext2fs_new_block(fs, goal, NULL, &block)) {
-		ext2fs_fast_mark_block_bitmap(fs->block_map, block);
-		*block_ret = block;
-		return 0;
-	}
-	return -ENOSPC;
-}
-
-static int ext2_alloc_block_range(struct btrfs_convert_context *cctx, u64 goal,
-		int num, u64 *block_ret)
-{
-	ext2_filsys fs = cctx->fs_data;
-	blk_t block;
-	ext2fs_block_bitmap bitmap = fs->block_map;
-	blk_t start = ext2fs_get_block_bitmap_start(bitmap);
-	blk_t end = ext2fs_get_block_bitmap_end(bitmap);
-
-	for (block = max_t(u64, goal, start); block + num < end; block++) {
-		if (ext2fs_fast_test_block_bitmap_range(bitmap, block, num)) {
-			ext2fs_fast_mark_block_bitmap_range(bitmap, block,
-					num);
-			*block_ret = block;
-			return 0;
-		}
-	}
-	return -ENOSPC;
-}
-
-static void ext2_free_block(struct btrfs_convert_context *cctx, u64 block)
-{
-	ext2_filsys fs = cctx->fs_data;
-
-	BUG_ON(block != (blk_t)block);
-	ext2fs_fast_unmark_block_bitmap(fs->block_map, block);
-}
-
-static void ext2_free_block_range(struct btrfs_convert_context *cctx, u64 block, int num)
-{
-	ext2_filsys fs = cctx->fs_data;
-
-	BUG_ON(block != (blk_t)block);
-	ext2fs_fast_unmark_block_bitmap_range(fs->block_map, block, num);
-}
-
-static int cache_free_extents(struct btrfs_root *root,
-			      struct btrfs_convert_context *cctx)
-
-{
-	int i, ret = 0;
-	blk_t block;
-	u64 bytenr;
-	u64 blocksize = cctx->blocksize;
-
-	block = cctx->first_data_block;
-	for (; block < cctx->block_count; block++) {
-		if (convert_test_block(cctx, block))
-			continue;
-		bytenr = block * blocksize;
-		ret = set_extent_dirty(&root->fs_info->free_space_cache,
-				       bytenr, bytenr + blocksize - 1, 0);
-		BUG_ON(ret);
-	}
-
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
-		bytenr &= ~((u64)BTRFS_STRIPE_LEN - 1);
-		if (bytenr >= blocksize * cctx->block_count)
-			break;
-		clear_extent_dirty(&root->fs_info->free_space_cache, bytenr,
-				   bytenr + BTRFS_STRIPE_LEN - 1, 0);
-	}
-
-	clear_extent_dirty(&root->fs_info->free_space_cache,
-			   0, BTRFS_SUPER_INFO_OFFSET - 1, 0);
-
-	return 0;
-}
-
-static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
-			       u64 hint_byte, struct btrfs_key *ins,
-			       int metadata)
-{
-	u64 start;
-	u64 end;
-	u64 last = hint_byte;
-	int ret;
-	int wrapped = 0;
-	struct btrfs_block_group_cache *cache;
-
-	while(1) {
-		ret = find_first_extent_bit(&root->fs_info->free_space_cache,
-					    last, &start, &end, EXTENT_DIRTY);
-		if (ret) {
-			if (wrapped++ == 0) {
-				last = 0;
-				continue;
-			} else {
-				goto fail;
-			}
-		}
-
-		start = max(last, start);
-		last = end + 1;
-		if (last - start < num_bytes)
-			continue;
-
-		last = start + num_bytes;
-		if (test_range_bit(&root->fs_info->pinned_extents,
-				   start, last - 1, EXTENT_DIRTY, 0))
-			continue;
-
-		cache = btrfs_lookup_block_group(root->fs_info, start);
-		BUG_ON(!cache);
-		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM ||
-		    last > cache->key.objectid + cache->key.offset) {
-			last = cache->key.objectid + cache->key.offset;
-			continue;
-		}
-
-		if (metadata) {
-			BUG_ON(num_bytes != root->nodesize);
-			if (check_crossing_stripes(start, num_bytes)) {
-				last = round_down(start + num_bytes,
-						  BTRFS_STRIPE_LEN);
-				continue;
-			}
-		}
-		clear_extent_dirty(&root->fs_info->free_space_cache,
-				   start, start + num_bytes - 1, 0);
-
-		ins->objectid = start;
-		ins->offset = num_bytes;
-		ins->type = BTRFS_EXTENT_ITEM_KEY;
-		return 0;
-	}
-fail:
-	fprintf(stderr, "not enough free space\n");
-	return -ENOSPC;
-}
-
 static int intersect_with_sb(u64 bytenr, u64 num_bytes)
 {
 	int i;
@@ -447,17 +263,6 @@ static int intersect_with_sb(u64 bytenr, u64 num_bytes)
 	return 0;
 }
 
-static int custom_free_extent(struct btrfs_root *root, u64 bytenr,
-			      u64 num_bytes)
-{
-	return intersect_with_sb(bytenr, num_bytes);
-}
-
-static struct btrfs_extent_ops extent_ops = {
-	.alloc_extent = custom_alloc_extent,
-	.free_extent = custom_free_extent,
-};
-
 static int convert_insert_dirent(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 const char *name, size_t name_len,
@@ -1361,29 +1166,6 @@ static int copy_single_inode(struct btrfs_trans_handle *trans,
 	return btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
 }
 
-static int copy_disk_extent(struct btrfs_root *root, u64 dst_bytenr,
-		            u64 src_bytenr, u32 num_bytes)
-{
-	int ret;
-	char *buffer;
-	struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
-
-	buffer = malloc(num_bytes);
-	if (!buffer)
-		return -ENOMEM;
-	ret = pread(fs_devs->latest_bdev, buffer, num_bytes, src_bytenr);
-	if (ret != num_bytes)
-		goto fail;
-	ret = pwrite(fs_devs->latest_bdev, buffer, num_bytes, dst_bytenr);
-	if (ret != num_bytes)
-		goto fail;
-	ret = 0;
-fail:
-	free(buffer);
-	if (ret > 0)
-		ret = -1;
-	return ret;
-}
 /*
  * scan ext2's inode bitmap and copy all used inodes.
  */
@@ -1443,255 +1225,7 @@ static int ext2_copy_inodes(struct btrfs_convert_context *cctx,
 	return ret;
 }
 
-static int ext2_test_block(struct btrfs_convert_context *cctx, u64 block)
-{
-	ext2_filsys ext2_fs = cctx->fs_data;
-
-	BUG_ON(block != (u32)block);
-	return ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block);
-}
-
-/*
- * Construct a range of ext2fs image file.
- * scan block allocation bitmap, find all blocks used by the ext2fs
- * in this range and create file extents that point to these blocks.
- *
- * Note: Before calling the function, no file extent points to blocks
- * 	 in this range
- */
 static int create_image_file_range(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root, u64 objectid,
-				   struct btrfs_inode_item *inode,
-				   u64 start_byte, u64 end_byte,
-				   struct btrfs_convert_context *cctx, int datacsum)
-{
-	u32 blocksize = cctx->blocksize;
-	u32 block = start_byte / blocksize;
-	u32 last_block = (end_byte + blocksize - 1) / blocksize;
-	int ret = 0;
-	struct blk_iterate_data data;
-
-	init_blk_iterate_data(&data, trans, root, inode, objectid, datacsum);
-	data.first_block = block;
-
-	for (; start_byte < end_byte; block++, start_byte += blocksize) {
-		if (!convert_test_block(cctx, block))
-			continue;
-		ret = block_iterate_proc(block, block, &data);
-		if (ret < 0)
-			goto fail;
-	}
-	if (data.num_blocks > 0) {
-		ret = record_file_blocks(&data, data.first_block,
-					 data.disk_block, data.num_blocks);
-		if (ret)
-			goto fail;
-		data.first_block += data.num_blocks;
-	}
-	if (last_block > data.first_block) {
-		ret = record_file_blocks(&data, data.first_block, 0,
-					 last_block - data.first_block);
-		if (ret)
-			goto fail;
-	}
-fail:
-	return ret;
-}
-
-/*
- * Create the fs image file.
- */
-static int create_image(struct btrfs_convert_context *cctx,
-			struct btrfs_root *root, const char *name, int datacsum)
-{
-	int ret;
-	struct btrfs_key key;
-	struct btrfs_key location;
-	struct btrfs_path path;
-	struct btrfs_inode_item btrfs_inode;
-	struct btrfs_inode_item *inode_item;
-	struct extent_buffer *leaf;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_root *extent_root = fs_info->extent_root;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_extent_item *ei;
-	struct btrfs_extent_inline_ref *iref;
-	struct btrfs_extent_data_ref *dref;
-	u64 bytenr;
-	u64 num_bytes;
-	u64 objectid;
-	u64 last_byte;
-	u64 first_free;
-	u64 total_bytes;
-	u64 flags = BTRFS_INODE_READONLY;
-	u32 sectorsize = root->sectorsize;
-
-	total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
-	first_free =  BTRFS_SUPER_INFO_OFFSET + sectorsize * 2 - 1;
-	first_free &= ~((u64)sectorsize - 1);
-	if (!datacsum)
-		flags |= BTRFS_INODE_NODATASUM;
-
-	memset(&btrfs_inode, 0, sizeof(btrfs_inode));
-	btrfs_set_stack_inode_generation(&btrfs_inode, 1);
-	btrfs_set_stack_inode_size(&btrfs_inode, total_bytes);
-	btrfs_set_stack_inode_nlink(&btrfs_inode, 1);
-	btrfs_set_stack_inode_nbytes(&btrfs_inode, 0);
-	btrfs_set_stack_inode_mode(&btrfs_inode, S_IFREG | 0400);
-	btrfs_set_stack_inode_flags(&btrfs_inode,  flags);
-	btrfs_init_path(&path);
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
-
-	objectid = btrfs_root_dirid(&root->root_item);
-	ret = btrfs_find_free_objectid(trans, root, objectid, &objectid);
-	if (ret)
-		goto fail;
-
-	/*
-	 * copy blocks covered by extent #0 to new positions. extent #0 is
-	 * special, we can't rely on relocate_extents_range to relocate it.
-	 */
-	for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
-		ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
-		if (ret)
-			goto fail;
-		ret = copy_disk_extent(root, key.objectid, last_byte,
-				       sectorsize);
-		if (ret)
-			goto fail;
-		ret = btrfs_record_file_extent(trans, root, objectid,
-					       &btrfs_inode, last_byte,
-					       key.objectid, sectorsize);
-		if (ret)
-			goto fail;
-		if (datacsum) {
-			ret = csum_disk_extent(trans, root, key.objectid,
-					       sectorsize);
-			if (ret)
-				goto fail;
-		}
-	}
-
-	while(1) {
-		key.objectid = last_byte;
-		key.offset = 0;
-		btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-		ret = btrfs_search_slot(trans, fs_info->extent_root,
-					&key, &path, 0, 0);
-		if (ret < 0)
-			goto fail;
-next:
-		leaf = path.nodes[0];
-		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(extent_root, &path);
-			if (ret < 0)
-				goto fail;
-			if (ret > 0)
-				break;
-			leaf = path.nodes[0];
-		}
-		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
-		if (last_byte > key.objectid ||
-		    key.type != BTRFS_EXTENT_ITEM_KEY) {
-			path.slots[0]++;
-			goto next;
-		}
-
-		bytenr = key.objectid;
-		num_bytes = key.offset;
-		ei = btrfs_item_ptr(leaf, path.slots[0],
-				    struct btrfs_extent_item);
-		if (!(btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_DATA)) {
-			path.slots[0]++;
-			goto next;
-		}
-
-		BUG_ON(btrfs_item_size_nr(leaf, path.slots[0]) != sizeof(*ei) +
-		       btrfs_extent_inline_ref_size(BTRFS_EXTENT_DATA_REF_KEY));
-
-		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
-		key.type = btrfs_extent_inline_ref_type(leaf, iref);
-		BUG_ON(key.type != BTRFS_EXTENT_DATA_REF_KEY);
-		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
-		if (btrfs_extent_data_ref_root(leaf, dref) !=
-		    BTRFS_FS_TREE_OBJECTID) {
-			path.slots[0]++;
-			goto next;
-		}
-
-		if (bytenr > last_byte) {
-			ret = create_image_file_range(trans, root, objectid,
-						      &btrfs_inode, last_byte,
-						      bytenr, cctx,
-						      datacsum);
-			if (ret)
-				goto fail;
-		}
-		ret = btrfs_record_file_extent(trans, root, objectid,
-					       &btrfs_inode, bytenr, bytenr,
-					       num_bytes);
-		if (ret)
-			goto fail;
-		last_byte = bytenr + num_bytes;
-		btrfs_release_path(&path);
-
-		if (trans->blocks_used >= 4096) {
-			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
-			trans = btrfs_start_transaction(root, 1);
-			BUG_ON(!trans);
-		}
-	}
-	btrfs_release_path(&path);
-	if (total_bytes > last_byte) {
-		ret = create_image_file_range(trans, root, objectid,
-					      &btrfs_inode, last_byte,
-					      total_bytes, cctx,
-					      datacsum);
-		if (ret)
-			goto fail;
-	}
-
-	ret = btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
-	if (ret)
-		goto fail;
-
-	location.objectid = objectid;
-	location.offset = 0;
-	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
-	ret = btrfs_insert_dir_item(trans, root, name, strlen(name),
-				    btrfs_root_dirid(&root->root_item),
-				    &location, BTRFS_FT_REG_FILE, objectid);
-	if (ret)
-		goto fail;
-	ret = btrfs_insert_inode_ref(trans, root, name, strlen(name),
-				     objectid,
-				     btrfs_root_dirid(&root->root_item),
-				     objectid);
-	if (ret)
-		goto fail;
-	location.objectid = btrfs_root_dirid(&root->root_item);
-	location.offset = 0;
-	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
-	ret = btrfs_lookup_inode(trans, root, &path, &location, 1);
-	if (ret)
-		goto fail;
-	leaf = path.nodes[0];
-	inode_item = btrfs_item_ptr(leaf, path.slots[0],
-				    struct btrfs_inode_item);
-	btrfs_set_inode_size(leaf, inode_item, strlen(name) * 2 +
-			     btrfs_inode_size(leaf, inode_item));
-	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(&path);
-	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
-fail:
-	btrfs_release_path(&path);
-	return ret;
-}
-
-static int create_image_file_range_v2(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      struct cache_tree *used,
 				      struct btrfs_inode_item *inode,
@@ -1890,7 +1424,7 @@ static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
  * This is completely fs independent as we have cctx->used, only
  * need to create file extents point to all the posistions.
  */
-static int create_image_v2(struct btrfs_root *root,
+static int create_image(struct btrfs_root *root,
 			   struct btrfs_mkfs_config *cfg,
 			   struct btrfs_convert_context *cctx, int fd,
 			   u64 size, char *name, int datacsum)
@@ -1957,14 +1491,14 @@ static int create_image_v2(struct btrfs_root *root,
 		goto out;
 
 	/*
-	 * Start from 1M, as 0~1M is reserved, and create_image_file_range_v2()
+	 * Start from 1M, as 0~1M is reserved, and create_image_file_range()
 	 * can't handle bytenr 0(will consider it as a hole)
 	 */
 	cur = 1024 * 1024;
 	while (cur < size) {
 		u64 len = size - cur;
 
-		ret = create_image_file_range_v2(trans, root, &used_tmp,
+		ret = create_image_file_range(trans, root, &used_tmp,
 						&buf, ino, cur, &len, datacsum);
 		if (ret < 0)
 			goto out;
@@ -2094,147 +1628,24 @@ fail:
 	return new_root;
 }
 
-static int create_chunk_mapping(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root)
+static int create_subvol(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root, u64 root_objectid)
 {
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_root *chunk_root = info->chunk_root;
-	struct btrfs_root *extent_root = info->extent_root;
-	struct btrfs_device *device;
-	struct btrfs_block_group_cache *cache;
-	struct btrfs_dev_extent *extent;
-	struct extent_buffer *leaf;
-	struct btrfs_chunk chunk;
+	struct extent_buffer *tmp;
+	struct btrfs_root *new_root;
 	struct btrfs_key key;
-	struct btrfs_path path;
-	u64 cur_start;
-	u64 total_bytes;
-	u64 chunk_objectid;
+	struct btrfs_root_item root_item;
 	int ret;
 
-	btrfs_init_path(&path);
-
-	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
-	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	ret = btrfs_copy_root(trans, root, root->node, &tmp,
+			      root_objectid);
+	BUG_ON(ret);
 
-	BUG_ON(list_empty(&info->fs_devices->devices));
-	device = list_entry(info->fs_devices->devices.next,
-			    struct btrfs_device, dev_list);
-	BUG_ON(device->devid != info->fs_devices->latest_devid);
-
-	/* delete device extent created by make_btrfs */
-	key.objectid = device->devid;
-	key.offset = 0;
-	key.type = BTRFS_DEV_EXTENT_KEY;
-	ret = btrfs_search_slot(trans, device->dev_root, &key, &path, -1, 1);
-	if (ret < 0)
-		goto err;
-
-	BUG_ON(ret > 0);
-	ret = btrfs_del_item(trans, device->dev_root, &path);
-	if (ret)
-		goto err;
-	btrfs_release_path(&path);
-
-	/* delete chunk item created by make_btrfs */
-	key.objectid = chunk_objectid;
-	key.offset = 0;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-	ret = btrfs_search_slot(trans, chunk_root, &key, &path, -1, 1);
-	if (ret < 0)
-		goto err;
-
-	BUG_ON(ret > 0);
-	ret = btrfs_del_item(trans, chunk_root, &path);
-	if (ret)
-		goto err;
-	btrfs_release_path(&path);
-
-	/* for each block group, create device extent and chunk item */
-	cur_start = 0;
-	while (cur_start < total_bytes) {
-		cache = btrfs_lookup_block_group(root->fs_info, cur_start);
-		BUG_ON(!cache);
-
-		/* insert device extent */
-		key.objectid = device->devid;
-		key.offset = cache->key.objectid;
-		key.type = BTRFS_DEV_EXTENT_KEY;
-		ret = btrfs_insert_empty_item(trans, device->dev_root, &path,
-					      &key, sizeof(*extent));
-		if (ret)
-			goto err;
-
-		leaf = path.nodes[0];
-		extent = btrfs_item_ptr(leaf, path.slots[0],
-					struct btrfs_dev_extent);
-
-		btrfs_set_dev_extent_chunk_tree(leaf, extent,
-						chunk_root->root_key.objectid);
-		btrfs_set_dev_extent_chunk_objectid(leaf, extent,
-						    chunk_objectid);
-		btrfs_set_dev_extent_chunk_offset(leaf, extent,
-						  cache->key.objectid);
-		btrfs_set_dev_extent_length(leaf, extent, cache->key.offset);
-		write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
-		    (unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
-		    BTRFS_UUID_SIZE);
-		btrfs_mark_buffer_dirty(leaf);
-		btrfs_release_path(&path);
-
-		/* insert chunk item */
-		btrfs_set_stack_chunk_length(&chunk, cache->key.offset);
-		btrfs_set_stack_chunk_owner(&chunk,
-					    extent_root->root_key.objectid);
-		btrfs_set_stack_chunk_stripe_len(&chunk, BTRFS_STRIPE_LEN);
-		btrfs_set_stack_chunk_type(&chunk, cache->flags);
-		btrfs_set_stack_chunk_io_align(&chunk, device->io_align);
-		btrfs_set_stack_chunk_io_width(&chunk, device->io_width);
-		btrfs_set_stack_chunk_sector_size(&chunk, device->sector_size);
-		btrfs_set_stack_chunk_num_stripes(&chunk, 1);
-		btrfs_set_stack_chunk_sub_stripes(&chunk, 0);
-		btrfs_set_stack_stripe_devid(&chunk.stripe, device->devid);
-		btrfs_set_stack_stripe_offset(&chunk.stripe,
-					      cache->key.objectid);
-		memcpy(&chunk.stripe.dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-
-		key.objectid = chunk_objectid;
-		key.offset = cache->key.objectid;
-		key.type = BTRFS_CHUNK_ITEM_KEY;
-
-		ret = btrfs_insert_item(trans, chunk_root, &key, &chunk,
-					btrfs_chunk_item_size(1));
-		if (ret)
-			goto err;
-
-		cur_start = cache->key.objectid + cache->key.offset;
-	}
-
-	device->bytes_used = total_bytes;
-	ret = btrfs_update_device(trans, device);
-err:
-	btrfs_release_path(&path);
-	return ret;
-}
-
-static int create_subvol(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root, u64 root_objectid)
-{
-	struct extent_buffer *tmp;
-	struct btrfs_root *new_root;
-	struct btrfs_key key;
-	struct btrfs_root_item root_item;
-	int ret;
-
-	ret = btrfs_copy_root(trans, root, root->node, &tmp,
-			      root_objectid);
-	BUG_ON(ret);
-
-	memcpy(&root_item, &root->root_item, sizeof(root_item));
-	btrfs_set_root_bytenr(&root_item, tmp->start);
-	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
-	btrfs_set_root_generation(&root_item, trans->transid);
-	free_extent_buffer(tmp);
+	memcpy(&root_item, &root->root_item, sizeof(root_item));
+	btrfs_set_root_bytenr(&root_item, tmp->start);
+	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	btrfs_set_root_generation(&root_item, trans->transid);
+	free_extent_buffer(tmp);
 
 	key.objectid = root_objectid;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -2253,7 +1664,7 @@ static int create_subvol(struct btrfs_trans_handle *trans,
 }
 
 /*
- * New make_btrfs_v2() has handle system and meta chunks quite well.
+ * New make_btrfs() has handle system and meta chunks quite well.
  * So only need to add remaining data chunks.
  */
 static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
@@ -2313,7 +1724,7 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
  * (XXX: Not need again?)
  * But the convert image subvolume is *NOT* linked to fs tree yet.
  */
-static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
+static int init_btrfs(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
 			 struct btrfs_convert_context *cctx, int datacsum,
 			 int packing, int noxattr)
 {
@@ -2372,63 +1783,6 @@ err:
 	return ret;
 }
 
-static int init_btrfs(struct btrfs_root *root)
-{
-	int ret;
-	struct btrfs_key location;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct extent_buffer *tmp;
-
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
-	ret = btrfs_make_block_groups(trans, root);
-	if (ret)
-		goto err;
-	ret = btrfs_fix_block_accounting(trans, root);
-	if (ret)
-		goto err;
-	ret = create_chunk_mapping(trans, root);
-	if (ret)
-		goto err;
-	ret = btrfs_make_root_dir(trans, fs_info->tree_root,
-				  BTRFS_ROOT_TREE_DIR_OBJECTID);
-	if (ret)
-		goto err;
-	memcpy(&location, &root->root_key, sizeof(location));
-	location.offset = (u64)-1;
-	ret = btrfs_insert_dir_item(trans, fs_info->tree_root, "default", 7,
-				btrfs_super_root_dir(fs_info->super_copy),
-				&location, BTRFS_FT_DIR, 0);
-	if (ret)
-		goto err;
-	ret = btrfs_insert_inode_ref(trans, fs_info->tree_root, "default", 7,
-				location.objectid,
-				btrfs_super_root_dir(fs_info->super_copy), 0);
-	if (ret)
-		goto err;
-	btrfs_set_root_dirid(&fs_info->fs_root->root_item,
-			     BTRFS_FIRST_FREE_OBJECTID);
-
-	/* subvol for fs image file */
-	ret = create_subvol(trans, root, CONV_IMAGE_SUBVOL_OBJECTID);
-	BUG_ON(ret);
-	/* subvol for data relocation */
-	ret = create_subvol(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
-	BUG_ON(ret);
-
-	extent_buffer_get(fs_info->csum_root->node);
-	ret = __btrfs_cow_block(trans, fs_info->csum_root,
-				fs_info->csum_root->node, NULL, 0, &tmp, 0, 0);
-	BUG_ON(ret);
-	free_extent_buffer(tmp);
-
-	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
-err:
-	return ret;
-}
-
 /*
  * Migrate super block to its default position and zero 0 ~ 16k
  */
@@ -2471,515 +1825,54 @@ static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
 		ret = pwrite(fd, buf->data, len, bytenr);
 		if (ret != len) {
 			fprintf(stderr, "unable to zero fill device\n");
-			break;
-		}
-		bytenr += len;
-	}
-	ret = 0;
-	fsync(fd);
-fail:
-	free(buf);
-	if (ret > 0)
-		ret = -1;
-	return ret;
-}
-
-static int prepare_system_chunk_sb(struct btrfs_super_block *super)
-{
-	struct btrfs_chunk *chunk;
-	struct btrfs_disk_key *key;
-	u32 sectorsize = btrfs_super_sectorsize(super);
-
-	key = (struct btrfs_disk_key *)(super->sys_chunk_array);
-	chunk = (struct btrfs_chunk *)(super->sys_chunk_array +
-				       sizeof(struct btrfs_disk_key));
-
-	btrfs_set_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-	btrfs_set_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
-	btrfs_set_disk_key_offset(key, 0);
-
-	btrfs_set_stack_chunk_length(chunk, btrfs_super_total_bytes(super));
-	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
-	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
-	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
-	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
-	btrfs_set_stack_chunk_sector_size(chunk, sectorsize);
-	btrfs_set_stack_chunk_num_stripes(chunk, 1);
-	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
-	chunk->stripe.devid = super->dev_item.devid;
-	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
-	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
-	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
-	return 0;
-}
-
-static int prepare_system_chunk(int fd, u64 sb_bytenr)
-{
-	int ret;
-	struct extent_buffer *buf;
-	struct btrfs_super_block *super;
-
-	BUG_ON(BTRFS_SUPER_INFO_SIZE < sizeof(*super));
-	buf = malloc(sizeof(*buf) + BTRFS_SUPER_INFO_SIZE);
-	if (!buf)
-		return -ENOMEM;
-
-	buf->len = BTRFS_SUPER_INFO_SIZE;
-	ret = pread(fd, buf->data, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
-	if (ret != BTRFS_SUPER_INFO_SIZE)
-		goto fail;
-
-	super = (struct btrfs_super_block *)buf->data;
-	BUG_ON(btrfs_super_bytenr(super) != sb_bytenr);
-	BUG_ON(btrfs_super_num_devices(super) != 1);
-
-	ret = prepare_system_chunk_sb(super);
-	if (ret)
-		goto fail;
-
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
-	if (ret != BTRFS_SUPER_INFO_SIZE)
-		goto fail;
-
-	ret = 0;
-fail:
-	free(buf);
-	if (ret > 0)
-		ret = -1;
-	return ret;
-}
-
-static int relocate_one_reference(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  u64 extent_start, u64 extent_size,
-				  struct btrfs_key *extent_key,
-				  struct extent_io_tree *reloc_tree)
-{
-	struct extent_buffer *leaf;
-	struct btrfs_file_extent_item *fi;
-	struct btrfs_key key;
-	struct btrfs_path path;
-	struct btrfs_inode_item inode;
-	struct blk_iterate_data data;
-	u64 bytenr;
-	u64 num_bytes;
-	u64 cur_offset;
-	u64 new_pos;
-	u64 nbytes;
-	u64 sector_end;
-	u32 sectorsize = root->sectorsize;
-	unsigned long ptr;
-	int datacsum;
-	int fd;
-	int ret;
-
-	btrfs_init_path(&path);
-	ret = btrfs_search_slot(trans, root, extent_key, &path, -1, 1);
-	if (ret)
-		goto fail;
-
-	leaf = path.nodes[0];
-	fi = btrfs_item_ptr(leaf, path.slots[0],
-			    struct btrfs_file_extent_item);
-	BUG_ON(btrfs_file_extent_offset(leaf, fi) > 0);
-	if (extent_start != btrfs_file_extent_disk_bytenr(leaf, fi) ||
-	    extent_size != btrfs_file_extent_disk_num_bytes(leaf, fi)) {
-		ret = 1;
-		goto fail;
-	}
-
-	bytenr = extent_start + btrfs_file_extent_offset(leaf, fi);
-	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
-
-	ret = btrfs_del_item(trans, root, &path);
-	if (ret)
-		goto fail;
-
-	ret = btrfs_free_extent(trans, root, extent_start, extent_size, 0,
-				root->root_key.objectid,
-				extent_key->objectid, extent_key->offset);
-	if (ret)
-		goto fail;
-
-	btrfs_release_path(&path);
-
-	key.objectid = extent_key->objectid;
-	key.offset = 0;
-	key.type =  BTRFS_INODE_ITEM_KEY;
-	ret = btrfs_lookup_inode(trans, root, &path, &key, 0);
-	if (ret)
-		goto fail;
-
-	leaf = path.nodes[0];
-	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
-	read_extent_buffer(leaf, &inode, ptr, sizeof(inode));
-	btrfs_release_path(&path);
-
-	BUG_ON(num_bytes & (sectorsize - 1));
-	nbytes = btrfs_stack_inode_nbytes(&inode) - num_bytes;
-	btrfs_set_stack_inode_nbytes(&inode, nbytes);
-	datacsum = !(btrfs_stack_inode_flags(&inode) & BTRFS_INODE_NODATASUM);
-
-	init_blk_iterate_data(&data, trans, root, &inode, extent_key->objectid,
-			      datacsum);
-	data.first_block = extent_key->offset;
-
-	cur_offset = extent_key->offset;
-	while (num_bytes > 0) {
-		sector_end = bytenr + sectorsize - 1;
-		if (test_range_bit(reloc_tree, bytenr, sector_end,
-				   EXTENT_LOCKED, 1)) {
-			ret = get_state_private(reloc_tree, bytenr, &new_pos);
-			BUG_ON(ret);
-		} else {
-			ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
-			if (ret)
-				goto fail;
-			new_pos = key.objectid;
-
-			if (cur_offset == extent_key->offset) {
-				fd = root->fs_info->fs_devices->latest_bdev;
-				readahead(fd, bytenr, num_bytes);
-			}
-			ret = copy_disk_extent(root, new_pos, bytenr,
-					       sectorsize);
-			if (ret)
-				goto fail;
-			ret = set_extent_bits(reloc_tree, bytenr, sector_end,
-					      EXTENT_LOCKED, GFP_NOFS);
-			BUG_ON(ret);
-			ret = set_state_private(reloc_tree, bytenr, new_pos);
-			BUG_ON(ret);
-		}
-
-		ret = block_iterate_proc(new_pos / sectorsize,
-					 cur_offset / sectorsize, &data);
-		if (ret < 0)
-			goto fail;
-
-		cur_offset += sectorsize;
-		bytenr += sectorsize;
-		num_bytes -= sectorsize;
-	}
-
-	if (data.num_blocks > 0) {
-		ret = record_file_blocks(&data, data.first_block,
-					 data.disk_block, data.num_blocks);
-		if (ret)
-			goto fail;
-	}
-
-	key.objectid = extent_key->objectid;
-	key.offset = 0;
-	key.type =  BTRFS_INODE_ITEM_KEY;
-	ret = btrfs_lookup_inode(trans, root, &path, &key, 1);
-	if (ret)
-		goto fail;
-
-	leaf = path.nodes[0];
-	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
-	write_extent_buffer(leaf, &inode, ptr, sizeof(inode));
-	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(&path);
-
-fail:
-	btrfs_release_path(&path);
-	return ret;
-}
-
-static int relocate_extents_range(struct btrfs_root *fs_root,
-				  struct btrfs_root *image_root,
-				  u64 start_byte, u64 end_byte)
-{
-	struct btrfs_fs_info *info = fs_root->fs_info;
-	struct btrfs_root *extent_root = info->extent_root;
-	struct btrfs_root *cur_root = NULL;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_extent_data_ref *dref;
-	struct btrfs_extent_inline_ref *iref;
-	struct btrfs_extent_item *ei;
-	struct extent_buffer *leaf;
-	struct btrfs_key key;
-	struct btrfs_key extent_key;
-	struct btrfs_path path;
-	struct extent_io_tree reloc_tree;
-	unsigned long ptr;
-	unsigned long end;
-	u64 cur_byte;
-	u64 num_bytes;
-	u64 ref_root;
-	u64 num_extents;
-	int pass = 0;
-	int ret;
-
-	btrfs_init_path(&path);
-	extent_io_tree_init(&reloc_tree);
-
-	key.objectid = start_byte;
-	key.offset = 0;
-	key.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
-	if (ret < 0)
-		goto fail;
-	if (ret > 0) {
-		ret = btrfs_previous_item(extent_root, &path, 0,
-					  BTRFS_EXTENT_ITEM_KEY);
-		if (ret < 0)
-			goto fail;
-		if (ret == 0) {
-			leaf = path.nodes[0];
-			btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
-			if (key.objectid + key.offset > start_byte)
-				start_byte = key.objectid;
-		}
-	}
-	btrfs_release_path(&path);
-again:
-	cur_root = (pass % 2 == 0) ? image_root : fs_root;
-	num_extents = 0;
-
-	trans = btrfs_start_transaction(cur_root, 1);
-	BUG_ON(!trans);
-
-	cur_byte = start_byte;
-	while (1) {
-		key.objectid = cur_byte;
-		key.offset = 0;
-		key.type = BTRFS_EXTENT_ITEM_KEY;
-		ret = btrfs_search_slot(trans, extent_root,
-					&key, &path, 0, 0);
-		if (ret < 0)
-			goto fail;
-next:
-		leaf = path.nodes[0];
-		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(extent_root, &path);
-			if (ret < 0)
-				goto fail;
-			if (ret > 0)
-				break;
-			leaf = path.nodes[0];
-		}
-
-		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
-		if (key.objectid < cur_byte ||
-		    key.type != BTRFS_EXTENT_ITEM_KEY) {
-			path.slots[0]++;
-			goto next;
-		}
-		if (key.objectid >= end_byte)
-			break;
-
-		num_extents++;
-
-		cur_byte = key.objectid;
-		num_bytes = key.offset;
-		ei = btrfs_item_ptr(leaf, path.slots[0],
-				    struct btrfs_extent_item);
-		BUG_ON(!(btrfs_extent_flags(leaf, ei) &
-			 BTRFS_EXTENT_FLAG_DATA));
-
-		ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
-		end = ptr + btrfs_item_size_nr(leaf, path.slots[0]);
-
-		ptr += sizeof(struct btrfs_extent_item);
-
-		while (ptr < end) {
-			iref = (struct btrfs_extent_inline_ref *)ptr;
-			key.type = btrfs_extent_inline_ref_type(leaf, iref);
-			BUG_ON(key.type != BTRFS_EXTENT_DATA_REF_KEY);
-			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
-			ref_root = btrfs_extent_data_ref_root(leaf, dref);
-			extent_key.objectid =
-				btrfs_extent_data_ref_objectid(leaf, dref);
-			extent_key.offset =
-				btrfs_extent_data_ref_offset(leaf, dref);
-			extent_key.type = BTRFS_EXTENT_DATA_KEY;
-			BUG_ON(btrfs_extent_data_ref_count(leaf, dref) != 1);
-
-			if (ref_root == cur_root->root_key.objectid)
-				break;
-
-			ptr += btrfs_extent_inline_ref_size(key.type);
-		}
-
-		if (ptr >= end) {
-			path.slots[0]++;
-			goto next;
-		}
-
-		ret = relocate_one_reference(trans, cur_root, cur_byte,
-					     num_bytes, &extent_key,
-					     &reloc_tree);
-		if (ret < 0)
-			goto fail;
-
-		cur_byte += num_bytes;
-		btrfs_release_path(&path);
-
-		if (trans->blocks_used >= 4096) {
-			ret = btrfs_commit_transaction(trans, cur_root);
-			BUG_ON(ret);
-			trans = btrfs_start_transaction(cur_root, 1);
-			BUG_ON(!trans);
-		}
-	}
-	btrfs_release_path(&path);
-
-	ret = btrfs_commit_transaction(trans, cur_root);
-	BUG_ON(ret);
-
-	if (num_extents > 0 && pass++ < 16)
-		goto again;
-
-	ret = (num_extents > 0) ? -1 : 0;
-fail:
-	btrfs_release_path(&path);
-	extent_io_tree_cleanup(&reloc_tree);
-	return ret;
-}
-
-/*
- * relocate data in system chunk
- */
-static int cleanup_sys_chunk(struct btrfs_root *fs_root,
-			     struct btrfs_root *image_root)
-{
-	struct btrfs_block_group_cache *cache;
-	int i, ret = 0;
-	u64 offset = 0;
-	u64 end_byte;
-
-	while(1) {
-		cache = btrfs_lookup_block_group(fs_root->fs_info, offset);
-		if (!cache)
-			break;
-
-		end_byte = cache->key.objectid + cache->key.offset;
-		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-			ret = relocate_extents_range(fs_root, image_root,
-						     cache->key.objectid,
-						     end_byte);
-			if (ret)
-				goto fail;
+			break;
 		}
-		offset = end_byte;
-	}
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		offset = btrfs_sb_offset(i);
-		offset &= ~((u64)BTRFS_STRIPE_LEN - 1);
-
-		ret = relocate_extents_range(fs_root, image_root,
-					     offset, offset + BTRFS_STRIPE_LEN);
-		if (ret)
-			goto fail;
+		bytenr += len;
 	}
 	ret = 0;
+	fsync(fd);
 fail:
+	free(buf);
+	if (ret > 0)
+		ret = -1;
 	return ret;
 }
 
-static int fixup_chunk_mapping(struct btrfs_root *root)
+static int prepare_system_chunk_sb(struct btrfs_super_block *super)
 {
-	struct btrfs_trans_handle *trans;
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_root *chunk_root = info->chunk_root;
-	struct extent_buffer *leaf;
-	struct btrfs_key key;
-	struct btrfs_path path;
-	struct btrfs_chunk chunk;
-	unsigned long ptr;
-	u32 size;
-	u64 type;
-	int ret;
-
-	btrfs_init_path(&path);
-
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
-
-	/*
-	 * recow the whole chunk tree. this will move all chunk tree blocks
-	 * into system block group.
-	 */
-	memset(&key, 0, sizeof(key));
-	while (1) {
-		ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
-		if (ret < 0)
-			goto err;
-
-		ret = btrfs_next_leaf(chunk_root, &path);
-		if (ret < 0)
-			goto err;
-		if (ret > 0)
-			break;
-
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		btrfs_release_path(&path);
-	}
-	btrfs_release_path(&path);
-
-	/* fixup the system chunk array in super block */
-	btrfs_set_super_sys_array_size(info->super_copy, 0);
-
-	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	key.offset = 0;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-
-	ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 0);
-	if (ret < 0)
-		goto err;
-	BUG_ON(ret != 0);
-	while(1) {
-		leaf = path.nodes[0];
-		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(chunk_root, &path);
-			if (ret < 0)
-				goto err;
-			if (ret > 0)
-				break;
-			leaf = path.nodes[0];
-		}
-		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
-		if (key.type != BTRFS_CHUNK_ITEM_KEY)
-			goto next;
-
-		ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
-		size = btrfs_item_size_nr(leaf, path.slots[0]);
-		BUG_ON(size != sizeof(chunk));
-		read_extent_buffer(leaf, &chunk, ptr, size);
-		type = btrfs_stack_chunk_type(&chunk);
+	struct btrfs_chunk *chunk;
+	struct btrfs_disk_key *key;
+	u32 sectorsize = btrfs_super_sectorsize(super);
 
-		if (!(type & BTRFS_BLOCK_GROUP_SYSTEM))
-			goto next;
+	key = (struct btrfs_disk_key *)(super->sys_chunk_array);
+	chunk = (struct btrfs_chunk *)(super->sys_chunk_array +
+				       sizeof(struct btrfs_disk_key));
 
-		ret = btrfs_add_system_chunk(trans, chunk_root, &key,
-					     &chunk, size);
-		if (ret)
-			goto err;
-next:
-		path.slots[0]++;
-	}
+	btrfs_set_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
+	btrfs_set_disk_key_offset(key, 0);
 
-	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
-err:
-	btrfs_release_path(&path);
-	return ret;
+	btrfs_set_stack_chunk_length(chunk, btrfs_super_total_bytes(super));
+	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
+	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
+	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
+	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
+	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
+	btrfs_set_stack_chunk_sector_size(chunk, sectorsize);
+	btrfs_set_stack_chunk_num_stripes(chunk, 1);
+	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
+	chunk->stripe.devid = super->dev_item.devid;
+	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
+	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
+	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
+	return 0;
 }
 
 static const struct btrfs_convert_operations ext2_convert_ops = {
 	.name			= "ext2",
 	.open_fs		= ext2_open_fs,
 	.read_used_space	= ext2_read_used_space,
-	.alloc_block		= ext2_alloc_block,
-	.alloc_block_range	= ext2_alloc_block_range,
 	.copy_inodes		= ext2_copy_inodes,
-	.test_block		= ext2_test_block,
-	.free_block		= ext2_free_block,
-	.free_block_range	= ext2_free_block_range,
 	.close_fs		= ext2_close_fs,
 };
 
@@ -3220,7 +2113,7 @@ static int convert_read_used_space(struct btrfs_convert_context *cctx)
 	return ret;
 }
 
-static int do_convert_v2(const char *devname, int datacsum, int packing,
+static int do_convert(const char *devname, int datacsum, int packing,
 		int noxattr, u32 nodesize, int copylabel, const char *fslabel,
 		int progress, u64 features)
 {
@@ -3293,7 +2186,7 @@ static int do_convert_v2(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
 	}
-	ret = init_btrfs_v2(&mkfs_cfg, root, &cctx, datacsum, packing, noxattr);
+	ret = init_btrfs(&mkfs_cfg, root, &cctx, datacsum, packing, noxattr);
 	if (ret) {
 		fprintf(stderr, "unable to setup the root tree\n");
 		goto fail;
@@ -3314,7 +2207,7 @@ static int do_convert_v2(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "unable to create subvol\n");
 		goto fail;
 	}
-	ret = create_image_v2(image_root, &mkfs_cfg, &cctx, fd,
+	ret = create_image(image_root, &mkfs_cfg, &cctx, fd,
 			      mkfs_cfg.num_bytes, "image", datacsum);
 	if (ret) {
 		fprintf(stderr, "error during create_image %d\n", ret);
@@ -3395,220 +2288,6 @@ fail:
 	return -1;
 }
 
-static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
-		u32 nodesize, int copylabel, const char *fslabel, int progress,
-		u64 features)
-{
-	int i, ret, blocks_per_node;
-	int fd = -1;
-	int is_btrfs = 0;
-	u32 blocksize;
-	u64 blocks[7];
-	u64 total_bytes;
-	u64 super_bytenr;
-	struct btrfs_root *root;
-	struct btrfs_root *image_root;
-	struct btrfs_convert_context cctx;
-	char *subvol_name = NULL;
-	struct task_ctx ctx;
-	char features_buf[64];
-	struct btrfs_mkfs_config mkfs_cfg;
-
-	init_convert_context(&cctx);
-	ret = convert_open_fs(devname, &cctx);
-	if (ret)
-		goto fail;
-	ret = convert_read_used_space(&cctx);
-	if (ret)
-		goto fail;
-
-	blocksize = cctx.blocksize;
-	total_bytes = (u64)blocksize * (u64)cctx.block_count;
-	if (blocksize < 4096) {
-		fprintf(stderr, "block size is too small\n");
-		goto fail;
-	}
-	if (btrfs_check_nodesize(nodesize, blocksize, features))
-		goto fail;
-	blocks_per_node = nodesize / blocksize;
-	ret = -blocks_per_node;
-	for (i = 0; i < 7; i++) {
-		if (nodesize == blocksize)
-			ret = convert_alloc_block(&cctx, 0, blocks + i);
-		else
-			ret = convert_alloc_block_range(&cctx,
-					ret + blocks_per_node, blocks_per_node,
-					blocks + i);
-		if (ret) {
-			fprintf(stderr, "not enough free space\n");
-			goto fail;
-		}
-		blocks[i] *= blocksize;
-	}
-	super_bytenr = blocks[0];
-	fd = open(devname, O_RDWR);
-	if (fd < 0) {
-		fprintf(stderr, "unable to open %s\n", devname);
-		goto fail;
-	}
-	btrfs_parse_features_to_string(features_buf, features);
-	if (features == BTRFS_MKFS_DEFAULT_FEATURES)
-		strcat(features_buf, " (default)");
-
-	printf("create btrfs filesystem:\n");
-	printf("\tblocksize: %u\n", blocksize);
-	printf("\tnodesize:  %u\n", nodesize);
-	printf("\tfeatures:  %s\n", features_buf);
-
-	mkfs_cfg.label = cctx.volume_name;
-	mkfs_cfg.fs_uuid = NULL;
-	memcpy(mkfs_cfg.blocks, blocks, sizeof(blocks));
-	mkfs_cfg.num_bytes = total_bytes;
-	mkfs_cfg.nodesize = nodesize;
-	mkfs_cfg.sectorsize = blocksize;
-	mkfs_cfg.stripesize = blocksize;
-	mkfs_cfg.features = features;
-
-	ret = make_btrfs(fd, &mkfs_cfg, NULL);
-	if (ret) {
-		fprintf(stderr, "unable to create initial ctree: %s\n",
-			strerror(-ret));
-		goto fail;
-	}
-	/* create a system chunk that maps the whole device */
-	ret = prepare_system_chunk(fd, super_bytenr);
-	if (ret) {
-		fprintf(stderr, "unable to update system chunk\n");
-		goto fail;
-	}
-	root = open_ctree_fd(fd, devname, super_bytenr, OPEN_CTREE_WRITES);
-	if (!root) {
-		fprintf(stderr, "unable to open ctree\n");
-		goto fail;
-	}
-	ret = cache_free_extents(root, &cctx);
-	if (ret) {
-		fprintf(stderr, "error during cache_free_extents %d\n", ret);
-		goto fail;
-	}
-	root->fs_info->extent_ops = &extent_ops;
-	/* recover block allocation bitmap */
-	for (i = 0; i < 7; i++) {
-		blocks[i] /= blocksize;
-		if (nodesize == blocksize)
-			convert_free_block(&cctx, blocks[i]);
-		else
-			convert_free_block_range(&cctx, blocks[i],
-					blocks_per_node);
-	}
-	ret = init_btrfs(root);
-	if (ret) {
-		fprintf(stderr, "unable to setup the root tree\n");
-		goto fail;
-	}
-	printf("creating btrfs metadata.\n");
-	ctx.max_copy_inodes = (cctx.inodes_count - cctx.free_inodes_count);
-	ctx.cur_copy_inodes = 0;
-
-	if (progress) {
-		ctx.info = task_init(print_copied_inodes, after_copied_inodes, &ctx);
-		task_start(ctx.info);
-	}
-	ret = copy_inodes(&cctx, root, datacsum, packing, noxattr, &ctx);
-	if (ret) {
-		fprintf(stderr, "error during copy_inodes %d\n", ret);
-		goto fail;
-	}
-	if (progress) {
-		task_stop(ctx.info);
-		task_deinit(ctx.info);
-	}
-
-	printf("creating %s image file.\n", cctx.convert_ops->name);
-	ret = asprintf(&subvol_name, "%s_saved", cctx.convert_ops->name);
-	if (ret < 0) {
-		fprintf(stderr, "error allocating subvolume name: %s_saved\n",
-			cctx.convert_ops->name);
-		goto fail;
-	}
-
-	image_root = link_subvol(root, subvol_name, CONV_IMAGE_SUBVOL_OBJECTID);
-
-	free(subvol_name);
-
-	if (!image_root) {
-		fprintf(stderr, "unable to create subvol\n");
-		goto fail;
-	}
-	ret = create_image(&cctx, image_root, "image", datacsum);
-	if (ret) {
-		fprintf(stderr, "error during create_image %d\n", ret);
-		goto fail;
-	}
-	memset(root->fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
-	if (copylabel == 1) {
-		strncpy(root->fs_info->super_copy->label,
-				cctx.volume_name, BTRFS_LABEL_SIZE);
-		fprintf(stderr, "copy label '%s'\n",
-				root->fs_info->super_copy->label);
-	} else if (copylabel == -1) {
-		strcpy(root->fs_info->super_copy->label, fslabel);
-		fprintf(stderr, "set label to '%s'\n", fslabel);
-	}
-
-	printf("cleaning up system chunk.\n");
-	ret = cleanup_sys_chunk(root, image_root);
-	if (ret) {
-		fprintf(stderr, "error during cleanup_sys_chunk %d\n", ret);
-		goto fail;
-	}
-	ret = close_ctree(root);
-	if (ret) {
-		fprintf(stderr, "error during close_ctree %d\n", ret);
-		goto fail;
-	}
-	convert_close_fs(&cctx);
-	clean_convert_context(&cctx);
-
-	/*
-	 * If this step succeed, we get a mountable btrfs. Otherwise
-	 * the source fs is left unchanged.
-	 */
-	ret = migrate_super_block(fd, super_bytenr, blocksize);
-	if (ret) {
-		fprintf(stderr, "unable to migrate super block\n");
-		goto fail;
-	}
-	is_btrfs = 1;
-
-	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
-	if (!root) {
-		fprintf(stderr, "unable to open ctree\n");
-		goto fail;
-	}
-	/* move chunk tree into system chunk. */
-	ret = fixup_chunk_mapping(root);
-	if (ret) {
-		fprintf(stderr, "error during fixup_chunk_tree\n");
-		goto fail;
-	}
-	ret = close_ctree(root);
-	close(fd);
-
-	printf("conversion complete.\n");
-	return 0;
-fail:
-	clean_convert_context(&cctx);
-	if (fd != -1)
-		close(fd);
-	if (is_btrfs)
-		fprintf(stderr,
-			"WARNING: an error occured during chunk mapping fixup, filesystem mountable but not finalized\n");
-	else
-		fprintf(stderr, "conversion aborted\n");
-	return -1;
-}
-
 static int may_rollback(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *info = root->fs_info;
@@ -4153,7 +2832,7 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file);
 	} else {
-		ret = do_convert_v2(file, datacsum, packing, noxattr, nodesize,
+		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
 				copylabel, fslabel, progress, features);
 	}
 	if (ret)
diff --git a/ctree.h b/ctree.h
index 10038be..2c1bba2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -945,13 +945,6 @@ struct btrfs_block_group_cache {
 	int ro;
 };
 
-struct btrfs_extent_ops {
-       int (*alloc_extent)(struct btrfs_root *root, u64 num_bytes,
-			   u64 hint_byte, struct btrfs_key *ins, int metadata);
-       int (*free_extent)(struct btrfs_root *root, u64 bytenr,
-		          u64 num_bytes);
-};
-
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
@@ -1001,7 +994,6 @@ struct btrfs_fs_info {
 	u64 super_bytenr;
 	u64 total_pinned;
 
-	struct btrfs_extent_ops *extent_ops;
 	struct list_head dirty_cowonly_roots;
 	struct list_head recow_ebs;
 
diff --git a/extent-tree.c b/extent-tree.c
index 2883785..cc68c96 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2181,7 +2181,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 
 	struct btrfs_key key;
 	struct btrfs_path *path;
-	struct btrfs_extent_ops *ops = root->fs_info->extent_ops;
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
@@ -2382,14 +2381,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			}
 		}
 
-		if (ops && ops->free_extent) {
-			ret = ops->free_extent(root, bytenr, num_bytes);
-			if (ret > 0) {
-				pin = 0;
-				mark_free = 0;
-			}
-		}
-
 		if (pin) {
 			ret = pin_down_bytes(trans, root, bytenr, num_bytes,
 					     is_data);
@@ -2662,13 +2653,6 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	u64 alloc_profile;
 	struct btrfs_fs_info *info = root->fs_info;
 
-	if (info->extent_ops) {
-		struct btrfs_extent_ops *ops = info->extent_ops;
-		ret = ops->alloc_extent(root, num_bytes, hint_byte, ins, !data);
-		BUG_ON(ret);
-		goto found;
-	}
-
 	if (data) {
 		alloc_profile = info->avail_data_alloc_bits &
 			        info->data_alloc_profile;
@@ -2702,7 +2686,6 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			       trans->alloc_exclude_start,
 			       trans->alloc_exclude_nr, data);
 	BUG_ON(ret);
-found:
 	clear_extent_dirty(&root->fs_info->free_space_cache,
 			   ins->objectid, ins->objectid + ins->offset - 1,
 			   GFP_NOFS);
-- 
2.6.2



