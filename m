From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 04/12] Btrfs: Fix disk_i_size update corner case
Date: Thu, 12 Nov 2009 17:34:21 +0800
Message-ID: <4AFBD69D.60206@oracle.com>
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
 fs/btrfs/btrfs_inode.h  |    5 +--
 fs/btrfs/inode.c        |   70 +++++++++++++++++++++++++++-------------------
 fs/btrfs/ordered-data.c |   71 +++++++++++++++++++++++++++++++++-------------
 fs/btrfs/ordered-data.h |    2 +-
 4 files changed, 94 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index f6783a4..3f1f50d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -44,9 +44,6 @@ struct btrfs_inode {
 	 */
 	struct extent_io_tree io_failure_tree;
 
-	/* held while inesrting or deleting extents from files */
-	struct mutex extent_mutex;
-
 	/* held while logging the inode in tree-log.c */
 	struct mutex log_mutex;
 
@@ -166,7 +163,7 @@ static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
 
 static inline void btrfs_i_size_write(struct inode *inode, u64 size)
 {
-	inode->i_size = size;
+	i_size_write(inode, size);
 	BTRFS_I(inode)->disk_i_size = size;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 670902f..a824372 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -187,9 +187,6 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	}
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
-
-	BTRFS_I(inode)->disk_i_size = inode->i_size;
-	btrfs_update_inode(trans, root, inode);
 	return 0;
 fail:
 	btrfs_free_path(path);
@@ -415,7 +412,6 @@ again:
 						    start, end,
 						    total_compressed, pages);
 		}
-		btrfs_end_transaction(trans, root);
 		if (ret == 0) {
 			/*
 			 * inline extent creation worked, we don't need
@@ -429,9 +425,15 @@ again:
 			     EXTENT_CLEAR_DELALLOC |
 			     EXTENT_CLEAR_ACCOUNTING |
 			     EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK);
-			ret = 0;
+
+			btrfs_ordered_update_i_size(inode, end + 1, NULL);
+			ret = btrfs_update_inode(trans, root, inode);
+			BUG_ON(ret);
+
+			btrfs_end_transaction(trans, root);
 			goto free_pages_out;
 		}
+		btrfs_end_transaction(trans, root);
 	}
 
 	if (will_compress) {
@@ -542,7 +544,6 @@ static noinline int submit_compressed_extents(struct inode *inode,
 	if (list_empty(&async_cow->extents))
 		return 0;
 
-	trans = btrfs_join_transaction(root, 1);
 
 	while (!list_empty(&async_cow->extents)) {
 		async_extent = list_entry(async_cow->extents.next,
@@ -589,19 +590,15 @@ retry:
 		lock_extent(io_tree, async_extent->start,
 			    async_extent->start + async_extent->ram_size - 1,
 			    GFP_NOFS);
-		/*
-		 * here we're doing allocation and writeback of the
-		 * compressed pages
-		 */
-		btrfs_drop_extent_cache(inode, async_extent->start,
-					async_extent->start +
-					async_extent->ram_size - 1, 0);
 
+		trans = btrfs_join_transaction(root, 1);
 		ret = btrfs_reserve_extent(trans, root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
 					   0, alloc_hint,
 					   (u64)-1, &ins, 1);
+		btrfs_end_transaction(trans, root);
+
 		if (ret) {
 			int i;
 			for (i = 0; i < async_extent->nr_pages; i++) {
@@ -617,6 +614,14 @@ retry:
 			goto retry;
 		}
 
+		/*
+		 * here we're doing allocation and writeback of the
+		 * compressed pages
+		 */
+		btrfs_drop_extent_cache(inode, async_extent->start,
+					async_extent->start +
+					async_extent->ram_size - 1, 0);
+
 		em = alloc_extent_map(GFP_NOFS);
 		em->start = async_extent->start;
 		em->len = async_extent->ram_size;
@@ -648,8 +653,6 @@ retry:
 					       BTRFS_ORDERED_COMPRESSED);
 		BUG_ON(ret);
 
-		btrfs_end_transaction(trans, root);
-
 		/*
 		 * clear dirty, set writeback and unlock the pages.
 		 */
@@ -671,13 +674,11 @@ retry:
 				    async_extent->nr_pages);
 
 		BUG_ON(ret);
-		trans = btrfs_join_transaction(root, 1);
 		alloc_hint = ins.objectid + ins.offset;
 		kfree(async_extent);
 		cond_resched();
 	}
 
-	btrfs_end_transaction(trans, root);
 	return 0;
 }
 
@@ -741,6 +742,11 @@ static noinline int cow_file_range(struct inode *inode,
 				     EXTENT_CLEAR_DIRTY |
 				     EXTENT_SET_WRITEBACK |
 				     EXTENT_END_WRITEBACK);
+
+			btrfs_ordered_update_i_size(inode, end + 1, NULL);
+			ret = btrfs_update_inode(trans, root, inode);
+			BUG_ON(ret);
+
 			*nr_written = *nr_written +
 			     (end - start + PAGE_CACHE_SIZE) / PAGE_CACHE_SIZE;
 			*page_started = 1;
