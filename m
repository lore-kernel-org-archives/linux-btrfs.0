From: Josef Bacik <josef@redhat.com>
Subject: [RFC] [PATCH 1/2] fs: introduce inode operation ->update_time
Date: Mon, 26 Mar 2012 10:10:30 -0400
Message-ID: <1332771031-3337-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has to make sure we have space to allocate new blocks in order to modify
the inode, so updating time can fail.  We've gotten around this by having our
own file_update_time but this is kind of a pain, and Christoph has indicated he
would like to make xfs do something different with atime updates.  So introduce
->update_time, where we will deal with i_version an a/m/c time updates and
indicate which changes need to be made.  The normal version just does what it
has always done, updates the time and marks the inode dirty, and then
filesystems can choose to do something different.

I've gone through all of the users of file_update_time and made them check for
errors with the exception of the fault code since it's complicated and I wasn't
quite sure what to do there, also Jan is going to be pushing the file time
updates into page_mkwrite for those who have it so that should satisfy btrfs and
make it not a big deal to check the file_update_time() return code in the
generic fault path. Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 Documentation/filesystems/Locking |    3 ++
 Documentation/filesystems/vfs.txt |    4 +++
 fs/fuse/file.c                    |    4 ++-
 fs/inode.c                        |   50 +++++++++++++++++++++++++++---------
 fs/ncpfs/file.c                   |    6 +++-
 fs/ntfs/file.c                    |    4 ++-
 fs/pipe.c                         |    7 +++-
 fs/splice.c                       |    6 +++-
 fs/xfs/xfs_file.c                 |    9 +++++-
 include/linux/fs.h                |   10 ++++++-
 mm/filemap.c                      |    4 ++-
 mm/filemap_xip.c                  |    4 ++-
 12 files changed, 85 insertions(+), 26 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 4fca82e..d5a269a 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -62,6 +62,7 @@ ata *);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
+	void (*update_time)(struct inode *, struct timespec *, int);
 
 locking rules:
 	all may block
@@ -89,6 +90,8 @@ listxattr:	no
 removexattr:	yes
 truncate_range:	yes
 fiemap:		no
+update_time:	no
+
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
 	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3d9393b..be73d17 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -364,6 +364,7 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	void (*update_time)(struct inode *, struct timespec *, int);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -475,6 +476,9 @@ otherwise noted.
   truncate_range: a method provided by the underlying filesystem to truncate a
   	range of blocks , i.e. punch a hole somewhere in a file.
 
+  update_time: called by the VFS to update a specific time or the i_version of
+  	an inode.  If this is not defined the VFS will update the inode itself
+  	and call mark_inode_dirty_sync.
 
 The Address Space Object
 ========================
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4a199fd..83a2b53 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -960,7 +960,9 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (err)
 		goto out;
 
-	file_update_time(file);
+	err = file_update_time(file);
+	if (err)
+		goto out;
 
 	iov_iter_init(&i, iov, nr_segs, count, 0);
 	written = fuse_perform_write(file, mapping, &i, pos);
diff --git a/fs/inode.c b/fs/inode.c
index 4fa4f09..9dddd03 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1504,6 +1504,27 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 	return 0;
 }
 
+/*
+ * This does the actual work of updating an inodes time or version.  Must have
+ * had called mnt_want_write() before calling this.
+ */
+static int update_time(struct inode *inode, struct timespec *time, int flags)
+{
+	if (inode->i_op->update_time)
+		return inode->i_op->update_time(inode, time, flags);
+
+	if (flags & S_ATIME)
+		inode->i_atime = *time;
+	if (flags & S_VERSION)
+		inode_inc_iversion(inode);
+	if (flags & S_CTIME)
+		inode->i_ctime = *time;
+	if (flags & S_MTIME)
+		inode->i_mtime = *time;
+	mark_inode_dirty_sync(inode);
+	return 0;
+}
+
 /**
  *	touch_atime	-	update the access time
  *	@mnt: mount the inode is accessed on
@@ -1541,8 +1562,14 @@ void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
 	if (mnt_want_write(mnt))
 		return;
 
-	inode->i_atime = now;
-	mark_inode_dirty_sync(inode);
+	/*
+	 * File systems can error out when updating inodes if they need to
+	 * allocate new space to modify an inode (such is the case for
+	 * Btrfs), but since we touch atime while walking down the path we
+	 * really don't care if we failed to update the atime of the file,
+	 * so just ignore the return value.
+	 */
+	update_time(inode, &now, S_ATIME);
 	mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
@@ -1556,14 +1583,16 @@ EXPORT_SYMBOL(touch_atime);
  *	usage in the file write path of filesystems, and filesystems may
  *	choose to explicitly ignore update via this function with the
  *	S_NOCMTIME inode flag, e.g. for network filesystem where these
- *	timestamps are handled by the server.
+ *	timestamps are handled by the server.  This can return an error for
+ *	file systems who need to allocate space in order to update an inode.
  */
 
