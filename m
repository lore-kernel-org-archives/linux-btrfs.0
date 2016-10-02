Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51119 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751574AbcJBNZa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:30 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNCDg046153
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:29 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25t7f9q5c8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:29 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:28 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 05/19] Btrfs: subpage-blocksize: Fix whole page read.
Date: Sun,  2 Oct 2016 18:54:14 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-6-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the subpage-blocksize scenario, a page can contain multiple
blocks. In such cases, this patch handles reading data from files.

To track the status of individual blocks of a page, this patch makes use
of a bitmap pointed to by the newly introduced per-page 'struct
btrfs_page_private'.

The per-page btrfs_page_private->io_lock plays the same role as
BH_Uptodate_Lock (see end_buffer_async_read()) i.e. without the io_lock
we may end up in the following situation,

NOTE: Assume 64k page size and 4k block size. Also assume that the first
12 blocks of the page are contiguous while the next 4 blocks are
contiguous. When reading the page we end up submitting two "logical
address space" bios. So end_bio_extent_readpage function is invoked
twice, once for each bio.

|-------------------------+-------------------------+-------------|
| Task A                  | Task B                  | Task C      |
|-------------------------+-------------------------+-------------|
| end_bio_extent_readpage |                         |             |
| process block 0         |                         |             |
| - clear BLK_STATE_IO    |                         |             |
| - page_read_complete    |                         |             |
| process block 1         |                         |             |
|                         |                         |             |
|                         |                         |             |
|                         | end_bio_extent_readpage |             |
|                         | process block 0         |             |
|                         | - clear BLK_STATE_IO    |             |
|                         | - page_read_complete    |             |
|                         | process block 1         |             |
|                         |                         |             |
| process block 11        | process block 3         |             |
| - clear BLK_STATE_IO    | - clear BLK_STATE_IO    |             |
| - page_read_complete    | - page_read_complete    |             |
|   - returns true        |   - returns true        |             |
|   - unlock_page()       |                         |             |
|                         |                         | lock_page() |
|                         |   - unlock_page()       |             |
|-------------------------+-------------------------+-------------|

We end up incorrectly unlocking the page twice and "Task C" ends up
working on an unlocked page. So private->io_lock makes sure that only
one of the tasks gets "true" as the return value when page_io_complete()
is invoked. As an optimization the patch gets the io_lock only when the
last block of the bio_vec is being processed.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 299 +++++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h |  76 ++++++++++++-
 fs/btrfs/inode.c     |  13 +--
 3 files changed, 320 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 522c943..b3885cc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -23,6 +23,7 @@
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
+static struct kmem_cache *page_private_cache;
 static struct bio_set *btrfs_bioset;
 
 static inline bool extent_state_in_tree(const struct extent_state *state)
@@ -163,10 +164,16 @@ int __init extent_io_init(void)
 	if (!extent_buffer_cache)
 		goto free_state_cache;
 
+	page_private_cache = kmem_cache_create("btrfs_page_private",
+			sizeof(struct btrfs_page_private), 0,
+			SLAB_MEM_SPREAD, NULL);
+	if (!page_private_cache)
+		goto free_buffer_cache;
+
 	btrfs_bioset = bioset_create(BIO_POOL_SIZE,
 				     offsetof(struct btrfs_io_bio, bio));
 	if (!btrfs_bioset)
-		goto free_buffer_cache;
+		goto free_page_private_cache;
 
 	if (bioset_integrity_create(btrfs_bioset, BIO_POOL_SIZE))
 		goto free_bioset;
@@ -177,6 +184,10 @@ free_bioset:
 	bioset_free(btrfs_bioset);
 	btrfs_bioset = NULL;
 
+free_page_private_cache:
+	kmem_cache_destroy(page_private_cache);
+	page_private_cache = NULL;
+
 free_buffer_cache:
 	kmem_cache_destroy(extent_buffer_cache);
 	extent_buffer_cache = NULL;
