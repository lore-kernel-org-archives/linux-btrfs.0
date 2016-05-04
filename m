Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60330 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbcEDJxO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 05:53:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7C3ED2038D
	for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2016 09:53:13 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 5F37F20394
	for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2016 09:53:12 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: unpin log if rename operation fails
Date: Wed,  4 May 2016 02:49:38 +0100
Message-Id: <1462326578-6188-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If rename operations fail at some point after we pinned the log, we end
up aborting the current transaction but never unpin the log, which leaves
concurrent tasks that are trying to sync the log (as part of an fsync
request from user space) blocked forever and preventing the filesystem
from being unmountable.

Fix this by safely unpinning the log.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0085899..f6d7d9b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9406,6 +9406,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u64 root_objectid;
 	int ret;
 	u64 old_ino = btrfs_ino(old_inode);
+	bool log_pinned = false;
 
 	if (btrfs_ino(new_dir) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
@@ -9493,6 +9494,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		 * we unlink the name but before we add the new name back in.
 		 */
 		btrfs_pin_log_trans(root);
+		log_pinned = true;
 	}
 
 	inode_inc_iversion(old_dir);
@@ -9559,12 +9561,36 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_inode->i_nlink == 1)
 		BTRFS_I(old_inode)->dir_index = index;
 
-	if (old_ino != BTRFS_FIRST_FREE_OBJECTID) {
+	if (log_pinned) {
 		struct dentry *parent = new_dentry->d_parent;
+
 		btrfs_log_new_name(trans, old_inode, old_dir, parent);
 		btrfs_end_log_trans(root);
+		log_pinned = false;
 	}
 out_fail:
+	/*
+	 * If we have pinned the log and an error happened, we unpin tasks
+	 * trying to sync the log and force them to fallback to a transaction
+	 * commit if the log currently contains any of the inodes involved in
+	 * this rename operation (to ensure we do not persist a log with an
+	 * inconsistent state for any of these inodes or leading to any
+	 * inconsistencies when replayed). If the transaction was aborted, the
+	 * abortion reason is propagated to userspace when attempting to commit
+	 * the transaction. If the log does not contain any of these inodes, we
+	 * allow the tasks to sync it.
+	 */
+	if (ret && log_pinned) {
+		if (btrfs_inode_in_log(old_dir, root->fs_info->generation) ||
+		    btrfs_inode_in_log(new_dir, root->fs_info->generation) ||
+		    btrfs_inode_in_log(old_inode, root->fs_info->generation) ||
+		    (new_inode &&
+		     btrfs_inode_in_log(new_inode, root->fs_info->generation)))
+		    btrfs_set_log_full_commit(root->fs_info, trans);
+
+		btrfs_end_log_trans(root);
+		log_pinned = false;
+	}
 	btrfs_end_transaction(trans, root);
 out_notrans:
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
-- 
2.7.0.rc3

