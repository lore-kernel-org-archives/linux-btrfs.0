From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: async block group caching v6
Date: Wed, 8 Jul 2009 16:03:15 -0400
Message-ID: <20090708200313.GA2269@localhost.localdomain>
References: <20090707194818.GB2096@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090707194818.GB2096@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 07, 2009 at 03:48:18PM -0400, Josef Bacik wrote:
> This patch moves the caching of the block group off to a kthread in order to
> allow people to allocate sooner.  Instead of blocking up behind the caching
> mutex, we instead kick of the caching kthread, and then attempt to make an
> allocation.  If we cannot, we wait on the block groups caching waitqueue, which
> the caching kthread will wake the waiting threads up everytime it finds 2 meg
> worth of space, and then again when its finished caching.  This is how I tested
> the speedup from this
> 
> mkfs the disk
> mount the disk
> fill the disk up with fs_mark
> unmount the disk
> mount the disk
> time touch /mnt/foo
> 
> Without my changes this took 11 seconds on my box, with these changes it now
> takes 1 second.
> 
> Another change thats been put in place is we lock the super mirror's in the
> pinned extent map in order to keep us from adding that stuff as free space when
> caching the block group.  This doesn't really change anything else as far as the
> pinned extent map is concerned, since for actual pinned extents we use
> EXTENT_DIRTY, but it does mean that when we unmount we have to go in and unlock
> those extents to keep from leaking memory.
> 
> I've also added a check where when we are reading block groups from disk, if the
> amount of space used == the size of the block group, we go ahead and mark the
> block group as cached.  This drastically reduces the amount of time it takes to
> cache the block groups.  Using the same test as above, except doing a dd to a
> file and then unmounting, it used to take 33 seconds to umount, now it takes 3
> seconds.
> 
> This version uses the commit_root in the caching kthread, and then keeps track
> of how many async caching threads are running at any given time so if one of the
> async threads is still running as we cross transactions we can wait until its
> finished before handling the pinned extents.  Thank you,
> 

Ok here is the updated version of this patch.  I think this is the right way to
deal with the pinned stuff.  If we have outstanding caching threads when we copy
the pinned extents then we go through and mark all pinned extents with DELALLOC,
and then make the async threads cleanup their own damned pinned extents.  Then
btrfs_finish_extent_commit will go through and cleanup any other pinned extents
that were left over because the extent belonged to a block group that isnt
cached yet or was already cached.  This seems to be the least crappy way to fix
the whole async threads crossing a transaction problem.  The nice sideaffect is
that it seems to make things a bit faster, like 1/2 a second faster.  Thanks,


Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h            |   21 ++-
 fs/btrfs/disk-io.c          |    3 +
 fs/btrfs/extent-tree.c      |  403 ++++++++++++++++++++++++++++++++++---------
 fs/btrfs/free-space-cache.c |   42 +++--
 fs/btrfs/transaction.c      |   23 ++-
 fs/btrfs/tree-log.c         |    2 +-
 6 files changed, 381 insertions(+), 113 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eb6639c..dd97f09 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -721,11 +721,17 @@ struct btrfs_free_cluster {
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
@@ -733,15 +739,19 @@ struct btrfs_block_group_cache {
 	int extents_thresh;
 	int free_extents;
 	int total_bitmaps;
-	int cached;
 	int ro;
 	int dirty;
 
+	/* cache tracking stuff */
+	wait_queue_head_t caching_q;
+	int cached;
+
 	struct btrfs_space_info *space_info;
 
 	/* free space cache stuff */
 	spinlock_t tree_lock;
 	struct rb_root free_space_offset;
+	u64 free_space;
 
 	/* block group cache stuff */
 	struct rb_node cache_node;
@@ -834,6 +844,7 @@ struct btrfs_fs_info {
 	atomic_t async_submit_draining;
 	atomic_t nr_async_bios;
 	atomic_t async_delalloc_pages;
+	atomic_t async_caching_threads;
 
 	/*
 	 * this is used by the balancing code to wait for all the pending
@@ -950,6 +961,9 @@ struct btrfs_root {
 	/* the node lock is held while changing the node pointer */
 	spinlock_t node_lock;
 
+	/* taken when updating the commit root */
+	struct rw_semaphore commit_root_sem;
+
 	struct extent_buffer *commit_root;
 	struct btrfs_root *log_root;
 	struct btrfs_root *reloc_root;
@@ -1911,7 +1925,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_update_pinned_extents(struct btrfs_root *root,
-				u64 bytenr, u64 num, int pin);
+				u64 bytenr, u64 num, int pin, int mark_free);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct extent_buffer *leaf);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
@@ -1996,6 +2010,7 @@ void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+void btrfs_free_super_mirror_extents(struct btrfs_fs_info *info);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0d50d49..405555a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -907,6 +907,7 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	spin_lock_init(&root->inode_lock);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
+	init_rwsem(&root->commit_root_sem);
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
@@ -1566,6 +1567,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->async_delalloc_pages, 0);
 	atomic_set(&fs_info->async_submit_draining, 0);
 	atomic_set(&fs_info->nr_async_bios, 0);
