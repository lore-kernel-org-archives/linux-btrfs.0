Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35741 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaEUJld (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 05:41:33 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 21 May 2014 15:11:31 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id C0E6E125805C
	for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 15:10:34 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4L9fqUY39452744
	for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 15:11:52 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4L9fPR0018168
	for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 15:11:26 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH 2/8] Btrfs: subpagesize-blocksize: Get rid of whole page writes.
Date: Wed, 21 May 2014 15:11:12 +0530
Message-Id: <1400665278-4091-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1400665278-4091-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1400665278-4091-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit brings back functions that set/clear EXTENT_WRITEBACK bits. These
are required to reliably clear PG_writeback page flag.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 73 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fd6f011..17ff01b 100644
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
@@ -2378,6 +2403,32 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	return 0;
 }
 
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
+	}
+
+	unlock_extent(tree, io_bio->start_offset, io_bio->start_offset + len - 1);
+}
+
 /*
  * after a writepage IO is done, we need to:
  * clear the uptodate bits on error
@@ -2389,6 +2440,9 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  */
 static void end_bio_extent_writepage(struct bio *bio, int err)
 {
+	struct address_space *mapping =  bio->bi_io_vec->bv_page->mapping;
+	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	u64 start;
 	u64 end;
@@ -2413,8 +2467,8 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 					bvec->bv_offset, bvec->bv_len);
 		}
 
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
 
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
@@ -2422,9 +2476,10 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		if (end_extent_writepage(page, err, start, end))
 			continue;
 
-		end_page_writeback(page);
 	} while (bvec >= bio->bi_io_vec);
 
+	clear_extent_and_page_writeback(mapping, tree, io_bio);
+
 	bio_put(bio);
 }
 
@@ -3151,6 +3206,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	u64 last_byte = i_size_read(inode);
 	u64 block_start;
 	u64 iosize;
+	u64 unlock_start = start;
 	sector_t sector;
 	struct extent_state *cached_state = NULL;
 	struct extent_map *em;
@@ -3233,6 +3289,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			/* File system has been set read-only */
 			if (ret) {
 				SetPageError(page);
+				unlock_start = page_end + 1;
 				goto done;
 			}
 			/*
@@ -3268,10 +3325,14 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
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
@@ -3292,9 +3353,11 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 	end = page_end;
 	if (last_byte <= start) {
+		unlock_extent(tree, start, page_end);
 		if (tree->ops && tree->ops->writepage_end_io_hook)
 			tree->ops->writepage_end_io_hook(page, start,
 							 page_end, NULL, 1);
+		unlock_start = page_end + 1;
 		goto done;
 	}
 
@@ -3302,9 +3365,11 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
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
@@ -3332,6 +3397,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		 */
 		if (compressed || block_start == EXTENT_MAP_HOLE ||
 		    block_start == EXTENT_MAP_INLINE) {
+			unlock_extent(tree, unlock_start, cur + iosize - 1);
 			/*
 			 * end_io notification does not happen here for
 			 * compressed extents
@@ -3351,6 +3417,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 			cur += iosize;
 			pg_offset += iosize;
+			unlock_start = cur;
 			continue;
 		}
 		/* leave this out until we have a page_mkwrite call */
@@ -3397,6 +3464,9 @@ done:
 		set_page_writeback(page);
 		end_page_writeback(page);
 	}
+	if (unlock_start <= page_end)
+		unlock_extent(tree, unlock_start, page_end);
+
 	unlock_page(page);
 
 done_unlocked:
-- 
1.8.3.1

