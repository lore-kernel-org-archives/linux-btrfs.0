Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753673AbeGELuw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 07:50:52 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com, misono.tomohiro@jp.fujitsu.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: qgroups: Move transaction management inside btrfs_quota_enable/disable
Date: Thu,  5 Jul 2018 14:50:48 +0300
Message-Id: <1530791448-12743-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to
btrfs_quota_enable") not only resulted in an easier to follow code but
it also introduced a subtle bug. It changed the timing when the initial
transaction rescan was happening - before the commit it would happen
after transaction commit had occured but after the commit it might happen
before the transaction was committed. This results in failure to
correctly rescan the quota since there could be data which is still not
committed on disk.

This patch aims to fix this by movign the transaction creation/commit
inside btrfs_quota_enable, which allows to schedule the quota commit
after the transaction has been committed.

Fixes: 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to btrfs_quota_enable")
Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Link: https://marc.info/?l=linux-btrfs&m=152999289017582
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Hello, 

One open-ended question this patch puts is how many items should be reserved
to guarantee successful qgroup disable. Before this patch quota disable was 
always using the arbitrary reservation of 2 items. Since this patch makes the 
the transaction for enable/disable independent we have a chance to actually 
set appropriate values for both transactions. In any case this patch doesn't 
make things worse than before. 

 fs/btrfs/ioctl.c  | 15 ++--------
 fs/btrfs/qgroup.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/qgroup.h |  6 ++--
 3 files changed, 76 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cc03d1a04988..7b308184af57 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5135,9 +5135,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ioctl_quota_ctl_args *sa;
-	struct btrfs_trans_handle *trans = NULL;
 	int ret;
-	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -5153,28 +5151,19 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
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
 
-	err = btrfs_commit_transaction(trans);
-	if (err && !ret)
-		ret = err;
-out:
 	kfree(sa);
 	up_write(&fs_info->subvol_sem);
 drop_write:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c25dc47210a3..67e4c7a1cc2b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -875,8 +875,7 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_quota_enable(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info)
+int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -886,6 +885,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_qgroup *qgroup = NULL;
+	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 	int slot;
 
@@ -893,9 +893,24 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	if (fs_info->quota_root)
 		goto out;
 
+	/*
+	 * 1 for quota root item
+	 * 1 for BTRFS_QGROUP_STATUS item
+	 *
+	 * Yet we also need 2*n items for a QGROUP_INFO/QGROUP_LIMIT items
+	 * per subvolume. However those are not currently reserved since it
+	 * would be a lot of overkill.
+	 */
+	trans = btrfs_start_transaction(tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
 	if (!fs_info->qgroup_ulist) {
 		ret = -ENOMEM;
+		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 
@@ -906,12 +921,14 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 				       BTRFS_QUOTA_TREE_OBJECTID);
 	if (IS_ERR(quota_root)) {
 		ret =  PTR_ERR(quota_root);
+		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
+		btrfs_abort_transaction(trans, ret);
 		goto out_free_root;
 	}
 
@@ -921,8 +938,10 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
 				      sizeof(*ptr));
-	if (ret)
+	if (ret) {
 		goto out_free_path;
+		btrfs_abort_transaction(trans, ret);
+	}
 
 	leaf = path->nodes[0];
 	ptr = btrfs_item_ptr(leaf, path->slots[0],
@@ -944,8 +963,10 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot_for_read(tree_root, &key, path, 1, 0);
 	if (ret > 0)
 		goto out_add_root;
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
+	}
 
 
 	while (1) {
@@ -956,18 +977,23 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		if (found_key.type == BTRFS_ROOT_REF_KEY) {
 			ret = add_qgroup_item(trans, quota_root,
 					      found_key.offset);
-			if (ret)
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
 				goto out_free_path;
+			}
 
 			qgroup = add_qgroup_rb(fs_info, found_key.offset);
 			if (IS_ERR(qgroup)) {
 				ret = PTR_ERR(qgroup);
+				btrfs_abort_transaction(trans, ret);
 				goto out_free_path;
 			}
 		}
 		ret = btrfs_next_item(tree_root, path);
-		if (ret < 0)
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, ret);
 			goto out_free_path;
+		}
 		if (ret)
 			break;
 	}
@@ -975,18 +1001,28 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 out_add_root:
 	btrfs_release_path(path);
 	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
+	}
 
 	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
 	if (IS_ERR(qgroup)) {
 		ret = PTR_ERR(qgroup);
+		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
 	}
 	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
+
+	ret = btrfs_commit_transaction(trans);
+	if (ret) {
+		trans = NULL;
+		goto out_free_path;
+	}
+
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (!ret) {
 	        qgroup_rescan_zero_tracking(fs_info);
@@ -1006,20 +1042,35 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	if (ret) {
 		ulist_free(fs_info->qgroup_ulist);
 		fs_info->qgroup_ulist = NULL;
+		if (trans)
+			btrfs_end_transaction(trans);
 	}
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
 
-int btrfs_quota_disable(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info)
+int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *quota_root;
+	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
 		goto out;
+
+	/*
+	 * 1 For the root item
+	 *
+	 * We should also reserve enough items for the quota tree deletion in
+	 * btrfs_clean_quota_tree but this is not done.
+	 */
+	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 	spin_lock(&fs_info->qgroup_lock);
@@ -1031,12 +1082,16 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	btrfs_free_qgroup_config(fs_info);
 
 	ret = btrfs_clean_quota_tree(trans, quota_root);
-	if (ret)
-		goto out;
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto end_trans;
+	}
 
 	ret = btrfs_del_root(trans, fs_info, &quota_root->root_key);
-	if (ret)
-		goto out;
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto end_trans;
+	}
 
 	list_del(&quota_root->dirty_list);
 
@@ -1048,6 +1103,9 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	free_extent_buffer(quota_root->node);
 	free_extent_buffer(quota_root->commit_root);
 	kfree(quota_root);
+
+end_trans:
+	ret = btrfs_end_transaction(trans);
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
@@ -3070,7 +3128,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len);
 	extent_changeset_init(&changeset);
-	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
+	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
 		goto out;
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
-- 
2.7.4

