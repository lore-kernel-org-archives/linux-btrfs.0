From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: release delalloc reservations on extent item
	insertion
Date: Wed, 7 Oct 2009 14:22:49 -0400
Message-ID: <20091007182248.GA10911@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes an issue with the delalloc metadata space reservation
code.  The problem is we used to free the reservation as soon as we
allocated the delalloc region.  The problem with this is if we are not
inserting an inline extent, we don't actually insert the extent item until
after the ordered extent is written out.  This patch does 3 things,

1) It moves the reservation clearing stuff into the ordered code, so when
we remove the ordered extent we remove the reservation.
2) It adds a EXTENT_DO_ACCOUNTING flag that gets passed when we clear
delalloc bits in the cases where we want to clear the metadata reservation
when we clear the delalloc extent, in the case that we do an inline extent
or we invalidate the page.
3) It adds another waitqueue to the space info so that when we start a fs
wide delalloc flush, anybody else who also hits that area will simply wait
for the flush to finish and then try to make their allocation.

This has been tested thoroughly to make sure we did not regress on
performance.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/btrfs_inode.h  |   12 ++++++----
 fs/btrfs/ctree.h        |    3 ++
 fs/btrfs/extent-tree.c  |   54 ++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/extent_io.c    |   15 +++++++++---
 fs/btrfs/extent_io.h    |    2 +
 fs/btrfs/file.c         |    3 +-
 fs/btrfs/inode.c        |   56 ++++++++++++++++++++++++++++++----------------
 fs/btrfs/ordered-data.c |    7 ++++++
 8 files changed, 111 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 9874da8..164f231 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -128,12 +128,14 @@ struct btrfs_inode {
 	u64 last_unlink_trans;
 
 	/*
-	 * These two counters are for delalloc metadata reservations.  We keep
-	 * track of how many extents we've accounted for vs how many extents we
-	 * have.
+	 * Counters to keep track of the number of extent item's we may use due
+	 * to delalloc and such.  outstanding_extents is the number of extent
+	 * items we think we'll end up using, and reserved_extents is the number
+	 * of extent items we've reserved metadata for.
 	 */
-	int delalloc_reserved_extents;
-	int delalloc_extents;
+	spinlock_t accounting_lock;
+	int reserved_extents;
+	int outstanding_extents;
 
 	/*
 	 * ordered_data_close is set by truncate when a file that used
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c362308..61599dc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -695,6 +695,9 @@ struct btrfs_space_info {
 
 	int allocating_chunk;
 	wait_queue_head_t wait;
+
+	int flushing;
+	wait_queue_head_t flush_wait;
 };
 
 /*
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 923b0b5..22be623 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2823,14 +2823,17 @@ int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
 					   num_items);
 
 	spin_lock(&meta_sinfo->lock);
-	if (BTRFS_I(inode)->delalloc_reserved_extents <=
-	    BTRFS_I(inode)->delalloc_extents) {
+	spin_lock(&BTRFS_I(inode)->accounting_lock);
+	if (BTRFS_I(inode)->reserved_extents <=
+	    BTRFS_I(inode)->outstanding_extents) {
+		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		spin_unlock(&meta_sinfo->lock);
 		return 0;
 	}
+	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
-	BTRFS_I(inode)->delalloc_reserved_extents--;
-	BUG_ON(BTRFS_I(inode)->delalloc_reserved_extents < 0);
+	BTRFS_I(inode)->reserved_extents--;
+	BUG_ON(BTRFS_I(inode)->reserved_extents < 0);
 
 	if (meta_sinfo->bytes_delalloc < num_bytes) {
 		bug = true;
@@ -2863,6 +2866,37 @@ static void check_force_delalloc(struct btrfs_space_info *meta_sinfo)
 		meta_sinfo->force_delalloc = 0;
 }
 
+static void flush_delalloc(struct btrfs_root *root,
+				 struct btrfs_space_info *info)
+{
+	bool wait = false;
+
+	spin_lock(&info->lock);
+
+	if (!info->flushing) {
+		info->flushing = 1;
+		init_waitqueue_head(&info->flush_wait);
+	} else {
+		wait = true;
+	}
+
+	spin_unlock(&info->lock);
+
+	if (wait) {
+		wait_event(info->flush_wait,
+			   !info->flushing);
+		return;
+	}
+
+	btrfs_start_delalloc_inodes(root);
+	btrfs_wait_ordered_extents(root, 0);
+
+	spin_lock(&info->lock);
+	info->flushing = 0;
+	spin_unlock(&info->lock);
+	wake_up(&info->flush_wait);
+}
+
 static int maybe_allocate_chunk(struct btrfs_root *root,
 				 struct btrfs_space_info *info)
 {
@@ -2982,21 +3016,20 @@ again:
 			filemap_flush(inode->i_mapping);
 			goto again;
 		} else if (flushed == 3) {
-			btrfs_start_delalloc_inodes(root);
-			btrfs_wait_ordered_extents(root, 0);
+			flush_delalloc(root, meta_sinfo);
 			goto again;
 		}
 		spin_lock(&meta_sinfo->lock);
 		meta_sinfo->bytes_delalloc -= num_bytes;
 		spin_unlock(&meta_sinfo->lock);
 		printk(KERN_ERR "enospc, has %d, reserved %d\n",
-		       BTRFS_I(inode)->delalloc_extents,
-		       BTRFS_I(inode)->delalloc_reserved_extents);
+		       BTRFS_I(inode)->outstanding_extents,
+		       BTRFS_I(inode)->reserved_extents);
 		dump_space_info(meta_sinfo, 0, 0);
 		return -ENOSPC;
 	}
 
-	BTRFS_I(inode)->delalloc_reserved_extents++;
+	BTRFS_I(inode)->reserved_extents++;
 	check_force_delalloc(meta_sinfo);
 	spin_unlock(&meta_sinfo->lock);
 
@@ -3095,8 +3128,7 @@ again:
 		}
 
 		if (retries == 2) {
-			btrfs_start_delalloc_inodes(root);
-			btrfs_wait_ordered_extents(root, 0);
+			flush_delalloc(root, meta_sinfo);
 			goto again;
 		}
 		spin_lock(&meta_sinfo->lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9d3949d..ce7d142 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -460,7 +460,8 @@ static int clear_state_bit(struct extent_io_tree *tree,
 			    struct extent_state *state, int bits, int wake,
 			    int delete)
 {
-	int ret = state->state & bits;
+	int bits_to_clear = bits & ~EXTENT_DO_ACCOUNTING;
+	int ret = state->state & bits_to_clear;
 
 	if ((bits & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
@@ -468,7 +469,7 @@ static int clear_state_bit(struct extent_io_tree *tree,
 		tree->dirty_bytes -= range;
 	}
 	clear_state_cb(tree, state, bits);
-	state->state &= ~bits;
+	state->state &= ~bits_to_clear;
 	if (wake)
 		wake_up(&state->wq);
 	if (delete || state->state == 0) {
@@ -955,7 +956,8 @@ int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end,
-				EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0,
+				EXTENT_DIRTY | EXTENT_DELALLOC |
+				EXTENT_DO_ACCOUNTING, 0, 0,
 				NULL, mask);
 }
 
@@ -1403,6 +1405,7 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 				int unlock_pages,
 				int clear_unlock,
 				int clear_delalloc, int clear_dirty,
+				int clear_accounting,
 				int set_writeback,
 				int end_writeback,
 				int set_private2)
@@ -1423,6 +1426,9 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 	if (clear_delalloc)
 		clear_bits |= EXTENT_DELALLOC;
 
+	if (clear_accounting)
+		clear_bits |= EXTENT_DO_ACCOUNTING;
+
 	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
 	if (!(unlock_pages || clear_dirty || set_writeback || end_writeback ||
 	      set_private2))
@@ -2693,7 +2699,8 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 	lock_extent(tree, start, end, GFP_NOFS);
 	wait_on_page_writeback(page);
 	clear_extent_bit(tree, start, end,
-			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC,
+			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
+			 EXTENT_DO_ACCOUNTING,
 			 1, 1, NULL, GFP_NOFS);
 	return 0;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4794ec8..c2fb479 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -15,6 +15,7 @@
 #define EXTENT_BUFFER_FILLED (1 << 8)
 #define EXTENT_BOUNDARY (1 << 9)
 #define EXTENT_NODATASUM (1 << 10)
+#define EXTENT_DO_ACCOUNTING (1 << 11)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 
 /* flags for bio submission */
@@ -291,6 +292,7 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 				int unlock_page,
 				int clear_unlock,
 				int clear_delalloc, int clear_dirty,
+				int clear_accounting,
 				int set_writeback,
 				int end_writeback,
 				int set_private2);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1be96ba..82ddf44 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -878,7 +878,8 @@ again:
 			btrfs_put_ordered_extent(ordered);
 
 		clear_extent_bits(&BTRFS_I(inode)->io_tree, start_pos,
-				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC,
+				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
+				  EXTENT_DO_ACCOUNTING,
 				  GFP_NOFS);
 		unlock_extent(&BTRFS_I(inode)->io_tree,
 			      start_pos, last_pos - 1, GFP_NOFS);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1010979..e7f27f4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -426,7 +426,7 @@ again:
 			extent_clear_unlock_delalloc(inode,
 						     &BTRFS_I(inode)->io_tree,
 						     start, end, NULL, 1, 0,
-						     0, 1, 1, 1, 0);
+						     0, 1, 0, 1, 1, 0);
 			ret = 0;
 			goto free_pages_out;
 		}
