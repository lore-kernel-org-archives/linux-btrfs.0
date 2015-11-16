Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57337 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbKPHJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:09:14 -0500
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 12:39:11 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 8078AE00A5
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:37 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG78veM17104936
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:58 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG78ubE027261
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:57 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [RFC PATCH V12 02/14] Btrfs: subpagesize-blocksize: Fix whole page write
Date: Mon, 16 Nov 2015 12:38:29 +0530
Message-Id: <1447657721-10025-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the subpagesize-blocksize scenario, a page can contain multiple
blocks. In such cases, this patch handles writing data to files.

Also, When setting EXTENT_DELALLOC, we no longer set EXTENT_UPTODATE bit on
the extent_io_tree since uptodate status is being tracked by the bitmap
pointed to by page->private.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c  | 154 ++++++++++++++++++++++++--------------------------
 fs/btrfs/file.c       |  16 ++++++
 fs/btrfs/inode.c      |  64 +++++++++++++++++----
 fs/btrfs/relocation.c |   3 +
 4 files changed, 146 insertions(+), 91 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c377456..92fe728 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1351,9 +1351,8 @@ int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end,
-			      EXTENT_DELALLOC | EXTENT_UPTODATE,
-			      NULL, cached_state, mask);
+	return set_extent_bit(tree, start, end, EXTENT_DELALLOC,
+			NULL, cached_state, mask);
 }
 
 int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1573,25 +1572,6 @@ int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 	return 0;
 }
 