+	atomic_set(&fs_info->async_caching_threads, 0);
 	fs_info->sb = sb;
 	fs_info->max_extent = (u64)-1;
 	fs_info->max_inline = 8192 * 1024;
@@ -2327,6 +2329,7 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(root->fs_info->csum_root->commit_root);
 
 	btrfs_free_block_groups(root->fs_info);
+	btrfs_free_super_mirror_extents(root->fs_info);
 
 	del_fs_roots(fs_info);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index af9d94b..f0da696 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/sort.h>
 #include <linux/rcupdate.h>
+#include <linux/kthread.h>
 #include "compat.h"
 #include "hash.h"
 #include "ctree.h"
@@ -61,6 +62,13 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
 
+static noinline int
+block_group_cache_done(struct btrfs_block_group_cache *cache)
+{
+	smp_mb();
+	return cache->cached == BTRFS_CACHE_FINISHED;
+}
+
 static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
 {
 	return (cache->flags & bits) == bits;
@@ -145,21 +153,64 @@ block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
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
+static int remove_sb_from_cache(struct btrfs_root *root,
+				struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	u64 bytenr;
+	u64 *logical;
+	int stripe_len;
+	int i, nr, ret;
+
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
+				       cache->key.objectid, bytenr,
+				       0, &logical, &nr, &stripe_len);
+		BUG_ON(ret);
+		while (nr--) {
+			try_lock_extent(&fs_info->pinned_extents,
+					logical[nr],
+					logical[nr] + stripe_len - 1, GFP_NOFS);
+		}
+		kfree(logical);
+	}
+
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
+					    EXTENT_DIRTY|EXTENT_LOCKED|
+					    EXTENT_DELALLOC);
 		if (ret)
 			break;
 
@@ -167,6 +218,7 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 			start = extent_end + 1;
 		} else if (extent_start > start && extent_start < end) {
 			size = extent_start - start;
+			total_added += size;
 			ret = btrfs_add_free_space(block_group, start,
 						   size);
 			BUG_ON(ret);
@@ -178,84 +230,138 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (start < end) {
 		size = end - start;
+		total_added += size;
 		ret = btrfs_add_free_space(block_group, start, size);
 		BUG_ON(ret);
 	}
 
-	return 0;
+	return total_added;
 }
 
