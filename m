Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29226 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab3BTOLn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 09:11:43 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: fix cleaner thread not working with inode cache option
Date: Wed, 20 Feb 2013 22:10:23 +0800
Message-Id: <1361369423-2208-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Right now inode cache inode is treated as the same as space cache
inode, ie. keep inode in memory till putting super.

But this leads to an awkward situation.

If we're going to delete a snapshot/subvolume, btrfs will not
actually delete it and return free space, but will add it to dead
roots list until the last inode on this snap/subvol being destroyed.
Then we'll fetch deleted roots and cleanup them via cleaner thread.

So here is the problem, if we enable inode cache option, each
snap/subvol has a cached inode which is used to store inode allcation
information.  And this cache inode will be kept in memory, as the above
said.  So with inode cache, snap/subvol can only be added into
dead roots list during freeing roots stage in umount, so that we can
ONLY get space back after another remount(we cleanup dead roots on mount).

But the real thing is we'll no more use the snap/subvol if we mark it
deleted, so we can safely iput its cache inode when we delete snap/subvol.

Another thing is that we need to change the rules of droping inode, we
don't keep snap/subvol's cache inode in memory till end so that we can
add snap/subvol into dead roots list in time.

Reported-by: Mitch Harder <mitch.harder@sabayonlinux.org>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    3 ++-
 fs/btrfs/ioctl.c |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca7ace7..d9984fa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7230,8 +7230,9 @@ int btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
+	/* the snap/subvol tree is on deleting */
 	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    !btrfs_is_free_space_inode(inode))
+	    root != root->fs_info->tree_root)
 		return 1;
 	else
 		return generic_drop_inode(inode);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a31cd93..375f31f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2171,6 +2171,12 @@ out_unlock:
 		shrink_dcache_sb(root->fs_info->sb);
 		btrfs_invalidate_inodes(dest);
 		d_delete(dentry);
+
+		/* the last ref */
+		if (dest->cache_inode) {
+			iput(dest->cache_inode);
+			dest->cache_inode = NULL;
+		}
 	}
 out_dput:
 	dput(dentry);
-- 
1.7.7.6

