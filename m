From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] proper VFS interaction for subvolume creation
Date: Tue, 7 Oct 2008 19:50:26 +0200
Message-ID: <20081007175026.GA9975@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Creating a subvolume is in many ways like a normal VFS ->mkdir, and we
really need to play with the VFS topology locking rules.  So instead of
just creating the snapshot on disk and then later getting rid of
confliting aliases do it correctly from the start.  This will become
especially important once we allow for subvolumes anywher in the tree,
and not just below a hidden root.

Note that snapshots will need the same treatment, but do to the delay
in creating them we can't do it currently.  Chris promised to fix that
issue, so I'll wait on that.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/ioctl.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/ioctl.c	2008-10-06 16:26:24.000000000 +0200
+++ btrfs-unstable/fs/btrfs/ioctl.c	2008-10-07 19:44:45.000000000 +0200
@@ -21,6 +21,7 @@
 #include <linux/buffer_head.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
@@ -28,12 +29,15 @@
 #include <linux/string.h>
 #include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
+#include <linux/mount.h>
 #include <linux/mpage.h>
+#include <linux/namei.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/statfs.h>
 #include <linux/compat.h>
 #include <linux/bit_spinlock.h>
+#include <linux/security.h>
 #include <linux/version.h>
 #include <linux/xattr.h>
 #include <linux/vmalloc.h>
@@ -48,8 +52,9 @@
 
 
 
