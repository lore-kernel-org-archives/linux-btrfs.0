Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab2KZIo1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:44:27 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ8iQjb006745
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 16:44:26 +0800
Message-ID: <50B32C02.1090106@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:44:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/9] Btrfs: get write access when removing a device
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -d single -m single <disk0> <disk1>
 # mount -o ro <disk0> <mnt0>
 # mount -o ro <disk0> <mnt1>
 # mount -o remount,rw <mnt0>
 # umount <mnt0>
 # btrfs device delete <disk1> <mnt1>

We can remove a device from a R/O filesystem. The reason is that we just check
the R/O flag of the super block object. It is not enough, because the kernel
may set the R/O flag only for the mount point. We need invoke

	mnt_want_write_file()

to do a full check.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c4bcba5..5921bb9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2248,16 +2248,18 @@ out:
 	return ret;
 }
 
-static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 {
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_vol_args *vol_args;
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
 
 	mutex_lock(&root->fs_info->volume_mutex);
 	if (root->fs_info->balance_ctl) {
@@ -2278,6 +2280,7 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
+	mnt_drop_write_file(file);
 	return ret;
 }
 
@@ -3766,7 +3769,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_ADD_DEV:
 		return btrfs_ioctl_add_dev(root, argp);
 	case BTRFS_IOC_RM_DEV:
-		return btrfs_ioctl_rm_dev(root, argp);
+		return btrfs_ioctl_rm_dev(file, argp);
 	case BTRFS_IOC_FS_INFO:
 		return btrfs_ioctl_fs_info(root, argp);
 	case BTRFS_IOC_DEV_INFO:
-- 
1.7.11.7

