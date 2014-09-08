Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37770 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaIHOPX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 10:15:23 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 8 Sep 2014 19:45:21 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id A1827E0023
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Sep 2014 19:47:43 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s88EFk3X721380
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:45:46 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s88EFDCr023664
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:45:19 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V6 14/15] Btrfs: subpagesize-blocksize: Explicitly Track I/O status of blocks of an ordered extent.
Date: Mon,  8 Sep 2014 19:44:25 +0530
Message-Id: <1410185666-23308-15-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1410185666-23308-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1410185666-23308-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario a page can have more than one block. So
in addition to PagePrivate2 flag, we would have to track the I/O status of
each block of a page to reliably mark the ordered extent as complete.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c        | 327 ++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/ordered-data.c |  17 +++
 fs/btrfs/ordered-data.h |   4 +
 3 files changed, 267 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4ed78dd..d79a543 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2827,51 +2827,115 @@ static void finish_ordered_fn(struct btrfs_work *work)
 	btrfs_finish_ordered_io(ordered_extent);
 }
 
-static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
+static void mark_blks_io_complete(struct btrfs_ordered_extent *ordered,
+				u64 blk, u64 nr_blks, int uptodate)
+{
+	struct inode *inode = ordered->inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_workqueue *workers;
+	int done;
+
+	while (nr_blks--) {
+		if (test_and_set_bit(blk, ordered->blocks_done)) {
+			blk++;
+			continue;
+		}
+
+		done = btrfs_dec_test_ordered_pending(inode, &ordered,
+						ordered->file_offset
+						+ (blk << inode->i_sb->s_blocksize_bits),
+						root->sectorsize,
+						uptodate);
+		if (done) {
+			btrfs_init_work(&ordered->work, finish_ordered_fn,
+					NULL, NULL);
+
+			ordered->work.func = finish_ordered_fn;
+			ordered->work.flags = 0;
+
+			if (btrfs_is_free_space_inode(inode))
+				workers = root->fs_info->endio_freespace_worker;
+			else
+				workers = root->fs_info->endio_write_workers;
+
+			btrfs_queue_work(workers, &ordered->work);
+		}
+
+		blk++;
+	}
+}
+
+int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
-	struct btrfs_workqueue *workers;
-	u64 ordered_start, ordered_end;
-	int done;
+	u64 blk, nr_blks;
+	int clear;
 
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
-	ClearPagePrivate2(page);
-loop:
-	ordered_extent = btrfs_lookup_ordered_range(inode, start,
-						end - start + 1);
-	if (!ordered_extent)
-		goto out;
+	while (start < end) {
+		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
+		if (!ordered_extent) {
+			start += root->sectorsize;
+			continue;
+		}
 
-	ordered_start = max_t(u64, start, ordered_extent->file_offset);
-	ordered_end = min_t(u64, end,
-			ordered_extent->file_offset + ordered_extent->len - 1);
+		blk = (start - ordered_extent->file_offset)
+			>> inode->i_sb->s_blocksize_bits;
 
-	done = btrfs_dec_test_ordered_pending(inode, &ordered_extent,
-					ordered_start,
-					ordered_end - ordered_start + 1,
-					uptodate);
-	if (done) {
-		btrfs_init_work(&ordered_extent->work, finish_ordered_fn, NULL, NULL);
+		nr_blks = (min(end, ordered_extent->file_offset + ordered_extent->len - 1)
+			+ 1 - start) >> inode->i_sb->s_blocksize_bits;
 
-		if (btrfs_is_free_space_inode(inode))
-			workers = root->fs_info->endio_freespace_worker;
-		else
-			workers = root->fs_info->endio_write_workers;
+		BUG_ON(!nr_blks);
 
-		btrfs_queue_work(workers, &ordered_extent->work);
+		mark_blks_io_complete(ordered_extent, blk, nr_blks, uptodate);
+
+		start = ordered_extent->file_offset + ordered_extent->len;
+
+		btrfs_put_ordered_extent(ordered_extent);
 	}
 
-	btrfs_put_ordered_extent(ordered_extent);
+	start = page_offset(page);
+	end = start + PAGE_CACHE_SIZE - 1;
+	clear = 1;
 
-	start = ordered_end + 1;
+	while (start < end) {
+		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
+		if (!ordered_extent) {
+			start += root->sectorsize;
+			continue;
+		}
+
+		blk = (start - ordered_extent->file_offset)
+			>> inode->i_sb->s_blocksize_bits;
+		nr_blks = (min(end, ordered_extent->file_offset + ordered_extent->len - 1)
+			+ 1  - start) >> inode->i_sb->s_blocksize_bits;
+
+		BUG_ON(!nr_blks);
+
+		while (nr_blks--) {
+			if (!test_bit(blk++, ordered_extent->blocks_done)) {
+				clear = 0;
+				break;
+			}
+		}
+
+		if (!clear) {
+			btrfs_put_ordered_extent(ordered_extent);
+			break;
+		}
+
+		start += ordered_extent->len;
+
+		btrfs_put_ordered_extent(ordered_extent);
+	}
+
+	if (clear)
+		ClearPagePrivate2(page);
 
-	if (start < end)
-		goto loop;
-out:
 	return 0;
 }
 
