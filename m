From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 07/99] btrfs: Use mempools for extent_state structures
Date: Wed, 23 Nov 2011 19:35:40 -0500
Message-ID: <20111124004220.628076319@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The extent_state structure is used at the core of the extent i/o code
 for managing flags, locking, etc. It requires allocations deep in the
 write code and if failures occur they are difficult to recover from.

 We avoid most of the failures by using a mempool, which can sleep when
 required, to honor the allocations. This allows future patches to convert
 most of the {set,clear,convert}_extent_bit and derivatives to return
 void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   71 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 20 deletions(-)

Index: source/fs/btrfs/extent_io.c
===================================================================
--- source.orig/fs/btrfs/extent_io.c	2011-11-21 14:13:55.000000000 -0500
+++ source/fs/btrfs/extent_io.c	2011-11-21 14:38:23.000000000 -0500
@@ -12,6 +12,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/mempool.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "compat.h"
@@ -21,6 +22,8 @@
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
+static mempool_t *extent_state_pool;
+#define EXTENT_STATE_POOL_SIZE (64*1024)
 
 static LIST_HEAD(buffers);
 static LIST_HEAD(states);
@@ -61,18 +64,28 @@ tree_fs_info(struct extent_io_tree *tree
 int __init extent_io_init(void)
 {
 	extent_state_cache = kmem_cache_create("extent_state",
-			sizeof(struct extent_state), 0,
-			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+				        sizeof(struct extent_state), 0,
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					NULL);
 	if (!extent_state_cache)
 		return -ENOMEM;
 
+	extent_state_pool = mempool_create_slab_pool(
+						EXTENT_STATE_POOL_SIZE /
+						sizeof(struct extent_state),
+						extent_state_cache);
+	if (!extent_state_pool)
+		goto free_state_cache;
+
 	extent_buffer_cache = kmem_cache_create("extent_buffers",
 			sizeof(struct extent_buffer), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_buffer_cache)
-		goto free_state_cache;
+		goto free_state_mempool;
 	return 0;
 
+free_state_mempool:
+	mempool_destroy(extent_state_pool);
 free_state_cache:
 	kmem_cache_destroy(extent_state_cache);
 	return -ENOMEM;
@@ -103,6 +116,8 @@ void extent_io_exit(void)
 		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
+	if (extent_state_pool)
+		mempool_destroy(extent_state_pool);
 	if (extent_state_cache)
 		kmem_cache_destroy(extent_state_cache);
 	if (extent_buffer_cache)
@@ -128,7 +143,7 @@ static struct extent_state *alloc_extent
 	unsigned long flags;
 #endif
 
-	state = kmem_cache_alloc(extent_state_cache, mask);
+	state = mempool_alloc(extent_state_pool, mask);
 	if (!state)
 		return state;
 	state->state = 0;
@@ -145,6 +160,12 @@ static struct extent_state *alloc_extent
 	return state;
 }
 
+static struct extent_state *alloc_extent_state_nofail(gfp_t mask)
+{
+	BUG_ON(!(mask & __GFP_WAIT));
+	return alloc_extent_state(mask);
+}
+
 void free_extent_state(struct extent_state *state)
 {
 	if (!state)
@@ -160,7 +181,7 @@ void free_extent_state(struct extent_sta
 		spin_unlock_irqrestore(&leak_lock, flags);
 #endif
 		trace_free_extent_state(state, _RET_IP_);
-		kmem_cache_free(extent_state_cache, state);
+		mempool_free(state, extent_state_pool);
 	}
 }
 
@@ -437,6 +458,12 @@ static int clear_state_bit(struct extent
 	return ret;
 }
 
+static void
+assert_atomic_alloc(struct extent_state *prealloc, gfp_t mask)
+{
+	WARN_ON(!prealloc && (mask & __GFP_WAIT));
+}
+
 static struct extent_state *
 alloc_extent_state_atomic(struct extent_state *prealloc)
 {
@@ -464,6 +491,7 @@ NORET_TYPE void extent_io_tree_panic(str
  * the range [start, end] is inclusive.
  *
  * This takes the tree lock, and returns 0 on success and < 0 on error.
+ * If (mask & __GFP_WAIT) == 0, there are no error conditions.
  */
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     int bits, int wake, int delete,
@@ -486,11 +514,8 @@ int clear_extent_bit(struct extent_io_tr
 	if (bits & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		clear = 1;
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
-		prealloc = alloc_extent_state(mask);
-		if (!prealloc)
-			return -ENOMEM;
-	}
+	if (!prealloc && (mask & __GFP_WAIT))
+		prealloc = alloc_extent_state_nofail(mask);
 
 	spin_lock(&tree->lock);
 	if (cached_state) {
@@ -542,6 +567,7 @@ hit_next:
 	 */
 
 	if (state->start < start) {
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
@@ -566,6 +592,7 @@ hit_next:
 	 * on the first half
 	 */
 	if (state->start <= end && state->end > end) {
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
@@ -726,15 +753,14 @@ int set_extent_bit(struct extent_io_tree
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
 	int err = 0;
+	int wait = mask & __GFP_WAIT;
 	u64 last_start;
 	u64 last_end;
 
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
-		prealloc = alloc_extent_state(mask);
-		BUG_ON(!prealloc);
-	}
+	if (!prealloc && wait)
+		prealloc = alloc_extent_state_nofail(mask);
 
 	spin_lock(&tree->lock);
 	if (cached_state && *cached_state) {
@@ -751,6 +777,7 @@ again:
 	 */
 	node = tree_search(tree, start);
 	if (!node) {
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
@@ -820,6 +847,7 @@ hit_next:
 			goto out;
 		}
 
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
@@ -853,6 +881,7 @@ hit_next:
 		else
 			this_end = last_start - 1;
 
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 
@@ -883,6 +912,7 @@ hit_next:
 			goto out;
 		}
 
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
@@ -909,7 +939,7 @@ search_again:
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
-	if (mask & __GFP_WAIT)
+	if (wait)
 		cond_resched();
 	goto again;
 }
@@ -940,11 +970,8 @@ int convert_extent_bit(struct extent_io_
 	u64 last_end;
 
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
-		prealloc = alloc_extent_state(mask);
-		if (!prealloc)
-			return -ENOMEM;
-	}
+	if (!prealloc && (mask & __GFP_WAIT))
+		prealloc = alloc_extent_state_nofail(mask);
 
 	spin_lock(&tree->lock);
 	/*
@@ -953,6 +980,7 @@ again:
 	 */
 	node = tree_search(tree, start);
 	if (!node) {
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc)
 			return -ENOMEM;
@@ -1010,6 +1038,7 @@ hit_next:
 	 * desired bit on it.
 	 */
 	if (state->start < start) {
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc)
 			return -ENOMEM;
@@ -1042,6 +1071,7 @@ hit_next:
 		else
 			this_end = last_start - 1;
 
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc)
 			return -ENOMEM;
@@ -1069,6 +1099,7 @@ hit_next:
 	 * on the first half
 	 */
 	if (state->start <= end && state->end > end) {
+		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc)
 			return -ENOMEM;



