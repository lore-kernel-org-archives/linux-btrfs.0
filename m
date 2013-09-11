Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3IKIwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 04:52:01 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8B8ppWl019950
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 16:51:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 7/9] btrfs: Replace the fs_info->submit_workers with kernel workqueue.
Date: Wed, 11 Sep 2013 16:52:36 +0800
Message-Id: <1378889558-21514-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the submit worker with kernel workqueue.
The submit_workers is different from other workers in the following
things:
1) Requeue:
This is quiet easy, just queue_work can handle it.

2) Initialize:
The work_struct in btrfs_devices should be initialized carefully to
prevent broken work_struct to be queued.

Besides this, not much to worry about.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 10 ++++------
 fs/btrfs/super.c   |  2 +-
 fs/btrfs/volumes.c | 17 +++++++++--------
 fs/btrfs/volumes.h |  2 +-
 5 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 81aba0e..0cf4320 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1477,10 +1477,10 @@ struct btrfs_fs_info {
 	 * two
 	 */
 	struct btrfs_workers generic_worker;
-	struct btrfs_workers submit_workers;
 
 	struct btrfs_workqueue_struct *workers;
 	struct btrfs_workqueue_struct *delalloc_workers;
+	struct workqueue_struct *submit_workers;
 	struct workqueue_struct *flush_workers;
 	struct workqueue_struct *endio_workers;
 	struct workqueue_struct *endio_meta_workers;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 434e5b3..97df233 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1987,7 +1987,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
-	btrfs_stop_workers(&fs_info->submit_workers);
+	destroy_workqueue(fs_info->submit_workers);
 	destroy_workqueue(fs_info->fixup_workers);
 	destroy_workqueue(fs_info->endio_workers);
 	destroy_workqueue(fs_info->endio_meta_workers);
@@ -2470,10 +2470,8 @@ int open_ctree(struct super_block *sb,
 
 	fs_info->flush_workers = alloc_workqueue("flush_delalloc", flags,
 						 max_active);
-	btrfs_init_workers(&fs_info->submit_workers, "submit",
-			   min_t(u64, fs_devices->num_devices,
-			   fs_info->thread_pool_size),
-			   &fs_info->generic_worker);
+	fs_info->submit_workers = alloc_workqueue("submit", flags,
+						  max_active);
 	fs_info->caching_workers = alloc_workqueue("cache", flags, 2);
 
 	fs_info->fixup_workers = alloc_workqueue("fixup", flags, 1);
@@ -2500,10 +2498,10 @@ int open_ctree(struct super_block *sb,
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->submit_workers);
 
 	if (ret || !(fs_info->flush_workers && fs_info->endio_workers &&
 		     fs_info->endio_meta_workers && fs_info->workers &&
+		     fs_info->submit_workers &&
 		     fs_info->endio_raid56_workers &&
 		     fs_info->rmw_workers && fs_info->delalloc_workers &&
 		     fs_info->endio_meta_write_workers &&
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 771b98a..402b488 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1177,7 +1177,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->submit_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->caching_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->fixup_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 12eaf89..cb10e02 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -352,7 +352,7 @@ loop_lock:
 			device->running_pending = 1;
 
 			spin_unlock(&device->io_lock);
-			btrfs_requeue_work(&device->work);
+			queue_work(fs_info->submit_workers, &device->work);
 			goto done;
 		}
 		/* unplug every 64 requests just for good measure */
@@ -376,7 +376,7 @@ done:
 	blk_finish_plug(&plug);
 }
 
-static void pending_bios_fn(struct btrfs_work *work)
+static void pending_bios_fn(struct work_struct *work)
 {
 	struct btrfs_device *device;
 
@@ -421,7 +421,7 @@ static noinline int device_list_add(const char *path,
 		}
 		device->devid = devid;
 		device->dev_stats_valid = 0;
-		device->work.func = pending_bios_fn;
+		INIT_WORK(&device->work, pending_bios_fn);
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
 		spin_lock_init(&device->io_lock);
@@ -507,7 +507,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		rcu_assign_pointer(device->name, name);
 
 		device->devid = orig_dev->devid;
-		device->work.func = pending_bios_fn;
+		INIT_WORK(&device->work, pending_bios_fn);
 		memcpy(device->uuid, orig_dev->uuid, sizeof(device->uuid));
 		spin_lock_init(&device->io_lock);
 		INIT_LIST_HEAD(&device->dev_list);
@@ -652,6 +652,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		new_device->in_fs_metadata = 0;
 		new_device->can_discard = 0;
 		spin_lock_init(&new_device->io_lock);
+		INIT_WORK(&new_device->work, pending_bios_fn);
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 
 		call_rcu(&device->rcu, free_device);
@@ -1992,7 +1993,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (blk_queue_discard(q))
 		device->can_discard = 1;
 	device->writeable = 1;
-	device->work.func = pending_bios_fn;
+	INIT_WORK(&device->work, pending_bios_fn);
 	generate_random_uuid(device->uuid);
 	spin_lock_init(&device->io_lock);
 	device->generation = trans->transid;
@@ -5087,8 +5088,8 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	spin_unlock(&device->io_lock);
 
 	if (should_queue)
-		btrfs_queue_worker(&root->fs_info->submit_workers,
-				   &device->work);
+		queue_work(root->fs_info->submit_workers,
+			   &device->work);
 }
 
 static int bio_size_ok(struct block_device *bdev, struct bio *bio,
@@ -5313,7 +5314,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 	list_add(&device->dev_list,
 		 &fs_devices->devices);
 	device->devid = devid;
-	device->work.func = pending_bios_fn;
+	INIT_WORK(&device->work, pending_bios_fn);
 	device->fs_devices = fs_devices;
 	device->missing = 1;
 	fs_devices->num_devices++;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8670558..bd849cc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -91,7 +91,7 @@ struct btrfs_device {
 	/* per-device scrub information */
 	struct scrub_ctx *scrub_device;
 
-	struct btrfs_work work;
+	struct work_struct work;
 	struct rcu_head rcu;
 	struct work_struct rcu_work;
 
-- 
1.8.4

