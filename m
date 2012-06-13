Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16777 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2FMKMC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 06:12:02 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5DABox9011741
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 18:11:52 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] Btrfs: apply rwlock for extent state
Date: Wed, 13 Jun 2012 18:19:11 +0800
Message-Id: <1339582751-32029-5-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used to protect both extent state tree and an individual state's state
by tree->lock, but this can be an obstacle of lockless read.

So we seperate them here:
o tree->lock protects the tree
o state->lock protects the state.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |  380 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/extent_io.h |    3 +-
 2 files changed, 336 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bb66e3c..4c6b743 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -27,7 +27,7 @@ static struct kmem_cache *extent_buffer_cache;
 static LIST_HEAD(buffers);
 static LIST_HEAD(states);
 
-#define LEAK_DEBUG 0
+#define LEAK_DEBUG 1
 #if LEAK_DEBUG
 static DEFINE_SPINLOCK(leak_lock);
 #endif
@@ -120,7 +120,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 	INIT_RADIX_TREE(&tree->csum, GFP_ATOMIC);
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
-	spin_lock_init(&tree->lock);
+	rwlock_init(&tree->lock);
 	spin_lock_init(&tree->buffer_lock);
 	spin_lock_init(&tree->csum_lock);
 	tree->mapping = mapping;
@@ -146,6 +146,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 #endif
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
+	spin_lock_init(&state->lock);
 	trace_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
 }
@@ -281,6 +282,7 @@ static void merge_state(struct extent_io_tree *tree,
 		if (!other_node)
 			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
+		/* FIXME: need other->lock? */
 		if (other->end != state->start - 1 ||
 		    other->state != state->state)
 			break;
@@ -297,6 +299,7 @@ static void merge_state(struct extent_io_tree *tree,
 		if (!other_node)
 			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
+		/* FIXME: need other->lock? */
 		if (other->start != state->end + 1 ||
 		    other->state != state->state)
 			break;
@@ -364,7 +367,10 @@ static int insert_state(struct extent_io_tree *tree,
 		return -EEXIST;
 	}
 	state->tree = tree;
+
+	spin_lock(&state->lock);
 	merge_state(tree, state);
+	spin_unlock(&state->lock);
 	return 0;
 }
 
@@ -410,6 +416,23 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 	return 0;
 }
 
+static struct extent_state *
+alloc_extent_state_atomic(struct extent_state *prealloc)
+{
+	if (!prealloc)
+		prealloc = alloc_extent_state(GFP_ATOMIC);
+
+	return prealloc;
+}
+
+enum extent_lock_type {
+	EXTENT_READ    = 0,
+	EXTENT_WRITE   = 1,
+	EXTENT_RLOCKED = 2,
+	EXTENT_WLOCKED = 3,
+	EXTENT_LAST    = 4,
+};
+
 static struct extent_state *next_state(struct extent_state *state)
 {
 	struct rb_node *next = rb_next(&state->rb_node);
@@ -426,13 +449,17 @@ static struct extent_state *next_state(struct extent_state *state)
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
  */
-static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
-					    struct extent_state *state,
-					    int *bits, int wake)
+static int __clear_state_bit(struct extent_io_tree *tree,
+			     struct extent_state *state,
+			     int *bits, int wake, int check)
 {
-	struct extent_state *next;
 	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
 
+	if (check) {
+		if ((state->state & ~bits_to_clear) == 0)
+			return 1;
+	}
+
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
 		WARN_ON(range > tree->dirty_bytes);
@@ -442,7 +469,17 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	state->state &= ~bits_to_clear;
 	if (wake)
 		wake_up(&state->wq);
+	return 0;
+}
+
+static struct extent_state *
+try_free_or_merge_state(struct extent_io_tree *tree, struct extent_state *state)
+{
+	struct extent_state *next = NULL;
+
+	BUG_ON(!spin_is_locked(&state->lock));
 	if (state->state == 0) {
+		spin_unlock(&state->lock);
 		next = next_state(state);
 		if (state->tree) {
 			rb_erase(&state->rb_node, &tree->state);
@@ -453,18 +490,17 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 		}
 	} else {
 		merge_state(tree, state);
+		spin_unlock(&state->lock);
 		next = next_state(state);
 	}
 	return next;
 }
 