-void file_update_time(struct file *file)
+int file_update_time(struct file *file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
-	enum { S_MTIME = 1, S_CTIME = 2, S_VERSION = 4 } sync_it = 0;
+	int sync_it = 0;
+	int ret;
 
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
@@ -1586,15 +1615,10 @@ void file_update_time(struct file *file)
 	if (mnt_want_write_file(file))
 		return;
 
-	/* Only change inode inside the lock region */
-	if (sync_it & S_VERSION)
-		inode_inc_iversion(inode);
-	if (sync_it & S_CTIME)
-		inode->i_ctime = now;
-	if (sync_it & S_MTIME)
-		inode->i_mtime = now;
-	mark_inode_dirty_sync(inode);
+	ret = update_time(inode, &now, sync_it);
 	mnt_drop_write_file(file);
+
+	return ret;
 }
 EXPORT_SYMBOL(file_update_time);
 
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 64a3264..2b622d9 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -222,6 +222,10 @@ ncp_file_write(struct file *file, const char __user *buf, size_t count, loff_t *
 
 	already_written = 0;
 
+	errno = file_update_time(file);
+	if (errno)
+		goto outrel;
+
 	bouncebuffer = vmalloc(bufsize);
 	if (!bouncebuffer) {
 		errno = -EIO;	/* -ENOMEM */
@@ -253,8 +257,6 @@ ncp_file_write(struct file *file, const char __user *buf, size_t count, loff_t *
 	}
 	vfree(bouncebuffer);
 
-	file_update_time(file);
-
 	*ppos = pos;
 
 	if (pos > i_size_read(inode)) {
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index c587e2d..53fae89 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2096,7 +2096,9 @@ static ssize_t ntfs_file_aio_write_nolock(struct kiocb *iocb,
 	err = file_remove_suid(file);
 	if (err)
 		goto out;
-	file_update_time(file);
+	err = file_update_time(file);
+	if (err)
+		goto out;
 	written = ntfs_file_buffered_write(iocb, iov, nr_segs, pos, ppos,
 			count);
 out:
diff --git a/fs/pipe.c b/fs/pipe.c
index a932ced..92c91fd 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -626,8 +626,11 @@ out:
 		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
-	if (ret > 0)
-		file_update_time(filp);
+	if (ret > 0) {
+		int err = file_update_time(filp);
+		if (err)
+			ret = err;
+	}
 	return ret;
 }
 
diff --git a/fs/splice.c b/fs/splice.c
index 1ec0493..5bb04fc 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1003,8 +1003,10 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 		ret = file_remove_suid(out);
 		if (!ret) {
-			file_update_time(out);
-			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
+			ret = file_update_time(out);
+			if (!ret)
+				ret = splice_from_pipe_feed(pipe, &sd,
+							    pipe_to_file);
 		}
 		mutex_unlock(&inode->i_mutex);
 	} while (ret > 0);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7e5bc87..24d672a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -659,8 +659,13 @@ restart:
 		return error;
 	}
 
-	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
-		file_update_time(file);
+	if (likely(!(file->f_mode & FMODE_NOCMTIME))) {
+		error = file_update_time(file);
+		if (error) {
+			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+			return error;
+		}
+	}
 
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0244082..c887989 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1653,6 +1653,7 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	int (*update_time)(struct inode *, struct timespec *, int);
 } ____cacheline_aligned;
 
 struct seq_file;
@@ -1811,6 +1812,13 @@ static inline void inode_inc_iversion(struct inode *inode)
        spin_unlock(&inode->i_lock);
 }
 
+enum file_time_flags {
+	S_ATIME = 1,
+	S_MTIME = 2,
+	S_CTIME = 4,
+	S_VERSION = 8,
+};
+
 extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
 static inline void file_accessed(struct file *file)
 {
@@ -2554,7 +2562,7 @@ extern int inode_change_ok(const struct inode *, struct iattr *);
 extern int inode_newsize_ok(const struct inode *, loff_t offset);
 extern void setattr_copy(struct inode *inode, const struct iattr *attr);
 
-extern void file_update_time(struct file *file);
+extern int file_update_time(struct file *file);
 
 extern int generic_show_options(struct seq_file *m, struct dentry *root);
 extern void save_mount_options(struct super_block *sb, char *options);
diff --git a/mm/filemap.c b/mm/filemap.c
index 97f49ed..38dd9e7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2534,7 +2534,9 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (err)
 		goto out;
 
-	file_update_time(file);
+	err = file_update_time(file);
+	if (err)
+		goto out;
 
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (unlikely(file->f_flags & O_DIRECT)) {
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index f91b2f6..4fe2666 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -421,7 +421,9 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	if (ret)
 		goto out_backing;
 
-	file_update_time(filp);
+	ret = file_update_time(filp);
+	if (ret)
+		goto out_backing;
 
 	ret = __xip_file_write (filp, buf, count, pos, ppos);
 
-- 
1.7.5.2

