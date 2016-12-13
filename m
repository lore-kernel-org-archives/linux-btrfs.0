Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9722 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932676AbcLMJos (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 04:44:48 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: chandan@linux.vnet.ibm.com
Subject: [PATCH 2/3] btrfs-progs: convert: Rework rollback to handle new convert image
Date: Tue, 13 Dec 2016 17:44:14 +0800
Message-Id: <20161213094415.30912-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161213094415.30912-1-quwenruo@cn.fujitsu.com>
References: <20161213094415.30912-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although commit 9c4b820412746b3 tried to make the rollback condition
less restrict, to co-operate with new rollback behavior, it's still too
restrict.

If btrfs allocates a new data chunk, it's highly possible that the new
chunk will not be 1:1 mapped anymore.

And this makes old rollback check fails, and refuse to rollback.

This patch rework it by checking rollback condition more accurately.

1) Rollback condition
   Unlike old chunk level check, we use file extent level check.
   So we manually check every file extents of convert image file.

   Only when all file extents except ones in btrfs relocated ranges(*)
   are mapped 1:1 we allow rollback.

   This behavior make both old and new behavior happy.
*:
   [0, 1M)
   [btrfs_sb_offset(1), +64K)
   [btrfs_sb_offset(2), +64K)

2) Rollback method
   Old rollback method is quite complex, using extent_io tree to mark
   every checked ranges.
   And do extra chunk tree operation before rollback.

   The new rollback method is quite simple.
   1) open btrfs
   2) read and save relocated data
   3) close btrfs
   4) write relocated into place.

Such rework fixes the following problem
1) rollback failure after new data chunk allocation
2) rollback failure after correct NO_HOLES convert

Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 691 ++++++++++++++++++++++-----------------------------------
 1 file changed, 266 insertions(+), 425 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index e6d8b3e..0052d80 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1411,36 +1411,6 @@ fail:
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
@@ -2544,479 +2514,350 @@ fail:
 }
 
 /*
- * Check if a non 1:1 mapped chunk can be rolled back.
- * For new convert, it's OK while for old convert it's not.
+ * If [start1, start1 + len1) is a subset of [start2, start2 + len2)
+ * return 1.
+ * Else return 0.
  */
-static int may_rollback_chunk(struct btrfs_fs_info *fs_info, u64 bytenr)
+static int is_range_subset(u64 start1, u64 len1, u64 start2, u64 len2)
 {
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
+	if (start1 >= start2 && start1 + len1 <= start2 + len2)
+		return 1;
+	return 0;
+}
 
-	key.objectid = bg_end;
-	key.type = BTRFS_METADATA_ITEM_KEY;
-	key.offset = 0;
-	btrfs_init_path(&path);
+/*
+ * If [start1, start1 + len2) intersects with [start2, start2 + len2)
+ * return 1.
+ * Else return 0.
+ */
+static int is_range_intersect(u64 start1, u64 len1, u64 start2, u64 len2)
+{
+	if (start1 >= start2 + len2 || start1 + len1 <= start2)
+		return 0;
+	return 1;
+}
 
-	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
-	if (ret < 0)
-		return ret;
+/*
+ * Check if a range is a subset of btrfs convert reloc space.
+ */
+static int is_range_subset_of_reloc_space(u64 start, u64 len)
+{
+	/*
+	 * Must be in one of the ranges, or it's not in btrfs reloc space
+	 * [0, 1M)
+	 * [sb_offset(1), + 64K)
+	 * [sb_offset(2), + 64K)
+	 */
+	if (is_range_subset(start, len, 0, 1024 * 1024) ||
+	    is_range_subset(start, len, btrfs_sb_offset(1), 64 * 1024) ||
+	    is_range_subset(start, len, btrfs_sb_offset(2), 64 * 1024))
+		return 1;
+	return 0;
+}
 
