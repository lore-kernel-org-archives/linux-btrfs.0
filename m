Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62619 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750869AbdCNIFY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:05:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 7/7] btrfs-progs: convert: Rework rollback
Date: Tue, 14 Mar 2017 16:05:09 +0800
Message-ID: <20170314080509.31163-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rework rollback to a more easy to understand way.

New convert behavior makes us to have a more flex chunk layout, which
only data chunk containing old fs data will be at the same physical
location, while new chunks (data/meta/sys) can be mapped anywhere else.

This behavior makes old rollback behavior can't handle it.
As old behavior assumes all data/meta is mapped in a large chunk, which is
mapped 1:1 on disk.

So rework rollback to handle new convert behavior, enhance the check by
only checking all file extents of convert image, only to check if these
file extents and therir chunks are mapped 1:1.

This new rollback check behavior can handle both new and old convert
behavior, as the new behavior is a superset of old behavior.

Further more, introduce a simple rollback mechanisim:
1) Read reserved data (offset = file offset) from convert image
2) Write reserved data into disk (offset = physical offset)

Since old fs image is a valid fs, and we only need to rollback
superblocks (btrfs reserved ranges), then we just read out data in
reserved range, and write it back.

Due to the fact that all other file extents of converted image is mapped
1:1 on disk, we put the missing piece back, then the fs is as good as
old one.

Then what we do in btrfs is just another dream.

With this new rollback mechanisim, we can open btrfs read-only, so we
won't cause any damage to current btrfs, until the final piece (0~1M,
containing 1st super block) is put back.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 591 ++++++++++++++-------------------------------------------
 1 file changed, 138 insertions(+), 453 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 3ad7b2fb..e81a1a29 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1164,36 +1164,6 @@ fail:
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
 static int convert_open_fs(const char *devname,
 			   struct btrfs_convert_context *cctx)
 {
@@ -1382,131 +1352,6 @@ fail:
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
  * Read out data of convert image which is in btrfs reserved range.
  *
  * So rollback can just use these data to overwrite these ranges of btrfs
@@ -1716,354 +1561,194 @@ next:
 	return ret;
 }
 
+/*
+ * btrfs rollback is just reverted convert:
+ * |<---------------Btrfs fs------------------------------>|
+ * |<-   Old data chunk  ->|< new chunk (D/M/S)>|<- ODC  ->|
+ * |<-Old-FE->| |<-Old-FE->|<- Btrfs extents  ->|<-Old-FE->|
+ *                           ||
+ *                           \/
+ * |<------------------Old fs----------------------------->|
+ * |<- used ->| |<- used ->|                    |<- used ->|
+ *
+ * However things are much easier than convert, we don't really need to
+ * do the complex space calculation, but only to handle btrfs reserved space
+ *
+ * |<---------------------------Btrfs fs----------------------------->|
+ * |   RSV 1   |  | Old  |   |    RSV 2  | | Old  | |   RSV 3   |
+ * |   0~1M    |  | Fs   |   | SB2 + 64K | | Fs   | | SB3 + 64K |
+ *
+ * On the other hande, the converted fs image in btrfs is a completely
+ * valid old fs.
+ *
+ * |<-----------------Converted fs image in btrfs-------------------->|
+ * |   RSV 1   |  | Old  |   |    RSV 2  | | Old  | |   RSV 3   |
+ * | Relocated |  | Fs   |   | Relocated | | Fs   | | Relocated |
+ *
+ * Used space in fs image should be at the same physical position on disk.
+ * We only need to recover the data in reserved ranges, so the whole
+ * old fs is back.
+ *
+ * The idea to rollback is also straightforward, we just "read" out the data
+ * of reserved ranges, and write them back to there they should be.
+ * Then the old fs is back.
+ */
 static int do_rollback(const char *devname)
 {
-	int fd = -1;
-	int ret;
-	int i;
 	struct btrfs_root *root;
 	struct btrfs_root *image_root;
-	struct btrfs_root *chunk_root;
-	struct btrfs_dir_item *dir;
-	struct btrfs_inode_item *inode;
-	struct btrfs_file_extent_item *fi;
-	struct btrfs_trans_handle *trans;
-	struct extent_buffer *leaf;
-	struct btrfs_block_group_cache *cache1;
-	struct btrfs_block_group_cache *cache2;
+	struct btrfs_fs_info *fs_info;
 	struct btrfs_key key;
 	struct btrfs_path path;
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
+	struct btrfs_dir_item *dir;
+	struct btrfs_inode_item *inode_item;
+	char *image_name = "image";
+	char *reserved_ranges[ARRAY_SIZE(btrfs_reserved_ranges)] = { NULL };
 	u64 total_bytes;
-	u32 sectorsize;
+	u64 fsize;
+	u64 root_dir;
+	u64 ino;
+	int fd = -1;
+	int ret;
+	int i;
 
-	extent_io_tree_init(&io_tree);
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
+		reserved_ranges[i] = calloc(1, range->len);
+		if (!reserved_ranges[i]) {
+			ret = -ENOMEM;
+			goto free_mem;
+		}
+	}
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
 		error("unable to open %s: %s", devname, strerror(errno));