-/*
- * helper function to set both pages and extents in the tree writeback
- */
-static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
-{
-	unsigned long index = start >> PAGE_CACHE_SHIFT;
-	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
-	struct page *page;
-
-	while (index <= end_index) {
-		page = find_get_page(tree->mapping, index);
-		BUG_ON(!page); /* Pages should be in the extent_io_tree */
-		set_page_writeback(page);
-		page_cache_release(page);
-		index++;
-	}
-	return 0;
-}
-
 /* find the first state struct with 'bits' set after 'start', and
  * return it.  tree->lock must be held.  NULL will returned if
  * nothing was found after 'start'
@@ -2155,6 +2135,14 @@ static int page_read_complete(struct page *page)
 	return !test_page_blks_state(page, BLK_STATE_IO, start, end, 0);
 }
 
+static int page_write_complete(struct page *page)
+{
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_CACHE_SIZE - 1;
+
+	return !test_page_blks_state(page, BLK_STATE_IO, start, end, 0);
+}
+
 int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 {
 	int ret;
@@ -2650,38 +2638,37 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  */
 static void end_bio_extent_writepage(struct bio *bio)
 {
+	struct btrfs_page_private *pg_private;
 	struct bio_vec *bvec;
+	unsigned long flags;
 	u64 start;
 	u64 end;
+	int clear_writeback;
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		/* We always issue full-page reads, but if some block
-		 * in a page fails to read, blk_update_request() will
-		 * advance bv_offset and adjust bv_len to compensate.
-		 * Print a warning for nonzero offsets, and an error
-		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
-			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
-				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "partial page write in btrfs with offset %u and length %u",
-					bvec->bv_offset, bvec->bv_len);
-			else
-				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page write in btrfs with offset %u and "
-				   "length %u",
-					bvec->bv_offset, bvec->bv_len);
-		}
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
 
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
+		pg_private = (struct btrfs_page_private *)page->private;
 
-		if (end_extent_writepage(page, bio->bi_error, start, end))
+		spin_lock_irqsave(&pg_private->io_lock, flags);
+
+		if (end_extent_writepage(page, bio->bi_error, start, end)) {
+			spin_unlock_irqrestore(&pg_private->io_lock, flags);
 			continue;
+		}
 
-		end_page_writeback(page);
+		clear_page_blks_state(page, 1 << BLK_STATE_IO, start, end);
+
+		clear_writeback = page_write_complete(page);
+
+		spin_unlock_irqrestore(&pg_private->io_lock, flags);
+
+		if (clear_writeback)
+			end_page_writeback(page);
 	}
 
 	bio_put(bio);
@@ -3544,14 +3531,14 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
 	u64 cur = start;
+	u64 next;
 	u64 extent_offset;
 	u64 block_start;
 	u64 iosize;
 	sector_t sector;
-	struct extent_state *cached_state = NULL;
 	struct extent_map *em;
 	struct block_device *bdev;
-	size_t pg_offset = 0;
+	size_t pg_offset;
 	size_t blocksize;
 	int ret = 0;
 	int nr = 0;
@@ -3598,20 +3585,38 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 							 page_end, NULL, 1);
 			break;
 		}
-		em = epd->get_extent(inode, page, pg_offset, cur,
-				     end - cur + 1, 1);
+
+		if (!test_page_blks_state(page, BLK_STATE_DIRTY, cur,
+						cur + blocksize - 1, 1)) {
+			cur += blocksize;
+			continue;
+		}
+
+		pg_offset = cur & (PAGE_CACHE_SIZE - 1);
+
+		em = epd->get_extent(inode, page, pg_offset, cur, blocksize, 1);
 		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
 			ret = PTR_ERR_OR_ZERO(em);
 			break;
 		}
 
-		extent_offset = cur - em->start;
 		em_end = extent_map_end(em);
 		BUG_ON(em_end <= cur);
 		BUG_ON(end < cur);
-		iosize = min(em_end - cur, end - cur + 1);
+
+		iosize = blocksize;
+		next = cur + blocksize;
+		while ((next < end)
+			&& (next < em_end)
+			&& test_page_blks_state(page, BLK_STATE_DIRTY, next,
+						next + blocksize - 1, 1)) {
+			iosize += blocksize;
+			next += blocksize;
+		}
+
 		iosize = ALIGN(iosize, blocksize);
+		extent_offset = cur - em->start;
 		sector = (em->block_start + extent_offset) >> 9;
 		bdev = em->bdev;
 		block_start = em->block_start;
@@ -3619,32 +3624,20 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		free_extent_map(em);
 		em = NULL;
 
-		/*
-		 * compressed and inline extents are written through other
-		 * paths in the FS
-		 */
-		if (compressed || block_start == EXTENT_MAP_HOLE ||
-		    block_start == EXTENT_MAP_INLINE) {
-			/*
-			 * end_io notification does not happen here for
-			 * compressed extents
-			 */
-			if (!compressed && tree->ops &&
-			    tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, cur,
-							 cur + iosize - 1,
-							 NULL, 1);
-			else if (compressed) {
-				/* we don't want to end_page_writeback on
-				 * a compressed extent.  this happens
-				 * elsewhere
-				 */
-				nr++;
-			}
+		BUG_ON(compressed);
+		BUG_ON(block_start == EXTENT_MAP_INLINE);
 
-			cur += iosize;
-			pg_offset += iosize;
-			continue;
+		if (block_start == EXTENT_MAP_HOLE) {
+			if (test_page_blks_state(page, BLK_STATE_UPTODATE, cur,
+							cur + iosize - 1, 1)) {
+				clear_page_blks_state(page,
+						1 << BLK_STATE_DIRTY, cur,
+						cur + iosize - 1);
+				cur += iosize;
+				continue;
+			} else {
+				BUG();
+			}
 		}
 
 		if (tree->ops && tree->ops->writepage_io_hook) {
@@ -3658,7 +3651,13 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		} else {
 			unsigned long max_nr = (i_size >> PAGE_CACHE_SHIFT) + 1;
 
-			set_range_writeback(tree, cur, cur + iosize - 1);
+			clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, cur,
+					cur + iosize - 1);
+			set_page_writeback(page);
+
+			set_page_blks_state(page, 1 << BLK_STATE_IO, cur,
+					cur + iosize - 1);
+
 			if (!PageWriteback(page)) {
 				btrfs_err(BTRFS_I(inode)->root->fs_info,
 					   "page %lu not writeback, cur %llu end %llu",
@@ -3673,17 +3672,14 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			if (ret)
 				SetPageError(page);
 		}
-		cur = cur + iosize;
-		pg_offset += iosize;
+
+		cur += iosize;
 		nr++;
 	}
 done:
 	*nr_ret = nr;
 
 done_unlocked:
-
-	/* drop our reference on any cached states */
-	free_extent_state(cached_state);
 	return ret;
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f0f3a189..386299f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -495,6 +495,9 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	u64 num_bytes;
 	u64 start_pos;
 	u64 end_of_last_block;
+	u64 start;
+	u64 end;
+	u64 page_end;
 	u64 end_pos = pos + write_bytes;
 	loff_t isize = i_size_read(inode);
 
@@ -507,11 +510,24 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	if (err)
 		return err;
 
+	start = start_pos;
+
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = pages[i];
 		SetPageUptodate(p);
 		ClearPageChecked(p);
+
+		end = page_end = page_offset(p) + PAGE_CACHE_SIZE - 1;
+
+		if (i == num_pages - 1)
+			end = min_t(u64, page_end, end_of_last_block);
+
+		set_page_blks_state(p,
+				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+				start, end);
 		set_page_dirty(p);
+
+		start = page_end + 1;
 	}
 
 	/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b5f7e0dc..29d6c07 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -204,6 +204,9 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 		page = find_get_page(inode->i_mapping,
 				     start >> PAGE_CACHE_SHIFT);
 		btrfs_set_file_extent_compression(leaf, ei, 0);
+		clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, start,
+                                round_up(start + size - 1, root->sectorsize)
+				- 1);
 		kaddr = kmap_atomic(page);
 		offset = start & (PAGE_CACHE_SIZE - 1);
 		write_extent_buffer(leaf, kaddr + offset, ptr, size);
