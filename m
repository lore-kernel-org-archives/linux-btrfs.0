Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2JVLiP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 07:38:15 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9MBcB7S007018
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 19:38:11 +0800
Message-ID: <50853040.1030404@cn.fujitsu.com>
Date: Mon, 22 Oct 2012 19:38:40 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: don't check the permission of the subvolume which
 we want to delete
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Step to reproduce:
 # mkfs.btrfs <disk>
 # mount -o user_subvol_rm_allowed <disk> <mnt>
 # mkdir <mnt>/dir0
 # chmod 777 <mnt>/dir0
 # btrfs sub snap <mnt> <mnt>/dir0/snap0
 # su -c "btrfs sub del <mnt>/dir0/snap0" -s /bin/bash nobody
 ERROR: cannot delete '<mnt>/dir0/snap0' - Permission denied

This is because we checked the permission of the subvolume that we want to
delete, and found the user - nobody have no WRITE permission of this subvolume.

I think we need not check the permission of the subvolume we want to delete,
because we have the right to clean up the directory since we have WRITE and
EXECUTE permission, just like rmdir command.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f5a2e6c..29fb07c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2062,10 +2062,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		if (root == dest)
 			goto out_dput;
 
-		err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
-		if (err)
-			goto out_dput;
-
 		/* check if subvolume may be deleted by a non-root user */
 		err = btrfs_may_delete(dir, dentry, 1);
 		if (err)
-- 
1.7.6.5
