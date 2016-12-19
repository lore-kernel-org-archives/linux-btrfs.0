Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52330 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753331AbcLSG5H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 01:57:07 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 25E5241B4BDE
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 14:56:52 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/6] btrfs-progs: convert: Switch to new rollback function
Date: Mon, 19 Dec 2016 14:56:41 +0800
Message-Id: <20161219065642.25078-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have the whole facilities needed to rollback, switch to the new
rollback.

The new rollback function can handle the following things that old
rollback either can't handle or just refuse to rollback:

1) New converted btrfs which allocates new data chunk
   This is due to the too restrict may_roll_back() condition, which is
   never a good friend for new convert behavior.

   The new rollback behavior fixes it by not checking data chunks, but
   only to check the file extents of the convert image file.

   If all file extents except the ones in reserved ranges, then we allow
   rollback.

2) New converted btrfs which enabled NO_HOLES feature
   Thanks to previous patches, we can convert to real NO_HOLES btrfs.

   And since old rollback assumes that file extents and holes covers the
   whole image file, it will fail due to the non-exists holes.

   Fix it by iterating file extents of convert image, and only compare
   the size we checked against file size if NO_HOLES is not enabled.

And makes rollback function simpler:

1) Read-n-write vs extra chunk tree relocation
   Since converted btrfs only has 3 ranges that are not 1:1 mapped, just
   read this data out, and close btrfs, finally write them into position
   will be good enough, for both new convert and old convert.
   (To be more specific, old convert is just a subset of more universal
    new convert behavior)

   No extra work is needed any more, and we can even open the btrfs RO.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 527 ++++++---------------------------------------------------
 1 file changed, 52 insertions(+), 475 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 5b9141b..3ff864b 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1421,36 +1421,6 @@ fail:
 	return ret;
 }
 
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
 #if BTRFSCONVERT_EXT2
 
 /*
@@ -2557,131 +2527,6 @@ fail:
 }
 
 /*
- * Check if a non 1:1 mapped chunk can be rolled back.
- * For new convert, it's OK while for old convert it's not.
- */
-static int may_rollback_chunk(struct btrfs_fs_info *fs_info, u64 bytenr)
-{
-	struct btrfs_block_group_cache *bg;
-	struct btrfs_key key;
-	struct btrfs_path path;
-	struct btrfs_root *extent_root = fs_info->extent_root;
-	u64 bg_start;
-	u64 bg_end;
-	int ret;
-
-	bg = btrfs_lookup_first_block_group(fs_info, bytenr);
-	if (!bg)
-		return -ENOENT;
-	bg_start = bg->key.objectid;
-	bg_end = bg->key.objectid + bg->key.offset;
-
-	key.objectid = bg_end;
-	key.type = BTRFS_METADATA_ITEM_KEY;
-	key.offset = 0;
-	btrfs_init_path(&path);
-
-	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
-	if (ret < 0)
-		return ret;
-
-	while (1) {
-		struct btrfs_extent_item *ei;
-
-		ret = btrfs_previous_extent_item(extent_root, &path, bg_start);
-		if (ret > 0) {
-			ret = 0;
-			break;
-		}
-		if (ret < 0)
-			break;
-
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		if (key.type == BTRFS_METADATA_ITEM_KEY)
-			continue;
-		/* Now it's EXTENT_ITEM_KEY only */
-		ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
-				    struct btrfs_extent_item);
-		/*
-		 * Found data extent, means this is old convert must follow 1:1
-		 * mapping.
-		 */
-		if (btrfs_extent_flags(path.nodes[0], ei)
-				& BTRFS_EXTENT_FLAG_DATA) {
-			ret = -EINVAL;
-			break;
-		}
-	}
-	btrfs_release_path(&path);
-	return ret;
-}
-
-static int may_rollback(struct btrfs_root *root)
-{
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_multi_bio *multi = NULL;
-	u64 bytenr;
-	u64 length;
-	u64 physical;
-	u64 total_bytes;
-	int num_stripes;
-	int ret;
-
-	if (btrfs_super_num_devices(info->super_copy) != 1)
-		goto fail;
-
-	bytenr = BTRFS_SUPER_INFO_OFFSET;
-	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
-
-	while (1) {
-		ret = btrfs_map_block(&info->mapping_tree, WRITE, bytenr,
-				      &length, &multi, 0, NULL);
-		if (ret) {
-			if (ret == -ENOENT) {
-				/* removed block group at the tail */
-				if (length == (u64)-1)
-					break;
-
-				/* removed block group in the middle */
-				goto next;
-			}
-			goto fail;
-		}
-
-		num_stripes = multi->num_stripes;
-		physical = multi->stripes[0].physical;
-		free(multi);
-
-		if (num_stripes != 1) {
-			error("num stripes for bytenr %llu is not 1", bytenr);
-			goto fail;
-		}
-
-		/*
-		 * Extra check for new convert, as metadata chunk from new
-		 * convert is much more free than old convert, it doesn't need
-		 * to do 1:1 mapping.
-		 */
-		if (physical != bytenr) {
-			/*
-			 * Check if it's a metadata chunk and has only metadata
-			 * extent.
-			 */
-			ret = may_rollback_chunk(info, bytenr);
-			if (ret < 0)
-				goto fail;
-		}
-next:
-		bytenr += length;
-		if (bytenr >= total_bytes)
-			break;
-	}
-	return 0;
-fail:
-	return -1;
-}
-
-/*
  * Check if [start, start + len) is a subset of btrfs reserved ranges
  */
 static int is_range_subset_of_reserved_ranges(u64 start, u64 len)
