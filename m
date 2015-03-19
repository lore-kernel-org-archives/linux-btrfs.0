Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51119 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182AbbCSGEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:53 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/7] Btrfs: qgroup: split information and limits in qgroup to other structures.
Date: Thu, 19 Mar 2015 14:00:55 +0800
Message-ID: <1426744864-7031-3-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Restruct the btrfs_qgroup structure:

btrfs_qgroup:                                     |-------------|
-----------------                                 |rfer         |
|data_info      |--------------->btrfs_qgroup_info|rfer_cmpr    |
|metadata_info  |                                 |excl         |
|               |                                 |excl_cmpr    |
|data_limits    |                                 ---------------
|metadata_limits|
|mixed_limits   |--------------->btrfs_qgroup_limits|-------------
|-------------- |                                   |lim_flags  |
                                                    |max_rfer   |
                                                    |max_excl   |
                                                    |rsv_rfer   |
                                                    |rsv_excl   |
                                                    ------------

Then we can account data and metadata separately. And we can limit them
separately. mixed_limits is provided to limit the sum of data and metadata.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 308 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 214 insertions(+), 94 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 28b0aa5..dd99908 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -46,33 +46,44 @@
  *  - check all ioctl parameters
  */
 
-/*
- * one struct for each qgroup, organized in fs_info->qgroup_tree.
- */
-struct btrfs_qgroup {
-	u64 qgroupid;
-
-	/*
-	 * state
-	 */
+struct btrfs_qgroup_info {
 	u64 rfer;	/* referenced */
 	u64 rfer_cmpr;	/* referenced compressed */
 	u64 excl;	/* exclusive */
 	u64 excl_cmpr;	/* exclusive compressed */
 
 	/*
-	 * limits
+	 * reservation tracking
 	 */
+	u64 reserved;
+};
+
+struct btrfs_qgroup_limits {
 	u64 lim_flags;	/* which limits are set */
 	u64 max_rfer;
 	u64 max_excl;
 	u64 rsv_rfer;
 	u64 rsv_excl;
+};
+
+/*
+ * one struct for each qgroup, organized in fs_info->qgroup_tree.
+ */
+struct btrfs_qgroup {
+	u64 qgroupid;
 
 	/*
-	 * reservation tracking
+	 * infos
 	 */
-	u64 reserved;
+	struct btrfs_qgroup_info	data_info;
+	struct btrfs_qgroup_info	metadata_info;
+
+	/*
+	 * limits
+	 */
+	struct btrfs_qgroup_limits	data_limits;
+	struct btrfs_qgroup_limits	metadata_limits;
+	struct btrfs_qgroup_limits	mixed_limits;
 
 	/*
 	 * lists
@@ -251,11 +262,13 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 			       u64 rfer, u64 excl)
 {
 	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_info *info;
 
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
 	if (!qgroup)
 		return -EINVAL;
-	if (qgroup->rfer != rfer || qgroup->excl != excl)
+	info = &qgroup->data_info;
+	if (info->rfer != rfer || info->excl != excl)
 		return -EINVAL;
 	return 0;
 }
@@ -357,26 +370,30 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 		switch (found_key.type) {
 		case BTRFS_QGROUP_INFO_KEY: {
 			struct btrfs_qgroup_info_item *ptr;
+			struct btrfs_qgroup_info *info;
 
+			info = &qgroup->data_info;
 			ptr = btrfs_item_ptr(l, slot,
 					     struct btrfs_qgroup_info_item);
-			qgroup->rfer = btrfs_qgroup_info_rfer(l, ptr);
-			qgroup->rfer_cmpr = btrfs_qgroup_info_rfer_cmpr(l, ptr);
-			qgroup->excl = btrfs_qgroup_info_excl(l, ptr);
-			qgroup->excl_cmpr = btrfs_qgroup_info_excl_cmpr(l, ptr);
+			info->rfer = btrfs_qgroup_info_rfer(l, ptr);
+			info->rfer_cmpr = btrfs_qgroup_info_rfer_cmpr(l, ptr);
+			info->excl = btrfs_qgroup_info_excl(l, ptr);
+			info->excl_cmpr = btrfs_qgroup_info_excl_cmpr(l, ptr);
 			/* generation currently unused */
 			break;
 		}
 		case BTRFS_QGROUP_LIMIT_KEY: {
 			struct btrfs_qgroup_limit_item *ptr;
+			struct btrfs_qgroup_limits *limits;
 
+			limits = &qgroup->mixed_limits;
 			ptr = btrfs_item_ptr(l, slot,
 					     struct btrfs_qgroup_limit_item);
-			qgroup->lim_flags = btrfs_qgroup_limit_flags(l, ptr);
-			qgroup->max_rfer = btrfs_qgroup_limit_max_rfer(l, ptr);
-			qgroup->max_excl = btrfs_qgroup_limit_max_excl(l, ptr);
-			qgroup->rsv_rfer = btrfs_qgroup_limit_rsv_rfer(l, ptr);
-			qgroup->rsv_excl = btrfs_qgroup_limit_rsv_excl(l, ptr);
+			limits->lim_flags = btrfs_qgroup_limit_flags(l, ptr);
+			limits->max_rfer = btrfs_qgroup_limit_max_rfer(l, ptr);
+			limits->max_excl = btrfs_qgroup_limit_max_excl(l, ptr);
+			limits->rsv_rfer = btrfs_qgroup_limit_rsv_rfer(l, ptr);
+			limits->rsv_excl = btrfs_qgroup_limit_rsv_excl(l, ptr);
 			break;
 		}
 		}
