Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaBTKHm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:42 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7YYN011826
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] Btrfs: stop joining the log transaction if sync log fails
Date: Thu, 20 Feb 2014 18:08:57 +0800
Message-Id: <1392890939-19044-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the log sync fails, there is something wrong in the log tree, we
should not continue to join the log transaction and log the metadata.
What we should do is to do a full commit.

This patch fixes this problem by setting ->last_trans_log_full_commit
to the current transaction id, it will tell the tasks not to join
the log transaction, and do a full commit.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c27e2c9..4326da9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -142,6 +142,12 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
+		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) ==
+		    trans->transid) {
+			ret = -EAGAIN;
+			goto out;
+		}
+
 		if (!root->log_start_pid) {
 			root->log_start_pid = current->pid;
 			clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
@@ -2488,6 +2494,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		blk_finish_plug(&plug);
 		btrfs_abort_transaction(trans, root, ret);
 		btrfs_free_logged_extents(log, log_transid);
+		ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) =
+								trans->transid;
 		mutex_unlock(&root->log_mutex);
 		goto out;
 	}
@@ -2520,13 +2528,13 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	if (ret) {
 		blk_finish_plug(&plug);
+		ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) =
+								trans->transid;
 		if (ret != -ENOSPC) {
 			btrfs_abort_transaction(trans, root, ret);
 			mutex_unlock(&log_root_tree->log_mutex);
 			goto out;
 		}
-		ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) =
-								trans->transid;
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
@@ -2572,6 +2580,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 					 EXTENT_DIRTY | EXTENT_NEW);
 	blk_finish_plug(&plug);
 	if (ret) {
+		ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) =
+								trans->transid;
 		btrfs_abort_transaction(trans, root, ret);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
@@ -2600,6 +2610,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 */
 	ret = write_ctree_super(trans, root->fs_info->tree_root, 1);
 	if (ret) {
+		ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) =
+								trans->transid;
 		btrfs_abort_transaction(trans, root, ret);
 		goto out_wake_log_root;
 	}
-- 
1.8.1.4

