From: jim owens <owens6336@gmail.com>
Subject: [PATCH] Btrfs: change ordered data tree search to use start and length.
Date: Sun, 21 Mar 2010 19:38:06 -0400
Message-ID: <4BA6ADDE.2060006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Users of btrfs_lookup_first_ordered_extent() want to detect only a
real overlap, so searching for the range instead of just an address
prevents taking references on entries we don't want.  This also
simplifies the code.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/file.c         |   10 +-
 fs/btrfs/inode.c        |   32 ++---
 fs/btrfs/ioctl.c        |    2 +-
 fs/btrfs/ordered-data.c |  289 +++++++++++++++--------------------------------
 fs/btrfs/ordered-data.h |    7 +-
 5 files changed, 112 insertions(+), 228 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d146dde..66533c0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -786,11 +786,9 @@ again:
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
 				 start_pos, last_pos - 1, 0, &cached_state,
 				 GFP_NOFS);
-		ordered = btrfs_lookup_first_ordered_extent(inode,
-							    last_pos - 1);
-		if (ordered &&
-		    ordered->file_offset + ordered->len > start_pos &&
-		    ordered->file_offset < last_pos) {
+		ordered = btrfs_lookup_first_ordered_extent(inode, start_pos,
+						last_pos - start_pos);
+		if (ordered) {
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     start_pos, last_pos - 1,
@@ -803,8 +801,6 @@ again:
 						 last_pos - start_pos);
 			goto again;
 		}
-		if (ordered)
-			btrfs_put_ordered_extent(ordered);
 
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
 				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 49dfc1a..b704f49 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5331,7 +5331,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	spin_unlock(&root->list_lock);
 
 	while (1) {
-		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
+		ordered = btrfs_lookup_first_ordered_extent(inode, 0, (u64)-1);
 		if (!ordered)
 			break;
 		else {
@@ -5869,25 +5869,19 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 		lock_extent_bits(&BTRFS_I(inode)->io_tree, alloc_start,
 				 locked_end, 0, &cached_state, GFP_NOFS);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
-							    alloc_end - 1);
-		if (ordered &&
-		    ordered->file_offset + ordered->len > alloc_start &&
-		    ordered->file_offset < alloc_end) {
-			btrfs_put_ordered_extent(ordered);
-			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     alloc_start, locked_end,
-					     &cached_state, GFP_NOFS);
-			/*
-			 * we can't wait on the range with the transaction
-			 * running or with the extent lock held
-			 */
-			btrfs_wait_ordered_range(inode, alloc_start,
-						 alloc_end - alloc_start);
-		} else {
-			if (ordered)
-				btrfs_put_ordered_extent(ordered);
+					alloc_start, alloc_end - alloc_start);
+		if (!ordered)
 			break;
-		}
+
+		btrfs_put_ordered_extent(ordered);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start,
+					locked_end, &cached_state, GFP_NOFS);
+		/*
+		 * we can't wait on the range with the transaction
+		 * running or with the extent lock held
+		 */
+		btrfs_wait_ordered_range(inode, alloc_start,
+					 alloc_end - alloc_start);
 	}
 
 	cur_offset = alloc_start;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2845c6c..0c29175 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1532,7 +1532,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
 		lock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
-		ordered = btrfs_lookup_first_ordered_extent(inode, off+len);
+		ordered = btrfs_lookup_first_ordered_extent(inode, off, len);
 		if (BTRFS_I(src)->delalloc_bytes == 0 && !ordered)
 			break;
 		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a8ffecd..98e0837 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -60,95 +60,51 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 file_offset,
 	return NULL;
 }
 
