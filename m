Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430AbcATVtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 16:49:35 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/3] btrfs-progs: Import interval tree implemenation from Linux v4.0-rc7.
Date: Wed, 20 Jan 2016 13:49:25 -0800
Message-Id: <1453326567-20454-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
References: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While I had the chance, I compared the rbtre code in btrfs-progs to that of
the latest kernel.  No new bug fixes need importing, however rbtree.h and
rbtree_augmented.h get documentation updates

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 interval_tree_generic.h | 193 ++++++++++++++++++++++++++++++++++++++++++++++++
 rbtree.h                |   2 +-
 rbtree_augmented.h      |  10 +++
 3 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 interval_tree_generic.h

diff --git a/interval_tree_generic.h b/interval_tree_generic.h
new file mode 100644
index 0000000..e26c732
--- /dev/null
+++ b/interval_tree_generic.h
@@ -0,0 +1,193 @@
+/*
+  Interval Trees
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
+  include/linux/interval_tree_generic.h
+*/
+
+#include <stdbool.h>
+
+#include "rbtree_augmented.h"
+
+/*
+ * Template for implementing interval trees
+ *
+ * ITSTRUCT:   struct type of the interval tree nodes
+ * ITRB:       name of struct rb_node field within ITSTRUCT
+ * ITTYPE:     type of the interval endpoints
+ * ITSUBTREE:  name of ITTYPE field within ITSTRUCT holding last-in-subtree
+ * ITSTART(n): start endpoint of ITSTRUCT node n
+ * ITLAST(n):  last endpoint of ITSTRUCT node n
+ * ITSTATIC:   'static' or empty
+ * ITPREFIX:   prefix to use for the inline tree definitions
+ *
+ * Note - before using this, please consider if non-generic version
+ * (interval_tree.h) would work for you...
+ */
+
+#define INTERVAL_TREE_DEFINE(ITSTRUCT, ITRB, ITTYPE, ITSUBTREE,		      \
+			     ITSTART, ITLAST, ITSTATIC, ITPREFIX)	      \
+									      \
+/* Callbacks for augmented rbtree insert and remove */			      \
+									      \
+static inline ITTYPE ITPREFIX ## _compute_subtree_last(ITSTRUCT *node)	      \
+{									      \
+	ITTYPE max = ITLAST(node), subtree_last;			      \
+	if (node->ITRB.rb_left) {					      \
+		subtree_last = rb_entry(node->ITRB.rb_left,		      \
+					ITSTRUCT, ITRB)->ITSUBTREE;	      \
+		if (max < subtree_last)					      \
+			max = subtree_last;				      \
+	}								      \
+	if (node->ITRB.rb_right) {					      \
+		subtree_last = rb_entry(node->ITRB.rb_right,		      \
+					ITSTRUCT, ITRB)->ITSUBTREE;	      \
+		if (max < subtree_last)					      \
+			max = subtree_last;				      \
+	}								      \
+	return max;							      \
+}									      \
+									      \
+RB_DECLARE_CALLBACKS(static, ITPREFIX ## _augment, ITSTRUCT, ITRB,	      \
+		     ITTYPE, ITSUBTREE, ITPREFIX ## _compute_subtree_last)    \
+									      \
+/* Insert / remove interval nodes from the tree */			      \
+									      \
+ITSTATIC void ITPREFIX ## _insert(ITSTRUCT *node, struct rb_root *root)	      \
+{									      \
+	struct rb_node **link = &root->rb_node, *rb_parent = NULL;	      \
+	ITTYPE start = ITSTART(node), last = ITLAST(node);		      \
+	ITSTRUCT *parent;						      \
+									      \
+	while (*link) {							      \
+		rb_parent = *link;					      \
+		parent = rb_entry(rb_parent, ITSTRUCT, ITRB);		      \
+		if (parent->ITSUBTREE < last)				      \
+			parent->ITSUBTREE = last;			      \
+		if (start < ITSTART(parent))				      \
+			link = &parent->ITRB.rb_left;			      \
+		else							      \
+			link = &parent->ITRB.rb_right;			      \
+	}								      \
+									      \
+	node->ITSUBTREE = last;						      \
+	rb_link_node(&node->ITRB, rb_parent, link);			      \
+	rb_insert_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+}									      \
+									      \
+ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node, struct rb_root *root)	      \
+{									      \
+	rb_erase_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+}									      \
+									      \
+/*									      \
+ * Iterate over intervals intersecting [start;last]			      \
+ *									      \
+ * Note that a node's interval intersects [start;last] iff:		      \
+ *   Cond1: ITSTART(node) <= last					      \
+ * and									      \
+ *   Cond2: start <= ITLAST(node)					      \
+ */									      \
+									      \
+static ITSTRUCT *							      \
+ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
+{									      \
+	while (true) {							      \
+		/*							      \
+		 * Loop invariant: start <= node->ITSUBTREE		      \
+		 * (Cond2 is satisfied by one of the subtree nodes)	      \
+		 */							      \
+		if (node->ITRB.rb_left) {				      \
+			ITSTRUCT *left = rb_entry(node->ITRB.rb_left,	      \
+						  ITSTRUCT, ITRB);	      \
+			if (start <= left->ITSUBTREE) {			      \
+				/*					      \
+				 * Some nodes in left subtree satisfy Cond2.  \
+				 * Iterate to find the leftmost such node N.  \
+				 * If it also satisfies Cond1, that's the     \
+				 * match we are looking for. Otherwise, there \
+				 * is no matching interval as nodes to the    \
+				 * right of N can't satisfy Cond1 either.     \
+				 */					      \
+				node = left;				      \
+				continue;				      \
+			}						      \
+		}							      \
+		if (ITSTART(node) <= last) {		/* Cond1 */	      \
+			if (start <= ITLAST(node))	/* Cond2 */	      \
+				return node;	/* node is leftmost match */  \
+			if (node->ITRB.rb_right) {			      \
+				node = rb_entry(node->ITRB.rb_right,	      \
+						ITSTRUCT, ITRB);	      \
+				if (start <= node->ITSUBTREE)		      \
+					continue;			      \
+			}						      \
+		}							      \
+		return NULL;	/* No match */				      \
+	}								      \
+}									      \
+									      \
+ITSTATIC ITSTRUCT *							      \
+ITPREFIX ## _iter_first(struct rb_root *root, ITTYPE start, ITTYPE last)      \
+{									      \
+	ITSTRUCT *node;							      \
+									      \
+	if (!root->rb_node)						      \
+		return NULL;						      \
+	node = rb_entry(root->rb_node, ITSTRUCT, ITRB);			      \
+	if (node->ITSUBTREE < start)					      \
+		return NULL;						      \
+	return ITPREFIX ## _subtree_search(node, start, last);		      \
+}									      \
+									      \
+ITSTATIC ITSTRUCT *							      \
+ITPREFIX ## _iter_next(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
+{									      \
+	struct rb_node *rb = node->ITRB.rb_right, *prev;		      \
+									      \
+	while (true) {							      \
+		/*							      \
+		 * Loop invariants:					      \
+		 *   Cond1: ITSTART(node) <= last			      \
+		 *   rb == node->ITRB.rb_right				      \
+		 *							      \
+		 * First, search right subtree if suitable		      \
+		 */							      \
+		if (rb) {						      \
+			ITSTRUCT *right = rb_entry(rb, ITSTRUCT, ITRB);	      \
+			if (start <= right->ITSUBTREE)			      \
+				return ITPREFIX ## _subtree_search(right,     \
+								start, last); \
+		}							      \
+									      \
+		/* Move up the tree until we come from a node's left child */ \
+		do {							      \
+			rb = rb_parent(&node->ITRB);			      \
+			if (!rb)					      \
+				return NULL;				      \
+			prev = &node->ITRB;				      \
+			node = rb_entry(rb, ITSTRUCT, ITRB);		      \
+			rb = node->ITRB.rb_right;			      \
+		} while (prev == rb);					      \
+									      \
+		/* Check if the node intersects [start;last] */		      \
+		if (last < ITSTART(node))		/* !Cond1 */	      \
+			return NULL;					      \
+		else if (start <= ITLAST(node))		/* Cond2 */	      \
+			return node;					      \
+	}								      \
+}
diff --git a/rbtree.h b/rbtree.h
index 0d4f2bf..47b662a 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -57,7 +57,7 @@ struct rb_root {
 
 #define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
 
-/* 'empty' nodes are nodes that are known not to be inserted in an rbree */
+/* 'empty' nodes are nodes that are known not to be inserted in an rtbree */
 #define RB_EMPTY_NODE(node)  \
 	((node)->__rb_parent_color == (unsigned long)(node))
 #define RB_CLEAR_NODE(node)  \
diff --git a/rbtree_augmented.h b/rbtree_augmented.h
index cbc9639..5d26978 100644
--- a/rbtree_augmented.h
+++ b/rbtree_augmented.h
@@ -46,6 +46,16 @@ struct rb_augment_callbacks {
 
 extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
+/*
+ * Fixup the rbtree and update the augmented information when rebalancing.
+ *
+ * On insertion, the user must update the augmented information on the path
+ * leading to the inserted node, then call rb_link_node() as usual and
+ * rb_augment_inserted() instead of the usual rb_insert_color() call.
+ * If rb_augment_inserted() rebalances the rbtree, it will callback into
+ * a user provided function to update the augmented information on the
+ * affected subtrees.
+ */
 static inline void
 rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 		    const struct rb_augment_callbacks *augment)
-- 
2.1.4

