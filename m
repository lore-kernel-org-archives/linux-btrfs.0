Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50142 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbaJJU5d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:33 -0400
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id s9AKqNRJ007701
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:32 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by m0004347.ppops.net with ESMTP id 1pxkqwge53-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:31 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/12] Btrfs-progs: update rbtree libs
Date: Fri, 10 Oct 2014 16:57:09 -0400
Message-ID: <1412974637-31334-5-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While debugging a broken fs we were seeing hangs in the rb_erase loops.  The
rbtree was simple and wasn't corrupted so it appeared to be a bug in our rbtree
library.  Updating to the kernels latest rbtree code made the infinite loop go
away, so pull it back.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 kerncompat.h       |   5 +
 rbtree.c           | 667 +++++++++++++++++++++++++++++++++--------------------
 rbtree.h           | 142 ++++--------
 rbtree_augmented.h | 231 +++++++++++++++++++
 4 files changed, 695 insertions(+), 350 deletions(-)
 create mode 100644 rbtree_augmented.h

diff --git a/kerncompat.h b/kerncompat.h
index ea34936..a1336de 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -330,6 +330,11 @@ struct __una_u64 { __le64 x; } __attribute__((__packed__));
 #define put_unaligned_le64(val,p) (((struct __una_u64 *)(p))->x = cpu_to_le64(val))
 #endif
 
+#ifndef true
+#define true 1
+#define false 0
+#endif
+
 #ifndef noinline
 #define noinline
 #endif
diff --git a/rbtree.c b/rbtree.c
index 6ad800f..92590a5 100644
--- a/rbtree.c
+++ b/rbtree.c
@@ -2,7 +2,8 @@
   Red Black Trees
   (C) 1999  Andrea Arcangeli <andrea@suse.de>
   (C) 2002  David Woodhouse <dwmw2@infradead.org>
-  
+  (C) 2012  Michel Lespinasse <walken@google.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
@@ -20,276 +21,396 @@
   linux/lib/rbtree.c
 */
 
-#include "rbtree.h"
-
-static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *right = node->rb_right;
-	struct rb_node *parent = rb_parent(node);
+#include "rbtree_augmented.h"
 
-	if ((node->rb_right = right->rb_left))
-		rb_set_parent(right->rb_left, node);
-	right->rb_left = node;
-
-	rb_set_parent(right, parent);
+/*
+ * red-black trees properties:  http://en.wikipedia.org/wiki/Rbtree
+ *
+ *  1) A node is either red or black
+ *  2) The root is black
+ *  3) All leaves (NULL) are black
+ *  4) Both children of every red node are black
+ *  5) Every simple path from root to leaves contains the same number
+ *     of black nodes.
+ *
+ *  4 and 5 give the O(log n) guarantee, since 4 implies you cannot have two
+ *  consecutive red nodes in a path and every red node is therefore followed by
+ *  a black. So if B is the number of black nodes on every simple path (as per
+ *  5), then the longest possible path due to 4 is 2B.
+ *
+ *  We shall indicate color with case, where black nodes are uppercase and red
+ *  nodes will be lowercase. Unknown color nodes shall be drawn as red within
+ *  parentheses and have some accompanying text comment.
+ */
 
-	if (parent)
-	{
-		if (node == parent->rb_left)
-			parent->rb_left = right;
-		else
-			parent->rb_right = right;
-	}
-	else
-		root->rb_node = right;
-	rb_set_parent(node, right);
+static inline void rb_set_black(struct rb_node *rb)
+{
+	rb->__rb_parent_color |= RB_BLACK;
 }
 
-static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
+static inline struct rb_node *rb_red_parent(struct rb_node *red)
 {
-	struct rb_node *left = node->rb_left;
-	struct rb_node *parent = rb_parent(node);
-
-	if ((node->rb_left = left->rb_right))
-		rb_set_parent(left->rb_right, node);
-	left->rb_right = node;
-
-	rb_set_parent(left, parent);
+	return (struct rb_node *)red->__rb_parent_color;
+}
 
-	if (parent)
-	{
-		if (node == parent->rb_right)
-			parent->rb_right = left;
-		else
-			parent->rb_left = left;
-	}
-	else
-		root->rb_node = left;
-	rb_set_parent(node, left);
+/*
+ * Helper function for rotations:
+ * - old's parent and color get assigned to new
+ * - old gets assigned new as a parent and 'color' as a color.
+ */
+static inline void
+__rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
+			struct rb_root *root, int color)
+{
+	struct rb_node *parent = rb_parent(old);
+	new->__rb_parent_color = old->__rb_parent_color;
+	rb_set_parent_color(old, new, color);
+	__rb_change_child(old, new, parent, root);
 }
 
