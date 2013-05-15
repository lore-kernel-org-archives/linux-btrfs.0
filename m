Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab3EOHss (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:48 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 16/17] Btrfs: remove the time check in btrfs_commit_transaction()
Date: Wed, 15 May 2013 15:48:30 +0800
Message-Id: <1368604111-25073-17-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We checked the commit time to avoid committing the transaction
frequently, but it is unnecessary because:
- It made the transaction commit spend more time, and delayed the
  operation of the external writers(TRANS_START/TRANS_USERSPACE).
- Except the space that we have to commit transaction, such as
  snapshot creation, btrfs doesn't commit the transaction on its
  own initiative.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 75e7b15..5e75ff4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1566,10 +1566,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
-	DEFINE_WAIT(wait);
 	int ret;
-	int should_grow = 0;
-	unsigned long now = get_seconds();
 
 	ret = btrfs_run_ordered_operations(trans, root, 0);
 	if (ret) {
@@ -1660,28 +1657,14 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto cleanup_transaction;
 
-	if (!btrfs_test_opt(root, SSD) &&
-	    (now < cur_trans->start_time || now - cur_trans->start_time < 1))
-		should_grow = 1;
-
-	do {
-		WARN_ON(cur_trans != trans->transaction);
-
-		ret = btrfs_flush_all_pending_stuffs(trans, root);
-		if (ret)
-			goto cleanup_transaction;
-
-		prepare_to_wait(&cur_trans->writer_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-
-		if (extwriter_counter_read(cur_trans) > 0)
-			schedule();
-		else if (should_grow)
-			schedule_timeout(1);
+	ret = btrfs_flush_all_pending_stuffs(trans, root);
+	if (ret)
+		goto cleanup_transaction;
 
-		finish_wait(&cur_trans->writer_wait, &wait);
-	} while (extwriter_counter_read(cur_trans) > 0);
+	wait_event(cur_trans->writer_wait,
+		   extwriter_counter_read(cur_trans) == 0);
 
+	/* some pending stuffs might be added after the previous flush. */
 	ret = btrfs_flush_all_pending_stuffs(trans, root);
 	if (ret)
 		goto cleanup_transaction;
-- 
1.8.1.4

