From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: save preloaded extent_state's in a percpu cache
Date: Mon, 20 Jun 2011 14:24:55 -0400
Message-ID: <1308594295-20076-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When doing DIO tracing I noticed we were doing a ton of allocations, a lot of
the time for extent_states.  Some of the time we don't even use the prealloc'ed
extent_state, it just get's free'd up.  So instead create a per-cpu cache like
the radix tree stuff.  So we will check to see if our per-cpu cache has a
prealloc'ed extent_state in it and if so we just continue, else we alloc a new
one and fill the cache.  Then if we need to use a prealloc'ed extent_state we
can just take it out of our per-cpu cache.  We will also refill the cache on
free to try and limit the number of times we have to ask the allocator for
caches.  With this patch dbench 50 goes from ~210 mb/s to ~260 mb/s.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |  163 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 124 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7055d11..3a33c11 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -12,6 +12,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/cpu.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "compat.h"
@@ -31,6 +32,8 @@ static DEFINE_SPINLOCK(leak_lock);
 
 #define BUFFER_LRU_MAX 64
 
+static DEFINE_PER_CPU(struct extent_state *, extent_state_preloads) = NULL;
+
 struct tree_entry {
 	u64 start;
 	u64 end;
@@ -71,10 +74,36 @@ free_state_cache:
 	return -ENOMEM;
 }
 
+static void __free_extent_state(struct extent_state *state)
+{
+	if (!state)
+		return;
+	if (atomic_dec_and_test(&state->refs)) {
+#if LEAK_DEBUG
+		unsigned long flags;
+#endif
+		WARN_ON(state->tree);
+#if LEAK_DEBUG
+		spin_lock_irqsave(&leak_lock, flags);
+		list_del(&state->leak_list);
+		spin_unlock_irqrestore(&leak_lock, flags);
+#endif
+		kmem_cache_free(extent_state_cache, state);
+	}
+}
 void extent_io_exit(void)
 {
 	struct extent_state *state;
 	struct extent_buffer *eb;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		state = per_cpu(extent_state_preloads, cpu);
+		if (!state)
+			continue;
+		per_cpu(extent_state_preloads, cpu) = NULL;
+		__free_extent_state(state);
+	}
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
@@ -114,16 +143,11 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 	tree->mapping = mapping;
 }
 
-static struct extent_state *alloc_extent_state(gfp_t mask)
+static void init_extent_state(struct extent_state *state)
 {
-	struct extent_state *state;
 #if LEAK_DEBUG
 	unsigned long flags;
 #endif
-
-	state = kmem_cache_alloc(extent_state_cache, mask);
-	if (!state)
-		return state;
 	state->state = 0;
 	state->private = 0;
 	state->tree = NULL;
@@ -134,6 +158,16 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 #endif
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
+}
+
+static struct extent_state *alloc_extent_state(gfp_t mask)
+{
+	struct extent_state *state;
+
+	state = kmem_cache_alloc(extent_state_cache, mask);
+	if (!state)
+		return state;
+	init_extent_state(state);
 	return state;
 }
 
@@ -142,6 +176,7 @@ void free_extent_state(struct extent_state *state)
 	if (!state)
 		return;
 	if (atomic_dec_and_test(&state->refs)) {
+		struct extent_state *tmp;
 #if LEAK_DEBUG
 		unsigned long flags;
 #endif
@@ -151,10 +186,53 @@ void free_extent_state(struct extent_state *state)
 		list_del(&state->leak_list);
 		spin_unlock_irqrestore(&leak_lock, flags);
 #endif
-		kmem_cache_free(extent_state_cache, state);
+		preempt_disable();
+		tmp = __get_cpu_var(extent_state_preloads);
+		if (!tmp) {
+			init_extent_state(state);
+			__get_cpu_var(extent_state_preloads) = state;
+		} else {
+			kmem_cache_free(extent_state_cache, state);
+		}
+		preempt_enable();
 	}
 }
 
