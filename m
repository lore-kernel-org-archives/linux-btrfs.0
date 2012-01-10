From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH v2 3/3] Btrfs: convert rwlock to RCU for extent_map
Date: Tue, 10 Jan 2012 15:31:36 +0800
Message-ID: <1326180696-3614-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>, <dave@jikos.cz>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

In this patch, we make two things:

a) skiplist -> rcu-skiplist
   This is quite direct, since in skiplist each level is a list,
   any modification to the skiplist refers to "pointers change",
   which fits RCU's sematic.

b) use rcu lock for reader side and mutex lock for updater side
   to protect extent_map instead of rwlock.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
changes v2:
- fix a bug reported by David Sterba <dave@jikos.cz>, thanks a lot!
- use mutex lock to protect extent_map updater side, so that we can make
  the reclaim code much easier.
---
 fs/btrfs/compression.c |    8 ++++----
 fs/btrfs/disk-io.c     |    9 ++++-----
 fs/btrfs/extent_io.c   |   13 ++++++-------
 fs/btrfs/extent_map.c  |   28 ++++++++++++++++++----------
 fs/btrfs/extent_map.h  |    5 ++---
 fs/btrfs/file.c        |   11 ++++++-----
 fs/btrfs/inode.c       |   28 ++++++++++++++--------------
 fs/btrfs/ioctl.c       |    8 ++++----
 fs/btrfs/relocation.c  |    4 ++--
 fs/btrfs/scrub.c       |    4 ++--
 fs/btrfs/skiplist.c    |   11 +++++++----
 fs/btrfs/skiplist.h    |   25 ++++++++++++++++---------
 fs/btrfs/volumes.c     |   36 ++++++++++++++++++------------------
 13 files changed, 103 insertions(+), 87 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 14f1c5a..bb4ac31 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -498,10 +498,10 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		 */
 		set_page_extent_mapped(page);
 		lock_extent(tree, last_offset, end, GFP_NOFS);
-		read_lock(&em_tree->lock);
+		rcu_read_lock();
 		em = lookup_extent_mapping(em_tree, last_offset,
 					   PAGE_CACHE_SIZE);
-		read_unlock(&em_tree->lock);
+		rcu_read_unlock();
 
 		if (!em || last_offset < em->start ||
 		    (last_offset + PAGE_CACHE_SIZE > extent_map_end(em)) ||
@@ -583,11 +583,11 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	em_tree = &BTRFS_I(inode)->extent_tree;
 
 	/* we need the actual starting offset of this extent in the file */
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree,
 				   page_offset(bio->bi_io_vec->bv_page),
 				   PAGE_CACHE_SIZE);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	compressed_len = em->block_len;
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3f9d555..8e09517 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -191,15 +191,14 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 	struct extent_map *em;
 	int ret;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, start, len);
+	rcu_read_unlock();
 	if (em) {
 		em->bdev =
 			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
-		read_unlock(&em_tree->lock);
 		goto out;
 	}
-	read_unlock(&em_tree->lock);
 
 	em = alloc_extent_map();
 	if (!em) {
@@ -212,7 +211,7 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 	em->block_start = 0;
 	em->bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
-	write_lock(&em_tree->lock);
+	mutex_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em);
 	if (ret == -EEXIST) {
 		u64 failed_start = em->start;
@@ -231,7 +230,7 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 		free_extent_map(em);
 		em = NULL;
 	}
-	write_unlock(&em_tree->lock);
+	mutex_unlock(&em_tree->lock);
 
 	if (ret)
 		em = ERR_PTR(ret);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 49f3c9d..7efa8dd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2013,10 +2013,10 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		failrec->bio_flags = 0;
 		failrec->in_validation = 0;
 
-		read_lock(&em_tree->lock);
+		rcu_read_lock();
 		em = lookup_extent_mapping(em_tree, start, failrec->len);
+		rcu_read_unlock();
 		if (!em) {
-			read_unlock(&em_tree->lock);
 			kfree(failrec);
 			return -EIO;
 		}
@@ -2025,7 +2025,6 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 			free_extent_map(em);
 			em = NULL;
 		}