-void rb_insert_color(struct rb_node *node, struct rb_root *root)
+static __always_inline void
+__rb_insert(struct rb_node *node, struct rb_root *root,
+	    void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
-	struct rb_node *parent, *gparent;
-
-	while ((parent = rb_parent(node)) && rb_is_red(parent))
-	{
-		gparent = rb_parent(parent);
-
-		if (parent == gparent->rb_left)
-		{
-			{
-				register struct rb_node *uncle = gparent->rb_right;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
+	struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
+
+	while (true) {
+		/*
+		 * Loop invariant: node is red
+		 *
+		 * If there is a black parent, we are done.
+		 * Otherwise, take some corrective action as we don't
+		 * want a red root or two consecutive red nodes.
+		 */
+		if (!parent) {
+			rb_set_parent_color(node, NULL, RB_BLACK);
+			break;
+		} else if (rb_is_black(parent))
+			break;
+
+		gparent = rb_red_parent(parent);
+
+		tmp = gparent->rb_right;
+		if (parent != tmp) {	/* parent == gparent->rb_left */
+			if (tmp && rb_is_red(tmp)) {
+				/*
+				 * Case 1 - color flips
+				 *
+				 *       G            g
+				 *      / \          / \
+				 *     p   u  -->   P   U
+				 *    /            /
+				 *   n            n
+				 *
+				 * However, since g's parent might be red, and
+				 * 4) does not allow this, we need to recurse
+				 * at g.
+				 */
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+				rb_set_parent_color(parent, gparent, RB_BLACK);
+				node = gparent;
+				parent = rb_parent(node);
+				rb_set_parent_color(node, parent, RB_RED);
+				continue;
 			}
 
-			if (parent->rb_right == node)
-			{
-				register struct rb_node *tmp;
-				__rb_rotate_left(parent, root);
-				tmp = parent;
+			tmp = parent->rb_right;
+			if (node == tmp) {
+				/*
+				 * Case 2 - left rotate at parent
+				 *
+				 *      G             G
+				 *     / \           / \
+				 *    p   U  -->    n   U
+				 *     \           /
+				 *      n         p
+				 *
+				 * This still leaves us in violation of 4), the
+				 * continuation into Case 3 will fix that.
+				 */
+				parent->rb_right = tmp = node->rb_left;
+				node->rb_left = parent;
+				if (tmp)
+					rb_set_parent_color(tmp, parent,
+							    RB_BLACK);
+				rb_set_parent_color(parent, node, RB_RED);
+				augment_rotate(parent, node);
 				parent = node;
-				node = tmp;
+				tmp = node->rb_right;
 			}
 
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_right(gparent, root);
+			/*
+			 * Case 3 - right rotate at gparent
+			 *
+			 *        G           P
+			 *       / \         / \
+			 *      p   U  -->  n   g
+			 *     /                 \
+			 *    n                   U
+			 */
+			gparent->rb_left = tmp;  /* == parent->rb_right */
+			parent->rb_right = gparent;
+			if (tmp)
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
+			augment_rotate(gparent, parent);
+			break;
 		} else {
-			{
-				register struct rb_node *uncle = gparent->rb_left;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
+			tmp = gparent->rb_left;
+			if (tmp && rb_is_red(tmp)) {
+				/* Case 1 - color flips */
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+				rb_set_parent_color(parent, gparent, RB_BLACK);
+				node = gparent;
+				parent = rb_parent(node);
+				rb_set_parent_color(node, parent, RB_RED);
+				continue;
 			}
 
-			if (parent->rb_left == node)
-			{
-				register struct rb_node *tmp;
-				__rb_rotate_right(parent, root);
-				tmp = parent;
+			tmp = parent->rb_left;
+			if (node == tmp) {
+				/* Case 2 - right rotate at parent */
+				parent->rb_left = tmp = node->rb_right;
+				node->rb_right = parent;
+				if (tmp)
+					rb_set_parent_color(tmp, parent,
+							    RB_BLACK);
+				rb_set_parent_color(parent, node, RB_RED);
+				augment_rotate(parent, node);
 				parent = node;
-				node = tmp;
+				tmp = node->rb_left;
 			}
 
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_left(gparent, root);
+			/* Case 3 - left rotate at gparent */
+			gparent->rb_right = tmp;  /* == parent->rb_left */
+			parent->rb_left = gparent;
+			if (tmp)
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
+			augment_rotate(gparent, parent);
+			break;
 		}
 	}
-
-	rb_set_black(root->rb_node);
 }
 
-static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
-			     struct rb_root *root)
+/*
+ * Inline version for rb_erase() use - we want to be able to inline
+ * and eliminate the dummy_rotate callback there
+ */
+static __always_inline void
+____rb_erase_color(struct rb_node *parent, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
-	struct rb_node *other;
-
-	while ((!node || rb_is_black(node)) && node != root->rb_node)
-	{
-		if (parent->rb_left == node)
-		{
-			other = parent->rb_right;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_left(parent, root);
-				other = parent->rb_right;
-			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
+	struct rb_node *node = NULL, *sibling, *tmp1, *tmp2;
+
+	while (true) {
+		/*
+		 * Loop invariants:
+		 * - node is black (or NULL on first iteration)
+		 * - node is not the root (parent is not NULL)
+		 * - All leaf paths going through parent and node have a
+		 *   black node count that is 1 lower than other leaf paths.
+		 */
+		sibling = parent->rb_right;
+		if (node != sibling) {	/* node == parent->rb_left */
+			if (rb_is_red(sibling)) {
+				/*
+				 * Case 1 - left rotate at parent
+				 *
+				 *     P               S
+				 *    / \             / \
+				 *   N   s    -->    p   Sr
+				 *      / \         / \
+				 *     Sl  Sr      N   Sl
+				 */
+				parent->rb_right = tmp1 = sibling->rb_left;
+				sibling->rb_left = parent;
+				rb_set_parent_color(tmp1, parent, RB_BLACK);
+				__rb_rotate_set_parents(parent, sibling, root,
+							RB_RED);
+				augment_rotate(parent, sibling);
+				sibling = tmp1;
 			}
-			else
-			{
-				if (!other->rb_right || rb_is_black(other->rb_right))
-				{
-					struct rb_node *o_left;
-					if ((o_left = other->rb_left))
-						rb_set_black(o_left);
-					rb_set_red(other);
-					__rb_rotate_right(other, root);
-					other = parent->rb_right;
+			tmp1 = sibling->rb_right;
+			if (!tmp1 || rb_is_black(tmp1)) {
+				tmp2 = sibling->rb_left;
+				if (!tmp2 || rb_is_black(tmp2)) {
+					/*
+					 * Case 2 - sibling color flip
+					 * (p could be either color here)
+					 *
+					 *    (p)           (p)
+					 *    / \           / \
+					 *   N   S    -->  N   s
+					 *      / \           / \
+					 *     Sl  Sr        Sl  Sr
+					 *
+					 * This leaves us violating 5) which
+					 * can be fixed by flipping p to black
+					 * if it was red, or by recursing at p.
+					 * p is red when coming from Case 1.
+					 */
+					rb_set_parent_color(sibling, parent,
+							    RB_RED);
+					if (rb_is_red(parent))
+						rb_set_black(parent);
+					else {
+						node = parent;
+						parent = rb_parent(node);
+						if (parent)
+							continue;
+					}
+					break;
 				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				if (other->rb_right)
-					rb_set_black(other->rb_right);
-				__rb_rotate_left(parent, root);
-				node = root->rb_node;
-				break;
+				/*
+				 * Case 3 - right rotate at sibling
+				 * (p could be either color here)
+				 *
+				 *   (p)           (p)
+				 *   / \           / \
+				 *  N   S    -->  N   Sl
+				 *     / \             \
+				 *    sl  Sr            s
+				 *                       \
+				 *                        Sr
+				 */
+				sibling->rb_left = tmp1 = tmp2->rb_right;
+				tmp2->rb_right = sibling;
+				parent->rb_right = tmp2;
+				if (tmp1)
+					rb_set_parent_color(tmp1, sibling,
+							    RB_BLACK);
+				augment_rotate(sibling, tmp2);
+				tmp1 = sibling;
+				sibling = tmp2;
 			}
-		}
-		else
-		{
-			other = parent->rb_left;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_right(parent, root);
-				other = parent->rb_left;
-			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
+			/*
+			 * Case 4 - left rotate at parent + color flips
+			 * (p and sl could be either color here.
+			 *  After rotation, p becomes black, s acquires
+			 *  p's color, and sl keeps its color)
+			 *
+			 *      (p)             (s)
+			 *      / \             / \
+			 *     N   S     -->   P   Sr
+			 *        / \         / \
+			 *      (sl) sr      N  (sl)
+			 */
+			parent->rb_right = tmp2 = sibling->rb_left;
+			sibling->rb_left = parent;
+			rb_set_parent_color(tmp1, sibling, RB_BLACK);
+			if (tmp2)
+				rb_set_parent(tmp2, parent);
+			__rb_rotate_set_parents(parent, sibling, root,
+						RB_BLACK);
+			augment_rotate(parent, sibling);
+			break;
+		} else {
+			sibling = parent->rb_left;
+			if (rb_is_red(sibling)) {
+				/* Case 1 - right rotate at parent */
+				parent->rb_left = tmp1 = sibling->rb_right;
+				sibling->rb_right = parent;
+				rb_set_parent_color(tmp1, parent, RB_BLACK);
+				__rb_rotate_set_parents(parent, sibling, root,
+							RB_RED);
+				augment_rotate(parent, sibling);
+				sibling = tmp1;
 			}
-			else
-			{
-				if (!other->rb_left || rb_is_black(other->rb_left))
-				{
-					register struct rb_node *o_right;
-					if ((o_right = other->rb_right))
-						rb_set_black(o_right);
-					rb_set_red(other);
-					__rb_rotate_left(other, root);
-					other = parent->rb_left;
+			tmp1 = sibling->rb_left;
+			if (!tmp1 || rb_is_black(tmp1)) {
+				tmp2 = sibling->rb_right;
+				if (!tmp2 || rb_is_black(tmp2)) {
+					/* Case 2 - sibling color flip */
+					rb_set_parent_color(sibling, parent,
+							    RB_RED);
+					if (rb_is_red(parent))
+						rb_set_black(parent);
+					else {
+						node = parent;
+						parent = rb_parent(node);
+						if (parent)
+							continue;
+					}
+					break;
 				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				if (other->rb_left)
-					rb_set_black(other->rb_left);
-				__rb_rotate_right(parent, root);
-				node = root->rb_node;
-				break;
+				/* Case 3 - right rotate at sibling */
+				sibling->rb_right = tmp1 = tmp2->rb_left;
+				tmp2->rb_left = sibling;
+				parent->rb_left = tmp2;
+				if (tmp1)
+					rb_set_parent_color(tmp1, sibling,
+							    RB_BLACK);
+				augment_rotate(sibling, tmp2);
+				tmp1 = sibling;
+				sibling = tmp2;
 			}
+			/* Case 4 - left rotate at parent + color flips */
+			parent->rb_left = tmp2 = sibling->rb_right;
+			sibling->rb_right = parent;
+			rb_set_parent_color(tmp1, sibling, RB_BLACK);
+			if (tmp2)
+				rb_set_parent(tmp2, parent);
+			__rb_rotate_set_parents(parent, sibling, root,
+						RB_BLACK);
+			augment_rotate(parent, sibling);
+			break;
 		}
 	}
-	if (node)
-		rb_set_black(node);
+}
+
+/* Non-inline version for rb_erase_augmented() use */
+void __rb_erase_color(struct rb_node *parent, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
+{
+	____rb_erase_color(parent, root, augment_rotate);
+}
+
+/*
+ * Non-augmented rbtree manipulation functions.
+ *
+ * We use dummy augmented callbacks here, and have the compiler optimize them
+ * out of the rb_insert_color() and rb_erase() function definitions.
+ */
+
+static inline void dummy_propagate(struct rb_node *node, struct rb_node *stop) {}
+static inline void dummy_copy(struct rb_node *old, struct rb_node *new) {}
+static inline void dummy_rotate(struct rb_node *old, struct rb_node *new) {}
+
+static const struct rb_augment_callbacks dummy_callbacks = {
+	dummy_propagate, dummy_copy, dummy_rotate
+};
+
+void rb_insert_color(struct rb_node *node, struct rb_root *root)
+{
+	__rb_insert(node, root, dummy_rotate);
 }
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *child, *parent;
-	int color;
-
-	if (!node->rb_left)
-		child = node->rb_right;
-	else if (!node->rb_right)
-		child = node->rb_left;
-	else
-	{
-		struct rb_node *old = node, *left;
-
-		node = node->rb_right;
-		while ((left = node->rb_left) != NULL)
-			node = left;
-		child = node->rb_right;
-		parent = rb_parent(node);
-		color = rb_color(node);
-
-		if (child)
-			rb_set_parent(child, parent);
-		if (parent == old) {
-			parent->rb_right = child;
-			parent = node;
-		} else
-			parent->rb_left = child;
-
-		node->rb_parent_color = old->rb_parent_color;
-		node->rb_right = old->rb_right;
-		node->rb_left = old->rb_left;
-
-		if (rb_parent(old))
-		{
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
-
-		rb_set_parent(old->rb_left, node);
-		if (old->rb_right)
-			rb_set_parent(old->rb_right, node);
-		goto color;
-	}
+	struct rb_node *rebalance;
+	rebalance = __rb_erase_augmented(node, root, &dummy_callbacks);
+	if (rebalance)
+		____rb_erase_color(rebalance, root, dummy_rotate);
+}
 
-	parent = rb_parent(node);
-	color = rb_color(node);
-
-	if (child)
-		rb_set_parent(child, parent);
-	if (parent)
-	{
-		if (parent->rb_left == node)
-			parent->rb_left = child;
-		else
-			parent->rb_right = child;
-	}
-	else
-		root->rb_node = child;
+/*
+ * Augmented rbtree manipulation functions.
+ *
+ * This instantiates the same __always_inline functions as in the non-augmented
+ * case, but this time with user-defined callbacks.
+ */
 
- color:
-	if (color == RB_BLACK)
-		__rb_erase_color(child, parent, root);
+void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
+{
+	__rb_insert(node, root, augment_rotate);
 }
 
 /*
  * This function returns the first node (in sort order) of the tree.
  */
-struct rb_node *rb_first(struct rb_root *root)
+struct rb_node *rb_first(const struct rb_root *root)
 {
 	struct rb_node	*n;
 
@@ -301,7 +422,7 @@ struct rb_node *rb_first(struct rb_root *root)
 	return n;
 }
 
-struct rb_node *rb_last(struct rb_root *root)
+struct rb_node *rb_last(const struct rb_root *root)
 {
 	struct rb_node	*n;
 
@@ -313,52 +434,59 @@ struct rb_node *rb_last(struct rb_root *root)
 	return n;
 }
 
-struct rb_node *rb_next(struct rb_node *node)
+struct rb_node *rb_next(const struct rb_node *node)
 {
 	struct rb_node *parent;
 
-	if (rb_parent(node) == node)
+	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a right-hand child, go down and then left as far
-	   as we can. */
+	/*
+	 * If we have a right-hand child, go down and then left as far
+	 * as we can.
+	 */
 	if (node->rb_right) {
 		node = node->rb_right; 
 		while (node->rb_left)
 			node=node->rb_left;
-		return node;
+		return (struct rb_node *)node;
 	}
 
-	/* No right-hand children.  Everything down and left is
-	   smaller than us, so any 'next' node must be in the general
-	   direction of our parent. Go up the tree; any time the
-	   ancestor is a right-hand child of its parent, keep going
-	   up. First time it's a left-hand child of its parent, said
-	   parent is our 'next' node. */
+	/*
+	 * No right-hand children. Everything down and left is smaller than us,
+	 * so any 'next' node must be in the general direction of our parent.
+	 * Go up the tree; any time the ancestor is a right-hand child of its
+	 * parent, keep going up. First time it's a left-hand child of its
+	 * parent, said parent is our 'next' node.
+	 */
 	while ((parent = rb_parent(node)) && node == parent->rb_right)
 		node = parent;
 
 	return parent;
 }
 
-struct rb_node *rb_prev(struct rb_node *node)
+struct rb_node *rb_prev(const struct rb_node *node)
 {
 	struct rb_node *parent;
 
-	if (rb_parent(node) == node)
+	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a left-hand child, go down and then right as far
-	   as we can. */
+	/*
+	 * If we have a left-hand child, go down and then right as far
+	 * as we can.
+	 */
 	if (node->rb_left) {
 		node = node->rb_left; 
 		while (node->rb_right)
 			node=node->rb_right;
-		return node;
+		return (struct rb_node *)node;
 	}
 
-	/* No left-hand children. Go up till we find an ancestor which
-	   is a right-hand child of its parent */
+	/*
+	 * No left-hand children. Go up till we find an ancestor which
+	 * is a right-hand child of its parent.
+	 */
 	while ((parent = rb_parent(node)) && node == parent->rb_left)
 		node = parent;
 
@@ -371,14 +499,7 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
 	struct rb_node *parent = rb_parent(victim);
 
 	/* Set the surrounding nodes to point to the replacement */
-	if (parent) {
-		if (victim == parent->rb_left)
-			parent->rb_left = new;
-		else
-			parent->rb_right = new;
-	} else {
-		root->rb_node = new;
-	}
+	__rb_change_child(victim, new, parent, root);
 	if (victim->rb_left)
 		rb_set_parent(victim->rb_left, new);
 	if (victim->rb_right)
@@ -387,3 +508,41 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
 	/* Copy the pointers/colour from the victim to the replacement */
 	*new = *victim;
 }
+
+static struct rb_node *rb_left_deepest_node(const struct rb_node *node)
+{
+	for (;;) {
+		if (node->rb_left)
+			node = node->rb_left;
+		else if (node->rb_right)
+			node = node->rb_right;
+		else
+			return (struct rb_node *)node;
+	}
+}
+
+struct rb_node *rb_next_postorder(const struct rb_node *node)
+{
+	const struct rb_node *parent;
+	if (!node)
+		return NULL;
+	parent = rb_parent(node);
+
+	/* If we're sitting on node, we've already seen our children */
+	if (parent && node == parent->rb_left && parent->rb_right) {
+		/* If we are the parent's left node, go to the parent's right
+		 * node then all the way down to the left */
+		return rb_left_deepest_node(parent->rb_right);
+	} else
+		/* Otherwise we are the parent's right node, and the parent
+		 * should be next */
+		return (struct rb_node *)parent;
+}
+
+struct rb_node *rb_first_postorder(const struct rb_root *root)
+{
+	if (!root->rb_node)
+		return NULL;
+
+	return rb_left_deepest_node(root->rb_node);
+}
diff --git a/rbtree.h b/rbtree.h
index 3add424..03c06d8 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -23,72 +23,7 @@
   I know it's not the cleaner way,  but in C (not in C++) to get
   performances and genericity...
 
-  Some example of insert and search follows here. The search is a plain
-  normal search over an ordered tree. The insert instead must be implemented
-  int two steps: as first thing the code must insert the element in
-  order as a red leaf in the tree, then the support library function
-  rb_insert_color() must be called. Such function will do the
-  not trivial work to rebalance the rbtree if necessary.
-
------------------------------------------------------------------------
-static inline struct page * rb_search_page_cache(struct inode * inode,
-						 unsigned long offset)
-{
-	struct rb_node * n = inode->i_rb_page_cache.rb_node;
-	struct page * page;
-
-	while (n)
-	{
-		page = rb_entry(n, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			n = n->rb_left;
-		else if (offset > page->offset)
-			n = n->rb_right;
-		else
-			return page;
-	}
-	return NULL;
-}
-
-static inline struct page * __rb_insert_page_cache(struct inode * inode,
-						   unsigned long offset,
-						   struct rb_node * node)
-{
-	struct rb_node ** p = &inode->i_rb_page_cache.rb_node;
-	struct rb_node * parent = NULL;
-	struct page * page;
-
-	while (*p)
-	{
-		parent = *p;
-		page = rb_entry(parent, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			p = &(*p)->rb_left;
-		else if (offset > page->offset)
-			p = &(*p)->rb_right;
-		else
-			return page;
-	}
-
-	rb_link_node(node, parent, p);
-
-	return NULL;
-}
-
-static inline struct page * rb_insert_page_cache(struct inode * inode,
-						 unsigned long offset,
-						 struct rb_node * node)
-{
-	struct page * ret;
-	if ((ret = __rb_insert_page_cache(inode, offset, node)))
-		goto out;
-	rb_insert_color(node, &inode->i_rb_page_cache);
- out:
-	return ret;
-}
------------------------------------------------------------------------
+  See Documentation/rbtree.txt for documentation and samples.
 */
 
 #ifndef	_LINUX_RBTREE_H
@@ -98,63 +33,78 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 #else
 #include <btrfs/kerncompat.h>
 #endif /* BTRFS_FLAT_INCLUDES */
-struct rb_node
-{
-	unsigned long  rb_parent_color;
-#define	RB_RED		0
-#define	RB_BLACK	1
+
+struct rb_node {
+	unsigned long  __rb_parent_color;
 	struct rb_node *rb_right;
 	struct rb_node *rb_left;
 } __attribute__((aligned(sizeof(long))));
     /* The alignment might seem pointless, but allegedly CRIS needs it */
 
-struct rb_root
-{
+struct rb_root {
 	struct rb_node *rb_node;
 };
 
-#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
-#define rb_color(r)   ((r)->rb_parent_color & 1)
-#define rb_is_red(r)   (!rb_color(r))
-#define rb_is_black(r) rb_color(r)
-#define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
-#define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
 
-static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & 3) | (unsigned long)p;
-}
-static inline void rb_set_color(struct rb_node *rb, int color)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
-}
+#define rb_parent(r)   ((struct rb_node *)((r)->__rb_parent_color & ~3))
 
 #define RB_ROOT	(struct rb_root) { NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
-#define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
-#define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
-#define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
+#define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
+
+/* 'empty' nodes are nodes that are known not to be inserted in an rbree */
+#define RB_EMPTY_NODE(node)  \
+	((node)->__rb_parent_color == (unsigned long)(node))
+#define RB_CLEAR_NODE(node)  \
+	((node)->__rb_parent_color = (unsigned long)(node))
+
 
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
+
 /* Find logical next and previous nodes in a tree */
-extern struct rb_node *rb_next(struct rb_node *);
-extern struct rb_node *rb_prev(struct rb_node *);
-extern struct rb_node *rb_first(struct rb_root *);
-extern struct rb_node *rb_last(struct rb_root *);
+extern struct rb_node *rb_next(const struct rb_node *);
+extern struct rb_node *rb_prev(const struct rb_node *);
+extern struct rb_node *rb_first(const struct rb_root *);
+extern struct rb_node *rb_last(const struct rb_root *);
+
+/* Postorder iteration - always visit the parent after its children */
+extern struct rb_node *rb_first_postorder(const struct rb_root *);
+extern struct rb_node *rb_next_postorder(const struct rb_node *);
 
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
-extern void rb_replace_node(struct rb_node *victim, struct rb_node *xnew,
+extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
 			    struct rb_root *root);
 
 static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 				struct rb_node ** rb_link)
 {
-	node->rb_parent_color = (unsigned long )parent;
+	node->__rb_parent_color = (unsigned long)parent;
 	node->rb_left = node->rb_right = NULL;
 
 	*rb_link = node;
 }
+
+#define rb_entry_safe(ptr, type, member) \
+	({ typeof(ptr) ____ptr = (ptr); \
+	   ____ptr ? rb_entry(____ptr, type, member) : NULL; \
+	})
+
+/**
+ * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
+ * given type safe against removal of rb_node entry
+ *
+ * @pos:	the 'type *' to use as a loop cursor.
+ * @n:		another 'type *' to use as temporary storage
+ * @root:	'rb_root *' of the rbtree.
+ * @field:	the name of the rb_node field within 'type'.
+ */
+#define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
+	for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
+	     pos && ({ n = rb_entry_safe(rb_next_postorder(&pos->field), \
+			typeof(*pos), field); 1; }); \
+	     pos = n)
+
 #endif	/* _LINUX_RBTREE_H */
diff --git a/rbtree_augmented.h b/rbtree_augmented.h
new file mode 100644
index 0000000..079eb97
--- /dev/null
+++ b/rbtree_augmented.h
@@ -0,0 +1,231 @@
+/*
+  Red Black Trees
+  (C) 1999  Andrea Arcangeli <andrea@suse.de>
+  (C) 2002  David Woodhouse <dwmw2@infradead.org>
+  (C) 2012  Michel Lespinasse <walken@google.com>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  linux/include/linux/rbtree_augmented.h
+*/
+
+#ifndef _LINUX_RBTREE_AUGMENTED_H
+#define _LINUX_RBTREE_AUGMENTED_H
+
+#include "rbtree.h"
+
+/*
+ * Please note - only struct rb_augment_callbacks and the prototypes for
+ * rb_insert_augmented() and rb_erase_augmented() are intended to be public.
+ * The rest are implementation details you are not expected to depend on.
+ *
+ * See Documentation/rbtree.txt for documentation and samples.
+ */
+
+struct rb_augment_callbacks {
+	void (*propagate)(struct rb_node *node, struct rb_node *stop);
+	void (*copy)(struct rb_node *old, struct rb_node *new);
+	void (*rotate)(struct rb_node *old, struct rb_node *new);
+};
+
+extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
+static inline void
+rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+		    const struct rb_augment_callbacks *augment)
+{
+	__rb_insert_augmented(node, root, augment->rotate);
+}
+
+#define RB_DECLARE_CALLBACKS(rbstatic, rbname, rbstruct, rbfield,	\
+			     rbtype, rbaugmented, rbcompute)		\
+static inline void							\
+rbname ## _propagate(struct rb_node *rb, struct rb_node *stop)		\
+{									\
+	while (rb != stop) {						\
+		rbstruct *node = rb_entry(rb, rbstruct, rbfield);	\
+		rbtype augmented = rbcompute(node);			\
+		if (node->rbaugmented == augmented)			\
+			break;						\
+		node->rbaugmented = augmented;				\
+		rb = rb_parent(&node->rbfield);				\
+	}								\
+}									\
+static inline void							\
+rbname ## _copy(struct rb_node *rb_old, struct rb_node *rb_new)		\
+{									\
+	rbstruct *old = rb_entry(rb_old, rbstruct, rbfield);		\
+	rbstruct *new = rb_entry(rb_new, rbstruct, rbfield);		\
+	new->rbaugmented = old->rbaugmented;				\
+}									\
+static void								\
+rbname ## _rotate(struct rb_node *rb_old, struct rb_node *rb_new)	\
+{									\
+	rbstruct *old = rb_entry(rb_old, rbstruct, rbfield);		\
+	rbstruct *new = rb_entry(rb_new, rbstruct, rbfield);		\
+	new->rbaugmented = old->rbaugmented;				\
+	old->rbaugmented = rbcompute(old);				\
+}									\
+rbstatic const struct rb_augment_callbacks rbname = {			\
+	rbname ## _propagate, rbname ## _copy, rbname ## _rotate	\
+};
+
+
+#define	RB_RED		0
+#define	RB_BLACK	1
+
+#define __rb_parent(pc)    ((struct rb_node *)(pc & ~3))
+
+#define __rb_color(pc)     ((pc) & 1)
+#define __rb_is_black(pc)  __rb_color(pc)
+#define __rb_is_red(pc)    (!__rb_color(pc))
+#define rb_color(rb)       __rb_color((rb)->__rb_parent_color)
+#define rb_is_red(rb)      __rb_is_red((rb)->__rb_parent_color)
+#define rb_is_black(rb)    __rb_is_black((rb)->__rb_parent_color)
+
+static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
+{
+	rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
+}
+
+static inline void rb_set_parent_color(struct rb_node *rb,
+				       struct rb_node *p, int color)
+{
+	rb->__rb_parent_color = (unsigned long)p | color;
+}
+
+static inline void
+__rb_change_child(struct rb_node *old, struct rb_node *new,
+		  struct rb_node *parent, struct rb_root *root)
+{
+	if (parent) {
+		if (parent->rb_left == old)
+			parent->rb_left = new;
+		else
+			parent->rb_right = new;
+	} else
+		root->rb_node = new;
+}
+
+extern void __rb_erase_color(struct rb_node *parent, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
+
+static __always_inline struct rb_node *
+__rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+		     const struct rb_augment_callbacks *augment)
+{
+	struct rb_node *child = node->rb_right, *tmp = node->rb_left;
+	struct rb_node *parent, *rebalance;
+	unsigned long pc;
+
+	if (!tmp) {
+		/*
+		 * Case 1: node to erase has no more than 1 child (easy!)
+		 *
+		 * Note that if there is one child it must be red due to 5)
+		 * and node must be black due to 4). We adjust colors locally
+		 * so as to bypass __rb_erase_color() later on.
+		 */
+		pc = node->__rb_parent_color;
+		parent = __rb_parent(pc);
+		__rb_change_child(node, child, parent, root);
+		if (child) {
+			child->__rb_parent_color = pc;
+			rebalance = NULL;
+		} else
+			rebalance = __rb_is_black(pc) ? parent : NULL;
+		tmp = parent;
+	} else if (!child) {
+		/* Still case 1, but this time the child is node->rb_left */
+		tmp->__rb_parent_color = pc = node->__rb_parent_color;
+		parent = __rb_parent(pc);
+		__rb_change_child(node, tmp, parent, root);
+		rebalance = NULL;
+		tmp = parent;
+	} else {
+		struct rb_node *successor = child, *child2;
+		tmp = child->rb_left;
+		if (!tmp) {
+			/*
+			 * Case 2: node's successor is its right child
+			 *
+			 *    (n)          (s)
+			 *    / \          / \
+			 *  (x) (s)  ->  (x) (c)
+			 *        \
+			 *        (c)
+			 */
+			parent = successor;
+			child2 = successor->rb_right;
+			augment->copy(node, successor);
+		} else {
+			/*
+			 * Case 3: node's successor is leftmost under
+			 * node's right child subtree
+			 *
+			 *    (n)          (s)
+			 *    / \          / \
+			 *  (x) (y)  ->  (x) (y)
+			 *      /            /
+			 *    (p)          (p)
+			 *    /            /
+			 *  (s)          (c)
+			 *    \
+			 *    (c)
+			 */
+			do {
+				parent = successor;
+				successor = tmp;
+				tmp = tmp->rb_left;
+			} while (tmp);
+			parent->rb_left = child2 = successor->rb_right;
+			successor->rb_right = child;
+			rb_set_parent(child, successor);
+			augment->copy(node, successor);
+			augment->propagate(parent, successor);
+		}
+
+		successor->rb_left = tmp = node->rb_left;
+		rb_set_parent(tmp, successor);
+
+		pc = node->__rb_parent_color;
+		tmp = __rb_parent(pc);
+		__rb_change_child(node, successor, tmp, root);
+		if (child2) {
+			successor->__rb_parent_color = pc;
+			rb_set_parent_color(child2, parent, RB_BLACK);
+			rebalance = NULL;
+		} else {
+			unsigned long pc2 = successor->__rb_parent_color;
+			successor->__rb_parent_color = pc;
+			rebalance = __rb_is_black(pc2) ? parent : NULL;
+		}
+		tmp = successor;
+	}
+
+	augment->propagate(tmp, NULL);
+	return rebalance;
+}
+
+static __always_inline void
+rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+		   const struct rb_augment_callbacks *augment)
+{
+	struct rb_node *rebalance = __rb_erase_augmented(node, root, augment);
+	if (rebalance)
+		__rb_erase_color(rebalance, root, augment->rotate);
+}
+
+#endif	/* _LINUX_RBTREE_AUGMENTED_H */
-- 
1.8.3.1

