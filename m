Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbcEEQoR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 12:44:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E5F4203A5
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:44:16 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id B07B3203A0
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:44:14 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: fix inode leak on failure to setup whiteout inode in rename
Date: Thu,  5 May 2016 02:34:14 +0100
Message-Id: <1462412056-27878-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If we failed to fully setup the whiteout inode during a rename operation
with the whiteout flag, we ended up leaking the inode, not decrementing
its link count nor removing all its items from the fs/subvol tree.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 09947cb..ab64721 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9612,21 +9612,21 @@ static int btrfs_whiteout_for_rename(struct btrfs_trans_handle *trans,
 	ret = btrfs_init_inode_security(trans, inode, dir,
 				&dentry->d_name);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = btrfs_add_nondir(trans, dir, dentry,
 				inode, 0, index);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = btrfs_update_inode(trans, root, inode);
-	if (ret)
-		return ret;
-
+out:
 	unlock_new_inode(inode);
+	if (ret)
+		inode_dec_link_count(inode);
 	iput(inode);
 
-	return 0;
+	return ret;
 }
 
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-- 
2.7.0.rc3

