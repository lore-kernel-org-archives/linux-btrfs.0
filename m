Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60477 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3JGTMj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 15:12:39 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 549489A035C
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 13:12:39 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id gkto1dsnRnZc7cC3 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 13:12:38 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup reserved space when freeing tree log on error
Date: Mon, 7 Oct 2013 15:12:36 -0400
Message-ID: <1381173156-6573-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On error we will wait and free the tree log at unmount without a transaction.
This means that the actual freeing of the blocks doesn't happen which means we
complain about space leaks on unmount.  So to fix this just skip the transaction
specific cleanup part of the tree log free'ing if we don't have a transaction
and that way we can free up our reserved space and our counters stay happy.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 964c583..849b729 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2151,11 +2151,13 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 					return ret;
 				}
 
-				btrfs_tree_lock(next);
-				btrfs_set_lock_blocking(next);
-				clean_tree_block(trans, root, next);
-				btrfs_wait_tree_block_writeback(next);
-				btrfs_tree_unlock(next);
+				if (trans) {
+					btrfs_tree_lock(next);
+					btrfs_set_lock_blocking(next);
+					clean_tree_block(trans, root, next);
+					btrfs_wait_tree_block_writeback(next);
+					btrfs_tree_unlock(next);
+				}
 
 				WARN_ON(root_owner !=
 					BTRFS_TREE_LOG_OBJECTID);
@@ -2227,11 +2229,13 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 
 				next = path->nodes[*level];
 
-				btrfs_tree_lock(next);
-				btrfs_set_lock_blocking(next);
-				clean_tree_block(trans, root, next);
-				btrfs_wait_tree_block_writeback(next);
-				btrfs_tree_unlock(next);
+				if (trans) {
+					btrfs_tree_lock(next);
+					btrfs_set_lock_blocking(next);
+					clean_tree_block(trans, root, next);
+					btrfs_wait_tree_block_writeback(next);
+					btrfs_tree_unlock(next);
+				}
 
 				WARN_ON(root_owner != BTRFS_TREE_LOG_OBJECTID);
 				ret = btrfs_free_and_pin_reserved_extent(root,
@@ -2301,11 +2305,13 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 
 			next = path->nodes[orig_level];
 
-			btrfs_tree_lock(next);
-			btrfs_set_lock_blocking(next);
-			clean_tree_block(trans, log, next);
-			btrfs_wait_tree_block_writeback(next);
-			btrfs_tree_unlock(next);
+			if (trans) {
+				btrfs_tree_lock(next);
+				btrfs_set_lock_blocking(next);
+				clean_tree_block(trans, log, next);
+				btrfs_wait_tree_block_writeback(next);
+				btrfs_tree_unlock(next);
+			}
 
 			WARN_ON(log->root_key.objectid !=
 				BTRFS_TREE_LOG_OBJECTID);
@@ -2608,13 +2614,10 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 		.process_func = process_one_buffer
 	};
 
-	if (trans) {
-		ret = walk_log_tree(trans, log, &wc);
-
-		/* I don't think this can happen but just in case */
-		if (ret)
-			btrfs_abort_transaction(trans, log, ret);
-	}
+	ret = walk_log_tree(trans, log, &wc);
+	/* I don't think this can happen but just in case */
+	if (ret)
+		btrfs_abort_transaction(trans, log, ret);
 
 	while (1) {
 		ret = find_first_extent_bit(&log->dirty_log_pages,
-- 
1.8.3.1

