Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51371 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbaLJNOl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:14:41 -0500
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 10 Dec 2014 18:44:39 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id D4F7BE0053
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:45:12 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sBADEVno65142784
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:44:31 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sBADEZ69031782
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:44:36 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V10 01/19] Btrfs: subpagesize-blocksize: Get rid of whole page reads.
Date: Wed, 10 Dec 2014 18:44:03 +0530
Message-Id: <1418217261-17273-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1418217261-17273-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1418217261-17273-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on original patch from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

For the subpagesize-blocksize scenario, a page can contain multiple
blocks. This patch handles this case.

This patch adds the new EXTENT_READ_IO extent state bit to reliably unlock
pages in readpage's end bio function.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 182 ++++++++++++++++++++++++---------------------------
 fs/btrfs/extent_io.h |   5 +-
 2 files changed, 89 insertions(+), 98 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a389820..c98dfd8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1951,14 +1951,23 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
+static void check_page_uptodate(struct extent_io_tree *tree, struct page *page,
+				struct extent_state *cached)
 {
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
-	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
+	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, cached))
 		SetPageUptodate(page);
 }
 
+static int page_read_complete(struct extent_io_tree *tree, struct page *page)
+{
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_CACHE_SIZE - 1;
+
+	return !test_range_bit(tree, start, end, EXTENT_READ_IO, 0, NULL);
+}
+
 /*
  * When IO fails, either with EIO or csum verification fails, we
  * try other mirrors that might have a good copy of the data.  This
@@ -2275,7 +2284,9 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	 *	a) deliver good data to the caller
 	 *	b) correct the bad sectors on disk
 	 */