@@ -1727,18 +1733,27 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
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
@@ -1765,22 +1780,20 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
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
 
@@ -3562,7 +3575,6 @@ static noinline void init_btrfs_i(struct inode *inode)
 	INIT_LIST_HEAD(&BTRFS_I(inode)->ordered_operations);
 	RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
 	btrfs_ordered_inode_tree_init(&BTRFS_I(inode)->ordered_tree);
-	mutex_init(&BTRFS_I(inode)->extent_mutex);
 	mutex_init(&BTRFS_I(inode)->log_mutex);
 }
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ab21c29..5645ebe 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -591,7 +591,7 @@ out:
  * After an extent is done, call this to conditionally update the on disk
  * i_size.  i_size is updated to cover any fully written part of the file.
  */
-int btrfs_ordered_update_i_size(struct inode *inode,
+int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered)
 {
 	struct btrfs_ordered_inode_tree *tree = &BTRFS_I(inode)->ordered_tree;
@@ -599,18 +599,30 @@ int btrfs_ordered_update_i_size(struct inode *inode,
 	u64 disk_i_size;
 	u64 new_i_size;
 	u64 i_size_test;
+	u64 i_size = i_size_read(inode);
 	struct rb_node *node;
+	struct rb_node *prev = NULL;
 	struct btrfs_ordered_extent *test;
+	int ret = 1;
+
+	if (ordered)
+		offset = entry_end(ordered);
 
 	mutex_lock(&tree->mutex);
 	disk_i_size = BTRFS_I(inode)->disk_i_size;
 
+	/* truncate file */
+	if (disk_i_size > i_size) {
+		BTRFS_I(inode)->disk_i_size = i_size;
+		ret = 0;
+		goto out;
+	}
+
 	/*
 	 * if the disk i_size is already at the inode->i_size, or
 	 * this ordered extent is inside the disk i_size, we're done
 	 */
-	if (disk_i_size >= inode->i_size ||
-	    ordered->file_offset + ordered->len <= disk_i_size) {
+	if (disk_i_size == i_size || offset <= disk_i_size) {
 		goto out;
 	}
 
@@ -618,8 +630,7 @@ int btrfs_ordered_update_i_size(struct inode *inode,
 	 * we can't update the disk_isize if there are delalloc bytes
 	 * between disk_i_size and  this ordered extent
 	 */
-	if (test_range_bit(io_tree, disk_i_size,
-			   ordered->file_offset + ordered->len - 1,
+	if (test_range_bit(io_tree, disk_i_size, offset - 1,
 			   EXTENT_DELALLOC, 0, NULL)) {
 		goto out;
 	}
@@ -628,20 +639,32 @@ int btrfs_ordered_update_i_size(struct inode *inode,
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
-		if (test->file_offset >= inode->i_size)
+		if (test->file_offset >= i_size)
 			break;
 		if (test->file_offset >= disk_i_size)
 			goto out;
+		node = rb_prev(node);
 	}
-	new_i_size = min_t(u64, entry_end(ordered), i_size_read(inode));
+	new_i_size = min_t(u64, offset, i_size);
 
 	/*
 	 * at this point, we know we can safely update i_size to at least
@@ -649,7 +672,14 @@ int btrfs_ordered_update_i_size(struct inode *inode,
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
@@ -657,10 +687,10 @@ int btrfs_ordered_update_i_size(struct inode *inode,
 		 * between our ordered extent and the next one.
 		 */
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-		if (test->file_offset > entry_end(ordered))
+		if (test->file_offset > offset)
 			i_size_test = test->file_offset;
 	} else {
-		i_size_test = i_size_read(inode);
+		i_size_test = i_size;
 	}
 
 	/*
@@ -669,15 +699,16 @@ int btrfs_ordered_update_i_size(struct inode *inode,
 	 * are no delalloc bytes in this area, it is safe to update
 	 * disk_i_size to the end of the region.
 	 */
-	if (i_size_test > entry_end(ordered) &&
-	    !test_range_bit(io_tree, entry_end(ordered), i_size_test - 1,
-			   EXTENT_DELALLOC, 0, NULL)) {
-		new_i_size = min_t(u64, i_size_test, i_size_read(inode));
+	if (i_size_test > offset &&
+	    !test_range_bit(io_tree, offset, i_size_test - 1,
+			    EXTENT_DELALLOC, 0, NULL)) {
+		new_i_size = min_t(u64, i_size_test, i_size);
 	}
 	BTRFS_I(inode)->disk_i_size = new_i_size;
+	ret = 0;
 out:
 	mutex_unlock(&tree->mutex);
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 993a7ea..a080180 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -150,7 +150,7 @@ void btrfs_start_ordered_extent(struct inode *inode,
 int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
 struct btrfs_ordered_extent *
 btrfs_lookup_first_ordered_extent(struct inode * inode, u64 file_offset);
-int btrfs_ordered_update_i_size(struct inode *inode,
+int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
 int btrfs_wait_on_page_writeback_range(struct address_space *mapping,
-- 
1.6.2.5