-		goto fail;
+		ret = -EIO;
+		goto free_mem;
 	}
+	fsize = lseek(fd, 0, SEEK_END);
 	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
 	if (!root) {
 		error("unable to open ctree");
-		goto fail;
-	}
-	ret = may_rollback(root);
-	if (ret < 0) {
-		error("unable to do rollback: %d", ret);
-		goto fail;
+		ret = -EIO;
+		goto free_mem;
 	}
+	fs_info = root->fs_info;
 
-	sectorsize = root->sectorsize;
-	buf = malloc(sectorsize);
-	if (!buf) {
-		error("unable to allocate memory");
-		goto fail;
-	}
 
+	/*
+	 * Search root backref first, or after subvolume deletion (orphan),
+	 * we can still rollback the image.
+	 */
 	btrfs_init_path(&path);
 
 	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
 	key.type = BTRFS_ROOT_BACKREF_KEY;
 	key.offset = BTRFS_FS_TREE_OBJECTID;
-	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path, 0,
-				0);
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0, 0);
 	btrfs_release_path(&path);
 	if (ret > 0) {
-		error("unable to convert ext2 image subvolume, is it deleted?");
-		goto fail;
+		error("unable to find ext2 image subvolume, is it deleted?");
+		ret = -ENOENT;
+		goto close_fs;
 	} else if (ret < 0) {
-		error("unable to open ext2_saved, id %llu: %s",
-			(unsigned long long)key.objectid, strerror(-ret));
-		goto fail;
+		error("failed to find ext2 image subvolume: %s",
+			strerror(-ret));
+		goto close_fs;
 	}
 
+	/* Search convert subvolume */
 	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
-	image_root = btrfs_read_fs_root(root->fs_info, &key);
-	if (!image_root || IS_ERR(image_root)) {
-		error("unable to open subvolume %llu: %ld",
-			(unsigned long long)key.objectid, PTR_ERR(image_root));
-		goto fail;
+
+	image_root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(image_root)) {
+		ret = PTR_ERR(image_root);
+		error("failed to open convert image subvolume: %s",
+			strerror(-ret));
+		goto close_fs;
 	}
 
-	name = "image";
-	root_dir = btrfs_root_dirid(&root->root_item);
-	dir = btrfs_lookup_dir_item(NULL, image_root, &path,
-				   root_dir, name, strlen(name), 0);
+	/* Search the image file */
+	root_dir = btrfs_root_dirid(&image_root->root_item);
+	dir = btrfs_lookup_dir_item(NULL, image_root, &path, root_dir,
+			image_name, strlen(image_name), 0);
 	if (!dir || IS_ERR(dir)) {
-		error("unable to find file %s: %ld", name, PTR_ERR(dir));
-		goto fail;
+		btrfs_release_path(&path);
+		if (dir)
+			ret = PTR_ERR(dir);
+		else
+			ret = -ENOENT;
+		error("failed to locate file %s: %s", image_name,
+			strerror(-ret));
+		goto close_fs;
 	}