-	if (failed_bio->bi_vcnt > 1) {
+	if ((failed_bio->bi_vcnt > 1)
+		|| (failed_bio->bi_io_vec->bv_len
+			> BTRFS_I(inode)->root->sectorsize)) {
 		/*
 		 * to fulfill b), we need to know the exact failing sectors, as
 		 * we don't want to rewrite any more than the failed ones. thus,
@@ -2422,18 +2433,6 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static void
-endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
-			      int uptodate)
-{
-	struct extent_state *cached = NULL;
-	u64 end = start + len - 1;
-
-	if (uptodate && tree->track_uptodate)
-		set_extent_uptodate(tree, start, end, &cached, GFP_ATOMIC);
-	unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
-}
-
 /*
  * after a readpage IO is done, we need to:
  * clear the uptodate bits on error
@@ -2450,14 +2449,15 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	struct bio_vec *bvec;
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct extent_state *cached = NULL;
 	struct extent_io_tree *tree;
+	unsigned long flags;
 	u64 offset = 0;
 	u64 start;
 	u64 end;
-	u64 len;
-	u64 extent_start = 0;
-	u64 extent_len = 0;
+	int nr_sectors;
 	int mirror;
+	int unlock;
 	int ret;
 	int i;
 
@@ -2467,54 +2467,31 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
+		struct btrfs_root *root = BTRFS_I(inode)->root;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
 			 "mirror=%lu\n", (u64)bio->bi_iter.bi_sector, err,
 			 io_bio->mirror_num);
 		tree = &BTRFS_I(inode)->io_tree;
 
-		/* We always issue full-page reads, but if some block
-		 * in a page fails to read, blk_update_request() will
-		 * advance bv_offset and adjust bv_len to compensate.
-		 * Print a warning for nonzero offsets, and an error
-		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
-			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
-				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "partial page read in btrfs with offset %u and length %u",
-					bvec->bv_offset, bvec->bv_len);
-			else
-				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page read in btrfs with offset %u and "
-				   "length %u",
-					bvec->bv_offset, bvec->bv_len);
-		}
-
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
-		len = bvec->bv_len;
-
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
+		nr_sectors = bvec->bv_len >> inode->i_sb->s_blocksize_bits;
 		mirror = io_bio->mirror_num;
-		if (likely(uptodate && tree->ops &&
-			   tree->ops->readpage_end_io_hook)) {
+
+next_block:
+		if (likely(uptodate)) {
 			ret = tree->ops->readpage_end_io_hook(io_bio, offset,
-							      page, start, end,
-							      mirror);
+							page, start,
+							start + root->sectorsize - 1,
+							mirror);
 			if (ret)
 				uptodate = 0;
 			else
 				clean_io_failure(start, page);
 		}
 
-		if (likely(uptodate))
-			goto readpage_ok;
-
-		if (tree->ops && tree->ops->readpage_io_failed_hook) {
-			ret = tree->ops->readpage_io_failed_hook(page, mirror);
-			if (!ret && !err &&
-			    test_bit(BIO_UPTODATE, &bio->bi_flags))
-				uptodate = 1;
-		} else {
+		if (!uptodate) {
 			/*
 			 * The generic bio_readpage_error handles errors the
 			 * following way: If possible, new read requests are
@@ -2525,60 +2502,64 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 * can't handle the error it will return -EIO and we
 			 * remain responsible for that page.
 			 */
-			ret = bio_readpage_error(bio, offset, page, start, end,
-						 mirror);
+			ret = bio_readpage_error(bio, offset, page,
+						start, start + root->sectorsize - 1,
+						mirror);
 			if (ret == 0) {
-				uptodate =
-					test_bit(BIO_UPTODATE, &bio->bi_flags);
+				uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
-				continue;
+				offset += root->sectorsize;
+				if (--nr_sectors) {
+					start += root->sectorsize;
+					goto next_block;
+				} else {
+					continue;
+				}
 			}
 		}
-readpage_ok:
-		if (likely(uptodate)) {
-			loff_t i_size = i_size_read(inode);
-			pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
-			unsigned offset;
-
-			/* Zero out the end if this page straddles i_size */
-			offset = i_size & (PAGE_CACHE_SIZE-1);
-			if (page->index == end_index && offset)
-				zero_user_segment(page, offset, PAGE_CACHE_SIZE);
-			SetPageUptodate(page);
+
+		if (uptodate) {
+			set_extent_uptodate(tree, start,
+					start + root->sectorsize - 1,
+					&cached, GFP_ATOMIC);
+			check_page_uptodate(tree, page, cached);
 		} else {
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
-		unlock_page(page);
-		offset += len;
-
-		if (unlikely(!uptodate)) {
-			if (extent_len) {
-				endio_readpage_release_extent(tree,
-							      extent_start,
-							      extent_len, 1);
-				extent_start = 0;
-				extent_len = 0;
-			}
-			endio_readpage_release_extent(tree, start,
-						      end - start + 1, 0);
-		} else if (!extent_len) {
-			extent_start = start;
-			extent_len = end + 1 - start;
-		} else if (extent_start + extent_len == start) {
-			extent_len += end + 1 - start;
-		} else {
-			endio_readpage_release_extent(tree, extent_start,
-						      extent_len, uptodate);
-			extent_start = start;
-			extent_len = end + 1 - start;
+
+		offset += root->sectorsize;
+
+		if (--nr_sectors) {
+			clear_extent_bit(tree, start, start + root->sectorsize - 1,
+				EXTENT_READ_IO, 0, 0, &cached, GFP_ATOMIC);
+			clear_extent_bit(tree, start, start + root->sectorsize - 1,
+					EXTENT_LOCKED, 1, 0, &cached, GFP_ATOMIC);
+			start += root->sectorsize;
+			goto next_block;
 		}
+
+		WARN_ON(!PagePrivate(page));
+
+		local_irq_save(flags);
+		bit_spin_lock(EXTENT_PAGE_UPTODATE_LOCK, &page->private);
+
+		clear_extent_bit(tree, start, start + root->sectorsize - 1,
+				EXTENT_READ_IO, 0, 0, &cached, GFP_ATOMIC);
+
+		unlock = page_read_complete(tree, page);
+
+		bit_spin_unlock(EXTENT_PAGE_UPTODATE_LOCK, &page->private);
+		local_irq_restore(flags);
+
+		clear_extent_bit(tree, start, start + root->sectorsize - 1,
+				EXTENT_LOCKED, 1, 0, &cached, GFP_ATOMIC);
+
+		if (unlock)
+			unlock_page(page);
 	}
 
-	if (extent_len)
-		endio_readpage_release_extent(tree, extent_start, extent_len,
-					      uptodate);
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, err);
 	bio_put(bio);
@@ -2799,6 +2780,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			 unsigned long *bio_flags, int rw)
 {
 	struct inode *inode = page->mapping->host;
+	struct extent_state *cached = NULL;
 	u64 start = page_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
@@ -2918,7 +2900,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 		/* the get_extent function already copied into the page */
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
-			check_page_uptodate(tree, page);
+			check_page_uptodate(tree, page, NULL);
 			if (!parent_locked)
 				unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
@@ -2938,6 +2920,10 @@ static int __do_readpage(struct extent_io_tree *tree,
 		}
 
 		pnr -= page->index;
+
+		set_extent_bit(tree, cur, cur + iosize - 1, EXTENT_READ_IO,
+			NULL, &cached, GFP_NOFS);
+
 		ret = submit_extent_page(rw, tree, page,
 					 sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
@@ -2949,8 +2935,12 @@ static int __do_readpage(struct extent_io_tree *tree,
 			*bio_flags = this_bio_flag;
 		} else {
 			SetPageError(page);
+			clear_extent_bit(tree, cur, cur + iosize - 1,
+					EXTENT_READ_IO, 0, 0, &cached,
+					GFP_NOFS);
 			if (!parent_locked)
-				unlock_extent(tree, cur, cur + iosize - 1);
+				unlock_extent_cached(tree, cur, cur + iosize - 1,
+						&cached, GFP_NOFS);
 		}
 		cur = cur + iosize;
 		pg_offset += iosize;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ccc264e..4d019c0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -20,6 +20,7 @@
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
 #define EXTENT_NORESERVE (1 << 15)
+#define EXTENT_READ_IO (1 << 16)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -56,8 +57,8 @@
  * page->private values.  Every page that is controlled by the extent
  * map has page->private set to one.
  */
-#define EXTENT_PAGE_PRIVATE 1
-#define EXTENT_PAGE_PRIVATE_FIRST_PAGE 3
+#define EXTENT_PAGE_PRIVATE		(1 << 0)
+#define EXTENT_PAGE_UPTODATE_LOCK	(1 << 1)
 
 struct extent_state;
 struct btrfs_root;
-- 
2.1.0

