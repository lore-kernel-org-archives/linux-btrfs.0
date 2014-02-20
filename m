Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbaBTKHh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:37 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7XQc011821
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] Btrfs: don't start the log transaction if the log tree init fails
Date: Thu, 20 Feb 2014 18:08:53 +0800
Message-Id: <1392890939-19044-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The old code would start the log transaction even the log tree init
failed, it was unnecessary. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8a03b39..ca960ad 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -139,7 +139,6 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root)
 {
 	int ret;
-	int err = 0;
 
 	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
@@ -155,24 +154,27 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 		mutex_unlock(&root->log_mutex);
 		return 0;
 	}
-	root->log_multiple_pids = false;
-	root->log_start_pid = current->pid;
+
+	ret = 0;
 	mutex_lock(&root->fs_info->tree_log_mutex);
-	if (!root->fs_info->log_root_tree) {
+	if (!root->fs_info->log_root_tree)
 		ret = btrfs_init_log_root_tree(trans, root->fs_info);
-		if (ret)
-			err = ret;
-	}
-	if (err == 0 && !root->log_root) {
+	mutex_unlock(&root->fs_info->tree_log_mutex);
+	if (ret)
+		goto out;
+
+	if (!root->log_root) {
 		ret = btrfs_add_log_tree(trans, root);
 		if (ret)
-			err = ret;
+			goto out;
 	}
-	mutex_unlock(&root->fs_info->tree_log_mutex);
+	root->log_multiple_pids = false;
+	root->log_start_pid = current->pid;
 	atomic_inc(&root->log_batch);
 	atomic_inc(&root->log_writers);
+out:
 	mutex_unlock(&root->log_mutex);
-	return err;
+	return ret;
 }
 
 /*
@@ -4116,7 +4118,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 
 	ret = start_log_trans(trans, root);
 	if (ret)
-		goto end_trans;
+		goto end_no_trans;
 
 	ret = btrfs_log_inode(trans, root, inode, inode_only);
 	if (ret)
-- 
1.8.1.4

