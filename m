Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37911 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbbHNKdf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:35 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 08/23] Btrfs: device delete by devid
Date: Fri, 14 Aug 2015 18:32:53 +0800
Message-Id: <1439548388-29686-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This introduces BTRFS_IOC_RM_DEV_V2, which can accept devid as
an argument to delete the device.

Current only choice to is to pass device path for the device delete
cli, but if btrfs is unable to read device SB, then cli fails. And
user won't be able to delete the device.

With this patch now the user can specify devid as the device
to delete.

The patch won't delete the old interface so that kernel will
remain compatible with the older user-interface programs like
btrfs-progs.

Test case/script:
echo "0 $(blockdev --getsz /dev/sdf) linear /dev/sdf 0" | dmsetup create bad_disk
mkfs.btrfs -f -d raid1 -m raid1 /dev/sdd /dev/sde /dev/mapper/bad_disk
mount /dev/sdd /btrfs
dmsetup suspend bad_disk
echo "0 $(blockdev --getsz /dev/sdf) error /dev/sdf 0" | dmsetup load bad_disk
dmsetup resume bad_disk
echo "bad disk failed. now deleting/replacing"
btrfs dev del  3  /btrfs
echo $?
btrfs fi show /btrfs
umount /btrfs
btrfs-show-super /dev/sdd | egrep num_device
dmsetup remove bad_disk
wipefs -a /dev/sdf

v3: commit update, included test case

v2: don't use device->name after free
commit update with the test script which I have been using

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reported-by: Martin <m_btrfs@ml1.co.uk>
---
 fs/btrfs/ioctl.c           | 50 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c         | 51 ++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/volumes.h         |  2 +-
 include/uapi/linux/btrfs.h |  8 ++++++++
 4 files changed, 98 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0adf542..6c9e58c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2653,6 +2653,52 @@ out:
 	return ret;
 }
 
+static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
+	struct btrfs_ioctl_vol_args_v3 *vol_args;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args)) {
+		ret = PTR_ERR(vol_args);
+		goto err_drop;
+	}
+
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
+		goto out;
+	}
+
+	mutex_lock(&root->fs_info->volume_mutex);
+	ret = btrfs_rm_device(root, vol_args->name, vol_args->devid);
+	mutex_unlock(&root->fs_info->volume_mutex);
+	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
+
+	if (!ret) {
+		if (vol_args->devid)
+			btrfs_info(root->fs_info, "disk devid %llu deleted",
+								vol_args->devid);
+		else
+			btrfs_info(root->fs_info, "disk deleted - %s", vol_args->name);
+	}
+out:
+	kfree(vol_args);
+err_drop:
+	mnt_drop_write_file(file);
+	return ret;
+}
+
 static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
@@ -2681,7 +2727,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	}
 
 	mutex_lock(&root->fs_info->volume_mutex);
-	ret = btrfs_rm_device(root, vol_args->name);
+	ret = btrfs_rm_device(root, vol_args->name, 0);
 	mutex_unlock(&root->fs_info->volume_mutex);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 
@@ -5419,6 +5465,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_add_dev(root, argp);
 	case BTRFS_IOC_RM_DEV:
 		return btrfs_ioctl_rm_dev(file, argp);
+	case BTRFS_IOC_RM_DEV_V2:
+		return btrfs_ioctl_rm_dev_v2(file, argp);
 	case BTRFS_IOC_FS_INFO:
 		return btrfs_ioctl_fs_info(root, argp);
 	case BTRFS_IOC_DEV_INFO:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a3fde18..2f8b974 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1637,21 +1637,21 @@ out:
 	return ret;
 }
 
-int btrfs_rm_device(struct btrfs_root *root, char *device_path)
+int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 {
 	struct btrfs_device *device;
 	struct btrfs_device *next_device;
-	struct block_device *bdev;
+	struct block_device *bdev = NULL;
 	struct buffer_head *bh = NULL;
-	struct btrfs_super_block *disk_super;
+	struct btrfs_super_block *disk_super = NULL;
 	struct btrfs_fs_devices *cur_devices;
 	u64 all_avail;
-	u64 devid;
 	u64 num_devices;
 	u8 *dev_uuid;
 	unsigned seq;
 	int ret = 0;
 	bool clear_super = false;
+	char *dev_name = NULL;
 
 	mutex_lock(&uuid_mutex);
 
@@ -1692,7 +1692,15 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
-	if (strcmp(device_path, "missing") == 0) {
+	if (devid) {
+		device = btrfs_find_device(root->fs_info, devid,
+				NULL, NULL);
+		if (!device) {
+			ret = -ENOENT;
+			goto out;
+		}
+		device_path = rcu_str_deref(device->name);
+	} else if (strcmp(device_path, "missing") == 0) {
 		struct list_head *devices;
 		struct btrfs_device *tmp;
 
@@ -1710,9 +1718,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 				break;
 			}
 		}
-		bdev = NULL;
-		bh = NULL;
-		disk_super = NULL;
 		if (!device) {
 			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 			goto out;
@@ -1750,6 +1755,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
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
 
@@ -1832,10 +1842,26 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * at this point, the device is zero sized.  We want to
 	 * remove it from the devices list and zero out the old super
 	 */
-	if (clear_super && disk_super) {
+	if (clear_super) {
 		u64 bytenr;
 		int i;
 
+		if (!disk_super) {
+			ret = btrfs_get_bdev_and_sb(dev_name,
+					    FMODE_WRITE | FMODE_EXCL,
+					    root->fs_info->bdev_holder, 0,
+					    &bdev, &bh);
+			if (ret) {
+				/*
+				 * It could be a failed device ok for clear_super
+				 * to fail. So return success
+				 */
+				ret = 0;
+				goto done;
+			}
+
+			disk_super = (struct btrfs_super_block *)bh->b_data;
+		}
 		/* make sure this device isn't detected as part of
 		 * the FS anymore
 		 */
@@ -1872,14 +1898,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		}
 	}
 
+done:
 	ret = 0;
-
 	if (bdev) {
 		/* Notify udev that device has changed */
 		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
 		/* Update ctime/mtime for device path for libblkid */
-		update_dev_time(device_path);
+		update_dev_time(dev_name);
 	}
 
 error_brelse:
@@ -1887,6 +1913,9 @@ error_brelse:
 	if (bdev)
 		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
+	if (dev_name)
+		kfree(dev_name);
+
 	mutex_unlock(&uuid_mutex);
 	return ret;
 error_undo:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 413a70c..f4b0ed8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -432,7 +432,7 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
-int btrfs_rm_device(struct btrfs_root *root, char *device_path);
+int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b6dec05..074affe 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -31,6 +31,12 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+struct btrfs_ioctl_vol_args_v3 {
+	__s64 fd;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+	__u64 devid;
+};
+
 #define BTRFS_DEVICE_PATH_NAME_MAX 1024
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
@@ -634,5 +640,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags[3])
+#define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
+				   struct btrfs_ioctl_vol_args_v3)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.4.1

