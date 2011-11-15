From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: wait on caching if we're loading the free space cache
Date: Tue, 15 Nov 2011 14:55:44 -0500
Message-ID: <1321386944-2540-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We've been hitting panics when running xfstest 13 in a loop for long periods of
time.  And actually this problem has always existed so we've been hitting these
things randomly for a while.  Basically what happens is we get a thread coming
into the allocator and reading the space cache off of disk and adding the
entries to the free space cache as we go.  Then we get another thread that comes
in and tries to allocate from that block group.  Since block_group->cached !=
BTRFS_CACHE_NO it goes ahead and tries to do the allocation.  We do this because
if we're doing the old slow way of caching we don't want to hold people up and
wait for everything to finish.  The problem with this is we could end up
discarding the space cache at some arbitrary point in the future, which means we
could very well end up allocating space that is either bad, or when the real
caching happens it could end up thinking the space isn't in use when it really
is and cause all sorts of other problems.

The solution is to add a new flag to indicate we are loading the free space
cache from disk, and always try to cache the block group if cache->cached !=
BTRFS_CACHE_FINISHED.  That way if we are loading the space cache anybody else
who tries to allocate from the block group will have to wait until it's finished
to make sure it completes successfully.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 +-
 fs/btrfs/extent-tree.c |  121 ++++++++++++++++++++++++++++++++----------------
 2 files changed, 83 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b9ba59f..60c813c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -848,7 +848,8 @@ struct btrfs_free_cluster {
 enum btrfs_caching_type {
 	BTRFS_CACHE_NO		= 0,
 	BTRFS_CACHE_STARTED	= 1,
-	BTRFS_CACHE_FINISHED	= 2,
+	BTRFS_CACHE_FAST	= 2,
+	BTRFS_CACHE_FINISHED	= 3,
 };
 
 enum btrfs_disk_cache_state {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fa4f602..8a60f22 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -462,6 +462,12 @@ out:
 	btrfs_put_block_group(block_group);
 }
 
+static int block_group_caching_fast(struct btrfs_block_group_cache *cache)
+{
+	smp_mb();
+	return cache->cached == BTRFS_CACHE_FAST;
+}
+
 static int cache_block_group(struct btrfs_block_group_cache *cache,
 			     struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
@@ -471,9 +477,52 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	struct btrfs_caching_control *caching_ctl;
 	int ret = 0;
 
-	smp_mb();
-	if (cache->cached != BTRFS_CACHE_NO)
+again:
+	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_NOFS);
+	BUG_ON(!caching_ctl);
+
+	INIT_LIST_HEAD(&caching_ctl->list);
+	mutex_init(&caching_ctl->mutex);
+	init_waitqueue_head(&caching_ctl->wait);
+	caching_ctl->block_group = cache;
+	caching_ctl->progress = cache->key.objectid;
+	/* one for caching kthread, one for caching block group list */
+	atomic_set(&caching_ctl->count, 2);
+	caching_ctl->work.func = caching_thread;
+
+	spin_lock(&cache->lock);
+	/*
+	 * This should be a rare occasion, but this could happen I think in the
+	 * case where one thread starts to load the space cache info, and then
+	 * some other thread starts a transaction commit which tries to do an
+	 * allocation while the other thread is still loading the space cache
+	 * info.  The previous loop should have kept us from choosing this block
+	 * group, but if we've moved to the state where we will wait on caching
+	 * block groups we need to first check if we're doing a fast load here,
+	 * so we can wait for it to finish, otherwise we could end up allocating
+	 * from a block group who's cache gets evicted for one reason or
+	 * another.
+	 */
+	if (cache->cached == BTRFS_CACHE_FAST) {
+		kfree(caching_ctl);
+		caching_ctl = cache->caching_ctl;
+		atomic_inc(&caching_ctl->count);
+		spin_unlock(&cache->lock);
+		wait_event(caching_ctl->wait,
+			   !block_group_caching_fast(cache));
+		put_caching_control(caching_ctl);
+		goto again;
+	}
+
+	if (cache->cached != BTRFS_CACHE_NO) {
+		spin_unlock(&cache->lock);
+		kfree(caching_ctl);
 		return 0;
+	}
+	WARN_ON(cache->caching_ctl);
+	cache->caching_ctl = caching_ctl;
+	cache->cached = BTRFS_CACHE_FAST;
+	spin_unlock(&cache->lock);
 
 	/*
 	 * We can't do the read from on-disk cache during a commit since we need
@@ -484,54 +533,48 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	if (trans && (!trans->transaction->in_commit) &&
 	    (root && root != root->fs_info->tree_root) &&
 	    btrfs_test_opt(root, SPACE_CACHE)) {
-		spin_lock(&cache->lock);
-		if (cache->cached != BTRFS_CACHE_NO) {
-			spin_unlock(&cache->lock);
-			return 0;
-		}
-		cache->cached = BTRFS_CACHE_STARTED;
-		spin_unlock(&cache->lock);
-
 		ret = load_free_space_cache(fs_info, cache);
 
 		spin_lock(&cache->lock);
 		if (ret == 1) {
+			cache->caching_ctl = NULL;
 			cache->cached = BTRFS_CACHE_FINISHED;
 			cache->last_byte_to_unpin = (u64)-1;
 		} else {
-			cache->cached = BTRFS_CACHE_NO;
+			if (load_cache_only) {
+				cache->caching_ctl = NULL;
+				cache->cached = BTRFS_CACHE_NO;
+			} else {
+				cache->cached = BTRFS_CACHE_STARTED;
+			}
 		}
 		spin_unlock(&cache->lock);
+		wake_up(&caching_ctl->wait);
 		if (ret == 1) {
+			put_caching_control(caching_ctl);
 			free_excluded_extents(fs_info->extent_root, cache);
 			return 0;
 		}
+	} else {
+		/*
+		 * We are not going to do the fast caching, set cached to the
+		 * appropriate value and wakeup any waiters.
+		 */
+		spin_lock(&cache->lock);
+		if (load_cache_only) {
+			cache->caching_ctl = NULL;
+			cache->cached = BTRFS_CACHE_NO;
+		} else {
+			cache->cached = BTRFS_CACHE_STARTED;
+		}
+		spin_unlock(&cache->lock);
+		wake_up(&caching_ctl->wait);
 	}
 