-static int remove_sb_from_cache(struct btrfs_root *root,
-				struct btrfs_block_group_cache *cache)
+DEFINE_MUTEX(discard_mutex);
+
+/*
+ * if async kthreads are running when we cross transactions, we mark any pinned
+ * extents with EXTENT_DELALLOC and then let the caching kthreads clean up those
+ * extents when they are done.  Also we run this from btrfs_finish_extent_commit
+ * in case there were some pinned extents that were missed because we had
+ * already cached that block group.
+ */
+static void btrfs_discard_pinned_extents(struct btrfs_fs_info *fs_info,
+					 struct btrfs_block_group_cache *cache)
 {
-	u64 bytenr;
-	u64 *logical;
-	int stripe_len;
-	int i, nr, ret;
+	u64 start, end, last;
+	int ret;
 
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
-				       cache->key.objectid, bytenr, 0,
-				       &logical, &nr, &stripe_len);
-		BUG_ON(ret);
-		while (nr--) {
-			btrfs_remove_free_space(cache, logical[nr],
-						stripe_len);
+	if (!cache)
+		last = 0;
+	else
+		last = cache->key.objectid;
+
+	mutex_lock(&discard_mutex);
+	while (1) {
+		ret = find_first_extent_bit(&fs_info->pinned_extents, last,
+					    &start, &end, EXTENT_DELALLOC);
+		if (ret)
+			break;
+
+		if (cache && start >= cache->key.objectid + cache->key.offset)
+			break;
+
+
+		if (!cache) {
+			cache = btrfs_lookup_block_group(fs_info, start);
+			BUG_ON(!cache);
+
+			start = max(start, cache->key.objectid);
+			end = min(end, cache->key.objectid + cache->key.offset - 1);
+
+			if (block_group_cache_done(cache))
+				btrfs_add_free_space(cache, start,
+						     end - start + 1);
+			cache = NULL;
+		} else {
+			start = max(start, cache->key.objectid);
+			end = min(end, cache->key.objectid + cache->key.offset - 1);
+			btrfs_add_free_space(cache, start, end - start + 1);
+		}
+
+		clear_extent_bits(&fs_info->pinned_extents, start, end,
+				  EXTENT_DELALLOC, GFP_NOFS);
+		last = end + 1;
+
+		if (need_resched()) {
+			mutex_unlock(&discard_mutex);
+			cond_resched();
+			mutex_lock(&discard_mutex);
 		}
-		kfree(logical);
 	}
-	return 0;
+	mutex_unlock(&discard_mutex);
 }
 
-static int cache_block_group(struct btrfs_root *root,
-			     struct btrfs_block_group_cache *block_group)
+static int caching_kthread(void *data)
 {
+	struct btrfs_block_group_cache *block_group = data;
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
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
+	BUG_ON(!fs_info);
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = 2;
+	atomic_inc(&fs_info->async_caching_threads);
+	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
+again:
+	/* need to make sure the commit_root doesn't disappear */
+	down_read(&fs_info->extent_root->commit_root_sem);
+
 	/*
-	 * we get into deadlocks with paths held by callers of this function.
-	 * since the alloc_mutex is protecting things right now, just
-	 * skip the locking here
+	 * We don't want to deadlock with somebody trying to allocate a new
+	 * extent for the extent root while also trying to search the extent
+	 * root to add free space.  So we skip locking and search the commit
+	 * root, since its read-only
 	 */
 	path->skip_locking = 1;
-	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
+	path->search_commit_root = 1;
+	path->reada = 2;
+
 	key.objectid = last;
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
 
 	while (1) {
+		smp_mb();
+		if (block_group->fs_info->closing)
+			break;
+
 		leaf = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(root, path);
+			ret = btrfs_next_leaf(fs_info->extent_root, path);
 			if (ret < 0)
 				goto err;
-			if (ret == 0)
-				continue;
-			else
+			else if (ret)
 				break;
+
+			if (need_resched()) {
+				btrfs_release_path(fs_info->extent_root, path);
+				up_read(&fs_info->extent_root->commit_root_sem);
+				cond_resched();
+				goto again;
+			}
+
+			continue;
 		}
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid < block_group->key.objectid)
@@ -266,24 +372,62 @@ static int cache_block_group(struct btrfs_root *root,
 			break;
 
 		if (btrfs_key_type(&key) == BTRFS_EXTENT_ITEM_KEY) {
-			add_new_free_space(block_group, root->fs_info, last,
-					   key.objectid);
-
+			total_found += add_new_free_space(block_group,
+							  fs_info, last,
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
+	ret = 0;
 
-	add_new_free_space(block_group, root->fs_info, last,
-			   block_group->key.objectid +
-			   block_group->key.offset);
+	total_found += add_new_free_space(block_group, fs_info, last,
+					  block_group->key.objectid +
+					  block_group->key.offset);
+
+	spin_lock(&block_group->lock);
+	block_group->cached = BTRFS_CACHE_FINISHED;
+	spin_unlock(&block_group->lock);
 
-	block_group->cached = 1;
-	remove_sb_from_cache(root, block_group);
-	ret = 0;
 err:
 	btrfs_free_path(path);
+	up_read(&fs_info->extent_root->commit_root_sem);
+	atomic_dec(&fs_info->async_caching_threads);
+	wake_up(&block_group->caching_q);
+
+	if (!ret)
+		btrfs_discard_pinned_extents(fs_info, block_group);
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
 
@@ -1722,7 +1866,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 				BUG_ON(ret);
 			}
 			btrfs_update_pinned_extents(root, node->bytenr,
-						    node->num_bytes, 1);
+						    node->num_bytes, 1, 0);
 			update_reserved_extents(root, node->bytenr,
 						node->num_bytes, 0);
 		}
