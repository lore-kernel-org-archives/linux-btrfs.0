Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35882 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdAQWjv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:39:51 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so41992974wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:39:40 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 01/24] btrfs: Make btrfs_must_commit_transaction take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:27 +0200
Message-Id: <1484692310-3987-2-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b814cd7bbe70..a2a822a993af 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5021,13 +5021,13 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
  * we logged the inode or it might have also done the unlink).
  */
 static bool btrfs_must_commit_transaction(struct btrfs_trans_handle *trans,
-					  struct inode *inode)
+					  struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	bool ret = false;
 
-	mutex_lock(&BTRFS_I(inode)->log_mutex);
-	if (BTRFS_I(inode)->last_unlink_trans > fs_info->last_trans_committed) {
+	mutex_lock(&inode->log_mutex);
+	if (inode->last_unlink_trans > fs_info->last_trans_committed) {
 		/*
 		 * Make sure any commits to the log are forced to be full
 		 * commits.
@@ -5035,7 +5035,7 @@ static bool btrfs_must_commit_transaction(struct btrfs_trans_handle *trans,
 		btrfs_set_log_full_commit(fs_info, trans);
 		ret = true;
 	}
-	mutex_unlock(&BTRFS_I(inode)->log_mutex);
+	mutex_unlock(&inode->log_mutex);
 
 	return ret;
 }
@@ -5084,7 +5084,7 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 			BTRFS_I(inode)->logged_trans = trans->transid;
 		smp_mb();
 
-		if (btrfs_must_commit_transaction(trans, inode)) {
+		if (btrfs_must_commit_transaction(trans, BTRFS_I(inode))) {
 			ret = 1;
 			break;
 		}
@@ -5094,7 +5094,7 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 
 		if (IS_ROOT(parent)) {
 			inode = d_inode(parent);
-			if (btrfs_must_commit_transaction(trans, inode))
+			if (btrfs_must_commit_transaction(trans, BTRFS_I(inode)))
 				ret = 1;
 			break;
 		}
@@ -5248,7 +5248,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 			ret = btrfs_log_inode(trans, root, di_inode,
 					      log_mode, 0, LLONG_MAX, ctx);
 			if (!ret &&
-			    btrfs_must_commit_transaction(trans, di_inode))
+			    btrfs_must_commit_transaction(trans, BTRFS_I(di_inode)))
 				ret = 1;
 			iput(di_inode);
 			if (ret)
@@ -5368,7 +5368,7 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 			ret = btrfs_log_inode(trans, root, dir_inode,
 					      LOG_INODE_ALL, 0, LLONG_MAX, ctx);
 			if (!ret &&
-			    btrfs_must_commit_transaction(trans, dir_inode))
+			    btrfs_must_commit_transaction(trans, BTRFS_I(dir_inode)))
 				ret = 1;
 			if (!ret && ctx && ctx->log_new_dentries)
 				ret = log_new_dir_dentries(trans, root,
-- 
2.7.4

