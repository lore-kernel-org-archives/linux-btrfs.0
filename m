Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21147 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752139AbbCWIKr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:47 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89gPH012359
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 09/11] btrfs: qgroup: Use oper->old/new_roots to update refcnt.
Date: Mon, 23 Mar 2015 16:08:35 +0800
Message-ID: <1427098117-25152-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) Use accurate old/new_roots in btrfs_qgroup_operation.
Old implement uses find_all_roots() to get a roots referring to given
bytenr.
But the problem is, at the timing of btrfs_delayed_qgroup_accounting(),
it's too late and we can only get final result of all delayed_ref
operations.

Thanks to previous patches, we have old_roots which restored the correct
roots got from calling find_all_roots() before we write backref to
extent tree and skip the current running ref_node.
And new_roots is got from calling find_all_roots() just after we write
backref to extent tree.

So we have accurate results than the old implement.

2) Use same routine to handle old/new_refcnt.
The old routine uses different routine for old/new_refcnt update, which
is a duplication of codes and takes extra time to maintain.

3) No more special case for rescan.
Old implement adds some special case for rescan, but now we don't need
them anymore.
Just set old_roots to NULL should allow rescan to get correct result.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 210 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 115 insertions(+), 95 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4ad4106..16240e6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -84,7 +84,7 @@ struct btrfs_qgroup {
 
 	/*
 	 * temp variables for accounting operations
-	 * Refer to qgroup_shared_accouting() for details.
+	 * Refer to qgroup_shared_accounting() for details.
 	 */
 	u64 old_refcnt;
 	u64 new_refcnt;
@@ -1501,10 +1501,69 @@ out:
 	return ret;
 }
 
+
+#define UPDATE_NEW	0
+#define UPDATE_OLD	1
 /*
  * Walk all of the roots that pointed to our bytenr and adjust their refcnts as
  * properly.
  */
+static int qgroup_update_refcnt(struct btrfs_fs_info *fs_info,
+				struct ulist *roots,
+				struct ulist *tmp,
+				struct ulist *qgroups,
+				u64 seq, int update_old)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct ulist_node *tmp_unode;
+	struct ulist_iterator tmp_uiter;
+	struct btrfs_qgroup *qg;
+	int ret;
+
+	if (!roots)
+		return 0;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(roots, &uiter))) {
+		qg = find_qgroup_rb(fs_info, unode->val);
+		if (!qg)
+			continue;
+
+		ulist_reinit(tmp);
+		ret = ulist_add(qgroups, qg->qgroupid, ptr_to_u64(qg),
+				GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+		ret = ulist_add(tmp, qg->qgroupid, ptr_to_u64(qg), GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+		ULIST_ITER_INIT(&tmp_uiter);
+		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
+			struct btrfs_qgroup_list *glist;
+
+			qg = u64_to_ptr(tmp_unode->aux);
+			if (update_old)
+				btrfs_qgroup_update_old_refcnt(qg, seq, 1);
+			else
+				btrfs_qgroup_update_new_refcnt(qg, seq, 1);
+			list_for_each_entry(glist, &qg->groups, next_group) {
+				ret = ulist_add(qgroups, glist->group->qgroupid,
+						ptr_to_u64(glist->group),
+						GFP_ATOMIC);
+				if (ret < 0)
+					return ret;
+				ret = ulist_add(tmp, glist->group->qgroupid,
+						ptr_to_u64(glist->group),
+						GFP_ATOMIC);
+				if (ret < 0)
+					return ret;
+			}
+		}
+	}
+	return 0;
+}
+
 static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
 				  u64 root_to_skip, struct ulist *tmp,
 				  struct ulist *roots, struct ulist *qgroups,
@@ -1725,14 +1784,20 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
  * This adjusts the counters for all referenced qgroups if need be.
  */
 static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
-				  u64 root_to_skip, u64 num_bytes,
-				  struct ulist *qgroups, u64 seq,
-				  int old_roots, int new_roots, int rescan)
+				  struct ulist *qgroups,
+				  struct ulist *old_root_list,
+				  struct ulist *new_root_list,
+				  u64 num_bytes, u64 seq)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct btrfs_qgroup *qg;
 	u64 cur_new_count, cur_old_count;
