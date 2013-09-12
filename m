Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39699 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab3ILIHw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 04:07:52 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8C87c4U015390
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 16:07:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v2 2/9] btrfs: use kernel workqueue to replace the btrfs_workers functions
Date: Thu, 12 Sep 2013 16:08:17 +0800
Message-Id: <1378973304-11693-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the kernel workqueue to replace the btrfs_workers which are only
used as normal workqueue.

Other btrfs_workers will use some extra functions like requeue, high
priority and ordered work.
These btrfs_workers will not be touched in this patch.

The followings are the untouched btrfs_workers:

generic_worker:		As the helper for other btrfs_workers
workers:		Use the ordering and high priority features
delalloc_workers: 	Use the ordering feature
submit_workers:		Use requeue feature

All other workers can be replaced using the kernel workqueue directly.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h         |  39 +++++------
 fs/btrfs/delayed-inode.c |   9 ++-
 fs/btrfs/disk-io.c       | 164 ++++++++++++++++++-----------------------------
 fs/btrfs/extent-tree.c   |   6 +-
 fs/btrfs/inode.c         |  38 +++++------
 fs/btrfs/ordered-data.c  |  11 ++--
 fs/btrfs/ordered-data.h  |   4 +-
 fs/btrfs/qgroup.c        |  16 ++---
 fs/btrfs/raid56.c        |  37 +++++------
 fs/btrfs/reada.c         |   8 +--
 fs/btrfs/scrub.c         |  84 ++++++++++++------------
 fs/btrfs/super.c         |  23 ++++---
 12 files changed, 196 insertions(+), 243 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..0dd6ec9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1202,7 +1202,7 @@ struct btrfs_caching_control {
 	struct list_head list;
 	struct mutex mutex;
 	wait_queue_head_t wait;
-	struct btrfs_work work;
+	struct work_struct work;
 	struct btrfs_block_group_cache *block_group;
 	u64 progress;
 	atomic_t count;
@@ -1479,25 +1479,26 @@ struct btrfs_fs_info {
 	struct btrfs_workers generic_worker;
 	struct btrfs_workers workers;
 	struct btrfs_workers delalloc_workers;
-	struct btrfs_workers flush_workers;
-	struct btrfs_workers endio_workers;
-	struct btrfs_workers endio_meta_workers;
-	struct btrfs_workers endio_raid56_workers;
-	struct btrfs_workers rmw_workers;
-	struct btrfs_workers endio_meta_write_workers;
-	struct btrfs_workers endio_write_workers;
-	struct btrfs_workers endio_freespace_worker;
 	struct btrfs_workers submit_workers;
-	struct btrfs_workers caching_workers;
-	struct btrfs_workers readahead_workers;
+
+	struct workqueue_struct *flush_workers;
+	struct workqueue_struct *endio_workers;
+	struct workqueue_struct *endio_meta_workers;
+	struct workqueue_struct *endio_raid56_workers;
+	struct workqueue_struct *rmw_workers;
+	struct workqueue_struct *endio_meta_write_workers;
+	struct workqueue_struct *endio_write_workers;
+	struct workqueue_struct *endio_freespace_worker;
+	struct workqueue_struct *caching_workers;
+	struct workqueue_struct *readahead_workers;
 
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
 	 * the cow mechanism and make them safe to write.  It happens
 	 * for the sys_munmap function call path
 	 */
-	struct btrfs_workers fixup_workers;
-	struct btrfs_workers delayed_workers;
+	struct workqueue_struct *fixup_workers;
+	struct workqueue_struct *delayed_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
@@ -1576,9 +1577,9 @@ struct btrfs_fs_info {
 	wait_queue_head_t scrub_pause_wait;
 	struct rw_semaphore scrub_super_lock;
 	int scrub_workers_refcnt;
-	struct btrfs_workers scrub_workers;
-	struct btrfs_workers scrub_wr_completion_workers;
-	struct btrfs_workers scrub_nocow_workers;
+	struct workqueue_struct *scrub_workers;
+	struct workqueue_struct *scrub_wr_completion_workers;
+	struct workqueue_struct *scrub_nocow_workers;
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	u32 check_integrity_print_mask;
@@ -1619,9 +1620,9 @@ struct btrfs_fs_info {
 	/* qgroup rescan items */
 	struct mutex qgroup_rescan_lock; /* protects the progress item */
 	struct btrfs_key qgroup_rescan_progress;
-	struct btrfs_workers qgroup_rescan_workers;
+	struct workqueue_struct *qgroup_rescan_workers;
 	struct completion qgroup_rescan_completion;
-	struct btrfs_work qgroup_rescan_work;
+	struct work_struct qgroup_rescan_work;
 
 	/* filesystem state */
 	unsigned long fs_state;
@@ -3542,7 +3543,7 @@ struct btrfs_delalloc_work {
 	int delay_iput;
 	struct completion completion;
 	struct list_head list;
-	struct btrfs_work work;
+	struct work_struct work;
 };
 
 struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5615eac..2b8da0a7 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1258,10 +1258,10 @@ void btrfs_remove_delayed_node(struct inode *inode)
 struct btrfs_async_delayed_work {
 	struct btrfs_delayed_root *delayed_root;
 	int nr;
-	struct btrfs_work work;
+	struct work_struct work;
 };
 
-static void btrfs_async_run_delayed_root(struct btrfs_work *work)
+static void btrfs_async_run_delayed_root(struct work_struct *work)
 {
 	struct btrfs_async_delayed_work *async_work;
 	struct btrfs_delayed_root *delayed_root;
@@ -1359,11 +1359,10 @@ static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
 		return -ENOMEM;
 
 	async_work->delayed_root = delayed_root;
-	async_work->work.func = btrfs_async_run_delayed_root;
-	async_work->work.flags = 0;
+	INIT_WORK(&async_work->work, btrfs_async_run_delayed_root);
 	async_work->nr = nr;
 
-	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_work->work);
+	queue_work(root->fs_info->delayed_workers, &async_work->work);
 	return 0;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c2886c..d02a552 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -54,7 +54,7 @@
 #endif
 
 static struct extent_io_ops btree_extent_io_ops;
-static void end_workqueue_fn(struct btrfs_work *work);
+static void end_workqueue_fn(struct work_struct *work);
 static void free_fs_root(struct btrfs_root *root);
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
@@ -86,7 +86,7 @@ struct end_io_wq {
 	int error;
 	int metadata;
 	struct list_head list;
-	struct btrfs_work work;
+	struct work_struct work;
 };
 
 /*
@@ -692,31 +692,30 @@ static void end_workqueue_bio(struct bio *bio, int err)
 
 	fs_info = end_io_wq->info;
 	end_io_wq->error = err;
-	end_io_wq->work.func = end_workqueue_fn;
-	end_io_wq->work.flags = 0;
+	INIT_WORK(&end_io_wq->work, end_workqueue_fn);
 
 	if (bio->bi_rw & REQ_WRITE) {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA)
-			btrfs_queue_worker(&fs_info->endio_meta_write_workers,
-					   &end_io_wq->work);
+			queue_work(fs_info->endio_meta_write_workers,
+				   &end_io_wq->work);
 		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_FREE_SPACE)
-			btrfs_queue_worker(&fs_info->endio_freespace_worker,
-					   &end_io_wq->work);
+			queue_work(fs_info->endio_freespace_worker,
+				   &end_io_wq->work);
 		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
-			btrfs_queue_worker(&fs_info->endio_raid56_workers,
-					   &end_io_wq->work);
+			queue_work(fs_info->endio_raid56_workers,
+				   &end_io_wq->work);
 		else
-			btrfs_queue_worker(&fs_info->endio_write_workers,
-					   &end_io_wq->work);
+			queue_work(fs_info->endio_write_workers,
+				   &end_io_wq->work);
 	} else {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
-			btrfs_queue_worker(&fs_info->endio_raid56_workers,
+			queue_work(fs_info->endio_raid56_workers,
 					   &end_io_wq->work);
 		else if (end_io_wq->metadata)
-			btrfs_queue_worker(&fs_info->endio_meta_workers,
+			queue_work(fs_info->endio_meta_workers,
 					   &end_io_wq->work);
 		else
-			btrfs_queue_worker(&fs_info->endio_workers,
+			queue_work(fs_info->endio_workers,
 					   &end_io_wq->work);
 	}
 }
@@ -1662,7 +1661,7 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
  * called by the kthread helper functions to finally call the bio end_io
  * functions.  This is where read checksum verification actually happens
  */
-static void end_workqueue_fn(struct btrfs_work *work)
+static void end_workqueue_fn(struct work_struct *work)
 {
 	struct bio *bio;
 	struct end_io_wq *end_io_wq;
@@ -1987,22 +1986,22 @@ static noinline int next_root_backup(struct btrfs_fs_info *info,
 static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
 	btrfs_stop_workers(&fs_info->generic_worker);
-	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
 	btrfs_stop_workers(&fs_info->workers);
-	btrfs_stop_workers(&fs_info->endio_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_workers);
-	btrfs_stop_workers(&fs_info->endio_raid56_workers);
-	btrfs_stop_workers(&fs_info->rmw_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
-	btrfs_stop_workers(&fs_info->endio_write_workers);
-	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->delayed_workers);
-	btrfs_stop_workers(&fs_info->caching_workers);
-	btrfs_stop_workers(&fs_info->readahead_workers);
-	btrfs_stop_workers(&fs_info->flush_workers);
-	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
+	destroy_workqueue(fs_info->fixup_workers);
+	destroy_workqueue(fs_info->endio_workers);
+	destroy_workqueue(fs_info->endio_meta_workers);
+	destroy_workqueue(fs_info->endio_raid56_workers);
+	destroy_workqueue(fs_info->rmw_workers);
+	destroy_workqueue(fs_info->endio_meta_write_workers);
+	destroy_workqueue(fs_info->endio_write_workers);
+	destroy_workqueue(fs_info->endio_freespace_worker);
+	destroy_workqueue(fs_info->delayed_workers);
+	destroy_workqueue(fs_info->caching_workers);
+	destroy_workqueue(fs_info->readahead_workers);
+	destroy_workqueue(fs_info->flush_workers);
+	destroy_workqueue(fs_info->qgroup_rescan_workers);
 }
 
 /* helper to cleanup tree roots */
@@ -2099,6 +2098,8 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *quota_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
+	int max_active;
+	int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
@@ -2457,6 +2458,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	max_active = fs_info->thread_pool_size;
 	btrfs_init_workers(&fs_info->generic_worker,
 			   "genwork", 1, NULL);
 
@@ -2468,23 +2470,13 @@ int open_ctree(struct super_block *sb,
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
 
-	btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-
+	fs_info->flush_workers = alloc_workqueue("flush_delalloc", flags,
+						 max_active);
 	btrfs_init_workers(&fs_info->submit_workers, "submit",
 			   min_t(u64, fs_devices->num_devices,
 			   fs_info->thread_pool_size),
 			   &fs_info->generic_worker);
-
-	btrfs_init_workers(&fs_info->caching_workers, "cache",
-			   2, &fs_info->generic_worker);
-
-	/* a higher idle thresh on the submit workers makes it much more
-	 * likely that bios will be send down in a sane order to the
-	 * devices
-	 */
-	fs_info->submit_workers.idle_thresh = 64;
+	fs_info->caching_workers = alloc_workqueue("cache", flags, 2);
 
 	fs_info->workers.idle_thresh = 16;
 	fs_info->workers.ordered = 1;
@@ -2492,72 +2484,42 @@ int open_ctree(struct super_block *sb,
 	fs_info->delalloc_workers.idle_thresh = 2;
 	fs_info->delalloc_workers.ordered = 1;
 
-	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_workers, "endio",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_meta_workers, "endio-meta",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_meta_write_workers,
-			   "endio-meta-write", fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_raid56_workers,
-			   "endio-raid56", fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->rmw_workers,
-			   "rmw", fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_write_workers, "endio-write",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_freespace_worker, "freespace-write",
-			   1, &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
-			   &fs_info->generic_worker);
-
-	/*
-	 * endios are largely parallel and should have a very
-	 * low idle thresh
-	 */
-	fs_info->endio_workers.idle_thresh = 4;
-	fs_info->endio_meta_workers.idle_thresh = 4;
-	fs_info->endio_raid56_workers.idle_thresh = 4;
-	fs_info->rmw_workers.idle_thresh = 2;
-
-	fs_info->endio_write_workers.idle_thresh = 2;
-	fs_info->endio_meta_write_workers.idle_thresh = 2;
-	fs_info->readahead_workers.idle_thresh = 2;
-
+	fs_info->fixup_workers = alloc_workqueue("fixup", flags, 1);
+	fs_info->endio_workers = alloc_workqueue("endio", flags, max_active);
+	fs_info->endio_meta_workers = alloc_workqueue("endio-meta", flags,
+						      max_active);
+	fs_info->endio_meta_write_workers = alloc_workqueue("endio-meta-write",
+							    flags, max_active);
+	fs_info->endio_raid56_workers = alloc_workqueue("endio-raid56", flags,
+							max_active);
+	fs_info->rmw_workers = alloc_workqueue("rmw", flags, max_active);
+	fs_info->endio_write_workers = alloc_workqueue("endio-write", flags,
+						       max_active);
+	fs_info->endio_freespace_worker = alloc_workqueue("freespace-write",
+							  flags, 1);
+	fs_info->delayed_workers = alloc_workqueue("delayed_meta", flags,
+						   max_active);
+	fs_info->readahead_workers = alloc_workqueue("readahead", flags,
+						     max_active);
+	fs_info->qgroup_rescan_workers = alloc_workqueue("group-rescan",
+							 flags, 1);
 	/*
 	 * btrfs_start_workers can really only fail because of ENOMEM so just
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->workers);
 	ret |= btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->submit_workers);
 	ret |= btrfs_start_workers(&fs_info->delalloc_workers);
-	ret |= btrfs_start_workers(&fs_info->fixup_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
-	ret |= btrfs_start_workers(&fs_info->rmw_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_raid56_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_meta_write_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_write_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_freespace_worker);
-	ret |= btrfs_start_workers(&fs_info->delayed_workers);
-	ret |= btrfs_start_workers(&fs_info->caching_workers);
-	ret |= btrfs_start_workers(&fs_info->readahead_workers);
-	ret |= btrfs_start_workers(&fs_info->flush_workers);
-	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
-	if (ret) {
+	ret |= btrfs_start_workers(&fs_info->submit_workers);
+
+	if (ret || !(fs_info->flush_workers && fs_info->endio_workers &&
+		     fs_info->endio_meta_workers &&
+		     fs_info->endio_raid56_workers &&
+		     fs_info->rmw_workers && fs_info->qgroup_rescan_workers &&
+		     fs_info->endio_meta_write_workers &&
+		     fs_info->endio_write_workers &&
+		     fs_info->caching_workers && fs_info->readahead_workers &&
+		     fs_info->fixup_workers && fs_info->delayed_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..c8f67d9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -377,7 +377,7 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	return total_added;
 }
 
-static noinline void caching_thread(struct btrfs_work *work)
+static noinline void caching_thread(struct work_struct *work)
 {
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_fs_info *fs_info;
@@ -530,7 +530,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	caching_ctl->block_group = cache;
 	caching_ctl->progress = cache->key.objectid;
 	atomic_set(&caching_ctl->count, 1);
-	caching_ctl->work.func = caching_thread;
+	INIT_WORK(&caching_ctl->work, caching_thread);
 
 	spin_lock(&cache->lock);
 	/*
@@ -621,7 +621,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 
 	btrfs_get_block_group(cache);
 
-	btrfs_queue_worker(&fs_info->caching_workers, &caching_ctl->work);
+	queue_work(fs_info->caching_workers, &caching_ctl->work);
 
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b7c2487..53901a5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1818,10 +1818,10 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 /* see btrfs_writepage_start_hook for details on why this is required */
 struct btrfs_writepage_fixup {
 	struct page *page;
-	struct btrfs_work work;
+	struct work_struct work;
 };
 
-static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
+static void btrfs_writepage_fixup_worker(struct work_struct *work)
 {
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
@@ -1912,9 +1912,9 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 
 	SetPageChecked(page);
 	page_cache_get(page);
-	fixup->work.func = btrfs_writepage_fixup_worker;
+	INIT_WORK(&fixup->work, btrfs_writepage_fixup_worker);
 	fixup->page = page;
-	btrfs_queue_worker(&root->fs_info->fixup_workers, &fixup->work);
+	queue_work(root->fs_info->fixup_workers, &fixup->work);
 	return -EBUSY;
 }
 
@@ -2780,7 +2780,7 @@ out:
 	return ret;
 }
 
-static void finish_ordered_fn(struct btrfs_work *work)
+static void finish_ordered_fn(struct work_struct *work)
 {
 	struct btrfs_ordered_extent *ordered_extent;
 	ordered_extent = container_of(work, struct btrfs_ordered_extent, work);
@@ -2793,7 +2793,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	struct inode *inode = page->mapping->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
-	struct btrfs_workers *workers;
+	struct workqueue_struct *workers;
 
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
@@ -2802,14 +2802,13 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 					    end - start + 1, uptodate))
 		return 0;
 
-	ordered_extent->work.func = finish_ordered_fn;
-	ordered_extent->work.flags = 0;
+	INIT_WORK(&ordered_extent->work, finish_ordered_fn);
 
 	if (btrfs_is_free_space_inode(inode))
-		workers = &root->fs_info->endio_freespace_worker;
+		workers = root->fs_info->endio_freespace_worker;
 	else
-		workers = &root->fs_info->endio_write_workers;
-	btrfs_queue_worker(workers, &ordered_extent->work);
+		workers = root->fs_info->endio_write_workers;
+	queue_work(workers, &ordered_extent->work);
 
 	return 0;
 }
@@ -6906,10 +6905,9 @@ again:
 	if (!ret)
 		goto out_test;
 
-	ordered->work.func = finish_ordered_fn;
-	ordered->work.flags = 0;
-	btrfs_queue_worker(&root->fs_info->endio_write_workers,
-			   &ordered->work);
+	INIT_WORK(&ordered->work, finish_ordered_fn);
+	queue_work(root->fs_info->endio_write_workers, &ordered->work);
+
 out_test:
 	/*
 	 * our bio might span multiple ordered extents.  If we haven't
@@ -8187,7 +8185,7 @@ out_notrans:
 	return ret;
 }
 
-static void btrfs_run_delalloc_work(struct btrfs_work *work)
+static void btrfs_run_delalloc_work(struct work_struct *work)
 {
 	struct btrfs_delalloc_work *delalloc_work;
 
@@ -8206,7 +8204,7 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
 }
 
 struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
-						    int wait, int delay_iput)
+						      int wait, int delay_iput)
 {
 	struct btrfs_delalloc_work *work;
 
@@ -8219,8 +8217,7 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 	work->inode = inode;
 	work->wait = wait;
 	work->delay_iput = delay_iput;
-	work->work.func = btrfs_run_delalloc_work;
-
+	INIT_WORK(&work->work, btrfs_run_delalloc_work);
 	return work;
 }
 
@@ -8267,8 +8264,7 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 			goto out;
 		}
 		list_add_tail(&work->list, &works);
-		btrfs_queue_worker(&root->fs_info->flush_workers,
-				   &work->work);
+		queue_work(root->fs_info->flush_workers, &work->work);
 
 		cond_resched();
 		spin_lock(&root->delalloc_lock);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8136982..9b5ccac 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -552,7 +552,7 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	wake_up(&entry->wait);
 }
 
-static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
+static void btrfs_run_ordered_extent_work(struct work_struct *work)
 {
 	struct btrfs_ordered_extent *ordered;
 
@@ -594,10 +594,9 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 		atomic_inc(&ordered->refs);
 		spin_unlock(&root->ordered_extent_lock);
 
-		ordered->flush_work.func = btrfs_run_ordered_extent_work;
+		INIT_WORK(&ordered->flush_work, btrfs_run_ordered_extent_work);
 		list_add_tail(&ordered->work_list, &works);
-		btrfs_queue_worker(&root->fs_info->flush_workers,
-				   &ordered->flush_work);
+		queue_work(root->fs_info->flush_workers, &ordered->flush_work);
 
 		cond_resched();
 		spin_lock(&root->ordered_extent_lock);
@@ -706,8 +705,8 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 		list_add_tail(&work->list, &works);
-		btrfs_queue_worker(&root->fs_info->flush_workers,
-				   &work->work);
+		queue_work(root->fs_info->flush_workers,
+			   &work->work);
 
 		cond_resched();
 		spin_lock(&root->fs_info->ordered_root_lock);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 68844d5..f4c81d7 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -123,10 +123,10 @@ struct btrfs_ordered_extent {
 	/* a per root list of all the pending ordered extents */
 	struct list_head root_extent_list;
 
-	struct btrfs_work work;
+	struct work_struct work;
 
 	struct completion completion;
-	struct btrfs_work flush_work;
+	struct work_struct flush_work;
 	struct list_head work_list;
 };
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1280eff..a49fdfe 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1528,8 +1528,8 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		ret = qgroup_rescan_init(fs_info, 0, 1);
 		if (!ret) {
 			qgroup_rescan_zero_tracking(fs_info);
-			btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
-					   &fs_info->qgroup_rescan_work);
+			queue_work(fs_info->qgroup_rescan_workers,
+				   &fs_info->qgroup_rescan_work);
 		}
 		ret = 0;
 	}
