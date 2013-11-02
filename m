Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35421 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3KBPOo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 11:14:44 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so5181471pab.8
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Nov 2013 08:14:43 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, list.btrfs@jan-o-sch.net, wangsl.fnst@cn.fujitsu.com
Subject: [RFC PATCH 1/2] Btrfs: disable qgroup's exclusive size tracking
Date: Sat,  2 Nov 2013 23:14:32 +0800
Message-Id: <1383405273-27304-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1383405273-27304-1-git-send-email-wangshilong1991@gmail.com>
References: <1383405273-27304-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

This patch tries to disable qgroup's exclusive size tracking,this will
bring pros and cons.

Pros:
1. we need not walk backref tree during qgroup tracking thus reducing
high system memory cost and speed up qgroup tracking process.

2.when deleting a subvolume/snapshot, we just need to delete it's qgroup.

Cons:
1. We lost an important feature to know qgroup's sole size.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 265 +++++++-----------------------------------------------
 1 file changed, 30 insertions(+), 235 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e6ef49..32bedb5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -56,17 +56,13 @@ struct btrfs_qgroup {
 	 */
 	u64 rfer;	/* referenced */
 	u64 rfer_cmpr;	/* referenced compressed */
-	u64 excl;	/* exclusive */
-	u64 excl_cmpr;	/* exclusive compressed */
 
 	/*
 	 * limits
 	 */
 	u64 lim_flags;	/* which limits are set */
 	u64 max_rfer;
-	u64 max_excl;
 	u64 rsv_rfer;
-	u64 rsv_excl;
 
 	/*
 	 * reservation tracking
@@ -343,8 +339,6 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 					     struct btrfs_qgroup_info_item);
 			qgroup->rfer = btrfs_qgroup_info_rfer(l, ptr);
 			qgroup->rfer_cmpr = btrfs_qgroup_info_rfer_cmpr(l, ptr);
-			qgroup->excl = btrfs_qgroup_info_excl(l, ptr);
-			qgroup->excl_cmpr = btrfs_qgroup_info_excl_cmpr(l, ptr);
 			/* generation currently unused */
 			break;
 		}
@@ -355,9 +349,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 					     struct btrfs_qgroup_limit_item);
 			qgroup->lim_flags = btrfs_qgroup_limit_flags(l, ptr);
 			qgroup->max_rfer = btrfs_qgroup_limit_max_rfer(l, ptr);
-			qgroup->max_excl = btrfs_qgroup_limit_max_excl(l, ptr);
 			qgroup->rsv_rfer = btrfs_qgroup_limit_rsv_rfer(l, ptr);
-			qgroup->rsv_excl = btrfs_qgroup_limit_rsv_excl(l, ptr);
 			break;
 		}
 		}
@@ -557,8 +549,8 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 				  struct btrfs_qgroup_limit_item);
 	btrfs_set_qgroup_limit_flags(leaf, qgroup_limit, 0);
 	btrfs_set_qgroup_limit_max_rfer(leaf, qgroup_limit, 0);
-	btrfs_set_qgroup_limit_max_excl(leaf, qgroup_limit, 0);
 	btrfs_set_qgroup_limit_rsv_rfer(leaf, qgroup_limit, 0);
+	btrfs_set_qgroup_limit_max_excl(leaf, qgroup_limit, 0);
 	btrfs_set_qgroup_limit_rsv_excl(leaf, qgroup_limit, 0);
 
 	btrfs_mark_buffer_dirty(leaf);
@@ -617,8 +609,7 @@ out:
 
 static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root, u64 qgroupid,
-				    u64 flags, u64 max_rfer, u64 max_excl,
-				    u64 rsv_rfer, u64 rsv_excl)
+				    u64 flags, u64 max_rfer, u64 rsv_rfer)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -648,9 +639,7 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 				      struct btrfs_qgroup_limit_item);
 	btrfs_set_qgroup_limit_flags(l, qgroup_limit, flags);
 	btrfs_set_qgroup_limit_max_rfer(l, qgroup_limit, max_rfer);
-	btrfs_set_qgroup_limit_max_excl(l, qgroup_limit, max_excl);
 	btrfs_set_qgroup_limit_rsv_rfer(l, qgroup_limit, rsv_rfer);
-	btrfs_set_qgroup_limit_rsv_excl(l, qgroup_limit, rsv_excl);
 
 	btrfs_mark_buffer_dirty(l);
 
