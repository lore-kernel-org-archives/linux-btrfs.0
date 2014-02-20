Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaBTKHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:44 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7XQf011821
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] Btrfs: just wait or commit our own log sub-transaction
Date: Thu, 20 Feb 2014 18:08:59 +0800
Message-Id: <1392890939-19044-9-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We might commit the log sub-transaction which didn't contain the metadata we
logged. It was because we didn't record the log transid and just select
the current log sub-transaction to commit, but the right one might be
committed by the other task already. Actually, we needn't do anything
and it is safe that we go back directly in this case.

This patch improves the log sync by the above idea. We record the transid
of the log sub-transaction in which we log the metadata, and the transid
of the log sub-transaction we have committed. If the committed transid
is >= the transid we record when logging the metadata, we just go back.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |  3 +++
 fs/btrfs/disk-io.c  |  2 ++
 fs/btrfs/tree-log.c | 63 ++++++++++++++++++++++++++++++++++-------------------
 fs/btrfs/tree-log.h |  2 ++
 4 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1bfce32..dc72c1f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1744,6 +1744,9 @@ struct btrfs_root {
 	atomic_t log_commit[2];
 	atomic_t log_batch;
 	int log_transid;
+	/* No matter the commit succeeds or not*/
+	int log_transid_committed;
+	/* Just be updated when the commit succeeds. */
 	int last_log_commit;
 	pid_t log_start_pid;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f85f83b..6699483 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1206,6 +1206,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	atomic_set(&root->orphan_inodes, 0);
 	atomic_set(&root->refs, 1);
 	root->log_transid = 0;
+	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
 	if (fs_info)
 		extent_io_tree_init(&root->dirty_log_pages,
@@ -1419,6 +1420,7 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	WARN_ON(root->log_root);
 	root->log_root = log_root;
 	root->log_transid = 0;
+	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
 	return 0;
 }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3289eb5..ffee158 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -162,6 +162,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 		if (ctx) {
 			index = root->log_transid % 2;
 			list_add_tail(&ctx->list, &root->log_ctxs[index]);
+			ctx->log_transid = root->log_transid;
 		}
 		mutex_unlock(&root->log_mutex);
 		return 0;
@@ -187,6 +188,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 	if (ctx) {
 		index = root->log_transid % 2;
 		list_add_tail(&ctx->list, &root->log_ctxs[index]);
+		ctx->log_transid = root->log_transid;
 	}
 out:
 	mutex_unlock(&root->log_mutex);
@@ -2393,13 +2395,13 @@ static void wait_log_commit(struct btrfs_trans_handle *trans,
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
 
-		if (root->log_transid < transid + 2 &&
+		if (root->log_transid_committed < transid &&
 		    atomic_read(&root->log_commit[index]))
 			schedule();
 
 		finish_wait(&root->log_commit_wait[index], &wait);
 		mutex_lock(&root->log_mutex);
-	} while (root->log_transid < transid + 2 &&
+	} while (root->log_transid_committed < transid &&
 		 atomic_read(&root->log_commit[index]));
 }
 
@@ -2476,18 +2478,24 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct blk_plug plug;
 
 	mutex_lock(&root->log_mutex);
-	log_transid = root->log_transid;
-	index1 = root->log_transid % 2;
+	log_transid = ctx->log_transid;
+	if (root->log_transid_committed >= log_transid) {
+		mutex_unlock(&root->log_mutex);
+		return ctx->log_ret;
+	}
+
+	index1 = log_transid % 2;
 	if (atomic_read(&root->log_commit[index1])) {
-		wait_log_commit(trans, root, root->log_transid);
+		wait_log_commit(trans, root, log_transid);
 		mutex_unlock(&root->log_mutex);
 		return ctx->log_ret;
 	}
+	ASSERT(log_transid == root->log_transid);
 	atomic_set(&root->log_commit[index1], 1);
 
 	/* wait for previous tree log sync to complete */
 	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
-		wait_log_commit(trans, root, root->log_transid - 1);
+		wait_log_commit(trans, root, log_transid - 1);
 
 	while (1) {
 		int batch = atomic_read(&root->log_batch);
@@ -2544,9 +2552,16 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 */
 	mutex_unlock(&root->log_mutex);
 
+	btrfs_init_log_ctx(&root_log_ctx);
+
 	mutex_lock(&log_root_tree->log_mutex);
 	atomic_inc(&log_root_tree->log_batch);
 	atomic_inc(&log_root_tree->log_writers);
+
+	index2 = log_root_tree->log_transid % 2;
+	list_add_tail(&root_log_ctx.list, &log_root_tree->log_ctxs[index2]);
+	root_log_ctx.log_transid = log_root_tree->log_transid;
+
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	ret = update_log_root(trans, log);
@@ -2559,6 +2574,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	if (ret) {
+		if (!list_empty(&root_log_ctx.list))
+			list_del_init(&root_log_ctx.list);
+
 		blk_finish_plug(&plug);
 		ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) =
 								trans->transid;
@@ -2574,26 +2592,29 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	index2 = log_root_tree->log_transid % 2;
-
-	btrfs_init_log_ctx(&root_log_ctx);
-	list_add_tail(&root_log_ctx.list, &log_root_tree->log_ctxs[index2]);
+	if (log_root_tree->log_transid_committed >= root_log_ctx.log_transid) {
+		mutex_unlock(&log_root_tree->log_mutex);
+		ret = root_log_ctx.log_ret;
+		goto out;
+	}
 
+	index2 = root_log_ctx.log_transid % 2;
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
 		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		wait_log_commit(trans, log_root_tree,
-				log_root_tree->log_transid);
+				root_log_ctx.log_transid);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = root_log_ctx.log_ret;
 		goto out;
 	}
