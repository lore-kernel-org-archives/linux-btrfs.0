From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] fs: push flush and i_mutex lock in fsync down into the filesystems
Date: Mon, 18 Apr 2011 16:04:29 -0400
Message-ID: <1303157069-11580-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hch@infradead.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Some filesystems don't need to grab the i_mutex in order to do their fsyncs, and
others (btrfs) need to control how data is flushed during an fsync.  So fix
->fsync to take the start and end offsets that we're fsyncing and push the
taking of i_mutex and running filemap_write_and_wait_range down into all of the
filesystems.  I tried to keep it as close as how the original things worked, but
in some cases I went ahead and did what I thought was the most optimal.  In
other cases (ext3 and ocfs2 come to mind) I put a comment stating that I think
that i_mutex can be dropped there so the people familiar with the code can make
the decision and remove it if possible.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 Documentation/filesystems/vfs.txt |    2 +-
 fs/9p/v9fs_vfs.h                  |    3 ++-
 fs/9p/vfs_file.c                  |   22 ++++++++++++++++++++--
 fs/affs/affs.h                    |    2 +-
 fs/affs/file.c                    |    8 +++++++-
 fs/afs/internal.h                 |    2 +-
 fs/afs/write.c                    |   18 ++++++++++++++----
 fs/bad_inode.c                    |    3 ++-
 fs/block_dev.c                    |    6 +-----
 fs/btrfs/ctree.h                  |    2 +-
 fs/btrfs/file.c                   |   21 +++++++++++++++------
 fs/ceph/caps.c                    |    6 ++++--
 fs/ceph/dir.c                     |   10 +++++++++-
 fs/cifs/cifsfs.h                  |    4 ++--
 fs/cifs/file.c                    |   18 ++++++++++++++++--
 fs/coda/coda_int.h                |    2 +-
 fs/coda/file.c                    |    8 +++++++-
 fs/ecryptfs/file.c                |    7 ++++---
 fs/exofs/file.c                   |   10 +++++++++-
 fs/ext2/ext2.h                    |    3 ++-
 fs/ext2/file.c                    |    4 ++--
 fs/ext3/fsync.c                   |   18 ++++++++++++++++--
 fs/ext4/ext4.h                    |    2 +-
 fs/ext4/fsync.c                   |   14 +++++++++++---
 fs/fat/fat.h                      |    3 ++-
 fs/fat/file.c                     |    4 ++--
 fs/fuse/dir.c                     |    5 +++--
 fs/fuse/file.c                    |   24 ++++++++++++++++++------
 fs/fuse/fuse_i.h                  |    3 ++-
 fs/gfs2/file.c                    |    9 ++++++++-
 fs/hfs/inode.c                    |    9 ++++++++-
 fs/hfsplus/hfsplus_fs.h           |    3 ++-
 fs/hfsplus/inode.c                |   10 +++++++++-
 fs/hostfs/hostfs_kern.c           |   15 +++++++++++++--
 fs/hpfs/file.c                    |    5 ++---
 fs/hpfs/hpfs_fn.h                 |    2 +-
 fs/hppfs/hppfs.c                  |    5 +++--
 fs/jffs2/file.c                   |    9 ++++++++-
 fs/jffs2/os-linux.h               |    2 +-
 fs/jfs/file.c                     |    9 ++++++++-
 fs/jfs/jfs_inode.h                |    2 +-
 fs/libfs.c                        |   16 ++++++++++++----
 fs/logfs/file.c                   |   11 ++++++++++-
 fs/logfs/logfs.h                  |    2 +-
 fs/ncpfs/file.c                   |    4 ++--
 fs/nfs/dir.c                      |    8 ++++++--
 fs/nfs/file.c                     |   11 ++++++++---
 fs/nilfs2/file.c                  |   12 ++++++++++--
 fs/nilfs2/nilfs.h                 |    2 +-
 fs/ntfs/dir.c                     |   10 +++++++++-
 fs/ntfs/file.c                    |   10 +++++++++-
 fs/ocfs2/file.c                   |   14 +++++++++++++-
 fs/reiserfs/dir.c                 |   13 +++++++++++--
 fs/reiserfs/file.c                |    9 ++++++++-
 fs/sync.c                         |   25 +++----------------------
 fs/ubifs/file.c                   |   21 +++++++++++----------
 fs/ubifs/ubifs.h                  |    2 +-
 fs/xfs/linux-2.6/xfs_file.c       |   15 +++++++++++++--
 include/linux/ext3_fs.h           |    2 +-
 include/linux/fs.h                |    9 +++++----
 ipc/shm.c                         |    4 ++--
 61 files changed, 376 insertions(+), 138 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 80815ed..a2a9110 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -755,7 +755,7 @@ struct file_operations {
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *);
 	int (*release) (struct inode *, struct file *);
-	int (*fsync) (struct file *, int datasync);
+	int (*fsync) (struct file *, loff_t, loff_t, int datasync);
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 4014160..46ce357 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -70,7 +70,8 @@ ssize_t v9fs_file_readn(struct file *, char *, char __user *, u32, u64);
 ssize_t v9fs_fid_readn(struct p9_fid *, char *, char __user *, u32, u64);
 void v9fs_blank_wstat(struct p9_wstat *wstat);
 int v9fs_vfs_setattr_dotl(struct dentry *, struct iattr *);
-int v9fs_file_fsync_dotl(struct file *filp, int datasync);
+int v9fs_file_fsync_dotl(struct file *filp, loff_t start, loff_t end,
+			 int datasync);
 ssize_t v9fs_file_write_internal(struct inode *, struct p9_fid *,
 				 const char __user *, size_t, loff_t *, int);
 int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode);
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index ffed558..3c173fc 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -519,32 +519,50 @@ out:
 }
 
 
-static int v9fs_file_fsync(struct file *filp, int datasync)
+static int v9fs_file_fsync(struct file *filp, loff_t start, loff_t end,
+			   int datasync)
 {
 	struct p9_fid *fid;
+	struct inode *inode = filp->f_mapping->host;
 	struct p9_wstat wstat;
 	int retval;
 
+	retval = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (retval)
+		return retval;
+
+	mutex_lock(&inode->i_mutex);
 	P9_DPRINTK(P9_DEBUG_VFS, "filp %p datasync %x\n", filp, datasync);
 
 	fid = filp->private_data;
 	v9fs_blank_wstat(&wstat);
 
 	retval = p9_client_wstat(fid, &wstat);
+	mutex_unlock(&inode->i_mutex);
+
 	return retval;
 }
 