-	leaf = path.nodes[0];
-	btrfs_dir_item_key_to_cpu(leaf, dir, &key);
+	btrfs_dir_item_key_to_cpu(path.nodes[0], dir, &key);
 	btrfs_release_path(&path);
 
-	objectid = key.objectid;
+	/* Get total size of the original image */
+	ino = key.objectid;
 
 	ret = btrfs_lookup_inode(NULL, image_root, &path, &key, 0);
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
+	if (ret < 0) {
 		btrfs_release_path(&path);
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
-
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
-				EXTENT_LOCKED);
-		set_state_private(&io_tree, offset, bytenr);
-next_extent:
-		offset += btrfs_file_extent_num_bytes(leaf, fi);
-		path.slots[0]++;
+		error("unable to find inode %llu: %s", ino, strerror(-ret));
+		goto close_fs;
 	}
+	inode_item = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_inode_item);
+	total_bytes = btrfs_inode_size(path.nodes[0], inode_item);
 	btrfs_release_path(&path);
 
-	if (offset < total_bytes) {
-		error("unable to build extent mapping (offset %llu, total_bytes %llu)",
-				(unsigned long long)offset,
-				(unsigned long long)total_bytes);
-		error("converted filesystem after balance is unable to rollback");
-		goto fail;
-	}
-
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
-	/*
-	 * recow the whole chunk tree, this will remove all chunk tree blocks
-	 * from system block group
-	 */
-	chunk_root = root->fs_info->chunk_root;
-	memset(&key, 0, sizeof(key));
-	while (1) {
-		ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
-		if (ret < 0)
-			break;
-
-		ret = btrfs_next_leaf(chunk_root, &path);
-		if (ret)
-			break;
-
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		btrfs_release_path(&path);
+	/* Check if we can rollback the image */
+	ret = check_convert_image(image_root, ino, total_bytes,
+				  reserved_ranges);
+	if (ret < 0) {
+		error("old fs image can't be rolled back");
+		goto close_fs;
 	}
+close_fs:
 	btrfs_release_path(&path);
+	close_ctree_fs_info(fs_info);
+	if (ret)
+		goto free_mem;
 
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
-			goto fail;
-		}
-	}
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
-		clear_extent_bits(&io_tree, start, end, EXTENT_LOCKED);
+ 	/*
+	 * Everything is OK, just write back old fs data into btrfs reserved
+	 * ranges
+	 *
+	 * Here, we starts from the backup blocks first, so if something goes
+	 * wrong, the fs is still mountable
+	 */
+	for (i = ARRAY_SIZE(btrfs_reserved_ranges) - 1; i >= 0; i--) {
+		u64 real_size;
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
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
+		if (range_end(range) >= fsize)
+			continue;
+		real_size = min(range_end(range), fsize) - range->start;
+		ret = pwrite(fd, reserved_ranges[i], real_size, range->start);
+		if (ret < real_size) {
+			if (ret < 0)
+				ret = -errno;
+			else
+				ret = -EIO;
+			error("failed to recover range [%llu, %llu): %s",
+			      range->start, real_size, strerror(-ret));
+			goto free_mem;
 		}
+		ret = 0;
 	}
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
-	printf("rollback complete\n");
-	return 0;
-
-fail:
-	if (fd != -1)
-		close(fd);
-	free(buf);
-	error("rollback aborted");
-	return -1;
+free_mem:
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++)
+		free(reserved_ranges[i]);
+	if (ret)
+		error("rollback failed");
+	else
+		printf("rollback succeeded\n");
+	return ret;
 }
 
 static void print_usage(void)
-- 
2.12.0



