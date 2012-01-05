From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 3/3] Btrfs: convert rwlock to RCU for extent_map
Date: Thu, 5 Jan 2012 17:48:09 +0800
Message-ID: <1325756889-13294-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1325756889-13294-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325756889-13294-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

In this patch, we make three things:

a) skiplist -> rcu-skiplist
   This is quite direct, since in skiplist each level is a list,
   any modification to the skiplist refers to "pointers change",
   which fits RCU's sematic.

b) use rcu lock to protect extent_map instead of rwlock.

c) make extent_map reclaim after dropping the updater side lock.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/compression.c |    8 +++---
 fs/btrfs/disk-io.c     |   15 ++++++----
 fs/btrfs/extent_io.c   |   13 ++++-----
 fs/btrfs/extent_map.c  |   39 +++++++++++++++++---------
 fs/btrfs/extent_map.h  |    7 +++--
 fs/btrfs/file.c        |   23 +++++++++++-----
 fs/btrfs/inode.c       |   69 ++++++++++++++++++++++++++++++++---------------
 fs/btrfs/ioctl.c       |    8 +++---
 fs/btrfs/relocation.c  |    9 ++++--
 fs/btrfs/scrub.c       |    4 +-
 fs/btrfs/skiplist.c    |    6 ++--
 fs/btrfs/skiplist.h    |   25 +++++++++++------
 fs/btrfs/volumes.c     |   46 ++++++++++++++++++--------------
 13 files changed, 168 insertions(+), 104 deletions(-)

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
index 3f9d555..2dbc969 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -189,17 +189,17 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 {
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_map *em;
+	struct extent_map *to_free1 = NULL, *to_free2 = NULL;
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
@@ -212,8 +212,12 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 	em->block_start = 0;
 	em->bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
-	write_lock(&em_tree->lock);
-	ret = add_extent_mapping(em_tree, em);
+	spin_lock(&em_tree->lock);
+	ret = add_extent_mapping(em_tree, em, &to_free1, &to_free2);
+	spin_unlock(&em_tree->lock);
+	free_extent_map(to_free1);
+	free_extent_map(to_free2);
+
 	if (ret == -EEXIST) {
 		u64 failed_start = em->start;
 		u64 failed_len = em->len;
@@ -231,7 +235,6 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 		free_extent_map(em);
 		em = NULL;
 	}
-	write_unlock(&em_tree->lock);
 
 	if (ret)
 		em = ERR_PTR(ret);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 49f3c9d..30a8270 100644
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
+			spin_lock(&map->lock);
 			em = lookup_extent_mapping(map, start, len);
 			if (IS_ERR_OR_NULL(em)) {
-				write_unlock(&map->lock);
+				spin_unlock(&map->lock);
 				break;
 			}
 			if (test_bit(EXTENT_FLAG_PINNED, &em->flags) ||
 			    em->start != start) {
-				write_unlock(&map->lock);
+				spin_unlock(&map->lock);
 				free_extent_map(em);
 				break;
 			}
@@ -3307,7 +3306,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 				free_extent_map(em);
 			}
 			start = extent_map_end(em);
