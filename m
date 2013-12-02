Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38599 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3LBRdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 12:33:51 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so18575046pdj.15
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Dec 2013 09:33:50 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: ochmann@informatik.uni-bonn.de, wangshilong1991@gmail.com,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v3] Btrfs: fix wrong super generation mismatch when scrubbing supers
Date: Tue,  3 Dec 2013 01:33:39 +0800
Message-Id: <1386005619-7750-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

We came a race condition when scrubbing superblocks, the story is:

In commiting transaction, we will update last_trans_commited after
writting superblocks. if a scrub start after writting superblocks
and before last_trans_commited, generation mismatch happens!

We fix it by protecting writting superblock and updating last_trans_commited
with tree_log_mutex.

Reported-by: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Changelog:
	v2->v3:move tree_log_mutex out of device_list_mutex.
	v1->v2: use right way to fix the problem.
---
 fs/btrfs/scrub.c       | 11 +++++++----
 fs/btrfs/transaction.c | 13 ++++++++++---
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 561e2f1..a9ed102 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2887,6 +2887,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	}
 
 
+	mutex_lock(&fs_info->tree_log_mutex);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!dev || (dev->missing && !is_dev_replace)) {
@@ -2932,14 +2933,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
 
+	/*
+	 * holding tree_log_mutex we can avoid generation mismatch while
+	 * scrubbing superblocks, see comments in commiting transaction
+	 * when updating last_trans_commited.
+	 */
 	if (!is_dev_replace) {
-		/*
-		 * by holding device list mutex, we can
-		 * kick off writing super in log tree sync.
-		 */
 		ret = scrub_supers(sctx, dev);
 	}
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_info->tree_log_mutex);
 
 	if (!ret)
 		ret = scrub_enumerate_chunks(sctx, dev, start, end,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c6a872a..052eb22 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1898,15 +1898,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto cleanup_transaction;
 	}
 
+	btrfs_finish_extent_commit(trans, root);
+
+	/*
+	 * we must gurantee last_trans_commited update is protected by
+	 * tree_log_mutex with write_ctree_super together, otherwise,
+	 * scubbing super will come in before updating last_trans_commited
+	 * and we will get generation mismatch when scrubbing superblocks.
+	 */
+	root->fs_info->last_trans_committed = cur_trans->transid;
+
 	/*
 	 * the super is written, we can safely allow the tree-loggers
 	 * to go about their business
 	 */
 	mutex_unlock(&root->fs_info->tree_log_mutex);
 
-	btrfs_finish_extent_commit(trans, root);
-
-	root->fs_info->last_trans_committed = cur_trans->transid;
 	/*
 	 * We needn't acquire the lock here because there is no other task
 	 * which can change it.
-- 
1.8.4

