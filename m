Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:45438 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3I3PkY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 11:40:24 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B38677C0431
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 09:40:23 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id lzZGQSP0zsNmHqrR (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 09:40:22 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix two use-after-free bugs with transaction cleanup
Date: Mon, 30 Sep 2013 11:40:20 -0400
Message-ID: <1380555620-18855-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was noticing the slab redzone stuff going off every once and a while during
transaction aborts.  This was caused by two things

1) We would walk the pending snapshots and set their error to -ECANCELED.  We
don't need to do this, the snapshot stuff waits for a transaction commit and if
there is a problem we just free our pending snapshot object and exit.  Doing
this was causing us to touch the pending snapshot object after the thing had
already been freed.

2) We were freeing the transaction manually with wanton disregard for it's
use_count reference counter.  To fix this I cleaned up the transaction freeing
loop to either wait for the transaction commit to finish if it was in the middle
of that (since it will be cleaned and freed up there) or to do the cleanup
oursevles.

I also moved the global "kill all things dirty everywhere" stuff outside of the
transaction cleanup loop since that only needs to be done once.  With this patch
I'm no longer seeing slab corruption because of use after frees.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c     | 111 ++++++++++++++++++-------------------------------
 fs/btrfs/transaction.c |  22 +++++-----
 fs/btrfs/transaction.h |   1 +
 3 files changed, 52 insertions(+), 82 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 872b4ce..8aa93a9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -64,7 +64,6 @@ static void btrfs_destroy_ordered_operations(struct btrfs_transaction *t,
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
-static void btrfs_evict_pending_snapshots(struct btrfs_transaction *t);
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					struct extent_io_tree *dirty_pages,
@@ -3914,24 +3913,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	return ret;
 }
 
-static void btrfs_evict_pending_snapshots(struct btrfs_transaction *t)
-{
-	struct btrfs_pending_snapshot *snapshot;
-	struct list_head splice;
-
-	INIT_LIST_HEAD(&splice);
-
-	list_splice_init(&t->pending_snapshots, &splice);
-
-	while (!list_empty(&splice)) {
-		snapshot = list_entry(splice.next,
-				      struct btrfs_pending_snapshot,
-				      list);
-		snapshot->error = -ECANCELED;
-		list_del_init(&snapshot->list);
-	}
-}
-
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 {
 	struct btrfs_inode *btrfs_inode;
@@ -4061,6 +4042,8 @@ again:
 void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 				   struct btrfs_root *root)
 {
+	btrfs_destroy_ordered_operations(cur_trans, root);
+
 	btrfs_destroy_delayed_refs(cur_trans, root);
 	btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
 				cur_trans->dirty_pages.dirty_bytes);
@@ -4068,8 +4051,6 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	cur_trans->state = TRANS_STATE_COMMIT_START;
 	wake_up(&root->fs_info->transaction_blocked_wait);
 
-	btrfs_evict_pending_snapshots(cur_trans);
-
 	cur_trans->state = TRANS_STATE_UNBLOCKED;
 	wake_up(&root->fs_info->transaction_wait);
 