+	ASSERT(root_log_ctx.log_transid == log_root_tree->log_transid);
 	atomic_set(&log_root_tree->log_commit[index2], 1);
 
 	if (atomic_read(&log_root_tree->log_commit[(index2 + 1) % 2])) {
 		wait_log_commit(trans, log_root_tree,
-				log_root_tree->log_transid - 1);
+				root_log_ctx.log_transid - 1);
 	}
 
 	wait_for_writer(trans, log_root_tree);
@@ -2665,26 +2686,22 @@ out_wake_log_root:
 	 */
 	btrfs_remove_all_log_ctxs(log_root_tree, index2, ret);
 
-	/*
-	 * It is dangerous if log_commit is changed before we set
-	 * ->log_ret of log ctx. Because the readers may not get
-	 *  the return value.
-	 */
-	smp_wmb();
-
+	mutex_lock(&log_root_tree->log_mutex);
+	log_root_tree->log_transid_committed++;
 	atomic_set(&log_root_tree->log_commit[index2], 0);
-	smp_mb();
+	mutex_unlock(&log_root_tree->log_mutex);
+
 	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
 		wake_up(&log_root_tree->log_commit_wait[index2]);
 out:
 	/* See above. */
 	btrfs_remove_all_log_ctxs(root, index1, ret);
 
-	/* See above. */
-	smp_wmb();
+	mutex_lock(&root->log_mutex);
+	root->log_transid_committed++;
 	atomic_set(&root->log_commit[index1], 0);
+	mutex_unlock(&root->log_mutex);
 
-	smp_mb();
 	if (waitqueue_active(&root->log_commit_wait[index1]))
 		wake_up(&root->log_commit_wait[index1]);
 	return ret;
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 59c1edb..91b145f 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -24,12 +24,14 @@
 
 struct btrfs_log_ctx {
 	int log_ret;
+	int log_transid;
 	struct list_head list;
 };
 
 static inline void btrfs_init_log_ctx(struct btrfs_log_ctx *ctx)
 {
 	ctx->log_ret = 0;
+	ctx->log_transid = 0;
 	INIT_LIST_HEAD(&ctx->list);
 }
 
-- 
1.8.1.4

