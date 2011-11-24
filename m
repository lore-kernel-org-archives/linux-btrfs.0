From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 67/99] btrfs: fixup_low_keys should return void
Date: Wed, 23 Nov 2011 19:36:40 -0500
Message-ID: <20111124004227.573691338@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 fixup_low_keys has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c |   39 +++++++++++----------------------------
 1 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..dedd3a1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1864,15 +1864,12 @@ done:
  * fixing up pointers when a given leaf/node is not in slot 0 of the
  * higher levels
  *
- * If this fails to write a tree block, it returns -1, but continues
- * fixing up the blocks in ram so the tree is consistent.
  */
-static int fixup_low_keys(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct btrfs_path *path,
-			  struct btrfs_disk_key *key, int level)
+static void fixup_low_keys(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, struct btrfs_path *path,
+			   struct btrfs_disk_key *key, int level)
 {
 	int i;
-	int ret = 0;
 	struct extent_buffer *t;
 
 	for (i = level; i < BTRFS_MAX_LEVEL; i++) {
@@ -1885,7 +1882,6 @@ static int fixup_low_keys(struct btrfs_trans_handle *trans,
 		if (tslot != 0)
 			break;
 	}
-	return ret;
 }
 
 /*
@@ -2626,9 +2622,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
-	if (wret)
-		ret = wret;
+	fixup_low_keys(trans, root, path, &disk_key, 1);
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -2999,12 +2993,9 @@ again:
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
 			path->slots[0] = 0;
-			if (path->slots[1] == 0) {
-				wret = fixup_low_keys(trans, root,
-						path, &disk_key, 1);
-				if (wret)
-					ret = wret;
-			}
+			if (path->slots[1] == 0)
+				fixup_low_keys(trans, root, path,
+					       &disk_key, 1);
 		}
 		btrfs_mark_buffer_dirty(right);
 		return ret;
@@ -3527,7 +3518,7 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -3555,7 +3546,6 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 	u32 nritems;
 	unsigned int data_end;
 	struct btrfs_disk_key disk_key;
-	int ret;
 	struct extent_buffer *leaf;
 	int slot;
 
@@ -3616,10 +3606,9 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 
 	btrfs_set_header_nritems(leaf, nritems + nr);
 
-	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
@@ -3706,7 +3695,6 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
 	int ret = 0;
-	int wret;
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
@@ -3726,9 +3714,7 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
-		if (wret)
-			ret = wret;
+		fixup_low_keys(trans, root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
 	return ret;
@@ -3831,10 +3817,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			wret = fixup_low_keys(trans, root, path,
-					      &disk_key, 1);
-			if (wret)
-				ret = wret;
+			fixup_low_keys(trans, root, path, &disk_key, 1);
 		}
 
 		/* delete the leaf if it is mostly empty */