@@ -4093,63 +4074,51 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 static int btrfs_cleanup_transaction(struct btrfs_root *root)
 {
 	struct btrfs_transaction *t;
-	LIST_HEAD(list);
 
 	mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
 	spin_lock(&root->fs_info->trans_lock);
-	list_splice_init(&root->fs_info->trans_list, &list);
-	root->fs_info->running_transaction = NULL;
-	spin_unlock(&root->fs_info->trans_lock);
-
-	while (!list_empty(&list)) {
-		t = list_entry(list.next, struct btrfs_transaction, list);
-
-		btrfs_destroy_ordered_operations(t, root);
-
-		btrfs_destroy_all_ordered_extents(root->fs_info);
-
-		btrfs_destroy_delayed_refs(t, root);
-
-		/*
-		 *  FIXME: cleanup wait for commit
-		 *  We needn't acquire the lock here, because we are during
-		 *  the umount, there is no other task which will change it.
-		 */
-		t->state = TRANS_STATE_COMMIT_START;
-		smp_mb();
-		if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
-			wake_up(&root->fs_info->transaction_blocked_wait);
-
-		btrfs_evict_pending_snapshots(t);
-
-		t->state = TRANS_STATE_UNBLOCKED;
-		smp_mb();
-		if (waitqueue_active(&root->fs_info->transaction_wait))
-			wake_up(&root->fs_info->transaction_wait);
-
-		btrfs_destroy_delayed_inodes(root);
-		btrfs_assert_delayed_root_empty(root);
-
-		btrfs_destroy_all_delalloc_inodes(root->fs_info);
-
-		btrfs_destroy_marked_extents(root, &t->dirty_pages,
-					     EXTENT_DIRTY);
-
-		btrfs_destroy_pinned_extent(root,
-					    root->fs_info->pinned_extents);
-
-		t->state = TRANS_STATE_COMPLETED;
-		smp_mb();
-		if (waitqueue_active(&t->commit_wait))
-			wake_up(&t->commit_wait);
+	while (!list_empty(&root->fs_info->trans_list)) {
+		t = list_first_entry(&root->fs_info->trans_list,
+				     struct btrfs_transaction, list);
+		if (t->state >= TRANS_STATE_COMMIT_START) {
+			atomic_inc(&t->use_count);
+			spin_unlock(&root->fs_info->trans_lock);
+			btrfs_wait_for_commit(root, t->transid);
+			btrfs_put_transaction(t);
+			spin_lock(&root->fs_info->trans_lock);
+			continue;
+		}
+		if (t == root->fs_info->running_transaction) {
+			t->state = TRANS_STATE_COMMIT_DOING;
+			spin_unlock(&root->fs_info->trans_lock);
+			/*
+			 * We wait for 0 num_writers since we don't hold a trans
+			 * handle open currently for this transaction.
+			 */
+			wait_event(t->writer_wait,
+				   atomic_read(&t->num_writers) == 0);
+		} else {
+			spin_unlock(&root->fs_info->trans_lock);
+		}
+		btrfs_cleanup_one_transaction(t, root);
 
-		atomic_set(&t->use_count, 0);
+		spin_lock(&root->fs_info->trans_lock);
+		if (t == root->fs_info->running_transaction)
+			root->fs_info->running_transaction = NULL;
 		list_del_init(&t->list);
-		memset(t, 0, sizeof(*t));
-		kmem_cache_free(btrfs_transaction_cachep, t);
-	}
+		spin_unlock(&root->fs_info->trans_lock);
 
+		btrfs_put_transaction(t);
+		trace_btrfs_transaction_commit(root);
+		spin_lock(&root->fs_info->trans_lock);
+	}
+	spin_unlock(&root->fs_info->trans_lock);
+	btrfs_destroy_all_ordered_extents(root->fs_info);
+	btrfs_destroy_delayed_inodes(root);
+	btrfs_assert_delayed_root_empty(root);
+	btrfs_destroy_pinned_extent(root, root->fs_info->pinned_extents);
+	btrfs_destroy_all_delalloc_inodes(root->fs_info);
 	mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
 	return 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 374a91b..b903192 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -57,7 +57,7 @@ static unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 					   __TRANS_JOIN_NOLOCK),
 };
 
-static void put_transaction(struct btrfs_transaction *transaction)
+void btrfs_put_transaction(struct btrfs_transaction *transaction)
 {
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
 	if (atomic_dec_and_test(&transaction->use_count)) {
@@ -332,7 +332,7 @@ static void wait_current_trans(struct btrfs_root *root)
 		wait_event(root->fs_info->transaction_wait,
 			   cur_trans->state >= TRANS_STATE_UNBLOCKED ||
 			   cur_trans->aborted);
-		put_transaction(cur_trans);
+		btrfs_put_transaction(cur_trans);
 	} else {
 		spin_unlock(&root->fs_info->trans_lock);
 	}
@@ -610,7 +610,7 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 	}
 
 	wait_for_commit(root, cur_trans);
-	put_transaction(cur_trans);
+	btrfs_put_transaction(cur_trans);
 out:
 	return ret;
 }
@@ -735,7 +735,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	smp_mb();
 	if (waitqueue_active(&cur_trans->writer_wait))
 		wake_up(&cur_trans->writer_wait);
-	put_transaction(cur_trans);
+	btrfs_put_transaction(cur_trans);
 
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
@@ -1515,7 +1515,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 
-	put_transaction(cur_trans);
+	btrfs_put_transaction(cur_trans);
 	return 0;
 }
 
@@ -1559,8 +1559,8 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 
 	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(root->fs_info->sb);
-	put_transaction(cur_trans);
-	put_transaction(cur_trans);
+	btrfs_put_transaction(cur_trans);
+	btrfs_put_transaction(cur_trans);
 
 	trace_btrfs_transaction_commit(root);
 
@@ -1676,7 +1676,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 		wait_for_commit(root, cur_trans);
 
-		put_transaction(cur_trans);
+		btrfs_put_transaction(cur_trans);
 
 		return ret;
 	}
@@ -1693,7 +1693,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 			wait_for_commit(root, prev_trans);
 
-			put_transaction(prev_trans);
+			btrfs_put_transaction(prev_trans);
 		} else {
 			spin_unlock(&root->fs_info->trans_lock);
 		}
@@ -1895,8 +1895,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	list_del_init(&cur_trans->list);
 	spin_unlock(&root->fs_info->trans_lock);
 
-	put_transaction(cur_trans);
-	put_transaction(cur_trans);
+	btrfs_put_transaction(cur_trans);
+	btrfs_put_transaction(cur_trans);
 
 	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(root->fs_info->sb);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5c2af84..306f88a 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -166,4 +166,5 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
+void btrfs_put_transaction(struct btrfs_transaction *transaction);
 #endif
-- 
1.8.3.1

