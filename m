Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45621 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695AbbDBCXk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 22:23:40 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t322MXmS018150
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Apr 2015 10:22:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: convert: Make ext*_image file obey datacsum setting.
Date: Thu, 2 Apr 2015 10:21:35 +0800
Message-ID: <1427941296-19502-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, ext*_image is always set NODATACSUM inode flag.
However btrfs-convert will set normal file with DATACUSM flag by
default, and generate checksum for regular file extent.

Now, a regular file extent is shared by a btrfs file inode with DATACSUM
and ext*_image with NODATACSUM, and it has checksum in csum tree.
This will cause btrfsck complain about odd checksum, since ext*_image is
set NODATACSUM but has checksum generated from regular file extent.

This patch makes convert completely obey datacsum setting, meaning
btrfs-convert will generate csum for every file extent by default.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 4dc33b3..d742307 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1161,7 +1161,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root, u64 objectid,
 				   struct btrfs_inode_item *inode,
 				   u64 start_byte, u64 end_byte,
-				   ext2_filsys ext2_fs)
+				   ext2_filsys ext2_fs, int datacsum)
 {
 	u32 blocksize = ext2_fs->blocksize;
 	u32 block = start_byte / blocksize;
@@ -1176,7 +1176,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 		.disk_block	= 0,
 		.num_blocks	= 0,
 		.boundary	= (u64)-1,
-		.checksum 	= 0,
+		.checksum	= datacsum,
 		.errcode	= 0,
 	};
 	for (; start_byte < end_byte; block++, start_byte += blocksize) {
@@ -1191,7 +1191,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	if (data.num_blocks > 0) {
 		ret = record_file_blocks(trans, root, objectid, inode,
 					 data.first_block, data.disk_block,
-					 data.num_blocks, 0);
+					 data.num_blocks, datacsum);
 		if (ret)
 			goto fail;
 		data.first_block += data.num_blocks;
@@ -1199,7 +1199,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	if (last_block > data.first_block) {
 		ret = record_file_blocks(trans, root, objectid, inode,
 					 data.first_block, 0, last_block -
-					 data.first_block, 0);
+					 data.first_block, datacsum);
 		if (ret)
 			goto fail;
 	}
@@ -1210,7 +1210,7 @@ fail:
  * Create the ext2fs image file.
  */
 static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
-			     const char *name)
+			     const char *name, int datacsum)
 {
 	int ret;
 	struct btrfs_key key;
@@ -1231,11 +1231,14 @@ static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
 	u64 last_byte;
 	u64 first_free;
 	u64 total_bytes;
+	u64 flags = BTRFS_INODE_READONLY;
 	u32 sectorsize = root->sectorsize;
 
 	total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	first_free =  BTRFS_SUPER_INFO_OFFSET + sectorsize * 2 - 1;
 	first_free &= ~((u64)sectorsize - 1);
+	if (!datacsum)
+		flags |= BTRFS_INODE_NODATASUM;
 
 	memset(&btrfs_inode, 0, sizeof(btrfs_inode));
 	btrfs_set_stack_inode_generation(&btrfs_inode, 1);
@@ -1243,8 +1246,7 @@ static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
 	btrfs_set_stack_inode_nlink(&btrfs_inode, 1);
 	btrfs_set_stack_inode_nbytes(&btrfs_inode, 0);
 	btrfs_set_stack_inode_mode(&btrfs_inode, S_IFREG | 0400);
-	btrfs_set_stack_inode_flags(&btrfs_inode, BTRFS_INODE_NODATASUM |
-				    BTRFS_INODE_READONLY);
+	btrfs_set_stack_inode_flags(&btrfs_inode,  flags);
 	btrfs_init_path(&path);
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
@@ -1271,6 +1273,12 @@ static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
 					       key.objectid, sectorsize);
 		if (ret)
 			goto fail;
+		if (datacsum) {
+			ret = csum_disk_extent(trans, root, key.objectid,
+					       sectorsize);
+			if (ret)
+				goto fail;
+		}
 	}
 
 	while(1) {
@@ -1323,7 +1331,8 @@ next:
 		if (bytenr > last_byte) {
 			ret = create_image_file_range(trans, root, objectid,
 						      &btrfs_inode, last_byte,
-						      bytenr, ext2_fs);
+						      bytenr, ext2_fs,
+						      datacsum);
 			if (ret)
 				goto fail;
 		}
@@ -1346,7 +1355,8 @@ next:
 	if (total_bytes > last_byte) {
 		ret = create_image_file_range(trans, root, objectid,
 					      &btrfs_inode, last_byte,
-					      total_bytes, ext2_fs);
+					      total_bytes, ext2_fs,
+					      datacsum);
 		if (ret)
 			goto fail;
 	}
@@ -2374,7 +2384,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		fprintf(stderr, "unable to create subvol\n");
 		goto fail;
 	}
-	ret = create_ext2_image(ext2_root, ext2_fs, "image");
+	ret = create_ext2_image(ext2_root, ext2_fs, "image", datacsum);
 	if (ret) {
 		fprintf(stderr, "error during create_ext2_image %d\n", ret);
 		goto fail;
-- 
2.3.4

