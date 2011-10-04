From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 02/65] btrfs: Catch locking failures in {set,clear}_extent_bit
Date: Mon, 03 Oct 2011 23:22:32 -0400
Message-ID: <20111004032300.147032341@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The *_state functions can only return 0 or -EEXIST. This patch addresses
 the cases where those functions return -EEXIST, representing a locking
 failure. It handles them by panicking with an appropriate error message.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -51,6 +51,12 @@ struct extent_page_data {
 	unsigned int sync_io:1;
 };
 
+static inline struct btrfs_fs_info *
+tree_fs_info(struct extent_io_tree *tree)
+{
+	return btrfs_sb(tree->mapping->host->i_sb)->fs_info;
+}
+
 int __init extent_io_init(void)
 {
 	extent_state_cache = kmem_cache_create("extent_state",
@@ -437,6 +443,13 @@ alloc_extent_state_atomic(struct extent_
 	return prealloc;
 }
 
+NORET_TYPE void extent_io_tree_panic(struct extent_io_tree *tree, int err)
+{
+	btrfs_panic(tree_fs_info(tree), err, "Locking error: "
+		    "Extent tree was modified by another "
+		    "thread while locked.");
+}
+
 /*
  * clear some bits on a range in the tree.  This may require splitting
  * or inserting elements in the tree, so the gfp mask is used to
@@ -531,7 +544,9 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			extent_io_tree_panic(tree, err);
+
 		prealloc = NULL;
 		if (err)
 			goto out;
@@ -553,7 +568,9 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			extent_io_tree_panic(tree, err);
+
 		if (wake)
 			wake_up(&state->wq);
 
@@ -736,8 +753,10 @@ again:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
+		if (err)
+			extent_io_tree_panic(tree, err);
+
 		prealloc = NULL;
-		BUG_ON(err == -EEXIST);
 		goto out;
 	}
 	state = rb_entry(node, struct extent_state, rb_node);
@@ -803,7 +822,9 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			extent_io_tree_panic(tree, err);
+
 		prealloc = NULL;
 		if (err)
 			goto out;
@@ -840,12 +861,9 @@ hit_next:
 		 */
 		err = insert_state(tree, prealloc, start, this_end,
 				   &bits);
-		BUG_ON(err == -EEXIST);
-		if (err) {
-			free_extent_state(prealloc);
-			prealloc = NULL;
-			goto out;
-		}
+		if (err)
+			extent_io_tree_panic(tree, err);
+
 		cache_state(prealloc, cached_state);
 		prealloc = NULL;
 		start = this_end + 1;
@@ -867,7 +885,8 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			extent_io_tree_panic(tree, err);
 
 		set_state_bits(tree, prealloc, &bits);
 		cache_state(prealloc, cached_state);



