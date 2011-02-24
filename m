From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH] Btrfs: add ioctl to set compress or cow per file/dir
Date: Thu, 24 Feb 2011 17:40:55 +0800
Message-ID: <4D6627A7.7050001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Data compression and data cow are controlled across the entire FS by mount
options right now.  ioctls are needed to set this on a per file or per
directory basis.  This has been proposed previously, but VFS developers
wanted us to use generic ioctls rather than btrfs-specific ones.

We need to fit these into the existing per-inode flags, and to use the generic
FS_IOCTL_SETFLAGS ioctl.  For data compression, there are the existing
compression flags of vfs inode, while for datacow, there is no flag to
indicate it, which we need to add.
So, what we will do is to add datacow flag in vfs inode flags and then to
set or to unset btrfs compress/cow flag on the corresponding btrfs inode's flag
per file or per directory.  Moreover, we also add a compression type ioctl to
make this feature more flexible.

I really expect some advices and comments on the followings:

- In this patch, I made a special ioctl to set compress type, and to record
  the compress_type per inode on disk, I've consumed some reserved space of
  btrfs_inode_item, so is this acceptable?
  Meanwhile, I got another idea from my collegue, could we just owe the whole
  compress type thing to new proper mount options, ie,
  mount xxx xxx -o compress=a,inode_compress=b?
  Seems that this makes mount more flexible.

- When we are inclined to set inode's compression type, should it be a "force"
  mode?
  This is much like the difference between mount as compress and mount as
  compress-force.

- For directory basis, after compress/cow ioctl on it, any files that are
  created or renamed in it, or moved into it, will inherit the directory's
  compress and datacow attribute.
  Here comes to some disputes, is it right that renamed and moved files
  also inherit the father directory's compress & datacow attribute?
  And if what we are dealing with is directory, should this behaviour be
  recursive or not?
  I'm inclined to leave these recursive things to btrfs-progs if this is
  necessary.

After this patch, I'll fulfill the corresponding btrfs-progs.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |    9 +++++-
 fs/btrfs/inode.c   |   37 ++++++++++++++++++++++++-
 fs/btrfs/ioctl.c   |   76 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ioctl.h   |    1 +
 include/linux/fs.h |    2 +
 5 files changed, 119 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7219537..c189183 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -587,11 +587,16 @@ struct btrfs_inode_item {
 	/* modification sequence number for NFS */
 	__le64 sequence;
 
+	u8 compress_type;
+
 	/*
 	 * a little future expansion, for more than this we can
 	 * just grow the inode item and version it
 	 */
-	__le64 reserved[4];
+	u8 reserved_8;
+	__le16 reserved_16;
+	__le32 reserved_32;
+	__le64 reserved_64[3];
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
 	struct btrfs_timespec mtime;
@@ -1478,6 +1483,8 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_FUNCS(inode_compress_type, struct btrfs_inode_item,
+						 compress_type, 8);
 
 static inline struct btrfs_timespec *
 btrfs_inode_atime(struct btrfs_inode_item *inode_item)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c9bc0af..0e11ad3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2515,6 +2515,9 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	BTRFS_I(inode)->block_group = btrfs_find_block_group(root, 0,
 						alloc_group_block, 0);
 	btrfs_free_path(path);
+
+	BTRFS_I(inode)->force_compress = btrfs_inode_compress_type(leaf,
+								   inode_item);
 	inode_item = NULL;
 
 	switch (inode->i_mode & S_IFMT) {
@@ -2587,6 +2590,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
 	btrfs_set_inode_block_group(leaf, item, BTRFS_I(inode)->block_group);
+	btrfs_set_inode_compress_type(leaf, item,
+				      BTRFS_I(inode)->force_compress);
 }
 
 /*
@@ -4539,6 +4544,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->block_group =
 			btrfs_find_block_group(root, 0, alloc_hint, owner);
 
+	BTRFS_I(inode)->force_compress = BTRFS_I(dir)->force_compress;
+
 	key[0].objectid = objectid;
 	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
 	key[0].offset = 0;
@@ -4578,8 +4585,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	location->offset = 0;
 	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
 
-	btrfs_inherit_iflags(inode, dir);
-
 	if ((mode & S_IFREG)) {
 		if (btrfs_test_opt(root, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
@@ -4587,6 +4592,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 	}
 
+	btrfs_inherit_iflags(inode, dir);
+
 	insert_inode_hash(inode);
 	inode_tree_add(inode);
 	return inode;
@@ -6676,6 +6683,30 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	return 0;
 }
 
+/*
+ * If directory is set by cow/compress ioctl, files that be moved/renamed here
+ * will update their inode flags.
+ */
+static inline void btrfs_change_cow_and_compress(struct inode *dir,
+						 struct inode *inode)
+{
+	struct btrfs_inode *b_dir = BTRFS_I(dir);
+	struct btrfs_inode *b_inode = BTRFS_I(inode);
+
+	if (b_dir->flags & BTRFS_INODE_NODATACOW)
+		b_inode->flags |= BTRFS_INODE_NODATACOW;
+	else
+		b_inode->flags &= ~BTRFS_INODE_NODATACOW;
+
+	if (b_dir->flags & BTRFS_INODE_NOCOMPRESS) {
+		b_inode->flags |= BTRFS_INODE_NOCOMPRESS;
+		b_inode->force_compress = BTRFS_COMPRESS_NONE;
+	} else {
+		b_inode->flags &= ~BTRFS_INODE_NOCOMPRESS;
+		b_inode->force_compress = b_dir->force_compress;
+	}
+}
+
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry)
 {
@@ -6809,6 +6840,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
+	btrfs_change_cow_and_compress(new_dir, old_inode);
+
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 0, index);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e397da4..1bb562a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -155,7 +155,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
-		      FS_SYNC_FL | FS_DIRSYNC_FL))
+		      FS_SYNC_FL | FS_DIRSYNC_FL | \
+		      FS_NOCOMP_FL | FS_COMPR_FL | \
+		      FS_NOCOW_FL | FS_COW_FL))
 		return -EOPNOTSUPP;
 
 	if (!is_owner_or_cap(inode))
