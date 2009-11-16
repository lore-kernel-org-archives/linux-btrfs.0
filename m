From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] Subvolume Listing feature for ioctl.
Date: Mon, 16 Nov 2009 10:44:12 +0900
Message-ID: <4B00AE6C.7080507@jp.fujitsu.com>
References: <4B00ADE8.4090205@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	zheng.yan@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B00ADE8.4090205@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

New feature to list up subvolume/snapshots under
specified tree of file is introduced to ioctl.

---
 fs/btrfs/ioctl.c |  321 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   27 ++++
 2 files changed, 348 insertions(+)

Index: b/fs/btrfs/ioctl.c
===================================================================
--- a/fs/btrfs/ioctl.c	2009-11-12 23:47:05.000000000 +0900
+++ b/fs/btrfs/ioctl.c	2009-11-12 23:54:21.000000000 +0900
@@ -48,6 +48,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "locking.h"
+#include "ctree.h"

 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -738,6 +739,323 @@ out:
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
+		ptr -= len+1;
+		total_len += len+1;
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
+	struct dentry *dent=d;
+
+	ino = dent->d_inode->i_ino;
+	while (ino!=BTRFS_FIRST_FREE_OBJECTID) {
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
+	struct btrfs_ioctl_subvol_name *svol_iname;
+	struct btrfs_ioctl_subvol_cache *subvol, *tmp;
+	struct btrfs_ioctl_subvol_args *svol;
+	struct btrfs_root *tree_root, *root;
+	struct btrfs_root_ref *ref;
+	struct extent_buffer *l;
+	struct btrfs_path *path=NULL;
+	struct btrfs_key key;
+	u64 tree_id;
+	char *work_path, *f_path, *name;
+	int err, ret = 0, slot = 0, seq = 0;
+	LIST_HEAD(pending_subvols);
+	struct list_head *cur;
+	struct path vfs_path;
+	struct inode *d_inode;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	svol_iname = kzalloc(sizeof(*svol_iname), GFP_NOFS);
+	name = kzalloc(BTRFS_PATH_NAME_MAX+1, GFP_NOFS);
+	svol = memdup_user(arg, sizeof(*svol));
+	if (!svol_iname || IS_ERR(svol) || !name)
+		return -ENOMEM;
+
+	/* identify tree base and set it to user parameter. */
+	svol->nr = 0;
+	if (svol->seq == 0) {
+		work_path = kzalloc(BTRFS_PATH_NAME_MAX+1, GFP_NOFS);
+		if (!work_path) {
+			ret = -ENOMEM;
+			goto error_unrelease;
+		}
+		vfs_path.mnt = file->f_path.mnt;
+		vfs_path.dentry = btrfs_walkup_dentry_to_root(file->f_path.dentry);
+		f_path = d_path(&vfs_path, work_path, BTRFS_PATH_NAME_MAX);
+		if (!IS_ERR(f_path)) {
+			strcpy(svol_iname->name, f_path);
+			strcat(svol_iname->name, "/");
+			svol_iname->objectid = 0;
+			if (copy_to_user((svol->subvols), svol_iname,
+						sizeof(*svol_iname))) {
+				ret = -EFAULT;
+				kfree(work_path);
+				goto error_unrelease;
+			};
+			svol->nr++;
+		}
+		kfree(work_path);
+	}
+
+	/* identify tree id and tree root */
+	d_inode = file->f_path.dentry->d_inode;
+	root = BTRFS_I(d_inode)->root;
+	tree_root = root->fs_info->tree_root;
+	tree_id = root->root_key.objectid;
+
+	/* create first tree info to search subvolume and add it to inner list */
+	subvol = kzalloc(sizeof(struct btrfs_ioctl_subvol_cache), GFP_NOFS);
+	subvol->tree_id = tree_id;
+	subvol->name_len = 0;
+	subvol->path_len = 0;
+	list_add_tail(&subvol->list, &pending_subvols);
+	path = btrfs_alloc_path();
+
+	/* finalize path name info and search subvolumes until list get empty */
+	while (!list_empty(&pending_subvols)) {
+
+		/* pick up tree info */
+		subvol = list_entry(pending_subvols.next,
+					struct btrfs_ioctl_subvol_cache, list);
+		tree_id = subvol->tree_id;
+
+		/* if not first tree, identfy its path in the parent tree.
+		   subvol->path_name holds path_name from the specified root
+		   to the parent tree root. so, we concatenate subvol->path_name,
+		   and path_name in the parent tree, and directry name itself. */
+		if (subvol->name_len > 0) {
+			btrfs_search_path_in_tree(root->fs_info,
+						subvol->parent, subvol->dirid, name);
+
+			if (strlen(name)+subvol->name_len>BTRFS_PATH_NAME_MAX) {
+				ret = -1;
+				goto error_unrelease;
+			}
+			strcpy(svol_iname->name, subvol->path_name);
+			strcpy(svol_iname->name+strlen(subvol->path_name), name);
+			strcpy(svol_iname->name+strlen(subvol->path_name)+strlen(name),
+						subvol->name);
+			/* this name string is used to set subvolume info as path name
+			   of parent tree. */
+			strcpy(name, svol_iname->name);
+
+			/* if sequence is bigger than required, return subvol info to
+				user parameter */
+			if(seq > svol->seq) {
+				strcat(svol_iname->name, "/");
+				svol_iname->objectid = tree_id;
+				if (copy_to_user((svol->subvols+svol->nr),
+							svol_iname, sizeof(*svol_iname))) {
+					ret = -EFAULT;
+					goto error;
+				}
+				svol->nr++;
+				if (svol->nr >= svol->max) {
+					list_for_each_entry_safe(subvol, tmp,
+								&pending_subvols, list) {
+						list_del(&subvol->list);
+						if (subvol->name_len != 0)
+							kfree(subvol->name);
+						if (subvol->path_name)
+							kfree(subvol->path_name);
+						kfree(subvol);
+					}
+					ret = 1;
+					goto reach_limit;
+				}
+			}
+		}
+
+		/* search root tree to find subvolumes */
+		key.objectid = tree_id;
+		key.type = BTRFS_ROOT_REF_KEY;
+		key.offset = 0;
+		list_del(&subvol->list);
+		if (subvol->name_len != 0)
+			kfree(subvol->name);
+		if (subvol->path_name)
+			kfree(subvol->path_name);
+		kfree(subvol);
+		seq++;
+
+		err = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+		if (err < 0) {
+			printk("search slot failed: code=%d\n", err);
+			ret = -1;
+			goto error_unrelease;
+		}
+		cur = &pending_subvols;
+
+		/* traverse leafs to search subvolumes under the subvolume */
+		while (1) {
+			l = path->nodes[0];
+			slot = path->slots[0];
+			btrfs_item_key_to_cpu( l, &key, path->slots[0]);
+			if (slot >= btrfs_header_nritems(l)) {
+				err = btrfs_next_leaf(tree_root, path);
+				if (err == 0)
+					continue;
+				if (err < 0) {
+					printk("next_leaf failed: code=%d\n", err);
+					ret = -1;
+					goto error;
+				}
+			}
+			if (key.type != BTRFS_ROOT_REF_KEY || key.objectid != tree_id)
+				break;
+
+			subvol = kzalloc(sizeof(struct btrfs_ioctl_subvol_cache),
+						GFP_NOFS);
+			subvol->tree_id = key.offset;
+			subvol->parent = key.objectid;
+
+			/* set to subvolume info its name and info about parent tree */
+			ref = btrfs_item_ptr(l, slot, struct btrfs_root_ref);
+			subvol->name_len = btrfs_root_ref_name_len( l, ref);
+			subvol->name = kzalloc(subvol->name_len+1, GFP_NOFS);
+			read_extent_buffer(l, subvol->name,
+					(unsigned long)(ref + 1), subvol->name_len);
+			subvol->path_name = kzalloc(strlen(name)+2, GFP_NOFS);
+			if (strlen(name)!=0) {
+				strcpy(subvol->path_name, name);
+				strcat(subvol->path_name, "/");
+			}
+			subvol->dirid = btrfs_root_ref_dirid(l, ref);
+
+			list_add(&subvol->list, cur);
+			cur = &subvol->list;
+
+			path->slots[0]++;
+			cond_resched();
+		}
+		btrfs_release_path(tree_root, path);
+	}
+
+reach_limit:
+	svol->seq = seq;
+	if (copy_to_user(arg, svol,
+				sizeof(struct btrfs_ioctl_subvol_args))) {
+		ret = -EFAULT;
+	}
+	btrfs_release_path(tree_root, path);
+	kfree(svol);
+	kfree(svol_iname);
+	kfree(path);
+	kfree(name);
+	return ret;
+error:
+	btrfs_release_path(tree_root, path);
+error_unrelease:
+	kfree(svol);
+	kfree(svol_iname);
+	kfree(path);
+	kfree(name);
+	return ret;
+}
+
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 					     void __user *arg)
 {
@@ -1334,10 +1652,13 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_SNAP_LISTING:
+		return btrfs_ioctl_snap_listing(file, argp);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
 	}

