Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18694 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751532AbdBOCn0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 21:43:26 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fdmanana@gmail.com>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] btrfs: qgroup: Move half of the qgroup accounting time out of commit trans
Date: Wed, 15 Feb 2017 10:43:03 +0800
Message-ID: <20170215024303.26907-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just as Filipe pointed out, the most time consuming parts of qgroup are
btrfs_qgroup_account_extents() and
btrfs_qgroup_prepare_account_extents().
Which both call btrfs_find_all_roots() to get old_roots and new_roots
ulist.

What makes things worse is, we're calling that expensive
btrfs_find_all_roots() at transaction committing time with
TRANS_STATE_COMMIT_DOING, which will blocks all incoming transaction.

Such behavior is necessary for @new_roots search as current
btrfs_find_all_roots() can't do it correctly so we do call it just
before switch commit roots.

However for @old_roots search, it's not necessary as such search is
based on commit_root, so it will always be correct and we can move it
out of transaction committing.

This patch moves the @old_roots search part out of
commit_transaction(), so in theory we can half the time qgroup time
consumption at commit_transaction().

But please note that, this won't speedup qgroup overall, the total time
consumption is still the same, just reduce the performance stall.

Cc: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Update commit message to make it more clear.
  Don't call btrfs_find_all_roots() before insert qgroup extent record,
  so we can avoid wasting CPU for already inserted qgroup extent record.

PS:
If and only if we have fixed and proved btrfs_find_all_roots() can
get correct result with current root, then we can move all
expensive btrfs_find_all_roots() out of transaction committing.

However I strongly doubt if it's possible with current delayed ref,
and without such prove, move btrfs_find_all_roots() for @new_roots
out of transaction committing will just screw up qgroup accounting.

---
 fs/btrfs/delayed-ref.c | 20 ++++++++++++++++----
 fs/btrfs/qgroup.c      | 33 +++++++++++++++++++++++++++++----
 fs/btrfs/qgroup.h      | 33 ++++++++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ef724a5fc30e..0ee927ef5a71 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -550,13 +550,14 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		     struct btrfs_delayed_ref_node *ref,
 		     struct btrfs_qgroup_extent_record *qrecord,
 		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
-		     int action, int is_data)
+		     int action, int is_data, int *qrecord_inserted_ret)
 {
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_head *head_ref = NULL;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int count_mod = 1;
 	int must_insert_reserved = 0;
+	int qrecord_inserted = 0;
 
 	/* If reserved is provided, it must be a data extent. */
 	BUG_ON(!is_data && reserved);
@@ -623,6 +624,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		if(btrfs_qgroup_trace_extent_nolock(fs_info,
 					delayed_refs, qrecord))
 			kfree(qrecord);
+		else
+			qrecord_inserted = 1;
 	}
 
 	spin_lock_init(&head_ref->lock);
@@ -650,6 +653,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		atomic_inc(&delayed_refs->num_entries);
 		trans->delayed_ref_updates++;
 	}
+	if (qrecord_inserted_ret)
+		*qrecord_inserted_ret = qrecord_inserted;
 	return head_ref;
 }
 
@@ -779,6 +784,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
+	int qrecord_inserted;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
@@ -806,12 +812,15 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 * the spin lock
 	 */
 	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
-					bytenr, num_bytes, 0, 0, action, 0);
+					bytenr, num_bytes, 0, 0, action, 0,
+					&qrecord_inserted);
 
 	add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 			     num_bytes, parent, ref_root, level, action);
 	spin_unlock(&delayed_refs->lock);
 
+	if (qrecord_inserted)
+		return btrfs_qgroup_trace_extent_post(fs_info, record);
 	return 0;
 
 free_head_ref:
@@ -836,6 +845,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
+	int qrecord_inserted;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
@@ -870,13 +880,15 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 */
 	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
 					bytenr, num_bytes, ref_root, reserved,
-					action, 1);
+					action, 1, &qrecord_inserted);
 
 	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action);
 	spin_unlock(&delayed_refs->lock);
 
+	if (qrecord_inserted)
+		return btrfs_qgroup_trace_extent_post(fs_info, record);
 	return 0;
 }
 