@@ -692,9 +681,6 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	btrfs_set_qgroup_info_generation(l, qgroup_info, trans->transid);
 	btrfs_set_qgroup_info_rfer(l, qgroup_info, qgroup->rfer);
 	btrfs_set_qgroup_info_rfer_cmpr(l, qgroup_info, qgroup->rfer_cmpr);
-	btrfs_set_qgroup_info_excl(l, qgroup_info, qgroup->excl);
-	btrfs_set_qgroup_info_excl_cmpr(l, qgroup_info, qgroup->excl_cmpr);
-
 	btrfs_mark_buffer_dirty(l);
 
 out:
@@ -1157,8 +1143,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	}
 	ret = update_qgroup_limit_item(trans, quota_root, qgroupid,
 				       limit->flags, limit->max_rfer,
-				       limit->max_excl, limit->rsv_rfer,
-				       limit->rsv_excl);
+				       limit->rsv_rfer);
 	if (ret) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		printk(KERN_INFO "unable to update quota limit for %llu\n",
@@ -1168,9 +1153,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup->lim_flags = limit->flags;
 	qgroup->max_rfer = limit->max_rfer;
-	qgroup->max_excl = limit->max_excl;
 	qgroup->rsv_rfer = limit->rsv_rfer;
-	qgroup->rsv_excl = limit->rsv_excl;
 	spin_unlock(&fs_info->qgroup_lock);
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
@@ -1202,7 +1185,7 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 
 static int qgroup_account_ref_step1(struct btrfs_fs_info *fs_info,
 				    struct ulist *roots, struct ulist *tmp,
-				    u64 seq)
+				    u64 bytenr)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -1228,10 +1211,9 @@ static int qgroup_account_ref_step1(struct btrfs_fs_info *fs_info,
 			struct btrfs_qgroup_list *glist;
 
 			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
-			if (qg->refcnt < seq)
-				qg->refcnt = seq + 1;
-			else
-				++qg->refcnt;
+			qg->rfer += bytenr;
+			qg->rfer_cmpr += bytenr;
+			qgroup_dirty(fs_info, qg);
 
 			list_for_each_entry(glist, &qg->groups, next_group) {
 				ret = ulist_add(tmp, glist->group->qgroupid,
@@ -1247,9 +1229,8 @@ static int qgroup_account_ref_step1(struct btrfs_fs_info *fs_info,
 }
 
 static int qgroup_account_ref_step2(struct btrfs_fs_info *fs_info,
-				    struct ulist *roots, struct ulist *tmp,
-				    u64 seq, int sgn, u64 num_bytes,
-				    struct btrfs_qgroup *qgroup)
+				    struct ulist *tmp, int sgn,
+				    u64 num_bytes, struct btrfs_qgroup *qgroup)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -1265,18 +1246,10 @@ static int qgroup_account_ref_step2(struct btrfs_fs_info *fs_info,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
-		if (qg->refcnt < seq) {
-			/* not visited by step 1 */
-			qg->rfer += sgn * num_bytes;
-			qg->rfer_cmpr += sgn * num_bytes;
-			if (roots->nnodes == 0) {
-				qg->excl += sgn * num_bytes;
-				qg->excl_cmpr += sgn * num_bytes;
-			}
-			qgroup_dirty(fs_info, qg);
-		}
-		WARN_ON(qg->tag >= seq);
-		qg->tag = seq;
+
+		qg->rfer += sgn * num_bytes;
+		qg->rfer_cmpr += sgn * num_bytes;
+		qgroup_dirty(fs_info, qg);
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(tmp, glist->group->qgroupid,
@@ -1289,55 +1262,6 @@ static int qgroup_account_ref_step2(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int qgroup_account_ref_step3(struct btrfs_fs_info *fs_info,
-				    struct ulist *roots, struct ulist *tmp,
-				    u64 seq, int sgn, u64 num_bytes)
-{
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-	struct btrfs_qgroup *qg;
-	struct ulist_node *tmp_unode;
-	struct ulist_iterator tmp_uiter;
-	int ret;
-
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(roots, &uiter))) {
-		qg = find_qgroup_rb(fs_info, unode->val);
-		if (!qg)
-			continue;
-
-		ulist_reinit(tmp);
-		ret = ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
-		if (ret < 0)
-			return ret;
-
-		ULIST_ITER_INIT(&tmp_uiter);
-		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
-			struct btrfs_qgroup_list *glist;
-
-			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
-			if (qg->tag == seq)
-				continue;
-
-			if (qg->refcnt - seq == roots->nnodes) {
-				qg->excl -= sgn * num_bytes;
-				qg->excl_cmpr -= sgn * num_bytes;
-				qgroup_dirty(fs_info, qg);
-			}
-
-			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						(uintptr_t)glist->group,
-						GFP_ATOMIC);
-				if (ret < 0)
-					return ret;
-			}
-		}
-	}
-
-	return 0;
-}
-
 /*
  * btrfs_qgroup_account_ref is called for every ref that is added to or deleted
  * from the fs. First, all roots referencing the extent are searched, and
@@ -1353,8 +1277,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root;
 	u64 ref_root;
 	struct btrfs_qgroup *qgroup;
-	struct ulist *roots = NULL;
-	u64 seq;
 	int ret = 0;
 	int sgn;
 
@@ -1392,11 +1314,9 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	case BTRFS_ADD_DELAYED_REF:
 	case BTRFS_ADD_DELAYED_EXTENT:
 		sgn = 1;
-		seq = btrfs_tree_mod_seq_prev(node->seq);
 		break;
 	case BTRFS_DROP_DELAYED_REF:
 		sgn = -1;
-		seq = node->seq;
 		break;
 	case BTRFS_UPDATE_DELAYED_HEAD:
 		return 0;
@@ -1413,21 +1333,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	}
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	/*
-	 * the delayed ref sequence number we pass depends on the direction of
-	 * the operation. for add operations, we pass
-	 * tree_mod_log_prev_seq(node->seq) to skip
-	 * the delayed ref's current sequence number, because we need the state
-	 * of the tree before the add operation. for delete operations, we pass
-	 * (node->seq) to include the delayed ref's current sequence number,
-	 * because we need the state of the tree after the delete operation.
-	 */
-	ret = btrfs_find_all_roots(trans, fs_info, node->bytenr, seq, &roots);
-	if (ret < 0)
-		return ret;
-
 	spin_lock(&fs_info->qgroup_lock);