-	while (1) {
-		struct btrfs_extent_item *ei;
+/*
+ * Check if a range intersects with btrfs convert reloc space
+ * will record which range it intersects into @ret
+ */
+static int is_range_intersect_of_reloc_space(u64 start, u64 len,
+					     int *nr_intersect)
+{
+	int nr = -1;
 
-		ret = btrfs_previous_extent_item(extent_root, &path, bg_start);
-		if (ret > 0) {
-			ret = 0;
-			break;
-		}
-		if (ret < 0)
-			break;
+	if (is_range_intersect(start, len, 0, 1024 * 1024))
+		nr = 0;
+	else if (is_range_intersect(start, len, btrfs_sb_offset(1), 64 * 1024))
+		nr = 1;
+	else if (is_range_intersect(start, len, btrfs_sb_offset(2), 64 * 1024))
+		nr = 2;
 
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
+	if (nr == -1)
+		return 0;
+	if (nr_intersect)
+		*nr_intersect = nr;
+	return 1;
 }
 
-static int may_rollback(struct btrfs_root *root)
+
+/*
+ * Read relocated data from btrfs address space and restore it into
+ * corresponding reloc_ranges
+ */
+static int recover_reloc_data(struct btrfs_fs_info *fs_info,
+			u64 old_offset, u64 disk_bytenr, u64 len,
+			char *reloc_ranges[3])
 {
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_multi_bio *multi = NULL;
-	u64 bytenr;
-	u64 length;
-	u64 physical;
-	u64 total_bytes;
-	int num_stripes;
+	u64 range_starts[3] = { 0, btrfs_sb_offset(1), btrfs_sb_offset(2)};
+	u64 range_lens[3] = { 1024 * 1024, 64 * 1024, 64 * 1024};
+	u64 reloc_start;
+	u64 reloc_len;
+	u64 file_start;	/* Bytenr are file offset */
+	u64 file_len;
+	u64 logical_start; /* Bytenr are btrfs logical address */
+	u64 logical_len;
+	char *dest;
+	int nr;
 	int ret;
 
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
+	/* None intersects range with btrfs reloc space, just exit */
+	if (!is_range_intersect_of_reloc_space(old_offset, len, &nr))
+		return 0;
+	reloc_start = range_starts[nr];
+	reloc_len = range_lens[nr];
 
-		num_stripes = multi->num_stripes;
-		physical = multi->stripes[0].physical;
-		free(multi);
+	file_start = max(old_offset, reloc_start);
+	file_len = min(old_offset + len, reloc_start + reloc_len) - file_start;
 
-		if (num_stripes != 1) {
-			error("num stripes for bytenr %llu is not 1", bytenr);
-			goto fail;
-		}
+	logical_start = file_start - old_offset + disk_bytenr;
+	logical_len = file_len;
 
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
+	dest = reloc_ranges[nr] + file_start - reloc_start;
+	ret = read_extent_data(fs_info->tree_root, dest, logical_start, &logical_len,
+			0);
+	if (ret < 0)
+		return ret;
+	/* Short read, something went wrong */
+	if (logical_len != file_len)
+		return -EIO;
 	return 0;
-fail:
-	return -1;
 }
 
-static int do_rollback(const char *devname)
+/*
+ * Check if we can rollback, and fill reloc_ranges pointers, so we can use it
+ * to re-fill the data of old fs after close_tree()
+ */
+static int check_rollback(struct btrfs_fs_info *fs_info, char *reloc_ranges[3])
 {
-	int fd = -1;
-	int ret;
-	int i;
-	struct btrfs_root *root;
 	struct btrfs_root *image_root;
-	struct btrfs_root *chunk_root;
 	struct btrfs_dir_item *dir;
-	struct btrfs_inode_item *inode;
-	struct btrfs_file_extent_item *fi;
-	struct btrfs_trans_handle *trans;
-	struct extent_buffer *leaf;
-	struct btrfs_block_group_cache *cache1;
-	struct btrfs_block_group_cache *cache2;
-	struct btrfs_key key;
 	struct btrfs_path path;
-	struct extent_io_tree io_tree;
-	char *buf = NULL;
-	char *name;
-	u64 bytenr;
-	u64 num_bytes;
+	struct btrfs_key key;
+	struct btrfs_inode_item *inode_item;
+	char *image_name = "image";
+	u64 ino;
 	u64 root_dir;
-	u64 objectid;
-	u64 offset;
-	u64 start;
-	u64 end;
-	u64 sb_bytenr;
-	u64 first_free;
 	u64 total_bytes;
-	u32 sectorsize;
-
-	extent_io_tree_init(&io_tree);
+	u64 checked_bytes = 0;
+	int ret;
 
-	fd = open(devname, O_RDWR);
-	if (fd < 0) {
-		error("unable to open %s: %s", devname, strerror(errno));
-		goto fail;
-	}
-	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
-	if (!root) {
-		error("unable to open ctree");
-		goto fail;
-	}
-	ret = may_rollback(root);
-	if (ret < 0) {
-		error("unable to do rollback: %d", ret);
-		goto fail;
-	}
+	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
+	key.offset = (u64)-1;
+	key.type = BTRFS_ROOT_ITEM_KEY;
 
-	sectorsize = root->sectorsize;
-	buf = malloc(sectorsize);
-	if (!buf) {
-		error("unable to allocate memory");
-		goto fail;
+	/* Search for convert subvolume */
+	image_root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(image_root)) {
+		ret = PTR_ERR(image_root);
+		error("failed to find convert image subvolume: %s",
+			strerror(-ret));
+		return ret;
 	}
 
+	/* Search "image" file */
 	btrfs_init_path(&path);
+	root_dir = btrfs_root_dirid(&image_root->root_item);
+	dir = btrfs_lookup_dir_item(NULL, image_root, &path, root_dir,
+			image_name, strlen(image_name), 0);
 
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
 	if (!dir || IS_ERR(dir)) {
-		error("unable to find file %s: %ld", name, PTR_ERR(dir));
-		goto fail;
+		btrfs_release_path(&path);
+		ret = PTR_ERR(dir);
+		error("unable to find file %s: %s", image_name, strerror(-ret));
+		return ret;
 	}
-	leaf = path.nodes[0];
-	btrfs_dir_item_key_to_cpu(leaf, dir, &key);
+	btrfs_dir_item_key_to_cpu(path.nodes[0], dir, &key);
 	btrfs_release_path(&path);
 
-	objectid = key.objectid;
+	/* Get the total size of the original image */
+	ino = key.objectid;
 
 	ret = btrfs_lookup_inode(NULL, image_root, &path, &key, 0);
-	if (ret) {
-		error("unable to find inode item: %d", ret);
-		goto fail;
+	if (ret < 0) {
+		btrfs_release_path(&path);
+		error("unable to find inode %llu: %s", ino, strerror(-ret));
+		return ret;
 	}
-	leaf = path.nodes[0];
-	inode = btrfs_item_ptr(leaf, path.slots[0], struct btrfs_inode_item);
-	total_bytes = btrfs_inode_size(leaf, inode);
+	inode_item = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			struct btrfs_inode_item);
+	total_bytes = btrfs_inode_size(path.nodes[0], inode_item);
 	btrfs_release_path(&path);
 
-	key.objectid = objectid;
+	/* Main loop to check every file extents */
+	key.objectid = ino;
 	key.offset = 0;
 	key.type = BTRFS_EXTENT_DATA_KEY;
+
 	ret = btrfs_search_slot(NULL, image_root, &key, &path, 0, 0);
-	if (ret != 0) {
-		error("unable to find first file extent: %d", ret);
+	/*
+	 * Only ret < 0 is error. It's possible that for NO_HOLES feature
+	 * and some fs doesn't use range 0~1M
+	 */
+	if (ret < 0) {
+		error("failed to search file extents: %s", strerror(-ret));
 		btrfs_release_path(&path);
-		goto fail;
+		return ret;
 	}
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
+	while (1) {
+		struct btrfs_file_extent_item *fi;
+		struct extent_buffer *leaf = path.nodes[0];
+		u64 disk_bytenr;
+		u64 file_offset;
+		u64 ram_bytes;
+		u64 extent_offset;
+		int slot = path.slots[0];
+
+		if (path.slots[0] >= btrfs_header_nritems(leaf))
+			goto next;
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY) {
+			/* Search is done normally */
+			ret = 0;
 			break;
-
-		fi = btrfs_item_ptr(leaf, path.slots[0],
-				    struct btrfs_file_extent_item);
-		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
+		}
+		file_offset = key.offset;
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG) {
+			ret = -EINVAL;
+			error(
+			"ino %llu offset %llu is not regular file extent",
+				ino, file_offset);
 			break;
+		}
 		if (btrfs_file_extent_compression(leaf, fi) ||
 		    btrfs_file_extent_encryption(leaf, fi) ||
-		    btrfs_file_extent_other_encoding(leaf, fi))
+		    btrfs_file_extent_other_encoding(leaf, fi)) {
+			ret = -EINVAL;
+			error(
+			"ino %llu offset %llu is not plain file extent",
+				ino, file_offset);
 			break;
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
+		}
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+		extent_offset = btrfs_file_extent_offset(leaf, fi);
+
+		checked_bytes += ram_bytes;
+		/* skip hole */
+		if (disk_bytenr == 0)
+			goto next;
+
+		/* Only file extent in btrfs reserved ranges are allowed */
+		if (file_offset != disk_bytenr) {
+			if (!is_range_subset_of_reloc_space(file_offset,
+						ram_bytes)) {
+				ret = -EINVAL;
+				error(
+			"ino %llu offset %llu file extent is relocated",
+					ino, file_offset);
+				break;
+			}
+		}
+		ret = recover_reloc_data(fs_info, file_offset,
+				disk_bytenr + extent_offset, ram_bytes,
+				reloc_ranges);
+		if (ret < 0) {
+			error("ino %llu offset %llu failed to read extent data",
+				ino, file_offset);
 			break;
-
-		set_extent_bits(&io_tree, offset, offset + num_bytes - 1,
-				EXTENT_LOCKED, GFP_NOFS);
-		set_state_private(&io_tree, offset, bytenr);
-next_extent:
-		offset += btrfs_file_extent_num_bytes(leaf, fi);
-		path.slots[0]++;
+		}
+next:
+		ret = btrfs_next_item(image_root, &path);
+		if (ret) {
+			if (ret > 0)
+				ret = 0;
+			break;
+		}
 	}
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
 	/*
-	 * recow the whole chunk tree, this will remove all chunk tree blocks
-	 * from system block group
+	 * For holes mode, we should checked all bytes
 	 */
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
+	if (!btrfs_fs_incompat(fs_info, NO_HOLES)) {
+		if (checked_bytes != total_bytes) {
+			ret = -EINVAL;
+			error("some file extents are missing");
+		}
 	}
