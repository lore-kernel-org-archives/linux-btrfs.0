From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] btrfs: change how we unpin extents
Date: Mon, 27 Jul 2009 12:28:25 -0400
Message-ID: <20090727162823.GA2229@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zheng.yan@oracle.com, chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We are racy with async block caching and unpinning extents.  This patch makes
things much less complicated by only unpinning the extent if the block group is
cached.  We check the block_group->cached var under the block_group->lock spin
lock.  If it is set to BTRFS_CACHE_FINISHED then we update the pinned counters,
and unpin the extent and add the free space back.  If it is not set to this, we
start the caching of the block group so the next time we unpin extents we can
unpin the extent.  This keeps us from racing with the async caching threads,
lets us kill the fs wide async thread counter, and keeps us from having to set
DELALLOC bits for every extent we hit if there are caching kthreads going.

One thing that needed to be changed was btrfs_free_super_mirror_extents.  Now
instead of just looking for LOCKED extents, we also look for DIRTY extents,
since we could have left some extents pinned in the previous transaction that
will never get freed now that we are unmounting, which would cause us to leak
memory.  So btrfs_free_super_mirror_extents has been changed to
btrfs_free_pinned_extents, and it will clear the extents locked for the super
mirror, and any remaining pinned extents that may be present.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    5 +-
 fs/btrfs/disk-io.c     |    3 +-
 fs/btrfs/extent-tree.c |  149 ++++++++++++++----------------------------------
 fs/btrfs/tree-log.c    |    2 +-
 4 files changed, 46 insertions(+), 113 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 85c7080..d8d925c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -845,7 +845,6 @@ struct btrfs_fs_info {
 	atomic_t async_submit_draining;
 	atomic_t nr_async_bios;
 	atomic_t async_delalloc_pages;
-	atomic_t async_caching_threads;
 
 	/*
 	 * this is used by the balancing code to wait for all the pending
@@ -1926,7 +1925,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_update_pinned_extents(struct btrfs_root *root,
-				u64 bytenr, u64 num, int pin, int mark_free);
+				u64 bytenr, u64 num, int pin);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct extent_buffer *leaf);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
@@ -2011,7 +2010,7 @@ void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
-void btrfs_free_super_mirror_extents(struct btrfs_fs_info *info);
+void btrfs_free_pinned_extents(struct btrfs_fs_info *info);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 405555a..af858eb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1567,7 +1567,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->async_delalloc_pages, 0);
 	atomic_set(&fs_info->async_submit_draining, 0);
 	atomic_set(&fs_info->nr_async_bios, 0);
-	atomic_set(&fs_info->async_caching_threads, 0);
 	fs_info->sb = sb;
 	fs_info->max_extent = (u64)-1;
 	fs_info->max_inline = 8192 * 1024;
@@ -2329,7 +2328,7 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(root->fs_info->csum_root->commit_root);
 
 	btrfs_free_block_groups(root->fs_info);
-	btrfs_free_super_mirror_extents(root->fs_info);
+	btrfs_free_pinned_extents(root->fs_info);
 
 	del_fs_roots(fs_info);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 52e5c64..2c3ba33 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -153,18 +153,26 @@ block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
 	return ret;
 }
 
-void btrfs_free_super_mirror_extents(struct btrfs_fs_info *info)
+/*
+ * We always set EXTENT_LOCKED for the super mirror extents so we don't
+ * overwrite them, so those bits need to be unset.  Also, if we are unmounting
+ * with pinned extents still sitting there because we had a block group caching,
+ * we need to clear those now, since we are done.
+ */
+void btrfs_free_pinned_extents(struct btrfs_fs_info *info)
 {
 	u64 start, end, last = 0;
 	int ret;
 
 	while (1) {
 		ret = find_first_extent_bit(&info->pinned_extents, last,
-					    &start, &end, EXTENT_LOCKED);
+					    &start, &end,
+					    EXTENT_LOCKED|EXTENT_DIRTY);
 		if (ret)
 			break;
 
-		unlock_extent(&info->pinned_extents, start, end, GFP_NOFS);
+		clear_extent_bits(&info->pinned_extents, start, end,
+				  EXTENT_LOCKED|EXTENT_DIRTY, GFP_NOFS);
 		last = end+1;
 	}
 }