-int v9fs_file_fsync_dotl(struct file *filp, int datasync)
+int v9fs_file_fsync_dotl(struct file *filp, loff_t start, loff_t end,
+			 int datasync)
 {
 	struct p9_fid *fid;
+	struct inode *inode = filp->f_mapping->host;
 	int retval;
 
+	retval = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (retval)
+		return retval;
+
+	mutex_lock(&inode->i_mutex);
 	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_file_fsync_dotl: filp %p datasync %x\n",
 			filp, datasync);
 
 	fid = filp->private_data;
 
 	retval = p9_client_fsync(fid, datasync);
+	mutex_unlock(&inode->i_mutex);
+
 	return retval;
 }
 
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 0e95f73..c2b9c79 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -182,7 +182,7 @@ extern int			 affs_add_entry(struct inode *dir, struct inode *inode, struct dent
 
 void		affs_free_prealloc(struct inode *inode);
 extern void	affs_truncate(struct inode *);
-int		affs_file_fsync(struct file *, int);
+int		affs_file_fsync(struct file *, loff_t, loff_t, int);
 
 /* dir.c */
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index acf321b..2f4c935 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -923,14 +923,20 @@ affs_truncate(struct inode *inode)
 	affs_free_prealloc(inode);
 }
 
-int affs_file_fsync(struct file *filp, int datasync)
+int affs_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
 	int ret, err;
 
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+
+	mutex_lock(&inode->i_mutex);
 	ret = write_inode_now(inode, 0);
 	err = sync_blockdev(inode->i_sb->s_bdev);
 	if (!ret)
 		ret = err;
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 5a9b684..fe85208 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -750,7 +750,7 @@ extern void afs_pages_written_back(struct afs_vnode *, struct afs_call *);
 extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
 			      unsigned long, loff_t);
 extern int afs_writeback_all(struct afs_vnode *);
-extern int afs_fsync(struct file *, int);
+extern int afs_fsync(struct file *, loff_t, loff_t, int);
 
 
 /*****************************************************************************/
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 789b3af..8c1cf20 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -684,9 +684,10 @@ int afs_writeback_all(struct afs_vnode *vnode)
  * - the return status from this call provides a reliable indication of
  *   whether any write errors occurred for this process.
  */
-int afs_fsync(struct file *file, int datasync)
+int afs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = file->f_mapping->host;
 	struct afs_writeback *wb, *xwb;
 	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
 	int ret;
@@ -695,12 +696,19 @@ int afs_fsync(struct file *file, int datasync)
 	       vnode->fid.vid, vnode->fid.vnode, dentry->d_name.name,
 	       datasync);
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+	mutex_lock(&inode->i_mutex);
+
 	/* use a writeback record as a marker in the queue - when this reaches
 	 * the front of the queue, all the outstanding writes are either
 	 * completed or rejected */
 	wb = kzalloc(sizeof(*wb), GFP_KERNEL);
-	if (!wb)
-		return -ENOMEM;
+	if (!wb) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	wb->vnode = vnode;
 	wb->first = 0;
 	wb->last = -1;
@@ -723,7 +731,7 @@ int afs_fsync(struct file *file, int datasync)
 	if (ret < 0) {
 		afs_put_writeback(wb);
 		_leave(" = %d [wb]", ret);
-		return ret;
+		goto out;
 	}
 
 	/* wait for the preceding writes to actually complete */
@@ -732,6 +740,8 @@ int afs_fsync(struct file *file, int datasync)
 				       vnode->writebacks.next == &wb->link);
 	afs_put_writeback(wb);
 	_leave(" = %d", ret);
+out:
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 9ad2369..039d39e 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -87,7 +87,8 @@ static int bad_file_release(struct inode *inode, struct file *filp)
 	return -EIO;
 }
 
-static int bad_file_fsync(struct file *file, int datasync)
+static int bad_file_fsync(struct file *file, loff_t start, loff_t end,
+			  int datasync)
 {
 	return -EIO;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index c1511c6..6436833 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -373,7 +373,7 @@ static loff_t block_llseek(struct file *file, loff_t offset, int origin)
 	return retval;
 }
 	
-int blkdev_fsync(struct file *filp, int datasync)
+int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *bd_inode = filp->f_mapping->host;
 	struct block_device *bdev = I_BDEV(bd_inode);
@@ -384,14 +384,10 @@ int blkdev_fsync(struct file *filp, int datasync)
 	 * i_mutex and doing so causes performance issues with concurrent
 	 * O_SYNC writers to a block device.
 	 */
-	mutex_unlock(&bd_inode->i_mutex);
-
 	error = blkdev_issue_flush(bdev, GFP_KERNEL, NULL);
 	if (error == -EOPNOTSUPP)
 		error = 0;
 
-	mutex_lock(&bd_inode->i_mutex);
-
 	return error;
 }
 EXPORT_SYMBOL(blkdev_fsync);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d5f043e..b409721 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2567,7 +2567,7 @@ void btrfs_update_iflags(struct inode *inode);
 void btrfs_inherit_iflags(struct inode *inode, struct inode *dir);
 
 /* file.c */
-int btrfs_sync_file(struct file *file, int datasync);
+int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
 int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cd5e82e..70038d5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1194,7 +1194,7 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
  * important optimization for directories because holding the mutex prevents
  * new operations on the dir while we write to disk.
  */
-int btrfs_sync_file(struct file *file, int datasync)
+int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -1204,9 +1204,13 @@ int btrfs_sync_file(struct file *file, int datasync)
 
 	trace_btrfs_sync_file(file, datasync);
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+	mutex_lock(&inode->i_mutex);
+
 	/* we wait first, since the writeback may change the inode */
 	root->log_batch++;
-	/* the VFS called filemap_fdatawrite for us */
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	root->log_batch++;
 
@@ -1214,8 +1218,10 @@ int btrfs_sync_file(struct file *file, int datasync)
 	 * check the transaction that last modified this inode
 	 * and see if its already been committed
 	 */
