Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19039 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3LSDvU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 22:51:20 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH v3] btrfs: add framework to read fs info from btrfs-control
Date: Thu, 19 Dec 2013 11:59:35 +0800
Message-Id: <1387425575-15136-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1383536724-4603-1-git-send-email-anand.jain@oracle.com>
References: <1383536724-4603-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds ioctl BTRFS_IOC_GET_FSIDS which reads the fs
info through the btrfs-control, needed to optimize
heavily used btrfs-progs function check_mounted()
plus few other minor uses.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v3: rebase and update commit
 v2: accepts Zach suggested and now holds uuid_mutex

 fs/btrfs/super.c           |   66 ++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.c         |   39 ++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |    2 +
 include/uapi/linux/btrfs.h |   19 ++++++++++++
 4 files changed, 120 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0d4b1c3..13884c5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1645,38 +1645,92 @@ static struct file_system_type btrfs_fs_type = {
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
index 92303f4..debd619 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6284,3 +6284,42 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 
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
index 8b3cd14..ebb0d0c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -390,4 +390,6 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
 {
 	btrfs_dev_stat_set(dev, index, 0);
 }
+int btrfs_get_fslist_cnt(void);
+u64 btrfs_get_fslist(struct btrfs_ioctl_fslist *fslist, u64 ucnt);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 1b8a0f4..7d7f776 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -518,6 +518,23 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
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
@@ -613,6 +630,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_GET_FSLIST _IOWR(BTRFS_IOCTL_MAGIC, 56, \
+					struct btrfs_ioctl_fslist_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
1.7.1

