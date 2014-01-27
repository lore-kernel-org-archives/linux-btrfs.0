Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaA0KBK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 05:01:10 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0RA17mu013223
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 18:01:07 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] Btrfs: rework ulist with list+rb_tree
Date: Mon, 27 Jan 2014 17:59:47 +0800
Message-Id: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are really suffering from now ulist's implementation, some developers
gave their try, and i just gave some of my ideas for things:

 1. use list+rb_tree instead of arrary+rb_tree

 2. add cur_list to iterator rather than ulist structure.

 3. add seqnum into every node when they are added, this is
 used to do selfcheck when iterating node.

I noticed Zach Brown's comments before, long term is to kick off
ulist implementation, however, for now, we need at least avoid
arrary from ulist.

Cc: Liu Bo <bo.li.liu@oracle.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Zach Brown <zab@redhat.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v2->v3:
	only do selfchecks with CONFIG_BTRFS_DEBUG enabled(Thanks to Josef!)
	update ulist's comments since they are out of date.
v1->v2:
	add RFC title since this patch needs more reviews and comments.
	fix a used after free bug in ulist_fini().
---
 fs/btrfs/ulist.c | 109 ++++++++++++++++++++++++-------------------------------
 fs/btrfs/ulist.h |  41 +++++++--------------
 2 files changed, 61 insertions(+), 89 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 35f5de9..1c9e2c9 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include "ulist.h"
+#include "ctree.h"
 
 /*
  * ulist is a generic data structure to hold a collection of unique u64
@@ -14,10 +15,6 @@
  * enumerating it.
  * It is possible to store an auxiliary value along with the key.
  *
- * The implementation is preliminary and can probably be sped up
- * significantly. A first step would be to store the values in an rbtree
- * as soon as ULIST_SIZE is exceeded.
- *
  * A sample usage for ulists is the enumeration of directed graphs without
  * visiting a node twice. The pseudo-code could look like this:
  *
@@ -50,10 +47,11 @@
  */
 void ulist_init(struct ulist *ulist)
 {
-	ulist->nnodes = 0;
-	ulist->nodes = ulist->int_nodes;
-	ulist->nodes_alloced = ULIST_SIZE;
+	INIT_LIST_HEAD(&ulist->nodes);
 	ulist->root = RB_ROOT;
+#ifdef CONFIG_BTRFS_DEBUG
+	ulist->nnodes = 0;
+#endif
 }
 EXPORT_SYMBOL(ulist_init);
 
@@ -66,14 +64,14 @@ EXPORT_SYMBOL(ulist_init);
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
+	struct ulist_node *node;
+	struct ulist_node *next;
+
+	list_for_each_entry_safe(node, next, &ulist->nodes, list) {
+		kfree(node);
+	}
 	ulist->root = RB_ROOT;
+	INIT_LIST_HEAD(&ulist->nodes);
 }
 EXPORT_SYMBOL(ulist_fini);
 
@@ -192,57 +190,31 @@ int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask)
 int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		    u64 *old_aux, gfp_t gfp_mask)
 {
-	int ret = 0;
-	struct ulist_node *node = NULL;
+	int ret;
+	struct ulist_node *node;
+
 	node = ulist_rbtree_search(ulist, val);
 	if (node) {
 		if (old_aux)
 			*old_aux = node->aux;
 		return 0;
 	}
+	node = kmalloc(sizeof(*node), gfp_mask);
+	if (!node)
+		return -ENOMEM;
 
-	if (ulist->nnodes >= ulist->nodes_alloced) {
-		u64 new_alloced = ulist->nodes_alloced + 128;
-		struct ulist_node *new_nodes;
-		void *old = NULL;
-		int i;
-
-		/*
-		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
-		 * yet, so pass NULL to krealloc
-		 */
-		if (ulist->nodes_alloced > ULIST_SIZE)
-			old = ulist->nodes;
+	node->val = val;
+	node->aux = aux;
+#ifdef CONFIG_BTRFS_DEBUG
+	node->seqnum = ulist->nnodes;
+#endif
 
-		new_nodes = krealloc(old, sizeof(*new_nodes) * new_alloced,
-				     gfp_mask);
-		if (!new_nodes)
-			return -ENOMEM;
-
-		if (!old)
-			memcpy(new_nodes, ulist->int_nodes,
-			       sizeof(ulist->int_nodes));
-
-		ulist->nodes = new_nodes;
-		ulist->nodes_alloced = new_alloced;
-
-		/*
-		 * krealloc actually uses memcpy, which does not copy rb_node
-		 * pointers, so we have to do it ourselves.  Otherwise we may
-		 * be bitten by crashes.
-		 */
-		ulist->root = RB_ROOT;
-		for (i = 0; i < ulist->nnodes; i++) {
-			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);
-			if (ret < 0)
-				return ret;
-		}
-	}
-	ulist->nodes[ulist->nnodes].val = val;
-	ulist->nodes[ulist->nnodes].aux = aux;
-	ret = ulist_rbtree_insert(ulist, &ulist->nodes[ulist->nnodes]);
-	BUG_ON(ret);
-	++ulist->nnodes;
+	ret = ulist_rbtree_insert(ulist, node);
+	ASSERT(!ret);
+	list_add_tail(&node->list, &ulist->nodes);
+#ifdef CONFIG_BTRFS_DEBUG
+	ulist->nnodes++;
+#endif
 
 	return 1;
 }
