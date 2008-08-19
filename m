From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Tue, 19 Aug 2008 15:51:40 +0100
Message-ID: <1219157500.3184.484.camel@pmac.infradead.org>
References: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
	 <20080730195628.GP20055@kernel.dk>
	 <1217448700.20239.30.camel@think.oraclecorp.com>
	 <20080730201333.GR20055@kernel.dk>
	 <1217450622.20239.32.camel@think.oraclecorp.com>
	 <1217532421.3454.291.camel@pmac.infradead.org>
	 <1217533058.20239.62.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Sven Wegener <sven.wegener@stealer.net>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217533058.20239.62.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-07-31 at 15:37 -0400, Chris Mason wrote:
> > BUG: unable to handle kernel paging request at ffff880107c2aa00
> > IP: [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c
> [btrfs]
> 
> If you can reliably reproduce this, please try with the spin locks
> instead of rcu read locks.  What were you doing at the time?

Just using CONFIG_DEBUG_PAGEALLOC and dirtying a bunch of pages from
different inodes seems enough. Another patch to add to my collection at
git.infradead.org/users/dwmw2/btrfs-kernel-unstable.git ...

From: David Woodhouse <David.Woodhouse@intel.com>
Date: Tue, 19 Aug 2008 15:45:16 +0100
Subject: [PATCH] Remove broken optimisations in end_bio functions.

These ended up freeing objects while they were still using them. Under
guidance from Chris, just rip out the 'clever' bits and do things the
simple way.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 extent_io.c |  159 ++++++++---------------------------------------------------
 1 files changed, 21 insertions(+), 138 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index f46f886..83ba0c3 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -15,6 +15,8 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "compat.h"
+#include "ctree.h"
+#include "btrfs_inode.h"
 
 /* temporary define until extent_map moves out of btrfs */
 struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
@@ -1394,15 +1396,11 @@ static int end_bio_extent_writepage(struct bio *bio,
 {
 	int uptodate = err == 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_state *state = bio->bi_private;
-	struct extent_io_tree *tree = state->tree;
-	struct rb_node *node;
+	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
-	u64 cur;
 	int whole_page;
 	int ret;
-	unsigned long flags;
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,23)
 	if (bio->bi_size)
@@ -1410,6 +1408,8 @@ static int end_bio_extent_writepage(struct bio *bio,
 #endif
 	do {
 		struct page *page = bvec->bv_page;
+		tree = &BTRFS_I(page->mapping->host)->io_tree;
+
 		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
 			 bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
@@ -1423,7 +1423,7 @@ static int end_bio_extent_writepage(struct bio *bio,
 			prefetchw(&bvec->bv_page->flags);
 		if (tree->ops && tree->ops->writepage_end_io_hook) {
 			ret = tree->ops->writepage_end_io_hook(page, start,
-						       end, state, uptodate);
+						       end, NULL, uptodate);
 			if (ret)
 				uptodate = 0;
 		}
@@ -1431,9 +1431,8 @@ static int end_bio_extent_writepage(struct bio *bio,
 		if (!uptodate && tree->ops &&
 		    tree->ops->writepage_io_failed_hook) {
 			ret = tree->ops->writepage_io_failed_hook(bio, page,
-							 start, end, state);
+							 start, end, NULL);
 			if (ret == 0) {
-				state = NULL;
 				uptodate = (err == 0);
 				continue;
 			}
@@ -1445,68 +1444,7 @@ static int end_bio_extent_writepage(struct bio *bio,
 			SetPageError(page);
 		}
 
-		/*
-		 * bios can get merged in funny ways, and so we need to
-		 * be careful with the state variable.  We know the
-		 * state won't be merged with others because it has
-		 * WRITEBACK set, but we can't be sure each biovec is
-		 * sequential in the file.  So, if our cached state
-		 * doesn't match the expected end, search the tree
-		 * for the correct one.
-		 */
-
-		spin_lock_irqsave(&tree->lock, flags);
-		if (!state || state->end != end) {
-			state = NULL;
-			node = __etree_search(tree, start, NULL, NULL);
-			if (node) {
-				state = rb_entry(node, struct extent_state,
-						 rb_node);
-				if (state->end != end ||
-				    !(state->state & EXTENT_WRITEBACK))
-					state = NULL;
-			}
-			if (!state) {
-				spin_unlock_irqrestore(&tree->lock, flags);
-				clear_extent_writeback(tree, start,
-						       end, GFP_ATOMIC);
-				goto next_io;
-			}
-		}
-		cur = end;
-		while(1) {
-			struct extent_state *clear = state;
-			cur = state->start;
-			node = rb_prev(&state->rb_node);
-			if (node) {
-				state = rb_entry(node,
-						 struct extent_state,
-						 rb_node);
-			} else {
-				state = NULL;
-			}
-
-			clear_state_bit(tree, clear, EXTENT_WRITEBACK,
-					1, 0);
-			if (cur == start)
-				break;
-			if (cur < start) {
-				WARN_ON(1);
-				break;
-			}
-			if (!node)
-				break;
-		}
-		/* before releasing the lock, make sure the next state
-		 * variable has the expected bits set and corresponds
-		 * to the correct offsets in the file
-		 */
-		if (state && (state->end + 1 != start ||
-		    !(state->state & EXTENT_WRITEBACK))) {
-			state = NULL;
-		}
-		spin_unlock_irqrestore(&tree->lock, flags);
-next_io:
+		clear_extent_writeback(tree, start, end, GFP_ATOMIC);
 
 		if (whole_page)
 			end_page_writeback(page);
@@ -1539,13 +1477,9 @@ static int end_bio_extent_readpage(struct bio *bio,
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_state *state = bio->bi_private;
-	struct extent_io_tree *tree = state->tree;
-	struct rb_node *node;
+	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
-	u64 cur;
-	unsigned long flags;
 	int whole_page;
 	int ret;
 
@@ -1556,6 +1490,8 @@ static int end_bio_extent_readpage(struct bio *bio,
 
 	do {
 		struct page *page = bvec->bv_page;
+		tree = &BTRFS_I(page->mapping->host)->io_tree;
+
 		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
 			bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
@@ -1570,80 +1506,26 @@ static int end_bio_extent_readpage(struct bio *bio,
 
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
-							      state);
+							      NULL);
 			if (ret)
 				uptodate = 0;
 		}
 		if (!uptodate && tree->ops &&
 		    tree->ops->readpage_io_failed_hook) {
 			ret = tree->ops->readpage_io_failed_hook(bio, page,
-							 start, end, state);
+							 start, end, NULL);
 			if (ret == 0) {
-				state = NULL;
 				uptodate =
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				continue;
 			}
 		}
 
-		spin_lock_irqsave(&tree->lock, flags);
-		if (!state || state->end != end) {
-			state = NULL;
-			node = __etree_search(tree, start, NULL, NULL);
-			if (node) {
-				state = rb_entry(node, struct extent_state,
-						 rb_node);
-				if (state->end != end ||
-				    !(state->state & EXTENT_LOCKED))
-					state = NULL;
-			}
-			if (!state) {
-				spin_unlock_irqrestore(&tree->lock, flags);
-				if (uptodate)
-					set_extent_uptodate(tree, start, end,
-							    GFP_ATOMIC);
-				unlock_extent(tree, start, end, GFP_ATOMIC);
-				goto next_io;
-			}
-		}
+		if (uptodate)
+			set_extent_uptodate(tree, start, end,
+					    GFP_ATOMIC);
+		unlock_extent(tree, start, end, GFP_ATOMIC);
 
-		cur = end;
-		while(1) {
-			struct extent_state *clear = state;
-			cur = state->start;
-			node = rb_prev(&state->rb_node);
-			if (node) {
-				state = rb_entry(node,
-					 struct extent_state,
-					 rb_node);
-			} else {
-				state = NULL;
-			}
-			if (uptodate) {
-				set_state_cb(tree, clear, EXTENT_UPTODATE);
-				clear->state |= EXTENT_UPTODATE;
-			}
-			clear_state_bit(tree, clear, EXTENT_LOCKED,
-					1, 0);
-			if (cur == start)
-				break;
-			if (cur < start) {
-				WARN_ON(1);
-				break;
-			}
-			if (!node)
-				break;
-		}
-		/* before releasing the lock, make sure the next state
-		 * variable has the expected bits set and corresponds
-		 * to the correct offsets in the file
-		 */
-		if (state && (state->end + 1 != start ||
-		    !(state->state & EXTENT_LOCKED))) {
-			state = NULL;
-		}
-		spin_unlock_irqrestore(&tree->lock, flags);
-next_io:
 		if (whole_page) {
 			if (uptodate) {
 				SetPageUptodate(page);
@@ -1683,8 +1565,7 @@ static int end_bio_extent_preparewrite(struct bio *bio,
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_state *state = bio->bi_private;
-	struct extent_io_tree *tree = state->tree;
+	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
 
@@ -1695,6 +1576,8 @@ static int end_bio_extent_preparewrite(struct bio *bio,
 
 	do {
 		struct page *page = bvec->bv_page;
+		tree = &BTRFS_I(page->mapping->host)->io_tree;
+
 		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
 			bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
@@ -1765,7 +1648,7 @@ static int submit_one_bio(int rw, struct bio *bio, int mirror_num)
 	BUG_ON(state->end != end);
 	spin_unlock_irq(&tree->lock);
 
-	bio->bi_private = state;
+	bio->bi_private = NULL;
 
 	bio_get(bio);
 
-- 
1.5.5.1




-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



