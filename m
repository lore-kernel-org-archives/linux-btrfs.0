From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 7/8] btrfs: make fixup_low_keys() void
Date: Thu, 18 Aug 2011 14:57:00 -0700
Message-ID: <1313704621-15219-8-git-send-email-mfasheh@suse.de>
References: <1313704621-15219-1-git-send-email-mfasheh@suse.de>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>,
	Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313704621-15219-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

This is trivial - fixup_low_keys always returns zero so we can make it void.
As a result, we can then make setup_items_for_insert() void too which lets
us cut out a couple of BUG_ON(ret) lines.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c         |   59 ++++++++++++++-------------------------------
 fs/btrfs/ctree.h         |    8 +++---
 fs/btrfs/delayed-inode.c |    6 +---
 3 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84e4053e..b42caec 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1874,16 +1874,12 @@ done:
  * This is used after shifting pointers to the left, so it stops
  * fixing up pointers when a given leaf/node is not in slot 0 of the
  * higher levels
- *
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
@@ -1896,7 +1892,6 @@ static int fixup_low_keys(struct btrfs_trans_handle *trans,
 		if (tslot != 0)
 			break;
 	}
-	return ret;
 }
 
 /*
@@ -2524,7 +2519,6 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	u32 old_left_nritems;
 	u32 nr;
 	int ret = 0;
-	int wret;
 	u32 this_item_size;
 	u32 old_left_item_size;
 
@@ -2630,9 +2624,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
-	if (wret)
-		ret = wret;
+	fixup_low_keys(trans, root, path, &disk_key, 1);
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -2988,12 +2980,8 @@ again:
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
+				fixup_low_keys(trans, root, path, &disk_key, 1);
 		}
 		btrfs_mark_buffer_dirty(right);
 		return ret;
@@ -3209,10 +3197,9 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 		return ret;
 
 	path->slots[0]++;
-	ret = setup_items_for_insert(trans, root, path, new_key, &item_size,
-				     item_size, item_size +
-				     sizeof(struct btrfs_item), 1);
-	BUG_ON(ret);
+	setup_items_for_insert(trans, root, path, new_key, &item_size,
+			       item_size, item_size +
+			       sizeof(struct btrfs_item), 1);
 
 	leaf = path->nodes[0];
 	memcpy_extent_buffer(leaf,
@@ -3515,7 +3502,7 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -3533,17 +3520,16 @@ out:
  * to save stack depth by doing the bulk of the work in a function
  * that doesn't call btrfs_search_slot
  */
-int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *cpu_key, u32 *data_size,
-			   u32 total_data, u32 total_size, int nr)
+void setup_items_for_insert(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    u32 total_data, u32 total_size, int nr)
 {
 	struct btrfs_item *item;
 	int i;
 	u32 nritems;
 	unsigned int data_end;
 	struct btrfs_disk_key disk_key;
-	int ret;
 	struct extent_buffer *leaf;
 	int slot;
 
@@ -3604,10 +3590,9 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 
 	btrfs_set_header_nritems(leaf, nritems + nr);
 
-	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
@@ -3616,7 +3601,6 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return ret;
 }
 
 /*
@@ -3648,7 +3632,8 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	slot = path->slots[0];
 	BUG_ON(slot < 0);
 
-	ret = setup_items_for_insert(trans, root, path, cpu_key, data_size,
+	ret = 0;
+	setup_items_for_insert(trans, root, path, cpu_key, data_size,
 			       total_data, total_size, nr);
 
 out:
@@ -3694,7 +3679,6 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
 	int ret = 0;
-	int wret;
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
@@ -3714,9 +3698,7 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
-		if (wret)
-			ret = wret;
+		fixup_low_keys(trans, root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
 	return ret;
@@ -3819,10 +3801,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			wret = fixup_low_keys(trans, root, path,
-					      &disk_key, 1);
-			if (wret)
-				ret = wret;
+			fixup_low_keys(trans, root, path, &disk_key, 1);
 		}
 
 		/* delete the leaf if it is mostly empty */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0469263..d0b7b58 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2344,10 +2344,10 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 	return btrfs_del_items(trans, root, path, path->slots[0], 1);
 }
 
-int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *cpu_key, u32 *data_size,
-			   u32 total_data, u32 total_size, int nr);
+void setup_items_for_insert(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    u32 total_data, u32 total_size, int nr);
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b52c672..6211997 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -738,10 +738,8 @@ static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
 	btrfs_clear_path_blocking(path, NULL, 0);
 
 	/* insert the keys of the items */
-	ret = setup_items_for_insert(trans, root, path, keys, data_size,
-				     total_data_size, total_size, nitems);
-	if (ret)
-		goto error;
+	setup_items_for_insert(trans, root, path, keys, data_size,
+			       total_data_size, total_size, nitems);
 
 	/* insert the dir index items */
 	slot = path->slots[0];
-- 
1.7.6

