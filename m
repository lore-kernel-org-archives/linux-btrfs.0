Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30643 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbcDOJKy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 05:10:54 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, mfasheh@suse.de, fdmanana@suse.com
Subject: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating snapshot
Date: Fri, 15 Apr 2016 17:08:22 +0800
Message-Id: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
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
  Fix a bug which will cause qgroup accounting for dropping snapshot
  wrong
v4:
  Fix a bug caused by non-cowed btree modification.

To Filipe:
  I'm sorry I didn't wait for your reply on the dropped roots.
  I reverted back the version where we deleted dropped roots in
  switch_commit_roots().

  As I think as long as we called btrfs_qgroup_prepare_account_extents()
  and btrfs_qgroup_account_extents(), it should have already accounted
  extents for dropped roots, and then we are OK to drop them.

  It would be very nice if you could point out what I missed.
  Thanks
  Qu
---
 fs/btrfs/transaction.c | 117 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 93 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 43885e5..92f8193 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -311,10 +311,11 @@ loop:
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
 		WARN_ON(root->commit_root != root->node);
 
@@ -331,7 +332,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		smp_wmb();
 
 		spin_lock(&root->fs_info->fs_roots_radix_lock);
-		if (root->last_trans == trans->transid) {
+		if (root->last_trans == trans->transid && !force) {
 			spin_unlock(&root->fs_info->fs_roots_radix_lock);
 			return 0;
 		}
@@ -402,7 +403,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 		return 0;
 
 	mutex_lock(&root->fs_info->reloc_mutex);
-	record_root_in_trans(trans, root);
+	record_root_in_trans(trans, root, 0);
 	mutex_unlock(&root->fs_info->reloc_mutex);
 
 	return 0;
@@ -1311,6 +1312,80 @@ int btrfs_defrag_root(struct btrfs_root *root)
 }
 
 /*
+ * Do all special snapshot related qgroup dirty hack.
+ *
+ * Will do all needed qgroup inherit and dirty hack like switch commit
+ * roots inside one transaction and write all btree into disk, to make
+ * qgroup works.
+ */
+static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *src,
+				   struct btrfs_root *parent,
+				   struct btrfs_qgroup_inherit *inherit,
+				   u64 dst_objectid)
+{
+	struct btrfs_fs_info *fs_info = src->fs_info;
+	int ret;
+
+	/*
+	 * We are going to commit transaction, see btrfs_commit_transaction()
+	 * comment for reason locking tree_log_mutex
+	 */
+	mutex_lock(&fs_info->tree_log_mutex);
+
+	ret = commit_fs_roots(trans, src);
+	if (ret)
+		goto out;
+	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
+	if (ret < 0)
+		goto out;
+	ret = btrfs_qgroup_account_extents(trans, fs_info);
+	if (ret < 0)
+		goto out;
+
+	/* Now qgroup are all updated, we can inherit it to new qgroups */
+	ret = btrfs_qgroup_inherit(trans, fs_info,
+				   src->root_key.objectid, dst_objectid,
+				   inherit);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Now we do a simplified commit transaction, which will:
+	 * 1) commit all subvolume and extent tree
+	 *    To ensure all subvolume and extent tree have a valid
+	 *    commit_root to accounting later insert_dir_item()
+	 * 2) write all btree blocks onto disk
+	 *    This is to make sure later btree modification will be cowed
+	 *    Or commit_root can be populated and cause wrong qgroup numbers
+	 * In this simplified commit, we don't really care about other trees
+	 * like chunk and root tree, as they won't affect qgroup.
+	 * And we don't write super to avoid half committed status.
+	 */
+	ret = commit_cowonly_roots(trans, src);
+	if (ret)
+		goto out;
+	switch_commit_roots(trans->transaction, fs_info);
+	ret = btrfs_write_and_wait_transaction(trans, src);
+	if (ret)
+		btrfs_std_error(fs_info, ret,
+			"Error while writing out transaction for qgroup");
+
+out:
+	mutex_unlock(&fs_info->tree_log_mutex);
+
+	/*
+	 * Force parent root to be updated, as we recorded it before so its
+	 * last_trans == cur_transid.
+	 * Or it won't be committed again onto disk after later
+	 * insert_dir_item()
+	 */
+	if (!ret)
+		record_root_in_trans(trans, parent, 1);
+	return ret;
+}
+
+/*
  * new snapshots need to be created at a very specific time in the
  * transaction commit.  This does the actual creation.
  *
@@ -1383,7 +1458,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	dentry = pending->dentry;
 	parent_inode = pending->dir;
 	parent_root = BTRFS_I(parent_inode)->root;
-	record_root_in_trans(trans, parent_root);
+	record_root_in_trans(trans, parent_root, 0);
 
 	cur_time = current_fs_time(parent_inode->i_sb);
 
@@ -1420,7 +1495,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	record_root_in_trans(trans, root);
+	record_root_in_trans(trans, root, 0);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 	btrfs_check_and_init_root_item(new_root_item);
@@ -1516,6 +1591,17 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
+	/*
+	 * Do special qgroup accounting for snapshot, as we do some qgroup
+	 * snapshot hack to do fast snapshot.
+	 * To co-operate with that hack, we do hack again.
+	 * Or snapshot will be greatly slowed down by a subtree qgroup rescan
+	 */
+	ret = qgroup_account_snapshot(trans, root, parent_root,
+				      pending->inherit, objectid);
+	if (ret < 0)
+		goto fail;
+
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				    dentry->d_name.name, dentry->d_name.len,
 				    parent_inode, &key,
@@ -1559,23 +1645,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
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
-- 
2.8.0



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kerne
