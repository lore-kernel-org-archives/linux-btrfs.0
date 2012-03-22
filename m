From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 14/35] btrfs: __add_reloc_root error push-up
Date: Wed, 21 Mar 2012 21:11:18 -0400
Message-ID: <20120322011134.934540271@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch pushes kmalloc errors up to the caller and BUGs in the caller.

The BUG_ON for duplicate reloc tree root insertion is replaced with a
panic explaining the issue.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/relocation.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index e5996ff..974b0df 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1221,14 +1221,15 @@ fail:
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
@@ -1237,7 +1238,12 @@ static int __add_reloc_root(struct btrfs_root *root)
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
@@ -1353,6 +1359,7 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	struct btrfs_root *reloc_root;
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
 	int clear_rsv = 0;
+	int ret;
 
 	if (root->reloc_root) {
 		reloc_root = root->reloc_root;
@@ -1372,7 +1379,8 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	if (clear_rsv)
 		trans->block_rsv = NULL;
 
-	__add_reloc_root(reloc_root);
+	ret = __add_reloc_root(reloc_root);
+	BUG_ON(ret < 0);
 	root->reloc_root = reloc_root;
 	return 0;
 }
@@ -4226,7 +4234,8 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 				       reloc_root->root_key.offset);
 		BUG_ON(IS_ERR(fs_root));
 
-		__add_reloc_root(reloc_root);
+		err = __add_reloc_root(reloc_root);
+		BUG_ON(err < 0);
 		fs_root->reloc_root = reloc_root;
 	}
 
@@ -4428,7 +4437,8 @@ void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 	reloc_root = create_reloc_root(trans, root->reloc_root,
 				       new_root->root_key.objectid);
 
-	__add_reloc_root(reloc_root);
+	ret = __add_reloc_root(reloc_root);
+	BUG_ON(ret < 0);
 	new_root->reloc_root = reloc_root;
 
 	if (rc->create_reloc_tree) {
-- 
1.7.9



