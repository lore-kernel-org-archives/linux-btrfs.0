From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 4/8] Fix disk_i_size update corner case.
Date: Mon, 02 Nov 2009 17:20:09 +0800
Message-ID: <4AEEA449.20404@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are some cases file extents are inserted without involving
ordered struct. In these cases, we update disk_i_size directly,
without checking pending ordered extent and DELALLOC bit. This
patch extends btrfs_ordered_update_i_size() to handle these cases.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/btrfs_inode.h 4/fs/btrfs/btrfs_inode.h
--- 3/fs/btrfs/btrfs_inode.h	2009-10-15 09:33:17.796992000 +0800
+++ 4/fs/btrfs/btrfs_inode.h	2009-10-30 17:05:01.017070618 +0800
@@ -44,9 +44,6 @@ struct btrfs_inode {
 	 */
 	struct extent_io_tree io_failure_tree;
 
-	/* held while inesrting or deleting extents from files */
-	struct mutex extent_mutex;
-
 	/* held while logging the inode in tree-log.c */
 	struct mutex log_mutex;
 
diff -urp 3/fs/btrfs/inode.c 4/fs/btrfs/inode.c
--- 3/fs/btrfs/inode.c	2009-10-30 16:53:52.811039000 +0800
+++ 4/fs/btrfs/inode.c	2009-10-30 17:06:04.403039070 +0800
@@ -188,8 +188,9 @@ static noinline int insert_inline_extent
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	BTRFS_I(inode)->disk_i_size = inode->i_size;
-	btrfs_update_inode(trans, root, inode);
+	btrfs_ordered_update_i_size(inode, start + size, NULL);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
 	return 0;
 fail:
 	btrfs_free_path(path);
@@ -1698,18 +1699,27 @@ static int btrfs_finish_ordered_io(struc
 		}
 	}
 
-	trans = btrfs_join_transaction(root, 1);
-
 	if (!ordered_extent)
 		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
 	BUG_ON(!ordered_extent);
-	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
-		goto nocow;
+	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
+		BUG_ON(!list_empty(&ordered_extent->list));
+		ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
+		if (!ret) {
+			trans = btrfs_join_transaction(root, 1);
+			ret = btrfs_update_inode(trans, root, inode);
+			BUG_ON(ret);
+			btrfs_end_transaction(trans, root);
+		}
+		goto out;
+	}
 
 	lock_extent(io_tree, ordered_extent->file_offset,
 		    ordered_extent->file_offset + ordered_extent->len - 1,
 		    GFP_NOFS);
 
+	trans = btrfs_join_transaction(root, 1);
+
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
 		compressed = 1;
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
@@ -1736,22 +1746,20 @@ static int btrfs_finish_ordered_io(struc
 	unlock_extent(io_tree, ordered_extent->file_offset,
 		    ordered_extent->file_offset + ordered_extent->len - 1,
 		    GFP_NOFS);
-nocow:
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
 
-	mutex_lock(&BTRFS_I(inode)->extent_mutex);
-	btrfs_ordered_update_i_size(inode, ordered_extent);
-	btrfs_update_inode(trans, root, inode);
+	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
+	btrfs_end_transaction(trans, root);
+out:
 	btrfs_remove_ordered_extent(inode, ordered_extent);
-	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
-
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
 	btrfs_put_ordered_extent(ordered_extent);
 
-	btrfs_end_transaction(trans, root);
 	return 0;
 }
 
@@ -3510,7 +3518,6 @@ static noinline void init_btrfs_i(struct
 	INIT_LIST_HEAD(&BTRFS_I(inode)->ordered_operations);
 	RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
 	btrfs_ordered_inode_tree_init(&BTRFS_I(inode)->ordered_tree);
-	mutex_init(&BTRFS_I(inode)->extent_mutex);
 	mutex_init(&BTRFS_I(inode)->log_mutex);
 }
 
diff -urp 3/fs/btrfs/ordered-data.c 4/fs/btrfs/ordered-data.c
--- 3/fs/btrfs/ordered-data.c	2009-10-10 09:08:32.682677000 +0800
+++ 4/fs/btrfs/ordered-data.c	2009-10-30 17:05:01.025790331 +0800
@@ -591,7 +591,7 @@ out:
  * After an extent is done, call this to conditionally update the on disk
  * i_size.  i_size is updated to cover any fully written part of the file.
  */