@@ -2942,7 +3086,7 @@ static u64 first_logical_byte(struct btrfs_root *root, u64 search_start)
 }
 
 int btrfs_update_pinned_extents(struct btrfs_root *root,
-				u64 bytenr, u64 num, int pin)
+				u64 bytenr, u64 num, int pin, int mark_free)
 {
 	u64 len;
 	struct btrfs_block_group_cache *cache;
@@ -2977,7 +3121,7 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 			fs_info->total_pinned -= len;
-			if (cache->cached)
+			if (block_group_cache_done(cache) && mark_free)
 				btrfs_add_free_space(cache, bytenr, len);
 		}
 		btrfs_put_block_group(cache);
@@ -3023,14 +3167,27 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 	u64 last = 0;
 	u64 start;
 	u64 end;
+	bool caching_kthreads = false;
 	struct extent_io_tree *pinned_extents = &root->fs_info->pinned_extents;
 	int ret;
 
+	if (atomic_read(&root->fs_info->async_caching_threads))
+		caching_kthreads = true;
+
 	while (1) {
 		ret = find_first_extent_bit(pinned_extents, last,
 					    &start, &end, EXTENT_DIRTY);
 		if (ret)
 			break;
+
+		/*
+		 * we need to make sure that the pinned extents don't go away
+		 * while we are caching block groups
+		 */
+		if (unlikely(caching_kthreads))
+			set_extent_delalloc(pinned_extents, start, end,
+					    GFP_NOFS);
+
 		set_extent_dirty(copy, start, end, GFP_NOFS);
 		last = end + 1;
 	}
@@ -3044,6 +3201,12 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	u64 start;
 	u64 end;
 	int ret;
+	int mark_free = 1;
+
+	ret = find_first_extent_bit(&root->fs_info->pinned_extents, 0,
+				    &start, &end, EXTENT_DELALLOC);
+	if (!ret)
+		mark_free = 0;
 
 	while (1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
@@ -3054,11 +3217,16 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 		ret = btrfs_discard_extent(root, start, end + 1 - start);
 
 		/* unlocks the pinned mutex */
-		btrfs_update_pinned_extents(root, start, end + 1 - start, 0);
+		btrfs_update_pinned_extents(root, start, end + 1 - start, 0,
+					    mark_free);
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
 
 		cond_resched();
 	}
