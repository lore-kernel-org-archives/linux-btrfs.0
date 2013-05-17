Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26324 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3EQKt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 06:49:57 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4HAnsTI021629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:49:55 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HAnsp4014297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:49:55 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HAns07002196
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:49:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: device delete to get errors from the kernel
Date: Fri, 17 May 2013 18:52:45 +0800
Message-Id: <1368787965-11968-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1367327981-28000-1-git-send-email-anand.jain@oracle.com>
References: <1367327981-28000-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when user runs command btrfs dev del the raid requisite error if any
goes to the /var/log/messages, its not good idea to clutter messages
with these user (knowledge) errors, further user don't have to review
the system messages to know problem with the cli it should be dropped
to the user as part of the cli return.

to bring this feature created a set of the ERROR defined
BTRFS_ERROR_DEV* error codes and created their error string.

I expect this enum to be added with other error which we might
want to communicate to the user land

v3:
moved the code with in the file no logical change

v1->v2:
introduce error codes for the device mgmt usage

v1:
adds a parameter in the ioctl arg struct to carry the error string

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c           | 22 +++++++++++-----------
 fs/btrfs/volumes.c         | 26 +++++++-------------------
 include/uapi/linux/btrfs.h | 41 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 898c572..e6d21ec 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2347,14 +2347,6 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
-			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-		mnt_drop_write_file(file);
-		return -EINVAL;
-	}
-
-	mutex_lock(&root->fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -2362,12 +2354,20 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	}
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	ret = btrfs_rm_device(root, vol_args->name);
 
-	kfree(vol_args);
-out:
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
+		goto out;
+	}
+
+	mutex_lock(&root->fs_info->volume_mutex);
+	ret = btrfs_rm_device(root, vol_args->name);
 	mutex_unlock(&root->fs_info->volume_mutex);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
+
+out:
+	kfree(vol_args);
 	mnt_drop_write_file(file);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5989a92..22c702e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1461,31 +1461,23 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
-		printk(KERN_ERR "btrfs: unable to go below four devices "
-		       "on raid10\n");
-		ret = -EINVAL;
+		ret = BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET;
 		goto out;
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid1\n");
-		ret = -EINVAL;
+		ret = BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET;
 		goto out;
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
 	    root->fs_info->fs_devices->rw_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid5\n");
-		ret = -EINVAL;
+		ret = BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET;
 		goto out;
 	}
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
 	    root->fs_info->fs_devices->rw_devices <= 3) {
-		printk(KERN_ERR "btrfs: unable to go below three "
-		       "devices on raid6\n");
-		ret = -EINVAL;
+		ret = BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET;
 		goto out;
 	}
 
@@ -1511,8 +1503,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		bh = NULL;
 		disk_super = NULL;
 		if (!device) {
-			printk(KERN_ERR "btrfs: no missing devices found to "
-			       "remove\n");
+			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 			goto out;
 		}
 	} else {
@@ -1534,15 +1525,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	}
 
 	if (device->is_tgtdev_for_dev_replace) {
-		pr_err("btrfs: unable to remove the dev_replace target dev\n");
-		ret = -EINVAL;
+		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
 		goto error_brelse;
 	}
 
 	if (device->writeable && root->fs_info->fs_devices->rw_devices == 1) {
-		printk(KERN_ERR "btrfs: unable to remove the only writeable "
-		       "device\n");
-		ret = -EINVAL;
+		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
 		goto error_brelse;
 	}
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..408374a 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -423,6 +423,46 @@ struct btrfs_ioctl_send_args {
 	__u64 reserved[4];		/* in */
 };
 
+/* Error codes as returned by the kernel */
+enum btrfs_err_code {
+	notused,
+	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_TGT_REPLACE,
+	BTRFS_ERROR_DEV_MISSING_NOT_FOUND,
+	BTRFS_ERROR_DEV_ONLY_WRITABLE,
+	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
+};
+/* An error code to error string mapping for the kernel
+*  error codes
+*/
+static inline char *btrfs_err_str(enum btrfs_err_code err_code)
+{
+	switch (err_code) {
+		case BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET:
+			return "unable to go below two devices on raid1";
+		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
+			return "unable to go below four devices on raid10";
+		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
+			return "unable to go below two devices on raid5";
+		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
+			return "unable to go below three devices on raid6";
+		case BTRFS_ERROR_DEV_TGT_REPLACE:
+			return "unable to remove the dev_replace target dev";
+		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
+			return "no missing devices found to remove";
+		case BTRFS_ERROR_DEV_ONLY_WRITABLE:
+			return "unable to remove the only writeable device";
+		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
+			return "add/delete/balance/replace/resize operation "\
+				"in progress";
+		default:
+			return NULL;
+	}
+}
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -510,5 +550,4 @@ struct btrfs_ioctl_send_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
-
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.8.1.227.g44fe835