@@ -209,8 +217,7 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	while (start < end) {
 		ret = find_first_extent_bit(&info->pinned_extents, start,
 					    &extent_start, &extent_end,
-					    EXTENT_DIRTY|EXTENT_LOCKED|
-					    EXTENT_DELALLOC);
+					    EXTENT_DIRTY|EXTENT_LOCKED);
 		if (ret)
 			break;
 
@@ -238,67 +245,6 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	return total_added;
 }
 
-DEFINE_MUTEX(discard_mutex);
-
-/*
- * if async kthreads are running when we cross transactions, we mark any pinned
- * extents with EXTENT_DELALLOC and then let the caching kthreads clean up those
- * extents when they are done.  Also we run this from btrfs_finish_extent_commit
- * in case there were some pinned extents that were missed because we had
- * already cached that block group.
- */
-static void btrfs_discard_pinned_extents(struct btrfs_fs_info *fs_info,
-					 struct btrfs_block_group_cache *cache)
-{
-	u64 start, end, last;
-	int ret;
-
-	if (!cache)
-		last = 0;
-	else
-		last = cache->key.objectid;
-
-	mutex_lock(&discard_mutex);
-	while (1) {
-		ret = find_first_extent_bit(&fs_info->pinned_extents, last,
-					    &start, &end, EXTENT_DELALLOC);
-		if (ret)
-			break;
-
-		if (cache && start >= cache->key.objectid + cache->key.offset)
-			break;
-
-
-		if (!cache) {
-			cache = btrfs_lookup_block_group(fs_info, start);
-			BUG_ON(!cache);
-
-			start = max(start, cache->key.objectid);
-			end = min(end, cache->key.objectid + cache->key.offset - 1);
-
-			if (block_group_cache_done(cache))
-				btrfs_add_free_space(cache, start,
-						     end - start + 1);
-			cache = NULL;
-		} else {
-			start = max(start, cache->key.objectid);
-			end = min(end, cache->key.objectid + cache->key.offset - 1);
-			btrfs_add_free_space(cache, start, end - start + 1);
-		}
-
-		clear_extent_bits(&fs_info->pinned_extents, start, end,
-				  EXTENT_DELALLOC, GFP_NOFS);
-		last = end + 1;
-
-		if (need_resched()) {
-			mutex_unlock(&discard_mutex);
-			cond_resched();
-			mutex_lock(&discard_mutex);
-		}
-	}
-	mutex_unlock(&discard_mutex);
-}
-
 static int caching_kthread(void *data)
 {
 	struct btrfs_block_group_cache *block_group = data;
@@ -317,7 +263,6 @@ static int caching_kthread(void *data)
 	if (!path)
 		return -ENOMEM;
 
-	atomic_inc(&fs_info->async_caching_threads);
 	atomic_inc(&block_group->space_info->caching_threads);
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 again:
@@ -399,13 +344,9 @@ next:
 err:
 	btrfs_free_path(path);
 	up_read(&fs_info->extent_root->commit_root_sem);
-	atomic_dec(&fs_info->async_caching_threads);
 	atomic_dec(&block_group->space_info->caching_threads);
 	wake_up(&block_group->caching_q);
 
-	if (!ret)
-		btrfs_discard_pinned_extents(fs_info, block_group);
-
 	return 0;
 }
 
@@ -1868,7 +1809,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 				BUG_ON(ret);
 			}
 			btrfs_update_pinned_extents(root, node->bytenr,
-						    node->num_bytes, 1, 0);
+						    node->num_bytes, 1);
 			update_reserved_extents(root, node->bytenr,
 						node->num_bytes, 0);
 		}