-		read_unlock(&em_tree->lock);
 
 		if (!em || IS_ERR(em)) {
 			kfree(failrec);
@@ -3286,15 +3285,15 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 		u64 len;
 		while (start <= end) {
 			len = end - start + 1;
-			write_lock(&map->lock);
+			mutex_lock(&map->lock);
 			em = lookup_extent_mapping(map, start, len);
 			if (IS_ERR_OR_NULL(em)) {
-				write_unlock(&map->lock);
+				mutex_unlock(&map->lock);
 				break;
 			}
 			if (test_bit(EXTENT_FLAG_PINNED, &em->flags) ||
 			    em->start != start) {
-				write_unlock(&map->lock);
+				mutex_unlock(&map->lock);
 				free_extent_map(em);
 				break;
 			}
@@ -3307,7 +3306,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 				free_extent_map(em);
 			}
 			start = extent_map_end(em);
-			write_unlock(&map->lock);
+			mutex_unlock(&map->lock);
 
 			/* once for us */
 			free_extent_map(em);
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index e0a7881..8d40638 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -11,6 +11,7 @@ static struct kmem_cache *extent_map_cache;
 
 static LIST_HEAD(maps);
 
+#define MAP_REFS_DEBUG 1
 #define MAP_LEAK_DEBUG 1
 #if MAP_LEAK_DEBUG
 static DEFINE_SPINLOCK(map_leak_lock);
@@ -67,7 +68,7 @@ void extent_map_tree_init(struct extent_map_tree *tree)
 {
 	tree->head.start = (-1ULL);
 	sl_init_list(&tree->map, &tree->head.sl_node);
-	rwlock_init(&tree->lock);
+	mutex_init(&tree->lock);
 }
 
 /**
@@ -100,8 +101,11 @@ struct extent_map *alloc_extent_map(void)
 	return em;
 }
 
-static inline void __free_extent_map(struct extent_map *em)
+static inline void __free_extent_map(struct rcu_head *head)
 {
+	struct sl_node *node = container_of(head, struct sl_node, rcu_head);
+	struct extent_map *em = sl_entry(node, struct extent_map, sl_node);
+
 #if MAP_LEAK_DEBUG
 	unsigned long flags;
 
@@ -129,7 +133,7 @@ void free_extent_map(struct extent_map *em)
 
 	WARN_ON(atomic_read(&em->refs) == 0);
 	if (atomic_dec_and_test(&em->refs))
-		__free_extent_map(em);
+		call_rcu(&em->sl_node.rcu_head, __free_extent_map);
 }
 
 static inline int in_entry(struct sl_node *node, u64 offset)
@@ -166,14 +170,14 @@ static struct sl_node *sl_search(struct sl_list *list, u64 offset,
 
 	BUG_ON(!list);
 	level = list->level;
-	p = list->head;
+	p = rcu_dereference(list->head);
 	BUG_ON(!p);
 
 	if (sl_empty(p))
 		return NULL;
 	do {
 		while (entry = next_entry(p, level, &q), entry->start <= offset)
-			p = q;
+			p = rcu_dereference(q);
 
 		if (in_entry(p, offset))
 			return p;
@@ -299,7 +303,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 	int ret = 0;
 	struct extent_map *em;
 
-	write_lock(&tree->lock);
+	mutex_lock(&tree->lock);
 	em = lookup_extent_mapping(tree, start, len);
 
 	WARN_ON(!em || em->start != start);
@@ -312,7 +316,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 
 	free_extent_map(em);
 out:
-	write_unlock(&tree->lock);
+	mutex_unlock(&tree->lock);
 	return ret;
 }
 
@@ -326,8 +330,7 @@ out:
  * into the tree directly, with an additional reference taken, or a
  * reference dropped if the merge attempt was successful.
  */
-int add_extent_mapping(struct extent_map_tree *tree,
-		       struct extent_map *em)
+int add_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 {
 	int ret = 0;
 	struct sl_node *sl_node;
@@ -382,7 +385,12 @@ struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
 	if (strict && !(end > em->start && start < extent_map_end(em)))
 		return NULL;
 
-	atomic_inc(&em->refs);
+#if MAP_REFS_DEBUG
+	if (!atomic_read(&em->refs))
+		printk(KERN_INFO "Btrfs: Reader gets an em with 0 refs\n");
+#endif
+	if (!atomic_inc_not_zero(&em->refs))
+		return NULL;
 	return em;
 }
 
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 6d2c247..6563800 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -41,7 +41,7 @@ struct map_head {
 
 struct extent_map_tree {
 	struct sl_list map;
-	rwlock_t lock;
+	struct mutex lock;
 	struct map_head head;
 };
 
@@ -62,8 +62,7 @@ static inline u64 extent_map_block_end(struct extent_map *em)
 void extent_map_tree_init(struct extent_map_tree *tree);
 struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
-int add_extent_mapping(struct extent_map_tree *tree,
-		       struct extent_map *em);
+int add_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
 int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
 
 struct extent_map *alloc_extent_map(void);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cc7492c..27c5ff3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -454,24 +454,25 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split2 = alloc_extent_map();
 		BUG_ON(!split || !split2);
 
-		write_lock(&em_tree->lock);
+		mutex_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, start, len);
 		if (!em) {
-			write_unlock(&em_tree->lock);
+			mutex_unlock(&em_tree->lock);
 			break;
 		}
+
 		flags = em->flags;
 		if (skip_pinned && test_bit(EXTENT_FLAG_PINNED, &em->flags)) {
 			if (testend && em->start + em->len >= start + len) {
 				free_extent_map(em);
-				write_unlock(&em_tree->lock);
+				mutex_unlock(&em_tree->lock);
 				break;
 			}
 			start = em->start + em->len;
 			if (testend)
 				len = start + len - (em->start + em->len);
 			free_extent_map(em);
-			write_unlock(&em_tree->lock);
+			mutex_unlock(&em_tree->lock);
 			continue;
 		}
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
@@ -524,7 +525,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			free_extent_map(split);
 			split = NULL;
 		}
