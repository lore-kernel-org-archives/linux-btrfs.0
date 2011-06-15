From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: fix deadlock when doing reservation
Date: Wed, 15 Jun 2011 18:47:43 +0800
Message-ID: <4DF88DCF.2030502@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following deadlock may happen when doing reservation for metadata:

Task0				Flush thread		Task1
start_transaction()
  shrink_delalloc()
    writeback_inodes_sb_nr()
      wait for flush thread
      end.
				btrfs_writepages()
				  cow_file_range()
							btrfs_commit_transaction
							  wait num_writer == 1
							  (wait Task0 end
							   transaction)
				  start_transaction()
				    wait trans commit
				    end

Task0 -> Flush thread -> Task1 -> Task0

Fix the above deadlock by doing reservation before the trans handle has
been joined into the transaction.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   25 +++++++++++++----------
 fs/btrfs/transaction.c |   51 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 50 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b42efc2..eefa432 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3290,9 +3290,11 @@ again:
 
 /*
  * shrink metadata reservation for delalloc
+ *
+ * NOTE: This function can not run in the transaction context, or deadlock
+ *       will happen.
  */
-static int shrink_delalloc(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 to_reclaim, int sync)
+static int shrink_delalloc(struct btrfs_root *root, u64 to_reclaim)
 {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_space_info *space_info;
@@ -3338,9 +3340,6 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 		if (reserved == 0 || reclaimed >= max_reclaim)
 			break;
 
-		if (trans && trans->transaction->blocked)
-			return -EAGAIN;
-
 		time_left = schedule_timeout_interruptible(1);
 
 		/* We were interrupted, exit */
@@ -3449,12 +3448,16 @@ again:
 	/*
 	 * We do synchronous shrinking since we don't actually unreserve
 	 * metadata until after the IO is completed.
+	 *
+	 * shrink_delalloc() can not run in the transaction context.
 	 */
-	ret = shrink_delalloc(trans, root, num_bytes, 1);
-	if (ret > 0)
-		return 0;
-	else if (ret < 0)
-		goto out;
+	if (!trans || !trans->transaction) {
+		ret = shrink_delalloc(root, num_bytes);
+		if (ret > 0)
+			return 0;
+		else if (ret < 0)
+			goto out;
+	}
 
 	/*
 	 * So if we were overcommitted it's possible that somebody else flushed
@@ -3989,7 +3992,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
 	if (block_rsv->size > 512 * 1024 * 1024)
-		shrink_delalloc(NULL, root, to_reserve, 0);
+		shrink_delalloc(root, to_reserve);
 
 	return 0;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2b3590b..173b15d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -222,9 +222,31 @@ again:
 	if (!h)
 		return ERR_PTR(-ENOMEM);
 
+	h->transid = 0;
+	h->transaction = NULL;
+	h->blocks_used = 0;
+	h->bytes_reserved = 0;
+	h->delayed_ref_updates = 0;
+	h->use_count = 1;
+	h->block_rsv = NULL;
+	h->orig_rsv = NULL;
+
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
 
+	if (num_items > 0) {
+		/*
+		 * Now the handle has not been joined into the transaction,
+		 * so btrfs will shrink metadata reservation for delalloc if
+		 * there is no enough free space to reserve.
+		 */
+		ret = btrfs_trans_reserve_metadata(h, root, num_items);
+		if (ret < 0 && ret != -EAGAIN) {
+			kmem_cache_free(btrfs_trans_handle_cachep, h);
+			return ERR_PTR(ret);
+		}
+	}
+
 	do {
 		ret = join_transaction(root, type == TRANS_JOIN_NOLOCK);
 		if (ret == -EBUSY)
@@ -232,6 +254,7 @@ again:
 	} while (ret == -EBUSY);
 
 	if (ret < 0) {
+		btrfs_trans_release_metadata(h, root);
 		kmem_cache_free(btrfs_trans_handle_cachep, h);
 		return ERR_PTR(ret);
 	}
@@ -240,12 +263,6 @@ again:
 
 	h->transid = cur_trans->transid;
 	h->transaction = cur_trans;
-	h->blocks_used = 0;
-	h->bytes_reserved = 0;
-	h->delayed_ref_updates = 0;
-	h->use_count = 1;
-	h->block_rsv = NULL;
-	h->orig_rsv = NULL;
 
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
@@ -253,21 +270,25 @@ again:
 		goto again;
 	}
 
-	if (num_items > 0) {
-		ret = btrfs_trans_reserve_metadata(h, root, num_items);
-		if (ret == -EAGAIN && !retries) {
+	/*
+	 * Though we shrink metadata reservation for delalloc, we might still
+	 * not get enough free space, so we will commit the transaction and try
+	 * to reclaim the reservation.
+	 *
+	 * NOTE: In the transaction context, we won't shrink metadata
+	 *       reservation for delalloc, or the deadlock will happen.
+	 */
+	if (num_items > 0 && !h->bytes_reserved) {
+		if (!retries) {
 			retries++;
 			btrfs_commit_transaction(h, root);
 			goto again;
-		} else if (ret == -EAGAIN) {
+		} else {
 			/*
-			 * We have already retried and got EAGAIN, so really we
-			 * don't have space, so set ret to -ENOSPC.
+			 * We have already retried, so really we don't have
+			 * space, so set ret to -ENOSPC.
 			 */
 			ret = -ENOSPC;
-		}
-
-		if (ret < 0) {
 			btrfs_end_transaction(h, root);
 			return ERR_PTR(ret);
 		}
-- 
1.7.4
