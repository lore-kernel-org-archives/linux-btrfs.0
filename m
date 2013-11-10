Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:48904 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751206Ab3KJLmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 06:42:11 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove unused parameters from wait_for_commit and btrfs_wait_marked_extents
Date: Sun, 10 Nov 2013 12:39:32 +0100
Message-Id: <1384083572-15443-1-git-send-email-valentina.giusti@microon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes the following warnings:
fs/btrfs/transaction.c: In function ‘wait_for_commit’:
fs/btrfs/transaction.c:560:57: warning: unused parameter ‘root’ [-Wunused-parameter]
fs/btrfs/transaction.c: In function ‘btrfs_wait_marked_extents’:
fs/btrfs/transaction.c:811:50: warning: unused parameter ‘mark’ [-Wunused-parameter]

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/transaction.c |   13 ++++++-------
 fs/btrfs/transaction.h |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8c81bdc..f555231 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -557,8 +557,7 @@ btrfs_attach_transaction_barrier(struct btrfs_root *root)
 }
 
 /* wait for a transaction commit to be fully complete */
-static noinline void wait_for_commit(struct btrfs_root *root,
-				    struct btrfs_transaction *commit)
+static noinline void wait_for_commit(struct btrfs_transaction *commit)
 {
 	wait_event(commit->commit_wait, commit->state == TRANS_STATE_COMPLETED);
 }
@@ -609,7 +608,7 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 			goto out;  /* nothing committing|committed */
 	}
 
-	wait_for_commit(root, cur_trans);
+	wait_for_commit(cur_trans);
 	put_transaction(cur_trans);
 out:
 	return ret;
@@ -808,7 +807,7 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
  * on all the pages and clear them from the dirty pages state tree
  */
 int btrfs_wait_marked_extents(struct btrfs_root *root,
-			      struct extent_io_tree *dirty_pages, int mark)
+			      struct extent_io_tree *dirty_pages)
 {
 	int err = 0;
 	int werr = 0;
@@ -847,7 +846,7 @@ static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 	blk_start_plug(&plug);
 	ret = btrfs_write_marked_extents(root, dirty_pages, mark);
 	blk_finish_plug(&plug);
-	ret2 = btrfs_wait_marked_extents(root, dirty_pages, mark);
+	ret2 = btrfs_wait_marked_extents(root, dirty_pages);
 
 	if (ret)
 		return ret;
@@ -1667,7 +1666,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		atomic_inc(&cur_trans->use_count);
 		ret = btrfs_end_transaction(trans, root);
 
-		wait_for_commit(root, cur_trans);
+		wait_for_commit(cur_trans);
 
 		put_transaction(cur_trans);
 
@@ -1684,7 +1683,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			atomic_inc(&prev_trans->use_count);
 			spin_unlock(&root->fs_info->trans_lock);
 
-			wait_for_commit(root, prev_trans);
+			wait_for_commit(prev_trans);
 
 			put_transaction(prev_trans);
 		} else {
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5c2af84..f16ab19 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -163,7 +163,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 int btrfs_write_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_wait_marked_extents(struct btrfs_root *root,
-				struct extent_io_tree *dirty_pages, int mark);
+				struct extent_io_tree *dirty_pages);
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
 #endif
-- 
1.7.10.4

