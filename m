Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26950 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab3KGFv0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:26 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pGk0008356
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 09/17] btrfs: Replace fs_info->endio_* workqueue with btrfs_workqueue.
Date: Thu, 7 Nov 2013 13:51:59 +0800
Message-Id: <1383803527-23736-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->endio_* workqueues with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace endio_*.
---
 fs/btrfs/ctree.h        |  12 +++---
 fs/btrfs/disk-io.c      | 110 +++++++++++++++++++++++-------------------------
 fs/btrfs/inode.c        |  20 ++++-----
 fs/btrfs/ordered-data.h |   2 +-
 fs/btrfs/super.c        |  11 ++---
 5 files changed, 74 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c74f27e..e8916e3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1486,13 +1486,13 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue_struct *workers;
 	struct btrfs_workqueue_struct *delalloc_workers;
 	struct btrfs_workqueue_struct *flush_workers;
-	struct btrfs_workers endio_workers;
-	struct btrfs_workers endio_meta_workers;
-	struct btrfs_workers endio_raid56_workers;
+	struct btrfs_workqueue_struct *endio_workers;
+	struct btrfs_workqueue_struct *endio_meta_workers;
+	struct btrfs_workqueue_struct *endio_raid56_workers;
 	struct btrfs_workers rmw_workers;
-	struct btrfs_workers endio_meta_write_workers;
-	struct btrfs_workers endio_write_workers;
-	struct btrfs_workers endio_freespace_worker;
+	struct btrfs_workqueue_struct *endio_meta_write_workers;
+	struct btrfs_workqueue_struct *endio_write_workers;
+	struct btrfs_workqueue_struct *endio_freespace_worker;
 	struct btrfs_workqueue_struct *submit_workers;
 	struct btrfs_workers caching_workers;
 	struct btrfs_workers readahead_workers;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e4adff..7099001 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -55,7 +55,7 @@
 #endif
 
 static struct extent_io_ops btree_extent_io_ops;
-static void end_workqueue_fn(struct btrfs_work *work);
+static void end_workqueue_fn(struct btrfs_work_struct *work);
 static void free_fs_root(struct btrfs_root *root);
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
@@ -87,7 +87,7 @@ struct end_io_wq {
 	int error;
 	int metadata;
 	struct list_head list;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 };
 
 /*
@@ -689,32 +689,31 @@ static void end_workqueue_bio(struct bio *bio, int err)
 
 	fs_info = end_io_wq->info;
 	end_io_wq->error = err;
-	end_io_wq->work.func = end_workqueue_fn;
-	end_io_wq->work.flags = 0;
+	btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL, NULL);
 
 	if (bio->bi_rw & REQ_WRITE) {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA)
-			btrfs_queue_worker(&fs_info->endio_meta_write_workers,
-					   &end_io_wq->work);
+			btrfs_queue_work(fs_info->endio_meta_write_workers,
+					 &end_io_wq->work);
 		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_FREE_SPACE)
-			btrfs_queue_worker(&fs_info->endio_freespace_worker,
-					   &end_io_wq->work);
+			btrfs_queue_work(fs_info->endio_freespace_worker,
+					 &end_io_wq->work);
 		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
-			btrfs_queue_worker(&fs_info->endio_raid56_workers,
-					   &end_io_wq->work);
+			btrfs_queue_work(fs_info->endio_raid56_workers,
+					 &end_io_wq->work);
 		else
-			btrfs_queue_worker(&fs_info->endio_write_workers,
-					   &end_io_wq->work);
+			btrfs_queue_work(fs_info->endio_write_workers,
+					 &end_io_wq->work);
 	} else {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
-			btrfs_queue_worker(&fs_info->endio_raid56_workers,
-					   &end_io_wq->work);
+			btrfs_queue_work(fs_info->endio_raid56_workers,
+					 &end_io_wq->work);
 		else if (end_io_wq->metadata)
-			btrfs_queue_worker(&fs_info->endio_meta_workers,
-					   &end_io_wq->work);
+			btrfs_queue_work(fs_info->endio_meta_workers,
+					 &end_io_wq->work);
 		else
-			btrfs_queue_worker(&fs_info->endio_workers,
-					   &end_io_wq->work);
+			btrfs_queue_work(fs_info->endio_workers,
+					 &end_io_wq->work);
 	}
 }
 
@@ -1667,7 +1666,7 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
  * called by the kthread helper functions to finally call the bio end_io
  * functions.  This is where read checksum verification actually happens
  */
