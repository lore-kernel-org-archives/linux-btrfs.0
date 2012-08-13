Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:47593 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab2HMJXF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 05:23:05 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix gcc warnings for 32bit compiles
Date: Mon, 13 Aug 2012 10:52:38 +0200
Message-Id: <1344847958-3572-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c   |   25 +++++++++++++------------
 fs/btrfs/file-item.c |    2 +-
 fs/btrfs/qgroup.c    |   32 ++++++++++++++++----------------
 fs/btrfs/send.c      |    4 ++--
 4 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 6655ca6..e600857 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -231,7 +231,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			}
 			if (!ret) {
 				ret = ulist_add(parents, eb->start,
-						(u64)eie, GFP_NOFS);
+						(uintptr_t)eie, GFP_NOFS);
 				if (ret < 0)
 					break;
 				if (!extent_item_pos) {
@@ -363,8 +363,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		ULIST_ITER_INIT(&uiter);
 		node = ulist_next(parents, &uiter);
 		ref->parent = node ? node->val : 0;
-		ref->inode_list =
-			node ? (struct extent_inode_elem *)node->aux : 0;
+		ref->inode_list = node ?
+			(struct extent_inode_elem *)(uintptr_t)node->aux : 0;
 
 		/* additional parents require new refs being added here */
 		while ((node = ulist_next(parents, &uiter))) {
@@ -375,8 +375,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			}
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
-			new_ref->inode_list =
-					(struct extent_inode_elem *)node->aux;
+			new_ref->inode_list = (struct extent_inode_elem *)
+							(uintptr_t)node->aux;
 			list_add(&new_ref->list, &ref->list);
 		}
 		ulist_reinit(parents);
@@ -914,7 +914,7 @@ again:
 				free_extent_buffer(eb);
 			}
 			ret = ulist_add_merge(refs, ref->parent,
-					      (u64)ref->inode_list,
+					      (uintptr_t)ref->inode_list,
 					      (u64 *)&eie, GFP_NOFS);
 			if (!ret && extent_item_pos) {
 				/*
@@ -959,7 +959,7 @@ static void free_leaf_list(struct ulist *blocks)
 	while ((node = ulist_next(blocks, &uiter))) {
 		if (!node->aux)
 			continue;
-		eie = (struct extent_inode_elem *)node->aux;
+		eie = (struct extent_inode_elem *)(uintptr_t)node->aux;
 		for (; eie; eie = eie_next) {
 			eie_next = eie->next;
 			kfree(eie);
@@ -1405,11 +1405,12 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
 			pr_debug("root %llu references leaf %llu, data list "
 				 "%#llx\n", root_node->val, ref_node->val,
-				 ref_node->aux);
-			ret = iterate_leaf_refs(
-				(struct extent_inode_elem *)ref_node->aux,
-				root_node->val, extent_item_objectid,
-				iterate, ctx);
+				 (long long)ref_node->aux);
+			ret = iterate_leaf_refs((struct extent_inode_elem *)
+						(uintptr_t)ref_node->aux,
+						root_node->val,
+						extent_item_objectid,
+						iterate, ctx);
 		}
 		ulist_free(roots);
 		roots = NULL;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 857d93c..54f0335 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -25,7 +25,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 
-#define __MAX_CSUM_ITEMS(r, size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
+#define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
 				   sizeof(struct btrfs_item) * 2) / \
 				  size) - 1))
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1bc33c1..90619cc 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1145,12 +1145,12 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 		ulist_reinit(tmp);
 						/* XXX id not needed */
-		ulist_add(tmp, qg->qgroupid, (u64)qg, GFP_ATOMIC);
+		ulist_add(tmp, qg->qgroupid, (u64)(uintptr_t)qg, GFP_ATOMIC);
 		ULIST_ITER_INIT(&tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
 
-			qg = (struct btrfs_qgroup *)tmp_unode->aux;
+			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
 			if (qg->refcnt < seq)
 				qg->refcnt = seq + 1;
 			else
@@ -1158,7 +1158,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 			list_for_each_entry(glist, &qg->groups, next_group) {
 				ulist_add(tmp, glist->group->qgroupid,
-					  (u64)glist->group,
+					  (u64)(uintptr_t)glist->group,
 					  GFP_ATOMIC);
 			}
 		}
@@ -1168,13 +1168,13 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	 * step 2: walk from the new root
 	 */
 	ulist_reinit(tmp);
-	ulist_add(tmp, qgroup->qgroupid, (u64)qgroup, GFP_ATOMIC);
+	ulist_add(tmp, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
-		qg = (struct btrfs_qgroup *)unode->aux;
+		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
 		if (qg->refcnt < seq) {
 			/* not visited by step 1 */
 			qg->rfer += sgn * node->num_bytes;
@@ -1190,7 +1190,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ulist_add(tmp, glist->group->qgroupid,
-				  (u64)glist->group, GFP_ATOMIC);
+				  (uintptr_t)glist->group, GFP_ATOMIC);
 		}
 	}
 
