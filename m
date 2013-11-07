Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab3KGFva (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:30 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pGja008358
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 16/17] btrfs: Replace fs_info->scrub_* workqueue with btrfs_workqueue.
Date: Thu, 7 Nov 2013 13:52:06 +0800
Message-Id: <1383803527-23736-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->scrub_* with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace scrub_*.
---
 fs/btrfs/ctree.h |  6 ++--
 fs/btrfs/scrub.c | 94 ++++++++++++++++++++++++++++++--------------------------
 fs/btrfs/super.c |  4 +--
 3 files changed, 56 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2e7e6a4..1da2f33 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1582,9 +1582,9 @@ struct btrfs_fs_info {
 	wait_queue_head_t scrub_pause_wait;
 	struct rw_semaphore scrub_super_lock;
 	int scrub_workers_refcnt;
-	struct btrfs_workers scrub_workers;
-	struct btrfs_workers scrub_wr_completion_workers;
-	struct btrfs_workers scrub_nocow_workers;
+	struct btrfs_workqueue_struct *scrub_workers;
+	struct btrfs_workqueue_struct *scrub_wr_completion_workers;
+	struct btrfs_workqueue_struct *scrub_nocow_workers;
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	u32 check_integrity_print_mask;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a18e0e2..e3cd62f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -96,7 +96,8 @@ struct scrub_bio {
 #endif
 	int			page_count;
 	int			next_free;
-	struct btrfs_work	work;
+	struct btrfs_work_struct
+				work;
 };
 
 struct scrub_block {
@@ -154,7 +155,8 @@ struct scrub_fixup_nodatasum {
 	struct btrfs_device	*dev;
 	u64			logical;
 	struct btrfs_root	*root;
-	struct btrfs_work	work;
+	struct btrfs_work_struct
+				work;
 	int			mirror_num;
 };
 
@@ -172,7 +174,8 @@ struct scrub_copy_nocow_ctx {
 	int			mirror_num;
 	u64			physical_for_dev_replace;
 	struct list_head	inodes;
-	struct btrfs_work	work;
+	struct btrfs_work_struct
+				work;
 };
 
 struct scrub_warning {
@@ -232,7 +235,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 gen, int mirror_num, u8 *csum, int force,
 		       u64 physical_for_dev_replace);
 static void scrub_bio_end_io(struct bio *bio, int err);
-static void scrub_bio_end_io_worker(struct btrfs_work *work);
+static void scrub_bio_end_io_worker(struct btrfs_work_struct *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       u64 extent_logical, u64 extent_len,
@@ -249,14 +252,14 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage);
 static void scrub_wr_submit(struct scrub_ctx *sctx);
 static void scrub_wr_bio_end_io(struct bio *bio, int err);
-static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
+static void scrub_wr_bio_end_io_worker(struct btrfs_work_struct *work);
 static int write_page_nocow(struct scrub_ctx *sctx,
 			    u64 physical_for_dev_replace, struct page *page);
 static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 				      struct scrub_copy_nocow_ctx *ctx);
 static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			    int mirror_num, u64 physical_for_dev_replace);
-static void copy_nocow_pages_worker(struct btrfs_work *work);
+static void copy_nocow_pages_worker(struct btrfs_work_struct *work);
 
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
@@ -394,7 +397,8 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 		sbio->index = i;
 		sbio->sctx = sctx;
 		sbio->page_count = 0;
-		sbio->work.func = scrub_bio_end_io_worker;
+		btrfs_init_work(&sbio->work, scrub_bio_end_io_worker,
+				NULL, NULL);
 
 		if (i != SCRUB_BIOS_PER_SCTX - 1)
 			sctx->bios[i]->next_free = i + 1;
@@ -699,7 +703,7 @@ out:
 	return -EIO;
 }
 
-static void scrub_fixup_nodatasum(struct btrfs_work *work)
+static void scrub_fixup_nodatasum(struct btrfs_work_struct *work)
 {
 	int ret;
 	struct scrub_fixup_nodatasum *fixup;
@@ -963,9 +967,10 @@ nodatasum_case:
 		fixup_nodatasum->root = fs_info->extent_root;
 		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
 		scrub_pending_trans_workers_inc(sctx);
-		fixup_nodatasum->work.func = scrub_fixup_nodatasum;
-		btrfs_queue_worker(&fs_info->scrub_workers,
-				   &fixup_nodatasum->work);
+		btrfs_init_work(&fixup_nodatasum->work, scrub_fixup_nodatasum,
+				NULL, NULL);
+		btrfs_queue_work(fs_info->scrub_workers,
+				 &fixup_nodatasum->work);
 		goto out;
 	}
 
@@ -1597,11 +1602,11 @@ static void scrub_wr_bio_end_io(struct bio *bio, int err)
 	sbio->err = err;
 	sbio->bio = bio;
 
-	sbio->work.func = scrub_wr_bio_end_io_worker;
-	btrfs_queue_worker(&fs_info->scrub_wr_completion_workers, &sbio->work);
+	btrfs_init_work(&sbio->work, scrub_wr_bio_end_io_worker, NULL, NULL);
+	btrfs_queue_work(fs_info->scrub_wr_completion_workers, &sbio->work);
 }
 
