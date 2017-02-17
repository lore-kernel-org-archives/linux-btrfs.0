Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33828 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934539AbdBQOoR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:17 -0500
Received: by mail-wr0-f193.google.com with SMTP id c4so5517194wrd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:16 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 29/38] btrfs: make btrfs_orphan_del take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:20 +0200
Message-Id: <1487342609-20652-30-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 52387c033e3f..257f6e65fd68 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3272,20 +3272,20 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
  * item for this particular inode.
  */
 static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
-			    struct inode *inode)
+			    struct btrfs_inode *inode)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	int delete_item = 0;
 	int release_rsv = 0;
 	int ret = 0;
 
 	spin_lock(&root->orphan_lock);
 	if (test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-			       &BTRFS_I(inode)->runtime_flags))
+			       &inode->runtime_flags))
 		delete_item = 1;
 
 	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-			       &BTRFS_I(inode)->runtime_flags))
+			       &inode->runtime_flags))
 		release_rsv = 1;
 	spin_unlock(&root->orphan_lock);
 
@@ -3293,11 +3293,11 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 		atomic_dec(&root->orphan_inodes);
 		if (trans)
 			ret = btrfs_del_orphan_item(trans, root,
-						    btrfs_ino(BTRFS_I(inode)));
+						    btrfs_ino(inode));
 	}
 
 	if (release_rsv)
-		btrfs_orphan_release_metadata(BTRFS_I(inode));
+		btrfs_orphan_release_metadata(inode);
 
 	return ret;
 }
@@ -3468,7 +3468,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 			ret = btrfs_truncate(inode);
 			if (ret)
-				btrfs_orphan_del(NULL, inode);
+				btrfs_orphan_del(NULL, BTRFS_I(inode));
 		} else {
 			nr_unlink++;
 		}
@@ -5005,7 +5005,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 			/* To get a stable disk_i_size */
 			err = btrfs_wait_ordered_range(inode, 0, (u64)-1);
 			if (err) {
-				btrfs_orphan_del(NULL, inode);
+				btrfs_orphan_del(NULL, BTRFS_I(inode));
 				return err;
 			}
 
@@ -5017,11 +5017,11 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 			 */
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans)) {
-				btrfs_orphan_del(NULL, inode);
+				btrfs_orphan_del(NULL, BTRFS_I(inode));
 				return ret;
 			}
 			i_size_write(inode, BTRFS_I(inode)->disk_i_size);
-			err = btrfs_orphan_del(trans, inode);
+			err = btrfs_orphan_del(trans, BTRFS_I(inode));
 			if (err)
 				btrfs_abort_transaction(trans, err);
 			btrfs_end_transaction(trans);
@@ -5183,7 +5183,7 @@ void btrfs_evict_inode(struct inode *inode)
 		goto no_delete;
 
 	if (is_bad_inode(inode)) {
-		btrfs_orphan_del(NULL, inode);
+		btrfs_orphan_del(NULL, BTRFS_I(inode));
 		goto no_delete;
 	}
 	/* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
@@ -5206,13 +5206,13 @@ void btrfs_evict_inode(struct inode *inode)
 
 	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
 	if (ret) {
-		btrfs_orphan_del(NULL, inode);
+		btrfs_orphan_del(NULL, BTRFS_I(inode));
 		goto no_delete;
 	}
 
 	rsv = btrfs_alloc_block_rsv(fs_info, BTRFS_BLOCK_RSV_TEMP);
 	if (!rsv) {
-		btrfs_orphan_del(NULL, inode);
+		btrfs_orphan_del(NULL, BTRFS_I(inode));
 		goto no_delete;
 	}
 	rsv->size = min_size;
@@ -5254,14 +5254,14 @@ void btrfs_evict_inode(struct inode *inode)
 			btrfs_warn(fs_info,
 				   "Could not get space for a delete, will truncate on mount %d",
 				   ret);
-			btrfs_orphan_del(NULL, inode);
+			btrfs_orphan_del(NULL, BTRFS_I(inode));
 			btrfs_free_block_rsv(fs_info, rsv);
 			goto no_delete;
 		}
 
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
-			btrfs_orphan_del(NULL, inode);
+			btrfs_orphan_del(NULL, BTRFS_I(inode));
 			btrfs_free_block_rsv(fs_info, rsv);
 			goto no_delete;
 		}
@@ -5287,7 +5287,7 @@ void btrfs_evict_inode(struct inode *inode)
 		if (ret) {
 			ret = btrfs_commit_transaction(trans);
 			if (ret) {
-				btrfs_orphan_del(NULL, inode);
+				btrfs_orphan_del(NULL, BTRFS_I(inode));
 				btrfs_free_block_rsv(fs_info, rsv);
 				goto no_delete;
 			}
@@ -5316,9 +5316,9 @@ void btrfs_evict_inode(struct inode *inode)
 	 */
 	if (ret == 0) {
 		trans->block_rsv = root->orphan_block_rsv;
-		btrfs_orphan_del(trans, inode);
+		btrfs_orphan_del(trans, BTRFS_I(inode));
 	} else {
-		btrfs_orphan_del(NULL, inode);
+		btrfs_orphan_del(NULL, BTRFS_I(inode));
 	}
 
 	trans->block_rsv = &fs_info->trans_block_rsv;
@@ -6526,7 +6526,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 			 * If new hard link count is 1, it's a file created
 			 * with open(2) O_TMPFILE flag.
 			 */
-			err = btrfs_orphan_del(trans, inode);
+			err = btrfs_orphan_del(trans, BTRFS_I(inode));
 			if (err)
 				goto fail;
 		}
@@ -9158,7 +9158,7 @@ static int btrfs_truncate(struct inode *inode)
 
 	if (ret == 0 && inode->i_nlink > 0) {
 		trans->block_rsv = root->orphan_block_rsv;
-		ret = btrfs_orphan_del(trans, inode);
+		ret = btrfs_orphan_del(trans, BTRFS_I(inode));
 		if (ret)
 			err = ret;
 	}
-- 
2.7.4

