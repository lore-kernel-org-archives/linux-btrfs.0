Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48230 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbbFAPZd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 11:25:33 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 2 Jun 2015 01:25:32 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id C6E0A2BB0040
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:25:30 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t51FO7Sn1114588
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:15 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t51FNgf8027173
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:23:43 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V11 01/21] Btrfs: subpagesize-blocksize: Fix whole page read.
Date: Mon,  1 Jun 2015 20:52:36 +0530
Message-Id: <1433172176-8742-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the subpagesize-blocksize scenario, a page can contain multiple
blocks. In such cases, this patch handles reading data from files.

To track the status of individual blocks of a page, this patch makes use of a
bitmap pointed to by page->private.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 301 +++++++++++++++++++++++++++++++++------------------
 fs/btrfs/extent_io.h |  28 ++++-
 fs/btrfs/inode.c     |  13 +--
 3 files changed, 224 insertions(+), 118 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 782f3bc..d37badb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1325,6 +1325,88 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 				cached_state, mask);
 }
 
+static int modify_page_blks_state(struct page *page,
+				unsigned long blk_states,
+				u64 start, u64 end, int set)
+{
+	struct inode *inode = page->mapping->host;
+	unsigned long *bitmap;
+	unsigned long state;
+	u64 nr_blks;
+	u64 blk;
+
+	BUG_ON(!PagePrivate(page));
+
+	bitmap = ((struct btrfs_page_private *)page->private)->bstate;
+
+	blk = (start & (PAGE_CACHE_SIZE - 1)) >> inode->i_blkbits;
+	nr_blks = (end - start + 1) >> inode->i_blkbits;
+
+	while (nr_blks--) {
+		state = find_next_bit(&blk_states, BLK_NR_STATE, 0);
+
+		while (state < BLK_NR_STATE) {
+			if (set)
+				set_bit((blk * BLK_NR_STATE) + state, bitmap);
+			else
+				clear_bit((blk * BLK_NR_STATE) + state, bitmap);
+
+			state = find_next_bit(&blk_states, BLK_NR_STATE,
+					state + 1);
+		}
+
+		++blk;
+	}
+
+	return 0;
+}
+
+int set_page_blks_state(struct page *page, unsigned long blk_states,
+			u64 start, u64 end)
+{
+	return modify_page_blks_state(page, blk_states, start, end, 1);
+}
+
+int clear_page_blks_state(struct page *page, unsigned long blk_states,
+			u64 start, u64 end)
+{
+	return modify_page_blks_state(page, blk_states, start, end, 0);
+}
+
+int test_page_blks_state(struct page *page, enum blk_state blk_state,
+			u64 start, u64 end, int check_all)
+{
+	struct inode *inode = page->mapping->host;
+	unsigned long *bitmap;
+	unsigned long blk;
+	u64 nr_blks;
+	int found = 0;
+
+	BUG_ON(!PagePrivate(page));
+
+	bitmap = ((struct btrfs_page_private *)page->private)->bstate;
+
+	blk = (start & (PAGE_CACHE_SIZE - 1)) >> inode->i_blkbits;
+	nr_blks = (end - start + 1) >> inode->i_blkbits;
+
+	while (nr_blks--) {
+		if (test_bit((blk * BLK_NR_STATE) + blk_state, bitmap)) {
+			if (!check_all)
+				return 1;
+			found = 1;
+		} else if (check_all) {
+			return 0;
+		}
+
+		++blk;
+	}
+
+	if (!check_all && !found)
+		return 0;
+
+	return 1;
+}
+
 /*
  * either insert or lock state struct between start and end use mask to tell
  * us if waiting is desired.
@@ -1982,14 +2064,22 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
+static void check_page_uptodate(struct page *page)
 {
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
-	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
+	if (test_page_blks_state(page, BLK_STATE_UPTODATE, start, end, 1))
 		SetPageUptodate(page);
 }
 
+static int page_read_complete(struct page *page)
+{
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_CACHE_SIZE - 1;
+
+	return !test_page_blks_state(page, BLK_STATE_IO, start, end, 0);
+}
+
 int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 {
 	int ret;
@@ -2311,7 +2401,9 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
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
@@ -2520,18 +2612,6 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
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
@@ -2548,14 +2628,16 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	struct bio_vec *bvec;
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct extent_state *cached = NULL;
+	struct btrfs_page_private *pg_private;
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
 
@@ -2565,54 +2647,31 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
+		struct btrfs_root *root = BTRFS_I(inode)->root;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
 			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector, err,
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
 				clean_io_failure(inode, start, page, 0);
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
@@ -2623,61 +2682,63 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
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
-				offset += len;
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
-			unsigned off;
-
-			/* Zero out the end if this page straddles i_size */
-			off = i_size & (PAGE_CACHE_SIZE-1);
-			if (page->index == end_index && off)
-				zero_user_segment(page, off, PAGE_CACHE_SIZE);
-			SetPageUptodate(page);
+
+		if (uptodate) {
+			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, start,
+					start + root->sectorsize - 1);
+			check_page_uptodate(page);
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
+			clear_page_blks_state(page, 1 << BLK_STATE_IO,
+					start, start + root->sectorsize - 1);
+			clear_extent_bit(tree, start, start + root->sectorsize - 1,
+					EXTENT_LOCKED, 1, 0, &cached, GFP_ATOMIC);
+			start += root->sectorsize;
+			goto next_block;
 		}
+
+		WARN_ON(!PagePrivate(page));
+
+		pg_private = (struct btrfs_page_private *)page->private;
+
+		spin_lock_irqsave(&pg_private->io_lock, flags);
+
+		clear_page_blks_state(page, 1 << BLK_STATE_IO,
+				start, start + root->sectorsize - 1);
+
+		unlock = page_read_complete(page);
+
+		spin_unlock_irqrestore(&pg_private->io_lock, flags);
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
@@ -2859,13 +2920,36 @@ static void attach_extent_buffer_page(struct extent_buffer *eb,
 	}
 }
 
