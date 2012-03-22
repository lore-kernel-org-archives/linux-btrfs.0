From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 03/35] btrfs: Panic on bad rbtree operations
Date: Wed, 21 Mar 2012 21:11:07 -0400
Message-ID: <20120322011133.410948776@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
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

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a1c9404..2857f28 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -59,6 +59,14 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 file_offset,
 	return NULL;
 }
 
+static void ordered_data_tree_panic(struct inode *inode, int errno,
+					       u64 offset)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	btrfs_panic(fs_info, errno, "Inconsistency in ordered tree at offset "
+		    "%llu\n", (unsigned long long)offset);
+}
+
 /*
  * look for a given offset in the tree, and if it can't be found return the
  * first lesser offset
@@ -207,7 +215,8 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	spin_lock(&tree->lock);
 	node = tree_insert(&tree->tree, file_offset,
 			   &entry->rb_node);
-	BUG_ON(node);
+	if (node)
+		ordered_data_tree_panic(inode, -EEXIST, file_offset);
 	spin_unlock(&tree->lock);
 
 	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
@@ -215,7 +224,6 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 		      &BTRFS_I(inode)->root->fs_info->ordered_extents);
 	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
 
-	BUG_ON(node);
 	return 0;
 }
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8c1aae2..e5996ff 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -326,6 +326,19 @@ static struct rb_node *tree_search(struct rb_root *root, u64 bytenr)
 	return NULL;
 }
 
+void backref_tree_panic(struct rb_node *rb_node, int errno,
+					  u64 bytenr)
+{
+
+	struct btrfs_fs_info *fs_info = NULL;
+	struct backref_node *bnode = rb_entry(rb_node, struct backref_node,
+					      rb_node);
+	if (bnode->root)
+		fs_info = bnode->root->fs_info;
+	btrfs_panic(fs_info, errno, "Inconsistency in backref cache "
+		    "found at offset %llu\n", (unsigned long long)bytenr);
+}
+
 /*
  * walk up backref nodes until reach node presents tree root
  */
@@ -452,7 +465,8 @@ static void update_backref_node(struct backref_cache *cache,
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
@@ -1180,7 +1197,8 @@ static int clone_backref_node(struct btrfs_trans_handle *trans,
 
 	rb_node = tree_insert(&cache->rb_root, new_node->bytenr,
 			      &new_node->rb_node);
-	BUG_ON(rb_node);
+	if (rb_node)
+		backref_tree_panic(rb_node, -EEXIST, new_node->bytenr);
 
 	if (!new_node->lowest) {
 		list_for_each_entry(new_edge, &new_node->lower, list[UPPER]) {
@@ -1252,7 +1270,8 @@ static int __update_reloc_root(struct btrfs_root *root, int del)
 		rb_node = tree_insert(&rc->reloc_root_tree.rb_root,
 				      node->bytenr, &node->rb_node);
 		spin_unlock(&rc->reloc_root_tree.lock);
-		BUG_ON(rb_node);
+		if (rb_node)
+			backref_tree_panic(rb_node, -EEXIST, node->bytenr);
 	} else {
 		list_del_init(&root->root_list);
 		kfree(node);
@@ -3154,7 +3173,8 @@ static int add_tree_block(struct reloc_control *rc,
 	block->key_ready = 0;
 
 	rb_node = tree_insert(blocks, block->bytenr, &block->rb_node);
-	BUG_ON(rb_node);
+	if (rb_node)
+		backref_tree_panic(rb_node, -EEXIST, block->bytenr);
 
 	return 0;
 }
@@ -3426,7 +3446,9 @@ static int find_data_references(struct reloc_control *rc,
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
-- 
1.7.9



