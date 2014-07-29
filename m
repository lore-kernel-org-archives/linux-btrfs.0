Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43155 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaG2LOW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:14:22 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 16:44:19 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 8BACC1258054
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:14 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6TBEbrO61210752
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:38 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6TBEGuw012901
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:17 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V5 02/12] Btrfs: subpagesize-blocksize: Get rid of whole page writes.
Date: Tue, 29 Jul 2014 16:43:37 +0530
Message-Id: <1406632427-2209-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit brings back functions that set/clear EXTENT_WRITEBACK bits. These
are required to reliably clear PG_writeback page flag.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 134 +++++++++++++++++++++++++++++++++------------------
 fs/btrfs/extent_io.h |   2 +-
 fs/btrfs/inode.c     |  47 +++++++++++++-----
 3 files changed, 124 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fa28545..ba04bd2 100644
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
 
-	if (!uptodate) {
-		ClearPageUptodate(page);
-		SetPageError(page);
+static void clear_extent_and_page_writeback(struct address_space *mapping,
+					struct extent_io_tree *tree,
+					struct btrfs_io_bio *io_bio)
+{
+	struct page *page;
+	pgoff_t index;
+	u64 offset, len;
+
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
@@ -3208,6 +3248,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			goto done_unlocked;
 		}
 	}
+
 	if (tree->ops && tree->ops->writepage_start_hook) {
 		ret = tree->ops->writepage_start_hook(page, start,
 						      page_end);
@@ -3337,6 +3378,7 @@ done:
 		set_page_writeback(page);
 		end_page_writeback(page);
 	}
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
index 197edee..42ab0e4 100644
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
@@ -2759,30 +2759,53 @@ static void finish_ordered_fn(struct btrfs_work *work)
 	btrfs_finish_ordered_io(ordered_extent);
 }
 
-static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
+int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
 	struct inode *inode = page->mapping->host;
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

