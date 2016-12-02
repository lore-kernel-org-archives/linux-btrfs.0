Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752779AbcLBFHw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 493A9ABD3
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:51 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 18/18] btrfs: split btrfs_wait_marked_extents into normal and tree log functions
Date: Fri,  2 Dec 2016 00:07:38 -0500
Message-Id: <1480655258-15400-19-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_write_and_wait_marked_extents and btrfs_sync_log both call
btrfs_wait_marked_extents, which provides a core loop and then handles
errors differently based on whether it's it's a log root or not.

This means that btrfs_write_and_wait_marked_extents needs to take a root
because btrfs_wait_marked_extents requires one, even though it's only
used to determine whether the root is a log root.  The log root code
won't ever call into the transaction commit code using a log root, so we
can factor out the core loop and provide the error handling appropriate
to each waiter in new routines.  This allows us to eventually remove
the root argument from btrfs_commit_transaction, and as a result,
btrfs_end_transaction.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/transaction.c | 79 +++++++++++++++++++++++++++++++-------------------
 fs/btrfs/transaction.h |  5 ++--
 fs/btrfs/tree-log.c    | 14 ++++-----
 3 files changed, 58 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8667a99..a23fedd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -957,11 +957,11 @@ int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
 		 * time a temporary error. So when it happens, ignore the error
 		 * and wait for writeback of this range to finish - because we
 		 * failed to set the bit EXTENT_NEED_WAIT for the range, a call
-		 * to btrfs_wait_marked_extents() would not know that writeback
-		 * for this range started and therefore wouldn't wait for it to
-		 * finish - we don't want to commit a superblock that points to
-		 * btree nodes/leafs for which writeback hasn't finished yet
-		 * (and without errors).
+		 * to __btrfs_wait_marked_extents() would not know that
+		 * writeback for this range started and therefore wouldn't
+		 * wait for it to finish - we don't want to commit a
+		 * superblock that points to btree nodes/leafs for which
+		 * writeback hasn't finished yet (and without errors).
 		 * We cleanup any entries left in the io tree when committing
 		 * the transaction (through clear_btree_io_tree()).
 		 */
@@ -989,17 +989,15 @@ int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
  * those extents are on disk for transaction or log commit.  We wait
  * on all the pages and clear them from the dirty pages state tree
  */
-int btrfs_wait_marked_extents(struct btrfs_root *root,
-			      struct extent_io_tree *dirty_pages, int mark)
+static int __btrfs_wait_marked_extents(struct btrfs_fs_info *fs_info,
+				       struct extent_io_tree *dirty_pages)
 {
 	int err = 0;
 	int werr = 0;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct address_space *mapping = fs_info->btree_inode->i_mapping;
 	struct extent_state *cached_state = NULL;
 	u64 start = 0;
 	u64 end;
-	bool errors = false;
 
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
 				      EXTENT_NEED_WAIT, &cached_state)) {
@@ -1027,24 +1025,45 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 	}
 	if (err)
 		werr = err;
+	return werr;
+}
 
-	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
-		if ((mark & EXTENT_DIRTY) &&
-		    test_and_clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags))
-			errors = true;
+int btrfs_wait_extents(struct btrfs_fs_info *fs_info,
+		       struct extent_io_tree *dirty_pages)
+{
+	bool errors = false;
+	int err;
 
-		if ((mark & EXTENT_NEW) &&
-		    test_and_clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags))
-			errors = true;
-	} else {
-		if (test_and_clear_bit(BTRFS_FS_BTREE_ERR, &fs_info->flags))
-			errors = true;
-	}
+	err = __btrfs_wait_marked_extents(fs_info, dirty_pages);
+	if (test_and_clear_bit(BTRFS_FS_BTREE_ERR, &fs_info->flags))
+		errors = true;
+
+	if (errors && !err)
+		err = -EIO;
+	return err;
+}
 
-	if (errors && !werr)
-		werr = -EIO;
+int btrfs_wait_tree_log_extents(struct btrfs_root *log_root, int mark)
+{
+	struct btrfs_fs_info *fs_info = log_root->fs_info;
+	struct extent_io_tree *dirty_pages = &log_root->dirty_log_pages;
+	bool errors = false;
+	int err;
 
-	return werr;
+	ASSERT(log_root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+
+	err = __btrfs_wait_marked_extents(fs_info, dirty_pages);
+	if ((mark & EXTENT_DIRTY) &&
+	    test_and_clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags))
+		errors = true;
+
+	if ((mark & EXTENT_NEW) &&
+	    test_and_clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags))
+		errors = true;
+
+	if (errors && !err)
+		err = -EIO;
+	return err;
 }
 
 /*
@@ -1052,7 +1071,7 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
  * them in one of two extent_io trees.  This is used to make sure all of
  * those extents are on disk for transaction or log commit
  */
