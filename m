From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v3 2/3] Btrfs: Add readonly snapshots support
Date: Thu, 23 Dec 2010 16:15:54 +0800
Message-ID: <4D13053A.2010300@cn.fujitsu.com>
References: <4D130514.9080704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D130514.9080704@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Usage:

Set BTRFS_SUBVOL_RDONLY of btrfs_ioctl_vol_arg_v2->flags, and call
ioctl(BTRFS_I0CTL_SNAP_CREATE_V2).

Implementation:

- Set readonly bit of btrfs_root_item->flags.
- Add readonly checks in btrfs_permission (inode_permission),
btrfs_setattr, btrfs_set/remove_xattr and some ioctls.

Changelog for v3:

- Eliminate btrfs_root->readonly, but check btrfs_root->root_item.flags.
- Rename BTRFS_ROOT_SNAP_RDONLY to BTRFS_ROOT_SUBVOL_RDONLY.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    7 +++++++
 fs/btrfs/inode.c       |    8 ++++++++
 fs/btrfs/ioctl.c       |   42 ++++++++++++++++++++++++++++++++----------
 fs/btrfs/ioctl.h       |    1 +
 fs/btrfs/transaction.c |    8 ++++++++
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/xattr.c       |   18 ++++++++++++++++++
 7 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index af52f6d..4403e56 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -597,6 +597,8 @@ struct btrfs_dir_item {
 	u8 type;
 } __attribute__ ((__packed__));
 
+#define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
+
 struct btrfs_root_item {
 	struct btrfs_inode_item inode;
 	__le64 generation;
@@ -1893,6 +1895,11 @@ BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
 BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
 			 last_snapshot, 64);
 
+static inline bool btrfs_root_readonly(struct btrfs_root *root)
+{
+	return root->root_item.flags & BTRFS_ROOT_SUBVOL_RDONLY;
+}
+
 /* struct btrfs_super_block */
 
 BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f91944..956f1eb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3671,8 +3671,12 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int err;
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	err = inode_change_ok(inode, attr);
 	if (err)
 		return err;
@@ -7206,6 +7210,10 @@ static int btrfs_set_page_dirty(struct page *page)
 
 static int btrfs_permission(struct inode *inode, int mask)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (btrfs_root_readonly(root) && (mask & MAY_WRITE))
+		return -EROFS;
 	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
 	return generic_permission(inode, mask, btrfs_check_acl);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 02554e1..f066ccb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -147,6 +147,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	unsigned int flags, oldflags;
 	int ret;
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	if (copy_from_user(&flags, arg, sizeof(flags)))
 		return -EFAULT;
 
@@ -360,7 +363,8 @@ fail:
 }
 
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
-			   char *name, int namelen, u64 *async_transid)
+			   char *name, int namelen, u64 *async_transid,
+			   bool readonly)
 {
 	struct inode *inode;
 	struct dentry *parent;
@@ -378,6 +382,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv);
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
+	pending_snapshot->readonly = readonly;
 
 	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
 	if (IS_ERR(trans)) {
@@ -509,7 +514,7 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
 static noinline int btrfs_mksubvol(struct path *parent,
 				   char *name, int namelen,
 				   struct btrfs_root *snap_src,
-				   u64 *async_transid)
+				   u64 *async_transid, bool readonly)
 {
 	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
@@ -541,7 +546,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 
 	if (snap_src) {
 		error = create_snapshot(snap_src, dentry,
-					name, namelen, async_transid);
+					name, namelen, async_transid, readonly);
 	} else {
 		error = create_subvol(BTRFS_I(dir)->root, dentry,
 				      name, namelen, async_transid);
@@ -901,7 +906,8 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 						    char *name,
 						    unsigned long fd,
 						    int subvol,
-						    u64 *transid)
+						    u64 *transid,
+						    bool readonly)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct file *src_file;
@@ -919,7 +925,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 
 	if (subvol) {
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
-				     NULL, transid);
+				     NULL, transid, readonly);
 	} else {
 		struct inode *src_inode;
 		src_file = fget(fd);
@@ -938,7 +944,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		}
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
 				     BTRFS_I(src_inode)->root,
