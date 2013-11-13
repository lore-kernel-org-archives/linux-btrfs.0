Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:59884 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KMBVu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 20:21:50 -0500
Received: by mail-we0-f171.google.com with SMTP id t61so3436293wes.2
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 17:21:49 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH V2] Btrfs: add support for inode properties
Date: Wed, 13 Nov 2013 01:21:38 +0000
Message-Id: <1384305698-22710-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
References: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This change adds infrastructure to allow for generic properties for
inodes. Properties are name/value pairs that can be associated with
inodes for different purposes. They're stored as xattrs with the
prefix "btrfs."

Properties can be inherited - this means when a directory inode has
inheritable properties set, these are added to new inodes created
under that directory.

This change also adds one specific property implementation, named
"compression", whose values can be "lzo" or "zlib" and it's an
inheritable property.

The corresponding changes to btrfs-progs were also implemented.
A patch with xfstests for this feature will follow once there's
agreement on this change/feature.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Simplified the interface to user space. Got rid of the ioctls and
    using now the regular path for setting and getting xattrs. Like
    this properties can be set via regular getxattr and setxattr
    system calls.

 fs/btrfs/Makefile          |    2 +-
 fs/btrfs/btrfs_inode.h     |    1 +
 fs/btrfs/inode.c           |   27 +++-
 fs/btrfs/props.c           |  350 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/props.h           |   36 +++++
 fs/btrfs/xattr.c           |   12 +-
 include/uapi/linux/xattr.h |    3 +
 7 files changed, 425 insertions(+), 6 deletions(-)
 create mode 100644 fs/btrfs/props.c
 create mode 100644 fs/btrfs/props.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 1a44e42..af7f000 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o
+	   uuid-tree.o props.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ac0b39d..7dc2f78 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -43,6 +43,7 @@
 #define BTRFS_INODE_COPY_EVERYTHING		8
 #define BTRFS_INODE_IN_DELALLOC_LIST		9
 #define BTRFS_INODE_READDIO_NEED_LOCK		10
+#define BTRFS_INODE_HAS_PROPS		        11
 
 /* in memory btrfs inode */
 struct btrfs_inode {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f167ced..7a40aa6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -58,6 +58,7 @@
 #include "inode-map.h"
 #include "backref.h"
 #include "hash.h"
+#include "props.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -3247,7 +3248,8 @@ out:
  * slot is the slot the inode is in, objectid is the objectid of the inode
  */
 static noinline int acls_after_inode_item(struct extent_buffer *leaf,
-					  int slot, u64 objectid)
+					  int slot, u64 objectid,
+					  int *has_xattrs)
 {
 	u32 nritems = btrfs_header_nritems(leaf);
 	struct btrfs_key found_key;
@@ -3272,6 +3274,7 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 
 		/* we found an xattr, assume we've got an acl */
 		if (found_key.type == BTRFS_XATTR_ITEM_KEY) {
+			*has_xattrs = 1;
 			if (found_key.offset == xattr_access ||
 			    found_key.offset == xattr_default)
 				return 1;
@@ -3300,13 +3303,15 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 	 * something larger than an xattr.  We have to assume the inode
 	 * has acls
 	 */
+	*has_xattrs = 1;
+
 	return 1;
 }
 
 /*
  * read an inode from the btree into the in-memory inode
  */
-static void btrfs_read_locked_inode(struct inode *inode)
+static void btrfs_read_locked_inode(struct inode *inode, int *has_xattrs)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -3386,7 +3391,7 @@ cache_acl:
 	 * any xattrs or acls
 	 */
 	maybe_acls = acls_after_inode_item(leaf, path->slots[0],
-					   btrfs_ino(inode));
+					   btrfs_ino(inode), has_xattrs);
 	if (!maybe_acls)
 		cache_no_acl(inode);
 