@@ -7707,17 +7771,125 @@ static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 	return __btrfs_releasepage(page, gfp_flags & GFP_NOFS);
 }
 
+static void invalidate_ordered_extent_blocks(struct inode *inode,
+					struct btrfs_ordered_extent *ordered,
+					u64 range_start, u64 range_end,
+					u64 cur,
+					int inode_evicting)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_ordered_inode_tree *ordered_tree;
+	struct extent_io_tree *tree;
+	u64 blk, blk_done, nr_blks;
+	u64 end;
+	u64 new_len;
+
+	tree = &BTRFS_I(inode)->io_tree;
+
+	end = min(range_end, ordered->file_offset + ordered->len - 1);
+
+	if (!inode_evicting) {
+		clear_extent_bit(tree, cur, end,
+				EXTENT_DIRTY | EXTENT_DELALLOC |
+				EXTENT_DO_ACCOUNTING |
+				EXTENT_DEFRAG, 1, 0, NULL,
+				GFP_NOFS);
+		unlock_extent(tree, range_start, range_end);
+	}
+
+
+	ordered_tree = &BTRFS_I(inode)->ordered_tree;
+	spin_lock_irq(&ordered_tree->lock);
+	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
+	new_len = cur - ordered->file_offset;
+	if (new_len < ordered->truncated_len) {
+		ordered->truncated_len = new_len;
+	}
+
+	blk = (cur - ordered->file_offset) >> inode->i_sb->s_blocksize_bits;
+	nr_blks = (end + 1 - cur) >> inode->i_sb->s_blocksize_bits;
+
+	while (nr_blks--) {
+		blk_done = !test_and_set_bit(blk, ordered->blocks_done);
+		if (blk_done) {
+			spin_unlock_irq(&ordered_tree->lock);
+			if (btrfs_dec_test_ordered_pending(inode, &ordered,
+								ordered->file_offset + (blk << inode->i_sb->s_blocksize_bits),
+								root->sectorsize,
+								1))
+				btrfs_finish_ordered_io(ordered);
+
+			spin_lock_irq(&ordered_tree->lock);
+		}
+		blk++;
+	}
+
+	spin_unlock_irq(&ordered_tree->lock);
+
+	if (!inode_evicting)
+		lock_extent_bits(tree, range_start, range_end, 0, NULL);
+}
+
+static int page_blocks_written(struct page *page)
+{
+	struct btrfs_ordered_extent *ordered;
+	struct btrfs_root *root;
+	struct inode *inode;
+	unsigned long outstanding_blk;
+	u64 page_start, page_end;
+	u64 blk, nr_blks;
+	u64 cur;
+	u64 len;
+
+	inode = page->mapping->host;
+	root = BTRFS_I(inode)->root;
+
+	page_start = page_offset(page);
+	page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
+
+	cur = page_start;
+	while (cur < page_end) {
+		ordered = btrfs_lookup_ordered_extent(inode, cur);
+		if (ordered) {
+			blk = (cur - ordered->file_offset)
+				>> inode->i_sb->s_blocksize_bits;
+			len = min(page_end, ordered->file_offset + ordered->len - 1)
+				- cur + 1;
+			nr_blks = len >> inode->i_sb->s_blocksize_bits;
+
+			outstanding_blk = find_next_zero_bit(ordered->blocks_done,
+							ordered->len >> inode->i_sb->s_blocksize_bits,
+							blk);
+			if (outstanding_blk < len >> inode->i_sb->s_blocksize_bits) {
+				btrfs_put_ordered_extent(ordered);
+				return 0;
+			}
+
+			btrfs_put_ordered_extent(ordered);
+			cur += len;
+		} else {
+			cur += root->sectorsize;
+		}
+	}
+
+	return 1;
+}
+
 static void btrfs_invalidatepage(struct page *page, unsigned int offset,
-				 unsigned int length)
+				unsigned int length)
 {
 	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
-	u64 page_start = page_offset(page);
-	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
+	u64 start, end, cur;
+	u64 page_start, page_end;
 	int inode_evicting = inode->i_state & I_FREEING;
 
+	page_start = page_offset(page);
+	page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
+
 	/*
 	 * we have the page locked, so new writeback can't start,
 	 * and the dirty bit won't be cleared while we are here.
@@ -7728,73 +7900,66 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	wait_on_page_writeback(page);
 
 	tree = &BTRFS_I(inode)->io_tree;
-	if (offset) {
+
+	start = round_up(offset, root->sectorsize);
+	end = round_down(offset + length, root->sectorsize) - 1;
+	if (end - start + 1 < root->sectorsize) {
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
 
+	start = round_up(page_offset(page) + offset, root->sectorsize);
+	end = round_down(page_offset(page) + offset + length,
+			root->sectorsize) - 1;
 	if (!inode_evicting)
-		lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
-	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_CACHE_SIZE);
-	if (ordered) {
-		/*
-		 * IO on this page will never be started, so we need
-		 * to account for any ordered extents now
-		 */
-		if (!inode_evicting)
-			clear_extent_bit(tree, page_start, page_end,
-					 EXTENT_DIRTY | EXTENT_DELALLOC |
-					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
-					 EXTENT_DEFRAG, 1, 0, &cached_state,
-					 GFP_NOFS);
-		/*
-		 * whoever cleared the private bit is responsible
-		 * for the finish_ordered_io
-		 */
-		if (TestClearPagePrivate2(page)) {
-			struct btrfs_ordered_inode_tree *tree;
-			u64 new_len;
+		lock_extent_bits(tree, start, end, 0, NULL);
 
-			tree = &BTRFS_I(inode)->ordered_tree;
+	cur = start;
+	while (cur < end) {
+		ordered = btrfs_lookup_ordered_extent(inode, cur);
+		if (!ordered) {
+			cur += root->sectorsize;
+			continue;
+		}
 
-			spin_lock_irq(&tree->lock);
-			set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
-			new_len = page_start - ordered->file_offset;
-			if (new_len < ordered->truncated_len)
-				ordered->truncated_len = new_len;
-			spin_unlock_irq(&tree->lock);
+		invalidate_ordered_extent_blocks(inode, ordered,
+						start, end, cur,
+						inode_evicting);
 
-			if (btrfs_dec_test_ordered_pending(inode, &ordered,
-							   page_start,
-							   PAGE_CACHE_SIZE, 1))
-				btrfs_finish_ordered_io(ordered);
-		}
+		cur = min(end + 1, ordered->file_offset + ordered->len);
 		btrfs_put_ordered_extent(ordered);
-		if (!inode_evicting) {
-			cached_state = NULL;
-			lock_extent_bits(tree, page_start, page_end, 0,
-					 &cached_state);
-		}
 	}
 
 	if (!inode_evicting) {
-		clear_extent_bit(tree, page_start, page_end,
-				 EXTENT_LOCKED | EXTENT_DIRTY |
-				 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
-				 EXTENT_DEFRAG, 1, 1,
-				 &cached_state, GFP_NOFS);
-
+		cached_state = NULL;
+		clear_extent_bit(tree, start, end,
+				EXTENT_LOCKED | EXTENT_DIRTY |
+				EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
+				EXTENT_DEFRAG, 1, 1,
+				&cached_state, GFP_NOFS);
 		__btrfs_releasepage(page, GFP_NOFS);
 	}
 
-	ClearPageChecked(page);
-	if (PagePrivate(page)) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		page_cache_release(page);
+	if (!inode_evicting)
+		lock_extent_bits(tree, page_start, page_end, 0, NULL);
+
+	if (page_blocks_written(page))
+		ClearPagePrivate2(page);
+
+	if (!inode_evicting)
+		unlock_extent(tree, page_start, page_end);
+
+	if (length == PAGE_CACHE_SIZE) {
+		ClearPageChecked(page);
+		if (PagePrivate(page)) {
+			ClearPagePrivate(page);
+			set_page_private(page, 0);
+			page_cache_release(page);
+		}
 	}
 }
 
