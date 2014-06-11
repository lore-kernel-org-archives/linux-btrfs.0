Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39518 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaFKLdX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 07:33:23 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 11 Jun 2014 17:03:21 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 1B742125804D
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 17:02:19 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5BBX8BY49741936
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 17:03:09 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5BBWt5V015453
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 17:02:55 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH V2 2/8] Btrfs: subpagesize-blocksize: Get rid of whole page writes.
Date: Wed, 11 Jun 2014 17:02:15 +0530
Message-Id: <1402486341-592-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1402486341-592-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1402486341-592-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit brings back functions that set/clear EXTENT_WRITEBACK bits. These
are required to reliably clear PG_writeback page flag.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 147 +++++++++++++++++++++++++++++++++++----------------
 fs/btrfs/extent_io.h |   2 +-
 fs/btrfs/inode.c     |  45 ++++++++++++----
 3 files changed, 136 insertions(+), 58 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fa28545..20d8bdc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1293,6 +1293,20 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 				cached_state, mask);
 }
 
+static int set_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end,
+				struct extent_state **cached_state, gfp_t mask)
+{
+	return set_extent_bit(tree, start, end, EXTENT_WRITEBACK, NULL,
+			cached_state, mask);
+}
+
+static int clear_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end,
+				struct extent_state **cached_state, gfp_t mask)
+{
+	return clear_extent_bit(tree, start, end, EXTENT_WRITEBACK, 1, 0,
+				cached_state, mask);
+}
+
 /*
  * either insert or lock state struct between start and end use mask to tell
  * us if waiting is desired.
@@ -1399,6 +1413,7 @@ static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 		page_cache_release(page);
 		index++;
 	}
+	set_extent_writeback(tree, start, end, NULL, GFP_NOFS);
 	return 0;
 }
 
@@ -1966,6 +1981,16 @@ static void check_page_locked(struct extent_io_tree *tree, struct page *page)
 	}
 }
 
+static void check_page_writeback(struct extent_io_tree *tree, struct page *page)
+{
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_CACHE_SIZE - 1;
+
+	if (!test_range_bit(tree, start, end, EXTENT_WRITEBACK, 0, NULL))
+		end_page_writeback(page);
+}
+
+/*
  * When IO fails, either with EIO or csum verification fails, we
  * try other mirrors that might have a good copy of the data.  This
  * io_failure_record is used to record state as we go through all the
@@ -2359,27 +2384,69 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 }
 
 /* lots and lots of room for performance fixes in the end_bio funcs */
