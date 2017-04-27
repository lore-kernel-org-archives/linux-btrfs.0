Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:47032
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752150AbdD0KGl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 06:06:41 -0400
Date: Thu, 27 Apr 2017 15:35:34 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170427100534.GA10404@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bug: Fail to convert 22TB EXT4 to BTRFS
https://bugzilla.kernel.org/show_bug.cgi?id=194795

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 convert/source-ext2.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

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

