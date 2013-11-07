Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab3KGFv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:27 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pFI6008344
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 14/17] btrfs: Replace fs_info->delayed_workers workqueue with btrfs_workqueue.
Date: Thu, 7 Nov 2013 13:52:04 +0800
Message-Id: <1383803527-23736-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->delayed_workers with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  None
---
 fs/btrfs/ctree.h         |  2 +-
 fs/btrfs/delayed-inode.c | 10 +++++-----
 fs/btrfs/disk-io.c       | 11 +++++------
 fs/btrfs/super.c         |  2 +-
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a01b399..3493010 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1503,7 +1503,7 @@ struct btrfs_fs_info {
 	 * for the sys_munmap function call path
 	 */
 	struct btrfs_workqueue_struct *fixup_workers;
-	struct btrfs_workers delayed_workers;
+	struct btrfs_workqueue_struct *delayed_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index cbd9523..76589ad 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1259,10 +1259,10 @@ void btrfs_remove_delayed_node(struct inode *inode)
 struct btrfs_async_delayed_work {
 	struct btrfs_delayed_root *delayed_root;
 	int nr;
-	struct btrfs_work work;
+	struct btrfs_work_struct  work;
 };
 
-static void btrfs_async_run_delayed_root(struct btrfs_work *work)
+static void btrfs_async_run_delayed_root(struct btrfs_work_struct *work)
 {
 	struct btrfs_async_delayed_work *async_work;
 	struct btrfs_delayed_root *delayed_root;
@@ -1360,11 +1360,11 @@ static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
 		return -ENOMEM;
 
 	async_work->delayed_root = delayed_root;
-	async_work->work.func = btrfs_async_run_delayed_root;
-	async_work->work.flags = 0;
+	btrfs_init_work(&async_work->work, btrfs_async_run_delayed_root,
+			NULL, NULL);
 	async_work->nr = nr;
 
-	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_work->work);
+	btrfs_queue_work(root->fs_info->delayed_workers, &async_work->work);
 	return 0;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ae8201c..4fc26d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2003,7 +2003,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->endio_write_workers);
 	btrfs_destroy_workqueue(fs_info->endio_freespace_worker);
 	btrfs_destroy_workqueue(fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->delayed_workers);
+	btrfs_destroy_workqueue(fs_info->delayed_workers);
 	btrfs_destroy_workqueue(fs_info->caching_workers);
 	btrfs_destroy_workqueue(fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
@@ -2533,9 +2533,9 @@ int open_ctree(struct super_block *sb,
 	fs_info->endio_freespace_worker =
 			btrfs_alloc_workqueue("freespace-write", NULL, NULL,
 					      flags, max_active, 0);
-	btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	fs_info->delayed_workers = btrfs_alloc_workqueue("delayed-meta",
+							 NULL, NULL, flags,
+							 max_active, 0);
 	fs_info->readahead_workers = btrfs_alloc_workqueue("readahead", NULL,
 							   NULL, flags,
 							   max_active, 2);
@@ -2548,7 +2548,6 @@ int open_ctree(struct super_block *sb,
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
 		err = -ENOMEM;
@@ -2561,7 +2560,7 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->readahead_workers &&
-	      fs_info->fixup_workers)) {
+	      fs_info->fixup_workers && fs_info->delayed_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 841a72c..8940015 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1256,7 +1256,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 				new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_write_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
-	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->delayed_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->readahead_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->scrub_wr_completion_workers,
 			      new_pool_size);
-- 
1.8.4.2

