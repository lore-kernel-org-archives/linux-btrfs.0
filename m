Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55861 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3C1Kxy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 06:53:54 -0400
Received: by mail-pb0-f54.google.com with SMTP id rq13so1719400pbb.27
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 03:53:54 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH V2 1/6] Btrfs: introduce a mutex lock for btrfs quota operations
Date: Thu, 28 Mar 2013 18:53:44 +0800
Message-Id: <1364468024-1636-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1364468055-1669-1-git-send-email-wangshilong1991@gmail.com>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces mutex lock 'quota_lock', and makes
all the user change for quota protected by quota_lock.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |    3 +++
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/ioctl.c   |   16 ++++++++++++----
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6e81860..a11a8ed 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1584,6 +1584,9 @@ struct btrfs_fs_info {
 	struct rb_root qgroup_tree;
 	spinlock_t qgroup_lock;
 
+	/* protect user change operations for quota */
+	struct mutex quota_lock;
+
 	/* list of dirty qgroups to be written at next commit */
 	struct list_head dirty_qgroups;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fe82d08..4552f14 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2250,6 +2250,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->dev_replace.lock);
 
 	spin_lock_init(&fs_info->qgroup_lock);
+	mutex_init(&fs_info->quota_lock);
 	fs_info->qgroup_tree = RB_ROOT;
 	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
 	fs_info->qgroup_seq = 1;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 222ce84..e2950f1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -752,7 +752,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 
 	if (btrfs_root_refs(&BTRFS_I(dir)->root->root_item) == 0)
 		goto out_up_read;
-
+	mutex_lock(&BTRFS_I(dir)->root->fs_info->quota_lock);
 	if (snap_src) {
 		error = create_snapshot(snap_src, dir, dentry, name, namelen,
 					async_transid, readonly, inherit);
@@ -762,6 +762,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
+	mutex_unlock(&BTRFS_I(dir)->root->fs_info->quota_lock);
 out_up_read:
 	up_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
 out_dput:
@@ -3693,6 +3694,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	mutex_lock(&root->fs_info->quota_lock);
 	down_read(&root->fs_info->subvol_sem);
 	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
 		trans = btrfs_start_transaction(root, 2);
@@ -3728,6 +3730,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 out:
 	kfree(sa);
 	up_read(&root->fs_info->subvol_sem);
+	mutex_unlock(&root->fs_info->quota_lock);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3754,6 +3757,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	mutex_lock(&root->fs_info->quota_lock);
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
@@ -3775,6 +3779,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 
 out:
 	kfree(sa);
+	mutex_unlock(&root->fs_info->quota_lock);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3805,11 +3810,11 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		ret = -EINVAL;
 		goto out;
 	}
-
+	mutex_lock(&root->fs_info->quota_lock);
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out;
+		goto out_unlock;
 	}
 
 	/* FIXME: check if the IDs really exist */
@@ -3824,6 +3829,8 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	if (err && !ret)
 		ret = err;
 
+out_unlock:
+	mutex_unlock(&root->fs_info->quota_lock);
 out:
 	kfree(sa);
 drop_write:
@@ -3852,7 +3859,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		ret = PTR_ERR(sa);
 		goto drop_write;
 	}
-
+	mutex_lock(&root->fs_info->quota_lock);
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
@@ -3874,6 +3881,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 
 out:
 	kfree(sa);
+	mutex_unlock(&root->fs_info->quota_lock);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
-- 
1.7.7.6