-/*
- * look for a given offset in the tree, and if it can't be found return the
- * first lesser offset
- */
-static struct rb_node *__tree_search(struct rb_root *root, u64 file_offset,
-				     struct rb_node **prev_ret)
+/* find lowest offset ordered extent that overlaps this extent, null if none */
+static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
+					  u64 file_offset, u64 len)
 {
+	struct rb_root *root = &tree->tree;
 	struct rb_node *n = root->rb_node;
-	struct rb_node *prev = NULL;
-	struct rb_node *test;
+	struct rb_node *lowest = NULL;
 	struct btrfs_ordered_extent *entry;
-	struct btrfs_ordered_extent *prev_entry = NULL;
+	u64 file_end;
+
+	if (tree->last) {
+		entry = rb_entry(tree->last, struct btrfs_ordered_extent,
+				 rb_node);
+		if (file_offset >= entry->file_offset &&
+		    file_offset < entry_end(entry))
+			return tree->last;
+	}
+
+	/* make file_end same as entry_end() */
+	file_end = file_offset + len;
+	if (file_end < file_offset)
+		file_end = (u64)-1;
 
 	while (n) {
 		entry = rb_entry(n, struct btrfs_ordered_extent, rb_node);
-		prev = n;
-		prev_entry = entry;
 
-		if (file_offset < entry->file_offset)
+		if (file_end <= entry->file_offset) {
+			/* our end is before extent start go lower */
 			n = n->rb_left;
-		else if (file_offset >= entry_end(entry))
+		} else if (file_offset >= entry_end(entry)) {
+			/* our start is after extent end go higher */
 			n = n->rb_right;
-		else
-			return n;
+		} else {
+			/* current lowest identified partial overlap extent */
+			lowest = n;
+			if (file_offset >= entry->file_offset)
+				break; /* this is our lowest extent */
+			/* see if there is any lower extent that overlaps */
+			n = n->rb_left;
+		}
 	}
-	if (!prev_ret)
-		return NULL;
 
-	while (prev && file_offset >= entry_end(prev_entry)) {
-		test = rb_next(prev);
-		if (!test)
-			break;
-		prev_entry = rb_entry(test, struct btrfs_ordered_extent,
-				      rb_node);
-		if (file_offset < entry_end(prev_entry))
-			break;
-
-		prev = test;
-	}
-	if (prev)
-		prev_entry = rb_entry(prev, struct btrfs_ordered_extent,
-				      rb_node);
-	while (prev && file_offset < entry_end(prev_entry)) {
-		test = rb_prev(prev);
-		if (!test)
-			break;
-		prev_entry = rb_entry(test, struct btrfs_ordered_extent,
-				      rb_node);
-		prev = test;
-	}
-	*prev_ret = prev;
-	return NULL;
-}
-
-/*
- * helper to check if a given offset is inside a given entry
- */
-static int offset_in_entry(struct btrfs_ordered_extent *entry, u64 file_offset)
-{
-	if (file_offset < entry->file_offset ||
-	    entry->file_offset + entry->len <= file_offset)
-		return 0;
-	return 1;
-}
-
-/*
- * look find the first ordered struct that has this offset, otherwise
- * the first one less than this offset
- */
-static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
-					  u64 file_offset)
-{
-	struct rb_root *root = &tree->tree;
-	struct rb_node *prev;
-	struct rb_node *ret;
-	struct btrfs_ordered_extent *entry;
-
-	if (tree->last) {
-		entry = rb_entry(tree->last, struct btrfs_ordered_extent,
-				 rb_node);
-		if (offset_in_entry(entry, file_offset))
-			return tree->last;
-	}
-	ret = __tree_search(root, file_offset, &prev);
-	if (!ret)
-		ret = prev;
-	if (ret)
-		tree->last = ret;
-	return ret;
+	if (lowest)
+		tree->last = lowest;
+	return lowest;
 }
 
 /* allocate and add a new ordered_extent into the per-inode tree.
@@ -237,40 +193,34 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
-	struct btrfs_ordered_extent *entry = NULL;
-	int ret;
+	struct btrfs_ordered_extent *entry;
+	int ret = 0;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	spin_lock(&tree->lock);
-	node = tree_search(tree, file_offset);
-	if (!node) {
-		ret = 1;
+	node = tree_search(tree, file_offset, io_size);
+	if (!node)
 		goto out;
-	}
 
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-	if (!offset_in_entry(entry, file_offset)) {
-		ret = 1;
-		goto out;
-	}
-
 	if (io_size > entry->bytes_left) {
 		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
 		       (unsigned long long)entry->bytes_left,
 		       (unsigned long long)io_size);
+		io_size = entry->bytes_left;
 	}
+
 	entry->bytes_left -= io_size;
-	if (entry->bytes_left == 0)
-		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
-	else
-		ret = 1;
-out:
-	if (!ret && cached && entry) {
-		*cached = entry;
-		atomic_inc(&entry->refs);
+	if (entry->bytes_left == 0) {
+		ret = !test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
+		if (ret && cached) {
+			*cached = entry;
+			atomic_inc(&entry->refs);
+		}
 	}
+out:
 	spin_unlock(&tree->lock);
-	return ret == 0;
+	return ret;
 }
 
 /*
@@ -502,7 +452,7 @@ void btrfs_start_ordered_extent(struct inode *inode,
  */
 int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 {
-	u64 end;
+	u64 next;
 	u64 orig_end;
 	u64 wait_end;
 	struct btrfs_ordered_extent *ordered;
@@ -530,27 +480,20 @@ again:
 
 	filemap_fdatawait_range(inode->i_mapping, start, orig_end);
 
-	end = orig_end;
+	next = start;
 	found = 0;
+
 	while (1) {
-		ordered = btrfs_lookup_first_ordered_extent(inode, end);
+		ordered = btrfs_lookup_first_ordered_extent(inode,
+							next, orig_end - next);
 		if (!ordered)
 			break;
-		if (ordered->file_offset > orig_end) {
-			btrfs_put_ordered_extent(ordered);
-			break;
-		}
-		if (ordered->file_offset + ordered->len < start) {
-			btrfs_put_ordered_extent(ordered);
-			break;
-		}
 		found++;
 		btrfs_start_ordered_extent(inode, ordered, 1);
-		end = ordered->file_offset;
+		next = ordered->file_offset + ordered->len;
 		btrfs_put_ordered_extent(ordered);
-		if (end == 0 || end == start)
+		if (next < start || next > orig_end)
 			break;
-		end--;
 	}
 	if (found || test_range_bit(&BTRFS_I(inode)->io_tree, start, orig_end,
 			   EXTENT_DELALLOC, 0, NULL)) {
@@ -567,32 +510,15 @@ again:
 struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 							 u64 file_offset)
 {
-	struct btrfs_ordered_inode_tree *tree;
-	struct rb_node *node;
-	struct btrfs_ordered_extent *entry = NULL;
-
-	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
-	node = tree_search(tree, file_offset);
-	if (!node)
-		goto out;
-
-	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-	if (!offset_in_entry(entry, file_offset))
-		entry = NULL;
-	if (entry)
-		atomic_inc(&entry->refs);
-out:
-	spin_unlock(&tree->lock);
-	return entry;
+	return btrfs_lookup_first_ordered_extent(inode, file_offset, 1);
 }
 
 /*
- * lookup and return any extent before 'file_offset'.  NULL is returned
- * if none is found
+ * lookup and return lowest file_offset extent overlapping the start
+ * file_offset through the len. NULL is returned if no extent is found
  */
 struct btrfs_ordered_extent *
-btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
+btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset, u64 len)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
@@ -600,7 +526,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	spin_lock(&tree->lock);
-	node = tree_search(tree, file_offset);
+	node = tree_search(tree, file_offset, len);
 	if (!node)
 		goto out;
 
