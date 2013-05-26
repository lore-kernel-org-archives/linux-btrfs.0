Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47049 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3EZNve (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 09:51:34 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4QDpWKW017115
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:33 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpVVZ009990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:32 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpVOQ006799
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5 RESEND] Btrfs: allow file data clone within a file
Date: Sun, 26 May 2013 21:50:31 +0800
Message-Id: <1369576231-17836-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
References: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We did not allow file data clone within the same file because of
deadlock issues.

However, we now use nested lock to avoid deadlock between the
parent directory and the child file.

So it's safe to do file clone within the same file when the two
ranges are not overlapped.

Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0f81d67..112153a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2480,6 +2480,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	int ret;
 	u64 len = olen;
 	u64 bs = root->fs_info->sb->s_blocksize;
+	int same_inode = 0;
 
 	/*
 	 * TODO:
@@ -2516,7 +2517,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 	ret = -EINVAL;
 	if (src == inode)
-		goto out_fput;
+		same_inode = 1;
 
 	/* the src must be open for reading */
 	if (!(src_file.file->f_mode & FMODE_READ))
@@ -2547,12 +2548,16 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
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
@@ -2570,6 +2575,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
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
@@ -2846,7 +2857,8 @@ out:
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

