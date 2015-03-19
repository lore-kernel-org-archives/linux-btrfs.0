Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47683 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbbCSGE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:57 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/7] Btrfs: qgroup: record and account ref for qgroup in different type.
Date: Thu, 19 Mar 2015 14:00:59 +0800
Message-ID: <1426744864-7031-7-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch make the qgroup account the information of data or metadata
by different infos.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c        |  48 +++++----
 fs/btrfs/qgroup.c             | 239 ++++++++++++++++++++++++++----------------
 fs/btrfs/qgroup.h             |  25 ++++-
 fs/btrfs/tests/qgroup-tests.c |  15 ++-
 fs/btrfs/transaction.c        |  11 +-
 5 files changed, 217 insertions(+), 121 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3f49316..cb27da6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -83,7 +83,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
 				struct btrfs_delayed_extent_op *extra_op,
-				int no_quota);
+				int no_quota, unsigned int quota_type);
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
 				    struct btrfs_extent_item *ei);
@@ -1971,7 +1971,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  u64 parent, u64 root_objectid,
 				  u64 owner, u64 offset, int refs_to_add,
 				  int no_quota,
-				  struct btrfs_delayed_extent_op *extent_op)
+				  struct btrfs_delayed_extent_op *extent_op,
+				  unsigned int quota_type)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
@@ -2013,7 +2014,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
+					      bytenr, num_bytes, type,
+					      quota_type, 0);
 		goto out;
 	}
 
@@ -2037,7 +2039,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 	if (!no_quota) {
 		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
+					      bytenr, num_bytes, type,
+					      quota_type, 0);
 		if (ret)
 			goto out;
 	}
@@ -2091,13 +2094,15 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 					     node->num_bytes, parent,
 					     ref_root, ref->objectid,
 					     ref->offset, node->ref_mod,
-					     node->no_quota, extent_op);
+					     node->no_quota, extent_op,
+					     BTRFS_QGROUP_REF_TYPE_DATA);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		ret = __btrfs_free_extent(trans, root, node->bytenr,
 					  node->num_bytes, parent,
 					  ref_root, ref->objectid,
 					  ref->offset, node->ref_mod,
-					  extent_op, node->no_quota);
+					  extent_op, node->no_quota,
+					  BTRFS_QGROUP_REF_TYPE_DATA);
 	} else {
 		BUG();
 	}
@@ -2258,12 +2263,12 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent, ref_root,
 					     ref->level, 0, 1, node->no_quota,
-					     extent_op);
+					     extent_op, BTRFS_QGROUP_REF_TYPE_METADATA);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		ret = __btrfs_free_extent(trans, root, node->bytenr,
 					  node->num_bytes, parent, ref_root,
 					  ref->level, 0, 1, extent_op,
-					  node->no_quota);
+					  node->no_quota, BTRFS_QGROUP_REF_TYPE_METADATA);
 	} else {
 		BUG();
 	}
@@ -3694,7 +3699,7 @@ commit_trans:
 					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
-	ret = btrfs_qgroup_reserve(root, write_bytes);
+	ret = btrfs_qgroup_reserve(root, write_bytes, BTRFS_QGROUP_REF_TYPE_DATA);
 	if (ret)
 		goto out;
 	data_sinfo->bytes_may_use += bytes;
