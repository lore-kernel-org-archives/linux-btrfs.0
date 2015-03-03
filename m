Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:49380 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbbCCMVC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 07:21:02 -0500
Received: from localhost (mxf2.local [127.0.0.1])
	by mxf2-reinject (Postfix) with ESMTP id 467E41D977B
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2015 12:47:48 +0100 (CET)
Received: from mxf2.bahnhof.se ([127.0.0.1])
	by localhost (mxf2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LPc3hVpyPCj4 for <linux-btrfs@vger.kernel.org>;
	Tue,  3 Mar 2015 12:47:40 +0100 (CET)
Received: from miria.naju.se (h-219-91.a163.priv.bahnhof.se [85.24.219.91])
	by mxf2.bahnhof.se (Postfix) with ESMTP id 231161D977D
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2015 12:47:39 +0100 (CET)
Received: from sebban (helo=localhost)
	by miria.naju.se with local-esmtp (Exim 4.80)
	(envelope-from <sebth@naju.se>)
	id 1YSlIZ-0002vn-L9
	for linux-btrfs@vger.kernel.org; Tue, 03 Mar 2015 12:47:39 +0100
Date: Tue, 3 Mar 2015 12:47:39 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
Message-ID: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow btrfs-convert to use nodesizes other than 4096. It defaults to
max(16384, pagesize), like mkfs. The constant DEFAULT_MKFS_LEAF_SIZE has
been moved to utils.h and renamed to BTRFS_MKFS_DEFAULT_NODE_SIZE for
consistency. convert-tests now test both 4096 and 16384 nodesizes.

Signed-off-by: Sebastian Thorarensen <sebth@naju.se>
---
 Documentation/btrfs-convert.txt |    4 ++
 btrfs-convert.c                 |   80 +++++++++++++++++++++++++++++++++++----
 mkfs.c                          |    5 +--
 tests/convert-tests.sh          |   15 +++++---
 utils.h                         |    1 +
 5 files changed, 89 insertions(+), 16 deletions(-)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index e508c34..5cf9d03 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -23,6 +23,10 @@ Disable data checksum.
 Ignore xattrs and ACLs.
 -n::
 Disable packing of small files.
+-N <SIZE>::
+Set filesystem nodesize, the tree block size in which btrfs stores data.
+The default value is 16KB (16384) or the page size, whichever is bigger.
+Must be a multiple of the ext2/3/4 block size, but not larger than 65536.
 -r::
 Roll back to ext2fs.
 -l <LABEL>::
diff --git a/btrfs-convert.c b/btrfs-convert.c
index da10ad6..4163076 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -140,6 +140,25 @@ static int ext2_alloc_block(ext2_filsys fs, u64 goal, u64 *block_ret)
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
@@ -147,6 +166,13 @@ static int ext2_free_block(ext2_filsys fs, u64 block)
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
@@ -2231,10 +2257,28 @@ err:
 	return ret;
 }
 
+static int check_nodesize(u32 nodesize, u32 sectorsize)
+{
+	if (nodesize < sectorsize) {
+		fprintf(stderr, "illegal nodesize %u (smaller than %u)\n",
+			nodesize, sectorsize);
+		return -1;
+	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		fprintf(stderr, "illegal nodesize %u (larger than %u)\n",
+			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
+		return -1;
+	} else if (nodesize & (sectorsize - 1)) {
+		fprintf(stderr, "illegal nodesize %u (not aligned to %u)\n",
+			nodesize, sectorsize);
+		return -1;
+	}
+	return 0;
+}
+
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
-	       int copylabel, const char *fslabel, int progress)
+		u32 nodesize, int copylabel, const char *fslabel, int progress)
 {
-	int i, ret;
+	int i, ret, blocks_per_node;
 	int fd = -1;
 	u32 blocksize;
 	u64 blocks[7];
@@ -2261,8 +2305,17 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		fprintf(stderr, "filetype feature is missing\n");
 		goto fail;
 	}
+	if (check_nodesize(nodesize, blocksize))
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
@@ -2276,7 +2329,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		goto fail;
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
-			 NULL, blocks, total_bytes, blocksize, blocksize,
+			 NULL, blocks, total_bytes, nodesize, nodesize,
 			 blocksize, blocksize, 0);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree: %s\n",
@@ -2303,7 +2356,11 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
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
@@ -2759,10 +2816,11 @@ fail:
 
 static void print_usage(void)
 {
-	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-l label] [-L] device\n");
+	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-N size] [-l label] [-L] device\n");
 	printf("\t-d           disable data checksum\n");
 	printf("\t-i           ignore xattrs and ACLs\n");
 	printf("\t-n           disable packing of small files\n");
