Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2GYF7o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 01:59:44 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6P5xWH1005253
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 13:59:41 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/6 v3][RFC] Btrfs: apply rwlock for extent state
Date: Wed, 25 Jul 2012 13:58:40 +0800
Message-Id: <1343195922-31405-5-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used to protect both extent state tree and an individual state's state
by tree->lock, and now we want to reduce lock contention on this lock.

So we adopt rwlock for tree->lock and seperate them here for
reducing lock granularity:
o   tree->lock protects the tree
o   state->lock protects the state.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |  320 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.h |    3 +-
 2 files changed, 277 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a84d904..842a4e5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -120,7 +120,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 	INIT_RADIX_TREE(&tree->buffer, GFP_ATOMIC);
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
-	spin_lock_init(&tree->lock);
+	rwlock_init(&tree->lock);
 	spin_lock_init(&tree->buffer_lock);
 	tree->mapping = mapping;
 }
@@ -145,6 +145,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 #endif
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
+	spin_lock_init(&state->lock);
 	trace_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
 }
@@ -280,9 +281,25 @@ static void merge_state(struct extent_io_tree *tree,
 		if (!other_node)
 			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
-		if (other->end != state->start - 1 ||
-		    other->state != state->state)
+		if (other->end != state->start - 1)
 			break;
+		/*
+		 * Will race with the following:
+		 *    if (extent_rw_flip()) {
+		 *    		spin_unlock(other);
+		 *    		retry;
+		 *    }
+		 * o  extent_rw_flip() will do read_unlock,
+		 * o  meanwhile, another thread can get write lock here and
+		 *    free 'other'
+		 * o  then we'll get crash.
+		 */
+		spin_lock(&other->lock);
+		if (other->state != state->state) {
+			spin_unlock(&other->lock);
+			break;
+		}
+		spin_unlock(&other->lock);
 
 		merge_cb(tree, state, other);
 		state->start = other->start;
@@ -296,9 +313,15 @@ static void merge_state(struct extent_io_tree *tree,
 		if (!other_node)
 			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
-		if (other->start != state->end + 1 ||
-		    other->state != state->state)
+		if (other->start != state->end + 1)
+			break;
+
+		spin_lock(&other->lock);
+		if (other->state != state->state) {
+			spin_unlock(&other->lock);
 			break;
+		}
+		spin_unlock(&other->lock);
 
 		merge_cb(tree, state, other);
 		state->end = other->end;
@@ -350,6 +373,10 @@ static int insert_state(struct extent_io_tree *tree,
 	state->start = start;
 	state->end = end;
 
+	/*
+	 * We've not insert this state entry, and others will not find it,
+	 * so it is safe without lock.
+	 */
 	set_state_bits(tree, state, bits);
 
 	node = tree_insert(&tree->state, end, &state->rb_node);
@@ -363,7 +390,10 @@ static int insert_state(struct extent_io_tree *tree,
 		return -EEXIST;
 	}
 	state->tree = tree;
+
+	spin_lock(&state->lock);
 	merge_state(tree, state);
+	spin_unlock(&state->lock);
 	return 0;
 }
 
@@ -427,10 +457,15 @@ static struct extent_state *next_state(struct extent_state *state)
  */
 static int __clear_state_bit(struct extent_io_tree *tree,
 			     struct extent_state *state,
-			     int *bits, int wake)
+			     int *bits, int wake, int check)
 {
 	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
 
+	if (check) {
+		if ((state->state & ~bits_to_clear) == 0)
+			return 1;
+	}
+
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
 		WARN_ON(range > tree->dirty_bytes);
@@ -448,8 +483,10 @@ try_free_or_merge_state(struct extent_io_tree *tree, struct extent_state *state)
 {
 	struct extent_state *next = NULL;
 
+	BUG_ON(!spin_is_locked(&state->lock));
 	if (state->state == 0) {
 		next = next_state(state);
+		spin_unlock(&state->lock);
 		if (state->tree) {
 			rb_erase(&state->rb_node, &tree->state);
 			state->tree = NULL;
@@ -459,6 +496,7 @@ try_free_or_merge_state(struct extent_io_tree *tree, struct extent_state *state)
 		}
 	} else {
 		merge_state(tree, state);
+		spin_unlock(&state->lock);
 		next = next_state(state);
 	}
 	return next;
@@ -467,7 +505,7 @@ try_free_or_merge_state(struct extent_io_tree *tree, struct extent_state *state)
 static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 			   struct extent_state *state, int *bits, int wake)
 {
-	__clear_state_bit(tree, state, bits, wake);
+	__clear_state_bit(tree, state, bits, wake, 0);
 	return try_free_or_merge_state(tree, state);
 }
 
@@ -514,6 +552,74 @@ static int test_merge_state(struct extent_io_tree *tree,
 	return 0;
 }
 
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
+	if (!node)
+		goto out;
+
+	state = rb_entry(node, struct extent_state, rb_node);
+
+	spin_lock(&state->lock);
+	merge_state(tree, state);
+	spin_unlock(&state->lock);
+out:
+	write_unlock(&tree->lock);
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
@@ -536,8 +642,13 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
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
@@ -552,7 +663,7 @@ again:
 			return -ENOMEM;
 	}
 
-	spin_lock(&tree->lock);
+	extent_rw_lock(tree, &rw);
 	if (cached_state) {
 		cached = *cached_state;
 
@@ -585,8 +696,10 @@ hit_next:
 	WARN_ON(state->end < start);
 	last_end = state->end;
 
+	spin_lock(&state->lock);
 	/* the state doesn't have the wanted bits, go ahead */
 	if (!(state->state & bits)) {
+		spin_unlock(&state->lock);
 		state = next_state(state);
 		goto next;
 	}
@@ -608,6 +721,11 @@ hit_next:
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
@@ -615,11 +733,15 @@ hit_next:
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
@@ -630,22 +752,44 @@ hit_next:
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
+		merge |= test_merge_state(tree, state);
+		spin_unlock(&state->lock);
+		state = next_state(state);
+	} else {
+		/* this one will unlock state->lock for us */
+		state = try_free_or_merge_state(tree, state);
+	}
 next:
 	if (last_end == (u64)-1)
 		goto out;
@@ -655,16 +799,18 @@ next:
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
@@ -677,9 +823,9 @@ static void wait_on_state(struct extent_io_tree *tree,
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
 
@@ -693,7 +839,7 @@ void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 	struct extent_state *state;
 	struct rb_node *node;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 again:
 	while (1) {
 		/*
@@ -709,22 +855,27 @@ again:
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
@@ -783,6 +934,9 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
+	u64 orig_start = start;
+	int rw = EXTENT_READ;
+	int merge = 0;
 
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
@@ -791,7 +945,7 @@ again:
 		BUG_ON(!prealloc);
 	}
 
-	spin_lock(&tree->lock);
+	extent_rw_lock(tree, &rw);
 	if (cached_state && *cached_state) {
 		state = *cached_state;
 		if (state->start <= start && state->end > start &&
@@ -806,6 +960,9 @@ again:
 	 */
 	node = tree_search(tree, start);
 	if (!node) {
+		/* insert need a write lock */
+		if (extent_rw_flip(tree, &rw))
+			goto again;
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
@@ -820,6 +977,7 @@ hit_next:
 	last_start = state->start;
 	last_end = state->end;
 
+	spin_lock(&state->lock);
 	/*
 	 * | ---- desired range ---- |
 	 * | state |
@@ -828,6 +986,7 @@ hit_next:
 	 */
 	if (state->start == start && state->end <= end) {
 		if (state->state & exclusive_bits) {
+			spin_unlock(&state->lock);
 			*failed_start = state->start;
 			err = -EEXIST;
 			goto out;
@@ -835,7 +994,12 @@ hit_next:
 
 		set_state_bits(tree, state, &bits);
 		cache_state(state, cached_state);
-		merge_state(tree, state);
+		if (rw == EXTENT_RLOCKED)
+			merge |= test_merge_state(tree, state);
+		else
+			merge_state(tree, state);
+		spin_unlock(&state->lock);
+
 		if (last_end == (u64)-1)
 			goto out;
 		start = last_end + 1;
@@ -864,11 +1028,18 @@ hit_next:
 	 */
 	if (state->start < start) {
 		if (state->state & exclusive_bits) {
+			spin_unlock(&state->lock);
 			*failed_start = start;
 			err = -EEXIST;
 			goto out;
 		}
 
+		/* split needs a write lock */
+		if (extent_rw_flip(tree, &rw)) {
+			spin_unlock(&state->lock);
+			goto again;
+		}
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
@@ -876,12 +1047,15 @@ hit_next:
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
@@ -889,6 +1063,8 @@ hit_next:
 			if (start < end && state && state->start == start &&
 			    !need_resched())
 				goto hit_next;
+		} else {
+			spin_unlock(&state->lock);
 		}
 		goto search_again;
 	}
@@ -901,6 +1077,12 @@ hit_next:
 	 */
 	if (state->start > start) {
 		u64 this_end;
+
+		spin_unlock(&state->lock);
+		/* split need a write lock */
+		if (extent_rw_flip(tree, &rw))
+			goto again;
+
 		if (end < last_start)
 			this_end = end;
 		else
@@ -918,7 +1100,9 @@ hit_next:
 		if (err)
 			extent_io_tree_panic(tree, err);
 
+		spin_lock(&prealloc->lock);
 		cache_state(prealloc, cached_state);
+		spin_unlock(&prealloc->lock);
 		prealloc = NULL;
 		start = this_end + 1;
 		goto search_again;
@@ -931,20 +1115,30 @@ hit_next:
 	 */
 	if (state->start <= end && state->end > end) {
 		if (state->state & exclusive_bits) {
+			spin_unlock(&state->lock);
 			*failed_start = start;
 			err = -EEXIST;
 			goto out;
 		}
 
+		/* split need a write lock */
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
@@ -952,16 +1146,18 @@ hit_next:
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
@@ -1008,7 +1204,7 @@ again:
 			return -ENOMEM;
 	}
 
-	spin_lock(&tree->lock);
+	write_lock(&tree->lock);
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
@@ -1031,6 +1227,7 @@ hit_next:
 	last_start = state->start;
 	last_end = state->end;
 
+	spin_lock(&state->lock);
 	/*
 	 * | ---- desired range ---- |
 	 * | state |
@@ -1049,6 +1246,8 @@ hit_next:
 		goto search_again;
 	}
 
+	WARN_ON(1);
+
 	/*
 	 *     | ---- desired range ---- |
 	 * | state |
@@ -1068,6 +1267,7 @@ hit_next:
 	if (state->start < start) {
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc) {
+			spin_unlock(&state->lock);
 			err = -ENOMEM;
 			goto out;
 		}
@@ -1075,8 +1275,10 @@ hit_next:
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
@@ -1086,6 +1288,8 @@ hit_next:
 			if (start < end && state && state->start == start &&
 			    !need_resched())
 				goto hit_next;
+		} else {
+			spin_unlock(&state->lock);
 		}
 		goto search_again;
 	}
@@ -1098,6 +1302,8 @@ hit_next:
 	 */
 	if (state->start > start) {
 		u64 this_end;
+
+		spin_unlock(&state->lock);
 		if (end < last_start)
 			this_end = end;
 		else
@@ -1138,7 +1344,11 @@ hit_next:
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
@@ -1147,7 +1357,7 @@ hit_next:
 	goto search_again;
 
 out:
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (prealloc)
 		free_extent_state(prealloc);
 
@@ -1156,7 +1366,7 @@ out:
 search_again:
 	if (start > end)
 		goto out;
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	if (mask & __GFP_WAIT)
 		cond_resched();
 	goto again;
@@ -1316,8 +1526,12 @@ struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
 
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
@@ -1340,14 +1554,14 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
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
 
@@ -1367,7 +1581,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 found = 0;
 	u64 total_bytes = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 
 	/*
 	 * this search will find all the extents that end after
@@ -1382,15 +1596,20 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 
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
@@ -1407,7 +1626,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			break;
 	}
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return found;
 }
 
@@ -1668,7 +1887,7 @@ u64 count_range_bits(struct extent_io_tree *tree,
 		return 0;
 	}
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	if (cur_start == 0 && bits == EXTENT_DIRTY) {
 		total_bytes = tree->dirty_bytes;
 		goto out;
@@ -1687,7 +1906,9 @@ u64 count_range_bits(struct extent_io_tree *tree,
 			break;
 		if (contig && found && state->start > last + 1)
 			break;
+		spin_lock(&state->lock);
 		if (state->end >= cur_start && (state->state & bits) == bits) {
+			spin_unlock(&state->lock);
 			total_bytes += min(search_end, state->end) + 1 -
 				       max(cur_start, state->start);
 			if (total_bytes >= max_bytes)
@@ -1698,14 +1919,18 @@ u64 count_range_bits(struct extent_io_tree *tree,
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
 
@@ -1719,7 +1944,7 @@ int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 	struct extent_state *state;
 	int ret = 0;
 
-	spin_lock(&tree->lock);
+	write_lock(&tree->lock);
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
@@ -1736,7 +1961,7 @@ int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 	}
 	state->private = private;
 out:
-	spin_unlock(&tree->lock);
+	write_unlock(&tree->lock);
 	return ret;
 }
 
@@ -1746,7 +1971,7 @@ int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 	struct extent_state *state;
 	int ret = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
@@ -1763,7 +1988,7 @@ int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 	}
 	*private = state->private;
 out:
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return ret;
 }
 
@@ -1780,7 +2005,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct rb_node *node;
 	int bitset = 0;
 
-	spin_lock(&tree->lock);
+	read_lock(&tree->lock);
 	if (cached && cached->tree && cached->start <= start &&
 	    cached->end > start)
 		node = &cached->rb_node;
@@ -1797,13 +2022,18 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
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
@@ -1819,7 +2049,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 			break;
 		}
 	}
-	spin_unlock(&tree->lock);
+	read_unlock(&tree->lock);
 	return bitset;
 }
 
@@ -2032,11 +2262,11 @@ static int clean_io_failure(u64 start, struct page *page)
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
@@ -2170,12 +2400,12 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
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
@@ -2362,7 +2592,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
 
-		spin_lock(&tree->lock);
+		read_lock(&tree->lock);
 		state = find_first_extent_bit_state(tree, start, EXTENT_LOCKED);
 		if (state && state->start == start) {
 			/*
@@ -2371,7 +2601,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 */
 			cache_state(state, &cached);
 		}
-		spin_unlock(&tree->lock);
+		read_unlock(&tree->lock);
 
 		mirror = (int)(unsigned long)bio->bi_bdev;
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..bf403f2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -99,7 +99,7 @@ struct extent_io_tree {
 	struct address_space *mapping;
 	u64 dirty_bytes;
 	int track_uptodate;
-	spinlock_t lock;
+	rwlock_t lock;
 	spinlock_t buffer_lock;
 	struct extent_io_ops *ops;
 };
@@ -114,6 +114,7 @@ struct extent_state {
 	wait_queue_head_t wq;
 	atomic_t refs;
 	unsigned long state;
+	spinlock_t lock;
 
 	/* for use by the FS */
 	u64 private;
-- 
1.6.5.2

