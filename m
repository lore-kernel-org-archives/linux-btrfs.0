From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] optimize btrget/set/removexattr
Date: Sun, 24 Aug 2008 02:18:12 +0200
Message-ID: <20080824001812.GA5929@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs actually stores the whole xattr name, including the prefix ondisk,
so using the generic resolver that strips off the prefix is not very
helpful.  Instead do the real ondisk xattrs manually and only use the
generic resolver for synthetic xattrs like ACLs.

(Sorry Josef for guiding you towards the wrong direction here intially)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/xattr.c
===================================================================
--- btrfs-unstable.orig/xattr.c	2008-08-23 20:49:46.000000000 -0300
+++ btrfs-unstable/xattr.c	2008-08-23 21:03:20.000000000 -0300
@@ -27,91 +27,20 @@
 #include "xattr.h"
 #include "disk-io.h"
 
-static struct xattr_handler *btrfs_xattr_handler_map[] = {
-	[BTRFS_XATTR_INDEX_USER]		= &btrfs_xattr_user_handler,
-#ifdef CONFIG_FS_POSIX_ACL
-	[BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS]	= &btrfs_xattr_acl_access_handler,
-	[BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT]	= &btrfs_xattr_acl_default_handler,
-#endif
-	[BTRFS_XATTR_INDEX_TRUSTED]		= &btrfs_xattr_trusted_handler,
-	[BTRFS_XATTR_INDEX_SECURITY]		= &btrfs_xattr_security_handler,
-	[BTRFS_XATTR_INDEX_SYSTEM]		= &btrfs_xattr_system_handler,
-};
-
-struct xattr_handler *btrfs_xattr_handlers[] = {
-	&btrfs_xattr_user_handler,
-#ifdef CONFIG_FS_POSIX_ACL
-	&btrfs_xattr_acl_access_handler,
-	&btrfs_xattr_acl_default_handler,
-#endif
-	&btrfs_xattr_trusted_handler,
-	&btrfs_xattr_security_handler,
-	&btrfs_xattr_system_handler,
-	NULL,
-};
-
-/*
- * @param name_index - the index for the xattr handler
- * @return the xattr_handler if we found it, NULL otherwise
- *
- * use this if we know the type of the xattr already
- */
-static struct xattr_handler *btrfs_xattr_handler(int name_index)
-{
-	struct xattr_handler *handler = NULL;
-
-	if (name_index >= 0 &&
-	    name_index < ARRAY_SIZE(btrfs_xattr_handler_map))
-		handler = btrfs_xattr_handler_map[name_index];
 
-	return handler;
-}
-
-static inline char *get_name(const char *name, int name_index)
-{
-	char *ret = NULL;
-	struct xattr_handler *handler = btrfs_xattr_handler(name_index);
-	int prefix_len;
-
-	if (!handler)
-		return ret;
-
-	prefix_len = strlen(handler->prefix);
-
-	ret = kmalloc(strlen(name) + prefix_len + 1, GFP_KERNEL);
-	if (!ret)
-		return ret;
-
-	memcpy(ret, handler->prefix, prefix_len);
-	memcpy(ret+prefix_len, name, strlen(name));
-	ret[prefix_len + strlen(name)] = '\0';
-
-	return ret;
-}
-
-ssize_t btrfs_xattr_get(struct inode *inode, int name_index,
-			const char *attr_name, void *buffer, size_t size)
+ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
+				void *buffer, size_t size)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	struct xattr_handler *handler = btrfs_xattr_handler(name_index);
 	int ret = 0;
 	unsigned long data_ptr;
-	char *name;
-
-	if (!handler)
-		return -EOPNOTSUPP;
-	name = get_name(attr_name, name_index);
-	if (!name)
-		return -ENOMEM;
 
 	path = btrfs_alloc_path();
-	if (!path) {
-		kfree(name);
+	if (!path)
 		return -ENOMEM;
-	}
 
 	/* lookup the xattr by name */
 	di = btrfs_lookup_xattr(NULL, root, path, inode->i_ino, name,
@@ -140,33 +69,22 @@ ssize_t btrfs_xattr_get(struct inode *in
 	ret = btrfs_dir_data_len(leaf, di);
 
 out:
-	kfree(name);
 	btrfs_free_path(path);
 	return ret;
 }
 
-int btrfs_xattr_set(struct inode *inode, int name_index,
-		    const char *attr_name, const void *value, size_t size,
-		    int flags)
+int __btrfs_setxattr(struct inode *inode, const char *name,
+			    const void *value, size_t size, int flags)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
-	struct xattr_handler *handler = btrfs_xattr_handler(name_index);
-	char *name;
 	int ret = 0, mod = 0;
-	if (!handler)
-		return -EOPNOTSUPP;
-	name = get_name(attr_name, name_index);
-	if (!name)
-		return -ENOMEM;
 
 	path = btrfs_alloc_path();
-	if (!path) {
-		kfree(name);
+	if (!path)
 		return -ENOMEM;
-	}
 
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, inode);
@@ -221,9 +139,7 @@ out:
 	}
 
 	btrfs_end_transaction(trans, root);
