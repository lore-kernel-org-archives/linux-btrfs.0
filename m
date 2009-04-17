From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Fri, 17 Apr 2009 10:37:41 +0200
Message-ID: <20090417083741.GA14933@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add support for the standard attributes set via chattr and read vis
lsattr.  Currently we store the attributes in the flags value in
the btrfs inode, but I wonder whether we should split it into two so
that we don't have to keep converting between the two formats.

Remove the btrfs_clear_flag/btrfs_set_flag/btrfs_test_flag macros
as they were obsfuction the existing code and got in the way of the
new additions.

Also add the FS_IOC_GETVERSION ioctl for getting i_generation as it's
trivial.

Btw, any idea what the BTRFS_INODE_REDONLY flag is for?  It's a subset
of the immutable flag, but can't actually be set anywhere from the
filesystem code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/btrfs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/btrfs/ioctl.c	2009-04-17 10:08:11.758948607 +0200
+++ linux-2.6/fs/btrfs/ioctl.c	2009-04-17 10:33:21.555076930 +0200
@@ -50,7 +50,172 @@
 #include "volumes.h"
 #include "locking.h"
 
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & ~FS_DIRSYNC_FL;
+	else
+		return flags & (FS_NODUMP_FL | FS_NOATIME_FL);
+}
+
+/*
+ * Export inode flags to the format expected by the FS_IOC_GETFLAGS ioctl.
+ */
+static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
+{
+	unsigned int iflags = 0;
+
+	if (flags & BTRFS_INODE_SYNC)
+		iflags |= FS_SYNC_FL;
+	if (flags & BTRFS_INODE_IMMUTABLE)
+		iflags |= FS_IMMUTABLE_FL;
+	if (flags & BTRFS_INODE_APPEND)
+		iflags |= FS_APPEND_FL;
+	if (flags & BTRFS_INODE_NODUMP)
+		iflags |= FS_NODUMP_FL;
+	if (flags & BTRFS_INODE_NOATIME)
+		iflags |= FS_NOATIME_FL;
+	if (flags & BTRFS_INODE_DIRSYNC)
+		iflags |= FS_DIRSYNC_FL;
+
+	return iflags;
+}
+
+/*
+ * Update inode->i_flags based on the btrfs internal flags.
+ */
+void btrfs_update_iflags(struct inode *inode)
+{
+	struct btrfs_inode *ip = BTRFS_I(inode);
+
+	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+
+	if (ip->flags & BTRFS_INODE_SYNC)
+		inode->i_flags |= S_SYNC;
+	if (ip->flags & BTRFS_INODE_IMMUTABLE)
+		inode->i_flags |= S_IMMUTABLE;
+	if (ip->flags & BTRFS_INODE_APPEND)
+		inode->i_flags |= S_APPEND;
+	if (ip->flags & BTRFS_INODE_NOATIME)
+		inode->i_flags |= S_NOATIME;
+	if (ip->flags & BTRFS_INODE_DIRSYNC)
+		inode->i_flags |= S_DIRSYNC;
+}
+
+/*
+ * Inherit flags from the parent inode.
+ *
+ * Unlike extN we don't have any flags we don't want to inherit currently.
+ */
+void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
+{
+	unsigned int flags = BTRFS_I(dir)->flags;
+
+	if (S_ISREG(inode->i_mode))
+		flags &= ~BTRFS_INODE_DIRSYNC;
+	else if (!S_ISDIR(inode->i_mode))
+		flags &= (BTRFS_INODE_NODUMP | BTRFS_INODE_NOATIME);
+
+	BTRFS_I(inode)->flags = flags;
+	btrfs_update_iflags(inode);
+}
+
+static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
+{
+	struct btrfs_inode *ip = BTRFS_I(file->f_path.dentry->d_inode);
+	unsigned int flags = btrfs_flags_to_ioctl(ip->flags);
+
+	if (copy_to_user(arg, &flags, sizeof(flags)))
+		return -EFAULT;
+	return 0;
+}
+
+static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct btrfs_inode *ip = BTRFS_I(inode);
+	struct btrfs_root *root = ip->root;
+	struct btrfs_trans_handle *trans;
+	unsigned int flags, oldflags;
+	int ret;
+
+	if (copy_from_user(&flags, arg, sizeof(flags)))
+		return -EFAULT;
 