@@ -1311,6 +1322,96 @@ int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 				  changeset);
 }
 
+static int modify_page_blks_state(struct page *page,
+				unsigned long blk_states,
+				u64 start, u64 end, int set)
+{
+	struct inode *inode = page->mapping->host;
+	unsigned long *bitmap;
+	unsigned long first_state;
+	unsigned long state;
+	u64 nr_blks;
+	u64 blk;
+
+	if (BTRFS_I(inode)->root->sectorsize == PAGE_SIZE)
+		return 0;
+
+	bitmap = ((struct btrfs_page_private *)page->private)->bstate;
+
+	blk = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
+				start & (PAGE_SIZE - 1));
+	nr_blks = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
+				(end - start + 1));
+
+	first_state = find_next_bit(&blk_states, BLK_NR_STATE, 0);
+
+	while (nr_blks--) {
+		state = first_state;
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
+	ASSERT(BTRFS_I(inode)->root->sectorsize < PAGE_SIZE);
+
+	bitmap = ((struct btrfs_page_private *)page->private)->bstate;
+
+	blk = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
+				start & (PAGE_SIZE - 1));
+	nr_blks = BTRFS_BYTES_TO_BLKS(BTRFS_I(inode)->root->fs_info,
+				(end - start + 1));
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
@@ -1950,9 +2051,25 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static void check_page_uptodate(struct page *page)
+void check_page_uptodate(struct page *page)
 {
-	SetPageUptodate(page);
+	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_SIZE - 1;
+
+	if (root->sectorsize == PAGE_SIZE
+		|| test_page_blks_state(page, BLK_STATE_UPTODATE, start,
+					end, 1))
+		SetPageUptodate(page);
+}
+
+static int page_io_complete(struct page *page)
+{
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_SIZE - 1;
+
+	return !test_page_blks_state(page, BLK_STATE_IO, start, end, 0);
 }
 
 int free_io_failure(struct extent_io_tree *failure_tree,
@@ -2282,7 +2399,9 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
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
@@ -2506,17 +2625,21 @@ static void end_bio_extent_readpage(struct bio *bio)
 	int uptodate = !bio->bi_error;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	struct extent_io_tree *tree, *failure_tree;
+	struct btrfs_page_private *pg_private;
+	unsigned long flags;
 	u64 offset = 0;
 	u64 start;
 	u64 end;
-	u64 len;
+	int nr_sectors;
 	int mirror;
+	int unlock;
 	int ret;
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
+		struct btrfs_root *root = BTRFS_I(inode)->root;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
 			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector,
@@ -2524,28 +2647,14 @@ static void end_bio_extent_readpage(struct bio *bio)
 		tree = &BTRFS_I(inode)->io_tree;
 		failure_tree = &BTRFS_I(inode)->io_failure_tree;
 
-		/* We always issue full-page reads, but if some block
-		 * in a page fails to read, blk_update_request() will
-		 * advance bv_offset and adjust bv_len to compensate.
-		 * Print a warning for nonzero offsets, and an error
-		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_SIZE) {
-			if (bvec->bv_offset + bvec->bv_len != PAGE_SIZE)
-				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "partial page read in btrfs with offset %u and length %u",
-					bvec->bv_offset, bvec->bv_len);
-			else
-				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page read in btrfs with offset %u and "
-				   "length %u",
-					bvec->bv_offset, bvec->bv_len);
-		}
+		start = page_offset(page) + bvec->bv_offset;
+		nr_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info,
+						bvec->bv_len);
+		mirror = io_bio->mirror_num;
 
-		start = page_offset(page);
-		end = start + bvec->bv_offset + bvec->bv_len - 1;
-		len = bvec->bv_len;
+next_block:
+		end = start + root->sectorsize - 1;
 
-		mirror = io_bio->mirror_num;
 		if (likely(uptodate && tree->ops &&
 			   tree->ops->readpage_end_io_hook)) {
 			ret = tree->ops->readpage_end_io_hook(io_bio, offset,
@@ -2556,17 +2665,11 @@ static void end_bio_extent_readpage(struct bio *bio)
 			else
 				clean_io_failure(BTRFS_I(inode)->root->fs_info,
 						 failure_tree, tree, start,
-						 page, btrfs_ino(inode), 0);
+						 page, btrfs_ino(inode),
+						 start - page_offset(page));
 		}
 
-		if (likely(uptodate))
-			goto readpage_ok;
-
-		if (tree->ops && tree->ops->readpage_io_failed_hook) {
-			ret = tree->ops->readpage_io_failed_hook(page, mirror);
-			if (!ret && !bio->bi_error)
-				uptodate = 1;
-		} else {
+		if (!uptodate) {
 			/*
 			 * The generic bio_readpage_error handles errors the
 			 * following way: If possible, new read requests are
@@ -2581,30 +2684,58 @@ static void end_bio_extent_readpage(struct bio *bio)
 						 mirror);
 			if (ret == 0) {
 				uptodate = !bio->bi_error;
-				offset += len;
-				continue;
+				offset += root->sectorsize;
+				if (--nr_sectors) {
+					start = end + 1;
+					goto next_block;
+				} else {
+					continue;
+				}
 			}
 		}
-readpage_ok:
-		if (likely(uptodate)) {
-			loff_t i_size = i_size_read(inode);
-			pgoff_t end_index = i_size >> PAGE_SHIFT;
-			unsigned off;
-
-			/* Zero out the end if this page straddles i_size */
-			off = i_size & (PAGE_SIZE-1);
-			if (page->index == end_index && off)
-				zero_user_segment(page, off, PAGE_SIZE);
+
+		if (uptodate) {
+			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE,
+					start, end);
 			check_page_uptodate(page);
 		} else {
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
-		unlock_page(page);
-		offset += len;
 
-		unlock_extent_cached(tree, start, end, NULL, GFP_ATOMIC);
+		offset += root->sectorsize;
+
+		if (--nr_sectors) {
+			clear_page_blks_state(page, 1 << BLK_STATE_IO,
+					start, end);
+			clear_extent_bit(tree, start, end,
+					EXTENT_LOCKED, 1, 0, NULL, GFP_ATOMIC);
+			start = end + 1;
+			goto next_block;
+		}
+
+		WARN_ON(!PagePrivate(page));
+
+		unlock = 1;
+
+		if (root->sectorsize < PAGE_SIZE) {
+			pg_private = (struct btrfs_page_private *)page->private;
+
+			spin_lock_irqsave(&pg_private->io_lock, flags);
+
+			clear_page_blks_state(page, 1 << BLK_STATE_IO,
+					start, end);
+
+			unlock = page_io_complete(page);
+
+			spin_unlock_irqrestore(&pg_private->io_lock, flags);
+		}
+
+		clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
+				GFP_ATOMIC);
 
