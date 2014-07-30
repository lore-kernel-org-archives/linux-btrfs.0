Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbaG3RtP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 13:49:15 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: Use void * for ulist aux data
Date: Wed, 30 Jul 2014 19:49:14 +0200
Message-Id: <1406742554-27581-1-git-send-email-tiwai@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since all users of ulist_add() and ulist_add_merge() pass the pointer
of objects to aux, replace the aux data type itself to void pointer,
so that the caller can pass without ugly int/pointer casts.

Along with the replacements, kill u64/ptr conversion macros and
ulist_add_merge_ptr() wrapper functions that are no longer used.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

This is a cleanup patch to be applied on top of my first patch ("Btrfs:
Fix memory corruption by ulist_add_merge() on 32bit arch", v1, not v2).

 fs/btrfs/backref.c | 31 ++++++++++++---------------
 fs/btrfs/qgroup.c  | 62 +++++++++++++++++++++++-------------------------------
 fs/btrfs/ulist.c   |  6 +++---
 fs/btrfs/ulist.h   | 23 ++++----------------
 4 files changed, 47 insertions(+), 75 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index d7a24620a963..3dcadebc04f8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -236,7 +236,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 
 	if (level != 0) {
 		eb = path->nodes[level];
-		ret = ulist_add(parents, eb->start, 0, GFP_NOFS);
+		ret = ulist_add(parents, eb->start, NULL, GFP_NOFS);
 		if (ret < 0)
 			return ret;
 		return 0;
@@ -276,8 +276,8 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			}
 			if (ret > 0)
 				goto next;
-			ret = ulist_add_merge_ptr(parents, eb->start,
-						  eie, (void **)&old, GFP_NOFS);
+			ret = ulist_add_merge(parents, eb->start, eie,
+					      (void **)&old, GFP_NOFS);
 			if (ret < 0)
 				break;
 			if (!ret && extent_item_pos) {
@@ -420,8 +420,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		ULIST_ITER_INIT(&uiter);
 		node = ulist_next(parents, &uiter);
 		ref->parent = node ? node->val : 0;
-		ref->inode_list = node ?
-			(struct extent_inode_elem *)(uintptr_t)node->aux : NULL;
+		ref->inode_list = node ? node->aux : NULL;
 
 		/* additional parents require new refs being added here */
 		while ((node = ulist_next(parents, &uiter))) {
@@ -433,8 +432,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			}
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
-			new_ref->inode_list = (struct extent_inode_elem *)
-							(uintptr_t)node->aux;
+			new_ref->inode_list = node->aux;
 			list_add(&new_ref->list, &ref->list);
 		}
 		ulist_reinit(parents);
@@ -982,7 +980,7 @@ again:
 		WARN_ON(ref->count < 0);
 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
-			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
+			ret = ulist_add(roots, ref->root_id, NULL, GFP_NOFS);
 			if (ret < 0)
 				goto out;
 		}
@@ -1007,9 +1005,9 @@ again:
 					goto out;
 				ref->inode_list = eie;
 			}
