Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34331 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3BYEGu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Feb 2013 23:06:50 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marios Titas <redneb8888@gmail.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: do not change inode flags in rename
Date: Mon, 25 Feb 2013 12:04:42 +0800
Message-Id: <1361765082-6331-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before we forced to change a file's NOCOW and COMPRESS flag due to
the parent directory's, but this ends up a bad idea, because it
confuses end users a lot about file's NOCOW status, eg. if someone
change a file to NOCOW via 'chattr' and then rename it in the current
directory which is without NOCOW attribute, the file will lose the
NOCOW flag silently.

This diables 'change flags in rename', so from now on we'll only
inherit flags from the parent directory on creation stage while in
other places we can use 'chattr' to set NOCOW or COMPRESS flags.

Reported-by: Marios Titas <redneb8888@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d9984fa..383a7d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7325,29 +7325,6 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	return 0;
 }
 
-/*
- * If a file is moved, it will inherit the cow and compression flags of the new
- * directory.
- */
-static void fixup_inode_flags(struct inode *dir, struct inode *inode)
-{
-	struct btrfs_inode *b_dir = BTRFS_I(dir);
-	struct btrfs_inode *b_inode = BTRFS_I(inode);
-
-	if (b_dir->flags & BTRFS_INODE_NODATACOW)
-		b_inode->flags |= BTRFS_INODE_NODATACOW;
-	else
-		b_inode->flags &= ~BTRFS_INODE_NODATACOW;
-
-	if (b_dir->flags & BTRFS_INODE_COMPRESS) {
-		b_inode->flags |= BTRFS_INODE_COMPRESS;
-		b_inode->flags &= ~BTRFS_INODE_NOCOMPRESS;
-	} else {
-		b_inode->flags &= ~(BTRFS_INODE_COMPRESS |
-				    BTRFS_INODE_NOCOMPRESS);
-	}
-}
-
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry)
 {
@@ -7513,8 +7490,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
-	fixup_inode_flags(new_dir, old_inode);
-
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 0, index);
-- 
1.7.7.6

