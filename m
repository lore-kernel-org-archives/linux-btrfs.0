From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 08/20] btrfs: make del_ptr() and btrfs_del_leaf() void
Date: Thu, 15 Sep 2011 10:34:47 -0700
Message-ID: <1316108099-5099-9-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

Since fixup_low_keys() has been made void, del_ptr() always returns zero. We
can then make it void as well. This allows us in turn to make
btrfs_del_leaf() void as the only return value it was previously catching
was from del_ptr(). This winds up removing a couple of un-needed BUG_ON(ret)
lines.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |   40 +++++++++++++---------------------------
 1 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b4a0801..2b2f8fd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -36,8 +36,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
-static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_path *path, int level, int slot);
+static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		    struct btrfs_path *path, int level, int slot);
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
@@ -994,10 +994,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
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
@@ -1035,9 +1032,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
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
@@ -3685,12 +3680,11 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
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
@@ -3713,7 +3707,6 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		fixup_low_keys(trans, root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
-	return ret;
 }
 
 /*
@@ -3726,17 +3719,13 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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
@@ -3747,7 +3736,6 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	root_sub_used(root, leaf->len);
 
 	btrfs_free_tree_block(trans, root, leaf, 0, 1);
-	return 0;
 }
 /*
  * delete the item at the leaf level in path.  If that empties
@@ -3804,8 +3792,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		} else {
 			btrfs_set_path_blocking(path);
 			clean_tree_block(trans, root, leaf);
-			ret = btrfs_del_leaf(trans, root, path, leaf);
-			BUG_ON(ret);
+			btrfs_del_leaf(trans, root, path, leaf);
 		}
 	} else {
 		int used = leaf_space_used(leaf, 0, nritems);
@@ -3841,8 +3828,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
-				ret = btrfs_del_leaf(trans, root, path, leaf);
-				BUG_ON(ret);
+				btrfs_del_leaf(trans, root, path, leaf);
 				free_extent_buffer(leaf);
 			} else {
 				/* if we're still in the path, make sure
-- 
1.7.6

