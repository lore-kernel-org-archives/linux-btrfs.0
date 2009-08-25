From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 4/4] add drop snapshot/subvol ioctl
Date: Tue, 25 Aug 2009 22:38:45 +0800
Message-ID: <4A93F775.1070908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: aaron@merfinllc.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds drop snapshot/subvol ioctl that allows
dropping non-empty snapshot/subvols. The ioctl code is
based on Aaron Straus's patch.

Another change in this patch is add code that finds orphan
fs trees.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 4/fs/btrfs/ctree.h 5/fs/btrfs/ctree.h
--- 4/fs/btrfs/ctree.h	2009-08-24 10:39:12.200349458 +0800
+++ 5/fs/btrfs/ctree.h	2009-08-24 10:40:05.519385029 +0800
@@ -2125,6 +2125,7 @@ int btrfs_find_last_root(struct btrfs_ro
 int btrfs_search_root(struct btrfs_root *root, u64 search_start,
 		      u64 *found_objectid);
 int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
+int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
 int btrfs_set_root_node(struct btrfs_root_item *item,
 			struct extent_buffer *node);
 /* dir-item.c */
diff -urp 4/fs/btrfs/disk-io.c 5/fs/btrfs/disk-io.c
--- 4/fs/btrfs/disk-io.c	2009-08-24 10:39:12.202348481 +0800
+++ 5/fs/btrfs/disk-io.c	2009-08-25 15:23:52.441143639 +0800
@@ -950,13 +950,14 @@ static int find_and_setup_root(struct bt
 	ret = btrfs_find_last_root(tree_root, objectid,
 				   &root->root_item, &root->root_key);
 	BUG_ON(ret);
+	BUG_ON(btrfs_root_refs(&root->root_item) == 0);
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
-	root->commit_root = btrfs_root_node(root);
 	BUG_ON(!root->node);
+	root->commit_root = btrfs_root_node(root);
 	return 0;
 }
 
@@ -1194,12 +1195,13 @@ struct btrfs_root *btrfs_read_fs_root_no
 		kfree(root);
 		return ERR_PTR(ret);
 	}
-	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
-		ret = btrfs_find_dead_roots(fs_info->tree_root,
-					    root->root_key.objectid);
-		BUG_ON(ret);
+	ret = btrfs_find_dead_roots(fs_info->tree_root,
+				    root->root_key.objectid);
+	BUG_ON(ret);
+
+	if (!(fs_info->sb->s_flags & MS_RDONLY))
 		btrfs_orphan_cleanup(root);
-	}
+
 	return root;
 }
 
@@ -1424,9 +1426,12 @@ static int cleaner_kthread(void *arg)
 			break;
 
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
-		mutex_lock(&root->fs_info->cleaner_mutex);
-		btrfs_clean_old_snapshots(root);
-		mutex_unlock(&root->fs_info->cleaner_mutex);
+
+		if (!(root->fs_info->sb->s_flags & MS_RDONLY)) {
+			mutex_lock(&root->fs_info->cleaner_mutex);
+			btrfs_clean_old_snapshots(root);
+			mutex_unlock(&root->fs_info->cleaner_mutex);
+		}
 
 		if (freezing(current)) {
 			refrigerator();
@@ -1889,6 +1894,9 @@ struct btrfs_root *open_ctree(struct sup
 		}
 	}
 
+	ret = btrfs_find_orphan_roots(tree_root);
+	BUG_ON(ret);
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_recover_relocation(tree_root);
 		BUG_ON(ret);
