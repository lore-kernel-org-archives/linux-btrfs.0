Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab3LMKIa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 05:08:30 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBDA8S6E008938
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 18:08:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] Btrfs: remove residual code in delayed inode async helper
Date: Fri, 13 Dec 2013 18:09:36 +0800
Message-Id: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying the patch
  commit de3cb945db4d8eb3b046dc7a5ea89a893372750c
  title: Btrfs: improve the delayed inode throttling

We need requeue the async work after the current work was done, it
introduced a deadlock problem. So we wrote the code that this patch
removes to avoid the above problem. But after applying the above
patch, the deadlock problem didn't exist. So we should remove that
fix code.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 8d292fb..e832621 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1300,33 +1300,6 @@ again:
 	trans->block_rsv = &root->fs_info->delayed_block_rsv;
 
 	__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
-	/*
-	 * Maybe new delayed items have been inserted, so we need requeue
-	 * the work. Besides that, we must dequeue the empty delayed nodes
-	 * to avoid the race between delayed items balance and the worker.
-	 * The race like this:
-	 * 	Task1				Worker thread
-	 * 					count == 0, needn't requeue
-	 * 					  also needn't insert the
-	 * 					  delayed node into prepare
-	 * 					  list again.
-	 * 	add lots of delayed items
-	 * 	queue the delayed node
-	 * 	  already in the list,
-	 * 	  and not in the prepare
-	 * 	  list, it means the delayed
-	 * 	  node is being dealt with
-	 * 	  by the worker.
-	 * 	do delayed items balance
-	 * 	  the delayed node is being
-	 * 	  dealt with by the worker
-	 * 	  now, just wait.
-	 * 	  				the worker goto idle.
-	 * Task1 will sleep until the transaction is commited.
-	 */
-	mutex_lock(&delayed_node->mutex);
-	btrfs_dequeue_delayed_node(root->fs_info->delayed_root, delayed_node);
-	mutex_unlock(&delayed_node->mutex);
 
 	trans->block_rsv = block_rsv;
 	btrfs_end_transaction_dmeta(trans, root);
-- 
1.8.3.1

