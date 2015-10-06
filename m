Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30293 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbbJFPTm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:19:42 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/7] Btrfs: make use of btrfs_find_device_by_user_input()
Date: Tue,  6 Oct 2015 23:19:21 +0800
Message-Id: <1444144764-2384-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rm_device() has a section of the code which can be replaced
btrfs_find_device_by_user_input()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 100 ++++++++++++++++++++---------------------------------
 1 file changed, 37 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9243f8e..fbbe3fe 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1676,13 +1676,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 {
 	struct btrfs_device *device;
 	struct btrfs_device *next_device;
-	struct block_device *bdev;
+	struct block_device *bdev = NULL;
 	struct buffer_head *bh = NULL;
-	struct btrfs_super_block *disk_super;
+	struct btrfs_super_block *disk_super = NULL;
 	struct btrfs_fs_devices *cur_devices;
-	u64 devid;
 	u64 num_devices;
-	u8 *dev_uuid;
 	int ret = 0;
 	bool clear_super = false;
 
@@ -1692,57 +1690,19 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (ret)
 		goto out;
 
-	if (strcmp(device_path, "missing") == 0) {
-		struct list_head *devices;
-		struct btrfs_device *tmp;
-
-		device = NULL;
-		devices = &root->fs_info->fs_devices->devices;
-		/*
-		 * It is safe to read the devices since the volume_mutex
-		 * is held.
-		 */
-		list_for_each_entry(tmp, devices, dev_list) {
-			if (tmp->in_fs_metadata &&
-			    !tmp->is_tgtdev_for_dev_replace &&
-			    !tmp->bdev) {
-				device = tmp;
-				break;
-			}
-		}
-		bdev = NULL;
-		bh = NULL;
-		disk_super = NULL;
-		if (!device) {
-			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
-			goto out;
-		}
-	} else {
-		ret = btrfs_get_bdev_and_sb(device_path,
-					    FMODE_WRITE | FMODE_EXCL,
-					    root->fs_info->bdev_holder, 0,
-					    &bdev, &bh);
-		if (ret)
-			goto out;
-		disk_super = (struct btrfs_super_block *)bh->b_data;
-		devid = btrfs_stack_device_id(&disk_super->dev_item);
-		dev_uuid = disk_super->dev_item.uuid;
-		device = btrfs_find_device(root->fs_info, devid, dev_uuid,
-					   disk_super->fsid);
-		if (!device) {
-			ret = -ENOENT;
-			goto error_brelse;
-		}
-	}
+	ret = btrfs_find_device_by_user_input(root, 0, device_path,
+				&device);
+	if (ret)
+		goto out;
 
 	if (device->is_tgtdev_for_dev_replace) {
 		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
-		goto error_brelse;
+		goto out;
 	}
 
 	if (device->writeable && root->fs_info->fs_devices->rw_devices == 1) {
 		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
-		goto error_brelse;
+		goto out;
 	}
 
 	if (device->writeable) {
@@ -1832,16 +1792,33 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * at this point, the device is zero sized.  We want to
 	 * remove it from the devices list and zero out the old super
 	 */
-	if (clear_super && disk_super) {
+	if (clear_super) {
 		u64 bytenr;
 		int i;
 
+		if (!disk_super) {
+			ret = btrfs_get_bdev_and_sb(device_path,
+					FMODE_WRITE | FMODE_EXCL,
+					root->fs_info->bdev_holder, 0,
+					&bdev, &bh);
+			if (ret) {
+				/*
+				 * It could be a failed device ok for clear_super
+				 * to fail. So return success
+				 */
+				ret = 0;
+				goto out;
+			}
+
+			disk_super = (struct btrfs_super_block *)bh->b_data;
+		}
 		/* make sure this device isn't detected as part of
 		 * the FS anymore
 		 */
 		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
 		set_buffer_dirty(bh);
 		sync_dirty_buffer(bh);
+		brelse(bh);
 
 		/* clear the mirror copies of super block on the disk
 		 * being removed, 0th copy is been taken care above and
@@ -1853,7 +1830,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 					i_size_read(bdev->bd_inode))
 				break;
 
-			brelse(bh);
 			bh = __bread(bdev, bytenr / 4096,
 					BTRFS_SUPER_INFO_SIZE);
 			if (!bh)
@@ -1863,32 +1839,30 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 			if (btrfs_super_bytenr(disk_super) != bytenr ||
 				btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
+				brelse(bh);
 				continue;
 			}
 			memset(&disk_super->magic, 0,
 						sizeof(disk_super->magic));
 			set_buffer_dirty(bh);
 			sync_dirty_buffer(bh);
+			brelse(bh);
 		}
-	}
 
-	ret = 0;
-
-	if (bdev) {
-		/* Notify udev that device has changed */
-		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
+		if (bdev) {
+			/* Notify udev that device has changed */
+			btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
-		/* Update ctime/mtime for device path for libblkid */
-		update_dev_time(device_path);
+			/* Update ctime/mtime for device path for libblkid */
+			update_dev_time(device_path);
+			blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
+		}
 	}
 
-error_brelse:
-	brelse(bh);
-	if (bdev)
-		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
 	mutex_unlock(&uuid_mutex);
 	return ret;
+
 error_undo:
 	if (device->writeable) {
 		lock_chunks(root);
@@ -1897,7 +1871,7 @@ error_undo:
 		device->fs_devices->rw_devices++;
 		unlock_chunks(root);
 	}
-	goto error_brelse;
+	goto out;
 }
 
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
-- 
2.4.1

