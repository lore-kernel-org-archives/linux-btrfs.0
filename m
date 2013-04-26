Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33253 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab3DZJjZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 05:39:25 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3Q9dO75024992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:39:25 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3Q9dNCl006776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:39:24 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3Q9dNrA019749
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:39:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: device delete to get errors from the kernel
Date: Fri, 26 Apr 2013 17:41:15 +0800
Message-Id: <1366969275-3036-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366969275-3036-1-git-send-email-anand.jain@oracle.com>
References: <517A4B44.5060608@oracle.com>
 <1366969275-3036-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

adds a parameter in the ioctl arg struct to carry the error string

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c           | 42 +++++++++++++++++++++++++++---------------
 fs/btrfs/volumes.c         | 29 +++++++++++++++--------------
 fs/btrfs/volumes.h         |  2 +-
 include/uapi/linux/btrfs.h |  9 ++++++++-
 4 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 898c572..da9cba5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2337,7 +2337,8 @@ out:
 static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
-	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_ioctl_dev_args *dev_args = NULL;
+	char ret_err[BTRFS_IOCTL_ERR_LEN];
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2347,27 +2348,38 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
-			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-		mnt_drop_write_file(file);
-		return -EINVAL;
+	dev_args = memdup_user(arg, sizeof(*dev_args));
+	if (IS_ERR(dev_args)) {
+		ret = PTR_ERR(dev_args);
+		goto out;
 	}
 
-	mutex_lock(&root->fs_info->volume_mutex);
-	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args)) {
-		ret = PTR_ERR(vol_args);
+	dev_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	memset(ret_err, 0, BTRFS_IOCTL_ERR_LEN);
+
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		strncpy(dev_args->ret_err_str,
+			"add/delete/balance/replace/resize operation in progress\n",
+			BTRFS_IOCTL_ERR_LEN);
+		if (copy_to_user(arg, dev_args, sizeof(dev_args)))
+			ret = -EFAULT;
+		ret = -EINVAL;
 		goto out;
 	}
 
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	ret = btrfs_rm_device(root, vol_args->name);
-
-	kfree(vol_args);
-out:
+	mutex_lock(&root->fs_info->volume_mutex);
+	ret = btrfs_rm_device(root, dev_args->name, ret_err);
 	mutex_unlock(&root->fs_info->volume_mutex);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
+	if (ret) {
+		strncpy(dev_args->ret_err_str, ret_err,
+			BTRFS_IOCTL_ERR_LEN);
+		if (copy_to_user(arg, dev_args, sizeof(*dev_args)))
+			ret = -EFAULT;
+	}
+out:
+	kfree(dev_args);
 	mnt_drop_write_file(file);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5989a92..12c02d7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1426,7 +1426,7 @@ out:
 	return ret;
 }
 
-int btrfs_rm_device(struct btrfs_root *root, char *device_path)
+int btrfs_rm_device(struct btrfs_root *root, char *device_path, char *ret_err)
 {
 	struct btrfs_device *device;
 	struct btrfs_device *next_device;
@@ -1461,30 +1461,30 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
-		printk(KERN_ERR "btrfs: unable to go below four devices "
-		       "on raid10\n");
+		strncpy(ret_err, "unable to go below four devices on raid10",
+				BTRFS_IOCTL_ERR_LEN);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid1\n");
+		strncpy(ret_err, "unable to go below two devices on raid1",
+				BTRFS_IOCTL_ERR_LEN);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
 	    root->fs_info->fs_devices->rw_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid5\n");
+		strncpy(ret_err, "unable to go below two devices on raid5",
+				BTRFS_IOCTL_ERR_LEN);
 		ret = -EINVAL;
 		goto out;
 	}
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
 	    root->fs_info->fs_devices->rw_devices <= 3) {
-		printk(KERN_ERR "btrfs: unable to go below three "
-		       "devices on raid6\n");
+		strncpy(ret_err, "unable to go below three devices on raid6",
+				BTRFS_IOCTL_ERR_LEN);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1511,8 +1511,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		bh = NULL;
 		disk_super = NULL;
 		if (!device) {
-			printk(KERN_ERR "btrfs: no missing devices found to "
-			       "remove\n");
+			strncpy(ret_err, "no missing devices found to remove",
+				BTRFS_IOCTL_ERR_LEN);
 			goto out;
 		}
 	} else {
@@ -1534,14 +1534,15 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	}
 
 	if (device->is_tgtdev_for_dev_replace) {
-		pr_err("btrfs: unable to remove the dev_replace target dev\n");
+		strncpy(ret_err, "unable to remove the dev_replace target dev",
+			BTRFS_IOCTL_ERR_LEN);
 		ret = -EINVAL;
 		goto error_brelse;
 	}
 
 	if (device->writeable && root->fs_info->fs_devices->rw_devices == 1) {
-		printk(KERN_ERR "btrfs: unable to remove the only writeable "
-		       "device\n");
+		strncpy(ret_err, "unable to remove the only writeable device",
+			BTRFS_IOCTL_ERR_LEN);
 		ret = -EINVAL;
 		goto error_brelse;
 	}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 062d860..94dc9f2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -287,7 +287,7 @@ int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
-int btrfs_rm_device(struct btrfs_root *root, char *device_path);
+int btrfs_rm_device(struct btrfs_root *root, char *device_path, char *ret_err);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..b2fc716 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -31,6 +31,13 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_IOCTL_ERR_LEN 256
+struct btrfs_ioctl_dev_args {
+	__s64 fd;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+	char ret_err_str[BTRFS_IOCTL_ERR_LEN];
+};
+
 #define BTRFS_DEVICE_PATH_NAME_MAX 1024
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
@@ -442,7 +449,7 @@ struct btrfs_ioctl_send_args {
 #define BTRFS_IOC_CLONE        _IOW(BTRFS_IOCTL_MAGIC, 9, int)
 #define BTRFS_IOC_ADD_DEV _IOW(BTRFS_IOCTL_MAGIC, 10, \
 				   struct btrfs_ioctl_vol_args)
-#define BTRFS_IOC_RM_DEV _IOW(BTRFS_IOCTL_MAGIC, 11, \
+#define BTRFS_IOC_RM_DEV _IOWR(BTRFS_IOCTL_MAGIC, 11, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)
-- 
1.8.1.227.g44fe835

