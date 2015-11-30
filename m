Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbbK3VoI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 16:44:08 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 05/10] btrfs: Use xattr handler infrastructure
Date: Mon, 30 Nov 2015 22:43:38 +0100
Message-Id: <1448919823-27103-6-git-send-email-agruenba@redhat.com>
In-Reply-To: <1448919823-27103-1-git-send-email-agruenba@redhat.com>
References: <1448919823-27103-1-git-send-email-agruenba@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the VFS xattr handler infrastructure and get rid of similar code in
the filesystem.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/inode.c |   8 +--
 fs/btrfs/xattr.c | 166 ++++++++++++++++++++-----------------------------------
 fs/btrfs/xattr.h |   2 -
 3 files changed, 63 insertions(+), 113 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d540fd7..4fb8d6e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9994,7 +9994,7 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.setattr	= btrfs_setattr,
 	.mknod		= btrfs_mknod,
 	.setxattr	= btrfs_setxattr,
-	.getxattr	= btrfs_getxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
@@ -10071,7 +10071,7 @@ static const struct inode_operations btrfs_file_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.setxattr	= btrfs_setxattr,
-	.getxattr	= btrfs_getxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr      = btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
@@ -10085,7 +10085,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
 	.setxattr	= btrfs_setxattr,
-	.getxattr	= btrfs_getxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.get_acl	= btrfs_get_acl,
@@ -10100,7 +10100,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
 	.setxattr	= btrfs_setxattr,
-	.getxattr	= btrfs_getxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.update_time	= btrfs_update_time,
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 1fcd7b6..7cbef1a 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -351,137 +351,89 @@ err:
 	return ret;
 }
 
-/*
- * List of handlers for synthetic system.* attributes.  All real ondisk
- * attributes are handled directly.
- */
-const struct xattr_handler *btrfs_xattr_handlers[] = {
-#ifdef CONFIG_BTRFS_FS_POSIX_ACL
-	&posix_acl_access_xattr_handler,
-	&posix_acl_default_xattr_handler,
-#endif
-	NULL,
-};
-
-/*
- * Check if the attribute is in a supported namespace.
- *
- * This is applied after the check for the synthetic attributes in the system
- * namespace.
- */
-static int btrfs_is_valid_xattr(const char *name)
+static int btrfs_xattr_handler_get(const struct xattr_handler *handler,
+				   struct dentry *dentry, const char *name,
+				   void *buffer, size_t size)
 {
-	int len = strlen(name);
-	int prefixlen = 0;
-
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			XATTR_SECURITY_PREFIX_LEN))
-		prefixlen = XATTR_SECURITY_PREFIX_LEN;
-	else if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		prefixlen = XATTR_SYSTEM_PREFIX_LEN;
-	else if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
-		prefixlen = XATTR_TRUSTED_PREFIX_LEN;
-	else if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-		prefixlen = XATTR_USER_PREFIX_LEN;
-	else if (!strncmp(name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN))
-		prefixlen = XATTR_BTRFS_PREFIX_LEN;
-	else
-		return -EOPNOTSUPP;
-
-	/*
-	 * The name cannot consist of just prefix
-	 */
-	if (len <= prefixlen)
-		return -EINVAL;
+	struct inode *inode = d_inode(dentry);
 
-	return 0;
+	name = xattr_full_name(handler, name);
+	return __btrfs_getxattr(inode, name, buffer, size);
 }
 
-ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
-		       void *buffer, size_t size)
+static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
+				   struct dentry *dentry, const char *name,
+				   const void *buffer, size_t size,
+				   int flags)
 {
-	int ret;
+	struct inode *inode = d_inode(dentry);
 
-	/*
-	 * If this is a request for a synthetic attribute in the system.*
-	 * namespace use the generic infrastructure to resolve a handler
-	 * for it via sb->s_xattr.
-	 */
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return generic_getxattr(dentry, name, buffer, size);
+	name = xattr_full_name(handler, name);
+	return __btrfs_setxattr(NULL, inode, name, buffer, size, flags);
+}
 
