Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:56282 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab2EZK7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:51 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 01/15] Btrfs: ulist realloc bugfix
Date: Sat, 26 May 2012 12:59:35 +0200
Message-Id: <cd1b413c5c863a96bfdeab8e91b1fb3a52665e42.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ulist_next gets the pointer to the previously returned element to find the
next element from there. However, when we call ulist_add while iteration
with ulist_next is in progress (ulist explicitly supports this), we can
realloc the ulist internal memory, which makes the pointer to the previous
element useless.

Instead, we now use an iterator parameter that's independent from the
internal pointers.

Reported-by: Alexander Block <ablock84@googlemail.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |   18 +++++++++++++-----
 fs/btrfs/ulist.c   |   23 ++++++++---------------
 fs/btrfs/ulist.h   |    9 ++++++++-
 3 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bcec067..b41d94a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -201,6 +201,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 	struct __prelim_ref *new_ref;
 	struct ulist *parents;
 	struct ulist_node *node;
+	struct ulist_iterator uiter;
 
 	parents = ulist_alloc(GFP_NOFS);
 	if (!parents)
@@ -225,11 +226,12 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 
 		/* we put the first parent into the ref at hand */
-		node = ulist_next(parents, NULL);
+		ULIST_ITER_INIT(&uiter);
+		node = ulist_next(parents, &uiter);
 		ref->parent = node ? node->val : 0;
 
 		/* additional parents require new refs being added here */
-		while ((node = ulist_next(parents, node))) {
+		while ((node = ulist_next(parents, &uiter))) {
 			new_ref = kmalloc(sizeof(*new_ref), GFP_NOFS);
 			if (!new_ref) {
 				ret = -ENOMEM;
@@ -788,6 +790,7 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
+	struct ulist_iterator uiter;
 	int ret;
 
 	tmp = ulist_alloc(GFP_NOFS);
@@ -799,6 +802,7 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
+	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, seq,
 					tmp, *roots);
@@ -807,7 +811,7 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 			ulist_free(*roots);
 			return ret;
 		}
-		node = ulist_next(tmp, node);
+		node = ulist_next(tmp, &uiter);
 		if (!node)
 			break;
 		bytenr = node->val;
@@ -1176,6 +1180,8 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	struct ulist_node *ref_node = NULL;
 	struct ulist_node *root_node = NULL;
 	struct seq_list seq_elem;
+	struct ulist_iterator ref_uiter;
+	struct ulist_iterator root_uiter;
 	struct btrfs_delayed_ref_root *delayed_refs = NULL;
 
 	pr_debug("resolving all inodes for extent %llu\n",
@@ -1201,12 +1207,14 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	if (ret)
 		goto out;
 
-	while (!ret && (ref_node = ulist_next(refs, ref_node))) {
+	ULIST_ITER_INIT(&ref_uiter);
+	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val, -1,
 						seq_elem.seq, &roots);
 		if (ret)
 			break;
-		while (!ret && (root_node = ulist_next(roots, root_node))) {
+		ULIST_ITER_INIT(&root_uiter);
+		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
 			pr_debug("root %llu references leaf %llu\n",
 					root_node->val, ref_node->val);
 			ret = iterate_leaf_refs(fs_info, ref_node->val,
diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 12f5147..17e68bd 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -23,9 +23,9 @@
  *
  * ulist = ulist_alloc();
  * ulist_add(ulist, root);
- * elem = NULL;
+ * ULIST_ITER_INIT(&uiter);
  *
- * while ((elem = ulist_next(ulist, elem)) {
+ * while ((elem = ulist_next(ulist, &uiter)) {
  * 	for (all child nodes n in elem)
  *		ulist_add(ulist, n);
  *	do something useful with the node;
@@ -188,33 +188,26 @@ EXPORT_SYMBOL(ulist_add);
 /**
  * ulist_next - iterate ulist
  * @ulist:	ulist to iterate
- * @prev:	previously returned element or %NULL to start iteration
+ * @uiter:	iterator variable, initialized with ULIST_ITER_INIT(&iterator)
  *
  * Note: locking must be provided by the caller. In case of rwlocks only read
  *       locking is needed
  *
- * This function is used to iterate an ulist. The iteration is started with
- * @prev = %NULL. It returns the next element from the ulist or %NULL when the
+ * This function is used to iterate an ulist.
+ * It returns the next element from the ulist or %NULL when the
  * end is reached. No guarantee is made with respect to the order in which
  * the elements are returned. They might neither be returned in order of
  * addition nor in ascending order.
  * It is allowed to call ulist_add during an enumeration. Newly added items
  * are guaranteed to show up in the running enumeration.
  */
-struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev)
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 {
-	int next;
-
 	if (ulist->nnodes == 0)
 		return NULL;
-
-	if (!prev)
-		return &ulist->nodes[0];
-
-	next = (prev - ulist->nodes) + 1;
-	if (next < 0 || next >= ulist->nnodes)
+	if (uiter->i < 0 || uiter->i >= ulist->nnodes)
 		return NULL;
 
-	return &ulist->nodes[next];
+	return &ulist->nodes[uiter->i++];
 }
 EXPORT_SYMBOL(ulist_next);
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 2e25dec..62d2574 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -24,6 +24,10 @@
  */
 #define ULIST_SIZE 16
 
+struct ulist_iterator {
+	int i;
+};
+
 /*
  * element of the list
  */
@@ -63,6 +67,9 @@ struct ulist *ulist_alloc(unsigned long gfp_mask);
 void ulist_free(struct ulist *ulist);
 int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
 	      unsigned long gfp_mask);
-struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev);
+struct ulist_node *ulist_next(struct ulist *ulist,
+			      struct ulist_iterator *uiter);
+
+#define ULIST_ITER_INIT(uiter) ((uiter)->i = 0)
 
 #endif
-- 
1.7.3.4

