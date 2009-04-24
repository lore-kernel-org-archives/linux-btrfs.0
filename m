From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: async block group caching
Date: Fri, 24 Apr 2009 09:14:38 -0400
Message-ID: <1240578878-25816-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch moves the caching of the block group off to a kthread in order to
allow people to allocate sooner.  Instead of blocking up behind the caching
mutex, we instead kick of the caching kthread, and then attempt to make an
allocation.  If we cannot, we wait on the block groups caching waitqueue, which
the caching kthread will wake the waiting threads up everytime it finds 2 meg
worth of space, and then again when its finished caching.  This is how I tested
the speedup from this

mkfs the disk
mount the disk
fill the disk up with fs_mark
unmount the disk
mount the disk
time touch /mnt/foo

Without my changes this took 16 seconds on my box, with these changes it now
takes 6 seconds.  Still not great, but we're getting closer.

Another change thats been put in place is we lock the super mirror's in the
pinned extent map in order to keep us from adding that stuff as free space when
caching the block group.  This doesn't really change anything else as far as the
pinned extent map is concerned, since for actual pinned extents we use
EXTENT_DIRTY, but it does mean that when we unmount we have to go in and unlock
those extents to keep from leaking memory.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h            |   15 +++-
 fs/btrfs/disk-io.c          |    1 +
 fs/btrfs/extent-tree.c      |  226 +++++++++++++++++++++++++++++-------------
 fs/btrfs/free-space-cache.c |    3 +
 4 files changed, 173 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b82931f..86398a2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -658,24 +658,34 @@ struct btrfs_free_cluster {
 	struct list_head block_group_list;
 };
 
+enum btrfs_caching_type {
+	BTRFS_CACHE_NO		= 0,
+	BTRFS_CACHE_STARTED	= 1,
+	BTRFS_CACHE_FINISHED	= 2,
+};
+
 struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
+	struct btrfs_fs_info *fs_info;
 	spinlock_t lock;
-	struct mutex cache_mutex;
 	u64 pinned;
 	u64 reserved;
 	u64 flags;
-	int cached;
 	int ro;
 	int dirty;
 
+	/* caching crap */
+	wait_queue_head_t caching_q;
+	int cached;
+
 	struct btrfs_space_info *space_info;
 
 	/* free space cache stuff */
 	spinlock_t tree_lock;
 	struct rb_root free_space_bytes;
 	struct rb_root free_space_offset;
+	u64 free_space;
 
 	/* block group cache stuff */
 	struct rb_node cache_node;
@@ -1883,6 +1893,7 @@ void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+void btrfs_free_super_mirror_extents(struct btrfs_fs_info *info);
 /* ctree.c */
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e68ef7b..d2e24c9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2316,6 +2316,7 @@ int close_ctree(struct btrfs_root *root)
 		free_extent_buffer(root->fs_info->csum_root->node);
 
 	btrfs_free_block_groups(root->fs_info);
+	btrfs_free_super_mirror_extents(root->fs_info);
 
 	del_fs_roots(fs_info);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3b31d..faa0c1d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/sort.h>
 #include <linux/rcupdate.h>
+#include <linux/kthread.h>
 #include "compat.h"
 #include "hash.h"
 #include "crc32c.h"
@@ -156,21 +157,62 @@ block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
 	return ret;
 }
 