-	ret = btrfs_is_valid_xattr(name);
-	if (ret)
-		return ret;
-	return __btrfs_getxattr(d_inode(dentry), name, buffer, size);
+static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
+					struct dentry *dentry,
+					const char *name, const void *value,
+					size_t size, int flags)
+{
+	name = xattr_full_name(handler, name);
+	return btrfs_set_prop(d_inode(dentry), name, value, size, flags);
 }
 
+static const struct xattr_handler btrfs_security_xattr_handler = {
+	.prefix = XATTR_SECURITY_PREFIX,
+	.get = btrfs_xattr_handler_get,
+	.set = btrfs_xattr_handler_set,
+};
+
+static const struct xattr_handler btrfs_trusted_xattr_handler = {
+	.prefix = XATTR_TRUSTED_PREFIX,
+	.get = btrfs_xattr_handler_get,
+	.set = btrfs_xattr_handler_set,
+};
+
+static const struct xattr_handler btrfs_user_xattr_handler = {
+	.prefix = XATTR_USER_PREFIX,
+	.get = btrfs_xattr_handler_get,
+	.set = btrfs_xattr_handler_set,
+};
+
+static const struct xattr_handler btrfs_btrfs_xattr_handler = {
+	.prefix = XATTR_BTRFS_PREFIX,
+	.get = btrfs_xattr_handler_get,
+	.set = btrfs_xattr_handler_set_prop,
+};
+
+const struct xattr_handler *btrfs_xattr_handlers[] = {
+	&btrfs_security_xattr_handler,
+#ifdef CONFIG_BTRFS_FS_POSIX_ACL
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
+#endif
+	&btrfs_trusted_xattr_handler,
+	&btrfs_user_xattr_handler,
+	&btrfs_btrfs_xattr_handler,
+	NULL,
+};
+
 int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		   size_t size, int flags)
 {
 	struct btrfs_root *root = BTRFS_I(d_inode(dentry))->root;
-	int ret;
 
-	/*
-	 * The permission on security.* and system.* is not checked
-	 * in permission().
-	 */
 	if (btrfs_root_readonly(root))
 		return -EROFS;
-
-	/*
-	 * If this is a request for a synthetic attribute in the system.*
-	 * namespace use the generic infrastructure to resolve a handler
-	 * for it via sb->s_xattr.
-	 */
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return generic_setxattr(dentry, name, value, size, flags);
-
-	ret = btrfs_is_valid_xattr(name);
-	if (ret)
-		return ret;
-
-	if (!strncmp(name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN))
-		return btrfs_set_prop(d_inode(dentry), name,
-				      value, size, flags);
-
-	if (size == 0)
-		value = "";  /* empty EA, do not remove */
-
-	return __btrfs_setxattr(NULL, d_inode(dentry), name, value, size,
-				flags);
+	return generic_setxattr(dentry, name, value, size, flags);
 }
 
 int btrfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct btrfs_root *root = BTRFS_I(d_inode(dentry))->root;
-	int ret;
 
-	/*
-	 * The permission on security.* and system.* is not checked
-	 * in permission().
-	 */
 	if (btrfs_root_readonly(root))
 		return -EROFS;
-
-	/*
-	 * If this is a request for a synthetic attribute in the system.*
-	 * namespace use the generic infrastructure to resolve a handler
-	 * for it via sb->s_xattr.
-	 */
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return generic_removexattr(dentry, name);
-
-	ret = btrfs_is_valid_xattr(name);
-	if (ret)
-		return ret;
-
-	if (!strncmp(name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN))
-		return btrfs_set_prop(d_inode(dentry), name,
-				      NULL, 0, XATTR_REPLACE);
-
-	return __btrfs_setxattr(NULL, d_inode(dentry), name, NULL, 0,
-				XATTR_REPLACE);
+	return generic_removexattr(dentry, name);
 }
 
 static int btrfs_initxattrs(struct inode *inode,
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 5049608..96807b3 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -28,8 +28,6 @@ extern ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
 extern int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 			    struct inode *inode, const char *name,
 			    const void *value, size_t size, int flags);
-extern ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
-		void *buffer, size_t size);
 extern int btrfs_setxattr(struct dentry *dentry, const char *name,
 		const void *value, size_t size, int flags);
 extern int btrfs_removexattr(struct dentry *dentry, const char *name);
-- 
2.5.0