-static struct extent_state *
-alloc_extent_state_atomic(struct extent_state *prealloc)
+static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
+			   struct extent_state *state, int *bits, int wake)
 {
-	if (!prealloc)
-		prealloc = alloc_extent_state(GFP_ATOMIC);
-
-	return prealloc;
+	__clear_state_bit(tree, state, bits, wake, 0);
+	return try_free_or_merge_state(tree, state);
 }
 
 void extent_io_tree_panic(struct extent_io_tree *tree, int err)
@@ -474,6 +510,97 @@ void extent_io_tree_panic(struct extent_io_tree *tree, int err)
 		    "thread while locked.");
 }
 
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
+	spin_lock(&state->lock);
+	merge_state(tree, state);
+	spin_unlock(&state->lock);
+out:
+	write_unlock(&tree->lock);
+}
+
+static void extent_rw_lock(struct extent_io_tree *tree, int *rw)
+{
+	int lock = *rw;
+
+	if (lock == EXTENT_READ) {
+		read_lock(&tree->lock);
+		*rw = EXTENT_RLOCKED;
+	} else if (lock == EXTENT_WRITE) {
+		write_lock(&tree->lock);
+		*rw = EXTENT_WLOCKED;
+	} else {
+		WARN_ON(1);
+	}
+}
+
+static void extent_rw_unlock(struct extent_io_tree *tree, int *rw)
+{
+	int lock = *rw;
+
+	if (lock == EXTENT_RLOCKED)
+		read_unlock(&tree->lock);
+	if (lock == EXTENT_WLOCKED)
+		write_unlock(&tree->lock);
+	*rw = EXTENT_READ;
+}
+
+static int extent_rw_flip(struct extent_io_tree *tree, int *rw)
+{
+	int lock = *rw;
+
+	if (lock == EXTENT_RLOCKED) {
+		read_unlock(&tree->lock);
+		*rw = EXTENT_WRITE;
+		return 1;
+	}
+	return 0;
+}
+
 /*
  * clear some bits on a range in the tree.  This may require splitting
  * or inserting elements in the tree, so the gfp mask is used to
@@ -496,8 +623,13 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
 	u64 last_end;
+	u64 orig_start = start;
 	int err;
 	int clear = 0;
+	int rw = EXTENT_READ;
+	int free = 0;
+	int merge = 0;
+	int check = 0;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -512,7 +644,8 @@ again:
 			return -ENOMEM;
 	}
 
-	spin_lock(&tree->lock);
+	/* XXX: after this we're EXTENT_RLOCKED/EXTENT_WLOCKED */
+	extent_rw_lock(tree, &rw);
 	if (cached_state) {
 		cached = *cached_state;
 
@@ -545,8 +678,10 @@ hit_next:
 	WARN_ON(state->end < start);
 	last_end = state->end;
 
+	spin_lock(&state->lock);
 	/* the state doesn't have the wanted bits, go ahead */
 	if (!(state->state & bits)) {
+		spin_unlock(&state->lock);
 		state = next_state(state);
 		goto next;
 	}
@@ -568,6 +703,11 @@ hit_next:
 	 */
 
 	if (state->start < start) {
+		/* split needs a write lock */
+		if (extent_rw_flip(tree, &rw)) {
+			spin_unlock(&state->lock);
+			goto again;
+		}
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
@@ -575,11 +715,15 @@ hit_next:
 			extent_io_tree_panic(tree, err);
 
 		prealloc = NULL;
-		if (err)
+		if (err) {
+			spin_unlock(&state->lock);
 			goto out;
+		}
 		if (state->end <= end) {
 			state = clear_state_bit(tree, state, &bits, wake);
 			goto next;
+		} else {
+			spin_unlock(&state->lock);
 		}
 		goto search_again;
 	}
@@ -590,22 +734,44 @@ hit_next:
 	 * on the first half
 	 */
 	if (state->start <= end && state->end > end) {
+		/* split needs a write lock */
+		if (extent_rw_flip(tree, &rw)) {
+			spin_unlock(&state->lock);
+			goto again;
+		}
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);
+		spin_unlock(&state->lock);
 
 		if (wake)
 			wake_up(&state->wq);
 
+		spin_lock(&prealloc->lock);
 		clear_state_bit(tree, prealloc, &bits, wake);
 
 		prealloc = NULL;
 		goto out;
 	}
 
