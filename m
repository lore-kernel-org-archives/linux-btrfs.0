From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix how we merge extent states and deal with cached states
Date: Mon, 20 Jun 2011 14:56:35 -0400
Message-ID: <1308596195-22223-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

First, we can sometimes free the state we're merging, which means anybody who
calls merge_state() may have the state it passed in free'ed.  This is
problematic because we could end up caching the state, which makes caching
useless as the state will no longer be part of the tree.  So instead of free'ing
the state we passed into merge_state(), set it's end to the other->end and free
the other state.  This way we are sure to cache the correct state.  Also because
we can merge states together, instead of only using the cache'd state if it's
start == the start we are looking for, go ahead and use it if the start we are
looking for is within the range of the cached state.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3a33c11..4443b0f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -359,11 +359,10 @@ static int merge_state(struct extent_io_tree *tree,
 		if (other->start == state->end + 1 &&
 		    other->state == state->state) {
 			merge_cb(tree, state, other);
-			other->start = state->start;
-			state->tree = NULL;
-			rb_erase(&state->rb_node, &tree->state);
-			free_extent_state(state);
-			state = NULL;
+			state->end = other->end;
+			other->tree = NULL;
+			rb_erase(&other->rb_node, &tree->state);
+			free_extent_state(other);
 		}
 	}
 
@@ -429,7 +428,6 @@ static int insert_state(struct extent_io_tree *tree,
 		       "%llu %llu\n", (unsigned long long)found->start,
 		       (unsigned long long)found->end,
 		       (unsigned long long)start, (unsigned long long)end);
-		free_extent_state(state);
 		return -EEXIST;
 	}
 	state->tree = tree;
@@ -589,7 +587,8 @@ again:
 			cached_state = NULL;
 		}
 
-		if (cached && cached->tree && cached->start == start) {
+		if (cached && cached->tree && cached->start <= start &&
+		    cached->end > start) {
 			if (clear)
 				atomic_dec(&cached->refs);
 			state = cached;
@@ -832,7 +831,8 @@ again:
 	spin_lock(&tree->lock);
 	if (cached_state && *cached_state) {
 		state = *cached_state;
-		if (state->start == start && state->tree) {
+		if (state->start <= start && state->end > start &&
+		    state->tree) {
 			node = &state->rb_node;
 			goto hit_next;
 		}
@@ -872,13 +872,12 @@ hit_next:
 		if (err)
 			goto out;
 
-		next_node = rb_next(node);
-		cache_state(state, cached_state);
 		merge_state(tree, state);
 		if (last_end == (u64)-1)
 			goto out;
 
 		start = last_end + 1;
+		next_node = rb_next(&state->rb_node);
 		if (next_node && start < end && prealloc && !need_resched()) {
 			state = rb_entry(next_node, struct extent_state,
 					 rb_node);
@@ -950,7 +949,6 @@ hit_next:
 		 * Avoid to free 'prealloc' if it can be merged with
 		 * the later extent.
 		 */
-		atomic_inc(&prealloc->refs);
 		err = insert_state(tree, prealloc, start, this_end,
 				   &bits);
 		BUG_ON(err == -EEXIST);
@@ -959,7 +957,6 @@ hit_next:
 			goto out;
 		}
 		cache_state(prealloc, cached_state);
-		free_extent_state(prealloc);
 		start = this_end + 1;
 		goto search_again;
 	}
@@ -1649,7 +1646,8 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int bitset = 0;
 
 	spin_lock(&tree->lock);
-	if (cached && cached->tree && cached->start == start)
+	if (cached && cached->tree && cached->start <= start &&
+	    cached->end > start)
 		node = &cached->rb_node;
 	else
 		node = tree_search(tree, start);
-- 
1.7.5.2