+	printk("cmd : %u \n", cmd);
 	return -ENOTTY;
 }
Index: b/fs/btrfs/ioctl.h
===================================================================
--- a/fs/btrfs/ioctl.h	2009-11-12 23:47:08.000000000 +0900
+++ b/fs/btrfs/ioctl.h	2009-11-12 23:47:27.000000000 +0900
@@ -23,6 +23,7 @@
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
 #define BTRFS_PATH_NAME_MAX 4087
+#define BTRFS_SUBVOL_LIST_MAX 3

 /* this should be 4k */
 struct btrfs_ioctl_vol_args {
@@ -30,6 +31,30 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };

+struct btrfs_ioctl_subvol_name {
+	u64 objectid;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+};
+
+/* these members are same as first three members of btrfs_ioctl_subvol_args_inner */
+struct btrfs_ioctl_subvol_args {
+	int max;
+	int nr;
+	u64 seq;
+	struct btrfs_ioctl_subvol_name *subvols;
+};
+
+struct btrfs_ioctl_subvol_cache {
+	struct list_head list;
+	u64 tree_id;
+	u64 parent;
+	u64 dirid;
+	int path_len;
+	char *path_name;
+	int name_len;
+	char *name;
+};
+
 struct btrfs_ioctl_clone_range_args {
   __s64 src_fd;
   __u64 src_offset, src_length;
@@ -67,4 +92,6 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
+				   struct btrfs_ioctl_subvol_args)
 #endif

