Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbbEKGfB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 02:35:01 -0400
From: xuw2015@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>
Subject: [PATCHv2] btrfs: replace the 4096 magic number for block size
Date: Mon, 11 May 2015 14:34:55 +0800
Message-Id: <1431326095-25176-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: George Wang <xuw2015@gmail.com>

There are a lot of 4096 magic number in disk-io.c and volumes.c. Most of them
are used for block size of the bdev. By the block_size(bdev) and macor
BTRFS_MIN_BLOCK_SIZE, it can be more descriptive.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/btrfs/disk-io.c | 30 ++++++++++++++++--------------
 fs/btrfs/disk-io.h |  1 +
 fs/btrfs/volumes.c | 12 +++++++-----
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2ef9a4b..8f220a4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2548,8 +2548,8 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_balance(fs_info);
 	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
 
-	sb->s_blocksize = 4096;
-	sb->s_blocksize_bits = blksize_bits(4096);
+	sb->s_blocksize = BTRFS_MIN_BLOCK_SIZE;
+	sb->s_blocksize_bits = blksize_bits(BTRFS_MIN_BLOCK_SIZE);
 	sb->s_bdi = &fs_info->bdi;
 
 	btrfs_init_btree_inode(fs_info, tree_root);
@@ -3140,11 +3140,12 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	for (i = 0; i < 1; i++) {
+		unsigned int blksz = block_size(bdev);
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
 					i_size_read(bdev->bd_inode))
 			break;
-		bh = __bread(bdev, bytenr / 4096,
+		bh = __bread(bdev, bytenr / blksz,
 					BTRFS_SUPER_INFO_SIZE);
 		if (!bh)
 			continue;
@@ -3193,13 +3194,14 @@ static int write_dev_supers(struct btrfs_device *device,
 		max_mirrors = BTRFS_SUPER_MIRROR_MAX;
 
 	for (i = 0; i < max_mirrors; i++) {
+		unsigned int blksz = block_size(device->bdev);
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
 		    device->commit_total_bytes)
 			break;
 
 		if (wait) {
-			bh = __find_get_block(device->bdev, bytenr / 4096,
+			bh = __find_get_block(device->bdev, bytenr / blksz,
 					      BTRFS_SUPER_INFO_SIZE);
 			if (!bh) {
 				errors++;
@@ -3229,7 +3231,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			 * one reference for us, and we leave it for the
 			 * caller
 			 */
-			bh = __getblk(device->bdev, bytenr / 4096,
+			bh = __getblk(device->bdev, bytenr / blksz,
 				      BTRFS_SUPER_INFO_SIZE);
 			if (!bh) {
 				printk(KERN_ERR "BTRFS: couldn't get super "
@@ -3904,13 +3906,13 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
 	 * items yet, they'll be verified later. Issue just a warning.
 	 */
-	if (!IS_ALIGNED(btrfs_super_root(sb), 4096))
+	if (!IS_ALIGNED(btrfs_super_root(sb), BTRFS_MIN_BLOCK_SIZE))
 		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
 				btrfs_super_root(sb));
-	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096))
+	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), BTRFS_MIN_BLOCK_SIZE))
 		printk(KERN_WARNING "BTRFS: chunk_root block unaligned: %llu\n",
 				btrfs_super_chunk_root(sb));
-	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096))
+	if (!IS_ALIGNED(btrfs_super_log_root(sb), BTRFS_MIN_BLOCK_SIZE))
 		printk(KERN_WARNING "BTRFS: log_root block unaligned: %llu\n",
 				btrfs_super_log_root(sb));
 
@@ -3918,14 +3920,14 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Check the lower bound, the alignment and other constraints are
 	 * checked later.
 	 */
-	if (btrfs_super_nodesize(sb) < 4096) {
-		printk(KERN_ERR "BTRFS: nodesize too small: %u < 4096\n",
-				btrfs_super_nodesize(sb));
+	if (btrfs_super_nodesize(sb) < BTRFS_MIN_BLOCK_SIZE) {
+		printk(KERN_ERR "BTRFS: nodesize too small: %u < %d\n",
+				btrfs_super_nodesize(sb), BTRFS_MIN_BLOCK_SIZE);
 		ret = -EINVAL;
 	}
-	if (btrfs_super_sectorsize(sb) < 4096) {
-		printk(KERN_ERR "BTRFS: sectorsize too small: %u < 4096\n",
-				btrfs_super_sectorsize(sb));
+	if (btrfs_super_sectorsize(sb) < BTRFS_MIN_BLOCK_SIZE) {
+		printk(KERN_ERR "BTRFS: sectorsize too small: %u < %d\n",
+				btrfs_super_sectorsize(sb), BTRFS_MIN_BLOCK_SIZE);
 		ret = -EINVAL;
 	}
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index d4cbfee..6f43b33 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -21,6 +21,7 @@
 
 #define BTRFS_SUPER_INFO_OFFSET (64 * 1024)
 #define BTRFS_SUPER_INFO_SIZE 4096
+#define BTRFS_MIN_BLOCK_SIZE 4096
 
 #define BTRFS_SUPER_MIRROR_MAX	 3
 #define BTRFS_SUPER_MIRROR_SHIFT 12
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8bcd2a0..1f9d0de 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -200,7 +200,7 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 
 	if (flush)
 		filemap_write_and_wait((*bdev)->bd_inode->i_mapping);
-	ret = set_blocksize(*bdev, 4096);
+	ret = set_blocksize(*bdev, BTRFS_MIN_BLOCK_SIZE);
 	if (ret) {
 		blkdev_put(*bdev, flags);
 		goto error;
@@ -1746,14 +1746,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		 * the below would take of the rest
 		 */
 		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+			unsigned int blksz = block_size(bdev);
+
 			bytenr = btrfs_sb_offset(i);
 			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
 					i_size_read(bdev->bd_inode))
 				break;
 
 			brelse(bh);
-			bh = __bread(bdev, bytenr / 4096,
-					BTRFS_SUPER_INFO_SIZE);
+			bh = __bread(bdev, bytenr / blksz,
+							BTRFS_SUPER_INFO_SIZE);
 			if (!bh)
 				continue;
 
@@ -2167,7 +2169,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	device->is_tgtdev_for_dev_replace = 0;
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
-	set_blocksize(device->bdev, 4096);
+	set_blocksize(device->bdev, BTRFS_MIN_BLOCK_SIZE);
 
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
@@ -2374,7 +2376,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	device->is_tgtdev_for_dev_replace = 1;
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
-	set_blocksize(device->bdev, 4096);
+	set_blocksize(device->bdev, BTRFS_MIN_BLOCK_SIZE);
 	device->fs_devices = fs_info->fs_devices;
 	list_add(&device->dev_list, &fs_info->fs_devices->devices);
 	fs_info->fs_devices->num_devices++;
-- 
1.9.3