+	u64 old_roots = 0;
+	u64 new_roots = new_root_list->nnodes;
+
+	if (old_root_list)
+		old_roots = old_root_list->nnodes;
 
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(qgroups, &uiter))) {
@@ -1836,19 +1901,12 @@ static int check_existing_refs(struct btrfs_trans_handle *trans,
  * jack this sequence up by the number of roots we found each time in order to
  * make sure we don't have any overlap.
  *
- * 2) We first search all the roots that reference the area _except_ the root
- * we're acting on currently.  This makes up the old_refcnt of all the qgroups
- * before.
- *
- * 3) We walk all of the qgroups referenced by the root we are currently acting
- * on, and will either adjust old_refcnt in the case of a removal or the
- * new_refcnt in the case of an addition.
- *
- * 4) Finally we walk all the qgroups that are referenced by this range
- * including the root we are acting on currently.  We will adjust the counters
- * based on the number of roots we had and will have after this operation.
+ * 2) We have oper->old_roots and oper->new_roots, indicating the roots
+ * referring the extent before/after the delayed operation.
+ * So just update old/new_refcnt if one root is in old/new_roots.
  *
- * Take this example as an illustration
+ * 3) When updating one root in old/new_roots, we also needs to update all its
+ * parents.
  *
  *			[qgroup 1/0]
  *		     /         |          \
@@ -1856,36 +1914,41 @@ static int check_existing_refs(struct btrfs_trans_handle *trans,
  *		   \          |            /
  *		  [	   extent	    ]
  *
- * Say we are adding a reference that is covered by qg 0/0.  The first step
- * would give a refcnt of 1 to qg 0/1 and 0/2 and a refcnt of 2 to qg 1/0 with
- * old_roots being 2.  Because it is adding new_roots will be 1.  We then go
- * through qg 0/0 which will get the new_refcnt set to 1 and add 1 to qg 1/0's
- * new_refcnt, bringing it to 3.  We then walk through all of the qgroups, we
- * notice that the old refcnt for qg 0/0 < the new refcnt, so we added a
- * reference and thus must add the size to the referenced bytes.  Everything
- * else is the same so nothing else changes.
+ * Say we are adding a reference that is newly covered by qg 0/0.
+ * What we have in oper->old/new_roots:
+ * oper->old_roots = {0/1, 0/2}, nnodes = 2
+ * oper->new_roots = {0/0, 0/1, 0/2}, nnodes = 3
+ *
+ * Old refcnt update:
+ * 1) qg 0/1: 0->1, qg 1/0: 0->1  2)qg 0/2: 0->1, qg 1/0: 1->2
+ *
+ * New refcnt update:
+ * 1) qg 0/0: 0->1, qg 1/0: 0->1  2)qg 0/1: 0->1, qg 1/0: 1->2
+ * 3) qg 0/2: 0->1, qg 1/0: 2->3
+ *
+ * Accounting update:
+ * 1) qg 0/0, old 0, new 1, old_roots 2, new_roots 3.
+ * new > old, add rfer. new < new_roots, no add excl.
+ *
+ * 2) qg 0/1 ~ 0/2 , old 1, new 1, old_roots 2, new_roots 3.
+ * new == old, no add rfer. new < new_roots, no add excl.
+ *
+ * 3) qg 1/0, old 2, new 3, old_roots 2, new_roots 3.
+ * new > old, add rfer. new == new_roots, add excl
+ *
+ * See full judgements in qgroup_adjust_counters().
  */
 static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 				    struct btrfs_fs_info *fs_info,
 				    struct btrfs_qgroup_operation *oper)
 {
-	struct ulist *roots = NULL;
 	struct ulist *qgroups, *tmp;
 	struct btrfs_qgroup *qgroup;
-	struct seq_list elem = {};
 	u64 seq;
-	int old_roots = 0;
-	int new_roots = 0;
+	u64 old_roots = 0;
+	u64 new_roots = oper->new_roots->nnodes;
 	int ret = 0;
 
-	if (oper->elem.seq) {
-		ret = check_existing_refs(trans, fs_info, oper);
-		if (ret < 0)
-			return ret;
-		if (ret)
-			return 0;
-	}
-
 	qgroups = ulist_alloc(GFP_NOFS);
 	if (!qgroups)
 		return -ENOMEM;
@@ -1896,15 +1959,6 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	btrfs_get_tree_mod_seq(fs_info, &elem);
-	ret = btrfs_find_all_roots(trans, fs_info, NULL, oper->bytenr, elem.seq,
-				   &roots, 0);
-	btrfs_put_tree_mod_seq(fs_info, &elem);
-	if (ret < 0) {
-		ulist_free(qgroups);
-		ulist_free(tmp);
-		return ret;
-	}
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup = find_qgroup_rb(fs_info, oper->ref_root);
 	if (!qgroup)
@@ -1912,71 +1966,38 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 	seq = fs_info->qgroup_seq;
 
 	/*
-	 * So roots is the list of all the roots currently pointing at the
-	 * bytenr, including the ref we are adding if we are adding, or not if
-	 * we are removing a ref.  So we pass in the ref_root to skip that root
-	 * in our calculations.  We set old_refnct and new_refcnt cause who the
-	 * hell knows what everything looked like before, and it doesn't matter
-	 * except...
-	 */
-	ret = qgroup_calc_old_refcnt(fs_info, oper->ref_root, tmp, roots, qgroups,
-				     seq, &old_roots, 0);
-	if (ret < 0)
-		goto out;
-
-	/*
-	 * Now adjust the refcounts of the qgroups that care about this
-	 * reference, either the old_count in the case of removal or new_count
-	 * in the case of an addition.
+	 * Update old refcnts, since we have oper->old_roots, just use them
 	 */
-	ret = qgroup_calc_new_refcnt(fs_info, oper, qgroup, tmp, qgroups,
-				     seq);
+	ret = qgroup_update_refcnt(fs_info, oper->old_roots, tmp, qgroups, seq,
+				   UPDATE_OLD);
 	if (ret < 0)
 		goto out;
 
 	/*
-	 * ...in the case of removals.  If we had a removal before we got around
-	 * to processing this operation then we need to find that guy and count
-	 * his references as if they really existed so we don't end up screwing
-	 * up the exclusive counts.  Then whenever we go to process the delete
-	 * everything will be grand and we can account for whatever exclusive
-	 * changes need to be made there.  We also have to pass in old_roots so
-	 * we have an accurate count of the roots as it pertains to this
-	 * operations view of the world.
+	 * Update new refcnts, since we have oper->new_roots, just use them
 	 */
-	ret = qgroup_account_deleted_refs(fs_info, oper, tmp, qgroups, seq,
-					  &old_roots);
+	ret = qgroup_update_refcnt(fs_info, oper->new_roots, tmp, qgroups, seq,
+				   UPDATE_NEW);
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * We are adding our root, need to adjust up the number of roots,
-	 * otherwise old_roots is the number of roots we want.
-	 */
-	if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED) {
-		new_roots = old_roots + 1;
-	} else {
-		new_roots = old_roots;
-		old_roots++;
-	}
-
+	if (oper->old_roots)
+		old_roots = oper->old_roots->nnodes;
 	/*
 	 * Bump qgroup_seq to avoid seq overlap
 	 * XXX: This makes qgroup_seq mismatch with oper->seq.
 	 */