@@ -4871,6 +4876,8 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *new)
 {
 	struct inode *inode;
+	int has_xattrs = 0;
+	int ret;
 
 	inode = btrfs_iget_locked(s, location->objectid, root);
 	if (!inode)
@@ -4879,10 +4886,17 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 	if (inode->i_state & I_NEW) {
 		BTRFS_I(inode)->root = root;
 		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
-		btrfs_read_locked_inode(inode);
+		btrfs_read_locked_inode(inode, &has_xattrs);
 		if (!is_bad_inode(inode)) {
 			inode_tree_add(inode);
 			unlock_new_inode(inode);
+			if (has_xattrs) {
+				ret = btrfs_load_inode_props(inode);
+				if (ret)
+					pr_err("btrfs: error loading props for ino %llu (root %llu): %d\n",
+					       btrfs_ino(inode),
+					       root->root_key.objectid, ret);
+			}
 			if (new)
 				*new = 1;
 		} else {
@@ -5486,6 +5500,11 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_update_root_times(trans, root);
 
+	ret = btrfs_inherit_props(trans, inode, dir);
+	if (ret)
+		pr_err("btrfs: error inheriting props for ino %llu (root %llu): %d",
+		       btrfs_ino(inode), root->root_key.objectid, ret);
+
 	return inode;
 fail:
 	if (dir)
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
new file mode 100644
index 0000000..26e19bc
--- /dev/null
+++ b/fs/btrfs/props.c
@@ -0,0 +1,350 @@
+/*
+ * Copyright (C) 2013 Filipe David Borba Manana <fdmanana@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "props.h"
+#include "btrfs_inode.h"
+#include "transaction.h"
+#include "xattr.h"
+
+struct prop_handler {
+	const char *xattr_name;
+	int (*validate)(const char *value, size_t len);
+	int (*apply)(struct inode *inode, const char *value, size_t len);
+	int inheritable;
+};
+
+static int prop_compression_validate(const char *value, size_t len);
+
+static int prop_compression_apply(struct inode *inode,
+				  const char *value,
+				  size_t len);
+
+static const struct prop_handler prop_handlers[] = {
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "compression",
+		.validate = prop_compression_validate,
+		.apply = prop_compression_apply,
+		.inheritable = 1
+	},
+	{
+		.xattr_name = NULL,
+		.validate = NULL,
+		.apply = NULL
+	}
+};
+
+
+static const struct prop_handler *find_prop_handler(const char *name)
+{
+	const struct prop_handler *p;
+
+	for (p = &prop_handlers[0]; p->xattr_name; p++)
+		if (!strcmp(p->xattr_name, name))
+			return p;
+	return NULL;
+}
+
+static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
+			    struct inode *inode,
+			    const char *name,
+			    const char *value,
+			    size_t value_len,
+			    int flags)
+{
+	const struct prop_handler *handler;
+	int ret;
+
+	handler = find_prop_handler(name);
+	if (!handler)
+		return -EINVAL;
+
+	if (value_len == 0) {
+		ret = __btrfs_setxattr(trans, inode, handler->xattr_name,
+				       NULL, 0, flags);
+		if (ret)
+			return ret;
+
+		ret = handler->apply(inode, NULL, 0);
+		ASSERT(ret == 0);
+
+		return ret;
+	}
+
+	ret = handler->validate(value, value_len);
+	if (ret)
+		return ret;
+
+	ret = __btrfs_setxattr(trans, inode, handler->xattr_name,
+			       value, value_len, flags);
+	if (ret)
+		return ret;
+
+	ret = handler->apply(inode, value, value_len);
+	if (!ret)
+		set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
+
+	return ret;
+}
+
+int btrfs_set_prop(struct inode *inode,
+		   const char *name,
+		   const char *value,
+		   size_t value_len,
+		   int flags)
+{
+	return __btrfs_set_prop(NULL, inode, name, value, value_len, flags);
+}
+
+int btrfs_load_inode_props(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	u64 ino = btrfs_ino(inode);
+	char *name_buf = NULL;
+	char *value_buf = NULL;
+	int name_buf_len = 0;
+	int value_buf_len = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = ino;
+	key.type = BTRFS_XATTR_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		struct btrfs_dir_item *di;
+		struct extent_buffer *leaf;
+		u32 total_len, cur, this_len;
+		int slot;
+
+		slot = path->slots[0];
+		leaf = path->nodes[0];
+
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
+				break;
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid != ino || key.type != BTRFS_XATTR_ITEM_KEY)
+			break;
+
+		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
+		cur = 0;
+		total_len = btrfs_item_size_nr(leaf, slot);
+
+		while (cur < total_len) {
+			u32 name_len = btrfs_dir_name_len(leaf, di);
+			u32 data_len = btrfs_dir_data_len(leaf, di);
+			unsigned long name_ptr, data_ptr;
+			const struct prop_handler *handler;
+
+			this_len = sizeof(*di) + name_len + data_len;
+			name_ptr = (unsigned long)(di + 1);
+			data_ptr = name_ptr + name_len;
+
+			if (name_len <= 6 ||
+			    memcmp_extent_buffer(leaf, "btrfs.", name_ptr, 6))
+				goto next;
+
+			if (name_len >= name_buf_len) {
+				kfree(name_buf);
+				name_buf_len = name_len + 1;
+				name_buf = kmalloc(name_buf_len, GFP_NOFS);
+				if (!name_buf) {
+					ret = -ENOMEM;
+					goto out;
+				}
+			}
+			read_extent_buffer(leaf, name_buf, name_ptr, name_len);
+			name_buf[name_len] = '\0';
+
+			if (data_len > value_buf_len) {
+				kfree(value_buf);
+				value_buf_len = data_len;
+				value_buf = kmalloc(data_len, GFP_NOFS);
+				if (!value_buf) {
+					ret = -ENOMEM;
+					goto out;
+				}
+			}
+			read_extent_buffer(leaf, value_buf, data_ptr, data_len);
+
+			handler = find_prop_handler(name_buf);
+			if (!handler) {
+				pr_warn("btrfs: handler for prop %s, ino %llu (root %llu), not found",
+					name_buf, ino, root->root_key.objectid);
+				goto next;
+			}
+
+			ret = handler->apply(inode, value_buf, data_len);
+			if (ret)
+				pr_warn("btrfs: error applying prop %s to ino %llu (root %llu): %d",
+					name_buf, ino,
+					root->root_key.objectid, ret);
+			else
+				set_bit(BTRFS_INODE_HAS_PROPS,
+					&BTRFS_I(inode)->runtime_flags);
+next:
+			cur += this_len;
+			di = (struct btrfs_dir_item *)((char *) di + this_len);
+		}
+
+		path->slots[0]++;
+	}
+
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	kfree(name_buf);
+	kfree(value_buf);
+
+	return ret;
+}
+
+int btrfs_inherit_props(struct btrfs_trans_handle *trans,
+			struct inode *inode,
+			struct inode *dir)
+{
+	const struct prop_handler *h;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	char *buf = NULL;
+	int buf_len = 0;
+	struct btrfs_block_rsv *rsv = NULL;
+	struct btrfs_block_rsv *trans_rsv = trans->block_rsv;
+	int ret;
+
+	if (!dir)
+		return 0;
+
+	if (!test_bit(BTRFS_INODE_HAS_PROPS,
+		      &BTRFS_I(dir)->runtime_flags))
+		return 0;
+
+	for (h = &prop_handlers[0]; h->xattr_name; h++) {
+		size_t len = 0;
+		u64 num_bytes;
+
+		if (!h->inheritable)
+			continue;
+again:
+		ret = __btrfs_getxattr(dir, h->xattr_name, NULL, 0);
+		if (ret == -ENODATA)
+			continue;
+		else if (ret < 0)
+			goto out;
+		else
+			len = ret;
+
+		if (len > buf_len) {
+			kfree(buf);
+			buf = kmalloc(len, GFP_NOFS);
+			if (!buf) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			buf_len = len;
+		}
+
+		ret = __btrfs_getxattr(dir, h->xattr_name, buf, len);
+		if (ret == -ERANGE)
+			goto again;
+		else if (ret == -ENODATA)
+			continue;
+		else if (ret < 0)
+			goto out;
+
+		if (!rsv) {
+			rsv = btrfs_alloc_block_rsv(root, BTRFS_BLOCK_RSV_TEMP);
+			if (!rsv) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			trans->block_rsv = rsv;
+		}
+
+		num_bytes = btrfs_calc_trans_metadata_size(root, 2);
+		ret = btrfs_block_rsv_add(root, trans->block_rsv,
+					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
+		if (ret)
+			goto out;
+		ret = __btrfs_set_prop(trans, inode, h->xattr_name,
+				       buf, len, 0);
+		if (ret)
+			goto out;
+	}
+	ret = 0;
+out:
+	kfree(buf);
+	if (rsv) {
+		btrfs_free_block_rsv(root, rsv);
+		trans->block_rsv = trans_rsv;
+	}
+
+	return ret;
+}
+
+static int prop_compression_validate(const char *value, size_t len)
+{
+	if (!strncmp("lzo", value, len))
+		return 0;
+	else if (!strncmp("zlib", value, len))
+		return 0;
+
+	return -EINVAL;
+}
+
+static int prop_compression_apply(struct inode *inode,
+				  const char *value,
+				  size_t len)
+{
+	int type;
+
+	if (len == 0) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
+		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
+
+		return 0;
+	}
+
+	if (!strncmp("lzo", value, len))
+		type = BTRFS_COMPRESS_LZO;
+	else if (!strncmp("zlib", value, len))
+		type = BTRFS_COMPRESS_ZLIB;
+	else
+		return -EINVAL;
+
+	BTRFS_I(inode)->flags &= ~BTRFS_INODE_NOCOMPRESS;
+	BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
+	BTRFS_I(inode)->force_compress = type;
+
+	return 0;
+}
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
new file mode 100644
index 0000000..a352189
--- /dev/null
+++ b/fs/btrfs/props.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2013 Filipe David Borba Manana <fdmanana@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __BTRFS_PROPS_H
+#define __BTRFS_PROPS_H
+
+#include "ctree.h"
+
+int btrfs_set_prop(struct inode *inode,
+		   const char *name,
+		   const char *value,
+		   size_t value_len,
+		   int flags);
+
+int btrfs_load_inode_props(struct inode *inode);
+
+int btrfs_inherit_props(struct btrfs_trans_handle *trans,
+			struct inode *inode,
+			struct inode *dir);
+
+#endif
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 05740b9..4b33765 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -27,6 +27,7 @@
 #include "transaction.h"
 #include "xattr.h"
 #include "disk-io.h"
+#include "props.h"
 
 
 ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
@@ -331,7 +332,8 @@ static bool btrfs_is_valid_xattr(const char *name)
 			XATTR_SECURITY_PREFIX_LEN) ||
 	       !strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) ||
 	       !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
+	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) ||
+		!strncmp(name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
 }
 
 ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
@@ -373,6 +375,10 @@ int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	if (!btrfs_is_valid_xattr(name))
 		return -EOPNOTSUPP;
 
+	if (!strncmp(name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN))
+		return btrfs_set_prop(dentry->d_inode, name,
+				      value, size, flags);
+
 	if (size == 0)
 		value = "";  /* empty EA, do not remove */
 
@@ -402,6 +408,10 @@ int btrfs_removexattr(struct dentry *dentry, const char *name)
 	if (!btrfs_is_valid_xattr(name))
 		return -EOPNOTSUPP;
 
+	if (!strncmp(name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN))
+		return btrfs_set_prop(dentry->d_inode, name,
+				      NULL, 0, XATTR_REPLACE);
+
 	return __btrfs_setxattr(NULL, dentry->d_inode, name, NULL, 0,
 				XATTR_REPLACE);
 }
diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index e4629b9..40bbc04 100644
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -20,6 +20,9 @@
 #define XATTR_MAC_OSX_PREFIX "osx."
 #define XATTR_MAC_OSX_PREFIX_LEN (sizeof(XATTR_MAC_OSX_PREFIX) - 1)
 
+#define XATTR_BTRFS_PREFIX "btrfs."
+#define XATTR_BTRFS_PREFIX_LEN (sizeof(XATTR_BTRFS_PREFIX) - 1)
+
 #define XATTR_SECURITY_PREFIX	"security."
 #define XATTR_SECURITY_PREFIX_LEN (sizeof(XATTR_SECURITY_PREFIX) - 1)
 
-- 
1.7.9.5

