Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161932AbbKTD10 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:27:26 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdY022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:26:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 25/25] btrfs-progs: Cleanup old btrfs-convert
Date: Fri, 20 Nov 2015 11:24:29 +0800
Message-Id: <1447989869-24739-26-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup all the old btrfs-convert facilities, including old
init_btrfs(), create_file_image_range() and custom extent allocation
function.

The cleanup only focus on btrfs-convert, no make_btrfs() cleanup yet.
It will be delayed until I found a nice and clean way to rework
make_btrfs() to support RAID5/6 chunk at temporary btrfs creation time.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 1548 +++++--------------------------------------------------
 ctree.h         |    8 -
 extent-tree.c   |   17 -
 3 files changed, 142 insertions(+), 1431 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a81345d..261c9f7 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -126,145 +126,6 @@ static int close_ext2fs(ext2_filsys fs)
 	return 0;
 }
 
-static int ext2_alloc_block(ext2_filsys fs, u64 goal, u64 *block_ret)
-{
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
-static int ext2_alloc_block_range(ext2_filsys fs, u64 goal, int num,
-		u64 *block_ret)
-{
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
-static int ext2_free_block(ext2_filsys fs, u64 block)
-{
-	BUG_ON(block != (blk_t)block);
-	ext2fs_fast_unmark_block_bitmap(fs->block_map, block);
-	return 0;
-}
-
-static int ext2_free_block_range(ext2_filsys fs, u64 block, int num)
-{
-	BUG_ON(block != (blk_t)block);
-	ext2fs_fast_unmark_block_bitmap_range(fs->block_map, block, num);
-	return 0;
-}
-
-static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
-
-{
-	int i, ret = 0;
-	blk_t block;
-	u64 bytenr;
-	u64 blocksize = ext2_fs->blocksize;
-
-	block = ext2_fs->super->s_first_data_block;
-	for (; block < ext2_fs->super->s_blocks_count; block++) {
-		if (ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block))
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
-		if (bytenr >= blocksize * ext2_fs->super->s_blocks_count)
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
 
 static int intersect_with_sb(u64 bytenr, u64 num_bytes)
 {
@@ -282,17 +143,6 @@ static int intersect_with_sb(u64 bytenr, u64 num_bytes)
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
@@ -1190,29 +1040,6 @@ static int copy_single_inode(struct btrfs_trans_handle *trans,
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
@@ -1271,247 +1098,7 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 	return ret;
 }
 
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
-				   ext2_filsys ext2_fs, int datacsum)
-{
-	u32 blocksize = ext2_fs->blocksize;
-	u32 block = start_byte / blocksize;
-	u32 last_block = (end_byte + blocksize - 1) / blocksize;
-	int ret = 0;
-	struct blk_iterate_data data;
-
-	init_blk_iterate_data(&data, trans, root, inode, objectid, datacsum);
-	data.first_block = block;
-
-	for (; start_byte < end_byte; block++, start_byte += blocksize) {
-		if (!ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block))
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
- * Create the ext2fs image file.
- */
-static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
-			     const char *name, int datacsum)
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
-						      bytenr, ext2_fs,
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
-					      total_bytes, ext2_fs,
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
@@ -1699,9 +1286,9 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int create_ext2_image_v2(struct btrfs_root *root,
-				struct btrfs_mkfs_config *cfg, int fd, u64 size,
-				char *name, int datacsum)
+static int create_ext2_image(struct btrfs_root *root,
+			     struct btrfs_mkfs_config *cfg, int fd, u64 size,
+			     char *name, int datacsum)
 {
 	struct btrfs_inode_item buf;
 	struct btrfs_trans_handle *trans;
@@ -1754,7 +1341,7 @@ static int create_ext2_image_v2(struct btrfs_root *root,
 	while (cur < size) {
 		u64 len = size - cur;
 
-		ret = create_image_file_range_v2(trans, root,
+		ret = create_image_file_range(trans, root,
 				&cfg->convert_used, &buf, ino, cur, &len,
 				datacsum);
 		if (ret < 0)
@@ -1886,163 +1473,40 @@ fail:
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
+	memcpy(&root_item, &root->root_item, sizeof(root_item));
+	btrfs_set_root_bytenr(&root_item, tmp->start);
+	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	btrfs_set_root_generation(&root_item, trans->transid);
+	free_extent_buffer(tmp);
 
-	/* delete device extent created by make_btrfs */
-	key.objectid = device->devid;
-	key.offset = 0;
-	key.type = BTRFS_DEV_EXTENT_KEY;
-	ret = btrfs_search_slot(trans, device->dev_root, &key, &path, -1, 1);
-	if (ret < 0)
-		goto err;
+	key.objectid = root_objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = trans->transid;
+	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
+				&key, &root_item);
 
-	BUG_ON(ret > 0);
-	ret = btrfs_del_item(trans, device->dev_root, &path);
-	if (ret)
-		goto err;
-	btrfs_release_path(&path);
+	key.offset = (u64)-1;
+	new_root = btrfs_read_fs_root(root->fs_info, &key);
+	BUG_ON(!new_root || IS_ERR(new_root));
 
-	/* delete chunk item created by make_btrfs */
-	key.objectid = chunk_objectid;
-	key.offset = 0;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-	ret = btrfs_search_slot(trans, chunk_root, &key, &path, -1, 1);
-	if (ret < 0)
-		goto err;
+	ret = btrfs_make_root_dir(trans, new_root, BTRFS_FIRST_FREE_OBJECTID);
+	BUG_ON(ret);
 
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
-
-	key.objectid = root_objectid;
-	key.type = BTRFS_ROOT_ITEM_KEY;
-	key.offset = trans->transid;
-	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
-				&key, &root_item);
-
-	key.offset = (u64)-1;
-	new_root = btrfs_read_fs_root(root->fs_info, &key);
-	BUG_ON(!new_root || IS_ERR(new_root));
-
-	ret = btrfs_make_root_dir(trans, new_root, BTRFS_FIRST_FREE_OBJECTID);
-	BUG_ON(ret);
-
-	return 0;
-}
+	return 0;
+}
 
 /*
  * New make_btrfs_v2() has handle system and meta chunks quite well.
@@ -2101,9 +1565,9 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
  * chunks are allocated.
  * And also create convert image subvolume and relocation tree.
  */
-static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, ext2_filsys ext2_fs,
-			 struct btrfs_root *root, int datacsum, int packing,
-			 int noxattr)
+static int init_btrfs(struct btrfs_mkfs_config *cfg, ext2_filsys ext2_fs,
+		      struct btrfs_root *root, int datacsum, int packing,
+		      int noxattr)
 {
 	struct btrfs_key location;
 	struct btrfs_trans_handle *trans;
@@ -2198,63 +1662,6 @@ err:
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
-	/* subvol for ext2 image file */
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
@@ -2340,590 +1747,134 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
 	return 0;
 }
 
-static int prepare_system_chunk(int fd, u64 sb_bytenr)
+static int add_one_used_block(ext2_filsys fs, char *bitmap,
+			      unsigned long group_nr, struct cache_tree *used)
 {
-	int ret;
-	struct extent_buffer *buf;
-	struct btrfs_super_block *super;
+	unsigned long offset;
+	unsigned i;
+	int ret = 0;
 
-	BUG_ON(BTRFS_SUPER_INFO_SIZE < sizeof(*super));
-	buf = malloc(sizeof(*buf) + BTRFS_SUPER_INFO_SIZE);
-	if (!buf)
-		return -ENOMEM;
+	offset = fs->super->s_first_data_block;
+	offset /= EXT2FS_CLUSTER_RATIO(fs);
+	offset += group_nr * fs->super->s_clusters_per_group;
+	for (i = 0; i < fs->super->s_clusters_per_group; i++) {
+		if (ext2fs_test_bit(i, bitmap)) {
+			u64 start;
 
-	buf->len = BTRFS_SUPER_INFO_SIZE;
-	ret = pread(fd, buf->data, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
-	if (ret != BTRFS_SUPER_INFO_SIZE)
-		goto fail;
+			start = (i + offset) * EXT2FS_CLUSTER_RATIO(fs);
+			start *= fs->blocksize;
+			ret = add_merge_cache_extent(used, start,
+						     fs->blocksize);
+			if (ret < 0)
+				break;
+		}
+	}
+	return ret;
+}
 
-	super = (struct btrfs_super_block *)buf->data;
-	BUG_ON(btrfs_super_bytenr(super) != sb_bytenr);
-	BUG_ON(btrfs_super_num_devices(super) != 1);
+/*
+ * This function will iterate through all the ext2 block groups to fill used
+ * space tree.
+ * Which will later be used to build data chunk layout to ensure all ext2 used
+ * data will be covered by data chunk.
+ */
+static int read_ext2_used_space(ext2_filsys fs, struct cache_tree *used_tree)
+{
+	blk64_t blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	char *block_bitmap = NULL;
+	unsigned long i;
+	int block_nbytes;
+	int ret = 0;
 
-	ret = prepare_system_chunk_sb(super);
-	if (ret)
-		goto fail;
+	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
+	ret = ext2fs_read_bitmaps(fs);
+	if (ret < 0)
+		return ret;
+	/* Shouldn't happen */
+	BUG_ON(!fs->block_map);
 
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
-	if (ret != BTRFS_SUPER_INFO_SIZE)
-		goto fail;
+	block_bitmap = malloc(block_nbytes);
+	if (!block_bitmap)
+		return -ENOMEM;
 
-	ret = 0;
-fail:
-	free(buf);
-	if (ret > 0)
-		ret = -1;
+	for (i = 0; i < fs->group_desc_count; i++) {
+		ret = ext2fs_get_block_bitmap_range2(fs->block_map, blk_itr,
+						block_nbytes * 8, block_bitmap);
+		if (ret) {
+			error("fail to get bitmap from ext2, %s",
+			      strerror(-ret));
+			break;
+		}
+		ret = add_one_used_block(fs, block_bitmap, i, used_tree);
+		if (ret < 0) {
+			error("fail to build used space tree, %s",
+			      strerror(-ret));
+			break;
+		}
+		blk_itr += fs->super->s_clusters_per_group;
+	}
+
+	free(block_bitmap);
 	return ret;
 }
 
-static int relocate_one_reference(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  u64 extent_start, u64 extent_size,
-				  struct btrfs_key *extent_key,
-				  struct extent_io_tree *reloc_tree)
+static int do_convert(const char *devname, int datacsum, int packing,
+		int noxattr, u64 nodesize, int copylabel, const char *fslabel,
+		int progress, u64 features)
 {
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
 	int ret;
+	int fd = -1;
+	int is_btrfs = 0;
+	u32 blocksize;
+	u64 blocks[7];
+	u64 total_bytes;
+	ext2_filsys ext2_fs;
+	struct btrfs_root *root;
+	struct btrfs_root *image_root;
+	struct task_ctx ctx;
+	char features_buf[64];
+	struct btrfs_mkfs_config mkfs_cfg;
 
-	btrfs_init_path(&path);
-	ret = btrfs_search_slot(trans, root, extent_key, &path, -1, 1);
-	if (ret)
+	ret = open_ext2fs(devname, &ext2_fs);
+	if (ret) {
+		fprintf(stderr, "unable to open the Ext2fs\n");
 		goto fail;
-
-	leaf = path.nodes[0];
-	fi = btrfs_item_ptr(leaf, path.slots[0],
-			    struct btrfs_file_extent_item);
-	BUG_ON(btrfs_file_extent_offset(leaf, fi) > 0);
-	if (extent_start != btrfs_file_extent_disk_bytenr(leaf, fi) ||
-	    extent_size != btrfs_file_extent_disk_num_bytes(leaf, fi)) {
-		ret = 1;
+	}
+	blocksize = ext2_fs->blocksize;
+	total_bytes = (u64)ext2_fs->super->s_blocks_count * blocksize;
+	if (blocksize < 4096) {
+		fprintf(stderr, "block size is too small\n");
 		goto fail;
 	}
-
-	bytenr = extent_start + btrfs_file_extent_offset(leaf, fi);
-	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
-
-	ret = btrfs_del_item(trans, root, &path);
-	if (ret)
+	if (!(ext2_fs->super->s_feature_incompat &
+	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+		fprintf(stderr, "filetype feature is missing\n");
 		goto fail;
-
-	ret = btrfs_free_extent(trans, root, extent_start, extent_size, 0,
-				root->root_key.objectid,
-				extent_key->objectid, extent_key->offset);
-	if (ret)
+	}
+	if (btrfs_check_nodesize(nodesize, blocksize, features))
 		goto fail;
 
-	btrfs_release_path(&path);
-
-	key.objectid = extent_key->objectid;
-	key.offset = 0;
-	key.type =  BTRFS_INODE_ITEM_KEY;
-	ret = btrfs_lookup_inode(trans, root, &path, &key, 0);
-	if (ret)
+	/* Build the used space tree first */
+	init_mkfs_config(&mkfs_cfg);
+	ret = read_ext2_used_space(ext2_fs, &mkfs_cfg.convert_used);
+	if (ret < 0) {
+		error("fail to read ext2 block bitmap\n");
 		goto fail;
+	}
 
-	leaf = path.nodes[0];
-	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
-	read_extent_buffer(leaf, &inode, ptr, sizeof(inode));
-	btrfs_release_path(&path);
-
-	BUG_ON(num_bytes & (sectorsize - 1));
-	nbytes = btrfs_stack_inode_nbytes(&inode) - num_bytes;
-	btrfs_set_stack_inode_nbytes(&inode, nbytes);
-	datacsum = !(btrfs_stack_inode_flags(&inode) & BTRFS_INODE_NODATASUM);
+	fd = open(devname, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "unable to open %s\n", devname);
+		goto fail;
+	}
+	btrfs_parse_features_to_string(features_buf, features);
+	if (features == BTRFS_MKFS_DEFAULT_FEATURES)
+		strcat(features_buf, " (default)");
 
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
-		}
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
-	}
-	ret = 0;
-fail:
-	return ret;
-}
-
-static int fixup_chunk_mapping(struct btrfs_root *root)
-{
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
-
-		if (!(type & BTRFS_BLOCK_GROUP_SYSTEM))
-			goto next;
-
-		ret = btrfs_add_system_chunk(trans, chunk_root, &key,
-					     &chunk, size);
-		if (ret)
-			goto err;
-next:
-		path.slots[0]++;
-	}
-
-	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
-err:
-	btrfs_release_path(&path);
-	return ret;
-}
-
-static int add_one_used_block(ext2_filsys fs, char *bitmap,
-			      unsigned long group_nr, struct cache_tree *used)
-{
-	unsigned long offset;
-	unsigned i;
-	int ret = 0;
-
-	offset = fs->super->s_first_data_block;
-	offset /= EXT2FS_CLUSTER_RATIO(fs);
-	offset += group_nr * fs->super->s_clusters_per_group;
-	for (i = 0; i < fs->super->s_clusters_per_group; i++) {
-		if (ext2fs_test_bit(i, bitmap)) {
-			u64 start;
-
-			start = (i + offset) * EXT2FS_CLUSTER_RATIO(fs);
-			start *= fs->blocksize;
-			ret = add_merge_cache_extent(used, start,
-						     fs->blocksize);
-			if (ret < 0)
-				break;
-		}
-	}
-	return ret;
-}
-
-/*
- * This function will iterate through all the ext2 block groups to fill used
- * space tree.
- * Which will later be used to build data chunk layout to ensure all ext2 used
- * data will be covered by data chunk.
- */
-static int read_ext2_used_space(ext2_filsys fs, struct cache_tree *used_tree)
-{
-	blk64_t blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
-	char *block_bitmap = NULL;
-	unsigned long i;
-	int block_nbytes;
-	int ret = 0;
-
-	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
-	ret = ext2fs_read_bitmaps(fs);
-	if (ret < 0)
-		return ret;
-	/* Shouldn't happen */
-	BUG_ON(!fs->block_map);
-
-	block_bitmap = malloc(block_nbytes);
-	if (!block_bitmap)
-		return -ENOMEM;
-
-	for (i = 0; i < fs->group_desc_count; i++) {
-		ret = ext2fs_get_block_bitmap_range2(fs->block_map, blk_itr,
-						block_nbytes * 8, block_bitmap);
-		if (ret) {
-			error("fail to get bitmap from ext2, %s",
-			      strerror(-ret));
-			break;
-		}
-		ret = add_one_used_block(fs, block_bitmap, i, used_tree);
-		if (ret < 0) {
-			error("fail to build used space tree, %s",
-			      strerror(-ret));
-			break;
-		}
-		blk_itr += fs->super->s_clusters_per_group;
-	}
-
-	free(block_bitmap);
-	return ret;
-}
-
-static int do_convert_v2(const char *devname, int datacsum, int packing,
-		int noxattr, u64 nodesize, int copylabel, const char *fslabel,
-		int progress, u64 features)
-{
-	int ret;
-	int fd = -1;
-	int is_btrfs = 0;
-	u32 blocksize;
-	u64 blocks[7];
-	u64 total_bytes;
-	ext2_filsys ext2_fs;
-	struct btrfs_root *root;
-	struct btrfs_root *image_root;
-	struct task_ctx ctx;
-	char features_buf[64];
-	struct btrfs_mkfs_config mkfs_cfg;
-
-	ret = open_ext2fs(devname, &ext2_fs);
-	if (ret) {
-		fprintf(stderr, "unable to open the Ext2fs\n");
-		goto fail;
-	}
-	blocksize = ext2_fs->blocksize;
-	total_bytes = (u64)ext2_fs->super->s_blocks_count * blocksize;
-	if (blocksize < 4096) {
-		fprintf(stderr, "block size is too small\n");
-		goto fail;
-	}
-	if (!(ext2_fs->super->s_feature_incompat &
-	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
-		fprintf(stderr, "filetype feature is missing\n");
-		goto fail;
-	}
-	if (btrfs_check_nodesize(nodesize, blocksize, features))
-		goto fail;
-
-	/* Build the used space tree first */
-	init_mkfs_config(&mkfs_cfg);
-	ret = read_ext2_used_space(ext2_fs, &mkfs_cfg.convert_used);
-	if (ret < 0) {
-		error("fail to read ext2 block bitmap\n");
-		goto fail;
-	}
-
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
-	printf("\tnodesize:  %llu\n", nodesize);
-	printf("\tfeatures:  %s\n", features_buf);
+	printf("create btrfs filesystem:\n");
+	printf("\tblocksize: %u\n", blocksize);
+	printf("\tnodesize:  %llu\n", nodesize);
+	printf("\tfeatures:  %s\n", features_buf);
 
 	mkfs_cfg.label = ext2_fs->super->s_volume_name;
 	mkfs_cfg.fs_uuid = malloc(BTRFS_UUID_UNPARSED_SIZE);
@@ -2957,7 +1908,7 @@ static int do_convert_v2(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
 	}
-	ret = init_btrfs_v2(&mkfs_cfg, ext2_fs, root, datacsum, packing, 
+	ret = init_btrfs(&mkfs_cfg, ext2_fs, root, datacsum, packing, 
 			    noxattr);
 	if (ret) {
 		fprintf(stderr, "unable to setup the root tree\n");
@@ -2969,8 +1920,8 @@ static int do_convert_v2(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "unable to create subvol\n");
 		goto fail;
 	}
-	ret = create_ext2_image_v2(image_root, &mkfs_cfg, fd, total_bytes,
-				   "image", datacsum);
+	ret = create_ext2_image(image_root, &mkfs_cfg, fd, total_bytes,
+				"image", datacsum);
 	if (ret) {
 		fprintf(stderr, "error during create_ext2_image %d\n", ret);
 		goto fail;
@@ -3044,221 +1995,6 @@ fail:
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
-	ext2_filsys ext2_fs;
-	struct btrfs_root *root;
-	struct btrfs_root *image_root;
-	struct task_ctx ctx;
-	char features_buf[64];
-	struct btrfs_mkfs_config mkfs_cfg;
-
-	ret = open_ext2fs(devname, &ext2_fs);
-	if (ret) {
-		fprintf(stderr, "unable to open the Ext2fs\n");
-		goto fail;
-	}
-	blocksize = ext2_fs->blocksize;
-	total_bytes = (u64)ext2_fs->super->s_blocks_count * blocksize;
-	if (blocksize < 4096) {
-		fprintf(stderr, "block size is too small\n");
-		goto fail;
-	}
-	if (!(ext2_fs->super->s_feature_incompat &
-	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
-		fprintf(stderr, "filetype feature is missing\n");
-		goto fail;
-	}
-	if (btrfs_check_nodesize(nodesize, blocksize, features))
-		goto fail;
-
-	/* Build the used space tree first */
-	init_mkfs_config(&mkfs_cfg);
-	ret = read_ext2_used_space(ext2_fs, &mkfs_cfg.convert_used);
-	if (ret < 0) {
-		error("fail to read ext2 block bitmap\n");
-		goto fail;
-	}
-
-	blocks_per_node = nodesize / blocksize;
-	ret = -blocks_per_node;
-	for (i = 0; i < 7; i++) {
-		if (nodesize == blocksize)
-			ret = ext2_alloc_block(ext2_fs, 0, blocks + i);
-		else
-			ret = ext2_alloc_block_range(ext2_fs,
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
-	mkfs_cfg.label = ext2_fs->super->s_volume_name;
-	mkfs_cfg.chunk_uuid = NULL;
-	mkfs_cfg.fs_uuid = NULL;
-	memcpy(mkfs_cfg.blocks, blocks, sizeof(blocks));
-	mkfs_cfg.num_bytes = total_bytes;
-	mkfs_cfg.nodesize = nodesize;
-	mkfs_cfg.sectorsize = blocksize;
-	mkfs_cfg.stripesize = blocksize;
-	mkfs_cfg.features = features;
-
-	ret = make_btrfs(fd, &mkfs_cfg);
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
-	ret = cache_free_extents(root, ext2_fs);
-	if (ret) {
-		fprintf(stderr, "error during cache_free_extents %d\n", ret);
-		goto fail;
-	}
-	root->fs_info->extent_ops = &extent_ops;
-	/* recover block allocation bitmap */
-	for (i = 0; i < 7; i++) {
-		blocks[i] /= blocksize;
-		if (nodesize == blocksize)
-			ext2_free_block(ext2_fs, blocks[i]);
-		else
-			ext2_free_block_range(ext2_fs, blocks[i],
-					blocks_per_node);
-	}
-	ret = init_btrfs(root);
-	if (ret) {
-		fprintf(stderr, "unable to setup the root tree\n");
-		goto fail;
-	}
-	printf("creating btrfs metadata.\n");
-	ctx.max_copy_inodes = (ext2_fs->super->s_inodes_count
-			- ext2_fs->super->s_free_inodes_count);
-	ctx.cur_copy_inodes = 0;
-
-	if (progress) {
-		ctx.info = task_init(print_copied_inodes, after_copied_inodes, &ctx);
-		task_start(ctx.info);
-	}
-	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr, 0, &ctx);
-	if (ret) {
-		fprintf(stderr, "error during copy_inodes %d\n", ret);
-		goto fail;
-	}
-	if (progress) {
-		task_stop(ctx.info);
-		task_deinit(ctx.info);
-	}
-	printf("creating ext2fs image file.\n");
-	image_root = link_subvol(root, "ext2_saved", CONV_IMAGE_SUBVOL_OBJECTID);
-	if (!image_root) {
-		fprintf(stderr, "unable to create subvol\n");
-		goto fail;
-	}
-	ret = create_ext2_image(image_root, ext2_fs, "image", datacsum);
-	if (ret) {
-		fprintf(stderr, "error during create_ext2_image %d\n", ret);
-		goto fail;
-	}
-	memset(root->fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
-	if (copylabel == 1) {
-		strncpy(root->fs_info->super_copy->label,
-				ext2_fs->super->s_volume_name, 16);
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
-	close_ext2fs(ext2_fs);
-
-	/*
-	 * If this step succeed, we get a mountable btrfs. Otherwise
-	 * the ext2fs is left unchanged.
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
-	free_mkfs_config(&mkfs_cfg);
-
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
@@ -3807,7 +2543,7 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file);
 	} else {
-		ret = do_convert_v2(file, datacsum, packing, noxattr, nodesize,
+		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
 				copylabel, fslabel, progress, features);
 	}
 	if (ret)
diff --git a/ctree.h b/ctree.h
index 41b5e8f..6f32e5f 100644
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
index c0b4442..0c4210a 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2180,7 +2180,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 
 	struct btrfs_key key;
 	struct btrfs_path *path;
-	struct btrfs_extent_ops *ops = root->fs_info->extent_ops;
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
@@ -2381,14 +2380,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
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
@@ -2661,13 +2652,6 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
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
@@ -2701,7 +2685,6 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			       trans->alloc_exclude_start,
 			       trans->alloc_exclude_nr, data);
 	BUG_ON(ret);
-found:
 	clear_extent_dirty(&root->fs_info->free_space_cache,
 			   ins->objectid, ins->objectid + ins->offset - 1,
 			   GFP_NOFS);
-- 
2.6.2

