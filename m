From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 11/12] Btrfs: do not iput inode when inode is still in log
Date: Thu, 30 Jun 2011 15:36:31 +0800
Message-ID: <1309419392-17770-12-git-send-email-liubo2009@cn.fujitsu.com>
References: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <dave@jikos.cz>, <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309419392-17770-1-git-send-email-liubo2009@cn.fujitsu.com>
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
index 0007ae3..d4c910c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6828,8 +6828,15 @@ int btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    !is_free_space_inode(root, inode))
+	/*
+	 * If the inode has been in the log tree and the transaction is not
+	 * committed yet, then we need to keep this inode in cache.
+	 */
+	if (BTRFS_I(inode)->last_trans >= root->fs_info->generation &&
+	    BTRFS_I(inode)->logged_trans >= BTRFS_I(inode)->last_trans)
+		return 0;
+	else if (btrfs_root_refs(&root->root_item) == 0 &&
+		 !is_free_space_inode(root, inode))
 		return 1;
 	else
 		return generic_drop_inode(inode);
-- 
1.6.5.2

