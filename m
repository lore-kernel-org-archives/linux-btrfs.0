Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11649 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2JVLjb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 07:39:31 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9MBdOuE007049
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 19:39:24 +0800
Message-ID: <50853089.6010801@cn.fujitsu.com>
Date: Mon, 22 Oct 2012 19:39:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: do not delete a subvolume which is in a R/O subvolume
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Step to reproduce:
 # mkfs.btrfs <disk>
 # mount <disk> <mnt>
 # btrfs sub create <mnt>/subv0
 # btrfs sub snap <mnt> <mnt>/subv0/snap0
 # change <mnt>/subv0 from R/W to R/O
 # btrfs sub del <mnt>/subv0/snap0

We deleted the snapshot successfully. I think we should not be able to delete
the snapshot since the parent subvolume is R/O.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 29fb07c..54c56c7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2061,13 +2061,13 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		err = -EINVAL;
 		if (root == dest)
 			goto out_dput;
-
-		/* check if subvolume may be deleted by a non-root user */
-		err = btrfs_may_delete(dir, dentry, 1);
-		if (err)
-			goto out_dput;
 	}
 
+	/* check if subvolume may be deleted by a user */
+	err = btrfs_may_delete(dir, dentry, 1);
+	if (err)
+		goto out_dput;
+
 	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
 		err = -EINVAL;
 		goto out_dput;
-- 
1.7.6.5
