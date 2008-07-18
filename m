From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 1/5] updated acl support patch
Date: Fri, 18 Jul 2008 12:39:41 -0400
Message-ID: <20080718163941.GE15844@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is an updated ACL patch that applies cleanly to the new stuff in the
unstable tree.  Thanks,

Josef


diff -r e7b93e86f40b acl.c
--- a/acl.c	Fri Jul 18 12:01:11 2008 -0400
+++ b/acl.c	Fri Jul 18 19:34:01 2008 -0400
@@ -20,76 +20,302 @@
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
+static void btrfs_update_cached_acl(struct inode *inode,
+				    struct posix_acl **p_acl,
+				    struct posix_acl *acl)
+{
+	spin_lock(&inode->i_lock);
+	if (*p_acl && *p_acl != BTRFS_ACL_NOT_CACHED)
+		posix_acl_release(*p_acl);
+	*p_acl = posix_acl_dup(acl);
+	spin_unlock(&inode->i_lock);
+}
+
+static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
+{
+	int size, name_index;
+	char *value = NULL;
+	struct posix_acl *acl = NULL, **p_acl;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS;
+		p_acl = &BTRFS_I(inode)->i_acl;
+		break;
+	case ACL_TYPE_DEFAULT:
+		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		p_acl = &BTRFS_I(inode)->i_default_acl;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	spin_lock(&inode->i_lock);
+	if (*p_acl != BTRFS_ACL_NOT_CACHED)
+		acl = posix_acl_dup(*p_acl);
+	spin_unlock(&inode->i_lock);
+
+	if (acl)
+		return acl;
+
+
+	size = btrfs_xattr_get(inode, name_index, "", NULL, 0);
+	if (size > 0) {
+		value = kzalloc(size, GFP_NOFS);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		size = btrfs_xattr_get(inode, name_index, "", value, size);
+		if (size > 0) {
+			acl = posix_acl_from_xattr(value, size);
+			btrfs_update_cached_acl(inode, p_acl, acl);
+		}
+		kfree(value);
+	} else if (size == -ENOENT) {
+		acl = NULL;
+		btrfs_update_cached_acl(inode, p_acl, acl);
+	}
+
+	return acl;
+}
+
+static int btrfs_xattr_get_acl(struct inode *inode, int type,
+			       void *value, size_t size)
+{
+	struct posix_acl *acl;
+	int ret = 0;
+
+	acl = btrfs_get_acl(inode, type);
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
+	struct posix_acl **p_acl;
+	char *value = NULL;
+	mode_t mode;
+
+	if (acl) {
+		ret = posix_acl_valid(acl);
+		if (ret < 0)
+			return ret;
+		ret = 0;
+	}
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		mode = inode->i_mode;
+		ret = posix_acl_equiv_mode(acl, &mode);
+		if (ret < 0)
+			return ret;
+		ret = 0;
+		inode->i_mode = mode;
+		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_ACCESS;
+		p_acl = &BTRFS_I(inode)->i_acl;
+		break;
+	case ACL_TYPE_DEFAULT:
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EINVAL : 0;
+		name_index = BTRFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		p_acl = &BTRFS_I(inode)->i_default_acl;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (acl) {
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
+	ret = btrfs_xattr_set(inode, name_index, "", value, size, 0);
+
+out:
+	if (value)
+		kfree(value);
+
+	if (!ret)
+		btrfs_update_cached_acl(inode, p_acl, acl);
+
+	return ret;
+}
 
 static int btrfs_xattr_set_acl(struct inode *inode, int type,
 			       const void *value, size_t size)
 {
 	int ret = 0;
-	struct posix_acl *acl;
+	struct posix_acl *acl = NULL;
 
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
+	ret = btrfs_set_acl(inode, acl, type);
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
+	int error = -EAGAIN;
+
+	acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
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
+	int ret = 0;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (!IS_POSIXACL(inode))
+		return 0;
+
+	acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	posix_acl_release(acl);
+	if (!clone)
+		return -ENOMEM;
+
+	ret = posix_acl_chmod_masq(clone, inode->i_mode);
+	if (!ret)
+		ret = btrfs_set_acl(inode, clone, ACL_TYPE_ACCESS);
+
+	posix_acl_release(clone);
+
+	return ret;
+}
+
 struct xattr_handler btrfs_xattr_acl_default_handler = {
 	.prefix = POSIX_ACL_XATTR_DEFAULT,
 	.list	= btrfs_xattr_generic_list,
diff -r e7b93e86f40b btrfs_inode.h
--- a/btrfs_inode.h	Fri Jul 18 12:01:11 2008 -0400
+++ b/btrfs_inode.h	Fri Jul 18 19:34:01 2008 -0400
@@ -36,6 +36,9 @@ struct btrfs_inode {
 	struct inode vfs_inode;
 	struct btrfs_ordered_inode_tree ordered_tree;
 
+	struct posix_acl *i_acl;
+	struct posix_acl *i_default_acl;
+
 	/*
 	 * transid of the trans_handle that last modified this inode
 	 */
diff -r e7b93e86f40b ctree.h
--- a/ctree.h	Fri Jul 18 12:01:11 2008 -0400
+++ b/ctree.h	Fri Jul 18 19:34:01 2008 -0400
@@ -41,6 +41,8 @@ struct btrfs_ordered_sum;
 struct btrfs_ordered_sum;
 
 #define BTRFS_MAGIC "_B5RfS_M"
+
+#define BTRFS_ACL_NOT_CACHED    ((void *)-1)
 
 #define BTRFS_MAX_LEVEL 8
 
@@ -1671,4 +1673,9 @@ u64 btrfs_parse_size(char *str);
 u64 btrfs_parse_size(char *str);
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+
+/* acl.c */
+int btrfs_check_acl(struct inode *inode, int mask);
+int btrfs_init_acl(struct inode *inode, struct inode *dir);
+int btrfs_acl_chmod(struct inode *inode);
 #endif
diff -r e7b93e86f40b inode.c
--- a/inode.c	Fri Jul 18 12:01:11 2008 -0400
+++ b/inode.c	Fri Jul 18 19:34:01 2008 -0400
@@ -36,6 +36,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/version.h>
 #include <linux/xattr.h>
+#include <linux/posix_acl.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -1440,6 +1441,9 @@ static int btrfs_setattr(struct dentry *
 	}
 out:
 	err = inode_setattr(inode, attr);
+
+	if (!err && ((attr->ia_valid & ATTR_MODE)))
+		err = btrfs_acl_chmod(inode);
 fail:
 	return err;
 }
@@ -2058,6 +2062,12 @@ static int btrfs_mknod(struct inode *dir
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
@@ -2112,6 +2122,12 @@ static int btrfs_create(struct inode *di
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
@@ -2235,6 +2251,11 @@ static int btrfs_mkdir(struct inode *dir
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
@@ -2893,6 +2914,8 @@ struct inode *btrfs_alloc_inode(struct s
 		return NULL;
 	ei->last_trans = 0;
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
+	ei->i_acl = BTRFS_ACL_NOT_CACHED;
+	ei->i_default_acl = BTRFS_ACL_NOT_CACHED;
 	return &ei->vfs_inode;
 }
 
@@ -2901,6 +2924,13 @@ void btrfs_destroy_inode(struct inode *i
 	struct btrfs_ordered_extent *ordered;
 	WARN_ON(!list_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
+
+	if (BTRFS_I(inode)->i_acl &&
+	    BTRFS_I(inode)->i_acl != BTRFS_ACL_NOT_CACHED)
+		posix_acl_release(BTRFS_I(inode)->i_acl);
+	if (BTRFS_I(inode)->i_default_acl &&
+	    BTRFS_I(inode)->i_default_acl != BTRFS_ACL_NOT_CACHED)
+		posix_acl_release(BTRFS_I(inode)->i_default_acl);
 
 	while(1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
@@ -3096,6 +3126,12 @@ static int btrfs_symlink(struct inode *d
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
@@ -3176,7 +3212,7 @@ static int btrfs_permission(struct inode
 {
 	if (btrfs_test_flag(inode, READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
-	return generic_permission(inode, mask, NULL);
+	return generic_permission(inode, mask, btrfs_check_acl);
 }
 
 static struct inode_operations btrfs_dir_inode_operations = {
@@ -3258,6 +3294,10 @@ static struct inode_operations btrfs_spe
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
diff -r e7b93e86f40b super.c
--- a/super.c	Fri Jul 18 12:01:11 2008 -0400
+++ b/super.c	Fri Jul 18 19:34:01 2008 -0400
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
 
diff -r e7b93e86f40b xattr.c
--- a/xattr.c	Fri Jul 18 12:01:11 2008 -0400
+++ b/xattr.c	Fri Jul 18 19:34:01 2008 -0400
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
 
@@ -237,10 +239,14 @@ int btrfs_xattr_set(struct inode *inode,
 			mod = 1;
 			goto out;
 		}
-	} else if (flags & XATTR_REPLACE) {
-		/* we couldn't find the attr to replace, so error out */
-		ret = -ENODATA;
-		goto out;
+	} else {
+		btrfs_release_path(root, path);
+
+		if (flags & XATTR_REPLACE) {
+			/* we couldn't find the attr to replace */
+			ret = -ENODATA;
+			goto out;
+		}
 	}
 
 	/* ok we have to create a completely new xattr */
