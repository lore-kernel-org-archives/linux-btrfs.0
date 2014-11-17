Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60213 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaKQKhU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 05:37:20 -0500
Received: by mail-pd0-f174.google.com with SMTP id w10so2174390pde.33
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:37:19 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        <linux-fsdevel@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 1/6] btrfs: convert uses of ->mapping and ->index to wrappers
Date: Mon, 17 Nov 2014 02:36:54 -0800
Message-Id: <3bd22891a4f67bca123881290591bc1204c09ef3.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is probably the nastiest part of the patch series. Swapcache pages don't
use the ->mapping and ->index fields of the struct page. Instead, the
swp_entry_t in ->private points to the desired swap area and offset within it.
To support operating on swapcache pages in BTRFS, we need to get the mapping,
index, and offset through the page_file_mapping, page_file_index, and
page_file_offset wrappers.

Only a small subset of these calls will likely ever see a swapcache page, but
only changing those accesses leaves the rest of the code a minefield, so in my
opinion this is more foolproof.

fs/btrfs/compression.c does some shuffling around of the ->mapping field
directly. We can't have a compressed swap file anyways, so I didn't touch that
file.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/disk-io.c    |  16 +++---
 fs/btrfs/extent_io.c  | 137 ++++++++++++++++++++++++++------------------------
 fs/btrfs/file-item.c  |   6 +--
 fs/btrfs/inode.c      |  48 +++++++++---------
 fs/btrfs/ioctl.c      |  10 ++--
 fs/btrfs/relocation.c |   2 +-
 fs/btrfs/scrub.c      |   4 +-
 7 files changed, 115 insertions(+), 108 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1bf9f89..21b7eca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -502,7 +502,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 
 static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 found_start;
 	struct extent_buffer *eb;
 
@@ -607,7 +607,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	u64 found_start;
 	int found_level;
 	struct extent_buffer *eb;
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+	struct btrfs_root *root = BTRFS_I(page_file_mapping(page)->host)->root;
 	int ret = 0;
 	int reads_done;
 
