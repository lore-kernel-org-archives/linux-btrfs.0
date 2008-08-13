From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/3] NFS support for btrfs - v3
Date: Wed, 13 Aug 2008 16:06:30 +0100
Message-ID: <1218639990.2977.300.camel@pmac.infradead.org>
References: <200806290505.31641.balajirrao@gmail.com>
	 <1218548806.2977.179.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218548806.2977.179.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Balaji Rao <balajirrao@gmail.com>

Here's an implementation of NFS support for btrfs. It relies on the
fixes which are going in to 2.6.28 for the NFS readdir/lookup deadlock.

This uses the btrfs_iget helper introduced previously.

[dwmw2: Tidy up a little, switch to d_obtain_alias() w/compat routine,
	change fh_type,	store parent's root object ID where needed]

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---

This replaces patch 2 of the sequence I sent out yesterday; the other
two patches remain the same.

 Makefile |    2 +-
 compat.h |   17 +++++
 export.c |  200 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 export.h |   19 ++++++
 super.c  |    2 +
 5 files changed, 239 insertions(+), 1 deletions(-)
 create mode 100644 export.c
 create mode 100644 export.h

diff --git a/Makefile b/Makefile
index a4b3817..75f8818 100644
--- a/Makefile
+++ b/Makefile
@@ -7,7 +7,7 @@ btrfs-y := super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   ref-cache.o
+	   ref-cache.o export.o
 
 btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
diff --git a/compat.h b/compat.h
index b3349a6..d45fb37 100644
--- a/compat.h
+++ b/compat.h
@@ -5,6 +5,23 @@
 #define trylock_page(page) (!TestSetPageLocked(page))
 #endif
 
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,27)
+static inline struct dentry *d_obtain_alias(struct inode *inode)
+{
+	struct dentry *d;
+
+	if (!inode)
+		return NULL;
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	d = d_alloc_anon(inode);
+	if (!d)
+		iput(inode);
+	return d;
+}
+#endif
+
 /*
  * Even if AppArmor isn't enabled, it still has different prototypes.
  * Add more distro/version pairs here to declare which has AppArmor applied.
diff --git a/export.c b/export.c
new file mode 100644
index 0000000..1b8875c
--- /dev/null
+++ b/export.c
@@ -0,0 +1,200 @@
+#include <linux/fs.h>
+#include <linux/types.h>
+#include "ctree.h"
+#include "disk-io.h"
+#include "btrfs_inode.h"
+#include "print-tree.h"
+#include "export.h"
+#include "compat.h"
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
+#define FILEID_BTRFS_WITHOUT_PARENT		0x4d
+#define FILEID_BTRFS_WITH_PARENT 		0x4e
+#define FILEID_BTRFS_WITH_PARENT_ROOT 		0x4f
+#endif
+
+#define BTRFS_FID_SIZE_NON_CONNECTABLE		(offsetof(struct btrfs_fid, parent_objectid)/4)
+#define BTRFS_FID_SIZE_CONNECTABLE		(offsetof(struct btrfs_fid, parent_root_objectid)/4)
+#define BTRFS_FID_SIZE_CONNECTABLE_ROOT		(sizeof(struct btrfs_fid)/4)
+
+static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
+			   int connectable)
+{
+	struct btrfs_fid *fid = (struct btrfs_fid *)fh;
+	struct inode *inode = dentry->d_inode;
+	int len = *max_len;
+	int type;
+
+	if ((len < BTRFS_FID_SIZE_NON_CONNECTABLE) ||
+	    (connectable && len < BTRFS_FID_SIZE_CONNECTABLE))
+		return 255;
+
+	len  = BTRFS_FID_SIZE_NON_CONNECTABLE;
+	type = FILEID_BTRFS_WITHOUT_PARENT;
+
+	fid->objectid = BTRFS_I(inode)->location.objectid;
+	fid->root_objectid = BTRFS_I(inode)->root->objectid;
+	fid->gen = inode->i_generation;
+
+	if (connectable && !S_ISDIR(inode->i_mode)) {
+		struct inode *parent;
+		u64 parent_root_id;
+
+		spin_lock(&dentry->d_lock);
+
+		parent = dentry->d_parent->d_inode;
+		fid->parent_objectid = BTRFS_I(parent)->location.objectid;
+		fid->parent_gen = parent->i_generation;
+		parent_root_id = BTRFS_I(parent)->root->objectid;
+
+		spin_unlock(&dentry->d_lock);
+
+		if (parent_root_id != fid->root_objectid) {
+			fid->parent_root_objectid = parent_root_id;
+			len = BTRFS_FID_SIZE_CONNECTABLE_ROOT;
+			type = FILEID_BTRFS_WITH_PARENT_ROOT;
+		} else {
+			len = BTRFS_FID_SIZE_CONNECTABLE; 
+			type = FILEID_BTRFS_WITH_PARENT;
+		}
+	}
+
+	*max_len = len;
+	return type;
+}
+
+static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
+				       u64 root_objectid, u32 generation)
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
+	if (generation != inode->i_generation) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	result = d_obtain_alias(inode);
+	if (!result)
+		return ERR_PTR(-ENOMEM);
+
+	return result;
+}
+
+static struct dentry *btrfs_fh_to_parent(struct super_block *sb, struct fid *fh,
+					 int fh_len, int fh_type)
+{
+	struct btrfs_fid *fid = (struct btrfs_fid *) fh;
+	u64 objectid, root_objectid;
+	u32 generation;
+
+	if (fh_type == FILEID_BTRFS_WITH_PARENT) {
+		if (fh_len !=  BTRFS_FID_SIZE_CONNECTABLE)
+			return NULL;
+		root_objectid = fid->root_objectid;
+	} else if (fh_type == FILEID_BTRFS_WITH_PARENT_ROOT) {
+		if (fh_len != BTRFS_FID_SIZE_CONNECTABLE_ROOT)
+			return NULL;
+		root_objectid = fid->parent_root_objectid;
+	} else
+		return NULL;
+
+	objectid = fid->parent_objectid;
+	generation = fid->parent_gen;
+
+	return btrfs_get_dentry(sb, objectid, root_objectid, generation);
+}
+
+static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
+					 int fh_len, int fh_type)
+{
+	struct btrfs_fid *fid = (struct btrfs_fid *) fh;
+	u64 objectid, root_objectid;
+	u32 generation;
+
+	if ((fh_type != FILEID_BTRFS_WITH_PARENT ||
+	     fh_len != BTRFS_FID_SIZE_CONNECTABLE) &&
+	    (fh_type != FILEID_BTRFS_WITH_PARENT_ROOT ||
+	     fh_len != BTRFS_FID_SIZE_CONNECTABLE_ROOT) &&
+	    (fh_type != FILEID_BTRFS_WITHOUT_PARENT ||
+	     fh_len != BTRFS_FID_SIZE_NON_CONNECTABLE))
+		return NULL;
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
+	if (slot >= nritems)
+		goto out;
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (key.objectid != dir->i_ino || key.type != BTRFS_INODE_REF_KEY)
+		goto out;
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
+	parent = d_obtain_alias(inode);
+	if (!parent)
+		parent = ERR_PTR(-ENOMEM);
+
+	return parent;
+
+out:
+	btrfs_free_path(path);
+	return ERR_PTR(-EINVAL);
+}
+
+const struct export_operations btrfs_export_ops = {
+	.encode_fh	= btrfs_encode_fh,
+	.fh_to_dentry	= btrfs_fh_to_dentry,
+	.fh_to_parent	= btrfs_fh_to_parent,
+	.get_parent	= btrfs_get_parent,
+};
diff --git a/export.h b/export.h
new file mode 100644
index 0000000..074348a
--- /dev/null
+++ b/export.h
@@ -0,0 +1,19 @@
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
+
+	u64 parent_root_objectid;
+} __attribute__ ((packed));
+
+#endif
diff --git a/super.c b/super.c
index eb4b357..e830e0e 100644
--- a/super.c
+++ b/super.c
@@ -46,6 +46,7 @@
 #include "xattr.h"
 #include "volumes.h"
 #include "version.h"
+#include "export.h"
 
 #define BTRFS_SUPER_MAGIC 0x9123683E
 
@@ -303,6 +304,7 @@ static int btrfs_fill_super(struct super_block * sb,
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_magic = BTRFS_SUPER_MAGIC;
 	sb->s_op = &btrfs_super_ops;
+	sb->s_export_op = &btrfs_export_ops;
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_POSIXACL;
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



