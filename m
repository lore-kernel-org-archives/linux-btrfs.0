Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47169 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbcEEQoS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 12:44:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 79595203E3
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:44:17 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 57EB5203B8
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:44:16 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: unpin logs if rename exchange operation fails
Date: Thu,  5 May 2016 02:34:15 +0100
Message-Id: <1462412056-27878-2-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1462412056-27878-1-git-send-email-fdmanana@kernel.org>
References: <1462412056-27878-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If rename exchange operations fail at some point after we pinned any of
the logs, we end up aborting the current transaction but never unpin the
logs, which leaves concurrent tasks that are trying to sync the logs (as
part of an fsync request from user space) blocked forever and preventing
the filesystem from being unmountable.

Fix this by safely unpinning the log.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ab64721..503d749 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9412,6 +9412,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	u64 new_idx = 0;
 	u64 root_objectid;
 	int ret;
+	bool root_log_pinned = false;
+	bool dest_log_pinned = false;
 
 	/* we only allow rename subvolume link between subvolumes */
 	if (old_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
@@ -9464,6 +9466,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		if (ret)
 			goto out_fail;
 		btrfs_pin_log_trans(root);
+		root_log_pinned = true;
 	}
 
 	/* And now for the dest. */
@@ -9479,6 +9482,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		if (ret)
 			goto out_fail;
 		btrfs_pin_log_trans(dest);
+		dest_log_pinned = true;
 	}
 
 	/* Update inode version and ctime/mtime. */
@@ -9557,17 +9561,47 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	if (new_inode->i_nlink == 1)
 		BTRFS_I(new_inode)->dir_index = new_idx;
 
-	if (old_ino != BTRFS_FIRST_FREE_OBJECTID) {
+	if (root_log_pinned) {
 		parent = new_dentry->d_parent;
 		btrfs_log_new_name(trans, old_inode, old_dir, parent);
 		btrfs_end_log_trans(root);
+		root_log_pinned = false;
 	}
-	if (new_ino != BTRFS_FIRST_FREE_OBJECTID) {
+	if (dest_log_pinned) {
 		parent = old_dentry->d_parent;
 		btrfs_log_new_name(trans, new_inode, new_dir, parent);
 		btrfs_end_log_trans(dest);
+		dest_log_pinned = false;
 	}
 out_fail:
+	/*
+	 * If we have pinned a log and an error happened, we unpin tasks
+	 * trying to sync the log and force them to fallback to a transaction
+	 * commit if the log currently contains any of the inodes involved in
+	 * this rename operation (to ensure we do not persist a log with an
+	 * inconsistent state for any of these inodes or leading to any
+	 * inconsistencies when replayed). If the transaction was aborted, the
+	 * abortion reason is propagated to userspace when attempting to commit
+	 * the transaction. If the log does not contain any of these inodes, we
+	 * allow the tasks to sync it.
+	 */
+	if (ret && (root_log_pinned || dest_log_pinned)) {
+		if (btrfs_inode_in_log(old_dir, root->fs_info->generation) ||
+		    btrfs_inode_in_log(new_dir, root->fs_info->generation) ||
+		    btrfs_inode_in_log(old_inode, root->fs_info->generation) ||
+		    (new_inode &&
+		     btrfs_inode_in_log(new_inode, root->fs_info->generation)))
+		    btrfs_set_log_full_commit(root->fs_info, trans);
+
+		if (root_log_pinned) {
+			btrfs_end_log_trans(root);
+			root_log_pinned = false;
+		}
+		if (dest_log_pinned) {
+			btrfs_end_log_trans(dest);
+			dest_log_pinned = false;
+		}
+	}
 	ret = btrfs_end_transaction(trans, root);
 out_notrans:
 	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
-- 
2.7.0.rc3

