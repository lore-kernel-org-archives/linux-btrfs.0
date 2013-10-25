Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20402 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3JYRCB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 13:02:01 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9PH20rU009323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:02:00 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9PH1xW9008748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:01:59 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9PH1x8r008742
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:01:59 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add framework to read fs info from btrfs-control
Date: Sat, 26 Oct 2013 01:10:05 +0800
Message-Id: <1382721007-5531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds ioctl BTRFS_IOC_GET_FSIDS which reads the fs
info through the btrfs-control

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c           |   47 ++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.c         |   33 ++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |    2 +
 include/uapi/linux/btrfs.h |   19 +++++++++++++++++
 4 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0991fb1..bae53ba 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1641,38 +1641,73 @@ static struct file_system_type btrfs_fs_type = {
 };
 MODULE_ALIAS_FS("btrfs");
 
+static int btrfs_ioc_get_fslist(void __user *arg)
+{
+	int ret = 0;
+	u64 sz_fslist_arg;
+	u64 sz_fslist;
+	struct btrfs_ioctl_fslist_args *fslist_arg;
+	struct btrfs_ioctl_fslist *fslist;
+
+	sz_fslist_arg = sizeof(*fslist_arg);
+	fslist_arg = memdup_user(arg, sz_fslist_arg);
+
+	sz_fslist = sizeof(*fslist) * fslist_arg->count;
+	kfree(fslist_arg);
+	fslist_arg = memdup_user(arg, sz_fslist_arg + sz_fslist);
+	fslist = (struct btrfs_ioctl_fslist *) (fslist_arg + sz_fslist_arg);
+
+	ret = btrfs_get_fslist(fslist_arg, fslist);
+
+	fslist->self_sz = sz_fslist;
+	fslist_arg->self_sz = sz_fslist_arg;
+
+	if (copy_to_user(arg, fslist_arg, sz_fslist_arg + sz_fslist))
+		ret = -EFAULT;
+
+	kfree(fslist_arg);
+	return ret;
+}
+
 /*
  * used by btrfsctl to scan devices when no FS is mounted
  */
 static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct btrfs_ioctl_vol_args *vol;
+	struct btrfs_ioctl_vol_args *vol = NULL;
 	struct btrfs_fs_devices *fs_devices;
 	int ret = -ENOTTY;
+	void __user *argp = (void __user *)arg;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol = memdup_user((void __user *)arg, sizeof(*vol));
-	if (IS_ERR(vol))
-		return PTR_ERR(vol);
-
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
+		vol = memdup_user((void __user *)arg, sizeof(*vol));
+		if (IS_ERR(vol))
+			return PTR_ERR(vol);
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
+		kfree(vol);
 		break;
 	case BTRFS_IOC_DEVICES_READY:
+		vol = memdup_user((void __user *)arg, sizeof(*vol));
+		if (IS_ERR(vol))
+			return PTR_ERR(vol);
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
+		kfree(vol);
 		if (ret)
 			break;
 		ret = !(fs_devices->num_devices == fs_devices->total_devices);
 		break;
+	case BTRFS_IOC_GET_FSLIST:
+		ret = btrfs_ioc_get_fslist(argp);
+		break;
 	}
 
-	kfree(vol);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fe0f2ef..a7b8f26 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6284,3 +6284,36 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 
 	return 0;
 }
+
+/* return 1 if allocation count exceed the num of fs list
+ * in the kernel
+ */
+int btrfs_get_fslist(struct btrfs_ioctl_fslist_args *fslist_arg,
+			struct btrfs_ioctl_fslist *fslist)
+{
+	u64 cnt = 0, ucnt;
+	struct btrfs_fs_devices *fs_devices;
+
+	ucnt = fslist_arg->count;
+
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
+		if (cnt < ucnt) {
+			memcpy(fslist->fsid, fs_devices->fsid,
+					BTRFS_FSID_SIZE);
+			fslist->num_devices = fs_devices->num_devices;
+			fslist->missing_devices = fs_devices->missing_devices;
+			fslist->total_devices = fs_devices->total_devices;
+
+			if (fs_devices->opened)
+				fslist->flags = BTRFS_FS_MOUNTED;
+
+			fslist = (struct btrfs_ioctl_fslist *) fslist +
+							sizeof(*fslist);
+		}
+		cnt++;
+	}
+	fslist_arg->count = cnt;
+	if (cnt > ucnt)
+		return 1;
+	return 0;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b72f540..e68a1c8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -388,4 +388,6 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
 {
 	btrfs_dev_stat_set(dev, index, 0);
 }
+int btrfs_get_fslist(struct btrfs_ioctl_fslist_args *fslist_arg,
+			struct btrfs_ioctl_fslist *fslist);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 45e6189..6690551 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -512,6 +512,23 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 	}
 }
 
+/* fs flags */
+#define BTRFS_FS_MOUNTED	(1LLU << 0)
+
+struct btrfs_ioctl_fslist {
+	__u64 self_sz;			/* in/out */
+	__u8 fsid[BTRFS_FSID_SIZE];	/* out */
+	__u64 num_devices;
+	__u64 missing_devices;
+	__u64 total_devices;
+	__u64 flags;
+};
+
+struct btrfs_ioctl_fslist_args {
+	__u64 self_sz;		/* in/out */
+	__u64 count;		/* out */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -606,5 +623,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_GET_FSLIST _IOWR(BTRFS_IOCTL_MAGIC, 56, \
+					struct btrfs_ioctl_fslist_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.7.1