@@ -641,7 +641,7 @@ static noinline int submit_compressed_extents(struct inode *inode,
 					     async_extent->start,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
-					     NULL, 1, 1, 0, 1, 1, 0, 0);
+					     NULL, 1, 1, 0, 1, 0, 1, 0, 0);
 
 		ret = btrfs_submit_compressed_write(inode,
 				    async_extent->start,
@@ -714,7 +714,7 @@ static noinline int cow_file_range(struct inode *inode,
 			extent_clear_unlock_delalloc(inode,
 						     &BTRFS_I(inode)->io_tree,
 						     start, end, NULL, 1, 1,
-						     1, 1, 1, 1, 0);
+						     1, 1, 1, 1, 1, 0);
 			*nr_written = *nr_written +
 			     (end - start + PAGE_CACHE_SIZE) / PAGE_CACHE_SIZE;
 			*page_started = 1;
@@ -784,7 +784,7 @@ static noinline int cow_file_range(struct inode *inode,
 		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
 					     start, start + ram_size - 1,
 					     locked_page, unlock, 1,
-					     1, 0, 0, 0, 1);
+					     1, 0, 0, 0, 0, 1);
 		disk_num_bytes -= cur_alloc_size;
 		num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
@@ -857,7 +857,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	int limit = 10 * 1024 * 1042;
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED |
-			 EXTENT_DELALLOC, 1, 0, NULL, GFP_NOFS);
+			 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING, 1, 0, NULL,
+			 GFP_NOFS);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		async_cow->inode = inode;
@@ -1105,7 +1106,7 @@ out_check:
 
 		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
 					cur_offset, cur_offset + num_bytes - 1,