-			ret = ulist_add_merge_ptr(refs, ref->parent,
-						  ref->inode_list,
-						  (void **)&eie, GFP_NOFS);
+			ret = ulist_add_merge(refs, ref->parent,
+					      ref->inode_list,
+					      (void **)&eie, GFP_NOFS);
 			if (ret < 0)
 				goto out;
 			if (!ret && extent_item_pos) {
@@ -1056,9 +1054,9 @@ static void free_leaf_list(struct ulist *blocks)
 	while ((node = ulist_next(blocks, &uiter))) {
 		if (!node->aux)
 			continue;
-		eie = (struct extent_inode_elem *)(uintptr_t)node->aux;
+		eie = node->aux;
 		free_inode_elem_list(eie);
-		node->aux = 0;
+		node->aux = NULL;
 	}
 
 	ulist_free(blocks);
@@ -1563,11 +1561,10 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 			break;
 		ULIST_ITER_INIT(&root_uiter);
 		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
-			pr_debug("root %llu references leaf %llu, data list "
-				 "%#llx\n", root_node->val, ref_node->val,
+			pr_debug("root %llu references leaf %llu, data list %p\n",
+				 root_node->val, ref_node->val,
 				 ref_node->aux);
-			ret = iterate_leaf_refs((struct extent_inode_elem *)
-						(uintptr_t)ref_node->aux,
+			ret = iterate_leaf_refs(ref_node->aux,
 						root_node->val,
 						extent_item_objectid,
 						iterate, ctx);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 98cb6b2630f9..dc2665cb3f1b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -99,9 +99,6 @@ struct btrfs_qgroup_list {
 	struct btrfs_qgroup *member;
 };
 
-#define ptr_to_u64(x) ((u64)(uintptr_t)x)
-#define u64_to_ptr(x) ((struct btrfs_qgroup *)(uintptr_t)x)
-
 static int
 qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 		   int init_flags);
@@ -1353,7 +1350,7 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	/* Get all of the parent groups that contain this qgroup */
 	list_for_each_entry(glist, &qgroup->groups, next_group) {
 		ret = ulist_add(tmp, glist->group->qgroupid,
-				ptr_to_u64(glist->group), GFP_ATOMIC);
+				glist->group, GFP_ATOMIC);
 		if (ret < 0)
 			goto out;
 	}
@@ -1361,7 +1358,7 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	/* Iterate all of the parents and adjust their reference counts */
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
-		qgroup = u64_to_ptr(unode->aux);
+		qgroup = unode->aux;
 		qgroup->rfer += sign * oper->num_bytes;
 		qgroup->rfer_cmpr += sign * oper->num_bytes;
 		qgroup->excl += sign * oper->num_bytes;
@@ -1373,7 +1370,7 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		/* Add any parents of the parents */
 		list_for_each_entry(glist, &qgroup->groups, next_group) {
 			ret = ulist_add(tmp, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				goto out;
 		}
@@ -1421,18 +1418,17 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
 		(*old_roots)++;
 
 		ulist_reinit(tmp);
-		ret = ulist_add(qgroups, qg->qgroupid, ptr_to_u64(qg),
-				GFP_ATOMIC);
+		ret = ulist_add(qgroups, qg->qgroupid, qg, GFP_ATOMIC);
 		if (ret < 0)
 			return ret;
-		ret = ulist_add(tmp, qg->qgroupid, ptr_to_u64(qg), GFP_ATOMIC);
+		ret = ulist_add(tmp, qg->qgroupid, qg, GFP_ATOMIC);
 		if (ret < 0)
 			return ret;
 		ULIST_ITER_INIT(&tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
 
-			qg = u64_to_ptr(tmp_unode->aux);
+			qg = tmp_unode->aux;
 			/*
 			 * We use this sequence number to keep from having to
 			 * run the whole list and 0 out the refcnt every time.
@@ -1458,13 +1454,11 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
 				qg->new_refcnt++;
 			list_for_each_entry(glist, &qg->groups, next_group) {
 				ret = ulist_add(qgroups, glist->group->qgroupid,
-						ptr_to_u64(glist->group),
-						GFP_ATOMIC);
+						glist->group, GFP_ATOMIC);
 				if (ret < 0)
 					return ret;
 				ret = ulist_add(tmp, glist->group->qgroupid,
-						ptr_to_u64(glist->group),
-						GFP_ATOMIC);
+						glist->group, GFP_ATOMIC);
 				if (ret < 0)
 					return ret;
 			}
@@ -1513,8 +1507,7 @@ static int qgroup_account_deleted_refs(struct btrfs_fs_info *fs_info,
 		qg = find_qgroup_rb(fs_info, tmp_oper->ref_root);
 		if (!qg)
 			goto next;
-		ret = ulist_add(qgroups, qg->qgroupid, ptr_to_u64(qg),
-				GFP_ATOMIC);
+		ret = ulist_add(qgroups, qg->qgroupid, qg, GFP_ATOMIC);
 		if (ret) {
 			if (ret < 0)
 				return ret;
@@ -1529,8 +1522,7 @@ static int qgroup_account_deleted_refs(struct btrfs_fs_info *fs_info,
 			 * seen this qgroup and we can bump the old_roots.
 			 */
 			(*old_roots)++;
-			ret = ulist_add(tmp, qg->qgroupid, ptr_to_u64(qg),
-					GFP_ATOMIC);
+			ret = ulist_add(tmp, qg->qgroupid, qg, GFP_ATOMIC);
 			if (ret < 0)
 				return ret;
 		}
@@ -1548,7 +1540,7 @@ next:
 	while ((unode = ulist_next(tmp, &uiter))) {
 		struct btrfs_qgroup_list *glist;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 		if (qg->old_refcnt < seq)
 			qg->old_refcnt = seq + 1;
 		else
@@ -1559,11 +1551,11 @@ next:
 			qg->new_refcnt++;
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(qgroups, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				return ret;
 			ret = ulist_add(tmp, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				return ret;
 		}
@@ -1584,19 +1576,17 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	ulist_reinit(tmp);
-	ret = ulist_add(qgroups, qgroup->qgroupid, ptr_to_u64(qgroup),
-			GFP_ATOMIC);
+	ret = ulist_add(qgroups, qgroup->qgroupid, qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		return ret;
-	ret = ulist_add(tmp, qgroup->qgroupid, ptr_to_u64(qgroup),
-			GFP_ATOMIC);
+	ret = ulist_add(tmp, qgroup->qgroupid, qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		return ret;
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		struct btrfs_qgroup_list *glist;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 		if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED) {
 			if (qg->new_refcnt < seq)
 				qg->new_refcnt = seq + 1;
@@ -1610,11 +1600,11 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
 		}
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(tmp, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				return ret;
 			ret = ulist_add(qgroups, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				return ret;
 		}
@@ -1639,7 +1629,7 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 	while ((unode = ulist_next(qgroups, &uiter))) {
 		bool dirty = false;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 		/*
 		 * Wasn't referenced before but is now, add to the reference
 		 * counters.
@@ -2221,7 +2211,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	 */
 	ulist_reinit(fs_info->qgroup_ulist);
 	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
-			(uintptr_t)qgroup, GFP_ATOMIC);
+			qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		goto out;
 	ULIST_ITER_INIT(&uiter);
@@ -2229,7 +2219,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 		    qg->reserved + (s64)qg->rfer + num_bytes >
@@ -2248,7 +2238,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
 					glist->group->qgroupid,
-					(uintptr_t)glist->group, GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				goto out;
 		}
@@ -2261,7 +2251,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 
 		qg->reserved += num_bytes;
 	}
@@ -2299,7 +2289,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 	ulist_reinit(fs_info->qgroup_ulist);
 	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
-			(uintptr_t)qgroup, GFP_ATOMIC);
+			qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		goto out;
 	ULIST_ITER_INIT(&uiter);
@@ -2307,14 +2297,14 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 
 		qg->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
 					glist->group->qgroupid,
-					(uintptr_t)glist->group, GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				goto out;
 		}
diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 840a38b2778a..48ac43c2e89a 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -174,13 +174,13 @@ static int ulist_rbtree_insert(struct ulist *ulist, struct ulist_node *ins)
  * In case of allocation failure -ENOMEM is returned and the ulist stays
  * unaltered.
  */
-int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask)
+int ulist_add(struct ulist *ulist, u64 val, void *aux, gfp_t gfp_mask)
 {
 	return ulist_add_merge(ulist, val, aux, NULL, gfp_mask);
 }
 
-int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
-		    u64 *old_aux, gfp_t gfp_mask)
+int ulist_add_merge(struct ulist *ulist, u64 val, void *aux,
+		    void **old_aux, gfp_t gfp_mask)
 {
 	int ret;
 	struct ulist_node *node;
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 695fc2bac680..1088a55c6655 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -30,7 +30,7 @@ struct ulist_iterator {
  */
 struct ulist_node {
 	u64 val;		/* value to store */
-	u64 aux;		/* auxiliary value saved along with the val */
+	void *aux;		/* auxiliary value saved along with the val */
 
 #ifdef CONFIG_BTRFS_DEBUG
 	int seqnum;		/* sequence number this node is added */
@@ -54,24 +54,9 @@ void ulist_init(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask);
-int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
-		    u64 *old_aux, gfp_t gfp_mask);
-
-/* just like ulist_add_merge() but take a pointer for the aux data */
-static inline int ulist_add_merge_ptr(struct ulist *ulist, u64 val, void *aux,
-				      void **old_aux, gfp_t gfp_mask)
-{
-#if BITS_PER_LONG == 32
-	u64 old64 = (uintptr_t)*old_aux;
-	int ret = ulist_add_merge(ulist, val, (uintptr_t)aux, &old64, gfp_mask);
-	*old_aux = (void *)((uintptr_t)old64);
-	return ret;
-#else
-	return ulist_add_merge(ulist, val, (u64)aux, (u64 *)old_aux, gfp_mask)
-#endif
-}
-
+int ulist_add(struct ulist *ulist, u64 val, void *aux, gfp_t gfp_mask);
+int ulist_add_merge(struct ulist *ulist, u64 val, void *aux,
+		    void **old_aux, gfp_t gfp_mask);
 struct ulist_node *ulist_next(struct ulist *ulist,
 			      struct ulist_iterator *uiter);
 
-- 
2.0.1