-	btrfs_release_path(&path);
-
-	offset = 0;
-	num_bytes = 0;
-	while(1) {
-		cache1 = btrfs_lookup_block_group(root->fs_info, offset);
-		if (!cache1)
-			break;
+	return ret;
+}
 
-		if (cache1->flags & BTRFS_BLOCK_GROUP_SYSTEM)
-			num_bytes += btrfs_block_group_used(&cache1->item);
+static int do_rollback(const char *devname)
+{
+	int fd = -1;
+	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
+	char *reloc_ranges[3] = { NULL };
+	off_t fsize;
+	u64 reloc_phy[3] = { 0 , btrfs_sb_offset(1), btrfs_sb_offset(2) };
+	int reloc_sizes[3] = { 1024 * 1024, 64 * 1024, 64 * 1024 };
+	int ret;
+	int i;
 
-		offset = cache1->key.objectid + cache1->key.offset;
+	for (i = 0; i < 3; i++) {
+		reloc_ranges[i] = calloc(1, reloc_sizes[i]);
+		if (!reloc_ranges[i]) {
+			ret = -ENOMEM;
+			goto free_mem;
+		}
 	}
-	/* only extent #0 left in system block group? */
-	if (num_bytes > first_free) {
-		error(
-	"unable to empty system block group (num_bytes %llu, first_free %llu",
-				(unsigned long long)num_bytes,
-				(unsigned long long)first_free);
+
+	fd = open(devname, O_RDWR);
+	if (fd < 0) {
+		error("unable to open %s: %s", devname, strerror(errno));
+		ret = -errno;
 		goto fail;
 	}
-	/* create a system chunk that maps the whole device */
-	ret = prepare_system_chunk_sb(root->fs_info->super_copy);
-	if (ret) {
-		error("unable to update system chunk: %d", ret);
+	fsize = lseek(fd, 0, SEEK_END);
+	root = open_ctree_fd(fd, devname, 0, 0);
+	if (!root) {
+		error("unable to open ctree");
+		ret = -EIO;
 		goto fail;
 	}
+	fs_info = root->fs_info;
 
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret) {
-		error("transaction commit failed: %d", ret);
+	/* Check if we can rollback, and collect relocated data */
+	ret = check_rollback(fs_info, reloc_ranges);
+	close_ctree(root);
+	if (ret < 0) {
 		goto fail;
 	}
 
-	ret = close_ctree(root);
-	if (ret) {
-		error("close_ctree failed: %d", ret);
-		goto fail;
-	}
+	/* Reloc data are saved in reloc_ranges, just pwrite them */
+	for (i = 2; i >= 0; i--) {
+		u64 real_size;
 
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
+		if (reloc_phy[i] > fsize)
+			continue;
+		real_size = min(reloc_phy[i] + reloc_sizes[i], (u64)fsize) -
+			    reloc_phy[i];
+		ret = pwrite(fd, reloc_ranges[i], real_size, reloc_phy[i]);
+		if (ret != real_size) {
+			error(
+			"failed to write reserved range [%llu, %llu): %s",
+				reloc_phy[i], reloc_phy[i] + real_size,
+				strerror(errno));
+			ret = -errno;
 			goto fail;
 		}
+		ret = 0;
 	}
 
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
+free_mem:
+	for (i = 0; i < 3; i++)
+		free(reloc_ranges[i]);
+	return ret;
+
 
 fail:
 	if (fd != -1)
 		close(fd);
-	free(buf);
+	for (i = 0; i < 3; i++)
+		free(reloc_ranges[i]);
 	error("rollback aborted");
-	return -1;
+	return ret;
 }
 
 static void print_usage(void)
-- 
2.10.2



