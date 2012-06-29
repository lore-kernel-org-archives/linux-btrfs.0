Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2F2Jt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:49:29 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9nOae012593
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:49:24 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4 v2] Btrfs: check write access to mount earlier while creating snapshots
Date: Fri, 29 Jun 2012 17:58:46 +0800
Message-Id: <1340963929-32509-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move check of write access to mount into upper functions so that we can
use mnt_want_write_file instead, which is faster than mnt_want_write.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e92e57..b5e946e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -652,13 +652,9 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	if (dentry->d_inode)
 		goto out_dput;
 
-	error = mnt_want_write(parent->mnt);
-	if (error)
-		goto out_dput;
-
 	error = btrfs_may_create(dir, dentry);
 	if (error)
-		goto out_drop_write;
+		goto out_dput;
 
 	down_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
 
@@ -676,8 +672,6 @@ static noinline int btrfs_mksubvol(struct path *parent,
 		fsnotify_mkdir(dir, dentry);
 out_up_read:
 	up_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
-out_drop_write:
-	mnt_drop_write(parent->mnt);
 out_dput:
 	dput(dentry);
 out_unlock:
@@ -1393,16 +1387,20 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	ret = mnt_want_write_file(file);
+	if (ret)
+		goto out;
+
 	namelen = strlen(name);
 	if (strchr(name, '/')) {
 		ret = -EINVAL;
-		goto out;
+		goto out_drop_write;
 	}
 
 	if (name[0] == '.' &&
 	   (namelen == 1 || (name[1] == '.' && namelen == 2))) {
 		ret = -EEXIST;
-		goto out;
+		goto out_drop_write;
 	}
 
 	if (subvol) {
@@ -1413,7 +1411,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		src_file = fget(fd);
 		if (!src_file) {
 			ret = -EINVAL;
-			goto out;
+			goto out_drop_write;
 		}
 
 		src_inode = src_file->f_path.dentry->d_inode;
@@ -1422,13 +1420,15 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 			       "another FS\n");
 			ret = -EINVAL;
 			fput(src_file);
-			goto out;
+			goto out_drop_write;
 		}
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
 				     BTRFS_I(src_inode)->root,
 				     transid, readonly);
 		fput(src_file);
 	}
+out_drop_write:
+	mnt_drop_write_file(file);
 out:
 	return ret;
 }
-- 
1.6.5.2

