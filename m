Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60025 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbeEGFmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 01:42:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AABE1AD16
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 05:42:22 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] btrfs: qgroup: Only queue rescan work after QUOTA_ENABLED flag takes effect
Date: Mon,  7 May 2018 13:42:19 +0800
Message-Id: <20180507054219.12022-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently we set QUOTA_ENABLED flags and then queue rescan work, and
then commit current transaction.

The behavior could lead to missing quota accounts as quota rescan only
scan committed root, thus it won't account modification in current
transaction.
While for current transaction, we rely btrfs_qgroup_extent_record
structure to trace dirty extents, which is only created after
QUOTA_ENABLED flags set.

Above behavior a window where any modification before we set QUOTA_ENABLED
flags will not be accounted in current transaction.

This patch will fix the behavior by delaying setting QUOTA_ENABLED flags
(sounds pretty familiar right? Just like the old pending_quota_status),
and QUOTA_ENABLED will only be enabled after current transaction
committed, then we queue rescan work.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c       | 16 ++-------------
 fs/btrfs/qgroup.c      | 46 +++++++++++++++++++++++++++++++++++-------
 fs/btrfs/qgroup.h      |  6 ++----
 fs/btrfs/transaction.c |  3 +++
 fs/btrfs/transaction.h |  6 ++++++
 5 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e1dedc78d1ad..2ed8fdf9d1d5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4527,9 +4527,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ioctl_quota_ctl_args *sa;
-	struct btrfs_trans_handle *trans = NULL;
 	int ret;
-	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -4545,28 +4543,18 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	}
 
 	down_write(&fs_info->subvol_sem);
-	trans = btrfs_start_transaction(fs_info->tree_root, 2);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		goto out;
-	}
 
 	switch (sa->cmd) {
 	case BTRFS_QUOTA_CTL_ENABLE:
-		ret = btrfs_quota_enable(trans, fs_info);
+		ret = btrfs_quota_enable(fs_info);
 		break;
 	case BTRFS_QUOTA_CTL_DISABLE:
-		ret = btrfs_quota_disable(trans, fs_info);
+		ret = btrfs_quota_disable(fs_info);
 		break;
 	default:
 		ret = -EINVAL;
 		break;
 	}
-
-	err = btrfs_commit_transaction(trans);
-	if (err && !ret)
-		ret = err;
-out:
 	kfree(sa);
 	up_write(&fs_info->subvol_sem);
 drop_write:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2ee2d21d43ab..6a14aae426da 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -875,9 +875,9 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_quota_enable(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info)
+int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_root *quota_root;
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_path *path = NULL;
@@ -886,9 +886,14 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_qgroup *qgroup = NULL;
+	bool free_root = false;
 	int ret = 0;
 	int slot;
 
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (fs_info->quota_root)
 		goto out;
@@ -908,6 +913,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		ret =  PTR_ERR(quota_root);
 		goto out;
 	}
+	free_root = true;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -983,10 +989,24 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		ret = PTR_ERR(qgroup);
 		goto out_free_path;
 	}
+	free_root = false;
 	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
-	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+	/*
+	 * Quota rescan work is only add quota numbers for commit root, thus
+	 * modication happened current transaction will not be accounted if
+	 * QUOTA_ENABLED flag is set.
+	 * So only set QUOTA_ENABLED flag on next transaction and queue rescan
+	 * work in next transaction.
+	 */
+	set_bit(BTRFS_FS_QUOTA_ENABLED,
+		&trans->transaction->pending_fs_info_flags);
 	spin_unlock(&fs_info->qgroup_lock);
+	ret = btrfs_commit_transaction(trans);
+	trans = NULL;
+	if (ret)
+		goto out_free_path;
+
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (!ret) {
 	        qgroup_rescan_zero_tracking(fs_info);
@@ -997,7 +1017,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 out_free_path:
 	btrfs_free_path(path);
 out_free_root:
-	if (ret) {
+	if (free_root) {
 		free_extent_buffer(quota_root->node);
 		free_extent_buffer(quota_root->commit_root);
 		kfree(quota_root);
@@ -1008,15 +1028,21 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		fs_info->qgroup_ulist = NULL;
 	}
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (trans)
+		btrfs_end_transaction(trans);
 	return ret;
 }
 
-int btrfs_quota_disable(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info)
+int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *quota_root;
+	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
 		goto out;
@@ -1048,8 +1074,12 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	free_extent_buffer(quota_root->node);
 	free_extent_buffer(quota_root->commit_root);
 	kfree(quota_root);
+	ret = btrfs_commit_transaction(trans);
+	trans = NULL;
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (trans)
+		btrfs_end_transaction(trans);
 	return ret;
 }
 
@@ -2162,7 +2192,9 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		spin_lock(&fs_info->qgroup_lock);
 	}
-	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
+	    test_bit(BTRFS_FS_QUOTA_ENABLED,
+		     &trans->transaction->pending_fs_info_flags))
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_ON;
 	else
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d60dd06445ce..bec7c9b17a8e 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -141,10 +141,8 @@ struct btrfs_qgroup {
 #define QGROUP_RELEASE		(1<<1)
 #define QGROUP_FREE		(1<<2)
 
-int btrfs_quota_enable(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info);
-int btrfs_quota_disable(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info);
+int btrfs_quota_enable(struct btrfs_fs_info *fs_info);
+int btrfs_quota_disable(struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
 void btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dd3b0e0d822f..46c6e31d79bc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -241,6 +241,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	refcount_set(&cur_trans->use_count, 2);
 	atomic_set(&cur_trans->pending_ordered, 0);
 	cur_trans->flags = 0;
+	cur_trans->pending_fs_info_flags = 0;
 	cur_trans->start_time = get_seconds();
 
 	memset(&cur_trans->delayed_refs, 0, sizeof(cur_trans->delayed_refs));
@@ -2218,6 +2219,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	spin_lock(&fs_info->trans_lock);
 	cur_trans->state = TRANS_STATE_UNBLOCKED;
 	fs_info->running_transaction = NULL;
+	fs_info->flags |= cur_trans->pending_fs_info_flags;
+	cur_trans->pending_fs_info_flags = 0;
 	spin_unlock(&fs_info->trans_lock);
 	mutex_unlock(&fs_info->reloc_mutex);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d8c0826bc2c7..3654d78dbf7b 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -43,6 +43,12 @@ struct btrfs_transaction {
 
 	unsigned long flags;
 
+	/*
+	 * flags which will be set to fs_info->flags after this transaction
+	 * committed
+	 */
+	unsigned long pending_fs_info_flags;
+
 	/* Be protected by fs_info->trans_lock when we want to change it. */
 	enum btrfs_trans_state state;
 	int aborted;
-- 
2.17.0

