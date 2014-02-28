Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbaB1Cp1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 21:45:27 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1S2jIIv017664
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 10:45:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 11/18] btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue.
Date: Fri, 28 Feb 2014 10:46:12 +0800
Message-Id: <1393555579-11271-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->cache_workers with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Tested-by: David Sterba <dsterba@suse.cz>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace submit_workers.
v3->v4:
  - Use the simplified btrfs_alloc_workqueue API.
v4->v5:
  None
---
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/disk-io.c     | 10 +++++-----
 fs/btrfs/extent-tree.c |  6 +++---
 fs/btrfs/super.c       |  2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a7b0bdd..06a64fb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1221,7 +1221,7 @@ struct btrfs_caching_control {
 	struct list_head list;
 	struct mutex mutex;
 	wait_queue_head_t wait;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 	struct btrfs_block_group_cache *block_group;
 	u64 progress;
 	atomic_t count;
@@ -1516,7 +1516,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue_struct *endio_write_workers;
 	struct btrfs_workqueue_struct *endio_freespace_worker;
 	struct btrfs_workqueue_struct *submit_workers;
-	struct btrfs_workers caching_workers;
+	struct btrfs_workqueue_struct *caching_workers;
 	struct btrfs_workers readahead_workers;
 
 	/*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 12586b1..391cadf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2003,7 +2003,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->endio_freespace_worker);
 	btrfs_destroy_workqueue(fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
-	btrfs_stop_workers(&fs_info->caching_workers);
+	btrfs_destroy_workqueue(fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
 	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
@@ -2481,8 +2481,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->flush_workers =
 		btrfs_alloc_workqueue("flush_delalloc", flags, max_active, 0);
 
-	btrfs_init_workers(&fs_info->caching_workers, "cache",
-			   fs_info->thread_pool_size, NULL);
+	fs_info->caching_workers =
+		btrfs_alloc_workqueue("cache", flags, max_active, 0);
 
 	/*
 	 * a higher idle thresh on the submit workers makes it much more
@@ -2533,7 +2533,6 @@ int open_ctree(struct super_block *sb,
 	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
-	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
 	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
@@ -2545,7 +2544,8 @@ int open_ctree(struct super_block *sb,
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
index 32312e0..bb58082 100644
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
@@ -549,7 +549,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	caching_ctl->block_group = cache;
 	caching_ctl->progress = cache->key.objectid;
 	atomic_set(&caching_ctl->count, 1);
-	caching_ctl->work.func = caching_thread;
+	btrfs_init_work(&caching_ctl->work, caching_thread, NULL, NULL);
 
 	spin_lock(&cache->lock);
 	/*
@@ -640,7 +640,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 
 	btrfs_get_block_group(cache);
 
-	btrfs_queue_worker(&fs_info->caching_workers, &caching_ctl->work);
+	btrfs_queue_work(fs_info->caching_workers, &caching_ctl->work);
 
 	return ret;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 919eb36..cd52e20 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1320,7 +1320,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->submit_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_meta_workers, new_pool_size);
-- 
1.9.0