@@ -1208,12 +1208,12 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 			continue;
 
 		ulist_reinit(tmp);
-		ulist_add(tmp, qg->qgroupid, (u64)qg, GFP_ATOMIC);
+		ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
 		ULIST_ITER_INIT(&tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
 
-			qg = (struct btrfs_qgroup *)tmp_unode->aux;
+			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
 			if (qg->tag == seq)
 				continue;
 
@@ -1225,7 +1225,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 			list_for_each_entry(glist, &qg->groups, next_group) {
 				ulist_add(tmp, glist->group->qgroupid,
-					  (u64)glist->group,
+					  (uintptr_t)glist->group,
 					  GFP_ATOMIC);
 			}
 		}
@@ -1473,13 +1473,13 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	 * be exceeded
 	 */
 	ulist = ulist_alloc(GFP_ATOMIC);
-	ulist_add(ulist, qgroup->qgroupid, (u64)qgroup, GFP_ATOMIC);
+	ulist_add(ulist, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
-		qg = (struct btrfs_qgroup *)unode->aux;
+		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 		    qg->reserved + qg->rfer + num_bytes >
@@ -1493,7 +1493,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ulist_add(ulist, glist->group->qgroupid,
-				  (u64)glist->group, GFP_ATOMIC);
+				  (uintptr_t)glist->group, GFP_ATOMIC);
 		}
 	}
 	if (ret)
@@ -1506,7 +1506,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 
-		qg = (struct btrfs_qgroup *)unode->aux;
+		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
 
 		qg->reserved += num_bytes;
 	}
@@ -1545,19 +1545,19 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 		goto out;
 
 	ulist = ulist_alloc(GFP_ATOMIC);
-	ulist_add(ulist, qgroup->qgroupid, (u64)qgroup, GFP_ATOMIC);
+	ulist_add(ulist, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
-		qg = (struct btrfs_qgroup *)unode->aux;
+		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
 
 		qg->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ulist_add(ulist, glist->group->qgroupid,
-				  (u64)glist->group, GFP_ATOMIC);
+				  (uintptr_t)glist->group, GFP_ATOMIC);
 		}
 	}
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c972d8f..760390f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1034,7 +1034,7 @@ struct backref_ctx {
 
 static int __clone_root_cmp_bsearch(const void *key, const void *elt)
 {
-	u64 root = (u64)key;
+	u64 root = (u64)(uintptr_t)key;
 	struct clone_root *cr = (struct clone_root *)elt;
 
 	if (root < cr->root->objectid)
@@ -1068,7 +1068,7 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 	u64 i_size;
 
 	/* First check if the root is in the list of accepted clone sources */
-	found = bsearch((void *)root, bctx->sctx->clone_roots,
+	found = bsearch((void *)(uintptr_t)root, bctx->sctx->clone_roots,
 			bctx->sctx->clone_roots_cnt,
 			sizeof(struct clone_root),
 			__clone_root_cmp_bsearch);
-- 
1.7.1