+
+	if (unlikely(!mark_free))
+		btrfs_discard_pinned_extents(root->fs_info, NULL);
+
 	return ret;
 }
 
@@ -3099,7 +3267,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 pinit:
 	btrfs_set_path_blocking(path);
 	/* unlocks the pinned mutex */
-	btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
+	btrfs_update_pinned_extents(root, bytenr, num_bytes, 1, 0);
 
 	BUG_ON(err < 0);
 	return 0;
@@ -3410,7 +3578,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
 		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
 		/* unlocks the pinned mutex */
-		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
+		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1, 0);
 		update_reserved_extents(root, bytenr, num_bytes, 0);
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
@@ -3437,6 +3605,37 @@ static u64 stripe_align(struct btrfs_root *root, u64 val)
 }
 
 /*
+ * when we wait for progress in the block group caching, its because
+ * our allocation attempt failed at least once.  So, we must sleep
+ * and let some progress happen before we try again.
+ *
+ * This function will sleep at least once waiting for new free space to
+ * show up, and then it will check the block group free space numbers
+ * for our min num_bytes.  Another option is to have it go ahead
+ * and look in the rbtree for a free extent of a given size, but this
+ * is a good start.
+ */
+static noinline int
+wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
+				u64 num_bytes)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&cache->caching_q, &wait, TASK_UNINTERRUPTIBLE);
+
+	if (block_group_cache_done(cache)) {
+		finish_wait(&cache->caching_q, &wait);
+		return 0;
+	}
+	schedule();
+	finish_wait(&cache->caching_q, &wait);
+
+	wait_event(cache->caching_q, block_group_cache_done(cache) ||
+		   (cache->free_space >= num_bytes));
+	return 0;
+}
+
+/*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
  * ins->objectid == block start
@@ -3523,21 +3722,19 @@ search:
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
 
+		cached = block_group_cache_done(block_group);
+
 		if (unlikely(block_group->ro))
 			goto loop;
 
@@ -3616,7 +3813,14 @@ refill_cluster:
 					spin_unlock(&last_ptr->refill_lock);
 					goto checks;
 				}
+			} else if (!cached) {
+				spin_unlock(&last_ptr->refill_lock);
+
+				wait_block_group_cache_progress(block_group,
+				       num_bytes + empty_cluster + empty_size);
+				goto have_block_group;
 			}
+
 			/*
 			 * at this point we either didn't find a cluster
 			 * or we weren't able to allocate a block from our
@@ -3634,8 +3838,13 @@ refill_cluster:
 
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
-		if (!offset)
+		if (!offset && cached) {
 			goto loop;
+		} else if (!offset) {
+			wait_block_group_cache_progress(block_group,
+					num_bytes + empty_size);
+			goto have_block_group;
+		}
 checks:
 		search_start = stripe_align(root, offset);
 		/* move on to the next group */
@@ -3798,7 +4007,7 @@ again:
 			       num_bytes, data, 1);
 		goto again;
 	}
-	if (ret) {
+	if (ret == -ENOSPC) {
 		struct btrfs_space_info *sinfo;
 
 		sinfo = __find_space_info(root->fs_info, data);
@@ -3806,7 +4015,6 @@ again:
 		       "wanted %llu\n", (unsigned long long)data,
 		       (unsigned long long)num_bytes);
 		dump_space_info(sinfo, num_bytes);
-		BUG();
 	}
 
 	return ret;
@@ -3844,7 +4052,9 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	ret = __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
 				     empty_size, hint_byte, search_end, ins,
 				     data);
-	update_reserved_extents(root, ins->objectid, ins->offset, 1);
+	if (!ret)
+		update_reserved_extents(root, ins->objectid, ins->offset, 1);
+
 	return ret;
 }
 