@@ -4929,7 +4934,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (root->fs_info->quota_enabled) {
 		/* One for parent inode, two for dir entries */
 		num_bytes = 3 * root->nodesize;
-		ret = btrfs_qgroup_reserve(root, num_bytes);
+		ret = btrfs_qgroup_reserve(root, num_bytes, BTRFS_QGROUP_REF_TYPE_METADATA);
 		if (ret)
 			return ret;
 	} else {
@@ -4949,7 +4954,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 
 	if (ret) {
 		if (*qgroup_reserved)
-			btrfs_qgroup_free(root, *qgroup_reserved);
+			btrfs_qgroup_free(root, *qgroup_reserved, BTRFS_QGROUP_REF_TYPE_METADATA);
 	}
 
 	return ret;
@@ -5119,7 +5124,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	spin_unlock(&BTRFS_I(inode)->lock);
 
 	if (root->fs_info->quota_enabled) {
-		ret = btrfs_qgroup_reserve(root, nr_extents * root->nodesize);
+		ret = btrfs_qgroup_reserve(root, nr_extents * root->nodesize,
+					   BTRFS_QGROUP_REF_TYPE_METADATA);
 		if (ret)
 			goto out_fail;
 	}
@@ -5127,7 +5133,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
 	if (unlikely(ret)) {
 		if (root->fs_info->quota_enabled)
-			btrfs_qgroup_free(root, nr_extents * root->nodesize);
+			btrfs_qgroup_free(root, nr_extents * root->nodesize,
+					  BTRFS_QGROUP_REF_TYPE_METADATA);
 		goto out_fail;
 	}
 
@@ -5785,7 +5792,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
 				struct btrfs_delayed_extent_op *extent_op,
-				int no_quota)
+				int no_quota, unsigned int quota_type)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -6055,7 +6062,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_qgroup_record_ref(trans, info, root_objectid,
 					      bytenr, num_bytes, type,
-					      mod_seq);
+					      quota_type, mod_seq);
 	}
 out:
 	btrfs_free_path(path);
@@ -6996,7 +7003,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	/* Always set parent to 0 here since its exclusive anyway. */
 	ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
 				      ins->objectid, ins->offset,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+				      BTRFS_QGROUP_OPER_ADD_EXCL,
+				      BTRFS_QGROUP_REF_TYPE_DATA, 0);
 	if (ret)
 		return ret;
 
@@ -7084,7 +7092,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	if (!no_quota) {
 		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
 					      ins->objectid, num_bytes,
-					      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+					      BTRFS_QGROUP_OPER_ADD_EXCL,
+					      BTRFS_QGROUP_REF_TYPE_METADATA, 0);
 		if (ret)
 			return ret;
 	}
@@ -7462,7 +7471,8 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
 		ret = btrfs_qgroup_record_ref(trans, root->fs_info,
 					      root->objectid,
 					      bytenr, num_bytes,
-					      BTRFS_QGROUP_OPER_SUB_SUBTREE, 0);
+					      BTRFS_QGROUP_OPER_SUB_SUBTREE,
+					      BTRFS_QGROUP_REF_TYPE_METADATA, 0);
 		if (ret)
 			return ret;
 	}
@@ -7612,7 +7622,7 @@ walk_down:
 						child_bytenr,
 						root->nodesize,
 						BTRFS_QGROUP_OPER_SUB_SUBTREE,
-						0);
+						BTRFS_QGROUP_REF_TYPE_METADATA, 0);
 			if (ret)
 				goto out;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 34eb4f5..9dd2627 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1451,7 +1451,8 @@ static int insert_qgroup_oper(struct btrfs_fs_info *fs_info,
 int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info, u64 ref_root,
 			    u64 bytenr, u64 num_bytes,
-			    enum btrfs_qgroup_operation_type type, int mod_seq)
+			    enum btrfs_qgroup_operation_type type,
+			    unsigned int quota_type, int mod_seq)
 {
 	struct btrfs_qgroup_operation *oper;
 	int ret;
@@ -1467,6 +1468,7 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	oper->bytenr = bytenr;
 	oper->num_bytes = num_bytes;
 	oper->type = type;
+	oper->quota_type = quota_type;
 	oper->seq = atomic_inc_return(&fs_info->qgroup_op_seq);
 	INIT_LIST_HEAD(&oper->elem.list);
 	oper->elem.seq = 0;
@@ -1542,11 +1544,14 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		ASSERT(0);
 	}
 
-	/*
-	 * FIXME: use the data_info to store all information currently.
-	 * will seperate the information into data and metadata later.
-	 **/
-	info = &qgroup->data_info;
+	if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+		info = &qgroup->data_info;
+	} else {
+		if (oper->quota_type == BTRFS_QGROUP_REF_TYPE_DATA)
+			info = &qgroup->data_info;
+		else
+			info = &qgroup->metadata_info;
+	}
 
 	info->rfer += sign * oper->num_bytes;
 	info->rfer_cmpr += sign * oper->num_bytes;