-int btrfs_ordered_update_i_size(struct inode *inode,
+int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered)
 {
 	struct btrfs_ordered_inode_tree *tree = &BTRFS_I(inode)->ordered_tree;
@@ -600,7 +600,12 @@ int btrfs_ordered_update_i_size(struct i
 	u64 new_i_size;
 	u64 i_size_test;
 	struct rb_node *node;
+	struct rb_node *prev = NULL;
 	struct btrfs_ordered_extent *test;
+	int ret = 1;
+
+	if (ordered)
+		offset = entry_end(ordered);
 
 	mutex_lock(&tree->mutex);
 	disk_i_size = BTRFS_I(inode)->disk_i_size;
@@ -609,8 +614,7 @@ int btrfs_ordered_update_i_size(struct i
 	 * if the disk i_size is already at the inode->i_size, or
 	 * this ordered extent is inside the disk i_size, we're done
 	 */
-	if (disk_i_size >= inode->i_size ||
-	    ordered->file_offset + ordered->len <= disk_i_size) {
+	if (disk_i_size >= inode->i_size || offset <= disk_i_size) {
 		goto out;
 	}
 
@@ -618,8 +622,7 @@ int btrfs_ordered_update_i_size(struct i
 	 * we can't update the disk_isize if there are delalloc bytes
 	 * between disk_i_size and  this ordered extent
 	 */
-	if (test_range_bit(io_tree, disk_i_size,
-			   ordered->file_offset + ordered->len - 1,
+	if (test_range_bit(io_tree, disk_i_size, offset - 1,
 			   EXTENT_DELALLOC, 0, NULL)) {
 		goto out;
 	}
@@ -628,11 +631,22 @@ int btrfs_ordered_update_i_size(struct i
 	 * if we find an ordered extent then we can't update disk i_size
 	 * yet
 	 */
-	node = &ordered->rb_node;
-	while (1) {
-		node = rb_prev(node);
-		if (!node)
-			break;
+	if (ordered) {
+		node = rb_prev(&ordered->rb_node);
+	} else {
+		prev = tree_search(tree, offset);
+		/*
+		 * we insert file extents without involving ordered struct,
+		 * so there should be no ordered struct cover this offset
+		 */
+		if (prev) {
+			test = rb_entry(prev, struct btrfs_ordered_extent,
+					rb_node);
+			BUG_ON(offset_in_entry(test, offset));
+		}
+		node = prev;
+	}
+	while (node) {
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
 		if (test->file_offset + test->len <= disk_i_size)
 			break;
@@ -640,8 +654,9 @@ int btrfs_ordered_update_i_size(struct i
 			break;
 		if (test->file_offset >= disk_i_size)
 			goto out;
+		node = rb_prev(node);
 	}
-	new_i_size = min_t(u64, entry_end(ordered), i_size_read(inode));
+	new_i_size = min_t(u64, offset, i_size_read(inode));
 
 	/*
 	 * at this point, we know we can safely update i_size to at least
@@ -649,7 +664,14 @@ int btrfs_ordered_update_i_size(struct i
 	 * walk forward and see if ios from higher up in the file have
 	 * finished.
 	 */
-	node = rb_next(&ordered->rb_node);
+	if (ordered) {
+		node = rb_next(&ordered->rb_node);
+	} else {
+		if (prev)
+			node = rb_next(prev);
+		else
+			node = rb_first(&tree->tree);
+	}
 	i_size_test = 0;
 	if (node) {
 		/*
@@ -657,7 +679,7 @@ int btrfs_ordered_update_i_size(struct i
 		 * between our ordered extent and the next one.
 		 */
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-		if (test->file_offset > entry_end(ordered))
+		if (test->file_offset > offset)
 			i_size_test = test->file_offset;
 	} else {
 		i_size_test = i_size_read(inode);
@@ -669,15 +691,16 @@ int btrfs_ordered_update_i_size(struct i
 	 * are no delalloc bytes in this area, it is safe to update
 	 * disk_i_size to the end of the region.
 	 */
-	if (i_size_test > entry_end(ordered) &&
-	    !test_range_bit(io_tree, entry_end(ordered), i_size_test - 1,
-			   EXTENT_DELALLOC, 0, NULL)) {
+	if (i_size_test > offset &&
+	    !test_range_bit(io_tree, offset, i_size_test - 1,
+			    EXTENT_DELALLOC, 0, NULL)) {
 		new_i_size = min_t(u64, i_size_test, i_size_read(inode));
 	}
 	BTRFS_I(inode)->disk_i_size = new_i_size;
+	ret = 0;
 out:
 	mutex_unlock(&tree->mutex);
-	return 0;
+	return ret;
 }
 
 /*
diff -urp 3/fs/btrfs/ordered-data.h 4/fs/btrfs/ordered-data.h
--- 3/fs/btrfs/ordered-data.h	2009-09-28 14:16:59.618812000 +0800
+++ 4/fs/btrfs/ordered-data.h	2009-10-30 17:05:01.026790120 +0800
@@ -150,7 +150,7 @@ void btrfs_start_ordered_extent(struct i
 int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
 struct btrfs_ordered_extent *
 btrfs_lookup_first_ordered_extent(struct inode * inode, u64 file_offset);
-int btrfs_ordered_update_i_size(struct inode *inode,
+int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
 int btrfs_wait_on_page_writeback_range(struct address_space *mapping,
