From: Arne Jansen <sensille@gmx.net>
Subject: [RFC][PATCH] btrfs: using cached extent_state in set/unlock combinations
Date: Wed,  6 Apr 2011 12:02:20 +0200
Message-ID: <1302084140-22382-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In several places the sequence (set_extent_uptodate, unlock_extent) is used.
This leads to a duplicate lookup of the extent state. This patch lets
set_extent_uptodate return a cached extent_state which can be passed to
unlock_extent_cached.
The occurences of the above sequences are updated to use the cache. Only
end_bio_extent_readpage is updated that it first gets a cached state to
pass it to the readpage_end_io_hook as the prototype requested and is later
on being used for set/unlock.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent_io.c |   70 +++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/extent_io.h |    2 +-
 fs/btrfs/inode.c     |    2 +-
 3 files changed, 55 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9fcb5ed..9e8230d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -690,6 +690,17 @@ static void cache_state(struct extent_state *state,
 	}
 }
 
+static void uncache_state(struct extent_state **cached_ptr)
+{
+	if (cached_ptr && (*cached_ptr)) {
+		struct extent_state *state = *cached_ptr;
+		if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY)) {
+			*cached_ptr = NULL;
+			free_extent_state(state);
+		}
+	}
+}
+
 /*
  * set some bits on a range in the tree.  This may require allocations or
  * sleeping, so the gfp mask is used to indicate what is allowed.
@@ -940,10 +951,10 @@ static int clear_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
-			gfp_t mask)
+			struct extent_state **cached_state, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, NULL,
-			      NULL, mask);
+	return set_extent_bit(tree, start, end, EXTENT_UPTODATE, 0,
+			      NULL, cached_state, mask);
 }
 
 static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
@@ -1012,8 +1023,7 @@ int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 				mask);
 }
 
-int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end,
-		  gfp_t mask)
+int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
 				mask);
@@ -1735,6 +1745,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 	do {
 		struct page *page = bvec->bv_page;
+		struct extent_state *cached = NULL;
+		struct extent_state *state;
+
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
 		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
@@ -1749,9 +1762,20 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
 
+		spin_lock(&tree->lock);
+		state = find_first_extent_bit_state(tree, start, 0);
+		if (state) {
+			/*
+			 * take a reference on the state, unlock will drop
+			 * the ref
+			 */
+			cache_state(state, &cached);
+		}
+		spin_unlock(&tree->lock);
+
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
-							      NULL);
+							      state);
 			if (ret)
 				uptodate = 0;
 		}
@@ -1764,15 +1788,16 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
+				uncache_state(&cached);
 				continue;
 			}
 		}
 
 		if (uptodate) {
-			set_extent_uptodate(tree, start, end,
+			set_extent_uptodate(tree, start, end, &cached,
 					    GFP_ATOMIC);
 		}
-		unlock_extent(tree, start, end, GFP_ATOMIC);
+		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
 
 		if (whole_page) {
 			if (uptodate) {
@@ -1811,6 +1836,7 @@ static void end_bio_extent_preparewrite(struct bio *bio, int err)
 
 	do {
 		struct page *page = bvec->bv_page;
+		struct extent_state *cached = NULL;
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
 		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
@@ -1821,13 +1847,14 @@ static void end_bio_extent_preparewrite(struct bio *bio, int err)
 			prefetchw(&bvec->bv_page->flags);
 
 		if (uptodate) {
-			set_extent_uptodate(tree, start, end, GFP_ATOMIC);
+			set_extent_uptodate(tree, start, end, &cached,
+					    GFP_ATOMIC);
 		} else {
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
 
-		unlock_extent(tree, start, end, GFP_ATOMIC);
+		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
 
 	} while (bvec >= bio->bi_io_vec);
 
@@ -2016,14 +2043,17 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	while (cur <= end) {
 		if (cur >= last_byte) {
 			char *userpage;
+			struct extent_state *cached = NULL;
+
 			iosize = PAGE_CACHE_SIZE - page_offset;
 			userpage = kmap_atomic(page, KM_USER0);
 			memset(userpage + page_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage, KM_USER0);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    GFP_NOFS);
-			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
+					    &cached, GFP_NOFS);
+			unlock_extent_cached(tree, cur, cur + iosize - 1,
+					     &cached, GFP_NOFS);
 			break;
 		}
 		em = get_extent(inode, page, page_offset, cur,
@@ -2063,14 +2093,17 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		/* we've found a hole, just zero and go on */
 		if (block_start == EXTENT_MAP_HOLE) {
 			char *userpage;
+			struct extent_state *cached = NULL;
+
 			userpage = kmap_atomic(page, KM_USER0);
 			memset(userpage + page_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage, KM_USER0);
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    GFP_NOFS);
-			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
+					    &cached, GFP_NOFS);
+			unlock_extent_cached(tree, cur, cur + iosize - 1,
+			                     &cached, GFP_NOFS);
 			cur = cur + iosize;
 			page_offset += iosize;
 			continue;
@@ -2787,9 +2820,12 @@ int extent_prepare_write(struct extent_io_tree *tree,
 			iocount++;
 			block_start = block_start + iosize;
 		} else {
-			set_extent_uptodate(tree, block_start, cur_end,
+			struct extent_state *cached = NULL;
+
+			set_extent_uptodate(tree, block_start, cur_end, &cached,
 					    GFP_NOFS);
-			unlock_extent(tree, block_start, cur_end, GFP_NOFS);
+			unlock_extent_cached(tree, block_start, cur_end,
+					     &cached, GFP_NOFS);
 			block_start = cur_end + 1;
 		}
 		page_offset = block_start & (PAGE_CACHE_SIZE - 1);
@@ -3456,7 +3492,7 @@ int set_extent_buffer_uptodate(struct extent_io_tree *tree,
 	num_pages = num_extent_pages(eb->start, eb->len);
 
 	set_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
-			    GFP_NOFS);
+			    NULL, GFP_NOFS);
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if ((i == 0 && (eb->start & (PAGE_CACHE_SIZE - 1))) ||
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9318dfe..ceeda49 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -207,7 +207,7 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   int bits, int exclusive_bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
-			gfp_t mask);
+			struct extent_state **cached_state, gfp_t mask);
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db67821..8aea25c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5202,7 +5202,7 @@ again:
 			btrfs_mark_buffer_dirty(leaf);
 		}
 		set_extent_uptodate(io_tree, em->start,
-				    extent_map_end(em) - 1, GFP_NOFS);
+				    extent_map_end(em) - 1, NULL, GFP_NOFS);
 		goto insert;
 	} else {
 		printk(KERN_ERR "btrfs unknown found_type %d\n", found_type);
-- 
1.7.3.4

