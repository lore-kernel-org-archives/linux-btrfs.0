From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: cleanup error handling in the truncate path
Date: Mon, 31 Jan 2011 16:04:23 -0500
Message-ID: <1296507863-26583-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Now that we can handle having errors in the truncate path lets make sure we
return errors instead of doing BUG_ON() and such.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   61 +++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 77645948..596bf64 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3586,13 +3586,15 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 			err = btrfs_drop_extents(trans, inode, cur_offset,
 						 cur_offset + hole_size,
 						 &hint_byte, 1);
-			BUG_ON(err);
+			if (err)
+				break;
 
 			err = btrfs_insert_file_extent(trans, root,
 					inode->i_ino, cur_offset, 0,
 					0, hole_size, 0, hole_size,
 					0, 0, 0);
-			BUG_ON(err);
+			if (err)
+				break;
 
 			btrfs_drop_extent_cache(inode, hole_start,
 					last_byte - 1, 0);
@@ -3630,7 +3632,10 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 	btrfs_set_trans_block_group(trans, inode);
 
 	ret = btrfs_orphan_add(trans, inode);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_end_transaction(trans, root);
+		return ret;
+	}
 
 	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
@@ -3647,17 +3652,24 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 		}
 
 		trans = btrfs_start_transaction(root, 0);
-		BUG_ON(IS_ERR(trans));
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
 		btrfs_set_trans_block_group(trans, inode);
 		trans->block_rsv = root->orphan_block_rsv;
 		BUG_ON(!trans->block_rsv);
 
+		/*
+		 * If this fails just leave the orphan item so that it can get
+		 * cleaned up next time we mount.
+		 */
 		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
-		if (inode->i_nlink > 0) {
-			ret = btrfs_orphan_del(trans, inode);
-			BUG_ON(ret);
+		if (ret) {
+			btrfs_end_transaction(trans, root);
+			return ret;
 		}
+		if (inode->i_nlink > 0)
+			ret = btrfs_orphan_del(trans, inode);
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(root, nr);
@@ -6338,6 +6350,7 @@ static int btrfs_truncate(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
+	int err = 0;
 	struct btrfs_trans_handle *trans;
 	unsigned long nr;
 	u64 mask = root->sectorsize - 1;
@@ -6350,7 +6363,8 @@ static int btrfs_truncate(struct inode *inode)
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
 
 	trans = btrfs_start_transaction(root, 0);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = root->orphan_block_rsv;
 
@@ -6377,17 +6391,18 @@ static int btrfs_truncate(struct inode *inode)
 	while (1) {
 		if (!trans) {
 			trans = btrfs_start_transaction(root, 0);
-			BUG_ON(IS_ERR(trans));
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
 			btrfs_set_trans_block_group(trans, inode);
 			trans->block_rsv = root->orphan_block_rsv;
 		}
 
 		ret = btrfs_block_rsv_check(trans, root,
 					    root->orphan_block_rsv, 0, 5);
-		if (ret) {
-			BUG_ON(ret != -EAGAIN);
+		if (ret == -EAGAIN) {
 			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 			trans = NULL;
 			continue;
 		}
@@ -6395,11 +6410,16 @@ static int btrfs_truncate(struct inode *inode)
 		ret = btrfs_truncate_inode_items(trans, root, inode,
 						 inode->i_size,
 						 BTRFS_EXTENT_DATA_KEY);
-		if (ret != -EAGAIN)
+		if (ret != -EAGAIN) {
+			err = ret;
 			break;
+		}
 
 		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
+		if (ret) {
+			err = ret;
+			break;
+		}
 
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
@@ -6409,18 +6429,21 @@ static int btrfs_truncate(struct inode *inode)
 
 	if (ret == 0 && inode->i_nlink > 0) {
 		ret = btrfs_orphan_del(trans, inode);
-		BUG_ON(ret);
+		if (ret)
+			err = ret;
 	}
 
 	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
+	if (ret && !err)
+		err = ret;
 
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
-	BUG_ON(ret);
+	if (ret && !err)
+		err = ret;
 	btrfs_btree_balance_dirty(root, nr);
 
-	return ret;
+	return err;
 }
 
 /*
-- 
1.7.2.3

