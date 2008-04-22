From: Yan Zheng <yanzheng@21cn.com>
Subject: [Btrfs-devel][PATCH] Updates for ext3 converter.
Date: Tue, 22 Apr 2008 14:38:34 +0800
Message-ID: <480D87EA.8080800@21cn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org, btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates the ext3 converter. The main changes in this patch
are adding chunk handing and data relocation ability. In the last step
of conversion, the converter relocates data in system chunk and move
chunk tree into system chunk. In the rollback process, the converter
remove chunk tree from system chunk and copy data back.

Regards
YZ
---
diff -r 87f01ef6d798 convert.c
--- a/convert.c	Fri Apr 18 11:56:21 2008 -0400
+++ b/convert.c	Tue Apr 22 14:23:28 2008 +0800
@@ -33,6 +33,7 @@
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
+#include "volumes.h"
 #include "transaction.h"
 #include "crc32c.h"
 #include "utils.h"
@@ -76,6 +77,7 @@ static int close_ext2fs(ext2_filsys fs)
 	ext2fs_close(fs);
 	return 0;
 }
+
 static int ext2_alloc_block(ext2_filsys fs, u64 goal, u64 *block_ret)
 {
 	blk_t block;
@@ -98,32 +100,39 @@ static int custom_alloc_extent(struct bt
 static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 			       u64 hint_byte, struct btrfs_key *ins)
 {
-	ext2_filsys fs = (ext2_filsys)root->fs_info->priv_data;
-	u32 blocksize = fs->blocksize;
-	u64 first = 0;
-	u64 block;
+	struct btrfs_block_group_cache *cache;
+	ext2_filsys ext2_fs = (ext2_filsys)root->fs_info->priv_data;
+	u32 blocksize = ext2_fs->blocksize;
 	u64 bytenr;
+	blk_t block;
+	int wrapped = 0;
 	int ret;
 
-	block = hint_byte / blocksize;
-	BUG_ON(block != (blk_t)block);
-	BUG_ON(num_bytes != blocksize);
 	while (1) {
-		ret = ext2_alloc_block(fs, block, &block);
+		block = hint_byte / blocksize;
+		ret = ext2fs_new_block(ext2_fs, block, NULL, &block);
 		if (ret)
 			goto fail;
-		/* all free blocks are pinned */
-		if (first == block)
-			goto fail;
-		if (first == 0)
-			first = block;
-		bytenr = block * blocksize;
-		if (!test_range_bit(&root->fs_info->pinned_extents, bytenr,
-				    bytenr + blocksize - 1, EXTENT_DIRTY, 0))
-			break;
-
-		ext2_free_block(fs, block);
-		block++;
+
+		bytenr = (u64)block * blocksize;
+		if (bytenr < hint_byte && ++wrapped > 1)
+			goto fail;
+
+		cache = btrfs_lookup_block_group(root->fs_info, bytenr);
+		BUG_ON(!cache);
+		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+			hint_byte = cache->key.objectid + cache->key.offset;
+			continue;
+		}
+
+		if (test_range_bit(&root->fs_info->pinned_extents, bytenr,
+				   bytenr + blocksize - 1, EXTENT_DIRTY, 0)) {
+			hint_byte = bytenr + blocksize;
+			continue;
+		}
+
+		ext2fs_fast_mark_block_bitmap(ext2_fs->block_map, block);
+		break;
 	}
 	ins->objectid = bytenr;
 	ins->offset = blocksize;
@@ -133,6 +142,7 @@ fail:
 	fprintf(stderr, "not enough free space\n");
 	return -ENOSPC;
 }
