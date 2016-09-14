Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48542 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755488AbcINCK0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 22:10:26 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: remove BUG_ON in start_transaction
Date: Tue, 13 Sep 2016 19:15:48 -0700
Message-Id: <1473819348-8681-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we could get errors from the concurrent aborted transaction,
the check of this BUG_ON in start_transaction is not true any more.

Say, while flushing free space cache inode's dirty pages,
btrfs_finish_ordered_io
 -> btrfs_join_transaction_nolock
      (the transaction has been aborted.)
      -> BUG_ON(type == TRANS_JOIN_NOLOCK);

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/transaction.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 95d4191..6d06365 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -549,11 +549,8 @@ again:
 		}
 	} while (ret == -EBUSY);
 
-	if (ret < 0) {
-		/* We must get the transaction if we are JOIN_NOLOCK. */
-		BUG_ON(type == TRANS_JOIN_NOLOCK);
+	if (ret < 0)
 		goto join_fail;
-	}
 
 	cur_trans = root->fs_info->running_transaction;
 
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
