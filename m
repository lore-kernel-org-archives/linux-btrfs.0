From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: [RFC PATCH] Streamline split extent insertions
Date: Tue, 10 Jun 2008 14:15:36 -0400
Message-ID: <484EC4C8.3040402@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060203090503020209030505"
To: undisclosed-recipients:;
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060203090503020209030505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Since we know the spot in the RB tree where the split off extent is
going, streamline the insertion process for the new extent. Just compile
tested, it's really a question of how deep trees are expected to be
(quite deep, I'd suspect), and how often splits are done (have no clue).

Anyways, just checking to see if this is worth pursuing...

Alan

--------------060203090503020209030505
Content-Type: text/x-diff;
 name="split_left.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="split_left.patch"

diff -r 41243548e445 extent_io.c
--- a/extent_io.c	Tue Jun 10 10:40:46 2008 -0400
+++ b/extent_io.c	Tue Jun 10 14:09:20 2008 -0400
@@ -173,6 +173,38 @@ static struct rb_node *tree_insert(struc
 	rb_link_node(node, parent, p);
 	rb_insert_color(node, root);
 	return NULL;
+}
+
+/*
+ * tree_insert_left - insert split off node to a /known/ left node in a tree
+ * @root:	root of the whole tree
+ * @parent:	new node's parent
+ * @child:	new node
+ *
+ * Since we /know/ the position to insert into (the /left/ of the
+ * given parent), we can short-circuit the complete tree search.
+ *
+ * There are really two cases:
+ *	(1) The parent's left is NULL, this means that the new node is
+ *	    to be placed there.
+ *
+ *	(2) The parent's left is non-NULL, we then search for the
+ *	    right-most decendent of the parent's left-child. This is
+ *	    a simple decent down the right links.
+ *
+ * Note: We could (should?) complicate the code to add in checks for
+ *       already existing (or overlapping) entries...
+ */
+static void tree_insert_left(struct rb_root *root, struct rb_node *parent,
+			     struct rb_node *child)
+{
+	struct rb_node **link;
+
+	for (link = &parent->rb_left; *link; link = &parent->rb_right)
+		parent = *link;
+
+	rb_link_node(child, parent, link);
+	rb_insert_color(child, root);
 }
 
 static struct rb_node *__etree_search(struct extent_io_tree *tree, u64 offset,
@@ -369,20 +401,12 @@ static int split_state(struct extent_io_
 static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 		       struct extent_state *prealloc, u64 split)
 {
-	struct rb_node *node;
 	prealloc->start = orig->start;
 	prealloc->end = split - 1;
 	prealloc->state = orig->state;
 	orig->start = split;
 
-	node = tree_insert(&tree->state, prealloc->end, &prealloc->rb_node);
-	if (node) {
-		struct extent_state *found;
-		found = rb_entry(node, struct extent_state, rb_node);
-		printk("found node %Lu %Lu on insert of %Lu %Lu\n", found->start, found->end, prealloc->start, prealloc->end);
-		free_extent_state(prealloc);
-		return -EEXIST;
-	}
+	tree_insert_left(&tree->state, &orig->rb_node, &prealloc->rb_node);
 	prealloc->tree = tree;
 	return 0;
 }

--------------060203090503020209030505--