-
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
 		goto unlock;
@@ -1436,37 +1342,13 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	if (!qgroup)
 		goto unlock;
 
-	/*
-	 * step 1: for each old ref, visit all nodes once and inc refcnt
-	 */
 	ulist_reinit(fs_info->qgroup_ulist);
-	seq = fs_info->qgroup_seq;
-	fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
-
-	ret = qgroup_account_ref_step1(fs_info, roots, fs_info->qgroup_ulist,
-				       seq);
-	if (ret)
-		goto unlock;
-
-	/*
-	 * step 2: walk from the new root
-	 */
-	ret = qgroup_account_ref_step2(fs_info, roots, fs_info->qgroup_ulist,
-				       seq, sgn, node->num_bytes, qgroup);
-	if (ret)
-		goto unlock;
-
-	/*
-	 * step 3: walk again from old refs
-	 */
-	ret = qgroup_account_ref_step3(fs_info, roots, fs_info->qgroup_ulist,
-				       seq, sgn, node->num_bytes);
+	ret = qgroup_account_ref_step2(fs_info, fs_info->qgroup_ulist,
+				       sgn, node->num_bytes, qgroup);
 	if (ret)
 		goto unlock;
-
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
-	ulist_free(roots);
 
 	return ret;
 }
@@ -1578,9 +1460,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		ret = update_qgroup_limit_item(trans, quota_root, objectid,
 					       inherit->lim.flags,
 					       inherit->lim.max_rfer,
-					       inherit->lim.max_excl,
-					       inherit->lim.rsv_rfer,
-					       inherit->lim.rsv_excl);
+					       inherit->lim.rsv_rfer);
 		if (ret)
 			goto out;
 	}
@@ -1638,10 +1518,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			goto unlock;
 		dstgroup->rfer = srcgroup->rfer - level_size;
 		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr - level_size;
-		srcgroup->excl = level_size;
-		srcgroup->excl_cmpr = level_size;
 		qgroup_dirty(fs_info, dstgroup);
-		qgroup_dirty(fs_info, srcgroup);
 	}
 
 	if (!inherit)
@@ -1655,38 +1532,21 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			goto unlock;
 		++i_qgroups;
 	}
+	if (!srcid)
+		goto unlock;
 
