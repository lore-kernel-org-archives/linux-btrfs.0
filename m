From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use mark_inode_dirty when expanding the file
Date: Fri,  4 Mar 2011 14:43:04 -0500
Message-ID: <1299267784-2938-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Mark_inode_dirty will call btrfs_dirty_inode which will take care of updating
the inode.  This makes setsize a little cleaner since we don't have to start a
transaction and update the inode in there, we can just call mark_inode_dirty.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f57beff..7f39bd5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3640,10 +3640,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 
 static int btrfs_setsize(struct inode *inode, loff_t newsize)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
 	loff_t oldsize = i_size_read(inode);
-	unsigned long nr;
 	int ret;
 
 	if (newsize == oldsize)
@@ -3659,18 +3656,7 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 			return ret;
 		}
 
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
-
-		ret = btrfs_update_inode(trans, root, inode);
-		if (ret) {
-			btrfs_end_transaction(trans, root);
-			return ret;
-		}
-		nr = trans->blocks_used;
-		btrfs_end_transaction(trans, root);
-		btrfs_btree_balance_dirty(root, nr);
+		mark_inode_dirty(inode);
 	} else {
 
 		/*
-- 
1.7.2.3

