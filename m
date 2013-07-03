Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3GCOAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:36 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODWu003963
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/12] Btrfs-progs: introduce common insert/search/delete functions for rb-tree
Date: Wed, 3 Jul 2013 21:25:13 +0800
Message-Id: <1372857920-4678-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In fact, the code of many rb-tree insert/search/delete functions is similar,
so we can abstract them, and implement common functions for rb-tree, and then
simplify them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-list.c   |  19 +++-----
 cmds-check.c   | 111 +++++++++++++++++++-----------------------
 disk-io.c      |  39 ++++++---------
 disk-io.h      |   2 +-
 extent-cache.c | 150 +++++++++++++++++++++++++++++----------------------------
 extent-cache.h |  36 ++++++++------
 extent_io.c    |  45 ++++++++---------
 rbtree.c       |  63 ++++++++++++++++++++++++
 rbtree.h       |  24 +++++++--
 repair.c       |   2 +-
 volumes.c      |  22 ++++-----
 11 files changed, 284 insertions(+), 229 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index c3d35de..4fab858 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -513,8 +513,11 @@ static int add_root(struct root_lookup *root_lookup,
 	return 0;
 }
 
-void __free_root_info(struct root_info *ri)
+static void __free_root_info(struct rb_node *node)
 {
+	struct root_info *ri;
+
+	ri = rb_entry(node, struct root_info, rb_node);
 	if (ri->name)
 		free(ri->name);
 
@@ -527,19 +530,9 @@ void __free_root_info(struct root_info *ri)
 	free(ri);
 }
 