-static noinline int create_subvol(struct btrfs_root *root, char *name,
-				  int namelen)
+static noinline int create_subvol(struct btrfs_root *root,
+				  struct dentry *dentry,
+				  char *name, int namelen)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
@@ -151,14 +156,11 @@ static noinline int create_subvol(struct
 	trans = btrfs_start_transaction(new_root, 1);
 	BUG_ON(!trans);
 
-	ret = btrfs_create_subvol_root(new_root, trans, new_dirid,
+	ret = btrfs_create_subvol_root(new_root, dentry, trans, new_dirid,
 				       BTRFS_I(dir)->block_group);
 	if (ret)
 		goto fail;
 
-	/* Invalidate existing dcache entry for new subvolume. */
-	btrfs_invalidate_dcache_root(root, name, namelen);
-
 fail:
 	nr = trans->blocks_used;
 	err = btrfs_commit_transaction(trans, new_root);
@@ -210,6 +212,79 @@ fail_unlock:
 	return ret;
 }
 
+/* copy of may_create in fs/namei.c() */
+static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
+{
+	if (child->d_inode)
+		return -EEXIST;
+	if (IS_DEADDIR(dir))
+		return -ENOENT;
+	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+}
+
+/*
+ * Create a new subvolume below @parent.  This is largely modeled after
+ * sys_mkdirat and vfs_mkdir, but we only do a single component lookup
+ * inside this filesystem so it's quite a bit simpler.
+ */
+static noinline int btrfs_mksubvol(struct path *parent, char *name,
+				   int mode, int namelen)
+{
+	struct dentry *dentry;
+	int error;
+
+	mutex_lock_nested(&parent->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+
+	dentry = lookup_one_len(name, parent->dentry, namelen);
+	error = PTR_ERR(dentry);
+	if (IS_ERR(dentry))
+		goto out_unlock;
+
+	error = -EEXIST;
+	if (dentry->d_inode)
+		goto out_dput;
+
+	if (!IS_POSIXACL(parent->dentry->d_inode))
+		mode &= ~current->fs->umask;
+	error = mnt_want_write(parent->mnt);
+	if (error)
+		goto out_dput;
+
+	error = btrfs_may_create(parent->dentry->d_inode, dentry);
+	if (error)
+		goto out_drop_write;
+
+	mode &= (S_IRWXUGO|S_ISVTX);
+	error = security_inode_mkdir(parent->dentry->d_inode, dentry, mode);
+	if (error)
+		goto out_drop_write;
+
+	/*
+	 * Actually perform the low-level subvolume creation after all
+	 * this VFS fuzz.
+	 *
+	 * Eventually we want to pass in an inode under which we create this
+	 * subvolume, but for now all are under the filesystem root.
+	 *
+	 * Also we should pass on the mode eventually to allow creating new
+	 * subvolume with specific mode bits.
+	 */
+	error = create_subvol(BTRFS_I(parent->dentry->d_inode)->root, dentry,
+			      name, namelen);
+	if (error)
+		goto out_drop_write;
+
+	fsnotify_mkdir(parent->dentry->d_inode, dentry);
+out_drop_write:
+	mnt_drop_write(parent->mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
+	mutex_unlock(&parent->dentry->d_inode->i_mutex);
+	return error;
+}
+
+
 int btrfs_defrag_file(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
@@ -395,9 +470,10 @@ out:
 	return ret;
 }
 
-static noinline int btrfs_ioctl_snap_create(struct btrfs_root *root,
+static noinline int btrfs_ioctl_snap_create(struct file *file,
 					    void __user *arg)
 {
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_vol_args *vol_args;
 	struct btrfs_dir_item *di;
 	struct btrfs_path *path;
@@ -444,10 +520,14 @@ static noinline int btrfs_ioctl_snap_cre
 		goto out;
 	}
 
-	if (root == root->fs_info->tree_root)
-		ret = create_subvol(root, vol_args->name, namelen);
-	else
+	if (root == root->fs_info->tree_root) {
+		ret = btrfs_mksubvol(&file->f_path, vol_args->name,
+				     file->f_path.dentry->d_inode->i_mode,
+				     namelen);
+	} else {
 		ret = create_snapshot(root, vol_args->name, namelen);
+	}
+
 out:
 	kfree(vol_args);
 	return ret;
@@ -761,7 +841,7 @@ long btrfs_ioctl(struct file *file, unsi
 
 	switch (cmd) {
 	case BTRFS_IOC_SNAP_CREATE:
-		return btrfs_ioctl_snap_create(root, (void __user *)arg);
+		return btrfs_ioctl_snap_create(file, (void __user *)arg);
 	case BTRFS_IOC_DEFRAG:
 		return btrfs_ioctl_defrag(file);
 	case BTRFS_IOC_RESIZE:
Index: btrfs-unstable/fs/btrfs/ctree.h
===================================================================
--- btrfs-unstable.orig/fs/btrfs/ctree.h	2008-10-07 19:40:37.000000000 +0200
+++ btrfs-unstable/fs/btrfs/ctree.h	2008-10-07 19:40:46.000000000 +0200
@@ -1804,7 +1804,7 @@ int btrfs_start_delalloc_inodes(struct b
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end);
 int btrfs_writepages(struct address_space *mapping,
 		     struct writeback_control *wbc);
-int btrfs_create_subvol_root(struct btrfs_root *new_root,
+int btrfs_create_subvol_root(struct btrfs_root *new_root, struct dentry *dentry,
 		struct btrfs_trans_handle *trans, u64 new_dirid,
 		struct btrfs_block_group_cache *block_group);
 
Index: btrfs-unstable/fs/btrfs/inode.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/inode.c	2008-10-07 19:40:50.000000000 +0200
+++ btrfs-unstable/fs/btrfs/inode.c	2008-10-07 19:41:21.000000000 +0200
@@ -3402,11 +3402,12 @@ void btrfs_invalidate_dcache_root(struct
 /*
  * create a new subvolume directory/inode (helper for the ioctl).
  */
-int btrfs_create_subvol_root(struct btrfs_root *new_root,
+int btrfs_create_subvol_root(struct btrfs_root *new_root, struct dentry *dentry,
 		struct btrfs_trans_handle *trans, u64 new_dirid,
 		struct btrfs_block_group_cache *block_group)
 {
 	struct inode *inode;
+	int error;
 	u64 index = 0;
 
 	inode = btrfs_new_inode(trans, new_root, NULL, "..", 2, new_dirid,
@@ -3420,7 +3421,12 @@ int btrfs_create_subvol_root(struct btrf
 	inode->i_nlink = 1;
 	btrfs_i_size_write(inode, 0);
 
-	return btrfs_update_inode(trans, new_root, inode);
+	error = btrfs_update_inode(trans, new_root, inode);
+	if (error)
+		return error;
+
+	d_instantiate(dentry, inode);
+	return 0;
 }
 
 /* helper function for file defrag and space balancing.  This
