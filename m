Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:39228 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3ATP3W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 10:29:22 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so2427387eek.1
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 07:29:21 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH 1/5] Btrfs: bring back balance pause/resume logic
Date: Sun, 20 Jan 2013 17:22:28 +0200
Message-Id: <1358695352-7140-2-git-send-email-idryomov@gmail.com>
In-Reply-To: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
References: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance pause/resume logic got broken by 5ac00add (went in into 3.8-rc1
as part of dev-replace merge).  Offending commit took a stab at making
mutually exclusive volume operations (add_dev, rm_dev, resize, balance,
replace_dev) not block behind volume_mutex if another such operation is
in progress and instead return an error right away.  Balancing front-end
relied on the blocking behaviour, so the fix is ugly, but short of a
complete rework, it's the best we can do.

Reported-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c   |   78 ++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/volumes.c |   10 ++++--
 2 files changed, 71 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 171786a..ab82636 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3441,8 +3441,8 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_ioctl_balance_args *bargs;
 	struct btrfs_balance_control *bctl;
+	bool need_unlock; /* for mut. excl. ops lock */
 	int ret;
-	int need_to_clear_lock = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3451,14 +3451,61 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	mutex_lock(&fs_info->volume_mutex);
+again:
+	if (!atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1)) {
+		mutex_lock(&fs_info->volume_mutex);
+		mutex_lock(&fs_info->balance_mutex);
+		need_unlock = true;
+		goto locked;
+	}
+
+	/*
+	 * mut. excl. ops lock is locked.  Three possibilites:
+	 *   (1) some other op is running
+	 *   (2) balance is running
+	 *   (3) balance is paused -- special case (think resume)
+	 */
 	mutex_lock(&fs_info->balance_mutex);
+	if (fs_info->balance_ctl) {
+		/* this is either (2) or (3) */
+		if (!atomic_read(&fs_info->balance_running)) {
+			mutex_unlock(&fs_info->balance_mutex);
+			if (!mutex_trylock(&fs_info->volume_mutex))
+				goto again;
+			mutex_lock(&fs_info->balance_mutex);
+
+			if (fs_info->balance_ctl &&
+			    !atomic_read(&fs_info->balance_running)) {
+				/* this is (3) */
+				need_unlock = false;
+				goto locked;
+			}
+
+			mutex_unlock(&fs_info->balance_mutex);
+			mutex_unlock(&fs_info->volume_mutex);
+			goto again;
+		} else {
+			/* this is (2) */
+			mutex_unlock(&fs_info->balance_mutex);
+			ret = -EINPROGRESS;
+			goto out;
+		}
+	} else {
+		/* this is (1) */
+		mutex_unlock(&fs_info->balance_mutex);
+		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+locked:
+	BUG_ON(!atomic_read(&fs_info->mutually_exclusive_operation_running));
 
 	if (arg) {
 		bargs = memdup_user(arg, sizeof(*bargs));
 		if (IS_ERR(bargs)) {
 			ret = PTR_ERR(bargs);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (bargs->flags & BTRFS_BALANCE_RESUME) {
@@ -3478,13 +3525,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 		bargs = NULL;
 	}
 
-	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
-			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+	if (fs_info->balance_ctl) {
 		ret = -EINPROGRESS;
 		goto out_bargs;
 	}
-	need_to_clear_lock = 1;
 
 	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
 	if (!bctl) {
@@ -3505,11 +3549,17 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	}
 
 do_balance:
-	ret = btrfs_balance(bctl, bargs);
 	/*
-	 * bctl is freed in __cancel_balance or in free_fs_info if
-	 * restriper was paused all the way until unmount
+	 * Ownership of bctl and mutually_exclusive_operation_running
+	 * goes to to btrfs_balance.  bctl is freed in __cancel_balance,
+	 * or, if restriper was paused all the way until unmount, in
+	 * free_fs_info.  mutually_exclusive_operation_running is
+	 * cleared in __cancel_balance.
 	 */
+	need_unlock = false;
+
+	ret = btrfs_balance(bctl, bargs);
+
 	if (arg) {
 		if (copy_to_user(arg, bargs, sizeof(*bargs)))
 			ret = -EFAULT;
@@ -3517,12 +3567,12 @@ do_balance:
 
 out_bargs:
 	kfree(bargs);
-out:
-	if (need_to_clear_lock)
-		atomic_set(&root->fs_info->mutually_exclusive_operation_running,
-			   0);
+out_unlock:
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
+	if (need_unlock)
+		atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
+out:
 	mnt_drop_write_file(file);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 86279c3..9c84dbe 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2959,6 +2959,8 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 	unset_balance_control(fs_info);
 	ret = del_balance_item(fs_info->tree_root);
 	BUG_ON(ret);
+
+	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 }
 
 void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
@@ -3138,8 +3140,10 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 out:
 	if (bctl->flags & BTRFS_BALANCE_RESUME)
 		__cancel_balance(fs_info);
-	else
+	else {
 		kfree(bctl);
+		atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
+	}
 	return ret;
 }
 
@@ -3156,7 +3160,6 @@ static int balance_kthread(void *data)
 		ret = btrfs_balance(fs_info->balance_ctl, NULL);
 	}
 
-	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
 
@@ -3179,7 +3182,6 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 		return 0;
 	}
 
-	WARN_ON(atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1));
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
 	if (IS_ERR(tsk))
 		return PTR_ERR(tsk);
@@ -3233,6 +3235,8 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	btrfs_balance_sys(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
 
+	WARN_ON(atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1));
+
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
 
-- 
1.7.9.1

