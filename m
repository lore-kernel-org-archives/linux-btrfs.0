From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 10/10] btrfs: fix the wrong handle of btrfs_set_acl()
Date: Thu, 20 May 2010 15:25:49 +0800
Message-ID: <4BF4E3FD.5030402@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If the acl can be exactly represented in the traditional file mode permission
bits, we needn't insert any xattr item into fs/file root.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/acl.c   |   56 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/xattr.c |   22 +++++++++++++-------
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index da3133c..7f7c0e5 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -26,6 +26,7 @@
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "xattr.h"
+#include "transaction.h"
 
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 
@@ -97,6 +98,7 @@ static int btrfs_xattr_get_acl(struct inode *inode, int type,
 static int btrfs_set_acl(struct btrfs_trans_handle *trans,
 			 struct inode *inode, struct posix_acl *acl, int type)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret, size = 0;
 	const char *name;
 	char *value = NULL;
@@ -111,15 +113,20 @@ static int btrfs_set_acl(struct btrfs_trans_handle *trans,
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		mode = inode->i_mode;
 		name = POSIX_ACL_XATTR_ACCESS;
 		if (acl) {
+			mode = inode->i_mode;
 			ret = posix_acl_equiv_mode(acl, &mode);
 			if (ret < 0)
 				return ret;
-			inode->i_mode = mode;
+			else {
+				inode->i_mode = mode;
+				inode->i_ctime = CURRENT_TIME;
+				btrfs_update_inode(trans, root, inode);
+				if (ret == 0)
+					acl = NULL;
+			}
 		}
-		ret = 0;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
@@ -158,6 +165,8 @@ static int btrfs_xattr_set_acl(struct inode *inode, int type,
 {
 	int ret;
 	struct posix_acl *acl = NULL;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
 
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
@@ -169,8 +178,23 @@ static int btrfs_xattr_set_acl(struct inode *inode, int type,
 		}
 	}
 
-	ret = btrfs_set_acl(NULL, inode, acl, type);
+	ret = btrfs_reserve_metadata_space(root, 2);
+	if (ret)
+		goto reserve_space_err;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans) {
+		ret = -ENOMEM;
+		goto start_trans_err;
+	}
+	btrfs_set_trans_block_group(trans, inode);
+
+	ret = btrfs_set_acl(trans, inode, acl, type);
 
+	btrfs_end_transaction_throttle(trans, root);
+start_trans_err:
+	btrfs_unreserve_metadata_space(root, 2);
+reserve_space_err:
 	posix_acl_release(acl);
 
 	return ret;
@@ -279,6 +303,7 @@ failed:
 
 int btrfs_acl_chmod(struct inode *inode)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct posix_acl *acl, *clone;
 	int ret = 0;
 
@@ -298,9 +323,28 @@ int btrfs_acl_chmod(struct inode *inode)
 		return -ENOMEM;
 
 	ret = posix_acl_chmod_masq(clone, inode->i_mode);
-	if (!ret)
-		ret = btrfs_set_acl(NULL, inode, clone, ACL_TYPE_ACCESS);
+	if (!ret) {
+		struct btrfs_trans_handle *trans;
+
+		ret = btrfs_reserve_metadata_space(root, 2);
+		if (ret)
+			goto reserve_space_err;
+
+		trans = btrfs_start_transaction(root, 1);
+		if (!trans) {
+			ret = -ENOMEM;
+			goto start_trans_err;
+		}
+		btrfs_set_trans_block_group(trans, inode);
+
+		ret = btrfs_set_acl(trans, inode, clone, ACL_TYPE_ACCESS);
+
+		btrfs_end_transaction_throttle(trans, root);
+	start_trans_err:
+		btrfs_unreserve_metadata_space(root, 2);
+	}
 
+reserve_space_err:
 	posix_acl_release(clone);
 
 	return ret;
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 193b58f..0b3a891 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -124,7 +124,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 
 		/* if we don't have a value then we are removing the xattr */
 		if (!value)
-			goto out;
+			goto success_end;
 	} else {
 		btrfs_release_path(root, path);
 
@@ -133,12 +133,20 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 			ret = -ENODATA;
 			goto out;
 		}
+
+		if (!value)
+			goto out;
 	}
 
 	/* ok we have to create a completely new xattr */
 	ret = btrfs_insert_xattr_item(trans, root, path, inode->i_ino,
 				      name, name_len, value, size);
-	BUG_ON(ret);
+	btrfs_release_path(root, path);
+success_end:
+	if (!ret) {
+		inode->i_ctime = CURRENT_TIME;
+		btrfs_update_inode(trans, root, inode);
+	}
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -149,6 +157,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 		     const void *value, size_t size, int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int nr = 1;
 	int ret;
 
 	if (trans)
@@ -166,15 +175,12 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 	btrfs_set_trans_block_group(trans, inode);
 
 	ret = do_setxattr(trans, inode, name, value, size, flags);
-	if (ret)
-		goto out;
 
-	inode->i_ctime = CURRENT_TIME;
-	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
-out:
+	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
+out:
 	btrfs_unreserve_metadata_space(root, 2);
+	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
 
-- 
1.6.5.2


