Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31976 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3KDE0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 23:26:16 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rA44QFgu024957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 04:26:16 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA44QEVo006540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 04:26:15 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA44QEig014940
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 04:26:14 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: add framework to read fs info from btrfs-control
Date: Mon,  4 Nov 2013 12:34:41 +0800
Message-Id: <1383539681-5142-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1383536724-4603-1-git-send-email-anand.jain@oracle.com>
References: <1383536724-4603-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds ioctl BTRFS_IOC_GET_FSIDS which reads the fs
info through the btrfs-control

v2: accepts Zach suggested
    now holds uuid_mutex

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c           |   66 ++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.c         |   39 ++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |    2 +
 include/uapi/linux/btrfs.h |   19 ++++++++++++
 4 files changed, 120 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e9c4e41..241f401 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1646,38 +1646,92 @@ static struct file_system_type btrfs_fs_type = {
 };
 MODULE_ALIAS_FS("btrfs");
 
+static int btrfs_ioc_get_fslist(void __user *arg)
+{
+	int ret = 0;
+	u64 sz_fslist_arg;
+	u64 sz_fslist;
+	u64 sz_out;
+	struct btrfs_ioctl_fslist_args *fslist_arg;
+	struct btrfs_ioctl_fslist_args *fslist_arg_tmp;
+	struct btrfs_ioctl_fslist *fslist;
+
+	u64 cnt = 0, ucnt;
+
+	sz_fslist_arg = sizeof(*fslist_arg);
+	sz_fslist = sizeof(*fslist);
+	if (copy_from_user(&ucnt,
+		(struct btrfs_ioctl_fslist_args __user *)(arg +
+		offsetof(struct btrfs_ioctl_fslist_args, count)),
+			sizeof(ucnt)))
+		return -EFAULT;
+
+	cnt = btrfs_get_fslist_cnt();
+
+	if (cnt > ucnt) {
+		if (copy_to_user(arg +
+		offsetof(struct btrfs_ioctl_fslist_args, count),
+			&cnt, sizeof(cnt)))
+			return -EFAULT;
+		return 1;
+	}
+
+	sz_out = sz_fslist_arg + sz_fslist * cnt;
+	fslist_arg_tmp = fslist_arg = memdup_user(arg, sz_out);
+	if (IS_ERR(fslist_arg))
+		return PTR_ERR(fslist_arg);
+	fslist = (struct btrfs_ioctl_fslist *) (++fslist_arg_tmp);
+	cnt = btrfs_get_fslist(fslist, cnt);
+	fslist_arg->count = cnt;
+	if (copy_to_user(arg, fslist_arg, sz_out)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = 0;
+out:
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
index 5103cfe..b114372 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6289,3 +6289,42 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 
 	return 0;
 }
+
+int btrfs_get_fslist_cnt(void)
+{
+	int cnt = 0;
+	struct btrfs_fs_devices *fs_devices;
+
+	mutex_lock(&uuid_mutex);
+	list_for_each_entry(fs_devices, &fs_uuids, list)
+		cnt++;
+	mutex_unlock(&uuid_mutex);
+
+	return cnt;
+}
+
+u64 btrfs_get_fslist(struct btrfs_ioctl_fslist *fslist, u64 ucnt)
+{
+	u64 cnt = 0;
+	struct btrfs_fs_devices *fs_devices;
+
+	mutex_lock(&uuid_mutex);
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
+		if (!(cnt < ucnt))
+			break;
+		memcpy(fslist->fsid, fs_devices->fsid,
+				BTRFS_FSID_SIZE);
+		fslist->num_devices = fs_devices->num_devices;
+		fslist->missing_devices = fs_devices->missing_devices;
+		fslist->total_devices = fs_devices->total_devices;
+
+		if (fs_devices->opened)
+			fslist->flags = BTRFS_FS_MOUNTED;
+
+		fslist++;
+		cnt++;
+	}
+	mutex_unlock(&uuid_mutex);
+
+	return cnt;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b72f540..d8079e6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -388,4 +388,6 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
 {
 	btrfs_dev_stat_set(dev, index, 0);
 }
+int btrfs_get_fslist_cnt(void);
+u64 btrfs_get_fslist(struct btrfs_ioctl_fslist *fslist, u64 ucnt);
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

