From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 2/3] Btrfs: rebuild extent_map based on skiplist
Date: Thu, 5 Jan 2012 17:48:08 +0800
Message-ID: <1325756889-13294-3-git-send-email-liubo2009@cn.fujitsu.com>
References: <1325756889-13294-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325756889-13294-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

extent_map applies a "read more" senario, since we want to build
a RCU-skiplist later, we build a new version extent_map based on
skiplist firstly.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |  265 +++++++++++++++++++++++++++++++------------------
 fs/btrfs/extent_map.h |   14 +++-
 fs/btrfs/volumes.c    |   22 ++--
 3 files changed, 190 insertions(+), 111 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7c97b33..746084c 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -9,6 +9,13 @@
 
 static struct kmem_cache *extent_map_cache;
 
+static LIST_HEAD(maps);
+
+#define MAP_LEAK_DEBUG 1
+#if MAP_LEAK_DEBUG
+static DEFINE_SPINLOCK(map_leak_lock);
+#endif
+
 int __init extent_map_init(void)
 {
 	extent_map_cache = kmem_cache_create("extent_map",
@@ -21,6 +28,30 @@ int __init extent_map_init(void)
 
 void extent_map_exit(void)
 {
+	struct extent_map *em;
+
+#if MAP_LEAK_DEBUG
+	struct list_head *tmp;
+	int count = 0;
+
+	list_for_each(tmp, &maps)
+		count++;
+
+	printk(KERN_INFO "%d em is left to free\n", count);
+
+	while (!list_empty(&maps)) {
+		cond_resched();
+		em = list_entry(maps.next, struct extent_map, leak_list);
+		printk(KERN_ERR "btrfs extent map: start %llu, len %llu "
+			"refs %d block_start %llu, block_len %llu, in_tree %u\n",
+			 em->start, em->len, atomic_read(&em->refs),
+			 em->block_start, em->block_len, em->in_tree);
+		WARN_ON(1);
+		list_del(&em->leak_list);
+		kmem_cache_free(extent_map_cache, em);
+	}
+#endif
+
 	if (extent_map_cache)
 		kmem_cache_destroy(extent_map_cache);
 }
@@ -34,7 +65,8 @@ void extent_map_exit(void)
  */
 void extent_map_tree_init(struct extent_map_tree *tree)
 {
-	tree->map = RB_ROOT;
+	tree->head.start = (-1ULL);
+	sl_init_list(&tree->map, &tree->head.sl_node);
 	rwlock_init(&tree->lock);
 }
 
@@ -48,16 +80,41 @@ void extent_map_tree_init(struct extent_map_tree *tree)
 struct extent_map *alloc_extent_map(void)
 {
 	struct extent_map *em;
+#if MAP_LEAK_DEBUG
+	unsigned long flags;
+#endif
+
 	em = kmem_cache_alloc(extent_map_cache, GFP_NOFS);
 	if (!em)
 		return NULL;
 	em->in_tree = 0;
 	em->flags = 0;
 	em->compress_type = BTRFS_COMPRESS_NONE;
+	sl_init_node(&em->sl_node);
 	atomic_set(&em->refs, 1);
+#if MAP_LEAK_DEBUG
+	spin_lock_irqsave(&map_leak_lock, flags);
+	list_add(&em->leak_list, &maps);
+	spin_unlock_irqrestore(&map_leak_lock, flags);
+#endif
 	return em;
 }
 
+static inline void __free_extent_map(struct extent_map *em)
+{
+#if MAP_LEAK_DEBUG
+	unsigned long flags;
+
+	spin_lock_irqsave(&map_leak_lock, flags);
+	list_del(&em->leak_list);
+	spin_unlock_irqrestore(&map_leak_lock, flags);
+#endif
+
+	WARN_ON(em->in_tree);
+	sl_free_node(&em->sl_node);
+	kmem_cache_free(extent_map_cache, em);
+}
+
 /**
  * free_extent_map - drop reference count of an extent_map
  * @em:		extent map beeing releasead
@@ -69,91 +126,113 @@ void free_extent_map(struct extent_map *em)
 {
 	if (!em)
 		return;
+
 	WARN_ON(atomic_read(&em->refs) == 0);
-	if (atomic_dec_and_test(&em->refs)) {
-		WARN_ON(em->in_tree);
-		kmem_cache_free(extent_map_cache, em);
-	}
+	if (atomic_dec_and_test(&em->refs))
+		__free_extent_map(em);
 }
 
-static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
-				   struct rb_node *node)
+static inline int in_entry(struct sl_node *node, u64 offset)
 {
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
 	struct extent_map *entry;
 
-	while (*p) {
-		parent = *p;
-		entry = rb_entry(parent, struct extent_map, rb_node);
+	entry = sl_entry(node, struct extent_map, sl_node);
+	if (!node->head &&
+	    entry->start <= offset && extent_map_end(entry) - 1 >= offset)
+		return 1;
+	return 0;
+}
 
-		WARN_ON(!entry->in_tree);
+static inline struct extent_map *next_entry(struct sl_node *p, int l,
+					    struct sl_node **q)
+{
+	struct extent_map *ret;
+	struct sl_node *next;
 
-		if (offset < entry->start)
-			p = &(*p)->rb_left;
-		else if (offset >= extent_map_end(entry))
-			p = &(*p)->rb_right;
-		else
-			return parent;
-	}
+	next = __sl_next_with_level(p, l);
+	ret = sl_entry(next, struct extent_map, sl_node);
+	BUG_ON(!ret);
+	*q = next;
 
-	entry = rb_entry(node, struct extent_map, rb_node);
-	entry->in_tree = 1;
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
-	return NULL;
+	return ret;
 }
 
-/*
- * search through the tree for an extent_map with a given offset.  If
- * it can't be found, try to find some neighboring extents
- */
-static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
-				     struct rb_node **prev_ret,
-				     struct rb_node **next_ret)
+static struct sl_node *sl_search(struct sl_list *list, u64 offset,
+			  struct sl_node **next_ret)
 {
-	struct rb_node *n = root->rb_node;
-	struct rb_node *prev = NULL;
-	struct rb_node *orig_prev = NULL;
 	struct extent_map *entry;
-	struct extent_map *prev_entry = NULL;
+	struct sl_node *p, *q;
+	int level;
 
-	while (n) {
-		entry = rb_entry(n, struct extent_map, rb_node);
-		prev = n;
-		prev_entry = entry;
+	BUG_ON(!list);
+	level = list->level;
+	p = list->head;
+	BUG_ON(!p);
 
-		WARN_ON(!entry->in_tree);
+	if (sl_empty(p))
+		return NULL;
+	do {
+		while (entry = next_entry(p, level, &q), entry->start <= offset)
+			p = q;
 
-		if (offset < entry->start)
-			n = n->rb_left;
-		else if (offset >= extent_map_end(entry))
-			n = n->rb_right;
-		else
-			return n;
-	}
+		if (in_entry(p, offset))
+			return p;
+		if (in_entry(q, offset))
+			return q;
 
-	if (prev_ret) {
-		orig_prev = prev;
-		while (prev && offset >= extent_map_end(prev_entry)) {
-			prev = rb_next(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		}
-		*prev_ret = prev;
-		prev = orig_prev;
-	}
+		level--;
+	} while (level >= 0);
 
-	if (next_ret) {
-		prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		while (prev && offset < prev_entry->start) {
-			prev = rb_prev(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		}
-		*next_ret = prev;
+	if (next_ret)
+		*next_ret = sl_next(p);
+	return NULL;
+}
+
+static struct sl_node *
+sl_insert_node(struct sl_list *list, u64 offset, struct sl_node *node)
+{
+	struct extent_map *entry;
+	struct sl_node *backlook[MAXLEVEL];
+	struct sl_node *p;
+	struct sl_node *q;
+	int level;
+	u64 randseed;
+
+	/* step1: build backlook node, find insert place */
+	level = list->level;
+	p = list->head;
+	do {
+		while (entry = next_entry(p, level, &q), entry->start <= offset)
+			p = q;
+
+		/* -EEXIST */
+		if (in_entry(p, offset))
+			return p;
+		if (in_entry(q, offset))
+			return q;
+
+		backlook[level] = p;
+		level--;
+	} while (level >= 0);
+
+	/* step2: get random level */
+	get_random_bytes(&randseed, sizeof(u64));
+	level = generate_node_level(randseed);
+	if (level > list->level) {
+		list->level++;
+		level = list->level;
+		backlook[level] = list->head;
 	}
+
+	/* step3: insert the node */
+	entry = sl_entry(node, struct extent_map, sl_node);
+	entry->in_tree = 1;
+	sl_fill_node(node, level, GFP_ATOMIC);
+	sl_link_node(node, backlook, level);
 	return NULL;
 }
 
+
 /* check to see if two extent_map structs are adjacent and safe to merge */
 static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 {
@@ -186,31 +265,31 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 {
 	struct extent_map *merge = NULL;
-	struct rb_node *rb;
+	struct sl_node *sl;
 
 	if (em->start != 0) {
-		rb = rb_prev(&em->rb_node);
-		if (rb)
-			merge = rb_entry(rb, struct extent_map, rb_node);
-		if (rb && mergable_maps(merge, em)) {
+		sl = sl_prev(&em->sl_node);
+		if (sl)
+			merge = sl_entry(sl, struct extent_map, sl_node);
+		if (sl && mergable_maps(merge, em)) {
 			em->start = merge->start;
 			em->len += merge->len;
 			em->block_len += merge->block_len;
 			em->block_start = merge->block_start;
 			merge->in_tree = 0;
-			rb_erase(&merge->rb_node, &tree->map);
+			sl_erase(&merge->sl_node, &tree->map);
 			free_extent_map(merge);
 		}
 	}
 
-	rb = rb_next(&em->rb_node);
-	if (rb)
-		merge = rb_entry(rb, struct extent_map, rb_node);
-	if (rb && mergable_maps(em, merge)) {
+	sl = sl_next(&em->sl_node);
+	if (sl)
+		merge = sl_entry(sl, struct extent_map, sl_node);
+	if (sl && mergable_maps(em, merge)) {
 		em->len += merge->len;
 		em->block_len += merge->len;
-		rb_erase(&merge->rb_node, &tree->map);
 		merge->in_tree = 0;
+		sl_erase(&merge->sl_node, &tree->map);
 		free_extent_map(merge);
 	}
 }
@@ -224,7 +303,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 	em = lookup_extent_mapping(tree, start, len);
 
 	WARN_ON(!em || em->start != start);
-
 	if (!em)
 		goto out;
 
@@ -236,7 +314,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 out:
 	write_unlock(&tree->lock);
 	return ret;
-
 }
 
 /**
@@ -253,20 +330,14 @@ int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em)
 {
 	int ret = 0;
-	struct rb_node *rb;
-	struct extent_map *exist;
+	struct sl_node *sl_node;
 
-	exist = lookup_extent_mapping(tree, em->start, em->len);
-	if (exist) {
-		free_extent_map(exist);
-		ret = -EEXIST;
-		goto out;
-	}
-	rb = tree_insert(&tree->map, em->start, &em->rb_node);
-	if (rb) {
+	sl_node = sl_insert_node(&tree->map, em->start, &em->sl_node);
+	if (sl_node) {
 		ret = -EEXIST;
 		goto out;
 	}
+
 	atomic_inc(&em->refs);
 
 	try_merge_map(tree, em);
@@ -286,22 +357,20 @@ struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
 					   u64 start, u64 len, int strict)
 {
 	struct extent_map *em;
-	struct rb_node *rb_node;
-	struct rb_node *prev = NULL;
-	struct rb_node *next = NULL;
+	struct sl_node *sl_node;
+	struct sl_node *next = NULL;
 	u64 end = range_end(start, len);
 
-	rb_node = __tree_search(&tree->map, start, &prev, &next);
-	if (!rb_node) {
-		if (prev)
-			rb_node = prev;
-		else if (next)
-			rb_node = next;
+	sl_node = sl_search(&tree->map, start, &next);
+	if (!sl_node) {
+		if (next)
+			sl_node = next;
 		else
 			return NULL;
 	}
 
-	em = rb_entry(rb_node, struct extent_map, rb_node);
+	em = sl_entry(sl_node, struct extent_map, sl_node);
+	BUG_ON(!em);
 
 	if (strict && !(end > em->start && start < extent_map_end(em)))
 		return NULL;
@@ -357,7 +426,7 @@ int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 	int ret = 0;
 
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
-	rb_erase(&em->rb_node, &tree->map);
+	sl_erase(&em->sl_node, &tree->map);
 	em->in_tree = 0;
 	return ret;
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 33a7890..6d2c247 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -2,6 +2,7 @@
 #define __EXTENTMAP__
 
 #include <linux/rbtree.h>
+#include "skiplist.h"
 
 #define EXTENT_MAP_LAST_BYTE (u64)-4
 #define EXTENT_MAP_HOLE (u64)-3
@@ -15,7 +16,7 @@
 #define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
 
 struct extent_map {
-	struct rb_node rb_node;
+	struct sl_node sl_node;
 
 	/* all of these are in bytes */
 	u64 start;
@@ -28,11 +29,20 @@ struct extent_map {
 	atomic_t refs;
 	unsigned int in_tree:1;
 	unsigned int compress_type:4;
+
+	struct list_head leak_list;
+};
+
+struct map_head {
+	struct sl_node sl_node;
+	u64 start;
+	u64 len;
 };
 
 struct extent_map_tree {
-	struct rb_root map;
+	struct sl_list map;
 	rwlock_t lock;
+	struct map_head head;
 };
 
 static inline u64 extent_map_end(struct extent_map *em)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4b839f..adaac9e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2830,20 +2830,20 @@ void btrfs_mapping_init(struct btrfs_mapping_tree *tree)
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
 {
 	struct extent_map *em;
+	struct sl_node *head, *node;
+
+	/* At the end of the whole filesystem, so no lock is needed. */
+	head = tree->map_tree.map.head;
+	while (!sl_empty(head)) {
+		node = head->next[0];
+		em = sl_entry(node, struct extent_map, sl_node);
+
+		remove_extent_mapping(&tree->map_tree, em);
 
-	while (1) {
-		write_lock(&tree->map_tree.lock);
-		em = lookup_extent_mapping(&tree->map_tree, 0, (u64)-1);
-		if (em)
-			remove_extent_mapping(&tree->map_tree, em);
-		write_unlock(&tree->map_tree.lock);
-		if (!em)
-			break;
 		kfree(em->bdev);
-		/* once for us */
-		free_extent_map(em);
-		/* once for the tree */
 		free_extent_map(em);
+
+		cond_resched();
 	}
 }
 
-- 
1.6.5.2

