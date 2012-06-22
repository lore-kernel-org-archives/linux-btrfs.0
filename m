Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55338 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab2FVSYU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 14:24:20 -0400
Received: by wgbds11 with SMTP id ds11so963000wgb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 11:24:19 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 2/2] Btrfs: resume balance on rw (re)mounts properly
Date: Fri, 22 Jun 2012 21:24:13 +0300
Message-Id: <1340389453-21439-3-git-send-email-idryomov@gmail.com>
In-Reply-To: <1340389453-21439-1-git-send-email-idryomov@gmail.com>
References: <1340389453-21439-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This introduces btrfs_resume_balance_async(), which, given that
restriper state was recovered earlier by btrfs_recover_balance(),
resumes balance in btrfs-balance kthread.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |   24 +++++++++++++++---------
 fs/btrfs/super.c   |    4 ++++
 fs/btrfs/volumes.c |   36 +++++++++++++++++++++++++++---------
 fs/btrfs/volumes.h |    1 +
 4 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dae7cd6..e863f58 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2490,17 +2490,23 @@ retry_root_backup:
 		goto fail_trans_kthread;
 	}
 
-	if (!(sb->s_flags & MS_RDONLY)) {
-		down_read(&fs_info->cleanup_work_sem);
-		err = btrfs_orphan_cleanup(fs_info->fs_root);
-		if (!err)
-			err = btrfs_orphan_cleanup(fs_info->tree_root);
+	if (sb->s_flags & MS_RDONLY)
+		return 0;
+
+	down_read(&fs_info->cleanup_work_sem);
+	if ((ret = btrfs_orphan_cleanup(fs_info->fs_root)) ||
+	    (ret = btrfs_orphan_cleanup(fs_info->tree_root))) {
 		up_read(&fs_info->cleanup_work_sem);
+		close_ctree(tree_root);
+		return ret;
+	}
+	up_read(&fs_info->cleanup_work_sem);
 
-		if (err) {
-			close_ctree(tree_root);
-			return err;
-		}
+	ret = btrfs_resume_balance_async(fs_info);
+	if (ret) {
+		printk(KERN_WARNING "btrfs: failed to resume balance\n");
+		close_ctree(tree_root);
+		return ret;
 	}
 
 	return 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0eb9a4d..e239915 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1187,6 +1187,10 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (ret)
 			goto restore;
 
+		ret = btrfs_resume_balance_async(fs_info);
+		if (ret)
+			goto restore;
+
 		sb->s_flags &= ~MS_RDONLY;
 	}
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f7649b9..0f1778c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2845,28 +2845,46 @@ out:
 
 static int balance_kthread(void *data)
 {
-	struct btrfs_balance_control *bctl =
-			(struct btrfs_balance_control *)data;
-	struct btrfs_fs_info *fs_info = bctl->fs_info;
+	struct btrfs_fs_info *fs_info = data;
 	int ret = 0;
 
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
 
-	set_balance_control(bctl);
-
-	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
-		printk(KERN_INFO "btrfs: force skipping balance\n");
-	} else {
+	if (fs_info->balance_ctl) {
 		printk(KERN_INFO "btrfs: continuing balance\n");
-		ret = btrfs_balance(bctl, NULL);
+		ret = btrfs_balance(fs_info->balance_ctl, NULL);
 	}
 
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
+
 	return ret;
 }
 
+int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
+{
+	struct task_struct *tsk;
+
+	spin_lock(&fs_info->balance_lock);
+	if (!fs_info->balance_ctl) {
+		spin_unlock(&fs_info->balance_lock);
+		return 0;
+	}
+	spin_unlock(&fs_info->balance_lock);
+
+	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
+		printk(KERN_INFO "btrfs: force skipping balance\n");
+		return 0;
+	}
+
+	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
+	if (IS_ERR(tsk))
+		return PTR_ERR(tsk);
+
+	return 0;
+}
+
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_balance_control *bctl;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index e1b1a64..95f6637 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -281,6 +281,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
+int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
-- 
1.7.9.1

