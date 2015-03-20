Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:49533 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbbCTBLT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 21:11:19 -0400
Received: from localhost (mxf2.local [127.0.0.1])
	by mxf2-reinject (Postfix) with ESMTP id 5E1A41E949A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:11:17 +0100 (CET)
Received: from mxf2.bahnhof.se ([127.0.0.1])
	by localhost (mxf2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id biZBokqRlpmx for <linux-btrfs@vger.kernel.org>;
	Fri, 20 Mar 2015 02:11:11 +0100 (CET)
Received: from miria.naju.se (h-219-91.a163.priv.bahnhof.se [85.24.219.91])
	by mxf2.bahnhof.se (Postfix) with ESMTP id 7D0F11E944F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:11:11 +0100 (CET)
Received: from sebban (helo=localhost)
	by miria.naju.se with local-esmtp (Exim 4.80)
	(envelope-from <sebth@naju.se>)
	id 1YYlSx-0006zQ-9z
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 02:11:11 +0100
Date: Fri, 20 Mar 2015 02:11:11 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] btrfs-progs: btrfs-convert: Allow setting nodesize
In-Reply-To: <cover.1426812639.git.sebth@naju.se>
Message-ID: <2256058c25010c686a8461ce0949fb8a73fc6a92.1426812639.git.sebth@naju.se>
References: <cover.1426812639.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow btrfs-convert to use nodesizes other than 4096. It defaults to
max(16384, pagesize), like mkfs.

Signed-off-by: Sebastian Thorarensen <sebth@naju.se>
---
 Documentation/btrfs-convert.txt |    4 +++
 btrfs-convert.c                 |   60 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 6a9e1de..89b2fbd 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -23,6 +23,10 @@ Disable data checksum.
 Ignore xattrs and ACLs.
 -n::
 Disable packing of small files.
+-N <SIZE>::
+Set filesystem nodesize, the tree block size in which btrfs stores data.
+The default value is 16KB (16384) or the page size, whichever is bigger.
+Must be a multiple of the sectorsize, but not larger than 65536.
 -r::
 Roll back to ext2fs.
 -l <LABEL>::
diff --git a/btrfs-convert.c b/btrfs-convert.c
index 205eaf5..0ee023d 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -141,6 +141,25 @@ static int ext2_alloc_block(ext2_filsys fs, u64 goal, u64 *block_ret)
 	return -ENOSPC;
 }
 
+static int ext2_alloc_block_range(ext2_filsys fs, u64 goal, int num,
+		u64 *block_ret)
+{
+	blk_t block;
+	ext2fs_block_bitmap bitmap = fs->block_map;
+	blk_t start = ext2fs_get_block_bitmap_start(bitmap);
+	blk_t end = ext2fs_get_block_bitmap_end(bitmap);
+
+	for (block = max_t(u64, goal, start); block + num < end; block++) {
+		if (ext2fs_fast_test_block_bitmap_range(bitmap, block, num)) {
+			ext2fs_fast_mark_block_bitmap_range(bitmap, block,
+					num);
+			*block_ret = block;
+			return 0;
+		}
+	}
+	return -ENOSPC;
+}
+
 static int ext2_free_block(ext2_filsys fs, u64 block)
 {
 	BUG_ON(block != (blk_t)block);
@@ -148,6 +167,13 @@ static int ext2_free_block(ext2_filsys fs, u64 block)
 	return 0;
 }
 
+static int ext2_free_block_range(ext2_filsys fs, u64 block, int num)
+{
+	BUG_ON(block != (blk_t)block);
+	ext2fs_fast_unmark_block_bitmap_range(fs->block_map, block, num);
+	return 0;
+}
+
 static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
 
 {
@@ -2233,9 +2259,9 @@ err:
 }
 
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
-	       int copylabel, const char *fslabel, int progress)
+		u32 nodesize, int copylabel, const char *fslabel, int progress)
 {
-	int i, ret;
+	int i, ret, blocks_per_node;
 	int fd = -1;
 	u32 blocksize;
 	u64 blocks[7];
@@ -2262,8 +2288,17 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		fprintf(stderr, "filetype feature is missing\n");
 		goto fail;
 	}
+	if (check_node_or_leaf_size(nodesize, blocksize))
+		goto fail;
+	blocks_per_node = nodesize / blocksize;
+	ret = -blocks_per_node;
 	for (i = 0; i < 7; i++) {
-		ret = ext2_alloc_block(ext2_fs, 0, blocks + i);
+		if (nodesize == blocksize)
+			ret = ext2_alloc_block(ext2_fs, 0, blocks + i);
+		else
+			ret = ext2_alloc_block_range(ext2_fs,
+					ret + blocks_per_node, blocks_per_node,
+					blocks + i);
 		if (ret) {
 			fprintf(stderr, "not enough free space\n");
 			goto fail;
@@ -2277,7 +2312,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		goto fail;
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
-			 NULL, blocks, total_bytes, blocksize, blocksize,
+			 NULL, blocks, total_bytes, nodesize, nodesize,
 			 blocksize, blocksize, 0);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree: %s\n",
@@ -2304,7 +2339,11 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	/* recover block allocation bitmap */
 	for (i = 0; i < 7; i++) {
 		blocks[i] /= blocksize;
-		ext2_free_block(ext2_fs, blocks[i]);
+		if (nodesize == blocksize)
+			ext2_free_block(ext2_fs, blocks[i]);
+		else
+			ext2_free_block_range(ext2_fs, blocks[i],
+					blocks_per_node);
 	}
 	ret = init_btrfs(root);
 	if (ret) {
@@ -2764,6 +2803,7 @@ static void print_usage(void)
 	printf("\t-d             disable data checksum\n");
 	printf("\t-i             ignore xattrs and ACLs\n");
 	printf("\t-n             disable packing of small files\n");
+	printf("\t-N SIZE        set filesystem nodesize\n");
 	printf("\t-r             roll back to ext2fs\n");
 	printf("\t-l LABEL       set filesystem label\n");
 	printf("\t-L             use label from converted fs\n");
@@ -2777,6 +2817,8 @@ int main(int argc, char *argv[])
 	int packing = 1;
 	int noxattr = 0;
 	int datacsum = 1;
+	u32 nodesize = max_t(u32, sysconf(_SC_PAGESIZE),
+			BTRFS_MKFS_DEFAULT_NODE_SIZE);
 	int rollback = 0;
 	int copylabel = 0;
 	int usage_error = 0;
@@ -2791,7 +2833,7 @@ int main(int argc, char *argv[])
 			{ "no-progress", no_argument, NULL, GETOPT_VAL_IEC},
 			{ NULL, 0, NULL, 0 }
 		};
-		int c = getopt_long(argc, argv, "dinrl:Lp", long_options,
+		int c = getopt_long(argc, argv, "dinN:rl:Lp", long_options,
 				&long_index);
 
 		if (c < 0)
@@ -2806,6 +2848,9 @@ int main(int argc, char *argv[])
 			case 'n':
 				packing = 0;
 				break;
+			case 'N':
+				nodesize = parse_size(optarg);
+				break;
 			case 'r':
 				rollback = 1;
 				break;
@@ -2865,7 +2910,8 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file);
 	} else {
-		ret = do_convert(file, datacsum, packing, noxattr, copylabel, fslabel, progress);
+		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
+				copylabel, fslabel, progress);
 	}
 	if (ret)
 		return 1;
-- 
1.7.10.4