@@ -1994,7 +1994,7 @@ out:
 	return ret;
 }
 
-static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
+static void btrfs_qgroup_rescan_worker(struct work_struct *work)
 {
 	struct btrfs_fs_info *fs_info = container_of(work, struct btrfs_fs_info,
 						     qgroup_rescan_work);
@@ -2105,7 +2105,7 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	memset(&fs_info->qgroup_rescan_work, 0,
 	       sizeof(fs_info->qgroup_rescan_work));
-	fs_info->qgroup_rescan_work.func = btrfs_qgroup_rescan_worker;
+	INIT_WORK(&fs_info->qgroup_rescan_work, btrfs_qgroup_rescan_worker);
 
 	if (ret) {
 err:
@@ -2168,8 +2168,8 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 
 	qgroup_rescan_zero_tracking(fs_info);
 
-	btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
-			   &fs_info->qgroup_rescan_work);
+	queue_work(fs_info->qgroup_rescan_workers,
+		   &fs_info->qgroup_rescan_work);
 
 	return 0;
 }
@@ -2200,6 +2200,6 @@ void
 btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 {
 	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
-		btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
-				   &fs_info->qgroup_rescan_work);
+		queue_work(fs_info->qgroup_rescan_workers,
+			   &fs_info->qgroup_rescan_work);
 }
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0525e13..4b7769d 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -88,7 +88,7 @@ struct btrfs_raid_bio {
 	/*
 	 * for scheduling work in the helper threads
 	 */
-	struct btrfs_work work;
+	struct work_struct work;
 
 	/*
 	 * bio list and bio_list_lock are used
@@ -167,8 +167,8 @@ struct btrfs_raid_bio {
 
 static int __raid56_parity_recover(struct btrfs_raid_bio *rbio);
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio);
-static void rmw_work(struct btrfs_work *work);
-static void read_rebuild_work(struct btrfs_work *work);
+static void rmw_work(struct work_struct *work);
+static void read_rebuild_work(struct work_struct *work);
 static void async_rmw_stripe(struct btrfs_raid_bio *rbio);
 static void async_read_rebuild(struct btrfs_raid_bio *rbio);
 static int fail_bio_stripe(struct btrfs_raid_bio *rbio, struct bio *bio);
@@ -1417,20 +1417,16 @@ cleanup:
 
 static void async_rmw_stripe(struct btrfs_raid_bio *rbio)
 {
-	rbio->work.flags = 0;
-	rbio->work.func = rmw_work;
-
-	btrfs_queue_worker(&rbio->fs_info->rmw_workers,
-			   &rbio->work);
+	INIT_WORK(&rbio->work, rmw_work);
+	queue_work(rbio->fs_info->rmw_workers,
+		   &rbio->work);
 }
 
 static void async_read_rebuild(struct btrfs_raid_bio *rbio)
 {
-	rbio->work.flags = 0;
-	rbio->work.func = read_rebuild_work;
-
-	btrfs_queue_worker(&rbio->fs_info->rmw_workers,
-			   &rbio->work);
+	INIT_WORK(&rbio->work, read_rebuild_work);
+	queue_work(rbio->fs_info->rmw_workers,
+		   &rbio->work);
 }
 
 /*
@@ -1589,7 +1585,7 @@ struct btrfs_plug_cb {
 	struct blk_plug_cb cb;
 	struct btrfs_fs_info *info;
 	struct list_head rbio_list;
-	struct btrfs_work work;
+	struct work_struct work;
 };
 
 /*
@@ -1653,7 +1649,7 @@ static void run_plug(struct btrfs_plug_cb *plug)
  * if the unplug comes from schedule, we have to push the
  * work off to a helper thread
  */
-static void unplug_work(struct btrfs_work *work)
+static void unplug_work(struct work_struct *work)
 {
 	struct btrfs_plug_cb *plug;
 	plug = container_of(work, struct btrfs_plug_cb, work);
@@ -1666,10 +1662,9 @@ static void btrfs_raid_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	plug = container_of(cb, struct btrfs_plug_cb, cb);
 
 	if (from_schedule) {
-		plug->work.flags = 0;
-		plug->work.func = unplug_work;
-		btrfs_queue_worker(&plug->info->rmw_workers,
-				   &plug->work);
+		INIT_WORK(&plug->work, unplug_work);
+		queue_work(plug->info->rmw_workers,
+			   &plug->work);
 		return;
 	}
 	run_plug(plug);
@@ -2083,7 +2078,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 
 }
 
-static void rmw_work(struct btrfs_work *work)
+static void rmw_work(struct work_struct *work)
 {
 	struct btrfs_raid_bio *rbio;
 
@@ -2091,7 +2086,7 @@ static void rmw_work(struct btrfs_work *work)
 	raid56_rmw_stripe(rbio);
 }
 
-static void read_rebuild_work(struct btrfs_work *work)
+static void read_rebuild_work(struct work_struct *work)
 {
 	struct btrfs_raid_bio *rbio;
 
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 1031b69..9607648 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -91,7 +91,7 @@ struct reada_zone {
 };
 
 struct reada_machine_work {
-	struct btrfs_work	work;
+	struct work_struct	work;
 	struct btrfs_fs_info	*fs_info;
 };
 
@@ -732,7 +732,7 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 
 }
 
-static void reada_start_machine_worker(struct btrfs_work *work)
+static void reada_start_machine_worker(struct work_struct *work)
 {
 	struct reada_machine_work *rmw;
 	struct btrfs_fs_info *fs_info;
@@ -792,10 +792,10 @@ static void reada_start_machine(struct btrfs_fs_info *fs_info)
 		/* FIXME we cannot handle this properly right now */
 		BUG();
 	}
-	rmw->work.func = reada_start_machine_worker;
+	INIT_WORK(&rmw->work, reada_start_machine_worker);
 	rmw->fs_info = fs_info;
 
-	btrfs_queue_worker(&fs_info->readahead_workers, &rmw->work);
+	queue_work(fs_info->readahead_workers, &rmw->work);
 }
 
 #ifdef DEBUG
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4ba2a69..025bb53 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -96,7 +96,7 @@ struct scrub_bio {
 #endif
 	int			page_count;
 	int			next_free;
-	struct btrfs_work	work;
+	struct work_struct	work;
 };
 
 struct scrub_block {
@@ -154,7 +154,7 @@ struct scrub_fixup_nodatasum {
 	struct btrfs_device	*dev;
 	u64			logical;
 	struct btrfs_root	*root;
-	struct btrfs_work	work;
+	struct work_struct	work;
 	int			mirror_num;
 };
 
@@ -164,7 +164,7 @@ struct scrub_copy_nocow_ctx {
 	u64			len;
 	int			mirror_num;
 	u64			physical_for_dev_replace;
-	struct btrfs_work	work;
+	struct work_struct	work;
 };
 
 struct scrub_warning {
@@ -224,7 +224,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 gen, int mirror_num, u8 *csum, int force,
 		       u64 physical_for_dev_replace);
 static void scrub_bio_end_io(struct bio *bio, int err);
-static void scrub_bio_end_io_worker(struct btrfs_work *work);
+static void scrub_bio_end_io_worker(struct work_struct *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       u64 extent_logical, u64 extent_len,
@@ -241,14 +241,14 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage);
 static void scrub_wr_submit(struct scrub_ctx *sctx);
 static void scrub_wr_bio_end_io(struct bio *bio, int err);
-static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
+static void scrub_wr_bio_end_io_worker(struct work_struct *work);
 static int write_page_nocow(struct scrub_ctx *sctx,
 			    u64 physical_for_dev_replace, struct page *page);
 static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 				      void *ctx);
 static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			    int mirror_num, u64 physical_for_dev_replace);
