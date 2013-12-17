Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:44210 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab3LQJcE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBH9V6EQ027097
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 17:31:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4 10/18] btrfs: Replace fs_info->rmw_workers workqueue with btrfs_workqueue.
Date: Tue, 17 Dec 2013 17:31:51 +0800
Message-Id: <1387272719-11889-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->rmw_workers with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace rmw_workers.
v3->v4:
  - Use the simplified btrfs_alloc_workqueue API.
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 12 ++++--------
 fs/btrfs/raid56.c  | 35 ++++++++++++++++-------------------
 3 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5096164..294b373 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1495,7 +1495,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue_struct *endio_workers;
 	struct btrfs_workqueue_struct *endio_meta_workers;
 	struct btrfs_workqueue_struct *endio_raid56_workers;
-	struct btrfs_workers rmw_workers;
+	struct btrfs_workqueue_struct *rmw_workers;
 	struct btrfs_workqueue_struct *endio_meta_write_workers;
 	struct btrfs_workqueue_struct *endio_write_workers;
 	struct btrfs_workqueue_struct *endio_freespace_worker;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4f8591a..8b2977b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2012,7 +2012,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->endio_workers);
 	btrfs_destroy_workqueue(fs_info->endio_meta_workers);
 	btrfs_destroy_workqueue(fs_info->endio_raid56_workers);
-	btrfs_stop_workers(&fs_info->rmw_workers);
+	btrfs_destroy_workqueue(fs_info->rmw_workers);
 	btrfs_destroy_workqueue(fs_info->endio_meta_write_workers);
 	btrfs_destroy_workqueue(fs_info->endio_write_workers);
 	btrfs_destroy_workqueue(fs_info->endio_freespace_worker);
@@ -2509,9 +2509,8 @@ int open_ctree(struct super_block *sb,
 		btrfs_alloc_workqueue("endio-meta-write", flags, max_active, 2);
 	fs_info->endio_raid56_workers =
 		btrfs_alloc_workqueue("endio-raid56", flags, max_active, 4);
-	btrfs_init_workers(&fs_info->rmw_workers,
-			   "rmw", fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	fs_info->rmw_workers =
+		btrfs_alloc_workqueue("rmw", flags, max_active, 2);
 	fs_info->endio_write_workers =
 		btrfs_alloc_workqueue("endio-write", flags, max_active, 2);
 	fs_info->endio_freespace_worker =
@@ -2525,8 +2524,6 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
 			   &fs_info->generic_worker);
 
-	fs_info->rmw_workers.idle_thresh = 2;
-
 	fs_info->readahead_workers.idle_thresh = 2;
 
 	/*
@@ -2535,7 +2532,6 @@ int open_ctree(struct super_block *sb,
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
-	ret |= btrfs_start_workers(&fs_info->rmw_workers);
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
@@ -2549,7 +2545,7 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
 	      fs_info->endio_meta_write_workers &&
 	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
-	      fs_info->endio_freespace_worker)) {
+	      fs_info->endio_freespace_worker && fs_info->rmw_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 24ac218..5afa564 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -87,7 +87,7 @@ struct btrfs_raid_bio {
 	/*
 	 * for scheduling work in the helper threads
 	 */
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 
 	/*
 	 * bio list and bio_list_lock are used
@@ -166,8 +166,8 @@ struct btrfs_raid_bio {
 
 static int __raid56_parity_recover(struct btrfs_raid_bio *rbio);
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio);
-static void rmw_work(struct btrfs_work *work);
-static void read_rebuild_work(struct btrfs_work *work);
+static void rmw_work(struct btrfs_work_struct *work);
+static void read_rebuild_work(struct btrfs_work_struct *work);
 static void async_rmw_stripe(struct btrfs_raid_bio *rbio);
 static void async_read_rebuild(struct btrfs_raid_bio *rbio);
 static int fail_bio_stripe(struct btrfs_raid_bio *rbio, struct bio *bio);
@@ -1416,20 +1416,18 @@ cleanup:
 
 static void async_rmw_stripe(struct btrfs_raid_bio *rbio)
 {
-	rbio->work.flags = 0;
-	rbio->work.func = rmw_work;
+	btrfs_init_work(&rbio->work, rmw_work, NULL, NULL);
 
-	btrfs_queue_worker(&rbio->fs_info->rmw_workers,
-			   &rbio->work);
+	btrfs_queue_work(rbio->fs_info->rmw_workers,
+			 &rbio->work);
 }
 
 static void async_read_rebuild(struct btrfs_raid_bio *rbio)
 {
-	rbio->work.flags = 0;
-	rbio->work.func = read_rebuild_work;
+	btrfs_init_work(&rbio->work, read_rebuild_work, NULL, NULL);
 
-	btrfs_queue_worker(&rbio->fs_info->rmw_workers,
-			   &rbio->work);
+	btrfs_queue_work(rbio->fs_info->rmw_workers,
+			 &rbio->work);
 }
 
 /*
@@ -1590,7 +1588,7 @@ struct btrfs_plug_cb {
 	struct blk_plug_cb cb;
 	struct btrfs_fs_info *info;
 	struct list_head rbio_list;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 };
 
 /*
@@ -1654,7 +1652,7 @@ static void run_plug(struct btrfs_plug_cb *plug)
  * if the unplug comes from schedule, we have to push the
  * work off to a helper thread
  */
-static void unplug_work(struct btrfs_work *work)
+static void unplug_work(struct btrfs_work_struct *work)
 {
 	struct btrfs_plug_cb *plug;
 	plug = container_of(work, struct btrfs_plug_cb, work);
@@ -1667,10 +1665,9 @@ static void btrfs_raid_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	plug = container_of(cb, struct btrfs_plug_cb, cb);
 
 	if (from_schedule) {
-		plug->work.flags = 0;
-		plug->work.func = unplug_work;
-		btrfs_queue_worker(&plug->info->rmw_workers,
-				   &plug->work);
+		btrfs_init_work(&plug->work, unplug_work, NULL, NULL);
+		btrfs_queue_work(plug->info->rmw_workers,
+				 &plug->work);
 		return;
 	}
 	run_plug(plug);
@@ -2082,7 +2079,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 
 }
 
-static void rmw_work(struct btrfs_work *work)
+static void rmw_work(struct btrfs_work_struct *work)
 {
 	struct btrfs_raid_bio *rbio;
 
@@ -2090,7 +2087,7 @@ static void rmw_work(struct btrfs_work *work)
 	raid56_rmw_stripe(rbio);
 }
 
-static void read_rebuild_work(struct btrfs_work *work)
+static void read_rebuild_work(struct btrfs_work_struct *work)
 {
 	struct btrfs_raid_bio *rbio;
 
-- 
1.8.5.1

