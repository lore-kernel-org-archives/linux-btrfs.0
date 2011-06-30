From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use a worker thread to do caching
Date: Thu, 30 Jun 2011 16:03:48 -0400
Message-ID: <1309464228-20566-1-git-send-email-josef@redhat.com>
Cc: rm@romanrm.ru
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a deadlock when copying a bunch of files.  This is because they
were low on memory and kthreadd got hung up trying to migrate pages for an
allocation when starting the caching kthread.  The page was locked by the person
starting the caching kthread.  To fix this we just need to use the async thread
stuff so that the threads are already created and we don't have to worry about
deadlocks.  Thanks,

Reported-by: Roman Mamedov <rm@romanrm.ru>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    4 +++-
 fs/btrfs/disk-io.c     |    6 ++++++
 fs/btrfs/extent-tree.c |   47 +++++++++++++++++++----------------------------
 3 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ae9560a..c01b9d7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -766,7 +766,6 @@ struct btrfs_space_info {
 	struct list_head block_groups[BTRFS_NR_RAID_TYPES];
 	spinlock_t lock;
 	struct rw_semaphore groups_sem;
-	atomic_t caching_threads;
 	wait_queue_head_t wait;
 };
 
@@ -827,6 +826,7 @@ struct btrfs_caching_control {
 	struct list_head list;
 	struct mutex mutex;
 	wait_queue_head_t wait;
+	struct btrfs_work work;
 	struct btrfs_block_group_cache *block_group;
 	u64 progress;
 	atomic_t count;
@@ -1035,6 +1035,8 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers endio_freespace_worker;
 	struct btrfs_workers submit_workers;
+	struct btrfs_workers caching_workers;
+
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ac8db5d..234a084 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1807,6 +1807,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			   fs_info->thread_pool_size),
 			   &fs_info->generic_worker);
 
+	btrfs_init_workers(&fs_info->caching_workers, "cache",
+			   2, &fs_info->generic_worker);
+
 	/* a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
 	 * devices
@@ -1860,6 +1863,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	btrfs_start_workers(&fs_info->endio_write_workers, 1);
 	btrfs_start_workers(&fs_info->endio_freespace_worker, 1);
 	btrfs_start_workers(&fs_info->delayed_workers, 1);
+	btrfs_start_workers(&fs_info->caching_workers, 1);
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
@@ -2117,6 +2121,7 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
+	btrfs_stop_workers(&fs_info->caching_workers);
 fail_alloc:
 	kfree(fs_info->delayed_root);
 fail_iput:
@@ -2584,6 +2589,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
+	btrfs_stop_workers(&fs_info->caching_workers);
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 340c147..3e52b85 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -320,12 +320,12 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	return total_added;
 }
 
-static int caching_kthread(void *data)
+static noinline void caching_thread(struct btrfs_work *work)
 {
-	struct btrfs_block_group_cache *block_group = data;
-	struct btrfs_fs_info *fs_info = block_group->fs_info;
-	struct btrfs_caching_control *caching_ctl = block_group->caching_ctl;
-	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_block_group_cache *block_group;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_caching_control *caching_ctl;
+	struct btrfs_root *extent_root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
@@ -334,9 +334,14 @@ static int caching_kthread(void *data)
 	u32 nritems;
 	int ret = 0;
 
+	caching_ctl = container_of(work, struct btrfs_caching_control, work);
+	block_group = caching_ctl->block_group;
+	fs_info = block_group->fs_info;
+	extent_root = fs_info->extent_root;
+
 	path = btrfs_alloc_path();
 	if (!path)
-		return -ENOMEM;
+		goto out;
 
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 
@@ -433,13 +438,11 @@ err:
 	free_excluded_extents(extent_root, block_group);
 
 	mutex_unlock(&caching_ctl->mutex);
+out:
 	wake_up(&caching_ctl->wait);
 
 	put_caching_control(caching_ctl);
-	atomic_dec(&block_group->space_info->caching_threads);
 	btrfs_put_block_group(block_group);
-
-	return 0;
 }
 
 static int cache_block_group(struct btrfs_block_group_cache *cache,
@@ -449,7 +452,6 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
 	struct btrfs_caching_control *caching_ctl;
-	struct task_struct *tsk;
 	int ret = 0;
 
 	smp_mb();
@@ -501,6 +503,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	caching_ctl->progress = cache->key.objectid;
 	/* one for caching kthread, one for caching block group list */
 	atomic_set(&caching_ctl->count, 2);
+	caching_ctl->work.func = caching_thread;
 
 	spin_lock(&cache->lock);
 	if (cache->cached != BTRFS_CACHE_NO) {
@@ -516,16 +519,10 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	list_add_tail(&caching_ctl->list, &fs_info->caching_block_groups);
 	up_write(&fs_info->extent_commit_sem);
 
-	atomic_inc(&cache->space_info->caching_threads);
 	btrfs_get_block_group(cache);
 
-	tsk = kthread_run(caching_kthread, cache, "btrfs-cache-%llu\n",
-			  cache->key.objectid);
-	if (IS_ERR(tsk)) {
-		ret = PTR_ERR(tsk);
-		printk(KERN_ERR "error running thread %d\n", ret);
-		BUG();
-	}
+	btrfs_queue_worker(&root->fs_info->caching_workers,
+			   &caching_ctl->work);
 
 	return ret;
 }
@@ -2936,7 +2933,6 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	init_waitqueue_head(&found->wait);
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
-	atomic_set(&found->caching_threads, 0);
 	return 0;
 }
 
@@ -4997,14 +4993,10 @@ have_block_group:
 			}
 
 			/*
-			 * We only want to start kthread caching if we are at
-			 * the point where we will wait for caching to make
-			 * progress, or if our ideal search is over and we've
-			 * found somebody to start caching.
+			 * The caching workers are limited to 2 threads, so we
+			 * can queue as much work as we care to.
 			 */
-			if (loop > LOOP_CACHING_NOWAIT ||
-			    (loop > LOOP_FIND_IDEAL &&
-			     atomic_read(&space_info->caching_threads) < 2)) {
+			if (loop > LOOP_FIND_IDEAL) {
 				ret = cache_block_group(block_group, trans,
 							orig_root, 0);
 				BUG_ON(ret);
@@ -5226,8 +5218,7 @@ loop:
 		if (loop == LOOP_FIND_IDEAL && found_uncached_bg) {
 			found_uncached_bg = false;
 			loop++;
-			if (!ideal_cache_percent &&
-			    atomic_read(&space_info->caching_threads))
+			if (!ideal_cache_percent)
 				goto search;
 
 			/*
-- 
1.7.5.2

