Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab3KGFvZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:25 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pFSx008348
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 11/17] btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue.
Date: Thu, 7 Nov 2013 13:52:01 +0800
Message-Id: <1383803527-23736-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->cache_workers with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace caching_workers.
---
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/disk-io.c     | 12 ++++++------
 fs/btrfs/extent-tree.c |  6 +++---
 fs/btrfs/super.c       |  2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 89a5411..edc3097 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1199,7 +1199,7 @@ struct btrfs_caching_control {
 	struct list_head list;
 	struct mutex mutex;
 	wait_queue_head_t wait;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 	struct btrfs_block_group_cache *block_group;
 	u64 progress;
 	atomic_t count;
@@ -1494,7 +1494,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue_struct *endio_write_workers;
 	struct btrfs_workqueue_struct *endio_freespace_worker;
 	struct btrfs_workqueue_struct *submit_workers;
-	struct btrfs_workers caching_workers;
+	struct btrfs_workqueue_struct *caching_workers;
 	struct btrfs_workers readahead_workers;
 
 	/*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d6f5cf7..38b65d4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2004,7 +2004,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->endio_freespace_worker);
 	btrfs_destroy_workqueue(fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
-	btrfs_stop_workers(&fs_info->caching_workers);
+	btrfs_destroy_workqueue(fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
 	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
@@ -2502,9 +2502,9 @@ int open_ctree(struct super_block *sb,
 							fs_devices->num_devices,
 							max_active), 64);
 
-	btrfs_init_workers(&fs_info->caching_workers, "cache",
-			   fs_info->thread_pool_size, NULL);
-
+	fs_info->caching_workers = btrfs_alloc_workqueue("cache", NULL, NULL,
+							 flags, max_active,
+							 0);
 
 	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
 			   &fs_info->generic_worker);
@@ -2551,7 +2551,6 @@ int open_ctree(struct super_block *sb,
 	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
-	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
 	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
@@ -2563,7 +2562,8 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
 	      fs_info->endio_meta_write_workers &&
 	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
-	      fs_info->endio_freespace_worker && fs_info->rmw_workers)) {
+	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
+	      fs_info->caching_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..143acf7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -378,7 +378,7 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	return total_added;
 }
 
-static noinline void caching_thread(struct btrfs_work *work)
+static noinline void caching_thread(struct btrfs_work_struct *work)
 {
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_fs_info *fs_info;
@@ -548,7 +548,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	caching_ctl->block_group = cache;
 	caching_ctl->progress = cache->key.objectid;
 	atomic_set(&caching_ctl->count, 1);
-	caching_ctl->work.func = caching_thread;
+	btrfs_init_work(&caching_ctl->work, caching_thread, NULL, NULL);
 
 	spin_lock(&cache->lock);
 	/*
@@ -639,7 +639,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 
 	btrfs_get_block_group(cache);
 
-	btrfs_queue_worker(&fs_info->caching_workers, &caching_ctl->work);
+	btrfs_queue_work(fs_info->caching_workers, &caching_ctl->work);
 
 	return ret;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a8fc05d..e76c9d5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1249,7 +1249,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->submit_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_meta_workers, new_pool_size);
-- 
1.8.4.2