-void set_page_extent_mapped(struct page *page)
+int set_page_extent_mapped(struct page *page)
 {
+	struct btrfs_page_private *pg_private;
+
 	if (!PagePrivate(page)) {
+		pg_private = kzalloc(sizeof(*pg_private), GFP_NOFS);
+		if (!pg_private)
+			return -ENOMEM;
+
+		spin_lock_init(&pg_private->io_lock);
+
 		SetPagePrivate(page);
 		page_cache_get(page);
-		set_page_private(page, EXTENT_PAGE_PRIVATE);
+
+		set_page_private(page, (unsigned long)pg_private);
+	}
+
+	return 0;
+}
+
+int clear_page_extent_mapped(struct page *page)
+{
+	if (PagePrivate(page)) {
+		kfree((struct btrfs_page_private *)(page->private));
+		ClearPagePrivate(page);
+		set_page_private(page, 0);
+		page_cache_release(page);
 	}
+
+	return 0;
 }
 
 static struct extent_map *
@@ -2909,6 +2993,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			 unsigned long *bio_flags, int rw)
 {
 	struct inode *inode = page->mapping->host;
+	struct extent_state *cached = NULL;
 	u64 start = page_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
@@ -2964,8 +3049,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, cur,
+					cur + iosize - 1);
 			if (!parent_locked)
 				unlock_extent_cached(tree, cur,
 						     cur + iosize - 1,
@@ -3017,8 +3102,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
 
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, cur,
+					cur + iosize - 1);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
 			                     &cached, GFP_NOFS);
 			cur = cur + iosize;
@@ -3026,9 +3111,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 			continue;
 		}
 		/* the get_extent function already copied into the page */
-		if (test_range_bit(tree, cur, cur_end,
-				   EXTENT_UPTODATE, 1, NULL)) {
-			check_page_uptodate(tree, page);
+		if (test_page_blks_state(page, BLK_STATE_UPTODATE, cur,
+						cur_end, 1)) {
+			check_page_uptodate(page);
 			if (!parent_locked)
 				unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
@@ -3048,6 +3133,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 		}
 
 		pnr -= page->index;
+
+		set_page_blks_state(page, 1 << BLK_STATE_IO, cur,
+				cur + iosize - 1);
 		ret = submit_extent_page(rw, tree, page,
 					 sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
@@ -3059,8 +3147,11 @@ static int __do_readpage(struct extent_io_tree *tree,
 			*bio_flags = this_bio_flag;
 		} else {
 			SetPageError(page);
+			clear_page_blks_state(page, 1 << BLK_STATE_IO, cur,
+					cur + iosize - 1);
 			if (!parent_locked)
-				unlock_extent(tree, cur, cur + iosize - 1);
+				unlock_extent_cached(tree, cur, cur + iosize - 1,
+						&cached, GFP_NOFS);
 		}
 		cur = cur + iosize;
 		pg_offset += iosize;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c668f36..541b40a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -51,11 +51,22 @@
 #define PAGE_SET_PRIVATE2	(1 << 4)
 #define PAGE_SET_ERROR		(1 << 5)
 
+enum blk_state {
+	BLK_STATE_UPTODATE,
+	BLK_STATE_DIRTY,
+	BLK_STATE_IO,
+	BLK_NR_STATE,
+};
+
 /*
- * page->private values.  Every page that is controlled by the extent
- * map has page->private set to one.
- */
-#define EXTENT_PAGE_PRIVATE 1
+  The maximum number of blocks per page (i.e. 32) occurs when using 2k
+  as the block size and having 64k as the page size.
+*/
+#define BLK_STATE_NR_LONGS DIV_ROUND_UP(BLK_NR_STATE * 32, BITS_PER_LONG)
+struct btrfs_page_private {
+	spinlock_t io_lock;
+	unsigned long bstate[BLK_STATE_NR_LONGS];
+};
 
 struct extent_state;
 struct btrfs_root;
@@ -259,7 +270,14 @@ int extent_readpages(struct extent_io_tree *tree,
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
-void set_page_extent_mapped(struct page *page);
+int set_page_extent_mapped(struct page *page);
+int clear_page_extent_mapped(struct page *page);
+int set_page_blks_state(struct page *page, unsigned long blk_states,
+ 			u64 start, u64 end);
+int clear_page_blks_state(struct page *page, unsigned long blk_states,
+ 			u64 start, u64 end);
+int test_page_blks_state(struct page *page, enum blk_state blk_state,
+			u64 start, u64 end, int check_all);
 
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0020b56..8262f83 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6622,7 +6622,6 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_trans_handle *trans = NULL;
 	const bool new_inline = !page || create;
 
@@ -6800,8 +6799,8 @@ next:
 			kunmap(page);
 			btrfs_mark_buffer_dirty(leaf);
 		}
-		set_extent_uptodate(io_tree, em->start,
-				    extent_map_end(em) - 1, NULL, GFP_NOFS);
+		set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, em->start,
+				extent_map_end(em) - 1);
 		goto insert;
 	}
 not_found:
@@ -8392,11 +8391,9 @@ static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	map = &BTRFS_I(page->mapping->host)->extent_tree;
 	ret = try_release_extent_mapping(map, tree, page, gfp_flags);
-	if (ret == 1) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		page_cache_release(page);
-	}
+	if (ret == 1)
+		clear_page_extent_mapped(page);
+
 	return ret;
 }
 
-- 
2.1.0

