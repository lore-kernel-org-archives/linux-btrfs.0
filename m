Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48012 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932784AbcLGVhg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 16:37:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/6] Btrfs: refactor btrfs_file_write_iter
Date: Wed,  7 Dec 2016 13:45:07 -0800
Message-Id: <1481147110-20048-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a helper function btrfs_file_write_check for file checks, permission
check and necessary time and size extention.

With this, we simplify btrfs_file_write_iter by putting details into seperated
buffered_write and direct_write callback.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c | 128 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 78 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3a14c87..06e55e8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -44,6 +44,7 @@
 #include "compression.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
+static ssize_t btrfs_file_write_check(struct kiocb *iocb, struct iov_iter *from);
 /*
  * when auto defrag is enabled we
  * queue up these defrag structs to remember which
@@ -1735,20 +1736,25 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	return num_written ? num_written : ret;
 }
 
-static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t btrfs_file_direct_write(struct kiocb *iocb,
+				       struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	loff_t pos = iocb->ki_pos;
-	ssize_t written;
+	ssize_t written = 0;
 	ssize_t written_buffered;
 	loff_t endbyte;
 	int err;
 
-	written = generic_file_direct_write(iocb, from);
+	inode_lock(inode);
+	err = btrfs_file_write_check(iocb, from);
+	if (err)
+		goto out;
 
+	written = generic_file_direct_write(iocb, from);
 	if (written < 0 || !iov_iter_count(from))
-		return written;
+		goto out;
 
 	pos += written;
 	written_buffered = __btrfs_buffered_write(file, from, pos);
@@ -1772,6 +1778,7 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
+	inode_unlock(inode);
 	return written ? written : err;
 }
 
@@ -1793,47 +1800,56 @@ static void update_time_for_write(struct inode *inode)
 		inode_inc_iversion(inode);
 }
 
-static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
-				    struct iov_iter *from)
+static ssize_t btrfs_file_buffered_write(struct kiocb *iocb,
+					 struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	loff_t pos;
+	loff_t oldsize;
+	ssize_t ret;
+
+	inode_lock(inode);
+	ret = btrfs_file_write_check(iocb, from);
+	if (ret)
+		goto out;
+
+	current->backing_dev_info = inode_to_bdi(inode);
+
+	pos = iocb->ki_pos;
+	ret = __btrfs_buffered_write(file, from, pos);
+	if (ret > 0)
+		iocb->ki_pos = pos + ret;
+	if (oldsize < pos)
+		pagecache_isize_extended(inode, oldsize,
+					i_size_read(inode));
+
+	current->backing_dev_info = NULL;
+out:
+	inode_unlock(inode);
+	return ret;
+}
+
+static ssize_t btrfs_file_write_check(struct kiocb *iocb,
+				      struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 start_pos;
-	u64 end_pos;
-	ssize_t num_written = 0;
-	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 	ssize_t err;
 	loff_t pos;
 	size_t count;
 	loff_t oldsize;
-	int clean_page = 0;
+	u64 start_pos;
+	u64 end_pos;
 
-	inode_lock(inode);
 	err = generic_write_checks(iocb, from);
-	if (err <= 0) {
-		inode_unlock(inode);
+	if (err <= 0)
 		return err;
-	}
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	err = file_remove_privs(file);
-	if (err) {
-		inode_unlock(inode);
-		goto out;
-	}
-
-	/*
-	 * If BTRFS flips readonly due to some impossible error
-	 * (fs_info->fs_state now has BTRFS_SUPER_FLAG_ERROR),
-	 * although we have opened a file as writable, we have
-	 * to stop this write operation to ensure FS consistency.
-	 */
-	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state)) {
-		inode_unlock(inode);
-		err = -EROFS;
-		goto out;
-	}
+	if (err)
+		return err;
 
 	/*
 	 * We reserve space for updating the inode when we reserve space for the
@@ -1851,30 +1867,43 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 		/* Expand hole size to cover write data, preventing empty gap */
 		end_pos = round_up(pos + count, root->sectorsize);
 		err = btrfs_cont_expand(inode, oldsize, end_pos);
-		if (err) {
-			inode_unlock(inode);
-			goto out;
-		}
-		if (start_pos > round_up(oldsize, root->sectorsize))
-			clean_page = 1;
+		if (err)
+			return err;
 	}
 
+	return 0;
+}
+
+static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
+				    struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	ssize_t num_written = 0;
+	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
+
+	if (!iov_iter_count(from))
+		return 0;
+
+	/*
+	 * If BTRFS flips readonly due to some impossible error
+	 * (fs_info->fs_state now has BTRFS_SUPER_FLAG_ERROR),
+	 * although we have opened a file as writable, we have
+	 * to stop this write operation to ensure FS consistency.
+	 */
+	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
+		return -EROFS;
+
 	if (sync)
 		atomic_inc(&BTRFS_I(inode)->sync_writers);
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		num_written = __btrfs_direct_write(iocb, from);
+		num_written = btrfs_file_direct_write(iocb, from);
 	} else {
-		num_written = __btrfs_buffered_write(file, from, pos);
-		if (num_written > 0)
-			iocb->ki_pos = pos + num_written;
-		if (clean_page)
-			pagecache_isize_extended(inode, oldsize,
-						i_size_read(inode));
+		num_written = btrfs_file_buffered_write(iocb, from);
 	}
 
-	inode_unlock(inode);
-
 	/*
 	 * We also have to set last_sub_trans to the current log transid,
 	 * otherwise subsequent syncs to a file that's been synced in this
@@ -1888,9 +1917,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 
 	if (sync)
 		atomic_dec(&BTRFS_I(inode)->sync_writers);
-out:
-	current->backing_dev_info = NULL;
-	return num_written ? num_written : err;
+
+	return num_written;
 }
 
 int btrfs_release_file(struct inode *inode, struct file *filp)
-- 
2.5.5