@@ -4006,9 +4216,9 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_cache *block_group;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	mutex_lock(&block_group->cache_mutex);
-	cache_block_group(root, block_group);
-	mutex_unlock(&block_group->cache_mutex);
+	cache_block_group(block_group);
+	wait_event(block_group->caching_q,
+		   block_group_cache_done(block_group));
 
 	ret = btrfs_remove_free_space(block_group, ins->objectid,
 				      ins->offset);
@@ -4039,7 +4249,8 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
 	ret = __btrfs_reserve_extent(trans, root, num_bytes, num_bytes,
 				     empty_size, hint_byte, search_end,
 				     ins, 0);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
 		if (parent == 0)
@@ -6738,11 +6949,16 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			 &info->block_group_cache_tree);
 		spin_unlock(&info->block_group_cache_lock);
 
-		btrfs_remove_free_space_cache(block_group);
 		down_write(&block_group->space_info->groups_sem);
 		list_del(&block_group->list);
 		up_write(&block_group->space_info->groups_sem);
 
+		if (block_group->cached == BTRFS_CACHE_STARTED)
+			wait_event(block_group->caching_q,
+				   block_group_cache_done(block_group));
+
+		btrfs_remove_free_space_cache(block_group);
+
 		WARN_ON(atomic_read(&block_group->count) != 1);
 		kfree(block_group);
 
@@ -6808,10 +7024,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		atomic_set(&cache->count, 1);
 		spin_lock_init(&cache->lock);
 		spin_lock_init(&cache->tree_lock);
-		mutex_init(&cache->cache_mutex);
+		cache->fs_info = info;
+		init_waitqueue_head(&cache->caching_q);
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
-		cache->sectorsize = root->sectorsize;
 
 		/*
 		 * we only want to have 32k of ram per block group for keeping
@@ -6829,6 +7045,26 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		key.objectid = found_key.objectid + found_key.offset;
 		btrfs_release_path(root, path);
 		cache->flags = btrfs_block_group_flags(&cache->item);
+		cache->sectorsize = root->sectorsize;
+
+		remove_sb_from_cache(root, cache);
+
+		/*
+		 * check for two cases, either we are full, and therefore
+		 * don't need to bother with the caching work since we won't
+		 * find any space, or we are empty, and we can just add all
+		 * the space in and be done with it.  This saves us _alot_ of
+		 * time, particularly in the full case.
+		 */
+		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
+			cache->cached = BTRFS_CACHE_FINISHED;
+		} else if (btrfs_block_group_used(&cache->item) == 0) {
+			cache->cached = BTRFS_CACHE_FINISHED;
+			add_new_free_space(cache, root->fs_info,
+					   found_key.objectid,
+					   found_key.objectid +
+					   found_key.offset);
+		}
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
@@ -6884,7 +7120,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	spin_lock_init(&cache->tree_lock);
-	mutex_init(&cache->cache_mutex);
+	init_waitqueue_head(&cache->caching_q);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 
@@ -6893,11 +7129,12 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
-	cache->cached = 1;
-	ret = btrfs_add_free_space(cache, chunk_offset, size);
-	BUG_ON(ret);
+	cache->cached = BTRFS_CACHE_FINISHED;
 	remove_sb_from_cache(root, cache);
 
+	add_new_free_space(cache, root->fs_info, chunk_offset,
+			   chunk_offset + size);
+
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
@@ -6956,7 +7193,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
 	spin_unlock(&root->fs_info->block_group_cache_lock);