@@ -1571,11 +1576,14 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		qgroup = u64_to_ptr(unode->aux);
-		/*
-		 * FIXME: use the data_info to store all information currently.
-		 * will seperate the information into data and metadata later.
-		 **/
-		info = &qgroup->data_info;
+		if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+			info = &qgroup->data_info;
+		} else {
+			if (oper->quota_type == BTRFS_QGROUP_REF_TYPE_DATA)
+				info = &qgroup->data_info;
+			else
+				info = &qgroup->metadata_info;
+		}
 		info->rfer += sign * oper->num_bytes;
 		info->rfer_cmpr += sign * oper->num_bytes;
 		WARN_ON(sign < 0 && info->excl < oper->num_bytes);
@@ -1842,13 +1850,14 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
  */
 static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 				  u64 root_to_skip, u64 num_bytes,
-				  struct ulist *qgroups, u64 seq,
-				  int old_roots, int new_roots, int rescan)
+				  u8 quota_type, struct ulist *qgroups,
+				  u64 seq, int old_roots, int new_roots,
+				  int rescan)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct btrfs_qgroup *qg;
-	struct btrfs_qgroup_info *data_info;
+	struct btrfs_qgroup_info *info;
 	u64 cur_new_count, cur_old_count;
 
 	ULIST_ITER_INIT(&uiter);
@@ -1857,14 +1866,21 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 
 		qg = u64_to_ptr(unode->aux);
 
-		data_info = &qg->data_info;
+		if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+			info = &qg->data_info;
+		} else {
+			if (quota_type == BTRFS_QGROUP_REF_TYPE_DATA)
+				info = &qg->data_info;
+			else
+				info = &qg->metadata_info;
+		}
 		/*
 		 * Wasn't referenced before but is now, add to the reference
 		 * counters.
 		 */
 		if (qg->old_refcnt <= seq && qg->new_refcnt > seq) {
-			data_info->rfer += num_bytes;
-			data_info->rfer_cmpr += num_bytes;
+			info->rfer += num_bytes;
+			info->rfer_cmpr += num_bytes;
 			dirty = true;
 		}
 
@@ -1873,8 +1889,8 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		 * reference counters.
 		 */
 		if (qg->old_refcnt > seq && qg->new_refcnt <= seq) {
-			data_info->rfer -= num_bytes;
-			data_info->rfer_cmpr -= num_bytes;
+			info->rfer -= num_bytes;
+			info->rfer_cmpr -= num_bytes;
 			dirty = true;
 		}
 
@@ -1895,13 +1911,8 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		if (old_roots && cur_old_count == old_roots &&
 		    (cur_new_count != new_roots || new_roots == 0)) {
 			WARN_ON(cur_new_count != new_roots && new_roots == 0);
-			/*
-			 * FIXME: use the data_info to store all information currently.
-			 * will seperate the information into data and metadata later.
-			 **/
-			data_info = &qg->data_info;
-			data_info->excl -= num_bytes;
-			data_info->excl_cmpr -= num_bytes;
+			info->excl -= num_bytes;
+			info->excl_cmpr -= num_bytes;
 			dirty = true;
 		}
 
@@ -1911,13 +1922,8 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		 */
 		if ((!old_roots || (old_roots && cur_old_count != old_roots))
 		    && cur_new_count == new_roots) {
-			/*
-			 * FIXME: use the data_info to store all information currently.
-			 * will seperate the information into data and metadata later.
-			 **/
-			data_info = &qg->data_info;
-			data_info->excl += num_bytes;
-			data_info->excl_cmpr += num_bytes;
+			info->excl += num_bytes;
+			info->excl_cmpr += num_bytes;
 			dirty = true;
 		}
 
@@ -2102,7 +2108,8 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 	 * solution for this.
 	 */
 	qgroup_adjust_counters(fs_info, oper->ref_root, oper->num_bytes,
-			       qgroups, seq, old_roots, new_roots, 0);
+			       oper->quota_type, qgroups, seq, old_roots,
+			       new_roots, 0);
 out:
 	spin_unlock(&fs_info->qgroup_lock);
 	ulist_free(qgroups);