@@ -696,7 +696,7 @@ out:
 static int btree_io_failed_hook(struct page *page, int failed_mirror)
 {
 	struct extent_buffer *eb;
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+	struct btrfs_root *root = BTRFS_I(page_file_mapping(page)->host)->root;
 
 	eb = (struct extent_buffer *)page->private;
 	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
@@ -880,7 +880,7 @@ static int btree_csum_one_bio(struct bio *bio)
 	int i, ret = 0;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
+		root = BTRFS_I(page_file_mapping(bvec->bv_page)->host)->root;
 		ret = csum_dirty_buffer(root, bvec->bv_page);
 		if (ret)
 			break;
@@ -1018,7 +1018,7 @@ static int btree_writepages(struct address_space *mapping,
 static int btree_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	tree = &BTRFS_I(page_file_mapping(page)->host)->io_tree;
 	return extent_read_full_page(tree, page, btree_get_extent, 0);
 }
 
@@ -1034,13 +1034,13 @@ static void btree_invalidatepage(struct page *page, unsigned int offset,
 				 unsigned int length)
 {
 	struct extent_io_tree *tree;
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	tree = &BTRFS_I(page_file_mapping(page)->host)->io_tree;
 	extent_invalidatepage(tree, page, offset);
 	btree_releasepage(page, GFP_NOFS);
 	if (PagePrivate(page)) {
-		btrfs_warn(BTRFS_I(page->mapping->host)->root->fs_info,
+		btrfs_warn(BTRFS_I(page_file_mapping(page)->host)->root->fs_info,
 			   "page private not zero on page %llu",
-			   (unsigned long long)page_offset(page));
+			   (unsigned long long)page_file_offset(page));
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		page_cache_release(page);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bf3f424..9b67b37 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1563,7 +1563,7 @@ static noinline void __unlock_for_delalloc(struct inode *inode,
 	unsigned long nr_pages = end_index - index + 1;
 	int i;
 
-	if (index == locked_page->index && end_index == index)
+	if (index == page_file_index(locked_page) && end_index == index)
 		return;
 
 	while (nr_pages > 0) {
@@ -1596,7 +1596,7 @@ static noinline int lock_delalloc_pages(struct inode *inode,
 	int i;
 
 	/* the caller is responsible for locking the start index */
-	if (index == locked_page->index && index == end_index)
+	if (index == page_file_index(locked_page) && index == end_index)
 		return 0;
 
 	/* skip the page at the start index */
@@ -1956,7 +1956,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  */
 static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 {
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
 		SetPageUptodate(page);
@@ -2068,7 +2068,8 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 
 		ret = repair_io_failure(root->fs_info->btree_inode, start,
 					PAGE_CACHE_SIZE, start, p,
-					start - page_offset(p), mirror_num);
+					start - page_file_offset(p),
+					mirror_num);
 		if (ret)
 			break;
 		start += PAGE_CACHE_SIZE;
@@ -2371,7 +2372,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 			      int failed_mirror)
 {
 	struct io_failure_record *failrec;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct bio *bio;
 	int read_mode;
@@ -2396,7 +2397,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 
 	phy_offset >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
-				      start - page_offset(page),
+				      start - page_file_offset(page),
 				      (int)phy_offset, failed_bio->bi_end_io,
 				      NULL);
 	if (!bio) {
@@ -2426,7 +2427,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	struct extent_io_tree *tree;
 	int ret = 0;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	tree = &BTRFS_I(page_file_mapping(page)->host)->io_tree;
 
 	if (tree->ops && tree->ops->writepage_end_io_hook) {
 		ret = tree->ops->writepage_end_io_hook(page, start,
@@ -2439,7 +2440,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 		ClearPageUptodate(page);
 		SetPageError(page);
 		ret = ret < 0 ? ret : -EIO;
-		mapping_set_error(page->mapping, ret);
+		mapping_set_error(page_file_mapping(page), ret);
 	}
 	return 0;
 }
@@ -2469,18 +2470,19 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
 		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
+			struct btrfs_fs_info *fs_info;
+			fs_info = BTRFS_I(page_file_mapping(page)->host)->root->fs_info;
 			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
-				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "partial page write in btrfs with offset %u and length %u",
-					bvec->bv_offset, bvec->bv_len);
+				btrfs_err(fs_info,
+					  "partial page write in btrfs with offset %u and length %u",
+					  bvec->bv_offset, bvec->bv_len);
 			else
-				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page write in btrfs with offset %u and "
-				   "length %u",
-					bvec->bv_offset, bvec->bv_len);
+				btrfs_info(fs_info,
+					   "incomplete page write in btrfs with offset %u and length %u",
+					   bvec->bv_offset, bvec->bv_len);
 		}
 
-		start = page_offset(page);
+		start = page_file_offset(page);
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
 
 		if (end_extent_writepage(page, err, start, end))
@@ -2536,7 +2538,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
-		struct inode *inode = page->mapping->host;
+		struct inode *inode = page_file_mapping(page)->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
 			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector, err,
@@ -2549,18 +2551,19 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
 		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
+			struct btrfs_fs_info *fs_info;
+			fs_info = BTRFS_I(page_file_mapping(page)->host)->root->fs_info;
 			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
-				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "partial page read in btrfs with offset %u and length %u",
-					bvec->bv_offset, bvec->bv_len);
+				btrfs_err(fs_info,
+					  "partial page read in btrfs with offset %u and length %u",
+					  bvec->bv_offset, bvec->bv_len);
 			else
-				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
-				   "incomplete page read in btrfs with offset %u and "
-				   "length %u",
-					bvec->bv_offset, bvec->bv_len);
+				btrfs_info(fs_info,
+					   "incomplete page read in btrfs with offset %u and length %u",
+					   bvec->bv_offset, bvec->bv_len);
 		}
 
-		start = page_offset(page);
+		start = page_file_offset(page);
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
 		len = bvec->bv_len;
 
@@ -2614,7 +2617,7 @@ readpage_ok:
 
 			/* Zero out the end if this page straddles i_size */
 			off = i_size & (PAGE_CACHE_SIZE-1);
