From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: avoid taking the trans_mutex in btrfs_end_transaction
Date: Mon, 11 Apr 2011 15:49:17 -0400
Message-ID: <1302551357-27538-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been working on making our O_DIRECT latency not suck and I noticed we were
taking the trans_mutex in btrfs_end_transaction.  So to do this we convert
num_writers and use_count to atomic_t's and just decrement them in
btrfs_end_transaction.  I got rid of the put_transaction() in
btrfs_end_transaction() since we will never free the transaction from
btrfs_end_transaction().  Tested this with xfstests and everything went
smoothly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/transaction.c |   42 +++++++++++++++++++++---------------------
 fs/btrfs/transaction.h |    4 ++--
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8f1d44b..68c84c8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3057,7 +3057,7 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 		btrfs_destroy_pinned_extent(root,
 					    root->fs_info->pinned_extents);
 
-		t->use_count = 0;
+		atomic_set(&t->use_count, 0);
 		list_del_init(&t->list);
 		memset(t, 0, sizeof(*t));
 		kmem_cache_free(btrfs_transaction_cachep, t);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4583008..dbacd2c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -32,9 +32,8 @@
 
 static noinline void put_transaction(struct btrfs_transaction *transaction)
 {
-	WARN_ON(transaction->use_count == 0);
-	transaction->use_count--;
-	if (transaction->use_count == 0) {
+	WARN_ON(atomic_read(&transaction->use_count) == 0);
+	if (atomic_dec_and_test(&transaction->use_count)) {
 		list_del_init(&transaction->list);
 		memset(transaction, 0, sizeof(*transaction));
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
@@ -60,14 +59,14 @@ static noinline int join_transaction(struct btrfs_root *root)
 		if (!cur_trans)
 			return -ENOMEM;
 		root->fs_info->generation++;
-		cur_trans->num_writers = 1;
+		atomic_set(&cur_trans->num_writers, 1);
 		cur_trans->num_joined = 0;
 		cur_trans->transid = root->fs_info->generation;
 		init_waitqueue_head(&cur_trans->writer_wait);
 		init_waitqueue_head(&cur_trans->commit_wait);
 		cur_trans->in_commit = 0;
 		cur_trans->blocked = 0;
-		cur_trans->use_count = 1;
+		atomic_set(&cur_trans->use_count, 1);
 		cur_trans->commit_done = 0;
 		cur_trans->start_time = get_seconds();
 
@@ -88,7 +87,7 @@ static noinline int join_transaction(struct btrfs_root *root)
 		root->fs_info->running_transaction = cur_trans;
 		spin_unlock(&root->fs_info->new_trans_lock);
 	} else {
-		cur_trans->num_writers++;
+		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
 	}
 
@@ -145,7 +144,7 @@ static void wait_current_trans(struct btrfs_root *root)
 	cur_trans = root->fs_info->running_transaction;
 	if (cur_trans && cur_trans->blocked) {
 		DEFINE_WAIT(wait);
-		cur_trans->use_count++;
+		atomic_inc(&cur_trans->use_count);
 		while (1) {
 			prepare_to_wait(&root->fs_info->transaction_wait, &wait,
 					TASK_UNINTERRUPTIBLE);
@@ -205,7 +204,7 @@ again:
 	}
 
 	cur_trans = root->fs_info->running_transaction;
-	cur_trans->use_count++;
+	atomic_inc(&cur_trans->use_count);
 	if (type != TRANS_JOIN_NOLOCK)
 		mutex_unlock(&root->fs_info->trans_mutex);
 
@@ -336,7 +335,7 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 			goto out_unlock;  /* nothing committing|committed */
 	}
 
-	cur_trans->use_count++;
+	atomic_inc(&cur_trans->use_count);
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	wait_for_commit(root, cur_trans);
@@ -466,19 +465,20 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			wake_up_process(info->transaction_kthread);
 	}
 
-	if (lock)
-		mutex_lock(&info->trans_mutex);
 	WARN_ON(cur_trans != info->running_transaction);
-	WARN_ON(cur_trans->num_writers < 1);
-	cur_trans->num_writers--;
+	WARN_ON(atomic_read(&cur_trans->num_writers) < 1);
+	atomic_dec(&cur_trans->num_writers);
 
 	smp_mb();
 	if (waitqueue_active(&cur_trans->writer_wait))
 		wake_up(&cur_trans->writer_wait);
-	put_transaction(cur_trans);
-	if (lock)
-		mutex_unlock(&info->trans_mutex);
 
+	/*
+	 * A trans handle will never actually be putting the last reference of a
+	 * transaction, so just dec the use count to avoid taking the trans
+	 * mutex.
+	 */
+	atomic_dec(&cur_trans->use_count);
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 	memset(trans, 0, sizeof(*trans));
@@ -1187,7 +1187,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	/* take transaction reference */
 	mutex_lock(&root->fs_info->trans_mutex);
 	cur_trans = trans->transaction;
-	cur_trans->use_count++;
+	atomic_inc(&cur_trans->use_count);
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	btrfs_end_transaction(trans, root);
@@ -1246,7 +1246,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (cur_trans->in_commit) {
-		cur_trans->use_count++;
+		atomic_inc(&cur_trans->use_count);
 		mutex_unlock(&root->fs_info->trans_mutex);
 		btrfs_end_transaction(trans, root);
 
@@ -1268,7 +1268,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		prev_trans = list_entry(cur_trans->list.prev,
 					struct btrfs_transaction, list);
 		if (!prev_trans->commit_done) {
-			prev_trans->use_count++;
+			atomic_inc(&prev_trans->use_count);
 			mutex_unlock(&root->fs_info->trans_mutex);
 
 			wait_for_commit(root, prev_trans);
@@ -1309,14 +1309,14 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 				TASK_UNINTERRUPTIBLE);
 
 		smp_mb();
-		if (cur_trans->num_writers > 1)
+		if (atomic_read(&cur_trans->num_writers) > 1)
 			schedule_timeout(MAX_SCHEDULE_TIMEOUT);
 		else if (should_grow)
 			schedule_timeout(1);
 
 		mutex_lock(&root->fs_info->trans_mutex);
 		finish_wait(&cur_trans->writer_wait, &wait);
-	} while (cur_trans->num_writers > 1 ||
+	} while (atomic_read(&cur_trans->num_writers) > 1 ||
 		 (should_grow && cur_trans->num_joined != joined));
 
 	ret = create_pending_snapshots(trans, root->fs_info);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 229a594..e441acc 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -27,11 +27,11 @@ struct btrfs_transaction {
 	 * total writers in this transaction, it must be zero before the
 	 * transaction can end
 	 */
-	unsigned long num_writers;
+	atomic_t num_writers;
 
 	unsigned long num_joined;
 	int in_commit;
-	int use_count;
+	atomic_t use_count;
 	int commit_done;
 	int blocked;
 	struct list_head list;
-- 
1.7.2.3

