Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaB1Cpb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 21:45:31 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1S2jIIw017664
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 10:45:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 13/18] btrfs: Replace fs_info->fixup_workers workqueue with btrfs_workqueue.
Date: Fri, 28 Feb 2014 10:46:14 +0800
Message-Id: <1393555579-11271-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->fixup_workers with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Tested-by: David Sterba <dsterba@suse.cz>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace submit_workers.
v3->v4:
  - Use the simplified btrfs_alloc_workqueue API.
v4->v5:
  None
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 10 +++++-----
 fs/btrfs/inode.c   |  8 ++++----
 fs/btrfs/super.c   |  1 -
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3d6f490..95a1e66 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1524,7 +1524,7 @@ struct btrfs_fs_info {
 	 * the cow mechanism and make them safe to write.  It happens
 	 * for the sys_munmap function call path
 	 */
-	struct btrfs_workers fixup_workers;
+	struct btrfs_workqueue_struct *fixup_workers;
 	struct btrfs_workers delayed_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ca6d0cf..4da34df 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1991,7 +1991,7 @@ static noinline int next_root_backup(struct btrfs_fs_info *info,
 static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
 	btrfs_stop_workers(&fs_info->generic_worker);
-	btrfs_stop_workers(&fs_info->fixup_workers);
+	btrfs_destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
 	btrfs_destroy_workqueue(fs_info->endio_workers);
@@ -2494,8 +2494,8 @@ int open_ctree(struct super_block *sb,
 				      min_t(u64, fs_devices->num_devices,
 					    max_active), 64);
 
-	btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
-			   &fs_info->generic_worker);
+	fs_info->fixup_workers =
+		btrfs_alloc_workqueue("fixup", flags, 1, 0);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -2528,7 +2528,6 @@ int open_ctree(struct super_block *sb,
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->fixup_workers);
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
@@ -2541,7 +2540,8 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_meta_write_workers &&
 	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
-	      fs_info->caching_workers && fs_info->readahead_workers)) {
+	      fs_info->caching_workers && fs_info->readahead_workers &&
+	      fs_info->fixup_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4023c90..81395d6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1748,10 +1748,10 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 /* see btrfs_writepage_start_hook for details on why this is required */
 struct btrfs_writepage_fixup {
 	struct page *page;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 };
 
-static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
+static void btrfs_writepage_fixup_worker(struct btrfs_work_struct *work)
 {
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
@@ -1842,9 +1842,9 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 
 	SetPageChecked(page);
 	page_cache_get(page);
-	fixup->work.func = btrfs_writepage_fixup_worker;
+	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL, NULL);
 	fixup->page = page;
-	btrfs_queue_worker(&root->fs_info->fixup_workers, &fixup->work);
+	btrfs_queue_work(root->fs_info->fixup_workers, &fixup->work);
 	return -EBUSY;
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 56c5533..3614053 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1321,7 +1321,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->submit_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_meta_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_meta_write_workers,
-- 
1.9.0