+void btrfs_free_super_mirror_extents(struct btrfs_fs_info *info)
+{
+	u64 start, end, last = 0;
+	int ret;
+
+	while (1) {
+		ret = find_first_extent_bit(&info->pinned_extents, last,
+					    &start, &end, EXTENT_LOCKED);
+		if (ret)
+			break;
+
+		unlock_extent(&info->pinned_extents, start, end, GFP_NOFS);
+		last = end+1;
+	}
+}
+
+static int remove_sb_from_cache(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	u64 bytenr;
+	u64 *logical;
+	int stripe_len;
+	int i, nr, ret;
+
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		ret = btrfs_rmap_block(&root->fs_info->mapping_tree, 0, bytenr,
+				       0, &logical, &nr, &stripe_len);
+		BUG_ON(ret);
+		while (nr--) {
+			ret = try_lock_extent(&fs_info->pinned_extents,
+					      logical[nr],
+					      logical[nr] + stripe_len - 1,
+					      GFP_NOFS);
+			BUG_ON(!ret);
+		}
+		kfree(logical);
+	}
+	return 0;
+}
+
 /*
  * this is only called by cache_block_group, since we could have freed extents
  * we need to check the pinned_extents for any extents that can't be used yet
  * since their free space will be released as soon as the transaction commits.
  */
-static int add_new_free_space(struct btrfs_block_group_cache *block_group,
+static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 			      struct btrfs_fs_info *info, u64 start, u64 end)
 {
-	u64 extent_start, extent_end, size;
+	u64 extent_start, extent_end, size, total_added = 0;
 	int ret;
 
 	while (start < end) {
 		ret = find_first_extent_bit(&info->pinned_extents, start,
 					    &extent_start, &extent_end,
-					    EXTENT_DIRTY);
+					    EXTENT_DIRTY|EXTENT_LOCKED);
 		if (ret)
 			break;
 
@@ -178,6 +220,7 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 			start = extent_end + 1;
 		} else if (extent_start > start && extent_start < end) {
 			size = extent_start - start;
+			total_added += size;
 			ret = btrfs_add_free_space(block_group, start,
 						   size);
 			BUG_ON(ret);
@@ -189,65 +232,33 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (start < end) {
 		size = end - start;
+		total_added += size;
 		ret = btrfs_add_free_space(block_group, start, size);
 		BUG_ON(ret);
 	}
 
-	return 0;
-}
-
-static int remove_sb_from_cache(struct btrfs_root *root,
-				struct btrfs_block_group_cache *cache)
-{
-	u64 bytenr;
-	u64 *logical;
-	int stripe_len;
-	int i, nr, ret;
-
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
-				       cache->key.objectid, bytenr, 0,
-				       &logical, &nr, &stripe_len);
-		BUG_ON(ret);
-		while (nr--) {
-			btrfs_remove_free_space(cache, logical[nr],
-						stripe_len);
-		}
-		kfree(logical);
-	}
-	return 0;
+	return total_added;
 }
 
