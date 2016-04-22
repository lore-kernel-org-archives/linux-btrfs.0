Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbcDVUgu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 16:36:50 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-btrfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] btrfs: Switch to generic xattr handlers
Date: Fri, 22 Apr 2016 22:36:44 +0200
Message-Id: <1461357404-28350-1-git-send-email-agruenba@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_{set,remove}xattr inode operations check for a read-only root
(btrfs_root_readonly) before calling into generic_{set,remove}xattr.  If
this check is moved into __btrfs_setxattr, we can get rid of
btrfs_{set,remove}xattr.

This patch applies to mainline, I would like to keep it together with
the other xattr cleanups if possible, though.  Could you please review?

Thanks,
Andreas


Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/btrfs/inode.c | 16 ++++++++--------
 fs/btrfs/xattr.c | 22 +++-------------------
 fs/btrfs/xattr.h |  3 ---
 3 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 41a5688..0077b3b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10160,10 +10160,10 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.symlink	= btrfs_symlink,
 	.setattr	= btrfs_setattr,
 	.mknod		= btrfs_mknod,
-	.setxattr	= btrfs_setxattr,
+	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= btrfs_removexattr,
+	.removexattr	= generic_removexattr,
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
@@ -10237,10 +10237,10 @@ static const struct address_space_operations btrfs_symlink_aops = {
 static const struct inode_operations btrfs_file_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
-	.setxattr	= btrfs_setxattr,
+	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
 	.listxattr      = btrfs_listxattr,
-	.removexattr	= btrfs_removexattr,
+	.removexattr	= generic_removexattr,
 	.permission	= btrfs_permission,
 	.fiemap		= btrfs_fiemap,
 	.get_acl	= btrfs_get_acl,
@@ -10251,10 +10251,10 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
-	.setxattr	= btrfs_setxattr,
+	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= btrfs_removexattr,
+	.removexattr	= generic_removexattr,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
@@ -10265,10 +10265,10 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
-	.setxattr	= btrfs_setxattr,
+	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= btrfs_removexattr,
+	.removexattr	= generic_removexattr,
 	.update_time	= btrfs_update_time,
 };
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 03224b0..3bfb252 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -237,6 +237,9 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	if (trans)
 		return do_setxattr(trans, inode, name, value, size, flags);
 
@@ -432,25 +435,6 @@ const struct xattr_handler *btrfs_xattr_handlers[] = {
 	NULL,
 };
 
-int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		   size_t size, int flags)
-{
-	struct btrfs_root *root = BTRFS_I(d_inode(dentry))->root;
-
-	if (btrfs_root_readonly(root))
-		return -EROFS;
-	return generic_setxattr(dentry, name, value, size, flags);
-}
-
-int btrfs_removexattr(struct dentry *dentry, const char *name)
-{
-	struct btrfs_root *root = BTRFS_I(d_inode(dentry))->root;
-
-	if (btrfs_root_readonly(root))
-		return -EROFS;
-	return generic_removexattr(dentry, name);
-}
-
 static int btrfs_initxattrs(struct inode *inode,
 			    const struct xattr *xattr_array, void *fs_info)
 {
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 96807b3..15fc474 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -28,9 +28,6 @@ extern ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
 extern int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 			    struct inode *inode, const char *name,
 			    const void *value, size_t size, int flags);
-extern int btrfs_setxattr(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags);
-extern int btrfs_removexattr(struct dentry *dentry, const char *name);
 
 extern int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
 				     struct inode *inode, struct inode *dir,
-- 
2.5.5

