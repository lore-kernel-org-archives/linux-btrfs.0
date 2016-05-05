Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47177 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbcEEQoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 12:44:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7FF1203B8
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:44:18 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id C8094203A5
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:44:17 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: pin logs earlier when doing a rename exchange operation
Date: Thu,  5 May 2016 02:34:16 +0100
Message-Id: <1462412056-27878-3-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1462412056-27878-1-git-send-email-fdmanana@kernel.org>
References: <1462412056-27878-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The btrfs_rename_exchange() started as a copy-paste from btrfs_rename(),
which had a race fixed by my previous patch titled "Btrfs: pin log earlier
when renaming", and so it suffers from the same problem.

We pin the logs of the affected roots after we insert the new inode
references, leaving a time window where concurrent tasks logging the
inodes can end up logging both the new and old references, resulting
in log trees that when replayed can turn the metadata into inconsistent
states. This behaviour was added to btrfs_rename() in 2009 without any
explanation about why not pinning the logs earlier, just leaving a
comment about the posibility for the race. As of today it's perfectly
safe and sane to pin the logs before we start doing any of the steps
involved in the rename operation.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 503d749..dab6c08f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9458,6 +9458,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(root->fs_info, trans);
 	} else {
+		btrfs_pin_log_trans(root);
+		root_log_pinned = true;
 		ret = btrfs_insert_inode_ref(trans, dest,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
@@ -9465,8 +9467,6 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					     btrfs_ino(new_dir), old_idx);
 		if (ret)
 			goto out_fail;
-		btrfs_pin_log_trans(root);
-		root_log_pinned = true;
 	}
 
 	/* And now for the dest. */
@@ -9474,6 +9474,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(dest->fs_info, trans);
 	} else {
+		btrfs_pin_log_trans(dest);
+		dest_log_pinned = true;
 		ret = btrfs_insert_inode_ref(trans, root,
 					     old_dentry->d_name.name,
 					     old_dentry->d_name.len,
@@ -9481,8 +9483,6 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					     btrfs_ino(old_dir), new_idx);
 		if (ret)
 			goto out_fail;
-		btrfs_pin_log_trans(dest);
-		dest_log_pinned = true;
 	}
 
 	/* Update inode version and ctime/mtime. */
-- 
2.7.0.rc3

