Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28485 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbbD0HhL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 03:37:11 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, m_btrfs@ml1.co.uk
Subject: [PATCH 8/8] Btrfs: use btrfs_scratch_superblock() in btrfs_rm_device()
Date: Mon, 27 Apr 2015 15:34:15 +0800
Message-Id: <1430120055-10381-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430120055-10381-1-git-send-email-anand.jain@oracle.com>
References: <1429525756-2727-2-git-send-email-anand.jain@oracle.com>
 <1430120055-10381-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the previous patches now the btrfs_scratch_superblock()
is ready to be used in btrfs_rm_device() so use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 69 ++++--------------------------------------------------
 1 file changed, 5 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4fd7010..d722ee5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1659,9 +1659,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 {
 	struct btrfs_device *device;
 	struct btrfs_device *next_device;
-	struct block_device *bdev = NULL;
-	struct buffer_head *bh = NULL;
-	struct btrfs_super_block *disk_super = NULL;
 	struct btrfs_fs_devices *cur_devices;
 	u64 num_devices;
 	int ret = 0;
@@ -1783,68 +1780,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 	 * remove it from the devices list and zero out the old super
 	 */
 	if (clear_super) {
-		u64 bytenr;
-		int i;
-
-		if (!disk_super) {
-			ret = btrfs_get_bdev_and_sb(dev_name,
-					    FMODE_WRITE | FMODE_EXCL,
-					    root->fs_info->bdev_holder, 0,
-					    &bdev, &bh);
-			if (ret) {
-				/*
-				 * It could be a failed device ok for clear_super
-				 * to fail. So return success
-				 */
-				ret = 0;
-				goto out;
-			}
-
-			disk_super = (struct btrfs_super_block *)bh->b_data;
-		}
-		/* make sure this device isn't detected as part of
-		 * the FS anymore
-		 */
-		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-		set_buffer_dirty(bh);
-		sync_dirty_buffer(bh);
-		brelse(bh);
-
-		/* clear the mirror copies of super block on the disk
-		 * being removed, 0th copy is been taken care above and
-		 * the below would take of the rest
-		 */
-		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-			bytenr = btrfs_sb_offset(i);
-			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-					i_size_read(bdev->bd_inode))
-				break;
-
-			bh = __bread(bdev, bytenr / 4096,
-					BTRFS_SUPER_INFO_SIZE);
-			if (!bh)
-				continue;
-
-			disk_super = (struct btrfs_super_block *)bh->b_data;
-
-			if (btrfs_super_bytenr(disk_super) != bytenr ||
-				btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
-				brelse(bh);
-				continue;
-			}
-			memset(&disk_super->magic, 0,
-						sizeof(disk_super->magic));
-			set_buffer_dirty(bh);
-			sync_dirty_buffer(bh);
-			brelse(bh);
-		}
-
-		if (bdev) {
-			/* Notify udev that device has changed */
-			btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
+		struct block_device *bdev;
 
-			/* Update ctime/mtime for device path for libblkid */
-			update_dev_time(dev_name);
+		bdev = blkdev_get_by_path(dev_name, FMODE_READ | FMODE_EXCL,
+						root->fs_info->bdev_holder);
+		if (!IS_ERR(bdev)) {
+			btrfs_scratch_superblock(bdev, dev_name);
 			blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 		}
 	}
-- 
2.0.0.153.g79dcccc

