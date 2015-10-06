Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbJFPTt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:19:49 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH V4 7/7] Btrfs: Introduce device delete by devid
Date: Tue,  6 Oct 2015 23:19:24 +0800
Message-Id: <1444144764-2384-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This introduces new ioctl BTRFS_IOC_RM_DEV_V2, which uses
enhanced struct btrfs_ioctl_vol_args_v2 to carry devid as
an user argument.

The patch won't delete the old ioctl interface and remains
backward compatible with user land progs.

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

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reported-by: Martin <m_btrfs@ml1.co.uk>
---
v4: enahnced btrfs_ioctl_vol_args_v2 to accept devid instead of
    creating a new structure. Thanks to David.
    commit update and title changed from..
    Btrfs: device delete by devid

v3: commit update, included test case

v2: don't use device->name after free

 fs/btrfs/ioctl.c           | 58 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c         |  4 ++--
 fs/btrfs/volumes.h         |  2 +-
 include/uapi/linux/btrfs.h | 14 ++++++++++-
 4 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f43a104..f3aa37c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2653,6 +2653,60 @@ out:
 	return ret;
 }
 
+static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
+	struct btrfs_ioctl_vol_args_v2 *vol_args;
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
+	/* Check for compatibility reject unknown flags */
+	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS)
+		return -ENOTTY;
+
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
+		goto out;
+	}
+
+	mutex_lock(&root->fs_info->volume_mutex);
+	if (vol_args->flags & BTRFS_DEVICE_BY_ID) {
+		ret = btrfs_rm_device(root, NULL, vol_args->devid);
+	} else {
+		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+		ret = btrfs_rm_device(root, vol_args->name, 0);
+	}
+
+	mutex_unlock(&root->fs_info->volume_mutex);
+	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
+
+	if (!ret) {
+		if (vol_args->flags & BTRFS_DEVICE_BY_ID)
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
@@ -2681,7 +2735,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	}
 
 	mutex_lock(&root->fs_info->volume_mutex);
-	ret = btrfs_rm_device(root, vol_args->name);
+	ret = btrfs_rm_device(root, vol_args->name, 0);
 	mutex_unlock(&root->fs_info->volume_mutex);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 
@@ -5424,6 +5478,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_add_dev(root, argp);
 	case BTRFS_IOC_RM_DEV:
 		return btrfs_ioctl_rm_dev(file, argp);
+	case BTRFS_IOC_RM_DEV_V2:
+		return btrfs_ioctl_rm_dev_v2(file, argp);
 	case BTRFS_IOC_FS_INFO:
 		return btrfs_ioctl_fs_info(root, argp);
 	case BTRFS_IOC_DEV_INFO:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 69d311c..a384b65 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1672,7 +1672,7 @@ static int __check_raid_min_devices(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
-int btrfs_rm_device(struct btrfs_root *root, char *device_path)
+int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 {
 	struct btrfs_device *device;
 	struct btrfs_device *next_device;
@@ -1688,7 +1688,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (ret)
 		goto out;
 
-	ret = btrfs_find_device_by_user_input(root, 0, device_path,
+	ret = btrfs_find_device_by_user_input(root, devid, device_path,
 				&device);
 	if (ret)
 		goto out;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 15ee0dd..4150d9d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -436,7 +436,7 @@ int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
-int btrfs_rm_device(struct btrfs_root *root, char *device_path);
+int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b6dec05..ff40c48 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -36,6 +36,13 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
+#define BTRFS_DEVICE_BY_ID		(1ULL << 3)
+#define BTRFS_VOL_ARG_V2_FLAGS				\
+			(BTRFS_SUBVOL_CREATE_ASYNC |	\
+			BTRFS_SUBVOL_RDONLY |		\
+			BTRFS_SUBVOL_QGROUP_INHERIT |	\
+			BTRFS_DEVICE_BY_ID)
+
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 #define BTRFS_UUID_UNPARSED_SIZE	37
@@ -76,7 +83,10 @@ struct btrfs_ioctl_vol_args_v2 {
 		};
 		__u64 unused[4];
 	};
-	char name[BTRFS_SUBVOL_NAME_MAX + 1];
+	union {
+		char name[BTRFS_SUBVOL_NAME_MAX + 1];
+		u64 devid;
+	};
 };
 
 /*
@@ -634,5 +644,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags[3])
+#define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
+				   struct btrfs_ioctl_vol_args_v2)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.4.1