-		write_unlock(&em_tree->lock);
+		mutex_unlock(&em_tree->lock);
 
 		/* once for us */
 		free_extent_map(em);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13b0542..edf3258 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -675,9 +675,9 @@ retry:
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 
 		while (1) {
-			write_lock(&em_tree->lock);
+			mutex_lock(&em_tree->lock);
 			ret = add_extent_mapping(em_tree, em);
-			write_unlock(&em_tree->lock);
+			mutex_unlock(&em_tree->lock);
 			if (ret != -EEXIST) {
 				free_extent_map(em);
 				break;
@@ -732,7 +732,7 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
 	struct extent_map *em;
 	u64 alloc_hint = 0;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = search_extent_mapping(em_tree, start, num_bytes);
 	if (em) {
 		/*
@@ -752,7 +752,7 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
 			free_extent_map(em);
 		}
 	}
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	return alloc_hint;
 }
@@ -854,9 +854,9 @@ static noinline int cow_file_range(struct inode *inode,
 		set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 		while (1) {
-			write_lock(&em_tree->lock);
+			mutex_lock(&em_tree->lock);
 			ret = add_extent_mapping(em_tree, em);
-			write_unlock(&em_tree->lock);
+			mutex_unlock(&em_tree->lock);
 			if (ret != -EEXIST) {
 				free_extent_map(em);
 				break;
@@ -1207,9 +1207,9 @@ out_check:
 			em->bdev = root->fs_info->fs_devices->latest_bdev;
 			set_bit(EXTENT_FLAG_PINNED, &em->flags);
 			while (1) {
-				write_lock(&em_tree->lock);
+				mutex_lock(&em_tree->lock);
 				ret = add_extent_mapping(em_tree, em);
-				write_unlock(&em_tree->lock);
+				mutex_unlock(&em_tree->lock);
 				if (ret != -EEXIST) {
 					free_extent_map(em);
 					break;
@@ -4950,11 +4950,11 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	int compress_type;
 
 again:
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, start, len);
 	if (em)
 		em->bdev = root->fs_info->fs_devices->latest_bdev;
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	if (em) {
 		if (em->start > start || em->start + em->len <= start)
@@ -5166,7 +5166,7 @@ insert:
 	}
 
 	err = 0;
-	write_lock(&em_tree->lock);
+	mutex_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em);
 	/* it is possible that someone inserted the extent into the tree
 	 * while we had the lock dropped.  It is also possible that
@@ -5206,7 +5206,7 @@ insert:
 			err = 0;
 		}
 	}
-	write_unlock(&em_tree->lock);
+	mutex_unlock(&em_tree->lock);
 out:
 
 	trace_btrfs_get_extent(root, em);
@@ -5414,9 +5414,9 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 	while (insert) {
-		write_lock(&em_tree->lock);
+		mutex_lock(&em_tree->lock);
 		ret = add_extent_mapping(em_tree, em);
-		write_unlock(&em_tree->lock);
+		mutex_unlock(&em_tree->lock);
 		if (ret != -EEXIST)
 			break;
 		btrfs_drop_extent_cache(inode, start, start + em->len - 1, 0);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c04f02c..83fc601 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -673,9 +673,9 @@ static int check_defrag_in_cache(struct inode *inode, u64 offset, int thresh)
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	u64 end;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, offset, PAGE_CACHE_SIZE);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	if (em) {
 		end = extent_map_end(em);
@@ -782,9 +782,9 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 	 * hopefully we have this extent in the tree already, try without
 	 * the full extent lock
 	 */
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, start, len);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	if (!em) {
 		/* get the big lock and read metadata off disk */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cfb5543..7eb4685 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2899,9 +2899,9 @@ int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
 
 	lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
 	while (1) {
-		write_lock(&em_tree->lock);
+		mutex_lock(&em_tree->lock);
 		ret = add_extent_mapping(em_tree, em);
-		write_unlock(&em_tree->lock);
+		mutex_unlock(&em_tree->lock);
 		if (ret != -EEXIST) {
 			free_extent_map(em);
 			break;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ddf2c90..5aec748 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1374,9 +1374,9 @@ static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 	int i;
 	int ret = -EINVAL;
 
-	read_lock(&map_tree->map_tree.lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
-	read_unlock(&map_tree->map_tree.lock);
+	rcu_read_unlock();
 
 	if (!em)
 		return -EINVAL;
diff --git a/fs/btrfs/skiplist.c b/fs/btrfs/skiplist.c
index c803478..621eb7b 100644
--- a/fs/btrfs/skiplist.c
+++ b/fs/btrfs/skiplist.c
@@ -29,6 +29,7 @@ inline int sl_fill_node(struct sl_node *node, int level, gfp_t mask)
 	struct sl_node **p;
 	struct sl_node **q;
 	int num;
+	int i;
 
 	BUG_ON(level > MAXLEVEL);
 
@@ -44,6 +45,9 @@ inline int sl_fill_node(struct sl_node *node, int level, gfp_t mask)
 		return -ENOMEM;
 	}
 
+	for (i = 0; i < num; i++)
+		p[i] = q[i] = NULL;
+
 	node->next = p;
 	node->prev = q;
 	node->level = level;
@@ -62,7 +66,7 @@ inline void sl_link_node(struct sl_node *node, struct sl_node **backlook,
 
 		node->next[i] = q;
 		node->prev[i] = p;
-		p->next[i] = node;
+		rcu_assign_pointer(p->next[i], node);
 		q->prev[i] = node;
 
 		i++;
@@ -78,14 +82,13 @@ void sl_erase(struct sl_node *node, struct sl_list *list)
 
 	level = node->level;
 
-	for (i = 0; i <= level; i++) {
+	for (i = level; i >= 0; i--) {
 		prev = node->prev[i];
 		next = node->next[i];
 
 		prev->next[i] = next;
 		next->prev[i] = prev;
-		node->next[i] = node;
-		node->prev[i] = node;
+		node->prev[i] = NULL;
 	}
 
 	head = list->head;
diff --git a/fs/btrfs/skiplist.h b/fs/btrfs/skiplist.h
index 3e414b5..2ae997d 100644
--- a/fs/btrfs/skiplist.h
+++ b/fs/btrfs/skiplist.h
@@ -102,41 +102,48 @@ struct sl_node *sl_insert_node(struct sl_list *list, u64 offset,
 #define _SKIPLIST_H
 
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 
 #define MAXLEVEL 16
 /* double p = 0.25; */
 
 struct sl_node {
-	struct sl_node **next;
-	struct sl_node **prev;
+	struct sl_node __rcu **next;
+	struct sl_node __rcu **prev;
+	struct rcu_head rcu_head;
 	unsigned int level;
 	unsigned int head:1;
 };
 
 struct sl_list {
-	struct sl_node *head;
-	struct sl_node *h_next[MAXLEVEL];
-	struct sl_node *h_prev[MAXLEVEL];
+	struct sl_node __rcu *head;
+	struct sl_node __rcu *h_next[MAXLEVEL];
+	struct sl_node __rcu *h_prev[MAXLEVEL];
 	unsigned int level;
 };
 
-#define sl_entry(ptr, type, member) container_of(ptr, type, member)
+#define sl_entry(ptr, type, member) \
+	({ \
+		typeof(*ptr) __rcu *__ptr = (typeof(*ptr) __rcu __force *)ptr; \
+		container_of((typeof(ptr))rcu_dereference(__ptr), \
+			     type, member); \
+	})
 
 static inline int sl_empty(const struct sl_node *head)
 {
-	return head->next[0] == head;
+	return (rcu_dereference(head->next[0]) == head);
 }
 
 static inline struct sl_node *__sl_next_with_level(struct sl_node *node,
 						   int level)
 {
-	return node->next[level];
+	return rcu_dereference(node->next[level]);
 }
 
 static inline struct sl_node *__sl_prev_with_level(struct sl_node *node,
 						   int level)
 {
-	return node->prev[level];
+	return rcu_dereference(node->prev[level]);
 }
 
 static inline struct sl_node *sl_next(struct sl_node *node)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index adaac9e..acc86b4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1955,9 +1955,9 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	 * step two, delete the device extents and the
 	 * chunk tree entries
 	 */
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, chunk_offset, 1);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	BUG_ON(em->start > chunk_offset ||
 	       em->start + em->len < chunk_offset);
@@ -1988,9 +1988,9 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset);
 	BUG_ON(ret);
 
-	write_lock(&em_tree->lock);
+	mutex_lock(&em_tree->lock);
 	remove_extent_mapping(em_tree, em);
-	write_unlock(&em_tree->lock);
+	mutex_unlock(&em_tree->lock);
 
 	kfree(map);
 	em->bdev = NULL;
@@ -2589,9 +2589,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	em->block_len = em->len;
 
 	em_tree = &extent_root->fs_info->mapping_tree.map_tree;
-	write_lock(&em_tree->lock);
+	mutex_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em);
-	write_unlock(&em_tree->lock);
+	mutex_unlock(&em_tree->lock);
 	BUG_ON(ret);
 	free_extent_map(em);
 
@@ -2800,9 +2800,9 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	int readonly = 0;
 	int i;
 
-	read_lock(&map_tree->map_tree.lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
-	read_unlock(&map_tree->map_tree.lock);
+	rcu_read_unlock();
 	if (!em)
 		return 1;
 
@@ -2854,9 +2854,9 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	int ret;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, logical, len);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 	BUG_ON(!em);
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
@@ -2921,9 +2921,9 @@ again:
 		atomic_set(&bbio->error, 0);
 	}
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, logical, *length);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	if (!em) {
 		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
@@ -3187,9 +3187,9 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	u64 stripe_nr;
 	int i, j, nr = 0;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, chunk_start, 1);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	BUG_ON(!em || em->start != chunk_start);
 	map = (struct map_lookup *)em->bdev;
@@ -3472,9 +3472,9 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
 
-	read_lock(&map_tree->map_tree.lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
-	read_unlock(&map_tree->map_tree.lock);
+	rcu_read_unlock();
 
 	/* already mapped? */
 	if (em && em->start <= logical && em->start + em->len > logical) {
@@ -3533,9 +3533,9 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		map->stripes[i].dev->in_fs_metadata = 1;
 	}
 
-	write_lock(&map_tree->map_tree.lock);
+	mutex_lock(&map_tree->map_tree.lock);
 	ret = add_extent_mapping(&map_tree->map_tree, em);
-	write_unlock(&map_tree->map_tree.lock);
+	mutex_unlock(&map_tree->map_tree.lock);
 	BUG_ON(ret);
 	free_extent_map(em);
 
-- 
1.6.5.2

