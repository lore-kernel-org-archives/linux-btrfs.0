From: Yan Zheng <yanzheng@21cn.com>
Subject: [Btrfs-devel][PATCH] Speed improvement and bug fixes for ext3 converter.
Date: Wed, 23 Apr 2008 22:10:01 +0800
Message-ID: <480F4339.6050305__45365.3612676591$1208965726$gmane$org@21cn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch improves converter's allocator and fixes a bug in data relocation
function. The new allocator caches free blocks as Btrfs's default allocator.
In testing here, the user CPU time reduced to half of the original when 
checksum and small file packing was disabled. This patch also enlarges the 
size of block groups created by the converter.

Regards
YZ
---
diff -r d0e7ffc98bd7 convert.c
--- a/convert.c	Tue Apr 22 14:30:52 2008 -0400
+++ b/convert.c	Wed Apr 23 21:49:14 2008 +0800
@@ -16,7 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
+#define _XOPEN_SOURCE 600
+#define _GNU_SOURCE 1
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
@@ -97,47 +98,75 @@ static int ext2_free_block(ext2_filsys f
 	return 0;
 }
 
+static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
+			      
+{
+	int ret = 0;
+	blk_t block;
+	u64 bytenr;
+	u64 blocksize = ext2_fs->blocksize;
+
+	block = ext2_fs->super->s_first_data_block;
+	for (; block < ext2_fs->super->s_blocks_count; block++) {
+		if (ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block)) 
+			continue;
+		bytenr = block * blocksize;
+		ret = set_extent_dirty(&root->fs_info->free_space_cache, 
+				       bytenr, bytenr + blocksize - 1, 0);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
 static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 			       u64 hint_byte, struct btrfs_key *ins)
 {
+	u64 start;
+	u64 end;
+	u64 last = hint_byte;
+	int ret;
+	int wrapped = 0;
 	struct btrfs_block_group_cache *cache;
-	ext2_filsys ext2_fs = (ext2_filsys)root->fs_info->priv_data;
-	u32 blocksize = ext2_fs->blocksize;
-	u64 bytenr;
-	blk_t block;
-	int wrapped = 0;
-	int ret;
-
-	while (1) {
-		block = hint_byte / blocksize;
-		ret = ext2fs_new_block(ext2_fs, block, NULL, &block);
-		if (ret)
-			goto fail;
-
-		bytenr = (u64)block * blocksize;
-		if (bytenr < hint_byte && ++wrapped > 1)
-			goto fail;
-
-		cache = btrfs_lookup_block_group(root->fs_info, bytenr);
+
+	while(1) {
+		ret = find_first_extent_bit(&root->fs_info->free_space_cache,
+					    last, &start, &end, EXTENT_DIRTY);
+		if (ret) {
+			if (wrapped++ == 0) {
+				last = 0;
+				continue;
+			} else {
+				goto fail;
+			}
+		}
+
+		start = max(last, start);
+		last = end + 1;
+		if (last - start < num_bytes)
+			continue;
+
+		last = start + num_bytes;
+		if (test_range_bit(&root->fs_info->pinned_extents, 
+				   start, last - 1, EXTENT_DIRTY, 0))
+			continue;
+
+		cache = btrfs_lookup_block_group(root->fs_info, start);
 		BUG_ON(!cache);
-		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-			hint_byte = cache->key.objectid + cache->key.offset;
+		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM || 
+		    last > cache->key.objectid + cache->key.offset) {
+			last = cache->key.objectid + cache->key.offset;
 			continue;
 		}
 
-		if (test_range_bit(&root->fs_info->pinned_extents, bytenr,
-				   bytenr + blocksize - 1, EXTENT_DIRTY, 0)) {
-			hint_byte = bytenr + blocksize;
-			continue;
-		}
-
-		ext2fs_fast_mark_block_bitmap(ext2_fs->block_map, block);
-		break;
-	}
-	ins->objectid = bytenr;
-	ins->offset = blocksize;
-	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
-	return 0;
+		clear_extent_dirty(&root->fs_info->free_space_cache,
+				   start, start + num_bytes - 1, 0);
+	
+		ins->objectid = start;
+		ins->offset = num_bytes;
+		ins->type = BTRFS_EXTENT_ITEM_KEY;
+		return 0;
+	}
 fail:
 	fprintf(stderr, "not enough free space\n");
 	return -ENOSPC;