+/*
+ * Pre-load an extent state.
+ */
+static int extent_state_preload(gfp_t mask)
+{
+	struct extent_state *state;
+
+	preempt_disable();
+	state = __get_cpu_var(extent_state_preloads);
+	if (!state) {
+		struct extent_state *tmp;
+		preempt_enable();
+		tmp = alloc_extent_state(mask);
+		if (!tmp)
+			return -ENOMEM;
+		preempt_disable();
+		state = __get_cpu_var(extent_state_preloads);
+		if (state)
+			free_extent_state(tmp);
+		else
+			__get_cpu_var(extent_state_preloads) = tmp;
+	}
+
+	return 0;
+}
+
+/*
+ * Just re-enable preemption, this is here to make patch reviewing easier, to
+ * make sure we match up extent_state_preloads with the end() properly.
+ */
+static void extent_state_preload_end(void)
+{
+	preempt_enable();
+}
+
 static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 				   struct rb_node *node)
 {
@@ -441,13 +519,24 @@ static int clear_state_bit(struct extent_io_tree *tree,
 	return ret;
 }
 
-static struct extent_state *
-alloc_extent_state_atomic(struct extent_state *prealloc)
+static struct extent_state *get_prealloc_state(void)
 {
-	if (!prealloc)
-		prealloc = alloc_extent_state(GFP_ATOMIC);
+	struct extent_state *state;
 
-	return prealloc;
+	state = __get_cpu_var(extent_state_preloads);
+	__get_cpu_var(extent_state_preloads) = NULL;
+	return state;
+}
+
+static struct extent_state *alloc_extent_state_atomic(void)
+{
+	struct extent_state *state;
+
+	state = get_prealloc_state();
+	if (!state)
+		state = alloc_extent_state(GFP_ATOMIC);
+
+	return state;
 }
 
 /*
@@ -477,6 +566,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err;
 	int set = 0;
 	int clear = 0;
+	bool preload = !(mask & __GFP_WAIT);
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -485,9 +575,8 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (bits & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		clear = 1;
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
-		prealloc = alloc_extent_state(mask);
-		if (!prealloc)
+	if (!prealloc && preload) {
+		if (extent_state_preload(mask))
 			return -ENOMEM;
 	}
 
@@ -540,11 +629,10 @@ hit_next:
 	 */
 
 	if (state->start < start) {
-		prealloc = alloc_extent_state_atomic(prealloc);
+		prealloc = alloc_extent_state_atomic();
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
-		prealloc = NULL;
 		if (err)
 			goto out;
 		if (state->end <= end) {
@@ -562,7 +650,7 @@ hit_next:
 	 * on the first half
 	 */
 	if (state->start <= end && state->end > end) {
-		prealloc = alloc_extent_state_atomic(prealloc);
+		prealloc = alloc_extent_state_atomic();
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
@@ -571,7 +659,6 @@ hit_next:
 
 		set |= clear_state_bit(tree, prealloc, &bits, wake);
 
-		prealloc = NULL;
 		goto out;
 	}
 
@@ -594,8 +681,8 @@ hit_next:
 
 out:
 	spin_unlock(&tree->lock);
-	if (prealloc)
-		free_extent_state(prealloc);
+	if (preload)
+		extent_state_preload_end();
 
 	return set;
 
@@ -603,8 +690,10 @@ search_again:
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
-	if (mask & __GFP_WAIT)
+	if (preload) {
+		extent_state_preload_end();
 		cond_resched();
+	}
 	goto again;
 }
 
@@ -731,12 +820,13 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
+	bool preload = !(mask & __GFP_WAIT);
 
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
-	if (!prealloc && (mask & __GFP_WAIT)) {
-		prealloc = alloc_extent_state(mask);
-		BUG_ON(!prealloc);
+	if (!prealloc && preload) {
+		if (extent_state_preload(mask))
+			return -ENOMEM;
 	}
 
 	spin_lock(&tree->lock);
@@ -753,10 +843,9 @@ again:
 	 */
 	node = tree_search(tree, start);
 	if (!node) {
-		prealloc = alloc_extent_state_atomic(prealloc);
+		prealloc = alloc_extent_state_atomic();
 		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
-		prealloc = NULL;
 		BUG_ON(err == -EEXIST);
 		goto out;
 	}
@@ -822,11 +911,10 @@ hit_next:
 			goto out;
 		}
 
-		prealloc = alloc_extent_state_atomic(prealloc);
+		prealloc = alloc_extent_state_atomic();
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
-		prealloc = NULL;
 		if (err)
 			goto out;
 		if (state->end <= end) {
@@ -855,7 +943,7 @@ hit_next:
 		else
 			this_end = last_start - 1;
 
-		prealloc = alloc_extent_state_atomic(prealloc);
+		prealloc = alloc_extent_state_atomic();
 		BUG_ON(!prealloc);
 
 		/*
@@ -868,12 +956,10 @@ hit_next:
 		BUG_ON(err == -EEXIST);
 		if (err) {
 			free_extent_state(prealloc);
-			prealloc = NULL;
 			goto out;
 		}
 		cache_state(prealloc, cached_state);
 		free_extent_state(prealloc);
-		prealloc = NULL;
 		start = this_end + 1;
 		goto search_again;
 	}
@@ -890,19 +976,16 @@ hit_next:
 			goto out;
 		}
 
-		prealloc = alloc_extent_state_atomic(prealloc);
+		prealloc = alloc_extent_state_atomic();
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
 
 		err = set_state_bits(tree, prealloc, &bits);
-		if (err) {
-			prealloc = NULL;
+		if (err)
 			goto out;
-		}
 		cache_state(prealloc, cached_state);
 		merge_state(tree, prealloc);
-		prealloc = NULL;
 		goto out;
 	}
 
@@ -910,8 +993,8 @@ hit_next:
 
 out:
 	spin_unlock(&tree->lock);
-	if (prealloc)
-		free_extent_state(prealloc);
+	if (preload)
+		extent_state_preload_end();
 
 	return err;
 
@@ -919,6 +1002,8 @@ search_again:
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
+	if (preload)
+		extent_state_preload_end();
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
-- 
1.7.5.2