-static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
+static int btrfs_write_and_wait_marked_extents(struct btrfs_fs_info *fs_info,
 				struct extent_io_tree *dirty_pages, int mark)
 {
 	int ret;
@@ -1060,9 +1079,9 @@ static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 	struct blk_plug plug;
 
 	blk_start_plug(&plug);
-	ret = btrfs_write_marked_extents(root->fs_info, dirty_pages, mark);
+	ret = btrfs_write_marked_extents(fs_info, dirty_pages, mark);
 	blk_finish_plug(&plug);
-	ret2 = btrfs_wait_marked_extents(root, dirty_pages, mark);
+	ret2 = btrfs_wait_extents(fs_info, dirty_pages);
 
 	if (ret)
 		return ret;
@@ -1072,11 +1091,11 @@ static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 }
 
 static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-					    struct btrfs_root *root)
+					    struct btrfs_fs_info *fs_info)
 {
 	int ret;
 
-	ret = btrfs_write_and_wait_marked_extents(root,
+	ret = btrfs_write_and_wait_marked_extents(fs_info,
 					   &trans->transaction->dirty_pages,
 					   EXTENT_DIRTY);
 	clear_btree_io_tree(&trans->transaction->dirty_pages);
@@ -1384,7 +1403,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 	switch_commit_roots(trans->transaction, fs_info);
-	ret = btrfs_write_and_wait_transaction(trans, src);
+	ret = btrfs_write_and_wait_transaction(trans, fs_info);
 	if (ret)
 		btrfs_handle_fs_error(fs_info, ret,
 			"Error while writing out transaction for qgroup");
@@ -2231,7 +2250,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	wake_up(&fs_info->transaction_wait);
 
-	ret = btrfs_write_and_wait_transaction(trans, root);
+	ret = btrfs_write_and_wait_transaction(trans, fs_info);
 	if (ret) {
 		btrfs_handle_fs_error(fs_info, ret,
 				      "Error while writing out transaction");
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index b005371..1c43ed3 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -221,8 +221,9 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
 				struct extent_io_tree *dirty_pages, int mark);
-int btrfs_wait_marked_extents(struct btrfs_root *root,
-				struct extent_io_tree *dirty_pages, int mark);
+int btrfs_wait_extents(struct btrfs_fs_info *fs_info,
+		       struct extent_io_tree *dirty_pages);
+int btrfs_wait_tree_log_extents(struct btrfs_root *root, int mark);
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
 void btrfs_put_transaction(struct btrfs_transaction *transaction);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0cde002..61c7f6f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2870,7 +2870,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 			mutex_unlock(&log_root_tree->log_mutex);
 			goto out;
 		}
-		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+		btrfs_wait_tree_log_extents(log, mark);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = -EAGAIN;
@@ -2888,8 +2888,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	index2 = root_log_ctx.log_transid % 2;
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
 		blk_finish_plug(&plug);
-		ret = btrfs_wait_marked_extents(log, &log->dirty_log_pages,
-						mark);
+		ret = btrfs_wait_tree_log_extents(log, mark);
 		btrfs_wait_logged_extents(trans, log, log_transid);
 		wait_log_commit(log_root_tree,
 				root_log_ctx.log_transid);
@@ -2914,7 +2913,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 */
 	if (btrfs_need_log_full_commit(fs_info, trans)) {
 		blk_finish_plug(&plug);
-		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+		btrfs_wait_tree_log_extents(log, mark);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = -EAGAIN;
@@ -2932,11 +2931,10 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		mutex_unlock(&log_root_tree->log_mutex);
 		goto out_wake_log_root;
 	}
-	ret = btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+	ret = btrfs_wait_tree_log_extents(log, mark);
 	if (!ret)
-		ret = btrfs_wait_marked_extents(log_root_tree,
-						&log_root_tree->dirty_log_pages,
-						EXTENT_NEW | EXTENT_DIRTY);
+		ret = btrfs_wait_tree_log_extents(log_root_tree,
+						  EXTENT_NEW | EXTENT_DIRTY);
 	if (ret) {
 		btrfs_set_log_full_commit(fs_info, trans);
 		btrfs_free_logged_extents(log, log_transid);
-- 
2.7.1

