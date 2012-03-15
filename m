From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/5] Btrfs: use large extent range for read and its endio
Date: Thu, 15 Mar 2012 17:12:15 +0800
Message-ID: <1331802737-29454-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

we use larger extent state range for both readpages and read endio, so that
we can lock or unlock less and avoid most of split ops, then we'll reduce write
locks taken at endio time.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |  201 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 182 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7e76403..c3b2a2e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2231,17 +2231,25 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	struct extent_io_tree *tree;
+	struct extent_state *cached = NULL;
 	u64 start;
 	u64 end;
 	int whole_page;
 	int ret;
+	u64 up_start, up_end, un_start, un_end;
+	int up_first, un_first;
+	int for_uptodate[bio->bi_vcnt];
+	int i = 0;
+
+	up_start = un_start = (u64)-1;
+	up_end = un_end = 0;
+	up_first = un_first = 1;
 
 	if (err)
 		uptodate = 0;
 
 	do {
 		struct page *page = bvec->bv_page;
-		struct extent_state *cached = NULL;
 
 		pr_debug("end_bio_extent_readpage: bi_vcnt=%d, idx=%d, err=%d, "
 			 "mirror=%ld\n", bio->bi_vcnt, bio->bi_idx, err,
@@ -2252,11 +2260,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
 
-		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
-			whole_page = 1;
-		else
-			whole_page = 0;
-
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
 
@@ -2300,14 +2303,71 @@ error_handled:
 			}
 		}
 
+		if (uptodate)
+			for_uptodate[i++] = 1;
+		else
+			for_uptodate[i++] = 0;
+
 		if (uptodate) {
-			set_extent_uptodate(tree, start, end, &cached,
-					    GFP_ATOMIC);
+			if (up_first) {
+				up_start = start;
+				up_end = end;
+				up_first = 0;
+			} else {
+				if (up_start == end + 1) {
+					up_start = start;
+				} else if (up_end == start - 1) {
+					up_end = end;
+				} else {
+					set_extent_uptodate(
+							tree, up_start, up_end,
+							&cached, GFP_ATOMIC);
+					up_start = start;
+					up_end = end;
+				}
+			}
 		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+
+		if (un_first) {
+			un_start = start;
+			un_end = end;
+			un_first = 0;
+		} else {
+			if (un_start == end + 1) {
+				un_start = start;
+			} else if (un_end == start - 1) {
+				un_end = end;
+			} else {
+				unlock_extent_cached(tree, un_start, un_end,
+						     &cached, GFP_ATOMIC);
+				un_start = start;
+				un_end = end;
+			}
+		}
+	} while (bvec <= bvec_end);
+
+	cached = NULL;
+	if (up_start < up_end)
+		set_extent_uptodate(tree, up_start, up_end, &cached,
+				    GFP_ATOMIC);
+	if (un_start < un_end)
+		unlock_extent_cached(tree, un_start, un_end, &cached,
+				     GFP_ATOMIC);
+
+	i = 0;
+	bvec = bio->bi_io_vec;
+	do {
+		struct page *page = bvec->bv_page;
+
+		tree = &BTRFS_I(page->mapping->host)->io_tree;
+
+		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
+			whole_page = 1;
+		else
+			whole_page = 0;
 
 		if (whole_page) {
-			if (uptodate) {
+			if (for_uptodate[i++]) {
 				SetPageUptodate(page);
 			} else {
 				ClearPageUptodate(page);
@@ -2315,7 +2375,7 @@ error_handled:
 			}
 			unlock_page(page);
 		} else {
-			if (uptodate) {
+			if (for_uptodate[i++]) {
 				check_page_uptodate(tree, page);
 			} else {
 				ClearPageUptodate(page);
@@ -2323,6 +2383,7 @@ error_handled:
 			}
 			check_page_locked(tree, page);
 		}
+		++bvec;
 	} while (bvec <= bvec_end);
 
 	bio_put(bio);
@@ -2460,7 +2521,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct page *page,
 				   get_extent_t *get_extent,
 				   struct bio **bio, int mirror_num,
-				   unsigned long *bio_flags)
+				   unsigned long *bio_flags, int range_lock)
 {
 	struct inode *inode = page->mapping->host;
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
@@ -2494,6 +2555,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 	end = page_end;
 	while (1) {
+		if (range_lock)
+			break;
 		lock_extent(tree, start, end, GFP_NOFS);
 		ordered = btrfs_lookup_ordered_extent(inode, start);
 		if (!ordered)
@@ -2642,7 +2705,7 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	int ret;
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
-				      &bio_flags);
+				      &bio_flags, 0);
 	if (bio)
 		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
 	return ret;