@@ -2011,6 +2014,11 @@ again:
 	 }
 
 	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
+
+	set_page_blks_state(page,
+			1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+			page_start, page_end);
+
 	ClearPageChecked(page);
 	set_page_dirty(page);
 out:
@@ -3013,26 +3021,48 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct btrfs_workqueue *wq;
 	btrfs_work_func_t func;
+	u64 ordered_start, ordered_end;
+	int done;
 
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
 	ClearPagePrivate2(page);
-	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
-					    end - start + 1, uptodate))
-		return 0;
+loop:
+	ordered_extent = btrfs_lookup_ordered_range(inode, start,
+						end - start + 1);
+	if (!ordered_extent)
+		goto out;
 
-	if (btrfs_is_free_space_inode(inode)) {
-		wq = root->fs_info->endio_freespace_worker;
-		func = btrfs_freespace_write_helper;
-	} else {
-		wq = root->fs_info->endio_write_workers;
-		func = btrfs_endio_write_helper;
+	ordered_start = max_t(u64, start, ordered_extent->file_offset);
+	ordered_end = min_t(u64, end,
+			ordered_extent->file_offset + ordered_extent->len - 1);
+
+	done = btrfs_dec_test_ordered_pending(inode, &ordered_extent,
+					ordered_start,
+					ordered_end - ordered_start + 1,
+					uptodate);
+	if (done) {
+		if (btrfs_is_free_space_inode(inode)) {
+			wq = root->fs_info->endio_freespace_worker;
+			func = btrfs_freespace_write_helper;
+		} else {
+			wq = root->fs_info->endio_write_workers;
+			func = btrfs_endio_write_helper;
+		}
+
+		btrfs_init_work(&ordered_extent->work, func,
+				finish_ordered_fn, NULL, NULL);
+		btrfs_queue_work(wq, &ordered_extent->work);
 	}
 
-	btrfs_init_work(&ordered_extent->work, func, finish_ordered_fn, NULL,
-			NULL);
-	btrfs_queue_work(wq, &ordered_extent->work);
+	btrfs_put_ordered_extent(ordered_extent);
+
+	start = ordered_end + 1;
+
+	if (start < end)
+		goto loop;
 
+out:
 	return 0;
 }
 
@@ -4714,6 +4744,9 @@ again:
 		goto out_unlock;
 	}
 
+	set_page_blks_state(page, 1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+			block_start, block_end);
+
 	if (offset != blocksize) {
 		if (!len)
 			len = blocksize - offset;
@@ -8739,6 +8772,9 @@ again:
 	 *    This means the reserved space should be freed here.
 	 */
 	btrfs_qgroup_free_data(inode, page_start, PAGE_CACHE_SIZE);
+
+	clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, page_start, page_end);
+
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
@@ -8882,6 +8918,10 @@ again:
 		ret = VM_FAULT_SIGBUS;
 		goto out_unlock;
 	}
+
+	set_page_blks_state(page, 1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+			page_start, end);
+
 	ret = 0;
 
 	/* page is wholly or partially inside EOF */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b4ca545..8867451 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3185,6 +3185,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		}
 
 		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
+		set_page_blks_state(page,
+				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+				page_start, page_end);
 		set_page_dirty(page);
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
-- 
2.1.0

