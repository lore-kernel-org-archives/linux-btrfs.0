Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaBTKHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:36 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7XQb011821
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] Btrfs: fix the skipped transaction commit during the file sync
Date: Thu, 20 Feb 2014 18:08:52 +0800
Message-Id: <1392890939-19044-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We may abort the wait earlier if ->last_trans_log_full_commit was set to
the current transaction id, at this case, we need commit the current
transaction instead of the log sub-transaction. But the current code
didn't tell the caller to do it (return 0, not -EAGAIN). Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5a4e10b..8a03b39 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2364,6 +2364,7 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 {
 	DEFINE_WAIT(wait);
 	int index = transid % 2;
+	int ret = 0;
 
 	/*
 	 * we only allow two pending log transactions at a time,
@@ -2371,21 +2372,26 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 	 * current transaction, we're done
 	 */
 	do {
+		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) ==
+		    trans->transid) {
+			ret = -EAGAIN;
+			break;
+		}
+
 		prepare_to_wait(&root->log_commit_wait[index],
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
 
-		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
-		    trans->transid && root->log_transid < transid + 2 &&
+		if (root->log_transid < transid + 2 &&
 		    atomic_read(&root->log_commit[index]))
 			schedule();
 
 		finish_wait(&root->log_commit_wait[index], &wait);
 		mutex_lock(&root->log_mutex);
-	} while (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
-		 trans->transid && root->log_transid < transid + 2 &&
+	} while (root->log_transid < transid + 2 &&
 		 atomic_read(&root->log_commit[index]));
-	return 0;
+
+	return ret;
 }
 
 static void wait_for_writer(struct btrfs_trans_handle *trans,
@@ -2433,15 +2439,16 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	log_transid = root->log_transid;
 	index1 = root->log_transid % 2;
 	if (atomic_read(&root->log_commit[index1])) {
-		wait_log_commit(trans, root, root->log_transid);
+		ret = wait_log_commit(trans, root, root->log_transid);
 		mutex_unlock(&root->log_mutex);
-		return 0;
+		return ret;
 	}
 	atomic_set(&root->log_commit[index1], 1);
 
 	/* wait for previous tree log sync to complete */
 	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
 		wait_log_commit(trans, root, root->log_transid - 1);
+
 	while (1) {
 		int batch = atomic_read(&root->log_batch);
 		/* when we're on an ssd, just kick the log commit out */
@@ -2529,11 +2536,10 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
 		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
-		wait_log_commit(trans, log_root_tree,
-				log_root_tree->log_transid);
+		ret = wait_log_commit(trans, log_root_tree,
+				      log_root_tree->log_transid);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
-		ret = 0;
 		goto out;
 	}
 	atomic_set(&log_root_tree->log_commit[index2], 1);
-- 
1.8.1.4

