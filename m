Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab3GCOAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:36 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODWv003963
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/12] Btrfs-progs: extend the extent cache for the device extent
Date: Wed, 3 Jul 2013 21:25:15 +0800
Message-Id: <1372857920-4678-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we know, btrfs can manage several devices in the same fs, so [offset, size]
is not sufficient for unique identification of an device extent, we need the
device id to identify the device extents which have the same offset and size,
but are not in the same device. So, we added a member variant named objectid
into the extent cache, and introduced some functions to make the extent cache
be suitable to manage the device extent.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-check.c   |  96 ++++++++++++++++++-----------------------
 extent-cache.c | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 extent-cache.h |  18 ++++++--
 extent_io.c    |  19 ++++----
 volumes.c      |  15 ++++---
 5 files changed, 192 insertions(+), 90 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index faf48e6..2a34839 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -268,7 +268,7 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 	struct inode_record *rec = NULL;
 	int ret;
 
-	cache = find_cache_extent(inode_cache, ino, 1);
+	cache = lookup_cache_extent(inode_cache, ino, 1);
 	if (cache) {
 		node = container_of(cache, struct ptr_node, cache);
 		rec = node->data;
@@ -375,7 +375,7 @@ static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 
 	BUG_ON(rec->refs != 1);
 	if (can_free_inode_rec(rec)) {
-		cache = find_cache_extent(inode_cache, rec->ino, 1);
+		cache = lookup_cache_extent(inode_cache, rec->ino, 1);
 		node = container_of(cache, struct ptr_node, cache);
 		BUG_ON(node->data != rec);
 		remove_cache_extent(inode_cache, &node->cache);
@@ -598,7 +598,7 @@ static int splice_shared_node(struct shared_node *src_node,
 	src = &src_node->root_cache;
 	dst = &dst_node->root_cache;
 again:
-	cache = find_first_cache_extent(src, 0);
+	cache = search_cache_extent(src, 0);
 	while (cache) {
 		node = container_of(cache, struct ptr_node, cache);
 		rec = node->data;
@@ -667,7 +667,7 @@ static struct shared_node *find_shared_node(struct cache_tree *shared,
 	struct cache_extent *cache;
 	struct shared_node *node;
 
-	cache = find_cache_extent(shared, bytenr, 1);
+	cache = lookup_cache_extent(shared, bytenr, 1);
 	if (cache) {
 		node = container_of(cache, struct shared_node, cache);
 		return node;
@@ -1355,7 +1355,7 @@ static int check_inode_recs(struct btrfs_root *root,
 	}
 
 	while (1) {
-		cache = find_first_cache_extent(inode_cache, 0);
+		cache = search_cache_extent(inode_cache, 0);
 		if (!cache)
 			break;
 		node = container_of(cache, struct ptr_node, cache);
@@ -1412,7 +1412,7 @@ static struct root_record *get_root_rec(struct cache_tree *root_cache,
 	struct root_record *rec = NULL;
 	int ret;
 
-	cache = find_cache_extent(root_cache, objectid, 1);
+	cache = lookup_cache_extent(root_cache, objectid, 1);
 	if (cache) {
 		rec = container_of(cache, struct root_record, cache);
 	} else {
@@ -1536,7 +1536,7 @@ static int merge_root_recs(struct btrfs_root *root,
 	}
 
 	while (1) {
-		cache = find_first_cache_extent(src_cache, 0);
+		cache = search_cache_extent(src_cache, 0);
 		if (!cache)
 			break;
 		node = container_of(cache, struct ptr_node, cache);
@@ -1586,7 +1586,7 @@ static int check_root_refs(struct btrfs_root *root,
 	/* fixme: this can not detect circular references */
 	while (loop) {
 		loop = 0;
-		cache = find_first_cache_extent(root_cache, 0);
+		cache = search_cache_extent(root_cache, 0);
 		while (1) {
 			if (!cache)
 				break;
@@ -1613,7 +1613,7 @@ static int check_root_refs(struct btrfs_root *root,
 		}
 	}
 
-	cache = find_first_cache_extent(root_cache, 0);
+	cache = search_cache_extent(root_cache, 0);
 	while (1) {
 		if (!cache)
 			break;
@@ -1989,14 +1989,14 @@ static int free_all_extent_backrefs(struct extent_record *rec)
 	return 0;
 }
 
-static void free_extent_cache(struct btrfs_fs_info *fs_info,
-			      struct cache_tree *extent_cache)
+static void free_extent_record_cache(struct btrfs_fs_info *fs_info,
+				     struct cache_tree *extent_cache)
 {
 	struct cache_extent *cache;
 	struct extent_record *rec;
 
 	while (1) {
-		cache = find_first_cache_extent(extent_cache, 0);
+		cache = first_cache_extent(extent_cache);
 		if (!cache)
 			break;
 		rec = container_of(cache, struct extent_record, cache);
@@ -2108,7 +2108,7 @@ static int record_bad_block_io(struct btrfs_fs_info *info,
 	struct cache_extent *cache;
 	struct btrfs_key key;
 
-	cache = find_cache_extent(extent_cache, start, len);
+	cache = lookup_cache_extent(extent_cache, start, len);
 	if (!cache)
 		return 0;
 
@@ -2130,7 +2130,7 @@ static int check_block(struct btrfs_root *root,
 	int ret = 1;
 	int level;
 
-	cache = find_cache_extent(extent_cache, buf->start, buf->len);
+	cache = lookup_cache_extent(extent_cache, buf->start, buf->len);
 	if (!cache)
 		return 1;
 	rec = container_of(cache, struct extent_record, cache);
@@ -2293,7 +2293,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	int ret = 0;
 	int dup = 0;
 
-	cache = find_cache_extent(extent_cache, start, nr);
+	cache = lookup_cache_extent(extent_cache, start, nr);
 	if (cache) {
 		rec = container_of(cache, struct extent_record, cache);
 		if (inc_ref)
@@ -2418,11 +2418,11 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 	struct tree_backref *back;
 	struct cache_extent *cache;
 
-	cache = find_cache_extent(extent_cache, bytenr, 1);
+	cache = lookup_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
 		add_extent_rec(extent_cache, NULL, bytenr,
 			       1, 0, 0, 0, 0, 1, 0, 0);
-		cache = find_cache_extent(extent_cache, bytenr, 1);
+		cache = lookup_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
 			abort();
 	}
@@ -2466,11 +2466,11 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	struct data_backref *back;
 	struct cache_extent *cache;
 
-	cache = find_cache_extent(extent_cache, bytenr, 1);
+	cache = lookup_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
 		add_extent_rec(extent_cache, NULL, bytenr, 1, 0, 0, 0, 0,
 			       0, 0, max_size);
-		cache = find_cache_extent(extent_cache, bytenr, 1);
+		cache = lookup_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
 			abort();
 	}
@@ -2545,7 +2545,7 @@ static int pick_next_pending(struct cache_tree *pending,
 	struct cache_extent *cache;
 	int ret;
 
-	cache = find_first_cache_extent(reada, 0);
+	cache = search_cache_extent(reada, 0);
 	if (cache) {
 		bits[0].start = cache->start;
 		bits[1].size = cache->size;
@@ -2556,12 +2556,12 @@ static int pick_next_pending(struct cache_tree *pending,
 	if (node_start > 32768)
 		node_start -= 32768;
 
-	cache = find_first_cache_extent(nodes, node_start);
+	cache = search_cache_extent(nodes, node_start);
 	if (!cache)
-		cache = find_first_cache_extent(nodes, 0);
+		cache = search_cache_extent(nodes, 0);
 
 	if (!cache) {
-		 cache = find_first_cache_extent(pending, 0);
+		 cache = search_cache_extent(pending, 0);
 		 if (!cache)
 			 return 0;
 		 ret = 0;
@@ -2585,7 +2585,7 @@ static int pick_next_pending(struct cache_tree *pending,
 	if (bits_nr - ret > 8) {
 		u64 lookup = bits[0].start + bits[0].size;
 		struct cache_extent *next;
-		next = find_first_cache_extent(pending, lookup);
+		next = search_cache_extent(pending, lookup);
 		while(next) {
 			if (next->start - lookup > 32768)
 				break;
@@ -3182,17 +3182,17 @@ static int run_next_block(struct btrfs_root *root,
 	bytenr = bits[0].start;
 	size = bits[0].size;
 
-	cache = find_cache_extent(pending, bytenr, size);
+	cache = lookup_cache_extent(pending, bytenr, size);
 	if (cache) {
 		remove_cache_extent(pending, cache);
 		free(cache);
 	}
-	cache = find_cache_extent(reada, bytenr, size);
+	cache = lookup_cache_extent(reada, bytenr, size);
 	if (cache) {
 		remove_cache_extent(reada, cache);
 		free(cache);
 	}
-	cache = find_cache_extent(nodes, bytenr, size);
+	cache = lookup_cache_extent(nodes, bytenr, size);
 	if (cache) {
 		remove_cache_extent(nodes, cache);
 		free(cache);
@@ -3400,7 +3400,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 	struct cache_tree *extent_cache = root->fs_info->fsck_extent_cache;
 
 	is_data = owner >= BTRFS_FIRST_FREE_OBJECTID;
-	cache = find_cache_extent(extent_cache, bytenr, num_bytes);
+	cache = lookup_cache_extent(extent_cache, bytenr, num_bytes);
 	if (!cache)
 		return 0;
 
@@ -4070,8 +4070,8 @@ static int process_duplicates(struct btrfs_root *root,
 	good->refs = rec->refs;
 	list_splice_init(&rec->backrefs, &good->backrefs);
 	while (1) {
-		cache = find_cache_extent(extent_cache, good->start,
-					  good->nr);
+		cache = lookup_cache_extent(extent_cache, good->start,
+					    good->nr);
 		if (!cache)
 			break;
 		tmp = container_of(cache, struct extent_record, cache);
@@ -4244,7 +4244,8 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 		goto out;
 
 	/* was this block corrupt?  If so, don't add references to it */
-	cache = find_cache_extent(info->corrupt_blocks, rec->start, rec->max_size);
+	cache = lookup_cache_extent(info->corrupt_blocks,
+				    rec->start, rec->max_size);
 	if (cache) {
 		ret = 0;
 		goto out;
@@ -4348,7 +4349,7 @@ static int prune_corrupt_blocks(struct btrfs_trans_handle *trans,
 	struct cache_extent *cache;
 	struct btrfs_corrupt_block *corrupt;
 
-	cache = find_first_cache_extent(info->corrupt_blocks, 0);
+	cache = search_cache_extent(info->corrupt_blocks, 0);
 	while (1) {
 		if (!cache)
 			break;
@@ -4407,7 +4408,7 @@ static int check_block_groups(struct btrfs_trans_handle *trans,
 	/* this isn't quite working */
 	return 0;
 
-	ce = find_first_cache_extent(&map_tree->cache_tree, 0);
+	ce = search_cache_extent(&map_tree->cache_tree, 0);
 	while (1) {
 		if (!ce)
 			break;
@@ -4463,7 +4464,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 		 * In the worst case, this will be all the
 		 * extents in the FS
 		 */
-		cache = find_first_cache_extent(extent_cache, 0);
+		cache = search_cache_extent(extent_cache, 0);
 		while(cache) {
 			rec = container_of(cache, struct extent_record, cache);
 			btrfs_pin_extent(root->fs_info,
@@ -4472,7 +4473,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 		}
 
 		/* pin down all the corrupted blocks too */
-		cache = find_first_cache_extent(root->fs_info->corrupt_blocks, 0);
+		cache = search_cache_extent(root->fs_info->corrupt_blocks, 0);
 		while(cache) {
 			rec = container_of(cache, struct extent_record, cache);
 			btrfs_pin_extent(root->fs_info,
@@ -4522,7 +4523,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 
 	while(1) {
 		fixed = 0;
-		cache = find_first_cache_extent(extent_cache, 0);
+		cache = search_cache_extent(extent_cache, 0);
 		if (!cache)
 			break;
 		rec = container_of(cache, struct extent_record, cache);
@@ -4594,19 +4595,6 @@ repair_abort:
 	return err;
 }
 
-static void free_cache_tree(struct cache_tree *tree)
-{
-	struct cache_extent *cache;
-
-	while (1) {
-		cache = find_first_cache_extent(tree, 0);
-		if (!cache)
-			break;
-		remove_cache_extent(tree, cache);
-		free(cache);
-	}
-}
-
 static int check_extents(struct btrfs_root *root, int repair)
 {
 	struct cache_tree extent_cache;
@@ -4716,11 +4704,11 @@ again:
 		}
 
 		free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
-		free_cache_tree(&seen);
-		free_cache_tree(&pending);
-		free_cache_tree(&reada);
-		free_cache_tree(&nodes);
-		free_extent_cache(root->fs_info, &extent_cache);
+		free_extent_cache_tree(&seen);
+		free_extent_cache_tree(&pending);
+		free_extent_cache_tree(&reada);
+		free_extent_cache_tree(&nodes);
+		free_extent_record_cache(root->fs_info, &extent_cache);
 		goto again;
 	}
 
diff --git a/extent-cache.c b/extent-cache.c
index a09fe87..84de87b 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -21,15 +21,11 @@
 #include "extent-cache.h"
 
 struct cache_extent_search_range {
+	u64 objectid;
 	u64 start;
 	u64 size;
 };
 
-void cache_tree_init(struct cache_tree *tree)
-{
-	tree->root = RB_ROOT;
-}
-
 static int cache_tree_comp_range(struct rb_node *node, void *data)
 {
 	struct cache_extent *entry;
@@ -58,26 +54,62 @@ static int cache_tree_comp_nodes(struct rb_node *node1, struct rb_node *node2)
 	return cache_tree_comp_range(node1, (void *)&range);
 }
 
-struct cache_extent *alloc_cache_extent(u64 start, u64 size)
+static int cache_tree_comp_range2(struct rb_node *node, void *data)
+{
+	struct cache_extent *entry;
+	struct cache_extent_search_range *range;
+
+	range = (struct cache_extent_search_range *)data;
+	entry = rb_entry(node, struct cache_extent, rb_node);
+
+	if (entry->objectid < range->objectid)
+		return 1;
+	else if (entry->objectid > range->objectid)
+		return -1;
+	else if (entry->start + entry->size <= range->start)
+		return 1;
+	else if (range->start + range->size <= entry->start)
+		return -1;
+	else
+		return 0;
+}
+
+static int cache_tree_comp_nodes2(struct rb_node *node1, struct rb_node *node2)
+{
+	struct cache_extent *entry;
+	struct cache_extent_search_range range;
+
+	entry = rb_entry(node2, struct cache_extent, rb_node);
+	range.objectid = entry->objectid;
+	range.start = entry->start;
+	range.size = entry->size;
+
+	return cache_tree_comp_range2(node1, (void *)&range);
+}
+
+void cache_tree_init(struct cache_tree *tree)
+{
+	tree->root = RB_ROOT;
+}
+
+static struct cache_extent *
+alloc_cache_extent(u64 objectid, u64 start, u64 size)
 {
 	struct cache_extent *pe = malloc(sizeof(*pe));
 
 	if (!pe)
 		return pe;
 
+	pe->objectid = objectid;
 	pe->start = start;
 	pe->size = size;
 	return pe;
 }
 
-int insert_cache_extent(struct cache_tree *tree, struct cache_extent *pe)
-{
-	return rb_insert(&tree->root, &pe->rb_node, cache_tree_comp_nodes);
-}
-
-int add_cache_extent(struct cache_tree *tree, u64 start, u64 size)
+static int __add_cache_extent(struct cache_tree *tree,
+			      u64 objectid, u64 start, u64 size)
 {
-	struct cache_extent *pe = alloc_cache_extent(start, size);
+	struct cache_extent *pe = alloc_cache_extent(objectid, start, size);
 	int ret;
 
 	if (!pe) {
@@ -92,8 +124,29 @@ int add_cache_extent(struct cache_tree *tree, u64 start, u64 size)
 	return ret;
 }
 
-struct cache_extent *find_cache_extent(struct cache_tree *tree,
-				       u64 start, u64 size)
+int add_cache_extent(struct cache_tree *tree, u64 start, u64 size)
+{
+	return __add_cache_extent(tree, 0, start, size);
+}
+
+int add_cache_extent2(struct cache_tree *tree,
+		      u64 objectid, u64 start, u64 size)
+{
+	return __add_cache_extent(tree, objectid, start, size);
+}
+
+int insert_cache_extent(struct cache_tree *tree, struct cache_extent *pe)
+{
+	return rb_insert(&tree->root, &pe->rb_node, cache_tree_comp_nodes);
+}
+
+int insert_cache_extent2(struct cache_tree *tree, struct cache_extent *pe)
+{
+	return rb_insert(&tree->root, &pe->rb_node, cache_tree_comp_nodes2);
+}
+
+struct cache_extent *lookup_cache_extent(struct cache_tree *tree,
+					 u64 start, u64 size)
 {
 	struct rb_node *node;
 	struct cache_extent *entry;
@@ -109,7 +162,25 @@ struct cache_extent *find_cache_extent(struct cache_tree *tree,
 	return entry;
 }
 
-struct cache_extent *find_first_cache_extent(struct cache_tree *tree, u64 start)
+struct cache_extent *lookup_cache_extent2(struct cache_tree *tree,
+					 u64 objectid, u64 start, u64 size)
+{
+	struct rb_node *node;
+	struct cache_extent *entry;
+	struct cache_extent_search_range range;
+
+	range.objectid = objectid;
+	range.start = start;
+	range.size = size;
+	node = rb_search(&tree->root, &range, cache_tree_comp_range2, NULL);
+	if (!node)
+		return NULL;
+
+	entry = rb_entry(node, struct cache_extent, rb_node);
+	return entry;
+}
+
+struct cache_extent *search_cache_extent(struct cache_tree *tree, u64 start)
 {
 	struct rb_node *next;
 	struct rb_node *node;
@@ -128,6 +199,27 @@ struct cache_extent *find_first_cache_extent(struct cache_tree *tree, u64 start)
 	return entry;
 }
 
+struct cache_extent *search_cache_extent2(struct cache_tree *tree,
+					 u64 objectid, u64 start)
+{
+	struct rb_node *next;
+	struct rb_node *node;
+	struct cache_extent *entry;
+	struct cache_extent_search_range range;
+
+	range.objectid = objectid;
+	range.start = start;
+	range.size = 1;
+	node = rb_search(&tree->root, &range, cache_tree_comp_range2, &next);
+	if (!node)
+		node = next;
+	if (!node)
+		return NULL;
+
+	entry = rb_entry(node, struct cache_extent, rb_node);
+	return entry;
+}
+
 struct cache_extent *first_cache_extent(struct cache_tree *tree)
 {
 	struct rb_node *node = rb_first(&tree->root);
@@ -170,3 +262,13 @@ void cache_tree_free_extents(struct cache_tree *tree,
 		free_func(ce);
 	}
 }
+
+static void free_extent_cache(struct cache_extent *pe)
+{
+	free(pe);
+}
+
+void free_extent_cache_tree(struct cache_tree *tree)
+{
+	cache_tree_free_extents(tree, free_extent_cache);
+}
diff --git a/extent-cache.h b/extent-cache.h
index 2979fc3..cba83d1 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -33,6 +33,7 @@ struct cache_tree {
 
 struct cache_extent {
 	struct rb_node rb_node;
+	u64 objectid;
 	u64 start;
 	u64 size;
 };
@@ -43,10 +44,9 @@ struct cache_extent *first_cache_extent(struct cache_tree *tree);
 struct cache_extent *prev_cache_extent(struct cache_extent *pe);
 struct cache_extent *next_cache_extent(struct cache_extent *pe);
 
-struct cache_extent *find_first_cache_extent(struct cache_tree *tree,
-					     u64 start);
-struct cache_extent *find_cache_extent(struct cache_tree *tree,
-				       u64 start, u64 size);
+struct cache_extent *search_cache_extent(struct cache_tree *tree, u64 start);
+struct cache_extent *lookup_cache_extent(struct cache_tree *tree,
+					 u64 start, u64 size);
 
 int add_cache_extent(struct cache_tree *tree, u64 start, u64 size);
 int insert_cache_extent(struct cache_tree *tree, struct cache_extent *pe);
@@ -68,4 +68,14 @@ static void free_##name##_tree(struct cache_tree *tree)		\
 	cache_tree_free_extents(tree, free_func);		\
 }
 
+void free_extent_cache_tree(struct cache_tree *tree);
+
+struct cache_extent *search_cache_extent2(struct cache_tree *tree,
+					  u64 objectid, u64 start);
+struct cache_extent *lookup_cache_extent2(struct cache_tree *tree,
+					  u64 objectid, u64 start, u64 size);
+int add_cache_extent2(struct cache_tree *tree,
+		      u64 objectid, u64 start, u64 size);
+int insert_cache_extent2(struct cache_tree *tree, struct cache_extent *pe);
+
 #endif
diff --git a/extent_io.c b/extent_io.c
index 1e5d25a..377dec0 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -48,6 +48,7 @@ static struct extent_state *alloc_extent_state(void)
 	state = malloc(sizeof(*state));
 	if (!state)
 		return NULL;
+	state->cache_node.objectid = 0;
 	state->refs = 1;
 	state->state = 0;
 	state->xprivate = 0;
@@ -217,7 +218,7 @@ again:
 	 * this search will find the extents that end after
 	 * our range starts
 	 */
-	node = find_first_cache_extent(&tree->state, start);
+	node = search_cache_extent(&tree->state, start);
 	if (!node)
 		goto out;
 	state = container_of(node, struct extent_state, cache_node);
@@ -311,7 +312,7 @@ again:
 	 * this search will find the extents that end after
 	 * our range starts
 	 */
-	node = find_first_cache_extent(&tree->state, start);
+	node = search_cache_extent(&tree->state, start);
 	if (!node) {
 		err = insert_state(tree, prealloc, start, end, bits);
 		BUG_ON(err == -EEXIST);
@@ -438,7 +439,7 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 	 * this search will find all the extents that end after
 	 * our range starts.
 	 */
-	node = find_first_cache_extent(&tree->state, start);
+	node = search_cache_extent(&tree->state, start);
 	if (!node)
 		goto out;
 
@@ -465,7 +466,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct cache_extent *node;
 	int bitset = 0;
 
-	node = find_first_cache_extent(&tree->state, start);
+	node = search_cache_extent(&tree->state, start);
 	while (node && start <= end) {
 		state = container_of(node, struct extent_state, cache_node);
 
@@ -502,7 +503,7 @@ int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 	struct extent_state *state;
 	int ret = 0;
 
-	node = find_first_cache_extent(&tree->state, start);
+	node = search_cache_extent(&tree->state, start);
 	if (!node) {
 		ret = -ENOENT;
 		goto out;
@@ -523,7 +524,7 @@ int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 	struct extent_state *state;
 	int ret = 0;
 
-	node = find_first_cache_extent(&tree->state, start);
+	node = search_cache_extent(&tree->state, start);
 	if (!node) {
 		ret = -ENOENT;
 		goto out;
@@ -620,7 +621,7 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 	struct extent_buffer *eb = NULL;
 	struct cache_extent *cache;
 
-	cache = find_cache_extent(&tree->cache, bytenr, blocksize);
+	cache = lookup_cache_extent(&tree->cache, bytenr, blocksize);
 	if (cache && cache->start == bytenr &&
 	    cache->size == blocksize) {
 		eb = container_of(cache, struct extent_buffer, cache_node);
@@ -636,7 +637,7 @@ struct extent_buffer *find_first_extent_buffer(struct extent_io_tree *tree,
 	struct extent_buffer *eb = NULL;
 	struct cache_extent *cache;
 
-	cache = find_first_cache_extent(&tree->cache, start);
+	cache = search_cache_extent(&tree->cache, start);
 	if (cache) {
 		eb = container_of(cache, struct extent_buffer, cache_node);
 		list_move_tail(&eb->lru, &tree->lru);
@@ -651,7 +652,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	struct extent_buffer *eb;
 	struct cache_extent *cache;
 
-	cache = find_cache_extent(&tree->cache, bytenr, blocksize);
+	cache = lookup_cache_extent(&tree->cache, bytenr, blocksize);
 	if (cache && cache->start == bytenr &&
 	    cache->size == blocksize) {
 		eb = container_of(cache, struct extent_buffer, cache_node);
diff --git a/volumes.c b/volumes.c
index e8e7907..a3acee8 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1014,7 +1014,7 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	struct map_lookup *map;
 	int ret;
 
-	ce = find_first_cache_extent(&map_tree->cache_tree, logical);
+	ce = search_cache_extent(&map_tree->cache_tree, logical);
 	BUG_ON(!ce);
 	BUG_ON(ce->start > logical || ce->start + ce->size < logical);
 	map = container_of(ce, struct map_lookup, ce);
@@ -1038,7 +1038,7 @@ int btrfs_next_metadata(struct btrfs_mapping_tree *map_tree, u64 *logical,
 	struct cache_extent *ce;
 	struct map_lookup *map;
 
-	ce = find_first_cache_extent(&map_tree->cache_tree, *logical);
+	ce = search_cache_extent(&map_tree->cache_tree, *logical);
 
 	while (ce) {
 		ce = next_cache_extent(ce);
@@ -1069,7 +1069,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	u64 rmap_len;
 	int i, j, nr = 0;
 
-	ce = find_first_cache_extent(&map_tree->cache_tree, chunk_start);
+	ce = search_cache_extent(&map_tree->cache_tree, chunk_start);
 	BUG_ON(!ce);
 	map = container_of(ce, struct map_lookup, ce);
 
@@ -1181,7 +1181,7 @@ int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		stripes_allocated = 1;
 	}
 again:
-	ce = find_first_cache_extent(&map_tree->cache_tree, logical);
+	ce = search_cache_extent(&map_tree->cache_tree, logical);
 	if (!ce) {
 		if (multi)
 			kfree(multi);
@@ -1447,7 +1447,8 @@ int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 	if (ret == -EEXIST) {
 		struct cache_extent *old;
 		struct map_lookup *old_map;
-		old = find_cache_extent(&map_tree->cache_tree, logical, length);
+		old = lookup_cache_extent(&map_tree->cache_tree,
+					  logical, length);
 		old_map = container_of(old, struct map_lookup, ce);
 		remove_cache_extent(&map_tree->cache_tree, old);
 		kfree(old_map);
@@ -1466,7 +1467,7 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	int readonly = 0;
 	int i;
 
-	ce = find_first_cache_extent(&map_tree->cache_tree, chunk_offset);
+	ce = search_cache_extent(&map_tree->cache_tree, chunk_offset);
 	BUG_ON(!ce);
 
 	map = container_of(ce, struct map_lookup, ce);
@@ -1508,7 +1509,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
 
-	ce = find_first_cache_extent(&map_tree->cache_tree, logical);
+	ce = search_cache_extent(&map_tree->cache_tree, logical);
 
 	/* already mapped? */
 	if (ce && ce->start <= logical && ce->start + ce->size > logical) {
-- 
1.8.1.4

