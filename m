Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:42473 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812Ab3DYQFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 12:05:07 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, dsterba@suse.cz
Subject: [PATCH v4 1/3] Btrfs: split btrfs_qgroup_account_ref into four functions
Date: Thu, 25 Apr 2013 18:04:50 +0200
Message-Id: <1366905892-7880-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1366905892-7880-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1366905892-7880-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function is separated into a preparation part and the three accounting
steps mentioned in the qgroups documentation. The goal is to make steps two
and three usable by the rescan functionality. A side effect is that the
function is restructured into readable subunits.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/qgroup.c |  253 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 148 insertions(+), 105 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f175471..c50e5a5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1185,6 +1185,144 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static int qgroup_account_ref_step1(struct btrfs_fs_info *fs_info,
+				    struct ulist *roots, struct ulist *tmp,
+				    u64 seq)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct ulist_node *tmp_unode;
+	struct ulist_iterator tmp_uiter;
+	struct btrfs_qgroup *qg;
+	int ret;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(roots, &uiter))) {
+		qg = find_qgroup_rb(fs_info, unode->val);
+		if (!qg)
+			continue;
+
+		ulist_reinit(tmp);
+						/* XXX id not needed */
+		ret = ulist_add(tmp, qg->qgroupid,
+				(u64)(uintptr_t)qg, GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+		ULIST_ITER_INIT(&tmp_uiter);
+		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
+			struct btrfs_qgroup_list *glist;
+
+			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
+			if (qg->refcnt < seq)
+				qg->refcnt = seq + 1;
+			else
+				++qg->refcnt;
+
+			list_for_each_entry(glist, &qg->groups, next_group) {
+				ret = ulist_add(tmp, glist->group->qgroupid,
+						(u64)(uintptr_t)glist->group,
+						GFP_ATOMIC);
+				if (ret < 0)
+					return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int qgroup_account_ref_step2(struct btrfs_fs_info *fs_info,
+				    struct ulist *roots, struct ulist *tmp,
+				    u64 seq, int sgn, u64 num_bytes,
+				    struct btrfs_qgroup *qgroup)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct btrfs_qgroup *qg;
+	struct btrfs_qgroup_list *glist;
+	int ret;
+
+	ulist_reinit(tmp);
+	ret = ulist_add(tmp, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
+	if (ret < 0)
+		return ret;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(tmp, &uiter))) {
+		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
+		if (qg->refcnt < seq) {
+			/* not visited by step 1 */
+			qg->rfer += sgn * num_bytes;
+			qg->rfer_cmpr += sgn * num_bytes;
+			if (roots->nnodes == 0) {
+				qg->excl += sgn * num_bytes;
+				qg->excl_cmpr += sgn * num_bytes;
+			}
+			qgroup_dirty(fs_info, qg);
+		}
+		WARN_ON(qg->tag >= seq);
+		qg->tag = seq;
+
+		list_for_each_entry(glist, &qg->groups, next_group) {
+			ret = ulist_add(tmp, glist->group->qgroupid,
+					(uintptr_t)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int qgroup_account_ref_step3(struct btrfs_fs_info *fs_info,
+				    struct ulist *roots, struct ulist *tmp,
+				    u64 seq, int sgn, u64 num_bytes)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct btrfs_qgroup *qg;
+	struct ulist_node *tmp_unode;
+	struct ulist_iterator tmp_uiter;
+	int ret;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(roots, &uiter))) {
+		qg = find_qgroup_rb(fs_info, unode->val);
+		if (!qg)
+			continue;
+
+		ulist_reinit(tmp);
+		ret = ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+
+		ULIST_ITER_INIT(&tmp_uiter);
+		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
+			struct btrfs_qgroup_list *glist;
+
+			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
+			if (qg->tag == seq)
+				continue;
+
+			if (qg->refcnt - seq == roots->nnodes) {
+				qg->excl -= sgn * num_bytes;
+				qg->excl_cmpr -= sgn * num_bytes;
+				qgroup_dirty(fs_info, qg);
+			}
+
+			list_for_each_entry(glist, &qg->groups, next_group) {
+				ret = ulist_add(tmp, glist->group->qgroupid,
+						(uintptr_t)glist->group,
+						GFP_ATOMIC);
+				if (ret < 0)
+					return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
 /*
  * btrfs_qgroup_account_ref is called for every ref that is added to or deleted
  * from the fs. First, all roots referencing the extent are searched, and
@@ -1200,10 +1338,8 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root;
 	u64 ref_root;
 	struct btrfs_qgroup *qgroup;
-	struct ulist_node *unode;
 	struct ulist *roots = NULL;
 	struct ulist *tmp = NULL;
-	struct ulist_iterator uiter;
 	u64 seq;
 	int ret = 0;
 	int sgn;
@@ -1285,119 +1421,26 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	seq = fs_info->qgroup_seq;
 	fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
 
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(roots, &uiter))) {
-		struct ulist_node *tmp_unode;
-		struct ulist_iterator tmp_uiter;
-		struct btrfs_qgroup *qg;
-
-		qg = find_qgroup_rb(fs_info, unode->val);
-		if (!qg)
-			continue;
-
-		ulist_reinit(tmp);
-						/* XXX id not needed */
-		ret = ulist_add(tmp, qg->qgroupid,
-				(u64)(uintptr_t)qg, GFP_ATOMIC);
-		if (ret < 0)
-			goto unlock;
-		ULIST_ITER_INIT(&tmp_uiter);
-		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
-			struct btrfs_qgroup_list *glist;
-
-			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
-			if (qg->refcnt < seq)
-				qg->refcnt = seq + 1;
-			else
-				++qg->refcnt;
-
-			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						(u64)(uintptr_t)glist->group,
-						GFP_ATOMIC);
-				if (ret < 0)
-					goto unlock;
-			}
-		}
-	}
+	ret = qgroup_account_ref_step1(fs_info, roots, tmp, seq);
+	if (ret)
+		goto unlock;
 
 	/*
 	 * step 2: walk from the new root
 	 */
-	ulist_reinit(tmp);
-	ret = ulist_add(tmp, qgroup->qgroupid,
-			(uintptr_t)qgroup, GFP_ATOMIC);
-	if (ret < 0)
+	ret = qgroup_account_ref_step2(fs_info, roots, tmp, seq, sgn,
+				       node->num_bytes, qgroup);
+	if (ret)
 		goto unlock;
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(tmp, &uiter))) {
-		struct btrfs_qgroup *qg;
-		struct btrfs_qgroup_list *glist;
-
-		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
-		if (qg->refcnt < seq) {
-			/* not visited by step 1 */
-			qg->rfer += sgn * node->num_bytes;
-			qg->rfer_cmpr += sgn * node->num_bytes;
-			if (roots->nnodes == 0) {
-				qg->excl += sgn * node->num_bytes;
-				qg->excl_cmpr += sgn * node->num_bytes;
-			}
-			qgroup_dirty(fs_info, qg);
-		}
-		WARN_ON(qg->tag >= seq);
-		qg->tag = seq;
-
-		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(tmp, glist->group->qgroupid,
-					(uintptr_t)glist->group, GFP_ATOMIC);
-			if (ret < 0)
-				goto unlock;
-		}
-	}
 
 	/*
 	 * step 3: walk again from old refs
 	 */
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(roots, &uiter))) {
-		struct btrfs_qgroup *qg;
-		struct ulist_node *tmp_unode;
-		struct ulist_iterator tmp_uiter;
-
-		qg = find_qgroup_rb(fs_info, unode->val);
-		if (!qg)
-			continue;
-
-		ulist_reinit(tmp);
-		ret = ulist_add(tmp, qg->qgroupid,
-				(uintptr_t)qg, GFP_ATOMIC);
-		if (ret < 0)
-			goto unlock;
-		ULIST_ITER_INIT(&tmp_uiter);
-		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
-			struct btrfs_qgroup_list *glist;
-
-			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
-			if (qg->tag == seq)
-				continue;
-
-			if (qg->refcnt - seq == roots->nnodes) {
-				qg->excl -= sgn * node->num_bytes;
-				qg->excl_cmpr -= sgn * node->num_bytes;
-				qgroup_dirty(fs_info, qg);
-			}
+	ret = qgroup_account_ref_step3(fs_info, roots, tmp, seq, sgn,
+				       node->num_bytes);
+	if (ret)
+		goto unlock;
 
-			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						(uintptr_t)glist->group,
-						GFP_ATOMIC);
-				if (ret < 0)
-					goto unlock;
-			}
-		}
-	}
-	ret = 0;
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
 	ulist_free(roots);
-- 
1.7.1

