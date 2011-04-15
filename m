From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/2] Btrfs: switch to the ->fsync_nolock helper
Date: Fri, 15 Apr 2011 15:09:42 -0400
Message-ID: <1302894582-24341-3-git-send-email-josef@redhat.com>
References: <1302894582-24341-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1302894582-24341-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs needs to be able to control how IO is submitted in the fsync case, so in
preperation of this work convert to the ->fsync_nolock file op.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/file.c  |   27 ++++++++++++++++++---------
 fs/btrfs/inode.c |    2 +-
 3 files changed, 20 insertions(+), 11 deletions(-)

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
index cd5e82e..d50eea8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1194,19 +1194,23 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
  * important optimization for directories because holding the mutex prevents
  * new operations on the dir while we write to disk.
  */
-int btrfs_sync_file(struct file *file, int datasync)
+int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int err;
 	int ret = 0;
 	struct btrfs_trans_handle *trans;
 
 	trace_btrfs_sync_file(file, datasync);
 
+	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+
+	mutex_lock(&inode->i_mutex);
+
 	/* we wait first, since the writeback may change the inode */
 	root->log_batch++;
-	/* the VFS called filemap_fdatawrite for us */
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	root->log_batch++;
 
@@ -1215,7 +1219,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	 * and see if its already been committed
 	 */
 	if (!BTRFS_I(inode)->last_trans)
-		goto out;
+		goto out_lock;
 
 	/*
 	 * if the last transaction that changed this file was before
@@ -1226,7 +1230,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	if (BTRFS_I(inode)->last_trans <=
 	    root->fs_info->last_trans_committed) {
 		BTRFS_I(inode)->last_trans = 0;
-		goto out;
+		goto out_lock;
 	}
 
 	/*
@@ -1238,12 +1242,12 @@ int btrfs_sync_file(struct file *file, int datasync)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out;
+		goto out_lock;
 	}
 
 	ret = btrfs_log_dentry_safe(trans, root, dentry);
 	if (ret < 0)
-		goto out;
+		goto out_lock;
 
 	/* we've logged all the items and now have a consistent
 	 * version of the file in the log.  It is possible that
@@ -1255,7 +1259,7 @@ int btrfs_sync_file(struct file *file, int datasync)
 	 * file again, but that will end up using the synchronization
 	 * inside btrfs_sync_log to keep things safe.
 	 */
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 
 	if (ret != BTRFS_NO_LOG_SYNC) {
 		if (ret > 0) {
@@ -1270,8 +1274,13 @@ int btrfs_sync_file(struct file *file, int datasync)
 	} else {
 		ret = btrfs_end_transaction(trans, root);
 	}
-	mutex_lock(&dentry->d_inode->i_mutex);
+	goto out;
+
+out_lock:
+	mutex_unlock(&inode->i_mutex);
 out:
+	if (!ret)
+		ret = err;
 	return ret > 0 ? -EIO : ret;
 }
 
@@ -1416,7 +1425,7 @@ const struct file_operations btrfs_file_operations = {
 	.mmap		= btrfs_file_mmap,
 	.open		= generic_file_open,
 	.release	= btrfs_release_file,
-	.fsync		= btrfs_sync_file,
+	.fsync_nolock	= btrfs_sync_file,
 	.fallocate	= btrfs_fallocate,
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b1e5b11..e80b999 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7490,7 +7490,7 @@ static const struct file_operations btrfs_dir_file_operations = {
 	.compat_ioctl	= btrfs_ioctl,
 #endif
 	.release        = btrfs_release_file,
-	.fsync		= btrfs_sync_file,
+	.fsync_nolock	= btrfs_sync_file,
 };
 
 static struct extent_io_ops btrfs_extent_io_ops = {
-- 
1.7.2.3

