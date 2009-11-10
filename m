From: Sage Weil <sage@newdream.net>
Subject: [RFC] big fat transaction ioctl
Date: Tue, 10 Nov 2009 12:12:14 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This is an alternative approach to atomic user transactions for btrfs.  
The old start/end ioctls suffer from some basic limitations, namely

 - We can't properly reserve space ahead of time to avoid ENOSPC part 
way through the transaction, and
 - The process may die (seg fault, SIGKILL) part way through the 
transaction.  Currently when that happens the partial transaction will 
commit.

This patch implements an ioctl that lets the application completely 
specify the entire transaction in a single syscall.  If the process gets 
killed or seg faults part way through, the entire transaction will still 
complete.

The goal is to atomically commit updates to multiple files, xattrs, 
directories.  But this is still a file system: we don't get rollback if 
things go wrong.  Instead, do what we can up front to make sure things 
will work out.  And if things do go wrong, optionally prevent a partial 
result from reaching the disk.

A few things:

 - The implementation just exports the sys_* calls it needs (a popular 
move, no doubt :).  I've looked at using the corresponding vfs_* 
instructions instead, and keeping a table of struct file *'s instead of 
fd's to avoid these exports, but this requires a large amount of 
duplication of semi-boilerplate path lookup, security_path_* hooks, and 
similar code from fs/namei.c and elsewhere.  If we want to go that 
route, there are some advantages, the main one being that we can verify 
that every dentry/inode we operate on belongs to the same fs.  But the 
code will be more complex... I'm not sure if I should pursue that just 
yet.

 - The application gets to define what defines a failure for each 
individual op based on its return value.

 - If the transaction fails, the process can instruct the fs to wedge 
itself so that a partial result does not commit.  This isn't a particuarly 
elegant approach, but a wedged fs may be preferable to a partial 
transaction commit.  (Alternatively, a failure could branch/jump to 
another point in the transaction op vector to do some cleanup and/or an 
explicit WEDGE op to accomplish the same thing?)

- This still uses the existing ioctl start transaction call.  Depending on 
how Josef's ENOSPC journal_info stuff works out, I should be able to avoid 
the current global open_ioctl_trans counter for a cleaner interaction with 
the btrfs transaction code.

- The data space reservation is still missing.  I need a way to 
find which space_info will be used, and pin it for the duration 
of the entire transaction.

- The metadata reservation is a worst case bound.  It could be less 
conservative, but currently each op is pulled out of the user address 
space individually so we'd either need two passes, a big kmalloc, or 
further trust the app to get the value right.  (Same goes for the data 
size, actually, although that's easier to get correct.)

Thoughts on this?

Thanks-
sage


Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |  187 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   49 ++++++++++++++
 fs/namei.c       |    3 +
 fs/open.c        |    2 +
 fs/read_write.c  |    2 +
 fs/xattr.c       |    2 +
 6 files changed, 245 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 136c5ed..4269616 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -37,6 +37,7 @@
 #include <linux/compat.h>
 #include <linux/bit_spinlock.h>
 #include <linux/security.h>
+#include <linux/syscalls.h>
 #include <linux/xattr.h>
 #include <linux/vmalloc.h>
 #include "compat.h"
@@ -1303,6 +1304,190 @@ long btrfs_ioctl_trans_end(struct file *file)
 	return 0;
 }
 