-
-int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
+void end_extents_write(struct inode *inode, int err, u64 start, u64 end)
 {
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	int uptodate = (err == 0);
-	struct extent_io_tree *tree;
+	pgoff_t index, end_index;
+	u64 page_start, page_end;
+	struct page *page;
 	int ret;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	index = start >> PAGE_CACHE_SHIFT;
+	end_index = end >> PAGE_CACHE_SHIFT;
 
-	if (tree->ops && tree->ops->writepage_end_io_hook) {
-		ret = tree->ops->writepage_end_io_hook(page, start,
-					       end, NULL, uptodate);
-		if (ret)
-			uptodate = 0;
+	page_start = start;
+
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		BUG_ON(!page);
+
+		page_end = min_t(u64, end, page_offset(page) + PAGE_CACHE_SIZE - 1);
+
+		if (tree->ops && tree->ops->writepage_end_io_hook) {
+			ret = tree->ops->writepage_end_io_hook(page,
+							page_start, page_end,
+							NULL, uptodate);
+			if (ret)
+				uptodate = 0;
+		}
+
+		page_start = page_end + 1;
+
+		++index;
+
+		if (!uptodate) {
+			ClearPageUptodate(page);
+			SetPageError(page);
+		}
+
+		page_cache_release(page);
 	}
+}
+
+static void clear_extent_and_page_writeback(struct address_space *mapping,
+					struct extent_io_tree *tree,
+					struct btrfs_io_bio *io_bio)
+{
+	struct page *page;
+	pgoff_t index;
+	u64 offset, len;
 
-	if (!uptodate) {
-		ClearPageUptodate(page);
-		SetPageError(page);
+	offset	= io_bio->start_offset;
+	len	= io_bio->len;
+
+	clear_extent_writeback(tree, offset, offset + len - 1, NULL,
+			GFP_ATOMIC);
+
+	index = offset >> PAGE_CACHE_SHIFT;
+	while (offset < io_bio->start_offset + len) {
+		page = find_get_page(mapping, index);
+		check_page_writeback(tree, page);
+		page_cache_release(page);
+		index++;
+		offset += page_offset(page) + PAGE_CACHE_SIZE - offset;
 	}
-	return 0;
 }
 
 /*
@@ -2393,41 +2460,14 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  */
 static void end_bio_extent_writepage(struct bio *bio, int err)
 {
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	u64 start;
-	u64 end;
-
-	do {
-		struct page *page = bvec->bv_page;
-
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
-
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
-
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
+	struct address_space *mapping =  bio->bi_io_vec->bv_page->mapping;
+	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 
-		if (end_extent_writepage(page, err, start, end))
-			continue;
+	end_extents_write(mapping->host, err, io_bio->start_offset,
+			io_bio->start_offset + io_bio->len - 1);
 
-		end_page_writeback(page);
-	} while (bvec >= bio->bi_io_vec);
+	clear_extent_and_page_writeback(mapping, tree, io_bio);
 
 	bio_put(bio);
 }
@@ -3091,6 +3131,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	u64 last_byte = i_size_read(inode);
 	u64 block_start;
 	u64 iosize;
+	u64 unlock_start = start;
 	sector_t sector;
 	struct extent_state *cached_state = NULL;
 	struct extent_map *em;
@@ -3173,6 +3214,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			/* File system has been set read-only */
 			if (ret) {
 				SetPageError(page);
+				unlock_start = page_end + 1;
 				goto done;
 			}
 			/*
@@ -3208,10 +3250,14 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			goto done_unlocked;
 		}
 	}
+
+	lock_extent(tree, start, page_end);
+
 	if (tree->ops && tree->ops->writepage_start_hook) {
 		ret = tree->ops->writepage_start_hook(page, start,
 						      page_end);
 		if (ret) {
+			unlock_extent(tree, start, page_end);
 			/* Fixup worker will requeue */
 			if (ret == -EBUSY)
 				wbc->pages_skipped++;
@@ -3232,9 +3278,11 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 	end = page_end;
 	if (last_byte <= start) {
+		unlock_extent(tree, start, page_end);
 		if (tree->ops && tree->ops->writepage_end_io_hook)
 			tree->ops->writepage_end_io_hook(page, start,
 							 page_end, NULL, 1);
+		unlock_start = page_end + 1;
 		goto done;
 	}
 
@@ -3242,9 +3290,11 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 	while (cur <= end) {
 		if (cur >= last_byte) {
+			unlock_extent(tree, unlock_start, page_end);
 			if (tree->ops && tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, cur,
 							 page_end, NULL, 1);
+			unlock_start = page_end + 1;
 			break;
 		}
 		em = epd->get_extent(inode, page, pg_offset, cur,
@@ -3272,6 +3322,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		 */
 		if (compressed || block_start == EXTENT_MAP_HOLE ||
 		    block_start == EXTENT_MAP_INLINE) {
+			unlock_extent(tree, unlock_start, cur + iosize - 1);
 			/*
 			 * end_io notification does not happen here for
 			 * compressed extents
@@ -3291,6 +3342,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 			cur += iosize;
 			pg_offset += iosize;
+			unlock_start = cur;
 			continue;
 		}
 		/* leave this out until we have a page_mkwrite call */
@@ -3337,6 +3389,9 @@ done:
 		set_page_writeback(page);
 		end_page_writeback(page);
 	}
+	if (unlock_start <= page_end)
+		unlock_extent(tree, unlock_start, page_end);
+
 	unlock_page(page);
 
 done_unlocked:
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 58b27e5..42d0b74 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -341,7 +341,7 @@ struct btrfs_fs_info;
 int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 			u64 length, u64 logical, struct page *page,
 			int mirror_num);
-int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
+void end_extents_write(struct inode *inode, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8dba152..16da8e3a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1797,7 +1797,7 @@ again:
 	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
-		end_extent_writepage(page, ret, page_start, page_end);
+		end_extents_write(page->mapping->host, ret, page_start, page_end);
 		ClearPageChecked(page);
 		goto out;
 	 }
@@ -2766,23 +2766,46 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct btrfs_workers *workers;
+	u64 ordered_start, ordered_end;
+	int done;
 
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
 	ClearPagePrivate2(page);
-	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
-					    end - start + 1, uptodate))
-		return 0;
+loop:
+	ordered_extent = btrfs_lookup_ordered_range(inode, start,
+						start + end - 1);
+	if (!ordered_extent)
+		goto out;
 
-	ordered_extent->work.func = finish_ordered_fn;
-	ordered_extent->work.flags = 0;
+	ordered_start = max_t(u64, start, ordered_extent->file_offset);
+	ordered_end = min_t(u64, end,
+			ordered_extent->file_offset + ordered_extent->len - 1);
 
-	if (btrfs_is_free_space_inode(inode))
-		workers = &root->fs_info->endio_freespace_worker;
-	else
-		workers = &root->fs_info->endio_write_workers;
-	btrfs_queue_worker(workers, &ordered_extent->work);
+	done = btrfs_dec_test_ordered_pending(inode, &ordered_extent,
+					ordered_start,
+					ordered_end - ordered_start + 1,
+					uptodate);
+	if (done) {
+		ordered_extent->work.func = finish_ordered_fn;
+		ordered_extent->work.flags = 0;
 
+		if (btrfs_is_free_space_inode(inode))
+			workers = &root->fs_info->endio_freespace_worker;
+		else
+			workers = &root->fs_info->endio_write_workers;
+
+		btrfs_queue_worker(workers, &ordered_extent->work);
+	}
+
+	btrfs_put_ordered_extent(ordered_extent);
+
+	start = ordered_end + 1;
+
+	if (start < end)
+		goto loop;
+
+out:
 	return 0;
 }
 
-- 
1.8.3.1