@@ -2998,352 +2843,84 @@ static int check_rollback(struct btrfs_fs_info *fs_info, char *reloc_ranges[3])
 static int do_rollback(const char *devname)
 {
 	int fd = -1;
+	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
+	char *reloc_ranges[3] = { NULL };
+	off_t fsize;
 	int ret;
 	int i;
-	struct btrfs_root *root;
-	struct btrfs_root *image_root;
-	struct btrfs_root *chunk_root;
-	struct btrfs_dir_item *dir;
-	struct btrfs_inode_item *inode;
-	struct btrfs_file_extent_item *fi;
-	struct btrfs_trans_handle *trans;
-	struct extent_buffer *leaf;
-	struct btrfs_block_group_cache *cache1;
-	struct btrfs_block_group_cache *cache2;
-	struct btrfs_key key;
-	struct btrfs_path path;
-	struct extent_io_tree io_tree;
-	char *buf = NULL;
-	char *name;
-	u64 bytenr;
-	u64 num_bytes;
-	u64 root_dir;
-	u64 objectid;
-	u64 offset;
-	u64 start;
-	u64 end;
-	u64 sb_bytenr;
-	u64 first_free;
-	u64 total_bytes;
-	u32 sectorsize;
 
-	extent_io_tree_init(&io_tree);
+	for (i = 0; i < ARRAY_SIZE(reserved_range_starts); i++) {
+		reloc_ranges[i] = calloc(1, reserved_range_lens[i]);
+		if (!reloc_ranges[i]) {
+			ret = -ENOMEM;
+			goto free_mem;
+		}
+	}
 
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
 		error("unable to open %s: %s", devname, strerror(errno));
+		ret = -errno;
 		goto fail;
 	}
-	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
+
+	fsize = lseek(fd, 0, SEEK_END);
+	root = open_ctree_fd(fd, devname, 0, 0);
 	if (!root) {
 		error("unable to open ctree");
+		ret = -EIO;
 		goto fail;
 	}
-	ret = may_rollback(root);
-	if (ret < 0) {
-		error("unable to do rollback: %d", ret);
-		goto fail;
-	}
-
-	sectorsize = root->sectorsize;
-	buf = malloc(sectorsize);
-	if (!buf) {
-		error("unable to allocate memory");
-		goto fail;
-	}
-
-	btrfs_init_path(&path);
-
-	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
-	key.type = BTRFS_ROOT_BACKREF_KEY;
-	key.offset = BTRFS_FS_TREE_OBJECTID;
-	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path, 0,
-				0);
-	btrfs_release_path(&path);
-	if (ret > 0) {
-		error("unable to convert ext2 image subvolume, is it deleted?");
-		goto fail;
-	} else if (ret < 0) {
-		error("unable to open ext2_saved, id %llu: %s",
-			(unsigned long long)key.objectid, strerror(-ret));
-		goto fail;
-	}
-
-	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
-	key.type = BTRFS_ROOT_ITEM_KEY;
-	key.offset = (u64)-1;
-	image_root = btrfs_read_fs_root(root->fs_info, &key);
-	if (!image_root || IS_ERR(image_root)) {
-		error("unable to open subvolume %llu: %ld",
-			(unsigned long long)key.objectid, PTR_ERR(image_root));
-		goto fail;
-	}
-
-	name = "image";
-	root_dir = btrfs_root_dirid(&root->root_item);
-	dir = btrfs_lookup_dir_item(NULL, image_root, &path,
-				   root_dir, name, strlen(name), 0);
-	if (!dir || IS_ERR(dir)) {
-		error("unable to find file %s: %ld", name, PTR_ERR(dir));
-		goto fail;
-	}
-	leaf = path.nodes[0];
-	btrfs_dir_item_key_to_cpu(leaf, dir, &key);
-	btrfs_release_path(&path);
-
-	objectid = key.objectid;
-
-	ret = btrfs_lookup_inode(NULL, image_root, &path, &key, 0);
-	if (ret) {
-		error("unable to find inode item: %d", ret);
-		goto fail;
-	}
-	leaf = path.nodes[0];
-	inode = btrfs_item_ptr(leaf, path.slots[0], struct btrfs_inode_item);
-	total_bytes = btrfs_inode_size(leaf, inode);
-	btrfs_release_path(&path);
-
-	key.objectid = objectid;
-	key.offset = 0;
-	key.type = BTRFS_EXTENT_DATA_KEY;
-	ret = btrfs_search_slot(NULL, image_root, &key, &path, 0, 0);
-	if (ret != 0) {
-		error("unable to find first file extent: %d", ret);
-		btrfs_release_path(&path);
-		goto fail;
-	}
-
-	/* build mapping tree for the relocated blocks */
-	for (offset = 0; offset < total_bytes; ) {
-		leaf = path.nodes[0];
-		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(root, &path);
-			if (ret != 0)
-				break;	
-			continue;
-		}
-
-		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
-		if (key.objectid != objectid || key.offset != offset ||
-		    key.type != BTRFS_EXTENT_DATA_KEY)
-			break;
-
-		fi = btrfs_item_ptr(leaf, path.slots[0],
-				    struct btrfs_file_extent_item);
-		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
-			break;
-		if (btrfs_file_extent_compression(leaf, fi) ||
-		    btrfs_file_extent_encryption(leaf, fi) ||
-		    btrfs_file_extent_other_encoding(leaf, fi))
-			break;
+	fs_info = root->fs_info;
 
