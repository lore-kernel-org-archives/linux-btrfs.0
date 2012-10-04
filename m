Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m199-177.yeah.net ([123.58.177.199]:43936 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2JDJSq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 05:18:46 -0400
From: Rock Lee <zimilo@code-trick.com>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rock <zimilo@code-trick.com>
Subject: [PATCH] btrfs ulist use rbtree instead
Date: Thu,  4 Oct 2012 17:11:06 +0800
Message-Id: <1349341866-29320-1-git-send-email-zimilo@code-trick.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Rock <zimilo@code-trick.com>

---
 fs/btrfs/backref.c |   10 ++--
 fs/btrfs/qgroup.c  |   16 +++---
 fs/btrfs/send.c    |    2 +-
 fs/btrfs/ulist.c   |  154 +++++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/ulist.h   |   45 ++++++++++++---
 5 files changed, 161 insertions(+), 66 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index ff6475f..a5bebc8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -360,7 +360,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 
 		/* we put the first parent into the ref at hand */
-		ULIST_ITER_INIT(&uiter);
+		ULIST_ITER_INIT(parents, &uiter);
 		node = ulist_next(parents, &uiter);
 		ref->parent = node ? node->val : 0;
 		ref->inode_list =
@@ -955,7 +955,7 @@ static void free_leaf_list(struct ulist *blocks)
 	struct extent_inode_elem *eie_next;
 	struct ulist_iterator uiter;
 
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(blocks, &uiter);
 	while ((node = ulist_next(blocks, &uiter))) {
 		if (!node->aux)
 			continue;
@@ -1038,7 +1038,7 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(tmp, &uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr,
 					time_seq, tmp, *roots, NULL);
@@ -1395,13 +1395,13 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	if (ret)
 		goto out;
 
-	ULIST_ITER_INIT(&ref_uiter);
+	ULIST_ITER_INIT(refs, &ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val,
 					   tree_mod_seq_elem.seq, &roots);
 		if (ret)
 			break;
-		ULIST_ITER_INIT(&root_uiter);
+		ULIST_ITER_INIT(roots, &root_uiter);
 		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
 			pr_debug("root %llu references leaf %llu, data list "
 				 "%#lx\n", root_node->val, ref_node->val,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b650155..a0aad87 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1133,7 +1133,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	seq = fs_info->qgroup_seq;
 	fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
 
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(roots, &uiter);
 	while ((unode = ulist_next(roots, &uiter))) {
 		struct ulist_node *tmp_unode;
 		struct ulist_iterator tmp_uiter;
@@ -1146,7 +1146,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 		ulist_reinit(tmp);
 						/* XXX id not needed */
 		ulist_add(tmp, qg->qgroupid, (unsigned long)qg, GFP_ATOMIC);
-		ULIST_ITER_INIT(&tmp_uiter);
+		ULIST_ITER_INIT(tmp, &tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
 
@@ -1169,7 +1169,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	 */
 	ulist_reinit(tmp);
 	ulist_add(tmp, qgroup->qgroupid, (unsigned long)qgroup, GFP_ATOMIC);
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(tmp, &uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
@@ -1197,7 +1197,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	/*
 	 * step 3: walk again from old refs
 	 */
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(roots, &uiter);
 	while ((unode = ulist_next(roots, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct ulist_node *tmp_unode;
@@ -1209,7 +1209,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 		ulist_reinit(tmp);
 		ulist_add(tmp, qg->qgroupid, (unsigned long)qg, GFP_ATOMIC);
-		ULIST_ITER_INIT(&tmp_uiter);
+		ULIST_ITER_INIT(tmp, &tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
 
@@ -1470,7 +1470,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	 */
 	ulist = ulist_alloc(GFP_ATOMIC);
 	ulist_add(ulist, qgroup->qgroupid, (unsigned long)qgroup, GFP_ATOMIC);
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(ulist, &uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
@@ -1498,7 +1498,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	/*
 	 * no limits exceeded, now record the reservation into all qgroups
 	 */
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(ulist, &uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 
@@ -1542,7 +1542,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 	ulist = ulist_alloc(GFP_ATOMIC);
 	ulist_add(ulist, qgroup->qgroupid, (unsigned long)qgroup, GFP_ATOMIC);
-	ULIST_ITER_INIT(&uiter);
+	ULIST_ITER_INIT(ulist, &uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fb5ffe9..d4a2254 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2898,7 +2898,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 	 * deletion and if it's finally possible to perform the rmdir now.
 	 * We also update the inode stats of the parent dirs here.
 	 */
-	ULIST_ITER_INIT(&uit);
+	ULIST_ITER_INIT(check_dirs, &uit);
 	while ((un = ulist_next(check_dirs, &uit))) {
 		if (un->val > sctx->cur_ino)
 			continue;
diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index ab942f4..2040905 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -2,6 +2,8 @@
  * Copyright (C) 2011 STRATO AG
  * written by Arne Jansen <sensille@gmx.net>
  * Distributed under the GNU GPL license version 2.
+ *
+ * Copyright 2012 Rock Lee <zimilo@code-trick.com>
  */
 
 #include <linux/slab.h>
@@ -23,10 +25,10 @@
  *
  * ulist = ulist_alloc();
  * ulist_add(ulist, root);
- * ULIST_ITER_INIT(&uiter);
+ * ULIST_ITER_INIT(ulist, &uiter);
  *
  * while ((elem = ulist_next(ulist, &uiter)) {
- * 	for (all child nodes n in elem)
+ *	for (all child nodes n in elem)
  *		ulist_add(ulist, n);
  *	do something useful with the node;
  * }
@@ -51,8 +53,10 @@
 void ulist_init(struct ulist *ulist)
 {
 	ulist->nnodes = 0;
-	ulist->nodes = ulist->int_nodes;
 	ulist->nodes_alloced = ULIST_SIZE;
+	ulist->pools = NULL;
+	ulist->root = RB_ROOT;
+
 }
 EXPORT_SYMBOL(ulist_init);
 
@@ -65,13 +69,18 @@ EXPORT_SYMBOL(ulist_init);
  */
 void ulist_fini(struct ulist *ulist)
 {
-	/*
-	 * The first ULIST_SIZE elements are stored inline in struct ulist.
-	 * Only if more elements are alocated they need to be freed.
-	 */
-	if (ulist->nodes_alloced > ULIST_SIZE)
-		kfree(ulist->nodes);
-	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
+	if (ulist->pools) {
+		struct list_head *p, *n;
+		struct ulist_node_pool *pool;
+		list_for_each_safe(p, n, &(ulist->pools->list)) {
+			pool = list_entry(p, struct ulist_node_pool, list);
+			kfree(pool);
+		}
+		ulist->pools = NULL;
+	}
+	ulist->nnodes = 0;
+	ulist->nodes_alloced = ULIST_SIZE;
+	ulist->root = RB_ROOT;
 }
 EXPORT_SYMBOL(ulist_fini);
 
@@ -152,48 +161,98 @@ int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
 int ulist_add_merge(struct ulist *ulist, u64 val, unsigned long aux,
 		    unsigned long *old_aux, gfp_t gfp_mask)
 {
-	int i;
-
-	for (i = 0; i < ulist->nnodes; ++i) {
-		if (ulist->nodes[i].val == val) {
+	struct ulist_node *node;
+	struct ulist_node_pool *pool = NULL;
+	if (ulist->nnodes <= ULIST_SIZE) {
+		int i;
+		for (i = 0; i < ulist->nnodes; ++i) {
+			if (ulist->int_nodes[i].val == val) {
+				if (old_aux)
+					*old_aux = ulist->int_nodes[i].aux;
+				return 0;
+			}
+		}
+	} else {
+		node = __ulist_rbtree_search(ulist, val);
+		if (node) {
 			if (old_aux)
-				*old_aux = ulist->nodes[i].aux;
+				*old_aux = node->aux;
 			return 0;
 		}
 	}
 
-	if (ulist->nnodes >= ulist->nodes_alloced) {
-		u64 new_alloced = ulist->nodes_alloced + 128;
-		struct ulist_node *new_nodes;
-		void *old = NULL;
-
-		/*
-		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
-		 * yet, so pass NULL to krealloc
-		 */
-		if (ulist->nodes_alloced > ULIST_SIZE)
-			old = ulist->nodes;
-
-		new_nodes = krealloc(old, sizeof(*new_nodes) * new_alloced,
-				     gfp_mask);
-		if (!new_nodes)
+	if (ulist->nodes_alloced == ulist->nnodes) {
+		pool = kmalloc(sizeof(*pool), gfp_mask);
+		if (!pool)
 			return -ENOMEM;
+		pool->free_idx = 0;
 
-		if (!old)
-			memcpy(new_nodes, ulist->int_nodes,
-			       sizeof(ulist->int_nodes));
+		if (unlikely(ulist->nodes_alloced == ULIST_SIZE)) {
+			int i;
+			for (i = 0; i < ULIST_SIZE; ++i)
+				__ulist_rbtree_add_node(ulist,
+							&ulist->int_nodes[i]);
+			ulist->pools = pool;
+		} else {
+			list_add_tail(&pool->list, &ulist->pools->list);
+		}
+		ulist->nodes_alloced += ULIST_NODE_POOL_SIZE;
+	}
 
-		ulist->nodes = new_nodes;
-		ulist->nodes_alloced = new_alloced;
+	if (ulist->nnodes >= ULIST_SIZE) {
+		pool = list_entry(ulist->pools->list.prev,
+				struct ulist_node_pool,
+				list);
+		node = &pool->nodes[pool->free_idx++];
+		node->val = val;
+		__ulist_rbtree_add_node(ulist, node);
+	} else {
+		node = &ulist->int_nodes[ulist->nnodes];
+		node->val = val;
 	}
-	ulist->nodes[ulist->nnodes].val = val;
-	ulist->nodes[ulist->nnodes].aux = aux;
+
+	node->aux = aux;
 	++ulist->nnodes;
-
 	return 1;
 }
 EXPORT_SYMBOL(ulist_add);
 
+
+struct ulist_node *__ulist_rbtree_search(struct ulist *ulist, u64 val)
+{
+	struct rb_node *node = ulist->root.rb_node;
+	struct ulist_node *v;
+	while (node) {
+		v = rb_entry(node, struct ulist_node, node);
+		if (v->val < val)
+			node = node->rb_left;
+		else if (v->val > val)
+			node = node->rb_right;
+		else
+			return v;
+	}
+	return NULL;
+}
+
+
+int __ulist_rbtree_add_node(struct ulist *ulist, struct ulist_node *node)
+{
+	struct rb_node **new = &(ulist->root.rb_node), *parent = NULL;
+	struct ulist_node *v;
+	while (*new) {
+		v = rb_entry(*new, struct ulist_node, node);
+		if (v->val < node->val)
+			new = &((*new)->rb_left);
+		else if (v->val > node->val)
+			new = &((*new)->rb_right);
+		else
+			return -EEXIST;
+	}
+	rb_link_node(&node->node, parent, new);
+	rb_insert_color(&node->node, &ulist->root);
+	return 0;
+}
+
 /**
  * ulist_next - iterate ulist
  * @ulist:	ulist to iterate
@@ -207,16 +266,23 @@ EXPORT_SYMBOL(ulist_add);
  * end is reached. No guarantee is made with respect to the order in which
  * the elements are returned. They might neither be returned in order of
  * addition nor in ascending order.
- * It is allowed to call ulist_add during an enumeration. Newly added items
- * are guaranteed to show up in the running enumeration.
  */
 struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 {
 	if (ulist->nnodes == 0)
 		return NULL;
-	if (uiter->i < 0 || uiter->i >= ulist->nnodes)
-		return NULL;
-
-	return &ulist->nodes[uiter->i++];
+	if (ulist->nnodes <= ULIST_SIZE) {
+		if (uiter->d.i >= ulist->nnodes || uiter->d.i < 0)
+			return NULL;
+		return &ulist->int_nodes[uiter->d.i++];
+	} else {
+		struct ulist_node *node;
+		if (uiter->d.node == NULL)
+			return NULL;
+		node = rb_entry(uiter->d.node, struct ulist_node, node);
+		uiter->d.node = rb_next(uiter->d.node);
+		return node;
+	}
+	return NULL;
 }
 EXPORT_SYMBOL(ulist_next);
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 21bdc8e..bae5812 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -3,11 +3,15 @@
  * written by Arne Jansen <sensille@gmx.net>
  * Distributed under the GNU GPL license version 2.
  *
+ * Copyright 2012 Rock Lee <zimilo@code-trick.com>
  */
 
 #ifndef __ULIST__
 #define __ULIST__
 
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
 /*
  * ulist is a generic data structure to hold a collection of unique u64
  * values. The only operations it supports is adding to the list and
@@ -24,35 +28,53 @@
  */
 #define ULIST_SIZE 16
 
+/*
+ * number of elements statically allocated inside the pool
+ */
+#define ULIST_NODE_POOL_SIZE 128
+
 struct ulist_iterator {
-	int i;
+	union {
+		int i;
+		struct rb_node *node;
+	} d;
 };
 
 /*
  * element of the list
  */
 struct ulist_node {
+	struct rb_node node;    /* node for rbtree maintain */
 	u64 val;		/* value to store */
 	unsigned long aux;	/* auxiliary value saved along with the val */
 };
 
+struct ulist_node_pool {
+	struct list_head list;
+	unsigned int free_idx;
+	struct ulist_node nodes[ULIST_NODE_POOL_SIZE];
+};
+
 struct ulist {
 	/*
-	 * number of elements stored in list
+	 * number of elements stored in the list
 	 */
 	unsigned long nnodes;
 
 	/*
-	 * number of nodes we already have room for
+	 * number of nodes we can store in the list
 	 */
 	unsigned long nodes_alloced;
 
 	/*
-	 * pointer to the array storing the elements. The first ULIST_SIZE
-	 * elements are stored inline. In this case the it points to int_nodes.
-	 * After exceeding ULIST_SIZE, dynamic memory is allocated.
+	 * node pools for storing ulist_nodes
 	 */
-	struct ulist_node *nodes;
+	struct ulist_node_pool *pools;
+
+	/*
+	 * when exceeds the ULIST_SIZE, the root field is useful
+	 */
+	struct rb_root root;
 
 	/*
 	 * inline storage space for the first ULIST_SIZE entries
@@ -72,6 +94,13 @@ int ulist_add_merge(struct ulist *ulist, u64 val, unsigned long aux,
 struct ulist_node *ulist_next(struct ulist *ulist,
 			      struct ulist_iterator *uiter);
 
-#define ULIST_ITER_INIT(uiter) ((uiter)->i = 0)
+struct ulist_node *__ulist_rbtree_search(struct ulist *ulist, u64 val);
+int __ulist_rbtree_add_node(struct ulist *ulist, struct ulist_node *node);
+
 
+#define ULIST_ITER_INIT(ulist, uiter) \
+	if ((ulist)->nnodes <= ULIST_SIZE) \
+		(uiter)->d.i = 0;	  \
+	else				  \
+		(uiter)->d.node = rb_first(&((ulist)->root))
 #endif
-- 
1.7.9.5

