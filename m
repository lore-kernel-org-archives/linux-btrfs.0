From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 11/12 v5] Btrfs: do not iput inode when inode is still in log
Date: Sat, 6 Aug 2011 17:37:46 +0800
Message-ID: <1312623467-31487-12-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We maintain the inode's logged_trans to avoid reloging it, but if we iput
the inode and reread it, we'll get logged_trans to zero.

So when an inode is still in log tree, and transaction is not committed yet,
we do not iput the inode.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a1f9155..10375fc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6821,8 +6821,15 @@ int btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    !btrfs_is_free_space_inode(root, inode))
+	/*
+	 * If the inode has been in the log tree and the transaction is not
+	 * committed yet, then we need to keep this inode in cache.
+	 */
+	if (BTRFS_I(inode)->last_trans >= root->fs_info->generation &&
+	    BTRFS_I(inode)->logged_trans >= BTRFS_I(inode)->last_trans)
+		return 0;
+	else if (btrfs_root_refs(&root->root_item) == 0 &&
+		 !btrfs_is_free_space_inode(root, inode))
 		return 1;
 	else
 		return generic_drop_inode(inode);
-- 
1.6.5.2