+	printf("\t-N SIZE      set filesystem nodesize\n");
 	printf("\t-r           roll back to ext2fs\n");
 	printf("\t-l LABEL     set filesystem label\n");
 	printf("\t-L           use label from converted fs\n");
@@ -2775,6 +2833,8 @@ int main(int argc, char *argv[])
 	int packing = 1;
 	int noxattr = 0;
 	int datacsum = 1;
+	u32 nodesize = max_t(u32, sysconf(_SC_PAGESIZE),
+			BTRFS_MKFS_DEFAULT_NODE_SIZE);
 	int rollback = 0;
 	int copylabel = 0;
 	int usage_error = 0;
@@ -2783,7 +2843,7 @@ int main(int argc, char *argv[])
 	char *fslabel = NULL;
 
 	while(1) {
-		int c = getopt(argc, argv, "dinrl:Lp");
+		int c = getopt(argc, argv, "dinN:rl:Lp");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -2796,6 +2856,9 @@ int main(int argc, char *argv[])
 			case 'n':
 				packing = 0;
 				break;
+			case 'N':
+				nodesize = parse_size(optarg);
+				break;
 			case 'r':
 				rollback = 1;
 				break;
@@ -2852,7 +2915,8 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file);
 	} else {
-		ret = do_convert(file, datacsum, packing, noxattr, copylabel, fslabel, progress);
+		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
+				copylabel, fslabel, progress);
 	}
 	if (ret)
 		return 1;
diff --git a/mkfs.c b/mkfs.c
index f83554d..3c1ed7e 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -47,8 +47,6 @@ static u64 index_cnt = 2;
 #define DEFAULT_MKFS_FEATURES	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF \
 		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
-#define DEFAULT_MKFS_LEAF_SIZE 16384
-
 struct directory_name_entry {
 	char *dir_name;
 	char *path;
@@ -1230,7 +1228,8 @@ int main(int ac, char **av)
 	u64 alloc_start = 0;
 	u64 metadata_profile = 0;
 	u64 data_profile = 0;
-	u32 leafsize = max_t(u32, sysconf(_SC_PAGESIZE), DEFAULT_MKFS_LEAF_SIZE);
+	u32 leafsize = max_t(u32, sysconf(_SC_PAGESIZE),
+			BTRFS_MKFS_DEFAULT_NODE_SIZE);
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
 	u32 stripesize = 4096;
diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 6094287..3d912f3 100644
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -16,7 +16,8 @@ rm -f convert-tests-results.txt
 
 test(){
 	echo "    [TEST]   $1"
-	shift
+	nodesize=$2
+	shift 2
 	echo "creating ext image with: $*" >> convert-tests-results.txt
 	# 256MB is the smallest acceptable btrfs image.
 	rm -f $here/test.img >> convert-tests-results.txt 2>&1 \
@@ -25,13 +26,17 @@ test(){
 		|| _fail "could not create test image file"
 	$* -F $here/test.img >> convert-tests-results.txt 2>&1 \
 		|| _fail "filesystem create failed"
-	$here/btrfs-convert $here/test.img >> convert-tests-results.txt 2>&1 \
+	$here/btrfs-convert -N "$nodesize" $here/test.img \
+			>> convert-tests-results.txt 2>&1 \
 		|| _fail "btrfs-convert failed"
 	$here/btrfs check $here/test.img >> convert-tests-results.txt 2>&1 \
 		|| _fail "btrfs check detected errors"
 }
 
 # btrfs-convert requires 4k blocksize.
-test "ext2" mke2fs -b 4096
-test "ext3" mke2fs -j -b 4096
-test "ext4" mke2fs -t ext4 -b 4096
+test "ext2 4k nodesize" 4096 mke2fs -b 4096
+test "ext3 4k nodesize" 4096 mke2fs -j -b 4096
+test "ext4 4k nodesize" 4096 mke2fs -t ext4 -b 4096
+test "ext2 16k nodesize" 16384 mke2fs -b 4096
+test "ext3 16k nodesize" 16384 mke2fs -j -b 4096
+test "ext4 16k nodesize" 16384 mke2fs -t ext4 -b 4096
diff --git a/utils.h b/utils.h
index 82ab5e8..170e5cd 100644
--- a/utils.h
+++ b/utils.h
@@ -25,6 +25,7 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
+#define BTRFS_MKFS_DEFAULT_NODE_SIZE 16384
 
 #define BTRFS_SCAN_MOUNTED	(1ULL << 0)
 #define BTRFS_SCAN_LBLKID	(1ULL << 1)
-- 
1.7.10.4
