From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH] btrfs: make insert_ptr() void
Date: Mon, 8 Aug 2011 16:06:24 -0700
Message-ID: <20110808230624.GE8482@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

insert_ptr() always returns zero, so all the exta error handling can go
away.  This makes it trivial to also make copy_for_split() a void function
as it's only return was from insert_ptr(). Finally, this all makes the
BUG_ON(ret) in split_leaf() meaningless so I removed that.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |   59 ++++++++++++++++-------------------------------------
 1 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..41605ac 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2123,12 +2123,10 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
  *
  * slot and level indicate where you want the key to go, and
  * blocknr is the block the key points to.
- *
- * returns zero on success and < 0 on any error
  */
-static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_path *path, struct btrfs_disk_key
-		      *key, u64 bytenr, int slot, int level)
+static void insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
+		       *root, struct btrfs_path *path, struct btrfs_disk_key
+		       *key, u64 bytenr, int slot, int level)
 {
 	struct extent_buffer *lower;
 	int nritems;
@@ -2152,7 +2150,6 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_node_ptr_generation(lower, slot, trans->transid);
 	btrfs_set_header_nritems(lower, nritems + 1);
 	btrfs_mark_buffer_dirty(lower);
-	return 0;
 }
 
 /*
@@ -2173,7 +2170,6 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	struct btrfs_disk_key disk_key;
 	int mid;
 	int ret;
-	int wret;
 	u32 c_nritems;
 
 	c = path->nodes[level];
@@ -2230,11 +2226,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(c);
 	btrfs_mark_buffer_dirty(split);
 
-	wret = insert_ptr(trans, root, path, &disk_key, split->start,
-			  path->slots[level + 1] + 1,
-			  level + 1);
-	if (wret)
-		ret = wret;
+	insert_ptr(trans, root, path, &disk_key, split->start,
+		   path->slots[level + 1] + 1, level + 1);
 
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
@@ -2724,18 +2717,16 @@ out:
  *
  * returns 0 if all went well and < 0 on failure.
  */
-static noinline int copy_for_split(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct btrfs_path *path,
-			       struct extent_buffer *l,
-			       struct extent_buffer *right,
-			       int slot, int mid, int nritems)
+static noinline void copy_for_split(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct extent_buffer *l,
+				    struct extent_buffer *right,
+				    int slot, int mid, int nritems)
 {
 	int data_copy_size;
 	int rt_data_off;
 	int i;
-	int ret = 0;
-	int wret;
 	struct btrfs_disk_key disk_key;
 
 	nritems = nritems - mid;
@@ -2763,12 +2754,9 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_set_header_nritems(l, mid);
-	ret = 0;
 	btrfs_item_key(right, &disk_key, 0);
-	wret = insert_ptr(trans, root, path, &disk_key, right->start,
-			  path->slots[1] + 1, 1);
-	if (wret)
-		ret = wret;
+	insert_ptr(trans, root, path, &disk_key, right->start,
+		   path->slots[1] + 1, 1);
 
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
@@ -2786,8 +2774,6 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 	}
 
 	BUG_ON(path->slots[0] < 0);
-
-	return ret;
 }
 
 /*
@@ -2976,12 +2962,8 @@ again:
 	if (split == 0) {
 		if (mid <= slot) {
 			btrfs_set_header_nritems(right, 0);
-			wret = insert_ptr(trans, root, path,
-					  &disk_key, right->start,
-					  path->slots[1] + 1, 1);
-			if (wret)
-				ret = wret;
-
+			insert_ptr(trans, root, path, &disk_key, right->start,
+				   path->slots[1] + 1, 1);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -2989,12 +2971,8 @@ again:
 			path->slots[1] += 1;
 		} else {
 			btrfs_set_header_nritems(right, 0);
-			wret = insert_ptr(trans, root, path,
-					  &disk_key,
-					  right->start,
-					  path->slots[1], 1);
-			if (wret)
-				ret = wret;
+			insert_ptr(trans, root, path, &disk_key, right->start,
+				   path->slots[1], 1);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -3010,8 +2988,7 @@ again:
 		return ret;
 	}
 
-	ret = copy_for_split(trans, root, path, l, right, slot, mid, nritems);
-	BUG_ON(ret);
+	copy_for_split(trans, root, path, l, right, slot, mid, nritems);
 
 	if (split == 2) {
 		BUG_ON(num_doubles != 0);
-- 
1.7.6

