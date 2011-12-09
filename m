From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 2/3] Btrfs: add ioctl to get and reset the device stats
Date: Fri,  9 Dec 2011 17:40:27 +0100
Message-ID: <f2f1de6869aab38ff48d60235081257ce2c03bf4.1323448299.git.sbehrens@giantdisaster.de>
References: <cover.1323448299.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1323448299.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1323448299.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

An ioctl interface is added to get the device statistic counters.
A second ioctl is added to atomically get and reset these counters.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ioctl.c   |   26 +++++++++++++++++++
 fs/btrfs/ioctl.h   |   27 ++++++++++++++++++++
 fs/btrfs/volumes.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |   13 ++++++++++
 4 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72d4616..bce3f92 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2891,6 +2891,28 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
 	return ret;
 }
 
+static long btrfs_ioctl_get_device_stats(struct btrfs_root *root,
+					 void __user *arg, int reset_after_read)
+{
+	struct btrfs_ioctl_get_device_stats *sa;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	ret = btrfs_get_device_stats(root, sa, reset_after_read);
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
@@ -3108,6 +3130,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_scrub_cancel(root, argp);
 	case BTRFS_IOC_SCRUB_PROGRESS:
 		return btrfs_ioctl_scrub_progress(root, argp);
+	case BTRFS_IOC_GET_DEVICE_STATS:
+		return btrfs_ioctl_get_device_stats(root, argp, 0);
+	case BTRFS_IOC_GET_AND_RESET_DEVICE_STATS:
+		return btrfs_ioctl_get_device_stats(root, argp, 1);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 252ae99..b9ffd0b 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -217,6 +217,29 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+#define BTRFS_IOCTL_GET_DEVICE_STATS_MAX_NR_ITEMS	5
+struct btrfs_ioctl_get_device_stats {
+	__u64 devid;				/* in */
+	__u64 nr_items;				/* in/out */
+
+	/* out values: */
+
+	/* disk I/O failure stats */
+	__u64 cnt_write_io_errs; /* EIO or EREMOTEIO from lower layers */
+	__u64 cnt_read_io_errs; /* EIO or EREMOTEIO from lower layers */
+	__u64 cnt_flush_io_errs; /* EIO or EREMOTEIO from lower layers */
+
+	/* stats for indirect indications for I/O failures */
+	__u64 cnt_corruption_errs; /* checksum error, bytenr error or
+				    * contents is illegal: this is an
+				    * indication that the block was damaged
+				    * during read or write, or written to
+				    * wrong location or read from wrong
+				    * location */
+	__u64 cnt_generation_errs; /* an indication that blocks have not
+				    * been written */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -276,5 +299,9 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_GET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
+					 struct btrfs_ioctl_get_device_stats)
+#define BTRFS_IOC_GET_AND_RESET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
+					 struct btrfs_ioctl_get_device_stats)
 
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc21e14..99dfd00 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3852,3 +3852,72 @@ void btrfs_device_stat_print_on_error(struct btrfs_device *device)
 			   btrfs_device_stat_read(
 				&device->cnt_generation_errs));
 }
+
+int btrfs_get_device_stats(struct btrfs_root *root,
+			   struct btrfs_ioctl_get_device_stats *stats,
+			   int reset_after_read)
+{
+	struct btrfs_device *dev;
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	dev = btrfs_find_device(root, stats->devid, NULL, NULL);
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	if (!dev) {
+		printk(KERN_WARNING
+		       "btrfs: get device_stats failed, device not found\n");
+		return -ENODEV;
+	} else if (reset_after_read) {
+		if (stats->nr_items >= 1)
+			stats->cnt_write_io_errs =
+				btrfs_device_stat_read_and_reset(
+					&dev->cnt_write_io_errs);
+		else
+			btrfs_device_stat_reset(&dev->cnt_write_io_errs);
+		if (stats->nr_items >= 2)
+			stats->cnt_read_io_errs =
+				btrfs_device_stat_read_and_reset(
+					&dev->cnt_read_io_errs);
+		else
+			btrfs_device_stat_reset(&dev->cnt_read_io_errs);
+		if (stats->nr_items >= 3)
+			stats->cnt_flush_io_errs =
+				btrfs_device_stat_read_and_reset(
+					&dev->cnt_flush_io_errs);
+		else
+			btrfs_device_stat_reset(&dev->cnt_flush_io_errs);
+		if (stats->nr_items >= 4)
+			stats->cnt_corruption_errs =
+				btrfs_device_stat_read_and_reset(
+					&dev->cnt_corruption_errs);
+		else
+			btrfs_device_stat_reset(&dev->cnt_corruption_errs);
+		if (stats->nr_items >= 5)
+			stats->cnt_generation_errs =
+				btrfs_device_stat_read_and_reset(
+					&dev->cnt_generation_errs);
+		else
+			btrfs_device_stat_reset(&dev->cnt_generation_errs);
+		dev->device_stats_dirty = 1;
+	} else {
+		if (stats->nr_items >= 1)
+			stats->cnt_write_io_errs = btrfs_device_stat_read(
+					&dev->cnt_write_io_errs);
+		if (stats->nr_items >= 2)
+			stats->cnt_read_io_errs = btrfs_device_stat_read(
+					&dev->cnt_read_io_errs);
+		if (stats->nr_items >= 3)
+			stats->cnt_flush_io_errs = btrfs_device_stat_read(
+					&dev->cnt_flush_io_errs);
+		if (stats->nr_items >= 4)
+			stats->cnt_corruption_errs = btrfs_device_stat_read(
+					&dev->cnt_corruption_errs);
+		if (stats->nr_items >= 5)
+			stats->cnt_generation_errs = btrfs_device_stat_read(
+					&dev->cnt_generation_errs);
+	}
+	if (stats->nr_items > 5)
+		stats->nr_items = 5;
+	return 0;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 51ad850..ad8c3bc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -244,6 +244,9 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
 						   u64 logical, int mirror_num);
 void btrfs_device_stat_print_on_error(struct btrfs_device *device);
+int btrfs_get_device_stats(struct btrfs_root *root,
+			   struct btrfs_ioctl_get_device_stats *stats,
+			   int reset_after_read);
 
 static inline void btrfs_device_stat_inc(atomic_t *cnt)
 {
@@ -254,4 +257,14 @@ static inline int btrfs_device_stat_read(atomic_t *cnt)
 {
 	return atomic_read(cnt);
 }
+
+static inline int btrfs_device_stat_read_and_reset(atomic_t *cnt)
+{
+	return atomic_xchg(cnt, 0);
+}
+
+static inline void btrfs_device_stat_reset(atomic_t *cnt)
+{
+	atomic_set(cnt, 0);
+}
 #endif
-- 
1.7.3.4

