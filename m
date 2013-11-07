Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26950 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3KGFvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:23 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pFA2008341
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 07/17] btrfs: Replace fs_info->submit_workers with btrfs_workqueue.
Date: Thu, 7 Nov 2013 13:51:57 +0800
Message-Id: <1383803527-23736-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Much like the fs_info->workers, replace the fs_info->submit_workers
use the same btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  None
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 22 +++++++++++-----------
 fs/btrfs/super.c   |  2 +-
 fs/btrfs/volumes.c | 11 ++++++-----
 fs/btrfs/volumes.h |  2 +-
 5 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f38285e..3edb9e6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1493,7 +1493,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_meta_write_workers;
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers endio_freespace_worker;
-	struct btrfs_workers submit_workers;
+	struct btrfs_workqueue_struct *submit_workers;
 	struct btrfs_workers caching_workers;
 	struct btrfs_workers readahead_workers;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ed2eb52..ec474c8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2003,7 +2003,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
-	btrfs_stop_workers(&fs_info->submit_workers);
+	btrfs_destroy_workqueue(fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
@@ -2493,18 +2493,18 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
 			   fs_info->thread_pool_size, NULL);
 
-	btrfs_init_workers(&fs_info->submit_workers, "submit",
-			   min_t(u64, fs_devices->num_devices,
-			   fs_info->thread_pool_size), NULL);
-
-	btrfs_init_workers(&fs_info->caching_workers, "cache",
-			   fs_info->thread_pool_size, NULL);
-
 	/* a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
 	 * devices
 	 */
-	fs_info->submit_workers.idle_thresh = 64;
+	fs_info->submit_workers = btrfs_alloc_workqueue("submit", NULL, NULL,
+							flags, min_t(u64,
+							fs_devices->num_devices,
+							max_active), 64);
+
+	btrfs_init_workers(&fs_info->caching_workers, "cache",
+			   fs_info->thread_pool_size, NULL);
+
 
 	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
 			   &fs_info->generic_worker);
@@ -2555,7 +2555,6 @@ int open_ctree(struct super_block *sb,
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->submit_workers);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
 	ret |= btrfs_start_workers(&fs_info->endio_workers);
 	ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
@@ -2573,7 +2572,8 @@ int open_ctree(struct super_block *sb,
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
-	if (!(fs_info->workers && fs_info->delalloc_workers)) {
+	if (!(fs_info->workers && fs_info->delalloc_workers &&
+	      fs_info->submit_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6f0d206..4c5b4f2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1248,7 +1248,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->submit_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1bd573d..321a687 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -416,7 +416,8 @@ loop_lock:
 			device->running_pending = 1;
 
 			spin_unlock(&device->io_lock);
-			btrfs_requeue_work(&device->work);
+			btrfs_queue_work(fs_info->submit_workers,
+					 &device->work);
 			goto done;
 		}
 		/* unplug every 64 requests just for good measure */
@@ -440,7 +441,7 @@ done:
 	blk_finish_plug(&plug);
 }
 
-static void pending_bios_fn(struct btrfs_work *work)
+static void pending_bios_fn(struct btrfs_work_struct *work)
 {
 	struct btrfs_device *device;
 
@@ -5372,8 +5373,8 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	spin_unlock(&device->io_lock);
 
 	if (should_queue)
-		btrfs_queue_worker(&root->fs_info->submit_workers,
-				   &device->work);
+		btrfs_queue_work(root->fs_info->submit_workers,
+				 &device->work);
 }
 
 static int bio_size_ok(struct block_device *bdev, struct bio *bio,
@@ -5651,7 +5652,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	else
 		generate_random_uuid(dev->uuid);
 
-	dev->work.func = pending_bios_fn;
+	btrfs_init_work(&dev->work, pending_bios_fn, NULL, NULL);
 
 	return dev;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b72f540..ab897cb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -91,7 +91,7 @@ struct btrfs_device {
 	/* per-device scrub information */
 	struct scrub_ctx *scrub_device;
 
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 	struct rcu_head rcu;
 	struct work_struct rcu_work;
 
-- 
1.8.4.2

