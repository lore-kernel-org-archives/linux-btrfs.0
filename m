From: Balaji Rao <balajirrao@gmail.com>
Subject: [PATCH] NFS support for btrfs - v2
Date: Mon, 21 Jul 2008 02:01:56 +0530
Message-ID: <200807210201.56690.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: Chris Mason <chris.mason@oracle.com>,
	David Woodhouse <dwmw2@infradead.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Here's an implementation of NFS support for btrfs. It does not work in one
particular case as described in 
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg00298.html.

This uses the btrfs_iget helper introduced previously.

Comments ?
---

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff -r 3f0eee804974 Makefile
--- a/Makefile	Thu Jun 26 10:34:20 2008 -0400
+++ b/Makefile	Mon Jul 21 01:14:45 2008 +0530
@@ -6,7 +6,8 @@
 	   hash.o file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o
+	   extent_io.o volumes.o async-thread.o ioctl.o locking.o \
+	   export.o
 
 btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
diff -r 3f0eee804974 export.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/export.c	Mon Jul 21 01:14:45 2008 +0530
@@ -0,0 +1,183 @@
+#include <linux/fs.h>
+#include <linux/types.h>
+#include "ctree.h"
+#include "disk-io.h"
+#include "btrfs_inode.h"
+#include "print-tree.h"
+#include "export.h"
+
+/* The size of encoded fh is the type number of the fh itself */
+#define BTRFS_FID_NON_CONNECTABLE		5
+#define BTRFS_FID_CONNECTABLE	 		8
+
+static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
+			int connectable)
+{
+	struct btrfs_fid *fid = (struct btrfs_fid *)fh;
+	struct inode *inode = dentry->d_inode;
+	int len = *max_len;
+
+	if ((len < BTRFS_FID_NON_CONNECTABLE ) ||
+			(connectable && len < BTRFS_FID_CONNECTABLE)) {
+		return 255;
+	}
+	
+	len  = BTRFS_FID_NON_CONNECTABLE;
+
+	fid->objectid = BTRFS_I(inode)->location.objectid;
+	fid->root_objectid = BTRFS_I(inode)->root->objectid;
+	fid->gen = inode->i_generation;
+
+	if (connectable && !S_ISDIR(inode->i_mode)) {
+		struct inode *parent;
+
+		spin_lock(&dentry->d_lock);
+
+		parent = dentry->d_parent->d_inode;
+		fid->parent_objectid = BTRFS_I(parent)->location.objectid;
+		fid->parent_gen = parent->i_generation;
+
+		spin_unlock(&dentry->d_lock);
+		len = BTRFS_FID_CONNECTABLE;
+	}
+	*max_len = len;
+
+	/* We return length itself for the type */
+	return len;
+
+}
+
+static struct dentry * btrfs_get_dentry(struct super_block *sb,
+			u64 objectid, u64 root_objectid, u32 generation)
+{
+	struct btrfs_root *root;
+	struct inode *inode;
+	struct dentry *result;
+	struct btrfs_key key;
+
+	key.objectid = objectid;
+	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
+	key.offset = 0;
+
+	root = btrfs_lookup_fs_root(btrfs_sb(sb)->fs_info, root_objectid);
+	inode = btrfs_iget(sb, &key, root, NULL);
+	if (IS_ERR(inode))
+		return (void *)inode;
+
+	if(generation != inode->i_generation) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	result = d_alloc_anon(inode);
+	if(!result) {
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return result;
+}
+
+static struct dentry *btrfs_fh_to_parent(struct super_block *sb,
+		struct fid *fh, int fh_len, int fh_type)
+{
+	struct btrfs_fid *fid = (struct btrfs_fid *) fh;
+	u64 objectid, root_objectid;
+	u32 generation;
+
+	if (fh_type != BTRFS_FID_CONNECTABLE) {
+		return NULL;
+	}
+
+	
+	root_objectid = fid->root_objectid;
+	objectid = fid->parent_objectid;
+	generation = fid->parent_gen;
+
+	return btrfs_get_dentry(sb, objectid, root_objectid, generation);
+}
+
+static struct dentry *btrfs_fh_to_dentry(struct super_block *sb,
+		struct fid *fh, int fh_len, int fh_type)
+{
+	struct btrfs_fid *fid = (struct btrfs_fid *) fh;
+	u64 objectid, root_objectid;
+	u32 generation;
+
+	if (fh_type > BTRFS_FID_CONNECTABLE) {
+		return NULL;
+	}
+
+	objectid = fid->objectid;
+	root_objectid = fid->root_objectid;
+	generation = fid->gen;
+
+	return btrfs_get_dentry(sb, objectid, root_objectid, generation);
+}
+
+static struct dentry *btrfs_get_parent(struct dentry *child)
+{
+	struct inode *dir = child->d_inode;
+	struct inode *inode;
+	struct dentry *parent;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;	
+	u32 nritems;
+	int slot;
+	u64 objectid;
+	int ret;
+
+	path = btrfs_alloc_path();
+
+	key.objectid = dir->i_ino;
+	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	BUG_ON(ret == 0);
+	ret = 0;
+
+	leaf = path->nodes[0];
+	slot = path->slots[0];
+	nritems = btrfs_header_nritems(leaf);
+	if (slot >= nritems) {
+		goto out;
+	}
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (key.objectid != dir->i_ino ||
+	    key.type != BTRFS_INODE_REF_KEY) {
+		goto out;
+	}
+
+	btrfs_free_path(path);
+	objectid = key.offset;
+
+	/* Build a new key for the inode item */
+	key.objectid = objectid;
+	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
+	key.offset = 0;
+
+	inode = btrfs_iget(root->fs_info->sb, &key, root, NULL);
+	
+	parent = d_alloc_anon(inode);
+	if (!parent) {
+		iput(inode);
+		parent = ERR_PTR(-ENOMEM);
+	}
+	
+	return parent;
+
+out:
+	btrfs_free_path(path);
+	return ERR_PTR(-EINVAL);
+
+}
+
+const struct export_operations btrfs_export_ops = {
+	.encode_fh	= btrfs_encode_fh,
+	.fh_to_dentry	= btrfs_fh_to_dentry,
+	.fh_to_parent	= btrfs_fh_to_parent,
+	.get_parent	= btrfs_get_parent,
+};
diff -r 3f0eee804974 export.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/export.h	Mon Jul 21 01:14:45 2008 +0530
@@ -0,0 +1,17 @@
+#ifndef BTRFS_EXPORT_H
+#define BTRFS_EXPORT_H
+
+#include <linux/exportfs.h>
+
+extern const struct export_operations btrfs_export_ops;
+
+struct btrfs_fid {
+	u64 objectid;
+	u64 root_objectid;
+	u32 gen;
+
+	u64 parent_objectid;
+	u32 parent_gen;
+} __attribute__ ((packed));
+
+#endif
diff -r 3f0eee804974 super.c
--- a/super.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/super.c	Mon Jul 21 01:14:45 2008 +0530
@@ -45,6 +45,7 @@
 #include "print-tree.h"
 #include "xattr.h"
 #include "volumes.h"
+#include "export.h"
 
 #define BTRFS_SUPER_MAGIC 0x9123683E
 
@@ -298,6 +299,7 @@
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_magic = BTRFS_SUPER_MAGIC;
 	sb->s_op = &btrfs_super_ops;
+	sb->s_export_op = &btrfs_export_ops;
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
 
