From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 2/9] btrfs: Catch locking failures in {set,clear}_extent_bit
Date: Wed, 10 Aug 2011 19:20:29 -0400
Message-ID: <20110810232122.528777485@suse.com>
References: <20110810232027.129702612@suse.com>
To: linux-btrfs@vger.kernel.org
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
@@ -455,6 +455,7 @@ int clear_extent_bit(struct extent_io_tr
 		     struct extent_state **cached_state,
 		     gfp_t mask)
 {
+	struct btrfs_fs_info *fs_info;
 	struct extent_state *state;
 	struct extent_state *cached;
 	struct extent_state *prealloc = NULL;
@@ -465,6 +466,8 @@ int clear_extent_bit(struct extent_io_tr
 	int set = 0;
 	int clear = 0;
 
+	fs_info = btrfs_sb(tree->mapping->host->i_sb)->fs_info;
+
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
 	bits |= EXTENT_FIRST_DELALLOC;
@@ -531,7 +534,10 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			btrfs_panic(fs_info, err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 		prealloc = NULL;
 		if (err)
 			goto out;
@@ -553,7 +559,10 @@ hit_next:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
-		BUG_ON(err == -EEXIST);
+		if (err)
+			btrfs_panic(fs_info, err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 		if (wake)
 			wake_up(&state->wq);
 
@@ -704,6 +713,7 @@ int set_extent_bit(struct extent_io_tree
 		   int bits, int exclusive_bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask)
 {
+	struct btrfs_fs_info *fs_info;
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
@@ -711,6 +721,8 @@ int set_extent_bit(struct extent_io_tree
 	u64 last_start;
 	u64 last_end;
 
+	fs_info = btrfs_sb(tree->mapping->host->i_sb)->fs_info;
+
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
@@ -736,8 +748,11 @@ again:
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
+		if (err)
+			btrfs_panic(fs_info, err, "Locking error: "
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
+			btrfs_panic(fs_info, err, "Locking error: "
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
+			btrfs_panic(fs_info, err, "Locking error: "
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
+			btrfs_panic(fs_info, err, "Locking error: "
+				    "Extent tree was modified by another "
+				    "thread while locked.");
 
 		set_state_bits(tree, prealloc, &bits);
 		cache_state(prealloc, cached_state);


