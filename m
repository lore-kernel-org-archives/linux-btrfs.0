Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbaG3QiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 12:38:25 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch
Date: Wed, 30 Jul 2014 18:38:22 +0200
Message-Id: <1406738303-24341-1-git-send-email-tiwai@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've got bug reports that btrfs crashes when quota is enabled on
32bit kernel, typically with the Oops like below:
 BUG: unable to handle kernel NULL pointer dereference at 00000004
 IP: [<f9234590>] find_parent_nodes+0x360/0x1380 [btrfs]
 *pde = 00000000
 Oops: 0000 [#1] SMP
 CPU: 0 PID: 151 Comm: kworker/u8:2 Tainted: G S      W 3.15.2-1.gd43d97e-default #1
 Workqueue: btrfs-qgroup-rescan normal_work_helper [btrfs]
 task: f1478130 ti: f147c000 task.ti: f147c000
 EIP: 0060:[<f9234590>] EFLAGS: 00010213 CPU: 0
 EIP is at find_parent_nodes+0x360/0x1380 [btrfs]
 EAX: f147dda8 EBX: f147ddb0 ECX: 00000011 EDX: 00000000
 ESI: 00000000 EDI: f147dda4 EBP: f147ddf8 ESP: f147dd38
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 CR0: 8005003b CR2: 00000004 CR3: 00bf3000 CR4: 00000690
 Stack:
  00000000 00000000 f147dda4 00000050 00000001 00000000 00000001 00000050
  00000001 00000000 d3059000 00000001 00000022 000000a8 00000000 00000000
  00000000 000000a1 00000000 00000000 00000001 00000000 00000000 11800000
 Call Trace:
  [<f923564d>] __btrfs_find_all_roots+0x9d/0xf0 [btrfs]
  [<f9237bb1>] btrfs_qgroup_rescan_worker+0x401/0x760 [btrfs]
  [<f9206148>] normal_work_helper+0xc8/0x270 [btrfs]
  [<c025e38b>] process_one_work+0x11b/0x390
  [<c025eea1>] worker_thread+0x101/0x340
  [<c026432b>] kthread+0x9b/0xb0
  [<c0712a71>] ret_from_kernel_thread+0x21/0x30
  [<c0264290>] kthread_create_on_node+0x110/0x110

This indicates a NULL corruption in prefs_delayed list.  The further
investigation and bisection pointed that the call of ulist_add_merge()
results in the corruption.

ulist_add_merge() takes u64 as aux and writes a 64bit value into
old_aux.  The callers of this function in backref.c, however, pass a
pointer of a pointer to old_aux.  That is, the function overwrites
64bit value on 32bit pointer.  This caused a NULL in the adjacent
variable, in this case, prefs_delayed.

Since all callers of ulist_add() and ulist_add_merge() use pointers
for aux values, we can replace aux with void * instead of u64.  This
will fix automagically the bug, and as a more bonus, all messy casts
are removed.

There are still ugly void ** cast remaining in some places because
void ** cannot be taken implicitly.  But, it's safer than explicit
cast to u64, anyway.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=887046
Cc: <stable@vger.kernel.org> [v3.11+]
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: Metabolize and increase patch size by doing "right" replacements of all callers

 fs/btrfs/backref.c | 30 ++++++++++++---------------
 fs/btrfs/qgroup.c  | 59 ++++++++++++++++++++++++------------------------------
 fs/btrfs/ulist.c   |  6 +++---
 fs/btrfs/ulist.h   |  8 ++++----
 4 files changed, 46 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index e25564bfcb46..3dcadebc04f8 100644
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
@@ -276,9 +276,8 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			}
 			if (ret > 0)
 				goto next;
-			ret = ulist_add_merge(parents, eb->start,
-					      (uintptr_t)eie,
-					      (u64 *)&old, GFP_NOFS);
+			ret = ulist_add_merge(parents, eb->start, eie,
+					      (void **)&old, GFP_NOFS);
 			if (ret < 0)
 				break;
 			if (!ret && extent_item_pos) {
@@ -421,8 +420,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		ULIST_ITER_INIT(&uiter);
 		node = ulist_next(parents, &uiter);
 		ref->parent = node ? node->val : 0;
-		ref->inode_list = node ?
-			(struct extent_inode_elem *)(uintptr_t)node->aux : NULL;
+		ref->inode_list = node ? node->aux : NULL;
 
 		/* additional parents require new refs being added here */
 		while ((node = ulist_next(parents, &uiter))) {
@@ -434,8 +432,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			}
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
-			new_ref->inode_list = (struct extent_inode_elem *)
-							(uintptr_t)node->aux;
+			new_ref->inode_list = node->aux;
 			list_add(&new_ref->list, &ref->list);
 		}
 		ulist_reinit(parents);
@@ -983,7 +980,7 @@ again:
 		WARN_ON(ref->count < 0);
 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
-			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
+			ret = ulist_add(roots, ref->root_id, NULL, GFP_NOFS);
 			if (ret < 0)
 				goto out;
 		}
