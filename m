From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] Subvolume listing feature for ioctl.
Date: Wed, 18 Nov 2009 14:42:14 +0900
Message-ID: <4B038936.5020506@jp.fujitsu.com>
References: <4B00ADE8.4090205@jp.fujitsu.com> <3d0408630911160015t79044d72u3489a42d57c6f844@mail.gmail.com> <4B011435.2080005@jp.fujitsu.com> <4B038897.3000605@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: yanzheng@21cn.com, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B038897.3000605@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

New feature to list up subvolume/snapshots under
specified tree of file is introduced to ioctl.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c |  283 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   29 +++++
 2 files changed, 312 insertions(+)

Index: b/fs/btrfs/ioctl.c
===================================================================
--- a/fs/btrfs/ioctl.c	2009-11-12 23:47:05.000000000 +0900
+++ b/fs/btrfs/ioctl.c	2009-11-18 13:51:05.000000000 +0900
@@ -48,6 +48,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "locking.h"
+#include "ctree.h"

 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -738,6 +739,286 @@ out:
 	return ret;
 }

+/*
+  Search INODE_REFs to identify path name of 'dirid' directory
+  in a 'tree_id' tree. and sets path name to 'name'.
+*/
+static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
+				u64 tree_id, u64 dirid, char *name)
+{
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	char *name_stack, *ptr;
+	int ret = -1;
+	int slot;
+	int len;
+	int total_len = 0;
+	struct btrfs_inode_ref *iref;
+	struct extent_buffer *l;
+	struct btrfs_path *path;
+
+	if (dirid == BTRFS_FIRST_FREE_OBJECTID) {
+		name[0]='\0';
+		ret = 0;
+		goto out_direct;
+	}
+
+	path = btrfs_alloc_path();
+	name_stack = kzalloc(BTRFS_PATH_NAME_MAX+1, GFP_NOFS);
+	ptr = &name_stack[BTRFS_PATH_NAME_MAX];
+
+	key.objectid = tree_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	root = btrfs_read_fs_root_no_name(info, &key);
+
+	key.objectid = dirid;
+	key.type = BTRFS_INODE_REF_KEY;
+	key.offset = 0;
+
+	while(1) {
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret<0)
+			goto out;
+
+		l = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(l, &key, slot);
+
+		if (ret>0 && (key.objectid != dirid ||
+					key.type != BTRFS_INODE_REF_KEY))
+			goto out;
+
+		iref = btrfs_item_ptr(l, slot, struct btrfs_inode_ref);
+		len = btrfs_inode_ref_name_len(l, iref);
+		ptr -= len + 1;
+		total_len += len + 1;
+		if (ptr < name_stack)
+			goto out;
+
+		*(ptr + len) = '/';
+		read_extent_buffer(l, ptr,(unsigned long)(iref + 1), len);
+
+		if (key.offset == BTRFS_FIRST_FREE_OBJECTID)
+			break;
+
+		btrfs_release_path(root, path);
+		key.objectid = key.offset;
+		key.offset = 0;
+		dirid = key.objectid;
+
+	}
+	if (ptr < name_stack)
+		goto out;
+	strncpy(name, ptr, total_len);
+	name[total_len]='\0';
+	ret = 0;
+out:
+	btrfs_release_path(root, path);
+	kfree(path);
+	kfree(name_stack);
+
+out_direct:
+	return ret;
+}
+
+static inline char *btrfs_path_ptr(struct btrfs_ioctl_subvol_leaf *l,
+			int nr)
+{
+	return ((char *)l+l->items[nr].path_offset);
+}
+
+/*
+  Helper function to search tree root directory which contains
+  specified dentry.
+  This function is used in btrfs_ioctl_snap_listing function,
+  to notify root directory(different from the directory what
+  user specified) to user.
+*/
+static noinline struct dentry *btrfs_walkup_dentry_to_root(struct dentry *d)
+{
+	u64 ino;
+	struct dentry *dent = d;
+
+	ino = dent->d_inode->i_ino;
+	while (ino != BTRFS_FIRST_FREE_OBJECTID) {
+		dent = dent->d_parent;
+		ino = dent->d_inode->i_ino;
+	}
+	return dent;
+}
+
+/*
+  Create a list of Snapshot/Subvolume in specified tree.
+  Target tree is specified by struct file.
+*/
+static noinline int btrfs_ioctl_snap_listing(struct file *file,
+					     void __user *arg)
+{
+	struct btrfs_ioctl_subvol_leaf *leaf;
+	struct btrfs_ioctl_subvol_args *svol;
+	int rest, offset, idx, name_len, i;
+	struct btrfs_root *tree_root;
+	struct btrfs_root_ref *ref;
+	struct extent_buffer *l;
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	u64 dirid;
+	char *work_path, *f_path, *name;
+	int err, ret = 0, slot = 0;
+	LIST_HEAD(pending_subvols);
+	struct path vfs_path;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	work_path = kzalloc(BTRFS_PATH_NAME_MAX + 1, GFP_NOFS);
+	if (!work_path) {
+		kfree(path);
+		return -ENOMEM;
+	}
+
+	svol = memdup_user(arg, sizeof(struct btrfs_ioctl_subvol_args));
+	if (IS_ERR(svol)) {
+		kfree(path);
+		kfree(work_path);
+		return PTR_ERR(svol);
+	}
+	if (svol->len < BTRFS_SUBVOL_LEAF_SIZE_MIN) {
+		kfree(path);
+		kfree(work_path);
+		kfree(svol);
+		return -EINVAL;
+	}
+
+	leaf = memdup_user(svol->leaf, svol->len);
+	if (IS_ERR(leaf)) {
+		kfree(path);
+		kfree(work_path);
+		kfree(svol);
+		return PTR_ERR(leaf);
+	}
+	if (leaf->len != svol->len)
+		goto out_inval;
+
+	tree_root =
+		BTRFS_I(fdentry(file)->d_inode)->root->fs_info->tree_root;
+	if (!leaf->parent_tree) {
+		leaf->parent_tree =
+			BTRFS_I(fdentry(file)->d_inode)->root->root_key.objectid;
+		if (svol->base_path) {
+			work_path = kzalloc(BTRFS_PATH_NAME_MAX+1, GFP_NOFS);
+			if (!work_path) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			vfs_path.mnt = file->f_path.mnt;
+			vfs_path.dentry = btrfs_walkup_dentry_to_root(fdentry(file));
+			f_path = d_path(&vfs_path, work_path, BTRFS_PATH_NAME_MAX);
+			if (!IS_ERR(f_path)) {
+				strcpy(svol->base_path, f_path);
+				strcat(svol->base_path, "/");
+				if (copy_to_user(svol->base_path, f_path,
+						 strlen(f_path))) {
+					ret = -EFAULT;
+					kfree(work_path);
+					goto out;
+				}
+			}
+			kfree(work_path);
+		}
+	} else {
+		if (leaf->parent_tree != BTRFS_FS_TREE_OBJECTID &&
+			leaf->parent_tree < BTRFS_FIRST_FREE_OBJECTID) {
+			goto out_inval;
+		}
+	}
+
+	/* search root tree to find subvolumes */
+	key.objectid = leaf->parent_tree;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = leaf->last_tree+1;
+
+	offset = leaf->len;
+	rest = leaf->len -
+		offsetof(struct btrfs_ioctl_subvol_leaf, items);
+
+	idx = 0;
+	ret = 0;
+	while(rest >= 0) {
+		err = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+		if (err < 0) {
+			printk("search tree failed: code=%d\n", err);
+			ret = -EINVAL;
+			goto outr_error;
+		}
+
+		l = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(l, &key, path->slots[0]);
+
+		if (key.type != BTRFS_ROOT_REF_KEY ||
+			key.objectid != leaf->parent_tree) {
+			ret = 0;
+			btrfs_release_path(tree_root, path);
+			break;
+		}
+
+		ref = btrfs_item_ptr(l, slot, struct btrfs_root_ref);
+		name_len = btrfs_root_ref_name_len(l, ref);
+		name = kzalloc(name_len + 1, GFP_NOFS);
+		dirid = btrfs_root_ref_dirid(l, ref);
+		read_extent_buffer(l, name,
+				(unsigned long)(ref + 1), name_len);
+		btrfs_release_path(tree_root, path);
+		btrfs_search_path_in_tree(tree_root->fs_info,
+					leaf->parent_tree, dirid, work_path);
+		i = sizeof(struct btrfs_ioctl_subvol_items) +
+			name_len + strlen(work_path) + 1;
+		if (rest < sizeof(struct btrfs_ioctl_subvol_items) +
+			name_len + strlen(work_path) + 1) {
+			svol->next_len = name_len + strlen(work_path);
+			if (copy_to_user(arg, svol, sizeof(*svol))) {
+				ret = -EFAULT;
+				goto out;
+			}
+			ret = 1;
+			break;
+		}
+		leaf->nritems++;
+		leaf->last_tree = key.offset;
+		leaf->items[idx].tree_id = key.offset;
+		leaf->items[idx].len = strlen(work_path) + name_len;
+		*((char *)leaf+offset-1) = '\0';
+		offset -= leaf->items[idx].len + 1;
+		leaf->items[idx].path_offset = offset;
+		rest -= sizeof(struct btrfs_ioctl_subvol_items) + leaf->items[idx].len + 1;
+		strncpy(btrfs_path_ptr(leaf, idx), work_path, strlen(work_path));
+		strncpy(btrfs_path_ptr(leaf, idx) + strlen(work_path), name, name_len);
+		idx++;
+		key.offset++;
+	}
+
+	if (copy_to_user(svol->leaf, leaf, svol->len)) {
+		ret = -EFAULT;
+	}
+	goto out;
+
+outr_error:
+	btrfs_release_path(tree_root, path);
+out_inval:
+	ret = -EINVAL;
+out:
+	kfree(path);
+	kfree(leaf);
+	kfree(svol);
+	return ret;
+}
+
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 					     void __user *arg)
 {
@@ -1334,6 +1615,8 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_SNAP_LISTING:
+		return btrfs_ioctl_snap_listing(file, argp);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
Index: b/fs/btrfs/ioctl.h
===================================================================
--- a/fs/btrfs/ioctl.h	2009-11-12 23:47:08.000000000 +0900
+++ b/fs/btrfs/ioctl.h	2009-11-18 10:21:27.000000000 +0900
@@ -30,6 +30,33 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };

+struct btrfs_ioctl_subvol_args {
+	int len;
+	int next_len;
+	char *base_path;
+	struct btrfs_ioctl_subvol_leaf *leaf;
+	struct list_head list_top;
+};
+
+struct btrfs_ioctl_subvol_items {
+	u64 tree_id;
+	struct list_head children;
+	int path_offset;
+	int len;
+};
+
+struct btrfs_ioctl_subvol_leaf {
+	int len;
+	int nritems;
+	u64 parent_tree;
+	u64 last_tree;
+	struct list_head brother;
+	struct btrfs_ioctl_subvol_items items[];
+};
+
+#define BTRFS_SUBVOL_LEAF_SIZE_MIN sizeof(struct btrfs_ioctl_subvol_leaf) + \
+	sizeof(struct btrfs_ioctl_subvol_items)
+
 struct btrfs_ioctl_clone_range_args {
   __s64 src_fd;
   __u64 src_offset, src_length;
@@ -67,4 +94,6 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
+				   struct btrfs_ioctl_subvol_args)
 #endif

