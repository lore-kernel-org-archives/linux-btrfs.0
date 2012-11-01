Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10379 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2KAHcx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 03:32:53 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qA17WpRU031160
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 15:32:51 +0800
Message-ID: <509225BA.4080105@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 15:33:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] Btrfs: fix missing flush when committing a transaction
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Consider the following case:
	Task1				Task2
	start_transaction
					commit_transaction
					  check pending snapshots list and the
					  list is empty.
	add pending snapshot into list
					  skip the delalloc flush
	end_transaction
					  ...

And then the problem that the snapshot is different with the source subvolume
happen.

This patch fixes the above problem by flush all pending stuffs when all the
other tasks end the transaction.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   74 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6d0d5a0..d9a9a70 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1401,6 +1401,48 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 }
 
+static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root)
+{
+	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
+	int snap_pending = 0;
+	int ret;
+
+	if (!flush_on_commit) {
+		spin_lock(&root->fs_info->trans_lock);
+		if (!list_empty(&trans->transaction->pending_snapshots))
+			snap_pending = 1;
+		spin_unlock(&root->fs_info->trans_lock);
+	}
+
+	if (flush_on_commit || snap_pending) {
+		btrfs_start_delalloc_inodes(root, 1);
+		btrfs_wait_ordered_extents(root, 1);
+	}
+
+	ret = btrfs_run_delayed_items(trans, root);
+	if (ret)
+		return ret;
+
+	/*
+	 * running the delayed items may have added new refs. account
+	 * them now so that they hinder processing of more delayed refs
+	 * as little as possible.
+	 */
+	btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
+
+	/*
+	 * rename don't use btrfs_join_transaction, so, once we
+	 * set the transaction to blocked above, we aren't going
+	 * to get any new ordered operations.  We can safely run
+	 * it here and no for sure that nothing new will be added
+	 * to the list
+	 */
+	btrfs_run_ordered_operations(root, 1);
+
+	return 0;
+}
+
 /*
  * btrfs_transaction state sequence:
  *    in_commit = 0, blocked = 0  (initial)
@@ -1418,7 +1460,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	int ret = -EIO;
 	int should_grow = 0;
 	unsigned long now = get_seconds();
-	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
 
 	btrfs_run_ordered_operations(root, 0);
 
@@ -1491,39 +1532,14 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		should_grow = 1;
 
 	do {
-		int snap_pending = 0;
-
 		joined = cur_trans->num_joined;
-		if (!list_empty(&trans->transaction->pending_snapshots))
-			snap_pending = 1;
 
 		WARN_ON(cur_trans != trans->transaction);
 
-		if (flush_on_commit || snap_pending) {
-			btrfs_start_delalloc_inodes(root, 1);
-			btrfs_wait_ordered_extents(root, 1);
-		}
-
-		ret = btrfs_run_delayed_items(trans, root);
+		ret = btrfs_flush_all_pending_stuffs(trans, root);
 		if (ret)
 			goto cleanup_transaction;
 
-		/*
-		 * running the delayed items may have added new refs. account
-		 * them now so that they hinder processing of more delayed refs
-		 * as little as possible.
-		 */
-		btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
-
-		/*
-		 * rename don't use btrfs_join_transaction, so, once we
-		 * set the transaction to blocked above, we aren't going
-		 * to get any new ordered operations.  We can safely run
-		 * it here and no for sure that nothing new will be added
-		 * to the list
-		 */
-		btrfs_run_ordered_operations(root, 1);
-
 		prepare_to_wait(&cur_trans->writer_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 
@@ -1536,6 +1552,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	} while (atomic_read(&cur_trans->num_writers) > 1 ||
 		 (should_grow && cur_trans->num_joined != joined));
 
+	ret = btrfs_flush_all_pending_stuffs(trans, root);
+	if (ret)
+		goto cleanup_transaction;
+
 	/*
 	 * Ok now we need to make sure to block out any other joins while we
 	 * commit the transaction.  We could have started a join before setting
-- 
1.7.6.5