+	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
+		      FS_NOATIME_FL | FS_NODUMP_FL | \
+		      FS_SYNC_FL | FS_DIRSYNC_FL))
+		return -EOPNOTSUPP;
+
+	if (!is_owner_or_cap(inode))
+		return -EACCES;
+
+	mutex_lock(&inode->i_mutex);
+
+	flags = btrfs_mask_flags(inode->i_mode, flags);
+	oldflags = btrfs_flags_to_ioctl(ip->flags);
+	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+		if (!capable(CAP_LINUX_IMMUTABLE)) {
+			ret = -EPERM;
+			goto out_unlock;
+		}
+	}
+
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		goto out_unlock;
+
+	if (flags & FS_SYNC_FL)
+		ip->flags |= BTRFS_INODE_SYNC;
+	else
+		ip->flags &= ~BTRFS_INODE_SYNC;
+	if (flags & FS_IMMUTABLE_FL)
+		ip->flags |= BTRFS_INODE_IMMUTABLE;
+	else
+		ip->flags &= ~BTRFS_INODE_IMMUTABLE;
+	if (flags & FS_APPEND_FL)
+		ip->flags |= BTRFS_INODE_APPEND;
+	else
+		ip->flags &= ~BTRFS_INODE_APPEND;
+	if (flags & FS_NODUMP_FL)
+		ip->flags |= BTRFS_INODE_NODUMP;
+	else
+		ip->flags &= ~BTRFS_INODE_NODUMP;
+	if (flags & FS_NOATIME_FL)
+		ip->flags |= BTRFS_INODE_NOATIME;
+	else
+		ip->flags &= ~BTRFS_INODE_NOATIME;
+	if (flags & FS_DIRSYNC_FL)
+		ip->flags |= BTRFS_INODE_DIRSYNC;
+	else
+		ip->flags &= ~BTRFS_INODE_DIRSYNC;
+
+
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);
+
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
+
+	btrfs_update_iflags(inode);
+	inode->i_ctime = CURRENT_TIME;
+	btrfs_end_transaction(trans, root);
+
+	mnt_drop_write(file->f_path.mnt);
+ out_unlock:
+	mutex_unlock(&inode->i_mutex);
+	return 0;
+}
+
+static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	return put_user(inode->i_generation, arg);
+}
 
 static noinline int create_subvol(struct btrfs_root *root,
 				  struct dentry *dentry,
@@ -1100,6 +1265,12 @@ long btrfs_ioctl(struct file *file, unsi
 	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		return btrfs_ioctl_getflags(file, argp);
+	case FS_IOC_SETFLAGS:
+		return btrfs_ioctl_setflags(file, argp);
+	case FS_IOC_GETVERSION:
+		return btrfs_ioctl_getversion(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 0);
 	case BTRFS_IOC_SUBVOL_CREATE:
Index: linux-2.6/fs/btrfs/btrfs_inode.h
===================================================================
--- linux-2.6.orig/fs/btrfs/btrfs_inode.h	2009-04-17 10:08:11.780949312 +0200
+++ linux-2.6/fs/btrfs/btrfs_inode.h	2009-04-17 10:08:22.695949315 +0200
@@ -154,5 +154,4 @@ static inline void btrfs_i_size_write(st
 	BTRFS_I(inode)->disk_i_size = size;
 }
 
-
 #endif
Index: linux-2.6/fs/btrfs/compression.c
===================================================================
--- linux-2.6.orig/fs/btrfs/compression.c	2009-04-17 10:08:11.763948615 +0200
+++ linux-2.6/fs/btrfs/compression.c	2009-04-17 10:08:22.695949315 +0200
@@ -123,7 +123,7 @@ static int check_compressed_csum(struct 
 	u32 csum;
 	u32 *cb_sum = &cb->sums;
 
-	if (btrfs_test_flag(inode, NODATASUM))
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		return 0;
 
 	for (i = 0; i < cb->nr_pages; i++) {
@@ -670,7 +670,7 @@ int btrfs_submit_compressed_read(struct 
 			 */
 			atomic_inc(&cb->pending_bios);
 
-			if (!btrfs_test_flag(inode, NODATASUM)) {
+			if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
 				btrfs_lookup_bio_sums(root, inode, comp_bio,
 						      sums);
 			}
@@ -697,7 +697,7 @@ int btrfs_submit_compressed_read(struct 
 	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
 	BUG_ON(ret);
 
-	if (!btrfs_test_flag(inode, NODATASUM))
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
 		btrfs_lookup_bio_sums(root, inode, comp_bio, sums);
 
 	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
Index: linux-2.6/fs/btrfs/ctree.h
===================================================================
--- linux-2.6.orig/fs/btrfs/ctree.h	2009-04-17 10:08:11.767948635 +0200
+++ linux-2.6/fs/btrfs/ctree.h	2009-04-17 10:08:22.696949652 +0200
@@ -1053,12 +1053,14 @@ struct btrfs_root {
 #define BTRFS_INODE_READONLY		(1 << 2)
 #define BTRFS_INODE_NOCOMPRESS		(1 << 3)
 #define BTRFS_INODE_PREALLOC		(1 << 4)
-#define btrfs_clear_flag(inode, flag)	(BTRFS_I(inode)->flags &= \
-					 ~BTRFS_INODE_##flag)
-#define btrfs_set_flag(inode, flag)	(BTRFS_I(inode)->flags |= \
-					 BTRFS_INODE_##flag)
-#define btrfs_test_flag(inode, flag)	(BTRFS_I(inode)->flags & \
-					 BTRFS_INODE_##flag)
+#define BTRFS_INODE_SYNC		(1 << 5)
+#define BTRFS_INODE_IMMUTABLE		(1 << 6)
+#define BTRFS_INODE_APPEND		(1 << 7)
+#define BTRFS_INODE_NODUMP		(1 << 8)
+#define BTRFS_INODE_NOATIME		(1 << 9)
+#define BTRFS_INODE_DIRSYNC		(1 << 10)
+
+
 /* some macros to generate set/get funcs for the struct fields.  This
  * assumes there is a lefoo_to_cpu for every type, so lets make a simple
  * one for u8:
@@ -2165,6 +2167,8 @@ int btrfs_cont_expand(struct inode *inod
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+void btrfs_update_iflags(struct inode *inode);
+void btrfs_inherit_iflags(struct inode *inode, struct inode *dir);
 
 /* file.c */
 int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync);
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2009-04-17 10:08:11.772948713 +0200
+++ linux-2.6/fs/btrfs/inode.c	2009-04-17 10:08:22.700949323 +0200
@@ -370,7 +370,7 @@ again:
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (!btrfs_test_flag(inode, NOCOMPRESS) &&
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
 	    btrfs_test_opt(root, COMPRESS)) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
@@ -471,7 +471,7 @@ again:
 		nr_pages_ret = 0;
 
 		/* flag the file so we don't compress in the future */
-		btrfs_set_flag(inode, NOCOMPRESS);
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
 	}
 	if (will_compress) {
 		*num_added += 1;
@@ -864,7 +864,7 @@ static int cow_file_range_async(struct i
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 
-		if (btrfs_test_flag(inode, NOCOMPRESS))
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
 			cur_end = end;
 		else
 			cur_end = min(end, start + 512 * 1024 - 1);
@@ -1132,10 +1132,10 @@ static int run_delalloc_range(struct ino
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (btrfs_test_flag(inode, NODATACOW))
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
-	else if (btrfs_test_flag(inode, PREALLOC))
+	else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC)
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
 	else if (!btrfs_test_opt(root, COMPRESS))
@@ -1289,7 +1289,7 @@ static int btrfs_submit_bio_hook(struct 
 	int ret = 0;
 	int skip_sum;
 
-	skip_sum = btrfs_test_flag(inode, NODATASUM);
+	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
 	BUG_ON(ret);
@@ -1785,7 +1785,8 @@ static int btrfs_readpage_end_io_hook(st
 		ClearPageChecked(page);
 		goto good;
 	}
-	if (btrfs_test_flag(inode, NODATASUM))
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		return 0;
 
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
@@ -2097,6 +2098,8 @@ void btrfs_read_locked_inode(struct inod
 		init_special_inode(inode, inode->i_mode, rdev);
 		break;
 	}
+
+	btrfs_update_iflags(inode);
 	return;
 
 make_bad:
@@ -3505,9 +3508,9 @@ static struct inode *btrfs_new_inode(str
 			btrfs_find_block_group(root, 0, alloc_hint, owner);
 	if ((mode & S_IFREG)) {
 		if (btrfs_test_opt(root, NODATASUM))
-			btrfs_set_flag(inode, NODATASUM);
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 		if (btrfs_test_opt(root, NODATACOW))
-			btrfs_set_flag(inode, NODATACOW);
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 	}
 
 	key[0].objectid = objectid;
@@ -3561,6 +3564,8 @@ static struct inode *btrfs_new_inode(str
 	location->offset = 0;
 	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
 
+	btrfs_inherit_iflags(inode, dir);
+
 	insert_inode_hash(inode);
 	return inode;
 fail:
@@ -5003,7 +5008,7 @@ static int prealloc_file_range(struct in
 out:
 	if (cur_offset > start) {
 		inode->i_ctime = CURRENT_TIME;
-		btrfs_set_flag(inode, PREALLOC);
+		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    cur_offset > i_size_read(inode))
 			btrfs_i_size_write(inode, cur_offset);
@@ -5097,7 +5102,7 @@ static int btrfs_set_page_dirty(struct p
 
 static int btrfs_permission(struct inode *inode, int mask)
 {
-	if (btrfs_test_flag(inode, READONLY) && (mask & MAY_WRITE))
+	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask & MAY_WRITE))
 		return -EACCES;
 	return generic_permission(inode, mask, btrfs_check_acl);
 }
Reply-To: 

