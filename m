Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbcDNFlL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 01:41:11 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 6EA454056406
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 13:40:41 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: qgroup: Fix qgroup accounting when creating snapshot
Date: Thu, 14 Apr 2016 13:38:40 +0800
Message-Id: <1460612320-19199-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs qgroup design implies a requirement that after calling
btrfs_qgroup_account_extents() there must be a commit root switch.

Normally this is OK, as btrfs_qgroup_accounting_extents() is only called
inside btrfs_commit_transaction() just be commit_cowonly_roots().

However there is a exception at create_pending_snapshot(), which will
call btrfs_qgroup_account_extents() but no any commit root switch.

In case of creating a snapshot whose parent root is itself (create a
snapshot of fs tree), it will corrupt qgroup by the following trace:
(skipped unrelated data)
======
btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
======

The problem here is in first qgroup_account_extent(), the
nr_new_roots of the extent is 1, which means its reference got
increased, and qgroup increased its rfer and excl.

But at second qgroup_account_extent(), its reference got decreased, but
between these two qgroup_account_extent(), there is no switch roots.
This leads to the same nr_old_roots, and this extent just got ignored by
qgroup, which means this extent is wrongly accounted.

Fix it by call commit_cowonly_roots() after qgroup_account_extent() in
create_pending_snapshot(), with needed preparation.

Reported-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Fix a soft lockup caused by missing switch_commit_root() call.
  Fix a warning caused by dirty-but-not-committed root.
v3:
  Fix a difference behavior that btrfs qgroup will start accounting
  dropped roots if we are creating snapshots.
  Other than always account them in next transaction.
