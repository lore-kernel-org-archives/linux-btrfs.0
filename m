Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:49940
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750765AbdFCJ67 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Jun 2017 05:58:59 -0400
Date: Sat, 3 Jun 2017 15:27:45 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, dsterba <dsterba@suse.cz>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170603095745.GA4730@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With larger file system (in this case its 22TB), ext2fs_open() returns
EXT2_ET_CANT_USE_LEGACY_BITMAPS error message with ext2fs_read_block_bitmap().

To overcome this issue, (a) we need pass EXT2_FLAG_64BITS flag with ext2fs_open.
(b) use 64-bit functions like ext2fs_get_block_bitmap_range2,
ext2fs_inode_data_blocks2,ext2fs_read_ext_attr2. (c) use 64bit types with
btrfs_convert_context fields.

bug: https://bugzilla.kernel.org/show_bug.cgi?id=194795
Signed-off-by: Lakshmipathi.G <lakshmipathi.g@giis.co.in>
---
 convert/common.h      |  8 ++++----
 convert/source-ext2.c | 11 ++++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/convert/common.h b/convert/common.h
index 0d3adea..2f4ea48 100644
--- a/convert/common.h
+++ b/convert/common.h
@@ -30,10 +30,10 @@ struct btrfs_mkfs_config;
 
 struct btrfs_convert_context {
 	u32 blocksize;
-	u32 first_data_block;
-	u32 block_count;
-	u32 inodes_count;
-	u32 free_inodes_count;
+	u64 first_data_block;
+	u64 block_count;
+	u64 inodes_count;
+	u64 free_inodes_count;
 	u64 total_bytes;
 	char *volume_name;
 	const struct btrfs_convert_operations *convert_ops;
diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index 1b0576b..275cb89 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -34,8 +34,9 @@ static int ext2_open_fs(struct btrfs_convert_context *cctx, const char *name)
 	ext2_filsys ext2_fs;
 	ext2_ino_t ino;
 	u32 ro_feature;
+	int open_flag = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
 
-	ret = ext2fs_open(name, 0, 0, 0, unix_io_manager, &ext2_fs);
+	ret = ext2fs_open(name, open_flag, 0, 0, unix_io_manager, &ext2_fs);
 	if (ret) {
 		fprintf(stderr, "ext2fs_open: %s\n", error_message(ret));
 		return -1;
@@ -148,7 +149,7 @@ static int ext2_read_used_space(struct btrfs_convert_context *cctx)
 		return -ENOMEM;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		ret = ext2fs_get_block_bitmap_range(fs->block_map, blk_itr,
+		ret = ext2fs_get_block_bitmap_range2(fs->block_map, blk_itr,
 						block_nbytes * 8, block_bitmap);
 		if (ret) {
 			error("fail to get bitmap from ext2, %s",
@@ -353,7 +354,7 @@ static int ext2_create_symlink(struct btrfs_trans_handle *trans,
 	int ret;
 	char *pathname;
 	u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
-	if (ext2fs_inode_data_blocks(ext2_fs, ext2_inode)) {
+	if (ext2fs_inode_data_blocks2(ext2_fs, ext2_inode)) {
 		btrfs_set_stack_inode_size(btrfs_inode, inode_size + 1);
 		ret = ext2_create_file_extents(trans, root, objectid,
 				btrfs_inode, ext2_fs, ext2_ino,
@@ -627,9 +628,9 @@ static int ext2_copy_extended_attrs(struct btrfs_trans_handle *trans,
 		ret = -ENOMEM;
 		goto out;
 	}
-	err = ext2fs_read_ext_attr(ext2_fs, ext2_inode->i_file_acl, buffer);
+	err = ext2fs_read_ext_attr2(ext2_fs, ext2_inode->i_file_acl, buffer);
 	if (err) {
-		fprintf(stderr, "ext2fs_read_ext_attr: %s\n",
+		fprintf(stderr, "ext2fs_read_ext_attr2: %s\n",
 			error_message(err));
 		ret = -1;
 		goto out;
-- 
2.7.4

