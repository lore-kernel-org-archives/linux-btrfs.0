Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62731 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaB1CpY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 21:45:24 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1S2jIcS017665
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 10:45:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 05/18] btrfs: Replace fs_info->workers with btrfs_workqueue.
Date: Fri, 28 Feb 2014 10:46:06 +0800
Message-Id: <1393555579-11271-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the newly created btrfs_workqueue_struct to replace the original
fs_info->workers

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Tested-by: David Sterba <dsterba@suse.cz>
---
Changelog:
v1->v2:
  None
v2->v3:
  None
v3->v4:
  - Use the simplified btrfs_alloc_workqueue API.
v4->v5:
  None
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 41 +++++++++++++++++++++--------------------
 fs/btrfs/super.c   |  2 +-
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dac6653..448df5e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1505,7 +1505,7 @@ struct btrfs_fs_info {
 	 * two
 	 */
 	struct btrfs_workers generic_worker;
-	struct btrfs_workers workers;
+	struct btrfs_workqueue_struct *workers;
 	struct btrfs_workers delalloc_workers;
 	struct btrfs_workers flush_workers;
 	struct btrfs_workers endio_workers;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cc1b423..4040a43 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -108,7 +108,7 @@ struct async_submit_bio {
 	 * can't tell us where in the file the bio should go
 	 */
 	u64 bio_offset;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 	int error;
 };
 
@@ -738,12 +738,12 @@ int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
 {
 	unsigned long limit = min_t(unsigned long,
-				    info->workers.max_workers,
+				    info->thread_pool_size,
 				    info->fs_devices->open_devices);
 	return 256 * limit;
 }
 
-static void run_one_async_start(struct btrfs_work *work)
+static void run_one_async_start(struct btrfs_work_struct *work)
 {
 	struct async_submit_bio *async;
 	int ret;
@@ -756,7 +756,7 @@ static void run_one_async_start(struct btrfs_work *work)
 		async->error = ret;
 }
 
-static void run_one_async_done(struct btrfs_work *work)
+static void run_one_async_done(struct btrfs_work_struct *work)
 {
 	struct btrfs_fs_info *fs_info;
 	struct async_submit_bio *async;
@@ -783,7 +783,7 @@ static void run_one_async_done(struct btrfs_work *work)
 			       async->bio_offset);
 }
 
-static void run_one_async_free(struct btrfs_work *work)
+static void run_one_async_free(struct btrfs_work_struct *work)
 {
 	struct async_submit_bio *async;
 
@@ -811,11 +811,9 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 	async->submit_bio_start = submit_bio_start;
 	async->submit_bio_done = submit_bio_done;
 
-	async->work.func = run_one_async_start;
-	async->work.ordered_func = run_one_async_done;
-	async->work.ordered_free = run_one_async_free;
+	btrfs_init_work(&async->work, run_one_async_start,
+			run_one_async_done, run_one_async_free);
 
-	async->work.flags = 0;
 	async->bio_flags = bio_flags;
 	async->bio_offset = bio_offset;
 
@@ -824,9 +822,9 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 	atomic_inc(&fs_info->nr_async_submits);
 
 	if (rw & REQ_SYNC)
-		btrfs_set_work_high_prio(&async->work);
+		btrfs_set_work_high_priority(&async->work);
 
-	btrfs_queue_worker(&fs_info->workers, &async->work);
+	btrfs_queue_work(fs_info->workers, &async->work);
 
 	while (atomic_read(&fs_info->async_submit_draining) &&
 	      atomic_read(&fs_info->nr_async_submits)) {
@@ -1996,7 +1994,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
-	btrfs_stop_workers(&fs_info->workers);
+	btrfs_destroy_workqueue(fs_info->workers);
 	btrfs_stop_workers(&fs_info->endio_workers);
 	btrfs_stop_workers(&fs_info->endio_meta_workers);
 	btrfs_stop_workers(&fs_info->endio_raid56_workers);
@@ -2100,6 +2098,8 @@ int open_ctree(struct super_block *sb,
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
+	int max_active;
+	int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
 	bool create_uuid_tree;
 	bool check_uuid_tree;
 
@@ -2468,12 +2468,13 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	max_active = fs_info->thread_pool_size;
 	btrfs_init_workers(&fs_info->generic_worker,
 			   "genwork", 1, NULL);
 
-	btrfs_init_workers(&fs_info->workers, "worker",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	fs_info->workers =
+		btrfs_alloc_workqueue("worker", flags | WQ_HIGHPRI,
+				      max_active, 16);
 
 	btrfs_init_workers(&fs_info->delalloc_workers, "delalloc",
 			   fs_info->thread_pool_size, NULL);
@@ -2494,9 +2495,6 @@ int open_ctree(struct super_block *sb,
 	 */
 	fs_info->submit_workers.idle_thresh = 64;
 
-	fs_info->workers.idle_thresh = 16;
-	fs_info->workers.ordered = 1;
-
 	fs_info->delalloc_workers.idle_thresh = 2;
 	fs_info->delalloc_workers.ordered = 1;
 
@@ -2548,8 +2546,7 @@ int open_ctree(struct super_block *sb,
 	 * btrfs_start_workers can really only fail because of ENOMEM so just
 	 * return -ENOMEM if any of these fail.
 	 */
-	ret = btrfs_start_workers(&fs_info->workers);
-	ret |= btrfs_start_workers(&fs_info->generic_worker);
+	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->submit_workers);
 	ret |= btrfs_start_workers(&fs_info->delalloc_workers);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
@@ -2569,6 +2566,10 @@ int open_ctree(struct super_block *sb,
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
+	if (!(fs_info->workers)) {
+		err = -ENOMEM;
+		goto fail_sb_buffer;
+	}
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 97cc241..7039d3d7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1317,7 +1317,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	       old_pool_size, new_pool_size);
 
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
-	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
-- 
1.9.0

