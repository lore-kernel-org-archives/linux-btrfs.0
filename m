From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix some metadata enospc issues V2
Date: Tue, 3 Nov 2009 10:45:22 -0500
Message-ID: <20091103154522.GC5541@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We weren't reserving metadata space for rename, rmdir and unlink, which could
cause problems.  This patch fixes that problem.  V2 makes sure we unreserve
the space if we can't start the transaciton.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78139ef..b14029b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2474,7 +2474,19 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	root = BTRFS_I(dir)->root;
 
+	/*
+	 * 5 items for unlink inode
+	 * 1 for orphan
+	 */
+	ret = btrfs_reserve_metadata_space(root, 6);
+	if (ret)
+		return ret;
+
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_unreserve_metadata_space(root, 6);
+		return PTR_ERR(trans);
+	}
 
 	btrfs_set_trans_block_group(trans, dir);
 
@@ -2489,6 +2501,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	nr = trans->blocks_used;
 
 	btrfs_end_transaction_throttle(trans, root);
+	btrfs_unreserve_metadata_space(root, 6);
 	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
@@ -2569,7 +2582,16 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -ENOTEMPTY;
 
+	ret = btrfs_reserve_metadata_space(root, 5);
+	if (ret)
+		return ret;
+
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_unreserve_metadata_space(root, 5);
+		return PTR_ERR(trans);
+	}
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	if (unlikely(inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
@@ -2592,6 +2614,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 out:
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
+	btrfs_unreserve_metadata_space(root, 5);
 	btrfs_btree_balance_dirty(root, nr);
 
 	if (ret && !err)
@@ -5283,11 +5306,14 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -ENOTEMPTY;
 
 	/*
-	 * 2 items for dir items
-	 * 1 item for orphan entry
-	 * 1 item for ref
+	 * We want to reserve the absolute worst case amount of items.  So if
+	 * both inodes are subvols and we need to unlink them then that would
+	 * require 4 item modifications, but if they are both normal inodes it
+	 * would require 5 item modifications, so we'll assume their normal
+	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
+	 * should cover the worst case number of items we'll modify.
 	 */
-	ret = btrfs_reserve_metadata_space(root, 4);
+	ret = btrfs_reserve_metadata_space(root, 11);
 	if (ret)
 		return ret;
 
@@ -5403,7 +5429,7 @@ out_fail:
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
 
-	btrfs_unreserve_metadata_space(root, 4);
+	btrfs_unreserve_metadata_space(root, 11);
 	return ret;
 }
 
-- 
1.5.4.3

