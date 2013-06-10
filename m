Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51722 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3FJOzg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:55:36 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEtYcO006311
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:55:35 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEtXSX021435
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:55:34 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEtX2o014451
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:55:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info from the kernel
Date: Mon, 10 Jun 2013 22:59:15 +0800
Message-Id: <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876355-16584-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-1-git-send-email-anand.jain@oracle.com>
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

v1->v2:
  .code optimized
  .get the device generation number as well, so that
   btrfs-progs could print using print_one_uuid

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c           | 100 +++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.c         |  99 +++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h         |   2 +
 include/uapi/linux/btrfs.h |  62 ++++++++++++++++++++++++++++
 4 files changed, 255 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f0857e0..8b39a08 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1554,38 +1554,124 @@ static struct file_system_type btrfs_fs_type = {
 };
 MODULE_ALIAS_FS("btrfs");
 
+static size_t get_ioctl_sz(size_t pl_list_sz, u64 mul, u64 alloc_cnt)
+{
+	if (alloc_cnt)
+		return (sizeof(struct btrfs_ioctl_header)
+					+ pl_list_sz * alloc_cnt/mul);
+
+	return (sizeof(struct btrfs_ioctl_header) + pl_list_sz);
+}
+
+static int get_ioctl_header_and_payload(unsigned long arg,
+		size_t unit_sz, int default_len,
+		struct btrfs_ioctl_header **argp, size_t *sz)
+{
+	u64 cnt = 0;
+	struct btrfs_ioctl_header *ioctl_head;
+	size_t sz_head = sizeof(struct btrfs_ioctl_header);
+
+	*sz = get_ioctl_sz(unit_sz, default_len, cnt);
+	ioctl_head = *argp = (struct btrfs_ioctl_header *)
+				memdup_user((void __user *)arg, *sz);
+
+	if (IS_ERR(ioctl_head))
+		return PTR_ERR(ioctl_head);
+
+	cnt = ioctl_head->count;
+	if (cnt > default_len) {
+		kfree(ioctl_head);
+		/* Check for any mal-formed ioctl */
+		if (cnt % default_len)
+			return -EFAULT;
+		/* user has allocated more, so re-read
+		 * by using the recomupted size
+		*/
+		*sz = get_ioctl_sz(unit_sz, default_len, cnt);
+		ioctl_head = *argp = (struct btrfs_ioctl_header *)
+				memdup_user((void __user *)arg, *sz);
+		if (IS_ERR(ioctl_head))
+			return PTR_ERR(ioctl_head);
+	}
+
+	ioctl_head->sz_self = sz_head;
+	ioctl_head->sz = unit_sz;
+	ioctl_head->count = default_len;
+
+	if (ioctl_head->sz_self != sz_head || ioctl_head->sz != unit_sz
+		|| ioctl_head->count != default_len)
+		return 1;
+
+	return 0;
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
-	int ret = -ENOTTY;
+	struct btrfs_ioctl_header *argp = NULL;
+ 	int ret = -ENOTTY;
+	size_t sz = 0;
 
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
+	case BTRFS_IOC_GET_FSIDS:
+		ret = get_ioctl_header_and_payload(arg,
+				sizeof(struct btrfs_ioctl_fs_list),
+				BTRFS_FSIDS_LEN, &argp, &sz);
+		if (ret == 1) {
+			ret = copy_to_user((void __user *)arg, argp, sz);
+			kfree(argp);
+			return -EFAULT;
+		} else if (ret)
+			return -EFAULT;
+		ret = btrfs_get_fsids(argp);
+		if (ret == 0 && copy_to_user((void __user *)arg, argp, sz))
+			ret = -EFAULT;
+		kfree(argp);
+		break;
+	case BTRFS_IOC_GET_DEVS:
+		ret = get_ioctl_header_and_payload(arg,
+				sizeof(struct btrfs_ioctl_dev_list),
+				BTRFS_DEVS_LEN, &argp, &sz);
+		if (ret == 1) {
+			ret = copy_to_user((void __user *)arg, argp, sz);
+			kfree(argp);
+			return -EFAULT;
+		} else if (ret)
+			return -EFAULT;
+		ret = btrfs_get_devs(argp);
+		if (ret == 0 && copy_to_user((void __user *)arg, argp, sz))
+			ret = -EFAULT;
+		kfree(argp);
+		break;
 	}
 
