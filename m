Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaBTKHk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:40 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7XQe011821
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] Btrfs: fix skipped error handle when log sync failed
Date: Thu, 20 Feb 2014 18:08:58 +0800
Message-Id: <1392890939-19044-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is possible that many tasks sync the log tree at the same time, but
only one task can do the sync work, the others will wait for it. But those
wait tasks didn't get the result of the log sync, and returned 0 when they
ended the wait. It caused those tasks skipped the error handle, and the
serious problem was they told the users the file sync succeeded but in
fact they failed.

This patch fixes this problem by introducing a log context structure,
we insert it into the a global list. When the sync fails, we will set
the error number of every log context in the list, then the waiting tasks
get the error number of the log context and handle the error if need.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |   1 +
 fs/btrfs/disk-io.c  |   2 +
 fs/btrfs/file.c     |   9 +++--
 fs/btrfs/tree-log.c | 114 ++++++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/tree-log.h |  16 +++++++-
 5 files changed, 111 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 76b6bff..1bfce32 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1739,6 +1739,7 @@ struct btrfs_root {
 	struct mutex log_mutex;
 	wait_queue_head_t log_writer_wait;
 	wait_queue_head_t log_commit_wait[2];
+	struct list_head log_ctxs[2];
 	atomic_t log_writers;
 	atomic_t log_commit[2];
 	atomic_t log_batch;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cc0af87..f85f83b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1197,6 +1197,8 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
+	INIT_LIST_HEAD(&root->log_ctxs[0]);
+	INIT_LIST_HEAD(&root->log_ctxs[1]);
 	atomic_set(&root->log_commit[0], 0);
 	atomic_set(&root->log_commit[1], 0);
 	atomic_set(&root->log_writers, 0);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 76ff550..0660e16 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1858,8 +1858,9 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	int ret = 0;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_log_ctx ctx;
+	int ret = 0;
 	bool full_sync = 0;
 
 	trace_btrfs_sync_file(file, datasync);
@@ -1953,7 +1954,9 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 	trans->sync = true;
 
-	ret = btrfs_log_dentry_safe(trans, root, dentry);
+	btrfs_init_log_ctx(&ctx);
+
+	ret = btrfs_log_dentry_safe(trans, root, dentry, &ctx);
 	if (ret < 0) {
 		/* Fallthrough and commit/free transaction. */
 		ret = 1;
@@ -1973,7 +1976,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (ret != BTRFS_NO_LOG_SYNC) {
 		if (!ret) {
-			ret = btrfs_sync_log(trans, root);
+			ret = btrfs_sync_log(trans, root, &ctx);
 			if (!ret) {
 				ret = btrfs_end_transaction(trans, root);
 				goto out;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4326da9..3289eb5 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -136,8 +136,10 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
  * syncing the tree wait for us to finish
  */
 static int start_log_trans(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root)
+			   struct btrfs_root *root,
+			   struct btrfs_log_ctx *ctx)
 {
+	int index;
 	int ret;
 
 	mutex_lock(&root->log_mutex);
@@ -157,6 +159,10 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 
 		atomic_inc(&root->log_batch);
 		atomic_inc(&root->log_writers);
+		if (ctx) {
+			index = root->log_transid % 2;
+			list_add_tail(&ctx->list, &root->log_ctxs[index]);
+		}
 		mutex_unlock(&root->log_mutex);
 		return 0;
 	}
@@ -178,6 +184,10 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 	root->log_start_pid = current->pid;
 	atomic_inc(&root->log_batch);
 	atomic_inc(&root->log_writers);
+	if (ctx) {
+		index = root->log_transid % 2;
+		list_add_tail(&ctx->list, &root->log_ctxs[index]);
+	}
 out:
 	mutex_unlock(&root->log_mutex);
 	return ret;
@@ -2367,12 +2377,11 @@ static int update_log_root(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int wait_log_commit(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, int transid)
+static void wait_log_commit(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, int transid)
 {
 	DEFINE_WAIT(wait);
 	int index = transid % 2;
-	int ret = 0;
 
 	/*
 	 * we only allow two pending log transactions at a time,
@@ -2380,12 +2389,6 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 	 * current transaction, we're done
 	 */
 	do {
-		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) ==
-		    trans->transid) {
-			ret = -EAGAIN;
-			break;
-		}
-
 		prepare_to_wait(&root->log_commit_wait[index],
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
@@ -2398,27 +2401,55 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 		mutex_lock(&root->log_mutex);
 	} while (root->log_transid < transid + 2 &&
 		 atomic_read(&root->log_commit[index]));
-
-	return ret;
 }
 
 static void wait_for_writer(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
-	while (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
-	       trans->transid && atomic_read(&root->log_writers)) {
+
+	while (atomic_read(&root->log_writers)) {
 		prepare_to_wait(&root->log_writer_wait,
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
-		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) !=
-		    trans->transid && atomic_read(&root->log_writers))
+		if (atomic_read(&root->log_writers))
 			schedule();
 		mutex_lock(&root->log_mutex);
 		finish_wait(&root->log_writer_wait, &wait);
 	}
 }
 
+static inline void btrfs_remove_log_ctx(struct btrfs_root *root,
+					struct btrfs_log_ctx *ctx)
+{
+	if (!ctx)
+		return;
+
+	mutex_lock(&root->log_mutex);
+	list_del_init(&ctx->list);
+	mutex_unlock(&root->log_mutex);
+}
+
+/* 
+ * Invoked in log mutex context, or be sure there is no other task which
+ * can access the list.
+ */
+static inline void btrfs_remove_all_log_ctxs(struct btrfs_root *root,
+					     int index, int error)
+{
+	struct btrfs_log_ctx *ctx;
+
+	if (!error) {
+		INIT_LIST_HEAD(&root->log_ctxs[index]);
+		return;
+	}
+
+	list_for_each_entry(ctx, &root->log_ctxs[index], list)
+		ctx->log_ret = error;
+
+	INIT_LIST_HEAD(&root->log_ctxs[index]);
+}
+
 /*
  * btrfs_sync_log does sends a given tree log down to the disk and
  * updates the super blocks to record it.  When this call is done,
@@ -2432,7 +2463,7 @@ static void wait_for_writer(struct btrfs_trans_handle *trans,
  * that has happened.
  */
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
-		   struct btrfs_root *root)
+		   struct btrfs_root *root, struct btrfs_log_ctx *ctx)
 {
 	int index1;
 	int index2;
@@ -2441,15 +2472,16 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = root->fs_info->log_root_tree;
 	int log_transid = 0;
+	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
 
 	mutex_lock(&root->log_mutex);
 	log_transid = root->log_transid;
 	index1 = root->log_transid % 2;
 	if (atomic_read(&root->log_commit[index1])) {
-		ret = wait_log_commit(trans, root, root->log_transid);
+		wait_log_commit(trans, root, root->log_transid);
 		mutex_unlock(&root->log_mutex);
-		return ret;
+		return ctx->log_ret;
 	}
 	atomic_set(&root->log_commit[index1], 1);
 
@@ -2543,13 +2575,18 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	index2 = log_root_tree->log_transid % 2;
+
+	btrfs_init_log_ctx(&root_log_ctx);
+	list_add_tail(&root_log_ctx.list, &log_root_tree->log_ctxs[index2]);
+
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
 		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
-		ret = wait_log_commit(trans, log_root_tree,
-				      log_root_tree->log_transid);
+		wait_log_commit(trans, log_root_tree,
+				log_root_tree->log_transid);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
+		ret = root_log_ctx.log_ret;
 		goto out;
 	}
 	atomic_set(&log_root_tree->log_commit[index2], 1);
@@ -2622,12 +2659,31 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_unlock(&root->log_mutex);
 
 out_wake_log_root:
+	/*
+	 * We needn't get log_mutex here because we are sure all
+	 * the other tasks are blocked.
+	 */
+	btrfs_remove_all_log_ctxs(log_root_tree, index2, ret);
+
+	/*
+	 * It is dangerous if log_commit is changed before we set
+	 * ->log_ret of log ctx. Because the readers may not get
+	 *  the return value.
+	 */
+	smp_wmb();
+
 	atomic_set(&log_root_tree->log_commit[index2], 0);
 	smp_mb();
 	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
 		wake_up(&log_root_tree->log_commit_wait[index2]);
 out:
+	/* See above. */
+	btrfs_remove_all_log_ctxs(root, index1, ret);
+
+	/* See above. */
+	smp_wmb();
 	atomic_set(&root->log_commit[index1], 0);
+
 	smp_mb();
 	if (waitqueue_active(&root->log_commit_wait[index1]))
 		wake_up(&root->log_commit_wait[index1]);
@@ -4089,7 +4145,8 @@ out:
  */
 static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 			    	  struct btrfs_root *root, struct inode *inode,
-			    	  struct dentry *parent, int exists_only)
+			    	  struct dentry *parent, int exists_only,
+				  struct btrfs_log_ctx *ctx)
 {
 	int inode_only = exists_only ? LOG_INODE_EXISTS : LOG_INODE_ALL;
 	struct super_block *sb;
@@ -4126,7 +4183,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		goto end_no_trans;
 	}
 
