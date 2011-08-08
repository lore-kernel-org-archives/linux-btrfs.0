From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix how we reserve space for deleting inodes
Date: Mon,  8 Aug 2011 14:21:59 -0400
Message-ID: <1312827719-16284-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I converted btrfs_truncate to do sane reservations for truncate, but didn't
convert btrfs_evict_inode.  Basically we need to save the orphan_rsv for
deleting the orphan item, and do normal reservations for our truncate.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 54b11ad..4aa4ea9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3552,18 +3552,24 @@ void btrfs_evict_inode(struct inode *inode)
 
 	btrfs_i_size_write(inode, 0);
 
+	/*
+	 * This is a bit simpler than btrfs_truncate since
+	 *
+	 * 1) We've already reserved our space for our orphan item in the
+	 *    unlink.
+	 * 2) We're going to delete the inode item, so we don't need to update
+	 *    it at all.
+	 *
+	 * So we just need to reserve some slack space in case we add bytes when
+	 * doing the truncate.
+	 */
 	while (1) {
-		trans = btrfs_join_transaction(root);
-		BUG_ON(IS_ERR(trans));
-		trans->block_rsv = root->orphan_block_rsv;
-
-		ret = btrfs_block_rsv_check(trans, root,
-					    root->orphan_block_rsv, 0, 5);
-		if (ret) {
-			BUG_ON(ret != -EAGAIN);
-			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
-			continue;
+		trans = btrfs_start_transaction(root, 2);
+		if (IS_ERR(trans)) {
+			printk(KERN_WARNING "Could not get space for a "
+			       "delete, will truncate on mount\n");
+			btrfs_orphan_del(NULL, inode);
+			goto no_delete;
 		}
 
 		ret = btrfs_truncate_inode_items(trans, root, inode, 0, 0);
@@ -3574,14 +3580,15 @@ void btrfs_evict_inode(struct inode *inode)
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
 		btrfs_btree_balance_dirty(root, nr);
-
 	}
 
 	if (ret == 0) {
+		trans->block_rsv = root->orphan_block_rsv;
 		ret = btrfs_orphan_del(trans, inode);
 		BUG_ON(ret);
 	}
 
+	trans->block_rsv = &root->fs_info->trans_block_rsv;
 	if (!(root == root->fs_info->tree_root ||
 	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
 		btrfs_return_ino(root, btrfs_ino(inode));
-- 
1.7.5.2

