Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17769 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3DOC4N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Apr 2013 22:56:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] Btrfs: allow file data clone within a file
Date: Mon, 15 Apr 2013 10:55:45 +0800
Message-Id: <1365994545-19083-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We did not allow file data clone within the same file because of
deadlock issues.

However, we now use nested lock to avoid deadlock between the
parent directory and the child file.

So it's safe to do file clone within the same file when the two
ranges are not overlapped.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: add sanity check for overlapping range.

 fs/btrfs/ioctl.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 898c572..69cd80d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2473,6 +2473,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	int ret;
 	u64 len = olen;
 	u64 bs = root->fs_info->sb->s_blocksize;
+	int same_inode = 0;
 
 	/*
 	 * TODO:
@@ -2509,7 +2510,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 	ret = -EINVAL;
 	if (src == inode)
-		goto out_fput;
+		same_inode = 1;
 
 	/* the src must be open for reading */
 	if (!(src_file.file->f_mode & FMODE_READ))
@@ -2540,12 +2541,16 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	}
 	path->reada = 2;
 
-	if (inode < src) {
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
+	if (!same_inode) {
+		if (inode < src) {
+			mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
+			mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
+		} else {
+			mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
+			mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		}
 	} else {
-		mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		mutex_lock(&src->i_mutex);
 	}
 
 	/* determine range to clone */
@@ -2563,6 +2568,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	    !IS_ALIGNED(destoff, bs))
 		goto out_unlock;
 
+	/* verify if ranges are overlapped within the same file */
+	if (same_inode) {
+		if (destoff + len > off && destoff < off + len)
+			goto out_unlock;
+	}
+
 	if (destoff > inode->i_size) {
 		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
 		if (ret)
@@ -2839,7 +2850,8 @@ out:
 	unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
-	mutex_unlock(&inode->i_mutex);
+	if (!same_inode)
+		mutex_unlock(&inode->i_mutex);
 	vfree(buf);
 	btrfs_free_path(path);
 out_fput:
-- 
1.7.7

