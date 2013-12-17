Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:44210 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3LQJb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:31:56 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBH9V6EN027097
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 17:31:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4 07/18] btrfs: Replace fs_info->submit_workers with btrfs_workqueue.
Date: Tue, 17 Dec 2013 17:31:48 +0800
Message-Id: <1387272719-11889-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v3->v4:
  - Use the simplified btrfs_alloc_workqueue API.
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 17 +++++++++--------
 fs/btrfs/super.c   |  2 +-
 fs/btrfs/volumes.c | 11 ++++++-----
 fs/btrfs/volumes.h |  2 +-
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a86c9a1..4411a2b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1499,7 +1499,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers endio_meta_write_workers;
 	struct btrfs_workers endio_write_workers;
 	struct btrfs_workers endio_freespace_worker;
-	struct btrfs_workers submit_workers;
+	struct btrfs_workqueue_struct *submit_workers;
 	struct btrfs_workers caching_workers;
 	struct btrfs_workers readahead_workers;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1098435..cda9766 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2017,7 +2017,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
-	btrfs_stop_workers(&fs_info->submit_workers);
+	btrfs_destroy_workqueue(fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
@@ -2482,18 +2482,19 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
 			   fs_info->thread_pool_size, NULL);
 
-	btrfs_init_workers(&fs_info->submit_workers, "submit",
-			   min_t(u64, fs_devices->num_devices,
-			   fs_info->thread_pool_size), NULL);
 
 	btrfs_init_workers(&fs_info->caching_workers, "cache",
 			   fs_info->thread_pool_size, NULL);
 
-	/* a higher idle thresh on the submit workers makes it much more
+	/*
+	 * a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
 	 * devices
 	 */
-	fs_info->submit_workers.idle_thresh = 64;
+	fs_info->submit_workers =
+		btrfs_alloc_workqueue("submit", flags,
+				      min_t(u64, fs_devices->num_devices,
+					    max_active), 64);
 
 	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
 			   &fs_info->generic_worker);
@@ -2544,7 +2545,6 @@ int open_ctree(struct super_block *sb,
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->submit_workers);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
 	ret |= btrfs_start_workers(&fs_info->endio_workers);
 	ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
@@ -2562,7 +2562,8 @@ int open_ctree(struct super_block *sb,
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
index 875560e..9f1d0a5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1247,7 +1247,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->submit_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c63ed39..e07bd64 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -415,7 +415,8 @@ loop_lock:
 			device->running_pending = 1;
 
 			spin_unlock(&device->io_lock);
-			btrfs_requeue_work(&device->work);
+			btrfs_queue_work(fs_info->submit_workers,
+					 &device->work);
 			goto done;
 		}
 		/* unplug every 64 requests just for good measure */
@@ -439,7 +440,7 @@ done:
 	blk_finish_plug(&plug);
 }
 
-static void pending_bios_fn(struct btrfs_work *work)
+static void pending_bios_fn(struct btrfs_work_struct *work)
 {
 	struct btrfs_device *device;
 
@@ -5378,8 +5379,8 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	spin_unlock(&device->io_lock);
 
 	if (should_queue)
-		btrfs_queue_worker(&root->fs_info->submit_workers,
-				   &device->work);
+		btrfs_queue_work(root->fs_info->submit_workers,
+				 &device->work);
 }
 
 static int bio_size_ok(struct block_device *bdev, struct bio *bio,
@@ -5653,7 +5654,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	else
 		generate_random_uuid(dev->uuid);
 
-	dev->work.func = pending_bios_fn;
+	btrfs_init_work(&dev->work, pending_bios_fn, NULL, NULL);
 
 	return dev;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8b3cd14..60802e2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -95,7 +95,7 @@ struct btrfs_device {
 	/* per-device scrub information */
 	struct scrub_ctx *scrub_device;
 
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 	struct rcu_head rcu;
 	struct work_struct rcu_work;
 
-- 
1.8.5.1