@@ -2171,11 +2178,16 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	qg = find_qgroup_rb(fs_info, root_obj);
 	if (!qg)
 		goto out_unlock;
-	/*
-	 * FIXME: use the data_info to store all information currently.
-	 * will seperate the information into data and metadata later.
-	 **/
-	info = &qg->data_info;
+
+	if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+		info = &qg->data_info;
+	} else {
+		if (oper->quota_type == BTRFS_QGROUP_REF_TYPE_DATA)
+			info = &qg->data_info;
+		else
+			info = &qg->metadata_info;
+	}
+
 	info->excl += oper->num_bytes;
 	info->excl_cmpr += oper->num_bytes;
 	qgroup_dirty(fs_info, qg);
@@ -2197,11 +2209,15 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(parents, &uiter))) {
 		qg = u64_to_ptr(unode->aux);
-		/*
-		 * FIXME: use the data_info to store all information currently.
-		 * will seperate the information into data and metadata later.
-		 **/
-		info = &qg->data_info;
+
+		if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+			info = &qg->data_info;
+		} else {
+			if (oper->quota_type == BTRFS_QGROUP_REF_TYPE_DATA)
+				info = &qg->data_info;
+			else
+				info = &qg->metadata_info;
+		}
 		info->excl += oper->num_bytes;
 		info->excl_cmpr += oper->num_bytes;
 		qgroup_dirty(fs_info, qg);
@@ -2579,12 +2595,47 @@ out:
 	return ret;
 }
 
