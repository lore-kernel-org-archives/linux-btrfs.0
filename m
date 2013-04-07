Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781Ab3DGOUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 10:20:33 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r37EKWPF027787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 14:20:33 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r37EKVWq002257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 14:20:32 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r37EKVD5010795
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 14:20:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: allow file data clone within a file
Date: Sun,  7 Apr 2013 22:18:18 +0800
Message-Id: <1365344298-23917-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We did not allow file data clone within the same file because of
deadlock issues.

However, we now use nested lock to avoid deadlock between the
parent directory and the child file.

So it's safe to do file clone at different offset within the
same file.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 898c572..fa66b41 100644
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
@@ -2839,7 +2844,8 @@ out:
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

