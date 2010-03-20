From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: [PATCH 1/4] btrfs-convert: make more use of cache_free_extents
Date: Sat, 20 Mar 2010 00:24:49 -0400
Message-ID: <20100320042449.GA17083@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

An extent_io_tree is used for all free space information. This allows
removal of ext2_alloc_block and ext2_free_block, and makes
create_ext2_image less ext2-specific.
---
 convert.c |  154 +++++++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 99 insertions(+), 55 deletions(-)

diff --git a/convert.c b/convert.c
index d037c98..c48f8ba 100644
--- a/convert.c
+++ b/convert.c
@@ -95,29 +95,10 @@ static int close_ext2fs(ext2_filsys fs)
 	return 0;
 }
 
-static int ext2_alloc_block(ext2_filsys fs, u64 goal, u64 *block_ret)
+static int ext2_cache_free_extents(ext2_filsys ext2_fs,
+				   struct extent_io_tree *free_tree)
 {
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
-static int ext2_free_block(ext2_filsys fs, u64 block)
-{
-	BUG_ON(block != (blk_t)block);
-	ext2fs_fast_unmark_block_bitmap(fs->block_map, block);
-	return 0;
-}
-
-static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
-
-{
-	int i, ret = 0;
+	int ret = 0;
 	blk_t block;
 	u64 bytenr;
 	u64 blocksize = ext2_fs->blocksize;
@@ -127,29 +108,68 @@ static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
 		if (ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block))
 			continue;
 		bytenr = block * blocksize;
-		ret = set_extent_dirty(&root->fs_info->free_space_cache,
-				       bytenr, bytenr + blocksize - 1, 0);
+		ret = set_extent_dirty(free_tree, bytenr,
+				       bytenr + blocksize - 1, 0);
 		BUG_ON(ret);
 	}
 
+	return 0;
+}
+
+/* mark btrfs-reserved blocks as used */
+static void adjust_free_extents(ext2_filsys ext2_fs,
+				struct extent_io_tree *free_tree)
+{
+	int i;
+	u64 bytenr;
+	u64 blocksize = ext2_fs->blocksize;
+
+	clear_extent_dirty(free_tree, 0, BTRFS_SUPER_INFO_OFFSET - 1, 0);
+
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		bytenr &= ~((u64)STRIPE_LEN - 1);
 		if (bytenr >= blocksize * ext2_fs->super->s_blocks_count)
 			break;
-		clear_extent_dirty(&root->fs_info->free_space_cache, bytenr,
-				   bytenr + STRIPE_LEN - 1, 0);
+		clear_extent_dirty(free_tree, bytenr, bytenr + STRIPE_LEN - 1,
+				   0);
 	}
+}
 
-	clear_extent_dirty(&root->fs_info->free_space_cache,
-			   0, BTRFS_SUPER_INFO_OFFSET - 1, 0);
-
+static int alloc_blocks(struct extent_io_tree *free_tree,
+			u64 *blocks, int num, u64 blocksize)
+{
+	u64 start;
+	u64 end;
+	u64 last = 0;
+	u64 mask = blocksize - 1;
+	int ret;
+	while(num) {
+		ret = find_first_extent_bit(free_tree, last, &start, &end,
+					    EXTENT_DIRTY);
+		if (ret)
+			goto fail;
+		last = end + 1;
+		if (start & mask)
+			start = (start & mask) + blocksize;
+		if (last - start < blocksize)
+			continue;
+		*blocks++ = start;
+		num--;
+		last = start + blocksize;
+		clear_extent_dirty(free_tree, start, last - 1, 0);
+	}
 	return 0;
+fail:
+	fprintf(stderr, "not enough free space\n");
+	return -ENOSPC;
 }
 
 static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 			       u64 hint_byte, struct btrfs_key *ins)
 {
+	u64 blocksize = root->sectorsize;
+	u64 mask = blocksize - 1;
 	u64 start;
 	u64 end;
 	u64 last = hint_byte;
@@ -171,6 +191,8 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 
 		start = max(last, start);
 		last = end + 1;
+		if (start & mask)
+			start = (start & mask) + blocksize;
 		if (last - start < num_bytes)
 			continue;
 
@@ -1186,9 +1208,9 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root, u64 objectid,
 				   struct btrfs_inode_item *inode,
 				   u64 start_byte, u64 end_byte,
-				   ext2_filsys ext2_fs)
+				   struct extent_io_tree *orig_free_tree)
 {
-	u32 blocksize = ext2_fs->blocksize;
+	u32 blocksize = root->sectorsize;
 	u32 block = start_byte / blocksize;
 	u32 last_block = (end_byte + blocksize - 1) / blocksize;
 	int ret = 0;
@@ -1205,7 +1227,8 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 		.errcode	= 0,
 	};
 	for (; start_byte < end_byte; block++, start_byte += blocksize) {
-		if (!ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block))
+		if (test_range_bit(orig_free_tree, start_byte,
+				   start_byte + blocksize, EXTENT_DIRTY, 1))
 			continue;
 		ret = block_iterate_proc(NULL, block, block, &data);
 		if (ret & BLOCK_ABORT) {
@@ -1234,8 +1257,8 @@ fail:
 /*
  * Create the ext2fs image file.
  */
-static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
-			     const char *name)
+static int create_ext2_image(struct btrfs_root *root, const char *name,
+			     struct extent_io_tree *orig_free_tree)
 {
 	int ret;
 	struct btrfs_key key;
@@ -1348,7 +1371,7 @@ next:
 		if (bytenr > last_byte) {
 			ret = create_image_file_range(trans, root, objectid,
 						      &btrfs_inode, last_byte,
-						      bytenr, ext2_fs);
+						      bytenr, orig_free_tree);
 			if (ret)
 				goto fail;
 		}
