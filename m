From: jeffm@suse.com
Subject: [patch v3 02/23] btrfs: Catch locking failures in {set,clear}_extent_bit
Date: Thu, 08 Sep 2011 20:22:42 -0400
Message-ID: <20110909002730.027216967@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The *_state functions can only return 0 or -EEXIST. This patch addresses
 the cases where those functions return -EEXIST, representing a locking
 failure. It handles them by panicking with an appropriate error message.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

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
@@ -531,7 +537,10 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 		prealloc = NULL;
 		if (err)
 			goto out;
@@ -553,7 +562,10 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 		if (wake)
 			wake_up(&state->wq);
 
@@ -736,8 +748,11 @@ again:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
+		if (err)
+			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 		prealloc = NULL;
-		BUG_ON(err == -EEXIST);
 		goto out;
 	}
 	state = rb_entry(node, struct extent_state, rb_node);
@@ -803,7 +818,10 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 		prealloc = NULL;
 		if (err)
 			goto out;
@@ -840,12 +858,11 @@ hit_next:
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
+			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
+
 		cache_state(prealloc, cached_state);
 		prealloc = NULL;
 		start = this_end + 1;
@@ -867,7 +884,10 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 
 		set_state_bits(tree, prealloc, &bits);
 		cache_state(prealloc, cached_state);


