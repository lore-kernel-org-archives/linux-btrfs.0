Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:39551 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbeEKALp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 20:11:45 -0400
Received: by mail-pg0-f51.google.com with SMTP id e1-v6so1647869pga.6
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 17:11:45 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 11/12] Btrfs: simplify error handling in btrfs_evict_inode()
Date: Thu, 10 May 2018 17:11:21 -0700
Message-Id: <ad415c2e4470d5ba0d2f5cd0136ca960654d851a.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We have the same error handling code duplicated all over the place. Put
it all in one place, and while we're here, get rid of the weird
btrfs_orphan_del() trans == NULL case and just clear the orphan item bit
directly since that's all it does anymore.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 56 +++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 207e1d139b31..b28d5f251661 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3324,16 +3324,12 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode *inode)
 {
 	struct btrfs_root *root = inode->root;
-	int ret = 0;
 
 	if (!test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 				&inode->runtime_flags))
 		return 0;
 
-	if (trans)
-		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
-
-	return ret;
+	return btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
 }
 
 /*
@@ -5155,12 +5151,10 @@ void btrfs_evict_inode(struct inode *inode)
 	    ((btrfs_root_refs(&root->root_item) != 0 &&
 	      root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID) ||
 	     btrfs_is_free_space_inode(BTRFS_I(inode))))
-		goto no_delete;
+		goto out;
 
-	if (is_bad_inode(inode)) {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
-		goto no_delete;
-	}
+	if (is_bad_inode(inode))
+		goto clear_orphan;
 	/* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
 	if (!special_file(inode->i_mode))
 		btrfs_wait_ordered_range(inode, 0, (u64)-1);
@@ -5170,26 +5164,22 @@ void btrfs_evict_inode(struct inode *inode)
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
 		BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 				 &BTRFS_I(inode)->runtime_flags));
-		goto no_delete;
+		goto out;
 	}
 
 	if (inode->i_nlink > 0) {
 		BUG_ON(btrfs_root_refs(&root->root_item) != 0 &&
 		       root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID);
-		goto no_delete;
+		goto out;
 	}
 
 	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
-	if (ret) {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
-		goto no_delete;
-	}
+	if (ret)
+		goto clear_orphan;
 
 	rsv = btrfs_alloc_block_rsv(fs_info, BTRFS_BLOCK_RSV_TEMP);
-	if (!rsv) {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
-		goto no_delete;
-	}
+	if (!rsv)
+		goto clear_orphan;
 	rsv->size = min_size;
 	rsv->failfast = 1;
 
@@ -5197,11 +5187,8 @@ void btrfs_evict_inode(struct inode *inode)
 
 	while (1) {
 		trans = evict_refill_and_join(root, rsv, min_size);
-		if (IS_ERR(trans)) {
-			btrfs_orphan_del(NULL, BTRFS_I(inode));
-			btrfs_free_block_rsv(fs_info, rsv);
-			goto no_delete;
-		}
+		if (IS_ERR(trans))
+			goto free_rsv;
 
 		trans->block_rsv = rsv;
 
@@ -5210,11 +5197,8 @@ void btrfs_evict_inode(struct inode *inode)
 		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
 		if (ret) {
-			if (ret != -ENOSPC && ret != -EAGAIN) {
-				btrfs_orphan_del(NULL, BTRFS_I(inode));
-				btrfs_free_block_rsv(fs_info, rsv);
-				goto no_delete;
-			}
+			if (ret != -ENOSPC && ret != -EAGAIN)
+				goto free_rsv;
 		} else {
 			break;
 		}
@@ -5230,27 +5214,27 @@ void btrfs_evict_inode(struct inode *inode)
 	 * to add a mechanism for retrying these after a commit.
 	 */
 	trans = evict_refill_and_join(root, rsv, min_size);
-	if (IS_ERR(trans)) {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
-	} else {
+	if (!IS_ERR(trans)) {
 		trans->block_rsv = rsv;
 		btrfs_orphan_del(trans, BTRFS_I(inode));
 		trans->block_rsv = &fs_info->trans_block_rsv;
 		btrfs_end_transaction(trans);
 	}
 
-	btrfs_free_block_rsv(fs_info, rsv);
-
 	if (!(root == fs_info->tree_root ||
 	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
 		btrfs_return_ino(root, btrfs_ino(BTRFS_I(inode)));
 
+free_rsv:
+	btrfs_free_block_rsv(fs_info, rsv);
+clear_orphan:
 	/*
 	 * If we didn't successfully delete, the orphan item will still be in
 	 * the tree and we'll retry on the next mount. Again, we might also want
 	 * to retry these periodically in the future.
 	 */
-no_delete:
+	clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM, &BTRFS_I(inode)->runtime_flags);
+out:
 	btrfs_remove_delayed_node(BTRFS_I(inode));
 	clear_inode(inode);
 }
-- 
2.17.0