-static int cache_block_group(struct btrfs_root *root,
-			     struct btrfs_block_group_cache *block_group)
+static int caching_kthread(void *data)
 {
+	struct btrfs_block_group_cache *block_group = data;
+	struct btrfs_root *root = block_group->fs_info->extent_root;
+	u64 last = 0;
 	struct btrfs_path *path;
 	int ret = 0;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	int slot;
-	u64 last;
+	u64 total_found = 0;
 
-	if (!block_group)
-		return 0;
-
-	root = root->fs_info->extent_root;
-
-	if (block_group->cached)
-		return 0;
+	BUG_ON(!root);
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-
 	path->reada = 2;
-	/*
-	 * we get into deadlocks with paths held by callers of this function.
-	 * since the alloc_mutex is protecting things right now, just
-	 * skip the locking here
-	 */
-	path->skip_locking = 1;
+
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 	key.objectid = last;
 	key.offset = 0;
@@ -257,6 +268,10 @@ static int cache_block_group(struct btrfs_root *root,
 		goto err;
 
 	while (1) {
+		smp_mb();
+		if (block_group->fs_info->closing)
+			break;
+
 		leaf = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(leaf)) {
@@ -277,24 +292,55 @@ static int cache_block_group(struct btrfs_root *root,
 			break;
 
 		if (btrfs_key_type(&key) == BTRFS_EXTENT_ITEM_KEY) {
-			add_new_free_space(block_group, root->fs_info, last,
-					   key.objectid);
-
+			total_found += add_new_free_space(block_group,
+							  root->fs_info, last,
+							  key.objectid);
 			last = key.objectid + key.offset;
 		}
+
+		if (total_found > (1024 * 1024 * 2)) {
+			total_found = 0;
+			wake_up(&block_group->caching_q);
+		}
 next:
 		path->slots[0]++;
 	}
 
-	add_new_free_space(block_group, root->fs_info, last,
-			   block_group->key.objectid +
-			   block_group->key.offset);
+	total_found += add_new_free_space(block_group, root->fs_info, last,
+					  block_group->key.objectid +
+					  block_group->key.offset);
 
-	block_group->cached = 1;
-	remove_sb_from_cache(root, block_group);
-	ret = 0;
+	spin_lock(&block_group->lock);
+	block_group->cached = BTRFS_CACHE_FINISHED;
+	spin_unlock(&block_group->lock);
 err:
 	btrfs_free_path(path);
+	wake_up(&block_group->caching_q);
+
+	return 0;
+}
+
+static int cache_block_group(struct btrfs_block_group_cache *cache)
+{
+	struct task_struct *tsk;
+	int ret = 0;
+
+	spin_lock(&cache->lock);
+	if (cache->cached != BTRFS_CACHE_NO) {
+		spin_unlock(&cache->lock);
+		return ret;
+	}
+	cache->cached = BTRFS_CACHE_STARTED;
+	spin_unlock(&cache->lock);
+
+	tsk = kthread_run(caching_kthread, cache, "btrfs-cache-%llu\n",
+			  cache->key.objectid);
+	if (IS_ERR(tsk)) {
+		ret = PTR_ERR(tsk);
+		printk(KERN_ERR "error running thread %d\n", ret);
+		BUG();
+	}
+
 	return ret;
 }
 
@@ -2075,7 +2121,7 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 			fs_info->total_pinned -= len;
-			if (cache->cached)
+			if (cache->cached == BTRFS_CACHE_FINISHED)
 				btrfs_add_free_space(cache, bytenr, len);
 		}
 		btrfs_put_block_group(cache);
@@ -2602,21 +2648,19 @@ search:
 	down_read(&space_info->groups_sem);
 	list_for_each_entry(block_group, &space_info->block_groups, list) {
 		u64 offset;
+		int cached;
 
 		atomic_inc(&block_group->count);
 		search_start = block_group->key.objectid;
 
 have_block_group:
-		if (unlikely(!block_group->cached)) {
-			mutex_lock(&block_group->cache_mutex);
-			ret = cache_block_group(root, block_group);
-			mutex_unlock(&block_group->cache_mutex);
-			if (ret) {
-				btrfs_put_block_group(block_group);
-				break;
-			}
+		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
+			ret = cache_block_group(block_group);
+			BUG_ON(ret);
 		}
 
+		cached = (block_group->cached == BTRFS_CACHE_FINISHED);
+
 		if (unlikely(block_group->ro))
 			goto loop;
 
@@ -2680,7 +2724,17 @@ have_block_group:
 					spin_unlock(&last_ptr->refill_lock);
 					goto checks;
 				}
+			} else if (!cached) {
+				spin_unlock(&last_ptr->refill_lock);
+				wait_event(block_group->caching_q,
+					   block_group->cached ==
+					   BTRFS_CACHE_FINISHED ||
+					   (block_group->free_space >
+					    num_bytes + empty_cluster +
+					    empty_size));
+				goto have_block_group;
 			}