+
 /*
  * btrfs_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 963895c..4d9832f 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -189,12 +189,25 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry;
+	u64 nr_longs;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
 	if (!entry)
 		return -ENOMEM;
 
+	nr_longs = BITS_TO_LONGS(len >> inode->i_sb->s_blocksize_bits);
+	if (nr_longs == 1) {
+		entry->blocks_done = &entry->blocks_bitmap;
+	} else {
+		entry->blocks_done = kzalloc(nr_longs * sizeof(unsigned long),
+					GFP_NOFS);
+		if (!entry->blocks_done) {
+			kmem_cache_free(btrfs_ordered_extent_cache, entry);
+			return -ENOMEM;
+		}
+	}
+
 	entry->file_offset = file_offset;
 	entry->start = start;
 	entry->len = len;
@@ -541,6 +554,10 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
+
+		if (entry->blocks_done != &entry->blocks_bitmap)
+			kfree(entry->blocks_done);
+
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index d81a274..7de3b1e 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -135,6 +135,10 @@ struct btrfs_ordered_extent {
 	struct completion completion;
 	struct btrfs_work flush_work;
 	struct list_head work_list;
+
+	/* bitmap to track the blocks that have been written to disk */
+	unsigned long *blocks_done;
+	unsigned long blocks_bitmap;
 };
 
 /*
-- 
1.8.3.1

