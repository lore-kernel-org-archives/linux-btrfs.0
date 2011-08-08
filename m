From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: optimize how we account for space in truncate
Date: Mon,  8 Aug 2011 14:24:46 -0400
Message-ID: <1312827886-16568-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently we're starting and stopping a transaction for no real reason, so kill
that and just reserve enough space as if we can truncate all in one transaction.
Also use btrfs_block_rsv_check() for our reserve to minimize the amount of space
we may have to allocate for our slack space.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   58 +++++++++++++++++++++++++++---------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4aa4ea9..808ad07 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6452,6 +6452,7 @@ static int btrfs_truncate(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	unsigned long nr;
 	u64 mask = root->sectorsize - 1;
+	u64 min_size = btrfs_calc_trans_metadata_size(root, 2);
 
 	ret = btrfs_truncate_page(inode->i_mapping, inode->i_size);
 	if (ret)
@@ -6500,17 +6501,21 @@ static int btrfs_truncate(struct inode *inode)
 	if (!rsv)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 4);
+	/*
+	 * 2 for the truncate slack space
+	 * 1 for the orphan item we're going to add
+	 * 1 for the orphan item deletion
+	 * 1 for updating the inode.
+	 */
+	trans = btrfs_start_transaction(root, 5);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		goto out;
 	}
 
-	/*
-	 * Reserve space for the truncate process.  Truncate should be adding
-	 * space, but if there are snapshots it may end up using space.
-	 */
-	ret = btrfs_truncate_reserve_metadata(trans, root, rsv);
+	/* Migrate the slack space for the truncate to our reserve */
+	ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv, rsv,
+				      min_size);
 	BUG_ON(ret);
 
 	ret = btrfs_orphan_add(trans, inode);
@@ -6519,21 +6524,6 @@ static int btrfs_truncate(struct inode *inode)
 		goto out;
 	}
 
-	nr = trans->blocks_used;
-	btrfs_end_transaction(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
-
-	/*
-	 * Ok so we've already migrated our bytes over for the truncate, so here
-	 * just reserve the one slot we need for updating the inode.
-	 */
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
-		goto out;
-	}
-	trans->block_rsv = rsv;
-
 	/*
 	 * setattr is responsible for setting the ordered_data_close flag,
 	 * but that is only tested during the last file release.  That
@@ -6555,20 +6545,30 @@ static int btrfs_truncate(struct inode *inode)
 		btrfs_add_ordered_operation(trans, root, inode);
 
 	while (1) {
+		ret = btrfs_block_rsv_check(trans, root, rsv, min_size, 0);
+		if (ret) {
+			/*
+			 * This can only happen with the original transaction we
+			 * started above, every other time we shouldn't have a
+			 * transaction started yet.
+			 */
+			if (ret == -EAGAIN)
+				goto end_trans;
+			err = ret;
+			break;
+		}
+
 		if (!trans) {
-			trans = btrfs_start_transaction(root, 3);
+			/* Just need the 1 for updating the inode */
+			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
 				err = PTR_ERR(trans);
 				goto out;
 			}
-
-			ret = btrfs_truncate_reserve_metadata(trans, root,
-							      rsv);
-			BUG_ON(ret);
-
-			trans->block_rsv = rsv;
 		}
 
+		trans->block_rsv = rsv;
+
 		ret = btrfs_truncate_inode_items(trans, root, inode,
 						 inode->i_size,
 						 BTRFS_EXTENT_DATA_KEY);
@@ -6583,7 +6583,7 @@ static int btrfs_truncate(struct inode *inode)
 			err = ret;
 			break;
 		}
-
+end_trans:
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
-- 
1.7.5.2

