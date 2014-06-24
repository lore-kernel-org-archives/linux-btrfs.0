Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35952 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaFXO3o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 10:29:44 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 24 Jun 2014 19:59:42 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 802823940060
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:40 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5OETsBN62914682
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:54 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5OETa75023193
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:38 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH V3 1/9] Btrfs: subpagesize-blocksize: Get rid of whole page reads.
Date: Tue, 24 Jun 2014 19:59:00 +0530
Message-Id: <1403620148-28774-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
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
 fs/btrfs/extent_io.c | 120 +++++++++++++++++++++++++++++++++------------------
 fs/btrfs/volumes.h   |   3 ++
 2 files changed, 80 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fbe501d..fd6f011 100644
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
@@ -2414,16 +2428,33 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static void
-endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
-			      int uptodate)
+static void unlock_extent_and_page(struct address_space *mapping,
+				   struct extent_io_tree *tree,
+				   struct btrfs_io_bio *io_bio)
 {
-	struct extent_state *cached = NULL;
-	u64 end = start + len - 1;
+	pgoff_t index;
+	u64 offset, len;
+	/*
+	 * This btrfs_io_bio may span multiple pages.
+	 * We need to unlock the pages convered by them
+	 * if we got endio callback for all the blocks in the page.
+	 * btrfs_io_bio also contain "contigous blocks of the file"
+	 * look at submit_extent_page for more details.
+	 */
 
-	if (uptodate && tree->track_uptodate)
-		set_extent_uptodate(tree, start, end, &cached, GFP_ATOMIC);
-	unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+	offset = io_bio->start_offset;
+	len    = io_bio->len;
+	unlock_extent(tree, offset, offset + len - 1);
+
+	index = offset >> PAGE_CACHE_SHIFT;
+	while (offset < io_bio->start_offset + len) {
+		struct page *page;
+		page = find_get_page(mapping, index);
+		check_page_locked(tree, page);
+		page_cache_release(page);
+		index++;
+		offset += PAGE_CACHE_SIZE;
+	}
 }
 
 /*
@@ -2443,13 +2474,13 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct address_space *mapping = bio->bi_io_vec->bv_page->mapping;
 	struct extent_io_tree *tree;
+	struct extent_state *cached = NULL;
 	u64 offset = 0;
 	u64 start;
 	u64 end;
 	u64 len;
-	u64 extent_start = 0;
-	u64 extent_len = 0;
 	int mirror;
 	int ret;
 
@@ -2482,8 +2513,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 					bvec->bv_offset, bvec->bv_len);
 		}
 
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
 		len = bvec->bv_len;
 
 		if (++bvec <= bvec_end)
@@ -2540,40 +2571,24 @@ readpage_ok:
 			offset = i_size & (PAGE_CACHE_SIZE-1);
 			if (page->index == end_index && offset)
 				zero_user_segment(page, offset, PAGE_CACHE_SIZE);
-			SetPageUptodate(page);
+			if (tree->track_uptodate)
+				set_extent_uptodate(tree, start, end, &cached,
+						    GFP_ATOMIC);
 		} else {
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
-		unlock_page(page);
-		offset += len;
 
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
+		offset += len;
+		/*
+		 * Check whether the page in the bvec can be marked uptodate
+		 */
+		check_page_uptodate(tree, page, cached);
 	} while (bvec <= bvec_end);
-
-	if (extent_len)
-		endio_readpage_release_extent(tree, extent_start, extent_len,
-					      uptodate);
+	/*
+	 * Unlock the btrfs_bio and associated page
+	 */
+	unlock_extent_and_page(mapping, tree, io_bio);
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, err);
 	bio_put(bio);
@@ -2700,6 +2715,18 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
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
@@ -2709,6 +2736,11 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
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
@@ -2724,6 +2756,8 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
+	btrfs_io_bio(bio)->start_offset = page_offset(page) + offset;
+	btrfs_io_bio(bio)->len = page_size;
 
 	if (bio_ret)
 		*bio_ret = bio;
@@ -2914,7 +2948,7 @@ static int __do_readpage(struct extent_io_tree *tree,
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

