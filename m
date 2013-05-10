Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41189 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3EJLAM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 07:00:12 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4AB0A4S029090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:11 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4AB0Blh016776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:11 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4AB0AD9001961
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:10 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add framework to read fs info and dev info from the kernel
Date: Fri, 10 May 2013 19:02:43 +0800
Message-Id: <1368183764-7865-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368183764-7865-1-git-send-email-anand.jain@oracle.com>
References: <1368183764-7865-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds two ioctl BTRFS_IOC_GET_FSIDS and BTRFS_IOC_GET_DEVS
which reads the btrfs_fs_devices and btrfs_device structure
from the kernel respectively.

The information in these structure are useful to report the
device/fs information in line with the kernel operations and
thus immediately addresses the problem that 'btrfs fi show'
command reports the stale information after device device add
remove operation is performed. That is because btrfs fi show
reads the disks directly.

Further the frame-work provided here would help to enhance
the btrfs-progs/library to read the other fs information and
its device information. Also the frame work provided here is
easily extensible to retrieve any other structure as future
needs.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c           | 87 ++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.c         | 86 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h | 58 ++++++++++++++++++++++++++++++-
 4 files changed, 225 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 68a29a1..582fa17 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1559,22 +1559,85 @@ static struct file_system_type btrfs_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
+static size_t get_ioctl_sz(size_t pl_sz, u64 mul, u64 alloc_cnt)
+{
+	if (!alloc_cnt)
+		return (sizeof(struct btrfs_ioctl_header) + pl_sz);
+
+	/* alloc_cnt which is set by the user must be
+	 * multiple of mul
+	 */
+	if (alloc_cnt % mul)
+		return -ENOTTY;
+
+	return (sizeof(struct btrfs_ioctl_header) + pl_sz * alloc_cnt/mul);
+}
 /*
  * used by btrfsctl to scan devices when no FS is mounted
  */
 static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct btrfs_ioctl_vol_args *vol;
+	struct btrfs_ioctl_vol_args *vol = NULL;
 	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_ioctl_header *argp = NULL;
+	struct btrfs_ioctl_fs_list *fslist;
+	u64 cnt = 0;
 	int ret = -ENOTTY;
+	u64 sz = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol = memdup_user((void __user *)arg, sizeof(*vol));
-	if (IS_ERR(vol))
-		return PTR_ERR(vol);
+	switch (cmd) {
+	case BTRFS_IOC_SCAN_DEV:
+	case BTRFS_IOC_DEVICES_READY:
+		vol = memdup_user((void __user *)arg, sizeof(*vol));
+		if (IS_ERR(vol))
+			return PTR_ERR(vol);
+		break;
+	case BTRFS_IOC_GET_FSIDS:
+		sz = get_ioctl_sz(sizeof(struct btrfs_ioctl_fs_list), BTRFS_FSIDS_LEN, cnt);
+		argp = memdup_user((void __user *)arg, sz);
+
+		if (IS_ERR(argp))
+			return PTR_ERR(argp);
+
+		cnt = argp->count;
+		if (cnt > BTRFS_FSIDS_LEN) {
+			/* user has allocated more, so re-read
+			 * by using the recomupted size
+			*/
+			kfree(argp);
+			sz = get_ioctl_sz(sizeof(*fslist), BTRFS_FSIDS_LEN, cnt);
+			argp = memdup_user((void __user *)arg, sz);
+			if (IS_ERR(argp))
+				return PTR_ERR(argp);
+		}
+		break;
+	case BTRFS_IOC_GET_DEVS:
+		sz = get_ioctl_sz(sizeof(struct btrfs_ioctl_dev_list), BTRFS_DEVS_LEN, cnt);
+		argp = memdup_user((void __user *)arg, sz);
+
+		if (IS_ERR(argp))
+			return PTR_ERR(argp);
+
+		cnt = argp->count;
+		if (cnt > BTRFS_DEVS_LEN) {
+			/* user has allocated more, so re-read
+			 * by using the recomupted size
+			*/
+			sz = get_ioctl_sz(sizeof(struct btrfs_ioctl_dev_list),
+					BTRFS_DEVS_LEN, cnt);
+			kfree(argp);
+			argp = memdup_user((void __user *)arg, sz);
+			if (IS_ERR(argp))
+				return PTR_ERR(argp);
+		}
+		break;
+	default:
+		return ret;
+	}
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
@@ -1588,9 +1651,21 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 			break;
 		ret = !(fs_devices->num_devices == fs_devices->total_devices);
 		break;