-	state = clear_state_bit(tree, state, &bits, wake);
+	check = (rw == EXTENT_RLOCKED) ? 1 : 0;
+	free = __clear_state_bit(tree, state, &bits, wake, check);
+	if (free && rw == EXTENT_RLOCKED) {
+		/* this one will be freed, so it needs a write lock */
+		spin_unlock(&state->lock);
+		extent_rw_flip(tree, &rw);
+		goto again;
+	}
+	if (rw == EXTENT_RLOCKED) {
+		merge = test_merge_state(tree, state);
+		spin_unlock(&state->lock);
+		state = next_state(state);
+	} else {
+		/* this one will unlock state->lock for us */
+		state = try_free_or_merge_state(tree, state);
+	}
 next:
 	if (last_end == (u64)-1)
 		goto out;
@@ -615,16 +781,18 @@ next:
 	goto search_again;
 
 out:
-	spin_unlock(&tree->lock);
+	extent_rw_unlock(tree, &rw);
 	if (prealloc)
 		free_extent_state(prealloc);
+	if (merge)
+		process_merge_state(tree, orig_start);
 
 	return 0;
 
 search_again:
 	if (start > end)
 		goto out;
-	spin_unlock(&tree->lock);
+	extent_rw_unlock(tree, &rw);
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
@@ -637,9 +805,9 @@ static void wait_on_state(struct extent_io_tree *tree,
 {
 	DEFINE_WAIT(wait);
 	prepare_to_wait(&state->wq, &wait, TASK_UNINTERRUPTIBLE);
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	schedule();
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	finish_wait(&state->wq, &wait);
 }
 
@@ -653,7 +821,7 @@ void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 	struct extent_state *state;
 	struct rb_node *node;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 again:
 	while (1) {
 		/*
@@ -669,22 +837,27 @@ again:
 		if (state->start > end)
 			goto out;
 
+		spin_lock(&state->lock);
 		if (state->state & bits) {
+			spin_unlock(&state->lock);
 			start = state->start;
 			atomic_inc(&state->refs);
 			wait_on_state(tree, state);
 			free_extent_state(state);
 			goto again;
 		}
+		spin_unlock(&state->lock);
 		start = state->end + 1;
 
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
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
@@ -734,6 +907,9 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
+	u64 orig_start = start;
+	int rw = EXTENT_READ;
+	int merge = 0;
 
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
@@ -742,7 +918,8 @@ again:
 		BUG_ON(!prealloc);
 	}
 
-	spin_lock(&tree->lock);
+	/* XXX: after this we're EXTENT_RLOCKED/EXTENT_WLOCKED */
+	extent_rw_lock(tree, &rw);
 	if (cached_state && *cached_state) {
 		state = *cached_state;
 		if (state->start <= start && state->end > start &&
@@ -757,6 +934,9 @@ again:
 	 */
 	node = tree_search(tree, start);
 	if (!node) {
+		/* XXX: insert need a write lock */
+		if (extent_rw_flip(tree, &rw))
+			goto again;
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
@@ -771,6 +951,7 @@ hit_next:
 	last_start = state->start;
 	last_end = state->end;
 
+	spin_lock(&state->lock);
 	/*
 	 * | ---- desired range ---- |
 	 * | state |
@@ -779,6 +960,7 @@ hit_next:
 	 */
 	if (state->start == start && state->end <= end) {
 		if (state->state & exclusive_bits) {
+			spin_unlock(&state->lock);
 			*failed_start = state->start;
 			err = -EEXIST;
 			goto out;
@@ -786,7 +968,13 @@ hit_next:
 
 		set_state_bits(tree, state, &bits);
 		cache_state(state, cached_state);
-		merge_state(tree, state);
+		/* XXX */
+		if (rw == EXTENT_RLOCKED)
+			merge = test_merge_state(tree, state);
+		else
+			merge_state(tree, state);
+		spin_unlock(&state->lock);
+
 		if (last_end == (u64)-1)
 			goto out;
 		start = last_end + 1;
@@ -815,11 +1003,18 @@ hit_next:
 	 */
 	if (state->start < start) {
 		if (state->state & exclusive_bits) {
+			spin_unlock(&state->lock);
 			*failed_start = start;
 			err = -EEXIST;
 			goto out;
 		}
 
+		/* XXX: split needs a write lock */
+		if (extent_rw_flip(tree, &rw)) {
+			spin_unlock(&state->lock);
+			goto again;
+		}
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
@@ -827,12 +1022,15 @@ hit_next:
 			extent_io_tree_panic(tree, err);
 
 		prealloc = NULL;
-		if (err)
+		if (err) {
+			spin_unlock(&state->lock);
 			goto out;
+		}
 		if (state->end <= end) {
 			set_state_bits(tree, state, &bits);
 			cache_state(state, cached_state);
 			merge_state(tree, state);
+			spin_unlock(&state->lock);
 			if (last_end == (u64)-1)
 				goto out;
 			start = last_end + 1;
@@ -840,6 +1038,8 @@ hit_next:
 			if (start < end && state && state->start == start &&
 			    !need_resched())
 				goto hit_next;
+		} else {
+			spin_unlock(&state->lock);
 		}
 		goto search_again;
 	}
@@ -852,6 +1052,12 @@ hit_next:
 	 */
 	if (state->start > start) {
 		u64 this_end;
+
+		spin_unlock(&state->lock);
+		/* XXX: split need a write lock */
+		if (extent_rw_flip(tree, &rw))
+			goto again;
+
 		if (end < last_start)
 			this_end = end;
 		else
@@ -869,7 +1075,9 @@ hit_next:
 		if (err)
 			extent_io_tree_panic(tree, err);
 
+		spin_lock(&prealloc->lock);
 		cache_state(prealloc, cached_state);
+		spin_unlock(&prealloc->lock);
 		prealloc = NULL;
 		start = this_end + 1;
 		goto search_again;
@@ -882,20 +1090,30 @@ hit_next:
 	 */
 	if (state->start <= end && state->end > end) {
 		if (state->state & exclusive_bits) {
+			spin_unlock(&state->lock);
 			*failed_start = start;
 			err = -EEXIST;
 			goto out;
 		}
 
+		/* XXX: split need a write lock */
+		if (extent_rw_flip(tree, &rw)) {
+			spin_unlock(&state->lock);
+			goto again;
+		}
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);
 
+		spin_unlock(&state->lock);
+		spin_lock(&prealloc->lock);
 		set_state_bits(tree, prealloc, &bits);
 		cache_state(prealloc, cached_state);
 		merge_state(tree, prealloc);
+		spin_unlock(&prealloc->lock);
 		prealloc = NULL;
 		goto out;
 	}
@@ -903,16 +1121,18 @@ hit_next:
 	goto search_again;
 
 out:
-	spin_unlock(&tree->lock);
+	extent_rw_unlock(tree, &rw);
 	if (prealloc)
 		free_extent_state(prealloc);
+	if (merge)
+		process_merge_state(tree, orig_start);
 
 	return err;
 
 search_again:
 	if (start > end)
 		goto out;
-	spin_unlock(&tree->lock);
+	extent_rw_unlock(tree, &rw);
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
@@ -951,6 +1171,9 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
+	u64 orig_start = start;
+	int rw = EXTENT_READ;
+	int merge = 0;
 
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
@@ -959,13 +1182,18 @@ again:
 			return -ENOMEM;
 	}
 
-	spin_lock(&tree->lock);
+	/* XXX: after this we're EXTENT_RLOCKED/EXTENT_WLOCKED */
+	extent_rw_lock(tree, &rw);
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
 	 */
 	node = tree_search(tree, start);
 	if (!node) {
+		/* XXX: insert need a write lock */
+		if (extent_rw_flip(tree, &rw))
+			goto again;
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc) {
 			err = -ENOMEM;
@@ -982,6 +1210,7 @@ hit_next:
 	last_start = state->start;
 	last_end = state->end;
 
+	spin_lock(&state->lock);
 	/*
 	 * | ---- desired range ---- |
 	 * | state |
@@ -990,16 +1219,26 @@ hit_next:
 	 */
 	if (state->start == start && state->end <= end) {
 		set_state_bits(tree, state, &bits);
-		state = clear_state_bit(tree, state, &clear_bits, 0);
+		__clear_state_bit(tree, state, &clear_bits, 0, 0);
+		if (rw == EXTENT_LOCKED)
+			merge = test_merge_state(tree, state);
+		else
+			merge_state(tree, state);
+		spin_unlock(&state->lock);
+
 		if (last_end == (u64)-1)
 			goto out;
+
 		start = last_end + 1;
+		state = next_state(state);
 		if (start < end && state && state->start == start &&
 		    !need_resched())
 			goto hit_next;
 		goto search_again;
 	}
 
+	WARN_ON(1);
+
 	/*
 	 *     | ---- desired range ---- |
 	 * | state |
@@ -1017,8 +1256,15 @@ hit_next:
 	 * desired bit on it.
 	 */
 	if (state->start < start) {
+		/* XXX: split need a write lock */
+		if (extent_rw_flip(tree, &rw)) {
+			spin_unlock(&state->lock);
+			goto again;
+		}
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc) {
+			spin_unlock(&state->lock);
 			err = -ENOMEM;
 			goto out;
 		}
@@ -1026,8 +1272,10 @@ hit_next:
 		if (err)
 			extent_io_tree_panic(tree, err);
 		prealloc = NULL;
-		if (err)
+		if (err) {
+			spin_unlock(&state->lock);
 			goto out;
+		}
 		if (state->end <= end) {
 			set_state_bits(tree, state, &bits);
 			state = clear_state_bit(tree, state, &clear_bits, 0);
@@ -1037,6 +1285,8 @@ hit_next:
 			if (start < end && state && state->start == start &&
 			    !need_resched())
 				goto hit_next;
+		} else {
+			spin_unlock(&state->lock);
 		}
 		goto search_again;
 	}
@@ -1049,11 +1299,17 @@ hit_next:
 	 */
 	if (state->start > start) {
 		u64 this_end;
+
+		spin_unlock(&state->lock);
 		if (end < last_start)
 			this_end = end;
 		else
 			this_end = last_start - 1;
 
+		/* XXX: insert need a write lock */
+		if (extent_rw_flip(tree, &rw))
+			goto again;
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc) {
 			err = -ENOMEM;
@@ -1079,6 +1335,10 @@ hit_next:
 	 * on the first half
 	 */
 	if (state->start <= end && state->end > end) {
+		/* XXX: split need a write lock */
+		if (extent_rw_flip(tree, &rw))
+			goto again;
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc) {
 			err = -ENOMEM;
@@ -1089,7 +1349,11 @@ hit_next:
 		if (err)
 			extent_io_tree_panic(tree, err);
 
+		spin_unlock(&state->lock);
+		spin_lock(&prealloc->lock);
+
 		set_state_bits(tree, prealloc, &bits);
+		/* will unlock prealloc lock for us */
 		clear_state_bit(tree, prealloc, &clear_bits, 0);
 		prealloc = NULL;
 		goto out;
@@ -1098,16 +1362,20 @@ hit_next:
 	goto search_again;
 
 out:
-	spin_unlock(&tree->lock);
+	/* XXX */
+	extent_rw_unlock(tree, &rw);
 	if (prealloc)
 		free_extent_state(prealloc);
+	if (merge)
+		process_merge_state(tree, orig_start);
 
 	return err;
 
 search_again:
 	if (start > end)
 		goto out;
-	spin_unlock(&tree->lock);
+	/* XXX */
+	extent_rw_unlock(tree, &rw);
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
@@ -1267,8 +1535,12 @@ struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
 
 	while (1) {
 		state = rb_entry(node, struct extent_state, rb_node);
-		if (state->end >= start && (state->state & bits))
+		spin_lock(&state->lock);
+		if (state->end >= start && (state->state & bits)) {
+			spin_unlock(&state->lock);
 			return state;
+		}
+		spin_unlock(&state->lock);
 
 		node = rb_next(node);
 		if (!node)
@@ -1291,14 +1563,14 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
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
 
@@ -1318,7 +1590,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 found = 0;
 	u64 total_bytes = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 
 	/*
 	 * this search will find all the extents that end after
@@ -1333,15 +1605,20 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 
 	while (1) {
 		state = rb_entry(node, struct extent_state, rb_node);
+		spin_lock(&state->lock);
 		if (found && (state->start != cur_start ||
 			      (state->state & EXTENT_BOUNDARY))) {
+			spin_unlock(&state->lock);
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
+			spin_unlock(&state->lock);
 			if (!found)
 				*end = state->end;
 			goto out;
 		}
+		spin_unlock(&state->lock);
+
 		if (!found) {
 			*start = state->start;
 			*cached_state = state;
@@ -1358,7 +1635,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			break;
 	}
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return found;
 }
 
@@ -1619,7 +1896,7 @@ u64 count_range_bits(struct extent_io_tree *tree,
 		return 0;
 	}
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	if (cur_start == 0 && bits == EXTENT_DIRTY) {
 		total_bytes = tree->dirty_bytes;
 		goto out;
@@ -1638,7 +1915,9 @@ u64 count_range_bits(struct extent_io_tree *tree,
 			break;
 		if (contig && found && state->start > last + 1)
 			break;
+		spin_lock(&state->lock);
 		if (state->end >= cur_start && (state->state & bits) == bits) {
+			spin_unlock(&state->lock);
 			total_bytes += min(search_end, state->end) + 1 -
 				       max(cur_start, state->start);
 			if (total_bytes >= max_bytes)
@@ -1649,14 +1928,18 @@ u64 count_range_bits(struct extent_io_tree *tree,
 			}
 			last = state->end;
 		} else if (contig && found) {
+			spin_unlock(&state->lock);
 			break;
+		} else {
+			spin_unlock(&state->lock);
 		}
+
 		node = rb_next(node);
 		if (!node)
 			break;
 	}
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return total_bytes;
 }
 
@@ -1707,7 +1990,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct rb_node *node;
 	int bitset = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	if (cached && cached->tree && cached->start <= start &&
 	    cached->end > start)
 		node = &cached->rb_node;
@@ -1724,13 +2007,18 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (state->start > end)
 			break;
 
+		spin_lock(&state->lock);
 		if (state->state & bits) {
+			spin_unlock(&state->lock);
 			bitset = 1;
 			if (!filled)
 				break;
 		} else if (filled) {
+			spin_unlock(&state->lock);
 			bitset = 0;
 			break;
+		} else {
+			spin_unlock(&state->lock);
 		}
 
 		if (state->end == (u64)-1)
@@ -1746,7 +2034,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 			break;
 		}
 	}
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return bitset;
 }
 
@@ -1959,11 +2247,11 @@ static int clean_io_failure(u64 start, struct page *page)
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
@@ -2097,12 +2385,12 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
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
@@ -2701,7 +2989,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
-			                     &cached, GFP_NOFS);
+					     &cached, GFP_NOFS);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c896962..7a54d9f 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -100,7 +100,7 @@ struct extent_io_tree {
 	struct address_space *mapping;
 	u64 dirty_bytes;
 	int track_uptodate;
-	spinlock_t lock;
+	rwlock_t lock;
 	spinlock_t buffer_lock;
 	spinlock_t csum_lock;
 	struct extent_io_ops *ops;
@@ -116,6 +116,7 @@ struct extent_state {
 	wait_queue_head_t wq;
 	atomic_t refs;
 	unsigned long state;
+	spinlock_t lock;
 
 	/* for use by the FS */
 	u64 private;
-- 
1.6.5.2