-			write_unlock(&map->lock);
+			spin_unlock(&map->lock);
 
 			/* once for us */
 			free_extent_map(em);
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 746084c..e2e8af0 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -67,7 +67,7 @@ void extent_map_tree_init(struct extent_map_tree *tree)
 {
 	tree->head.start = (-1ULL);
 	sl_init_list(&tree->map, &tree->head.sl_node);
-	rwlock_init(&tree->lock);
+	spin_lock_init(&tree->lock);
 }
 
 /**
@@ -100,8 +100,11 @@ struct extent_map *alloc_extent_map(void)
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
 
@@ -129,7 +132,7 @@ void free_extent_map(struct extent_map *em)
 
 	WARN_ON(atomic_read(&em->refs) == 0);
 	if (atomic_dec_and_test(&em->refs))
-		__free_extent_map(em);
+		call_rcu(&em->sl_node.rcu_head, __free_extent_map);
 }
 
 static inline int in_entry(struct sl_node *node, u64 offset)
@@ -166,14 +169,14 @@ static struct sl_node *sl_search(struct sl_list *list, u64 offset,
 
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
@@ -262,7 +265,9 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	return 0;
 }
 
-static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
+static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em,
+			  struct extent_map **to_free1,
+			  struct extent_map **to_free2)
 {
 	struct extent_map *merge = NULL;
 	struct sl_node *sl;
@@ -278,7 +283,8 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 			em->block_start = merge->block_start;
 			merge->in_tree = 0;
 			sl_erase(&merge->sl_node, &tree->map);
-			free_extent_map(merge);
+			if (merge)
+				*to_free1 = merge;
 		}
 	}
 
@@ -290,7 +296,8 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 		em->block_len += merge->len;
 		merge->in_tree = 0;
 		sl_erase(&merge->sl_node, &tree->map);
-		free_extent_map(merge);
+		if (merge)
+			*to_free2 = merge;
 	}
 }
 
@@ -298,8 +305,9 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 {
 	int ret = 0;
 	struct extent_map *em;
+	struct extent_map *to_free1 = NULL, *to_free2 = NULL;
 
-	write_lock(&tree->lock);
+	spin_lock(&tree->lock);
 	em = lookup_extent_mapping(tree, start, len);
 
 	WARN_ON(!em || em->start != start);
@@ -308,11 +316,13 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len)
 
 	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 
-	try_merge_map(tree, em);
+	try_merge_map(tree, em, &to_free1, &to_free2);
 
 	free_extent_map(em);
 out:
-	write_unlock(&tree->lock);
+	spin_unlock(&tree->lock);
+	free_extent_map(to_free1);
+	free_extent_map(to_free2);
 	return ret;
 }
 
@@ -326,8 +336,9 @@ out:
  * into the tree directly, with an additional reference taken, or a
  * reference dropped if the merge attempt was successful.
  */
-int add_extent_mapping(struct extent_map_tree *tree,
-		       struct extent_map *em)
+int add_extent_mapping(struct extent_map_tree *tree, struct extent_map *em,
+		       struct extent_map **to_free1,
+		       struct extent_map **to_free2)
 {
 	int ret = 0;
 	struct sl_node *sl_node;
@@ -340,7 +351,7 @@ int add_extent_mapping(struct extent_map_tree *tree,
 
 	atomic_inc(&em->refs);
 
-	try_merge_map(tree, em);
+	try_merge_map(tree, em, to_free1, to_free2);
 out:
 	return ret;
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 6d2c247..c61a105 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -41,7 +41,7 @@ struct map_head {
 
 struct extent_map_tree {
 	struct sl_list map;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct map_head head;
 };
 
@@ -62,8 +62,9 @@ static inline u64 extent_map_block_end(struct extent_map *em)
 void extent_map_tree_init(struct extent_map_tree *tree);
 struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
-int add_extent_mapping(struct extent_map_tree *tree,
-		       struct extent_map *em);
+int add_extent_mapping(struct extent_map_tree *tree, struct extent_map *em,
+		       struct extent_map **to_free1,
+		       struct extent_map **to_free2);
 int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
 
 struct extent_map *alloc_extent_map(void);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cc7492c..8284202 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -435,10 +435,12 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 	struct extent_map *em;
 	struct extent_map *split = NULL;
 	struct extent_map *split2 = NULL;
+	struct extent_map *to_free[4];
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	u64 len = end - start + 1;
 	int ret;
 	int testend = 1;
+	int i;
 	unsigned long flags;
 	int compressed = 0;
 
@@ -454,24 +456,27 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split2 = alloc_extent_map();
 		BUG_ON(!split || !split2);
 
-		write_lock(&em_tree->lock);
+		for (i = 0; i < 4; i++)
+			to_free[i] = NULL;
+		spin_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, start, len);
 		if (!em) {
-			write_unlock(&em_tree->lock);
+			spin_unlock(&em_tree->lock);
 			break;
 		}
+
 		flags = em->flags;
 		if (skip_pinned && test_bit(EXTENT_FLAG_PINNED, &em->flags)) {
 			if (testend && em->start + em->len >= start + len) {
 				free_extent_map(em);
-				write_unlock(&em_tree->lock);
+				spin_unlock(&em_tree->lock);
 				break;
 			}
 			start = em->start + em->len;
 			if (testend)
 				len = start + len - (em->start + em->len);
 			free_extent_map(em);
-			write_unlock(&em_tree->lock);
+			spin_unlock(&em_tree->lock);
 			continue;
 		}
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
@@ -493,7 +498,8 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split->bdev = em->bdev;
 			split->flags = flags;
 			split->compress_type = em->compress_type;
-			ret = add_extent_mapping(em_tree, split);
+			ret = add_extent_mapping(em_tree, split, &to_free[0],
+						 &to_free[1]);
 			BUG_ON(ret);
 			free_extent_map(split);
 			split = split2;
@@ -519,12 +525,15 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 				split->orig_start = split->start;
 			}
 
-			ret = add_extent_mapping(em_tree, split);
+			ret = add_extent_mapping(em_tree, split, &to_free[2],
+						 &to_free[3]);
 			BUG_ON(ret);
 			free_extent_map(split);
 			split = NULL;
 		}
