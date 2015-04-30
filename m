Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbbD3JHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 05:07:31 -0400
From: xuw2015@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>
Subject: [PATCH 1/3] btrfs: introduce BTRFS_BLOCK_SIZE to replace number 4096
Date: Thu, 30 Apr 2015 17:07:23 +0800
Message-Id: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: George Wang <xuw2015@gmail.com>

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/btrfs/disk-io.c | 28 ++++++++++++++--------------
 fs/btrfs/disk-io.h |  3 ++-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2ef9a4b..342d4fc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2548,8 +2548,8 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_balance(fs_info);
 	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
 
-	sb->s_blocksize = 4096;
-	sb->s_blocksize_bits = blksize_bits(4096);
+	sb->s_blocksize = BTRFS_BLOCK_SIZE;
+	sb->s_blocksize_bits = blksize_bits(BTRFS_BLOCK_SIZE);
 	sb->s_bdi = &fs_info->bdi;
 
 	btrfs_init_btree_inode(fs_info, tree_root);
@@ -3144,7 +3144,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
 					i_size_read(bdev->bd_inode))
 			break;
-		bh = __bread(bdev, bytenr / 4096,
+		bh = __bread(bdev, bytenr / BTRFS_BLOCK_SIZE,
 					BTRFS_SUPER_INFO_SIZE);
 		if (!bh)
 			continue;
@@ -3199,7 +3199,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			break;
 
 		if (wait) {
-			bh = __find_get_block(device->bdev, bytenr / 4096,
+			bh = __find_get_block(device->bdev, bytenr / BTRFS_BLOCK_SIZE,
 					      BTRFS_SUPER_INFO_SIZE);
 			if (!bh) {
 				errors++;
@@ -3229,7 +3229,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			 * one reference for us, and we leave it for the
 			 * caller
 			 */
-			bh = __getblk(device->bdev, bytenr / 4096,
+			bh = __getblk(device->bdev, bytenr / BTRFS_BLOCK_SIZE,
 				      BTRFS_SUPER_INFO_SIZE);
 			if (!bh) {
 				printk(KERN_ERR "BTRFS: couldn't get super "
@@ -3904,13 +3904,13 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
 	 * items yet, they'll be verified later. Issue just a warning.
 	 */
-	if (!IS_ALIGNED(btrfs_super_root(sb), 4096))
+	if (!IS_ALIGNED(btrfs_super_root(sb), BTRFS_BLOCK_SIZE))
 		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
 				btrfs_super_root(sb));
-	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096))
+	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), BTRFS_BLOCK_SIZE))
 		printk(KERN_WARNING "BTRFS: chunk_root block unaligned: %llu\n",
 				btrfs_super_chunk_root(sb));
-	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096))
+	if (!IS_ALIGNED(btrfs_super_log_root(sb), BTRFS_BLOCK_SIZE))
 		printk(KERN_WARNING "BTRFS: log_root block unaligned: %llu\n",
 				btrfs_super_log_root(sb));
 
@@ -3918,14 +3918,14 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Check the lower bound, the alignment and other constraints are
 	 * checked later.
 	 */
-	if (btrfs_super_nodesize(sb) < 4096) {
-		printk(KERN_ERR "BTRFS: nodesize too small: %u < 4096\n",
-				btrfs_super_nodesize(sb));
+	if (btrfs_super_nodesize(sb) < BTRFS_BLOCK_SIZE) {
+		printk(KERN_ERR "BTRFS: nodesize too small: %u < %d\n",
+				btrfs_super_nodesize(sb), BTRFS_BLOCK_SIZE);
 		ret = -EINVAL;
 	}
-	if (btrfs_super_sectorsize(sb) < 4096) {
-		printk(KERN_ERR "BTRFS: sectorsize too small: %u < 4096\n",
-				btrfs_super_sectorsize(sb));
+	if (btrfs_super_sectorsize(sb) < BTRFS_BLOCK_SIZE) {
+		printk(KERN_ERR "BTRFS: sectorsize too small: %u < %d\n",
+				btrfs_super_sectorsize(sb), BTRFS_BLOCK_SIZE);
 		ret = -EINVAL;
 	}
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index d4cbfee..4d246ff 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -19,8 +19,9 @@
 #ifndef __DISKIO__
 #define __DISKIO__
 
+#define BTRFS_BLOCK_SIZE 4096
 #define BTRFS_SUPER_INFO_OFFSET (64 * 1024)
-#define BTRFS_SUPER_INFO_SIZE 4096
+#define BTRFS_SUPER_INFO_SIZE BTRFS_BLOCK_SIZE
 
 #define BTRFS_SUPER_MIRROR_MAX	 3
 #define BTRFS_SUPER_MIRROR_SHIFT 12
-- 
1.9.3