@@ -2229,6 +2237,15 @@ static int del_fs_roots(struct btrfs_fs_
 	struct btrfs_root *gang[8];
 	int i;
 
+	while (!list_empty(&fs_info->dead_roots)) {
+		gang[0] = list_entry(fs_info->dead_roots.next,
+				     struct btrfs_root, root_list);
+		list_del(&gang[0]->root_list);
+		free_extent_buffer(gang[0]->node);
+		free_extent_buffer(gang[0]->commit_root);
+		kfree(gang[0]);
+	}
+
 	while (1) {
 		ret = radix_tree_gang_lookup(&fs_info->fs_roots_radix,
 					     (void **)gang, 0,
@@ -2258,9 +2275,6 @@ int btrfs_cleanup_fs_roots(struct btrfs_
 		root_objectid = gang[ret - 1]->root_key.objectid + 1;
 		for (i = 0; i < ret; i++) {
 			root_objectid = gang[i]->root_key.objectid;
-			ret = btrfs_find_dead_roots(fs_info->tree_root,
-						    root_objectid);
-			BUG_ON(ret);
 			btrfs_orphan_cleanup(gang[i]);
 		}
 		root_objectid++;
diff -urp 4/fs/btrfs/extent-tree.c 5/fs/btrfs/extent-tree.c
--- 4/fs/btrfs/extent-tree.c	2009-08-24 10:36:43.016348000 +0800
+++ 5/fs/btrfs/extent-tree.c	2009-08-24 10:40:05.526099170 +0800
@@ -5356,6 +5356,17 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	ret = btrfs_del_root(trans, tree_root, &root->root_key);
 	BUG_ON(ret);
 
+	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
+		ret = btrfs_find_last_root(tree_root, root->root_key.objectid,
+					   NULL, NULL);
+		BUG_ON(ret < 0);
+		if (ret > 0) {
+			ret = btrfs_del_orphan_item(trans, tree_root,
+						    root->root_key.objectid);
+			BUG_ON(ret);
+		}
+	}
+
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
 	kfree(root);
diff -urp 4/fs/btrfs/inode-map.c 5/fs/btrfs/inode-map.c
--- 4/fs/btrfs/inode-map.c	2009-08-25 13:12:02.360309951 +0800
+++ 5/fs/btrfs/inode-map.c	2009-08-24 16:35:47.845349566 +0800
@@ -44,9 +44,9 @@ int btrfs_find_highest_inode(struct btrf
 		l = path->nodes[0];
 		btrfs_item_key_to_cpu(l, &found_key, slot);
 		*objectid = max_t(u64, found_key.objectid,
-				  BTRFS_FIRST_FREE_OBJECTID - 1);
+				  BTRFS_FIRST_FREE_OBJECTID);
 	} else {
-		*objectid = BTRFS_FIRST_FREE_OBJECTID - 1;
+		*objectid = BTRFS_FIRST_FREE_OBJECTID;
 	}
 	ret = 0;
 error:
diff -urp 4/fs/btrfs/ioctl.c 5/fs/btrfs/ioctl.c
--- 4/fs/btrfs/ioctl.c	2009-08-24 10:38:34.286099000 +0800
+++ 5/fs/btrfs/ioctl.c	2009-08-24 10:40:05.527099450 +0800
@@ -600,7 +600,8 @@ out_unlock:
 	return 0;
 }
 
-static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
+static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
+					void __user *arg)
 {
 	u64 new_size;
 	u64 old_size;
@@ -783,6 +784,88 @@ out:
 	return ret;
 }
 
+static noinline int btrfs_ioctl_snap_destroy(struct file *file,
+					     void __user *arg)
+{
+	struct dentry *dentry;
+	struct dentry *parent = fdentry(file);
+	struct inode *inode;
+	struct inode *dir = parent->d_inode;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_trans_handle *trans;
+	unsigned long nr = 0;
+	int namelen;
+	int ret;
+
+	vol_args = kmalloc(sizeof(*vol_args), GFP_KERNEL);
+	if (!vol_args)
+		return -ENOMEM;
+
+	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	namelen = strlen(vol_args->name);
+	if (strchr(vol_args->name, '/')) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		goto out;
+
+	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
+
+	dentry = lookup_one_len(vol_args->name, parent, namelen);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto out_unlock;
+	}
+
+	inode = dentry->d_inode;
+	if (!inode) {
+		ret = -ENOENT;
+		goto out_dput;
+	}
+	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
+		ret = -EINVAL;
+		goto out_dput;
+	}
+
+	ret = d_invalidate(dentry);
+	if (ret)
+		goto out_dput;
+
+	mutex_lock(&inode->i_mutex);
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_trans_block_group(trans, dir);
+
+	root->fs_info->last_trans_log_full_commit = trans->transid;
+	ret = btrfs_unlink_subvol(trans, root, dir, dentry->d_inode,
+				  dentry->d_name.name, dentry->d_name.len);
+	BUG_ON(ret);
+
+	nr = trans->blocks_used;
+	btrfs_end_transaction(trans, root);
+	btrfs_btree_balance_dirty(root, nr);
+
+	ret = 0;
+	mutex_unlock(&inode->i_mutex);
+out_dput:
+	dput(dentry);
+out_unlock:
+	mutex_unlock(&dir->i_mutex);
+	mnt_drop_write(file->f_path.mnt);
+out:
+	kfree(vol_args);
+	return ret;
+}
+
 static int btrfs_ioctl_defrag(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
@@ -856,8 +939,8 @@ static long btrfs_ioctl_rm_dev(struct bt
 	return ret;
 }
 
-static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
-		u64 off, u64 olen, u64 destoff)
+static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
+				       u64 off, u64 olen, u64 destoff)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1249,6 +1332,8 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_snap_create(file, argp, 0);
 	case BTRFS_IOC_SUBVOL_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 1);
