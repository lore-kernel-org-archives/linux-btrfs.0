From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/3] Btrfs: make btrfs_add_nondir take parent inode as an argument
Date: Fri, 19 Nov 2010 15:36:11 -0500
Message-ID: <1290198971-21663-4-git-send-email-josef@redhat.com>
References: <1290198971-21663-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290198971-21663-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Everybody who calls btrfs_add_nondir just passes in the dentry of the new file
and then dereference dentry->d_parent->d_inode, but everybody who calls
btrfs_add_nondir() are already passed the parent's inode.  So instead of
dereferencing dentry->d_parent, just make btrfs_add_nondir take the dir inode as
an argument and pass that along so we don't have to worry about d_parent.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5cce618..2579207 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4622,12 +4622,12 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 }
 
 static int btrfs_add_nondir(struct btrfs_trans_handle *trans,
-			    struct dentry *dentry, struct inode *inode,
-			    int backref, u64 index)
+			    struct inode *dir, struct dentry *dentry,
+			    struct inode *inode, int backref, u64 index)
 {
-	int err = btrfs_add_link(trans, dentry->d_parent->d_inode,
-				 inode, dentry->d_name.name,
-				 dentry->d_name.len, backref, index);
+	int err = btrfs_add_link(trans, dir, inode,
+				 dentry->d_name.name, dentry->d_name.len,
+				 backref, index);
 	if (!err) {
 		d_instantiate(dentry, inode);
 		return 0;
@@ -4668,8 +4668,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino, objectid,
+				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
@@ -4682,7 +4681,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	}
 
 	btrfs_set_trans_block_group(trans, inode);
-	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
 	else {
@@ -4730,10 +4729,8 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino,
-				objectid, BTRFS_I(dir)->block_group, mode,
-				&index);
+				dentry->d_name.len, dir->i_ino, objectid,
+				BTRFS_I(dir)->block_group, mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_unlock;
@@ -4745,7 +4742,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	}
 
 	btrfs_set_trans_block_group(trans, inode);
-	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
 	else {
@@ -4805,7 +4802,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	btrfs_set_trans_block_group(trans, dir);
 	ihold(inode);
 
-	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 1, index);
 
 	if (err) {
 		drop_inode = 1;
@@ -4855,8 +4852,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino, objectid,
+				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFDIR | mode,
 				&index);
 	if (IS_ERR(inode)) {
@@ -4879,9 +4875,8 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (err)
 		goto out_fail;
 
-	err = btrfs_add_link(trans, dentry->d_parent->d_inode,
-				 inode, dentry->d_name.name,
-				 dentry->d_name.len, 0, index);
+	err = btrfs_add_link(trans, dir, inode, dentry->d_name.name,
+			     dentry->d_name.len, 0, index);
 	if (err)
 		goto out_fail;
 
@@ -6761,8 +6756,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len,
-				dentry->d_parent->d_inode->i_ino, objectid,
+				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO,
 				&index);
 	err = PTR_ERR(inode);
@@ -6776,7 +6770,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	}
 
 	btrfs_set_trans_block_group(trans, inode);
-	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
+	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
 	else {
-- 
1.6.6.1