-	fs_info->qgroup_seq += old_roots + 1;
-
+	fs_info->qgroup_seq += max(old_roots, new_roots) + 1;
 
 	/*
 	 * And now the magic happens, bless Arne for having a pretty elegant
 	 * solution for this.
 	 */
-	qgroup_adjust_counters(fs_info, oper->ref_root, oper->num_bytes,
-			       qgroups, seq, old_roots, new_roots, 0);
+	qgroup_adjust_counters(fs_info, qgroups, oper->old_roots,
+			       oper->new_roots, oper->num_bytes, seq);
 out:
 	spin_unlock(&fs_info->qgroup_lock);
 	ulist_free(qgroups);
-	ulist_free(roots);
 	ulist_free(tmp);
 	return ret;
 }
@@ -2559,7 +2580,6 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	struct seq_list tree_mod_seq_elem = {};
 	u64 num_bytes;
 	u64 seq;
-	int new_roots;
 	int slot;
 	int ret;
 
@@ -2618,17 +2638,17 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		seq = fs_info->qgroup_seq;
 		fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
 
-		new_roots = 0;
-		ret = qgroup_calc_old_refcnt(fs_info, 0, tmp, roots, qgroups,
-					     seq, &new_roots, 1);
+		/* For rescan, we only need to update new refcnt */
+		ret = qgroup_update_refcnt(fs_info, roots, tmp, qgroups, seq,
+					   UPDATE_NEW);
 		if (ret < 0) {
 			spin_unlock(&fs_info->qgroup_lock);
 			ulist_free(roots);
 			goto out;
 		}
 
-		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, qgroups,
-					     seq, 0, new_roots, 1);
+		ret = qgroup_adjust_counters(fs_info, qgroups, NULL, roots,
+					     num_bytes, seq);
 		if (ret < 0) {
 			spin_unlock(&fs_info->qgroup_lock);
 			ulist_free(roots);
-- 
2.3.3