@@ -621,11 +547,8 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	struct btrfs_ordered_inode_tree *tree = &BTRFS_I(inode)->ordered_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	u64 disk_i_size;
-	u64 new_i_size;
-	u64 i_size_test;
 	u64 i_size = i_size_read(inode);
 	struct rb_node *node;
-	struct rb_node *prev = NULL;
 	struct btrfs_ordered_extent *test;
 	int ret = 1;
 
@@ -648,89 +571,59 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	 * if the disk i_size is already at the inode->i_size, or
 	 * this ordered extent is inside the disk i_size, we're done
 	 */
-	if (disk_i_size == i_size || offset <= disk_i_size) {
+	if (disk_i_size == i_size || offset <= disk_i_size)
 		goto out;
-	}
 
 	/*
-	 * we can't update the disk_isize if there are delalloc bytes
-	 * between disk_i_size and  this ordered extent
+	 * we can't update the disk_i_size if there are delalloc bytes
+	 * between disk_i_size and this ordered extent
 	 */
 	if (test_range_bit(io_tree, disk_i_size, offset - 1,
-			   EXTENT_DELALLOC, 0, NULL)) {
+			   EXTENT_DELALLOC, 0, NULL))
+		goto out;
+
+	/* find any ordered extent that overlaps our i_size increase */
+	node = tree_search(tree, disk_i_size,
+				(ordered ? ordered->file_offset : offset) -
+				disk_i_size);
+
+	if (node) /* overlap means we can't update */
+		goto out;
+
+	/* can update disk_i_size but it can only increase to inode->i_size */
+	if (i_size <= offset) {
+		BTRFS_I(inode)->disk_i_size = i_size;
+		ret = 0;
 		goto out;
 	}