-	btrfs_remove_free_space_cache(block_group);
+
 	down_write(&block_group->space_info->groups_sem);
 	/*
 	 * we must use list_del_init so people can check to see if they
@@ -6965,6 +7202,12 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	list_del_init(&block_group->list);
 	up_write(&block_group->space_info->groups_sem);
 
+	if (block_group->cached == BTRFS_CACHE_STARTED)
+		wait_event(block_group->caching_q,
+			   block_group_cache_done(block_group));
+
+	btrfs_remove_free_space_cache(block_group);
+
 	spin_lock(&block_group->space_info->lock);
 	block_group->space_info->total_bytes -= block_group->key.offset;
 	block_group->space_info->bytes_readonly -= block_group->key.offset;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e40b373..741067b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -225,6 +225,7 @@ static void unlink_free_space(struct btrfs_block_group_cache *block_group,
 {
 	rb_erase(&info->offset_index, &block_group->free_space_offset);
 	block_group->free_extents--;
+	block_group->free_space -= info->bytes;
 }
 
 static int link_free_space(struct btrfs_block_group_cache *block_group,
@@ -238,6 +239,7 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 	if (ret)
 		return ret;
 
+	block_group->free_space += info->bytes;
 	block_group->free_extents++;
 	return ret;
 }
@@ -272,36 +274,40 @@ static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
 	}
 }
 
-static void bitmap_clear_bits(struct btrfs_free_space *info, u64 offset, u64 bytes,
-			      u64 sectorsize)
+static void bitmap_clear_bits(struct btrfs_block_group_cache *block_group,
+			      struct btrfs_free_space *info, u64 offset,
+			      u64 bytes)
 {
 	unsigned long start, end;
 	unsigned long i;
 
-	start = offset_to_bit(info->offset, sectorsize, offset);
-	end = start + bytes_to_bits(bytes, sectorsize);
+	start = offset_to_bit(info->offset, block_group->sectorsize, offset);
+	end = start + bytes_to_bits(bytes, block_group->sectorsize);
 	BUG_ON(end > BITS_PER_BITMAP);
 
 	for (i = start; i < end; i++)
 		clear_bit(i, info->bitmap);
 
 	info->bytes -= bytes;
+	block_group->free_space -= bytes;
 }
 
-static void bitmap_set_bits(struct btrfs_free_space *info, u64 offset, u64 bytes,
-			    u64 sectorsize)
+static void bitmap_set_bits(struct btrfs_block_group_cache *block_group,
+			    struct btrfs_free_space *info, u64 offset,
+			    u64 bytes)
 {
 	unsigned long start, end;
 	unsigned long i;
 
-	start = offset_to_bit(info->offset, sectorsize, offset);
-	end = start + bytes_to_bits(bytes, sectorsize);
+	start = offset_to_bit(info->offset, block_group->sectorsize, offset);
+	end = start + bytes_to_bits(bytes, block_group->sectorsize);
 	BUG_ON(end > BITS_PER_BITMAP);
 
 	for (i = start; i < end; i++)
 		set_bit(i, info->bitmap);
 
 	info->bytes += bytes;
+	block_group->free_space += bytes;
 }
 
 static int search_bitmap(struct btrfs_block_group_cache *block_group,
@@ -401,13 +407,12 @@ again:
 		(u64)(BITS_PER_BITMAP * block_group->sectorsize) - 1;
 
 	if (*offset > bitmap_info->offset && *offset + *bytes > end) {
-		bitmap_clear_bits(bitmap_info, *offset,
-				  end - *offset + 1, block_group->sectorsize);
+		bitmap_clear_bits(block_group, bitmap_info, *offset,
+				  end - *offset + 1);
 		*bytes -= end - *offset + 1;
 		*offset = end + 1;
 	} else if (*offset >= bitmap_info->offset && *offset + *bytes <= end) {
-		bitmap_clear_bits(bitmap_info, *offset,
-				  *bytes, block_group->sectorsize);
+		bitmap_clear_bits(block_group, bitmap_info, *offset, *bytes);
 		*bytes = 0;
 	}
 
@@ -482,14 +487,13 @@ again:
 		(u64)(BITS_PER_BITMAP * block_group->sectorsize);
 
 	if (offset >= bitmap_info->offset && offset + bytes > end) {
-		bitmap_set_bits(bitmap_info, offset, end - offset,
-				block_group->sectorsize);
+		bitmap_set_bits(block_group, bitmap_info, offset,
+				end - offset);
 		bytes -= end - offset;
 		offset = end;
 		added = 0;
 	} else if (offset >= bitmap_info->offset && offset + bytes <= end) {
-		bitmap_set_bits(bitmap_info, offset, bytes,
-				block_group->sectorsize);
+		bitmap_set_bits(block_group, bitmap_info, offset, bytes);
 		bytes = 0;
 	} else {
 		BUG();
@@ -857,8 +861,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 
 	ret = offset;
 	if (entry->bitmap) {
-		bitmap_clear_bits(entry, offset, bytes,
-				  block_group->sectorsize);
+		bitmap_clear_bits(block_group, entry, offset, bytes);
 		if (!entry->bytes) {
 			unlink_free_space(block_group, entry);
 			kfree(entry->bitmap);
@@ -878,6 +881,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 
 out:
 	spin_unlock(&block_group->tree_lock);
+
 	return ret;
 }
 
@@ -954,7 +958,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 		goto out;
 
 	ret = search_start;
-	bitmap_clear_bits(entry, ret, bytes, block_group->sectorsize);
+	bitmap_clear_bits(block_group, entry, ret, bytes);
 out:
 	spin_unlock(&block_group->tree_lock);
 	spin_unlock(&cluster->lock);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4e83457..7fd6a9d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -40,6 +40,14 @@ static noinline void put_transaction(struct btrfs_transaction *transaction)
 	}
 }
 
+static noinline void switch_commit_root(struct btrfs_root *root)
+{
+	down_write(&root->commit_root_sem);
+	free_extent_buffer(root->commit_root);
+	root->commit_root = btrfs_root_node(root);
+	up_write(&root->commit_root_sem);
+}
+
 /*
  * either allocate a new transaction or hop into the existing one
  */