+		if (unlock)
+			unlock_page(page);
 	}
 
 	if (io_bio->end_io)
@@ -2794,13 +2925,51 @@ static void attach_extent_buffer_page(struct extent_buffer *eb,
 	}
 }
 
-void set_page_extent_mapped(struct page *page)
+int set_page_extent_mapped(struct page *page)
 {
+	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_page_private *pg_private;
+	unsigned long private = EXTENT_PAGE_PRIVATE;
+
 	if (!PagePrivate(page)) {
+		if (root->sectorsize < PAGE_SIZE) {
+			pg_private = kmem_cache_zalloc(page_private_cache,
+						GFP_NOFS);
+			if (!pg_private)
+				return -ENOMEM;
+
+			spin_lock_init(&pg_private->io_lock);
+
+			private = (unsigned long)pg_private;
+		}
+
 		SetPagePrivate(page);
 		get_page(page);
-		set_page_private(page, EXTENT_PAGE_PRIVATE);
+		set_page_private(page, private);
 	}
+
+	return 0;
+}
+
+int clear_page_extent_mapped(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_page_private *pg_private;
+
+	if (PagePrivate(page)) {
+		if (root->sectorsize < PAGE_SIZE) {
+			pg_private = (struct btrfs_page_private *)(page->private);
+			kmem_cache_free(page_private_cache, pg_private);
+		}
+
+		ClearPagePrivate(page);
+		set_page_private(page, 0);
+		put_page(page);
+	}
+
+	return 0;
 }
 
 static struct extent_map *
