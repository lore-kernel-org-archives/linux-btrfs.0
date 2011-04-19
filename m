From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: cleanup error handling in inode.c
Date: Tue, 19 Apr 2011 14:05:58 +0900
Message-ID: <201104190505.AA00013@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The error processing of several places is changed like setting the
error number only at the error.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a4157cf..e8e3a18 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4730,9 +4730,10 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
-	err = PTR_ERR(inode);
-	if (IS_ERR(inode))
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out_unlock;
+	}
 
 	err = btrfs_init_inode_security(trans, inode, dir);
 	if (err) {
@@ -4791,9 +4792,10 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
-	err = PTR_ERR(inode);
-	if (IS_ERR(inode))
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out_unlock;
+	}
 
 	err = btrfs_init_inode_security(trans, inode, dir);
 	if (err) {
@@ -7275,9 +7277,10 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO,
 				&index);
-	err = PTR_ERR(inode);
-	if (IS_ERR(inode))
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out_unlock;
+	}
 
 	err = btrfs_init_inode_security(trans, inode, dir);
 	if (err) {

