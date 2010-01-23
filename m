From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] btrfs: Drop the link count update from btrfs_unlink_inode
Date: Sun, 24 Jan 2010 02:08:07 +0530
Message-ID: <1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This helps to cleanup the rename and unlink case

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/btrfs/compat.h   |    1 +
 fs/btrfs/inode.c    |   12 ++++++++----
 fs/btrfs/tree-log.c |    5 ++---
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compat.h b/fs/btrfs/compat.h
index 7c4503e..19c82bb 100644
--- a/fs/btrfs/compat.h
+++ b/fs/btrfs/compat.h
@@ -3,5 +3,6 @@
 
 #define btrfs_drop_nlink(inode) drop_nlink(inode)
 #define btrfs_inc_nlink(inode)	inc_nlink(inode)
+#define btrfs_clear_nlink(inode) clear_nlink(inode)
 
 #endif /* _COMPAT_H_ */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b330e27..32aa27d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2550,7 +2550,6 @@ err:
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	inode->i_ctime = dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	btrfs_update_inode(trans, root, dir);
-	btrfs_drop_nlink(inode);
 	ret = btrfs_update_inode(trans, root, inode);
 out:
 	return ret;
@@ -2583,9 +2582,10 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	btrfs_set_trans_block_group(trans, dir);
 
 	btrfs_record_unlink_dir(trans, dir, dentry->d_inode, 0);
-
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
 				 dentry->d_name.name, dentry->d_name.len);
+	btrfs_drop_nlink(dentry->d_inode);
+	btrfs_update_inode(trans, root, dentry->d_inode);
 
 	if (inode->i_nlink == 0)
 		ret = btrfs_orphan_add(trans, inode);
@@ -2701,8 +2701,11 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
 				 dentry->d_name.name, dentry->d_name.len);
-	if (!err)
+	if (!err) {
 		btrfs_i_size_write(inode, 0);
+		btrfs_drop_nlink(inode);
+		btrfs_update_inode(trans, root, inode);
+	}
 out:
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
@@ -5575,7 +5578,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
 	} else {
-		btrfs_inc_nlink(old_dentry->d_inode);
 		ret = btrfs_unlink_inode(trans, root, old_dir,
 					 old_dentry->d_inode,
 					 old_dentry->d_name.name,
@@ -5598,6 +5600,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						 new_dentry->d_inode,
 						 new_dentry->d_name.name,
 						 new_dentry->d_name.len);
+			btrfs_drop_nlink(new_dentry->d_inode);
+			btrfs_update_inode(trans, dest, new_dentry->d_inode);
 		}
 		BUG_ON(ret);
 		if (new_inode->i_nlink == 0) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4a9434b..fb2d6a1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -671,6 +671,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	ret = btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
+	btrfs_drop_nlink(inode);
+	btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
 	kfree(name);
 
@@ -869,9 +871,7 @@ conflict_again:
 
 			if (!backref_in_log(log, key, victim_name,
 					    victim_name_len)) {
-				btrfs_inc_nlink(inode);
 				btrfs_release_path(root, path);
-
 				ret = btrfs_unlink_inode(trans, root, dir,
 							 inode, victim_name,
 							 victim_name_len);
@@ -1426,7 +1426,6 @@ again:
 			ret = link_to_fixup_dir(trans, root,
 						path, location.objectid);
 			BUG_ON(ret);
-			btrfs_inc_nlink(inode);
 			ret = btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
 			BUG_ON(ret);
-- 
1.6.6.1.394.gdedc0

