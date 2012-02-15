From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH] Btrfs: batch merge state at endio time
Date: Wed, 15 Feb 2012 18:04:00 +0800
Message-ID: <1329300240-26550-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <dave@jikos.cz>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This RFC patch is intended to make our extent state code more rcu friendly.

o Since IO related extents in the tree will not be merged or changed,
  we can safely clear the extents's lock flags at endio time.

o After clearing flags, we will merge the adjacent extents when their states
  are equal, where we may change the tree.

o If we manage to batch the merge part(now we're conservative and make a batch
  per bio), we will get to reduce write locks in endio and it will somewhat
  improve the read performance.

o Since this is a RFC one, I've just passed xfstests without further tests.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |  434 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.h |    5 +-
 2 files changed, 382 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 49f3c9d..0cced4d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -110,7 +110,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 	INIT_RADIX_TREE(&tree->buffer, GFP_ATOMIC);
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
-	spin_lock_init(&tree->lock);
+	rwlock_init(&tree->lock);
 	spin_lock_init(&tree->buffer_lock);
 	tree->mapping = mapping;
 }
@@ -391,17 +391,19 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 	return 0;
 }
 
-/*
- * utility function to clear some bits in an extent state struct.
- * it will optionally wake up any one waiting on this state (wake == 1), or
- * forcibly remove the state from the tree (delete == 1).
- *
- * If no bits are set on the state struct after clearing things, the
- * struct is freed and removed from the tree
- */
-static int clear_state_bit(struct extent_io_tree *tree,
-			    struct extent_state *state,
-			    int *bits, int wake)
+static struct extent_state *
+alloc_extent_state_atomic(struct extent_state *prealloc)
+{
+	if (!prealloc)
+		prealloc = alloc_extent_state(GFP_ATOMIC);
+
+	return prealloc;
+}
+
+#define RCU_FRIENDLY_CODE 1
+#if RCU_FRIENDLY_CODE
+static int __clear_state_bit(struct extent_io_tree *tree,
+			     struct extent_state *state, int *bits, int wake)
 {
 	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
 	int ret = state->state & bits_to_clear;
@@ -415,6 +417,12 @@ static int clear_state_bit(struct extent_io_tree *tree,
 	state->state &= ~bits_to_clear;
 	if (wake)
 		wake_up(&state->wq);
+	return ret;
+}
+
+static void try_free_or_merge_state(struct extent_io_tree *tree,
+				    struct extent_state *state)
+{
 	if (state->state == 0) {
 		if (state->tree) {
 			rb_erase(&state->rb_node, &tree->state);
@@ -426,19 +434,304 @@ static int clear_state_bit(struct extent_io_tree *tree,
 	} else {
 		merge_state(tree, state);
 	}
+}
+
+/*
+ * utility function to clear some bits in an extent state struct.
+ * it will optionally wake up any one waiting on this state (wake == 1), or
+ * forcibly remove the state from the tree (delete == 1).
+ *
+ * If no bits are set on the state struct after clearing things, the
+ * struct is freed and removed from the tree
+ */
+static int clear_state_bit(struct extent_io_tree *tree,
+			   struct extent_state *state, int *bits, int wake)
+{
+	int ret;
+
+	ret = __clear_state_bit(tree, state, bits, wake);
+	try_free_or_merge_state(tree, state);
+
 	return ret;
 }
 
-static struct extent_state *
-alloc_extent_state_atomic(struct extent_state *prealloc)
+static noinline void batch_merge_state(struct extent_io_tree *tree,
+				       struct extent_state *state)
 {
-	if (!prealloc)
-		prealloc = alloc_extent_state(GFP_ATOMIC);
+	struct extent_state *other;
+	struct rb_node *other_node;
 
-	return prealloc;
+	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
+		return;
+
+	while (1) {
+		other_node = rb_prev(&state->rb_node);
+		if (!other_node)
+			break;
+
+		other = rb_entry(other_node, struct extent_state, rb_node);
+		if (other->end == state->start - 1 &&
+		    other->state == state->state) {
+			merge_cb(tree, state, other);
+			state->start = other->start;
+			other->tree = NULL;
+			rb_erase(&other->rb_node, &tree->state);
+			free_extent_state(other);
+		} else {
+			break;
+		}
+	}
+
+	while (1) {
+		other_node = rb_next(&state->rb_node);
+		if (!other_node)
+			break;
+
+		other = rb_entry(other_node, struct extent_state, rb_node);
+		if (other->start == state->end + 1 &&
+		    other->state == state->state) {
+			merge_cb(tree, state, other);
+			state->end = other->end;
+			other->tree = NULL;
+			rb_erase(&other->rb_node, &tree->state);
+			free_extent_state(other);
+		} else {
+			break;
+		}
+	}
 }
 
 /*
+ * get into process_merge_state if return 1, otherwise just go ahead.
+ */
+static int test_merge_state(struct extent_io_tree *tree,
+			    struct extent_state *state)
+{
+	struct extent_state *other;
+	struct rb_node *other_node;
+
+	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
+		return 0;
+
+	other_node = rb_prev(&state->rb_node);
+	if (other_node) {
+		other = rb_entry(other_node, struct extent_state, rb_node);
+		if (other->end == state->start - 1 &&
+		    other->state == state->state)
+			return 1;
+	}
+	other_node = rb_next(&state->rb_node);
+	if (other_node) {
+		other = rb_entry(other_node, struct extent_state, rb_node);
+		if (other->start == state->end + 1 &&
+		    other->state == state->state)
+			return 1;
+	}
+
+	return 0;
+}
+
+static void process_merge_state(struct extent_io_tree *tree, u64 start)
+{
+	struct extent_state *state = NULL;
+	struct rb_node *node = NULL;
+
+	if (!tree || start == (u64)-1) {
+		WARN_ON(1);
+		return;
+	}
+
+	write_lock(&tree->lock);
+	node = tree_search(tree, start);
+	if (!node) {
+		printk(KERN_INFO "write side: not find states"
+		       " to merge %llu\n", start);
+		goto out;
+	}
+	state = rb_entry(node, struct extent_state, rb_node);
+	/* should merge all states around this one */
+	batch_merge_state(tree, state);
+out:
+	write_unlock(&tree->lock);
+}
+
+int clear_extent_bit_ro(struct extent_io_tree *tree, u64 start, u64 end,
+			int bits, int wake, int delete,
+			struct extent_state **cached_state,
+			gfp_t mask)
+{
+	struct extent_state *state;
+	struct extent_state *cached;
+	struct rb_node *next_node;
+	struct rb_node *node;
+	u64 last_end;
+	int set = 0;
+	int clear = 0;
+	int merge = 0;
+
+	if (delete)
+		bits |= ~EXTENT_CTLBITS;
+	bits |= EXTENT_FIRST_DELALLOC;
+
+	if (bits & (EXTENT_IOBITS | EXTENT_BOUNDARY))
+		clear = 1;
+
+again:
+	read_lock(&tree->lock);
+	if (cached_state) {
+		cached = *cached_state;
+
+		if (clear) {
+			*cached_state = NULL;
+			cached_state = NULL;
+		}
+
+		if (cached && cached->tree && cached->start <= start &&
+		    cached->end > start) {
+			if (clear)
+				atomic_dec(&cached->refs);
+			state = cached;
+			goto hit_next;
+		}
+		if (clear)
+			free_extent_state(cached);
+	}
+	/*
+	 * this search will find the extents that end after
+	 * our range starts
+	 */
+	node = tree_search(tree, start);
+	if (!node)
+		goto out;
+	state = rb_entry(node, struct extent_state, rb_node);
+hit_next:
+	if (state->start > end)
+		goto out;
+	WARN_ON(state->start < start || state->end > end);
+	WARN_ON(state->end < start);
+	last_end = state->end;
+
+	if (state->end < end && !need_resched())
+		next_node = rb_next(&state->rb_node);
+	else
+		next_node = NULL;
+
+	set |= __clear_state_bit(tree, state, &bits, wake);
+
+	/* batch merge ones */
+	merge = test_merge_state(tree, state);
+
+	if (last_end == (u64)-1)
+		goto out;
+	start = last_end + 1;
+	if (start <= end && next_node) {
+		state = rb_entry(next_node, struct extent_state,
+				 rb_node);
+		if (state->start == start)
+			goto hit_next;
+	}
+	goto search_again;
+
+out:
+	read_unlock(&tree->lock);
+
+	if (merge)
+		set |= EXTENT_MERGE;
+	return set;
+
+search_again:
+	if (start > end)
+		goto out;
+	read_unlock(&tree->lock);
+	if (mask & __GFP_WAIT)
+		cond_resched();
+	goto again;
+}
+
+static void cache_state(struct extent_state *state,
+			struct extent_state **cached_ptr);
+
+int set_extent_bit_ro(struct extent_io_tree *tree, u64 start, u64 end,
+		   int bits, int exclusive_bits, u64 *failed_start,
+		   struct extent_state **cached_state, gfp_t mask)
+{
+	struct extent_state *state;
+	struct rb_node *node;
+	int err = 0;
+	u64 last_start;
+	u64 last_end;
+
+	bits |= EXTENT_FIRST_DELALLOC;
+	WARN_ON(!(mask & GFP_ATOMIC));
+again:
+	read_lock(&tree->lock);
+	if (cached_state && *cached_state) {
+		state = *cached_state;
+		if (state->start <= start && state->end > start &&
+		    state->tree) {
+			node = &state->rb_node;
+			goto hit_next;
+		}
+	}
+	/*
+	 * this search will find all the extents that end after
+	 * our range starts.
+	 */
+	node = tree_search(tree, start);
+	BUG_ON(!node);
+	state = rb_entry(node, struct extent_state, rb_node);
+hit_next:
+	last_start = state->start;
+	last_end = state->end;
+
+	/*
+	 * | ---- desired range ---- |
+	 * | state |
+	 *
+	 * Just lock what we found and keep going
+	 */
+	if (state->start == start && state->end <= end) {
+		struct rb_node *next_node;
+		if (state->state & exclusive_bits) {
+			*failed_start = state->start;
+			err = -EEXIST;
+			goto out;
+		}
+
+		set_state_bits(tree, state, &bits);
+
+		cache_state(state, cached_state);
+
+		if (last_end == (u64)-1)
+			goto out;
+
+		start = last_end + 1;
+		if (state->end < end)
+			next_node = rb_next(&state->rb_node);
+		else
+			next_node = NULL;
+		if (next_node && start < end) {
+			state = rb_entry(next_node, struct extent_state,
+					 rb_node);
+			if (state->start == start)
+				goto hit_next;
+		}
+		goto search_again;
+	}
+	WARN_ON(1);
+	goto search_again;
+out:
+	read_unlock(&tree->lock);
+	return err;
+search_again:
+	if (start > end)
+		goto out;
+	read_unlock(&tree->lock);
+	goto again;
+}
+#endif
+
+/*
  * clear some bits on a range in the tree.  This may require splitting
  * or inserting elements in the tree, so the gfp mask is used to
  * indicate which allocations or sleeping are allowed.
@@ -479,7 +772,7 @@ again:
 			return -ENOMEM;
 	}
 
-	spin_lock(&tree->lock);
+	write_lock(&tree->lock);
 	if (cached_state) {
 		cached = *cached_state;
 
@@ -582,7 +875,7 @@ hit_next:
 	goto search_again;
 
 out:
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (prealloc)
 		free_extent_state(prealloc);
 
@@ -591,7 +884,7 @@ out:
 search_again:
 	if (start > end)
 		goto out;
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
@@ -604,9 +897,9 @@ static int wait_on_state(struct extent_io_tree *tree,
 {
 	DEFINE_WAIT(wait);
 	prepare_to_wait(&state->wq, &wait, TASK_UNINTERRUPTIBLE);
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	schedule();
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	finish_wait(&state->wq, &wait);
 	return 0;
 }
@@ -621,7 +914,7 @@ int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 	struct extent_state *state;
 	struct rb_node *node;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 again:
 	while (1) {
 		/*
@@ -649,10 +942,12 @@ again:
 		if (start > end)
 			break;
 
-		cond_resched_lock(&tree->lock);
+		read_unlock(&tree->lock);
+		cond_resched();
+		read_lock(&tree->lock);
 	}
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return 0;
 }
 
@@ -719,7 +1014,7 @@ again:
 		BUG_ON(!prealloc);
 	}
 
-	spin_lock(&tree->lock);
+	write_lock(&tree->lock);
 	if (cached_state && *cached_state) {
 		state = *cached_state;
 		if (state->start <= start && state->end > start &&
@@ -880,7 +1175,7 @@ hit_next:
 	goto search_again;
 
 out:
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (prealloc)
 		free_extent_state(prealloc);
 
@@ -889,7 +1184,7 @@ out:
 search_again:
 	if (start > end)
 		goto out;
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
@@ -927,7 +1222,7 @@ again:
 			return -ENOMEM;
 	}
 
-	spin_lock(&tree->lock);
+	write_lock(&tree->lock);
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
@@ -1076,7 +1371,7 @@ hit_next:
 	goto search_again;
 
 out:
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (prealloc)
 		free_extent_state(prealloc);
 
@@ -1085,7 +1380,7 @@ out:
 search_again:
 	if (start > end)
 		goto out;
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
@@ -1135,6 +1430,14 @@ int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 			      NULL, mask);
 }
 
+int set_extent_uptodate_ro(struct extent_io_tree *tree, u64 start, u64 end,
+			   struct extent_state **cached_state, gfp_t mask)
+{
+	WARN_ON(!(mask & GFP_ATOMIC));
+	return set_extent_bit_ro(tree, start, end, EXTENT_UPTODATE, 0,
+				 NULL, cached_state, mask);
+}
+
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask)
 {
@@ -1196,6 +1499,13 @@ int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 	return 1;
 }
 
+int unlock_extent_cached_ro(struct extent_io_tree *tree, u64 start, u64 end,
+			    struct extent_state **cached, gfp_t mask)
+{
+	return clear_extent_bit_ro(tree, start, end, EXTENT_LOCKED, 1, 0,
+				   cached, mask);
+}
+
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask)
 {
@@ -1272,14 +1582,14 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 	struct extent_state *state;
 	int ret = 1;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	state = find_first_extent_bit_state(tree, start, bits);
 	if (state) {
 		*start_ret = state->start;
 		*end_ret = state->end;
 		ret = 0;
 	}
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return ret;
 }
 
@@ -1299,7 +1609,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 found = 0;
 	u64 total_bytes = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 
 	/*
 	 * this search will find all the extents that end after
@@ -1339,7 +1649,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			break;
 	}
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return found;
 }
 
@@ -1602,7 +1912,7 @@ u64 count_range_bits(struct extent_io_tree *tree,
 		return 0;
 	}
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	if (cur_start == 0 && bits == EXTENT_DIRTY) {
 		total_bytes = tree->dirty_bytes;
 		goto out;
@@ -1639,7 +1949,7 @@ u64 count_range_bits(struct extent_io_tree *tree,
 			break;
 	}
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return total_bytes;
 }
 
@@ -1653,7 +1963,7 @@ int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 	struct extent_state *state;
 	int ret = 0;
 
-	spin_lock(&tree->lock);
+	write_lock(&tree->lock);
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
@@ -1670,7 +1980,7 @@ int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 	}
 	state->private = private;
 out:
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	return ret;
 }
 
@@ -1680,7 +1990,7 @@ int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 	struct extent_state *state;
 	int ret = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
@@ -1697,7 +2007,7 @@ int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 	}
 	*private = state->private;
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return ret;
 }
 
@@ -1714,7 +2024,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct rb_node *node;
 	int bitset = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	if (cached && cached->tree && cached->start <= start &&
 	    cached->end > start)
 		node = &cached->rb_node;
@@ -1753,7 +2063,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 			break;
 		}
 	}
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return bitset;
 }
 
@@ -1950,11 +2260,11 @@ static int clean_io_failure(u64 start, struct page *page)
 		goto out;
 	}
 
-	spin_lock(&BTRFS_I(inode)->io_tree.lock);
+	read_lock(&BTRFS_I(inode)->io_tree.lock);
 	state = find_first_extent_bit_state(&BTRFS_I(inode)->io_tree,
 					    failrec->start,
 					    EXTENT_LOCKED);
-	spin_unlock(&BTRFS_I(inode)->io_tree.lock);
+	read_unlock(&BTRFS_I(inode)->io_tree.lock);
 
 	if (state && state->start == failrec->start) {
 		map_tree = &BTRFS_I(inode)->root->fs_info->mapping_tree;
@@ -2088,12 +2398,12 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 	}
 
 	if (!state) {
-		spin_lock(&tree->lock);
+		read_lock(&tree->lock);
 		state = find_first_extent_bit_state(tree, failrec->start,
 						    EXTENT_LOCKED);
 		if (state && state->start != failrec->start)
 			state = NULL;
-		spin_unlock(&tree->lock);
+		read_unlock(&tree->lock);
 	}
 
 	/*
@@ -2245,6 +2555,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
+	u64 merge_start = (u64)-1;
+	unsigned long merge = 0;
 	int whole_page;
 	int ret;
 
@@ -2273,7 +2585,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
 
-		spin_lock(&tree->lock);
+		read_lock(&tree->lock);
 		state = find_first_extent_bit_state(tree, start, EXTENT_LOCKED);
 		if (state && state->start == start) {
 			/*
@@ -2282,7 +2594,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 */
 			cache_state(state, &cached);
 		}
-		spin_unlock(&tree->lock);
+		read_unlock(&tree->lock);
 
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
@@ -2326,10 +2638,17 @@ error_handled:
 		}
 
 		if (uptodate) {
-			set_extent_uptodate(tree, start, end, &cached,
-					    GFP_ATOMIC);
+			/* for readonly */
+			set_extent_uptodate_ro(tree, start, end, &cached,
+					GFP_ATOMIC);
+			merge |= unlock_extent_cached_ro(tree, start, end,
+							 &cached, GFP_ATOMIC);
+			if (merge & EXTENT_MERGE)
+				merge_start = min(start, merge_start);
+		} else {
+			unlock_extent_cached(tree, start, end, &cached,
+							 GFP_ATOMIC);
 		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
 
 		if (whole_page) {
 			if (uptodate) {
@@ -2350,6 +2669,9 @@ error_handled:
 		}
 	} while (bvec <= bvec_end);
 
+	if (merge & EXTENT_MERGE)
+		process_merge_state(tree, merge_start);
+
 	bio_put(bio);
 }
 
@@ -2552,8 +2874,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			kunmap_atomic(userpage, KM_USER0);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
-			unlock_extent_cached(tree, cur, cur + iosize - 1,
-					     &cached, GFP_NOFS);
+			unlock_extent_cached_ro(tree, cur, cur + iosize - 1,
+						&cached, GFP_NOFS);
 			break;
 		}
 		em = get_extent(inode, page, pg_offset, cur,
@@ -2602,8 +2924,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
-			unlock_extent_cached(tree, cur, cur + iosize - 1,
-			                     &cached, GFP_NOFS);
+			unlock_extent_cached_ro(tree, cur, cur + iosize - 1,
+						&cached, GFP_NOFS);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7604c30..f878aae 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -19,6 +19,7 @@
 #define EXTENT_FIRST_DELALLOC (1 << 12)
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
+#define EXTENT_MERGE (1 << 15)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -97,7 +98,7 @@ struct extent_io_tree {
 	struct radix_tree_root buffer;
 	struct address_space *mapping;
 	u64 dirty_bytes;
-	spinlock_t lock;
+	rwlock_t lock;
 	spinlock_t buffer_lock;
 	struct extent_io_ops *ops;
 };
@@ -186,6 +187,8 @@ int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask);
+int unlock_extent_cached_ro(struct extent_io_tree *tree, u64 start, u64 end,
+			 struct extent_state **cached, gfp_t mask);
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 		    gfp_t mask);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
-- 
1.6.5.2

