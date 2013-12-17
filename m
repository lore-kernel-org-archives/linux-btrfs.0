Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:44210 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3LQJc0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:26 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBH9V6ER027097
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 17:31:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4 14/18] btrfs: Replace fs_info->delayed_workers workqueue with btrfs_workqueue.
Date: Tue, 17 Dec 2013 17:31:55 +0800
Message-Id: <1387272719-11889-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v3->v4:
  - Use the simplified btrfs_alloc_workqueue API.
---
 fs/btrfs/ctree.h         |  2 +-
 fs/btrfs/delayed-inode.c | 10 +++++-----
 fs/btrfs/disk-io.c       | 10 ++++------
 fs/btrfs/super.c         |  2 +-
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 845615e..698cebc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1509,7 +1509,7 @@ struct btrfs_fs_info {
 	 * for the sys_munmap function call path
 	 */
 	struct btrfs_workqueue_struct *fixup_workers;
-	struct btrfs_workers delayed_workers;
+	struct btrfs_workqueue_struct *delayed_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 8d292fb..e4ad5ea 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1260,10 +1260,10 @@ void btrfs_remove_delayed_node(struct inode *inode)
 struct btrfs_async_delayed_work {
 	struct btrfs_delayed_root *delayed_root;
 	int nr;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 };
 
-static void btrfs_async_run_delayed_root(struct btrfs_work *work)
+static void btrfs_async_run_delayed_root(struct btrfs_work_struct *work)
 {
 	struct btrfs_async_delayed_work *async_work;
 	struct btrfs_delayed_root *delayed_root;
@@ -1361,11 +1361,11 @@ static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
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
index e5dec5a..9053df8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2017,7 +2017,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->endio_write_workers);
 	btrfs_destroy_workqueue(fs_info->endio_freespace_worker);
 	btrfs_destroy_workqueue(fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->delayed_workers);
+	btrfs_destroy_workqueue(fs_info->delayed_workers);
 	btrfs_destroy_workqueue(fs_info->caching_workers);
 	btrfs_destroy_workqueue(fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
@@ -2515,9 +2515,8 @@ int open_ctree(struct super_block *sb,
 		btrfs_alloc_workqueue("endio-write", flags, max_active, 2);
 	fs_info->endio_freespace_worker =
 		btrfs_alloc_workqueue("freespace-write", flags, max_active, 0);
-	btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	fs_info->delayed_workers =
+		btrfs_alloc_workqueue("delayed-meta", flags, max_active, 0);
 	fs_info->readahead_workers =
 		btrfs_alloc_workqueue("readahead", flags, max_active, 2);
 	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
@@ -2528,7 +2527,6 @@ int open_ctree(struct super_block *sb,
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
 		err = -ENOMEM;
@@ -2541,7 +2539,7 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->readahead_workers &&
-	      fs_info->fixup_workers)) {
+	      fs_info->fixup_workers && fs_info->delayed_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f7fd00c..83d3477 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1255,7 +1255,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 				new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_write_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
-	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->delayed_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->readahead_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->scrub_wr_completion_workers,
 			      new_pool_size);
-- 
1.8.5.1

