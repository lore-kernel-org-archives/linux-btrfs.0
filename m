Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65474 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3KGFv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:28 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pFA3008341
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 15/17] btrfs: Replace fs_info->qgroup_rescan_worker workqueue with btrfs_workqueue.
Date: Thu, 7 Nov 2013 13:52:05 +0800
Message-Id: <1383803527-23736-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->qgroup_rescan_worker with the newly created
btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace qgroup_rescan_workers.
---
 fs/btrfs/ctree.h   |  4 ++--
 fs/btrfs/disk-io.c | 12 ++++++------
 fs/btrfs/qgroup.c  | 17 +++++++++--------
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3493010..2e7e6a4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1625,9 +1625,9 @@ struct btrfs_fs_info {
 	/* qgroup rescan items */
 	struct mutex qgroup_rescan_lock; /* protects the progress item */
 	struct btrfs_key qgroup_rescan_progress;
-	struct btrfs_workers qgroup_rescan_workers;
+	struct btrfs_workqueue_struct *qgroup_rescan_workers;
 	struct completion qgroup_rescan_completion;
-	struct btrfs_work qgroup_rescan_work;
+	struct btrfs_work_struct qgroup_rescan_work;
 
 	/* filesystem state */
 	unsigned long fs_state;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4fc26d2..6950570 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2007,7 +2007,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->caching_workers);
 	btrfs_destroy_workqueue(fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
-	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
+	btrfs_destroy_workqueue(fs_info->qgroup_rescan_workers);
 }
 
 /* helper to cleanup tree roots */
@@ -2539,16 +2539,15 @@ int open_ctree(struct super_block *sb,
 	fs_info->readahead_workers = btrfs_alloc_workqueue("readahead", NULL,
 							   NULL, flags,
 							   max_active, 2);
-	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
-			   &fs_info->generic_worker);
-
+	fs_info->qgroup_rescan_workers =
+			btrfs_alloc_workqueue("qgroup-rescan", NULL, NULL,
+					      flags, 1, 0);
 
 	/*
 	 * btrfs_start_workers can really only fail because of ENOMEM so just
 	 * return -ENOMEM if any of these fail.
 	 */
 	ret = btrfs_start_workers(&fs_info->generic_worker);
-	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
@@ -2560,7 +2559,8 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->readahead_workers &&
-	      fs_info->fixup_workers && fs_info->delayed_workers)) {
+	      fs_info->fixup_workers && fs_info->delayed_workers &&
+	      fs_info->qgroup_rescan_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e6ef49..521144e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1516,8 +1516,8 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		ret = qgroup_rescan_init(fs_info, 0, 1);
 		if (!ret) {
 			qgroup_rescan_zero_tracking(fs_info);
-			btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
-					   &fs_info->qgroup_rescan_work);
+			btrfs_queue_work(fs_info->qgroup_rescan_workers,
+					 &fs_info->qgroup_rescan_work);
 		}
 		ret = 0;
 	}
@@ -1981,7 +1981,7 @@ out:
 	return ret;
 }
 
-static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
+static void btrfs_qgroup_rescan_worker(struct btrfs_work_struct *work)
 {
 	struct btrfs_fs_info *fs_info = container_of(work, struct btrfs_fs_info,
 						     qgroup_rescan_work);
@@ -2092,7 +2092,8 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	memset(&fs_info->qgroup_rescan_work, 0,
 	       sizeof(fs_info->qgroup_rescan_work));
-	fs_info->qgroup_rescan_work.func = btrfs_qgroup_rescan_worker;
+	btrfs_init_work(&fs_info->qgroup_rescan_work,
+			btrfs_qgroup_rescan_worker, NULL, NULL);
 
 	if (ret) {
 err:
@@ -2155,8 +2156,8 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 
 	qgroup_rescan_zero_tracking(fs_info);
 
-	btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
-			   &fs_info->qgroup_rescan_work);
+	btrfs_queue_work(fs_info->qgroup_rescan_workers,
+			 &fs_info->qgroup_rescan_work);
 
 	return 0;
 }
@@ -2187,6 +2188,6 @@ void
 btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 {
 	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
-		btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
-				   &fs_info->qgroup_rescan_work);
+		btrfs_queue_work(fs_info->qgroup_rescan_workers,
+				 &fs_info->qgroup_rescan_work);
 }
-- 
1.8.4.2