+
 			/*
 			 * at this point we either didn't find a cluster
 			 * or we weren't able to allocate a block from our
@@ -2698,8 +2752,15 @@ have_block_group:
 
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
-		if (!offset)
+		if (!offset && cached) {
 			goto loop;
+		} else if (!offset) {
+			wait_event(block_group->caching_q,
+				   block_group->cached == BTRFS_CACHE_FINISHED
+				   || (block_group->free_space > num_bytes +
+				       empty_size));
+			goto have_block_group;
+		}
 checks:
 		search_start = stripe_align(root, offset);
 
@@ -3020,9 +3081,9 @@ int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_cache *block_group;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	mutex_lock(&block_group->cache_mutex);
-	cache_block_group(root, block_group);
-	mutex_unlock(&block_group->cache_mutex);
+	cache_block_group(block_group);
+	wait_event(block_group->caching_q,
+		   block_group->cached == BTRFS_CACHE_FINISHED);
 
 	ret = btrfs_remove_free_space(block_group, ins->objectid,
 				      ins->offset);
@@ -5774,11 +5835,17 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			 &info->block_group_cache_tree);
 		spin_unlock(&info->block_group_cache_lock);
 
-		btrfs_remove_free_space_cache(block_group);
 		down_write(&block_group->space_info->groups_sem);
 		list_del(&block_group->list);
 		up_write(&block_group->space_info->groups_sem);
 
+		if (block_group->cached == BTRFS_CACHE_STARTED)
+			wait_event(block_group->caching_q,
+				   block_group->cached ==
+				   BTRFS_CACHE_FINISHED);
+
+		btrfs_remove_free_space_cache(block_group);
+
 		WARN_ON(atomic_read(&block_group->count) != 1);
 		kfree(block_group);
 
@@ -5824,6 +5891,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	if (!path)
 		return -ENOMEM;
 
+	/*
+	 * before we start reading the block groups, we want to lock the super
+	 * mirror's in the pinned tree, so when we cache the block groups we
+	 * don't think that we have free space where we have super mirrors
+	 */
+	remove_sb_from_cache(root);
+
 	while (1) {
 		ret = find_first_block_group(root, path, &key);
 		if (ret > 0) {
@@ -5844,7 +5918,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		atomic_set(&cache->count, 1);
 		spin_lock_init(&cache->lock);
 		spin_lock_init(&cache->tree_lock);
-		mutex_init(&cache->cache_mutex);
+		cache->fs_info = info;
+		init_waitqueue_head(&cache->caching_q);
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
 		read_extent_buffer(leaf, &cache->item,
@@ -5898,10 +5973,12 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	cache->fs_info = root->fs_info;
+	cache->cached = BTRFS_CACHE_FINISHED;
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	spin_lock_init(&cache->tree_lock);
-	mutex_init(&cache->cache_mutex);
+	init_waitqueue_head(&cache->caching_q);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 
@@ -5910,6 +5987,9 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
+	ret = btrfs_add_free_space(cache, chunk_offset, size);
+	BUG_ON(ret);
+
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
@@ -5952,11 +6032,17 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
 	spin_unlock(&root->fs_info->block_group_cache_lock);
-	btrfs_remove_free_space_cache(block_group);
+
 	down_write(&block_group->space_info->groups_sem);
 	list_del(&block_group->list);
 	up_write(&block_group->space_info->groups_sem);
 
+	if (block_group->cached == BTRFS_CACHE_STARTED)
+		wait_event(block_group->caching_q,
+			   block_group->cached == BTRFS_CACHE_FINISHED);
+
+	btrfs_remove_free_space_cache(block_group);
+
 	spin_lock(&block_group->space_info->lock);
 	block_group->space_info->total_bytes -= block_group->key.offset;
 	block_group->space_info->bytes_readonly -= block_group->key.offset;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 385520b..ed9f230 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -180,6 +180,7 @@ static struct btrfs_free_space *tree_search_bytes(struct rb_root *root,
 static void unlink_free_space(struct btrfs_block_group_cache *block_group,
 			      struct btrfs_free_space *info)
 {
+	block_group->free_space -= info->bytes;
 	rb_erase(&info->offset_index, &block_group->free_space_offset);
 	rb_erase(&info->bytes_index, &block_group->free_space_bytes);
 }
@@ -201,6 +202,8 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 	if (ret)
 		return ret;
 
+	block_group->free_space += info->bytes;
+
 	return ret;
 }
 
-- 
1.5.4.3