-			if (page->index == end_index && off)
+			if (page_file_index(page) == end_index && off)
 				zero_user_segment(page, off, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 		} else {
@@ -2727,15 +2730,16 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
-	start = page_offset(page) + bvec->bv_offset;
+	start = page_file_offset(page) + bvec->bv_offset;
 
 	bio->bi_private = NULL;
 
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
-		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
-					   mirror_num, bio_flags, start);
+		ret = tree->ops->submit_bio_hook(page_file_mapping(page)->host,
+						 rw, bio, mirror_num, bio_flags,
+						 start);
 	else
 		btrfsic_submit_bio(rw, bio);
 
@@ -2878,8 +2882,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 			 struct bio **bio, int mirror_num,
 			 unsigned long *bio_flags, int rw)
 {
-	struct inode *inode = page->mapping->host;
-	u64 start = page_offset(page);
+	struct inode *inode = page_file_mapping(page)->host;
+	u64 start = page_file_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
 	u64 cur = start;
@@ -2910,7 +2914,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 		}
 	}
 
-	if (page->index == last_byte >> PAGE_CACHE_SHIFT) {
+	if (page_file_index(page) == last_byte >> PAGE_CACHE_SHIFT) {
 		char *userpage;
 		size_t zero_offset = last_byte & (PAGE_CACHE_SIZE - 1);
 
@@ -3017,7 +3021,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			continue;
 		}
 
-		pnr -= page->index;
+		pnr -= page_file_index(page);
 		ret = submit_extent_page(rw, tree, page,
 					 sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
@@ -3089,7 +3093,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 	int first_index = 0;
 
 	for (index = 0; index < nr_pages; index++) {
-		page_start = page_offset(pages[index]);
+		page_start = page_file_offset(pages[index]);
 		if (!end) {
 			start = page_start;
 			end = start + PAGE_CACHE_SIZE - 1;
@@ -3121,9 +3125,9 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct bio **bio, int mirror_num,
 				   unsigned long *bio_flags, int rw)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct btrfs_ordered_extent *ordered;
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	int ret;
 
@@ -3176,8 +3180,10 @@ static noinline void update_nr_written(struct page *page,
 {
 	wbc->nr_to_write -= nr_written;
 	if (wbc->range_cyclic || (wbc->nr_to_write > 0 &&
-	    wbc->range_start == 0 && wbc->range_end == LLONG_MAX))
-		page->mapping->writeback_index = page->index + nr_written;
+	    wbc->range_start == 0 && wbc->range_end == LLONG_MAX)) {
+		page_file_mapping(page)->writeback_index =
+			page_file_index(page) + nr_written;
+	}
 }
 
 /*
@@ -3288,7 +3294,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 				 int write_flags, int *nr_ret)
 {
 	struct extent_io_tree *tree = epd->tree;
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
 	u64 cur = start;
@@ -3409,8 +3415,8 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			set_range_writeback(tree, cur, cur + iosize - 1);
 			if (!PageWriteback(page)) {
 				btrfs_err(BTRFS_I(inode)->root->fs_info,
-					   "page %lu not writeback, cur %llu end %llu",
-				       page->index, cur, end);
+					  "page %lu not writeback, cur %llu end %llu",
+					  page_file_index(page), cur, end);
 			}
 
 			ret = submit_extent_page(write_flags, tree, page,
@@ -3444,9 +3450,10 @@ done_unlocked:
 static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			      void *data)
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page_file_mapping(page);
+	struct inode *inode = mapping->host;
 	struct extent_page_data *epd = data;
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	int ret;
 	int nr = 0;
@@ -3468,14 +3475,14 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	ClearPageError(page);
 
 	pg_offset = i_size & (PAGE_CACHE_SIZE - 1);
-	if (page->index > end_index ||
-	   (page->index == end_index && !pg_offset)) {
-		page->mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
+	if (page_file_index(page) > end_index ||
+	   (page_file_index(page) == end_index && !pg_offset)) {
+		mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
 		unlock_page(page);
 		return 0;
 	}
 
-	if (page->index == end_index) {
+	if (page_file_index(page) == end_index) {
 		char *userpage;
 
 		userpage = kmap_atomic(page);
@@ -3796,7 +3803,7 @@ retry:
 			if (!PagePrivate(page))
 				continue;
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (!wbc->range_cyclic && page_file_index(page) > end) {
 				done = 1;
 				break;
 			}
@@ -3949,12 +3956,12 @@ retry:
 				lock_page(page);
 			}
 
-			if (unlikely(page->mapping != mapping)) {
+			if (unlikely(page_file_mapping(page) != mapping)) {
 				unlock_page(page);
 				continue;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (!wbc->range_cyclic && page_file_index(page) > end) {
 				done = 1;
 				unlock_page(page);
 				continue;
@@ -4130,7 +4137,7 @@ int extent_readpages(struct extent_io_tree *tree,
 		prefetchw(&page->flags);
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping,
-					page->index, GFP_NOFS)) {
+					page_file_index(page), GFP_NOFS)) {
 			page_cache_release(page);
 			continue;
 		}
@@ -4164,9 +4171,9 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset)
 {
 	struct extent_state *cached_state = NULL;
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
-	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
+	size_t blocksize = page_file_mapping(page)->host->i_sb->s_blocksize;
 
 	start += ALIGN(offset, blocksize);
 	if (start > end)
@@ -4190,7 +4197,7 @@ static int try_release_extent_state(struct extent_map_tree *map,
 				    struct extent_io_tree *tree,
 				    struct page *page, gfp_t mask)
 {
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	int ret = 1;
 
@@ -4229,11 +4236,11 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			       gfp_t mask)
 {
 	struct extent_map *em;
-	u64 start = page_offset(page);
+	u64 start = page_file_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 
 	if ((mask & __GFP_WAIT) &&
-	    page->mapping->host->i_size > 16 * 1024 * 1024) {
+	    page_file_mapping(page)->host->i_size > 16 * 1024 * 1024) {
 		u64 len;
 		while (start <= end) {
 			len = end - start + 1;
@@ -4528,7 +4535,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 		index--;
 		page = eb->pages[index];
 		if (page && mapped) {
-			spin_lock(&page->mapping->private_lock);
+			spin_lock(&page_file_mapping(page)->private_lock);
 			/*
 			 * We do this since we'll remove the pages after we've
 			 * removed the eb from the radix tree, so we could race
@@ -4550,7 +4557,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 				/* One for the page private */
 				page_cache_release(page);
 			}
-			spin_unlock(&page->mapping->private_lock);
+			spin_unlock(&page_file_mapping(page)->private_lock);
 
 		}
 		if (page) {
@@ -4997,13 +5004,13 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 		WARN_ON(!PagePrivate(page));
 
 		clear_page_dirty_for_io(page);
-		spin_lock_irq(&page->mapping->tree_lock);
+		spin_lock_irq(&page_file_mapping(page)->tree_lock);
 		if (!PageDirty(page)) {
-			radix_tree_tag_clear(&page->mapping->page_tree,
+			radix_tree_tag_clear(&page_file_mapping(page)->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_DIRTY);
 		}
-		spin_unlock_irq(&page->mapping->tree_lock);
+		spin_unlock_irq(&page_file_mapping(page)->tree_lock);
 		ClearPageError(page);
 		unlock_page(page);
 	}
@@ -5523,9 +5530,9 @@ int try_release_extent_buffer(struct page *page)
 	 * We need to make sure noboody is attaching this page to an eb right
 	 * now.
 	 */
-	spin_lock(&page->mapping->private_lock);
+	spin_lock(&page_file_mapping(page)->private_lock);
 	if (!PagePrivate(page)) {
-		spin_unlock(&page->mapping->private_lock);
+		spin_unlock(&page_file_mapping(page)->private_lock);
 		return 1;
 	}
 
@@ -5540,10 +5547,10 @@ int try_release_extent_buffer(struct page *page)
 	spin_lock(&eb->refs_lock);
 	if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
 		spin_unlock(&eb->refs_lock);
-		spin_unlock(&page->mapping->private_lock);
+		spin_unlock(&page_file_mapping(page)->private_lock);
 		return 0;
 	}
