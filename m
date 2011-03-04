From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: only add orphan items when truncating
Date: Fri,  4 Mar 2011 14:39:14 -0500
Message-ID: <1299267554-2581-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We don't need an orphan item when expanding files, we just need them for
truncating them, so only add the orphan item in btrfs_truncate instead of in
btrfs_setsize.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   45 ++++++++++++++++++---------------------------
 1 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7a5bb9e..f57beff 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3649,22 +3649,6 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 	if (newsize == oldsize)
 		return 0;
 
-	trans = btrfs_start_transaction(root, 5);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-
-	btrfs_set_trans_block_group(trans, inode);
-
-	ret = btrfs_orphan_add(trans, inode);
-	if (ret) {
-		btrfs_end_transaction(trans, root);
-		return ret;
-	}
-
-	nr = trans->blocks_used;
-	btrfs_end_transaction(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
-
 	if (newsize > oldsize) {
 		i_size_write(inode, newsize);
 		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
@@ -3675,25 +3659,15 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 			return ret;
 		}
 
-		trans = btrfs_start_transaction(root, 0);
+		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 
-		btrfs_set_trans_block_group(trans, inode);
-		trans->block_rsv = root->orphan_block_rsv;
-		BUG_ON(!trans->block_rsv);
-
-		/*
-		 * If this fails just leave the orphan item so that it can get
-		 * cleaned up next time we mount.
-		 */
 		ret = btrfs_update_inode(trans, root, inode);
 		if (ret) {
 			btrfs_end_transaction(trans, root);
 			return ret;
 		}
-		if (inode->i_nlink > 0)
-			ret = btrfs_orphan_del(trans, inode);
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(root, nr);
@@ -6515,6 +6489,23 @@ static int btrfs_truncate(struct inode *inode)
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
 
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	btrfs_set_trans_block_group(trans, inode);
+
+	ret = btrfs_orphan_add(trans, inode);
+	if (ret) {
+		btrfs_end_transaction(trans, root);
+		return ret;
+	}
+
+	nr = trans->blocks_used;
+	btrfs_end_transaction(trans, root);
+	btrfs_btree_balance_dirty(root, nr);
+
+	/* Now start a transaction for the truncate */
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-- 
1.7.2.3