@@ -651,6 +668,7 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct extent_buffer *l;
 	struct btrfs_qgroup_limit_item *qgroup_limit;
+	struct btrfs_qgroup_limits *limits;
 	int ret;
 	int slot;
 
@@ -669,14 +687,16 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
+	limits = &qgroup->mixed_limits;
+
 	l = path->nodes[0];
 	slot = path->slots[0];
 	qgroup_limit = btrfs_item_ptr(l, slot, struct btrfs_qgroup_limit_item);
-	btrfs_set_qgroup_limit_flags(l, qgroup_limit, qgroup->lim_flags);
-	btrfs_set_qgroup_limit_max_rfer(l, qgroup_limit, qgroup->max_rfer);
-	btrfs_set_qgroup_limit_max_excl(l, qgroup_limit, qgroup->max_excl);
-	btrfs_set_qgroup_limit_rsv_rfer(l, qgroup_limit, qgroup->rsv_rfer);
-	btrfs_set_qgroup_limit_rsv_excl(l, qgroup_limit, qgroup->rsv_excl);
+	btrfs_set_qgroup_limit_flags(l, qgroup_limit, limits->lim_flags);
+	btrfs_set_qgroup_limit_max_rfer(l, qgroup_limit, limits->max_rfer);
+	btrfs_set_qgroup_limit_max_excl(l, qgroup_limit, limits->max_excl);
+	btrfs_set_qgroup_limit_rsv_rfer(l, qgroup_limit, limits->rsv_rfer);
+	btrfs_set_qgroup_limit_rsv_excl(l, qgroup_limit, limits->rsv_excl);
 
 	btrfs_mark_buffer_dirty(l);
 
@@ -693,6 +713,7 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct extent_buffer *l;
 	struct btrfs_qgroup_info_item *qgroup_info;
+	struct btrfs_qgroup_info *data_info;
 	int ret;
 	int slot;
 
@@ -714,14 +735,16 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
+	data_info = &qgroup->data_info;
+
 	l = path->nodes[0];
 	slot = path->slots[0];
 	qgroup_info = btrfs_item_ptr(l, slot, struct btrfs_qgroup_info_item);
 	btrfs_set_qgroup_info_generation(l, qgroup_info, trans->transid);
-	btrfs_set_qgroup_info_rfer(l, qgroup_info, qgroup->rfer);
-	btrfs_set_qgroup_info_rfer_cmpr(l, qgroup_info, qgroup->rfer_cmpr);
-	btrfs_set_qgroup_info_excl(l, qgroup_info, qgroup->excl);
-	btrfs_set_qgroup_info_excl_cmpr(l, qgroup_info, qgroup->excl_cmpr);
+	btrfs_set_qgroup_info_rfer(l, qgroup_info, data_info->rfer);
+	btrfs_set_qgroup_info_rfer_cmpr(l, qgroup_info, data_info->rfer_cmpr);
+	btrfs_set_qgroup_info_excl(l, qgroup_info, data_info->excl);
+	btrfs_set_qgroup_info_excl_cmpr(l, qgroup_info, data_info->excl_cmpr);
 
 	btrfs_mark_buffer_dirty(l);
 
@@ -1203,6 +1226,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_limits *limits;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
@@ -1218,16 +1242,20 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	/* To the compatibility, treat the mixed limits as the
+	 * default limits now. will change it later. */
+	limits = &qgroup->mixed_limits;
+
 	spin_lock(&fs_info->qgroup_lock);
 	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