@@ -1370,7 +1393,7 @@ next:
 	if (total_bytes > last_byte) {
 		ret = create_image_file_range(trans, root, objectid,
 					      &btrfs_inode, last_byte,
-					      total_bytes, ext2_fs);
+					      total_bytes, orig_free_tree);
 		if (ret)
 			goto fail;
 	}
@@ -2332,9 +2355,23 @@ err:
 	return ret;
 }
 
+static int copy_dirtiness(struct extent_io_tree *out,
+			  struct extent_io_tree *in)
+{
+	int ret;
+	u64 start, end, last = 0;
+	while (!find_first_extent_bit(in, last, &start, &end, EXTENT_DIRTY)) {
+		ret = set_extent_dirty(out, start, end, 0);
+		if (ret)
+			return ret;
+		last = end + 1;
+	}
+	return 0;
+}
+
 int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 {
-	int i, fd, ret;
+	int fd, ret;
 	u32 blocksize;
 	u64 blocks[7];
 	u64 total_bytes;
@@ -2342,7 +2379,11 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	ext2_filsys ext2_fs;
 	struct btrfs_root *root;
 	struct btrfs_root *ext2_root;
+	struct extent_io_tree free_tree;
+	struct extent_io_tree orig_free_tree;
 
+	extent_io_tree_init(&free_tree);
+	extent_io_tree_init(&orig_free_tree);
 	ret = open_ext2fs(devname, &ext2_fs);
 	if (ret) {
 		fprintf(stderr, "unable to open the Ext2fs\n");
@@ -2359,13 +2400,23 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "filetype feature is missing\n");
 		goto fail;
 	}
-	for (i = 0; i < 7; i++) {
-		ret = ext2_alloc_block(ext2_fs, 0, blocks + i);
-		if (ret) {
-			fprintf(stderr, "not enough free space\n");
-			goto fail;
-		}
-		blocks[i] *= blocksize;
+	ret = ext2_cache_free_extents(ext2_fs, &orig_free_tree);
+	if (ret) {
+		fprintf(stderr, "error during cache_free_extents %d\n", ret);
+		goto fail;
+	}
+	/* preserve first 64KiB, just in case */
+	clear_extent_dirty(&orig_free_tree, 0, BTRFS_SUPER_INFO_OFFSET - 1, 0);
+
+	ret = copy_dirtiness(&free_tree, &orig_free_tree);
+	if (ret) {
+		fprintf(stderr, "error during copy_dirtiness %d\n", ret);
+		goto fail;
+	}
+	adjust_free_extents(ext2_fs, &free_tree);
+	ret = alloc_blocks(&free_tree, blocks, 7, blocksize);
+	if (ret) {
+		goto fail;
 	}
 	super_bytenr = blocks[0];
 	fd = open(devname, O_RDWR);
@@ -2391,17 +2442,9 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
 	}
-	ret = cache_free_extents(root, ext2_fs);
-	if (ret) {
-		fprintf(stderr, "error during cache_free_extents %d\n", ret);
-		goto fail;
-	}
+	copy_dirtiness(&root->fs_info->free_space_cache, &free_tree);
+	extent_io_tree_cleanup(&free_tree);
 	root->fs_info->extent_ops = &extent_ops;
-	/* recover block allocation bitmap */
-	for (i = 0; i < 7; i++) {
-		blocks[i] /= blocksize;
-		ext2_free_block(ext2_fs, blocks[i]);
-	}
 	ret = init_btrfs(root);
 	if (ret) {
 		fprintf(stderr, "unable to setup the root tree\n");
@@ -2419,11 +2462,12 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "unable to create subvol\n");
 		goto fail;
 	}
-	ret = create_ext2_image(ext2_root, ext2_fs, "image");
+	ret = create_ext2_image(ext2_root, "image", &orig_free_tree);
 	if (ret) {
 		fprintf(stderr, "error during create_ext2_image %d\n", ret);
 		goto fail;
 	}
+	extent_io_tree_cleanup(&orig_free_tree);
 	printf("cleaning up system chunk.\n");
 	ret = cleanup_sys_chunk(root, ext2_root);
 	if (ret) {
-- 
1.6.4.4