-	kfree(name);
 	btrfs_free_path(path);
-
 	return ret;
 }
 
@@ -329,51 +245,77 @@ err:
 }
 
 /*
- * Handler functions
+ * List of handlers for synthetic system.* attributes.  All real ondisk
+ * attributes are handled directly.
  */
-#define BTRFS_XATTR_SETGET_FUNCS(name, index)				\
-static int btrfs_xattr_##name##_get(struct inode *inode,		\
-				    const char *name, void *value,	\
-				    size_t size)			\
-{									\
-	if (*name == '\0')						\
-		return -EINVAL;						\
-	return btrfs_xattr_get(inode, index, name, value, size);	\
-}									\
-static int btrfs_xattr_##name##_set(struct inode *inode,		\
-				    const char *name, const void *value,\
-				    size_t size, int flags)		\
-{									\
-	if (*name == '\0')						\
-		return -EINVAL;						\
-	return btrfs_xattr_set(inode, index, name, value, size, flags);	\
+struct xattr_handler *btrfs_xattr_handlers[] = {
+#ifdef CONFIG_FS_POSIX_ACL
+	&btrfs_xattr_acl_access_handler,
+	&btrfs_xattr_acl_default_handler,
+#endif
+	NULL,
+};
+
+/*
+ * Check if the attribute is in a supported namespace.
+ *
+ * This applied after the check for the synthetic attributes in the system
+ * namespace.
+ */
+static bool btrfs_is_valid_xattr(const char *name)
+{
+	return !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) ||
+	       !strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) ||
+	       !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
+	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 }
 
-BTRFS_XATTR_SETGET_FUNCS(security, BTRFS_XATTR_INDEX_SECURITY);
-BTRFS_XATTR_SETGET_FUNCS(system, BTRFS_XATTR_INDEX_SYSTEM);
-BTRFS_XATTR_SETGET_FUNCS(user, BTRFS_XATTR_INDEX_USER);
-BTRFS_XATTR_SETGET_FUNCS(trusted, BTRFS_XATTR_INDEX_TRUSTED);
-
-struct xattr_handler btrfs_xattr_security_handler = {
-	.prefix = XATTR_SECURITY_PREFIX,
-	.get	= btrfs_xattr_security_get,
-	.set	= btrfs_xattr_security_set,
-};
+ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
+		       void *buffer, size_t size)
+{
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_getxattr(dentry, name, buffer, size);
 
-struct xattr_handler btrfs_xattr_system_handler = {
-	.prefix = XATTR_SYSTEM_PREFIX,
-	.get	= btrfs_xattr_system_get,
-	.set	= btrfs_xattr_system_set,
-};
+	if (!btrfs_is_valid_xattr(name))
+		return -EOPNOTSUPP;
+	return __btrfs_getxattr(dentry->d_inode, name, buffer, size);
+}
 
