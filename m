Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab2F2Jtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:49:31 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9nOaf012593
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:49:26 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4 v2] Btrfs: remove redundant r/o check for superblock
Date: Fri, 29 Jun 2012 17:58:47 +0800
Message-Id: <1340963929-32509-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340963929-32509-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1340963929-32509-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mnt_want_write() and mnt_want_write_file() will check sb->s_flags with
MS_RDONLY, and we don't need to do it ourselves.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b5e946e..069cd85 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1379,14 +1379,10 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 						    u64 *transid,
 						    bool readonly)
 {
-	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct file *src_file;
 	int namelen;
 	int ret = 0;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
-
 	ret = mnt_want_write_file(file);
 	if (ret)
 		goto out;
@@ -3265,9 +3261,6 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
-
 	ret = mnt_want_write(file->f_path.mnt);
 	if (ret)
 		return ret;
-- 
1.6.5.2

