Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab3EOHsr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:47 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 12/17] Btrfs: remove the code for the impossible case in cleanup_transaction()
Date: Wed, 15 May 2013 15:48:26 +0800
Message-Id: <1368604111-25073-13-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the transaction is removed from the transaction list, it means the
transaction has been committed successfully. So it is impossible to
call cleanup_transaction(), otherwise there is something wrong with
the code logic. Thus, we use BUG_ON() instead of the original handle.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bc22be9..cf8706c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1450,11 +1450,12 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 
 	spin_lock(&root->fs_info->trans_lock);
 
-	if (list_empty(&cur_trans->list)) {
-		spin_unlock(&root->fs_info->trans_lock);
-		btrfs_end_transaction(trans, root);
-		return;
-	}
+	/*
+	 * If the transaction is removed from the list, it means this
+	 * transaction has been committed successfully, so it is impossible
+	 * to call the cleanup function.
+	 */
+	BUG_ON(list_empty(&cur_trans->list));
 
 	list_del_init(&cur_trans->list);
 	if (cur_trans == root->fs_info->running_transaction) {
-- 
1.8.1.4

