From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: do not do balance in readonly mode
Date: Fri, 11 May 2012 18:11:26 +0800
Message-ID: <1336731086-26077-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In normal cases, we would not be allowed to do balance in RO mode.
However, when we're using a seeding device and adding another device to sprout,
things will change:

$ mkfs.btrfs /dev/sdb7
$ btrfstune -S 1 /dev/sdb7
$ mount /dev/sdb7 /mnt/btrfs -o ro
$ btrfs fi bal /mnt/btrfs   -----------------------> fail.
$ btrfs dev add /dev/sdb8 /mnt/btrfs
$ btrfs fi bal /mnt/btrfs   -----------------------> works!

It should not be designed as an exception, and we'd better add another check for
mnt flags.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 14f8e1f..f056469 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3212,8 +3212,9 @@ void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 	}
 }
 
-static long btrfs_ioctl_balance(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 {
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_ioctl_balance_args *bargs;
 	struct btrfs_balance_control *bctl;
@@ -3225,6 +3226,10 @@ static long btrfs_ioctl_balance(struct btrfs_root *root, void __user *arg)
 	if (fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		return ret;
+
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
 
@@ -3291,6 +3296,7 @@ out_bargs:
 out:
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
+	mnt_drop_write(file->f_path.mnt);
 	return ret;
 }
 
@@ -3386,7 +3392,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_DEV_INFO:
 		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
-		return btrfs_ioctl_balance(root, NULL);
+		return btrfs_ioctl_balance(file, NULL);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
@@ -3419,7 +3425,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SCRUB_PROGRESS:
 		return btrfs_ioctl_scrub_progress(root, argp);
 	case BTRFS_IOC_BALANCE_V2:
-		return btrfs_ioctl_balance(root, argp);
+		return btrfs_ioctl_balance(file, argp);
 	case BTRFS_IOC_BALANCE_CTL:
 		return btrfs_ioctl_balance_ctl(root, arg);
 	case BTRFS_IOC_BALANCE_PROGRESS:
-- 
1.6.5.2

