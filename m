Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41610 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKLISW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 03:18:22 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Nov 2014 18:18:20 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 979C92BB007D
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:17 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAC8I2Mx41418830
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:02 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAC8IGlS008456
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:17 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, steve.capper@linaro.org
Subject: [RFC PATCH V8 02/16] Btrfs: subpagesize-blocksize: Get rid of whole page writes.
Date: Wed, 12 Nov 2014 13:47:34 +0530
Message-Id: <1415780268-2017-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit brings back functions that set/clear EXTENT_WRITEBACK bits. These
are required to reliably clear PG_writeback page flag.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 47 +++++++++++++++++++++++++++--------------------
 fs/btrfs/inode.c     | 40 +++++++++++++++++++++++++++++++---------
 2 files changed, 58 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5d9cc68..7229c4d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1300,6 +1300,20 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
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
@@ -1406,6 +1420,7 @@ static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 		page_cache_release(page);
 		index++;
 	}
+	set_extent_writeback(tree, start, end, NULL, GFP_NOFS);
 	return 0;
 }
 
@@ -2408,31 +2423,23 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
+		struct inode *inode = page->mapping->host;
+		struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+		u64 page_start, page_end;
 
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
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
 
 		if (end_extent_writepage(page, err, start, end))
 			continue;
 
-		end_page_writeback(page);
+		clear_extent_writeback(tree, start, end, NULL, GFP_ATOMIC);
+
+		page_start = page_offset(page);
+		page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
+		if (!test_range_bit(tree, page_start, page_end,
+					EXTENT_WRITEBACK, 0, NULL))
+			end_page_writeback(page);
 	}
 
 	bio_put(bio);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7309832..2ffb4df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2823,22 +2823,44 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct btrfs_workqueue *workers;
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
 
-	btrfs_init_work(&ordered_extent->work, finish_ordered_fn, NULL, NULL);
+	ordered_start = max_t(u64, start, ordered_extent->file_offset);
+	ordered_end = min_t(u64, end,
+			ordered_extent->file_offset + ordered_extent->len - 1);
 
-	if (btrfs_is_free_space_inode(inode))
-		workers = root->fs_info->endio_freespace_worker;
-	else
-		workers = root->fs_info->endio_write_workers;
-	btrfs_queue_work(workers, &ordered_extent->work);
+	done = btrfs_dec_test_ordered_pending(inode, &ordered_extent,
+					ordered_start,
+					ordered_end - ordered_start + 1,
+					uptodate);
+	if (done) {
+		btrfs_init_work(&ordered_extent->work, finish_ordered_fn, NULL, NULL);
+
+		if (btrfs_is_free_space_inode(inode))
+			workers = root->fs_info->endio_freespace_worker;
+		else
+			workers = root->fs_info->endio_write_workers;
 
+		btrfs_queue_work(workers, &ordered_extent->work);
+	}
+
+	btrfs_put_ordered_extent(ordered_extent);
+
+	start = ordered_end + 1;
+
+	if (start < end)
+		goto loop;
+out:
 	return 0;
 }
 
-- 
2.1.0

