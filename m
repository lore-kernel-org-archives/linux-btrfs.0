From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: only drop the trans_mutex in join_transaction if we have to
Date: Mon, 11 Apr 2011 17:26:41 -0400
Message-ID: <1302557201-7380-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed we are dropping the trans_mutex and then immediately re-acquiring it
in the common case in join_transaction.  Instead of doing that, just drop it if
we have to (like we have to commit or end the transaction or something) and
otherwise just keep a hold of it.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c571734..cde38f9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -181,6 +181,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	struct btrfs_transaction *cur_trans;
 	int retries = 0;
 	int ret;
+	bool lock = (type != TRANS_JOIN_NOLOCK);
 
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
 		return ERR_PTR(-EROFS);
@@ -189,7 +190,7 @@ again:
 	if (!h)
 		return ERR_PTR(-ENOMEM);
 
-	if (type != TRANS_JOIN_NOLOCK)
+	if (lock)
 		mutex_lock(&root->fs_info->trans_mutex);
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
@@ -197,15 +198,13 @@ again:
 	ret = join_transaction(root);
 	if (ret < 0) {
 		kmem_cache_free(btrfs_trans_handle_cachep, h);
-		if (type != TRANS_JOIN_NOLOCK)
+		if (lock)
 			mutex_unlock(&root->fs_info->trans_mutex);
 		return ERR_PTR(ret);
 	}
 
 	cur_trans = root->fs_info->running_transaction;
 	atomic_inc(&cur_trans->use_count);
-	if (type != TRANS_JOIN_NOLOCK)
-		mutex_unlock(&root->fs_info->trans_mutex);
 
 	h->transid = cur_trans->transid;
 	h->transaction = cur_trans;
@@ -217,6 +216,11 @@ again:
 
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
+		/*
+		 * No need to test for lock since may_wait_transaction will only
+		 * return 1 if we had to take the trans_mutex anyway.
+		 */
+		mutex_unlock(&root->fs_info->trans_mutex);
 		btrfs_commit_transaction(h, root);
 		goto again;
 	}
@@ -225,6 +229,8 @@ again:
 		ret = btrfs_trans_reserve_metadata(h, root, num_items);
 		if (ret == -EAGAIN && !retries) {
 			retries++;
+			if (lock)
+				mutex_unlock(&root->fs_info->trans_mutex);
 			btrfs_commit_transaction(h, root);
 			goto again;
 		} else if (ret == -EAGAIN) {
@@ -236,15 +242,15 @@ again:
 		}
 
 		if (ret < 0) {
+			if (lock)
+				mutex_unlock(&root->fs_info->trans_mutex);
 			btrfs_end_transaction(h, root);
 			return ERR_PTR(ret);
 		}
 	}
 
-	if (type != TRANS_JOIN_NOLOCK)
-		mutex_lock(&root->fs_info->trans_mutex);
 	record_root_in_trans(h, root);
-	if (type != TRANS_JOIN_NOLOCK)
+	if (lock)
 		mutex_unlock(&root->fs_info->trans_mutex);
 
 	if (!current->journal_info && type != TRANS_USERSPACE)
-- 
1.7.2.3

