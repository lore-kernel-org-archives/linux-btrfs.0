From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch v2 2/9] btrfs: Catch locking failures in {set,clear}_extent_bit
Date: Mon, 15 Aug 2011 15:50:44 -0400
Message-ID: <20110815195232.162552691@suse.com>
References: <20110815195042.559654068@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The *_state functions can only return 0 or -EEXIST. This patch addresses
 the cases where those functions return -EEXIST, representing a locking
 failure. It handles them by panicking with an appropriate error message.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   36 +++++++++++++++++++++++++-----------
 fs/btrfs/extent_io.h |    6 ++++++
 2 files changed, 31 insertions(+), 11 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -531,7 +531,10 @@ hit_next:
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
@@ -553,7 +556,10 @@ hit_next:
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
 
@@ -736,8 +742,11 @@ again:
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
@@ -803,7 +812,10 @@ hit_next:
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
@@ -840,12 +852,11 @@ hit_next:
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
@@ -867,7 +878,10 @@ hit_next:
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
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -159,6 +159,12 @@ static inline int extent_compress_type(u
 	return bio_flags >> EXTENT_BIO_FLAG_SHIFT;
 }
 
+static inline struct btrfs_fs_info *
+tree_fs_info(struct extent_io_tree *tree)
+{
+	return btrfs_sb(tree->mapping->host->i_sb)->fs_info;
+}
+
 struct extent_map_tree;
 
 typedef struct extent_map *(get_extent_t)(struct inode *inode,


