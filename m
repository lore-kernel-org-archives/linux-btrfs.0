Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34225 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934226AbdBQOoS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:18 -0500
Received: by mail-wm0-f68.google.com with SMTP id c85so2932520wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:17 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 30/38] btrfs: Make btrfs_orphan_add take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:21 +0200
Message-Id: <1487342609-20652-31-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/inode.c       | 37 ++++++++++++++++++-------------------
 fs/btrfs/relocation.c  |  2 +-
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2bfc2e289f51..cfa63b13d247 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3174,7 +3174,7 @@ int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct inode *inode);
 int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, struct inode *inode);
-int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
+int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct btrfs_inode *inode);
 int btrfs_orphan_cleanup(struct btrfs_root *root);
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 84b61b53ed25..e854978ae01d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10340,7 +10340,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	mutex_unlock(&trans->transaction->cache_write_mutex);
 
 	if (!IS_ERR(inode)) {
-		ret = btrfs_orphan_add(trans, inode);
+		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 		if (ret) {
 			btrfs_add_delayed_iput(inode);
 			goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 257f6e65fd68..1bf7d10e15bd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3173,10 +3173,10 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
  * NOTE: caller of this function should reserve 5 units of metadata for
  *	 this function.
  */
-int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
+int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = NULL;
 	int reserve = 0;
 	int insert = 0;
@@ -3198,7 +3198,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	}
 
 	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-			      &BTRFS_I(inode)->runtime_flags)) {
+			      &inode->runtime_flags)) {
 #if 0
 		/*
 		 * For proper ENOSPC handling, we should do orphan
@@ -3215,39 +3215,38 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	}
 
 	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-			      &BTRFS_I(inode)->runtime_flags))
+			      &inode->runtime_flags))
 		reserve = 1;
 	spin_unlock(&root->orphan_lock);
 
 	/* grab metadata reservation from transaction handle */
 	if (reserve) {
-		ret = btrfs_orphan_reserve_metadata(trans, BTRFS_I(inode));
+		ret = btrfs_orphan_reserve_metadata(trans, inode);
 		ASSERT(!ret);
 		if (ret) {
 			atomic_dec(&root->orphan_inodes);
 			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-				  &BTRFS_I(inode)->runtime_flags);
+				  &inode->runtime_flags);
 			if (insert)
 				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-					  &BTRFS_I(inode)->runtime_flags);
+					  &inode->runtime_flags);
 			return ret;
 		}
 	}
 
 	/* insert an orphan item to track this unlinked/truncated file */
 	if (insert >= 1) {
-		ret = btrfs_insert_orphan_item(trans, root,
-				btrfs_ino(BTRFS_I(inode)));
+		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret) {
 			atomic_dec(&root->orphan_inodes);
 			if (reserve) {
 				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-					  &BTRFS_I(inode)->runtime_flags);
-				btrfs_orphan_release_metadata(BTRFS_I(inode));
+					  &inode->runtime_flags);
+				btrfs_orphan_release_metadata(inode);
 			}
 			if (ret != -EEXIST) {
 				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-					  &BTRFS_I(inode)->runtime_flags);
+					  &inode->runtime_flags);
 				btrfs_abort_transaction(trans, ret);
 				return ret;
 			}
@@ -3459,7 +3458,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				ret = PTR_ERR(trans);
 				goto out;
 			}
-			ret = btrfs_orphan_add(trans, inode);
+			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 			btrfs_end_transaction(trans);
 			if (ret) {
 				iput(inode);
@@ -4061,7 +4060,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto out;
 
 	if (inode->i_nlink == 0) {
-		ret = btrfs_orphan_add(trans, inode);
+		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 		if (ret)
 			goto out;
 	}
@@ -4178,7 +4177,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		goto out;
 	}
 
-	err = btrfs_orphan_add(trans, inode);
+	err = btrfs_orphan_add(trans, BTRFS_I(inode));
 	if (err)
 		goto out;
 
@@ -4985,7 +4984,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		 * so we need to guarantee from this point on that everything
 		 * will be consistent.
 		 */
-		ret = btrfs_orphan_add(trans, inode);
+		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 		btrfs_end_transaction(trans);
 		if (ret)
 			return ret;
@@ -9856,7 +9855,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						 new_dentry->d_name.len);
 		}
 		if (!ret && new_inode->i_nlink == 0)
-			ret = btrfs_orphan_add(trans, d_inode(new_dentry));
+			ret = btrfs_orphan_add(trans, BTRFS_I(d_inode(new_dentry)));
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out_fail;
@@ -10473,7 +10472,7 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	ret = btrfs_update_inode(trans, root, inode);
 	if (ret)
 		goto out_inode;
-	ret = btrfs_orphan_add(trans, inode);
+	ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 	if (ret)
 		goto out_inode;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index aecdea2e9051..5cb469768069 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4245,7 +4245,7 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 	BUG_ON(IS_ERR(inode) || is_bad_inode(inode));
 	BTRFS_I(inode)->index_cnt = group->key.objectid;
 
-	err = btrfs_orphan_add(trans, inode);
+	err = btrfs_orphan_add(trans, BTRFS_I(inode));
 out:
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
-- 
2.7.4

