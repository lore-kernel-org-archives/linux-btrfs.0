From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Progs: update convert for uninitialized block groups
Date: Wed, 21 Jan 2009 19:53:27 +0800
Message-ID: <49770CB7.8050205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

There is a new feature 'uninitialized block groups' in ext4.
Block and inode bitmaps in uninitialized block groups are
uninitialized. This confuses the converter. The fix is call
ext2fs_new_inode for each block group at open time. It set
up uninitialized block and inode bitmaps appropriately.

This patch also contains some other minor fixes. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-unstable/convert.c btrfs-progs/convert.c
--- btrfs-progs-unstable/convert.c	2009-01-13 18:55:53.214449273 +0800
+++ btrfs-progs/convert.c	2009-01-21 16:54:37.000000000 +0800
@@ -54,6 +54,7 @@ static int open_ext2fs(const char *name,
 {
 	errcode_t ret;
 	ext2_filsys ext2_fs;
+	ext2_ino_t ino;
 	ret = ext2fs_open(name, 0, 0, 0, unix_io_manager, &ext2_fs);
 	if (ret) {
 		fprintf(stderr, "ext2fs_open: %s\n", error_message(ret));
@@ -71,6 +72,17 @@ static int open_ext2fs(const char *name,
 			error_message(ret));
 		goto fail;
 	}
+	/*
+	 * search each block group for a free inode. this set up
+	 * uninit block/inode bitmaps appropriately.
+	 */
+	ino = 1;
+	while (ino <= ext2_fs->super->s_inodes_count) {
+		ext2_ino_t foo;
+		ext2fs_new_inode(ext2_fs, ino, 0, NULL, &foo);
+		ino += EXT2_INODES_PER_GROUP(ext2_fs->super);
+	}
+
 	*ret_fs = ext2_fs;
 	return 0;
 fail:
@@ -1929,6 +1941,7 @@ static int relocate_one_reference(struct
 		key.offset = 0;
 	}
 	btrfs_init_path(&path);
+recow:
 	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 	if (ret < 0)
 		goto fail;
@@ -1936,8 +1949,17 @@ static int relocate_one_reference(struct
 	leaf = path.nodes[0];
 	nritems = btrfs_header_nritems(leaf);
 	while (1) {
-		if (path.slots[0] >= nritems)
-			break;
+		if (path.slots[0] >= nritems) {
+			ret = btrfs_next_leaf(root, &path);
+			if (ret < 0)
+				goto fail;
+			if (ret > 0)
+				break;
+			btrfs_item_key_to_cpu(path.nodes[0], &key,
+					      path.slots[0]);
+			btrfs_release_path(root, &path);
+			goto recow;
+		}
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
 		if (key.objectid != objectid ||
 		    key.type != BTRFS_EXTENT_DATA_KEY)
@@ -2048,7 +2070,7 @@ static int relocate_one_reference(struct
 	if (data.num_blocks > 0) {
 		ret = record_file_blocks(trans, root, objectid, &inode,
 					 data.first_block, data.disk_block,
-					 data.num_blocks, 0);
+					 data.num_blocks, datacsum);
 		if (ret)
 			goto fail;
 	}
@@ -2218,7 +2240,7 @@ next:
 	ret = btrfs_commit_transaction(trans, cur_root);
 	BUG_ON(ret);
 
-	if (num_refs > 0 && pass++ < 4)
+	if (num_refs > 0 && pass++ < 16)
 		goto again;
 
 	ret = (num_refs > 0) ? -1 : 0;
@@ -2537,6 +2559,7 @@ int do_rollback(const char *devname, int
 {
 	int fd;
 	int ret;
+	int i;
 	struct btrfs_root *root;
 	struct btrfs_root *ext2_root;
 	struct btrfs_root *chunk_root;
@@ -2654,6 +2677,10 @@ int do_rollback(const char *devname, int
 				    struct btrfs_file_extent_item);
 		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
 			break;
+		if (btrfs_file_extent_compression(leaf, fi) ||
+		    btrfs_file_extent_encryption(leaf, fi) ||
+		    btrfs_file_extent_other_encoding(leaf, fi))
+			break;
 
 		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 		/* skip holes and direct mapped extents */
@@ -2750,6 +2777,15 @@ next_extent:
 		goto fail;
 	}
 
+	/* zero btrfs super block mirrors */
+	memset(buf, 0, sectorsize);
+	for (i = 1 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		if (bytenr >= total_bytes)
+			break;
+		ret = pwrite(fd, buf, sectorsize, bytenr);
+	}
+
 	sb_bytenr = (u64)-1;
 	/* copy all relocated blocks back */
 	while(1) {

