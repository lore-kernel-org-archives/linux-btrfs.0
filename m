From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: add a disk info ioctl to get the disks attached to a filesystem
Date: Tue, 28 Sep 2010 16:53:16 -0400
Message-ID: <1285707196-16268-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This was a request from the systemd guys.  They need a quick and easy way to get
all devices attached to a Btrfs filesystem in order to check if any of the disks
are SSD for...something, I didn't ask :).   I've tested this with the
btrfs-progs patch that accompanies this patch.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ioctl.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    7 ++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..f59b0bc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1957,6 +1957,68 @@ out:
 	return ret;
 }
 
+static noinline long btrfs_ioctl_disk_info(struct btrfs_root *root,
+					   void __user *arg)
+{
+	struct btrfs_ioctl_disk_info_args di_args;
+	u64 *user_dest;
+	u64 *dest = NULL;
+	struct btrfs_device *device;
+	struct list_head *devices;
+	int alloc_size = 0;
+	int ret = 0;
+
+	if (copy_from_user(&di_args,
+			   (struct btrfs_ioctl_disk_info_args __user *)arg,
+			   sizeof(di_args)))
+		return -EFAULT;
+
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	if (!di_args.num_devices) {
+		di_args.num_devices = root->fs_info->fs_devices->num_devices;
+		goto out;
+	}
+	alloc_size = sizeof(u64) * di_args.num_devices;
+
+	di_args.num_devices = 0;
+
+	/*
+	 * If we have more than 4k worth of space to hold a bunch of u64's,
+	 * somebody is misbehaving.
+	 */
+	if (alloc_size > PAGE_CACHE_SIZE) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dest = kzalloc(alloc_size, GFP_NOFS);
+	if (!dest) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	devices = &root->fs_info->fs_devices->devices;
+
+	list_for_each_entry(device, devices, dev_list) {
+		dest[di_args.num_devices] =
+			huge_encode_dev(device->bdev->bd_dev);
+		di_args.num_devices++;
+	}
+
+	user_dest = (u64 *)
+		(arg + sizeof(struct btrfs_ioctl_disk_info_args));
+
+	if (copy_to_user(user_dest, dest, alloc_size))
+		ret = -EFAULT;
+out:
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+	if (ret == 0 && copy_to_user(arg, &di_args, sizeof(di_args)))
+		ret = -EFAULT;
+	kfree(dest);
+
+	return ret;
+}
+
 /*
  * there are many ways the trans_start and trans_end ioctls can lead
  * to deadlocks.  They should only be used by applications that
@@ -2031,6 +2093,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_ino_lookup(file, argp);
 	case BTRFS_IOC_SPACE_INFO:
 		return btrfs_ioctl_space_info(root, argp);
+	case BTRFS_IOC_DISK_INFO:
+		return btrfs_ioctl_disk_info(root, argp);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..294e8c3 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -138,6 +138,11 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_disk_info_args {
+	__u32 num_devices;
+	__u64 devices[0];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -178,4 +183,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_DISK_INFO _IOWR(BTRFS_IOCTL_MAGIC, 21, \
+				  struct btrfs_ioctl_disk_info_args)
 #endif
-- 
1.6.6.1

