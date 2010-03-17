From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] btrfs: use add_to_page_cache_lru, use
 __page_cache_alloc
Date: Thu, 18 Mar 2010 00:31:04 +1100
Message-ID: <20100317133104.GI2869@laptop>
References: <20100317062053.GB2869@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100317062053.GB2869@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 17, 2010 at 05:20:53PM +1100, Nick Piggin wrote:
> btrfs: use add_to_page_cache_lru, use __page_cache_alloc
> 
> Pagecache pages should be allocated with __page_cache_alloc, so they
> obey pagecache memory policies.
> 
> add_to_page_cache_lru is exported, so it should be used. Benefits over
> using a private pagevec: neater code, 128 bytes fewer stack used, percpu
> lru ordering is preserved, and finally don't need to flush pagevec
> before returning so batching may be shared with other LRU insertions.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>:

Missed a rediff.
---
 fs/btrfs/compression.c |   20 ++------------------
 fs/btrfs/extent_io.c   |   22 +++++-----------------
 2 files changed, 7 insertions(+), 35 deletions(-)

Index: linux-2.6/fs/btrfs/compression.c
===================================================================
--- linux-2.6.orig/fs/btrfs/compression.c
+++ linux-2.6/fs/btrfs/compression.c
@@ -31,7 +31,6 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/bit_spinlock.h>
-#include <linux/pagevec.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -445,7 +444,6 @@ static noinline int add_ra_bio_pages(str
 	unsigned long nr_pages = 0;
 	struct extent_map *em;
 	struct address_space *mapping = inode->i_mapping;
-	struct pagevec pvec;
 	struct extent_map_tree *em_tree;
 	struct extent_io_tree *tree;
 	u64 end;
@@ -461,7 +459,6 @@ static noinline int add_ra_bio_pages(str
 
 	end_index = (i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT;
 
-	pagevec_init(&pvec, 0);
 	while (last_offset < compressed_end) {
 		page_index = last_offset >> PAGE_CACHE_SHIFT;
 
@@ -478,26 +475,17 @@ static noinline int add_ra_bio_pages(str
 			goto next;
 		}
 
-		page = alloc_page(mapping_gfp_mask(mapping) & ~__GFP_FS);
+		page = __page_cache_alloc(mapping_gfp_mask(mapping) &
+								~__GFP_FS);
 		if (!page)
 			break;
 
-		page->index = page_index;
-		/*
-		 * what we want to do here is call add_to_page_cache_lru,
-		 * but that isn't exported, so we reproduce it here
-		 */
-		if (add_to_page_cache(page, mapping,
-				      page->index, GFP_NOFS)) {
+		if (add_to_page_cache_lru(page, mapping, page_index,
+								GFP_NOFS)) {
 			page_cache_release(page);
 			goto next;
 		}
 
-		/* open coding of lru_cache_add, also not exported */
-		page_cache_get(page);
-		if (!pagevec_add(&pvec, page))
-			__pagevec_lru_add_file(&pvec);
-
 		end = last_offset + PAGE_CACHE_SIZE - 1;
 		/*
 		 * at this point, we have a locked page in the page cache
@@ -551,8 +539,6 @@ static noinline int add_ra_bio_pages(str
 next:
 		last_offset += PAGE_CACHE_SIZE;
 	}
-	if (pagevec_count(&pvec))
-		__pagevec_lru_add_file(&pvec);
 	return 0;
 }
 
Index: linux-2.6/fs/btrfs/extent_io.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent_io.c
+++ linux-2.6/fs/btrfs/extent_io.c
@@ -2663,33 +2663,21 @@ int extent_readpages(struct extent_io_tr
 {
 	struct bio *bio = NULL;
 	unsigned page_idx;
-	struct pagevec pvec;
 	unsigned long bio_flags = 0;
 
-	pagevec_init(&pvec, 0);
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
 
 		prefetchw(&page->flags);
 		list_del(&page->lru);
-		/*
-		 * what we want to do here is call add_to_page_cache_lru,
-		 * but that isn't exported, so we reproduce it here
-		 */
-		if (!add_to_page_cache(page, mapping,
+		if (add_to_page_cache_lru(page, mapping,
 					page->index, GFP_KERNEL)) {
-
-			/* open coding of lru_cache_add, also not exported */
-			page_cache_get(page);
-			if (!pagevec_add(&pvec, page))
-				__pagevec_lru_add_file(&pvec);
-			__extent_read_full_page(tree, page, get_extent,
-						&bio, 0, &bio_flags);
+			page_cache_release(page);
+			continue;
 		}
-		page_cache_release(page);
+		__extent_read_full_page(tree, page, get_extent,
+						&bio, 0, &bio_flags);
 	}
-	if (pagevec_count(&pvec))
-		__pagevec_lru_add_file(&pvec);
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		submit_one_bio(READ, bio, 0, bio_flags);