-	spin_unlock(&page->mapping->private_lock);
+	spin_unlock(&page_file_mapping(page)->private_lock);
 
 	/*
 	 * If tree ref isn't set then we know the ref on this eb is a real ref,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 84a2d18..ba11623 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -222,7 +222,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
 		if (!dio)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_file_offset(bvec->bv_page) + bvec->bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -448,7 +448,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	if (contig)
 		offset = file_start;
 	else
-		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+		offset = page_file_offset(bvec->bv_page) + bvec->bv_offset;
 
 	ordered = btrfs_lookup_ordered_extent(inode, offset);
 	BUG_ON(!ordered); /* Logic error */
@@ -457,7 +457,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 
 	while (bio_index < bio->bi_vcnt) {
 		if (!contig)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_file_offset(bvec->bv_page) + bvec->bv_offset;
 
 		if (offset >= ordered->file_offset + ordered->len ||
 		    offset < ordered->file_offset) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d23362f..0e84316 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -608,8 +608,8 @@ cleanup_and_bail_uncompressed:
 		 * for the async work queue to run cow_file_range to do
 		 * the normal delalloc dance
 		 */
-		if (page_offset(locked_page) >= start &&
-		    page_offset(locked_page) <= end) {
+		if (page_file_offset(locked_page) >= start &&
+		    page_file_offset(locked_page) <= end) {
 			__set_page_dirty_nobuffers(locked_page);
 			/* unlocked later on in the async handlers */
 		}
@@ -1685,7 +1685,7 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags)
 {
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+	struct btrfs_root *root = BTRFS_I(page_file_mapping(page)->host)->root;
 	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
 	u64 length = 0;
 	u64 map_length;
@@ -1856,14 +1856,14 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	page = fixup->page;
 again:
 	lock_page(page);
-	if (!page->mapping || !PageDirty(page) || !PageChecked(page)) {
+	if (!page_file_mapping(page) || !PageDirty(page) || !PageChecked(page)) {
 		ClearPageChecked(page);
 		goto out_page;
 	}
 
-	inode = page->mapping->host;
-	page_start = page_offset(page);
-	page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
+	inode = page_file_mapping(page)->host;
+	page_start = page_file_offset(page);
+	page_end = page_file_offset(page) + PAGE_CACHE_SIZE - 1;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end, 0,
 			 &cached_state);
@@ -1884,7 +1884,7 @@ again:
 
 	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (ret) {
-		mapping_set_error(page->mapping, ret);
+		mapping_set_error(page_file_mapping(page), ret);
 		end_extent_writepage(page, ret, page_start, page_end);
 		ClearPageChecked(page);
 		goto out;
@@ -1915,7 +1915,7 @@ out_page:
  */
 static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
@@ -2875,7 +2875,7 @@ static void finish_ordered_fn(struct btrfs_work *work)
 static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct btrfs_workqueue *wq;
@@ -2946,8 +2946,8 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 				      u64 phy_offset, struct page *page,
 				      u64 start, u64 end, int mirror)
 {
-	size_t offset = start - page_offset(page);
-	struct inode *inode = page->mapping->host;
+	size_t offset = start - page_file_offset(page);
+	struct inode *inode = page_file_mapping(page)->host;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
@@ -4356,13 +4356,13 @@ again:
 		goto out;
 	}
 
-	page_start = page_offset(page);
+	page_start = page_file_offset(page);
 	page_end = page_start + PAGE_CACHE_SIZE - 1;
 
 	if (!PageUptodate(page)) {
 		ret = btrfs_readpage(NULL, page);
 		lock_page(page);
-		if (page->mapping != mapping) {
+		if (page_file_mapping(page) != mapping) {
 			unlock_page(page);
 			page_cache_release(page);
 			goto again;
@@ -6462,7 +6462,7 @@ next:
 			goto out;
 
 		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
-		extent_offset = page_offset(page) + pg_offset - extent_start;
+		extent_offset = page_file_offset(page) + pg_offset - extent_start;
 		copy_size = min_t(u64, PAGE_CACHE_SIZE - pg_offset,
 				size - extent_offset);
 		em->start = extent_start + extent_offset;
@@ -6954,7 +6954,7 @@ bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
 	}
 
 	if (page) {
-		if (page->index <= end_idx)
+		if (page_file_index(page) <= end_idx)
 			found = true;
 		page_cache_release(page);
 	}
@@ -8028,7 +8028,7 @@ static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 int btrfs_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	tree = &BTRFS_I(page_file_mapping(page)->host)->io_tree;
 	return extent_read_full_page(tree, page, btrfs_get_extent, 0);
 }
 
@@ -8042,7 +8042,7 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 		unlock_page(page);
 		return 0;
 	}
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	tree = &BTRFS_I(page_file_mapping(page)->host)->io_tree;
 	return extent_write_full_page(tree, page, btrfs_get_extent, wbc);
 }
 
@@ -8070,8 +8070,8 @@ static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 	struct extent_map_tree *map;
 	int ret;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	map = &BTRFS_I(page->mapping->host)->extent_tree;
+	tree = &BTRFS_I(page_file_mapping(page)->host)->io_tree;
+	map = &BTRFS_I(page_file_mapping(page)->host)->extent_tree;
 	ret = try_release_extent_mapping(map, tree, page, gfp_flags);
 	if (ret == 1) {
 		ClearPagePrivate(page);
@@ -8091,11 +8091,11 @@ static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 				 unsigned int length)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
-	u64 page_start = page_offset(page);
+	u64 page_start = page_file_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
 	int inode_evicting = inode->i_state & I_FREEING;
 
@@ -8227,10 +8227,10 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 again:
 	lock_page(page);
 	size = i_size_read(inode);
-	page_start = page_offset(page);
+	page_start = page_file_offset(page);
 	page_end = page_start + PAGE_CACHE_SIZE - 1;
 
-	if ((page->mapping != inode->i_mapping) ||
+	if ((page_file_mapping(page) != inode->i_mapping) ||
 	    (page_start >= size)) {
 		/* page got truncated out from underneath us */
 		goto out_unlock;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4399f0c..e3b458a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1151,7 +1151,7 @@ again:
 		if (!page)
 			break;
 
-		page_start = page_offset(page);
+		page_start = page_file_offset(page);
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
 		while (1) {
 			lock_extent_bits(tree, page_start, page_end,
@@ -1171,7 +1171,7 @@ again:
 			 * we unlocked the page above, so we need check if
 			 * it was released or not.
 			 */
-			if (page->mapping != inode->i_mapping) {
+			if (page_file_mapping(page) != inode->i_mapping) {
 				unlock_page(page);
 				page_cache_release(page);
 				goto again;
@@ -1189,7 +1189,7 @@ again:
 			}
 		}
 
-		if (page->mapping != inode->i_mapping) {
+		if (page_file_mapping(page) != inode->i_mapping) {
 			unlock_page(page);
 			page_cache_release(page);
 			goto again;
@@ -1211,8 +1211,8 @@ again:
 	for (i = 0; i < i_done; i++)
 		wait_on_page_writeback(pages[i]);
 
-	page_start = page_offset(pages[0]);
-	page_end = page_offset(pages[i_done - 1]) + PAGE_CACHE_SIZE;
+	page_start = page_file_offset(pages[0]);
+	page_end = page_file_offset(pages[i_done - 1]) + PAGE_CACHE_SIZE;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree,
 			 page_start, page_end - 1, 0, &cached_state);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 74257d6..ad1abd3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3163,7 +3163,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			}
 		}
 
-		page_start = page_offset(page);
+		page_start = page_file_offset(page);
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
 
 		lock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index efa0831..ed7e275 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -668,7 +668,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 		}
 		ret = repair_io_failure(inode, offset, PAGE_SIZE,
 					fixup->logical, page,
-					offset - page_offset(page),
+					offset - page_file_offset(page),
 					fixup->mirror_num);
 		unlock_page(page);
 		corrected = !ret;
@@ -3411,7 +3411,7 @@ again:
 			 * old one, the new data may be written into the new
 			 * page in the page cache.
 			 */
-			if (page->mapping != inode->i_mapping) {
+			if (page_file_mapping(page) != inode->i_mapping) {
 				unlock_page(page);
 				page_cache_release(page);
 				goto again;
-- 
2.1.3

