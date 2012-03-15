From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/5] Btrfs: use radix tree for checksum
Date: Thu, 15 Mar 2012 17:12:13 +0800
Message-ID: <1331802737-29454-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We used to issue a checksum to an extent state of 4K range for read endio,
but we want to use larger range for performance optimization, so instead we
create a radix tree for checksum, where an item stands for checksum of 4K data.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   86 ++++++++++++-------------------------------------
 fs/btrfs/extent_io.h |    2 +
 fs/btrfs/inode.c     |    7 +---
 3 files changed, 24 insertions(+), 71 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a55fbe6..e6433d4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -109,10 +109,12 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 {
 	tree->state = RB_ROOT;
 	INIT_RADIX_TREE(&tree->buffer, GFP_ATOMIC);
+	INIT_RADIX_TREE(&tree->csum, GFP_ATOMIC);
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
 	spin_lock_init(&tree->lock);
 	spin_lock_init(&tree->buffer_lock);
+	spin_lock_init(&tree->csum_lock);
 	tree->mapping = mapping;
 }
 
@@ -686,15 +688,6 @@ static void cache_state(struct extent_state *state,
 	}
 }
 
-static void uncache_state(struct extent_state **cached_ptr)
-{
-	if (cached_ptr && (*cached_ptr)) {
-		struct extent_state *state = *cached_ptr;
-		*cached_ptr = NULL;
-		free_extent_state(state);
-	}
-}
-
 /*
  * set some bits on a range in the tree.  This may require allocations or
  * sleeping, so the gfp mask is used to indicate what is allowed.
@@ -1649,56 +1642,32 @@ out:
  */
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 {
-	struct rb_node *node;
-	struct extent_state *state;
 	int ret = 0;
 
-	spin_lock(&tree->lock);
-	/*
-	 * this search will find all the extents that end after
-	 * our range starts.
-	 */
-	node = tree_search(tree, start);
-	if (!node) {
-		ret = -ENOENT;
-		goto out;
-	}
-	state = rb_entry(node, struct extent_state, rb_node);
-	if (state->start != start) {
-		ret = -ENOENT;
-		goto out;
-	}
-	state->private = private;
-out:
-	spin_unlock(&tree->lock);
+	spin_lock(&tree->csum_lock);
+	ret = radix_tree_insert(&tree->csum, (unsigned long)start,
+			       (void *)((unsigned long)private << 1));
+	BUG_ON(ret);
+	spin_unlock(&tree->csum_lock);
 	return ret;
 }
 
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 {
-	struct rb_node *node;
-	struct extent_state *state;
-	int ret = 0;
+	void **slot = NULL;
 
-	spin_lock(&tree->lock);
-	/*
-	 * this search will find all the extents that end after
-	 * our range starts.
-	 */
-	node = tree_search(tree, start);
-	if (!node) {
-		ret = -ENOENT;
-		goto out;
-	}
-	state = rb_entry(node, struct extent_state, rb_node);
-	if (state->start != start) {
-		ret = -ENOENT;
-		goto out;
+	spin_lock(&tree->csum_lock);
+	slot = radix_tree_lookup_slot(&tree->csum, (unsigned long)start);
+	if (!slot) {
+		spin_unlock(&tree->csum_lock);
+		return -ENOENT;
 	}
-	*private = state->private;
-out:
-	spin_unlock(&tree->lock);
-	return ret;
+	*private = (u64)(*slot) >> 1;
+
+	radix_tree_delete(&tree->csum, (unsigned long)start);
+	spin_unlock(&tree->csum_lock);
+
+	return 0;
 }
 
 /*
@@ -2266,7 +2235,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	do {
 		struct page *page = bvec->bv_page;
 		struct extent_state *cached = NULL;
-		struct extent_state *state;
 
 		pr_debug("end_bio_extent_readpage: bi_vcnt=%d, idx=%d, err=%d, "
 			 "mirror=%ld\n", bio->bi_vcnt, bio->bi_idx, err,
@@ -2285,20 +2253,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
 
-		spin_lock(&tree->lock);
-		state = find_first_extent_bit_state(tree, start, EXTENT_LOCKED);
-		if (state && state->start == start) {
-			/*
-			 * take a reference on the state, unlock will drop
-			 * the ref
-			 */
-			cache_state(state, &cached);
-		}
-		spin_unlock(&tree->lock);
-
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
-							      state);
+							      NULL);
 			if (ret)
 				uptodate = 0;
 			else
@@ -2325,13 +2282,12 @@ error_handled:
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
-				uncache_state(&cached);
 				continue;
 			}
 			if (tree->ops && tree->ops->readpage_io_failed_hook) {
 				ret = tree->ops->readpage_io_failed_hook(
 							bio, page, start, end,
-							failed_mirror, state);
+							failed_mirror, NULL);
 				if (ret == 0)
 					goto error_handled;
 			}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index cecc351..d85e361 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -95,10 +95,12 @@ struct extent_io_ops {
 struct extent_io_tree {
 	struct rb_root state;
 	struct radix_tree_root buffer;
+	struct radix_tree_root csum;
 	struct address_space *mapping;
 	u64 dirty_bytes;
 	spinlock_t lock;
 	spinlock_t buffer_lock;
+	spinlock_t csum_lock;
 	struct extent_io_ops *ops;
 };
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cbeb2e3..e9c4d6c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1867,12 +1867,7 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 		return 0;
 	}
 
-	if (state && state->start == start) {
-		private = state->private;
-		ret = 0;
-	} else {
-		ret = get_state_private(io_tree, start, &private);
-	}
+	ret = get_state_private(io_tree, start, &private);
 	kaddr = kmap_atomic(page, KM_USER0);
 	if (ret)
 		goto zeroit;
-- 
1.6.5.2

