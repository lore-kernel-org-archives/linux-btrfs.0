Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab2F2Jtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:49:31 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9nSuG012601
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:49:28 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4 v2] Btrfs: do not set subvolume flags in readonly mode
Date: Fri, 29 Jun 2012 17:58:49 +0800
Message-Id: <1340963929-32509-4-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340963929-32509-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1340963929-32509-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ mkfs.btrfs /dev/sdb7
$ btrfstune -S1 /dev/sdb7
$ mount /dev/sdb7 /mnt/btrfs
mount: block device /dev/sdb7 is write-protected, mounting read-only
$ btrfs dev add /dev/sdb8 /mnt/btrfs/

Now we get a btrfs in which mnt flags has readonly but sb flags does
not.  So for those ioctls that only check sb flags with MS_RDONLY, it
is going to be a problem.
Setting subvolume flags is such an ioctl, we should use mnt_want_write_file()
to check RO flags.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
v1->v2: apply Tsutomu Itoh's comments.

 fs/btrfs/ioctl.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index df4c04d..2cf6b1b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1519,29 +1519,40 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	u64 flags;
 	int ret = 0;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
+	ret = mnt_want_write_file(file);
+	if (ret)
+		goto out;
 
-	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID)
-		return -EINVAL;
+	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
+		ret = -EINVAL;
+		goto out_drop_write;
+	}
 
-	if (copy_from_user(&flags, arg, sizeof(flags)))
-		return -EFAULT;
+	if (copy_from_user(&flags, arg, sizeof(flags))) {
+		ret = -EFAULT;
+		goto out_drop_write;
+	}
 
-	if (flags & BTRFS_SUBVOL_CREATE_ASYNC)
-		return -EINVAL;
+	if (flags & BTRFS_SUBVOL_CREATE_ASYNC) {
+		ret = -EINVAL;
+		goto out_drop_write;
+	}
 
-	if (flags & ~BTRFS_SUBVOL_RDONLY)
-		return -EOPNOTSUPP;
+	if (flags & ~BTRFS_SUBVOL_RDONLY) {
+		ret = -EOPNOTSUPP;
+		goto out_drop_write;
+	}
 
-	if (!inode_owner_or_capable(inode))
-		return -EACCES;
+	if (!inode_owner_or_capable(inode)) {
+		ret = -EACCES;
+		goto out_drop_write;
+	}
 
 	down_write(&root->fs_info->subvol_sem);
 
 	/* nothing to do */
 	if (!!(flags & BTRFS_SUBVOL_RDONLY) == btrfs_root_readonly(root))
-		goto out;
+		goto out_drop_sem;
 
 	root_flags = btrfs_root_flags(&root->root_item);
 	if (flags & BTRFS_SUBVOL_RDONLY)
@@ -1564,8 +1575,11 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 out_reset:
 	if (ret)
 		btrfs_set_root_flags(&root->root_item, root_flags);
-out:
+out_drop_sem:
 	up_write(&root->fs_info->subvol_sem);
+out_drop_write:
+	mnt_drop_write_file(file);
+out:
 	return ret;
 }
 
-- 
1.6.5.2

