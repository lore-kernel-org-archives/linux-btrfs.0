Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28671 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab2KZItt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:49:49 -0500
Message-ID: <50B32D43.4060703@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:50:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 8/9] Btrfs: get write access for qgroup operations
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need get write access for qgroup operations, or we will modify the R/O fs.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 73 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a7afafa..e6525d1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3481,8 +3481,9 @@ out:
 	return ret;
 }
 
-static long btrfs_ioctl_quota_ctl(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 {
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_quota_ctl_args *sa;
 	struct btrfs_trans_handle *trans = NULL;
 	int ret;
@@ -3491,12 +3492,15 @@ static long btrfs_ioctl_quota_ctl(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
 
 	sa = memdup_user(arg, sizeof(*sa));
-	if (IS_ERR(sa))
-		return PTR_ERR(sa);
+	if (IS_ERR(sa)) {
+		ret = PTR_ERR(sa);
+		goto drop_write;
+	}
 
 	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
 		trans = btrfs_start_transaction(root, 2);
@@ -3529,14 +3533,16 @@ static long btrfs_ioctl_quota_ctl(struct btrfs_root *root, void __user *arg)
 		if (err && !ret)
 			ret = err;
 	}
-
 out:
 	kfree(sa);
+drop_write:
+	mnt_drop_write_file(file);
 	return ret;
 }
 
-static long btrfs_ioctl_qgroup_assign(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 {
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_qgroup_assign_args *sa;
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -3545,12 +3551,15 @@ static long btrfs_ioctl_qgroup_assign(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
 
 	sa = memdup_user(arg, sizeof(*sa));
-	if (IS_ERR(sa))
-		return PTR_ERR(sa);
+	if (IS_ERR(sa)) {
+		ret = PTR_ERR(sa);
+		goto drop_write;
+	}
 
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
@@ -3573,11 +3582,14 @@ static long btrfs_ioctl_qgroup_assign(struct btrfs_root *root, void __user *arg)
 
 out:
 	kfree(sa);
+drop_write:
+	mnt_drop_write_file(file);
 	return ret;
 }
 
-static long btrfs_ioctl_qgroup_create(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 {
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_qgroup_create_args *sa;
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -3586,12 +3598,15 @@ static long btrfs_ioctl_qgroup_create(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
 
 	sa = memdup_user(arg, sizeof(*sa));
-	if (IS_ERR(sa))
-		return PTR_ERR(sa);
+	if (IS_ERR(sa)) {
+		ret = PTR_ERR(sa);
+		goto drop_write;
+	}
 
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
@@ -3613,11 +3628,14 @@ static long btrfs_ioctl_qgroup_create(struct btrfs_root *root, void __user *arg)
 
 out:
 	kfree(sa);
+drop_write:
+	mnt_drop_write_file(file);
 	return ret;
 }
 
-static long btrfs_ioctl_qgroup_limit(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 {
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_qgroup_limit_args *sa;
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -3627,12 +3645,15 @@ static long btrfs_ioctl_qgroup_limit(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
 
 	sa = memdup_user(arg, sizeof(*sa));
-	if (IS_ERR(sa))
-		return PTR_ERR(sa);
+	if (IS_ERR(sa)) {
+		ret = PTR_ERR(sa);
+		goto drop_write;
+	}
 
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
@@ -3655,6 +3676,8 @@ static long btrfs_ioctl_qgroup_limit(struct btrfs_root *root, void __user *arg)
 
 out:
 	kfree(sa);
+drop_write:
+	mnt_drop_write_file(file);
 	return ret;
 }
 
@@ -3830,13 +3853,13 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_GET_DEV_STATS:
 		return btrfs_ioctl_get_dev_stats(root, argp);
 	case BTRFS_IOC_QUOTA_CTL:
-		return btrfs_ioctl_quota_ctl(root, argp);
+		return btrfs_ioctl_quota_ctl(file, argp);
 	case BTRFS_IOC_QGROUP_ASSIGN:
-		return btrfs_ioctl_qgroup_assign(root, argp);
+		return btrfs_ioctl_qgroup_assign(file, argp);
 	case BTRFS_IOC_QGROUP_CREATE:
-		return btrfs_ioctl_qgroup_create(root, argp);
+		return btrfs_ioctl_qgroup_create(file, argp);
 	case BTRFS_IOC_QGROUP_LIMIT:
-		return btrfs_ioctl_qgroup_limit(root, argp);
+		return btrfs_ioctl_qgroup_limit(file, argp);
 	}
 
 	return -ENOTTY;
-- 
1.7.11.7

