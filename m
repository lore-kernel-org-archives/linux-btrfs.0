From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/5] btrfs: Add readonly snapshots support
Date: Mon, 29 Nov 2010 16:03:38 +0800
Message-ID: <4CF35E5A.6080208@cn.fujitsu.com>
References: <4CF35E17.6050705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF35E17.6050705@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Usage:

Set BTRFS_SNAPSHOT_CREATE_RDONLY of btrfs_ioctl_vol_arg_v2->flags,
and call ioctl(BTRFS_I0CTL_SNAP_CREATE_V2).

Implementation:

- In disk set readonly bit of btrfs_root_item->flags, and in memory
set btrfs_root->readonly.

- Add readonly checks in btrfs_permission (inode_permission),
btrfs_setattr, btrfs_set/remove_xattr and some ioctls.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    3 +++
 fs/btrfs/disk-io.c     |    5 +++++
 fs/btrfs/inode.c       |    8 ++++++++
 fs/btrfs/ioctl.c       |   33 +++++++++++++++++++++++++--------
 fs/btrfs/ioctl.h       |    1 +
 fs/btrfs/transaction.c |    8 ++++++++
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/xattr.c       |   18 ++++++++++++++++++
 8 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8db9234..4b263ed 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -597,6 +597,8 @@ struct btrfs_dir_item {
 	u8 type;
 } __attribute__ ((__packed__));
 
+#define BTRFS_ROOT_SNAP_RDONLY	(1ULL << 0)
+
 struct btrfs_root_item {
 	struct btrfs_inode_item inode;
 	__le64 generation;
@@ -1116,6 +1118,7 @@ struct btrfs_root {
 	int defrag_running;
 	char *name;
 	int in_sysfs;
+	bool readonly;
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fb650e0..5b88712 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -963,6 +963,7 @@ static void __setup_root_post(struct btrfs_root *root)
 {
 	u32 blocksize;
 	u64 generation;
+	u64 flags;
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
@@ -970,6 +971,10 @@ static void __setup_root_post(struct btrfs_root *root)
 				     blocksize, generation);
 	BUG_ON(!root->node);
 	root->commit_root = btrfs_root_node(root);
+
+	flags = btrfs_root_flags(&root->root_item);
+	if (flags & BTRFS_ROOT_SNAP_RDONLY)
+		root->readonly = true;
 }
 
 static int find_and_setup_root(struct btrfs_root *tree_root,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5132c9a..08c3075 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3671,8 +3671,12 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int err;
 
+	if (root->readonly)
+		return -EROFS;
+
 	err = inode_change_ok(inode, attr);
 	if (err)
 		return err;
@@ -7028,6 +7032,10 @@ static int btrfs_set_page_dirty(struct page *page)
 
 static int btrfs_permission(struct inode *inode, int mask)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (root->readonly && (mask & MAY_WRITE))
+		return -EROFS;
 	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
 	return generic_permission(inode, mask, btrfs_check_acl);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ba437ad..7f9c571 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -147,6 +147,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	unsigned int flags, oldflags;
 	int ret;
 
+	if (root->readonly)
+		return -EROFS;
+
 	if (copy_from_user(&flags, arg, sizeof(flags)))
 		return -EFAULT;
 
@@ -351,7 +354,8 @@ fail:
 }
 
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
-			   char *name, int namelen, u64 *async_transid)
+			   char *name, int namelen, u64 *async_transid,
+			   bool readonly)
 {
 	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
@@ -368,6 +372,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv);
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
+	pending_snapshot->readonly = readonly;
 
 	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
 	if (IS_ERR(trans)) {
@@ -497,7 +502,7 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
 static noinline int btrfs_mksubvol(struct path *parent,
 				   char *name, int namelen,
 				   struct btrfs_root *snap_src,
-				   u64 *async_transid)
+				   u64 *async_transid, bool readonly)
 {
 	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
@@ -529,7 +534,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 
 	if (snap_src) {
 		error = create_snapshot(snap_src, dentry,
-					name, namelen, async_transid);
+					name, namelen, async_transid, readonly);
 	} else {
 		error = create_subvol(BTRFS_I(dir)->root, dentry,
 				      name, namelen, async_transid);
@@ -889,7 +894,8 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 						    char *name,
 						    unsigned long fd,
 						    int subvol,
-						    u64 *transid)
+						    u64 *transid,
+						    bool readonly)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct file *src_file;
@@ -907,7 +913,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 
 	if (subvol) {
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
-				     NULL, transid);
+				     NULL, transid, readonly);
 	} else {
 		struct inode *src_inode;
 		src_file = fget(fd);
@@ -926,7 +932,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		}
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
 				     BTRFS_I(src_inode)->root,
-				     transid);
+				     transid, readonly);
 		fput(src_file);
 	}
 out:
@@ -943,6 +949,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 	u64 fd;
 	u64 transid = 0;
 	bool async = false;
+	bool readonly = false;
 	int ret;
 
 	if (v2) {
@@ -950,7 +957,8 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		if (IS_ERR(vol_args_v2))
 			return PTR_ERR(vol_args_v2);
 
-		if (vol_args_v2->flags & ~BTRFS_SNAPSHOT_CREATE_ASYNC) {
+		if (vol_args_v2->flags &
+		    ~(BTRFS_SNAPSHOT_CREATE_ASYNC | BTRFS_SNAPSHOT_RDONLY)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -960,6 +968,8 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		vol_args_v2->name[BTRFS_SNAPSHOT_NAME_MAX] = '\0';
 		if (vol_args_v2->flags & BTRFS_SNAPSHOT_CREATE_ASYNC)
 			async = true;
+		if (vol_args_v2->flags & BTRFS_SNAPSHOT_RDONLY)
+			readonly = true;
 	} else {
 		vol_args = memdup_user(arg, sizeof(*vol_args));
 		if (IS_ERR(vol_args))
@@ -970,7 +980,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 	}
 
 	ret = btrfs_ioctl_snap_create_transid(file, name, fd,
-					      subvol, &transid);
+					      subvol, &transid, readonly);
 
 	if (!ret && async) {
 		if (copy_to_user(arg +
@@ -1621,6 +1631,9 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
 		return -EINVAL;
 
+	if (root->readonly)
+		return -EROFS;
+
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
 		return ret;
@@ -1943,6 +1956,10 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	if (file->private_data)
 		goto out;
 
+	ret = -EROFS;
+	if (root->readonly)
+		goto out;
+
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
 		goto out;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index bc70584..ff15fb2 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -31,6 +31,7 @@ struct btrfs_ioctl_vol_args {
 };
 
 #define BTRFS_SNAPSHOT_CREATE_ASYNC	(1ULL << 0)
+#define BTRFS_SNAPSHOT_RDONLY		(1ULL << 1)
 
 #define BTRFS_SNAPSHOT_NAME_MAX 4039
 struct btrfs_ioctl_vol_args_v2 {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1fffbc0..fe85149 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -909,6 +909,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 to_reserve = 0;
 	u64 index = 0;
 	u64 objectid;
+	u64 root_flags;
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
@@ -965,6 +966,13 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
+	root_flags = btrfs_root_flags(new_root_item);
+	if (pending->readonly)
+		root_flags |= BTRFS_ROOT_SNAP_RDONLY;
+	else
+		root_flags &= ~BTRFS_ROOT_SNAP_RDONLY;
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
index 698fdd2..858ad4a 100644
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
+	if (root->readonly)
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
+	if (root->readonly)
+		return -EROFS;
+
 	/*
 	 * If this is a request for a synthetic attribute in the system.*
 	 * namespace use the generic infrastructure to resolve a handler
-- 
1.6.3