+
 static int custom_free_extent(struct btrfs_root *root, u64 bytenr,
 			      u64 num_bytes)
 {
@@ -162,6 +172,7 @@ struct dir_iterate_data {
 	u64 parent;
 	int errcode;
 };
+
 static u8 filetype_conversion_table[EXT2_FT_MAX] = {
 	[EXT2_FT_UNKNOWN]	= BTRFS_FT_UNKNOWN,
 	[EXT2_FT_REG_FILE]	= BTRFS_FT_REG_FILE,
@@ -259,9 +270,9 @@ static int read_disk_extent(struct btrfs
 		            u32 num_bytes, char *buffer)
 {
 	int ret;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-
-	ret = pread(fs_info->fp, buffer, num_bytes, bytenr);
+	struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
+
+	ret = pread(fs_devs->latest_bdev, buffer, num_bytes, bytenr);
 	if (ret != num_bytes)
 		goto fail;
 	ret = 0;
@@ -376,6 +387,7 @@ struct blk_iterate_data {
 	u64 first_block;
 	u64 disk_block;
 	u64 num_blocks;
+	u64 boundary;
 	int checksum;
 	int errcode;
 };
@@ -385,13 +397,15 @@ static int block_iterate_proc(ext2_filsy
 		              struct blk_iterate_data *idata)
 {
 	int ret;
-	u32 blocksize = ext2_fs->blocksize;
 	struct btrfs_root *root = idata->root;
 	struct btrfs_trans_handle *trans = idata->trans;
-
-	if ((file_block > idata->first_block + idata->num_blocks) ||
-	    (disk_block != idata->disk_block + idata->num_blocks) ||
-	    (idata->num_blocks >= BTRFS_BLOCK_GROUP_SIZE / blocksize)) {
+	struct btrfs_block_group_cache *cache;
+	u64 bytenr;
+
+	BUG_ON(disk_block == 0);
+	if ((idata->num_blocks > 0 && disk_block >= idata->boundary) ||
+	    (file_block > idata->first_block + idata->num_blocks) ||
+	    (disk_block != idata->disk_block + idata->num_blocks)) {
 		if (idata->num_blocks > 0) {
 			ret = record_file_blocks(trans, root, idata->objectid,
 					idata->inode, idata->first_block,
@@ -410,8 +424,15 @@ static int block_iterate_proc(ext2_filsy
 			if (ret)
 				goto fail;
 		}
+
+		bytenr = disk_block * root->sectorsize;
+		cache = btrfs_lookup_block_group(root->fs_info, bytenr); 
+		BUG_ON(!cache);
+		bytenr = cache->key.objectid + cache->key.offset;
+
 		idata->first_block = file_block;
 		idata->disk_block = disk_block;
+		idata->boundary = bytenr / root->sectorsize;
 	}
 	idata->num_blocks++;
 	return 0;
@@ -452,6 +473,7 @@ static int create_file_extents(struct bt
 		.first_block	= 0,
 		.disk_block	= 0,
 		.num_blocks	= 0,
+		.boundary	= (u64)-1,
 		.checksum	= datacsum,
 		.errcode	= 0,
 	};
@@ -972,15 +994,15 @@ static int copy_disk_extent(struct btrfs
 {
 	int ret;
 	char *buffer;
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
 
 	buffer = malloc(num_bytes);
 	if (!buffer)
 		return -ENOMEM;
-	ret = pread(fs_info->fp, buffer, num_bytes, src_bytenr);
+	ret = pread(fs_devs->latest_bdev, buffer, num_bytes, src_bytenr);
 	if (ret != num_bytes)
 		goto fail;
-	ret = pwrite(fs_info->fp, buffer, num_bytes, dst_bytenr);
+	ret = pwrite(fs_devs->latest_bdev, buffer, num_bytes, dst_bytenr);
 	if (ret != num_bytes)
 		goto fail;
 	ret = 0;
@@ -1019,7 +1041,7 @@ static int copy_inodes(struct btrfs_root
 			if (ret)
 				return ret;
 		}
-		if (trans->blocks_used >= 8192) {
+		if (trans->blocks_used >= 4096) {
 			ret = btrfs_commit_transaction(trans, root);
 			BUG_ON(ret);
 			trans = btrfs_start_transaction(root, 1);
@@ -1031,6 +1053,7 @@ static int copy_inodes(struct btrfs_root
 
 	return ret;
 }
+
 static int lookup_extent_item(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 bytenr, u64 num_bytes)
@@ -1038,12 +1061,25 @@ static int lookup_extent_item(struct btr
 	int ret;
 	struct btrfs_key key;
 	struct btrfs_path path;
+
 	btrfs_init_path(&path);
 	key.objectid = bytenr;
-	key.offset = num_bytes;
+	key.offset = (u64)-1;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root,
 				&key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	ret = btrfs_previous_item(root, &path, 0, BTRFS_EXTENT_ITEM_KEY);
+	if (ret != 0)
+		goto out;
+
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	if (key.objectid + key.offset < bytenr + num_bytes)
+		ret = 1;
+out:
 	btrfs_release_path(root, &path);
 	return ret;
 }
@@ -1072,8 +1108,9 @@ static int create_image_file_range(struc
 		.inode		= inode,
 		.objectid	= objectid,
 		.first_block	= block,
-		.disk_block	= block,
+		.disk_block	= 0,
 		.num_blocks	= 0,
+		.boundary	= (u64)-1,
 		.checksum 	= 0,
 		.errcode	= 0,
 	};
@@ -1088,19 +1125,18 @@ static int create_image_file_range(struc
 		if (ret == 0)
 			continue;
 
-		ret = block_iterate_proc(ext2_fs, block, block, &data);
-		if (ret & BLOCK_ABORT)
-			break;
-	}
-	ret = data.errcode;
-	if (ret)
-		return ret;
+		ret = block_iterate_proc(NULL, block, block, &data);
+		if (ret & BLOCK_ABORT) {
+			ret = data.errcode;
+			goto fail;
+		}
+	}
 	if (data.num_blocks > 0) {
 		ret = record_file_blocks(trans, root, objectid, inode,
 					 data.first_block, data.disk_block,
 					 data.num_blocks, 0);
 		if (ret)
-			return ret;
+			goto fail;
 		data.first_block += data.num_blocks;
 	}
 	if (last_block > data.first_block) {
@@ -1108,10 +1144,10 @@ static int create_image_file_range(struc
 					 data.first_block, 0, last_block -
 					 data.first_block, 0);
 		if (ret)
-			return ret;
+			goto fail;
 	}
 fail:
-	return 0;
+	return ret;
 }
 /*
  * Create the ext2fs image file.
@@ -1135,12 +1171,10 @@ static int create_ext2_image(struct btrf
 	u64 ref_root;
 	u64 ref_owner;
 	u64 objectid;
-	u64 new_block;
 	u64 last_byte;
 	u64 first_free;
 	u64 total_bytes;
 	u32 sectorsize = root->sectorsize;
-	int slot;
 	int file_extent;
 
 	total_bytes = btrfs_super_total_bytes(&fs_info->super_copy);
@@ -1165,56 +1199,47 @@ static int create_ext2_image(struct btrf
 		goto fail;
 
 	/*
-	 * copy the first a few blocks to new positions. the relocation is
-	 * reuqired for block 0 and default btrfs super block.
+	 * copy blocks covered by extent #0 to new positions. extent #0 is
+	 * special, we can't rely on relocate_extents_range to relocate it.
 	 */
 	for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
-		ret = ext2_alloc_block(ext2_fs, 0, &new_block);
+		ret = custom_alloc_extent(root, sectorsize, 0, &key);
 		if (ret)
 			goto fail;
-		new_block *= sectorsize;
-		ret = copy_disk_extent(root, new_block, last_byte, sectorsize);
+		ret = copy_disk_extent(root, key.objectid, last_byte,
+				       sectorsize);
 		if (ret)
 			goto fail;
 		ret = record_file_extent(trans, root, objectid,
 					 &btrfs_inode, last_byte,
-					 new_block, sectorsize, 0);
+					 key.objectid, sectorsize, 0);
 		if (ret)
 			goto fail;
 	}
-again:
-	if (trans->blocks_used >= 8192) {
-		ret = btrfs_commit_transaction(trans, root);
-		BUG_ON(ret);
-		trans = btrfs_start_transaction(root, 1);
-		BUG_ON(!trans);
-	}
-
-	key.objectid = last_byte;
-	key.offset = 0;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	ret = btrfs_search_slot(trans, fs_info->extent_root,
-				&key, &path, 0, 0);
-	if (ret < 0)
-		goto fail;
-
-	leaf = path.nodes[0];
-	slot = path.slots[0];
+
 	while(1) {
-		if (slot >= btrfs_header_nritems(leaf)) {
+		key.objectid = last_byte;
+		key.offset = 0;
+		btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
+		ret = btrfs_search_slot(trans, fs_info->extent_root,
+					&key, &path, 0, 0);
+		if (ret < 0)
+			goto fail;
+next:
+		leaf = path.nodes[0];
+		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(extent_root, &path);
 			if (ret < 0)
 				goto fail;
 			if (ret > 0)
 				break;
 			leaf = path.nodes[0];
-			slot = path.slots[0];
-		}
-		btrfs_item_key_to_cpu(leaf, &key, slot);
+		}
+		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
 		if (last_byte > key.objectid ||
 		    key.type != BTRFS_EXTENT_ITEM_KEY) {
-			slot++;
-			continue;
+			path.slots[0]++;
+			goto next;
 		}
 		/*
 		 * Check backref to distinguish extent items for normal
@@ -1225,23 +1250,22 @@ again:
 		num_bytes = key.offset;
 		file_extent = 0;
 		while (1) {
-			if (slot >= btrfs_header_nritems(leaf)) {
+			if (path.slots[0] >= btrfs_header_nritems(leaf)) {
 				ret = btrfs_next_leaf(extent_root, &path);
 				if (ret > 0)
 					break;
 				if (ret < 0)
 					goto fail;
 				leaf = path.nodes[0];
-				slot = path.slots[0];
 			}
-			btrfs_item_key_to_cpu(leaf, &key, slot);
+			btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
 			if (key.objectid != bytenr)
 				break;
 			if (key.type != BTRFS_EXTENT_REF_KEY) {
-				slot++;
+				path.slots[0]++;
 				continue;
 			}
-			ref_item = btrfs_item_ptr(leaf, slot,
+			ref_item = btrfs_item_ptr(leaf, path.slots[0],
 						  struct btrfs_extent_ref);
 			ref_root = btrfs_ref_root(leaf, ref_item);
 			ref_owner = btrfs_ref_objectid(leaf, ref_item);
@@ -1250,10 +1274,10 @@ again:
 				file_extent = 1;
 				break;
 			}
-			slot++;
+			path.slots[0]++;
 		}
 		if (!file_extent)
-			continue;
+			goto next;
 
 		if (bytenr > last_byte) {
 			ret = create_image_file_range(trans, root, objectid,
@@ -1267,8 +1291,14 @@ again:
 		if (ret)
 			goto fail;
 		last_byte = bytenr + num_bytes;
-		btrfs_release_path(root, &path);
-		goto again;
+		btrfs_release_path(extent_root, &path);
+
+		if (trans->blocks_used >= 4096) {
+			ret = btrfs_commit_transaction(trans, root);
+			BUG_ON(ret);
+			trans = btrfs_start_transaction(root, 1);
+			BUG_ON(!trans);
+		}
 	}
 	btrfs_release_path(root, &path);
 	if (total_bytes > last_byte) {
@@ -1278,14 +1308,7 @@ again:
 		if (ret)
 			goto fail;
 	}
-	/*
-	 * otime isn't used currently, so we can store some data in it.
-	 * These data are used by do_rollback to check whether the image
-	 * file has been modified.
-	 */
-	btrfs_set_stack_timespec_sec(&btrfs_inode.otime, trans->transid);
-	btrfs_set_stack_timespec_nsec(&btrfs_inode.otime,
-				      total_bytes / sectorsize);
+
 	ret = btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
 	if (ret)
 		goto fail;
@@ -1322,6 +1345,7 @@ fail:
 	btrfs_release_path(root, &path);
 	return ret;
 }
+
 struct btrfs_root *create_subvol(struct btrfs_root *root, const char *name)
 {
 	int ret;
@@ -1406,6 +1430,7 @@ static int fixup_block_accounting(struct
 			break;
 		start = cache->key.objectid + cache->key.offset;
 		btrfs_set_block_group_used(&cache->item, 0);
+		cache->space_info->bytes_used = 0;
 	}
 
 	btrfs_init_path(&path);
@@ -1442,6 +1467,129 @@ static int fixup_block_accounting(struct
 	return 0;
 }
 
+static int create_chunk_mapping(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_root *chunk_root = info->chunk_root;
+	struct btrfs_root *extent_root = info->extent_root;
+	struct btrfs_device *device;
+	struct btrfs_block_group_cache *cache;
+	struct btrfs_dev_extent *extent;
+	struct extent_buffer *leaf;
+	struct btrfs_chunk chunk;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	u64 cur_start;
+	u64 total_bytes;
+	u64 chunk_objectid;
+	int ret;
+
+	btrfs_init_path(&path);
+
+	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
+	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+
+	BUG_ON(list_empty(&info->fs_devices->devices));
+	device = list_entry(info->fs_devices->devices.next,
+			    struct btrfs_device, dev_list);
+	BUG_ON(device->devid != info->fs_devices->latest_devid);
+
+	/* delete device extent created by make_btrfs */
+	key.objectid = device->devid;
+	key.offset = 0;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	ret = btrfs_search_slot(trans, device->dev_root, &key, &path, -1, 1);	
+	if (ret < 0)
+		goto err;
+
+	BUG_ON(ret > 0);
+	ret = btrfs_del_item(trans, device->dev_root, &path);
+	if (ret)
+		goto err;
+	btrfs_release_path(device->dev_root, &path);
+
+	/* delete chunk item created by make_btrfs */
+	key.objectid = chunk_objectid;
+	key.offset = 0;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	ret = btrfs_search_slot(trans, chunk_root, &key, &path, -1, 1);	
+	if (ret < 0)
+		goto err;
+
+	BUG_ON(ret > 0);
+	ret = btrfs_del_item(trans, chunk_root, &path);
+	if (ret)
+		goto err;
+	btrfs_release_path(chunk_root, &path);
+
+	/* for each block group, create device extent and chunk item */
+	cur_start = 0;
+	while (cur_start < total_bytes) {
+		cache = btrfs_lookup_block_group(root->fs_info, cur_start);
+		BUG_ON(!cache);
+
+		/* insert device extent */
+		key.objectid = device->devid;
+		key.offset = cache->key.objectid;
+		key.type = BTRFS_DEV_EXTENT_KEY;
+		ret = btrfs_insert_empty_item(trans, device->dev_root, &path,
+					      &key, sizeof(*extent));
+		if (ret)
+			goto err;
+
+		leaf = path.nodes[0];
+		extent = btrfs_item_ptr(leaf, path.slots[0],
+					struct btrfs_dev_extent);
+
+		btrfs_set_dev_extent_chunk_tree(leaf, extent,
+						chunk_root->root_key.objectid);
+		btrfs_set_dev_extent_chunk_objectid(leaf, extent, 
+						    chunk_objectid);
+		btrfs_set_dev_extent_chunk_offset(leaf, extent, 
+						  cache->key.objectid);
+		btrfs_set_dev_extent_length(leaf, extent, cache->key.offset);
+		write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
+		    (unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
+		    BTRFS_UUID_SIZE);
+		btrfs_mark_buffer_dirty(leaf);
+		btrfs_release_path(device->dev_root, &path);
+
+		/* insert chunk item */
+		btrfs_set_stack_chunk_length(&chunk, cache->key.offset);
+		btrfs_set_stack_chunk_owner(&chunk, 
+					    extent_root->root_key.objectid);
+		btrfs_set_stack_chunk_stripe_len(&chunk, 64 * 1024);
+		btrfs_set_stack_chunk_type(&chunk, cache->flags);
+		btrfs_set_stack_chunk_io_align(&chunk, device->io_align);
+		btrfs_set_stack_chunk_io_width(&chunk, device->io_width);
+		btrfs_set_stack_chunk_sector_size(&chunk, device->sector_size);
+		btrfs_set_stack_chunk_num_stripes(&chunk, 1);
+		btrfs_set_stack_chunk_sub_stripes(&chunk, 0);
+		btrfs_set_stack_stripe_devid(&chunk.stripe, device->devid);
+		btrfs_set_stack_stripe_offset(&chunk.stripe, 
+					      cache->key.objectid);
+		memcpy(&chunk.stripe.dev_uuid, device->uuid, BTRFS_UUID_SIZE);
+
+		key.objectid = chunk_objectid;
+		key.offset = cache->key.objectid;
+		key.type = BTRFS_CHUNK_ITEM_KEY;
+
+		ret = btrfs_insert_item(trans, chunk_root, &key, &chunk,
+					btrfs_chunk_item_size(1));
+		if (ret)
+			goto err;
+
+		cur_start = cache->key.objectid + cache->key.offset;
+	}
+
+	device->bytes_used = total_bytes;
+	ret = btrfs_update_device(trans, device);
+err:
+	btrfs_release_path(device->dev_root, &path);
+	return ret;
+}
+
 static int init_btrfs(struct btrfs_root *root)
 {
 	int ret;
@@ -1455,6 +1603,9 @@ static int init_btrfs(struct btrfs_root 
 	if (ret)
 		goto err;
 	ret = fixup_block_accounting(trans, root);
+	if (ret)
+		goto err;
+	ret = create_chunk_mapping(trans, root);
 	if (ret)
 		goto err;
 	ret = btrfs_make_root_dir(trans, fs_info->tree_root,
@@ -1480,54 +1631,47 @@ err:
 err:
 	return ret;
 }
+
 /*
  * Migrate super block to it's default position and zero 0 ~ 16k
  */
 static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
 {
 	int ret;
-	char *buf;
-	u64 bytenr;
-	u32 crc =  ~(u32)0;
-	u32 len = 512 - BTRFS_CSUM_SIZE;
+	struct extent_buffer *buf;
 	struct btrfs_super_block *super;
-
-	ret = fsync(fd);
-	if (ret)
-		goto fail;
-
-	BUG_ON(sectorsize < sizeof(super));
-	buf = malloc(sectorsize);
+	u32 len;
+	u32 bytenr;
+
+	BUG_ON(sectorsize < sizeof(*super));
+	buf = malloc(sizeof(*buf) + sectorsize);
 	if (!buf)
 		return -ENOMEM;
-	ret = pread(fd, buf, sectorsize, old_bytenr);
+
+	buf->len = sectorsize;
+	ret = pread(fd, buf->data, sectorsize, old_bytenr);
 	if (ret != sectorsize)
 		goto fail;
 
-	super = (struct btrfs_super_block *)buf;
+	super = (struct btrfs_super_block *)buf->data;
 	BUG_ON(btrfs_super_bytenr(super) != old_bytenr);
 	btrfs_set_super_bytenr(super, BTRFS_SUPER_INFO_OFFSET);
 
-	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len);
-	crc = ~cpu_to_le32(crc);
-	memcpy(super->csum, &crc, BTRFS_CRC32_SIZE);
-
-	ret = pwrite(fd, buf, sectorsize, BTRFS_SUPER_INFO_OFFSET);
-	if (ret < 0)
-		goto fail;
-	/* How to handle this case? */
-	BUG_ON(ret != sectorsize);
+	csum_tree_block(NULL, buf, 0);
+	ret = pwrite(fd, buf->data, sectorsize, BTRFS_SUPER_INFO_OFFSET);
+	if (ret != sectorsize)
+		goto fail;
 
 	ret = fsync(fd);
 	if (ret)
 		goto fail;
 
-	memset(buf, 0, sectorsize);
+	memset(buf->data, 0, sectorsize);
 	for (bytenr = 0; bytenr < BTRFS_SUPER_INFO_OFFSET; ) {
 		len = BTRFS_SUPER_INFO_OFFSET - bytenr;
 		if (len > sectorsize)
 			len = sectorsize;
-		ret = pwrite(fd, buf, len, bytenr);
+		ret = pwrite(fd, buf->data, len, bytenr);
 		if (ret != len) {
 			fprintf(stderr, "unable to zero fill device\n");
 			break;
@@ -1540,6 +1684,460 @@ fail:
 	free(buf);
 	if (ret > 0)
 		ret = -1;
+	return ret;
+}
+
+static int prepare_system_chunk_sb(struct btrfs_super_block *super)
+{
+	struct btrfs_chunk *chunk;
+	struct btrfs_disk_key *key;
+	u32 sectorsize = btrfs_super_sectorsize(super);
+
+	key = (struct btrfs_disk_key *)(super->sys_chunk_array);
+	chunk = (struct btrfs_chunk *)(super->sys_chunk_array + 
+				       sizeof(struct btrfs_disk_key));
+
+	btrfs_set_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
+	btrfs_set_disk_key_offset(key, 0);
+
+	btrfs_set_stack_chunk_length(chunk, btrfs_super_total_bytes(super));
+	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
+	btrfs_set_stack_chunk_stripe_len(chunk, 64 * 1024);
+	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
+	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
+	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
+	btrfs_set_stack_chunk_sector_size(chunk, sectorsize);
+	btrfs_set_stack_chunk_num_stripes(chunk, 1);
+	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
+	chunk->stripe.devid = super->dev_item.devid;
+	chunk->stripe.offset = cpu_to_le64(0);
+	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
+	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
+	return 0;
+}
+
+static int prepare_system_chunk(int fd, u64 sb_bytenr, u32 sectorsize)
+{
+	int ret;
+	struct extent_buffer *buf;
+	struct btrfs_super_block *super;
+
+	BUG_ON(sectorsize < sizeof(*super));
+	buf = malloc(sizeof(*buf) + sectorsize);
+	if (!buf)
+		return -ENOMEM;
+
+	buf->len = sectorsize;
+	ret = pread(fd, buf->data, sectorsize, sb_bytenr);
+	if (ret != sectorsize)
+		goto fail;
+
+	super = (struct btrfs_super_block *)buf->data;
+	BUG_ON(btrfs_super_bytenr(super) != sb_bytenr);
+	BUG_ON(btrfs_super_num_devices(super) != 1);
+	
+	ret = prepare_system_chunk_sb(super);
+	if (ret)
+		goto fail;
+
+	csum_tree_block(NULL, buf, 0);
+	ret = pwrite(fd, buf->data, sectorsize, sb_bytenr);
+	if (ret != sectorsize)
+		goto fail;
+
+	ret = 0;
+fail:
+	free(buf);
+	if (ret > 0)
+		ret = -1;
+	return ret;
+}
+
+static int relocate_one_reference(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root, 
+				  u64 objectid, u64 offset,
+				  struct extent_io_tree *reloc_tree)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_inode_item inode;
+	struct blk_iterate_data data;
+	u64 bytenr;
+	u64 num_bytes;
+	u64 cur_offset;
+	u64 extent_start;
+	u64 extent_size;
+	u64 new_pos;
+	u64 nblocks;
+	u64 root_gen;
+	u64 root_owner;
+	u64 sector_end;
+	u32 sectorsize = root->sectorsize;
+	unsigned long ptr;
+	int ret;
+
+	btrfs_init_path(&path);
+
+	key.objectid = objectid;
+	key.offset = 0;
+	key.type =  BTRFS_INODE_ITEM_KEY;
+	ret = btrfs_lookup_inode(trans, root, &path, &key, 0);
+	if (ret)
+		goto fail;
+
+	leaf = path.nodes[0];
+	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
+	read_extent_buffer(leaf, &inode, ptr, sizeof(inode));
+	btrfs_release_path(root, &path);
+
+	ret = btrfs_lookup_file_extent(trans, root, &path, 
+				       objectid, offset, -1);
+	if (ret)
+		goto fail;
+
+	leaf = path.nodes[0];
+	fi = btrfs_item_ptr(leaf, path.slots[0],
+			    struct btrfs_file_extent_item);
+
+	root_gen = btrfs_header_generation(leaf);
+	root_owner = btrfs_header_owner(leaf);
+
+	extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
+	extent_size = btrfs_file_extent_disk_num_bytes(leaf, fi);
+	bytenr = extent_start + btrfs_file_extent_offset(leaf, fi);
+	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+	
+	ret = btrfs_del_item(trans, root, &path);
+	if (ret)
+		goto fail;
+	btrfs_release_path(root, &path);
+
+	BUG_ON(num_bytes & (sectorsize - 1));
+	nblocks = btrfs_stack_inode_nblocks(&inode) - num_bytes / 512;
+	btrfs_set_stack_inode_nblocks(&inode, nblocks);
+
+	data = (struct blk_iterate_data) {
+		.trans		= trans,
+		.root		= root,
+		.inode		= &inode,
+		.objectid	= objectid,
+		.first_block	= offset / sectorsize,
+		.disk_block	= 0,
+		.num_blocks	= 0,
+		.boundary	= (u64)-1,
+		.checksum 	= 0,
+		.errcode	= 0, 
+	};
+
+	cur_offset = offset;
+	while (num_bytes > 0) {
+		sector_end = bytenr + sectorsize - 1;
+		if (test_range_bit(reloc_tree, bytenr, sector_end,
+				   EXTENT_LOCKED, 1)) {
+			ret = get_state_private(reloc_tree, bytenr, &new_pos);
+			BUG_ON(ret);
+		} else {
+			ret = custom_alloc_extent(root, sectorsize, 0, &key);
+			if (ret)
+				goto fail;
+			new_pos = key.objectid;
+			ret = copy_disk_extent(root, new_pos, bytenr,
+					       sectorsize);
+			if (ret)
+				goto fail;
+			ret = set_extent_bits(reloc_tree, bytenr, sector_end,
+					      EXTENT_LOCKED, GFP_NOFS);
+			BUG_ON(ret);
+			ret = set_state_private(reloc_tree, bytenr, new_pos);
+			BUG_ON(ret);
+		}
+
+		ret = block_iterate_proc(NULL, new_pos / sectorsize,
+					 cur_offset / sectorsize, &data);
+		if (ret & BLOCK_ABORT) {
+			ret = data.errcode;
+			goto fail;
+		}
+
+		cur_offset += sectorsize;
+		bytenr += sectorsize;
+		num_bytes -= sectorsize;
+	}
+
+	if (data.num_blocks > 0) {
+		ret = record_file_blocks(trans, root, objectid, &inode,
+					 data.first_block, data.disk_block,
+					 data.num_blocks, 0);
+		if (ret)
+			goto fail;
+	}
+
+	key.objectid = objectid;
+	key.offset = 0;
+	key.type =  BTRFS_INODE_ITEM_KEY;
+	ret = btrfs_lookup_inode(trans, root, &path, &key, 1);
+	if (ret)
+		goto fail;
+
+	leaf = path.nodes[0];
+	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
+	write_extent_buffer(leaf, &inode, ptr, sizeof(inode));
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, &path);
+
+	ret = btrfs_free_extent(trans, root, extent_start, extent_size,
+				root_owner, root_gen, objectid, offset, 0);
+fail:
+	btrfs_release_path(root, &path);
+	return ret;
+}
+
+static int relocate_extents_range(struct btrfs_root *fs_root,
+				  struct btrfs_root *ext2_root,
+				  u64 start_byte, u64 end_byte)
+{
+	struct btrfs_fs_info *info = fs_root->fs_info;
+	struct btrfs_root *extent_root = info->extent_root;
+	struct btrfs_root *cur_root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_extent_ref *ref_item;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_io_tree reloc_tree;
+	u64 cur_byte;
+	u64 num_bytes;
+	u64 ref_root;
+	u64 ref_owner;
+	u64 ref_offset;
+	u64 num_refs;
+	int pass = 0;
+	int ret;
+	int found;
+
+	btrfs_init_path(&path);
+	extent_io_tree_init(&reloc_tree);
+again:
+	cur_root = (pass % 2 == 0) ? ext2_root : fs_root;
+	num_refs = 0;
+
+	trans = btrfs_start_transaction(cur_root, 1);
+	BUG_ON(!trans);
+
+	cur_byte = start_byte;
+	while (1) {
+		key.objectid = cur_byte;
+		key.offset = 0;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		ret = btrfs_search_slot(trans, extent_root,
+					&key, &path, 0, 0);
+		if (ret < 0)
+			goto fail;
+next:
+		leaf = path.nodes[0];
+		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(extent_root, &path);
+			if (ret < 0)
+				goto fail;
+			if (ret > 0)
+				break;
+			leaf = path.nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
+		if (key.objectid < cur_byte ||
+		    key.type != BTRFS_EXTENT_ITEM_KEY) {
+			path.slots[0]++;
+			goto next;
+		}
+		if (key.objectid >= end_byte)
+			break;
+
+		cur_byte = key.objectid;
+		num_bytes = key.offset;
+		found = 0;
+		while (1) {
+			if (path.slots[0] >= btrfs_header_nritems(leaf)) {
+				ret = btrfs_next_leaf(extent_root, &path);
+				if (ret > 0)
+					break;
+				if (ret < 0)
+					goto fail;
+				leaf = path.nodes[0];
+			}
+
+			btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
+			if (key.objectid != cur_byte)
+				break;
+			if (key.type != BTRFS_EXTENT_REF_KEY) {
+				path.slots[0]++;
+				continue;
+			}
+			ref_item = btrfs_item_ptr(leaf, path.slots[0],
+						  struct btrfs_extent_ref);
+			ref_root = btrfs_ref_root(leaf, ref_item);
+			ref_owner = btrfs_ref_objectid(leaf, ref_item);
+			ref_offset = btrfs_ref_offset(leaf, ref_item);
+			num_refs++;
+
+			BUG_ON(ref_owner < BTRFS_FIRST_FREE_OBJECTID);
+			if (ref_root == cur_root->root_key.objectid)
+				found = 1;
+
+			path.slots[0]++;
+		}
+		if (!found)
+			goto next;
+
+		cur_byte += num_bytes;
+		btrfs_release_path(extent_root, &path);
+
+		ret = relocate_one_reference(trans, cur_root, ref_owner,
+					     ref_offset, &reloc_tree);
+		if (ret)
+			goto fail;
+
+		if (trans->blocks_used >= 4096) {
+			ret = btrfs_commit_transaction(trans, cur_root);
+			BUG_ON(ret);
+			trans = btrfs_start_transaction(cur_root, 1);
+			BUG_ON(!trans);
+		}
+	}
+	btrfs_release_path(cur_root, &path);
+
+	ret = btrfs_commit_transaction(trans, cur_root);
+	BUG_ON(ret);
+
+	if (num_refs > 0 && pass++ < 4)
+		goto again;
+
+	ret = (num_refs > 0) ? -1 : 0;
+fail:
+	btrfs_release_path(cur_root, &path);
+	extent_io_tree_cleanup(&reloc_tree);
+	return ret;
+}
+
+/*
+ * relocate data in system chunk
+ */
+static int cleanup_sys_chunk(struct btrfs_root *fs_root,
+			     struct btrfs_root *ext2_root)
+{
+	struct btrfs_block_group_cache *cache;
+	int ret = 0;
+	u64 offset = 0;
+	u64 end_byte;
+
+	while(1) {
+		cache = btrfs_lookup_block_group(fs_root->fs_info, offset);
+		if (!cache)
+			break;
+
+		end_byte = cache->key.objectid + cache->key.offset;
+		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+			ret = relocate_extents_range(fs_root, ext2_root,
+						     cache->key.objectid,
+						     end_byte);
+			if (ret)
+				goto fail;
+		}
+		offset = end_byte;
+	}
+fail:
+	return ret;
+}
+
+static int fixup_chunk_mapping(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_root *chunk_root = info->chunk_root;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_chunk chunk;
+	unsigned long ptr;
+	u32 size;
+	u64 type;
+	int ret;
+
+	btrfs_init_path(&path);
+
+	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(!trans);
+
+	/*
+	 * recow the whole chunk tree. this will move all chunk tree blocks
+	 * into system block group.
+	 */
+	memset(&key, 0, sizeof(key));
+	while (1) {
+		ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
+		if (ret < 0)
+			goto err;
+
+		ret = btrfs_next_leaf(chunk_root, &path);
+		if (ret < 0)
+			goto err;
+		if (ret > 0)
+			break;
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		btrfs_release_path(chunk_root, &path);
+	}
+	btrfs_release_path(chunk_root, &path);
+
+	/* fixup the system chunk array in super block */
+	btrfs_set_super_sys_array_size(&info->super_copy, 0);
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.offset = 0;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+
+	ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto err;
+	BUG_ON(ret != 0);
+	while(1) {
+		leaf = path.nodes[0];
+		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(chunk_root, &path);
+			if (ret < 0)
+				goto err;
+			if (ret > 0)
+				break;
+			leaf = path.nodes[0];
+		}
+		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
+		if (key.type != BTRFS_CHUNK_ITEM_KEY)
+			goto next;
+
+		ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
+		size = btrfs_item_size_nr(leaf, path.slots[0]);
+		BUG_ON(size != sizeof(chunk));
+		read_extent_buffer(leaf, &chunk, ptr, size);
+		type = btrfs_stack_chunk_type(&chunk);
+
+		if (!(type & BTRFS_BLOCK_GROUP_SYSTEM))
+			goto next;
+
+		ret = btrfs_add_system_chunk(trans, chunk_root, &key,
+					     &chunk, size);
+		if (ret)
+			goto err;
+next:
+		path.slots[0]++;
+	}
+
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+err:
+	btrfs_release_path(chunk_root, &path);
 	return ret;
 }
 
@@ -1570,7 +2168,7 @@ int do_convert(const char *devname, int 
 		fprintf(stderr, "filetype feature is missing\n");
 		goto fail;
 	}
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < 6; i++) {
 		ret = ext2_alloc_block(ext2_fs, 0, blocks + i);
 		if (ret) {
 			fprintf(stderr, "not enough free space\n");
@@ -1584,22 +2182,25 @@ int do_convert(const char *devname, int 
 		fprintf(stderr, "unable to open %s\n", devname);
 		goto fail;
 	}
-	ret = make_btrfs(fd, blocks, total_bytes, blocksize,
-			 blocksize, blocksize, blocksize);
+	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
+			 blocks, total_bytes, blocksize, blocksize,
+			 blocksize, blocksize);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree\n");
 		goto fail;
 	}
-	root = open_ctree_fd(fd, super_bytenr);
+	/* create a system chunk that maps the whole device */
+	ret = prepare_system_chunk(fd, super_bytenr, blocksize);
+	if (ret) {
+		fprintf(stderr, "unable to update system chunk\n");
+		goto fail;
+	}
+	root = open_ctree_fd(fd, devname, super_bytenr);
 	if (!root) {
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
 	}
-	fd = dup(fd);
-	if (fd < 0) {
-		fprintf(stderr, "unable to duplicate file descriptor\n");
-		goto fail;
-	}
+
 	root->fs_info->priv_data = ext2_fs;
 	root->fs_info->extent_ops = &extent_ops;
 	ret = init_btrfs(root);
@@ -1624,6 +2225,12 @@ int do_convert(const char *devname, int 
 		fprintf(stderr, "error during create_ext2_image %d\n", ret);
 		goto fail;
 	}
+	printf("cleaning up system chunk.\n");
+	ret = cleanup_sys_chunk(root, ext2_root);
+	if (ret) {
+		fprintf(stderr, "error during cleanup_sys_chunk %d\n", ret);
+		goto fail;
+	}
 	btrfs_free_fs_root(ext2_root->fs_info, ext2_root);
 	ret = close_ctree(root);
 	if (ret) {
@@ -1632,13 +2239,30 @@ int do_convert(const char *devname, int 
 	}
 	close_ext2fs(ext2_fs);
 
-	/* finally migrate super block to its default postion */
+	/*   
+	 * If this step succeed, we get a mountable btrfs. Otherwise
+	 * the ext2fs is left unchanged.
+	 */
 	ret = migrate_super_block(fd, super_bytenr, blocksize);
 	if (ret) {
 		fprintf(stderr, "unable to migrate super block\n");
 		goto fail;
 	}
+
+	root = open_ctree_fd(fd, devname, 0);
+	if (!root) {
+		fprintf(stderr, "unable to open ctree\n");
+		goto fail;
+	}
+	/* move chunk tree into system chunk. */ 
+	ret = fixup_chunk_mapping(root);
+	if (ret) {
+		fprintf(stderr, "error during fixup_chunk_tree\n");
+		goto fail;
+	}
+	ret = close_ctree(root);
 	close(fd);
+	
 	printf("conversion complete.\n");
 	return 0;
 fail:
@@ -1646,20 +2270,62 @@ fail:
 	return -1;
 }
 
+static int may_rollback(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_multi_bio *multi = NULL;
+	u64 bytenr;
+	u64 length;
+	u64 physical;
+	u64 total_bytes;
+	int num_stripes;
+	int ret;
+
+	if (btrfs_super_num_devices(&info->super_copy) != 1)
+		goto fail;
+
+	bytenr = BTRFS_SUPER_INFO_OFFSET;
+	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
+
+	while (1) {
+		ret = btrfs_map_block(&info->mapping_tree, WRITE, bytenr,
+				      &length, &multi, 0);
+		if (ret)
+			goto fail;
+
+		num_stripes = multi->num_stripes;
+		physical = multi->stripes[0].physical;
+		kfree(multi);
+
+		if (num_stripes != 1 || physical != bytenr)
+			goto fail;
+
+		bytenr += length;
+		if (bytenr >= total_bytes)
+			break;
+	}
+	return 0;
+fail:
+	return -1;
+}
+
 int do_rollback(const char *devname, int force)
 {
 	int fd;
 	int ret;
-	int modified = 0;
 	struct btrfs_root *root;
 	struct btrfs_root *ext2_root;
+	struct btrfs_root *chunk_root;
 	struct btrfs_dir_item *dir;
 	struct btrfs_inode_item *inode;
 	struct btrfs_file_extent_item *fi;
-	struct btrfs_timespec *tspec;
+	struct btrfs_trans_handle *trans;
 	struct extent_buffer *leaf;
+	struct btrfs_block_group_cache *cache1;
+	struct btrfs_block_group_cache *cache2;
 	struct btrfs_key key;
 	struct btrfs_path path;
+	struct extent_io_tree io_tree;
 	char *buf;
 	char *name;
 	u64 bytenr;
@@ -1667,29 +2333,33 @@ int do_rollback(const char *devname, int
 	u64 root_dir;
 	u64 objectid;
 	u64 offset;
+	u64 start;
+	u64 end;
+	u64 sb_bytenr;
 	u64 first_free;
-	u64 last_trans;
 	u64 total_bytes;
+	u32 sectorsize;
+
+	extent_io_tree_init(&io_tree);
 
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
 		fprintf(stderr, "unable to open %s\n", devname);
 		goto fail;
 	}
-	root = open_ctree_fd(fd, 0);
+	root = open_ctree_fd(fd, devname, 0);
 	if (!root) {
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
 	}
-	fd = dup(fd);
-	if (fd < 0) {
-		fprintf(stderr, "unable to duplicate file descriptor\n");
-		goto fail;
-	}
-
-	first_free = BTRFS_SUPER_INFO_OFFSET + root->sectorsize * 2 - 1;
-	first_free &= ~((u64)root->sectorsize - 1);
-	buf = malloc(first_free);
+	ret = may_rollback(root);
+	if (ret < 0) {
+		fprintf(stderr, "unable to do rollback\n");
+		goto fail;
+	}
+
+	sectorsize = root->sectorsize;
+	buf = malloc(sectorsize);
 	if (!buf) {
 		fprintf(stderr, "unable to allocate memory\n");
 		goto fail;
@@ -1735,20 +2405,8 @@ int do_rollback(const char *devname, int
 	}
 	leaf = path.nodes[0];
 	inode = btrfs_item_ptr(leaf, path.slots[0], struct btrfs_inode_item);
-	tspec = btrfs_inode_otime(inode);
-	/*
-	 * get image file size and transaction id stored in 'otime' field.
-	 * see comments in create_ext2_image.
-	 */
-	last_trans = btrfs_timespec_sec(leaf, tspec);
-	total_bytes = btrfs_timespec_nsec(leaf, tspec);
-	total_bytes *= root->sectorsize;
+	total_bytes = btrfs_inode_size(leaf, inode);
 	btrfs_release_path(ext2_root, &path);
-	if (total_bytes < first_free ||
-	    total_bytes != btrfs_inode_size(leaf, inode)) {
-		fprintf(stderr, "image file size mismatch\n");
-		goto fail;
-	}
 
 	key.objectid = objectid;
 	key.offset = 0;
@@ -1759,6 +2417,8 @@ int do_rollback(const char *devname, int
 		btrfs_release_path(ext2_root, &path);
 		goto fail;
 	}
+
+	/* build mapping tree for the relocated blocks */
 	for (offset = 0; offset < total_bytes; ) {
 		leaf = path.nodes[0];
 		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
@@ -1775,66 +2435,169 @@ int do_rollback(const char *devname, int
 
 		fi = btrfs_item_ptr(leaf, path.slots[0],
 				    struct btrfs_file_extent_item);
-		if (btrfs_file_extent_generation(leaf, fi) > last_trans) {
-			modified = 1;
-			break;
-		}
 		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
 			break;
 
-		if (offset >= first_free)
-			goto next;
-
 		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
-		if (bytenr == 0)
-			break;
+		/* skip holes and direct mapped extents */
+		if (bytenr == 0 || bytenr == offset)
+			goto next_extent;
+
 		bytenr += btrfs_file_extent_offset(leaf, fi);
 		num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
-		if (num_bytes > first_free - offset)
-			num_bytes = first_free - offset;
-
-		ret = pread(fd, buf + offset, num_bytes, bytenr);
-		if (ret != num_bytes) {
-			fprintf(stderr, "unable to read required data\n");
-			btrfs_release_path(ext2_root, &path);
-			goto fail;
-		}
-next:
+
+		cache1 = btrfs_lookup_block_group(root->fs_info, offset);
+		cache2 =  btrfs_lookup_block_group(root->fs_info, 
+						   offset + num_bytes - 1);
+		if (!cache1 || cache1 != cache2 || 
+		    !(cache1->flags & BTRFS_BLOCK_GROUP_SYSTEM))
+			break;
+
+		set_extent_bits(&io_tree, offset, offset + num_bytes - 1,
+				EXTENT_LOCKED, GFP_NOFS);
+		set_state_private(&io_tree, offset, bytenr);
+next_extent:
 		offset += btrfs_file_extent_num_bytes(leaf, fi);
 		path.slots[0]++;
 	}
 	btrfs_release_path(ext2_root, &path);
-
-	if (modified) {
-		fprintf(stderr, "image file has been modified\n");
-		goto fail;
-	}
+	btrfs_free_fs_root(ext2_root->fs_info, ext2_root);
+
 	if (offset < total_bytes) {
-		fprintf(stderr, "unable to check all file extents\n");
-		goto fail;
-	}
-
-	btrfs_free_fs_root(ext2_root->fs_info, ext2_root);
+		fprintf(stderr, "unable to build extent mapping\n");
+		goto fail;
+	}
+
+	first_free = BTRFS_SUPER_INFO_OFFSET + 2 * sectorsize - 1;
+	first_free &= ~((u64)sectorsize - 1);
+	/* backup for extent #0 should exist */
+	if(!test_range_bit(&io_tree, 0, first_free - 1, EXTENT_LOCKED, 1)) {
+		fprintf(stderr, "no backup for the first extent\n");
+		goto fail;
+	}
+	/* force no allocation from system block group */
+	root->fs_info->system_allocs = -1;
+	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(!trans);
+	/* 
+	 * recow the whole chunk tree, this will remove all chunk tree blocks
+	 * from system block group
+	 */
+	chunk_root = root->fs_info->chunk_root;
+	memset(&key, 0, sizeof(key));
+	while (1) {
+		ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
+		if (ret < 0)
+			break;
+
+		ret = btrfs_next_leaf(chunk_root, &path);
+		if (ret)
+			break;
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		btrfs_release_path(chunk_root, &path);
+	}
+	btrfs_release_path(chunk_root, &path);
+
+	offset = 0;
+	num_bytes = 0;
+	while(1) {
+		cache1 = btrfs_lookup_block_group(root->fs_info, offset);
+		if (!cache1)
+			break;
+
+		if (cache1->flags & BTRFS_BLOCK_GROUP_SYSTEM)
+			num_bytes += btrfs_block_group_used(&cache1->item);
+
+		offset = cache1->key.objectid + cache1->key.offset;
+	}
+	/* only extent #0 left in system block group? */
+	if (num_bytes > first_free) {
+		fprintf(stderr, "unable to empty system block group\n");
+		goto fail;
+	}
+	/* create a system chunk that maps the whole device */
+	ret = prepare_system_chunk_sb(&root->fs_info->super_copy);
+	if (ret) {
+		fprintf(stderr, "unable to update system chunk\n");
+		goto fail;
+	}
+
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+
 	ret = close_ctree(root);
 	if (ret) {
 		fprintf(stderr, "error during close_ctree %d\n", ret);
 		goto fail;
-	}
-
-	ret = pwrite(fd, buf, first_free, 0);
-	if (ret < 0) {
-		fprintf(stderr, "error during pwrite %d\n", ret);
-		goto fail;
-	}
-	/* How to handle this case? */
-	BUG_ON(ret != first_free);
+	}	
+
+	sb_bytenr = (u64)-1;
+	/* copy all relocated blocks back */
+	while(1) {
+		ret = find_first_extent_bit(&io_tree, 0, &start, &end,
+					    EXTENT_LOCKED);
+		if (ret)
+			break;
+
+		ret = get_state_private(&io_tree, start, &bytenr);
+		BUG_ON(ret);
+
+		clear_extent_bits(&io_tree, start, end, EXTENT_LOCKED,
+				  GFP_NOFS);
+
+		while (start <= end) {
+			if (start == BTRFS_SUPER_INFO_OFFSET) {
+				sb_bytenr = bytenr;
+				goto next_sector;
+			}
+			ret = pread(fd, buf, sectorsize, bytenr);
+			if (ret < 0) {
+				fprintf(stderr, "error during pread %d\n", ret);
+				goto fail;
+			}
+			BUG_ON(ret != sectorsize);
+			ret = pwrite(fd, buf, sectorsize, start);
+			if (ret < 0) {
+				fprintf(stderr, "error during pwrite %d\n", ret);
+				goto fail;
+			}
+			BUG_ON(ret != sectorsize);
+next_sector:
+			start += sectorsize;
+			bytenr += sectorsize;
+		}
+	}
+	
 	ret = fsync(fd);
 	if (ret) {
 		fprintf(stderr, "error during fsync %d\n", ret);
 		goto fail;
 	}
+	/*
+	 * finally, overwrite btrfs super block.
+	 */
+	ret = pread(fd, buf, sectorsize, sb_bytenr);
+	if (ret < 0) {
+		fprintf(stderr, "error during pread %d\n", ret);	
+		goto fail;
+	}
+	BUG_ON(ret != sectorsize);
+	ret = pwrite(fd, buf, sectorsize, BTRFS_SUPER_INFO_OFFSET);
+	if (ret < 0) {
+		fprintf(stderr, "error during pwrite %d\n", ret);
+		goto fail;
+	}
+	BUG_ON(ret != sectorsize);
+	ret = fsync(fd);
+	if (ret) {
+		fprintf(stderr, "error during fsync %d\n", ret);
+		goto fail;
+	}
+
 	close(fd);
 	free(buf);
+	extent_io_tree_cleanup(&io_tree);
 	printf("rollback complete.\n");
 	return 0;
 fail:
@@ -1842,23 +2605,6 @@ fail:
 	return -1;
 }
 
-static void check_mounted(const char *name)
-{
-	int mnt_flags;
-	errcode_t ret;
-
-	ret = ext2fs_check_if_mounted(name, &mnt_flags);
-	if (ret) {
-		fprintf(stderr, "ext2fs_check_if_mounted: %s\n",
-			error_message(ret));
-		exit(1);
-	}
-	if (mnt_flags & EXT2_MF_MOUNTED) {
-		fprintf(stderr, "%s is mounted\n", name);
-		exit(1);
-	}
-}
-
 static void print_usage(void)
 {
 	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] device\n");
@@ -1866,7 +2612,6 @@ static void print_usage(void)
 	printf("\t-i ignore xattrs and ACLs\n");
 	printf("\t-n disable packing of small files\n");
 	printf("\t-r roll back to ext2fs\n");
-	exit(1);
 }
 
 int main(int argc, char *argv[])
@@ -1899,12 +2644,17 @@ int main(int argc, char *argv[])
 		}
 	}
 	argc = argc - optind;
-	if (argc == 1) {
-		file = argv[optind];
-		check_mounted(file);
-	} else {
+	if (argc != 1) {
 		print_usage();
-	}
+		return 1;
+	}
+
+	file = argv[optind];
+	if (check_mounted(file)) {
+		fprintf(stderr, "%s is mounted\n", file);
+		return 1;
+	}
+
 	if (rollback) {
 		ret = do_rollback(file, 0);
 	} else {
diff -r 87f01ef6d798 ctree.h
--- a/ctree.h	Fri Apr 18 11:56:21 2008 -0400
+++ b/ctree.h	Tue Apr 22 14:23:28 2008 +0800
@@ -513,8 +513,7 @@ struct btrfs_fs_info {
 
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head space_info;
-	int fp;
-	int force_system_allocs;
+	int system_allocs;
 	void *priv_data;
 };
 
@@ -1331,6 +1330,8 @@ int btrfs_make_block_group(struct btrfs_
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
+int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root);
 u64 btrfs_hash_extent_ref(u64 root_objectid, u64 ref_generation,
 			  u64 owner, u64 owner_offset);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
diff -r 87f01ef6d798 disk-io.c
--- a/disk-io.c	Fri Apr 18 11:56:21 2008 -0400
+++ b/disk-io.c	Tue Apr 22 14:23:28 2008 +0800
@@ -457,12 +457,16 @@ struct btrfs_root *open_ctree(const char
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr)
 {
 	int fp;
+	struct btrfs_root *root;
 
 	fp = open(filename, O_CREAT | O_RDWR, 0600);
 	if (fp < 0) {
 		return NULL;
 	}
-	return open_ctree_fd(fp, filename, sb_bytenr);
+	root = open_ctree_fd(fp, filename, sb_bytenr);
+	close(fp);
+
+	return root;
 }
 
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr)
@@ -502,7 +506,6 @@ struct btrfs_root *open_ctree_fd(int fp,
 	}
 
 	memset(fs_info, 0, sizeof(*fs_info));
-	fs_info->fp = fs_devices->lowest_bdev;
 	fs_info->fs_root = root;
 	fs_info->tree_root = tree_root;
 	fs_info->extent_root = extent_root;
@@ -640,7 +643,7 @@ int write_all_supers(struct btrfs_root *
 				    (unsigned long)btrfs_device_uuid(dev_item),
 				    BTRFS_UUID_SIZE);
 		sb->fd = dev->fd;
-		sb->dev_bytenr = BTRFS_SUPER_INFO_OFFSET;
+		sb->dev_bytenr = sb->start;
 		btrfs_set_header_flag(sb, BTRFS_HEADER_FLAG_WRITTEN);
 		csum_tree_block(root, sb, 0);
 		ret = write_extent_to_disk(sb);
@@ -685,7 +688,7 @@ static int close_all_devices(struct btrf
 	list = &fs_info->fs_devices->devices;
 	list_for_each(next, list) {
 		device = list_entry(next, struct btrfs_device, dev_list);
-		// close(device->fd);
+		close(device->fd);
 	}
 	return 0;
 }
@@ -706,7 +709,6 @@ int close_ctree(struct btrfs_root *root)
 	write_ctree_super(trans, root);
 	btrfs_free_transaction(root, trans);
 	btrfs_free_block_groups(root->fs_info);
-	close(root->fs_info->fp);
 	if (root->node)
 		free_extent_buffer(root->node);
 	if (root->fs_info->extent_root->node)
diff -r 87f01ef6d798 extent-tree.c
--- a/extent-tree.c	Fri Apr 18 11:56:21 2008 -0400
+++ b/extent-tree.c	Tue Apr 22 14:23:28 2008 +0800
@@ -1624,20 +1624,27 @@ int btrfs_alloc_extent(struct btrfs_tran
 	u64 super_used, root_used;
 	u64 search_start = 0;
 	u64 alloc_profile;
+	u32 sizes[2];
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_extent_ops *ops = info->extent_ops;
-	u32 sizes[2];
 	struct btrfs_root *extent_root = info->extent_root;
 	struct btrfs_path *path;
 	struct btrfs_extent_item *extent_item;
 	struct btrfs_extent_ref *ref;
 	struct btrfs_key keys[2];
 
+	if (info->extent_ops) {
+		struct btrfs_extent_ops *ops = info->extent_ops;
+		ret = ops->alloc_extent(root, num_bytes, hint_byte, ins);
+		BUG_ON(ret);
+		goto found;
+	}
+
 	if (data) {
 		alloc_profile = info->avail_data_alloc_bits &
 			        info->data_alloc_profile;
 		data = BTRFS_BLOCK_GROUP_DATA | alloc_profile;
-	} else if (root == info->chunk_root || info->force_system_allocs) {
+	} else if ((info->system_allocs > 0 || root == info->chunk_root) &&
+		   info->system_allocs >= 0) {
 		alloc_profile = info->avail_system_alloc_bits &
 			        info->system_alloc_profile;
 		data = BTRFS_BLOCK_GROUP_SYSTEM | alloc_profile;
@@ -1660,15 +1667,12 @@ int btrfs_alloc_extent(struct btrfs_tran
 	}
 
 	WARN_ON(num_bytes < root->sectorsize);
-	if (ops && ops->alloc_extent) {
-		ret = ops->alloc_extent(root, num_bytes, hint_byte, ins);
-	} else {
-		ret = find_free_extent(trans, root, num_bytes, empty_size,
-				        search_start, search_end, hint_byte,
-					ins, trans->alloc_exclude_start,
-					trans->alloc_exclude_nr, data);
-	}
+	ret = find_free_extent(trans, root, num_bytes, empty_size,
+			       search_start, search_end, hint_byte, ins,
+			       trans->alloc_exclude_start,
+			       trans->alloc_exclude_nr, data);
 	BUG_ON(ret);
+found:
 	if (ret)
 		return ret;
 
@@ -2331,6 +2335,100 @@ int btrfs_make_block_group(struct btrfs_
 	return 0;
 }
 
+/*
+ * This is for converter use only. 
+ *
+ * In that case, we don't know where are free blocks located.
+ * Therefore all block group cache entries must be setup properly 
+ * before doing any block allocation.
+ */
+int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
+{
+	u64 total_bytes;
+	u64 cur_start;
+	u64 group_type;
+	u64 group_size;
+	u64 group_nr = 0;
+	u64 chunk_objectid;
+	int ret;
+	int bit;
+	struct btrfs_root *extent_root;
+	struct btrfs_block_group_cache *cache;
+	struct extent_io_tree *block_group_cache;
+
+	extent_root = root->fs_info->extent_root;
+	block_group_cache = &root->fs_info->block_group_cache;
+	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
+
+	cur_start = 0;
+	while (cur_start < total_bytes) {
+		if (group_nr == 0) {
+			bit = BLOCK_GROUP_SYSTEM;
+			group_type = BTRFS_BLOCK_GROUP_SYSTEM;
+		} else if (group_nr % 3 == 1) {
+			bit = BLOCK_GROUP_DATA;
+			group_type = BTRFS_BLOCK_GROUP_METADATA;
+		} else {
+			bit = BLOCK_GROUP_METADATA;
+			group_type = BTRFS_BLOCK_GROUP_DATA;
+		}
+		group_nr++;
+
+		if (group_type == BTRFS_BLOCK_GROUP_SYSTEM) {
+			group_size = 32 * 1024 * 1024;
+		} else {
+			group_size = 256 * 1024 * 1024;
+			if (total_bytes - cur_start < group_size * 5 / 4)
+				group_size = total_bytes - cur_start;
+		}
+
+		cache = kzalloc(sizeof(*cache), GFP_NOFS);
+		BUG_ON(!cache);
+
+		cache->key.objectid = cur_start;
+		cache->key.offset = group_size;
+		btrfs_set_key_type(&cache->key, BTRFS_BLOCK_GROUP_ITEM_KEY);
+
+		btrfs_set_block_group_used(&cache->item, 0);
+		btrfs_set_block_group_chunk_objectid(&cache->item,
+						     chunk_objectid);
+		btrfs_set_block_group_flags(&cache->item, group_type);
+
+		cache->flags = group_type;
+
+		ret = update_space_info(root->fs_info, group_type, group_size,
+					0, &cache->space_info);
+		BUG_ON(ret);
+		set_avail_alloc_bits(extent_root->fs_info, group_type);
+
+		set_extent_bits(block_group_cache, cur_start,
+				cur_start + group_size - 1,
+				bit | EXTENT_LOCKED, GFP_NOFS);
+		set_state_private(block_group_cache, cur_start,
+				  (unsigned long)cache);
+		cur_start += group_size;
+	}
+	/* then insert all the items */
+	cur_start = 0;
+	while(cur_start < total_bytes) {
+		cache = btrfs_lookup_block_group(root->fs_info, cur_start);
+		BUG_ON(!cache);
+
+		ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
+					sizeof(cache->item));
+		BUG_ON(ret);
+
+		finish_current_insert(trans, extent_root);
+		ret = del_pending_extents(trans, extent_root);
+		BUG_ON(ret);
+
+		cur_start = cache->key.objectid + cache->key.offset;
+	}
+	return 0;
+}
+
 u64 btrfs_hash_extent_ref(u64 root_objectid, u64 ref_generation,
 			  u64 owner, u64 owner_offset)
 {
diff -r 87f01ef6d798 extent_io.c
--- a/extent_io.c	Fri Apr 18 11:56:21 2008 -0400
+++ b/extent_io.c	Tue Apr 22 14:23:28 2008 +0800
@@ -539,6 +539,8 @@ static int free_some_buffers(struct exte
 			free_extent_buffer(eb);
 			if (tree->cache_size < cache_max)
 				break;
+		} else {
+			list_move_tail(&eb->lru, &tree->lru);
 		}
 		if (nrscan++ > 64)
 			break;
diff -r 87f01ef6d798 mkfs.c
--- a/mkfs.c	Fri Apr 18 11:56:21 2008 -0400
+++ b/mkfs.c	Tue Apr 22 14:23:28 2008 +0800
@@ -79,7 +79,7 @@ static int make_root_dir(int fd, const c
 	trans = btrfs_start_transaction(root, 1);
 	bytes_used = btrfs_super_bytes_used(&root->fs_info->super_copy);
 
-	root->fs_info->force_system_allocs = 1;
+	root->fs_info->system_allocs = 1;
 	ret = btrfs_make_block_group(trans, root, bytes_used,
 				     BTRFS_BLOCK_GROUP_SYSTEM,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
@@ -96,7 +96,7 @@ static int make_root_dir(int fd, const c
 				     chunk_start, chunk_size);
 	BUG_ON(ret);
 
-	root->fs_info->force_system_allocs = 0;
+	root->fs_info->system_allocs = 0;
 	btrfs_commit_transaction(trans, root);
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
diff -r 87f01ef6d798 utils.c
--- a/utils.c	Fri Apr 18 11:56:21 2008 -0400
+++ b/utils.c	Tue Apr 22 14:23:28 2008 +0800
@@ -54,7 +54,7 @@ static u64 reference_root_table[6] = {
 	[5] =	BTRFS_FS_TREE_OBJECTID,
 };
 
-int make_btrfs(int fd, char *device_name, char *label,
+int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize)
 {
diff -r 87f01ef6d798 utils.h
--- a/utils.h	Fri Apr 18 11:56:21 2008 -0400
+++ b/utils.h	Tue Apr 22 14:23:28 2008 +0800
@@ -21,7 +21,7 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
-int make_btrfs(int fd, char *device_name, char *label,
+int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
diff -r 87f01ef6d798 volumes.c
--- a/volumes.c	Fri Apr 18 11:56:21 2008 -0400
+++ b/volumes.c	Tue Apr 22 14:23:28 2008 +0800
@@ -141,7 +141,8 @@ int btrfs_close_devices(struct btrfs_fs_
 
 	list_for_each(cur, head) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		device->fd = 0;
+		close(device->fd);
+		device->fd = -1;
 	}
 	return 0;
 }
diff -r 87f01ef6d798 volumes.h
--- a/volumes.h	Fri Apr 18 11:56:21 2008 -0400
+++ b/volumes.h	Tue Apr 22 14:23:28 2008 +0800
@@ -103,10 +103,15 @@ int btrfs_add_device(struct btrfs_trans_
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
+int btrfs_update_device(struct btrfs_trans_handle *trans,
+			struct btrfs_device *device);
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
 			  u64 *total_devs, u64 super_offset);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 			      struct btrfs_fs_devices *fs_devices);
+int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, struct btrfs_key *key,
+			   struct btrfs_chunk *chunk, int item_size);
 #endif