---
 fs/btrfs/transaction.c | 122 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 87 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 43885e5..5ba0d9a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -126,7 +126,8 @@ static void clear_btree_io_tree(struct extent_io_tree *tree)
 }
 
 static noinline void switch_commit_roots(struct btrfs_transaction *trans,
-					 struct btrfs_fs_info *fs_info)
+					 struct btrfs_fs_info *fs_info,
+					 int free_dropped_roots)
 {
 	struct btrfs_root *root, *tmp;
 
@@ -142,16 +143,18 @@ static noinline void switch_commit_roots(struct btrfs_transaction *trans,
 	}
 
 	/* We can free old roots now. */
-	spin_lock(&trans->dropped_roots_lock);
-	while (!list_empty(&trans->dropped_roots)) {
-		root = list_first_entry(&trans->dropped_roots,
-					struct btrfs_root, root_list);
-		list_del_init(&root->root_list);
-		spin_unlock(&trans->dropped_roots_lock);
-		btrfs_drop_and_free_fs_root(fs_info, root);
+	if (free_dropped_roots) {
 		spin_lock(&trans->dropped_roots_lock);
+		while (!list_empty(&trans->dropped_roots)) {
+			root = list_first_entry(&trans->dropped_roots,
+						struct btrfs_root, root_list);
+			list_del_init(&root->root_list);
+			spin_unlock(&trans->dropped_roots_lock);
+			btrfs_drop_and_free_fs_root(fs_info, root);
+			spin_lock(&trans->dropped_roots_lock);
+		}
+		spin_unlock(&trans->dropped_roots_lock);
 	}
-	spin_unlock(&trans->dropped_roots_lock);
 	up_write(&fs_info->commit_root_sem);
 }
 
@@ -311,12 +314,13 @@ loop:
  * when the transaction commits
  */
 static int record_root_in_trans(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root)
+			       struct btrfs_root *root,
+			       int force)
 {
-	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
-	    root->last_trans < trans->transid) {
+	if ((test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
+	    root->last_trans < trans->transid) || force) {
 		WARN_ON(root == root->fs_info->extent_root);
-		WARN_ON(root->commit_root != root->node);
+		WARN_ON(root->commit_root != root->node && !force);
 
 		/*
 		 * see below for IN_TRANS_SETUP usage rules
@@ -331,7 +335,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		smp_wmb();
 
 		spin_lock(&root->fs_info->fs_roots_radix_lock);
-		if (root->last_trans == trans->transid) {
+		if (root->last_trans == trans->transid && !force) {
 			spin_unlock(&root->fs_info->fs_roots_radix_lock);
 			return 0;
 		}
@@ -402,7 +406,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 		return 0;
 
 	mutex_lock(&root->fs_info->reloc_mutex);
-	record_root_in_trans(trans, root);
+	record_root_in_trans(trans, root, 0);
 	mutex_unlock(&root->fs_info->reloc_mutex);
 
 	return 0;
@@ -1383,7 +1387,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	dentry = pending->dentry;
 	parent_inode = pending->dir;
 	parent_root = BTRFS_I(parent_inode)->root;
-	record_root_in_trans(trans, parent_root);
+	record_root_in_trans(trans, parent_root, 0);
 
 	cur_time = current_fs_time(parent_inode->i_sb);
 
@@ -1420,7 +1424,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	record_root_in_trans(trans, root);
+	record_root_in_trans(trans, root, 0);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 	btrfs_check_and_init_root_item(new_root_item);
@@ -1516,6 +1520,65 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
+	/*
+	 * Account qgroups before insert the dir item
+	 * As such dir item insert will modify parent_root, which could be
+	 * src root. If we don't do it now, wrong accounting may be inherited
+	 * to snapshot qgroup.
+	 *
+	 * For reason locking tree_log_mutex, see btrfs_commit_transaction()
+	 * comment
+	 */
+	mutex_lock(&root->fs_info->tree_log_mutex);
+
+	ret = commit_fs_roots(trans, root);
+	if (ret) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+
+	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
+	if (ret < 0) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+	ret = btrfs_qgroup_account_extents(trans, root->fs_info);
+	if (ret < 0) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+	/*
+	 * Now qgroup are all updated, we can inherit it to new qgroups
+	 */
+	ret = btrfs_qgroup_inherit(trans, fs_info,
+				   root->root_key.objectid,
+				   objectid, pending->inherit);
+	if (ret < 0) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+	/*
+	 * qgroup_account_extents() must be followed by a
+	 * switch_commit_roots(), or next qgroup_account_extents() will
+	 * be corrupted
+	 */
+	ret = commit_cowonly_roots(trans, root);
+	if (ret) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+	/*
+	 * Just like in btrfs_commit_transaction(), we need to
+	 * switch_commit_roots().
+	 * However this time we don't need to do a full one,
+	 * excluding tree root and chunk root should be OK.
+	 *
+	 * Also we don't want to free dropped roots here.
+	 * Only the final switch_commit_roots() will free them
+	 */
+	switch_commit_roots(trans->transaction, root->fs_info, 0);
+	mutex_unlock(&root->fs_info->tree_log_mutex);
+
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				    dentry->d_name.name, dentry->d_name.len,
 				    parent_inode, &key,
@@ -1527,6 +1590,12 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
+	/*
+	 * Force parent root to be updated, as we recorded it before its
+	 * last_trans == cur_transid
+	 */
+	record_root_in_trans(trans, parent_root, 1);
+
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
 	parent_inode->i_mtime = parent_inode->i_ctime =
@@ -1559,23 +1628,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	/*
-	 * account qgroup counters before qgroup_inherit()
-	 */
-	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
-	if (ret)
-		goto fail;
-	ret = btrfs_qgroup_account_extents(trans, fs_info);
-	if (ret)
-		goto fail;
-	ret = btrfs_qgroup_inherit(trans, fs_info,
-				   root->root_key.objectid,
-				   objectid, pending->inherit);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		goto fail;
-	}
-
 fail:
 	pending->error = ret;
 dir_item_existed:
@@ -2115,7 +2167,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	list_add_tail(&root->fs_info->chunk_root->dirty_list,
 		      &cur_trans->switch_commits);
 
-	switch_commit_roots(cur_trans, root->fs_info);
+	switch_commit_roots(cur_trans, root->fs_info, 1);
 
 	assert_qgroups_uptodate(trans);
 	ASSERT(list_empty(&cur_trans->dirty_bgs));
-- 
2.8.0



