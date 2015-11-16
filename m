Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33575 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbbKPHJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:09:05 -0500
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 12:39:02 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 4E3BA39400A9
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:00 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG78xAl52953180
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:59 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG78uSF027334
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:57 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [RFC PATCH V12 09/14] Btrfs: subpagesize-blocksize: Explicitly track I/O status of blocks of an ordered extent.
Date: Mon, 16 Nov 2015 12:38:36 +0530
Message-Id: <1447657721-10025-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario a page can have more than one block. So
in addition to PagePrivate2 flag, we would have to track the I/O status of
each block of a page to reliably mark the ordered extent as complete.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c    |  19 +--
 fs/btrfs/extent_io.h    |   5 +-
 fs/btrfs/inode.c        | 365 ++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/ordered-data.c |  19 +++
 fs/btrfs/ordered-data.h |   4 +
 5 files changed, 297 insertions(+), 115 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d5d9408..34cb573 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4705,11 +4705,10 @@ int extent_invalidatepage(struct extent_io_tree *tree,
  * to drop the page.
  */
 static int try_release_extent_state(struct extent_map_tree *map,
-				    struct extent_io_tree *tree,
-				    struct page *page, gfp_t mask)
+				struct extent_io_tree *tree,
+				struct page *page, u64 start, u64 end,
+				gfp_t mask)
 {
-	u64 start = page_offset(page);
-	u64 end = start + PAGE_CACHE_SIZE - 1;
 	int ret = 1;
 
 	if (test_range_bit(tree, start, end,
@@ -4743,12 +4742,12 @@ static int try_release_extent_state(struct extent_map_tree *map,
  * map records are removed
  */
 int try_release_extent_mapping(struct extent_map_tree *map,
-			       struct extent_io_tree *tree, struct page *page,
-			       gfp_t mask)
+			struct extent_io_tree *tree, struct page *page,
+			u64 start, u64 end, gfp_t mask)
 {
 	struct extent_map *em;
-	u64 start = page_offset(page);
-	u64 end = start + PAGE_CACHE_SIZE - 1;
+	u64 orig_start = start;
+	u64 orig_end = end;
 
 	if ((mask & __GFP_WAIT) &&
 	    page->mapping->host->i_size > 16 * 1024 * 1024) {
@@ -4782,7 +4781,9 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			free_extent_map(em);
 		}
 	}
-	return try_release_extent_state(map, tree, page, mask);
+	return try_release_extent_state(map, tree, page,
+					orig_start, orig_end,
+					mask);
 }
 
 /*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c665584..93ec2d7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -232,8 +232,9 @@ typedef struct extent_map *(get_extent_t)(struct inode *inode,
 void extent_io_tree_init(struct extent_io_tree *tree,
 			 struct address_space *mapping);
 int try_release_extent_mapping(struct extent_map_tree *map,
-			       struct extent_io_tree *tree, struct page *page,
-			       gfp_t mask);
+			struct extent_io_tree *tree, struct page *page,
+			u64 start, u64 end,
+			gfp_t mask);
 int try_release_extent_buffer(struct page *page);
 int lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 891d533..fea4693 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3026,56 +3026,119 @@ static void finish_ordered_fn(struct btrfs_work *work)
 	btrfs_finish_ordered_io(ordered_extent);
 }
 
-static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
-				struct extent_state *state, int uptodate)
+static void mark_blks_io_complete(struct btrfs_ordered_extent *ordered,
+				u64 blk, u64 nr_blks, int uptodate)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = ordered->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct btrfs_workqueue *wq;
 	btrfs_work_func_t func;
-	u64 ordered_start, ordered_end;
 	int done;
 
-	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
+	while (nr_blks--) {
+		if (test_and_set_bit(blk, ordered->blocks_done)) {
+			blk++;
+			continue;
+		}
 
-	ClearPagePrivate2(page);
-loop:
-	ordered_extent = btrfs_lookup_ordered_range(inode, start,
-						end - start + 1);
-	if (!ordered_extent)
-		goto out;
+		done = btrfs_dec_test_ordered_pending(inode, &ordered,
+						ordered->file_offset
+						+ (blk << inode->i_blkbits),
+						root->sectorsize,
+						uptodate);
+		if (done) {
+			if (btrfs_is_free_space_inode(inode)) {
+				wq = root->fs_info->endio_freespace_worker;
+				func = btrfs_freespace_write_helper;
+			} else {
+				wq = root->fs_info->endio_write_workers;
+				func = btrfs_endio_write_helper;
+			}
 
-	ordered_start = max_t(u64, start, ordered_extent->file_offset);
-	ordered_end = min_t(u64, end,
-			ordered_extent->file_offset + ordered_extent->len - 1);
-
-	done = btrfs_dec_test_ordered_pending(inode, &ordered_extent,
-					ordered_start,
-					ordered_end - ordered_start + 1,
-					uptodate);
-	if (done) {
-		if (btrfs_is_free_space_inode(inode)) {
-			wq = root->fs_info->endio_freespace_worker;
-			func = btrfs_freespace_write_helper;
-		} else {
-			wq = root->fs_info->endio_write_workers;
-			func = btrfs_endio_write_helper;
+			btrfs_init_work(&ordered->work, func,
+					finish_ordered_fn, NULL, NULL);
+			btrfs_queue_work(wq, &ordered->work);
 		}
 
-		btrfs_init_work(&ordered_extent->work, func,
-				finish_ordered_fn, NULL, NULL);
-		btrfs_queue_work(wq, &ordered_extent->work);
+		blk++;
 	}
+}
 
-	btrfs_put_ordered_extent(ordered_extent);
+int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
+				struct extent_state *state, int uptodate)
+{
+	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_ordered_extent *ordered_extent = NULL;
+	u64 blk, nr_blks;
+	int clear;
 
-	start = ordered_end + 1;
+	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
-	if (start < end)
-		goto loop;
+	while (start < end) {
+		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
+		if (!ordered_extent) {
+			start += root->sectorsize;
+			continue;
+		}
+
+		blk = BTRFS_BYTES_TO_BLKS(root->fs_info,
+					start - ordered_extent->file_offset);
+
+		nr_blks = BTRFS_BYTES_TO_BLKS(root->fs_info,
+					min(end, ordered_extent->file_offset
+						+ ordered_extent->len - 1)
+					+ 1 - start);
+
+		BUG_ON(!nr_blks);
+
+		mark_blks_io_complete(ordered_extent, blk, nr_blks, uptodate);
+
+		start = ordered_extent->file_offset + ordered_extent->len;
+
+		btrfs_put_ordered_extent(ordered_extent);
+	}
+
+	start = page_offset(page);
+	end = start + PAGE_CACHE_SIZE - 1;
+	clear = 1;
+
+	while (start < end) {
+		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
+		if (!ordered_extent) {
+			start += root->sectorsize;
+			continue;
+		}
+
+		blk = BTRFS_BYTES_TO_BLKS(root->fs_info,
+					start - ordered_extent->file_offset);
+		nr_blks = BTRFS_BYTES_TO_BLKS(root->fs_info,
+					min(end, ordered_extent->file_offset
+						+ ordered_extent->len - 1)
+					+ 1  - start);
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
 
-out:
 	return 0;
 }
 
@@ -8671,7 +8734,9 @@ btrfs_readpages(struct file *file, struct address_space *mapping,
 	return extent_readpages(tree, mapping, pages, nr_pages,
 				btrfs_get_extent);
 }
-static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
+
+static int __btrfs_releasepage(struct page *page, u64 start, u64 end,
+			gfp_t gfp_flags)
 {
 	struct extent_io_tree *tree;
 	struct extent_map_tree *map;
@@ -8679,33 +8744,151 @@ static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	map = &BTRFS_I(page->mapping->host)->extent_tree;
-	ret = try_release_extent_mapping(map, tree, page, gfp_flags);
-	if (ret == 1)
+
+	ret = try_release_extent_mapping(map, tree, page, start, end,
+					gfp_flags);
+	if ((ret == 1) && ((end - start + 1) == PAGE_CACHE_SIZE)) {
 		clear_page_extent_mapped(page);
+	} else {
+		ret = 0;
+	}
 
 	return ret;
 }
 
 static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 {
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_CACHE_SIZE - 1;
+
 	if (PageWriteback(page) || PageDirty(page))
 		return 0;
-	return __btrfs_releasepage(page, gfp_flags & GFP_NOFS);
+
+	return __btrfs_releasepage(page, start, end, gfp_flags & GFP_NOFS);
+}
+
+static void invalidate_ordered_extent_blocks(struct inode *inode,
+					struct btrfs_ordered_extent *ordered,
+					u64 locked_start, u64 locked_end,
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
+	end = min(locked_end, ordered->file_offset + ordered->len - 1);
+
+	if (!inode_evicting) {
+		clear_extent_bit(tree, cur, end,
+				EXTENT_DIRTY | EXTENT_DELALLOC |
+				EXTENT_DO_ACCOUNTING |
+				EXTENT_DEFRAG, 1, 0, NULL,
+				GFP_NOFS);
+		unlock_extent(tree, locked_start, locked_end);
+	}
+
+
+	ordered_tree = &BTRFS_I(inode)->ordered_tree;
+	spin_lock_irq(&ordered_tree->lock);
+	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
+	new_len = cur - ordered->file_offset;
+	if (new_len < ordered->truncated_len)
+		ordered->truncated_len = new_len;
+
+	blk = BTRFS_BYTES_TO_BLKS(root->fs_info,
+				cur - ordered->file_offset);
+	nr_blks = BTRFS_BYTES_TO_BLKS(root->fs_info, end + 1 - cur);
+
+	while (nr_blks--) {
+		blk_done = !test_and_set_bit(blk, ordered->blocks_done);
+		if (blk_done) {
+			spin_unlock_irq(&ordered_tree->lock);
+			if (btrfs_dec_test_ordered_pending(inode, &ordered,
+								ordered->file_offset + (blk << inode->i_blkbits),
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
+		lock_extent_bits(tree, locked_start, locked_end, 0, NULL);
+}
+
+static int page_blocks_written(struct page *page)
+{
+	struct btrfs_ordered_extent *ordered;
+	struct btrfs_root *root;
+	struct inode *inode;
+	unsigned long outstanding_blk;
+	u64 page_start, page_end;
+	u64 blk, last_blk, nr_blks;
+	u64 cur;
+	u64 len;
+
+	inode = page->mapping->host;
+	root = BTRFS_I(inode)->root;
+
+	page_start = page_offset(page);
+	page_end = page_start + PAGE_CACHE_SIZE - 1;
+
+	cur = page_start;
+	while (cur < page_end) {
+		ordered = btrfs_lookup_ordered_extent(inode, cur);
+		if (!ordered) {
+			cur += root->sectorsize;
+			continue;
+		}
+
+		blk = BTRFS_BYTES_TO_BLKS(root->fs_info,
+					cur - ordered->file_offset);
+		len = min(page_end, ordered->file_offset + ordered->len - 1)
+			- cur + 1;
+		nr_blks = BTRFS_BYTES_TO_BLKS(root->fs_info, len);
+
+		last_blk = blk + nr_blks - 1;
+
+		outstanding_blk = find_next_zero_bit(ordered->blocks_done,
+						BTRFS_BYTES_TO_BLKS(root->fs_info,
+								ordered->len),
+						blk);
+		if (outstanding_blk <= last_blk) {
+			btrfs_put_ordered_extent(ordered);
+			return 0;
+		}
+
+		btrfs_put_ordered_extent(ordered);
+		cur += len;
+	}
+
+	return 1;
 }
 
 static void btrfs_invalidatepage(struct page *page, unsigned int offset,
-				 unsigned int length)
+				unsigned int length)
 {
 	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
-	struct extent_state *cached_state = NULL;
-	u64 page_start = page_offset(page);
-	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
-	u64 start;
-	u64 end;
+	u64 start, end, cur;
+	u64 page_start, page_end;
 	int inode_evicting = inode->i_state & I_FREEING;
 
+	page_start = page_offset(page);
+	page_end = page_start + PAGE_CACHE_SIZE - 1;
+
 	/*
 	 * we have the page locked, so new writeback can't start,
 	 * and the dirty bit won't be cleared while we are here.
@@ -8716,61 +8899,35 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
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
 
+	start = round_up(page_start + offset, root->sectorsize);
+	end = round_down(page_start + offset + length,
+			root->sectorsize) - 1;
+
 	if (!inode_evicting)
-		lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
-again:
-	start = page_start;
-	ordered = btrfs_lookup_ordered_range(inode, start,
-					page_end - start + 1);
-	if (ordered) {
-		end = min(page_end, ordered->file_offset + ordered->len - 1);
-		/*
-		 * IO on this page will never be started, so we need
-		 * to account for any ordered extents now
-		 */
-		if (!inode_evicting)
-			clear_extent_bit(tree, start, end,
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
-			new_len = start - ordered->file_offset;
-			if (new_len < ordered->truncated_len)
-				ordered->truncated_len = new_len;
-			spin_unlock_irq(&tree->lock);
+		invalidate_ordered_extent_blocks(inode, ordered,
+						start, end, cur,
+						inode_evicting);
 
-			if (btrfs_dec_test_ordered_pending(inode, &ordered,
-							   start,
-							   end - start + 1, 1))
-				btrfs_finish_ordered_io(ordered);
-		}
+		cur = min(end + 1, ordered->file_offset + ordered->len);
 		btrfs_put_ordered_extent(ordered);
-		if (!inode_evicting) {
-			cached_state = NULL;
-			lock_extent_bits(tree, start, end, 0,
-					 &cached_state);
-		}
-
-		start = end + 1;
-		if (start < page_end)
-			goto again;
 	}
 
 	/*
@@ -8786,26 +8943,26 @@ again:
 	 */
 	btrfs_qgroup_free_data(inode, page_start, PAGE_CACHE_SIZE);
 
-	clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, page_start, page_end);
+	clear_page_blks_state(page, 1 << BLK_STATE_DIRTY, start, end);
 