+	case BTRFS_IOC_GET_FSIDS:
+		ret = btrfs_get_fsids(argp);
+		if (ret == 0 && copy_to_user((void __user *)arg, argp, sz))
+			ret = -EFAULT;
+		break;
+	case BTRFS_IOC_GET_DEVS:
+		ret = btrfs_get_devs(argp);
+		if (ret == 0 && copy_to_user((void __user *)arg, argp, sz))
+			ret = -EFAULT;
+		break;
 	}
-
-	kfree(vol);
+	if (cmd == BTRFS_IOC_GET_FSIDS)
+		kfree(argp);
+	else
+		kfree(vol);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5989a92..e15cb37 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1830,7 +1830,7 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 }
 
 /*
- * strore the expected generation for seed devices in device items.
+ * store the expected generation for seed devices in device items.
  */
 static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
@@ -6004,3 +6004,87 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 
 	return 0;
 }
+
+int btrfs_get_fsids(struct btrfs_ioctl_header *argp)
+{
+	u64 cnt = 0;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_ioctl_fs_list *fslist;
+	struct btrfs_ioctl_fsinfo *fsinfo;
+
+	fslist = (struct btrfs_ioctl_fs_list *)((u8 *)argp + sizeof(*argp));
+
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
+		if (!fslist->all && !fs_devices->opened)
+			continue;
+		fsinfo = &fslist->fsinfo[cnt];
+		if (cnt < argp->count) {
+			memcpy(fsinfo->fsid, fs_devices->fsid,
+					BTRFS_FSID_SIZE);
+			fsinfo->num_devices = fs_devices->num_devices;
+			fsinfo->missing_devices = fs_devices->missing_devices;
+			fsinfo->total_rw_bytes = fs_devices->total_rw_bytes;
+			fsinfo->total_devices = fs_devices->total_devices;
+			if (fs_devices->opened)
+				fsinfo->flags = BTRFS_FS_MOUNTED;
+		}
+		cnt++;
+	}
+	argp->count = cnt;
+	return 0;
+}
+
+int btrfs_get_devs(struct btrfs_ioctl_header *argp)
+{
+	u64 cnt = 0;
+	u64 alloc_cnt = argp->count;
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_ioctl_dev_list *devlist;
+	struct btrfs_ioctl_devinfo *dev;
+
+	devlist = (struct btrfs_ioctl_dev_list *)
+					((u8 *)argp + sizeof(*argp));
+
+	/* Todo: optimize. there must be better way of doing this*/
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
+		if (memcmp(devlist->fsid, fs_devices->fsid, BTRFS_FSID_SIZE))
+			continue;
+
+		list_for_each_entry(device, &fs_devices->devices, dev_list) {
+			if (cnt < alloc_cnt) {
+				dev = &devlist->dev[cnt];
+				if (device->writeable)
+					dev->flags = BTRFS_DEV_WRITEABLE;
+				if (device->in_fs_metadata)
+					dev->flags = dev->flags |
+						BTRFS_DEV_IN_FS_MD;
+				if (device->missing)
+					dev->flags = dev->flags |
+						BTRFS_DEV_MISSING;
+				if (device->can_discard)
+					dev->flags = dev->flags |
+							BTRFS_DEV_CAN_DISCARD;
+				if (device->is_tgtdev_for_dev_replace)
+					dev->flags = dev->flags |
+						BTRFS_DEV_SUBSTITUTED;
+
+				dev->devid = device->devid;
+				dev->total_bytes = device->total_bytes;
+				dev->disk_total_bytes = device->disk_total_bytes;
+				dev->bytes_used = device->bytes_used;
+				dev->type = device->type;
+				dev->io_align = device->io_align;
+				dev->io_width = device->io_width;
+				dev->sector_size = device->sector_size;
+				memcpy(dev->uuid, device->uuid, BTRFS_UUID_SIZE);
+				memcpy(dev->name, rcu_str_deref(device->name),
+						BTRFS_PATH_NAME_MAX);
+			}
+			cnt++;
+		}
+		break;
+	}
+	argp->count = cnt;
+	return 0;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 062d860..39422d0 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -364,4 +364,6 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
 {
 	btrfs_dev_stat_set(dev, index, 0);
 }