-		qgroup->max_rfer = limit->max_rfer;
+		limits->max_rfer = limit->max_rfer;
 	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
-		qgroup->max_excl = limit->max_excl;
+		limits->max_excl = limit->max_excl;
 	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER)
-		qgroup->rsv_rfer = limit->rsv_rfer;
+		limits->rsv_rfer = limit->rsv_rfer;
 	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL)
-		qgroup->rsv_excl = limit->rsv_excl;
-	qgroup->lim_flags |= limit->flags;
+		limits->rsv_excl = limit->rsv_excl;
+	limits->lim_flags |= limit->flags;
 
 	spin_unlock(&fs_info->qgroup_lock);
 
@@ -1418,6 +1446,7 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 				  struct btrfs_qgroup_operation *oper)
 {
 	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_info *info;
 	struct ulist *tmp;
 	struct btrfs_qgroup_list *glist;
 	struct ulist_node *unode;
@@ -1445,14 +1474,21 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	default:
 		ASSERT(0);
 	}
-	qgroup->rfer += sign * oper->num_bytes;
-	qgroup->rfer_cmpr += sign * oper->num_bytes;
 
-	WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
-	qgroup->excl += sign * oper->num_bytes;
-	qgroup->excl_cmpr += sign * oper->num_bytes;
+	/*
+	 * FIXME: use the data_info to store all information currently.
+	 * will seperate the information into data and metadata later.
+	 **/
+	info = &qgroup->data_info;
+
+	info->rfer += sign * oper->num_bytes;
+	info->rfer_cmpr += sign * oper->num_bytes;
+
+	WARN_ON(sign < 0 && info->excl < oper->num_bytes);
+	info->excl += sign * oper->num_bytes;
+	info->excl_cmpr += sign * oper->num_bytes;
 	if (sign > 0)
-		qgroup->reserved -= oper->num_bytes;
+		info->reserved -= oper->num_bytes;
 
 	qgroup_dirty(fs_info, qgroup);
 
@@ -1468,13 +1504,18 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		qgroup = u64_to_ptr(unode->aux);
-		qgroup->rfer += sign * oper->num_bytes;
-		qgroup->rfer_cmpr += sign * oper->num_bytes;
-		WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
-		qgroup->excl += sign * oper->num_bytes;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		info = &qgroup->data_info;
+		info->rfer += sign * oper->num_bytes;
+		info->rfer_cmpr += sign * oper->num_bytes;
+		WARN_ON(sign < 0 && info->excl < oper->num_bytes);
+		info->excl += sign * oper->num_bytes;
 		if (sign > 0)
-			qgroup->reserved -= oper->num_bytes;
-		qgroup->excl_cmpr += sign * oper->num_bytes;
+			info->reserved -= oper->num_bytes;
+		info->excl_cmpr += sign * oper->num_bytes;
 		qgroup_dirty(fs_info, qgroup);
 
 		/* Add any parents of the parents */
@@ -1740,6 +1781,7 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct btrfs_qgroup *qg;
+	struct btrfs_qgroup_info *data_info;
 	u64 cur_new_count, cur_old_count;
 
 	ULIST_ITER_INIT(&uiter);
@@ -1747,13 +1789,15 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		bool dirty = false;
 
 		qg = u64_to_ptr(unode->aux);
+
+		data_info = &qg->data_info;
 		/*
 		 * Wasn't referenced before but is now, add to the reference
 		 * counters.
 		 */
 		if (qg->old_refcnt <= seq && qg->new_refcnt > seq) {
-			qg->rfer += num_bytes;
-			qg->rfer_cmpr += num_bytes;
+			data_info->rfer += num_bytes;
+			data_info->rfer_cmpr += num_bytes;
 			dirty = true;
 		}
 
@@ -1762,8 +1806,8 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		 * reference counters.
 		 */
 		if (qg->old_refcnt > seq && qg->new_refcnt <= seq) {
-			qg->rfer -= num_bytes;
-			qg->rfer_cmpr -= num_bytes;
+			data_info->rfer -= num_bytes;
+			data_info->rfer_cmpr -= num_bytes;
 			dirty = true;
 		}
 