-int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
+static int exceed_limits(struct btrfs_qgroup_info *info,
+			 struct btrfs_qgroup_limits *limits,
+			 struct btrfs_qgroup_info *another_info,
+			 u64 num_bytes)
+{
+	if (another_info) {
+		/*
+		 * For the mixed limits.
+		 */
+		if ((limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
+		    info->reserved + (s64)info->excl +
+		    another_info->reserved + (s64)another_info->excl +
+		    num_bytes > limits->max_excl)
+			return 1;
+
+		if ((limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
+		    info->reserved + (s64)info->rfer +
+		    another_info->reserved + (s64)another_info->rfer +
+		    num_bytes > limits->max_rfer)
+			return 1;
+		
+	} else {
+		if ((limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
+		    info->reserved + (s64)info->excl + num_bytes >
+		    limits->max_excl)
+			return 1;
+
+		if ((limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
+		    info->reserved + (s64)info->rfer + num_bytes >
+		    limits->max_rfer)
+			return 1;
+	}
+
+	return 0;
+}
+
+int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_qgroup_info *data_info;
-	struct btrfs_qgroup_limits *mixed_limits;
+	struct btrfs_qgroup_info *info;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
@@ -2617,33 +2668,32 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		goto out;
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
-		struct btrfs_qgroup *qg;
+		struct btrfs_qgroup *qgroup;
 		struct btrfs_qgroup_list *glist;
 
-		qg = u64_to_ptr(unode->aux);
-
-		/*
-		 * FIXME: use the data_info to store all information currently.
-		 * will seperate the information into data and metadata later.
-		 **/
-		data_info = &qgroup->data_info;
-		mixed_limits = &qgroup->mixed_limits;
+		qgroup = u64_to_ptr(unode->aux);
 
-		if ((mixed_limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    data_info->reserved + (s64)data_info->rfer + num_bytes >
-		    mixed_limits->max_rfer) {
-			ret = -EDQUOT;
-			goto out;
+		if (type == BTRFS_QGROUP_REF_TYPE_DATA) {
+			info = &qgroup->data_info;
+			if (exceed_limits(info, &qgroup->data_limits, NULL, num_bytes)) {
+				ret = -EDQUOT;
+				goto out;
+			}
+		} else {
+			info = &qgroup->metadata_info;
+			if (exceed_limits(info, &qgroup->metadata_limits, NULL, num_bytes)) {
+				ret = -EDQUOT;
+				goto out;
+			}
 		}
 
-		if ((mixed_limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    data_info->reserved + (s64)data_info->excl + num_bytes >
-		    mixed_limits->max_excl) {
+		if (exceed_limits(&qgroup->data_info, &qgroup->mixed_limits,
+				  &qgroup->metadata_info, num_bytes)) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
-		list_for_each_entry(glist, &qg->groups, next_group) {
+		list_for_each_entry(glist, &qgroup->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
 					glist->group->qgroupid,
 					(uintptr_t)glist->group, GFP_ATOMIC);
@@ -2661,13 +2711,16 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		/*
-		 * FIXME: use the data_info to store all information currently.
-		 * will seperate the information into data and metadata later.
-		 **/
-		data_info = &qg->data_info;
+		if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+			info = &qg->data_info;
+		} else {
+			if (type == BTRFS_QGROUP_REF_TYPE_DATA)
+				info = &qg->data_info;
+			else
+				info = &qg->metadata_info;
+		}
 
-		data_info->reserved += num_bytes;
+		info->reserved += num_bytes;
 	}
 
 out:
@@ -2675,11 +2728,11 @@ out:
 	return ret;
 }
 
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
+void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes, u8 type)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_qgroup_info *data_info;
+	struct btrfs_qgroup_info *info;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -2714,13 +2767,16 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		/*
-		 * FIXME: use the data_info to store all information currently.
-		 * will seperate the information into data and metadata later.
-		 **/
-		data_info = &qg->data_info;
+		if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+			info = &qg->data_info;
+		} else {
+			if (type == BTRFS_QGROUP_REF_TYPE_DATA)
+				info = &qg->data_info;
+			else
+				info = &qg->metadata_info;
+		}
 
-		data_info->reserved -= num_bytes;
+		info->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
@@ -2830,7 +2886,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 			goto out;
 		}
 
-		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, qgroups,
+		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, 0, qgroups,
 					     seq, 0, new_roots, 1);
 		if (ret < 0) {
 			spin_unlock(&fs_info->qgroup_lock);
@@ -2979,22 +3035,25 @@ qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)
 {
 	struct rb_node *n;
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_qgroup_info *data_info;
+	struct btrfs_qgroup_info *info;
 
 	spin_lock(&fs_info->qgroup_lock);
 	/* clear all current qgroup tracking information */
 	for (n = rb_first(&fs_info->qgroup_tree); n; n = rb_next(n)) {
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
-		/*
-		 * FIXME: use the data_info to store all information currently.
-		 * will seperate the information into data and metadata later.
-		 **/
-		data_info = &qgroup->data_info;
 
-		data_info->rfer = 0;
-		data_info->rfer_cmpr = 0;
-		data_info->excl = 0;
-		data_info->excl_cmpr = 0;
+		info = &qgroup->data_info;
+
+again:
+		info->rfer = 0;
+		info->rfer_cmpr = 0;
+		info->excl = 0;
+		info->excl_cmpr = 0;
+
+		if (info != &qgroup->metadata_info) {
+			info = &qgroup->metadata_info;
+			goto again;
+		}
 	}
 	spin_unlock(&fs_info->qgroup_lock);
 }
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 52d8b19..11b73f3 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -20,6 +20,22 @@
 #define __BTRFS_QGROUP__
 
 /*
+ * Type for quota reference. Caller of qgroup_record_ref()
+ * should choose one type of the reference passed to qgroup.
+ * Then qgroup will account the reference in the chosen info.
+ */
+#define BTRFS_QGROUP_REF_TYPE_DATA          (1 << 0)
+#define BTRFS_QGROUP_REF_TYPE_METADATA      (1 << 1)
+
+/*
+ * To keep the compatibility, define a default type to manage
+ * the all reference in the older kernel. Choose the data_info
+ * to account all reference in older kernel which did not record
+ * and account reference for data and metadata separately.
+ */
+#define BTRFS_QGROUP_REF_TYPE_DEFAULT	BTRFS_QGROUP_REF_TYPE_DATA
+
+/*
  * A description of the operations, all of these operations only happen when we
  * are adding the 1st reference for that subvolume in the case of adding space
  * or on the last reference delete in the case of subtraction.  The only
@@ -53,6 +69,10 @@ struct btrfs_qgroup_operation {
 	u64 num_bytes;
 	u64 seq;
 	enum btrfs_qgroup_operation_type type;
+	/*
+	 * DATA or METADATA;
+	 **/
+	unsigned int quota_type;
 	struct seq_list elem;
 	struct rb_node n;
 	struct list_head list;
@@ -86,6 +106,7 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info, u64 ref_root,
 			    u64 bytenr, u64 num_bytes,
 			    enum btrfs_qgroup_operation_type type,
+			    unsigned int quota_type,
 			    int mod_seq);
 int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
 				    struct btrfs_fs_info *fs_info);
