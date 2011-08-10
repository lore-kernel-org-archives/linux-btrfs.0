From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 5/9] btrfs: Push up clear_extent_bit errors to callers
Date: Wed, 10 Aug 2011 19:20:32 -0400
Message-ID: <20110810232122.995905950@suse.com>
References: <20110810232027.129702612@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 clear_extent_bit can fail with -ENOMEM for a specific case but will BUG
 on other memory allocation failures.

 This patch returns -ENOMEM for memory allocation failures and handles them
 with BUG_ON in callers which don't handle it already.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/btrfs/disk-io.c          |    7 ++-
 fs/btrfs/extent-tree.c      |   14 ++++--
 fs/btrfs/extent_io.c        |   56 ++++++++++++++++++--------
 fs/btrfs/file.c             |   10 ++--
 fs/btrfs/free-space-cache.c |   20 +++++----
 fs/btrfs/inode.c            |   92 +++++++++++++++++++++++++++-----------------
 fs/btrfs/ioctl.c            |    9 ++--
 fs/btrfs/relocation.c       |    5 +-
 fs/btrfs/transaction.c      |    4 +
 fs/btrfs/tree-log.c         |    5 +-
 10 files changed, 142 insertions(+), 80 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2981,7 +2981,9 @@ static int btrfs_destroy_marked_extents(
 		if (ret)
 			break;
 
-		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
+		ret = clear_extent_bits(dirty_pages, start, end, mark,
+					GFP_NOFS);
+		BUG_ON(ret < 0);
 		while (start <= end) {
 			index = start >> PAGE_CACHE_SHIFT;
 			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
@@ -3042,7 +3044,8 @@ static int btrfs_destroy_pinned_extent(s
 							 end + 1 - start,
 							 NULL);
 
-		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		ret = clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		BUG_ON(ret < 0);
 		btrfs_error_unpin_extent_range(root, start, end);
 		cond_resched();
 	}
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -207,14 +207,17 @@ static void free_excluded_extents(struct
 				  struct btrfs_block_group_cache *cache)
 {
 	u64 start, end;
+	int ret;
 
 	start = cache->key.objectid;
 	end = start + cache->key.offset - 1;
 
-	clear_extent_bits(&root->fs_info->freed_extents[0],
-			  start, end, EXTENT_UPTODATE, GFP_NOFS);
-	clear_extent_bits(&root->fs_info->freed_extents[1],
-			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+	ret = clear_extent_bits(&root->fs_info->freed_extents[0],
+				start, end, EXTENT_UPTODATE, GFP_NOFS);
+	BUG_ON(ret < 0);
+	ret = clear_extent_bits(&root->fs_info->freed_extents[1],
+				start, end, EXTENT_UPTODATE, GFP_NOFS);
+	BUG_ON(ret < 0);
 }
 
 static int exclude_super_stripes(struct btrfs_root *root,
@@ -4359,7 +4362,8 @@ int btrfs_finish_extent_commit(struct bt
 			ret = btrfs_discard_extent(root, start,
 						   end + 1 - start, NULL);
 
-		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		ret = clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		BUG_ON(ret < 0);
 		unpin_extent_range(root, start, end);
 		cond_resched();
 	}
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -532,7 +532,11 @@ hit_next:
 
 	if (state->start < start) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			btrfs_panic(fs_info, err, "Locking error: "
@@ -557,7 +561,11 @@ hit_next:
 	 */
 	if (state->start <= end && state->end > end) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			btrfs_panic(fs_info, err, "Locking error: "
@@ -1030,9 +1038,12 @@ int try_lock_extent(struct extent_io_tre
 	err = set_extent_bit(tree, start, end, EXTENT_LOCKED, EXTENT_LOCKED,
 			     &failed_start, NULL, mask);
 	if (err == -EEXIST) {
-		if (failed_start > start)
-			clear_extent_bit(tree, start, failed_start - 1,
-					 EXTENT_LOCKED, 1, 0, NULL, mask);
+		if (failed_start > start) {
+			err = clear_extent_bit(tree, start, failed_start - 1,
+					       EXTENT_LOCKED, 1, 0, NULL,
+					       mask);
+			BUG_ON(err < 0);
+		}
 		return 0;
 	} else if (err < 0)
 		return err;
@@ -1042,14 +1053,18 @@ int try_lock_extent(struct extent_io_tre
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
-				mask);
+	int ret = clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0,
+				   cached, mask);
+	BUG_ON(ret < 0);
+	return ret;
 }
 
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
-				mask);
+	int ret =  clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
+				    mask);
+	BUG_ON(ret < 0);
+	return ret;
 }
 
 /*
@@ -1389,7 +1404,9 @@ int extent_clear_unlock_delalloc(struct
 	if (op & EXTENT_CLEAR_DELALLOC)
 		clear_bits |= EXTENT_DELALLOC;
 
-	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
+	ret = clear_extent_bit(tree, start, end, clear_bits,
+			       1, 0, NULL, GFP_NOFS);
+	BUG_ON(ret < 0);
 	if (!(op & (EXTENT_CLEAR_UNLOCK_PAGE | EXTENT_CLEAR_DIRTY |
 		    EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK |
 		    EXTENT_SET_PRIVATE2)))
@@ -1694,7 +1711,9 @@ static void end_bio_extent_writepage(str
 		}
 
 		if (!uptodate) {
-			clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
+			ret = clear_extent_uptodate(tree, start, end,
+						    NULL, GFP_NOFS);
+			BUG_ON(ret < 0);
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
@@ -2673,10 +2692,11 @@ int extent_invalidatepage(struct extent_
 	ret = lock_extent_bits(tree, start, end, 0, &cached_state, GFP_NOFS);
 	BUG_ON(ret < 0);
 	wait_on_page_writeback(page);
-	clear_extent_bit(tree, start, end,
-			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-			 EXTENT_DO_ACCOUNTING,
-			 1, 1, &cached_state, GFP_NOFS);
+	ret = clear_extent_bit(tree, start, end,
+			       EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
+			       EXTENT_DO_ACCOUNTING,
+			       1, 1, &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 	return 0;
 }
 
@@ -3299,8 +3319,10 @@ int clear_extent_buffer_uptodate(struct
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 
 	if (eb_straddles_pages(eb)) {
-		clear_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
-				      cached_state, GFP_NOFS);
+		int ret = clear_extent_uptodate(tree, eb->start,
+						eb->start + eb->len - 1,
+						cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1128,10 +1128,12 @@ again:
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
-				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-				  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-				  GFP_NOFS);
+		err = clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
+				      last_pos - 1,
+				      EXTENT_DIRTY | EXTENT_DELALLOC |
+				      EXTENT_DO_ACCOUNTING, 0, 0,
+				      &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 				     start_pos, last_pos - 1, &cached_state,
 				     GFP_NOFS);
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -800,10 +800,12 @@ int __btrfs_write_out_cache(struct btrfs
 
 	ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
 	if (ret < 0) {
+		ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
+				       EXTENT_DIRTY | EXTENT_DELALLOC |
+				       EXTENT_DO_ACCOUNTING, 0, 0, NULL,
+				       GFP_NOFS);
+		BUG_ON(ret < 0);
 		ret = -1;
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
-				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
 		goto out;
 	}
 	leaf = path->nodes[0];
@@ -814,12 +816,14 @@ int __btrfs_write_out_cache(struct btrfs
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		if (found_key.objectid != BTRFS_FREE_SPACE_OBJECTID ||
 		    found_key.offset != offset) {
-			ret = -1;
-			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
-					 EXTENT_DIRTY | EXTENT_DELALLOC |
-					 EXTENT_DO_ACCOUNTING, 0, 0, NULL,
-					 GFP_NOFS);
+			ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, 0,
+					       bytes - 1,
+					       EXTENT_DIRTY | EXTENT_DELALLOC |
+					       EXTENT_DO_ACCOUNTING, 0, 0,
+					       NULL, GFP_NOFS);
+			BUG_ON(ret < 0);
 			btrfs_release_path(path);
+			ret = -1;
 			goto out;
 		}
 	}
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -960,9 +960,11 @@ static int cow_file_range_async(struct i
 	unsigned long nr_pages;
 	u64 cur_end;
 	int limit = 10 * 1024 * 1042;
+	int ret;
 
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
-			 1, 0, NULL, GFP_NOFS);
+	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end,
+			       EXTENT_LOCKED, 1, 0, NULL, GFP_NOFS);
+	BUG_ON(ret < 0);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		BUG_ON(!async_cow);
@@ -1917,9 +1919,11 @@ static int btrfs_io_failed_hook(struct b
 	}
 	if (!state || failrec->last_mirror > num_copies) {
 		set_state_private(failure_tree, failrec->start, 0);
-		clear_extent_bits(failure_tree, failrec->start,
-				  failrec->start + failrec->len - 1,
-				  EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
+		ret = clear_extent_bits(failure_tree, failrec->start,
+					failrec->start + failrec->len - 1,
+					EXTENT_LOCKED | EXTENT_DIRTY,
+					GFP_NOFS);
+		BUG_ON(ret < 0);
 		kfree(failrec);
 		return -EIO;
 	}
@@ -1963,11 +1967,13 @@ static int btrfs_clean_io_failures(struc
 				   private_failure;
 			set_state_private(&BTRFS_I(inode)->io_failure_tree,
 					  failure->start, 0);
-			clear_extent_bits(&BTRFS_I(inode)->io_failure_tree,
+			ret = clear_extent_bits(
+					  &BTRFS_I(inode)->io_failure_tree,
 					  failure->start,
 					  failure->start + failure->len - 1,
 					  EXTENT_DIRTY | EXTENT_LOCKED,
 					  GFP_NOFS);
+			BUG_ON(ret < 0);
 			kfree(failure);
 		}
 	}
@@ -2001,8 +2007,9 @@ static int btrfs_readpage_end_io_hook(st
 
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
 	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
-		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM,
-				  GFP_NOFS);
+		ret = clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM,
+					GFP_NOFS);
+		BUG_ON(ret < 0);
 		return 0;
 	}
 
@@ -3432,9 +3439,11 @@ again:
 		goto again;
 	}
 
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
-			  0, 0, &cached_state, GFP_NOFS);
+	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
+			       EXTENT_DIRTY | EXTENT_DELALLOC |
+			       EXTENT_DO_ACCOUNTING, 0, 0,
+			       &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
@@ -5584,6 +5593,7 @@ static int btrfs_get_blocks_direct(struc
 	u64 start = iblock << inode->i_blkbits;
 	u64 len = bh_result->b_size;
 	struct btrfs_trans_handle *trans;
+	int ret;
 
 	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
 	if (IS_ERR(em))
@@ -5679,9 +5689,11 @@ must_cow:
 		return PTR_ERR(em);
 	len = min(len, em->len - (start - em->start));
 unlock:
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, start + len - 1,
-			  EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DIRTY, 1,
-			  0, NULL, GFP_NOFS);
+	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, start,
+			       start + len - 1,
+			       EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DIRTY,
+			       1, 0, NULL, GFP_NOFS);
+	BUG_ON(ret < 0);
 map:
 	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
 		inode->i_blkbits;
@@ -6253,9 +6265,12 @@ static ssize_t btrfs_direct_IO(int rw, s
 				     &cached_state, GFP_NOFS);
 		BUG_ON(ret);
 		if (ret) {
-			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockend, EXTENT_LOCKED | write_bits,
-					 1, 0, &cached_state, GFP_NOFS);
+			int ret2;
+			ret2 = clear_extent_bit(&BTRFS_I(inode)->io_tree,
+						lockstart, lockend,
+						EXTENT_LOCKED | write_bits,
+						1, 0, &cached_state, GFP_NOFS);
+			BUG_ON(ret2 < 0);
 			goto out;
 		}
 	}
@@ -6269,19 +6284,21 @@ static ssize_t btrfs_direct_IO(int rw, s
 		   btrfs_submit_direct, 0);
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
-			      &cached_state, GFP_NOFS);
+		ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
+				       offset + iov_length(iov, nr_segs) - 1,
+				       EXTENT_LOCKED | write_bits, 1, 0,
+				       &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 	} else if (ret >= 0 && ret < iov_length(iov, nr_segs)) {
 		/*
 		 * We're falling back to buffered, unlock the section we didn't
 		 * do IO on.
 		 */
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
-			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
-			      &cached_state, GFP_NOFS);
+		ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
+				       offset + iov_length(iov, nr_segs) - 1,
+				       EXTENT_LOCKED | write_bits, 1, 0,
+				       &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 out:
 	free_extent_state(cached_state);
