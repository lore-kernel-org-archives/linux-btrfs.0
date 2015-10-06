Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30327 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbbJFPTp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:19:45 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH V2 6/7] Btrfs: make use of btrfs_scratch_superblocks() in btrfs_rm_device()
Date: Tue,  6 Oct 2015 23:19:23 +0800
Message-Id: <1444144764-2384-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the previous patches now the btrfs_scratch_superblocks()
is ready to be used in btrfs_rm_device() so use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: changelog update

 fs/btrfs/volumes.c | 78 ++++++++++--------------------------------------------
 1 file changed, 14 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e929211..69d311c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1676,13 +1676,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 {
 	struct btrfs_device *device;
 	struct btrfs_device *next_device;
-	struct block_device *bdev = NULL;
-	struct buffer_head *bh = NULL;
-	struct btrfs_super_block *disk_super = NULL;
 	struct btrfs_fs_devices *cur_devices;
 	u64 num_devices;
 	int ret = 0;
 	bool clear_super = false;
+	char *dev_name = NULL;
 
 	mutex_lock(&uuid_mutex);
 
@@ -1710,6 +1708,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		list_del_init(&device->dev_alloc_list);
 		device->fs_devices->rw_devices--;
 		unlock_chunks(root);
+		dev_name = kstrdup(device->name->str, GFP_NOFS);
+		if (!dev_name) {
+			ret = -ENOMEM;
+			goto error_undo;
+		}
 		clear_super = true;
 	}
 
@@ -1793,73 +1796,20 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * remove it from the devices list and zero out the old super
 	 */
 	if (clear_super) {
-		u64 bytenr;
-		int i;
-
-		if (!disk_super) {
-			ret = btrfs_get_bdev_and_sb(device_path,
-					FMODE_WRITE | FMODE_EXCL,
-					root->fs_info->bdev_holder, 0,
-					&bdev, &bh);
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
+		struct block_device *bdev;
 
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
-
-			/* Update ctime/mtime for device path for libblkid */
-			update_dev_time(device_path);
+		bdev = blkdev_get_by_path(dev_name, FMODE_READ | FMODE_EXCL,
+						root->fs_info->bdev_holder);
+		if (!IS_ERR(bdev)) {
+			btrfs_scratch_superblocks(bdev, dev_name);
 			blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 		}
 	}
 
 out:
+	if (dev_name)
+		kfree(dev_name);
+
 	mutex_unlock(&uuid_mutex);
 	return ret;
 
-- 
2.4.1

