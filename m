Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60363 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbcEDJxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 05:53:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B51F32038F
	for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2016 09:53:38 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 998C22038D
	for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2016 09:53:37 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: pin log earlier when renaming
Date: Wed,  4 May 2016 02:50:06 +0100
Message-Id: <1462326606-12460-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We were pinning the log right after the first step in the rename operation
(inserting inode ref for the new name in the destination directory)
instead of doing it before. This behaviour was introduced in 2009 for some
reason that was not mentioned neither on the changelog nor any comment,
with the drawback of a small time window where concurrent log writers can
end up logging the new inode reference for the inode we are renaming while
the rename operation is in progress (so that we can end up with a log
containing both the new and old references). As of today there's no reason
to not pin the log before that first step anymore, so just fix this.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f6d7d9b..7b4fb70 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9479,6 +9479,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(root->fs_info, trans);
 	} else {
+		btrfs_pin_log_trans(root);
+		log_pinned = true;
 		ret = btrfs_insert_inode_ref(trans, dest,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
@@ -9486,15 +9488,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					     btrfs_ino(new_dir), index);
 		if (ret)
 			goto out_fail;
-		/*
-		 * this is an ugly little race, but the rename is required
-		 * to make sure that if we crash, the inode is either at the
-		 * old name or the new one.  pinning the log transaction lets
-		 * us make sure we don't allow a log commit to come in after
-		 * we unlink the name but before we add the new name back in.
-		 */
-		btrfs_pin_log_trans(root);
-		log_pinned = true;
 	}
 
 	inode_inc_iversion(old_dir);
-- 
2.7.0.rc3