-	if (!BTRFS_I(inode)->last_trans)
+	if (!BTRFS_I(inode)->last_trans) {
+		mutex_unlock(&inode->i_mutex);
 		goto out;
+	}
 
 	/*
 	 * if the last transaction that changed this file was before
@@ -1226,6 +1232,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	if (BTRFS_I(inode)->last_trans <=
 	    root->fs_info->last_trans_committed) {
 		BTRFS_I(inode)->last_trans = 0;
+		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
 
@@ -1238,12 +1245,15 @@ int btrfs_sync_file(struct file *file, int datasync)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
 
 	ret = btrfs_log_dentry_safe(trans, root, dentry);
-	if (ret < 0)
+	if (ret < 0) {
+		mutex_unlock(&inode->i_mutex);
 		goto out;
+	}
 
 	/* we've logged all the items and now have a consistent
 	 * version of the file in the log.  It is possible that
@@ -1255,7 +1265,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	 * file again, but that will end up using the synchronization
 	 * inside btrfs_sync_log to keep things safe.
 	 */
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 
 	if (ret != BTRFS_NO_LOG_SYNC) {
 		if (ret > 0) {
@@ -1270,7 +1280,6 @@ int btrfs_sync_file(struct file *file, int datasync)
 	} else {
 		ret = btrfs_end_transaction(trans, root);
 	}
-	mutex_lock(&dentry->d_inode->i_mutex);
 out:
 	return ret > 0 ? -EIO : ret;
 }
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 6b61ded..24c8d46 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1810,7 +1810,7 @@ out:
 	spin_unlock(&ci->i_unsafe_lock);
 }
 
-int ceph_fsync(struct file *file, int datasync)
+int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -1821,9 +1821,10 @@ int ceph_fsync(struct file *file, int datasync)
 	dout("fsync %p%s\n", inode, datasync ? " datasync" : "");
 	sync_write_wait(inode);
 
-	ret = filemap_write_and_wait(inode->i_mapping);
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret < 0)
 		return ret;
+	mutex_lock(&inode->i_mutex);
 
 	dirty = try_flush_caps(inode, NULL, &flush_tid);
 	dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
@@ -1840,6 +1841,7 @@ int ceph_fsync(struct file *file, int datasync)
 	}
 
 	dout("fsync %p%s done\n", inode, datasync ? " datasync" : "");
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 1a867a3..dac2d7f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1109,7 +1109,8 @@ static ssize_t ceph_read_dir(struct file *file, char __user *buf, size_t size,
  * an fsync() on a dir will wait for any uncommitted directory
  * operations to commit.
  */
-static int ceph_dir_fsync(struct file *file, int datasync)
+static int ceph_dir_fsync(struct file *file, loff_t start, loff_t end,
+			  int datasync)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -1119,6 +1120,11 @@ static int ceph_dir_fsync(struct file *file, int datasync)
 	int ret = 0;
 
 	dout("dir_fsync %p\n", inode);
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+	mutex_lock(&inode->i_mutex);
+
 	spin_lock(&ci->i_unsafe_lock);
 	if (list_empty(head))
 		goto out;
@@ -1152,6 +1158,8 @@ static int ceph_dir_fsync(struct file *file, int datasync)
 	} while (req->r_tid < last_tid);
 out:
 	spin_unlock(&ci->i_unsafe_lock);
+	mutex_unlock(&inode->i_mutex);
+
 	return ret;
 }
 
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index a9371b6..6cded32 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -89,8 +89,8 @@ extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 				  unsigned long nr_segs, loff_t pos);
 extern int cifs_lock(struct file *, int, struct file_lock *);
-extern int cifs_fsync(struct file *, int);
-extern int cifs_strict_fsync(struct file *, int);
+extern int cifs_fsync(struct file *, loff_t, loff_t, int);
+extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
 extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
 extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c27d236..f91c6cf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1523,7 +1523,8 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	return rc;
 }
 
-int cifs_strict_fsync(struct file *file, int datasync)
+int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
+		      int datasync)
 {
 	int xid;
 	int rc = 0;
@@ -1532,6 +1533,11 @@ int cifs_strict_fsync(struct file *file, int datasync)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
+	rc = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (rc)
+		return rc;
+	mutex_lock(&inode->i_mutex);
+
 	xid = GetXid();
 
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
@@ -1545,16 +1551,23 @@ int cifs_strict_fsync(struct file *file, int datasync)
 		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
 
 	FreeXid(xid);
+	mutex_unlock(&inode->i_mutex);
 	return rc;
 }
 
-int cifs_fsync(struct file *file, int datasync)
+int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	int xid;
 	int rc = 0;
 	struct cifsTconInfo *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	struct inode *inode = file->f_mapping->host;
+
+	rc = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (rc)
+		return rc;
+	mutex_lock(&inode->i_mutex);
 
 	xid = GetXid();
 
@@ -1566,6 +1579,7 @@ int cifs_fsync(struct file *file, int datasync)
 		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
 
 	FreeXid(xid);
+	mutex_unlock(&inode->i_mutex);
 	return rc;
 }
 
diff --git a/fs/coda/coda_int.h b/fs/coda/coda_int.h
index 6b443ff..b7143cf 100644
--- a/fs/coda/coda_int.h
+++ b/fs/coda/coda_int.h
@@ -11,7 +11,7 @@ extern int coda_fake_statfs;
 
 void coda_destroy_inodecache(void);
 int coda_init_inodecache(void);
-int coda_fsync(struct file *coda_file, int datasync);
+int coda_fsync(struct file *coda_file, loff_t start, loff_t end, int datasync);
 void coda_sysctl_init(void);
 void coda_sysctl_clean(void);
 
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 0433057..8edd404 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -199,7 +199,7 @@ int coda_release(struct inode *coda_inode, struct file *coda_file)
 	return 0;
 }
 
-int coda_fsync(struct file *coda_file, int datasync)
+int coda_fsync(struct file *coda_file, loff_t start, loff_t end, int datasync)
 {
 	struct file *host_file;
 	struct inode *coda_inode = coda_file->f_path.dentry->d_inode;
@@ -210,6 +210,11 @@ int coda_fsync(struct file *coda_file, int datasync)
 	      S_ISLNK(coda_inode->i_mode)))
 		return -EINVAL;
 
+	err = filemap_write_and_wait_range(coda_inode->i_mapping, start, end);
+	if (err)
+		return err;
+	mutex_lock(&coda_inode->i_mutex);
+
 	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 	host_file = cfi->cfi_container;
@@ -217,6 +222,7 @@ int coda_fsync(struct file *coda_file, int datasync)
 	err = vfs_fsync(host_file, datasync);
 	if (!err && !datasync)
 		err = venus_fsync(coda_inode->i_sb, coda_i2f(coda_inode));
+	mutex_unlock(&coda_inode->i_mutex);
 
 	return err;
 }
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index cedc913..9c674fb 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -271,14 +271,15 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
 }
 
 static int
-ecryptfs_fsync(struct file *file, int datasync)
+ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	int rc = 0;
 
-	rc = generic_file_fsync(file, datasync);
+	rc = generic_file_fsync(file, start, end, datasync);
 	if (rc)
 		goto out;
