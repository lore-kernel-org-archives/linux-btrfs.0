Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14022 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbbCWIKs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:48 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89iVF012370
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 11/11] btrfs: qgroup: Cleanup the unneeded codes.
Date: Mon, 23 Mar 2015 16:08:37 +0800
Message-ID: <1427098117-25152-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup the unneeded codes only for special cases.
Since the new, more generic but simpler codes are already here, use
them.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
It feels so good just pressing 'd' in vim!!!
---
 fs/btrfs/qgroup.c | 249 ------------------------------------------------------
 1 file changed, 249 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 16240e6..88abd13 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1564,222 +1564,6 @@ static int qgroup_update_refcnt(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
-				  u64 root_to_skip, struct ulist *tmp,
-				  struct ulist *roots, struct ulist *qgroups,
-				  u64 seq, int *old_roots, int rescan)
-{
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-	struct ulist_node *tmp_unode;
-	struct ulist_iterator tmp_uiter;
-	struct btrfs_qgroup *qg;
-	int ret;
-
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(roots, &uiter))) {
-		/* We don't count our current root here */
-		if (unode->val == root_to_skip)
-			continue;
-		qg = find_qgroup_rb(fs_info, unode->val);
-		if (!qg)
-			continue;
-		/*
-		 * We could have a pending removal of this same ref so we may
-		 * not have actually found our ref root when doing
-		 * btrfs_find_all_roots, so we need to keep track of how many
-		 * old roots we find in case we removed ours and added a
-		 * different one at the same time.  I don't think this could
-		 * happen in practice but that sort of thinking leads to pain
-		 * and suffering and to the dark side.
-		 */
-		(*old_roots)++;
-
-		ulist_reinit(tmp);
-		ret = ulist_add(qgroups, qg->qgroupid, ptr_to_u64(qg),
-				GFP_ATOMIC);
-		if (ret < 0)
-			return ret;
-		ret = ulist_add(tmp, qg->qgroupid, ptr_to_u64(qg), GFP_ATOMIC);
-		if (ret < 0)
-			return ret;
-		ULIST_ITER_INIT(&tmp_uiter);
-		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
-			struct btrfs_qgroup_list *glist;
-			int mod;
-
-			qg = u64_to_ptr(tmp_unode->aux);
-			/*
-			 * We use this sequence number to keep from having to
-			 * run the whole list and 0 out the refcnt every time.
-			 * We basically use sequnce as the known 0 count and
-			 * then add 1 everytime we see a qgroup.  This is how we
-			 * get how many of the roots actually point up to the
-			 * upper level qgroups in order to determine exclusive
-			 * counts.
-			 *
-			 * For rescan none of the extent is recorded before so
-			 * we just don't add old_refcnt.
-			 */
-			if (rescan)
-				mod = 0;
-			else
-				mod = 1;
-			btrfs_qgroup_update_old_refcnt(qg, seq, mod);
-			btrfs_qgroup_update_new_refcnt(qg, seq, 1);
-			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(qgroups, glist->group->qgroupid,
-						ptr_to_u64(glist->group),
-						GFP_ATOMIC);
-				if (ret < 0)
-					return ret;
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						ptr_to_u64(glist->group),
-						GFP_ATOMIC);
-				if (ret < 0)
-					return ret;
-			}
-		}
-	}
-	return 0;
-}
-
-/*
- * We need to walk forward in our operation tree and account for any roots that
- * were deleted after we made this operation.
- */
-static int qgroup_account_deleted_refs(struct btrfs_fs_info *fs_info,
-				       struct btrfs_qgroup_operation *oper,
-				       struct ulist *tmp,
-				       struct ulist *qgroups, u64 seq,
-				       int *old_roots)
-{
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-	struct btrfs_qgroup *qg;
-	struct btrfs_qgroup_operation *tmp_oper;
-	struct rb_node *n;
-	int ret;
-
-	ulist_reinit(tmp);
-
-	/*
-	 * We only walk forward in the tree since we're only interested in
-	 * removals that happened _after_  our operation.
-	 */
-	spin_lock(&fs_info->qgroup_op_lock);
-	n = rb_next(&oper->n);
-	spin_unlock(&fs_info->qgroup_op_lock);
-	if (!n)
-		return 0;
-	tmp_oper = rb_entry(n, struct btrfs_qgroup_operation, n);
-	while (tmp_oper->bytenr == oper->bytenr) {
-		/*
-		 * If it's not a removal we don't care, additions work out
-		 * properly with our refcnt tracking.
-		 */
-		if (tmp_oper->type != BTRFS_QGROUP_OPER_SUB_SHARED &&
-		    tmp_oper->type != BTRFS_QGROUP_OPER_SUB_EXCL)
-			goto next;
-		qg = find_qgroup_rb(fs_info, tmp_oper->ref_root);
-		if (!qg)
-			goto next;
-		ret = ulist_add(qgroups, qg->qgroupid, ptr_to_u64(qg),
-				GFP_ATOMIC);
-		if (ret) {
-			if (ret < 0)
-				return ret;
-			/*
-			 * We only want to increase old_roots if this qgroup is
-			 * not already in the list of qgroups.  If it is already
-			 * there then that means it must have been re-added or
-			 * the delete will be discarded because we had an
-			 * existing ref that we haven't looked up yet.  In this
-			 * case we don't want to increase old_roots.  So if ret
-			 * == 1 then we know that this is the first time we've
-			 * seen this qgroup and we can bump the old_roots.
-			 */
-			(*old_roots)++;
-			ret = ulist_add(tmp, qg->qgroupid, ptr_to_u64(qg),
-					GFP_ATOMIC);
-			if (ret < 0)
-				return ret;
-		}
-next:
-		spin_lock(&fs_info->qgroup_op_lock);
-		n = rb_next(&tmp_oper->n);
-		spin_unlock(&fs_info->qgroup_op_lock);
-		if (!n)
-			break;
-		tmp_oper = rb_entry(n, struct btrfs_qgroup_operation, n);
-	}
-
-	/* Ok now process the qgroups we found */
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(tmp, &uiter))) {
-		struct btrfs_qgroup_list *glist;
-
-		qg = u64_to_ptr(unode->aux);
-		btrfs_qgroup_update_old_refcnt(qg, seq, 1);
-		btrfs_qgroup_update_new_refcnt(qg, seq, 1);
-		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(qgroups, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
-			if (ret < 0)
-				return ret;
-			ret = ulist_add(tmp, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
-			if (ret < 0)
-				return ret;
-		}
-	}
-	return 0;
-}
-
-/* Add refcnt for the newly added reference. */
-static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
-				  struct btrfs_qgroup_operation *oper,
-				  struct btrfs_qgroup *qgroup,
-				  struct ulist *tmp, struct ulist *qgroups,
-				  u64 seq)
-{
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-	struct btrfs_qgroup *qg;
-	int ret;
-
-	ulist_reinit(tmp);
-	ret = ulist_add(qgroups, qgroup->qgroupid, ptr_to_u64(qgroup),
-			GFP_ATOMIC);
-	if (ret < 0)
-		return ret;
-	ret = ulist_add(tmp, qgroup->qgroupid, ptr_to_u64(qgroup),
-			GFP_ATOMIC);
-	if (ret < 0)
-		return ret;
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(tmp, &uiter))) {
-		struct btrfs_qgroup_list *glist;
-
-		qg = u64_to_ptr(unode->aux);
-		if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED)
-			btrfs_qgroup_update_new_refcnt(qg, seq, 1);
-		else
-			btrfs_qgroup_update_old_refcnt(qg, seq, 1);
-		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(tmp, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
-			if (ret < 0)
-				return ret;
-			ret = ulist_add(qgroups, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
-			if (ret < 0)
-				return ret;
-		}
-	}
-	return 0;
-}
-
 /*
  * This adjusts the counters for all referenced qgroups if need be.
  */
@@ -1858,39 +1642,6 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 }
 
 /*
- * If we removed a data extent and there were other references for that bytenr
- * then we need to lookup all referenced roots to make sure we still don't
- * reference this bytenr.  If we do then we can just discard this operation.
- */
-static int check_existing_refs(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info,
-			       struct btrfs_qgroup_operation *oper)
-{
-	struct ulist *roots = NULL;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-	int ret = 0;
-
-	ret = btrfs_find_all_roots(trans, fs_info, NULL, oper->bytenr,
-				   oper->elem.seq, &roots, 0);
-	if (ret < 0)
-		return ret;
-	ret = 0;
-
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(roots, &uiter))) {
-		if (unode->val == oper->ref_root) {
-			ret = 1;
-			break;
-		}
-	}
-	ulist_free(roots);
-	btrfs_put_tree_mod_seq(fs_info, &oper->elem);
-
-	return ret;
-}
-
-/*
  * If we share a reference across multiple roots then we may need to adjust
  * various qgroups referenced and exclusive counters.  The basic premise is this
  *
-- 
2.3.3

