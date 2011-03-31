From: Johann Lombardi <johann@whamcloud.com>
Subject: [PATCH] Btrfs: fix subvol_sem leak in btrfs_rename()
Date: Thu, 31 Mar 2011 15:23:47 +0200
Message-ID: <1301577827-19380-1-git-send-email-johann@whamcloud.com>
Cc: Johann Lombardi <johann@whamcloud.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_rename() does not release the subvol_sem if the transaction failed to start.

Signed-off-by: Johann Lombardi <johann@whamcloud.com>
---
 fs/btrfs/inode.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 93c28a1..495b055 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6960,8 +6960,10 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * should cover the worst case number of items we'll modify.
 	 */
 	trans = btrfs_start_transaction(root, 20);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+                ret = PTR_ERR(trans);
+                goto out_notrans;
+        }
 
 	btrfs_set_trans_block_group(trans, new_dir);
 
@@ -7061,7 +7063,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 out_fail:
 	btrfs_end_transaction_throttle(trans, root);
-
+out_notrans:
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
 
-- 
1.7.1

