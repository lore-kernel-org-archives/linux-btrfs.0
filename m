Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43575 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753336AbdLOKGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 05:06:21 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5B714ACAC
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 10:06:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove unused btrfs_start_transaction_lflush function
Date: Fri, 15 Dec 2017 12:06:18 +0200
Message-Id: <1513332378-7193-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 0e8c36a9fd81 ("Btrfs: fix lots of orphan inodes when the space
is not enough") changed the way transaction reservation is made in
btrfs_evict_node and as a result this function became unused. This has
been the status quo for 5 years in which time no one noticed, so I'd
say it's safe to assume it's unlikely it will ever be used again.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 10 +---------
 fs/btrfs/transaction.h |  3 ---
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5a8c2649af2f..b1793688c716 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -542,7 +542,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	 * and then we deadlock with somebody doing a freeze.
 	 *
 	 * If we are ATTACH, it means we just want to catch the current
-	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
+	 * transaction and commit it, so we needn't do sb_start_intwrite().
 	 */
 	if (type & __TRANS_FREEZABLE)
 		sb_start_intwrite(fs_info->sb);
@@ -658,14 +658,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 	return trans;
 }
 
-struct btrfs_trans_handle *btrfs_start_transaction_lflush(
-					struct btrfs_root *root,
-					unsigned int num_items)
-{
-	return start_transaction(root, num_items, TRANS_START,
-				 BTRFS_RESERVE_FLUSH_LIMIT, true);
-}
-
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_JOIN, BTRFS_RESERVE_NO_FLUSH,
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index c55e44560103..9b25b0ba92ee 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -187,9 +187,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items,
 					int min_factor);
-struct btrfs_trans_handle *btrfs_start_transaction_lflush(
-					struct btrfs_root *root,
-					unsigned int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
-- 
2.7.4

