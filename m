From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 70/99] btrfs: insert_ptr should return void
Date: Wed, 23 Nov 2011 19:36:43 -0500
Message-ID: <20111124004227.919649051@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 insert_ptr has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c |   46 +++++++++++++---------------------------------
 1 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c605fb3..2604ec4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2114,12 +2114,11 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
  *
  * slot and level indicate where you want the key to go, and
  * blocknr is the block the key points to.
- *
- * returns zero on success and < 0 on any error
  */
-static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_path *path, struct btrfs_disk_key
-		      *key, u64 bytenr, int slot, int level)
+static void insert_ptr(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct btrfs_path *path,
+		       struct btrfs_disk_key *key, u64 bytenr,
+		       int slot, int level)
 {
 	struct extent_buffer *lower;
 	int nritems;
@@ -2129,8 +2128,7 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 	lower = path->nodes[level];
 	nritems = btrfs_header_nritems(lower);
 	BUG_ON(slot > nritems);
-	if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
-		BUG();
+	BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(root));
 	if (slot != nritems) {
 		memmove_extent_buffer(lower,
 			      btrfs_node_key_ptr_offset(slot + 1),
@@ -2143,7 +2141,6 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_node_ptr_generation(lower, slot, trans->transid);
 	btrfs_set_header_nritems(lower, nritems + 1);
 	btrfs_mark_buffer_dirty(lower);
-	return 0;
 }
 
 /*
@@ -2164,7 +2161,6 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	struct btrfs_disk_key disk_key;
 	int mid;
 	int ret;
-	int wret;
 	u32 c_nritems;
 
 	c = path->nodes[level];
@@ -2221,11 +2217,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
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
@@ -2722,8 +2715,6 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 	int data_copy_size;
 	int rt_data_off;
 	int i;
-	int ret = 0;
-	int wret;
 	struct btrfs_disk_key disk_key;
 
 	nritems = nritems - mid;
@@ -2751,12 +2742,9 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
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
@@ -2775,7 +2763,7 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 
 	BUG_ON(path->slots[0] < 0);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2964,12 +2952,8 @@ again:
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
@@ -2977,12 +2961,8 @@ again:
 			path->slots[1] += 1;
 		} else {
 			btrfs_set_header_nritems(right, 0);
-			wret = insert_ptr(trans, root, path,
-					  &disk_key,
-					  right->start,
-					  path->slots[1], 1);
+			insert_ptr(trans, root, path, &disk_key, right->start,
+					  path->slots[1], 1);
-			if (wret)
-				ret = wret;
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;