@@ -163,8 +165,19 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	mutex_lock(&inode->i_mutex);
 
-	flags = btrfs_mask_flags(inode->i_mode, flags);
 	oldflags = btrfs_flags_to_ioctl(ip->flags);
+	/* for compress, get original inode flag first */
+	if (flags & FS_NOCOMP_FL || flags & FS_COMPR_FL ||
+	    flags & FS_NOCOW_FL || flags & FS_COW_FL) {
+		if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+
+		flags |= oldflags;
+	}
+
+	flags = btrfs_mask_flags(inode->i_mode, flags);
 	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
 		if (!capable(CAP_LINUX_IMMUTABLE)) {
 			ret = -EPERM;
@@ -200,7 +213,14 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ip->flags |= BTRFS_INODE_DIRSYNC;
 	else
 		ip->flags &= ~BTRFS_INODE_DIRSYNC;
-
+	if (flags & FS_NOCOMP_FL)
+		ip->flags |= BTRFS_INODE_NOCOMPRESS;
+	else if (flags & FS_COMPR_FL)
+		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
+	if (flags & FS_NOCOW_FL)
+		ip->flags |= BTRFS_INODE_NODATACOW;
+	else if (flags & FS_COW_FL)
+		ip->flags &= ~BTRFS_INODE_NODATACOW;
 
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
@@ -2368,6 +2388,54 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+static noinline long btrfs_ioctl_set_compress_type(struct file *file,
+						   void __user *argp)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct btrfs_inode *ip = BTRFS_I(inode);
+	struct btrfs_root *root = ip->root;
+	struct btrfs_trans_handle *trans;
+	unsigned int type;
+	int ret;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+		return -EINVAL;
+
+	if (copy_from_user(&type, argp, sizeof(type)))
+		return -EFAULT;
+
+	if (type == BTRFS_COMPRESS_NONE || type > BTRFS_COMPRESS_TYPES)
+		return -EINVAL;
+
+	mutex_lock(&inode->i_mutex);
+
+	ret = mnt_want_write(file->f_vfsmnt);
+	if (ret)
+		goto out_unlock;
+
+	/* compress type: zlib, lzo, NONE */
+	ip->force_compress = type;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		mnt_drop_write(file->f_vfsmnt);
+		goto out_unlock;
+	}
+
+	ret = btrfs_update_inode(trans, root, inode);
+
+	inode->i_ctime = CURRENT_TIME;
+	btrfs_end_transaction(trans, root);
+
+	mnt_drop_write(file->f_vfsmnt);
+out_unlock:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2428,6 +2496,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_start_sync(file, argp);
 	case BTRFS_IOC_WAIT_SYNC:
 		return btrfs_ioctl_wait_sync(file, argp);
+	case BTRFS_IOC_SET_COMPRESS_TYPE:
+		return btrfs_ioctl_set_compress_type(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 8fb3821..a45a0b7 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -203,4 +203,5 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
+#define BTRFS_IOC_SET_COMPRESS_TYPE _IOW(BTRFS_IOCTL_MAGIC, 27, unsigned int)
 #endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..235c75e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -353,6 +353,8 @@ struct inodes_stat_t {
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_NOCOW_FL			0x00200000 /* Do not cow file */
+#define FS_COW_FL			0x00100000 /* Cow file */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-- 
1.6.5.2