@@ -3089,19 +3030,15 @@ static u64 first_logical_byte(struct btrfs_root *root, u64 search_start)
 }
 
 int btrfs_update_pinned_extents(struct btrfs_root *root,
-				u64 bytenr, u64 num, int pin, int mark_free)
+				u64 bytenr, u64 num, int pin)
 {
 	u64 len;
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	if (pin) {
+	if (pin)
 		set_extent_dirty(&fs_info->pinned_extents,
 				bytenr, bytenr + num - 1, GFP_NOFS);
-	} else {
-		clear_extent_dirty(&fs_info->pinned_extents,
-				bytenr, bytenr + num - 1, GFP_NOFS);
-	}
 
 	while (num > 0) {
 		cache = btrfs_lookup_block_group(fs_info, bytenr);
@@ -3117,14 +3054,34 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 			spin_unlock(&cache->space_info->lock);
 			fs_info->total_pinned += len;
 		} else {
+			int unpin = 0;
+
+			/*
+			 * in order to not race with the block group caching, we
+			 * only want to unpin the extent if we are cached.  If
+			 * we aren't cached, we want to start async caching this
+			 * block group so we can free the extent the next time
+			 * around.
+			 */
 			spin_lock(&cache->space_info->lock);
 			spin_lock(&cache->lock);
-			cache->pinned -= len;
-			cache->space_info->bytes_pinned -= len;
+			unpin = (cache->cached == BTRFS_CACHE_FINISHED);
+			if (likely(unpin)) {
+				cache->pinned -= len;
+				cache->space_info->bytes_pinned -= len;
+				fs_info->total_pinned -= len;
+			}
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
-			fs_info->total_pinned -= len;
-			if (block_group_cache_done(cache) && mark_free)
+
+			if (likely(unpin))
+				clear_extent_dirty(&fs_info->pinned_extents,
+						   bytenr, bytenr + len -1,
+						   GFP_NOFS);
+			else
+				cache_block_group(cache);
+
+			if (unpin)
 				btrfs_add_free_space(cache, bytenr, len);
 		}
 		btrfs_put_block_group(cache);
@@ -3170,27 +3127,15 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 	u64 last = 0;
 	u64 start;
 	u64 end;
-	bool caching_kthreads = false;
 	struct extent_io_tree *pinned_extents = &root->fs_info->pinned_extents;
 	int ret;
 
-	if (atomic_read(&root->fs_info->async_caching_threads))
-		caching_kthreads = true;
-
 	while (1) {
 		ret = find_first_extent_bit(pinned_extents, last,
 					    &start, &end, EXTENT_DIRTY);
 		if (ret)
 			break;
 
-		/*
-		 * we need to make sure that the pinned extents don't go away
-		 * while we are caching block groups
-		 */
-		if (unlikely(caching_kthreads))
-			set_extent_delalloc(pinned_extents, start, end,
-					    GFP_NOFS);
-
 		set_extent_dirty(copy, start, end, GFP_NOFS);
 		last = end + 1;
 	}
@@ -3204,12 +3149,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	u64 start;
 	u64 end;
 	int ret;
-	int mark_free = 1;
-
-	ret = find_first_extent_bit(&root->fs_info->pinned_extents, 0,
-				    &start, &end, EXTENT_DELALLOC);
-	if (!ret)
-		mark_free = 0;
 
 	while (1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
@@ -3220,16 +3159,12 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 		ret = btrfs_discard_extent(root, start, end + 1 - start);
 
 		/* unlocks the pinned mutex */
-		btrfs_update_pinned_extents(root, start, end + 1 - start, 0,
-					    mark_free);
+		btrfs_update_pinned_extents(root, start, end + 1 - start, 0);
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
 
 		cond_resched();
 	}
 
-	if (unlikely(!mark_free))
-		btrfs_discard_pinned_extents(root->fs_info, NULL);
-
 	return ret;
 }
 
@@ -3270,7 +3205,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 pinit:
 	btrfs_set_path_blocking(path);
 	/* unlocks the pinned mutex */
-	btrfs_update_pinned_extents(root, bytenr, num_bytes, 1, 0);
+	btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
 
 	BUG_ON(err < 0);
 	return 0;
@@ -3581,7 +3516,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
 		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
 		/* unlocks the pinned mutex */
-		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1, 0);
+		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
 		update_reserved_extents(root, bytenr, num_bytes, 0);
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1956068..c139222 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -264,7 +264,7 @@ static int process_one_buffer(struct btrfs_root *log,
 {
 	if (wc->pin)
 		btrfs_update_pinned_extents(log->fs_info->extent_root,
-					    eb->start, eb->len, 1, 0);
+					    eb->start, eb->len, 1);
 
 	if (btrfs_buffer_uptodate(eb, gen)) {
 		if (wc->write)
-- 
1.5.4.3