-	for (i = 0; i <  inherit->num_ref_copies; ++i) {
-		struct btrfs_qgroup *src;
-		struct btrfs_qgroup *dst;
-
-		src = find_qgroup_rb(fs_info, i_qgroups[0]);
-		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
-
-		if (!src || !dst) {
-			ret = -EINVAL;
-			goto unlock;
-		}
-
-		dst->rfer = src->rfer - level_size;
-		dst->rfer_cmpr = src->rfer_cmpr - level_size;
-		i_qgroups += 2;
-	}
-	for (i = 0; i <  inherit->num_excl_copies; ++i) {
-		struct btrfs_qgroup *src;
-		struct btrfs_qgroup *dst;
-
-		src = find_qgroup_rb(fs_info, i_qgroups[0]);
-		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
+	i_qgroups = (u64 *)(inherit + 1);
+	for (i = 0; i < inherit->num_qgroups; ++i) {
+		struct btrfs_qgroup *qgroup;
 
-		if (!src || !dst) {
-			ret = -EINVAL;
-			goto unlock;
-		}
+		qgroup = find_qgroup_rb(fs_info, *i_qgroups);
+		if (!qgroup)
+			continue;
 
-		dst->excl = src->excl + level_size;
-		dst->excl_cmpr = src->excl_cmpr + level_size;
-		i_qgroups += 2;
+		qgroup->rfer += dstgroup->rfer;
+		qgroup->rfer_cmpr += dstgroup->rfer_cmpr;
+		qgroup_dirty(quota_root->fs_info, qgroup);
+		++i_qgroups;
 	}
 
 unlock:
@@ -1750,13 +1610,6 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 			goto out;
 		}
 
-		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + (s64)qg->excl + num_bytes >
-		    qg->max_excl) {
-			ret = -EDQUOT;
-			goto out;
-		}
-
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
 					glist->group->qgroupid,
@@ -1858,10 +1711,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 {
 	struct btrfs_key found;
 	struct ulist *roots = NULL;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
 	struct seq_list tree_mod_seq_elem = {};
-	u64 seq;
 	int slot;
 	int ret;
 
@@ -1909,67 +1759,14 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 					   tree_mod_seq_elem.seq, &roots);
 		if (ret < 0)
 			goto out;
-		spin_lock(&fs_info->qgroup_lock);
-		seq = fs_info->qgroup_seq;
-		fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
 
-		ret = qgroup_account_ref_step1(fs_info, roots, tmp, seq);
+		spin_lock(&fs_info->qgroup_lock);
+		ret = qgroup_account_ref_step1(fs_info, roots, tmp, found.offset);
 		if (ret) {
 			spin_unlock(&fs_info->qgroup_lock);
 			ulist_free(roots);
 			goto out;
 		}
-
-		/*
-		 * step2 of btrfs_qgroup_account_ref works from a single root,
-		 * we're doing all at once here.
-		 */
-		ulist_reinit(tmp);
-		ULIST_ITER_INIT(&uiter);
-		while ((unode = ulist_next(roots, &uiter))) {
-			struct btrfs_qgroup *qg;
-
-			qg = find_qgroup_rb(fs_info, unode->val);
-			if (!qg)
-				continue;
-
-			ret = ulist_add(tmp, qg->qgroupid, (uintptr_t)qg,
-					GFP_ATOMIC);
-			if (ret < 0) {
-				spin_unlock(&fs_info->qgroup_lock);
-				ulist_free(roots);
-				goto out;
-			}
-		}
-
-		/* this loop is similar to step 2 of btrfs_qgroup_account_ref */
-		ULIST_ITER_INIT(&uiter);
-		while ((unode = ulist_next(tmp, &uiter))) {
-			struct btrfs_qgroup *qg;
-			struct btrfs_qgroup_list *glist;
-
-			qg = (struct btrfs_qgroup *)(uintptr_t) unode->aux;
-			qg->rfer += found.offset;
-			qg->rfer_cmpr += found.offset;
-			WARN_ON(qg->tag >= seq);
-			if (qg->refcnt - seq == roots->nnodes) {
-				qg->excl += found.offset;
-				qg->excl_cmpr += found.offset;
-			}
-			qgroup_dirty(fs_info, qg);
-
-			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						(uintptr_t)glist->group,
-						GFP_ATOMIC);
-				if (ret < 0) {
-					spin_unlock(&fs_info->qgroup_lock);
-					ulist_free(roots);
-					goto out;
-				}
-			}
-		}
-
 		spin_unlock(&fs_info->qgroup_lock);
 		ulist_free(roots);
 		ret = 0;
@@ -2115,8 +1912,6 @@ qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
 		qgroup->rfer = 0;
 		qgroup->rfer_cmpr = 0;
-		qgroup->excl = 0;
-		qgroup->excl_cmpr = 0;
 	}
 	spin_unlock(&fs_info->qgroup_lock);
 }
-- 
1.7.11.7

