Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43595 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab3JYLPT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 07:15:19 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r9PBFH61017422
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 19:15:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove scrub_super_lock holding in btrfs_sync_log()
Date: Fri, 25 Oct 2013 19:12:02 +0800
Message-Id: <1382699522-9741-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally, we introduced scrub_super_lock to synchronize
tree log code with scrubbing super.

However we can replace scrub_super_lock with device_list_mutex,
because writing super will hold this mutex, this will reduce an extra
lock holding when writing supers in sync log code.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
The idea comes from miao's suggestion with my previous patch.(though it
addressed a not existed problem)
---
 fs/btrfs/ctree.h    |  3 ---
 fs/btrfs/disk-io.c  |  1 -
 fs/btrfs/scrub.c    | 18 +++++-------------
 fs/btrfs/tree-log.c |  2 --
 fs/btrfs/volumes.h  |  4 +++-
 5 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0a008d8..941019d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1588,7 +1588,6 @@ struct btrfs_fs_info {
 	atomic_t scrubs_paused;
 	atomic_t scrub_cancel_req;
 	wait_queue_head_t scrub_pause_wait;
-	struct rw_semaphore scrub_super_lock;
 	int scrub_workers_refcnt;
 	struct btrfs_workers scrub_workers;
 	struct btrfs_workers scrub_wr_completion_workers;
@@ -3952,9 +3951,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		    u64 end, struct btrfs_scrub_progress *progress,
 		    int readonly, int is_dev_replace);
 void btrfs_scrub_pause(struct btrfs_root *root);
-void btrfs_scrub_pause_super(struct btrfs_root *root);
 void btrfs_scrub_continue(struct btrfs_root *root);
-void btrfs_scrub_continue_super(struct btrfs_root *root);
 int btrfs_scrub_cancel(struct btrfs_fs_info *info);
 int btrfs_scrub_cancel_dev(struct btrfs_fs_info *info,
 			   struct btrfs_device *dev);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62c4aba..a3ad3a2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2250,7 +2250,6 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->scrubs_paused, 0);
 	atomic_set(&fs_info->scrub_cancel_req, 0);
 	init_waitqueue_head(&fs_info->scrub_pause_wait);
-	init_rwsem(&fs_info->scrub_super_lock);
 	fs_info->scrub_workers_refcnt = 0;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	fs_info->check_integrity_print_mask = 0;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f21e2df..12009b4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2932,13 +2932,15 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	if (!is_dev_replace) {
-		down_read(&fs_info->scrub_super_lock);
+		/*
+		 * by holding device list mutex, we can
+		 * kick off writing super in log tree sync.
+		 */
 		ret = scrub_supers(sctx, dev);
-		up_read(&fs_info->scrub_super_lock);
 	}
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	if (!ret)
 		ret = scrub_enumerate_chunks(sctx, dev, start, end,
@@ -2988,16 +2990,6 @@ void btrfs_scrub_continue(struct btrfs_root *root)
 	wake_up(&fs_info->scrub_pause_wait);
 }
 
-void btrfs_scrub_pause_super(struct btrfs_root *root)
-{
-	down_write(&root->fs_info->scrub_super_lock);
-}
-
-void btrfs_scrub_continue_super(struct btrfs_root *root)
-{
-	up_write(&root->fs_info->scrub_super_lock);
-}
-
 int btrfs_scrub_cancel(struct btrfs_fs_info *fs_info)
 {
 	mutex_lock(&fs_info->scrub_lock);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2ff031a..ef80ce0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2586,9 +2586,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * the running transaction open, so a full commit can't hop
 	 * in and cause problems either.
 	 */
-	btrfs_scrub_pause_super(root);
 	ret = write_ctree_super(trans, root->fs_info->tree_root, 1);
-	btrfs_scrub_continue_super(root);
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
 		goto out_wake_log_root;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b72f540..49e0ff0 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -132,7 +132,9 @@ struct btrfs_fs_devices {
 
 	/* all of the devices in the FS, protected by a mutex
 	 * so we can safely walk it to write out the supers without
-	 * worrying about add/remove by the multi-device code
+	 * worrying about add/remove by the multi-device code.
+	 * Scrubbing super can kick off supers writing by holding
+	 * this mutex lock.
 	 */
 	struct mutex device_list_mutex;
 	struct list_head devices;
-- 
1.8.3.1

