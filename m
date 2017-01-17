Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35421 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdAQWib (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:38:31 -0500
Received: by mail-wm0-f68.google.com with SMTP id d140so25582305wmd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:38:30 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 18/24] btrfs: Make btrfs_unlink_inode take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:44 +0200
Message-Id: <1484692310-3987-19-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/ctree.h    |  2 +-
 fs/btrfs/inode.c    | 58 ++++++++++++++++++++++++++---------------------------
 fs/btrfs/tree-log.c | 14 ++++++-------
 3 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6a823719b6c5..06d5e6388b4c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3119,7 +3119,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
-		       struct inode *dir, struct inode *inode,
+		       struct btrfs_inode *dir, struct btrfs_inode *inode,
 		       const char *name, int name_len);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct inode *parent_inode, struct inode *inode,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e86b08eabb82..ac433c43d242 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3996,7 +3996,7 @@ noinline int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
  */
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				struct inode *dir, struct inode *inode,
+				struct btrfs_inode *dir, struct btrfs_inode *inode,
 				const char *name, int name_len)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4006,8 +4006,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 	u64 index;
-	u64 ino = btrfs_ino(BTRFS_I(inode));
-	u64 dir_ino = btrfs_ino(BTRFS_I(dir));
+	u64 ino = btrfs_ino(inode);
+	u64 dir_ino = btrfs_ino(dir);
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -4043,10 +4043,10 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	 * that we delay to delete it, and just do this deletion when
 	 * we update the inode item.
 	 */
-	if (BTRFS_I(inode)->dir_index) {
-		ret = btrfs_delayed_delete_inode_ref(BTRFS_I(inode));
+	if (inode->dir_index) {
+		ret = btrfs_delayed_delete_inode_ref(inode);
 		if (!ret) {
-			index = BTRFS_I(inode)->dir_index;
+			index = inode->dir_index;
 			goto skip_backref;
 		}
 	}
@@ -4061,21 +4061,19 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	}
 skip_backref:
-	ret = btrfs_delete_delayed_dir_index(trans, fs_info, BTRFS_I(dir), index);
+	ret = btrfs_delete_delayed_dir_index(trans, fs_info, dir, index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto err;
 	}
 
-	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len,
-					 BTRFS_I(inode), dir_ino);
+	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len, inode, dir_ino);
 	if (ret != 0 && ret != -ENOENT) {
 		btrfs_abort_transaction(trans, ret);
 		goto err;
 	}
 
-	ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
-					   BTRFS_I(dir), index);
+	ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len, dir, index);
 	if (ret == -ENOENT)
 		ret = 0;
 	else if (ret)
@@ -4085,26 +4083,26 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
-	inode_inc_iversion(inode);
-	inode_inc_iversion(dir);
-	inode->i_ctime = dir->i_mtime =
-		dir->i_ctime = current_time(inode);
-	ret = btrfs_update_inode(trans, root, dir);
+	btrfs_i_size_write(&dir->vfs_inode, dir->vfs_inode.i_size - name_len * 2);
+	inode_inc_iversion(&inode->vfs_inode);
+	inode_inc_iversion(&dir->vfs_inode);
+	inode->vfs_inode.i_ctime = dir->vfs_inode.i_mtime =
+		dir->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
+	ret = btrfs_update_inode(trans, root, &dir->vfs_inode);
 out:
 	return ret;
 }
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
-		       struct inode *dir, struct inode *inode,
+		       struct btrfs_inode *dir, struct btrfs_inode *inode,
 		       const char *name, int name_len)
 {
 	int ret;
 	ret = __btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
 	if (!ret) {
-		drop_nlink(inode);
-		ret = btrfs_update_inode(trans, root, inode);
+		drop_nlink(&inode->vfs_inode);
+		ret = btrfs_update_inode(trans, root, &inode->vfs_inode);
 	}
 	return ret;
 }
@@ -4144,7 +4142,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)), 0);
 
-	ret = btrfs_unlink_inode(trans, root, dir, d_inode(dentry),
+	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 				 dentry->d_name.name, dentry->d_name.len);
 	if (ret)
 		goto out;
@@ -4274,7 +4272,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
 
 	/* now the directory is empty */
-	err = btrfs_unlink_inode(trans, root, dir, d_inode(dentry),
+	err = btrfs_unlink_inode(trans, root, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 				 dentry->d_name.name, dentry->d_name.len);
 	if (!err) {
 		btrfs_i_size_write(inode, 0);
@@ -9605,8 +9603,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					  old_dentry->d_name.name,
 					  old_dentry->d_name.len);
 	} else { /* src is an inode */
-		ret = __btrfs_unlink_inode(trans, root, old_dir,
-					   old_dentry->d_inode,
+		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
+					   BTRFS_I(old_dentry->d_inode),
 					   old_dentry->d_name.name,
 					   old_dentry->d_name.len);
 		if (!ret)
@@ -9625,8 +9623,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					  new_dentry->d_name.name,
 					  new_dentry->d_name.len);
 	} else { /* dest is an inode */
-		ret = __btrfs_unlink_inode(trans, dest, new_dir,
-					   new_dentry->d_inode,
+		ret = __btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),
+					   BTRFS_I(new_dentry->d_inode),
 					   new_dentry->d_name.name,
 					   new_dentry->d_name.len);
 		if (!ret)
@@ -9881,8 +9879,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
 	} else {
-		ret = __btrfs_unlink_inode(trans, root, old_dir,
-					d_inode(old_dentry),
+		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
+					BTRFS_I(d_inode(old_dentry)),
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
 		if (!ret)
@@ -9905,8 +9903,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						new_dentry->d_name.len);
 			BUG_ON(new_inode->i_nlink == 0);
 		} else {
-			ret = btrfs_unlink_inode(trans, dest, new_dir,
-						 d_inode(new_dentry),
+			ret = btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),
+						 BTRFS_I(d_inode(new_dentry)),
 						 new_dentry->d_name.name,
 						 new_dentry->d_name.len);
 		}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b0cc56fe86e9..b2c0a30811f6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -875,7 +875,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
+	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir), BTRFS_I(inode), name, name_len);
 	if (ret)
 		goto out;
 	else
@@ -1050,8 +1050,8 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				inc_nlink(inode);
 				btrfs_release_path(path);
 
-				ret = btrfs_unlink_inode(trans, root, dir,
-							 inode, victim_name,
+				ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+							 BTRFS_I(inode), victim_name,
 							 victim_name_len);
 				kfree(victim_name);
 				if (ret)
@@ -1121,8 +1121,8 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					btrfs_release_path(path);
 
 					ret = btrfs_unlink_inode(trans, root,
-								 victim_parent,
-								 inode,
+								 BTRFS_I(victim_parent),
+								 BTRFS_I(inode),
 								 victim_name,
 								 victim_name_len);
 					if (!ret)
@@ -2052,8 +2052,8 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 			}
 
 			inc_nlink(inode);
-			ret = btrfs_unlink_inode(trans, root, dir, inode,
-						 name, name_len);
+			ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+					BTRFS_I(inode), name, name_len);
 			if (!ret)
 				ret = btrfs_run_delayed_items(trans, fs_info);
 			kfree(name);
-- 
2.7.4

