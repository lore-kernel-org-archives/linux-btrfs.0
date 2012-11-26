Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab2KZInW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:43:22 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ8hLQ5006688
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 16:43:21 +0800
Message-ID: <50B32BC1.7040201@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:43:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/9] Btrfs: get write access when doing resize fs
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs <partition>
 # mount -o ro <partition> <mnt0>
 # mount -o ro <partition> <mnt1>
 # mount -o remount,rw <mnt0>
 # umount <mnt0>
 # btrfs fi resize 10g <mnt1>

We re-sized a R/O filesystem. The reason is that we just check the R/O flag
of the super block object. It is not enough, because the kernel may set the
R/O flag only for the mount point. We need invoke mnt_want_write_file() to
do a full check.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7d0214b..c4bcba5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1293,12 +1293,13 @@ out_ra:
 	return ret;
 }
 
-static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
+static noinline int btrfs_ioctl_resize(struct file *file,
 					void __user *arg)
 {
 	u64 new_size;
 	u64 old_size;
 	u64 devid = 1;
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_vol_args *vol_args;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device = NULL;
@@ -1307,12 +1308,13 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	int ret = 0;
 	int mod = 0;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
 	mutex_lock(&root->fs_info->volume_mutex);
 	if (root->fs_info->balance_ctl) {
 		printk(KERN_INFO "btrfs: balance in progress\n");
@@ -1415,6 +1417,7 @@ out_free:
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
+	mnt_drop_write_file(file);
 	return ret;
 }
 
@@ -3759,7 +3762,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_DEFRAG_RANGE:
 		return btrfs_ioctl_defrag(file, argp);
 	case BTRFS_IOC_RESIZE:
-		return btrfs_ioctl_resize(root, argp);
+		return btrfs_ioctl_resize(file, argp);
 	case BTRFS_IOC_ADD_DEV:
 		return btrfs_ioctl_add_dev(root, argp);
 	case BTRFS_IOC_RM_DEV:
-- 
1.7.11.7

