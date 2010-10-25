From: Sage Weil <sage@newdream.net>
Subject: [PATCH 2/6] Btrfs: async transaction commit
Date: Mon, 25 Oct 2010 12:07:38 -0700
Message-ID: <1288033662-21464-3-git-send-email-sage@newdream.net>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <1288033662-21464-2-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288033662-21464-2-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add support for an async transaction commit that is ordered such that any
subsequent operations will join the following transaction, but does not
wait until the current commit is fully on disk.  This avoids much of the
latency associated with the btrfs_commit_transaction for callers concerned
with serialization and not safety.

The wait_for_unblock flag controls whether we wait for the 'middle' portion
of commit_transaction to complete, which is necessary if the caller expects
some of the modifications contained in the commit to be available (this is
the case for subvol/snapshot creation).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/transaction.c |  119 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h |    3 +
 4 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eaf286a..4c3c20b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -863,6 +863,7 @@ struct btrfs_fs_info {
 	struct btrfs_transaction *running_transaction;
 	wait_queue_head_t transaction_throttle;
 	wait_queue_head_t transaction_wait;
+	wait_queue_head_t transaction_blocked_wait;
 	wait_queue_head_t async_submit_wait;
 
 	struct btrfs_super_block super_copy;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 64f1008..034abc6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1680,6 +1680,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	init_waitqueue_head(&fs_info->transaction_throttle);
 	init_waitqueue_head(&fs_info->transaction_wait);
+	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
 
 	__setup_root(4096, 4096, 4096, 4096, tree_root,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bf399ea..d720106 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -988,6 +988,123 @@ int btrfs_transaction_blocked(struct btrfs_fs_info *info)
 	return ret;
 }
 
+/*
+ * wait for the current transaction commit to start and block subsequent
+ * transaction joins
+ */
+static void wait_current_trans_commit_start(struct btrfs_root *root,
+					    struct btrfs_transaction *trans)
+{
+	DEFINE_WAIT(wait);
+
+	if (trans->in_commit)
+		return;
+
+	while (1) {
+		prepare_to_wait(&root->fs_info->transaction_blocked_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (trans->in_commit) {
+			finish_wait(&root->fs_info->transaction_blocked_wait,
+				    &wait);
+			break;
+		}
+		mutex_unlock(&root->fs_info->trans_mutex);
+		schedule();
+		mutex_lock(&root->fs_info->trans_mutex);
+		finish_wait(&root->fs_info->transaction_blocked_wait, &wait);
+	}
+}
+
+/*
+ * wait for the current transaction to start and then become unblocked.
+ * caller holds ref.
+ */
+static void wait_current_trans_commit_start_and_unblock(struct btrfs_root *root,
+					 struct btrfs_transaction *trans)
+{
+	DEFINE_WAIT(wait);
+
+	if (trans->commit_done || (trans->in_commit && !trans->blocked))
+		return;
+
+	while (1) {
+		prepare_to_wait(&root->fs_info->transaction_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (trans->commit_done ||
+		    (trans->in_commit && !trans->blocked)) {
+			finish_wait(&root->fs_info->transaction_wait,
+				    &wait);
+			break;
+		}
+		mutex_unlock(&root->fs_info->trans_mutex);
+		schedule();
+		mutex_lock(&root->fs_info->trans_mutex);
+		finish_wait(&root->fs_info->transaction_wait,
+			    &wait);
+	}
+}
+
+/*
+ * commit transactions asynchronously. once btrfs_commit_transaction_async
+ * returns, any subsequent transaction will not be allowed to join.
+ */
+struct btrfs_async_commit {
+	struct btrfs_trans_handle *newtrans;
+	struct btrfs_root *root;
+	struct delayed_work work;
+};
+
+static void do_async_commit(struct work_struct *work)
+{
+	struct btrfs_async_commit *ac =
+		container_of(work, struct btrfs_async_commit, work.work);
+	
+	btrfs_commit_transaction(ac->newtrans, ac->root);
+	kfree(ac);
+}
+
+int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   int wait_for_unblock)
+{
+	struct btrfs_async_commit *ac;
+	struct btrfs_transaction *cur_trans;
+
+	ac = kmalloc(sizeof(*ac), GFP_NOFS);
+	BUG_ON(!ac);
+
+	INIT_DELAYED_WORK(&ac->work, do_async_commit);
+	ac->root = root;
+	ac->newtrans = btrfs_join_transaction(root, 0);
+
+	/* take transaction reference */
+	mutex_lock(&root->fs_info->trans_mutex);
+	cur_trans = trans->transaction;
+	cur_trans->use_count++;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	btrfs_end_transaction(trans, root);
+	schedule_delayed_work(&ac->work, 0);
+
+	/* wait for transaction to start and unblock */
+	mutex_lock(&root->fs_info->trans_mutex);
+	if (wait_for_unblock)
+		wait_current_trans_commit_start_and_unblock(root, cur_trans);
+	else
+		wait_current_trans_commit_start(root, cur_trans);
+	put_transaction(cur_trans);
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	return 0;
+}
+
+/*
+ * btrfs_transaction state sequence:
+ *    in_commit = 0, blocked = 0  (initial)
+ *    in_commit = 1, blocked = 1
+ *    blocked = 0
+ *    commit_done = 1
+ */
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
@@ -1038,6 +1155,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	trans->transaction->in_commit = 1;
 	trans->transaction->blocked = 1;
+	wake_up(&root->fs_info->transaction_blocked_wait);
+
 	if (cur_trans->list.prev != &root->fs_info->trans_list) {
 		prev_trans = list_entry(cur_trans->list.prev,
 					struct btrfs_transaction, list);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e104986..8972c62 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -104,6 +104,9 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
+int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   int wait_for_unblock);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root);
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
-- 
1.6.6.1