@@ -899,7 +911,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 
 	add_delayed_ref_head(fs_info, trans, &head_ref->node, NULL, bytenr,
 			     num_bytes, 0, 0, BTRFS_UPDATE_DELAYED_HEAD,
-			     extent_op->is_data);
+			     extent_op->is_data, NULL);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 662821f1252c..979e0e8a3d90 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1446,8 +1446,9 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 	while (node) {
 		record = rb_entry(node, struct btrfs_qgroup_extent_record,
 				  node);
-		ret = btrfs_find_all_roots(NULL, fs_info, record->bytenr, 0,
-					   &record->old_roots);
+		if (WARN_ON(!record->old_roots))
+			ret = btrfs_find_all_roots(NULL, fs_info,
+					record->bytenr, 0, &record->old_roots);
 		if (ret < 0)
 			break;
 		if (qgroup_to_skip)
@@ -1486,6 +1487,28 @@ int btrfs_qgroup_trace_extent_nolock(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
+				   struct btrfs_qgroup_extent_record *qrecord)
+{
+	struct ulist *old_root;
+	u64 bytenr = qrecord->bytenr;
+	int ret;
+
+	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Here we don't need to get the lock of
+	 * trans->transaction->delayed_refs, since inserted qrecord won't
+	 * be deleted, only qrecord->node may be modified (new qrecord insert)
+	 *
+	 * So modifying qrecord->old_roots is safe here
+	 */
+	qrecord->old_roots = old_root;
+	return 0;
+}
+
 int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
 		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
 		gfp_t gfp_flag)
@@ -1511,9 +1534,11 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
 	spin_lock(&delayed_refs->lock);
 	ret = btrfs_qgroup_trace_extent_nolock(fs_info, delayed_refs, record);
 	spin_unlock(&delayed_refs->lock);
-	if (ret > 0)
+	if (ret > 0) {
 		kfree(record);
-	return 0;
+		return 0;
+	}
+	return btrfs_qgroup_trace_extent_post(fs_info, record);
 }
 
 int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 416ae8e1d23c..0b9da45f7d72 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -94,9 +94,10 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
 /*
  * Inform qgroup to trace one dirty extent, its info is recorded in @record.
- * So qgroup can account it at commit trans time.
+ * So qgroup can account it at transaction committing time.
  *
- * No lock version, caller must acquire delayed ref lock and allocate memory.
+ * No lock version, caller must acquire delayed ref lock and allocated memory,
+ * then call btrfs_qgroup_trace_extent_post() after exiting lock context.
  *
  * Return 0 for success insert
  * Return >0 for existing record, caller can free @record safely.
@@ -108,11 +109,37 @@ int btrfs_qgroup_trace_extent_nolock(
 		struct btrfs_qgroup_extent_record *record);
 
 /*
+ * Post handler after qgroup_trace_extent_nolock().
+ *
+ * NOTE: Current qgroup does the expensive backref walk at transaction
+ * committing time with TRANS_STATE_COMMIT_DOING, this blocks incoming
+ * new transaction.
+ * This is designed to allow btrfs_find_all_roots() to get correct new_roots
+ * result.
+ *
+ * However for old_roots there is no need to do backref walk at that time,
+ * since we search commit roots to walk backref and result will always be
+ * correct.
+ *
+ * Due to the nature of no lock version, we can't do backref there.
+ * So we must call btrfs_qgroup_trace_extent_post() after exiting
+ * spinlock context.
+ *
+ * TODO: If we can fix and prove btrfs_find_all_roots() can get correct result
+ * using current root, then we can move all expensive backref walk out of
+ * transaction committing, but not now as qgroup accounting will be wrong again.
+ */
+int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
+				   struct btrfs_qgroup_extent_record *qrecord);
+
+/*
  * Inform qgroup to trace one dirty extent, specified by @bytenr and
  * @num_bytes.
  * So qgroup can account it at commit trans time.
  *
- * Better encapsulated version.
+ * Better encapsulated version, with memory allocation and backref walk for
+ * commit roots.
+ * So this can sleep.
  *
  * Return 0 if the operation is done.
  * Return <0 for error, like memory allocation failure or invalid parameter
-- 
2.11.1



