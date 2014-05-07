Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaEGUH2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 16:07:28 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/3] btrfs-progs: import ulist
Date: Wed,  7 May 2014 13:07:16 -0700
Message-Id: <1399493237-19740-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
References: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

qgroup-verify.c wants this for walking root refs.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 Makefile     |   3 +-
 kerncompat.h |   2 +-
 ulist.c      | 253 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ulist.h      |  66 ++++++++++++++++
 4 files changed, 322 insertions(+), 2 deletions(-)
 create mode 100644 ulist.c
 create mode 100644 ulist.h

diff --git a/Makefile b/Makefile
index da05197..202013e 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,8 @@ CFLAGS = -g -O1 -fno-strict-aliasing
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o
+	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
+	  ulist.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/kerncompat.h b/kerncompat.h
index f370cd8..652275e 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -235,7 +235,7 @@ static inline long IS_ERR(const void *ptr)
 
 #define BUG_ON(c) assert(!(c))
 #define WARN_ON(c) assert(!(c))
-
+#define	ASSERT(c) assert(c)
 
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
diff --git a/ulist.c b/ulist.c
new file mode 100644
index 0000000..60fdc09
--- /dev/null
+++ b/ulist.c
@@ -0,0 +1,253 @@
+/*
+ * Copyright (C) 2011 STRATO AG
+ * written by Arne Jansen <sensille@gmx.net>
+ * Distributed under the GNU GPL license version 2.
+ */
+
+//#include <linux/slab.h>
+#include <stdlib.h>
+#include "kerncompat.h"
+#include "ulist.h"
+#include "ctree.h"
+
+/*
+ * ulist is a generic data structure to hold a collection of unique u64
+ * values. The only operations it supports is adding to the list and
+ * enumerating it.
+ * It is possible to store an auxiliary value along with the key.
+ *
+ * A sample usage for ulists is the enumeration of directed graphs without
+ * visiting a node twice. The pseudo-code could look like this:
+ *
+ * ulist = ulist_alloc();
+ * ulist_add(ulist, root);
+ * ULIST_ITER_INIT(&uiter);
+ *
+ * while ((elem = ulist_next(ulist, &uiter)) {
+ * 	for (all child nodes n in elem)
+ *		ulist_add(ulist, n);
+ *	do something useful with the node;
+ * }
+ * ulist_free(ulist);
+ *
+ * This assumes the graph nodes are adressable by u64. This stems from the
+ * usage for tree enumeration in btrfs, where the logical addresses are
+ * 64 bit.
+ *
+ * It is also useful for tree enumeration which could be done elegantly
+ * recursively, but is not possible due to kernel stack limitations. The
+ * loop would be similar to the above.
+ */
+
+/**
+ * ulist_init - freshly initialize a ulist
+ * @ulist:	the ulist to initialize
+ *
+ * Note: don't use this function to init an already used ulist, use
+ * ulist_reinit instead.
+ */
+void ulist_init(struct ulist *ulist)
+{
+	INIT_LIST_HEAD(&ulist->nodes);
+	ulist->root = RB_ROOT;
+	ulist->nnodes = 0;
+}
+
+/**
+ * ulist_fini - free up additionally allocated memory for the ulist
+ * @ulist:	the ulist from which to free the additional memory
+ *
+ * This is useful in cases where the base 'struct ulist' has been statically
+ * allocated.
+ */
+static void ulist_fini(struct ulist *ulist)
+{
+	struct ulist_node *node;
+	struct ulist_node *next;
+
+	list_for_each_entry_safe(node, next, &ulist->nodes, list) {
+		kfree(node);
+	}
+	ulist->root = RB_ROOT;
+	INIT_LIST_HEAD(&ulist->nodes);
+}
+
+/**
+ * ulist_reinit - prepare a ulist for reuse
+ * @ulist:	ulist to be reused
+ *
+ * Free up all additional memory allocated for the list elements and reinit
+ * the ulist.
+ */
+void ulist_reinit(struct ulist *ulist)
+{
+	ulist_fini(ulist);
+	ulist_init(ulist);
+}
+
+/**
+ * ulist_alloc - dynamically allocate a ulist
+ * @gfp_mask:	allocation flags to for base allocation
+ *
+ * The allocated ulist will be returned in an initialized state.
+ */
+struct ulist *ulist_alloc(gfp_t gfp_mask)
+{
+	struct ulist *ulist = kmalloc(sizeof(*ulist), gfp_mask);
+
+	if (!ulist)
+		return NULL;
+
+	ulist_init(ulist);
+
+	return ulist;
+}
+
+/**
+ * ulist_free - free dynamically allocated ulist
+ * @ulist:	ulist to free
+ *
+ * It is not necessary to call ulist_fini before.
+ */
+void ulist_free(struct ulist *ulist)
+{
+	if (!ulist)
+		return;
+	ulist_fini(ulist);
+	kfree(ulist);
+}
+
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
+/**
+ * ulist_add - add an element to the ulist
+ * @ulist:	ulist to add the element to
+ * @val:	value to add to ulist
+ * @aux:	auxiliary value to store along with val
+ * @gfp_mask:	flags to use for allocation
+ *
+ * Note: locking must be provided by the caller. In case of rwlocks write
+ *       locking is needed
+ *
+ * Add an element to a ulist. The @val will only be added if it doesn't
+ * already exist. If it is added, the auxiliary value @aux is stored along with
+ * it. In case @val already exists in the ulist, @aux is ignored, even if
+ * it differs from the already stored value.
+ *
+ * ulist_add returns 0 if @val already exists in ulist and 1 if @val has been
+ * inserted.
+ * In case of allocation failure -ENOMEM is returned and the ulist stays
+ * unaltered.
+ */
+int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask)
+{
+	return ulist_add_merge(ulist, val, aux, NULL, gfp_mask);
+}
+
+int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
+		    u64 *old_aux, gfp_t gfp_mask)
+{
+	int ret;
+	struct ulist_node *node;
+
+	node = ulist_rbtree_search(ulist, val);
+	if (node) {
+		if (old_aux)
+			*old_aux = node->aux;
+		return 0;
+	}
+	node = kmalloc(sizeof(*node), gfp_mask);
+	if (!node)
+		return -ENOMEM;
+
+	node->val = val;
+	node->aux = aux;
+#ifdef CONFIG_BTRFS_DEBUG
+	node->seqnum = ulist->nnodes;
+#endif
+
+	ret = ulist_rbtree_insert(ulist, node);
+	ASSERT(!ret);
+	list_add_tail(&node->list, &ulist->nodes);
+	ulist->nnodes++;
+
+	return 1;
+}
+
+/**
+ * ulist_next - iterate ulist
+ * @ulist:	ulist to iterate
+ * @uiter:	iterator variable, initialized with ULIST_ITER_INIT(&iterator)
+ *
+ * Note: locking must be provided by the caller. In case of rwlocks only read
+ *       locking is needed
+ *
+ * This function is used to iterate an ulist.
+ * It returns the next element from the ulist or %NULL when the
+ * end is reached. No guarantee is made with respect to the order in which
+ * the elements are returned. They might neither be returned in order of
+ * addition nor in ascending order.
+ * It is allowed to call ulist_add during an enumeration. Newly added items
+ * are guaranteed to show up in the running enumeration.
+ */
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
+{
+	struct ulist_node *node;
+
+	if (list_empty(&ulist->nodes))
+		return NULL;
+	if (uiter->cur_list && uiter->cur_list->next == &ulist->nodes)
+		return NULL;
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
+}
diff --git a/ulist.h b/ulist.h
new file mode 100644
index 0000000..2a0e948
--- /dev/null
+++ b/ulist.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2011 STRATO AG
+ * written by Arne Jansen <sensille@gmx.net>
+ * Distributed under the GNU GPL license version 2.
+ *
+ */
+
+#ifndef __ULIST__
+#define __ULIST__
+
+#include "kerncompat.h"
+#include "list.h"
+#include "rbtree.h"
+
+/*
+ * ulist is a generic data structure to hold a collection of unique u64
+ * values. The only operations it supports is adding to the list and
+ * enumerating it.
+ * It is possible to store an auxiliary value along with the key.
+ *
+ */
+struct ulist_iterator {
+#ifdef CONFIG_BTRFS_DEBUG
+	int i;
+#endif
+	struct list_head *cur_list;  /* hint to start search */
+};
+
+/*
+ * element of the list
+ */
+struct ulist_node {
+	u64 val;		/* value to store */
+	u64 aux;		/* auxiliary value saved along with the val */
+
+#ifdef CONFIG_BTRFS_DEBUG
+	int seqnum;		/* sequence number this node is added */
+#endif
+
+	struct list_head list;  /* used to link node */
+	struct rb_node rb_node;	/* used to speed up search */
+};
+
+struct ulist {
+	/*
+	 * number of elements stored in list
+	 */
+	unsigned long nnodes;
+
+	struct list_head nodes;
+	struct rb_root root;
+};
+
+void ulist_init(struct ulist *ulist);
+void ulist_reinit(struct ulist *ulist);
+struct ulist *ulist_alloc(gfp_t gfp_mask);
+void ulist_free(struct ulist *ulist);
+int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask);
+int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
+		    u64 *old_aux, gfp_t gfp_mask);
+struct ulist_node *ulist_next(struct ulist *ulist,
+			      struct ulist_iterator *uiter);
+
+#define ULIST_ITER_INIT(uiter) ((uiter)->cur_list = NULL)
+
+#endif
-- 
1.8.4