-		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
-		/* skip holes and direct mapped extents */
-		if (bytenr == 0 || bytenr == offset)
-			goto next_extent;
-
-		bytenr += btrfs_file_extent_offset(leaf, fi);
-		num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
-
-		cache1 = btrfs_lookup_block_group(root->fs_info, offset);
-		cache2 = btrfs_lookup_block_group(root->fs_info,
-						  offset + num_bytes - 1);
-		/*
-		 * Here we must take consideration of old and new convert
-		 * behavior.
-		 * For old convert case, sign, there is no consist chunk type
-		 * that will cover the extent. META/DATA/SYS are all possible.
-		 * Just ensure relocate one is in SYS chunk.
-		 * For new convert case, they are all covered by DATA chunk.
-		 *
-		 * So, there is not valid chunk type check for it now.
-		 */
-		if (cache1 != cache2)
-			break;
-
-		set_extent_bits(&io_tree, offset, offset + num_bytes - 1,
-				EXTENT_LOCKED, GFP_NOFS);
-		set_state_private(&io_tree, offset, bytenr);
-next_extent:
-		offset += btrfs_file_extent_num_bytes(leaf, fi);
-		path.slots[0]++;
-	}
-	btrfs_release_path(&path);
-
-	if (offset < total_bytes) {
-		error("unable to build extent mapping (offset %llu, total_bytes %llu)",
-				(unsigned long long)offset,
-				(unsigned long long)total_bytes);
-		error("converted filesystem after balance is unable to rollback");
+	/* Check if we can rollback, and collect relocated data */
+	ret = check_rollback(fs_info, reloc_ranges);
+	close_ctree(root);
+	if (ret < 0)
 		goto fail;
-	}
 
-	first_free = BTRFS_SUPER_INFO_OFFSET + 2 * sectorsize - 1;
-	first_free &= ~((u64)sectorsize - 1);
-	/* backup for extent #0 should exist */
-	if(!test_range_bit(&io_tree, 0, first_free - 1, EXTENT_LOCKED, 1)) {
-		error("no backup for the first extent");
-		goto fail;
-	}
-	/* force no allocation from system block group */
-	root->fs_info->system_allocs = -1;
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		error("unable to start transaction");
-		goto fail;
-	}
 	/*
-	 * recow the whole chunk tree, this will remove all chunk tree blocks
-	 * from system block group
+	 * Reloc data are saved in reloc_ranges, just pwrite them
+	 *
+	 * And write from backup roots, so if things goes wrong, we still
+	 * have a mountable btrfs
 	 */