-	if (!inode_evicting) {
-		clear_extent_bit(tree, page_start, page_end,
-				 EXTENT_LOCKED | EXTENT_DIRTY |
-				 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
-				 EXTENT_DEFRAG, 1, 1,
-				 &cached_state, GFP_NOFS);
+	if (page_blocks_written(page))
+		ClearPagePrivate2(page);
 
-		__btrfs_releasepage(page, GFP_NOFS);
+	if (!inode_evicting) {
+		clear_extent_bit(tree, start, end,
+				EXTENT_LOCKED | EXTENT_DIRTY |
+				EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
+				EXTENT_DEFRAG, 1, 1, NULL, GFP_NOFS);
+		__btrfs_releasepage(page, start, end, GFP_NOFS);
 	}
 
-	ClearPageChecked(page);
-	if (PagePrivate(page)) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		page_cache_release(page);
+	if (!offset && length == PAGE_CACHE_SIZE) {
+		ClearPageChecked(page);
+		clear_page_extent_mapped(page);
 	}
 }
 
+
 /*
  * btrfs_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8c27292..d111f8b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -189,12 +189,27 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry;
+	u64 nr_longs;
+	u64 nr_blks;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
 	if (!entry)
 		return -ENOMEM;
 
+	nr_blks = BTRFS_BYTES_TO_BLKS(root->fs_info, len);
+	nr_longs = BITS_TO_LONGS(nr_blks);
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
@@ -576,6 +591,10 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
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
index 23c9605..41264bc 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -139,6 +139,10 @@ struct btrfs_ordered_extent {
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
2.1.0