-	rc = vfs_fsync(ecryptfs_file_to_lower(file), datasync);
+	rc = vfs_fsync_range(ecryptfs_file_to_lower(file), start, end,
+			     datasync);
 out:
 	return rc;
 }
diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index 45ca323..491c6c0 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -42,11 +42,19 @@ static int exofs_release_file(struct inode *inode, struct file *filp)
  *   Note, in exofs all metadata is written as part of inode, regardless.
  *   The writeout is synchronous
  */
-static int exofs_file_fsync(struct file *filp, int datasync)
+static int exofs_file_fsync(struct file *filp, loff_t start, loff_t end,
+			    int datasync)
 {
+	struct inode *inode = filp->f_mapping->host;
 	int ret;
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+
+	mutex_lock(&inode->i_mutex);
 	ret = sync_inode_metadata(filp->f_mapping->host, 1);
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 645be9e..af9fc89 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -150,7 +150,8 @@ extern void ext2_write_super (struct super_block *);
 extern const struct file_operations ext2_dir_operations;
 
 /* file.c */
-extern int ext2_fsync(struct file *file, int datasync);
+extern int ext2_fsync(struct file *file, loff_t start, loff_t end,
+		      int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 extern const struct file_operations ext2_xip_file_operations;
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 49eec94..82e0632 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -40,13 +40,13 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
-int ext2_fsync(struct file *file, int datasync)
+int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	int ret;
 	struct super_block *sb = file->f_mapping->host->i_sb;
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 
-	ret = generic_file_fsync(file, datasync);
+	ret = generic_file_fsync(file, start, end, datasync);
 	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
 		/* We don't really know where the IO error happened... */
 		ext2_error(sb, __func__,
diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 09b13bb..0bcf63a 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -43,7 +43,7 @@
  * inode to disk.
  */
 
-int ext3_sync_file(struct file *file, int datasync)
+int ext3_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct ext3_inode_info *ei = EXT3_I(inode);
@@ -54,6 +54,17 @@ int ext3_sync_file(struct file *file, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+
+	/*
+	 * Taking the mutex here just to keep consistent with how fsync was
+	 * called previously, however it looks like we don't need to take
+	 * i_mutex at all.
+	 */
+	mutex_lock(&inode->i_mutex);
+
 	J_ASSERT(ext3_journal_current_handle() == NULL);
 
 	/*
@@ -70,8 +81,10 @@ int ext3_sync_file(struct file *file, int datasync)
 	 *  (they were dirtied by commit).  But that's OK - the blocks are
 	 *  safe in-journal, which is all fsync() needs to ensure.
 	 */
-	if (ext3_should_journal_data(inode))
+	if (ext3_should_journal_data(inode)) {
+		mutex_unlock(&inode->i_mutex);
 		return ext3_force_commit(inode->i_sb);
+	}
 
 	if (datasync)
 		commit_tid = atomic_read(&ei->i_datasync_tid);
@@ -91,5 +104,6 @@ int ext3_sync_file(struct file *file, int datasync)
 	 */
 	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4daaf2b..2d387af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1671,7 +1671,7 @@ extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 
 /* fsync.c */
-extern int ext4_sync_file(struct file *, int);
+extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
 extern int ext4_flush_completed_IO(struct inode *);
 
 /* hash.c */
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 7f74019..9ced801 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -154,7 +154,7 @@ static void ext4_sync_parent(struct inode *inode)
  * i_mutex lock is held when entering and exiting this function
  */
 
-int ext4_sync_file(struct file *file, int datasync)
+int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -166,15 +166,22 @@ int ext4_sync_file(struct file *file, int datasync)
 
 	trace_ext4_sync_file_enter(file, datasync);
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+	mutex_lock(&inode->i_mutex);
+
 	if (inode->i_sb->s_flags & MS_RDONLY)
-		return 0;
+		goto out;
 
 	ret = ext4_flush_completed_IO(inode);
 	if (ret < 0)
 		goto out;
 
 	if (!journal) {
-		ret = generic_file_fsync(file, datasync);
+		if (inode->i_state & I_DIRTY ||
+		    (datasync && (inode->i_state & I_DIRTY_DATASYNC)))
+			ret = sync_inode_metadata(inode, 1);
 		if (!ret && !list_empty(&inode->i_dentry))
 			ext4_sync_parent(inode);
 		goto out;
@@ -218,6 +225,7 @@ int ext4_sync_file(struct file *file, int datasync)
 	} else if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
  out:
+	mutex_unlock(&inode->i_mutex);
 	trace_ext4_sync_file_exit(inode, ret);
 	return ret;
 }
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index f504089..58766f3 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -309,7 +309,8 @@ extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
 extern void fat_truncate_blocks(struct inode *inode, loff_t offset);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
-extern int fat_file_fsync(struct file *file, int datasync);
+extern int fat_file_fsync(struct file *file, loff_t start, loff_t end,
+			  int datasync);
 
 /* fat/inode.c */
 extern void fat_attach(struct inode *inode, loff_t i_pos);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 7257752..d185ac1 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -149,12 +149,12 @@ static int fat_file_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-int fat_file_fsync(struct file *filp, int datasync)
+int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
 	int res, err;
 
-	res = generic_file_fsync(filp, datasync);
+	res = generic_file_fsync(filp, start, end, datasync);
 	err = sync_mapping_buffers(MSDOS_SB(inode->i_sb)->fat_inode->i_mapping);
 
 	return res ? res : err;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c6ba49b..6138814 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1176,9 +1176,10 @@ static int fuse_dir_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int fuse_dir_fsync(struct file *file, int datasync)
+static int fuse_dir_fsync(struct file *file, loff_t start, loff_t end,
+			  int datasync)
 {
-	return fuse_fsync_common(file, datasync, 1);
+	return fuse_fsync_common(file, start, end, datasync, 1);
 }
 
 static bool update_mtime(unsigned ivalid)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6ea0073..123387e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -400,7 +400,8 @@ static void fuse_sync_writes(struct inode *inode)
 	fuse_release_nowrite(inode);
 }
 
-int fuse_fsync_common(struct file *file, int datasync, int isdir)
+int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
+		      int datasync, int isdir)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -412,9 +413,15 @@ int fuse_fsync_common(struct file *file, int datasync, int isdir)
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+
 	if ((!isdir && fc->no_fsync) || (isdir && fc->no_fsyncdir))
 		return 0;
 
+	mutex_lock(&inode->i_mutex);
+
 	/*
 	 * Start writeback against all dirty pages of the inode, then
 	 * wait for all outstanding writes, before sending the FSYNC
@@ -422,13 +429,15 @@ int fuse_fsync_common(struct file *file, int datasync, int isdir)
 	 */
 	err = write_inode_now(inode, 0);
 	if (err)
-		return err;
+		goto out;
 
 	fuse_sync_writes(inode);
 
 	req = fuse_get_req(fc);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out;
+	}
 
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.fh = ff->fh;
@@ -448,12 +457,15 @@ int fuse_fsync_common(struct file *file, int datasync, int isdir)
 			fc->no_fsync = 1;
 		err = 0;
 	}
