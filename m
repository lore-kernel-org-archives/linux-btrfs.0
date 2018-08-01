Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65449 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730957AbeHAFQN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:13 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2AB624B6ADE6
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:42 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/7] btrfs: Remove root parameter from btrfs_unlink_subvol
Date: Wed, 1 Aug 2018 11:32:30 +0800
Message-ID: <20180801033231.23166-7-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched by BTRFS_I(dir)->root.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 407d068d4208..b8c131b82978 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4081,10 +4081,10 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 }
 
 static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct inode *dir, u64 objectid,
-			const char *name, int name_len)
+			       struct inode *dir, u64 objectid,
+			       const char *name, int name_len)
 {
+	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
@@ -4335,10 +4335,8 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 
 	btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
 
-	ret = btrfs_unlink_subvol(trans, root, dir,
-				dest->root_key.objectid,
-				dentry->d_name.name,
-				dentry->d_name.len);
+	ret = btrfs_unlink_subvol(trans, dir, dest->root_key.objectid,
+				  dentry->d_name.name, dentry->d_name.len);
 	if (ret) {
 		err = ret;
 		btrfs_abort_transaction(trans, ret);
@@ -4433,7 +4431,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return PTR_ERR(trans);
 
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-		err = btrfs_unlink_subvol(trans, root, dir,
+		err = btrfs_unlink_subvol(trans, dir,
 					  BTRFS_I(inode)->location.objectid,
 					  dentry->d_name.name,
 					  dentry->d_name.len);
@@ -9505,8 +9503,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	/* src is a subvolume */
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
-		ret = btrfs_unlink_subvol(trans, root, old_dir,
-					  root_objectid,
+		ret = btrfs_unlink_subvol(trans, old_dir, root_objectid,
 					  old_dentry->d_name.name,
 					  old_dentry->d_name.len);
 	} else { /* src is an inode */
@@ -9525,8 +9522,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	/* dest is a subvolume */
 	if (new_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		root_objectid = BTRFS_I(new_inode)->root->root_key.objectid;
-		ret = btrfs_unlink_subvol(trans, dest, new_dir,
-					  root_objectid,
+		ret = btrfs_unlink_subvol(trans, new_dir, root_objectid,
 					  new_dentry->d_name.name,
 					  new_dentry->d_name.len);
 	} else { /* dest is an inode */
@@ -9786,7 +9782,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
-		ret = btrfs_unlink_subvol(trans, root, old_dir, root_objectid,
+		ret = btrfs_unlink_subvol(trans, old_dir, root_objectid,
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
 	} else {
@@ -9808,8 +9804,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (unlikely(btrfs_ino(BTRFS_I(new_inode)) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 			root_objectid = BTRFS_I(new_inode)->location.objectid;
-			ret = btrfs_unlink_subvol(trans, dest, new_dir,
-						root_objectid,
+			ret = btrfs_unlink_subvol(trans, new_dir, root_objectid,
 						new_dentry->d_name.name,
 						new_dentry->d_name.len);
 			BUG_ON(new_inode->i_nlink == 0);
-- 
2.18.0



