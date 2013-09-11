Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8360 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3IKIwC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 04:52:02 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8B8prI5019959
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 16:51:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 5/9] btrfs: Use btrfs_workqueue_struct to replace the fs_info->workers
Date: Wed, 11 Sep 2013 16:52:34 +0800
Message-Id: <1378889558-21514-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the newly created btrfs_workqueue_struct to replace the original
fs_info->workers

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 36 +++++++++++++++---------------------
 fs/btrfs/super.c   |  3 ++-
 3 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0dd6ec9..2662ef2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1477,10 +1477,10 @@ struct btrfs_fs_info {
 	 * two
 	 */
 	struct btrfs_workers generic_worker;
-	struct btrfs_workers workers;
 	struct btrfs_workers delalloc_workers;
 	struct btrfs_workers submit_workers;
 
+	struct btrfs_workqueue_struct *workers;
 	struct workqueue_struct *flush_workers;
 	struct workqueue_struct *endio_workers;
 	struct workqueue_struct *endio_meta_workers;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0f44828..fb9b760 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -48,6 +48,7 @@
 #include "rcu-string.h"
 #include "dev-replace.h"
 #include "raid56.h"
+#include "bwq.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -108,7 +109,7 @@ struct async_submit_bio {
 	 * can't tell us where in the file the bio should go
 	 */
 	u64 bio_offset;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 	int error;
 };
 
@@ -751,12 +752,12 @@ int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
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
@@ -769,7 +770,7 @@ static void run_one_async_start(struct btrfs_work *work)
 		async->error = ret;
 }
 
-static void run_one_async_done(struct btrfs_work *work)
+static void run_one_async_done(struct btrfs_work_struct *work)
 {
 	struct btrfs_fs_info *fs_info;
 	struct async_submit_bio *async;
@@ -796,7 +797,7 @@ static void run_one_async_done(struct btrfs_work *work)
 			       async->bio_offset);
 }
 
-static void run_one_async_free(struct btrfs_work *work)
+static void run_one_async_free(struct btrfs_work_struct *work)
 {
 	struct async_submit_bio *async;
 
@@ -824,11 +825,9 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
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
 
@@ -837,9 +836,9 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 	atomic_inc(&fs_info->nr_async_submits);
 
 	if (rw & REQ_SYNC)
-		btrfs_set_work_high_prio(&async->work);
+		btrfs_set_work_high_priority(&async->work);
 
-	btrfs_queue_worker(&fs_info->workers, &async->work);
+	btrfs_queue_work(fs_info->workers, &async->work);
 
 	while (atomic_read(&fs_info->async_submit_draining) &&
 	      atomic_read(&fs_info->nr_async_submits)) {
@@ -1987,7 +1986,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
 	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
-	btrfs_stop_workers(&fs_info->workers);
+	btrfs_destroy_workqueue(fs_info->workers);
 	btrfs_stop_workers(&fs_info->submit_workers);
 	destroy_workqueue(fs_info->fixup_workers);
 	destroy_workqueue(fs_info->endio_workers);
@@ -2462,9 +2461,8 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->generic_worker,
 			   "genwork", 1, NULL);
 
-	btrfs_init_workers(&fs_info->workers, "worker",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	fs_info->workers = btrfs_alloc_workqueue("worker", "worker-ordered",
+						 "worker-high", max_active);
 
 	btrfs_init_workers(&fs_info->delalloc_workers, "delalloc",
 			   fs_info->thread_pool_size,
@@ -2478,9 +2476,6 @@ int open_ctree(struct super_block *sb,
 			   &fs_info->generic_worker);
 	fs_info->caching_workers = alloc_workqueue("cache", flags, 2);
 
-	fs_info->workers.idle_thresh = 16;
-	fs_info->workers.ordered = 1;
-
 	fs_info->delalloc_workers.idle_thresh = 2;
 	fs_info->delalloc_workers.ordered = 1;
 
@@ -2507,13 +2502,12 @@ int open_ctree(struct super_block *sb,
 	 * btrfs_start_workers can really only fail because of ENOMEM so just
 	 * return -ENOMEM if any of these fail.
 	 */
-	ret = btrfs_start_workers(&fs_info->workers);
-	ret |= btrfs_start_workers(&fs_info->generic_worker);
+	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->delalloc_workers);
 	ret |= btrfs_start_workers(&fs_info->submit_workers);
 
 	if (ret || !(fs_info->flush_workers && fs_info->endio_workers &&
-		     fs_info->endio_meta_workers &&
+		     fs_info->endio_meta_workers && fs_info->workers &&
 		     fs_info->endio_raid56_workers &&
 		     fs_info->rmw_workers &&
 		     fs_info->endio_meta_write_workers &&
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f557ab6..8fe41f9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -56,6 +56,7 @@
 #include "rcu-string.h"
 #include "dev-replace.h"
 #include "free-space-cache.h"
+#include "bwq.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1174,7 +1175,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	       old_pool_size, new_pool_size);
 
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
-	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->caching_workers, new_pool_size);
-- 
1.8.4