+out:
+	mutex_unlock(&inode->i_mutex);
 	return err;
 }
 
-static int fuse_fsync(struct file *file, int datasync)
+static int fuse_fsync(struct file *file, loff_t start, loff_t end,
+		      int datasync)
 {
-	return fuse_fsync_common(file, datasync, 0);
+	return fuse_fsync_common(file, start, end, datasync, 0);
 }
 
 void fuse_read_fill(struct fuse_req *req, struct file *file, loff_t pos,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index b788bec..c6aa2d4 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -589,7 +589,8 @@ void fuse_release_common(struct file *file, int opcode);
 /**
  * Send FSYNC or FSYNCDIR request
  */
-int fuse_fsync_common(struct file *file, int datasync, int isdir);
+int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
+		      int datasync, int isdir);
 
 /**
  * Notify poll wakeup
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index b2682e0..af2b4b5 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -561,12 +561,18 @@ static int gfs2_close(struct inode *inode, struct file *file)
  * Returns: errno
  */
 
-static int gfs2_fsync(struct file *file, int datasync)
+static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
+		      int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
 	int ret = 0;
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+	mutex_lock(&inode->i_mutex);
+
 	if (gfs2_is_jdata(GFS2_I(inode))) {
 		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
 		return 0;
@@ -580,6 +586,7 @@ static int gfs2_fsync(struct file *file, int datasync)
 			gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
 	}
 
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index fff16c9..ce3f575 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -625,12 +625,18 @@ int hfs_inode_setattr(struct dentry *dentry, struct iattr * attr)
 	return 0;
 }
 
-static int hfs_file_fsync(struct file *filp, int datasync)
+static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
+			  int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
 	struct super_block * sb;
 	int ret, err;
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+	mutex_lock(&inode->i_mutex);
+
 	/* sync the inode to buffers */
 	ret = write_inode_now(inode, 0);
 
@@ -647,6 +653,7 @@ static int hfs_file_fsync(struct file *filp, int datasync)
 	err = sync_blockdev(sb->s_bdev);
 	if (!ret)
 		ret = err;
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index d685752..38184e3 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -392,7 +392,8 @@ int hfsplus_cat_read_inode(struct inode *, struct hfs_find_data *);
 int hfsplus_cat_write_inode(struct inode *);
 struct inode *hfsplus_new_inode(struct super_block *, int);
 void hfsplus_delete_inode(struct inode *);
-int hfsplus_file_fsync(struct file *file, int datasync);
+int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync);
 
 /* ioctl.c */
 long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index b248a6c..43e846b 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -306,13 +306,19 @@ static int hfsplus_setattr(struct dentry *dentry, struct iattr *attr)
 	return 0;
 }
 
-int hfsplus_file_fsync(struct file *file, int datasync)
+int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	int error = 0, error2;
 
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+	mutex_lock(&inode->i_mutex);
+
 	/*
 	 * Sync inode metadata into the catalog and extent trees.
 	 */
@@ -340,6 +346,8 @@ int hfsplus_file_fsync(struct file *file, int datasync)
 	if (!test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 
+	mutex_unlock(&inode->i_mutex);
+
 	return error;
 }
 
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 2638c834e..dfd5882 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -362,9 +362,20 @@ retry:
 	return 0;
 }
 
-int hostfs_fsync(struct file *file, int datasync)
+int hostfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	return fsync_file(HOSTFS_I(file->f_mapping->host)->fd, datasync);
+	struct inode * inode = file->f_mapping->host;
+	int ret;
+
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+
+	mutex_lock(&inode->i_mutex);
+	ret = fsync_file(HOSTFS_I(inode)->fd, datasync);
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
 }
 
 static const struct file_operations hostfs_file_fops = {
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 9b9eb69..3646961 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -18,10 +18,9 @@ static int hpfs_file_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-int hpfs_file_fsync(struct file *file, int datasync)
+int hpfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	/*return file_fsync(file, datasync);*/
-	return 0; /* Don't fsync :-) */
+	return filemap_write_and_wait(file->f_mapping, start, end);
 }
 
 /*
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index c15adbc..46430cb 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -268,7 +268,7 @@ void hpfs_set_ea(struct inode *, struct fnode *, const char *,
 
 /* file.c */
 
-int hpfs_file_fsync(struct file *, int);
+int hpfs_file_fsync(struct file *, loff_t, loff_t, int);
 extern const struct file_operations hpfs_file_ops;
 extern const struct inode_operations hpfs_file_iops;
 extern const struct address_space_operations hpfs_aops;
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 87ed48e..44a3ebc 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -588,9 +588,10 @@ static int hppfs_readdir(struct file *file, void *ent, filldir_t filldir)
 	return err;
 }
 
-static int hppfs_fsync(struct file *file, int datasync)
+static int hppfs_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync)
 {
-	return 0;
+	return filemap_write_and_wait_range(file->f_mapping, start, end);
 }
 
 static const struct file_operations hppfs_dir_fops = {
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 1c0a08d..3989f7e 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -27,13 +27,20 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			struct page **pagep, void **fsdata);
 static int jffs2_readpage (struct file *filp, struct page *pg);
 
-int jffs2_fsync(struct file *filp, int datasync)
+int jffs2_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
+	int ret;
+
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
 
+	mutex_lock(&inode->i_mutex);
 	/* Trigger GC to flush any pending writes for this inode */
 	jffs2_flush_wbuf_gc(c, inode->i_ino);
+	mutex_unlock(&inode->i_mutex);
 
 	return 0;
 }
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 00bae7c..7cacb2b 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -158,7 +158,7 @@ extern const struct inode_operations jffs2_dir_inode_operations;
 extern const struct file_operations jffs2_file_operations;
 extern const struct inode_operations jffs2_file_inode_operations;
 extern const struct address_space_operations jffs2_file_address_operations;
