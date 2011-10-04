From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 03/65] btrfs: Panic on bad rbtree operations
Date: Mon, 03 Oct 2011 23:22:33 -0400
Message-ID: <20111004032300.262968021@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The ordered data and relocation trees have BUG_ONs to protect against
 bad tree operations.

 This patch replaces them with a panic that will report the problem.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ordered-data.c |   12 ++++++++++--
 fs/btrfs/relocation.c   |   36 +++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 9 deletions(-)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -59,6 +59,14 @@ static struct rb_node *tree_insert(struc
 	return NULL;
 }
 
+NORET_TYPE static void ordered_data_tree_panic(struct inode *inode, int errno,
+					       u64 offset)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb)->fs_info;
+	btrfs_panic(fs_info, errno, "Inconsistency in ordered tree at offset "
+		    "%llu\n", offset);
+}
+
 /*
  * look for a given offset in the tree, and if it can't be found return the
  * first lesser offset
@@ -207,7 +215,8 @@ static int __btrfs_add_ordered_extent(st
 	spin_lock(&tree->lock);
 	node = tree_insert(&tree->tree, file_offset,
 			   &entry->rb_node);
-	BUG_ON(node);
+	if (node)
+		ordered_data_tree_panic(inode, -EEXIST, file_offset);
 	spin_unlock(&tree->lock);
 
 	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
@@ -215,7 +224,6 @@ static int __btrfs_add_ordered_extent(st
 		      &BTRFS_I(inode)->root->fs_info->ordered_extents);
 	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
 
-	BUG_ON(node);
 	return 0;
 }
 
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -326,6 +326,19 @@ static struct rb_node *tree_search(struc
 	return NULL;
 }
 
+NORET_TYPE static void backref_tree_panic(struct rb_node *rb_node, int errno,
+					  u64 bytenr)
+{
+
+	struct btrfs_fs_info *fs_info = NULL;
+	struct backref_node *bnode = rb_entry(rb_node, struct backref_node,
+					      rb_node);
+	if (bnode->root)
+		fs_info = bnode->root->fs_info;
+	btrfs_panic(fs_info, errno, "Inconsistency in backref cache "
+		    "found at offset %llu\n", bytenr);
+}
+
 /*
  * walk up backref nodes until reach node presents tree root
  */
@@ -452,7 +465,8 @@ static void update_backref_node(struct b
 	rb_erase(&node->rb_node, &cache->rb_root);
 	node->bytenr = bytenr;
 	rb_node = tree_insert(&cache->rb_root, node->bytenr, &node->rb_node);
-	BUG_ON(rb_node);
+	if (rb_node)
+		backref_tree_panic(rb_node, -EEXIST, bytenr);
 }
 
 /*
@@ -999,7 +1013,8 @@ next:
 	if (!cowonly) {
 		rb_node = tree_insert(&cache->rb_root, node->bytenr,
 				      &node->rb_node);
-		BUG_ON(rb_node);
+		if (rb_node)
+			backref_tree_panic(rb_node, -EEXIST, node->bytenr);
 		list_add_tail(&node->lower, &cache->leaves);
 	}
 
@@ -1034,7 +1049,9 @@ next:
 		if (!cowonly) {
 			rb_node = tree_insert(&cache->rb_root, upper->bytenr,
 					      &upper->rb_node);
-			BUG_ON(rb_node);
+			if (rb_node)
+				backref_tree_panic(rb_node, -EEXIST,
+						   upper->bytenr);
 		}
 
 		list_add_tail(&edge->list[UPPER], &upper->lower);
@@ -1178,7 +1195,8 @@ static int clone_backref_node(struct btr
 
 	rb_node = tree_insert(&cache->rb_root, new_node->bytenr,
 			      &new_node->rb_node);
-	BUG_ON(rb_node);
+	if (rb_node)
+		backref_tree_panic(rb_node, -EEXIST, new_node->bytenr);
 
 	if (!new_node->lowest) {
 		list_for_each_entry(new_edge, &new_node->lower, list[UPPER]) {
@@ -1254,7 +1272,8 @@ static int __update_reloc_root(struct bt
 		rb_node = tree_insert(&rc->reloc_root_tree.rb_root,
 				      node->bytenr, &node->rb_node);
 		spin_unlock(&rc->reloc_root_tree.lock);
-		BUG_ON(rb_node);
+		if (rb_node)
+			backref_tree_panic(rb_node, -EEXIST, node->bytenr);
 	} else {
 		list_del_init(&root->root_list);
 		kfree(node);
@@ -3168,7 +3187,8 @@ static int add_tree_block(struct reloc_c
 	block->key_ready = 0;
 
 	rb_node = tree_insert(blocks, block->bytenr, &block->rb_node);
-	BUG_ON(rb_node);
+	if (rb_node)
+		backref_tree_panic(rb_node, -EEXIST, block->bytenr);
 
 	return 0;
 }
@@ -3437,7 +3457,9 @@ static int find_data_references(struct r
 			block->key_ready = 1;
 			rb_node = tree_insert(blocks, block->bytenr,
 					      &block->rb_node);
-			BUG_ON(rb_node);
+			if (rb_node)
+				backref_tree_panic(rb_node, -EEXIST,
+						   block->bytenr);
 		}
 		if (counted)
 			added = 1;



