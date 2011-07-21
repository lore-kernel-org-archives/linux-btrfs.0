From: Jeff Mahoney <jeffm@suse.de>
Subject: [PATCH] btrfs: Make extent-io callbacks that never fail return void
Date: Thu, 21 Jul 2011 12:56:09 -0400
Message-ID: <4E285A29.2000908@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The set/clear bit and the extent split/merge hooks only ever return 0.

 Changing them to return void simplifies the error handling cases later.

 This patch changes the hook prototypes, the single implementation of each,
 and the functions that call them to return void instead.

 Since all four of these hooks execute under a spinlock, they're necessarily
 simple.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   52 +++++++++++++--------------------------------------
 fs/btrfs/extent_io.h |   18 ++++++++---------
 fs/btrfs/inode.c     |   26 ++++++++++---------------
 3 files changed, 34 insertions(+), 62 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -254,14 +254,14 @@ static void merge_cb(struct extent_io_tr
  *
  * This should be called with the tree lock held.
  */
-static int merge_state(struct extent_io_tree *tree,
-		       struct extent_state *state)
+static void merge_state(struct extent_io_tree *tree,
+		        struct extent_state *state)
 {
 	struct extent_state *other;
 	struct rb_node *other_node;
 
 	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
-		return 0;
+		return;
 
 	other_node = rb_prev(&state->rb_node);
 	if (other_node) {
@@ -288,19 +288,13 @@ static int merge_state(struct extent_io_
 			state = NULL;
 		}
 	}
-
-	return 0;
 }
 
-static int set_state_cb(struct extent_io_tree *tree,
+static void set_state_cb(struct extent_io_tree *tree,
 			 struct extent_state *state, int *bits)
 {
-	if (tree->ops && tree->ops->set_bit_hook) {
-		return tree->ops->set_bit_hook(tree->mapping->host,
-					       state, bits);
-	}
-
-	return 0;
+	if (tree->ops && tree->ops->set_bit_hook)
+		tree->ops->set_bit_hook(tree->mapping->host, state, bits);
 }
 
 static void clear_state_cb(struct extent_io_tree *tree,
@@ -326,7 +320,6 @@ static int insert_state(struct extent_io
 {
 	struct rb_node *node;
 	int bits_to_set = *bits & ~EXTENT_CTLBITS;
-	int ret;
 
 	if (end < start) {
 		printk(KERN_ERR "btrfs end < start %llu %llu\n",
@@ -336,9 +329,7 @@ static int insert_state(struct extent_io
 	}
 	state->start = start;
 	state->end = end;
-	ret = set_state_cb(tree, state, bits);
-	if (ret)
-		return ret;
+	set_state_cb(tree, state, bits);
 
 	if (bits_to_set & EXTENT_DIRTY)
 		tree->dirty_bytes += end - start + 1;
@@ -359,13 +350,11 @@ static int insert_state(struct extent_io
 	return 0;
 }
 
-static int split_cb(struct extent_io_tree *tree, struct extent_state *orig,
+static void split_cb(struct extent_io_tree *tree, struct extent_state *orig,
 		     u64 split)
 {
 	if (tree->ops && tree->ops->split_extent_hook)
-		return tree->ops->split_extent_hook(tree->mapping->host,
-						    orig, split);
-	return 0;
+		tree->ops->split_extent_hook(tree->mapping->host, orig, split);
 }
 
 /*
@@ -671,23 +660,18 @@ out:
 	return 0;
 }
 
-static int set_state_bits(struct extent_io_tree *tree,
+static void set_state_bits(struct extent_io_tree *tree,
 			   struct extent_state *state,
 			   int *bits)
 {
-	int ret;
 	int bits_to_set = *bits & ~EXTENT_CTLBITS;
 
-	ret = set_state_cb(tree, state, bits);
-	if (ret)
-		return ret;
+	set_state_cb(tree, state, bits);
 	if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
 		tree->dirty_bytes += range;
 	}
 	state->state |= bits_to_set;
-
-	return 0;
 }
 
 static void cache_state(struct extent_state *state,
@@ -779,9 +763,7 @@ hit_next:
 			goto out;
 		}
 
-		err = set_state_bits(tree, state, &bits);
-		if (err)
-			goto out;
+		set_state_bits(tree, state, &bits);
 
 		next_node = rb_next(node);
 		cache_state(state, cached_state);
@@ -830,9 +812,7 @@ hit_next:
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			err = set_state_bits(tree, state, &bits);
-			if (err)
-				goto out;
+			set_state_bits(tree, state, &bits);
 			cache_state(state, cached_state);
 			merge_state(tree, state);
 			if (last_end == (u64)-1)
@@ -895,11 +875,7 @@ hit_next:
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
 
-		err = set_state_bits(tree, prealloc, &bits);
-		if (err) {
-			prealloc = NULL;
-			goto out;
-		}
+		set_state_bits(tree, prealloc, &bits);
 		cache_state(prealloc, cached_state);
 		merge_state(tree, prealloc);
 		prealloc = NULL;
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -76,15 +76,15 @@ struct extent_io_ops {
 				    struct extent_state *state);
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
-	int (*set_bit_hook)(struct inode *inode, struct extent_state *state,
-			    int *bits);
-	int (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
-			      int *bits);
-	int (*merge_extent_hook)(struct inode *inode,
-				 struct extent_state *new,
-				 struct extent_state *other);
-	int (*split_extent_hook)(struct inode *inode,
-				 struct extent_state *orig, u64 split);
+	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
+			     int *bits);
+	void (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
+			       int *bits);
+	void (*merge_extent_hook)(struct inode *inode,
+				  struct extent_state *new,
+				  struct extent_state *other);
+	void (*split_extent_hook)(struct inode *inode,
+				  struct extent_state *orig, u64 split);
 	int (*write_cache_pages_lock_hook)(struct page *page);
 };
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1292,15 +1292,14 @@ static int run_delalloc_range(struct ino
 	return ret;
 }
 
-static int btrfs_split_extent_hook(struct inode *inode,
-				   struct extent_state *orig, u64 split)
+static void btrfs_split_extent_hook(struct inode *inode,
+				    struct extent_state *orig, u64 split)
 {
 	/* not delalloc, ignore it */
 	if (!(orig->state & EXTENT_DELALLOC))
-		return 0;
+		return;
 
 	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
-	return 0;
 }
 
 /*
@@ -1309,16 +1308,15 @@ static int btrfs_split_extent_hook(struc
  * extents, such as when we are doing sequential writes, so we can properly
  * account for the metadata space we'll need.
  */
-static int btrfs_merge_extent_hook(struct inode *inode,
-				   struct extent_state *new,
-				   struct extent_state *other)
+static void btrfs_merge_extent_hook(struct inode *inode,
+				    struct extent_state *new,
+				    struct extent_state *other)
 {
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
-		return 0;
+		return;
 
 	atomic_dec(&BTRFS_I(inode)->outstanding_extents);
-	return 0;
 }
 
 /*
@@ -1326,8 +1324,8 @@ static int btrfs_merge_extent_hook(struc
  * bytes in this file, and to maintain the list of inodes that
  * have pending delalloc work to be done.
  */
-static int btrfs_set_bit_hook(struct inode *inode,
-			      struct extent_state *state, int *bits)
+static void btrfs_set_bit_hook(struct inode *inode,
+			       struct extent_state *state, int *bits)
 {
 
 	/*
@@ -1354,14 +1352,13 @@ static int btrfs_set_bit_hook(struct ino
 		}
 		spin_unlock(&root->fs_info->delalloc_lock);
 	}
-	return 0;
 }
 
 /*
  * extent_io.c clear_bit_hook, see set_bit_hook for why
  */
-static int btrfs_clear_bit_hook(struct inode *inode,
-				struct extent_state *state, int *bits)
+static void btrfs_clear_bit_hook(struct inode *inode,
+				 struct extent_state *state, int *bits)
 {
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
@@ -1395,7 +1392,6 @@ static int btrfs_clear_bit_hook(struct i
 		}
 		spin_unlock(&root->fs_info->delalloc_lock);
 	}
-	return 0;
 }
 
 /*
-- 
Jeff Mahoney
SUSE Labs