-int jffs2_fsync(struct file *, int);
+int jffs2_fsync(struct file *, loff_t, loff_t, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
 
 /* ioctl.c */
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index c5ce6c1..b497189 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -28,19 +28,26 @@
 #include "jfs_acl.h"
 #include "jfs_debug.h"
 
-int jfs_fsync(struct file *file, int datasync)
+int jfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int rc = 0;
 
+	rc = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (rc)
+		return rc;
+
+	mutex_lock(&inode->i_mutex);
 	if (!(inode->i_state & I_DIRTY) ||
 	    (datasync && !(inode->i_state & I_DIRTY_DATASYNC))) {
 		/* Make sure committed changes hit the disk */
 		jfs_flush_journal(JFS_SBI(inode->i_sb)->log, 1);
+		mutex_unlock(&inode->i_mutex);
 		return rc;
 	}
 
 	rc |= jfs_commit_inode(inode, 1);
+	mutex_unlock(&inode->i_mutex);
 
 	return rc ? -EIO : 0;
 }
diff --git a/fs/jfs/jfs_inode.h b/fs/jfs/jfs_inode.h
index 155e91e..aec7896 100644
--- a/fs/jfs/jfs_inode.h
+++ b/fs/jfs/jfs_inode.h
@@ -21,7 +21,7 @@
 struct fid;
 
 extern struct inode *ialloc(struct inode *, umode_t);
-extern int jfs_fsync(struct file *, int);
+extern int jfs_fsync(struct file *, loff_t, loff_t, int);
 extern long jfs_ioctl(struct file *, unsigned int, unsigned long);
 extern long jfs_compat_ioctl(struct file *, unsigned int, unsigned long);
 extern struct inode *jfs_iget(struct super_block *, unsigned long);
diff --git a/fs/libfs.c b/fs/libfs.c
index c88eab5..02c94e7 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -905,21 +905,29 @@ EXPORT_SYMBOL_GPL(generic_fh_to_parent);
  * filesystems which track all non-inode metadata in the buffers list
  * hanging off the address_space structure.
  */
-int generic_file_fsync(struct file *file, int datasync)
+int generic_file_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
 	int ret;
 
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+
+	mutex_lock(&inode->i_mutex);
 	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode->i_state & I_DIRTY))
-		return ret;
+		goto out;
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		return ret;
+		goto out;
 
 	err = sync_inode_metadata(inode, 1);
 	if (ret == 0)
 		ret = err;
+out:
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 EXPORT_SYMBOL(generic_file_fsync);
@@ -956,7 +964,7 @@ EXPORT_SYMBOL(generic_check_addressable);
 /*
  * No-op implementation of ->fsync for in-memory filesystems.
  */
-int noop_fsync(struct file *file, int datasync)
+int noop_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	return 0;
 }
diff --git a/fs/logfs/file.c b/fs/logfs/file.c
index c2ad702..b4d123e 100644
--- a/fs/logfs/file.c
+++ b/fs/logfs/file.c
@@ -219,11 +219,20 @@ long logfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 }
 
-int logfs_fsync(struct file *file, int datasync)
+int logfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct super_block *sb = file->f_mapping->host->i_sb;
+	struct inode *inode = filemap->f_mapping->host;
+	int ret;
+
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
 
+	mutex_lock(&inode->i_mutex);
 	logfs_write_anchor(sb);
+	mutex_unlock(&inode->i_mutex);
+
 	return 0;
 }
 
diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index 57afd4a..f22d108 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -506,7 +506,7 @@ extern const struct file_operations logfs_reg_fops;
 extern const struct address_space_operations logfs_reg_aops;
 int logfs_readpage(struct file *file, struct page *page);
 long logfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-int logfs_fsync(struct file *file, int datasync);
+int logfs_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 /* gc.c */
 u32 get_best_cand(struct super_block *sb, struct candidate_list *list, u32 *ec);
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 0ed65e0..64a3264 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -20,9 +20,9 @@
 
 #include "ncp_fs.h"
 
-static int ncp_fsync(struct file *file, int datasync)
+static int ncp_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	return 0;
+	return filemap_write_and_wait_range(file->f_mapping, start, end);
 }
 
 /*
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 7237672..04cabf3 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -56,7 +56,7 @@ static int nfs_link(struct dentry *, struct inode *, struct dentry *);
 static int nfs_mknod(struct inode *, struct dentry *, int, dev_t);
 static int nfs_rename(struct inode *, struct dentry *,
 		      struct inode *, struct dentry *);
-static int nfs_fsync_dir(struct file *, int);
+static int nfs_fsync_dir(struct file *, loff_t, loff_t, int);
 static loff_t nfs_llseek_dir(struct file *, loff_t, int);
 static void nfs_readdir_clear_array(struct page*);
 
@@ -950,15 +950,19 @@ out:
  * All directory operations under NFS are synchronous, so fsync()
  * is a dummy operation.
  */
