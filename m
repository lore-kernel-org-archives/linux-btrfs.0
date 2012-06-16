Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55129 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2FPMie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jun 2012 08:38:34 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn6so435356wib.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jun 2012 05:38:33 -0700 (PDT)
From: Andrei Popa <andrei.popa@i-neo.ro>
To: linux-btrfs@vger.kernel.org
Cc: Andrei Popa <andrei.popa@i-neo.ro>
Subject: [PATCH] Btrfs: Fix NOCOW file attribute
Date: Sat, 16 Jun 2012 15:37:12 +0300
Message-Id: <1339850232-25584-2-git-send-email-andrei.popa@i-neo.ro>
In-Reply-To: <1339850232-25584-1-git-send-email-andrei.popa@i-neo.ro>
References: <1339850232-25584-1-git-send-email-andrei.popa@i-neo.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds BTRFS_INODE_NODATASUM to inode flags when setting NOCOW for a file (chattr +C file).
In btrfs, NOCOW implies NODATASUM and without setting NODATASUM, btrfs doesn't honour correctly the NOCOW attribute.

Signed-off-by: Andrei Popa <andrei.popa@i-neo.ro>
---
 fs/btrfs/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e92e57..8a7be76 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -139,7 +139,7 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 	}
 
 	if (flags & BTRFS_INODE_NODATACOW)
-		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW | BTRFS_INODE_NODATASUM;
 
 	btrfs_update_iflags(inode);
 }
@@ -236,7 +236,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	else
 		ip->flags &= ~BTRFS_INODE_DIRSYNC;
 	if (flags & FS_NOCOW_FL)
-		ip->flags |= BTRFS_INODE_NODATACOW;
+		ip->flags |= BTRFS_INODE_NODATACOW | BTRFS_INODE_NODATASUM;
 	else
 		ip->flags &= ~BTRFS_INODE_NODATACOW;
 
-- 
1.7.3.4

