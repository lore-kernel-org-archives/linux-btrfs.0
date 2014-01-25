Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaAYF3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 00:29:02 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0P5SwkG021070
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 13:28:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: rework ulist with list+rb_tree
Date: Sat, 25 Jan 2014 13:27:42 +0800
Message-Id: <1390627663-2924-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
 fs/btrfs/ulist.c | 84 +++++++++++++++++++++-----------------------------------
 fs/btrfs/ulist.h | 22 ++++-----------
 2 files changed, 37 insertions(+), 69 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 35f5de9..674430b 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include "ulist.h"
+#include "ctree.h"
 
 /*
  * ulist is a generic data structure to hold a collection of unique u64
@@ -51,8 +52,7 @@
 void ulist_init(struct ulist *ulist)
 {
 	ulist->nnodes = 0;
-	ulist->nodes = ulist->int_nodes;
-	ulist->nodes_alloced = ULIST_SIZE;
+	INIT_LIST_HEAD(&ulist->nodes);
 	ulist->root = RB_ROOT;
 }
 EXPORT_SYMBOL(ulist_init);
@@ -66,13 +66,11 @@ EXPORT_SYMBOL(ulist_init);
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
+
+	list_for_each_entry(node, &ulist->nodes, list) {
+		kfree(node);
+	}
 	ulist->root = RB_ROOT;
 }
 EXPORT_SYMBOL(ulist_fini);
@@ -200,48 +198,17 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
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
-
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
+	node->val = val;
+	node->aux = aux;
+	node->seqnum = ulist->nnodes;
 
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
+	ret = ulist_rbtree_insert(ulist, node);
+	ASSERT(!ret);
+	list_add_tail(&node->list, &ulist->nodes);
 	++ulist->nnodes;
 
 	return 1;
@@ -266,11 +233,22 @@ EXPORT_SYMBOL(ulist_add);
  */
 struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 {
-	if (ulist->nnodes == 0)
-		return NULL;
-	if (uiter->i < 0 || uiter->i >= ulist->nnodes)
+	struct ulist_node *node;
+
+	if (ulist->nnodes == 0 || uiter->i >= ulist->nnodes)
 		return NULL;
+	ASSERT(uiter->i >= 0);
+
+	if (uiter->i == 0) {
+		uiter->cur_list = ulist->nodes.next;
+		uiter->i++;
+		return list_entry(uiter->cur_list, struct ulist_node, list);
+	}
+	uiter->cur_list = uiter->cur_list->next;
+	node = list_entry(uiter->cur_list, struct ulist_node, list);
+	ASSERT(node->seqnum == uiter->i);
+	uiter->i++;
 
-	return &ulist->nodes[uiter->i++];
+	return node;
 }
 EXPORT_SYMBOL(ulist_next);
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index fb36731..b84d27b 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -29,6 +29,7 @@
 
 struct ulist_iterator {
 	int i;
+	struct list_head *cur_list;  /* hint to start search*/
 };
 
 /*
@@ -37,6 +38,10 @@ struct ulist_iterator {
 struct ulist_node {
 	u64 val;		/* value to store */
 	u64 aux;		/* auxiliary value saved along with the val */
+
+	int seqnum;		/* sequence of number this node is added */
+
+	struct list_head list;  /* used to link node */
 	struct rb_node rb_node;	/* used to speed up search */
 };
 
@@ -46,24 +51,9 @@ struct ulist {
 	 */
 	unsigned long nnodes;
 
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
+	struct list_head nodes;
 
 	struct rb_root root;
-
-	/*
-	 * inline storage space for the first ULIST_SIZE entries
-	 */
-	struct ulist_node int_nodes[ULIST_SIZE];
 };
 
 void ulist_init(struct ulist *ulist);
-- 
1.8.3.1

