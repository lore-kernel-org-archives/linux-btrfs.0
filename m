Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49755 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3CZLzf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:55:35 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so1108588pad.6
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:55:35 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH 1/7] Btrfs: introduce a mutex lock for btrfs quota operations
Date: Tue, 26 Mar 2013 19:55:24 +0800
Message-Id: <1364298930-4507-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The original code only has one spin_lock 'qgroup_lock' to protect
quota configurations on memory, if we want to add a BTRFS_QGROUP_INFO_KEY,
it will be added to Btree firstly and then update quota configuration
on memory,this case works ok just because of Btrfs internal btree lock.
However, if we want to add a BTRFS_QGROUP_RELATION_KEY, this will cause
problems, in fact,we need to check 'src' and 'dst' before, without an extra lock,
race conditions can not be avoided.

Holding mutex_lock, we can have the check before operations in safety.
Besides, we can remove some spin_lock usages and ease the burdern
of the global spin_lock.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/ioctl.c   |   13 ++++++++++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6e81860..a7fec8c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1582,6 +1582,7 @@ struct btrfs_fs_info {
 
 	/* holds configuration and tracking. Protected by qgroup_lock */
 	struct rb_root qgroup_tree;
+	struct mutex quota_lock;
 	spinlock_t qgroup_lock;
 
 	/* list of dirty qgroups to be written at next commit */
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
index 222ce84..0b8ab81 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3693,6 +3693,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	mutex_lock(&root->fs_info->quota_lock);
 	down_read(&root->fs_info->subvol_sem);
 	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
 		trans = btrfs_start_transaction(root, 2);
@@ -3728,6 +3729,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 out:
 	kfree(sa);
 	up_read(&root->fs_info->subvol_sem);
+	mutex_unlock(&root->fs_info->quota_lock);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3754,6 +3756,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	mutex_lock(&root->fs_info->quota_lock);
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
@@ -3775,6 +3778,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 
 out:
 	kfree(sa);
+	mutex_unlock(&root->fs_info->quota_lock);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
@@ -3805,11 +3809,11 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
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
@@ -3824,6 +3828,8 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	if (err && !ret)
 		ret = err;
 
+out_unlock:
+	mutex_unlock(&root->fs_info->quota_lock);
 out:
 	kfree(sa);
 drop_write:
@@ -3852,7 +3858,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		ret = PTR_ERR(sa);
 		goto drop_write;
 	}
-
+	mutex_lock(&root->fs_info->quota_lock);
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
@@ -3874,6 +3880,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 
 out:
 	kfree(sa);
+	mutex_unlock(&root->fs_info->quota_lock);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
-- 
1.7.7.6