-static void copy_nocow_pages_worker(struct btrfs_work *work);
+static void copy_nocow_pages_worker(struct work_struct *work);
 
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
@@ -386,7 +386,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 		sbio->index = i;
 		sbio->sctx = sctx;
 		sbio->page_count = 0;
-		sbio->work.func = scrub_bio_end_io_worker;
+		INIT_WORK(&sbio->work, scrub_bio_end_io_worker);
 
 		if (i != SCRUB_BIOS_PER_SCTX - 1)
 			sctx->bios[i]->next_free = i + 1;
@@ -691,7 +691,7 @@ out:
 	return -EIO;
 }
 
-static void scrub_fixup_nodatasum(struct btrfs_work *work)
+static void scrub_fixup_nodatasum(struct work_struct *work)
 {
 	int ret;
 	struct scrub_fixup_nodatasum *fixup;
@@ -956,9 +956,8 @@ nodatasum_case:
 		fixup_nodatasum->root = fs_info->extent_root;
 		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
 		scrub_pending_trans_workers_inc(sctx);
-		fixup_nodatasum->work.func = scrub_fixup_nodatasum;
-		btrfs_queue_worker(&fs_info->scrub_workers,
-				   &fixup_nodatasum->work);
+		INIT_WORK(&fixup_nodatasum->work, scrub_fixup_nodatasum);
+		queue_work(fs_info->scrub_workers, &fixup_nodatasum->work);
 		goto out;
 	}
 
