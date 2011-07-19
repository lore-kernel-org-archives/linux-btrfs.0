From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: return error to caller when btrfs_unlink() failes
Date: Tue, 19 Jul 2011 16:27:20 +0900
Message-ID: <201107190727.AA00031@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_unlink_inode() and btrfs_orphan_add() in btrfs_unlink()
are error, the error code is returned to the caller instead of
BUG_ON(). 

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    3 ++-
 fs/btrfs/inode.c       |   10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..eb92721 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7166,7 +7166,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	inode = lookup_free_space_inode(root, block_group, path);
 	if (!IS_ERR(inode)) {
-		btrfs_orphan_add(trans, inode);
+		ret = btrfs_orphan_add(trans, inode);
+		BUG_ON(ret);
 		clear_nlink(inode);
 		/* One for the block groups ref */
 		spin_lock(&block_group->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4a13730..af57c2b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2214,7 +2214,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	if (!root->orphan_block_rsv) {
 		block_rsv = btrfs_alloc_block_rsv(root);
-		BUG_ON(!block_rsv);
+		if (!block_rsv)
+			return -ENOMEM;
 	}
 
 	spin_lock(&root->orphan_lock);
@@ -3021,13 +3022,16 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
 				 dentry->d_name.name, dentry->d_name.len);
-	BUG_ON(ret);
+	if (ret)
+		goto out;
 
 	if (inode->i_nlink == 0) {
 		ret = btrfs_orphan_add(trans, inode);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 	}
 
+out:
 	nr = trans->blocks_used;
 	__unlink_end_trans(trans, root);
 	btrfs_btree_balance_dirty(root, nr);


