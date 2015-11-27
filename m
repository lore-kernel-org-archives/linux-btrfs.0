Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44651 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbbK0Qje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 11:39:34 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix memory leaks after transaction is aborted
Date: Fri, 27 Nov 2015 16:39:29 +0000
Message-Id: <1448642369-28264-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When a transaction is aborted, or its commit fails before writing the new
superblock and calling btrfs_finish_extent_commit(), we leak reference
counts on the block groups attached to the transaction's delete_bgs list,
because btrfs_finish_extent_commit() is never called for those two cases.
Fix this by dropping their references at btrfs_put_transaction(), which
is called when transactions are aborted (by making the transaction kthread
commit the transaction) or if their commits fail.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index be8eae8..f85ccf6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -75,6 +75,23 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 			list_del_init(&em->list);
 			free_extent_map(em);
 		}
+		/*
+		 * If any block groups are found in ->deleted_bgs then it's
+		 * because the transaction was aborted and a commit did not
+		 * happen (things failed before writing the new superblock
+		 * and calling btrfs_finish_extent_commit()), so we can not
+		 * discard the physical locations of the block groups.
+		 */
+		while (!list_empty(&transaction->deleted_bgs)) {
+			struct btrfs_block_group_cache *cache;
+
+			cache = list_first_entry(&transaction->deleted_bgs,
+						 struct btrfs_block_group_cache,
+						 bg_list);
+			list_del_init(&cache->bg_list);
+			btrfs_put_block_group_trimming(cache);
+			btrfs_put_block_group(cache);
+		}
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
 	}
 }
-- 
2.1.3

