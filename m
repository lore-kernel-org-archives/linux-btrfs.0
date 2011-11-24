From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 66/99] btrfs: __add_reloc_root error push-up
Date: Wed, 23 Nov 2011 19:36:39 -0500
Message-ID: <20111124004227.458024495@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch pushes kmalloc errors up to the caller and BUGs in the caller.

 The BUG_ON for duplicate reloc tree root insertion is replaced with a
 panic explaining the issue.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/relocation.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1219,14 +1219,15 @@ fail:
 /*
  * helper to add 'address of tree root -> reloc tree' mapping
  */
-static int __add_reloc_root(struct btrfs_root *root)
+static int __must_check __add_reloc_root(struct btrfs_root *root)
 {
 	struct rb_node *rb_node;
 	struct mapping_node *node;
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
 
 	node = kmalloc(sizeof(*node), GFP_NOFS);
-	BUG_ON(!node);
+	if (!node)
+		return -ENOMEM;
 
 	node->bytenr = root->node->start;
 	node->data = root;
@@ -1235,7 +1236,12 @@ static int __add_reloc_root(struct btrfs
 	rb_node = tree_insert(&rc->reloc_root_tree.rb_root,
 			      node->bytenr, &node->rb_node);
 	spin_unlock(&rc->reloc_root_tree.lock);
-	BUG_ON(rb_node);
+	if (rb_node) {
+		kfree(node);
+		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
+			    "for start=%llu while inserting into relocation "
+			    "tree\n");
+	}
 
 	list_add_tail(&root->root_list, &rc->reloc_roots);
 	return 0;
@@ -1351,6 +1357,7 @@ int btrfs_init_reloc_root(struct btrfs_t
 	struct btrfs_root *reloc_root;
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
 	int clear_rsv = 0;
+	int ret;
 
 	if (root->reloc_root) {
 		reloc_root = root->reloc_root;
@@ -1370,7 +1377,8 @@ int btrfs_init_reloc_root(struct btrfs_t
 	if (clear_rsv)
 		trans->block_rsv = NULL;
 
-	__add_reloc_root(reloc_root);
+	ret = __add_reloc_root(reloc_root);
+	BUG_ON(ret < 0);
 	root->reloc_root = reloc_root;
 	return 0;
 }
@@ -4248,7 +4256,8 @@ int btrfs_recover_relocation(struct btrf
 				       reloc_root->root_key.offset);
 		BUG_ON(IS_ERR(fs_root));
 
-		__add_reloc_root(reloc_root);
+		err = __add_reloc_root(reloc_root);
+		BUG_ON(err < 0);
 		fs_root->reloc_root = reloc_root;
 	}
 
@@ -4450,7 +4459,8 @@ void btrfs_reloc_post_snapshot(struct bt
 	reloc_root = create_reloc_root(trans, root->reloc_root,
 				       new_root->root_key.objectid);
 
-	__add_reloc_root(reloc_root);
+	ret = __add_reloc_root(reloc_root);
+	BUG_ON(ret < 0);
 	new_root->reloc_root = reloc_root;
 
 	if (rc->create_reloc_tree) {