+int btrfs_get_fsids(struct btrfs_ioctl_header *fsid);
+int btrfs_get_devs(struct btrfs_ioctl_header *argp);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..ce65e59 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -423,6 +423,59 @@ struct btrfs_ioctl_send_args {
 	__u64 reserved[4];		/* in */
 };
 
+/* ioctl header */
+struct btrfs_ioctl_header {
+	__u64 sz_self;	/* in/out */
+	__u64 sz;	/* in/out */
+	__u64 count;	/* in/out */
+}__attribute__ ((__packed__));
+
+/* ioctl payloads */
+#define BTRFS_FSIDS_LEN	16
+#define BTRFS_FS_MOUNTED	(1LLU << 0)
+
+struct btrfs_ioctl_fsinfo {
+	__u64 sz_self;
+	__u8 fsid[BTRFS_FSID_SIZE]; /* out */
+	__u64 num_devices;
+	__u64 missing_devices;
+	__u64 total_rw_bytes;
+	__u64 total_devices;
+	__u64 flags;
+}__attribute__ ((__packed__));
+
+struct btrfs_ioctl_fs_list {
+	__u64 all; /* in */
+	struct btrfs_ioctl_fsinfo fsinfo[BTRFS_FSIDS_LEN]; /* out */
+}__attribute__ ((__packed__));
+
+#define BTRFS_DEVS_LEN	16
+#define BTRFS_DEV_WRITEABLE	(1LLU << 0)
+#define BTRFS_DEV_IN_FS_MD	(1LLU << 1)
+#define BTRFS_DEV_MISSING	(1LLU << 2)
+#define BTRFS_DEV_CAN_DISCARD	(1LLU << 3)
+#define BTRFS_DEV_SUBSTITUTED	(1LLU << 4)
+
+struct btrfs_ioctl_devinfo {
+	__u64 sz_self;
+	__u64 flags;
+	__u64 devid;
+	__u64 total_bytes;
+	__u64 disk_total_bytes;
+	__u64 bytes_used;
+	__u64 type;
+	__u32 io_align;
+	__u32 io_width;
+	__u32 sector_size;
+	__u8 uuid[BTRFS_UUID_SIZE];
+	__u8 name[BTRFS_PATH_NAME_MAX + 1];
+}__attribute__ ((__packed__));
+
+struct btrfs_ioctl_dev_list {
+	__u8 fsid[BTRFS_FSID_SIZE]; /* in */
+	struct btrfs_ioctl_devinfo dev[BTRFS_DEVS_LEN]; /* out */
+}__attribute__ ((__packed__));
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -510,5 +563,8 @@ struct btrfs_ioctl_send_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
-
+#define BTRFS_IOC_GET_FSIDS _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+				     struct btrfs_ioctl_header)
+#define BTRFS_IOC_GET_DEVS _IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				     struct btrfs_ioctl_header)
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.8.1.227.g44fe835

