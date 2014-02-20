Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaBTKHf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:35 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7XQa011821
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] Btrfs: use ACCESS_ONCE to prevent the optimize accesses to ->last_trans_log_full_commit
Date: Thu, 20 Feb 2014 18:08:51 +0800
Message-Id: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

->last_trans_log_full_commit may be changed by the other tasks without lock,
so we need prevent the compiler from the optimize access just like
	tmp = fs_info->last_trans_log_full_commit
	if (tmp == ...)
		...

	<do something>

	if (tmp == ...)
		...

In fact, we need get the new value of ->last_trans_log_full_commit during
the second access. Fix it by ACCESS_ONCE().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7c449c6..5a4e10b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2375,14 +2375,14 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
 
-		if (root->fs_info->last_trans_log_full_commit !=
+		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
 		    trans->transid && root->log_transid < transid + 2 &&
 		    atomic_read(&root->log_commit[index]))
 			schedule();
 
 		finish_wait(&root->log_commit_wait[index], &wait);
 		mutex_lock(&root->log_mutex);
-	} while (root->fs_info->last_trans_log_full_commit !=
+	} while (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
 		 trans->transid && root->log_transid < transid + 2 &&
 		 atomic_read(&root->log_commit[index]));
 	return 0;
@@ -2392,12 +2392,12 @@ static void wait_for_writer(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
-	while (root->fs_info->last_trans_log_full_commit !=
+	while (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
 	       trans->transid && atomic_read(&root->log_writers)) {
 		prepare_to_wait(&root->log_writer_wait,
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
-		if (root->fs_info->last_trans_log_full_commit !=
+		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
 		    trans->transid && atomic_read(&root->log_writers))
 			schedule();
 		mutex_lock(&root->log_mutex);
@@ -2456,7 +2456,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	/* bail out if we need to do a full commit */
-	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+	if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) ==
+	    trans->transid) {
 		ret = -EAGAIN;
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&root->log_mutex);
@@ -2515,7 +2516,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 			mutex_unlock(&log_root_tree->log_mutex);
 			goto out;
 		}
-		root->fs_info->last_trans_log_full_commit = trans->transid;
+		ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) =
+								trans->transid;
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
@@ -2547,7 +2549,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * now that we've moved on to the tree of log tree roots,
 	 * check the full commit flag again
 	 */
-	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+	if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) ==
+	    trans->transid) {
 		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		btrfs_free_logged_extents(log, log_transid);
-- 
1.8.1.4

