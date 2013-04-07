Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:62905 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab3DGKuy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 06:50:54 -0400
Received: by mail-da0-f41.google.com with SMTP id w4so2207531dam.0
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 03:50:53 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH V3 1/5] Btrfs: introduce a mutex lock for btrfs quota operations
Date: Sun,  7 Apr 2013 18:50:16 +0800
Message-Id: <1365331820-973-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
References: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The original code has one spin_lock 'qgroup_lock' to protect quota
configurations in memory. If we want to add a BTRFS_QGROUP_INFO_KEY,
it will be added to Btree firstly, and then update configurations in
memory,however, a race condition may happen between these operations.
For example:
	->add_qgroup_info_item()
		->add_qgroup_rb()

For the above case, del_qgroup_info_item() may happen just before
add_qgroup_rb().

What's worse, when we want to add a qgroup relation:
	->add_qgroup_relation_item()
		->add_qgroup_relations()

We don't have any checks whether 'src' and 'dst' exist before
add_qgroup_relation_item(), a race condition can also happen for
the above case.

To avoid race condition and have all the necessary checks, we introduce
a mutex lock 'qgroup_ioctl_lock', and we make all the user change operations
protected by the mutex lock.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |  3 ++
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/qgroup.c  | 82 +++++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6e81860..15bd72b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1584,6 +1584,9 @@ struct btrfs_fs_info {
 	struct rb_root qgroup_tree;
 	spinlock_t qgroup_lock;
 
+	/* protect user change for quota operations */
+	struct mutex qgroup_ioctl_lock;
+
 	/* list of dirty qgroups to be written at next commit */
 	struct list_head dirty_qgroups;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4bae789..238f5cc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2251,6 +2251,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->dev_replace.lock);
 
 	spin_lock_init(&fs_info->qgroup_lock);
+	mutex_init(&fs_info->qgroup_ioctl_lock);
 	fs_info->qgroup_tree = RB_ROOT;
 	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
 	fs_info->qgroup_seq = 1;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e3598fa..5837cb5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -793,6 +793,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int slot;
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	spin_lock(&fs_info->qgroup_lock);
 	if (fs_info->quota_root) {
 		fs_info->pending_quota_state = 1;
@@ -902,6 +903,7 @@ out_free_root:
 		kfree(quota_root);
 	}
 out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
@@ -912,10 +914,11 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root;
 	int ret = 0;
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	spin_lock(&fs_info->qgroup_lock);
 	if (!fs_info->quota_root) {
 		spin_unlock(&fs_info->qgroup_lock);
-		return 0;
+		goto out;
 	}
 	fs_info->quota_enabled = 0;
 	fs_info->pending_quota_state = 0;
@@ -924,8 +927,10 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	btrfs_free_qgroup_config(fs_info);
 	spin_unlock(&fs_info->qgroup_lock);
 
-	if (!quota_root)
-		return -EINVAL;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = btrfs_clean_quota_tree(trans, quota_root);
 	if (ret)
@@ -946,6 +951,7 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	free_extent_buffer(quota_root->commit_root);
 	kfree(quota_root);
 out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
@@ -961,24 +967,28 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root;
 	int ret = 0;
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = add_qgroup_relation_item(trans, quota_root, src, dst);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = add_qgroup_relation_item(trans, quota_root, dst, src);
 	if (ret) {
 		del_qgroup_relation_item(trans, quota_root, src, dst);
-		return ret;
+		goto out;
 	}
 
 	spin_lock(&fs_info->qgroup_lock);
 	ret = add_relation_rb(quota_root->fs_info, src, dst);
 	spin_unlock(&fs_info->qgroup_lock);
-
+out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
@@ -989,9 +999,12 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int err;
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = del_qgroup_relation_item(trans, quota_root, src, dst);
 	err = del_qgroup_relation_item(trans, quota_root, dst, src);
@@ -1002,7 +1015,8 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 	del_relation_rb(fs_info, src, dst);
 
 	spin_unlock(&fs_info->qgroup_lock);
-
+out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
@@ -1013,9 +1027,12 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = add_qgroup_item(trans, quota_root, qgroupid);
 
@@ -1025,7 +1042,8 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 
 	if (IS_ERR(qgroup))
 		ret = PTR_ERR(qgroup);
-
+out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
@@ -1036,9 +1054,12 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		return -EINVAL;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* check if there are no relations to this qgroup */
 	spin_lock(&fs_info->qgroup_lock);
@@ -1046,7 +1067,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	if (qgroup) {
 		if (!list_empty(&qgroup->groups) || !list_empty(&qgroup->members)) {
 			spin_unlock(&fs_info->qgroup_lock);
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out;
 		}
 	}
 	spin_unlock(&fs_info->qgroup_lock);
@@ -1056,7 +1078,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	spin_lock(&fs_info->qgroup_lock);
 	del_qgroup_rb(quota_root->fs_info, qgroupid);
 	spin_unlock(&fs_info->qgroup_lock);
-
+out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
@@ -1064,12 +1087,16 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 qgroupid,
 		       struct btrfs_qgroup_limit *limit)
 {
-	struct btrfs_root *quota_root = fs_info->quota_root;
+	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 
-	if (!quota_root)
-		return -EINVAL;
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	quota_root = fs_info->quota_root;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = update_qgroup_limit_item(trans, quota_root, qgroupid,
 				       limit->flags, limit->max_rfer,
@@ -1096,7 +1123,8 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
-
+out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
@@ -1394,11 +1422,14 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup *dstgroup;
 	u32 level_size = 0;
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_enabled)
-		return 0;
+		goto out;
 
-	if (!quota_root)
-		return -EINVAL;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/*
 	 * create a tracking group for the subvol itself
@@ -1525,6 +1556,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
 out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
-- 
1.7.11.7