@@ -1784,8 +1828,13 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		if (old_roots && cur_old_count == old_roots &&
 		    (cur_new_count != new_roots || new_roots == 0)) {
 			WARN_ON(cur_new_count != new_roots && new_roots == 0);
-			qg->excl -= num_bytes;
-			qg->excl_cmpr -= num_bytes;
+			/*
+			 * FIXME: use the data_info to store all information currently.
+			 * will seperate the information into data and metadata later.
+			 **/
+			data_info = &qg->data_info;
+			data_info->excl -= num_bytes;
+			data_info->excl_cmpr -= num_bytes;
 			dirty = true;
 		}
 
@@ -1795,8 +1844,13 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		 */
 		if ((!old_roots || (old_roots && cur_old_count != old_roots))
 		    && cur_new_count == new_roots) {
-			qg->excl += num_bytes;
-			qg->excl_cmpr += num_bytes;
+			/*
+			 * FIXME: use the data_info to store all information currently.
+			 * will seperate the information into data and metadata later.
+			 **/
+			data_info = &qg->data_info;
+			data_info->excl += num_bytes;
+			data_info->excl_cmpr += num_bytes;
 			dirty = true;
 		}
 
@@ -2004,6 +2058,7 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	struct ulist_iterator uiter;
 	struct btrfs_qgroup_list *glist;
 	struct ulist *parents;
+	struct btrfs_qgroup_info *info;
 	int ret = 0;
 	int err;
 	struct btrfs_qgroup *qg;
@@ -2049,9 +2104,13 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	qg = find_qgroup_rb(fs_info, root_obj);
 	if (!qg)
 		goto out_unlock;
-
-	qg->excl += oper->num_bytes;
-	qg->excl_cmpr += oper->num_bytes;
+	/*
+	 * FIXME: use the data_info to store all information currently.
+	 * will seperate the information into data and metadata later.
+	 **/
+	info = &qg->data_info;
+	info->excl += oper->num_bytes;
+	info->excl_cmpr += oper->num_bytes;
 	qgroup_dirty(fs_info, qg);
 
 	/*
@@ -2071,8 +2130,13 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(parents, &uiter))) {
 		qg = u64_to_ptr(unode->aux);
-		qg->excl += oper->num_bytes;
-		qg->excl_cmpr += oper->num_bytes;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		info = &qg->data_info;
+		info->excl += oper->num_bytes;
+		info->excl_cmpr += oper->num_bytes;
 		qgroup_dirty(fs_info, qg);
 
 		/* Add any parents of the parents */
@@ -2242,6 +2306,10 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_qgroup *srcgroup;
 	struct btrfs_qgroup *dstgroup;
+	struct btrfs_qgroup_info *srcinfo;
+	struct btrfs_qgroup_info *dstinfo;
+	struct btrfs_qgroup_limits *srclimits;
+	struct btrfs_qgroup_limits *dstlimits;
 	u32 level_size = 0;
 	u64 nums;
 
