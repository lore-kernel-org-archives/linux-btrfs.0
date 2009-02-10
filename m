From: Aaron Straus <aaron@merfinllc.com>
Subject: [PATCH] start work on delete snapshot code
Date: Mon,  9 Feb 2009 16:07:33 -0800
Message-ID: <1234224453-4227-1-git-send-email-aaron@merfinllc.com>
Cc: Aaron Straus <aaron@merfinllc.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is far from complete and in particular it *doesn't* take the necessary
locks at all i.e. please don't use this yet outside of testing.  This patch is
more of a request for help with regards to the locking.

I think there is also a bug in the mainline tree.  When taking snapshots of
snapshots I'm not sure we're adding the proper references and back references
in the root_tree.

This code doesn't immediately panic the system and seems to delete a tree
succesfully in simple tests.  The filesystem even fscks correctly afterwards!

Thanks!
---
 fs/btrfs/ioctl.c |  325 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    3 +
 2 files changed, 328 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 988fdc8..6e09873 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -550,6 +550,329 @@ out:
 	return ret;
 }
 
+static noinline int remove_directory_entries(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root, struct inode *dir,
+				struct inode *inode, char *name, int name_len)
+{
+	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	int ret;
+	unsigned long found_name;
+	struct extent_buffer *leaf;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
+				    name, name_len, -1);
+
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto err;
+	}
+
+	if (!di) {
+		printk(KERN_INFO "btrfs: weird no dentry\n");
+		ret = -ENOENT;
+		goto err;
+	}
+
+	ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	if (ret) {
+		printk(KERN_INFO "btrfs: cannot delete name\n");
+		goto err;
+	}
+
+	btrfs_release_path(root, path);
+
+	/* now the tough part... the index.. we can't rely on the inode
+	 * ref b/c the inode ref lives in a different tree... just fall
+	 * back to search */
+	key.objectid = dir->i_ino;
+	key.offset = (u64) -1;
+	key.type = BTRFS_DIR_INDEX_KEY;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+
+	if (ret < 0) {
+		printk(KERN_INFO "btrfs: problem with initial dir index search\n");
+		goto err;
+	}
+
+	BUG_ON(ret == 0);
+
+	ret = 0;
+	di = NULL;
+
+	while (!ret) {
+		ret = btrfs_previous_item(root, path, key.objectid,
+					  BTRFS_DIR_INDEX_KEY);
+
+		if (ret < 0) {
+			printk(KERN_INFO "btrfs: problem scanning backwards for index\n");
+			goto err;
+		}
+
+		if (ret)
+			break;
+
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      path->slots[0]);
+		leaf = path->nodes[0];
+
+		BUG_ON(found_key.objectid != key.objectid);
+
+		di = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
+
+		if (btrfs_dir_name_len(leaf, di) == name_len) {
+			found_name = (unsigned long) (di + 1);
+			if (!memcmp_extent_buffer(leaf, name, found_name, name_len))
+				break;
+		}
+
+		di = NULL;
+	}
+
+	/* di will be non-null if we found a match */
+	if (di != NULL) {
+		ret = btrfs_del_item(trans, root, path);
+		BUG_ON(ret);
+		btrfs_release_path(root, path);
+	} else {
+		printk(KERN_INFO "btrfs: hmm no dir index\n");
+	}
+
+	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
+	inode->i_ctime = dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	btrfs_update_inode(trans, root, dir);
+	dir->i_sb->s_dirt = 1;
+err:
+	btrfs_free_path(path);
+out:
+	return ret;
+}
+
+static noinline int delete_root_references(struct btrfs_root *dir_root,
+			struct btrfs_root *target_root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	int ret;
+	int refs;
+	struct btrfs_path *path;
+	struct btrfs_root *root;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	root = dir_root->fs_info->tree_root;
+
+	trans = btrfs_start_transaction(root, 1);
+
+	key.objectid = dir_root->root_key.objectid;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = target_root->root_key.objectid;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+
+	if (ret < 0) {
+		printk(KERN_INFO "btrfs:  problem find root refs\n");
+		goto err;
+	}
+
+	if (!ret)
+		btrfs_del_item(trans, root, path);
+	else
+		printk(KERN_INFO "btrfs:  hmm no root refs\n");
+
+	btrfs_release_path(root, path);
+
+	key.objectid = target_root->root_key.objectid;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = dir_root->root_key.objectid;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+
+	if (ret < 0) {
+		printk(KERN_INFO "btrfs:  problem find root backrefs\n");
+		goto err;
+	}
+
+	if (!ret)
+		btrfs_del_item(trans, root, path);
+	else
+		printk(KERN_INFO "btrfs:  hmm no root backrefs\n");
+
+	btrfs_release_path(root, path);
+
+	refs = btrfs_root_refs(&target_root->root_item);
+	btrfs_set_root_refs(&target_root->root_item, refs - 1);
+
+	ret = btrfs_update_root(trans, root, &target_root->root_key,
+				&target_root->root_item);
+
+	if (ret) {
+		printk(KERN_INFO "btrfs: problem copying root into btree\n");
+		goto err;
+	}
+
+	ret = btrfs_commit_transaction(trans, root);
+
+	if (ret) {
+		printk(KERN_INFO "btrfs: problem committing transaction\n");
+		goto err;
+	}
+
+err:
+	btrfs_free_path(path);
+out:
+	return ret;
+}
+
+static noinline int btrfs_ioctl_snap_destroy(struct file *file,
+				void __user *arg)
+{
+	struct inode *inode;
+	struct dentry *dir = fdentry(file);
+	struct dentry *dentry;
+	struct btrfs_root *root = BTRFS_I(dir->d_inode)->root;
+	struct btrfs_root *target_root;
+	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_trans_handle *trans;
+	int namelen;
+	int ret = 0;
+	int refs;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY) {
+		ret = -EROFS;
+		goto out_final;
+	}
+
+	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
+
+	if (!vol_args) {
+		ret = -ENOMEM;
+		goto out_final;
+	}
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
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
+
+	dentry = lookup_one_len(vol_args->name, dir, namelen);
+	if (IS_ERR(dentry)) {
+		mutex_unlock(&dir->d_inode->i_mutex);
+		goto out;
+	}
+
+	inode = dentry->d_inode;
+
+	mutex_unlock(&dir->d_inode->i_mutex);
+
+	/* (1) locks needed? */
+	if (!(inode->i_mode & S_IFDIR)) {
+		printk(KERN_INFO "btrfs: not directory\n");
+		ret = -EINVAL;
+		goto out_dput;
+	}
+
+	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
+		printk(KERN_INFO "btrfs: not snapshot\n");
+		ret = -EINVAL;
+		goto out_dput;
+	}
+
+	/* (2) lock out submounts? */
+	if (have_submounts(dentry)) {
+		printk(KERN_INFO "btrfs: Snapshot has submounts\n");
+		ret = -EBUSY;
+		goto out_dput;
+	}
+
+	/* (3) lock sb... lock dcache  lock btrfs? */
+	shrink_dcache_parent(dentry);
+
+	if (!list_empty(&dentry->d_subdirs)) {
+		printk(KERN_INFO "btrfs: leftover dentries\n");
+		ret = -EBUSY;
+		goto out_dput;
+	}
+
+	ret = btrfs_check_free_space(root, 1, 1);
+	if (ret) {
+		printk(KERN_INFO "btrfs: not enough space to delete snapshot\n");
+		goto out_dput;
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_trans_block_group(trans, dir->d_inode);
+
+	ret = remove_directory_entries(trans, root, dir->d_inode,
+				       inode, vol_args->name, namelen);
+
+	if (ret) {
+		printk(KERN_INFO "btrfs: problem removing dentries\n");
+		goto out_dput;
+	}
+
+	ret = btrfs_commit_transaction(trans, root);
+
+	if (ret) {
+		printk(KERN_INFO "btrfs: problem committing transaction\n");
+		goto out_dput;
+	}
+
+	target_root = BTRFS_I(inode)->root;
+
+	ret = delete_root_references(root, target_root);
+
+	if (ret) {
+		printk(KERN_INFO "btrfs: problem deleting root references\n");
+		goto out_dput;
+	}
+
+	refs = btrfs_root_refs(&target_root->root_item);
+
+	if (!refs) {
+		ret = btrfs_add_dead_root(target_root, root);
+
+		if (ret) {
+			printk(KERN_INFO "btrfs: problem adding dead root\n");
+			goto out_dput;
+		}
+
+		radix_tree_delete(&target_root->fs_info->fs_roots_radix,
+				  (unsigned long)target_root->root_key.objectid);
+
+		/* leak root? */
+	}
+
+out_dput:
+	dput(dentry);
+out:
+	kfree(vol_args);
+out_final:
+	return ret;
+}
+
 static noinline int btrfs_ioctl_snap_create(struct file *file,
 					    void __user *arg, int subvol)
 {
@@ -1102,6 +1425,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 	switch (cmd) {
 	case BTRFS_IOC_SNAP_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 0);
+	case BTRFS_IOC_SNAP_DESTROY:
+		return btrfs_ioctl_snap_destroy(file, argp);
 	case BTRFS_IOC_SUBVOL_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 1);
 	case BTRFS_IOC_DEFRAG:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index b320b10..587d021 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -66,4 +66,7 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
 
+#define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
+				   struct btrfs_ioctl_vol_args)
+
 #endif
-- 
1.5.6.5

