From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/2 v3] Btrfs: Per file/directory controls for COW and compression
Date: Tue, 22 Mar 2011 18:12:20 +0800
Message-ID: <4D887604.7030808@cn.fujitsu.com>
References: <4D8712E9.108@cn.fujitsu.com> <20110321174348.GC8235@granier.hd.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Johann Lombardi <johann@whamcloud.com>,
	Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110321174348.GC8235@granier.hd.free.fr>
List-ID: <linux-btrfs.vger.kernel.org>


From: Liu Bo <liubo2009@cn.fujitsu.com>

Subject: [PATCH 2/2 v3] Btrfs: Per file/directory controls for COW and compression

Data compression and data cow are controlled across the entire FS by mount
options right now.  ioctls are needed to set this on a per file or per
directory basis.  This has been proposed previously, but VFS developers
wanted us to use generic ioctls rather than btrfs-specific ones.

According to Chris's comment, there should be just one true compression
method(probably LZO) stored in the super.  However, before this, we would
wait for that one method is stable enough to be adopted into the super.
So I list it as a long term goal, and just store it in ram today.

After applying this patch, we can use the generic "FS_IOC_SETFLAGS" ioctl to
control file and directory's datacow and compression attribute.

NOTE:
 - The compression type is selected by such rules:
   If we mount btrfs with compress options, ie, zlib/lzo, the type is it.
   Otherwise, we'll use the default compress type (zlib today).

v1->v2:
- rebase to the latest btrfs.
v2->v3:
- fix a problem, i.e. when a file is set NOCOW via mount option, then this NOCOW
  will be screwed by inheritance from parent directory.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/disk-io.c |    6 ++++++
 fs/btrfs/inode.c   |   31 ++++++++++++++++++++++++++++---
 fs/btrfs/ioctl.c   |   41 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b4b9d1..b77d1a5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1283,6 +1283,7 @@ struct btrfs_root {
 #define BTRFS_INODE_NODUMP		(1 << 8)
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
+#define BTRFS_INODE_COMPRESS		(1 << 11)
 
 /* some macros to generate set/get funcs for the struct fields.  This
  * assumes there is a lefoo_to_cpu for every type, so lets make a simple
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e1ea3e..a894c12 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1762,6 +1762,12 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
 
+	/*
+	 * In the long term, we'll store the compression type in the super
+	 * block, and it'll be used for per file compression control.
+	 */
+	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
+
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
 		err = ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db67821..2d9910d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -381,7 +381,8 @@ again:
 	 */
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
 	    (btrfs_test_opt(root, COMPRESS) ||
-	     (BTRFS_I(inode)->force_compress))) {
+	     (BTRFS_I(inode)->force_compress) ||
+	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
 
@@ -1253,7 +1254,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
 	else if (!btrfs_test_opt(root, COMPRESS) &&
-		 !(BTRFS_I(inode)->force_compress))
+		 !(BTRFS_I(inode)->force_compress) &&
+		 !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
 	else
@@ -4586,7 +4588,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if ((mode & S_IFREG)) {
 		if (btrfs_test_opt(root, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
-		if (btrfs_test_opt(root, NODATACOW))
+		if (btrfs_test_opt(root, NODATACOW) ||
+		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 	}
 
@@ -6803,6 +6806,26 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	return 0;
 }
 
+/*
+ * If a file is moved, it will inherit the cow and compression flags of the new
+ * directory.
+ */
+static void fixup_inode_flags(struct inode *dir, struct inode *inode)
+{
+	struct btrfs_inode *b_dir = BTRFS_I(dir);
+	struct btrfs_inode *b_inode = BTRFS_I(inode);
+
+	if (b_dir->flags & BTRFS_INODE_NODATACOW)
+		b_inode->flags |= BTRFS_INODE_NODATACOW;
+	else
+		b_inode->flags &= ~BTRFS_INODE_NODATACOW;
+
+	if (b_dir->flags & BTRFS_INODE_COMPRESS)
+		b_inode->flags |= BTRFS_INODE_COMPRESS;
+	else
+		b_inode->flags &= ~BTRFS_INODE_COMPRESS;
+}
+
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry)
 {
@@ -6936,6 +6959,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
+	fixup_inode_flags(new_dir, old_inode);
+
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 0, index);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5fdb2ab..93e7f6c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -138,6 +138,24 @@ static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 	return 0;
 }
 
+static int check_flags(unsigned int flags)
+{
+	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
+		      FS_NOATIME_FL | FS_NODUMP_FL | \
+		      FS_SYNC_FL | FS_DIRSYNC_FL | \
+		      FS_NOCOMP_FL | FS_COMPR_FL | \
+		      FS_NOCOW_FL | FS_COW_FL))
+		return -EOPNOTSUPP;
+
+	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
+		return -EINVAL;
+
+	if ((flags & FS_NOCOW_FL) && (flags & FS_COW_FL))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -153,10 +171,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (copy_from_user(&flags, arg, sizeof(flags)))
 		return -EFAULT;
 
-	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
-		      FS_NOATIME_FL | FS_NODUMP_FL | \
-		      FS_SYNC_FL | FS_DIRSYNC_FL))
-		return -EOPNOTSUPP;
+	ret = check_flags(flags);
+	if (ret)
+		return ret;
 
 	if (!is_owner_or_cap(inode))
 		return -EACCES;
@@ -201,6 +218,22 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	else
 		ip->flags &= ~BTRFS_INODE_DIRSYNC;
 
+	/*
+	 * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
+	 * flag may be changed automatically if compression code won't make
+	 * things smaller.
+	 */
+	if (flags & FS_NOCOMP_FL) {
+		ip->flags &= ~BTRFS_INODE_COMPRESS;
+		ip->flags |= BTRFS_INODE_NOCOMPRESS;
+	} else if (flags & FS_COMPR_FL) {
+		ip->flags |= BTRFS_INODE_COMPRESS;
+		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
+	}
+	if (flags & FS_NOCOW_FL)
+		ip->flags |= BTRFS_INODE_NODATACOW;
+	else if (flags & FS_COW_FL)
+		ip->flags &= ~BTRFS_INODE_NODATACOW;
 
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
-- 
1.6.5.2
