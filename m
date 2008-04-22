From: Sage Weil <sage@newdream.net>
Subject: transaction ioctls
Date: Tue, 22 Apr 2008 13:12:35 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804221210130.23551__3201.57705941728$1208896753$gmane$org@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

These ioctls let a user application hold a transaction open while it 
performs a series of operations.  A final ioctl does a sync on the fs 
(closing the current transaction).  This is the main requirement for 
Ceph's OSD to be able to keep the data it's storing in a btrfs volume 
consistent, and AFAICS it works just fine.  The application would do 
something like

	fd = ::open("some/file", O_RDONLY);
	::ioctl(fd, BTRFS_IOC_TRANS_START);
	/* do a bunch of stuff */
	::ioctl(fd, BTRFS_IOC_TRANS_END);
or just
	::close(fd);

And to ensure it commits to disk,

	::ioctl(fd, BTRFS_IOC_SYNC);

When a transaction is held open, the trans_handle is attached to the 
struct file (via private_data) so that it will get cleaned up if the 
process dies unexpectedly.  A held transaction is also ended on fsync() to 
avoid a deadlock.  There may be other places I missed?  

A misbehaving application could also deliberately hold a transaction open, 
effectively locking up the FS, so it may make sense to restrict something 
like this to root or something.

Anyway, does this look reasonable?

Thanks-
sage



diff -r e4cd88595ed7 ctree.h
--- a/ctree.h	Thu Feb 21 14:54:12 2008 -0500
+++ b/ctree.h	Tue Apr 22 12:08:53 2008 -0700
@@ -1179,6 +1179,7 @@ void btrfs_destroy_inode(struct inode *i
 void btrfs_destroy_inode(struct inode *inode);
 int btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
+long btrfs_ioctl_trans_end(struct file *file);
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
 				struct btrfs_root *root);
@@ -1199,6 +1200,8 @@ int btrfs_drop_extents(struct btrfs_tran
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode,
 		       u64 start, u64 end, u64 inline_limit, u64 *hint_block);
+int btrfs_file_release(struct inode *inode, struct file *file);
+
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, int cache_only);
@@ -1217,4 +1220,5 @@ int btrfs_delete_xattrs(struct btrfs_tra
 			struct btrfs_root *root, struct inode *inode);
 /* super.c */
 u64 btrfs_parse_size(char *str);
+int btrfs_sync_fs(struct super_block *sb, int wait);
 #endif
diff -r e4cd88595ed7 file.c
--- a/file.c	Thu Feb 21 14:54:12 2008 -0500
+++ b/file.c	Tue Apr 22 12:08:53 2008 -0700
@@ -941,6 +941,8 @@ static int btrfs_sync_file(struct file *
 	/*
 	 * ok we haven't committed the transaction yet, lets do a commit
 	 */
+	if (file->private_data)
+		btrfs_ioctl_trans_end(file);
 	trans = btrfs_start_transaction(root, 1);
 	if (!trans) {
 		ret = -ENOMEM;
@@ -950,6 +952,13 @@ out:
 out:
 	mutex_unlock(&root->fs_info->fs_mutex);
 	return ret > 0 ? EIO : ret;
+}
+
+int btrfs_file_release(struct inode *inode, struct file *file)
+{
+	if (file->private_data)
+		btrfs_ioctl_trans_end(file);
+	return 0;
 }
 
 static struct vm_operations_struct btrfs_file_vm_ops = {
@@ -980,6 +989,7 @@ struct file_operations btrfs_file_operat
 	.write		= btrfs_file_write,
 	.mmap		= btrfs_file_mmap,
 	.open		= generic_file_open,
+	.release        = btrfs_file_release,
 	.fsync		= btrfs_sync_file,
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
diff -r e4cd88595ed7 inode.c
--- a/inode.c	Thu Feb 21 14:54:12 2008 -0500
+++ b/inode.c	Tue Apr 22 12:08:53 2008 -0700
@@ -2690,6 +2690,42 @@ static int btrfs_ioctl_defrag(struct fil
 	return 0;
 }
 
+long btrfs_ioctl_trans_start(struct file *file)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	int ret = 0;
+
+	if (file->private_data)
+		return -EINPROGRESS;
+	mutex_lock(&root->fs_info->fs_mutex);
+	trans = btrfs_start_transaction(root, 0);
+	if (trans)
+		file->private_data = trans;
+	else
+		ret = -ENOMEM;
+	/*printk(KERN_INFO "btrfs_ioctl_trans_start on %p\n", file);*/
+	mutex_unlock(&root->fs_info->fs_mutex);
+	return ret;
+}
+
+long btrfs_ioctl_trans_end(struct file *file)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans = file->private_data;
+
+	if (!trans)
+		return -EINVAL;
+	/*printk(KERN_INFO "btrfs_ioctl_trans_end on %p\n", file);*/
+	mutex_lock(&root->fs_info->fs_mutex);
+	btrfs_end_transaction(trans, root);
+	file->private_data = 0;
+	mutex_unlock(&root->fs_info->fs_mutex);
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2702,6 +2738,13 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_defrag(file);
 	case BTRFS_IOC_RESIZE:
 		return btrfs_ioctl_resize(root, (void __user *)arg);
+	case BTRFS_IOC_TRANS_START:
+		return btrfs_ioctl_trans_start(file);
+	case BTRFS_IOC_TRANS_END:
+		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_SYNC:
+		btrfs_sync_fs(file->f_dentry->d_sb, 1);
+		return 0;
 	}
 
 	return -ENOTTY;
@@ -3019,6 +3062,7 @@ static struct file_operations btrfs_dir_
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_ioctl,
 #endif
+	.release        = btrfs_file_release,
 };
 
 static struct extent_io_ops btrfs_extent_io_ops = {
diff -r e4cd88595ed7 ioctl.h
--- a/ioctl.h	Thu Feb 21 14:54:12 2008 -0500
+++ b/ioctl.h	Tue Apr 22 12:08:53 2008 -0700
@@ -32,4 +32,9 @@ struct btrfs_ioctl_vol_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_RESIZE _IOW(BTRFS_IOCTL_MAGIC, 3, \
 				   struct btrfs_ioctl_vol_args)
+
+#define BTRFS_IOC_TRANS_START  _IO(BTRFS_IOCTL_MAGIC, 6)
+#define BTRFS_IOC_TRANS_END    _IO(BTRFS_IOCTL_MAGIC, 7)
+#define BTRFS_IOC_SYNC         _IO(BTRFS_IOCTL_MAGIC, 8)
 #endif
+
diff -r e4cd88595ed7 super.c
--- a/super.c	Thu Feb 21 14:54:12 2008 -0500
+++ b/super.c	Tue Apr 22 12:08:53 2008 -0700
@@ -284,7 +284,7 @@ fail_close:
 	return err;
 }
 
-static int btrfs_sync_fs(struct super_block *sb, int wait)
+int btrfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