@@ -97,8 +118,8 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
-int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
+int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type);
+void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes, u8 type);
 
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index c32a7ba..2c978ce 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -239,7 +239,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	}
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+				      BTRFS_QGROUP_OPER_ADD_EXCL,
+				      BTRFS_QGROUP_REF_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Couldn't add space to a qgroup %d\n", ret);
 		return ret;
@@ -265,7 +266,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return -EINVAL;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_SUB_EXCL, 0);
+				      BTRFS_QGROUP_OPER_SUB_EXCL,
+				      BTRFS_QGROUP_REF_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Couldn't remove space from the qgroup %d\n", ret);
 		return -EINVAL;
@@ -312,7 +314,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+				      BTRFS_QGROUP_OPER_ADD_EXCL,
+				      BTRFS_QGROUP_REF_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Couldn't add space to a qgroup %d\n", ret);
 		return ret;
@@ -334,7 +337,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_SHARED, 0);
+				      BTRFS_QGROUP_OPER_ADD_SHARED,
+				      BTRFS_QGROUP_REF_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Qgroup record ref failed %d\n", ret);
 		return ret;
@@ -361,7 +365,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
-				      BTRFS_QGROUP_OPER_SUB_SHARED, 0);
+				      BTRFS_QGROUP_OPER_SUB_SHARED,
+				      BTRFS_QGROUP_REF_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Qgroup record ref failed %d\n", ret);
 		return ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7e80f32..8d4bffb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -440,7 +440,8 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 		if (root->fs_info->quota_enabled &&
 		    is_fstree(root->root_key.objectid)) {
 			qgroup_reserved = num_items * root->nodesize;
-			ret = btrfs_qgroup_reserve(root, qgroup_reserved);
+			ret = btrfs_qgroup_reserve(root, qgroup_reserved,
+						   BTRFS_QGROUP_REF_TYPE_METADATA);
 			if (ret)
 				return ERR_PTR(ret);
 		}
@@ -555,7 +556,7 @@ alloc_fail:
 					num_bytes);
 reserve_fail:
 	if (qgroup_reserved)
-		btrfs_qgroup_free(root, qgroup_reserved);
+		btrfs_qgroup_free(root, qgroup_reserved, BTRFS_QGROUP_REF_TYPE_METADATA);
 	return ERR_PTR(ret);
 }
 
@@ -777,7 +778,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		 * the same root has to be passed here between start_transaction
 		 * and end_transaction. Subvolume quota depends on this.
 		 */
-		btrfs_qgroup_free(trans->root, trans->qgroup_reserved);
+		btrfs_qgroup_free(trans->root, trans->qgroup_reserved, BTRFS_QGROUP_REF_TYPE_METADATA);
 		trans->qgroup_reserved = 0;
 	}
 
@@ -1783,7 +1784,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		btrfs_qgroup_free(root, trans->qgroup_reserved, BTRFS_QGROUP_REF_TYPE_METADATA);
 		trans->qgroup_reserved = 0;
 	}
 
@@ -2079,7 +2080,7 @@ cleanup_transaction:
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		btrfs_qgroup_free(root, trans->qgroup_reserved, BTRFS_QGROUP_REF_TYPE_METADATA);
 		trans->qgroup_reserved = 0;
 	}
 	btrfs_warn(root->fs_info, "Skipping commit of aborted transaction.");
-- 
1.8.4.2