@@ -462,8 +470,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 		BUG_ON(ret);
 	}
-	free_extent_buffer(root->commit_root);
-	root->commit_root = btrfs_root_node(root);
+	switch_commit_root(root);
 	return 0;
 }
 
@@ -544,8 +551,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			btrfs_update_reloc_root(trans, root);
 
 			if (root->commit_root != root->node) {
-				free_extent_buffer(root->commit_root);
-				root->commit_root = btrfs_root_node(root);
+				switch_commit_root(root);
 				btrfs_set_root_node(&root->root_item,
 						    root->node);
 			}
@@ -1007,15 +1013,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_set_root_node(&root->fs_info->tree_root->root_item,
 			    root->fs_info->tree_root->node);
-	free_extent_buffer(root->fs_info->tree_root->commit_root);
-	root->fs_info->tree_root->commit_root =
-				btrfs_root_node(root->fs_info->tree_root);
+	switch_commit_root(root->fs_info->tree_root);
 
 	btrfs_set_root_node(&root->fs_info->chunk_root->root_item,
 			    root->fs_info->chunk_root->node);
-	free_extent_buffer(root->fs_info->chunk_root->commit_root);
-	root->fs_info->chunk_root->commit_root =
-				btrfs_root_node(root->fs_info->chunk_root);
+	switch_commit_root(root->fs_info->chunk_root);
 
 	update_super_roots(root);
 
@@ -1055,6 +1057,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	cur_trans->commit_done = 1;
 
 	root->fs_info->last_trans_committed = cur_trans->transid;
+
 	wake_up(&cur_trans->commit_wait);
 
 	put_transaction(cur_trans);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c139222..1956068 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -264,7 +264,7 @@ static int process_one_buffer(struct btrfs_root *log,
 {
 	if (wc->pin)
 		btrfs_update_pinned_extents(log->fs_info->extent_root,
-					    eb->start, eb->len, 1);
+					    eb->start, eb->len, 1, 0);
 
 	if (btrfs_buffer_uptodate(eb, gen)) {
 		if (wc->write)
-- 
1.5.4.3

