From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 48/65] btrfs: del_ptr should return void
Date: Mon, 03 Oct 2011 23:23:18 -0400
Message-ID: <20111004032305.416414332@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 With fixup_low_keys now returning void, there are no error conditions
 for del_ptr to report so it should return void. We set ret = 0 explicitly
 in btrfs_del_items but I'm not convinced that the error handling code
 already there is correct.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c |   39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -36,7 +36,7 @@ static int balance_node_right(struct btr
 			      struct btrfs_root *root,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
-static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
 
 struct btrfs_path *btrfs_alloc_path(void)
@@ -994,10 +994,7 @@ static noinline int balance_level(struct
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			wret = del_ptr(trans, root, path, level + 1, pslot +
-				       1);
-			if (wret)
-				ret = wret;
+			del_ptr(trans, root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
 			btrfs_free_tree_block(trans, root, right, 0, 1);
 			free_extent_buffer(right);
@@ -1035,9 +1032,7 @@ static noinline int balance_level(struct
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		wret = del_ptr(trans, root, path, level + 1, pslot);
-		if (wret)
-			ret = wret;
+		del_ptr(trans, root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		free_extent_buffer(mid);
@@ -3684,12 +3679,11 @@ int btrfs_insert_item(struct btrfs_trans
  * the tree should have been previously balanced so the deletion does not
  * empty a node.
  */
-static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_path *path, int level, int slot)
+static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		    struct btrfs_path *path, int level, int slot)
 {
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
-	int ret = 0;
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
@@ -3712,7 +3706,6 @@ static int del_ptr(struct btrfs_trans_ha
 		fixup_low_keys(trans, root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
-	return ret;
 }
 
 /*
@@ -3725,17 +3718,13 @@ static int del_ptr(struct btrfs_trans_ha
  * The path must have already been setup for deleting the leaf, including
  * all the proper balancing.  path->nodes[1] must be locked.
  */
-static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root,
-				   struct btrfs_path *path,
-				   struct extent_buffer *leaf)
+static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct extent_buffer *leaf)
 {
-	int ret;
-
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
-	ret = del_ptr(trans, root, path, 1, path->slots[1]);
-	if (ret)
-		return ret;
+	del_ptr(trans, root, path, 1, path->slots[1]);
 
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
@@ -3746,7 +3735,6 @@ static noinline int btrfs_del_leaf(struc
 	root_sub_used(root, leaf->len);
 
 	btrfs_free_tree_block(trans, root, leaf, 0, 1);
-	return 0;
 }
 /*
  * delete the item at the leaf level in path.  If that empties
@@ -3803,8 +3791,7 @@ int btrfs_del_items(struct btrfs_trans_h
 		} else {
 			btrfs_set_path_blocking(path);
 			clean_tree_block(trans, root, leaf);
-			ret = btrfs_del_leaf(trans, root, path, leaf);
-			BUG_ON(ret);
+			btrfs_del_leaf(trans, root, path, leaf);
 		}
 	} else {
 		int used = leaf_space_used(leaf, 0, nritems);
@@ -3840,9 +3827,9 @@ int btrfs_del_items(struct btrfs_trans_h
 
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
-				ret = btrfs_del_leaf(trans, root, path, leaf);
-				BUG_ON(ret);
+				btrfs_del_leaf(trans, root, path, leaf);
 				free_extent_buffer(leaf);
+				ret = 0;
 			} else {
 				/* if we're still in the path, make sure
 				 * we're dirty.  Otherwise, one of the


