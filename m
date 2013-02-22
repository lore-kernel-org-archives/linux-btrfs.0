Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27163 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3BVIMw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 03:12:52 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marios Titas <redneb8888@gmail.com>
Subject: [PATCH] Btrfs: update inode flags when renaming
Date: Fri, 22 Feb 2013 16:11:31 +0800
Message-Id: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported some weird behaviours,
if we move a file with the noCow flag to a directory without the
noCow flag, the file is now without the flag, but after remount,
we'll find the file's noCow flag comes back.

This is because we missed a proper inode update after inheriting
parent directory's flags,

Reported-by: Marios Titas <redneb8888@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d9984fa..d2e3352 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7478,8 +7478,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					old_dentry->d_inode,
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
-		if (!ret)
-			ret = btrfs_update_inode(trans, root, old_inode);
 	}
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
@@ -7514,6 +7512,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	fixup_inode_flags(new_dir, old_inode);
+	ret = btrfs_update_inode(trans, root, old_inode);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out_fail;
+	}
 
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,
-- 
1.7.7.6