-		write_unlock(&em_tree->lock);
+		spin_unlock(&em_tree->lock);
+		for (i = 0; i < 4; i++)
+			free_extent_map(to_free[i]);
 
 		/* once for us */
 		free_extent_map(em);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13b0542..d896b39 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -573,6 +573,7 @@ static noinline int submit_compressed_extents(struct inode *inode,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key ins;
 	struct extent_map *em;
+	struct extent_map *to_free1 = NULL, *to_free2 = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree;
@@ -675,9 +676,12 @@ retry:
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 
 		while (1) {
-			write_lock(&em_tree->lock);
-			ret = add_extent_mapping(em_tree, em);
-			write_unlock(&em_tree->lock);
+			spin_lock(&em_tree->lock);
+			ret = add_extent_mapping(em_tree, em, &to_free1,
+						 &to_free2);
+			spin_unlock(&em_tree->lock);
+			free_extent_map(to_free1);
+			free_extent_map(to_free2);
 			if (ret != -EEXIST) {
 				free_extent_map(em);
 				break;
@@ -732,8 +736,9 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
 	struct extent_map *em;
 	u64 alloc_hint = 0;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = search_extent_mapping(em_tree, start, num_bytes);
+	rcu_read_unlock();
 	if (em) {
 		/*
 		 * if block start isn't an actual block number then find the
@@ -752,7 +757,6 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
 			free_extent_map(em);
 		}
 	}
-	read_unlock(&em_tree->lock);
 
 	return alloc_hint;
 }
@@ -786,6 +790,7 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 blocksize = root->sectorsize;
 	struct btrfs_key ins;
 	struct extent_map *em;
+	struct extent_map *to_free1 = NULL, *to_free2 = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
 
@@ -854,9 +859,12 @@ static noinline int cow_file_range(struct inode *inode,
 		set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 		while (1) {
-			write_lock(&em_tree->lock);
-			ret = add_extent_mapping(em_tree, em);
-			write_unlock(&em_tree->lock);
+			spin_lock(&em_tree->lock);
+			ret = add_extent_mapping(em_tree, em, &to_free1,
+						 &to_free2);
+			spin_unlock(&em_tree->lock);
+			free_extent_map(to_free1);
+			free_extent_map(to_free2);
 			if (ret != -EEXIST) {
 				free_extent_map(em);
 				break;
@@ -1195,6 +1203,7 @@ out_check:
 
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 			struct extent_map *em;
+			struct extent_map *to_free1 = NULL, *to_free2 = NULL;
 			struct extent_map_tree *em_tree;
 			em_tree = &BTRFS_I(inode)->extent_tree;
 			em = alloc_extent_map();
@@ -1207,9 +1216,12 @@ out_check:
 			em->bdev = root->fs_info->fs_devices->latest_bdev;
 			set_bit(EXTENT_FLAG_PINNED, &em->flags);
 			while (1) {
-				write_lock(&em_tree->lock);
-				ret = add_extent_mapping(em_tree, em);
-				write_unlock(&em_tree->lock);
+				spin_lock(&em_tree->lock);
+				ret = add_extent_mapping(em_tree, em, &to_free1,
+							 &to_free2);
+				spin_unlock(&em_tree->lock);
+				free_extent_map(to_free1);
+				free_extent_map(to_free2);
 				if (ret != -EEXIST) {
 					free_extent_map(em);
 					break;
@@ -4862,7 +4874,9 @@ out_fail:
 static int merge_extent_mapping(struct extent_map_tree *em_tree,
 				struct extent_map *existing,
 				struct extent_map *em,
-				u64 map_start, u64 map_len)
+				u64 map_start, u64 map_len,
+				struct extent_map **to_free1,
+				struct extent_map **to_free2)
 {
 	u64 start_diff;
 
@@ -4875,7 +4889,7 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
 		em->block_start += start_diff;
 		em->block_len -= start_diff;
 	}
-	return add_extent_mapping(em_tree, em);
+	return add_extent_mapping(em_tree, em, to_free1, to_free2);
 }
 
 static noinline int uncompress_inline(struct btrfs_path *path,
@@ -4944,17 +4958,19 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	struct extent_buffer *leaf;
 	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
+	struct extent_map *to_free[4];
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_trans_handle *trans = NULL;
 	int compress_type;
+	int i;
 
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
@@ -5166,8 +5182,10 @@ insert:
 	}
 
 	err = 0;
-	write_lock(&em_tree->lock);
-	ret = add_extent_mapping(em_tree, em);
+	for (i = 0; i < 4; i++)
+		to_free[i] = NULL;
+	spin_lock(&em_tree->lock);
+	ret = add_extent_mapping(em_tree, em, &to_free[0], &to_free[1]);
 	/* it is possible that someone inserted the extent into the tree
 	 * while we had the lock dropped.  It is also possible that
 	 * an overlapping map exists in the tree
@@ -5189,7 +5207,9 @@ insert:
 			if (existing) {
 				err = merge_extent_mapping(em_tree, existing,
 							   em, start,
-							   root->sectorsize);
+							   root->sectorsize,
+							   &to_free[2],
+							   &to_free[3]);
 				free_extent_map(existing);
 				if (err) {
 					free_extent_map(em);
@@ -5206,7 +5226,9 @@ insert:
 			err = 0;
 		}
 	}
-	write_unlock(&em_tree->lock);
+	spin_unlock(&em_tree->lock);
+	for (i = 0; i < 4; i++)
+		free_extent_map(to_free[i]);
 out:
 
 	trace_btrfs_get_extent(root, em);
@@ -5414,9 +5436,12 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 	while (insert) {
-		write_lock(&em_tree->lock);
-		ret = add_extent_mapping(em_tree, em);
-		write_unlock(&em_tree->lock);
+		struct extent_map *to_free1 = NULL, *to_free2 = NULL;
+		spin_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em, &to_free1, &to_free2);
+		spin_unlock(&em_tree->lock);
+		free_extent_map(to_free1);
+		free_extent_map(to_free2);
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
index cfb5543..b92d207 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2884,6 +2884,7 @@ int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_map *em;
+	struct extent_map *to_free1 = NULL, *to_free2 = NULL;
 	int ret = 0;
 
 	em = alloc_extent_map();
@@ -2899,9 +2900,11 @@ int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
 
 	lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
 	while (1) {
-		write_lock(&em_tree->lock);
-		ret = add_extent_mapping(em_tree, em);
-		write_unlock(&em_tree->lock);
+		spin_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em, &to_free1, &to_free2);
+		spin_unlock(&em_tree->lock);
+		free_extent_map(to_free1);
+		free_extent_map(to_free2);
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
index c803478..1069922 100644
--- a/fs/btrfs/skiplist.c
+++ b/fs/btrfs/skiplist.c
@@ -62,7 +62,7 @@ inline void sl_link_node(struct sl_node *node, struct sl_node **backlook,
 
 		node->next[i] = q;
 		node->prev[i] = p;
-		p->next[i] = node;
+		rcu_assign_pointer(p->next[i], node);
 		q->prev[i] = node;
 
 		i++;
@@ -78,11 +78,11 @@ void sl_erase(struct sl_node *node, struct sl_list *list)
 
 	level = node->level;
 
-	for (i = 0; i <= level; i++) {
+	for (i = level; i >= 0; i--) {
 		prev = node->prev[i];
 		next = node->next[i];
 
-		prev->next[i] = next;
+		rcu_assign_pointer(prev->next[i], next);
 		next->prev[i] = prev;
 		node->next[i] = node;
 		node->prev[i] = node;
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
index adaac9e..c41502d 100644
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
+	spin_lock(&em_tree->lock);
 	remove_extent_mapping(em_tree, em);
-	write_unlock(&em_tree->lock);
+	spin_unlock(&em_tree->lock);
 
 	kfree(map);
 	em->bdev = NULL;
@@ -2378,6 +2378,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct map_lookup *map = NULL;
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
+	struct extent_map *to_free1 = NULL, *to_free2 = NULL;
 	struct btrfs_device_info *devices_info = NULL;
 	u64 total_avail;
 	int num_stripes;	/* total number of stripes to allocate */
@@ -2589,9 +2590,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	em->block_len = em->len;
 
 	em_tree = &extent_root->fs_info->mapping_tree.map_tree;
-	write_lock(&em_tree->lock);
-	ret = add_extent_mapping(em_tree, em);
-	write_unlock(&em_tree->lock);
+	spin_lock(&em_tree->lock);
+	ret = add_extent_mapping(em_tree, em, &to_free1, &to_free2);
+	spin_unlock(&em_tree->lock);
+	free_extent_map(to_free1);
+	free_extent_map(to_free2);
 	BUG_ON(ret);
 	free_extent_map(em);
 
@@ -2800,9 +2803,9 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	int readonly = 0;
 	int i;
 
-	read_lock(&map_tree->map_tree.lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
-	read_unlock(&map_tree->map_tree.lock);
+	rcu_read_unlock();
 	if (!em)
 		return 1;
 
@@ -2854,9 +2857,9 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	int ret;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, logical, len);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 	BUG_ON(!em);
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
@@ -2921,9 +2924,9 @@ again:
 		atomic_set(&bbio->error, 0);
 	}
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, logical, *length);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	if (!em) {
 		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
@@ -3187,9 +3190,9 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	u64 stripe_nr;
 	int i, j, nr = 0;
 
-	read_lock(&em_tree->lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(em_tree, chunk_start, 1);
-	read_unlock(&em_tree->lock);
+	rcu_read_unlock();
 
 	BUG_ON(!em || em->start != chunk_start);
 	map = (struct map_lookup *)em->bdev;
@@ -3461,6 +3464,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct extent_map *em;
+	struct extent_map *to_free1 = NULL, *to_free2 = NULL;
 	u64 logical;
 	u64 length;
 	u64 devid;
@@ -3472,9 +3476,9 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
 
-	read_lock(&map_tree->map_tree.lock);
+	rcu_read_lock();
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
-	read_unlock(&map_tree->map_tree.lock);
+	rcu_read_unlock();
 
 	/* already mapped? */
 	if (em && em->start <= logical && em->start + em->len > logical) {
@@ -3533,9 +3537,11 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		map->stripes[i].dev->in_fs_metadata = 1;
 	}
 
-	write_lock(&map_tree->map_tree.lock);
-	ret = add_extent_mapping(&map_tree->map_tree, em);
-	write_unlock(&map_tree->map_tree.lock);
+	spin_lock(&map_tree->map_tree.lock);
+	ret = add_extent_mapping(&map_tree->map_tree, em, &to_free1, &to_free2);
+	spin_unlock(&map_tree->map_tree.lock);
+	free_extent_map(to_free1);
+	free_extent_map(to_free2);
 	BUG_ON(ret);
 	free_extent_map(em);
 
-- 
1.6.5.2