@@ -2846,6 +3015,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			 u64 *prev_em_start)
 {
 	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 start = page_offset(page);
 	u64 page_end = start + PAGE_SIZE - 1;
 	u64 end;
@@ -2868,12 +3038,10 @@ static int __do_readpage(struct extent_io_tree *tree,
 	set_page_extent_mapped(page);
 
 	end = page_end;
-	if (!PageUptodate(page)) {
-		if (cleancache_get_page(page) == 0) {
-			BUG_ON(blocksize != PAGE_SIZE);
-			unlock_extent(tree, start, end);
-			goto out;
-		}
+	if ((blocksize == PAGE_SIZE) && !PageUptodate(page) &&
+		(cleancache_get_page(page) == 0)) {
+		unlock_extent(tree, start, end);
+		goto out;
 	}
 
 	if (page->index == last_byte >> PAGE_SHIFT) {
@@ -2900,6 +3068,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
+			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, cur,
+						cur + iosize - 1);
 			unlock_extent_cached(tree, cur,
 					     cur + iosize - 1,
 					     NULL, GFP_NOFS);
@@ -2992,6 +3162,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
 
+			set_page_blks_state(page, 1 << BLK_STATE_UPTODATE, cur,
+					cur + iosize - 1);
+
 			unlock_extent_cached(tree, cur,
 					     cur + iosize - 1,
 					     &cached, GFP_NOFS);
@@ -3000,7 +3173,12 @@ static int __do_readpage(struct extent_io_tree *tree,
 			continue;
 		}
 		/* the get_extent function already copied into the page */
-		if (PageUptodate(page)) {
+		if ((root->sectorsize == PAGE_SIZE
+				&& PageUptodate(page))
+			|| (root->sectorsize < PAGE_SIZE
+				&& test_page_blks_state(page,
+							BLK_STATE_UPTODATE, cur,
+							cur_end, 1))) {
 			check_page_uptodate(page);
 			unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
@@ -3019,6 +3197,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 		}
 
 		pnr -= page->index;
+
+		set_page_blks_state(page, 1 << BLK_STATE_IO, cur,
+				cur + iosize - 1);
 		ret = submit_extent_page(REQ_OP_READ, read_flags, tree, NULL,
 					 page, sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
@@ -3031,6 +3212,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 			*bio_flags = this_bio_flag;
 		} else {
 			SetPageError(page);
+			clear_page_blks_state(page, 1 << BLK_STATE_IO,
+					cur, cur + iosize - 1);
 			unlock_extent(tree, cur, cur + iosize - 1);
 			goto out;
 		}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9aa22f9..e7a0462 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -55,11 +55,72 @@
 #define PAGE_SET_ERROR		(1 << 5)
 
 /*
- * page->private values.  Every page that is controlled by the extent
- * map has page->private set to one.
+ * page->private values for "sector size" == "page size" case.  Every
+ * page that is controlled by the extent map has page->private set to
+ * one.
  */
 #define EXTENT_PAGE_PRIVATE 1
 
+enum blk_state {
+	BLK_STATE_UPTODATE,
+	BLK_STATE_DIRTY,
+	BLK_STATE_IO,
+	BLK_NR_STATE,
+};
+
+/*
+ * The maximum number of blocks per page (i.e. 32) occurs when using 2k
+ * as the block size and having 64k as the page size.
+ */
+#define BLK_STATE_NR_LONGS DIV_ROUND_UP(BLK_NR_STATE * 32, BITS_PER_LONG)
+
+
+/*
+ * btrfs_page_private->io_lock plays the same role as BH_Uptodate_Lock
+ * (see end_buffer_async_read()) i.e. without the io_lock we may end up
+ * in the following situation,
+ *
+ * NOTE: Assume 64k page size and 4k block size. Also assume that the first 12
+ * blocks of the page are contiguous while the next 4 blocks are contiguous. When
+ * reading the page we end up submitting two "logical address space" bios. So
+ * end_bio_extent_readpage function is invoked twice, once for each bio.
+ *
+ * |-------------------------+-------------------------+-------------|
+ * | Task A                  | Task B                  | Task C      |
+ * |-------------------------+-------------------------+-------------|
+ * | end_bio_extent_readpage |                         |             |
+ * | process block 0         |                         |             |
+ * | - clear BLK_STATE_IO    |                         |             |
+ * | - page_read_complete    |                         |             |
+ * | process block 1         |                         |             |
+ * |                         |                         |             |
+ * |                         |                         |             |
+ * |                         | end_bio_extent_readpage |             |
+ * |                         | process block 0         |             |
+ * |                         | - clear BLK_STATE_IO    |             |
+ * |                         | - page_read_complete    |             |
+ * |                         | process block 1         |             |
+ * |                         |                         |             |
+ * | process block 11        | process block 3         |             |
+ * | - clear BLK_STATE_IO    | - clear BLK_STATE_IO    |             |
+ * | - page_read_complete    | - page_read_complete    |             |
+ * |   - returns true        |   - returns true        |             |
+ * |   - unlock_page()       |                         |             |
+ * |                         |                         | lock_page() |
+ * |                         |   - unlock_page()       |             |
+ * |-------------------------+-------------------------+-------------|
+ *
+ * We end up incorrectly unlocking the page twice and "Task C" ends up
+ * working on an unlocked page. So private->io_lock makes sure that
+ * only one of the tasks gets "true" as the return value when
+ * page_io_complete() is invoked. As an optimization the patch gets the
+ * io_lock only when the last block of the bio_vec is being processed.
+ */
+struct btrfs_page_private {
+	spinlock_t io_lock;
+	unsigned long bstate[BLK_STATE_NR_LONGS];
+};
+
 struct extent_state;
 struct btrfs_root;
 struct btrfs_io_bio;
@@ -356,8 +417,14 @@ int extent_readpages(struct extent_io_tree *tree,
 		     get_extent_t get_extent);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
-void set_page_extent_mapped(struct page *page);
-
+int set_page_extent_mapped(struct page *page);
+int clear_page_extent_mapped(struct page *page);
+int set_page_blks_state(struct page *page, unsigned long blk_states,
+			u64 start, u64 end);
+int clear_page_blks_state(struct page *page, unsigned long blk_states,
+			u64 start, u64 end);
+int test_page_blks_state(struct page *page, enum blk_state blk_state,
+			u64 start, u64 end, int check_all);
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_eb_info *eb_info,
@@ -477,6 +544,7 @@ struct io_failure_record {
 	int in_validation;
 };
 
+void check_page_uptodate(struct page *page);
 void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end);
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 				struct io_failure_record **failrec_ret);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ac4a7c0..10dcb44 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6983,7 +6983,10 @@ next:
 			btrfs_mark_buffer_dirty(leaf);
 		}
 
-		SetPageUptodate(page);
+		set_page_blks_state(page, 1 << BLK_STATE_UPTODATE,
+				em->start, extent_map_end(em) - 1);
+		check_page_uptodate(page);
+
 		goto insert;
 	}
 not_found:
@@ -8802,11 +8805,9 @@ static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	map = &BTRFS_I(page->mapping->host)->extent_tree;
 	ret = try_release_extent_mapping(map, tree, page, gfp_flags);
-	if (ret == 1) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		put_page(page);
-	}
+	if (ret == 1)
+		clear_page_extent_mapped(page);
+
 	return ret;
 }
 
-- 
2.5.5