-	/*
-	 * walk backward from this ordered extent to disk_i_size.
-	 * if we find an ordered extent then we can't update disk i_size
-	 * yet
-	 */
-	if (ordered) {
-		node = rb_prev(&ordered->rb_node);
-	} else {
-		prev = tree_search(tree, offset);
-		/*
-		 * we insert file extents without involving ordered struct,
-		 * so there should be no ordered struct cover this offset
-		 */
-		if (prev) {
-			test = rb_entry(prev, struct btrfs_ordered_extent,
-					rb_node);
-			BUG_ON(offset_in_entry(test, offset));
-		}
-		node = prev;
-	}
-	while (node) {
-		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-		if (test->file_offset + test->len <= disk_i_size)
-			break;
-		if (test->file_offset >= i_size)
-			break;
-		if (test->file_offset >= disk_i_size)
-			goto out;
-		node = rb_prev(node);
-	}
-	new_i_size = min_t(u64, offset, i_size);
 
 	/*
 	 * at this point, we know we can safely update i_size to at least
 	 * the offset from this ordered extent.  But, we need to
 	 * walk forward and see if ios from higher up in the file have
-	 * finished.
+	 * finished between there and inode->i_size.
 	 */
-	if (ordered) {
+	if (ordered)
 		node = rb_next(&ordered->rb_node);
-	} else {
-		if (prev)
-			node = rb_next(prev);
-		else
-			node = rb_first(&tree->tree);
-	}
-	i_size_test = 0;
+	else
+		node = tree_search(tree, offset, i_size - offset + 1);
+
 	if (node) {
 		/*
 		 * do we have an area where IO might have finished
 		 * between our ordered extent and the next one.
+		 * test->file_offset is the end of a region after this ordered
+		 * extent where there are no ordered extents.  As long as there
+		 * are no delalloc bytes in this area, it is safe to update
+		 * disk_i_size to the end of the region.
 		 */
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-		if (test->file_offset > offset)
-			i_size_test = test->file_offset;
-	} else {
-		i_size_test = i_size;
+		if (!test_range_bit(io_tree, offset, test->file_offset - 1,
+				    EXTENT_DELALLOC, 0, NULL))
+			i_size = min_t(u64, test->file_offset, i_size);
 	}
 
-	/*
-	 * i_size_test is the end of a region after this ordered
-	 * extent where there are no ordered extents.  As long as there
-	 * are no delalloc bytes in this area, it is safe to update
-	 * disk_i_size to the end of the region.
-	 */
-	if (i_size_test > offset &&
-	    !test_range_bit(io_tree, offset, i_size_test - 1,
-			    EXTENT_DELALLOC, 0, NULL)) {
-		new_i_size = min_t(u64, i_size_test, i_size);
-	}
-	BTRFS_I(inode)->disk_i_size = new_i_size;
+	BTRFS_I(inode)->disk_i_size = i_size;
 	ret = 0;
 out:
 	/*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index c82f76a..a2fa23e 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -149,11 +149,12 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 void btrfs_start_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry, int wait);
 int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
-struct btrfs_ordered_extent *
-btrfs_lookup_first_ordered_extent(struct inode * inode, u64 file_offset);
+struct btrfs_ordered_extent *btrfs_lookup_first_ordered_extent(
+				struct inode *inode, u64 file_offset, u64 len);
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
-int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
+int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
+				u32 *sum);
 int btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
 int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-- 
1.6.3.3
