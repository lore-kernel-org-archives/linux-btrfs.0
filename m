From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: [PATCH] ctree code cleanups
Date: Thu, 27 Jan 2011 19:01:53 -0600
Message-ID: <AANLkTimAq9TstN3cqr43iG-tGD4kFtWJsAHOsvfrOjAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following has been done as a part of cleanup -

o Eliminated bin_search() by replacing with btrfs_bin_search()
o Eliminated unused return value in fixup_low_keys()
o Eliminated additional variable (sret) in setup_nodes_for_search()

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 ctree.c |   71 ++++++++++++++++++----------------------------------------------
 1 file changed, 20 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9ac1715..69f71e8 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -928,7 +928,7 @@ static noinline int generic_bin_search(struct
extent_buffer *eb,
  * simple bin_search frontend that does the right thing for
  * leaves vs nodes
  */
-static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		      int level, int *slot)
 {
 	if (level == 0) {
@@ -947,12 +947,6 @@ static int bin_search(struct extent_buffer *eb,
struct btrfs_key *key,
 	return -1;
 }

-int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
-		     int level, int *slot)
-{
-	return bin_search(eb, key, level, slot);
-}
-
 static void root_add_used(struct btrfs_root *root, u32 size)
 {
 	spin_lock(&root->accounting_lock);
@@ -1648,38 +1642,29 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 	int ret;
 	if ((p->search_for_split || ins_len > 0) && btrfs_header_nritems(b) >=
 	    BTRFS_NODEPTRS_PER_BLOCK(root) - 3) {
-		int sret;
-
-		sret = reada_for_balance(root, p, level);
-		if (sret)
+		ret = reada_for_balance(root, p, level);
+		if (ret)
 			goto again;

 		btrfs_set_path_blocking(p);
-		sret = split_node(trans, root, p, level);
+		ret = split_node(trans, root, p, level);
 		btrfs_clear_path_blocking(p, NULL);

-		BUG_ON(sret > 0);
-		if (sret) {
-			ret = sret;
+		BUG_ON(ret > 0);
+		if (ret)
 			goto done;
-		}
 		b = p->nodes[level];
 	} else if (ins_len < 0 && btrfs_header_nritems(b) <
 		   BTRFS_NODEPTRS_PER_BLOCK(root) / 2) {
-		int sret;
-
-		sret = reada_for_balance(root, p, level);
-		if (sret)
+		ret = reada_for_balance(root, p, level);
+		if (ret)
 			goto again;

 		btrfs_set_path_blocking(p);
-		sret = balance_level(trans, root, p, level);
+		ret = balance_level(trans, root, p, level);
 		btrfs_clear_path_blocking(p, NULL);
-
-		if (sret) {
-			ret = sret;
+		if (ret)
 			goto done;
-		}
 		b = p->nodes[level];
 		if (!b) {
 			btrfs_release_path(NULL, p);
@@ -1802,7 +1787,7 @@ cow_done:
 			goto done;
 		}

-		ret = bin_search(b, key, level, &slot);
+		ret = btrfs_bin_search(b, key, level, &slot);

 		if (level != 0) {
 			int dec = 0;
@@ -1888,16 +1873,12 @@ done:
  * This is used after shifting pointers to the left, so it stops
  * fixing up pointers when a given leaf/node is not in slot 0 of the
  * higher levels
- *
- * If this fails to write a tree block, it returns -1, but continues
- * fixing up the blocks in ram so the tree is consistent.
  */
-static int fixup_low_keys(struct btrfs_trans_handle *trans,
+static void fixup_low_keys(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct btrfs_path *path,
 			  struct btrfs_disk_key *key, int level)
 {
 	int i;
-	int ret = 0;
 	struct extent_buffer *t;

 	for (i = level; i < BTRFS_MAX_LEVEL; i++) {
@@ -1910,7 +1891,6 @@ static int fixup_low_keys(struct
btrfs_trans_handle *trans,
 		if (tslot != 0)
 			break;
 	}
-	return ret;
 }

 /*
@@ -2567,7 +2547,6 @@ static noinline int __push_leaf_left(struct
btrfs_trans_handle *trans,
 	u32 old_left_nritems;
 	u32 nr;
 	int ret = 0;
-	int wret;
 	u32 this_item_size;
 	u32 old_left_item_size;

@@ -2708,9 +2687,7 @@ static noinline int __push_leaf_left(struct
btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);

 	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
-	if (wret)
-		ret = wret;
+	fixup_low_keys(trans, root, path, &disk_key, 1);

 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -3091,12 +3068,9 @@ again:
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
 			path->slots[0] = 0;
-			if (path->slots[1] == 0) {
-				wret = fixup_low_keys(trans, root,
+			if (path->slots[1] == 0)
+				fixup_low_keys(trans, root,
 						path, &disk_key, 1);
-				if (wret)
-					ret = wret;
-			}
 		}
 		btrfs_mark_buffer_dirty(right);
 		return ret;
@@ -3662,7 +3636,7 @@ int btrfs_insert_some_items(struct
btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}

 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -3770,7 +3744,7 @@ setup_items_for_insert(struct btrfs_trans_handle *trans,
 	if (slot == 0) {
 		struct btrfs_disk_key disk_key;
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
@@ -3856,7 +3830,6 @@ static int del_ptr(struct btrfs_trans_handle
*trans, struct btrfs_root *root,
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
 	int ret = 0;
-	int wret;

 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
@@ -3876,9 +3849,7 @@ static int del_ptr(struct btrfs_trans_handle
*trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;

 		btrfs_node_key(parent, &disk_key, 0);
-		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
-		if (wret)
-			ret = wret;
+		fixup_low_keys(trans, root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
 	return ret;
@@ -3993,10 +3964,8 @@ int btrfs_del_items(struct btrfs_trans_handle
*trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;

 			btrfs_item_key(leaf, &disk_key, 0);
-			wret = fixup_low_keys(trans, root, path,
+			fixup_low_keys(trans, root, path,
 					      &disk_key, 1);
-			if (wret)
-				ret = wret;
 		}

 		/* delete the leaf if it is mostly empty */
@@ -4130,7 +4099,7 @@ again:
 	while (1) {
 		nritems = btrfs_header_nritems(cur);
 		level = btrfs_header_level(cur);
-		sret = bin_search(cur, min_key, level, &slot);
+		sret = btrfs_bin_search(cur, min_key, level, &slot);

 		/* at the lowest level, we're done, setup the path and exit */
 		if (level == path->lowest_level) {

-- 
Goldwyn
