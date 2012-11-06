Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:40381 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.1 OK) with ESMTP id p01bfcoA6DKxNc
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/26] Btrfs: disallow mutually exclusiv admin operations from user mode
Date: Tue,  6 Nov 2012 17:38:34 +0100
Message-Id: <2991a9d436b003e25a28474465020db6ca9dd614.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

Btrfs admin operations that are manually started from user mode
and that cannot be executed at the same time return -EINPROGRESS.
A common way to enter and leave this locked section is introduced
since it used to be specific to the balance operation.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/ioctl.c   | 53 ++++++++++++++++++++++++++++++++++++-----------------
 fs/btrfs/volumes.c |  2 ++
 3 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4bffc63..f9ceea9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1527,6 +1527,8 @@ struct btrfs_fs_info {
 
 	/* device replace state */
 	struct btrfs_dev_replace dev_replace;
+
+	atomic_t mutually_exclusive_operation_running;
 };
 
 /*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7ece1fe..d912c64 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1314,13 +1314,13 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	mutex_lock(&root->fs_info->volume_mutex);
-	if (root->fs_info->balance_ctl) {
-		printk(KERN_INFO "btrfs: balance in progress\n");
-		ret = -EINVAL;
-		goto out;
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		return -EINPROGRESS;
 	}
 
+	mutex_lock(&root->fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -1416,6 +1416,7 @@ out_free:
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
+	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 	return ret;
 }
 
@@ -2157,9 +2158,17 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		return -EINPROGRESS;
+	}
 	ret = mnt_want_write_file(file);
-	if (ret)
+	if (ret) {
+		atomic_set(&root->fs_info->mutually_exclusive_operation_running,
+			   0);
 		return ret;
+	}
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFDIR:
@@ -2211,6 +2220,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	}
 out:
 	mnt_drop_write_file(file);
+	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 	return ret;
 }
 
@@ -2222,13 +2232,13 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	mutex_lock(&root->fs_info->volume_mutex);
-	if (root->fs_info->balance_ctl) {
-		printk(KERN_INFO "btrfs: balance in progress\n");
-		ret = -EINVAL;
-		goto out;
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		return -EINPROGRESS;
 	}
 
+	mutex_lock(&root->fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -2241,6 +2251,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
+	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 	return ret;
 }
 
@@ -2255,13 +2266,13 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
-	mutex_lock(&root->fs_info->volume_mutex);
-	if (root->fs_info->balance_ctl) {
-		printk(KERN_INFO "btrfs: balance in progress\n");
-		ret = -EINVAL;
-		goto out;
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		return -EINPROGRESS;
 	}
 
+	mutex_lock(&root->fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -2274,6 +2285,7 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
+	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 	return ret;
 }
 
@@ -3316,6 +3328,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	struct btrfs_ioctl_balance_args *bargs;
 	struct btrfs_balance_control *bctl;
 	int ret;
+	int need_to_clear_lock = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3351,10 +3364,13 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 		bargs = NULL;
 	}
 
-	if (fs_info->balance_ctl) {
+	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
+			1)) {
+		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
 		ret = -EINPROGRESS;
 		goto out_bargs;
 	}
+	need_to_clear_lock = 1;
 
 	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
 	if (!bctl) {
@@ -3388,6 +3404,9 @@ do_balance:
 out_bargs:
 	kfree(bargs);
 out:
+	if (need_to_clear_lock)
+		atomic_set(&root->fs_info->mutually_exclusive_operation_running,
+			   0);
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
 	mnt_drop_write_file(file);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 473ae89..1827bcd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2956,6 +2956,7 @@ static int balance_kthread(void *data)
 		ret = btrfs_balance(fs_info->balance_ctl, NULL);
 	}
 
+	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
 
@@ -2978,6 +2979,7 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 		return 0;
 	}
 
+	WARN_ON(atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1));
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
 	if (IS_ERR(tsk))
 		return PTR_ERR(tsk);
-- 
1.8.0