-	ret = start_log_trans(trans, root);
+	ret = start_log_trans(trans, root, ctx);
 	if (ret)
 		goto end_no_trans;
 
@@ -4176,6 +4233,9 @@ end_trans:
 		root->fs_info->last_trans_log_full_commit = trans->transid;
 		ret = 1;
 	}
+
+	if (ret)
+		btrfs_remove_log_ctx(root, ctx);
 	btrfs_end_log_trans(root);
 end_no_trans:
 	return ret;
@@ -4188,12 +4248,14 @@ end_no_trans:
  * data on disk.
  */
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct dentry *dentry)
+			  struct btrfs_root *root, struct dentry *dentry,
+			  struct btrfs_log_ctx *ctx)
 {
 	struct dentry *parent = dget_parent(dentry);
 	int ret;
 
-	ret = btrfs_log_inode_parent(trans, root, dentry->d_inode, parent, 0);
+	ret = btrfs_log_inode_parent(trans, root, dentry->d_inode, parent,
+				     0, ctx);
 	dput(parent);
 
 	return ret;
@@ -4430,6 +4492,6 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		    root->fs_info->last_trans_committed))
 		return 0;
 
-	return btrfs_log_inode_parent(trans, root, inode, parent, 1);
+	return btrfs_log_inode_parent(trans, root, inode, parent, 1, NULL);
 }
 
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 1d4ae0d..59c1edb 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -22,14 +22,26 @@
 /* return value for btrfs_log_dentry_safe that means we don't need to log it at all */
 #define BTRFS_NO_LOG_SYNC 256
 
+struct btrfs_log_ctx {
+	int log_ret;
+	struct list_head list;
+};
+
+static inline void btrfs_init_log_ctx(struct btrfs_log_ctx *ctx)
+{
+	ctx->log_ret = 0;
+	INIT_LIST_HEAD(&ctx->list);
+}
+
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
-		   struct btrfs_root *root);
+		   struct btrfs_root *root, struct btrfs_log_ctx *ctx);
 int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
 int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_recover_log_trees(struct btrfs_root *tree_root);
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct dentry *dentry);
+			  struct btrfs_root *root, struct dentry *dentry,
+			  struct btrfs_log_ctx *ctx);
 int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 const char *name, int name_len,
-- 
1.8.1.4