-static void scrub_wr_bio_end_io_worker(struct btrfs_work *work)
+static void scrub_wr_bio_end_io_worker(struct btrfs_work_struct *work)
 {
 	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
 	struct scrub_ctx *sctx = sbio->sctx;
@@ -2066,10 +2071,10 @@ static void scrub_bio_end_io(struct bio *bio, int err)
 	sbio->err = err;
 	sbio->bio = bio;
 
-	btrfs_queue_worker(&fs_info->scrub_workers, &sbio->work);
+	btrfs_queue_work(fs_info->scrub_workers, &sbio->work);
 }
 
-static void scrub_bio_end_io_worker(struct btrfs_work *work)
+static void scrub_bio_end_io_worker(struct btrfs_work_struct *work)
 {
 	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
 	struct scrub_ctx *sctx = sbio->sctx;
@@ -2782,34 +2787,37 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 						int is_dev_replace)
 {
 	int ret = 0;
+	int flags = WQ_FREEZABLE;
+	int max_active = fs_info->thread_pool_size;
 
 	mutex_lock(&fs_info->scrub_lock);
 	if (fs_info->scrub_workers_refcnt == 0) {
 		if (is_dev_replace)
-			btrfs_init_workers(&fs_info->scrub_workers, "scrub", 1,
-					&fs_info->generic_worker);
+			fs_info->scrub_workers =
+				btrfs_alloc_workqueue("scrub", NULL, NULL,
+						      flags, 1, 4);
 		else
-			btrfs_init_workers(&fs_info->scrub_workers, "scrub",
-					fs_info->thread_pool_size,
-					&fs_info->generic_worker);
-		fs_info->scrub_workers.idle_thresh = 4;
-		ret = btrfs_start_workers(&fs_info->scrub_workers);
-		if (ret)
+			fs_info->scrub_workers =
+				btrfs_alloc_workqueue("scrub", NULL, NULL,
+						      flags, max_active, 4);
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
+			btrfs_alloc_workqueue("scrubwrc", NULL, NULL, flags,
+					      max_active, 2);
+		if (!fs_info->scrub_wr_completion_workers) {
+			ret = -ENOMEM;
 			goto out;
-		btrfs_init_workers(&fs_info->scrub_nocow_workers, "scrubnc", 1,
-				   &fs_info->generic_worker);
-		ret = btrfs_start_workers(&fs_info->scrub_nocow_workers);
-		if (ret)
+		}
+		fs_info->scrub_nocow_workers =
+			btrfs_alloc_workqueue("scrubnc", NULL, NULL, flags,
+					      1, 0);
+		if (!fs_info->scrub_nocow_workers) {
+			ret = -ENOMEM;
 			goto out;
+		}
 	}
 	++fs_info->scrub_workers_refcnt;
 out:
@@ -2822,9 +2830,9 @@ static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
 {
 	mutex_lock(&fs_info->scrub_lock);
 	if (--fs_info->scrub_workers_refcnt == 0) {
-		btrfs_stop_workers(&fs_info->scrub_workers);
-		btrfs_stop_workers(&fs_info->scrub_wr_completion_workers);
-		btrfs_stop_workers(&fs_info->scrub_nocow_workers);
+		btrfs_destroy_workqueue(fs_info->scrub_workers);
+		btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
+		btrfs_destroy_workqueue(fs_info->scrub_nocow_workers);
 	}
 	WARN_ON(fs_info->scrub_workers_refcnt < 0);
 	mutex_unlock(&fs_info->scrub_lock);
@@ -3133,10 +3141,10 @@ static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	nocow_ctx->len = len;
 	nocow_ctx->mirror_num = mirror_num;
 	nocow_ctx->physical_for_dev_replace = physical_for_dev_replace;
-	nocow_ctx->work.func = copy_nocow_pages_worker;
+	btrfs_init_work(&nocow_ctx->work, copy_nocow_pages_worker, NULL, NULL);
 	INIT_LIST_HEAD(&nocow_ctx->inodes);
-	btrfs_queue_worker(&fs_info->scrub_nocow_workers,
-			   &nocow_ctx->work);
+	btrfs_queue_work(fs_info->scrub_nocow_workers,
+			 &nocow_ctx->work);
 
 	return 0;
 }
@@ -3158,7 +3166,7 @@ static int record_inode_for_nocow(u64 inum, u64 offset, u64 root, void *ctx)
 
 #define COPY_COMPLETE 1
 
-static void copy_nocow_pages_worker(struct btrfs_work *work)
+static void copy_nocow_pages_worker(struct btrfs_work_struct *work)
 {
 	struct scrub_copy_nocow_ctx *nocow_ctx =
 		container_of(work, struct scrub_copy_nocow_ctx, work);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8940015..65bfbdf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1258,8 +1258,8 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delayed_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->readahead_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->scrub_wr_completion_workers,
-			      new_pool_size);
+	btrfs_workqueue_set_max(fs_info->scrub_wr_completion_workers,
+				new_pool_size);
 }
 
 static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info)
-- 
1.8.4.2