@@ -1009,8 +1006,8 @@ again:
 				ref->inode_list = eie;
 			}
 			ret = ulist_add_merge(refs, ref->parent,
-					      (uintptr_t)ref->inode_list,
-					      (u64 *)&eie, GFP_NOFS);
+					      ref->inode_list,
+					      (void **)&eie, GFP_NOFS);
 			if (ret < 0)
 				goto out;
 			if (!ret && extent_item_pos) {
@@ -1057,9 +1054,9 @@ static void free_leaf_list(struct ulist *blocks)
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
@@ -1564,11 +1561,10 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
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
index 98cb6b2630f9..b499f580d005 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1353,7 +1353,7 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	/* Get all of the parent groups that contain this qgroup */
 	list_for_each_entry(glist, &qgroup->groups, next_group) {
 		ret = ulist_add(tmp, glist->group->qgroupid,
-				ptr_to_u64(glist->group), GFP_ATOMIC);
+				glist->group, GFP_ATOMIC);
 		if (ret < 0)
 			goto out;
 	}
@@ -1361,7 +1361,7 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	/* Iterate all of the parents and adjust their reference counts */
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
-		qgroup = u64_to_ptr(unode->aux);
+		qgroup = unode->aux;
 		qgroup->rfer += sign * oper->num_bytes;
 		qgroup->rfer_cmpr += sign * oper->num_bytes;
 		qgroup->excl += sign * oper->num_bytes;
@@ -1373,7 +1373,7 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		/* Add any parents of the parents */
 		list_for_each_entry(glist, &qgroup->groups, next_group) {
 			ret = ulist_add(tmp, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				goto out;
 		}
@@ -1421,18 +1421,17 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
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
@@ -1458,13 +1457,11 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
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
@@ -1513,8 +1510,7 @@ static int qgroup_account_deleted_refs(struct btrfs_fs_info *fs_info,
 		qg = find_qgroup_rb(fs_info, tmp_oper->ref_root);
 		if (!qg)
 			goto next;
-		ret = ulist_add(qgroups, qg->qgroupid, ptr_to_u64(qg),
-				GFP_ATOMIC);
+		ret = ulist_add(qgroups, qg->qgroupid, qg, GFP_ATOMIC);
 		if (ret) {
 			if (ret < 0)
 				return ret;
@@ -1529,8 +1525,7 @@ static int qgroup_account_deleted_refs(struct btrfs_fs_info *fs_info,
 			 * seen this qgroup and we can bump the old_roots.
 			 */
 			(*old_roots)++;
-			ret = ulist_add(tmp, qg->qgroupid, ptr_to_u64(qg),
-					GFP_ATOMIC);
+			ret = ulist_add(tmp, qg->qgroupid, qg, GFP_ATOMIC);
 			if (ret < 0)
 				return ret;
 		}
@@ -1548,7 +1543,7 @@ next:
 	while ((unode = ulist_next(tmp, &uiter))) {
 		struct btrfs_qgroup_list *glist;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 		if (qg->old_refcnt < seq)
 			qg->old_refcnt = seq + 1;
 		else
@@ -1559,11 +1554,11 @@ next:
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
@@ -1584,19 +1579,17 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
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
@@ -1610,11 +1603,11 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
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
@@ -1639,7 +1632,7 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 	while ((unode = ulist_next(qgroups, &uiter))) {
 		bool dirty = false;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 		/*
 		 * Wasn't referenced before but is now, add to the reference
 		 * counters.
@@ -2221,7 +2214,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	 */
 	ulist_reinit(fs_info->qgroup_ulist);
 	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
-			(uintptr_t)qgroup, GFP_ATOMIC);
+			qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		goto out;
 	ULIST_ITER_INIT(&uiter);
@@ -2229,7 +2222,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 		    qg->reserved + (s64)qg->rfer + num_bytes >
@@ -2248,7 +2241,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
 					glist->group->qgroupid,
-					(uintptr_t)glist->group, GFP_ATOMIC);
+					glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				goto out;
 		}
@@ -2261,7 +2254,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 
-		qg = u64_to_ptr(unode->aux);
+		qg = unode->aux;
 
 		qg->reserved += num_bytes;
 	}
@@ -2299,7 +2292,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 	ulist_reinit(fs_info->qgroup_ulist);
 	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
-			(uintptr_t)qgroup, GFP_ATOMIC);
+			qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		goto out;
 	ULIST_ITER_INIT(&uiter);
@@ -2307,14 +2300,14 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
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
index 7f78cbf5cf41..1088a55c6655 100644
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
@@ -54,9 +54,9 @@ void ulist_init(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask);
-int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
-		    u64 *old_aux, gfp_t gfp_mask);
+int ulist_add(struct ulist *ulist, u64 val, void *aux, gfp_t gfp_mask);
+int ulist_add_merge(struct ulist *ulist, u64 val, void *aux,
+		    void **old_aux, gfp_t gfp_mask);
 struct ulist_node *ulist_next(struct ulist *ulist,
 			      struct ulist_iterator *uiter);
 
-- 
2.0.1

