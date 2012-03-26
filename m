From: Josef Bacik <josef@redhat.com>
Subject: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Mon, 26 Mar 2012 10:10:31 -0400
Message-ID: <1332771031-3337-2-git-send-email-josef@redhat.com>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1332771031-3337-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs had been doing it's own file_update_time so we could catch ENOSPC
properly, so just update our btrfs_update_time to work with the new stuff and
then we'll be fancy later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h |    1 -
 fs/btrfs/file.c  |    2 +-
 fs/btrfs/inode.c |   53 ++++++++++++++---------------------------------------
 3 files changed, 15 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9d6f59c..9e4a06e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2887,7 +2887,6 @@ int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
 int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
 int btrfs_dirty_inode(struct inode *inode);
-int btrfs_update_time(struct file *file);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 859ba2d..50b8cea 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1389,7 +1389,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		goto out;
 	}
 
-	err = btrfs_update_time(file);
+	err = file_update_time(file);
 	if (err) {
 		mutex_unlock(&inode->i_mutex);
 		goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c2c44d6..2c7359b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4287,46 +4287,18 @@ int btrfs_dirty_inode(struct inode *inode)
  * This is a copy of file_update_time.  We need this so we can return error on
  * ENOSPC for updating the inode in the case of file write and mmap writes.
  */
-int btrfs_update_time(struct file *file)
+static int btrfs_update_time(struct inode *inode, struct timespec *now,
+			     int flags)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct timespec now;
-	int ret;
-	enum { S_MTIME = 1, S_CTIME = 2, S_VERSION = 4 } sync_it = 0;
-
-	/* First try to exhaust all avenues to not sync */
-	if (IS_NOCMTIME(inode))
-		return 0;
-
-	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now))
-		sync_it = S_MTIME;
-
-	if (!timespec_equal(&inode->i_ctime, &now))
-		sync_it |= S_CTIME;
-
-	if (IS_I_VERSION(inode))
-		sync_it |= S_VERSION;
-
-	if (!sync_it)
-		return 0;
-
-	/* Finally allowed to write? Takes lock. */
-	if (mnt_want_write_file(file))
-		return 0;
-
-	/* Only change inode inside the lock region */
-	if (sync_it & S_VERSION)
+	if (flags & S_VERSION)
 		inode_inc_iversion(inode);
-	if (sync_it & S_CTIME)
-		inode->i_ctime = now;
-	if (sync_it & S_MTIME)
-		inode->i_mtime = now;
-	ret = btrfs_dirty_inode(inode);
-	if (!ret)
-		mark_inode_dirty_sync(inode);
-	mnt_drop_write(file->f_path.mnt);
-	return ret;
+	if (flags & S_CTIME)
+		inode->i_ctime = *now;
+	if (flags & S_MTIME)
+		inode->i_mtime = *now;
+	if (flags & S_ATIME)
+		inode->i_atime = *now;
+	return btrfs_dirty_inode(inode);
 }
 
 /*
@@ -6405,7 +6377,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (!ret)
-		ret = btrfs_update_time(vma->vm_file);
+		ret = file_update_time(vma->vm_file);
 	if (ret) {
 		if (ret == -ENOMEM)
 			ret = VM_FAULT_OOM;
@@ -7451,6 +7423,7 @@ static const struct inode_operations btrfs_file_inode_operations = {
 	.permission	= btrfs_permission,
 	.fiemap		= btrfs_fiemap,
 	.get_acl	= btrfs_get_acl,
+	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
@@ -7461,6 +7434,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.get_acl	= btrfs_get_acl,
+	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
@@ -7474,6 +7448,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.get_acl	= btrfs_get_acl,
+	.update_time	= btrfs_update_time,
 };
 
 const struct dentry_operations btrfs_dentry_operations = {
-- 
1.7.5.2

