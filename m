Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49663 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3KZPmE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 10:42:04 -0500
Received: by mail-wg0-f51.google.com with SMTP id b13so2576784wgh.18
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 07:42:02 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: more efficient extent state insertions
Date: Tue, 26 Nov 2013 15:41:47 +0000
Message-Id: <1385480507-1043-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently we do 2 traversals of an inode's extent_io_tree
before inserting an extent state structure: 1 to see if a
matching extent state already exists and 1 to do the insertion
if the fist traversal didn't found such extent state.

This change just combines those tree traversals into a single one.
While running sysbench tests (random writes) I captured the number
of elements in extent_io_tree trees for a while (into a procfs file
backed by a seq_list from seq_file module) and got this histogram:

Count: 9310
Range: 51.000 - 21386.000; Mean: 11785.243; Median: 18743.500; Stddev: 8923.688
Percentiles:  90th: 20985.000; 95th: 21155.000; 99th: 21369.000
  51.000 -   93.933:   693 ########
  93.933 -  172.314:   938 ##########
 172.314 -  315.408:   856 #########
 315.408 -  576.646:    95 #
 576.646 - 6415.830:   888 ##########
6415.830 - 11713.809:  1024 ###########
11713.809 - 21386.000:  4816 #####################################################

So traversing such trees can take some significant time that can
easily be avoided.

Ran the following sysbench tests, 5 times each, for sequential and
random writes, and got the following results:

  sysbench --test=fileio --file-num=1 --file-total-size=2G \
    --file-test-mode=seqwr --num-threads=16 --file-block-size=65536 \
    --max-requests=0 --max-time=60 --file-io-mode=sync

  sysbench --test=fileio --file-num=1 --file-total-size=2G \
    --file-test-mode=rndwr --num-threads=16 --file-block-size=65536 \
    --max-requests=0 --max-time=60 --file-io-mode=sync

Before this change:

sequential writes: 69.28Mb/sec (average of 5 runs)
random writes:     4.14Mb/sec  (average of 5 runs)

After this change:

sequential writes: 69.91Mb/sec (average of 5 runs)
random writes:     5.69Mb/sec  (average of 5 runs)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent_io.c |   76 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b8e7e41..3c3f448 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -224,12 +224,20 @@ void free_extent_state(struct extent_state *state)
 }
 
 static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
-				   struct rb_node *node)
+				   struct rb_node *node,
+				   struct rb_node ***p_in,
+				   struct rb_node **parent_in)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct tree_entry *entry;
 
+	if (p_in && parent_in) {
+		p = *p_in;
+		parent = *parent_in;
+		goto do_insert;
+	}
+
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct tree_entry, rb_node);
@@ -242,35 +250,43 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 			return parent;
 	}
 