@@ -2326,11 +2394,12 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	}
 
 	if (inherit && inherit->flags & BTRFS_QGROUP_INHERIT_SET_LIMITS) {
-		dstgroup->lim_flags = inherit->lim.flags;
-		dstgroup->max_rfer = inherit->lim.max_rfer;
-		dstgroup->max_excl = inherit->lim.max_excl;
-		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
-		dstgroup->rsv_excl = inherit->lim.rsv_excl;
+		dstlimits = &dstgroup->mixed_limits;
+		dstlimits->lim_flags = inherit->lim.flags;
+		dstlimits->max_rfer = inherit->lim.max_rfer;
+		dstlimits->max_excl = inherit->lim.max_excl;
+		dstlimits->rsv_rfer = inherit->lim.rsv_rfer;
+		dstlimits->rsv_excl = inherit->lim.rsv_excl;
 
 		ret = update_qgroup_limit_item(trans, quota_root, dstgroup);
 		if (ret) {
@@ -2345,25 +2414,33 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		srcgroup = find_qgroup_rb(fs_info, srcid);
 		if (!srcgroup)
 			goto unlock;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		dstinfo = &dstgroup->data_info;
+		srcinfo = &srcgroup->data_info;
 
 		/*
 		 * We call inherit after we clone the root in order to make sure
 		 * our counts don't go crazy, so at this point the only
 		 * difference between the two roots should be the root node.
 		 */
-		dstgroup->rfer = srcgroup->rfer;
-		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr;
-		dstgroup->excl = level_size;
-		dstgroup->excl_cmpr = level_size;
-		srcgroup->excl = level_size;
-		srcgroup->excl_cmpr = level_size;
-
+		dstinfo->rfer = srcinfo->rfer;
+		dstinfo->rfer_cmpr = srcinfo->rfer_cmpr;
+		dstinfo->excl = level_size;
+		dstinfo->excl_cmpr = level_size;
+		srcinfo->excl = level_size;
+		srcinfo->excl_cmpr = level_size;
+
+		dstlimits = &dstgroup->mixed_limits;
+		srclimits = &srcgroup->mixed_limits;
 		/* inherit the limit info */
-		dstgroup->lim_flags = srcgroup->lim_flags;
-		dstgroup->max_rfer = srcgroup->max_rfer;
-		dstgroup->max_excl = srcgroup->max_excl;
-		dstgroup->rsv_rfer = srcgroup->rsv_rfer;
-		dstgroup->rsv_excl = srcgroup->rsv_excl;
+		dstlimits->lim_flags = srclimits->lim_flags;
+		dstlimits->max_rfer = srclimits->max_rfer;
+		dstlimits->max_excl = srclimits->max_excl;
+		dstlimits->rsv_rfer = srclimits->rsv_rfer;
+		dstlimits->rsv_excl = srclimits->rsv_excl;
 
 		qgroup_dirty(fs_info, dstgroup);
 		qgroup_dirty(fs_info, srcgroup);
@@ -2393,8 +2470,15 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			goto unlock;
 		}
 
-		dst->rfer = src->rfer - level_size;
-		dst->rfer_cmpr = src->rfer_cmpr - level_size;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		dstinfo = &dst->data_info;
+		srcinfo = &src->data_info;
+
+		dstinfo->rfer = srcinfo->rfer - level_size;
+		dstinfo->rfer_cmpr = srcinfo->rfer_cmpr - level_size;
 		i_qgroups += 2;
 	}
 	for (i = 0; i <  inherit->num_excl_copies; ++i) {
@@ -2409,8 +2493,15 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			goto unlock;
 		}
 
-		dst->excl = src->excl + level_size;
-		dst->excl_cmpr = src->excl_cmpr + level_size;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		dstinfo = &dst->data_info;
+		srcinfo = &src->data_info;
+
+		dstinfo->excl = srcinfo->excl + level_size;
+		dstinfo->excl_cmpr = srcinfo->excl_cmpr + level_size;
 		i_qgroups += 2;
 	}
 
@@ -2425,6 +2516,8 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_info *data_info;
+	struct btrfs_qgroup_limits *mixed_limits;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
@@ -2462,16 +2555,23 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + (s64)qg->rfer + num_bytes >
-		    qg->max_rfer) {
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		data_info = &qgroup->data_info;
+		mixed_limits = &qgroup->mixed_limits;
+
+		if ((mixed_limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
+		    data_info->reserved + (s64)data_info->rfer + num_bytes >
+		    mixed_limits->max_rfer) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
-		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + (s64)qg->excl + num_bytes >
-		    qg->max_excl) {
+		if ((mixed_limits->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
+		    data_info->reserved + (s64)data_info->excl + num_bytes >
+		    mixed_limits->max_excl) {
 			ret = -EDQUOT;
 			goto out;
 		}
@@ -2494,7 +2594,13 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved += num_bytes;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		data_info = &qg->data_info;
+
+		data_info->reserved += num_bytes;
 	}
 
 out:
@@ -2506,6 +2612,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_info *data_info;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -2540,7 +2647,13 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved -= num_bytes;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		data_info = &qg->data_info;
+
+		data_info->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
@@ -2799,15 +2912,22 @@ qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)
 {
 	struct rb_node *n;
 	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_info *data_info;
 
 	spin_lock(&fs_info->qgroup_lock);
 	/* clear all current qgroup tracking information */
 	for (n = rb_first(&fs_info->qgroup_tree); n; n = rb_next(n)) {
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
-		qgroup->rfer = 0;
-		qgroup->rfer_cmpr = 0;
-		qgroup->excl = 0;
-		qgroup->excl_cmpr = 0;
+		/*
+		 * FIXME: use the data_info to store all information currently.
+		 * will seperate the information into data and metadata later.
+		 **/
+		data_info = &qgroup->data_info;
+
+		data_info->rfer = 0;
+		data_info->rfer_cmpr = 0;
+		data_info->excl = 0;
+		data_info->excl_cmpr = 0;
 	}
 	spin_unlock(&fs_info->qgroup_lock);
 }
-- 
1.8.4.2

