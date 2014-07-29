Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55172 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaG2LOX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:14:23 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 16:44:20 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 23EF81258048
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:14 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6TBEbhH16580672
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:37 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6TBEFDg012877
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:16 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V5 01/12] Btrfs: subpagesize-blocksize: Get rid of whole page reads.
Date: Tue, 29 Jul 2014 16:43:36 +0530
Message-Id: <1406632427-2209-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on original patch from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

bio_vec->{bv_offset, bv_len} cannot be relied upon by the end bio functions
to track the file offset range operated on by the bio. Hence this patch adds
two new members to 'struct btrfs_io_bio' to track the file offset range.

This patch also brings back check_page_locked() to reliably unlock pages in
readpage's end bio function.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 200 ++++++++++++++++++++++-----------------------------
 fs/btrfs/volumes.h   |   3 +
 2 files changed, 90 insertions(+), 113 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fbe501d..fa28545 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1943,15 +1943,29 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
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
 
 /*
+ * helper function to unlock a page if all the extents in the tree
+ * for that page are unlocked
+ */
+static void check_page_locked(struct extent_io_tree *tree, struct page *page)
+{
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_CACHE_SIZE - 1;
+
+	if (!test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL)) {
+		unlock_page(page);
+	}
+}
+
  * When IO fails, either with EIO or csum verification fails, we
  * try other mirrors that might have a good copy of the data.  This
  * io_failure_record is used to record state as we go through all the
@@ -2173,6 +2187,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	struct bio *bio;
 	struct btrfs_io_bio *btrfs_failed_bio;
 	struct btrfs_io_bio *btrfs_bio;
+	int nr_sectors;
 	int num_copies;
 	int ret;
 	int read_mode;
@@ -2267,7 +2282,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	 *	a) deliver good data to the caller
 	 *	b) correct the bad sectors on disk
 	 */
-	if (failed_bio->bi_vcnt > 1) {
+	nr_sectors = btrfs_io_bio(failed_bio)->len >> inode->i_sb->s_blocksize_bits;
+	if (nr_sectors > 1) {
 		/*
 		 * to fulfill b), we need to know the exact failing sectors, as
 		 * we don't want to rewrite any more than the failed ones. thus,
@@ -2314,6 +2330,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	bio->bi_sector = failrec->logical >> 9;
 	bio->bi_bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 	bio->bi_size = 0;
+	btrfs_io_bio(bio)->start_offset = start;
+	btrfs_io_bio(bio)->len = end - start + 1;
 
 	btrfs_failed_bio = btrfs_io_bio(failed_bio);
 	if (btrfs_failed_bio->csum) {
@@ -2414,18 +2432,6 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
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
@@ -2440,76 +2446,50 @@ endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
 static void end_bio_extent_readpage(struct bio *bio, int err)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct bio_vec *bvec = bio->bi_io_vec;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct address_space *mapping;
+	struct extent_state *cached = NULL;
 	struct extent_io_tree *tree;
-	u64 offset = 0;
+	struct btrfs_root *root;
+	struct inode *inode;
+	struct page *page;
 	u64 start;
-	u64 end;
+	u64 offset = 0;
 	u64 len;
-	u64 extent_start = 0;
-	u64 extent_len = 0;
+	int nr_sectors;
 	int mirror;
 	int ret;
 
-	if (err)
-		uptodate = 0;
+	mapping = bio->bi_io_vec->bv_page->mapping;
+	inode = mapping->host;
+	root = BTRFS_I(inode)->root;
+	tree = &BTRFS_I(inode)->io_tree;
 
-	do {
-		struct page *page = bvec->bv_page;
-		struct inode *inode = page->mapping->host;
-
-		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
-			 "mirror=%lu\n", (u64)bio->bi_sector, err,
-			 io_bio->mirror_num);
-		tree = &BTRFS_I(inode)->io_tree;
-
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
+	start = btrfs_io_bio(bio)->start_offset;
+	len = btrfs_io_bio(bio)->len;
+	mirror = io_bio->mirror_num;
 
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
-		len = bvec->bv_len;
+	nr_sectors = len >> inode->i_sb->s_blocksize_bits;
+	BUG_ON(!nr_sectors);
 
-		if (++bvec <= bvec_end)
-			prefetchw(&bvec->bv_page->flags);
+	do {
+		BUG_ON(bvec > bvec_end);
+		page = bvec->bv_page;
 
-		mirror = io_bio->mirror_num;
-		if (likely(uptodate && tree->ops &&
-			   tree->ops->readpage_end_io_hook)) {
+		if (uptodate) {
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
@@ -2520,63 +2500,38 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
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
+				goto next_block;
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
-		}
-	} while (bvec <= bvec_end);
 
-	if (extent_len)
-		endio_readpage_release_extent(tree, extent_start, extent_len,
-					      uptodate);
+		unlock_extent(tree, start, start + root->sectorsize - 1);
+		check_page_locked(tree, page);
+next_block:
+		offset += root->sectorsize;
+		start += root->sectorsize;
+		if ((page_offset(page) + PAGE_CACHE_SIZE) == start)
+			++bvec;
+	} while (--nr_sectors);
+
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, err);
-	bio_put(bio);
 }
 
 /*
@@ -2700,6 +2655,18 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 		else
 			contig = bio_end_sector(bio) == sector;
 
+		if (contig) {
+			/*
+			 * Check whether we are contig if file offsets.
+			 * We should mostly be for readpage/readpages
+			 * We need to do this because we use btrfs_io_bio
+			 * start_offset and len to unlock in endio routines.
+			 */
+			if ((page_offset(page) + offset) !=
+					(btrfs_io_bio(bio)->start_offset +
+					 btrfs_io_bio(bio)->len))
+				contig = 0;
+		}
 		if (prev_bio_flags != bio_flags || !contig ||
 		    merge_bio(rw, tree, page, offset, page_size, bio, bio_flags) ||
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
@@ -2709,6 +2676,11 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 				return ret;
 			bio = NULL;
 		} else {
+			/*
+			 * update btrfs_io_bio len. So that we can unlock
+			 * correctly in end_io callback.
+			 */
+			btrfs_io_bio(bio)->len += page_size;
 			return 0;
 		}
 	}
@@ -2724,6 +2696,8 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
+	btrfs_io_bio(bio)->start_offset = page_offset(page) + offset;
+	btrfs_io_bio(bio)->len = page_size;
 
 	if (bio_ret)
 		*bio_ret = bio;
@@ -2914,7 +2888,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 		/* the get_extent function already copied into the page */
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
-			check_page_uptodate(tree, page);
+			check_page_uptodate(tree, page, NULL);
 			if (!parent_locked)
 				unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 80754f9..fb2dbdc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -173,6 +173,9 @@ struct btrfs_io_bio {
 	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
 	u8 *csum_allocated;
 	btrfs_io_bio_end_io_t *end_io;
+	/* Track file offset range operated on by the bio.*/
+	u64 start_offset;
+	u64 len;
 	struct bio bio;
 };
 
-- 
1.8.3.1