-static int nfs_fsync_dir(struct file *filp, int datasync)
+static int nfs_fsync_dir(struct file *filp, loff_t start, loff_t end,
+			 int datasync)
 {
 	struct dentry *dentry = filp->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
 
 	dfprintk(FILE, "NFS: fsync dir(%s/%s) datasync %d\n",
 			dentry->d_parent->d_name.name, dentry->d_name.name,
 			datasync);
 
+	mutex_lock(&inode->i_mutex);
 	nfs_inc_stats(dentry->d_inode, NFSIOS_VFSFSYNC);
+	mutex_unlock(&inode->i_mutex);
 	return 0;
 }
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 3ac5bd6..00774ff 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -55,7 +55,7 @@ static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
 static ssize_t nfs_file_write(struct kiocb *, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 static int  nfs_file_flush(struct file *, fl_owner_t id);
-static int  nfs_file_fsync(struct file *, int datasync);
+static int  nfs_file_fsync(struct file *, loff_t, loff_t, int datasync);
 static int nfs_check_flags(int flags);
 static int nfs_lock(struct file *filp, int cmd, struct file_lock *fl);
 static int nfs_flock(struct file *filp, int cmd, struct file_lock *fl);
@@ -305,7 +305,7 @@ nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
  * fall back to doing a synchronous write.
  */
 static int
-nfs_file_fsync(struct file *file, int datasync)
+nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct nfs_open_context *ctx = nfs_file_open_context(file);
@@ -313,11 +313,15 @@ nfs_file_fsync(struct file *file, int datasync)
 	int have_error, status;
 	int ret = 0;
 
-
 	dprintk("NFS: fsync file(%s/%s) datasync %d\n",
 			dentry->d_parent->d_name.name, dentry->d_name.name,
 			datasync);
 
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+	mutex_lock(&inode->i_mutex);
+
 	nfs_inc_stats(inode, NFSIOS_VFSFSYNC);
 	have_error = test_and_clear_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	status = nfs_commit_inode(inode, FLUSH_SYNC);
@@ -329,6 +333,7 @@ nfs_file_fsync(struct file *file, int datasync)
 	if (!ret && !datasync)
 		/* application has asked for meta-data sync */
 		ret = pnfs_layoutcommit_inode(inode, true);
+	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 397e732..14dcf16 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -27,7 +27,7 @@
 #include "nilfs.h"
 #include "segment.h"
 
-int nilfs_sync_file(struct file *file, int datasync)
+int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	/*
 	 * Called from fsync() system call
@@ -40,8 +40,15 @@ int nilfs_sync_file(struct file *file, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	int err;
 
-	if (!nilfs_inode_dirty(inode))
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+	mutex_lock(&inode->i_mutex);
+
+	if (!nilfs_inode_dirty(inode)) {
+		mutex_unlock(&inode->i_mutex);
 		return 0;
+	}
 
 	if (datasync)
 		err = nilfs_construct_dsync_segment(inode->i_sb, inode, 0,
@@ -49,6 +56,7 @@ int nilfs_sync_file(struct file *file, int datasync)
 	else
 		err = nilfs_construct_segment(inode->i_sb);
 
+	mutex_unlock(&inode->i_mutex);
 	return err;
 }
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index a8dd344..8b920c7 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -241,7 +241,7 @@ extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
 			   struct page *, struct inode *);
 
 /* file.c */
-extern int nilfs_sync_file(struct file *, int);
+extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
 
 /* ioctl.c */
 long nilfs_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index 0f48e7c..99e3610 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -1527,13 +1527,20 @@ static int ntfs_dir_open(struct inode *vi, struct file *filp)
  * this problem for now.  We do write the $BITMAP attribute if it is present
  * which is the important one for a directory so things are not too bad.
  */
-static int ntfs_dir_fsync(struct file *filp, int datasync)
+static int ntfs_dir_fsync(struct file *filp, loff_t start, loff_t end,
+			  int datasync)
 {
 	struct inode *bmp_vi, *vi = filp->f_mapping->host;
 	int err, ret;
 	ntfs_attr na;
 
 	ntfs_debug("Entering for inode 0x%lx.", vi->i_ino);
+
+	err = filemap_write_and_wait_range(vi->i_mapping, start, end);
+	if (err)
+		return err;
+	mutex_lock(&vi->i_mutex);
+
 	BUG_ON(!S_ISDIR(vi->i_mode));
 	/* If the bitmap attribute inode is in memory sync it, too. */
 	na.mft_no = vi->i_ino;
@@ -1555,6 +1562,7 @@ static int ntfs_dir_fsync(struct file *filp, int datasync)
 	else
 		ntfs_warning(vi->i_sb, "Failed to f%ssync inode 0x%lx.  Error "
 				"%u.", datasync ? "data" : "", vi->i_ino, -ret);
+	mutex_unlock(&vi->i_mutex);
 	return ret;
 }
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index f4b1057..c404ad0 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2153,12 +2153,19 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
  * with this inode but since we have no simple way of getting to them we ignore
  * this problem for now.
  */
-static int ntfs_file_fsync(struct file *filp, int datasync)
+static int ntfs_file_fsync(struct file *filp, loff_t start, loff_t end,
+			   int datasync)
 {
 	struct inode *vi = filp->f_mapping->host;
 	int err, ret = 0;
 
 	ntfs_debug("Entering for inode 0x%lx.", vi->i_ino);
+
+	err = filemap_write_and_wait_range(vi->i_mapping, start, end);
+	if (err)
+		return err;
+	mutex_lock(&vi->i_mutex);
+
 	BUG_ON(S_ISDIR(vi->i_mode));
 	if (!datasync || !NInoNonResident(NTFS_I(vi)))
 		ret = __ntfs_write_inode(vi, 1);
@@ -2176,6 +2183,7 @@ static int ntfs_file_fsync(struct file *filp, int datasync)
 	else
 		ntfs_warning(vi->i_sb, "Failed to f%ssync inode 0x%lx.  Error "
 				"%u.", datasync ? "data" : "", vi->i_ino, -ret);
+	mutex_unlock(&vi->i_mutex);
 	return ret;
 }
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 41565ae..5addaab 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -171,7 +171,8 @@ static int ocfs2_dir_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int ocfs2_sync_file(struct file *file, int datasync)
+static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
+			   int datasync)
 {
 	int err = 0;
 	journal_t *journal;
@@ -184,6 +185,16 @@ static int ocfs2_sync_file(struct file *file, int datasync)
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+
+	/*
+	 * Probably don't need the i_mutex at all in here, just putting it here
+	 * to be consistent with how fsync used to be called, someone more
+	 * familiar with the fs could possibly remove it.
+	 */
+	mutex_lock(&inode->i_mutex);
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
 		/*
 		 * We still have to flush drive's caches to get data to the
@@ -200,6 +211,7 @@ static int ocfs2_sync_file(struct file *file, int datasync)
 bail:
 	if (err)
 		mlog_errno(err);
+	mutex_unlock(&inode->i_mutex);
 
 	return (err < 0) ? -EIO : 0;
 }
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 198dabf..133e935 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -14,7 +14,8 @@
 extern const struct reiserfs_key MIN_KEY;
 
 static int reiserfs_readdir(struct file *, void *, filldir_t);
-static int reiserfs_dir_fsync(struct file *filp, int datasync);
+static int reiserfs_dir_fsync(struct file *filp, loff_t start, loff_t end,
+			      int datasync);
 
 const struct file_operations reiserfs_dir_operations = {
 	.llseek = generic_file_llseek,
@@ -27,13 +28,21 @@ const struct file_operations reiserfs_dir_operations = {
 #endif
 };
 
-static int reiserfs_dir_fsync(struct file *filp, int datasync)
+static int reiserfs_dir_fsync(struct file *filp, loff_t start, loff_t end,
+			      int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
 	int err;
+
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+
+	mutex_lock(&inode->i_mutex);
 	reiserfs_write_lock(inode->i_sb);
 	err = reiserfs_commit_for_inode(inode);
 	reiserfs_write_unlock(inode->i_sb);
+	mutex_unlock(&inode->i_mutex);
 	if (err < 0)
 		return err;
 	return 0;
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 91f080c..1a23e1e 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -140,12 +140,18 @@ static void reiserfs_vfs_truncate_file(struct inode *inode)
  * be removed...
  */
 
-static int reiserfs_sync_file(struct file *filp, int datasync)
+static int reiserfs_sync_file(struct file *filp, loff_t start, loff_t end,
+			      int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
 	int err;
 	int barrier_done;
 
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+
+	mutex_lock(&inode->i_mutex);
 	BUG_ON(!S_ISREG(inode->i_mode));
 	err = sync_mapping_buffers(inode->i_mapping);
 	reiserfs_write_lock(inode->i_sb);
@@ -153,6 +159,7 @@ static int reiserfs_sync_file(struct file *filp, int datasync)
 	reiserfs_write_unlock(inode->i_sb);
 	if (barrier_done != 1 && reiserfs_barrier_flush(inode->i_sb))
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+	mutex_unlock(&inode->i_mutex);
 	if (barrier_done < 0)
 		return barrier_done;
 	return (err < 0) ? -EIO : 0;
diff --git a/fs/sync.c b/fs/sync.c
index c38ec16..c98a747 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -165,28 +165,9 @@ SYSCALL_DEFINE1(syncfs, int, fd)
  */
 int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct address_space *mapping = file->f_mapping;
-	int err, ret;
-
-	if (!file->f_op || !file->f_op->fsync) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ret = filemap_write_and_wait_range(mapping, start, end);
-
-	/*
-	 * We need to protect against concurrent writers, which could cause
-	 * livelocks in fsync_buffers_list().
-	 */
-	mutex_lock(&mapping->host->i_mutex);
-	err = file->f_op->fsync(file, datasync);
-	if (!ret)
-		ret = err;
-	mutex_unlock(&mapping->host->i_mutex);
-
-out:
-	return ret;
+	if (!file->f_op || !file->f_op->fsync)
+		return -EINVAL;
+	return file->f_op->fsync(file, start, end, datasync);
 }
 EXPORT_SYMBOL(vfs_fsync_range);
 
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 28be1e6..d068a75 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1304,7 +1304,7 @@ static void *ubifs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	return NULL;
 }
 