@@ -6391,10 +6408,11 @@ static void btrfs_invalidatepage(struct
 		 * IO on this page will never be started, so we need
 		 * to account for any ordered extents now
 		 */
-		clear_extent_bit(tree, page_start, page_end,
-				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
-				 &cached_state, GFP_NOFS);
+		ret = clear_extent_bit(tree, page_start, page_end,
+				       EXTENT_DIRTY | EXTENT_DELALLOC |
+				       EXTENT_LOCKED | EXTENT_DO_ACCOUNTING,
+				       1, 0, &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
@@ -6409,9 +6427,11 @@ static void btrfs_invalidatepage(struct
 				       0, &cached_state, GFP_NOFS);
 		BUG_ON(ret < 0);
 	}
-	clear_extent_bit(tree, page_start, page_end,
-		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
+	ret = clear_extent_bit(tree, page_start, page_end,
+			       EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
+			       EXTENT_DO_ACCOUNTING, 1, 1,
+			       &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
@@ -6501,9 +6521,11 @@ again:
 	 * is probably a better way to do this, but for now keep consistent with
 	 * prepare_pages in the normal write path.
 	 */
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
-			  0, 0, &cached_state, GFP_NOFS);
+	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
+			       EXTENT_DIRTY | EXTENT_DELALLOC |
+			       EXTENT_DO_ACCOUNTING, 0, 0,
+			       &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -926,10 +926,11 @@ again:
 	if (ordered)
 		btrfs_put_ordered_extent(ordered);
 
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
-			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-			  GFP_NOFS);
+	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
+			       page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
+			       EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
+			       GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	if (i_done != num_pages) {
 		spin_lock(&BTRFS_I(inode)->lock);
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3834,8 +3834,9 @@ restart:
 	}
 
 	btrfs_release_path(path);
-	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY,
-			  GFP_NOFS);
+	ret = clear_extent_bits(&rc->processed_blocks, 0, (u64)-1,
+				EXTENT_DIRTY, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	if (trans) {
 		nr = trans->blocks_used;
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -636,7 +636,9 @@ int btrfs_wait_marked_extents(struct btr
 		if (ret)
 			break;
 
-		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
+		ret = clear_extent_bits(dirty_pages, start, end,
+					mark, GFP_NOFS);
+		BUG_ON(ret < 0);
 		while (start <= end) {
 			index = start >> PAGE_CACHE_SHIFT;
 			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2158,8 +2158,9 @@ static void free_log_tree(struct btrfs_t
 		if (ret)
 			break;
 
-		clear_extent_bits(&log->dirty_log_pages, start, end,
-				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
+		ret = clear_extent_bits(&log->dirty_log_pages, start, end,
+					EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 
 	free_extent_buffer(log->node);