@@ -146,16 +175,6 @@ static int custom_free_extent(struct btr
 static int custom_free_extent(struct btrfs_root *root, u64 bytenr,
 			      u64 num_bytes)
 {
-	u64 block;
-	ext2_filsys fs = (ext2_filsys)root->fs_info->priv_data;
-
-	BUG_ON(bytenr & (fs->blocksize - 1));
-	block = bytenr / fs->blocksize;
-	while (num_bytes > 0) {
-		ext2_free_block(fs, block);
-		block++;
-		num_bytes -= fs->blocksize;
-	}
 	return 0;
 }
 
@@ -1054,35 +1073,6 @@ static int copy_inodes(struct btrfs_root
 	return ret;
 }
 
-static int lookup_extent_item(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     u64 bytenr, u64 num_bytes)
-{
-	int ret;
-	struct btrfs_key key;
-	struct btrfs_path path;
-
-	btrfs_init_path(&path);
-	key.objectid = bytenr;
-	key.offset = (u64)-1;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	ret = btrfs_search_slot(trans, root->fs_info->extent_root,
-				&key, &path, 0, 0);
-	if (ret < 0)
-		goto out;
-	BUG_ON(ret == 0);
-
-	ret = btrfs_previous_item(root, &path, 0, BTRFS_EXTENT_ITEM_KEY);
-	if (ret != 0)
-		goto out;
-
-	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-	if (key.objectid + key.offset < bytenr + num_bytes)
-		ret = 1;
-out:
-	btrfs_release_path(root, &path);
-	return ret;
-}
 /*
  * Construct a range of ext2fs image file.
  * scan block allocation bitmap, find all blocks used by the ext2fs
@@ -1097,7 +1087,6 @@ static int create_image_file_range(struc
 				   u64 start_byte, u64 end_byte,
 				   ext2_filsys ext2_fs)
 {
-	u64 bytenr;
 	u32 blocksize = ext2_fs->blocksize;
 	u32 block = start_byte / blocksize;
 	u32 last_block = (end_byte + blocksize - 1) / blocksize;
@@ -1117,14 +1106,6 @@ static int create_image_file_range(struc
 	for (; start_byte < end_byte; block++, start_byte += blocksize) {
 		if (!ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block))
 			continue;
-		/* the bit may be set by us, check extent tree */
-		bytenr = (u64)block * blocksize;
-		ret = lookup_extent_item(trans, root, bytenr, blocksize);
-		if (ret < 0)
-			goto fail;
-		if (ret == 0)
-			continue;
-
 		ret = block_iterate_proc(NULL, block, block, &data);
 		if (ret & BLOCK_ABORT) {
 			ret = data.errcode;
@@ -1756,6 +1737,7 @@ fail:
 
 static int relocate_one_reference(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
+				  u64 extent_start, u64 extent_size,
 				  u64 objectid, u64 offset,
 				  struct extent_io_tree *reloc_tree)
 {
@@ -1768,8 +1750,6 @@ static int relocate_one_reference(struct
 	u64 bytenr;
 	u64 num_bytes;
 	u64 cur_offset;
-	u64 extent_start;
-	u64 extent_size;
 	u64 new_pos;
 	u64 nblocks;
 	u64 root_gen;
@@ -1777,9 +1757,34 @@ static int relocate_one_reference(struct
 	u64 sector_end;
 	u32 sectorsize = root->sectorsize;
 	unsigned long ptr;
+	int fd;
 	int ret;
 
 	btrfs_init_path(&path);
+	ret = btrfs_lookup_file_extent(trans, root, &path, 
+				       objectid, offset, -1);
+	if (ret)
+		goto fail;
+
+	leaf = path.nodes[0];
+	fi = btrfs_item_ptr(leaf, path.slots[0],
+			    struct btrfs_file_extent_item);
+	/* the extent may be referenced by old snapshot */
+	if (extent_start != btrfs_file_extent_disk_bytenr(leaf, fi) ||
+	    extent_size != btrfs_file_extent_disk_num_bytes(leaf, fi)) {
+		ret = 1;
+		goto fail;
+	}
+
+	root_gen = btrfs_header_generation(leaf);
+	root_owner = btrfs_header_owner(leaf);
+	bytenr = extent_start + btrfs_file_extent_offset(leaf, fi);
+	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+	
+	ret = btrfs_del_item(trans, root, &path);
+	if (ret)
+		goto fail;
+	btrfs_release_path(root, &path);
 
 	key.objectid = objectid;
 	key.offset = 0;
@@ -1791,28 +1796,6 @@ static int relocate_one_reference(struct
 	leaf = path.nodes[0];
 	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
 	read_extent_buffer(leaf, &inode, ptr, sizeof(inode));
-	btrfs_release_path(root, &path);
-
-	ret = btrfs_lookup_file_extent(trans, root, &path,
-				       objectid, offset, -1);
-	if (ret)
-		goto fail;
-
-	leaf = path.nodes[0];
-	fi = btrfs_item_ptr(leaf, path.slots[0],
-			    struct btrfs_file_extent_item);
-
-	root_gen = btrfs_header_generation(leaf);
-	root_owner = btrfs_header_owner(leaf);
-
-	extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
-	extent_size = btrfs_file_extent_disk_num_bytes(leaf, fi);
-	bytenr = extent_start + btrfs_file_extent_offset(leaf, fi);
-	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
-
-	ret = btrfs_del_item(trans, root, &path);
-	if (ret)
-		goto fail;
 	btrfs_release_path(root, &path);
 
 	BUG_ON(num_bytes & (sectorsize - 1));
@@ -1844,6 +1827,11 @@ static int relocate_one_reference(struct
 			if (ret)
 				goto fail;
 			new_pos = key.objectid;
+
+			if (cur_offset == offset) {
+				fd = root->fs_info->fs_devices->latest_bdev;
+				readahead(fd, bytenr, num_bytes);
+			}
 			ret = copy_disk_extent(root, new_pos, bytenr,
 					       sectorsize);
 			if (ret)
@@ -1984,21 +1972,23 @@ next:
 			num_refs++;
 
 			BUG_ON(ref_owner < BTRFS_FIRST_FREE_OBJECTID);
-			if (ref_root == cur_root->root_key.objectid)
+			if (ref_root == cur_root->root_key.objectid) {
 				found = 1;
-
+				break;
+			}
 			path.slots[0]++;
 		}
 		if (!found)
 			goto next;
 
+		ret = relocate_one_reference(trans, cur_root, cur_byte,
+					     num_bytes, ref_owner,
+					     ref_offset, &reloc_tree);
+		if (ret < 0)
+			goto fail;
+
 		cur_byte += num_bytes;
 		btrfs_release_path(extent_root, &path);
-
-		ret = relocate_one_reference(trans, cur_root, ref_owner,
-					     ref_offset, &reloc_tree);
-		if (ret)
-			goto fail;
 
 		if (trans->blocks_used >= 4096) {
 			ret = btrfs_commit_transaction(trans, cur_root);
@@ -2200,9 +2190,17 @@ int do_convert(const char *devname, int 
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
 	}
-
-	root->fs_info->priv_data = ext2_fs;
+	ret = cache_free_extents(root, ext2_fs);
+	if (ret) {
+		fprintf(stderr, "error during cache_free_extents %d\n", ret);
+		goto fail;
+	}
 	root->fs_info->extent_ops = &extent_ops;
+	/* recover block allocation bitmap */
+	for (i = 0; i < 6; i++) {
+		blocks[i] /= blocksize; 
+		ext2_free_block(ext2_fs, blocks[i]);
+	}
 	ret = init_btrfs(root);
 	if (ret) {
 		fprintf(stderr, "unable to setup the root tree\n");
@@ -2641,6 +2639,7 @@ int main(int argc, char *argv[])
 				break;
 			default:
 				print_usage();
+				return 1;
 		}
 	}
 	argc = argc - optind;
diff -r d0e7ffc98bd7 ctree.h
--- a/ctree.h	Tue Apr 22 14:30:52 2008 -0400
+++ b/ctree.h	Wed Apr 23 21:49:14 2008 +0800
@@ -514,7 +514,6 @@ struct btrfs_fs_info {
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head space_info;
 	int system_allocs;
-	void *priv_data;
 };
 
 /*
diff -r d0e7ffc98bd7 extent-tree.c
--- a/extent-tree.c	Tue Apr 22 14:30:52 2008 -0400
+++ b/extent-tree.c	Wed Apr 23 21:49:14 2008 +0800
@@ -2349,7 +2349,9 @@ int btrfs_make_block_groups(struct btrfs
 	u64 cur_start;
 	u64 group_type;
 	u64 group_size;
-	u64 group_nr = 0;
+	u64 group_align;
+	u64 total_data = 0;
+	u64 total_metadata = 0;
 	u64 chunk_objectid;
 	int ret;
 	int bit;
@@ -2361,26 +2363,33 @@ int btrfs_make_block_groups(struct btrfs
 	block_group_cache = &root->fs_info->block_group_cache;
 	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
+	group_align = 64 * root->sectorsize;
 
 	cur_start = 0;
 	while (cur_start < total_bytes) {
-		if (group_nr == 0) {
+		group_size = total_bytes / 12;
+		group_size = min_t(u64, group_size, total_bytes - cur_start);
+		if (cur_start == 0) {
 			bit = BLOCK_GROUP_SYSTEM;
 			group_type = BTRFS_BLOCK_GROUP_SYSTEM;
-		} else if (group_nr % 3 == 1) {
-			bit = BLOCK_GROUP_DATA;
-			group_type = BTRFS_BLOCK_GROUP_METADATA;
+			group_size /= 4;
+			group_size &= ~(group_align - 1);
+			group_size = max_t(u64, group_size, 32 * 1024 * 1024);
+			group_size = min_t(u64, group_size, 128 * 1024 * 1024);
 		} else {
-			bit = BLOCK_GROUP_METADATA;
-			group_type = BTRFS_BLOCK_GROUP_DATA;
-		}
-		group_nr++;
-
-		if (group_type == BTRFS_BLOCK_GROUP_SYSTEM) {
-			group_size = 32 * 1024 * 1024;
-		} else {
-			group_size = 256 * 1024 * 1024;
-			if (total_bytes - cur_start < group_size * 5 / 4)
+			group_size &= ~(group_align - 1);
+			if (total_data >= total_metadata * 2) {
+				group_type = BTRFS_BLOCK_GROUP_METADATA;
+				group_size = min_t(u64, group_size,
+						   1ULL * 1024 * 1024 * 1024);
+				total_metadata += group_size;
+			} else {
+				group_type = BTRFS_BLOCK_GROUP_DATA;
+				group_size = min_t(u64, group_size,
+						   5ULL * 1024 * 1024 * 1024);
+				total_data += group_size;
+			}
+			if ((total_bytes - cur_start) * 4 < group_size * 5)
 				group_size = total_bytes - cur_start;
 		}
 
