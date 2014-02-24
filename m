Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17264 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaBXLtb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 06:49:31 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1OBnTVX005915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:49:30 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s1OBnS9v010743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:49:29 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1OBnSCp024502
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:49:28 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: introduce BTRFS_IOC_GET_DEVS
Date: Mon, 24 Feb 2014 19:48:45 +0800
Message-Id: <1393242525-18587-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1393242525-18587-1-git-send-email-Anand.Jain@oracle.com>
References: <1393242525-18587-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

The user land progs needs   a simple way to see
the raw list of disks and its parameters as seen
by the btrfs kernel.
As of now btrfs-devlist uses this ioctl.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: add more parameter to get from the kernel

 fs/btrfs/super.c           |  56 ++++++++++++++++++
 fs/btrfs/volumes.c         | 140 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |   2 +
 include/uapi/linux/btrfs.h |  49 ++++++++++++++++
 4 files changed, 247 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index afb719e..f3c0247 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1717,6 +1717,59 @@ static struct file_system_type btrfs_fs_type = {
 };
 MODULE_ALIAS_FS("btrfs");
 
+static int btrfs_ioc_get_devlist(void __user *arg)
+{
+	int ret = 0;
+	u64 sz_devlist_arg;
+	u64 sz_devlist;
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
@@ -1801,6 +1854,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	case BTRFS_IOC_GET_FSLIST:
 		ret = btrfs_ioc_get_fslist(argp);
 		break;
+	case BTRFS_IOC_GET_DEVS:
+		ret = btrfs_ioc_get_devlist(argp);
+		break;
 	}
 
 	return ret;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 253fd9f..3c44800 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6338,3 +6338,143 @@ u64 btrfs_get_fslist(struct btrfs_ioctl_fslist *fslist, u64 ucnt)
 
 	return cnt;
 }
+
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
+			memcpy(dev->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
+
+			if (fs_devices->seed)
+				memcpy(dev->seed_fsid, fs_devices->seed->fsid,
+						BTRFS_FSID_SIZE);
+			else
+				memset(dev->seed_fsid, 0, BTRFS_FSID_SIZE);
+
+			if (sprout_fs_devices)
+				memcpy(dev->sprout_fsid, sprout_fs_devices->fsid,
+						BTRFS_FSID_SIZE);
+			else
+				memset(dev->sprout_fsid, 0, BTRFS_FSID_SIZE);
+
+			dev->fs_latest_devid = fs_devices->latest_devid;
+			dev->fs_latest_trans = fs_devices->latest_trans;
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
+			if (device->dev_stats_dirty)
+				dev->flags |= BTRFS_DEV_STATS_DIRTY;
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
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0b97fcf..91b7596 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -393,4 +393,6 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
 }
 int btrfs_get_fslist_cnt(void);
 u64 btrfs_get_fslist(struct btrfs_ioctl_fslist *fslist, u64 ucnt);
+int btrfs_get_devlist_cnt(void);
+u64 btrfs_get_devlist(struct btrfs_ioctl_devlist *devlist, u64 ucnt);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 76b91d6..23541b2 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -520,6 +520,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 
 /* fs flags */
 #define BTRFS_FS_MOUNTED	(1LLU << 0)
+#define BTRFS_FS_SEEDING	(1LLU << 1)
+#define BTRFS_FS_ROTATING	(1LLU << 2)
 
 struct btrfs_ioctl_fslist {
 	__u64 self_sz;			/* in/out */
@@ -535,6 +537,51 @@ struct btrfs_ioctl_fslist_args {
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
+#define BTRFS_DEV_STATS_DIRTY	(1LLU << 16)
+#define BTRFS_DEV_BDEV		(1LLU << 17)
+
+struct btrfs_ioctl_devlist {
+	__u64 sz_self;
+	__u64 fs_latest_devid;
+	__u64 fs_latest_trans;
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
+	__u8 name[BTRFS_PATH_NAME_MAX];
+}__attribute__ ((__packed__));
+
+struct btrfs_ioctl_devlist_args {
+	__u64 self_sz;		/* in/out */
+	__u64 count;		/* in/out */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -637,5 +684,7 @@ struct btrfs_ioctl_fslist_args {
 				   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags[3])
+#define BTRFS_IOC_GET_DEVS _IOWR(BTRFS_IOCTL_MAGIC, 58, \
+				     struct btrfs_ioctl_devlist_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.8.4.2