-	if (load_cache_only)
-		return 0;
-
-	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_NOFS);
-	BUG_ON(!caching_ctl);
-
-	INIT_LIST_HEAD(&caching_ctl->list);
-	mutex_init(&caching_ctl->mutex);
-	init_waitqueue_head(&caching_ctl->wait);
-	caching_ctl->block_group = cache;
-	caching_ctl->progress = cache->key.objectid;
-	/* one for caching kthread, one for caching block group list */
-	atomic_set(&caching_ctl->count, 2);
-	caching_ctl->work.func = caching_thread;
-
-	spin_lock(&cache->lock);
-	if (cache->cached != BTRFS_CACHE_NO) {
-		spin_unlock(&cache->lock);
-		kfree(caching_ctl);
+	if (load_cache_only) {
+		put_caching_control(caching_ctl);
 		return 0;
 	}
-	cache->caching_ctl = caching_ctl;
-	cache->cached = BTRFS_CACHE_STARTED;
-	spin_unlock(&cache->lock);
 
 	down_write(&fs_info->extent_commit_sem);
 	list_add_tail(&caching_ctl->list, &fs_info->caching_block_groups);
@@ -5179,13 +5222,15 @@ search:
 		}
 
 have_block_group:
-		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
+		cached = block_group_cache_done(block_group);
+		if (unlikely(!cached)) {
 			u64 free_percent;
 
+			found_uncached_bg = true;
 			ret = cache_block_group(block_group, trans,
 						orig_root, 1);
 			if (block_group->cached == BTRFS_CACHE_FINISHED)
-				goto have_block_group;
+				goto alloc;
 
 			free_percent = btrfs_block_group_used(&block_group->item);
 			free_percent *= 100;
@@ -5207,7 +5252,6 @@ have_block_group:
 							orig_root, 0);
 				BUG_ON(ret);
 			}
-			found_uncached_bg = true;
 
 			/*
 			 * If loop is set for cached only, try the next block
@@ -5217,10 +5261,7 @@ have_block_group:
 				goto loop;
 		}
 
-		cached = block_group_cache_done(block_group);
-		if (unlikely(!cached))
-			found_uncached_bg = true;
-
+alloc:
 		if (unlikely(block_group->ro))
 			goto loop;
 
-- 
1.7.5.2

