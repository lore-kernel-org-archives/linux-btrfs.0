Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:47888 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab2EYOGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 10:06:12 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by ysabell.rzone.de (Postfix) with ESMTP id B079F3D7
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 16:06:10 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 2/3] Btrfs: add ioctl to get and reset the device stats
Date: Fri, 25 May 2012 16:06:09 +0200
Message-Id: <1337954770-10086-3-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
References: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An ioctl interface is added to get the device statistic counters.
A second ioctl is added to atomically get and reset these counters.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ioctl.c   |   26 ++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |   14 ++++++++++++++
 fs/btrfs/volumes.c |   34 ++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |    3 +++
 4 files changed, 77 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 14f8e1f..2f5072d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3042,6 +3042,28 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
 	return ret;
 }
 
+static long btrfs_ioctl_get_dev_stats(struct btrfs_root *root,
+				      void __user *arg, int reset_after_read)
+{
+	struct btrfs_ioctl_get_dev_stats *sa;
+	int ret;
+
+	if (reset_after_read && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	ret = btrfs_get_dev_stats(root, sa, reset_after_read);
+
+	if (copy_to_user(arg, sa, sizeof(*sa)))
+		ret = -EFAULT;
+
+	kfree(sa);
+	return ret;
+}
+
 static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 {
 	int ret = 0;
@@ -3424,6 +3446,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_balance_ctl(root, arg);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root, argp);
+	case BTRFS_IOC_GET_DEV_STATS:
+		return btrfs_ioctl_get_dev_stats(root, argp, 0);
+	case BTRFS_IOC_GET_AND_RESET_DEV_STATS:
+		return btrfs_ioctl_get_dev_stats(root, argp, 1);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 5bf05e2..497c530 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -285,6 +285,16 @@ enum btrfs_dev_stat_values {
 	BTRFS_DEV_STAT_VALUES_MAX
 };
 
+struct btrfs_ioctl_get_dev_stats {
+	__u64 devid;				/* in */
+	__u64 nr_items;				/* in/out */
+
+	/* out values: */
+	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
+
+	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -349,5 +359,9 @@ enum btrfs_dev_stat_values {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
+				      struct btrfs_ioctl_get_dev_stats)
+#define BTRFS_IOC_GET_AND_RESET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
+					struct btrfs_ioctl_get_dev_stats)
 
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 05e05fb..b9138b7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4673,3 +4673,37 @@ void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 			   btrfs_dev_stat_read(dev,
 					       BTRFS_DEV_STAT_GENERATION_ERRS));
 }
+
+int btrfs_get_dev_stats(struct btrfs_root *root,
+			struct btrfs_ioctl_get_dev_stats *stats,
+			int reset_after_read)
+{
+	struct btrfs_device *dev;
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	int i;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	dev = btrfs_find_device(root, stats->devid, NULL, NULL);
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	if (!dev) {
+		printk(KERN_WARNING
+		       "btrfs: get dev_stats failed, device not found\n");
+		return -ENODEV;
+	} else if (reset_after_read) {
+		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
+			if (stats->nr_items > i)
+				stats->values[i] =
+					btrfs_dev_stat_read_and_reset(dev, i);
+			else
+				btrfs_dev_stat_reset(dev, i);
+		}
+	} else {
+		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
+			if (stats->nr_items > i)
+				stats->values[i] = btrfs_dev_stat_read(dev, i);
+	}
+	if (stats->nr_items > BTRFS_DEV_STAT_VALUES_MAX)
+		stats->nr_items = BTRFS_DEV_STAT_VALUES_MAX;
+	return 0;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 193b283..6798f86 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -290,6 +290,9 @@ struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
 						   u64 logical, int mirror_num);
 void btrfs_dev_stat_print_on_error(struct btrfs_device *device);
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
+int btrfs_get_dev_stats(struct btrfs_root *root,
+			struct btrfs_ioctl_get_dev_stats *stats,
+			int reset_after_read);
 
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
-- 
1.7.10.2

