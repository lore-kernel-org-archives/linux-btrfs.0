Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:44210 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3LQJcC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:02 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBH9VHVW027153
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 17:31:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4 12/18] btrfs: Replace fs_info->readahead_workers workqueue with btrfs_workqueue.
Date: Tue, 17 Dec 2013 17:31:53 +0800
Message-Id: <1387272719-11889-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->readahead_workers with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace readahead_workers.
v3->v4:
  - Use the simplified btrfs_alloc_workqueue API.
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c | 12 ++++--------
 fs/btrfs/reada.c   |  9 +++++----
 fs/btrfs/super.c   |  2 +-
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8630986..302dc46 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1501,7 +1501,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue_struct *endio_freespace_worker;
 	struct btrfs_workqueue_struct *submit_workers;
 	struct btrfs_workqueue_struct *caching_workers;
-	struct btrfs_workers readahead_workers;
+	struct btrfs_workqueue_struct *readahead_workers;
 
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d8f42d2..4d49d87 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2019,7 +2019,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_destroy_workqueue(fs_info->caching_workers);
-	btrfs_stop_workers(&fs_info->readahead_workers);
+	btrfs_destroy_workqueue(fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
 	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
 }
@@ -2518,14 +2518,11 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
-	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+	fs_info->readahead_workers =
+		btrfs_alloc_workqueue("readahead", flags, max_active, 2);
 	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
 			   &fs_info->generic_worker);
 
-	fs_info->readahead_workers.idle_thresh = 2;
-
 	/*
 	 * btrfs_start_workers can really only fail because of ENOMEM so just
 	 * return -ENOMEM if any of these fail.
@@ -2533,7 +2530,6 @@ int open_ctree(struct super_block *sb,
 	ret = btrfs_start_workers(&fs_info->generic_worker);
 	ret |= btrfs_start_workers(&fs_info->fixup_workers);
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
-	ret |= btrfs_start_workers(&fs_info->readahead_workers);
 	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
 		err = -ENOMEM;
@@ -2545,7 +2541,7 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_meta_write_workers &&
 	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
-	      fs_info->caching_workers)) {
+	      fs_info->caching_workers && fs_info->readahead_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 1031b69..854b69a 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -91,7 +91,8 @@ struct reada_zone {
 };
 
 struct reada_machine_work {
-	struct btrfs_work	work;
+	struct btrfs_work_struct
+				work;
 	struct btrfs_fs_info	*fs_info;
 };
 
@@ -732,7 +733,7 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 
 }
 
-static void reada_start_machine_worker(struct btrfs_work *work)
+static void reada_start_machine_worker(struct btrfs_work_struct *work)
 {
 	struct reada_machine_work *rmw;
 	struct btrfs_fs_info *fs_info;
@@ -792,10 +793,10 @@ static void reada_start_machine(struct btrfs_fs_info *fs_info)
 		/* FIXME we cannot handle this properly right now */
 		BUG();
 	}
-	rmw->work.func = reada_start_machine_worker;
+	btrfs_init_work(&rmw->work, reada_start_machine_worker, NULL, NULL);
 	rmw->fs_info = fs_info;
 
-	btrfs_queue_worker(&fs_info->readahead_workers, &rmw->work);
+	btrfs_queue_work(fs_info->readahead_workers, &rmw->work);
 }
 
 #ifdef DEBUG
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5bfe566..7a46e23 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1257,7 +1257,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_workqueue_set_max(fs_info->endio_write_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
 	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
+	btrfs_workqueue_set_max(fs_info->readahead_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->scrub_wr_completion_workers,
 			      new_pool_size);
 }
-- 
1.8.5.1