-static void end_workqueue_fn(struct btrfs_work *work)
+static void end_workqueue_fn(struct btrfs_work_struct *work)
 {
 	struct bio *bio;
 	struct end_io_wq *end_io_wq;
@@ -1996,13 +1995,13 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
-	btrfs_stop_workers(&fs_info->endio_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_workers);
-	btrfs_stop_workers(&fs_info->endio_raid56_workers);
+	btrfs_destroy_workqueue(fs_info->endio_workers);
+	btrfs_destroy_workqueue(fs_info->endio_meta_workers);
+	btrfs_destroy_workqueue(fs_info->endio_raid56_workers);
 	btrfs_stop_workers(&fs_info->rmw_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
-	btrfs_stop_workers(&fs_info->endio_write_workers);
-	btrfs_stop_workers(&fs_info->endio_freespace_worker);
+	btrfs_destroy_workqueue(fs_info->endio_meta_write_workers);
+	btrfs_destroy_workqueue(fs_info->endio_write_workers);
+	btrfs_destroy_workqueue(fs_info->endio_freespace_worker);
 	btrfs_destroy_workqueue(fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
@@ -2509,26 +2508,32 @@ int open_ctree(struct super_block *sb,
 
 	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
 			   &fs_info->generic_worker);
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
+	/*
+	 * endios are largely parallel and should have a very
+	 * low idle thresh
+	 */
+	fs_info->endio_workers = btrfs_alloc_workqueue("endio", NULL, NULL,
+						       flags, max_active, 4);
+	fs_info->endio_meta_workers = btrfs_alloc_workqueue("endio-meta",
+							    NULL, NULL, flags,
+							    max_active, 4);
+	fs_info->endio_meta_write_workers =
+			btrfs_alloc_workqueue("endio-meta-write", NULL, NULL,
+					      flags, max_active, 2);
+	fs_info->endio_raid56_workers = btrfs_alloc_workqueue("endio-raid56",
+							      NULL, NULL,
+							      flags,
+							      max_active, 4);
 	btrfs_init_workers(&fs_info->rmw_workers,
 			   "rmw", fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_write_workers, "endio-write",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->endio_freespace_worker, "freespace-write",
-			   1, &fs_info->generic_worker);
+	fs_info->endio_write_workers = btrfs_alloc_workqueue("endio-write",
+							     NULL, NULL,
+							     flags,
+							     max_active, 2);
+	fs_info->endio_freespace_worker =
+			btrfs_alloc_workqueue("freespace-write", NULL, NULL,
+					      flags, max_active, 0);
 	btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
@@ -2538,17 +2543,8 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
 			   &fs_info->generic_worker);
 
-	/*
-	 * endios are largely parallel and should have a very
-	 * low idle thresh
-	 */
-	fs_info->endio_workers.idle_thresh = 4;
-	fs_info->endio_meta_workers.idle_thresh = 4;
-	fs_info->endio_raid56_workers.idle_thresh = 4;
 	fs_info->rmw_workers.idle_thresh = 2;
 
-	fs_info->endio_write_workers.idle_thresh = 2;
-	fs_info->endio_meta_write_workers.idle_thresh = 2;
 	fs_info->readahead_workers.idle_thresh = 2;
 
 	/*
@@ -2557,13 +2553,7 @@ int open_ctree(struct super_block *sb,
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
 	ret |= btrfs_start_workers(&fs_info->rmw_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_raid56_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_meta_write_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_write_workers);
-	ret |= btrfs_start_workers(&fs_info->endio_freespace_worker);
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
@@ -2573,7 +2563,11 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 	if (!(fs_info->workers && fs_info->delalloc_workers &&
-	      fs_info->submit_workers && fs_info->flush_workers)) {
+	      fs_info->submit_workers && fs_info->flush_workers &&
+	      fs_info->endio_workers && fs_info->endio_meta_workers &&
+	      fs_info->endio_meta_write_workers &&
+	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
+	      fs_info->endio_freespace_worker)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5e5fc7f..9dd807d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2719,7 +2719,7 @@ out:
 	return ret;
 }
 
-static void finish_ordered_fn(struct btrfs_work *work)
+static void finish_ordered_fn(struct btrfs_work_struct *work)
 {
 	struct btrfs_ordered_extent *ordered_extent;
 	ordered_extent = container_of(work, struct btrfs_ordered_extent, work);
@@ -2732,7 +2732,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	struct inode *inode = page->mapping->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
-	struct btrfs_workers *workers;
+	struct btrfs_workqueue_struct *workers;
 
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
@@ -2741,14 +2741,13 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 					    end - start + 1, uptodate))
 		return 0;
 
-	ordered_extent->work.func = finish_ordered_fn;
-	ordered_extent->work.flags = 0;
+	btrfs_init_work(&ordered_extent->work, finish_ordered_fn, NULL, NULL);
 
 	if (btrfs_is_free_space_inode(inode))
-		workers = &root->fs_info->endio_freespace_worker;
+		workers = root->fs_info->endio_freespace_worker;
 	else
-		workers = &root->fs_info->endio_write_workers;
-	btrfs_queue_worker(workers, &ordered_extent->work);
+		workers = root->fs_info->endio_write_workers;
+	btrfs_queue_work(workers, &ordered_extent->work);
 
 	return 0;
 }
@@ -6835,10 +6834,9 @@ again:
 	if (!ret)
 		goto out_test;
 
-	ordered->work.func = finish_ordered_fn;
-	ordered->work.flags = 0;
-	btrfs_queue_worker(&root->fs_info->endio_write_workers,
-			   &ordered->work);
+	btrfs_init_work(&ordered->work, finish_ordered_fn, NULL, NULL);
+	btrfs_queue_work(root->fs_info->endio_write_workers,
+			 &ordered->work);
 out_test:
 	/*
 	 * our bio might span multiple ordered extents.  If we haven't
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 7496866..86a3a86 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -130,7 +130,7 @@ struct btrfs_ordered_extent {
 	/* a per root list of all the pending ordered extents */
 	struct list_head root_extent_list;
 
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 
 	struct completion completion;
 	struct btrfs_work_struct flush_work;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4c5b4f2..a8fc05d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1251,11 +1251,12 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_workqueue_set_max(fs_info->submit_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_meta_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_meta_write_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_write_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->endio_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->endio_meta_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->endio_meta_write_workers,
+				new_pool_size);
+	btrfs_workqueue_set_max(fs_info->endio_write_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
 	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->scrub_wr_completion_workers,
-- 
1.8.4.2

