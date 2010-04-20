From: Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH]btrfs: speed up extent_io tree search
Date: Tue, 20 Apr 2010 17:21:58 +0800
Message-ID: <20100420092158.GA5873@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

searching extent_io_tree is frequently used and tooks a lot of cpu time.
We could cache last found extent_state to skip some full search. In my
test, the hit rate is from 30% to 70% depending on different workload,
which can speed up the search.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d2d0368..645f00c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -110,6 +110,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 	spin_lock_init(&tree->lock);
 	spin_lock_init(&tree->buffer_lock);
 	tree->mapping = mapping;
+	tree->cached_state = NULL;
 }
 
 static struct extent_state *alloc_extent_state(gfp_t mask)
@@ -135,6 +136,22 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	return state;
 }
 
+static void remove_cached_extent(struct extent_io_tree *tree,
+	struct extent_state *state)
+{
+	if (!tree->cached_state)
+		return;
+	if (tree->cached_state == state)
+		tree->cached_state = NULL;
+}
+
+static void merge_cached_extent(struct extent_io_tree *tree,
+	struct extent_state *first, struct extent_state *last)
+{
+	if (tree->cached_state == first || tree->cached_state == last)
+		tree->cached_state = first;
+}
+
 static void free_extent_state(struct extent_state *state)
 {
 	if (!state)
@@ -188,6 +205,12 @@ static struct rb_node *__etree_search(struct extent_io_tree *tree, u64 offset,
 	struct rb_node *orig_prev = NULL;
 	struct tree_entry *entry;
 	struct tree_entry *prev_entry = NULL;
+	struct tree_entry *cached_entry =
+				(struct tree_entry *)tree->cached_state;
+
+	if (likely(cached_entry && offset >= cached_entry->start &&
+		offset <= cached_entry->end))
+		return &cached_entry->rb_node;
 
 	while (n) {
 		entry = rb_entry(n, struct tree_entry, rb_node);
@@ -198,8 +221,10 @@ static struct rb_node *__etree_search(struct extent_io_tree *tree, u64 offset,
 			n = n->rb_left;
 		else if (offset > entry->end)
 			n = n->rb_right;
-		else
+		else {
+			tree->cached_state = (struct extent_state *)entry;
 			return n;
+		}
 	}
 
 	if (prev_ret) {
@@ -313,6 +338,7 @@ static int merge_state(struct extent_io_tree *tree,
 			merge_cb(tree, state, other);
 			state->start = other->start;
 			other->tree = NULL;
+			merge_cached_extent(tree, state, other);
 			rb_erase(&other->rb_node, &tree->state);
 			free_extent_state(other);
 		}
@@ -325,6 +351,7 @@ static int merge_state(struct extent_io_tree *tree,
 			merge_cb(tree, state, other);
 			other->start = state->start;
 			state->tree = NULL;
+			merge_cached_extent(tree, other, state);
 			rb_erase(&state->rb_node, &tree->state);
 			free_extent_state(state);
 			state = NULL;
@@ -473,6 +500,7 @@ static int clear_state_bit(struct extent_io_tree *tree,
 		wake_up(&state->wq);
 	if (delete || state->state == 0) {
 		if (state->tree) {
+			remove_cached_extent(tree, state);
 			clear_state_cb(tree, state, state->state);
 			rb_erase(&state->rb_node, &tree->state);
 			state->tree = NULL;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index bbab481..e60b367 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -89,6 +89,7 @@ struct extent_io_tree {
 	spinlock_t lock;
 	spinlock_t buffer_lock;
 	struct extent_io_ops *ops;
+	struct extent_state *cached_state;
 };
 
 struct extent_state {
