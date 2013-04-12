Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35076 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab3DLMMr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 08:12:47 -0400
Received: by mail-pd0-f177.google.com with SMTP id u11so1373459pdi.22
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2013 05:12:46 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2] Btrfs: add a rb_tree to improve performance of ulist search
Date: Fri, 12 Apr 2013 20:12:17 +0800
Message-Id: <1365768737-23848-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Walking backref tree and btrfs quota rely on ulist very much.
This patch tries to use rb_tree to speed up search time.

The original code always checks whether an element
exists before adding a new element, however it costs O(n).

I try to add a rb_tree in the ulist,this is only used to speed up
search. I also do some measurements with quota enabled.

fsstress -p 4 -n 10000

Without this path:
real    0m51.058s       2m4.745s        1m28.222s       1m5.137s
user    0m0.035s        0m0.041s        0m0.105s        0m0.100s
sys     0m12.009s       0m11.246s       0m10.901s       0m10.999s       0m11.287s

With this path:
real    0m55.295s       0m50.960s       1m2.214s        0m48.273s
user    0m0.053s        0m0.095s        0m0.135s        0m0.107s
sys     0m7.766s        0m6.013s        0m6.319s        0m6.030s        0m6.532s

After applying the patch,the execute time is down by ~42%.(11.287s->6.532s)

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
Changelog v1->v2:
-fix coding style problem
---
 fs/btrfs/ulist.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ulist.h |  6 ++++++
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index ddc61ca..7b417e2 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -53,6 +53,7 @@ void ulist_init(struct ulist *ulist)
 	ulist->nnodes = 0;
 	ulist->nodes = ulist->int_nodes;
 	ulist->nodes_alloced = ULIST_SIZE;
+	ulist->root = RB_ROOT;
 }
 EXPORT_SYMBOL(ulist_init);
 
@@ -72,6 +73,7 @@ void ulist_fini(struct ulist *ulist)
 	if (ulist->nodes_alloced > ULIST_SIZE)
 		kfree(ulist->nodes);
 	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
+	ulist->root = RB_ROOT;
 }
 EXPORT_SYMBOL(ulist_fini);
 
@@ -123,6 +125,45 @@ void ulist_free(struct ulist *ulist)
 }
 EXPORT_SYMBOL(ulist_free);
 
+static struct ulist_node *ulist_rbtree_search(struct ulist *ulist, u64 val)
+{
+	struct rb_node *n = ulist->root.rb_node;
+	struct ulist_node *u = NULL;
+
+	while (n) {
+		u = rb_entry(n, struct ulist_node, rb_node);
+		if (u->val < val)
+			n = n->rb_right;
+		else if (u->val > val)
+			n = n->rb_left;
+		else
+			return u;
+	}
+	return NULL;
+}
+
+static int ulist_rbtree_insert(struct ulist *ulist, struct ulist_node *ins)
+{
+	struct rb_node **p = &ulist->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct ulist_node *cur = NULL;
+
+	while (*p) {
+		parent = *p;
+		cur = rb_entry(parent, struct ulist_node, rb_node);
+
+		if (cur->val < ins->val)
+			p = &(*p)->rb_right;
+		else if (cur->val > ins->val)
+			p = &(*p)->rb_left;
+		else
+			return -EEXIST;
+	}
+	rb_link_node(&ins->rb_node, parent, p);
+	rb_insert_color(&ins->rb_node, &ulist->root);
+	return 0;
+}
+
 /**
  * ulist_add - add an element to the ulist
  * @ulist:	ulist to add the element to
@@ -151,14 +192,13 @@ int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask)
 int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		    u64 *old_aux, gfp_t gfp_mask)
 {
-	int i;
-
-	for (i = 0; i < ulist->nnodes; ++i) {
-		if (ulist->nodes[i].val == val) {
-			if (old_aux)
-				*old_aux = ulist->nodes[i].aux;
-			return 0;
-		}
+	int ret = 0;
+	struct ulist_node *node = NULL;
+	node = ulist_rbtree_search(ulist, val);
+	if (node) {
+		if (old_aux)
+			*old_aux = node->aux;
+		return 0;
 	}
 
 	if (ulist->nnodes >= ulist->nodes_alloced) {
@@ -187,6 +227,8 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 	}
 	ulist->nodes[ulist->nnodes].val = val;
 	ulist->nodes[ulist->nnodes].aux = aux;
+	ret = ulist_rbtree_insert(ulist, &ulist->nodes[ulist->nnodes]);
+	BUG_ON(ret);
 	++ulist->nnodes;
 
 	return 1;
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 21a1963..fb36731 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -8,6 +8,9 @@
 #ifndef __ULIST__
 #define __ULIST__
 
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
 /*
  * ulist is a generic data structure to hold a collection of unique u64
  * values. The only operations it supports is adding to the list and
@@ -34,6 +37,7 @@ struct ulist_iterator {
 struct ulist_node {
 	u64 val;		/* value to store */
 	u64 aux;		/* auxiliary value saved along with the val */
+	struct rb_node rb_node;	/* used to speed up search */
 };
 
 struct ulist {
@@ -54,6 +58,8 @@ struct ulist {
 	 */
 	struct ulist_node *nodes;
 
+	struct rb_root root;
+
 	/*
 	 * inline storage space for the first ULIST_SIZE entries
 	 */
-- 
1.7.11.7

