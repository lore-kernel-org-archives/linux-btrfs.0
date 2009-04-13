From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: fix throttle_on_drops deadlock with user transactions
Date: Mon, 13 Apr 2009 09:40:12 -0700
Message-ID: <1239640812-13453-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Starting in b7ec40d7845bffca8bb3af2ea3f192d6257bbe21, drop_dirty_roots()
tries to avoid generating delayed refs in a transaction that is currently
closing (and trying to flush dirty refs out) by waiting for it to close.
However, if a transaction is held open by a user space TRANS_START ioctl,
that will deadlock against throttle_on_drops().

The underlying problem is that by the time we are ready to wait in
wait_transaction_pre_flush(), drop_dirty_roots() has already signaled its
intent to drop in fs_info->throttles, and the process calling
throttle_on_drops() will block.  If the throttling process is part of a
user transaction, the transaction will never close and we deadlock.

Fix this by calling throttle_on_drops() only when we are very clearly
not part of a running user transaction (that is, when the open_ioctl_trans
counter is 0).  Then do the throttle explicitly in
btrfs_start_ioctl_transaction().

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/transaction.c |   40 ++++++++++++++++++++++++++++++++--------
 1 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2869b33..4a8d4f0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -207,12 +207,6 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 	return start_transaction(root, num_blocks, 0);
 }
 
-struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
-							 int num_blocks)
-{
-	return start_transaction(r, num_blocks, 2);
-}
-
 /* wait for a transaction commit to be fully complete */
 static noinline int wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
@@ -274,13 +268,35 @@ harder:
 	}
 }
 
+/*
+ * if we are starting a user transaction, throttle_on_drops here (the
+ * usual paths won't if the open_ioctl_trans count is non-zero).  and
+ * tell start_transaction it is safe to wait_current_trans even if
+ * other user transactions are open.
+ */
+struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
+							 int num_blocks)
+{
+	throttle_on_drops(r);
+	return start_transaction(r, num_blocks, 2);
+}
+
+/*
+ * if open_ioctl_trans>0, we may be part of a user transaction and it
+ * is not safe to wait_current_trans or throttle_on_drops.
+ */
 void btrfs_throttle(struct btrfs_root *root)
 {
+	int throttle = 1;
+
 	mutex_lock(&root->fs_info->trans_mutex);
-	if (!root->fs_info->open_ioctl_trans)
+	if (root->fs_info->open_ioctl_trans)
+		throttle = 0;
+	else
 		wait_current_trans(root);
 	mutex_unlock(&root->fs_info->trans_mutex);
-	throttle_on_drops(root);
+	if (throttle)
+		throttle_on_drops(root);
 }
 
 static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
@@ -319,6 +335,14 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (waitqueue_active(&cur_trans->writer_wait))
 		wake_up(&cur_trans->writer_wait);
 	put_transaction(cur_trans);
+
+	/*
+	 * if open_ioctl_trans>0, we may be part of a usertrans and it
+	 * is not safe to throttle_on_drops.
+	 */
+	if (root->fs_info->open_ioctl_trans)
+		throttle = 0;	
+
 	mutex_unlock(&info->trans_mutex);
 	memset(trans, 0, sizeof(*trans));
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-- 
1.5.6.5

