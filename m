Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38426 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3HMSOA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 14:14:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DF8A57C06A0
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 12:13:59 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id yjavBmbHsVhi8RBR (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 12:13:59 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix the error handling wrt orphan items
Date: Tue, 13 Aug 2013 14:13:57 -0400
Message-ID: <1376417637-22065-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are several places where we BUG_ON() if we fail to remove the orphan items
and such, which is not ok, so remove those and either abort or just carry on.
This also fixes a problem where if we couldn't start a transaction we wouldn't
actually remove the orphan item reserve for the inode.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0b38755..bd05bb6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2940,8 +2940,10 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 	    btrfs_root_refs(&root->root_item) > 0) {
 		ret = btrfs_del_orphan_item(trans, root->fs_info->tree_root,
 					    root->root_key.objectid);
-		BUG_ON(ret);
-		root->orphan_item_inserted = 0;
+		if (ret)
+			btrfs_abort_transaction(trans, root, ret);
+		else
+			root->orphan_item_inserted = 0;
 	}
 
 	if (block_rsv) {
@@ -3010,11 +3012,18 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	/* insert an orphan item to track this unlinked/truncated file */
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
-		if (ret && ret != -EEXIST) {
+		if (ret) {
 			clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 				  &BTRFS_I(inode)->runtime_flags);
-			btrfs_abort_transaction(trans, root, ret);
-			return ret;
+			if (reserve) {
+				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
+					  &BTRFS_I(inode)->runtime_flags);
+				btrfs_orphan_release_metadata(inode);
+			}
+			if (ret != -EEXIST) {
+				btrfs_abort_transaction(trans, root, ret);
+				return ret;
+			}
 		}
 		ret = 0;
 	}
@@ -3053,17 +3062,15 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 		release_rsv = 1;
 	spin_unlock(&root->orphan_lock);
 
-	if (trans && delete_item) {
+	if (trans && delete_item)
 		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
-		BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
-	}
 
 	if (release_rsv) {
 		btrfs_orphan_release_metadata(inode);
 		atomic_dec(&root->orphan_inodes);
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -3193,8 +3200,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				found_key.objectid);
 			ret = btrfs_del_orphan_item(trans, root,
 						    found_key.objectid);
-			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
 			btrfs_end_transaction(trans, root);
+			if (ret)
+				goto out;
 			continue;
 		}
 
@@ -4570,10 +4578,15 @@ void btrfs_evict_inode(struct inode *inode)
 
 	btrfs_free_block_rsv(root, rsv);
 
+	/*
+	 * Errors here aren't a big deal, it just means we leave orphan items
+	 * in the tree.  They will be cleaned up on the next mount.
+	 */
 	if (ret == 0) {
 		trans->block_rsv = root->orphan_block_rsv;
-		ret = btrfs_orphan_del(trans, inode);
-		BUG_ON(ret);
+		btrfs_orphan_del(trans, inode);
+	} else {
+		btrfs_orphan_del(NULL, inode);
 	}
 
 	trans->block_rsv = &root->fs_info->trans_block_rsv;
@@ -8136,10 +8149,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						 new_dentry->d_name.name,
 						 new_dentry->d_name.len);
 		}
-		if (!ret && new_inode->i_nlink == 0) {
+		if (!ret && new_inode->i_nlink == 0)
 			ret = btrfs_orphan_add(trans, new_dentry->d_inode);
-			BUG_ON(ret);
-		}
 		if (ret) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto out_fail;
-- 
1.7.7.6