-	kfree(vol);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 024fc11..de8399b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1819,7 +1819,7 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 }
 
 /*
- * strore the expected generation for seed devices in device items.
+ * store the expected generation for seed devices in device items.
  */
 static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
@@ -5988,3 +5988,100 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 
 	return 0;
 }
+
+int btrfs_get_fsids(struct btrfs_ioctl_header *argp)
+{
+	u64 cnt = 0;
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_ioctl_fs_list *fslist;
+	struct btrfs_ioctl_fsinfo *fsinfo;
+
+	fslist = (struct btrfs_ioctl_fs_list *)((u8 *)argp
+						+ sizeof(*argp));
+
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
+		if (!fslist->all && !fs_devices->opened)
+			continue;
+		if (cnt < argp->count) {
+			fsinfo = &fslist->fsinfo[cnt];
+			memcpy(fsinfo->fsid, fs_devices->fsid,
+					BTRFS_FSID_SIZE);
+			fsinfo->num_devices = fs_devices->num_devices;
+			fsinfo->missing_devices = fs_devices->missing_devices;
+			fsinfo->total_devices = fs_devices->total_devices;
+
+			if (fs_devices->opened) {
+				fsinfo->flags = BTRFS_FS_MOUNTED;
+				/* just get a devs sb */
+				device = list_entry(fs_devices->devices.next,
+						struct btrfs_device, dev_list);
+
+				fsinfo->bytes_used = device->dev_root\
+						->fs_info->super_copy->bytes_used;
+				memcpy(fsinfo->label, device->dev_root\
+						->fs_info->super_copy->label,
+						BTRFS_LABEL_SIZE);
+			}
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
+				dev->disk_total_bytes = device->disk_total_bytes;
+				dev->bytes_used = device->bytes_used;
+
+				dev->type = device->type;
+				dev->io_align = device->io_align;
+				dev->io_width = device->io_width;
+				dev->sector_size = device->sector_size;
+				memcpy(dev->uuid, device->uuid, BTRFS_UUID_SIZE);
+				memcpy(dev->name, rcu_str_deref(device->name),
+						BTRFS_PATH_NAME_MAX);
+				dev->generation = device->generation;
+			}
+			cnt++;
+		}
+		break;
+	}
+	argp->count = cnt;
+	return 0;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index f6247e2..48ebd3e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -371,4 +371,6 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
 {
 	btrfs_dev_stat_set(dev, index, 0);
 }
+int btrfs_get_fsids(struct btrfs_ioctl_header *fsid);
+int btrfs_get_devs(struct btrfs_ioctl_header *argp);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index de3ec34..9d552ef 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -487,6 +487,64 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 	}
 }
 
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
+#define BTRFS_LABEL_SIZE	256
+
+struct btrfs_ioctl_fsinfo {
+	__u64 sz_self;
+	__u8 fsid[BTRFS_FSID_SIZE]; /* out */
+	__u64 num_devices;
+	__u64 total_devices;
+	__u64 missing_devices;
+	__u64 total_rw_bytes;
+	__u64 bytes_used;
+	__u64 flags;
+	__u64 default_mount_subvol_id;
+	char label[BTRFS_LABEL_SIZE];
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
+	__u64 generation;
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
@@ -578,4 +636,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_GET_FSIDS _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+				struct btrfs_ioctl_header)
+#define BTRFS_IOC_GET_DEVS _IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				struct btrfs_ioctl_header)
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.8.1.227.g44fe835

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
