Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23620 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760278AbaGYMa3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 08:30:29 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PCUSf0010846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:29 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PCUS8g011026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:28 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PCUR0j011010
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: introduce BTRFS_IOC_GET_DEVS
Date: Fri, 25 Jul 2014 20:33:51 +0800
Message-Id: <1406291632-29582-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1406291632-29582-1-git-send-email-anand.jain@oracle.com>
References: <1406291632-29582-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The user land progs needs   a simple way to see
the raw list of disks and its parameters as seen
by the btrfs kernel.
As of now btrfs-devlist uses this ioctl.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c           |  86 +++++++++++++++++++++++++++
 fs/btrfs/volumes.c         | 145 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |   3 +
 include/uapi/linux/btrfs.h |  53 ++++++++++++++++-
 4 files changed, 286 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 59172ed..f3660f5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1957,6 +1957,89 @@ static struct file_system_type btrfs_fs_type = {
 };
 MODULE_ALIAS_FS("btrfs");
 
+static int btrfs_ioc_get_devlist(void __user *arg)
+{
+	int ret = 0;
+	u64 sz_devlist_arg;
+	u64 sz_devlist;
+	u64 u_sz_devlist_arg;
+	u64 u_sz_devlist;
+	u64 sz_out;
+
+	struct btrfs_ioctl_devlist_args *devlist_arg;
+	struct btrfs_ioctl_devlist_args *tmp_devlist_arg;
+	struct btrfs_ioctl_devlist *devlist;
+
+	u64 cnt = 0, ucnt;
+
+	sz_devlist_arg = sizeof(*devlist_arg);
+	sz_devlist = sizeof(*devlist);
+
+	/* Check if the user land and kernel ioctl struct match */
+	if (copy_from_user(&u_sz_devlist_arg,
+		(struct btrfs_ioctl_devlist_args __user *)(arg +
+			offsetof(struct btrfs_ioctl_devlist_args, sz_self)),
+			sizeof(u_sz_devlist_arg)))
+		return -EFAULT;
+
+	if (copy_from_user(&u_sz_devlist,
+		(struct btrfs_ioctl_devlist_args __user *)(arg +
+			sz_devlist_arg +
+			offsetof(struct btrfs_ioctl_devlist, sz_self)),
+			sizeof(u_sz_devlist)))
+		return -EFAULT;
+
+	if (u_sz_devlist_arg != sz_devlist_arg ||
+		u_sz_devlist != sz_devlist) {
+		if (copy_to_user(arg +
+			offsetof(struct btrfs_ioctl_devlist_args, sz_self),
+			&sz_devlist_arg, sizeof(sz_devlist_arg)))
+			return -EFAULT;
+		if (copy_to_user(arg +
+			sz_devlist_arg +
+			offsetof(struct btrfs_ioctl_devlist, sz_self),
+			&sz_devlist, sizeof(sz_devlist)))
+			return -EFAULT;
+		return 2;
+	}
+
+	if (copy_from_user(&ucnt,
+		(struct btrfs_ioctl_devlist_args __user *)(arg +
+		offsetof(struct btrfs_ioctl_devlist_args, count)),
+			sizeof(ucnt)))
+		return -EFAULT;
+
+	cnt = btrfs_get_devlist_cnt();
+
+	if (cnt > ucnt) {
+		if (copy_to_user(arg +
+		offsetof(struct btrfs_ioctl_devlist_args, count),
+			&cnt, sizeof(cnt)))
+			return -EFAULT;
+		return 1;
+	}
+
+	sz_out = sz_devlist_arg + sz_devlist * cnt;
+
+	tmp_devlist_arg = devlist_arg = memdup_user(arg, sz_out);
+	if (IS_ERR(devlist_arg))
+		return PTR_ERR(devlist_arg);
+
+	devlist = (struct btrfs_ioctl_devlist *) (++tmp_devlist_arg);
+	cnt = btrfs_get_devlist(devlist, cnt);
+	devlist_arg->count = cnt;
+
+	if (copy_to_user(arg, devlist_arg, sz_out)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = 0;
+out:
+	kfree(devlist_arg);
+	return ret;
+
+}
+
 static int btrfs_ioc_get_fslist(void __user *arg)
 {
 	int ret = 0;
@@ -2019,6 +2102,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		return -EPERM;
 
 	switch (cmd) {
+	case BTRFS_IOC_GET_DEVS:
+		ret = btrfs_ioc_get_devlist(argp);
+		break;
 	case BTRFS_IOC_SCAN_DEV:
 		vol = memdup_user((void __user *)arg, sizeof(*vol));
 		if (IS_ERR(vol))
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 92b3d4d..15c533d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -229,6 +229,151 @@ error:
 	return ret;
 }
 
+int btrfs_get_devlist_cnt(void)
+{
+	int cnt = 0;
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_fs_devices *cur_fs_devices;
+
+	mutex_lock(&uuid_mutex);
+	list_for_each_entry(cur_fs_devices, &fs_uuids, list) {
+
+		fs_devices = cur_fs_devices;
+again_dev_cnt:
+		list_for_each_entry(device, &fs_devices->devices, dev_list)
+			cnt++;
+
+		fs_devices = fs_devices->seed;
+		if (fs_devices)
+			goto again_dev_cnt;
+	}
+
+	mutex_unlock(&uuid_mutex);
+
+	return cnt;
+}
+
+u64 btrfs_get_devlist(struct btrfs_ioctl_devlist *dev, u64 alloc_cnt)
+{
+	u64 cnt = 0;
+
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_fs_devices *cur_fs_devices;
+	struct btrfs_fs_devices *sprout_fs_devices;
+
+	mutex_lock(&uuid_mutex);
+	/* Todo: there must be better way of doing this */
+	list_for_each_entry(cur_fs_devices, &fs_uuids, list) {
+
+		mutex_lock(&cur_fs_devices->device_list_mutex);
+
+		fs_devices = cur_fs_devices;
+		sprout_fs_devices = NULL;
+
+again_dev:
+		list_for_each_entry(device, &fs_devices->devices, dev_list) {
+
+			if (!(cnt < alloc_cnt))
+				break;
+
+			dev->dev_root_addr = (u64)device->dev_root;
+			if (device->dev_root)
+				memcpy(dev->root_fsid,
+					device->dev_root->fs_info->fsid,
+					BTRFS_FSID_SIZE);
+			dev->fs_addr = (u64)fs_devices;
+			dev->dev_addr = (u64)device;
+			memcpy(dev->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
+
+			if (fs_devices->seed) {
+				memcpy(dev->seed_fsid, fs_devices->seed->fsid,
+						BTRFS_FSID_SIZE);
+				dev->seed_fs_addr = (u64)fs_devices->seed;
+			} else
+				memset(dev->seed_fsid, 0, BTRFS_FSID_SIZE);
+
+			if (sprout_fs_devices) {
+				memcpy(dev->sprout_fsid, sprout_fs_devices->fsid,
+						BTRFS_FSID_SIZE);
+				dev->sprout_fs_addr = (u64)sprout_fs_devices;
+			} else
+				memset(dev->sprout_fsid, 0, BTRFS_FSID_SIZE);
+
+			dev->fs_num_devices = fs_devices->num_devices;
+			dev->fs_open_devices = fs_devices->open_devices;
+			dev->fs_rw_devices = fs_devices->rw_devices;
+			dev->fs_missing_devices = fs_devices->missing_devices;
+			dev->fs_total_rw_bytes = fs_devices->total_rw_bytes;
+			dev->fs_num_can_discard = fs_devices->num_can_discard;
+			dev->fs_total_devices = fs_devices->total_devices;
+
+			dev->flags = 0;
+
+			if (fs_devices->opened)
+				dev->flags |= BTRFS_FS_MOUNTED;
+			if (fs_devices->seeding)
+				dev->flags |= BTRFS_FS_SEEDING;
+			if (fs_devices->rotating)
+				dev->flags |= BTRFS_FS_ROTATING;
+
+			dev->gen = device->generation;
+			dev->devid = device->devid;
+			dev->total_bytes = device->total_bytes;
+			dev->disk_total_bytes = device->disk_total_bytes;
+			dev->bytes_used = device->bytes_used;
+			dev->type = device->type;
+			dev->io_align = device->io_align;
+			dev->io_width = device->io_width;
+			dev->sector_size = device->sector_size;
+			dev->fmode = device->mode;
+
+			if (device->writeable)
+				dev->flags |= BTRFS_DEV_WRITEABLE;
+			if (device->in_fs_metadata)
+				dev->flags |= BTRFS_DEV_IN_FS_MD;
+			if (device->missing)
+				dev->flags |= BTRFS_DEV_MISSING;
+			if (device->can_discard)
+				dev->flags |= BTRFS_DEV_CAN_DISCARD;
+			if (device->is_tgtdev_for_dev_replace)
+				dev->flags |= BTRFS_DEV_REPLACE_TGT;
+			if (device->running_pending)
+				dev->flags |= BTRFS_DEV_RUN_PENDING;
+			if (device->nobarriers)
+				dev->flags |= BTRFS_DEV_NOBARRIERS;
+			if (device->dev_stats_valid)
+				dev->flags |= BTRFS_DEV_STATS_VALID;
+			if (device->bdev)
+				dev->flags |= BTRFS_DEV_BDEV;
+
+			memcpy(dev->uuid, device->uuid, BTRFS_UUID_SIZE);
+			if (device->name) {
+				rcu_read_lock();
+				memcpy(dev->name, rcu_str_deref(device->name),
+					BTRFS_PATH_NAME_MAX);
+				rcu_read_unlock();
+			} else {
+				memset(dev->name, 0, BTRFS_PATH_NAME_MAX);
+			}
+			dev++;
+			cnt++;
+		}
+
+		if (fs_devices->seed) {
+			sprout_fs_devices = fs_devices;
+			fs_devices = fs_devices->seed;
+			goto again_dev;
+		}
+
+		mutex_unlock(&cur_fs_devices->device_list_mutex);
+	}
+	mutex_unlock(&uuid_mutex);
+
+	return cnt;
+}
+
 static void requeue_list(struct btrfs_pending_bios *pending_bios,
 			struct bio *head, struct bio *tail)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c602416..e71dc9e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -281,6 +281,9 @@ struct btrfs_balance_control {
 	struct btrfs_balance_progress stat;
 };
 
+int btrfs_get_devlist_cnt(void);
+u64 btrfs_get_devlist(struct btrfs_ioctl_devlist *devlist, u64 ucnt);
+
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index f8c4bd6..3175e38 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -534,6 +534,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 
 /* fs flags */
 #define BTRFS_FS_MOUNTED	(1LLU << 0)
+#define BTRFS_FS_SEEDING	(1LLU << 1)
+#define BTRFS_FS_ROTATING	(1LLU << 2)
 
 struct btrfs_ioctl_fslist {
 	__u64 self_sz;			/* in/out */
@@ -549,6 +551,54 @@ struct btrfs_ioctl_fslist_args {
 	__u64 count;		/* out */
 };
 
+#define BTRFS_DEV_WRITEABLE	(1LLU << 8)
+#define BTRFS_DEV_IN_FS_MD	(1LLU << 9)
+#define BTRFS_DEV_MISSING	(1LLU << 10)
+#define BTRFS_DEV_CAN_DISCARD	(1LLU << 11)
+#define BTRFS_DEV_REPLACE_TGT	(1LLU << 12)
+#define BTRFS_DEV_RUN_PENDING   (1LLU << 13)
+#define BTRFS_DEV_NOBARRIERS	(1LLU << 14)
+#define BTRFS_DEV_STATS_VALID	(1LLU << 15)
+#define BTRFS_DEV_BDEV		(1LLU << 16)
+
+struct btrfs_ioctl_devlist {
+	__u64 sz_self;
+	__u64 dev_root_addr;
+	__u64 fs_addr;
+	__u64 dev_addr;
+	__u64 seed_fs_addr;
+	__u64 sprout_fs_addr;
+	__u64 fs_num_devices;
+	__u64 fs_open_devices;
+	__u64 fs_rw_devices;
+	__u64 fs_missing_devices;
+	__u64 fs_total_rw_bytes;
+	__u64 fs_num_can_discard;
+	__u64 fs_total_devices;
+	__u64 gen;
+	__u64 flags;
+	__u64 devid;
+	__u64 total_bytes;
+	__u64 disk_total_bytes;
+	__u64 bytes_used;
+	__u64 type;
+	__u64 fmode;
+	__u32 io_align;
+	__u32 io_width;
+	__u32 sector_size;
+	__u8 fsid[BTRFS_FSID_SIZE];
+	__u8 uuid[BTRFS_UUID_SIZE];
+	__u8 seed_fsid[BTRFS_FSID_SIZE];
+	__u8 sprout_fsid[BTRFS_UUID_SIZE];
+	__u8 root_fsid[BTRFS_FSID_SIZE];
+	__u8 name[BTRFS_PATH_NAME_MAX];
+}__attribute__ ((__packed__));
+
+struct btrfs_ioctl_devlist_args {
+	__u64 sz_self;		/* in/out */
+	__u64 count;		/* in/out */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -653,5 +703,6 @@ struct btrfs_ioctl_fslist_args {
 				   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags[3])
-
+#define BTRFS_IOC_GET_DEVS _IOWR(BTRFS_IOCTL_MAGIC, 59, \
+					struct btrfs_ioctl_devlist_args)
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.0.0.153.g79dcccc