+/*
+ * return number of successfully complete ops via @ops_completed
+ * (where success/failure is defined by the _FAIL_* flags).
+ */
+static long do_usertrans(struct btrfs_root *root,
+			 struct btrfs_ioctl_usertrans *ut,
+			 u64 *ops_completed)
+{
+	int i;
+	int *fds;
+	int err;
+	struct file *file;
+	struct btrfs_ioctl_usertrans_op *ops = (void *)ut->ops_ptr;
+	int fd1, fd2;
+
+	fds = kcalloc(sizeof(int), ut->num_fds, GFP_KERNEL);
+	if (!fds)
+		return -ENOMEM;
+
+	for (i = 0; i < ut->num_ops; i++) {
+		struct btrfs_ioctl_usertrans_op op;
+		int ret;
+
+		err = -EFAULT;
+		if (copy_from_user(&op, &ops[i], sizeof(op)))
+			goto out;
+
+		/* lookup fd args? */
+		err = -EINVAL;
+		switch (op.op) {
+		case BTRFS_IOC_UT_OP_CLONERANGE:
+			if (op.args[1] < 0 || op.args[1] >= ut->num_fds)
+				goto out;
+			fd2 = fds[1];
+
+		case BTRFS_IOC_UT_OP_CLOSE:
+		case BTRFS_IOC_UT_OP_PWRITE:
+			if (op.args[0] < 0 || op.args[0] >= ut->num_fds)
+				goto out;
+			fd1 = fds[0];
+		}
+
+		/* do op */
+		switch (op.op) {
+		case BTRFS_IOC_UT_OP_OPEN:
+			ret = -EINVAL;
+			if (op.args[3] < 0 || op.args[3] >= ut->num_fds)
+				goto out;
+			ret = sys_open((const char __user *)op.args[0],
+				       op.args[1], op.args[2]);
+			fds[op.args[3]] = ret;
+			break;
+		case BTRFS_IOC_UT_OP_CLOSE:
+			ret = sys_close(fd1);
+			break;
+		case BTRFS_IOC_UT_OP_PWRITE:
+			ret = sys_pwrite64(fd1, (const char __user *)op.args[1],
+					   op.args[2], op.args[3]);
+			break;
+		case BTRFS_IOC_UT_OP_UNLINK:
+			ret = sys_unlink((const char __user *)op.args[0]);
+			break;
+		case BTRFS_IOC_UT_OP_MKDIR:
+			ret = sys_mkdir((const char __user *)op.args[0],
+				op.args[1]);
+			break;
+		case BTRFS_IOC_UT_OP_RMDIR:
+			ret = sys_rmdir((const char __user *)op.args[0]);
+			break;
+		case BTRFS_IOC_UT_OP_TRUNCATE:
+			ret = sys_truncate((const char __user *)op.args[0],
+					   op.args[1]);
+			break;
+		case BTRFS_IOC_UT_OP_SETXATTR:
+			ret = sys_setxattr((char __user *)op.args[0],
+					   (char __user *)op.args[1],
+					   (void __user *)op.args[2],
+					   op.args[3], op.args[4]);
+			break;
+		case BTRFS_IOC_UT_OP_REMOVEXATTR:
+			ret = sys_removexattr((char __user *)op.args[0],
+					      (char __user *)op.args[1]);
+			break;
+		case BTRFS_IOC_UT_OP_CLONERANGE:
+			ret = -EBADF;
+			file = fget(fd1);
+			if (file) {
+				ret = btrfs_ioctl_clone(file, fd2,
+							op.args[2], op.args[3],
+							op.args[4]);
+				fput(file);
+			}
+			break;
+		}
+		pr_debug(" ut %d/%d op %d args %llx %llx %llx %llx %llx = %d\n",
+			 i, (int)ut->num_ops, (int)op.op, op.args[0],
+			 op.args[1], op.args[2], op.args[3], op.args[4], ret);
+
+		put_user(ret, &ops[i].rval);
+
+		if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FAIL_ON_NE) &&
+		    ret != op.rval)
+			goto out;
+		if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FAIL_ON_EQ) &&
+		    ret == op.rval)
+			goto out;
+		if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FAIL_ON_LT) &&
+		    ret < op.rval)
+			goto out;
+		if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FAIL_ON_GT) &&
+		    ret > op.rval)
+			goto out;
+		if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FAIL_ON_LTE) &&
+		    ret <= op.rval)
+			goto out;
+		if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FAIL_ON_GTE) &&
+		    ret >= op.rval)
+			goto out;
+	}
+	err = 0;
+out:
+	*ops_completed = i;
+	kfree(fds);
+	return err;
+}
+
+long btrfs_ioctl_usertrans(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_ioctl_usertrans ut, *orig_ut = arg;
+	u64 ops_completed = 0;
+	int ret;
+
+	ret = -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(&ut, orig_ut, sizeof(ut)))
+		goto out;
+
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		goto out;
+
+	ret = btrfs_reserve_metadata_space(root, 5*ut.num_ops);
+	if (ret)
+		goto out_drop_write;
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	root->fs_info->open_ioctl_trans++;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	ret = -ENOMEM;
+	trans = btrfs_start_ioctl_transaction(root, 0);
+	if (!trans)
+		goto out_drop;
+
+	ret = do_usertrans(root, &ut, &ops_completed);
+	put_user(ops_completed, &orig_ut->ops_completed);
+
+	if (ret < 0 && (ut.flags & BTRFS_IOC_UT_FLAG_WEDGEONFAIL))
+		pr_err("btrfs: usertrans failed, wedging to avoid partial "
+		       " commit\n");
+	else
+		btrfs_end_transaction(trans, root);
+
+out_drop:
+	mutex_lock(&root->fs_info->trans_mutex);
+	root->fs_info->open_ioctl_trans--;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	btrfs_unreserve_metadata_space(root, 5*ut.num_ops);
+out_drop_write:
+	mnt_drop_write(file->f_path.mnt);
+out:
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -1343,6 +1528,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
+	case BTRFS_IOC_USERTRANS:
+		return btrfs_ioctl_usertrans(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index bc49914..f94e293 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -67,4 +67,53 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				struct btrfs_ioctl_vol_args)
+
+/* usertrans ops */
+/* the 'fd' values are _indices_ into a temporary fd table, see num_fds below */
+#define BTRFS_IOC_UT_OP_OPEN         1  /* path, flags, mode, fd */
+#define BTRFS_IOC_UT_OP_CLOSE        2  /* fd */
+#define BTRFS_IOC_UT_OP_PWRITE       3  /* fd, data, length, offset */
+#define BTRFS_IOC_UT_OP_UNLINK       4  /* path */
+#define BTRFS_IOC_UT_OP_LINK         5  /* oldpath, newpath */
+#define BTRFS_IOC_UT_OP_MKDIR        6  /* path, mode */
+#define BTRFS_IOC_UT_OP_RMDIR        7  /* path */
+#define BTRFS_IOC_UT_OP_TRUNCATE     8  /* path, size */
+#define BTRFS_IOC_UT_OP_SETXATTR     9  /* path, name, data, len */
+#define BTRFS_IOC_UT_OP_REMOVEXATTR 10  /* path, name */
+#define BTRFS_IOC_UT_OP_CLONERANGE  11  /* dst fd, src fd, off, len, dst off */
+
+/* define what 'failure' entails for each op based on return value */
+#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_NE    (1<< 1)
+#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_EQ    (1<< 2)
+#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_LT    (1<< 3)
+#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_GT    (1<< 4)
+#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_LTE   (1<< 5)
+#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_GTE   (1<< 6)
+
+struct btrfs_ioctl_usertrans_op {
+	__u64 op;
+	__s64 args[5];
+	__s64 rval;
+	__u64 flags;
+};
+
+/*
+ * If an op fails and we cannot complete the transaction, we may want
+ * to lock up the file system (requiring a reboot) to prevent a
+ * partial result from committing.
+ */
+#define BTRFS_IOC_UT_FLAG_WEDGEONFAIL (1<<13)
+
+struct btrfs_ioctl_usertrans {
+	__u64 num_ops;                  /* in: # ops */
+	__u64 ops_ptr;                  /* in: usertrans_op array */
+	__u64 num_fds;	                /* in: size of fd table (max fd + 1) */
+	__u64 data_bytes, metadata_ops; /* in: for space reservation */
+	__u64 flags;                    /* in: flags */
+	__u64 ops_completed;            /* out: # ops completed */
+};
+
+#define BTRFS_IOC_USERTRANS  _IOW(BTRFS_IOCTL_MAGIC, 16,	\
+				  struct btrfs_ioctl_usertrans)
+
 #endif
