Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51320 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755212AbbBJK1w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:52 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAR6d5000985
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:27:06 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 7/7] btrfs: qgroup: fix a bug when type of parent is different with child's.
Date: Tue, 10 Feb 2015 18:24:22 +0800
Message-ID: <1423563862-9151-12-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the type of a record is not considered, we currently ignore it at all.
But this operation may be considered by his parent.

This patch fix this problem, it record the operation and only accounting it
when current type cover the operation type in iteration.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 100 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 54 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d4ad565..103a908 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1457,8 +1457,6 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	qgroup = find_qgroup_rb(fs_info, oper->ref_root);
 	if (!qgroup)
 		goto out;
-	if (!(qgroup->type & oper->quota_type))
-		goto out;
 	switch (oper->type) {
 	case BTRFS_QGROUP_OPER_ADD_EXCL:
 		sign = 1;
@@ -1469,16 +1467,19 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	default:
 		ASSERT(0);
 	}
-	qgroup->rfer += sign * oper->num_bytes;
-	qgroup->rfer_cmpr += sign * oper->num_bytes;
 
-	WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
-	qgroup->excl += sign * oper->num_bytes;
-	qgroup->excl_cmpr += sign * oper->num_bytes;
-	if (sign > 0)
-		qgroup->reserved -= oper->num_bytes;
+	if ((qgroup->type & oper->quota_type)) {
+		qgroup->rfer += sign * oper->num_bytes;
+		qgroup->rfer_cmpr += sign * oper->num_bytes;
+
+		WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
+		qgroup->excl += sign * oper->num_bytes;
+		qgroup->excl_cmpr += sign * oper->num_bytes;
+		if (sign > 0)
+			qgroup->reserved -= oper->num_bytes;
 
-	qgroup_dirty(fs_info, qgroup);
+		qgroup_dirty(fs_info, qgroup);
+	}
 
 	/* Get all of the parent groups that contain this qgroup */
 	list_for_each_entry(glist, &qgroup->groups, next_group) {
@@ -1492,14 +1493,18 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		qgroup = u64_to_ptr(unode->aux);
-		qgroup->rfer += sign * oper->num_bytes;
-		qgroup->rfer_cmpr += sign * oper->num_bytes;
-		WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
-		qgroup->excl += sign * oper->num_bytes;
-		if (sign > 0)
-			qgroup->reserved -= oper->num_bytes;
-		qgroup->excl_cmpr += sign * oper->num_bytes;
-		qgroup_dirty(fs_info, qgroup);
+
+		if ((qgroup->type & oper->quota_type)) {
+			qgroup->rfer += sign * oper->num_bytes;
+			qgroup->rfer_cmpr += sign * oper->num_bytes;
+			WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
+			qgroup->excl += sign * oper->num_bytes;
+			if (sign > 0)
+				qgroup->reserved -= oper->num_bytes;
+			qgroup->excl_cmpr += sign * oper->num_bytes;
+			qgroup_dirty(fs_info, qgroup);
+
+		}
 
 		/* Add any parents of the parents */
 		list_for_each_entry(glist, &qgroup->groups, next_group) {
@@ -1951,8 +1956,7 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 	qgroup = find_qgroup_rb(fs_info, oper->ref_root);
 	if (!qgroup)
 		goto out;
-	if (!(qgroup->type & oper->quota_type))
-		goto out;
+
 	seq = fs_info->qgroup_seq;
 
 	/*
@@ -2079,12 +2083,12 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	qg = find_qgroup_rb(fs_info, root_obj);
 	if (!qg)
 		goto out_unlock;
-	if (!(qg->type & oper->quota_type))
-		goto out_unlock;
 
-	qg->excl += oper->num_bytes;
-	qg->excl_cmpr += oper->num_bytes;
-	qgroup_dirty(fs_info, qg);
+	if ((qg->type & oper->quota_type)) {
+		qg->excl += oper->num_bytes;
+		qg->excl_cmpr += oper->num_bytes;
+		qgroup_dirty(fs_info, qg);
+	}
 
 	/*
 	 * Adjust counts for parent groups. First we find all
@@ -2103,9 +2107,12 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(parents, &uiter))) {
 		qg = u64_to_ptr(unode->aux);
-		qg->excl += oper->num_bytes;
-		qg->excl_cmpr += oper->num_bytes;
-		qgroup_dirty(fs_info, qg);
+
+		if ((qg->type & oper->quota_type)) {
+			qg->excl += oper->num_bytes;
+			qg->excl_cmpr += oper->num_bytes;
+			qgroup_dirty(fs_info, qg);
+		}
 
 		/* Add any parents of the parents */
 		list_for_each_entry(glist, &qg->groups, next_group) {
@@ -2492,8 +2499,6 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type)
 	if (!qgroup)
 		goto out;
 
-	if (!(qgroup->type & type))
-		goto out;
 	/*
 	 * in a first step, we check all affected qgroups if any limits would
 	 * be exceeded
@@ -2510,18 +2515,20 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type)
 
 		qg = u64_to_ptr(unode->aux);
 
-		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + (s64)qg->rfer + num_bytes >
-		    qg->max_rfer) {
-			ret = -EDQUOT;
-			goto out;
-		}
+		if (qg->type & type) {
+			if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
+			    qg->reserved + (s64)qg->rfer + num_bytes >
+			    qg->max_rfer) {
+				ret = -EDQUOT;
+				goto out;
+			}
 
-		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + (s64)qg->excl + num_bytes >
-		    qg->max_excl) {
-			ret = -EDQUOT;
-			goto out;
+			if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
+			    qg->reserved + (s64)qg->excl + num_bytes >
+			    qg->max_excl) {
+				ret = -EDQUOT;
+				goto out;
+			}
 		}
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
@@ -2542,7 +2549,9 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved += num_bytes;
+		if (qg->type & type) {
+			qg->reserved += num_bytes;
+		}
 	}
 
 out:
@@ -2576,9 +2585,6 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes, u8 type)
 	if (!qgroup)
 		goto out;
 
-	if (!(qgroup->type & type))
-		goto out;
-
 	ulist_reinit(fs_info->qgroup_ulist);
 	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
 			(uintptr_t)qgroup, GFP_ATOMIC);
@@ -2591,7 +2597,9 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes, u8 type)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved -= num_bytes;
+		if (qg->type & type) {
+			qg->reserved -= num_bytes;
+		}
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
-- 
1.8.4.2