-	chunk_root = root->fs_info->chunk_root;
-	memset(&key, 0, sizeof(key));
-	while (1) {
-		ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
-		if (ret < 0)
-			break;
+	for (i = 2; i >= 0; i--) {
+		u64 real_size;
 
-		ret = btrfs_next_leaf(chunk_root, &path);
-		if (ret)
-			break;
-
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		btrfs_release_path(&path);
-	}
-	btrfs_release_path(&path);
-
-	offset = 0;
-	num_bytes = 0;
-	while(1) {
-		cache1 = btrfs_lookup_block_group(root->fs_info, offset);
-		if (!cache1)
-			break;
-
-		if (cache1->flags & BTRFS_BLOCK_GROUP_SYSTEM)
-			num_bytes += btrfs_block_group_used(&cache1->item);
-
-		offset = cache1->key.objectid + cache1->key.offset;
-	}
-	/* only extent #0 left in system block group? */
-	if (num_bytes > first_free) {
-		error(
-	"unable to empty system block group (num_bytes %llu, first_free %llu",
-				(unsigned long long)num_bytes,
-				(unsigned long long)first_free);
-		goto fail;
-	}
-	/* create a system chunk that maps the whole device */
-	ret = prepare_system_chunk_sb(root->fs_info->super_copy);
-	if (ret) {
-		error("unable to update system chunk: %d", ret);
-		goto fail;
-	}
-
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret) {
-		error("transaction commit failed: %d", ret);
-		goto fail;
-	}
-
-	ret = close_ctree(root);
-	if (ret) {
-		error("close_ctree failed: %d", ret);
-		goto fail;
-	}
-
-	/* zero btrfs super block mirrors */
-	memset(buf, 0, sectorsize);
-	for (i = 1 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
-		if (bytenr >= total_bytes)
-			break;
-		ret = pwrite(fd, buf, sectorsize, bytenr);
-		if (ret != sectorsize) {
-			error("zeroing superblock mirror %d failed: %d",
-					i, ret);
+		if (reserved_range_starts[i] > fsize)
+			continue;
+		real_size = min(reserved_range_starts[i] +
+				reserved_range_lens[i], (u64)fsize) -
+			    reserved_range_starts[i];
+		ret = pwrite(fd, reloc_ranges[i], real_size,
+			     reserved_range_starts[i]);
+		if (ret != real_size) {
+			if (ret < 0)
+				ret = -errno;
+			else
+				ret = -EIO;
+			error(
+			"failed to recover reserved range [%llu, %llu): %s",
+				reserved_range_starts[i],
+				reserved_range_starts[i] + real_size,
+				strerror(-ret));
 			goto fail;
 		}
+		ret = 0;
 	}
-
-	sb_bytenr = (u64)-1;
-	/* copy all relocated blocks back */
-	while(1) {
-		ret = find_first_extent_bit(&io_tree, 0, &start, &end,
-					    EXTENT_LOCKED);
-		if (ret)
-			break;
-
-		ret = get_state_private(&io_tree, start, &bytenr);
-		BUG_ON(ret);
-
-		clear_extent_bits(&io_tree, start, end, EXTENT_LOCKED,
-				  GFP_NOFS);
-
-		while (start <= end) {
-			if (start == BTRFS_SUPER_INFO_OFFSET) {
-				sb_bytenr = bytenr;
-				goto next_sector;
-			}
-			ret = pread(fd, buf, sectorsize, bytenr);
-			if (ret < 0) {
-				error("reading superblock at %llu failed: %d",
-						(unsigned long long)bytenr, ret);
-				goto fail;
-			}
-			BUG_ON(ret != sectorsize);
-			ret = pwrite(fd, buf, sectorsize, start);
-			if (ret < 0) {
-				error("writing superblock at %llu failed: %d",
-						(unsigned long long)start, ret);
-				goto fail;
-			}
-			BUG_ON(ret != sectorsize);
-next_sector:
-			start += sectorsize;
-			bytenr += sectorsize;
-		}
-	}
-
-	ret = fsync(fd);
-	if (ret < 0) {
-		error("fsync failed: %s", strerror(errno));
-		goto fail;
-	}
-	/*
-	 * finally, overwrite btrfs super block.
-	 */
-	ret = pread(fd, buf, sectorsize, sb_bytenr);
-	if (ret < 0) {
-		error("reading primary superblock failed: %s",
-				strerror(errno));
-		goto fail;
-	}
-	BUG_ON(ret != sectorsize);
-	ret = pwrite(fd, buf, sectorsize, BTRFS_SUPER_INFO_OFFSET);
-	if (ret < 0) {
-		error("writing primary superblock failed: %s",
-				strerror(errno));
-		goto fail;
-	}
-	BUG_ON(ret != sectorsize);
-	ret = fsync(fd);
-	if (ret < 0) {
-		error("fsync failed: %s", strerror(errno));
-		goto fail;
-	}
-
-	close(fd);
-	free(buf);
-	extent_io_tree_cleanup(&io_tree);
 	printf("rollback complete\n");
-	return 0;
-
 fail:
 	if (fd != -1)
 		close(fd);
-	free(buf);
-	error("rollback aborted");
-	return -1;
+free_mem:
+	for (i = 0; i < ARRAY_SIZE(reserved_range_starts); i++)
+		free(reloc_ranges[i]);
+
+	if (ret < 0)
+		error("rollback aborted");
+	return ret;
 }
 
 static void print_usage(void)
-- 
2.10.2



