Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34128 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbbHNKdl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:41 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 12/23] Btrfs: use btrfs_find_device_by_user_input()
Date: Fri, 14 Aug 2015 18:32:57 +0800
Message-Id: <1439548388-29686-13-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rm_device() has a section of the code which can be replaced
btrfs_find_device_by_user_input()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 84 ++++++++++++------------------------------------------
 1 file changed, 19 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f1b36b9..1d35332 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1689,7 +1689,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 	struct btrfs_super_block *disk_super = NULL;
 	struct btrfs_fs_devices *cur_devices;
 	u64 num_devices;
-	u8 *dev_uuid;
 	int ret = 0;
 	bool clear_super = false;
 	char *dev_name = NULL;
@@ -1700,62 +1699,19 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 	if (ret)
 		goto out;
 
-	if (devid) {
-		device = btrfs_find_device(root->fs_info, devid,
-				NULL, NULL);
-		if (!device) {
-			ret = -ENOENT;
-			goto out;
-		}
-		device_path = rcu_str_deref(device->name);
-	} else if (strcmp(device_path, "missing") == 0) {
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
+	ret = btrfs_find_device_by_user_input(root, devid, device_path,
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
@@ -1865,7 +1821,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 				 * to fail. So return success
 				 */
 				ret = 0;
-				goto done;
+				goto out;
 			}
 
 			disk_super = (struct btrfs_super_block *)bh->b_data;
@@ -1876,6 +1832,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
 		set_buffer_dirty(bh);
 		sync_dirty_buffer(bh);
+		brelse(bh);
 
 		/* clear the mirror copies of super block on the disk
 		 * being removed, 0th copy is been taken care above and
@@ -1887,7 +1844,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 					i_size_read(bdev->bd_inode))
 				break;
 
-			brelse(bh);
 			bh = __bread(bdev, bytenr / 4096,
 					BTRFS_SUPER_INFO_SIZE);
 			if (!bh)
@@ -1897,35 +1853,33 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 
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
 
-done:
-	ret = 0;
-	if (bdev) {
-		/* Notify udev that device has changed */
-		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
+		if (bdev) {
+			/* Notify udev that device has changed */
+			btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
-		/* Update ctime/mtime for device path for libblkid */
-		update_dev_time(dev_name);
+			/* Update ctime/mtime for device path for libblkid */
+			update_dev_time(dev_name);
+			blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
+		}
 	}
 
-error_brelse:
-	brelse(bh);
-	if (bdev)
-		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
 	if (dev_name)
 		kfree(dev_name);
 
 	mutex_unlock(&uuid_mutex);
 	return ret;
+
 error_undo:
 	if (device->writeable) {
 		lock_chunks(root);
@@ -1934,7 +1888,7 @@ error_undo:
 		device->fs_devices->rw_devices++;
 		unlock_chunks(root);
 	}
-	goto error_brelse;
+	goto out;
 }
 
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
-- 
2.4.1

