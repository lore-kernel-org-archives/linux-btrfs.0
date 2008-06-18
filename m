From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] add proper ACL support to btrfs
Date: Wed, 18 Jun 2008 10:34:23 -0400
Message-ID: <20080618143423.GD20021@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch adds proper full ACL support to btrfs.  I've tested this with the ACL
tests in LTP and in the XFS stuff and everything is on par with ext*.  Alot of
this will probably have to be re-arranged when fs_mutex goes bye-bye, but it
shouldnt be too bad.  Thanks much,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff -r 79b81fd6dd78 acl.c
--- a/acl.c	Thu Jun 12 14:46:17 2008 -0400
+++ b/acl.c	Wed Jun 18 17:34:41 2008 -0400
@@ -20,76 +20,281 @@
 #include <linux/string.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/posix_acl.h>
 #include <linux/sched.h>
+
 #include "ctree.h"
+#include "btrfs_inode.h"
 #include "xattr.h"
-#ifndef is_owner_or_cap
-#define is_owner_or_cap(inode)	\
-	((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
-#endif
+
+static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
+{
+	int size, name_index;
+	char *value = NULL;
+	struct posix_acl *acl = NULL;
+
+	if (type == ACL_TYPE_ACCESS)
+		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS;
+	else
+		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
+
+
+	size = btrfs_xattr_get_locked(inode, name_index, "", NULL, 0);
+	if (size > 0) {
+		value = kzalloc(size, GFP_NOFS);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		size = btrfs_xattr_get_locked(inode, name_index, "", value,
+					      size);
+		if (size > 0)
+			acl = posix_acl_from_xattr(value, size);
+		kfree(value);
+	}
+
+	return acl;
+}
+
+static int btrfs_xattr_get_acl(struct inode *inode, int type,
+			       void *value, size_t size)
+{
+	struct posix_acl *acl;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;
+
+	mutex_lock(&root->fs_info->fs_mutex);
+	acl = btrfs_get_acl(inode, type);
+	mutex_unlock(&root->fs_info->fs_mutex);
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	ret = posix_acl_to_xattr(acl, value, size);
+	posix_acl_release(acl);
+
+	return ret;
+}
+
+/*
+ * Needs to be called with fs_mutex held
+ */
+static int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
+{
+	int ret, name_index = 0, size = 0;
+	char *value = NULL;
+
+	if (acl) {
+		mode_t mode;
+
+		ret = posix_acl_valid(acl);
+		if (ret < 0)
+			goto out;
+
+		switch (type) {
+		case ACL_TYPE_ACCESS:
+			mode = inode->i_mode;
+			ret = posix_acl_equiv_mode(acl, &mode);
+			if (ret < 0)
+				goto out;
+			ret = 0;
+			inode->i_mode = mode;
+			name_index = BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS;
+			break;
+		case ACL_TYPE_DEFAULT:
+			if (!S_ISDIR(inode->i_mode)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			name_index = BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
+			break;
+		}
+
+		size = posix_acl_xattr_size(acl->a_count);
+		value = kmalloc(size, GFP_NOFS);
+		if (!value) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = posix_acl_to_xattr(acl, value, size);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret =  btrfs_xattr_set_locked(inode, name_index, "", value, size, 0);
+
+out:
+	if (value)
+		kfree(value);
+
+	return ret;
+}
 
 static int btrfs_xattr_set_acl(struct inode *inode, int type,
 			       const void *value, size_t size)
 {
 	int ret = 0;
-	struct posix_acl *acl;
+	struct posix_acl *acl = NULL;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (!is_owner_or_cap(inode))
-		return -EPERM;
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
 		if (acl == NULL) {
 			value = NULL;
 			size = 0;
 		} else if (IS_ERR(acl)) {
-			ret = PTR_ERR(acl);
-		} else {
-			ret = posix_acl_valid(acl);
-			posix_acl_release(acl);
+			return PTR_ERR(acl);
 		}
-		if (ret)
-			return ret;
 	}
-	return btrfs_xattr_set(inode, type, "", value, size, 0);
+
+	mutex_lock(&root->fs_info->fs_mutex);
+
+	ret = btrfs_set_acl(inode, acl, type);
+
+	mutex_unlock(&root->fs_info->fs_mutex);
+
+	posix_acl_release(acl);
+
+	return ret;
 }
 
-static int btrfs_xattr_get_acl(struct inode *inode, int type,
-			       void *value, size_t size)
-{
-	return btrfs_xattr_get(inode, type, "", value, size);
-}
+
 static int btrfs_xattr_acl_access_get(struct inode *inode, const char *name,
 				      void *value, size_t size)
 {
-	if (*name != '\0')
-	       return -EINVAL;
-	return btrfs_xattr_get_acl(inode, BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS,
-				   value, size);
+	return btrfs_xattr_get_acl(inode, ACL_TYPE_ACCESS, value, size);
 }
+
 static int btrfs_xattr_acl_access_set(struct inode *inode, const char *name,
 				      const void *value, size_t size, int flags)
 {
-	if (*name != '\0')
-	       return -EINVAL;
-	return btrfs_xattr_set_acl(inode, BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS,
-				   value, size);
+	return btrfs_xattr_set_acl(inode, ACL_TYPE_ACCESS, value, size);
 }
+
 static int btrfs_xattr_acl_default_get(struct inode *inode, const char *name,
 				       void *value, size_t size)
 {
-	if (*name != '\0')
-	       return -EINVAL;
-	return btrfs_xattr_get_acl(inode, BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT,
-				   value, size);
+	return btrfs_xattr_get_acl(inode, ACL_TYPE_DEFAULT, value, size);
 }
+
 static int btrfs_xattr_acl_default_set(struct inode *inode, const char *name,
 				       const void *value, size_t size, int flags)
 {
-	if (*name != '\0')
-	       return -EINVAL;
-	return btrfs_xattr_set_acl(inode, BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT,
-				   value, size);
+	return btrfs_xattr_set_acl(inode, ACL_TYPE_DEFAULT, value, size);
 }
+
+int btrfs_check_acl(struct inode *inode, int mask)
+{
+	struct posix_acl *acl;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int error = -EAGAIN;
+
+	mutex_lock(&root->fs_info->fs_mutex);
+	acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
+	mutex_unlock(&root->fs_info->fs_mutex);
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		error = posix_acl_permission(inode, acl, mask);
+		posix_acl_release(acl);
+	}
+
+	return error;
+}
+
+/*
+ * btrfs_init_acl is already generally called under fs_mutex, so the locking
+ * stuff has been fixed to work with that.  If the locking stuff changes, we
+ * need to re-evaluate the acl locking stuff.
+ */
+int btrfs_init_acl(struct inode *inode, struct inode *dir)
+{
+	struct posix_acl *acl = NULL;
+	int ret = 0;
+
+	/* this happens with subvols */
+	if (!dir)
+		return 0;
+
+	if (!S_ISLNK(inode->i_mode)) {
+		if (IS_POSIXACL(dir)) {
+			acl = btrfs_get_acl(dir, ACL_TYPE_DEFAULT);
+			if (IS_ERR(acl))
+				return PTR_ERR(acl);
+		}
+
+		if (!acl)
+			inode->i_mode &= ~current->fs->umask;
+	}
+
+	if (IS_POSIXACL(dir) && acl) {
+		struct posix_acl *clone;
+		mode_t mode;
+
+		if (S_ISDIR(inode->i_mode)) {
+			ret = btrfs_set_acl(inode, acl, ACL_TYPE_DEFAULT);
+			if (ret)
+				goto failed;
+		}
+		clone = posix_acl_clone(acl, GFP_NOFS);
+		ret = -ENOMEM;
+		if (!clone)
+			goto failed;
+
+		mode = inode->i_mode;
+		ret = posix_acl_create_masq(clone, &mode);
+		if (ret >= 0) {
+			inode->i_mode = mode;
+			if (ret > 0) {
+				/* we need an acl */
+				ret = btrfs_set_acl(inode, clone,
+						    ACL_TYPE_ACCESS);
+			}
+		}
+	}
+failed:
+	posix_acl_release(acl);
+
+	return ret;
+}
+
+int btrfs_acl_chmod(struct inode *inode)
+{
+	struct posix_acl *acl, *clone;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (!IS_POSIXACL(inode))
+		return 0;
+
+	mutex_lock(&root->fs_info->fs_mutex);
+	acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl) {
+		mutex_unlock(&root->fs_info->fs_mutex);
+		return PTR_ERR(acl);
+	}
+
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	posix_acl_release(acl);
+	if (!clone) {
+		mutex_unlock(&root->fs_info->fs_mutex);
+		return -ENOMEM;
+	}
+
+	ret = posix_acl_chmod_masq(clone, inode->i_mode);
+	if (!ret)
+		ret = btrfs_set_acl(inode, clone, ACL_TYPE_ACCESS);
+
+	posix_acl_release(clone);
+	mutex_unlock(&root->fs_info->fs_mutex);
+
+	return ret;
+}
+
 struct xattr_handler btrfs_xattr_acl_default_handler = {
 	.prefix = POSIX_ACL_XATTR_DEFAULT,
 	.list	= btrfs_xattr_generic_list,
diff -r 79b81fd6dd78 ctree.h
--- a/ctree.h	Thu Jun 12 14:46:17 2008 -0400
+++ b/ctree.h	Wed Jun 18 17:34:41 2008 -0400
@@ -1638,4 +1638,9 @@ u64 btrfs_parse_size(char *str);
 u64 btrfs_parse_size(char *str);
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+
+/* acl.c */
+int btrfs_check_acl(struct inode *inode, int mask);
+int btrfs_init_acl(struct inode *inode, struct inode *dir);
+int btrfs_acl_chmod(struct inode *inode);
 #endif
diff -r 79b81fd6dd78 inode.c
--- a/inode.c	Thu Jun 12 14:46:17 2008 -0400
+++ b/inode.c	Wed Jun 18 17:34:41 2008 -0400
@@ -1263,6 +1263,9 @@ static int btrfs_setattr(struct dentry *
 	}
 out:
 	err = inode_setattr(inode, attr);
+
+	if (!err && ((attr->ia_valid & ATTR_MODE)))
+		err = btrfs_acl_chmod(inode);
 fail:
 	return err;
 }
@@ -1890,6 +1893,12 @@ static int btrfs_mknod(struct inode *dir
 	if (IS_ERR(inode))
 		goto out_unlock;
 
+	err = btrfs_init_acl(inode, dir);
+	if (err) {
+		drop_inode = 1;
+		goto out_unlock;
+	}
+
 	btrfs_set_trans_block_group(trans, inode);
 	err = btrfs_add_nondir(trans, dentry, inode, 0);
 	if (err)
@@ -1948,6 +1957,12 @@ static int btrfs_create(struct inode *di
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_unlock;
+
+	err = btrfs_init_acl(inode, dir);
+	if (err) {
+		drop_inode = 1;
+		goto out_unlock;
+	}
 
 	btrfs_set_trans_block_group(trans, inode);
 	err = btrfs_add_nondir(trans, dentry, inode, 0);
@@ -2076,6 +2091,11 @@ static int btrfs_mkdir(struct inode *dir
 	}
 
 	drop_on_err = 1;
+
+	err = btrfs_init_acl(inode, dir);
+	if (err)
+		goto out_fail;
+
 	inode->i_op = &btrfs_dir_inode_operations;
 	inode->i_fop = &btrfs_dir_file_operations;
 	btrfs_set_trans_block_group(trans, inode);
@@ -2914,6 +2934,12 @@ static int btrfs_symlink(struct inode *d
 	if (IS_ERR(inode))
 		goto out_unlock;
 
+	err = btrfs_init_acl(inode, dir);
+	if (err) {
+		drop_inode = 1;
+		goto out_unlock;
+	}
+
 	btrfs_set_trans_block_group(trans, inode);
 	err = btrfs_add_nondir(trans, dentry, inode, 0);
 	if (err)
@@ -2988,7 +3014,7 @@ static int btrfs_permission(struct inode
 {
 	if (btrfs_test_flag(inode, READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
-	return generic_permission(inode, mask, NULL);
+	return generic_permission(inode, mask, btrfs_check_acl);
 }
 
 static struct inode_operations btrfs_dir_inode_operations = {
@@ -3068,6 +3094,10 @@ static struct inode_operations btrfs_spe
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= btrfs_listxattr,
+	.removexattr	= generic_removexattr,
 };
 static struct inode_operations btrfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
diff -r 79b81fd6dd78 super.c
--- a/super.c	Thu Jun 12 14:46:17 2008 -0400
+++ b/super.c	Wed Jun 18 17:34:41 2008 -0400
@@ -67,7 +67,7 @@ enum {
 enum {
 	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
-	Opt_ssd, Opt_thread_pool, Opt_err,
+	Opt_ssd, Opt_thread_pool, Opt_noacl,  Opt_err,
 };
 
 static match_table_t tokens = {
@@ -82,7 +82,8 @@ static match_table_t tokens = {
 	{Opt_alloc_start, "alloc_start=%s"},
 	{Opt_thread_pool, "thread_pool=%d"},
 	{Opt_ssd, "ssd"},
-	{Opt_err, NULL}
+	{Opt_noacl, "noacl"},
+	{Opt_err, NULL},
 };
 
 u64 btrfs_parse_size(char *str)
@@ -213,6 +214,9 @@ int btrfs_parse_options(struct btrfs_roo
 					"btrfs: allocations start at %llu\n",
 					info->alloc_start);
 			}
+			break;
+		case Opt_noacl:
+			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
 		default:
 			break;
@@ -300,6 +304,7 @@ static int btrfs_fill_super(struct super
 	sb->s_op = &btrfs_super_ops;
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
+	sb->s_flags |= MS_POSIXACL;
 
 	tree_root = open_ctree(sb, fs_devices, (char *)data);
 
diff -r 79b81fd6dd78 xattr.c
--- a/xattr.c	Thu Jun 12 14:46:17 2008 -0400
+++ b/xattr.c	Wed Jun 18 17:34:41 2008 -0400
@@ -26,25 +26,27 @@
 #include "transaction.h"
 #include "xattr.h"
 #include "disk-io.h"
+
 static struct xattr_handler *btrfs_xattr_handler_map[] = {
 	[BTRFS_XATTR_INDEX_USER]		= &btrfs_xattr_user_handler,
 #ifdef CONFIG_FS_POSIX_ACL
-//	[BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS]	= &btrfs_xattr_acl_access_handler,
-//	[BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT]	= &btrfs_xattr_acl_default_handler,
+	[BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS]	= &btrfs_xattr_acl_access_handler,
+	[BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT]	= &btrfs_xattr_acl_default_handler,
 #endif
 	[BTRFS_XATTR_INDEX_TRUSTED]		= &btrfs_xattr_trusted_handler,
 	[BTRFS_XATTR_INDEX_SECURITY]		= &btrfs_xattr_security_handler,
-//	[BTRFS_XATTR_INDEX_SYSTEM]		= &btrfs_xattr_system_handler,
+	[BTRFS_XATTR_INDEX_SYSTEM]		= &btrfs_xattr_system_handler,
 };
+
 struct xattr_handler *btrfs_xattr_handlers[] = {
 	&btrfs_xattr_user_handler,
 #ifdef CONFIG_FS_POSIX_ACL
-//	&btrfs_xattr_acl_access_handler,
-//	&btrfs_xattr_acl_default_handler,
+	&btrfs_xattr_acl_access_handler,
+	&btrfs_xattr_acl_default_handler,
 #endif
 	&btrfs_xattr_trusted_handler,
 	&btrfs_xattr_security_handler,
-//	&btrfs_xattr_system_handler,
+	&btrfs_xattr_system_handler,
 	NULL,
 };
 
@@ -129,8 +131,12 @@ size_t btrfs_xattr_generic_list(struct i
 	return name_len+1;
 }
 
-ssize_t btrfs_xattr_get(struct inode *inode, int name_index,
-			const char *attr_name, void *buffer, size_t size)
+/*
+ * Use this if fs_mutex is already held
+ */
+ssize_t btrfs_xattr_get_locked(struct inode *inode, int name_index,
+			       const char *attr_name, void *buffer,
+			       size_t size)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -153,7 +159,6 @@ ssize_t btrfs_xattr_get(struct inode *in
 		return -ENOMEM;
 	}
 
-	mutex_lock(&root->fs_info->fs_mutex);
 	/* lookup the xattr by name */
 	di = btrfs_lookup_xattr(NULL, root, path, inode->i_ino, name,
 				strlen(name), 0);
@@ -179,17 +184,34 @@ ssize_t btrfs_xattr_get(struct inode *in
 	read_extent_buffer(leaf, buffer, data_ptr,
 			   btrfs_dir_data_len(leaf, di));
 	ret = btrfs_dir_data_len(leaf, di);
-
 out:
-	mutex_unlock(&root->fs_info->fs_mutex);
 	kfree(name);
 	btrfs_free_path(path);
 	return ret;
 }
 
-int btrfs_xattr_set(struct inode *inode, int name_index,
-		    const char *attr_name, const void *value, size_t size,
-		    int flags)
+ssize_t btrfs_xattr_get(struct inode *inode, int name_index,
+			const char *attr_name, void *buffer, size_t size)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	ssize_t ret = 0;
+
+	mutex_lock(&root->fs_info->fs_mutex);
+
+	ret = btrfs_xattr_get_locked(inode, name_index, attr_name, buffer,
+				     size);
+
+	mutex_unlock(&root->fs_info->fs_mutex);
+
+	return ret;
+}
+
+/*
+ * Use this if we are already under fs_mutex
+ */
+int btrfs_xattr_set_locked(struct inode *inode, int name_index,
+			   const char *attr_name, const void *value,
+			   size_t size, int flags)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -210,11 +232,8 @@ int btrfs_xattr_set(struct inode *inode,
 		return -ENOMEM;
 	}
 
-	mutex_lock(&root->fs_info->fs_mutex);
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, inode);
-
-	/* first lets see if we already have this xattr */
 	di = btrfs_lookup_xattr(trans, root, path, inode->i_ino, name,
 				strlen(name), -1);
 	if (IS_ERR(di)) {
@@ -233,6 +252,7 @@ int btrfs_xattr_set(struct inode *inode,
 		ret = btrfs_delete_one_dir_name(trans, root, path, di);
 		if (ret)
 			goto out;
+
 		btrfs_release_path(root, path);
 
 		/* if we don't have a value then we are removing the xattr */
@@ -260,9 +280,24 @@ out:
 	}
 
 	btrfs_end_transaction(trans, root);
-	mutex_unlock(&root->fs_info->fs_mutex);
 	kfree(name);
 	btrfs_free_path(path);
+
+	return ret;
+}
+
+int btrfs_xattr_set(struct inode *inode, int name_index, const char *attr_name,
+		    const void *value, size_t size, int flags)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;
+
+	mutex_lock(&root->fs_info->fs_mutex);
+
+	ret = btrfs_xattr_set_locked(inode, name_index, attr_name, value,
+				     size, flags);
+
+	mutex_unlock(&root->fs_info->fs_mutex);
 
 	return ret;
 }
diff -r 79b81fd6dd78 xattr.h
--- a/xattr.h	Thu Jun 12 14:46:17 2008 -0400
+++ b/xattr.h	Wed Jun 18 17:34:41 2008 -0400
@@ -42,11 +42,15 @@ extern struct xattr_handler btrfs_xattr_
 
 extern struct xattr_handler *btrfs_xattr_handlers[];
 
+ssize_t btrfs_xattr_get_locked(struct inode *inode, int name_index,
+				const char *name, void *buffer, size_t size);
 ssize_t btrfs_xattr_get(struct inode *inode, int name_index, const char *name,
 			void *buffer, size_t size);
+int btrfs_xattr_set_locked(struct inode *inode, int name_index,
+				const char *name, const void *value,
+				size_t size, int flags);
 int btrfs_xattr_set(struct inode *inode, int name_index, const char *name,
 			const void *value, size_t size, int flags);
-
 /*
  * the only reason this is public is for acl.c.  There may be a point where
  * acl.c doesn't need it, and if thats the case we need to remove it and make