-				     transid);
+				     transid, readonly);
 		fput(src_file);
 	}
 out:
@@ -957,7 +963,8 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
-					      vol_args->fd, subvol, NULL);
+					      vol_args->fd, subvol,
+					      NULL, false);
 
 	kfree(vol_args);
 	return ret;
@@ -970,22 +977,27 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 	int ret;
 	u64 transid = 0;
 	u64 *ptr = NULL;
+	bool readonly = false;
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
 		return PTR_ERR(vol_args);
 	vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 
-	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_ASYNC) {
-		ret = -EINVAL;
+	if (vol_args->flags &
+	    ~(BTRFS_SUBVOL_CREATE_ASYNC | BTRFS_SUBVOL_RDONLY)) {
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
 	if (vol_args->flags & BTRFS_SUBVOL_CREATE_ASYNC)
 		ptr = &transid;
+	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
+		readonly = true;
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
-					      vol_args->fd, subvol, ptr);
+					      vol_args->fd, subvol,
+					      ptr, readonly);
 
 	if (ret == 0 && ptr &&
 	    copy_to_user(arg +
@@ -1505,6 +1517,9 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	struct btrfs_ioctl_defrag_range_args *range;
 	int ret;
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
 		return ret;
@@ -1633,6 +1648,9 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
 		return -EINVAL;
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
 		return ret;
@@ -1954,6 +1972,10 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	if (file->private_data)
 		goto out;
 
+	ret = -EROFS;
+	if (btrfs_root_readonly(root))
+		goto out;
+
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
 		goto out;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index c344d12..52ae489 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -31,6 +31,7 @@ struct btrfs_ioctl_vol_args {
 };
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
+#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 
 #define BTRFS_SUBVOL_NAME_MAX 4039
 struct btrfs_ioctl_vol_args_v2 {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f50e931..29e30d8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -910,6 +910,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 to_reserve = 0;
 	u64 index = 0;
 	u64 objectid;
+	u64 root_flags;
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
@@ -967,6 +968,13 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
+	root_flags = btrfs_root_flags(new_root_item);
+	if (pending->readonly)
+		root_flags |= BTRFS_ROOT_SUBVOL_RDONLY;
+	else
+		root_flags &= ~BTRFS_ROOT_SUBVOL_RDONLY;
+	btrfs_set_root_flags(new_root_item, root_flags);
+
 	old = btrfs_lock_root_node(root);
 	btrfs_cow_block(trans, root, old, NULL, 0, &old);
 	btrfs_set_lock_blocking(old);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f104b57..229a594 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -62,6 +62,7 @@ struct btrfs_pending_snapshot {
 	struct btrfs_block_rsv block_rsv;
 	/* extra metadata reseration for relocation */
 	int error;
+	bool readonly;
 	struct list_head list;
 };
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 698fdd2..a577653 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -316,6 +316,15 @@ ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
 int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		   size_t size, int flags)
 {
+	struct btrfs_root *root = BTRFS_I(dentry->d_inode)->root;
+
+	/*
+	 * The permission on security.* and system.* is not checked
+	 * in permission().
+	 */
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	/*
 	 * If this is a request for a synthetic attribute in the system.*
 	 * namespace use the generic infrastructure to resolve a handler
@@ -336,6 +345,15 @@ int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 
 int btrfs_removexattr(struct dentry *dentry, const char *name)
 {
+	struct btrfs_root *root = BTRFS_I(dentry->d_inode)->root;
+
+	/*
+	 * The permission on security.* and system.* is not checked
+	 * in permission().
+	 */
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	/*
 	 * If this is a request for a synthetic attribute in the system.*
 	 * namespace use the generic infrastructure to resolve a handler
-- 
1.6.3