-void __free_all_subvolumn(struct root_lookup *root_tree)
+static inline void __free_all_subvolumn(struct root_lookup *root_tree)
 {
-	struct root_info *entry;
-	struct rb_node *n;
-
-	n = rb_first(&root_tree->root);
-	while (n) {
-		entry = rb_entry(n, struct root_info, rb_node);
-		rb_erase(n, &root_tree->root);
-		__free_root_info(entry);
-
-		n = rb_first(&root_tree->root);
-	}
+	rb_free_nodes(&root_tree->root, __free_root_info);
 }
 
 /*
diff --git a/cmds-check.c b/cmds-check.c
index 68cdd52..faf48e6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -293,7 +293,7 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		if (ino == BTRFS_FREE_INO_OBJECTID)
 			rec->found_link = 1;
 
-		ret = insert_existing_cache_extent(inode_cache, &node->cache);
+		ret = insert_cache_extent(inode_cache, &node->cache);
 		BUG_ON(ret);
 	}
 	return rec;
@@ -614,7 +614,7 @@ again:
 			ins->data = rec;
 			rec->refs++;
 		}
-		ret = insert_existing_cache_extent(dst, &ins->cache);
+		ret = insert_cache_extent(dst, &ins->cache);
 		if (ret == -EEXIST) {
 			conflict = get_inode_rec(dst, rec->ino, 1);
 			merge_inode_recs(rec, conflict, dst);
@@ -648,24 +648,19 @@ again:
 	return 0;
 }
 
-static void free_inode_recs(struct cache_tree *inode_cache)
+static void free_inode_ptr(struct cache_extent *cache)
 {
-	struct cache_extent *cache;
 	struct ptr_node *node;
 	struct inode_record *rec;
 
-	while (1) {
-		cache = find_first_cache_extent(inode_cache, 0);
-		if (!cache)
-			break;
-		node = container_of(cache, struct ptr_node, cache);
-		rec = node->data;
-		remove_cache_extent(inode_cache, &node->cache);
-		free(node);
-		free_inode_rec(rec);
-	}
+	node = container_of(cache, struct ptr_node, cache);
+	rec = node->data;
+	free_inode_rec(rec);
+	free(node);
 }
 
+FREE_EXTENT_CACHE_BASED_TREE(inode_recs, free_inode_ptr);
+
 static struct shared_node *find_shared_node(struct cache_tree *shared,
 					    u64 bytenr)
 {
@@ -692,7 +687,7 @@ static int add_shared_node(struct cache_tree *shared, u64 bytenr, u32 refs)
 	cache_tree_init(&node->inode_cache);
 	node->refs = refs;
 
-	ret = insert_existing_cache_extent(shared, &node->cache);
+	ret = insert_cache_extent(shared, &node->cache);
 	BUG_ON(ret);
 	return 0;
 }
@@ -719,8 +714,8 @@ static int enter_shared_node(struct btrfs_root *root, u64 bytenr, u32 refs,
 	if (wc->root_level == wc->active_node &&
 	    btrfs_root_refs(&root->root_item) == 0) {
 		if (--node->refs == 0) {
-			free_inode_recs(&node->root_cache);
-			free_inode_recs(&node->inode_cache);
+			free_inode_recs_tree(&node->root_cache);
+			free_inode_recs_tree(&node->inode_cache);
 			remove_cache_extent(&wc->shared, &node->cache);
 			free(node);
 		}
@@ -1427,7 +1422,7 @@ static struct root_record *get_root_rec(struct cache_tree *root_cache,
 		rec->cache.start = objectid;
 		rec->cache.size = 1;
 
-		ret = insert_existing_cache_extent(root_cache, &rec->cache);
+		ret = insert_cache_extent(root_cache, &rec->cache);
 		BUG_ON(ret);
 	}
 	return rec;
@@ -1460,29 +1455,24 @@ static struct root_backref *get_root_backref(struct root_record *rec,
 	return backref;
 }
 
-static void free_root_recs(struct cache_tree *root_cache)
+static void free_root_record(struct cache_extent *cache)
 {
-	struct cache_extent *cache;
 	struct root_record *rec;
 	struct root_backref *backref;
 
-	while (1) {
-		cache = find_first_cache_extent(root_cache, 0);
-		if (!cache)
-			break;
-		rec = container_of(cache, struct root_record, cache);
-		remove_cache_extent(root_cache, &rec->cache);
-
-		while (!list_empty(&rec->backrefs)) {
-			backref = list_entry(rec->backrefs.next,
-					     struct root_backref, list);
-			list_del(&backref->list);
-			free(backref);
-		}
-		kfree(rec);
+	rec = container_of(cache, struct root_record, cache);
+	while (!list_empty(&rec->backrefs)) {
+		backref = list_entry(rec->backrefs.next,
+				     struct root_backref, list);
+		list_del(&backref->list);
+		free(backref);
 	}
+
+	kfree(rec);
 }
 
+FREE_EXTENT_CACHE_BASED_TREE(root_recs, free_root_record);
+
 static int add_root_backref(struct cache_tree *root_cache,
 			    u64 root_id, u64 ref_root, u64 dir, u64 index,
 			    const char *name, int namelen,
@@ -1541,7 +1531,7 @@ static int merge_root_recs(struct btrfs_root *root,
 	struct inode_backref *backref;
 
 	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
-		free_inode_recs(src_cache);
+		free_inode_recs_tree(src_cache);
 		return 0;
 	}
 
@@ -1855,7 +1845,7 @@ static int check_fs_roots(struct btrfs_root *root,
 			ret = check_fs_root(tmp_root, root_cache, &wc);
 			if (ret)
 				err = 1;
-			btrfs_free_fs_root(root->fs_info, tmp_root);
+			btrfs_free_fs_root(tmp_root);
 		} else if (key.type == BTRFS_ROOT_REF_KEY ||
 			   key.type == BTRFS_ROOT_BACKREF_KEY) {
 			process_root_ref(leaf, path.slots[0], &key,
@@ -1935,7 +1925,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long long)rec->start,
 					back->full_backref ?
 					"parent" : "root",
-					back->full_backref ? 
+					back->full_backref ?
 					(unsigned long long)dback->parent:
 					(unsigned long long)dback->root,
 					(unsigned long long)dback->owner,
@@ -2411,7 +2401,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 
 	rec->cache.start = start;
 	rec->cache.size = nr;
-	ret = insert_existing_cache_extent(extent_cache, &rec->cache);
+	ret = insert_cache_extent(extent_cache, &rec->cache);
 	BUG_ON(ret);
 	bytes_used += nr;
 	if (set_checked) {
@@ -2538,10 +2528,10 @@ static int add_pending(struct cache_tree *pending,
 		       struct cache_tree *seen, u64 bytenr, u32 size)
 {
 	int ret;
-	ret = insert_cache_extent(seen, bytenr, size);
+	ret = add_cache_extent(seen, bytenr, size);
 	if (ret)
 		return ret;
-	insert_cache_extent(pending, bytenr, size);
+	add_cache_extent(pending, bytenr, size);
 	return 0;
 }
 
@@ -3171,15 +3161,17 @@ static int run_next_block(struct btrfs_root *root,
 	struct cache_extent *cache;
 	int reada_bits;
 
-	ret = pick_next_pending(pending, reada, nodes, *last, bits,
-				bits_nr, &reada_bits);
-	if (ret == 0) {
+	nritems = pick_next_pending(pending, reada, nodes, *last, bits,
+				    bits_nr, &reada_bits);
+	if (nritems == 0)
 		return 1;
-	}
+
 	if (!reada_bits) {
-		for(i = 0; i < ret; i++) {
-			insert_cache_extent(reada, bits[i].start,
-					    bits[i].size);
+		for(i = 0; i < nritems; i++) {
+			ret = add_cache_extent(reada, bits[i].start,
+					       bits[i].size);
+			if (ret == -EEXIST)
+				continue;
 
 			/* fixme, get the parent transid */
 			readahead_tree_block(root, bits[i].start,
@@ -3295,7 +3287,7 @@ static int run_next_block(struct btrfs_root *root,
 				ref = btrfs_item_ptr(buf, i,
 						struct btrfs_shared_data_ref);
 				add_data_backref(extent_cache,
-					key.objectid, key.offset, 0, 0, 0, 
+					key.objectid, key.offset, 0, 0, 0,
 					btrfs_shared_data_ref_count(buf, ref),
 					0, root->sectorsize);
 				continue;
@@ -4110,7 +4102,7 @@ static int process_duplicates(struct btrfs_root *root,
 		remove_cache_extent(extent_cache, &tmp->cache);
 		free(tmp);
 	}
-	ret = insert_existing_cache_extent(extent_cache, &good->cache);
+	ret = insert_cache_extent(extent_cache, &good->cache);
 	BUG_ON(ret);
 	free(rec);
 	return good->num_duplicates ? 0 : 1;
@@ -4367,21 +4359,16 @@ static int prune_corrupt_blocks(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static void free_corrupt_blocks(struct btrfs_fs_info *info)
+static void free_corrupt_block(struct cache_extent *cache)
 {
-	struct cache_extent *cache;
 	struct btrfs_corrupt_block *corrupt;
 
-	while (1) {
-		cache = find_first_cache_extent(info->corrupt_blocks, 0);
-		if (!cache)
-			break;
-		corrupt = container_of(cache, struct btrfs_corrupt_block, cache);
-		remove_cache_extent(info->corrupt_blocks, cache);
-		free(corrupt);
-	}
+	corrupt = container_of(cache, struct btrfs_corrupt_block, cache);
+	free(corrupt);
 }
 
+FREE_EXTENT_CACHE_BASED_TREE(corrupt_blocks, free_corrupt_block);
+
 static int check_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *info,
 			      struct map_lookup *map,
@@ -4728,7 +4715,7 @@ again:
 			goto out;
 		}
 
-		free_corrupt_blocks(root->fs_info);
+		free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
 		free_cache_tree(&seen);
 		free_cache_tree(&pending);
 		free_cache_tree(&reada);
@@ -4746,7 +4733,7 @@ again:
 	}
 out:
 	if (repair) {
-		free_corrupt_blocks(root->fs_info);
+		free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
 		root->fs_info->fsck_extent_cache = NULL;
 		root->fs_info->free_extent_hook = NULL;
 		root->fs_info->corrupt_blocks = NULL;
@@ -5254,7 +5241,7 @@ int cmd_check(int argc, char **argv)
 	fprintf(stderr, "checking root refs\n");
 	ret = check_root_refs(root, &root_cache);
 out:
-	free_root_recs(&root_cache);
+	free_root_recs_tree(&root_cache);
 	close_ctree(root);
 
 	if (found_old_backref) { /*
diff --git a/disk-io.c b/disk-io.c
index 8116afc..4541573 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -671,8 +671,7 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 }
 
 
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info,
-		       struct btrfs_root *root)
+int btrfs_free_fs_root(struct btrfs_root *root)
 {
 	if (root->node)
 		free_extent_buffer(root->node);
@@ -682,22 +681,16 @@ int btrfs_free_fs_root(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int free_fs_roots(struct btrfs_fs_info *fs_info)
+static void __free_fs_root(struct cache_extent *cache)
 {
-	struct cache_extent *cache;
 	struct btrfs_root *root;
 
-	while (1) {
-		cache = find_first_cache_extent(&fs_info->fs_root_cache, 0);
-		if (!cache)
-			break;
-		root = container_of(cache, struct btrfs_root, cache);
-		remove_cache_extent(&fs_info->fs_root_cache, cache);
-		btrfs_free_fs_root(fs_info, root);
-	}
-	return 0;
+	root = container_of(cache, struct btrfs_root, cache);
+	btrfs_free_fs_root(root);
 }
 
+FREE_EXTENT_CACHE_BASED_TREE(fs_roots, __free_fs_root);
+
 struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 					       struct btrfs_key *location)
 {
@@ -790,8 +783,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 
 	root->cache.start = location->objectid;
 	root->cache.size = 1;
-	ret = insert_existing_cache_extent(&fs_info->fs_root_cache,
-					   &root->cache);
+	ret = insert_cache_extent(&fs_info->fs_root_cache, &root->cache);
 	BUG_ON(ret);
 	return root;
 }
@@ -989,22 +981,19 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
 		free_extent_buffer(fs_info->chunk_root->node);
 }
 
-static void free_mapping_cache(struct btrfs_fs_info *fs_info)
+static void free_map_lookup(struct cache_extent *ce)
 {
-	struct cache_tree *cache_tree = &fs_info->mapping_tree.cache_tree;
-	struct cache_extent *ce;
 	struct map_lookup *map;
 
-	while ((ce = find_first_cache_extent(cache_tree, 0))) {
-		map = container_of(ce, struct map_lookup, ce);
-		remove_cache_extent(cache_tree, ce);
-		kfree(map);
-	}
+	map = container_of(ce, struct map_lookup, ce);
+	kfree(map);
 }
 
+FREE_EXTENT_CACHE_BASED_TREE(mapping_cache, free_map_lookup);
+
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 {
-	free_mapping_cache(fs_info);
+	free_mapping_cache_tree(&fs_info->mapping_tree.cache_tree);
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
 	extent_io_tree_cleanup(&fs_info->block_group_cache);
@@ -1394,7 +1383,7 @@ int close_ctree(struct btrfs_root *root)
 	}
 	btrfs_free_block_groups(fs_info);
 
-	free_fs_roots(fs_info);
+	free_fs_roots_tree(&fs_info->fs_root_cache);
 
 	btrfs_release_all_roots(fs_info);
 	btrfs_close_devices(fs_info->fs_devices);
diff --git a/disk-io.h b/disk-io.h
index 2fe2d72..e845459 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -78,7 +78,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 				      struct btrfs_key *location);
 struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 					       struct btrfs_key *location);
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
+int btrfs_free_fs_root(struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
diff --git a/extent-cache.c b/extent-cache.c
index 3dd6434..a09fe87 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -20,65 +20,42 @@
 #include "kerncompat.h"
 #include "extent-cache.h"
 
+struct cache_extent_search_range {
+	u64 start;
+	u64 size;
+};
+
 void cache_tree_init(struct cache_tree *tree)
 {
-	tree->root.rb_node = NULL;
+	tree->root = RB_ROOT;
 }
 
-static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
-				   u64 size, struct rb_node *node)
+static int cache_tree_comp_range(struct rb_node *node, void *data)
 {
-	struct rb_node ** p = &root->rb_node;
-	struct rb_node * parent = NULL;
 	struct cache_extent *entry;
+	struct cache_extent_search_range *range;
 
-	while(*p) {
-		parent = *p;
-		entry = rb_entry(parent, struct cache_extent, rb_node);
-
-		if (offset + size <= entry->start)
-			p = &(*p)->rb_left;
-		else if (offset >= entry->start + entry->size)
-			p = &(*p)->rb_right;
-		else
-			return parent;
-	}
+	range = (struct cache_extent_search_range *)data;
+	entry = rb_entry(node, struct cache_extent, rb_node);
 
-	entry = rb_entry(parent, struct cache_extent, rb_node);
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
-	return NULL;
+	if (entry->start + entry->size <= range->start)
+		return 1;
+	else if (range->start + range->size <= entry->start)
+		return -1;
+	else
+		return 0;
 }
 
-static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
-				     u64 size, struct rb_node **prev_ret)
+static int cache_tree_comp_nodes(struct rb_node *node1, struct rb_node *node2)
 {
-	struct rb_node * n = root->rb_node;
-	struct rb_node *prev = NULL;
 	struct cache_extent *entry;
-	struct cache_extent *prev_entry = NULL;
-
-	while(n) {
-		entry = rb_entry(n, struct cache_extent, rb_node);
-		prev = n;
-		prev_entry = entry;
-
-		if (offset + size <= entry->start)
-			n = n->rb_left;
-		else if (offset >= entry->start + entry->size)
-			n = n->rb_right;
-		else
-			return n;
-	}
-	if (!prev_ret)
-		return NULL;
+	struct cache_extent_search_range range;
 
-	while(prev && offset >= prev_entry->start + prev_entry->size) {
-		prev = rb_next(prev);
-		prev_entry = rb_entry(prev, struct cache_extent, rb_node);
-	}
-	*prev_ret = prev;
-	return NULL;
+	entry = rb_entry(node2, struct cache_extent, rb_node);
+	range.start = entry->start;
+	range.size = entry->size;
+
+	return cache_tree_comp_range(node1, (void *)&range);
 }
 
 struct cache_extent *alloc_cache_extent(u64 start, u64 size)
@@ -87,63 +64,79 @@ struct cache_extent *alloc_cache_extent(u64 start, u64 size)
 
 	if (!pe)
 		return pe;
+
 	pe->start = start;
 	pe->size = size;
 	return pe;
 }
 
-int insert_existing_cache_extent(struct cache_tree *tree,
-				 struct cache_extent *pe)
+int insert_cache_extent(struct cache_tree *tree, struct cache_extent *pe)
 {
-	struct rb_node *found;
-
-	found = tree_insert(&tree->root, pe->start, pe->size, &pe->rb_node);
-	if (found)
-		return -EEXIST;
-
-	return 0;
+	return rb_insert(&tree->root, &pe->rb_node, cache_tree_comp_nodes);
 }
 
-int insert_cache_extent(struct cache_tree *tree, u64 start, u64 size)
+int add_cache_extent(struct cache_tree *tree, u64 start, u64 size)
 {
 	struct cache_extent *pe = alloc_cache_extent(start, size);
 	int ret;
-	ret = insert_existing_cache_extent(tree, pe);
+
+	if (!pe) {
+		fprintf(stderr, "memory allocation failed\n");
+		exit(1);
+	}
+
+	ret = insert_cache_extent(tree, pe);
 	if (ret)
 		free(pe);
+
 	return ret;
 }
 
 struct cache_extent *find_cache_extent(struct cache_tree *tree,
-					   u64 start, u64 size)
+				       u64 start, u64 size)
 {
-	struct rb_node *prev;
-	struct rb_node *ret;
+	struct rb_node *node;
 	struct cache_extent *entry;
-	ret = __tree_search(&tree->root, start, size, &prev);
-	if (!ret)
+	struct cache_extent_search_range range;
+
+	range.start = start;
+	range.size = size;
+	node = rb_search(&tree->root, &range, cache_tree_comp_range, NULL);
+	if (!node)
 		return NULL;
 
-	entry = rb_entry(ret, struct cache_extent, rb_node);
+	entry = rb_entry(node, struct cache_extent, rb_node);
 	return entry;
 }
 
-struct cache_extent *find_first_cache_extent(struct cache_tree *tree,
-						 u64 start)
+struct cache_extent *find_first_cache_extent(struct cache_tree *tree, u64 start)
 {
-	struct rb_node *prev;
-	struct rb_node *ret;
+	struct rb_node *next;
+	struct rb_node *node;
 	struct cache_extent *entry;
+	struct cache_extent_search_range range;
 
-	ret = __tree_search(&tree->root, start, 1, &prev);
-	if (!ret)
-		ret = prev;
-	if (!ret)
+	range.start = start;
+	range.size = 1;
+	node = rb_search(&tree->root, &range, cache_tree_comp_range, &next);
+	if (!node)
+		node = next;
+	if (!node)
 		return NULL;
-	entry = rb_entry(ret, struct cache_extent, rb_node);
+
+	entry = rb_entry(node, struct cache_extent, rb_node);
 	return entry;
 }
 
+struct cache_extent *first_cache_extent(struct cache_tree *tree)
+{
+	struct rb_node *node = rb_first(&tree->root);
+
+	if (!node)
+		return NULL;
+	return rb_entry(node, struct cache_extent, rb_node);
+}
+
 struct cache_extent *prev_cache_extent(struct cache_extent *pe)
 {
 	struct rb_node *node = rb_prev(&pe->rb_node);
@@ -162,9 +155,18 @@ struct cache_extent *next_cache_extent(struct cache_extent *pe)
 	return rb_entry(node, struct cache_extent, rb_node);
 }
 
-void remove_cache_extent(struct cache_tree *tree,
-				 struct cache_extent *pe)
+void remove_cache_extent(struct cache_tree *tree, struct cache_extent *pe)
 {
 	rb_erase(&pe->rb_node, &tree->root);
 }
 
+void cache_tree_free_extents(struct cache_tree *tree,
+			     free_cache_extent free_func)
+{
+	struct cache_extent *ce;
+
+	while ((ce = first_cache_extent(tree))) {
+		remove_cache_extent(tree, ce);
+		free_func(ce);
+	}
+}
diff --git a/extent-cache.h b/extent-cache.h
index 4cd0f79..2979fc3 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -16,8 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __PENDING_EXTENT__
-#define __PENDING_EXTENT__
+#ifndef __EXTENT_CACHE_H__
+#define __EXTENT_CACHE_H__
 
 #if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
@@ -38,28 +38,34 @@ struct cache_extent {
 };
 
 void cache_tree_init(struct cache_tree *tree);
-void remove_cache_extent(struct cache_tree *tree,
-			  struct cache_extent *pe);
-struct cache_extent *find_first_cache_extent(struct cache_tree *tree,
-						 u64 start);
+
+struct cache_extent *first_cache_extent(struct cache_tree *tree);
 struct cache_extent *prev_cache_extent(struct cache_extent *pe);
 struct cache_extent *next_cache_extent(struct cache_extent *pe);
+
+struct cache_extent *find_first_cache_extent(struct cache_tree *tree,
+					     u64 start);
 struct cache_extent *find_cache_extent(struct cache_tree *tree,
-					   u64 start, u64 size);
-int insert_cache_extent(struct cache_tree *tree, u64 start, u64 size);
-int insert_existing_cache_extent(struct cache_tree *tree,
-				 struct cache_extent *pe);
+				       u64 start, u64 size);
+
+int add_cache_extent(struct cache_tree *tree, u64 start, u64 size);
+int insert_cache_extent(struct cache_tree *tree, struct cache_extent *pe);
+void remove_cache_extent(struct cache_tree *tree, struct cache_extent *pe);
 
 static inline int cache_tree_empty(struct cache_tree *tree)
 {
 	return RB_EMPTY_ROOT(&tree->root);
 }
 
-static inline void free_cache_extent(struct cache_extent *pe)
-{
-	free(pe);
-}
+typedef void (*free_cache_extent)(struct cache_extent *pe);
 
-struct cache_extent *alloc_pending_extent(u64 start, u64 size);
+void cache_tree_free_extents(struct cache_tree *tree,
+			     free_cache_extent free_func);
+
+#define FREE_EXTENT_CACHE_BASED_TREE(name, free_func)		\
+static void free_##name##_tree(struct cache_tree *tree)		\
+{								\
+	cache_tree_free_extents(tree, free_func);		\
+}
 
 #endif
diff --git a/extent_io.c b/extent_io.c
index 5093aeb..1e5d25a 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -54,7 +54,7 @@ static struct extent_state *alloc_extent_state(void)
 	return state;
 }
 
-static void free_extent_state(struct extent_state *state)
+static void btrfs_free_extent_state(struct extent_state *state)
 {
 	state->refs--;
 	BUG_ON(state->refs < 0);
@@ -62,11 +62,17 @@ static void free_extent_state(struct extent_state *state)
 		free(state);
 }
 
-void extent_io_tree_cleanup(struct extent_io_tree *tree)
+static void free_extent_state_func(struct cache_extent *cache)
 {
 	struct extent_state *es;
+
+	es = container_of(cache, struct extent_state, cache_node);
+	btrfs_free_extent_state(es);
+}
+
+void extent_io_tree_cleanup(struct extent_io_tree *tree)
+{
 	struct extent_buffer *eb;
-	struct cache_extent *cache;
 
 	while(!list_empty(&tree->lru)) {
 		eb = list_entry(tree->lru.next, struct extent_buffer, lru);
@@ -78,14 +84,8 @@ void extent_io_tree_cleanup(struct extent_io_tree *tree)
 		}
 		free_extent_buffer(eb);
 	}
-	while (1) {
-		cache = find_first_cache_extent(&tree->state, 0);
-		if (!cache)
-			break;
-		es = container_of(cache, struct extent_state, cache_node);
-		remove_cache_extent(&tree->state, &es->cache_node);
-		free_extent_state(es);
-	}
+
+	cache_tree_free_extents(&tree->state, free_extent_state_func);
 }
 
 static inline void update_extent_state(struct extent_state *state)
@@ -118,7 +118,7 @@ static int merge_state(struct extent_io_tree *tree,
 			state->start = other->start;
 			update_extent_state(state);
 			remove_cache_extent(&tree->state, &other->cache_node);
-			free_extent_state(other);
+			btrfs_free_extent_state(other);
 		}
 	}
 	other_node = next_cache_extent(&state->cache_node);
@@ -130,7 +130,7 @@ static int merge_state(struct extent_io_tree *tree,
 			other->start = state->start;
 			update_extent_state(other);
 			remove_cache_extent(&tree->state, &state->cache_node);
-			free_extent_state(state);
+			btrfs_free_extent_state(state);
 		}
 	}
 	return 0;
@@ -151,7 +151,7 @@ static int insert_state(struct extent_io_tree *tree,
 	state->start = start;
 	state->end = end;
 	update_extent_state(state);
-	ret = insert_existing_cache_extent(&tree->state, &state->cache_node);
+	ret = insert_cache_extent(&tree->state, &state->cache_node);
 	BUG_ON(ret);
 	merge_state(tree, state);
 	return 0;
@@ -172,8 +172,7 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 	update_extent_state(prealloc);
 	orig->start = split;
 	update_extent_state(orig);
-	ret = insert_existing_cache_extent(&tree->state,
-					   &prealloc->cache_node);
+	ret = insert_cache_extent(&tree->state, &prealloc->cache_node);
 	BUG_ON(ret);
 	return 0;
 }
@@ -189,7 +188,7 @@ static int clear_state_bit(struct extent_io_tree *tree,
 	state->state &= ~bits;
 	if (state->state == 0) {
 		remove_cache_extent(&tree->state, &state->cache_node);
-		free_extent_state(state);
+		btrfs_free_extent_state(state);
 	} else {
 		merge_state(tree, state);
 	}
@@ -280,7 +279,7 @@ again:
 	goto search_again;
 out:
 	if (prealloc)
-		free_extent_state(prealloc);
+		btrfs_free_extent_state(prealloc);
 	return set;
 
 search_again:
@@ -408,7 +407,7 @@ again:
 	prealloc = NULL;
 out:
 	if (prealloc)
-		free_extent_state(prealloc);
+		btrfs_free_extent_state(prealloc);
 	return err;
 search_again:
 	if (start > end)
@@ -587,7 +586,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->cache_node.size = blocksize;
 
 	free_some_buffers(tree);
-	ret = insert_existing_cache_extent(&tree->cache, &eb->cache_node);
+	ret = insert_cache_extent(&tree->cache, &eb->cache_node);
 	if (ret) {
 		free(eb);
 		return NULL;
@@ -622,7 +621,8 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 	struct cache_extent *cache;
 
 	cache = find_cache_extent(&tree->cache, bytenr, blocksize);
-	if (cache && cache->start == bytenr && cache->size == blocksize) {
+	if (cache && cache->start == bytenr &&
+	    cache->size == blocksize) {
 		eb = container_of(cache, struct extent_buffer, cache_node);
 		list_move_tail(&eb->lru, &tree->lru);
 		eb->refs++;
@@ -652,7 +652,8 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	struct cache_extent *cache;
 
 	cache = find_cache_extent(&tree->cache, bytenr, blocksize);
-	if (cache && cache->start == bytenr && cache->size == blocksize) {
+	if (cache && cache->start == bytenr &&
+	    cache->size == blocksize) {
 		eb = container_of(cache, struct extent_buffer, cache_node);
 		list_move_tail(&eb->lru, &tree->lru);
 		eb->refs++;
diff --git a/rbtree.c b/rbtree.c
index 6ad800f..4c06b0c 100644
--- a/rbtree.c
+++ b/rbtree.c
@@ -387,3 +387,66 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
 	/* Copy the pointers/colour from the victim to the replacement */
 	*new = *victim;
 }
+
+int rb_insert(struct rb_root *root, struct rb_node *node,
+	      rb_compare_nodes comp)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	int ret;
+
+	while(*p) {
+		parent = *p;
+
+		ret = comp(parent, node);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return 0;
+}
+
+struct rb_node *rb_search(struct rb_root *root, void *key, rb_compare_keys comp,
+			  struct rb_node **next_ret)
+{
+	struct rb_node *n = root->rb_node;
+	struct rb_node *parent = NULL;
+	int ret = 0;
+
+	while(n) {
+		parent = n;
+
+		ret = comp(n, key);
+		if (ret < 0)
+			n = n->rb_left;
+		else if (ret > 0)
+			n = n->rb_right;
+		else
+			return n;
+	}
+
+	if (!next_ret)
+		return NULL;
+
+	if (parent && ret > 0)
+		parent = rb_next(parent);
+
+	*next_ret = parent;
+	return NULL;
+}
+
+void rb_free_nodes(struct rb_root *root, rb_free_node free_node)
+{
+	struct rb_node *node;
+
+	while ((node = rb_first(root))) {
+		rb_erase(node, root);
+		free_node(node);
+	}
+}
diff --git a/rbtree.h b/rbtree.h
index 8f717a9..48e5157 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -111,11 +111,8 @@ struct rb_node
 struct rb_root
 {
 	struct rb_node *rb_node;
-	void (*rotate_notify)(struct rb_node *old_parent, struct rb_node *node);
-
 };
 
-
 #define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
 #define rb_color(r)   ((r)->rb_parent_color & 1)
 #define rb_is_red(r)   (!rb_color(r))
@@ -161,4 +158,25 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
+/* The common insert/search/free functions */
+typedef int (*rb_compare_nodes)(struct rb_node *node1, struct rb_node *node2);
+typedef int (*rb_compare_keys)(struct rb_node *node, void *key);
+typedef void (*rb_free_node)(struct rb_node *node);
+
+int rb_insert(struct rb_root *root, struct rb_node *node,
+	      rb_compare_nodes comp);
+/*
+ * In some cases, we need return the next node if we don't find the node we
+ * specify. At this time, we can use next_ret.
+ */
+struct rb_node *rb_search(struct rb_root *root, void *key, rb_compare_keys comp,
+			  struct rb_node **next_ret);
+void rb_free_nodes(struct rb_root *root, rb_free_node free_node);
+
+#define FREE_RB_BASED_TREE(name, free_func)		\
+static void free_##name##_tree(struct rb_root *root)	\
+{							\
+	rb_free_nodes(root, free_func);			\
+}
+
 #endif	/* _LINUX_RBTREE_H */
diff --git a/repair.c b/repair.c
index e640465..4f74742 100644
--- a/repair.c
+++ b/repair.c
@@ -41,7 +41,7 @@ int btrfs_add_corrupt_extent_record(struct btrfs_fs_info *info,
 	corrupt->cache.size = len;
 	corrupt->level = level;
 
-	ret = insert_existing_cache_extent(info->corrupt_blocks, &corrupt->cache);
+	ret = insert_cache_extent(info->corrupt_blocks, &corrupt->cache);
 	if (ret)
 		free(corrupt);
 	BUG_ON(ret && ret != -EEXIST);
diff --git a/volumes.c b/volumes.c
index 0f6a35b..e8e7907 100644
--- a/volumes.c
+++ b/volumes.c
@@ -665,12 +665,12 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 {
 	u64 dev_offset;
 	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
+	struct btrfs_root *chunk_root = info->chunk_root;
 	struct btrfs_stripe *stripes;
 	struct btrfs_device *device = NULL;
 	struct btrfs_chunk *chunk;
 	struct list_head private_devs;
-	struct list_head *dev_list = &extent_root->fs_info->fs_devices->devices;
+	struct list_head *dev_list = &info->fs_devices->devices;
 	struct list_head *cur;
 	struct map_lookup *map;
 	int min_stripe_size = 1 * 1024 * 1024;
@@ -890,9 +890,7 @@ again:
 	map->ce.start = key.offset;
 	map->ce.size = *num_bytes;
 
-	ret = insert_existing_cache_extent(
-			   &extent_root->fs_info->mapping_tree.cache_tree,
-			   &map->ce);
+	ret = insert_cache_extent(&info->mapping_tree.cache_tree, &map->ce);
 	BUG_ON(ret);
 
 	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
@@ -911,11 +909,11 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 {
 	u64 dev_offset;
 	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
+	struct btrfs_root *chunk_root = info->chunk_root;
 	struct btrfs_stripe *stripes;
 	struct btrfs_device *device = NULL;
 	struct btrfs_chunk *chunk;
-	struct list_head *dev_list = &extent_root->fs_info->fs_devices->devices;
+	struct list_head *dev_list = &info->fs_devices->devices;
 	struct list_head *cur;
 	struct map_lookup *map;
 	u64 calc_size = 8 * 1024 * 1024;
@@ -998,9 +996,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	map->ce.start = key.offset;
 	map->ce.size = num_bytes;
 
-	ret = insert_existing_cache_extent(
-			   &extent_root->fs_info->mapping_tree.cache_tree,
-			   &map->ce);
+	ret = insert_cache_extent(&info->mapping_tree.cache_tree, &map->ce);
 	BUG_ON(ret);
 
 	kfree(chunk);
@@ -1447,7 +1443,7 @@ int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 		map->stripes[i].dev = device;
 		i++;
 	}
-	ret = insert_existing_cache_extent(&map_tree->cache_tree, &map->ce);
+	ret = insert_cache_extent(&map_tree->cache_tree, &map->ce);
 	if (ret == -EEXIST) {
 		struct cache_extent *old;
 		struct map_lookup *old_map;
@@ -1455,7 +1451,7 @@ int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 		old_map = container_of(old, struct map_lookup, ce);
 		remove_cache_extent(&map_tree->cache_tree, old);
 		kfree(old_map);
-		ret = insert_existing_cache_extent(&map_tree->cache_tree,
+		ret = insert_cache_extent(&map_tree->cache_tree,
 						   &map->ce);
 	}
 	BUG_ON(ret);
@@ -1550,7 +1546,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		}
 
 	}
-	ret = insert_existing_cache_extent(&map_tree->cache_tree, &map->ce);
+	ret = insert_cache_extent(&map_tree->cache_tree, &map->ce);
 	BUG_ON(ret);
 
 	return 0;
-- 
1.8.1.4