@@ -1592,11 +1591,11 @@ static void scrub_wr_bio_end_io(struct bio *bio, int err)
 	sbio->err = err;
 	sbio->bio = bio;
 
-	sbio->work.func = scrub_wr_bio_end_io_worker;
-	btrfs_queue_worker(&fs_info->scrub_wr_completion_workers, &sbio->work);
+	INIT_WORK(&sbio->work, scrub_wr_bio_end_io_worker);
+	queue_work(fs_info->scrub_wr_completion_workers, &sbio->work);
 }
 
-static void scrub_wr_bio_end_io_worker(struct btrfs_work *work)
+static void scrub_wr_bio_end_io_worker(struct work_struct *work)
 {
 	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
 	struct scrub_ctx *sctx = sbio->sctx;
@@ -2061,10 +2060,10 @@ static void scrub_bio_end_io(struct bio *bio, int err)
 	sbio->err = err;
 	sbio->bio = bio;
 
-	btrfs_queue_worker(&fs_info->scrub_workers, &sbio->work);
+	queue_work(fs_info->scrub_workers, &sbio->work);
 }
 
-static void scrub_bio_end_io_worker(struct btrfs_work *work)
+static void scrub_bio_end_io_worker(struct work_struct *work)
 {
 	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
 	struct scrub_ctx *sctx = sbio->sctx;
@@ -2778,34 +2777,33 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 						int is_dev_replace)
 {
 	int ret = 0;
+	int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
+	int max_active = fs_info->thread_pool_size;
 
 	mutex_lock(&fs_info->scrub_lock);
 	if (fs_info->scrub_workers_refcnt == 0) {
 		if (is_dev_replace)
-			btrfs_init_workers(&fs_info->scrub_workers, "scrub", 1,
-					&fs_info->generic_worker);
+			fs_info->scrub_workers =
+				alloc_workqueue("scrub", flags, 1);
 		else
-			btrfs_init_workers(&fs_info->scrub_workers, "scrub",
-					fs_info->thread_pool_size,
-					&fs_info->generic_worker);
-		fs_info->scrub_workers.idle_thresh = 4;
-		ret = btrfs_start_workers(&fs_info->scrub_workers);
-		if (ret)
+			fs_info->scrub_workers =
+				alloc_workqueue("scrub", flags, max_active);
+		if (!fs_info->scrub_workers) {
+			ret = -ENOMEM;
 			goto out;
-		btrfs_init_workers(&fs_info->scrub_wr_completion_workers,
-				   "scrubwrc",
-				   fs_info->thread_pool_size,
-				   &fs_info->generic_worker);
-		fs_info->scrub_wr_completion_workers.idle_thresh = 2;
-		ret = btrfs_start_workers(
-				&fs_info->scrub_wr_completion_workers);
-		if (ret)
+		}
+		fs_info->scrub_wr_completion_workers =
+			alloc_workqueue("scrubwrc", flags, max_active);
+		if (!fs_info->scrub_wr_completion_workers) {
+			ret = -ENOMEM;
 			goto out;
-		btrfs_init_workers(&fs_info->scrub_nocow_workers, "scrubnc", 1,
-				   &fs_info->generic_worker);
-		ret = btrfs_start_workers(&fs_info->scrub_nocow_workers);
-		if (ret)
+		}
+		fs_info->scrub_nocow_workers =
+			alloc_workqueue("scrubnc", flags, 1);
+		if (!fs_info->scrub_nocow_workers) {
+			ret = -ENOMEM;
 			goto out;
+		}
 	}
 	++fs_info->scrub_workers_refcnt;
 out:
@@ -2818,9 +2816,9 @@ static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
 {
 	mutex_lock(&fs_info->scrub_lock);
 	if (--fs_info->scrub_workers_refcnt == 0) {
-		btrfs_stop_workers(&fs_info->scrub_workers);
-		btrfs_stop_workers(&fs_info->scrub_wr_completion_workers);
-		btrfs_stop_workers(&fs_info->scrub_nocow_workers);
+		destroy_workqueue(fs_info->scrub_workers);
+		destroy_workqueue(fs_info->scrub_wr_completion_workers);
+		destroy_workqueue(fs_info->scrub_nocow_workers);
 	}
 	WARN_ON(fs_info->scrub_workers_refcnt < 0);
 	mutex_unlock(&fs_info->scrub_lock);
@@ -3130,14 +3128,14 @@ static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	nocow_ctx->len = len;
 	nocow_ctx->mirror_num = mirror_num;
 	nocow_ctx->physical_for_dev_replace = physical_for_dev_replace;
-	nocow_ctx->work.func = copy_nocow_pages_worker;
-	btrfs_queue_worker(&fs_info->scrub_nocow_workers,
-			   &nocow_ctx->work);
+	INIT_WORK(&nocow_ctx->work, copy_nocow_pages_worker);
+	queue_work(fs_info->scrub_nocow_workers,
+		   &nocow_ctx->work);
 
 	return 0;
 }
 
-static void copy_nocow_pages_worker(struct btrfs_work *work)
+static void copy_nocow_pages_worker(struct work_struct *work)
 {
 	struct scrub_copy_nocow_ctx *nocow_ctx =
 		container_of(work, struct scrub_copy_nocow_ctx, work);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8eb6191..f557ab6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1177,16 +1177,19 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_meta_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_meta_write_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_write_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_size);
-	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->scrub_wr_completion_workers,
+	workqueue_set_max_active(fs_info->caching_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->fixup_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->endio_meta_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->endio_meta_write_workers,
+				 new_pool_size);
+	workqueue_set_max_active(fs_info->endio_write_workers,
+				 new_pool_size);
+	workqueue_set_max_active(fs_info->endio_freespace_worker,
+				 new_pool_size);
+	workqueue_set_max_active(fs_info->delayed_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->readahead_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->scrub_wr_completion_workers,
 			      new_pool_size);
 }
 
-- 
1.8.4

