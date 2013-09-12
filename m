Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab3ILIIG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 04:08:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8C87c4W015390
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 16:07:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v2 6/9] btrfs: Use btrfs_workqueue_struct to replace the fs_info->delalloc_workers
Date: Thu, 12 Sep 2013 16:08:21 +0800
Message-Id: <1378973304-11693-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Much like the fs_info->workers, replace the fs_info->delalloc_workers
use the same btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 13 +++++--------
 fs/btrfs/inode.c   | 19 +++++++++----------
 fs/btrfs/super.c   |  2 +-
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2662ef2..81aba0e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1477,10 +1477,10 @@ struct btrfs_fs_info {
 	 * two
 	 */
 	struct btrfs_workers generic_worker;
-	struct btrfs_workers delalloc_workers;
 	struct btrfs_workers submit_workers;
 
 	struct btrfs_workqueue_struct *workers;
+	struct btrfs_workqueue_struct *delalloc_workers;
 	struct workqueue_struct *flush_workers;
 	struct workqueue_struct *endio_workers;
 	struct workqueue_struct *endio_meta_workers;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 364c409..fd795b6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1985,7 +1985,7 @@ static noinline int next_root_backup(struct btrfs_fs_info *info,
 static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
 	btrfs_stop_workers(&fs_info->generic_worker);
-	btrfs_stop_workers(&fs_info->delalloc_workers);
+	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
 	btrfs_stop_workers(&fs_info->submit_workers);
 	destroy_workqueue(fs_info->fixup_workers);
@@ -2464,9 +2464,9 @@ int open_ctree(struct super_block *sb,
 	fs_info->workers = btrfs_alloc_workqueue("worker", "worker-ordered",
 						 "worker-high", max_active);
 
-	btrfs_init_workers(&fs_info->delalloc_workers, "delalloc",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	fs_info->delalloc_workers = btrfs_alloc_workqueue("delalloc",
+							  "delalloc-ordered",
+							  NULL, max_active);
 
 	fs_info->flush_workers = alloc_workqueue("flush_delalloc", flags,
 						 max_active);
@@ -2476,9 +2476,6 @@ int open_ctree(struct super_block *sb,
 			   &fs_info->generic_worker);
 	fs_info->caching_workers = alloc_workqueue("cache", flags, 2);
 
-	fs_info->delalloc_workers.idle_thresh = 2;
-	fs_info->delalloc_workers.ordered = 1;
-
 	fs_info->fixup_workers = alloc_workqueue("fixup", flags, 1);
 	fs_info->endio_workers = alloc_workqueue("endio", flags, max_active);
 	fs_info->endio_meta_workers = alloc_workqueue("endio-meta", flags,
@@ -2503,11 +2500,11 @@ int open_ctree(struct super_block *sb,
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->delalloc_workers);
 	ret |= btrfs_start_workers(&fs_info->submit_workers);
 
 	if (ret || !(fs_info->flush_workers && fs_info->endio_workers &&
 		     fs_info->endio_meta_workers && fs_info->workers &&
+		     fs_info->delalloc_workers &&
 		     fs_info->endio_raid56_workers &&
 		     fs_info->rmw_workers && fs_info->qgroup_rescan_workers &&
 		     fs_info->endio_meta_write_workers &&
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 53901a5..0ae21a6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -59,6 +59,7 @@
 #include "inode-map.h"
 #include "backref.h"
 #include "hash.h"
+#include "bwq.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -295,7 +296,7 @@ struct async_cow {
 	u64 start;
 	u64 end;
 	struct list_head extents;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 };
 
 static noinline int add_async_extent(struct async_cow *cow,
@@ -1057,7 +1058,7 @@ static noinline int cow_file_range(struct inode *inode,
 /*
  * work queue call back to started compression on a file and pages
  */
-static noinline void async_cow_start(struct btrfs_work *work)
+static noinline void async_cow_start(struct btrfs_work_struct *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
@@ -1075,7 +1076,7 @@ static noinline void async_cow_start(struct btrfs_work *work)
 /*
  * work queue call back to submit previously compressed pages
  */
-static noinline void async_cow_submit(struct btrfs_work *work)
+static noinline void async_cow_submit(struct btrfs_work_struct *work)
 {
 	struct async_cow *async_cow;
 	struct btrfs_root *root;
@@ -1096,7 +1097,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 		submit_compressed_extents(async_cow->inode, async_cow);
 }
 
-static noinline void async_cow_free(struct btrfs_work *work)
+static noinline void async_cow_free(struct btrfs_work_struct *work)
 {
 	struct async_cow *async_cow;
 	async_cow = container_of(work, struct async_cow, work);
@@ -1133,17 +1134,15 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
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
index 8fe41f9..771b98a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1176,7 +1176,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->caching_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->fixup_workers, new_pool_size);
-- 
1.8.4