@@ -3159,6 +3222,59 @@ int extent_writepages(struct extent_io_tree *tree,
 	return ret;
 }
 
+struct page_list {
+	struct page *page;
+	struct list_head list;
+};
+
+static int process_batch_pages(struct extent_io_tree *tree,
+			       struct address_space *mapping,
+			       struct list_head *lock_pages, int *page_cnt,
+			       u64 lock_start, u64 lock_end,
+				get_extent_t get_extent, struct bio **bio,
+				unsigned long *bio_flags)
+{
+	u64 page_start;
+	struct page_list *plist;
+
+	while (1) {
+		struct btrfs_ordered_extent *ordered = NULL;
+
+		lock_extent(tree, lock_start, lock_end, GFP_NOFS);
+		page_start = lock_start;
+		while (page_start < lock_end) {
+			ordered = btrfs_lookup_ordered_extent(mapping->host,
+							      page_start);
+			if (ordered) {
+				page_start = ordered->file_offset;
+				break;
+			}
+			page_start += PAGE_CACHE_SIZE;
+		}
+		if (!ordered)
+			break;
+		unlock_extent(tree, lock_start, lock_end, GFP_NOFS);
+		btrfs_start_ordered_extent(mapping->host, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+	}
+
+	plist = NULL;
+	while (!list_empty(lock_pages)) {
+		plist = list_entry(lock_pages->prev, struct page_list, list);
+
+		__extent_read_full_page(tree, plist->page, get_extent,
+					bio, 0, bio_flags, 1);
+		page_cache_release(plist->page);
+		list_del(&plist->list);
+		plist->page = NULL;
+		kfree(plist);
+		(*page_cnt)--;
+	}
+
+	WARN_ON((*page_cnt));
+	return 0;
+}
+
 int extent_readpages(struct extent_io_tree *tree,
 		     struct address_space *mapping,
 		     struct list_head *pages, unsigned nr_pages,
@@ -3167,7 +3283,17 @@ int extent_readpages(struct extent_io_tree *tree,
 	struct bio *bio = NULL;
 	unsigned page_idx;
 	unsigned long bio_flags = 0;
-
+	u64 page_start;
+	u64 page_end;
+	u64 lock_start = (u64)-1;
+	u64 lock_end = 0;
+	struct page_list *plist;
+	int page_cnt = 0;
+	LIST_HEAD(lock_pages);
+	int first = 1;
+
+	lock_start = (u64)-1;
+	lock_end = 0;
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
 
@@ -3175,12 +3301,49 @@ int extent_readpages(struct extent_io_tree *tree,
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
 					page->index, GFP_NOFS)) {
-			__extent_read_full_page(tree, page, get_extent,
-						&bio, 0, &bio_flags);
+			page_start = (u64)page_offset(page);
+			page_end = page_start + PAGE_CACHE_SIZE - 1;
+
+			if (first) {
+				lock_start = page_start;
+				lock_end = page_end;
+				first = 0;
+			} else {
+				/*
+				 * |--lock range--||--page range--|
+				 * or
+				 * |--page range--||--lock range--|
+				 */
+				if (lock_start != page_end - 1 &&
+				    lock_end != page_start - 1) {
+					process_batch_pages(tree, mapping,
+						&lock_pages, &page_cnt,
+						lock_start, lock_end,
+						get_extent, &bio, &bio_flags);
+
+					lock_start = page_start;
+					lock_end = page_end;
+				} else {
+					lock_start =
+						 min(lock_start, page_start);
+					lock_end = max(lock_end, page_end);
+				}
+			}
+			plist = kmalloc(sizeof(*plist), GFP_NOFS);
+			BUG_ON(!plist);
+			plist->page = page;
+			list_add(&plist->list, &lock_pages);
+			page_cache_get(page);
+			page_cnt++;
 		}
 		page_cache_release(page);
 	}
+
+	if (!list_empty(&lock_pages))
+		process_batch_pages(tree, mapping, &lock_pages, &page_cnt,
+			lock_start, lock_end, get_extent, &bio, &bio_flags);
 	BUG_ON(!list_empty(pages));
+
 	if (bio)
 		submit_one_bio(READ, bio, 0, bio_flags);
 	return 0;
@@ -4001,9 +4164,9 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			if (start_i == 0)
 				inc_all_pages = 1;
 			ClearPageError(page);
-			err = __extent_read_full_page(tree, page,
-						      get_extent, &bio,
-						      mirror_num, &bio_flags);
+			err = __extent_read_full_page(
+						tree, page, get_extent, &bio,
+						mirror_num, &bio_flags, 0);
 			if (err)
 				ret = err;
 		} else {
-- 
1.6.5.2