-					locked_page, 1, 1, 1, 0, 0, 0, 1);
+					locked_page, 1, 1, 1, 0, 0, 0, 0, 1);
 		cur_offset = extent_end;
 		if (cur_offset > end)
 			break;
@@ -1170,15 +1171,17 @@ static int btrfs_split_extent_hook(struct inode *inode,
 					root->fs_info->max_extent);
 
 		/*
-		 * if we break a large extent up then leave delalloc_extents be,
-		 * since we've already accounted for the large extent.
+		 * if we break a large extent up then leave oustanding_extents
+		 * be, since we've already accounted for the large extent.
 		 */
 		if (div64_u64(new_size + root->fs_info->max_extent - 1,
 			      root->fs_info->max_extent) < num_extents)
 			return 0;
 	}
 
-	BTRFS_I(inode)->delalloc_extents++;
+	spin_lock(&BTRFS_I(inode)->accounting_lock);
+	BTRFS_I(inode)->outstanding_extents++;
+	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
 	return 0;
 }
@@ -1209,7 +1212,9 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 
 	/* we're not bigger than the max, unreserve the space and go */
 	if (new_size <= root->fs_info->max_extent) {
-		BTRFS_I(inode)->delalloc_extents--;
+		spin_lock(&BTRFS_I(inode)->accounting_lock);
+		BTRFS_I(inode)->outstanding_extents--;
+		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		return 0;
 	}
 