+do_insert:
 	rb_link_node(node, parent, p);
 	rb_insert_color(node, root);
 	return NULL;
 }
 
 static struct rb_node *__etree_search(struct extent_io_tree *tree, u64 offset,
-				     struct rb_node **prev_ret,
-				     struct rb_node **next_ret)
+				      struct rb_node **prev_ret,
+				      struct rb_node **next_ret,
+				      struct rb_node ***p_ret,
+				      struct rb_node **parent_ret)
 {
 	struct rb_root *root = &tree->state;
-	struct rb_node *n = root->rb_node;
+	struct rb_node **n = &root->rb_node;
 	struct rb_node *prev = NULL;
 	struct rb_node *orig_prev = NULL;
 	struct tree_entry *entry;
 	struct tree_entry *prev_entry = NULL;
 
-	while (n) {
-		entry = rb_entry(n, struct tree_entry, rb_node);
-		prev = n;
+	while (*n) {
+		prev = *n;
+		entry = rb_entry(prev, struct tree_entry, rb_node);
 		prev_entry = entry;
 
 		if (offset < entry->start)
-			n = n->rb_left;
+			n = &(*n)->rb_left;
 		else if (offset > entry->end)
-			n = n->rb_right;
+			n = &(*n)->rb_right;
 		else
-			return n;
+			return *n;
 	}
 
+	if (p_ret)
+		*p_ret = n;
+	if (parent_ret)
+		*parent_ret = prev;
+
 	if (prev_ret) {
 		orig_prev = prev;
 		while (prev && offset > prev_entry->end) {
@@ -292,18 +308,27 @@ static struct rb_node *__etree_search(struct extent_io_tree *tree, u64 offset,
 	return NULL;
 }
 
-static inline struct rb_node *tree_search(struct extent_io_tree *tree,
-					  u64 offset)
+static inline struct rb_node *
+tree_search_for_insert(struct extent_io_tree *tree,
+		       u64 offset,
+		       struct rb_node ***p_ret,
+		       struct rb_node **parent_ret)
 {
 	struct rb_node *prev = NULL;
 	struct rb_node *ret;
 
-	ret = __etree_search(tree, offset, &prev, NULL);
+	ret = __etree_search(tree, offset, &prev, NULL, p_ret, parent_ret);
 	if (!ret)
 		return prev;
 	return ret;
 }
 
+static inline struct rb_node *tree_search(struct extent_io_tree *tree,
+					  u64 offset)
+{
+	return tree_search_for_insert(tree, offset, NULL, NULL);
+}
+
 static void merge_cb(struct extent_io_tree *tree, struct extent_state *new,
 		     struct extent_state *other)
 {
@@ -385,6 +410,8 @@ static void set_state_bits(struct extent_io_tree *tree,
  */
 static int insert_state(struct extent_io_tree *tree,
 			struct extent_state *state, u64 start, u64 end,
+			struct rb_node ***p,
+			struct rb_node **parent,
 			unsigned long *bits)
 {
 	struct rb_node *node;
@@ -397,7 +424,7 @@ static int insert_state(struct extent_io_tree *tree,
 
 	set_state_bits(tree, state, bits);
 
-	node = tree_insert(&tree->state, end, &state->rb_node);
+	node = tree_insert(&tree->state, end, &state->rb_node, p, parent);
 	if (node) {
 		struct extent_state *found;
 		found = rb_entry(node, struct extent_state, rb_node);
@@ -444,7 +471,8 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 	prealloc->state = orig->state;
 	orig->start = split;
 
-	node = tree_insert(&tree->state, prealloc->end, &prealloc->rb_node);
+	node = tree_insert(&tree->state, prealloc->end, &prealloc->rb_node,
+			   NULL, NULL);
 	if (node) {
 		free_extent_state(prealloc);
 		return -EEXIST;
@@ -783,6 +811,8 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
+	struct rb_node **p;
+	struct rb_node *parent;
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
@@ -809,11 +839,12 @@ again:
 	 * this search will find all the extents that end after
 	 * our range starts.
 	 */
-	node = tree_search(tree, start);
+	node = tree_search_for_insert(tree, start, &p, &parent);
 	if (!node) {
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
-		err = insert_state(tree, prealloc, start, end, &bits);
+		err = insert_state(tree, prealloc, start, end,
+				   &p, &parent, &bits);
 		if (err)
 			extent_io_tree_panic(tree, err);
 
@@ -920,7 +951,7 @@ hit_next:
 		 * the later extent.
 		 */
 		err = insert_state(tree, prealloc, start, this_end,
-				   &bits);
+				   NULL, NULL, &bits);
 		if (err)
 			extent_io_tree_panic(tree, err);
 
@@ -1006,6 +1037,8 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
+	struct rb_node **p;
+	struct rb_node *parent;
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
@@ -1033,14 +1066,15 @@ again:
 	 * this search will find all the extents that end after
 	 * our range starts.
 	 */
-	node = tree_search(tree, start);
+	node = tree_search_for_insert(tree, start, &p, &parent);
 	if (!node) {
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc) {
 			err = -ENOMEM;
 			goto out;
 		}
-		err = insert_state(tree, prealloc, start, end, &bits);
+		err = insert_state(tree, prealloc, start, end,
+				   &p, &parent, &bits);
 		if (err)
 			extent_io_tree_panic(tree, err);
 		cache_state(prealloc, cached_state);
@@ -1137,7 +1171,7 @@ hit_next:
 		 * the later extent.
 		 */
 		err = insert_state(tree, prealloc, start, this_end,
-				   &bits);
+				   NULL, NULL, &bits);
 		if (err)
 			extent_io_tree_panic(tree, err);
 		cache_state(prealloc, cached_state);
-- 
1.7.9.5