@@ -266,11 +238,26 @@ EXPORT_SYMBOL(ulist_add);
  */
 struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 {
-	if (ulist->nnodes == 0)
+	struct ulist_node *node;
+
+	if (list_empty(&ulist->nodes))
 		return NULL;
-	if (uiter->i < 0 || uiter->i >= ulist->nnodes)
+	if (uiter->cur_list && uiter->cur_list->next == &ulist->nodes)
 		return NULL;
-
-	return &ulist->nodes[uiter->i++];
+	if (uiter->cur_list) {
+		uiter->cur_list = uiter->cur_list->next;
+	} else {
+		uiter->cur_list = ulist->nodes.next;
+#ifdef CONFIG_BTRFS_DEBUG
+		uiter->i = 0;
+#endif
+	}
+	node = list_entry(uiter->cur_list, struct ulist_node, list);
+#ifdef CONFIG_BTRFS_DEBUG
+	ASSERT(node->seqnum == uiter->i);
+	ASSERT(uiter->i >= 0 && uiter->i < ulist->nnodes);
+	uiter->i++;
+#endif
+	return node;
 }
 EXPORT_SYMBOL(ulist_next);
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index fb36731..7be97fc 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -17,18 +17,12 @@
  * enumerating it.
  * It is possible to store an auxiliary value along with the key.
  *
- * The implementation is preliminary and can probably be sped up
- * significantly. A first step would be to store the values in an rbtree
- * as soon as ULIST_SIZE is exceeded.
  */
-
-/*
- * number of elements statically allocated inside struct ulist
- */
-#define ULIST_SIZE 16
-
 struct ulist_iterator {
+#ifdef CONFIG_BTRFS_DEBUG
 	int i;
+#endif
+	struct list_head *cur_list;  /* hint to start search */
 };
 
 /*
@@ -37,6 +31,12 @@ struct ulist_iterator {
 struct ulist_node {
 	u64 val;		/* value to store */
 	u64 aux;		/* auxiliary value saved along with the val */
+
+#ifdef CONFIG_BTRFS_DEBUG
+	int seqnum;		/* sequence number this node is added */
+#endif
+
+	struct list_head list;  /* used to link node */
 	struct rb_node rb_node;	/* used to speed up search */
 };
 
@@ -44,26 +44,11 @@ struct ulist {
 	/*
 	 * number of elements stored in list
 	 */
+#ifdef CONFIG_BTRFS_DEBUG
 	unsigned long nnodes;
-
-	/*
-	 * number of nodes we already have room for
-	 */
-	unsigned long nodes_alloced;
-
-	/*
-	 * pointer to the array storing the elements. The first ULIST_SIZE
-	 * elements are stored inline. In this case the it points to int_nodes.
-	 * After exceeding ULIST_SIZE, dynamic memory is allocated.
-	 */
-	struct ulist_node *nodes;
-
+#endif
+	struct list_head nodes;
 	struct rb_root root;
-
-	/*
-	 * inline storage space for the first ULIST_SIZE entries
-	 */
-	struct ulist_node int_nodes[ULIST_SIZE];
 };
 
 void ulist_init(struct ulist *ulist);
@@ -77,6 +62,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 struct ulist_node *ulist_next(struct ulist *ulist,
 			      struct ulist_iterator *uiter);
 
-#define ULIST_ITER_INIT(uiter) ((uiter)->i = 0)
+#define ULIST_ITER_INIT(uiter) ((uiter)->cur_list = NULL)
 
 #endif
-- 
1.8.3.1