diff --git a/fs/namei.c b/fs/namei.c
index d11f404..4d53225 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2148,6 +2148,7 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
 {
 	return sys_mkdirat(AT_FDCWD, pathname, mode);
 }
+EXPORT_SYMBOL(sys_mkdir);
 
 /*
  * We try to drop the dentry early: we should have
@@ -2262,6 +2263,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 {
 	return do_rmdir(AT_FDCWD, pathname);
 }
+EXPORT_SYMBOL(sys_rmdir);
 
 int vfs_unlink(struct inode *dir, struct dentry *dentry)
 {
@@ -2369,6 +2371,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 {
 	return do_unlinkat(AT_FDCWD, pathname);
 }
+EXPORT_SYMBOL(sys_unlink);
 
 int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
diff --git a/fs/open.c b/fs/open.c
index 4f01e06..15eddfc 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -294,6 +294,7 @@ SYSCALL_DEFINE2(truncate, const char __user *, path, long, length)
 {
 	return do_sys_truncate(path, length);
 }
+EXPORT_SYMBOL(sys_truncate);
 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
@@ -1062,6 +1063,7 @@ SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, int, mode)
 	asmlinkage_protect(3, ret, filename, flags, mode);
 	return ret;
 }
+EXPORT_SYMBOL(sys_open);
 
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 		int, mode)
diff --git a/fs/read_write.c b/fs/read_write.c
index 3ac2898..75e9f60 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -453,6 +453,8 @@ SYSCALL_DEFINE(pwrite64)(unsigned int fd, const char __user *buf,
 
 	return ret;
 }
+EXPORT_SYMBOL(sys_pwrite64);
+
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 asmlinkage long SyS_pwrite64(long fd, long buf, long count, loff_t pos)
 {
diff --git a/fs/xattr.c b/fs/xattr.c
index 6d4f6d3..488c889 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -294,6 +294,7 @@ SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
 	path_put(&path);
 	return error;
 }
+EXPORT_SYMBOL(sys_setxattr);
 
 SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
 		const char __user *, name, const void __user *, value,
@@ -523,6 +524,7 @@ SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
 	path_put(&path);
 	return error;
 }
+EXPORT_SYMBOL(sys_removexattr);
 
 SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 		const char __user *, name)
-- 
1.5.6.5

