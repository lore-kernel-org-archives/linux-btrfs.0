Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3KGFvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:22 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pE7l008340
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 06/17] btrfs: Replace fs_info->delalloc_workers with btrfs_workqueue
Date: Thu, 7 Nov 2013 13:51:56 +0800
Message-Id: <1383803527-23736-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Much like the fs_info->workers, replace the fs_info->delalloc_workers
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
 fs/btrfs/disk-io.c | 14 ++++++--------
 fs/btrfs/inode.c   | 18 ++++++++----------
 fs/btrfs/super.c   |  2 +-
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dbc6e2d..f38285e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1484,7 +1484,7 @@ struct btrfs_fs_info {
 	 */
 	struct btrfs_workers generic_worker;
 	struct btrfs_workqueue_struct *workers;
-	struct btrfs_workers delalloc_workers;
+	struct btrfs_workqueue_struct *delalloc_workers;
 	struct btrfs_workers flush_workers;
 	struct btrfs_workers endio_workers;
 	struct btrfs_workers endio_meta_workers;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a467044..ed2eb52 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1994,7 +1994,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
 	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_stop_workers(&fs_info->fixup_workers);
-	btrfs_stop_workers(&fs_info->delalloc_workers);
+	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
 	btrfs_stop_workers(&fs_info->endio_workers);
 	btrfs_stop_workers(&fs_info->endio_meta_workers);
@@ -2485,8 +2485,10 @@ int open_ctree(struct super_block *sb,
 						 "worker-high", flags,
 						 max_active, 16);
 
-	btrfs_init_workers(&fs_info->delalloc_workers, "delalloc",
-			   fs_info->thread_pool_size, NULL);
+	fs_info->delalloc_workers = btrfs_alloc_workqueue("delalloc",
+							  "delalloc-ordered",
+							  NULL, flags,
+							  max_active, 2);
 
 	btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
 			   fs_info->thread_pool_size, NULL);
@@ -2504,9 +2506,6 @@ int open_ctree(struct super_block *sb,
 	 */
 	fs_info->submit_workers.idle_thresh = 64;
 
-	fs_info->delalloc_workers.idle_thresh = 2;
-	fs_info->delalloc_workers.ordered = 1;
-
 	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
 			   &fs_info->generic_worker);
 	btrfs_init_workers(&fs_info->endio_workers, "endio",
@@ -2557,7 +2556,6 @@ int open_ctree(struct super_block *sb,
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->submit_workers);
-	ret |= btrfs_start_workers(&fs_info->delalloc_workers);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
 	ret |= btrfs_start_workers(&fs_info->endio_workers);
 	ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
@@ -2575,7 +2573,7 @@ int open_ctree(struct super_block *sb,
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
-	if (!(fs_info->workers)) {
+	if (!(fs_info->workers && fs_info->delalloc_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b4ffaf..42e3f81 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -306,7 +306,7 @@ struct async_cow {
 	u64 start;
 	u64 end;
 	struct list_head extents;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 };
 
 static noinline int add_async_extent(struct async_cow *cow,
@@ -978,7 +978,7 @@ out_unlock:
 /*
  * work queue call back to started compression on a file and pages
  */
-static noinline void async_cow_start(struct btrfs_work *work)
+static noinline void async_cow_start(struct btrfs_work_struct *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
@@ -996,7 +996,7 @@ static noinline void async_cow_start(struct btrfs_work *work)
 /*
  * work queue call back to submit previously compressed pages
  */
-static noinline void async_cow_submit(struct btrfs_work *work)
+static noinline void async_cow_submit(struct btrfs_work_struct *work)
 {
 	struct async_cow *async_cow;
 	struct btrfs_root *root;
@@ -1017,7 +1017,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 		submit_compressed_extents(async_cow->inode, async_cow);
 }
 
-static noinline void async_cow_free(struct btrfs_work *work)
+static noinline void async_cow_free(struct btrfs_work_struct *work)
 {
 	struct async_cow *async_cow;
 	async_cow = container_of(work, struct async_cow, work);
@@ -1054,17 +1054,15 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
 
-		async_cow->work.func = async_cow_start;
-		async_cow->work.ordered_func = async_cow_submit;
-		async_cow->work.ordered_free = async_cow_free;
-		async_cow->work.flags = 0;
+		btrfs_init_work(&async_cow->work, async_cow_start,
+				async_cow_submit, async_cow_free);
 
 		nr_pages = (cur_end - start + PAGE_CACHE_SIZE) >>
 			PAGE_CACHE_SHIFT;
 		atomic_add(nr_pages, &root->fs_info->async_delalloc_pages);
 
-		btrfs_queue_worker(&root->fs_info->delalloc_workers,
-				   &async_cow->work);
+		btrfs_queue_work(root->fs_info->delalloc_workers,
+				 &async_cow->work);
 
 		if (atomic_read(&root->fs_info->async_delalloc_pages) > limit) {
 			wait_event(root->fs_info->async_submit_wait,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 623be23..6f0d206 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1247,7 +1247,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
-- 
1.8.4.2

