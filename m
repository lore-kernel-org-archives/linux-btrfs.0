Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2FNIQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:02 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/10] Btrfs: remove unused FS_NOCOMP_FL check in setflags and getflags
Date: Thu, 14 Jun 2012 16:23:17 +0800
Message-Id: <1339662206-5307-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

chattr only uses FS_COMPR_FL to switch on/off the compression flag,
so we don't need these FS_NOCOMP_FL checks.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 24b776c..57380ee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -85,11 +85,9 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
-
-	if ((flags & BTRFS_INODE_COMPRESS) && !(flags & BTRFS_INODE_NOCOMPRESS))
+	if ((flags & BTRFS_INODE_COMPRESS) &&
+	    !(flags & BTRFS_INODE_NOCOMPRESS))
 		iflags |= FS_COMPR_FL;
-	else if (flags & BTRFS_INODE_NOCOMPRESS)
-		iflags |= FS_NOCOMP_FL;
 
 	return iflags;
 }
@@ -158,13 +156,9 @@ static int check_flags(unsigned int flags)
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
-		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_COMPR_FL | FS_NOCOW_FL))
 		return -EOPNOTSUPP;
 
-	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
-		return -EINVAL;
-
 	return 0;
 }
 
@@ -244,10 +238,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	 * flag may be changed automatically if compression code won't make
 	 * things smaller.
 	 */
-	if (flags & FS_NOCOMP_FL) {
-		ip->flags &= ~BTRFS_INODE_COMPRESS;
-		ip->flags |= BTRFS_INODE_NOCOMPRESS;
-	} else if (flags & FS_COMPR_FL) {
+	if (flags & FS_COMPR_FL) {
 		ip->flags |= BTRFS_INODE_COMPRESS;
 		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
 	} else {
-- 
1.6.5.2