+	case BTRFS_IOC_SNAP_DESTROY:
+		return btrfs_ioctl_snap_destroy(file, argp);
 	case BTRFS_IOC_DEFRAG:
 		return btrfs_ioctl_defrag(file);
 	case BTRFS_IOC_RESIZE:
diff -urp 4/fs/btrfs/ioctl.h 5/fs/btrfs/ioctl.h
--- 4/fs/btrfs/ioctl.h	2009-08-24 10:36:43.018349000 +0800
+++ 5/fs/btrfs/ioctl.h	2009-08-24 10:40:05.528099380 +0800
@@ -65,5 +65,6 @@ struct btrfs_ioctl_clone_range_args {
 
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
-
+#define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
+				struct btrfs_ioctl_vol_args)
 #endif
diff -urp 4/fs/btrfs/root-tree.c 5/fs/btrfs/root-tree.c
--- 4/fs/btrfs/root-tree.c	2009-08-24 10:38:34.287099000 +0800
+++ 5/fs/btrfs/root-tree.c	2009-08-24 10:40:05.529100569 +0800
@@ -94,17 +94,22 @@ int btrfs_find_last_root(struct btrfs_ro
 		goto out;
 
 	BUG_ON(ret == 0);
+	if (path->slots[0] == 0) {
+		ret = 1;
+		goto out;
+	}
 	l = path->nodes[0];
-	BUG_ON(path->slots[0] == 0);
 	slot = path->slots[0] - 1;
 	btrfs_item_key_to_cpu(l, &found_key, slot);
 	if (found_key.objectid != objectid) {
 		ret = 1;
 		goto out;
 	}
-	read_extent_buffer(l, item, btrfs_item_ptr_offset(l, slot),
-			   sizeof(*item));
-	memcpy(key, &found_key, sizeof(found_key));
+	if (item)
+		read_extent_buffer(l, item, btrfs_item_ptr_offset(l, slot),
+				   sizeof(*item));
+	if (key)
+		memcpy(key, &found_key, sizeof(found_key));
 	ret = 0;
 out:
 	btrfs_free_path(path);
@@ -249,6 +254,59 @@ err:
 	return ret;
 }
 
+int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int err = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = 0;
+
+	while (1) {
+		ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+		if (ret < 0) {
+			err = ret;
+			break;
+		}
+
+		leaf = path->nodes[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(tree_root, path);
+			if (ret < 0)
+				err = ret;
+			if (ret != 0)
+				break;
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		btrfs_release_path(tree_root, path);
+
+		if (key.objectid != BTRFS_ORPHAN_OBJECTID ||
+		    key.type != BTRFS_ORPHAN_ITEM_KEY)
+			break;
+
+		ret = btrfs_find_dead_roots(tree_root, key.offset);
+		if (ret) {
+			err = ret;
+			break;
+		}
+
+		key.offset++;
+	}
+
+	btrfs_free_path(path);
+	return err;
+}
+
 /* drop the root item for 'key' from 'root' */
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_key *key)
diff -urp 4/fs/btrfs/transaction.c 5/fs/btrfs/transaction.c
--- 4/fs/btrfs/transaction.c	2009-08-24 10:38:34.288098000 +0800
+++ 5/fs/btrfs/transaction.c	2009-08-24 10:40:05.530100150 +0800
@@ -1087,8 +1087,12 @@ int btrfs_clean_old_snapshots(struct btr
 
 	while (!list_empty(&list)) {
 		root = list_entry(list.next, struct btrfs_root, root_list);
-		list_del_init(&root->root_list);
-		btrfs_drop_snapshot(root, 0);
+		list_del(&root->root_list);
+		if (btrfs_header_backref_rev(root->node) <
+		    BTRFS_MIXED_BACKREF_REV)
+			btrfs_drop_snapshot(root, 0);
+		else
+			btrfs_drop_snapshot(root, 1);
 	}
 	return 0;
 }