@@ -1223,7 +1228,9 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 		      root->fs_info->max_extent) > num_extents)
 		return 0;
 
-	BTRFS_I(inode)->delalloc_extents--;
+	spin_lock(&BTRFS_I(inode)->accounting_lock);
+	BTRFS_I(inode)->outstanding_extents--;
+	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
 	return 0;
 }
@@ -1245,7 +1252,9 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 	if (!(old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
-		BTRFS_I(inode)->delalloc_extents++;
+		spin_lock(&BTRFS_I(inode)->accounting_lock);
+		BTRFS_I(inode)->outstanding_extents++;
+		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		btrfs_delalloc_reserve_space(root, inode, end - start + 1);
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += end - start + 1;
@@ -1273,8 +1282,12 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 	if ((state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
-		BTRFS_I(inode)->delalloc_extents--;
-		btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+		if (bits & EXTENT_DO_ACCOUNTING) {
+			spin_lock(&BTRFS_I(inode)->accounting_lock);
+			BTRFS_I(inode)->outstanding_extents--;
+			spin_unlock(&BTRFS_I(inode)->accounting_lock);
+			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+		}
 
 		spin_lock(&root->fs_info->delalloc_lock);
 		if (state->end - state->start + 1 >
@@ -4565,7 +4578,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		 */
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_LOCKED, 1, 0, NULL, GFP_NOFS);
+				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
+				 NULL, GFP_NOFS);
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
@@ -4578,8 +4592,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		lock_extent(tree, page_start, page_end, GFP_NOFS);
 	}
 	clear_extent_bit(tree, page_start, page_end,
-		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC,
-		 1, 1, NULL, GFP_NOFS);
+		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
+		 EXTENT_DO_ACCOUNTING, 1, 1, NULL, GFP_NOFS);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
@@ -4674,7 +4688,8 @@ again:
 	 * prepare_pages in the normal write path.
 	 */
 	clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC, GFP_NOFS);
+			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end);
 	if (ret) {
@@ -4823,8 +4838,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 		return NULL;
 	ei->last_trans = 0;
 	ei->logged_trans = 0;
-	ei->delalloc_extents = 0;
-	ei->delalloc_reserved_extents = 0;
+	ei->outstanding_extents = 0;
+	ei->reserved_extents = 0;
+	spin_lock_init(&ei->accounting_lock);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->ordered_operations);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4a9c8c4..5dcd474 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -305,6 +305,13 @@ int btrfs_remove_ordered_extent(struct inode *inode,
 	rb_erase(node, &tree->tree);
 	tree->last = NULL;
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
+	if (!test_bit(BTRFS_ORDERED_COMPRESSED, &entry->flags)) {
+		spin_lock(&BTRFS_I(inode)->accounting_lock);
+		BTRFS_I(inode)->outstanding_extents--;
+		spin_unlock(&BTRFS_I(inode)->accounting_lock);
+		btrfs_unreserve_metadata_for_delalloc(BTRFS_I(inode)->root,
+						      inode, 1);
+	}
 
 	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
-- 
1.5.4.3