-int ubifs_fsync(struct file *file, int datasync)
+int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
@@ -1312,14 +1312,16 @@ int ubifs_fsync(struct file *file, int datasync)
 
 	dbg_gen("syncing inode %lu", inode->i_ino);
 
-	/*
-	 * VFS has already synchronized dirty pages for this inode. Synchronize
-	 * the inode unless this is a 'datasync()' call.
-	 */
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (err)
+		return err;
+	mutex_lock(&inode->i_mutex);
+
+	/* Synchronize the inode unless this is a 'datasync()' call. */
 	if (!datasync || (inode->i_state & I_DIRTY_DATASYNC)) {
 		err = inode->i_sb->s_op->write_inode(inode, NULL);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/*
@@ -1327,10 +1329,9 @@ int ubifs_fsync(struct file *file, int datasync)
 	 * them.
 	 */
 	err = ubifs_sync_wbufs_by_inode(c, inode);
-	if (err)
-		return err;
-
-	return 0;
+out:
+	mutex_unlock(&inode->i_mutex);
+	return err;
 }
 
 /**
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 8c40ad3..16dab3b 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1712,7 +1712,7 @@ const struct ubifs_lprops *ubifs_fast_find_frdi_idx(struct ubifs_info *c);
 int ubifs_calc_dark(const struct ubifs_info *c, int spc);
 
 /* file.c */
-int ubifs_fsync(struct file *file, int datasync);
+int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 int ubifs_setattr(struct dentry *dentry, struct iattr *attr);
 
 /* dir.c */
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 52aadfb..1dc7249 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -127,6 +127,8 @@ xfs_iozero(
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
+	loff_t			start,
+	loff_t			end,
 	int			datasync)
 {
 	struct inode		*inode = file->f_mapping->host;
@@ -137,8 +139,15 @@ xfs_file_fsync(
 
 	trace_xfs_file_fsync(ip);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+	mutex_lock(&inode->i_mutex);
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		mutex_unlock(&inode->i_mutex);
 		return -XFS_ERROR(EIO);
+	}
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
@@ -180,6 +189,7 @@ xfs_file_fsync(
 				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
+			mutex_unlock(&inode->i_mutex);
 			return -error;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -232,6 +242,7 @@ xfs_file_fsync(
 			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
 	}
 
+	mutex_unlock(&inode->i_mutex);
 	return -error;
 }
 
@@ -869,7 +880,7 @@ xfs_file_aio_write(
 		error = filemap_write_and_wait_range(mapping, pos, end);
 		xfs_rw_ilock(ip, iolock);
 
-		error2 = -xfs_file_fsync(file,
+		error2 = -xfs_file_fsync(file, pos, end,
 					 (file->f_flags & __O_SYNC) ? 0 : 1);
 		if (error)
 			ret = error;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 85c1d30..931e4c3 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -877,7 +877,7 @@ extern int ext3_htree_store_dirent(struct file *dir_file, __u32 hash,
 extern void ext3_htree_free_dir_info(struct dir_private_info *p);
 
 /* fsync.c */
-extern int ext3_sync_file(struct file *, int);
+extern int ext3_sync_file(struct file *, loff_t, loff_t, int);
 
 /* hash.c */
 extern int ext3fs_dirhash(const char *name, int len, struct
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1b95af3..61ce3a6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1550,7 +1550,7 @@ struct file_operations {
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
-	int (*fsync) (struct file *, int datasync);
+	int (*fsync) (struct file *, loff_t, loff_t, int datasync);
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
@@ -2309,7 +2309,8 @@ extern int generic_segment_checks(const struct iovec *iov,
 /* fs/block_dev.c */
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
-extern int blkdev_fsync(struct file *filp, int datasync);
+extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
+			int datasync);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
@@ -2436,7 +2437,7 @@ extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
-extern int noop_fsync(struct file *, int);
+extern int noop_fsync(struct file *, loff_t, loff_t, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
 extern int simple_write_begin(struct file *file, struct address_space *mapping,
@@ -2461,7 +2462,7 @@ extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 		const void __user *from, size_t count);
 
-extern int generic_file_fsync(struct file *, int);
+extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
 
 extern int generic_check_addressable(unsigned, u64);
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 8644452..1f9e1b1 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -277,13 +277,13 @@ static int shm_release(struct inode *ino, struct file *file)
 	return 0;
 }
 
-static int shm_fsync(struct file *file, int datasync)
+static int shm_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
 
 	if (!sfd->file->f_op->fsync)
 		return -EINVAL;
-	return sfd->file->f_op->fsync(sfd->file, datasync);
+	return sfd->file->f_op->fsync(sfd->file, start, end, datasync);
 }
 
 static unsigned long shm_get_unmapped_area(struct file *file,
-- 
1.7.2.3