-struct xattr_handler btrfs_xattr_user_handler = {
-	.prefix	= XATTR_USER_PREFIX,
-	.get	= btrfs_xattr_user_get,
-	.set	= btrfs_xattr_user_set,
-};
+int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		   size_t size, int flags)
+{
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_setxattr(dentry, name, value, size, flags);
 
-struct xattr_handler btrfs_xattr_trusted_handler = {
-	.prefix = XATTR_TRUSTED_PREFIX,
-	.get	= btrfs_xattr_trusted_get,
-	.set	= btrfs_xattr_trusted_set,
-};
+	if (!btrfs_is_valid_xattr(name))
+		return -EOPNOTSUPP;
+
+	if (size == 0)
+		value = "";  /* empty EA, do not remove */
+	return __btrfs_setxattr(dentry->d_inode, name, value, size, flags);
+}
+
+int btrfs_removexattr(struct dentry *dentry, const char *name)
+{
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_removexattr(dentry, name);
+
+	if (!btrfs_is_valid_xattr(name))
+		return -EOPNOTSUPP;
+	return __btrfs_setxattr(dentry->d_inode, name, NULL, 0, XATTR_REPLACE);
+}
Index: btrfs-unstable/acl.c
===================================================================
--- btrfs-unstable.orig/acl.c	2008-08-23 21:02:55.000000000 -0300
+++ btrfs-unstable/acl.c	2008-08-23 21:08:05.000000000 -0300
@@ -40,17 +40,18 @@ static void btrfs_update_cached_acl(stru
 
 static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 {
-	int size, name_index;
+	int size;
+	const char *name;
 	char *value = NULL;
 	struct posix_acl *acl = NULL, **p_acl;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS;
+		name = POSIX_ACL_XATTR_ACCESS;
 		p_acl = &BTRFS_I(inode)->i_acl;
 		break;
 	case ACL_TYPE_DEFAULT:
-		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		name = POSIX_ACL_XATTR_DEFAULT;
 		p_acl = &BTRFS_I(inode)->i_default_acl;
 		break;
 	default:
@@ -66,12 +67,12 @@ static struct posix_acl *btrfs_get_acl(s
 		return acl;
 
 
-	size = btrfs_xattr_get(inode, name_index, "", NULL, 0);
+	size = __btrfs_getxattr(inode, name, "", 0);
 	if (size > 0) {
 		value = kzalloc(size, GFP_NOFS);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
-		size = btrfs_xattr_get(inode, name_index, "", value, size);
+		size = __btrfs_getxattr(inode, name, value, size);
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
 			btrfs_update_cached_acl(inode, p_acl, acl);
@@ -108,7 +109,8 @@ static int btrfs_xattr_get_acl(struct in
  */
 static int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
-	int ret, name_index = 0, size = 0;
+	int ret, size = 0;
+	const char *name;
 	struct posix_acl **p_acl;
 	char *value = NULL;
 	mode_t mode;
@@ -128,13 +130,13 @@ static int btrfs_set_acl(struct inode *i
 			return ret;
 		ret = 0;
 		inode->i_mode = mode;
-		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS;
+		name = POSIX_ACL_XATTR_ACCESS;
 		p_acl = &BTRFS_I(inode)->i_acl;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
 			return acl ? -EINVAL : 0;
-		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		name = POSIX_ACL_XATTR_DEFAULT;
 		p_acl = &BTRFS_I(inode)->i_default_acl;
 		break;
 	default:
@@ -154,7 +156,7 @@ static int btrfs_set_acl(struct inode *i
 			goto out;
 	}
 
-	ret = btrfs_xattr_set(inode, name_index, "", value, size, 0);
+	ret = __btrfs_setxattr(inode, name, value, size, 0);
 
 out:
 	if (value)
Index: btrfs-unstable/xattr.h
===================================================================
--- btrfs-unstable.orig/xattr.h	2008-08-23 21:02:18.000000000 -0300
+++ btrfs-unstable/xattr.h	2008-08-23 21:10:20.000000000 -0300
@@ -20,31 +20,20 @@
 #define __XATTR__
 
 #include <linux/xattr.h>
-#include "ctree.h"
 
-/* Name indexes */
-enum {
-	BTRFS_XATTR_INDEX_USER,
-	BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS,
-	BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT,
-	BTRFS_XATTR_INDEX_TRUSTED,
-	BTRFS_XATTR_INDEX_SECURITY,
-	BTRFS_XATTR_INDEX_SYSTEM,
-	BTRFS_XATTR_INDEX_END,
-};
-
-extern struct xattr_handler btrfs_xattr_user_handler;
-extern struct xattr_handler btrfs_xattr_trusted_handler;
 extern struct xattr_handler btrfs_xattr_acl_access_handler;
 extern struct xattr_handler btrfs_xattr_acl_default_handler;
-extern struct xattr_handler btrfs_xattr_security_handler;
-extern struct xattr_handler btrfs_xattr_system_handler;
-
 extern struct xattr_handler *btrfs_xattr_handlers[];
 
-ssize_t btrfs_xattr_get(struct inode *inode, int name_index, const char *name,
-			void *buffer, size_t size);
-int btrfs_xattr_set(struct inode *inode, int name_index, const char *name,
-			const void *value, size_t size, int flags);
+extern ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
+		void *buffer, size_t size);
+extern int __btrfs_setxattr(struct inode *inode, const char *name,
+		const void *value, size_t size, int flags);
+
+extern ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
+		void *buffer, size_t size);
+extern int btrfs_setxattr(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags);
+extern int btrfs_removexattr(struct dentry *dentry, const char *name);
 
 #endif /* __XATTR__ */
Index: btrfs-unstable/inode.c
===================================================================
--- btrfs-unstable.orig/inode.c	2008-08-23 21:10:41.000000000 -0300
+++ btrfs-unstable/inode.c	2008-08-23 21:11:39.000000000 -0300
@@ -45,6 +45,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "ordered-data.h"
+#include "xattr.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -3667,10 +3668,10 @@ static struct inode_operations btrfs_dir
 	.symlink	= btrfs_symlink,
 	.setattr	= btrfs_setattr,
 	.mknod		= btrfs_mknod,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
+	.setxattr	= btrfs_setxattr,
+	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= generic_removexattr,
+	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
 };
 static struct inode_operations btrfs_dir_ro_inode_operations = {
@@ -3728,20 +3729,20 @@ static struct inode_operations btrfs_fil
 	.truncate	= btrfs_truncate,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
+	.setxattr	= btrfs_setxattr,
+	.getxattr	= btrfs_getxattr,
 	.listxattr      = btrfs_listxattr,
-	.removexattr	= generic_removexattr,
+	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
 };
 static struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
+	.setxattr	= btrfs_setxattr,
+	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= generic_removexattr,
+	.removexattr	= btrfs_removexattr,
 };
 static struct inode_operations btrfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
