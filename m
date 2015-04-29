Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15215 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031499AbbD2Cb3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:29 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2UDCV018346
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 13/18] btrfs: qgroup: Switch to new extent-oriented qgroup mechanism.
Date: Wed, 29 Apr 2015 10:29:06 +0800
Message-ID: <1430274551-9277-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Switch from old ref_node based qgroup to extent based qgroup mechanism
for normal operations.

The new mechanism should hugely reduce the overhead of btrfs quota
system, and further more, the codes and logic should be more clean and
easier to maintain.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 fs/btrfs/extent-tree.c | 110 +++++--------------------------------------------
 fs/btrfs/transaction.c |  18 ++++++++
 2 files changed, 28 insertions(+), 100 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dd6e47e..70723dc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1997,26 +1997,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 					   bytenr, num_bytes, parent,
 					   root_objectid, owner, offset,
 					   refs_to_add, extent_op);
-	if ((ret < 0 && ret != -EAGAIN) || (!ret && no_quota))
+	if ((ret < 0 && ret != -EAGAIN) || !ret)
 		goto out;
-	/*
-	 * Ok we were able to insert an inline extent and it appears to be a new
-	 * reference, deal with the qgroup accounting.
-	 */
-	if (!ret && !no_quota) {
-		ASSERT(root->fs_info->quota_enabled);
-		leaf = path->nodes[0];
-		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		item = btrfs_item_ptr(leaf, path->slots[0],
-				      struct btrfs_extent_item);
-		if (btrfs_extent_refs(leaf, item) > (u64)refs_to_add)
-			type = BTRFS_QGROUP_OPER_ADD_SHARED;
-		btrfs_release_path(path);
-
-		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
-		goto out;
-	}
 
 	/*
 	 * Ok we had -EAGAIN which means we didn't have space to insert and
@@ -2036,13 +2018,6 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	if (!no_quota) {
-		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
-		if (ret)
-			goto out;
-	}
-
 	path->reada = 1;
 	path->leave_spinning = 1;
 	/* now insert the actual backref */
@@ -2808,9 +2783,6 @@ again:
 		goto again;
 	}
 out:
-	ret = btrfs_delayed_qgroup_accounting(trans, root->fs_info);
-	if (ret)
-		return ret;
 	assert_qgroups_uptodate(trans);
 	return 0;
 }
@@ -6070,18 +6042,6 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	/* Deal with the quota accounting */
-	if (!ret && last_ref && !no_quota) {
-		int mod_seq = 0;
-
-		if (owner_objectid >= BTRFS_FIRST_FREE_OBJECTID &&
-		    type == BTRFS_QGROUP_OPER_SUB_SHARED)
-			mod_seq = 1;
-
-		ret = btrfs_qgroup_record_ref(trans, info, root_objectid,
-					      bytenr, num_bytes, type,
-					      mod_seq);
-	}
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -7017,13 +6977,6 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	/* Always set parent to 0 here since its exclusive anyway. */
-	ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-				      ins->objectid, ins->offset,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
-	if (ret)
-		return ret;
-
 	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
@@ -7105,14 +7058,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	if (!no_quota) {
-		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      ins->objectid, num_bytes,
-					      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
-		if (ret)
-			return ret;
-	}
-
 	ret = update_block_group(trans, root, ins->objectid, root->nodesize,
 				 1);
 	if (ret) { /* -ENOENT, logic error */
@@ -7454,12 +7399,18 @@ reada:
 	wc->reada_slot = slot;
 }
 
+/*
+ * TODO: Modify related function to add related node/leaf to dirty_extent_root,
+ * for later qgroup accounting.
+ *
+ * Current, this function does nothing.
+ */
 static int account_leaf_items(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct extent_buffer *eb)
 {
 	int nr = btrfs_header_nritems(eb);
-	int i, extent_type, ret;
+	int i, extent_type;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
 	u64 bytenr, num_bytes;
@@ -7482,13 +7433,6 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
 			continue;
 
 		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
-
-		ret = btrfs_qgroup_record_ref(trans, root->fs_info,
-					      root->objectid,
-					      bytenr, num_bytes,
-					      BTRFS_QGROUP_OPER_SUB_SUBTREE, 0);
-		if (ret)
-			return ret;
 	}
 	return 0;
 }
@@ -7557,6 +7501,8 @@ static int adjust_slots_upwards(struct btrfs_root *root,
 
 /*
  * root_eb is the subtree root and is locked before this function is called.
+ * TODO: Modify this function to mark all (including complete shared node)
+ * to dirty_extent_root to allow it get accounted in qgroup.
  */
 static int account_shared_subtree(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
@@ -7630,16 +7576,6 @@ walk_down:
 			btrfs_tree_read_lock(eb);
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
-
-			ret = btrfs_qgroup_record_ref(trans, root->fs_info,
-						root->objectid,
-						child_bytenr,
-						root->nodesize,
-						BTRFS_QGROUP_OPER_SUB_SUBTREE,
-						0);
-			if (ret)
-				goto out;
-
 		}
 
 		if (level == 0) {
@@ -8232,24 +8168,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				goto out_end_trans;
 			}
 
-			/*
-			 * Qgroup update accounting is run from
-			 * delayed ref handling. This usually works
-			 * out because delayed refs are normally the
-			 * only way qgroup updates are added. However,
-			 * we may have added updates during our tree
-			 * walk so run qgroups here to make sure we
-			 * don't lose any updates.
-			 */
-			ret = btrfs_delayed_qgroup_accounting(trans,
-							      root->fs_info);
-			if (ret)
-				printk_ratelimited(KERN_ERR "BTRFS: Failure %d "
-						   "running qgroup updates "
-						   "during snapshot delete. "
-						   "Quota is out of sync, "
-						   "rescan required.\n", ret);
-
 			btrfs_end_transaction_throttle(trans, tree_root);
 			if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
 				pr_debug("BTRFS: drop snapshot early exit\n");
@@ -8303,14 +8221,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	}
 	root_dropped = true;
 out_end_trans:
-	ret = btrfs_delayed_qgroup_accounting(trans, tree_root->fs_info);
-	if (ret)
-		printk_ratelimited(KERN_ERR "BTRFS: Failure %d "
-				   "running qgroup updates "
-				   "during snapshot delete. "
-				   "Quota is out of sync, "
-				   "rescan required.\n", ret);
-
 	btrfs_end_transaction_throttle(trans, tree_root);
 out_free:
 	kfree(wc);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 871b405..eaea170 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1927,6 +1927,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto scrub_continue;
 	}
 
+	/* Reocrd old roots for later qgroup accounting */
+	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
+	if (ret) {
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto scrub_continue;
+	}
+
 	/*
 	 * make sure none of the code above managed to slip in a
 	 * delayed item
@@ -1968,6 +1975,17 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	btrfs_free_log_root_tree(trans, root->fs_info);
 
+	/*
+	 * Since fs roots are all committed, we can get a quite accurate
+	 * new_roots. So let's do quota accounting.
+	 */
+	ret = btrfs_qgroup_account_extents(trans, root->fs_info);
+	if (ret < 0) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto scrub_continue;
+	}
+
 	ret = commit_cowonly_roots(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
-- 
2.3.6

