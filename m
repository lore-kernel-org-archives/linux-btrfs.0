From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v1 6/6] btrfs: new ioctls for scrub
Date: Tue,  8 Mar 2011 15:37:49 +0100
Message-ID: <5d116a0952b8fb9d04910472c82f7457fc4a5b24.1299593612.git.sensille@gmx.net>
References: <cover.1299593612.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	jansen@webgods.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1299593612.git.sensille@gmx.net>
In-Reply-To: <cover.1299593612.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

adds ioctls necessary to start and cancel scrubs, to get current
progress and to get info about devices to be scrubbed.
Note that the scrub is done per-device and that the ioctl only
returns after the scrub for this devices is finished or has been
canceled.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ioctl.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    7 ++++
 2 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index be2d4f6..f988ab6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1715,6 +1715,31 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	return ret;
 }
 
+static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_dev_info_args di_args;
+	struct btrfs_device *device, *next;
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	di_args.num_devices = fs_devices->num_devices;
+	di_args.max_id = 0;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
+		if (device->devid > di_args.max_id)
+			di_args.max_id = device->devid;
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	if (copy_to_user(arg, &di_args, sizeof(di_args)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				       u64 off, u64 olen, u64 destoff)
 {
@@ -2372,6 +2397,58 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+static long btrfs_ioctl_scrub(struct btrfs_root *root, void __user *arg)
+{
+	int ret;
+	struct btrfs_ioctl_scrub_args *sa;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	ret = btrfs_scrub_dev(root, sa->devid, sa->start, sa->end,
+	                      &sa->progress);
+
+	if (copy_to_user(arg, sa, sizeof(*sa)))
+		ret = -EFAULT;
+
+	kfree(sa);
+	return ret;
+}
+
+static long btrfs_ioctl_scrub_cancel(struct btrfs_root *root, void __user *arg)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return btrfs_scrub_cancel(root);
+}
+
+static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
+                                       void __user *arg)
+{
+	struct btrfs_ioctl_scrub_args *sa;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	ret = btrfs_scrub_progress(root, sa->devid, &sa->progress);
+
+	if (copy_to_user(arg, sa, sizeof(*sa)))
+		ret = -EFAULT;
+
+	kfree(sa);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2409,6 +2486,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_add_dev(root, argp);
 	case BTRFS_IOC_RM_DEV:
 		return btrfs_ioctl_rm_dev(root, argp);
+	case BTRFS_IOC_DEV_INFO:
+		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_CLONE:
@@ -2432,6 +2511,12 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_start_sync(file, argp);
 	case BTRFS_IOC_WAIT_SYNC:
 		return btrfs_ioctl_wait_sync(file, argp);
+	case BTRFS_IOC_SCRUB:
+		return btrfs_ioctl_scrub(root, argp);
+	case BTRFS_IOC_SCRUB_CANCEL:
+		return btrfs_ioctl_scrub_cancel(root, argp);
+	case BTRFS_IOC_SCRUB_PROGRESS:
+		return btrfs_ioctl_scrub_progress(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index f7bf177..9aa3603 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -232,4 +232,11 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
+#define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
+                             struct btrfs_ioctl_scrub_args)
+#define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
+#define BTRFS_IOC_SCRUB_PROGRESS _IOWR(BTRFS_IOCTL_MAGIC, 29, \
+                             struct btrfs_ioctl_scrub_args)
+#define BTRFS_IOC_DEV_INFO _IOR(BTRFS_IOCTL_MAGIC, 30, \
+                                struct btrfs_ioctl_dev_info_args)
 #endif
-- 
1.7.3.4

