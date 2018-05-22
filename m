Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44647 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbeEVQ77 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 12:59:59 -0400
Received: by mail-pg0-f65.google.com with SMTP id c22-v6so7460778pgn.11
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:59:59 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>, Jun Wu <quark@fb.com>
Subject: [PATCH] Btrfs: clean up error handling in btrfs_truncate()
Date: Tue, 22 May 2018 09:59:50 -0700
Message-Id: <63257e551e4ebd40d77dc0758f7bada3d38e71e9.1527008327.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_truncate() uses two variables for error handling, ret and err (if
this sounds familiar, it's because btrfs_truncate_inode_items() did
something similar). This is error prone, as was made evident by "Btrfs:
fix error handling in btrfs_truncate()". We only have err because we
don't want to mask an error if we call btrfs_update_inode() and
btrfs_end_transaction(), so let's make that its own scoped return
variable and use ret everywhere else.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
This is the same as my v1 "Btrfs: fix error handling in
btrfs_truncate()", but rebased on top of kdave/for-next + v2 of "Btrfs:
fix error handling in btrfs_truncate()".

 fs/btrfs/inode.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 220b609d711d..25ca1c14ecb4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9019,8 +9019,7 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv;
-	int ret = 0;
-	int err = 0;
+	int ret;
 	struct btrfs_trans_handle *trans;
 	u64 mask = fs_info->sectorsize - 1;
 	u64 min_size = btrfs_calc_trunc_metadata_size(fs_info, 1);
@@ -9072,7 +9071,7 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 	 */
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+		ret = PTR_ERR(trans);
 		goto out;
 	}
 
@@ -9096,24 +9095,19 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 						 inode->i_size,
 						 BTRFS_EXTENT_DATA_KEY);
 		trans->block_rsv = &fs_info->trans_block_rsv;
-		if (ret != -ENOSPC && ret != -EAGAIN) {
-			if (ret < 0)
-				err = ret;
+		if (ret != -ENOSPC && ret != -EAGAIN)
 			break;
-		}
 
 		ret = btrfs_update_inode(trans, root, inode);
-		if (ret) {
-			err = ret;
+		if (ret)
 			break;
-		}
 
 		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
 
 		trans = btrfs_start_transaction(root, 2);
 		if (IS_ERR(trans)) {
-			ret = err = PTR_ERR(trans);
+			ret = PTR_ERR(trans);
 			trans = NULL;
 			break;
 		}
@@ -9147,21 +9141,22 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 	}
 
 	if (trans) {
+		int ret2;
+
 		trans->block_rsv = &fs_info->trans_block_rsv;
-		ret = btrfs_update_inode(trans, root, inode);
-		if (ret && !err)
-			err = ret;
+		ret2 = btrfs_update_inode(trans, root, inode);
+		if (ret2 && !ret)
+			ret = ret2;
 
-		ret = btrfs_end_transaction(trans);
+		ret2 = btrfs_end_transaction(trans);
+		if (ret2 && !ret)
+			ret = ret2;
 		btrfs_btree_balance_dirty(fs_info);
 	}
 out:
 	btrfs_free_block_rsv(fs_info, rsv);
 
-	if (ret && !err)
-		err = ret;
-
-	return err;
+	return ret;
 }
 
 /*
-- 
2.17.0

