Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21787 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbcGDEfM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:35:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644XfKm062810
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:35:12 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23x8wuqtnw-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:35:12 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 3 Jul 2016 22:35:11 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 02/19] Btrfs: subpage-blocksize: Fix whole page write
Date: Mon,  4 Jul 2016 10:04:22 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-3-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the subpage-blocksize scenario, a page can contain multiple
blocks. In such cases, this patch handles writing data to files.

Also, When setting EXTENT_DELALLOC, we no longer set EXTENT_UPTODATE bit on
the extent_io_tree since uptodate status is being tracked by the bitmap
pointed to by page->private.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c  | 150 ++++++++++++++++++++++++--------------------------
 fs/btrfs/file.c       |  17 ++++++
 fs/btrfs/inode.c      |  75 +++++++++++++++++++++----
 fs/btrfs/relocation.c |   3 +
 4 files changed, 155 insertions(+), 90 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a349f99..0adbff5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1494,24 +1494,6 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
 	}
 }
 
-/*
- * helper function to set both pages and extents in the tree writeback
- */
-static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
-{
-	unsigned long index = start >> PAGE_SHIFT;
-	unsigned long end_index = end >> PAGE_SHIFT;
-	struct page *page;
-
-	while (index <= end_index) {
-		page = find_get_page(tree->mapping, index);
-		BUG_ON(!page); /* Pages should be in the extent_io_tree */
-		set_page_writeback(page);
-		put_page(page);
-		index++;
-	}
-}
-
 /* find the first state struct with 'bits' set after 'start', and
  * return it.  tree->lock must be held.  NULL will returned if
  * nothing was found after 'start'
@@ -2585,36 +2567,41 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
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
+		struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 
-		/* We always issue full-page reads, but if some block
-		 * in a page fails to read, blk_update_request() will
-		 * advance bv_offset and adjust bv_len to compensate.
-		 * Print a warning for nonzero offsets, and an error
-		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_SIZE) {
-			if (bvec->bv_offset + bvec->bv_len != PAGE_SIZE)
-				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "partial page write in btrfs with offset %u and length %u",
-					bvec->bv_offset, bvec->bv_len);
-			else
-				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page write in btrfs with offset %u and "
-				   "length %u",
-					bvec->bv_offset, bvec->bv_len);
-		}
+		pg_private = NULL;
+		flags = 0;
+		clear_writeback = 1;
 
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
+
+		if (root->sectorsize < PAGE_SIZE) {
+			pg_private = (struct btrfs_page_private *)page->private;
+			spin_lock_irqsave(&pg_private->io_lock, flags);
+		}
 
 		end_extent_writepage(page, bio->bi_error, start, end);
-		end_page_writeback(page);
+
+		if (root->sectorsize < PAGE_SIZE) {
+			clear_page_blks_state(page, 1 << BLK_STATE_IO, start,
+					end);
+			clear_writeback = page_io_complete(page);
+			spin_unlock_irqrestore(&pg_private->io_lock, flags);
+		}
+
+		if (clear_writeback)
+			end_page_writeback(page);
 	}
 
 	bio_put(bio);
@@ -3486,7 +3473,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	u64 block_start;
 	u64 iosize;
 	sector_t sector;
-	struct extent_state *cached_state = NULL;
 	struct extent_map *em;
 	struct block_device *bdev;
 	size_t pg_offset = 0;
@@ -3538,20 +3524,29 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 							 page_end, NULL, 1);
 			break;
 		}
-		em = epd->get_extent(inode, page, pg_offset, cur,
-				     end - cur + 1, 1);
+
+		if (blocksize < PAGE_SIZE
+			&& !test_page_blks_state(page, BLK_STATE_DIRTY, cur,
+						cur + blocksize - 1, 1)) {
+			cur += blocksize;
+			continue;
+		}
+
+		pg_offset = cur & (PAGE_SIZE - 1);
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
-		iosize = ALIGN(iosize, blocksize);
+
+		iosize = blocksize;
+		extent_offset = cur - em->start;
 		sector = (em->block_start + extent_offset) >> 9;
 		bdev = em->bdev;
 		block_start = em->block_start;
@@ -3559,65 +3554,64 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
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
+		ASSERT(!compressed);
+		ASSERT(block_start != EXTENT_MAP_INLINE);
 
+		if (block_start == EXTENT_MAP_HOLE) {
+			if (blocksize < PAGE_SIZE) {
+				if (test_page_blks_state(page, BLK_STATE_UPTODATE,
+								cur, cur + iosize - 1,
+								1)) {
+					clear_page_blks_state(page,
+							1 << BLK_STATE_DIRTY, cur,
+							cur + iosize - 1);
+				} else {
+					BUG();
+				}
+			} else if (!PageUptodate(page)) {
+					BUG();
+			}
 			cur += iosize;
-			pg_offset += iosize;
 			continue;
 		}
 
 		max_nr = (i_size >> PAGE_SHIFT) + 1;
 
-		set_range_writeback(tree, cur, cur + iosize - 1);
+		if (blocksize < PAGE_SIZE)
+			clear_page_blks_state(page,
+					1 << BLK_STATE_DIRTY, cur,
+					cur + iosize - 1);
+		set_page_writeback(page);
+
+		if (blocksize < PAGE_SIZE)
+			set_page_blks_state(page, 1 << BLK_STATE_IO,
+					cur, cur + iosize - 1);
+
 		if (!PageWriteback(page)) {
 			btrfs_err(BTRFS_I(inode)->root->fs_info,
-				   "page %lu not writeback, cur %llu end %llu",
-			       page->index, cur, end);
+				"page %lu not writeback, cur %llu end %llu",
+				page->index, cur, end);
 		}
 
 		ret = submit_extent_page(write_flags, tree, wbc, page,
-					 sector, iosize, pg_offset,
-					 bdev, &epd->bio, max_nr,
-					 end_bio_extent_writepage,
-					 0, 0, 0, false);
+					sector, iosize, pg_offset,
+					bdev, &epd->bio, max_nr,
+					end_bio_extent_writepage,
+					0, 0, 0, false);
 		if (ret)
 			SetPageError(page);
 
-		cur = cur + iosize;
-		pg_offset += iosize;
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
 
+
 /*
  * the writepage semantics are similar to regular writepage.  extent
  * records are inserted to lock ranges in the tree, and as dirty areas
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8d7c79a..38f5e8e 100644
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
 
@@ -507,11 +510,25 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	if (err)
 		return err;
 
+	start = start_pos;
+
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = pages[i];
 		SetPageUptodate(p);
 		ClearPageChecked(p);
+
+		end = page_end = page_offset(p) + PAGE_SIZE - 1;
+
+		if (i == num_pages - 1)
+			end = min_t(u64, page_end, end_of_last_block);
+
+		if (root->sectorsize < PAGE_SIZE)
+			set_page_blks_state(p,
+					1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+					start, end);
 		set_page_dirty(p);
+
+		start = page_end + 1;
 	}
 
 	/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 27cb723..e8a0005 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -211,6 +211,10 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 		page = find_get_page(inode->i_mapping,
 				     start >> PAGE_SHIFT);
 		btrfs_set_file_extent_compression(leaf, ei, 0);
+		if (root->sectorsize < PAGE_SIZE)
+			clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, start,
+					round_up(start + size - 1, root->sectorsize)
+					- 1);
 		kaddr = kmap_atomic(page);
 		offset = start & (PAGE_SIZE - 1);
 		write_extent_buffer(leaf, kaddr + offset, ptr, size);
@@ -2007,6 +2011,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct btrfs_root *root;
 	struct page *page;
 	struct inode *inode;
 	u64 page_start;
@@ -2023,6 +2028,7 @@ again:
 	}
 
 	inode = page->mapping->host;
+	root = BTRFS_I(inode)->root;
 	page_start = page_offset(page);
 	page_end = page_offset(page) + PAGE_SIZE - 1;
 
@@ -2054,6 +2060,12 @@ again:
 	 }
 
 	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
+
+	if (root->sectorsize < PAGE_SIZE)
+		set_page_blks_state(page,
+				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+				page_start, page_end);
+
 	ClearPageChecked(page);
 	set_page_dirty(page);
 out:
@@ -3056,26 +3068,48 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
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
 
@@ -4767,6 +4801,11 @@ again:
 		goto out_unlock;
 	}
 
+	if (blocksize < PAGE_SIZE)
+		set_page_blks_state(page,
+				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+				block_start, block_end);
+
 	if (offset != blocksize) {
 		if (!len)
 			len = blocksize - offset;
@@ -8819,6 +8858,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 				 unsigned int length)
 {
 	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
@@ -8907,6 +8947,11 @@ again:
 	 *    This means the reserved space should be freed here.
 	 */
 	btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
+
+	if (root->sectorsize < PAGE_SIZE)
+		clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, page_start,
+				page_end);
+
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
@@ -9050,6 +9095,12 @@ again:
 		ret = VM_FAULT_SIGBUS;
 		goto out_unlock;
 	}
+
+	if (root->sectorsize < PAGE_SIZE)
+		set_page_blks_state(page,
+				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+				page_start, end);
+
 	ret = 0;
 
 	/* page is wholly or partially inside EOF */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fc067b0..05b88f8 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3190,6 +3190,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		}
 
 		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
+		set_page_blks_state(page,
+				1 << BLK_STATE_DIRTY | 1 << BLK_STATE_UPTODATE,
+				page_start, page_end);
 		set_page_dirty(page);
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
-- 
2.5.5

