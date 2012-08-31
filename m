Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50768 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2HaFii (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:38:38 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7V5cZkM019048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:36 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7V5cZLk018229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:35 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7V5cYRV023923
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 00:38:34 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] Btrfs: fix a bug of per-file nocow
Date: Fri, 31 Aug 2012 13:36:54 +0800
Message-Id: <1346391419-4278-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
References: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Users report a bug, the reproducer is:
$ mkfs.btrfs /dev/loop0
$ mount /dev/loop0 /mnt/btrfs/
$ mkdir /mnt/btrfs/dir
$ chattr +C /mnt/btrfs/dir/
$ dd if=/dev/zero of=/mnt/btrfs/dir/foo bs=4K count=10;
$ lsattr /mnt/btrfs/dir/foo
---------------C- /mnt/btrfs/dir/foo
$ filefrag /mnt/btrfs/dir/foo
/mnt/btrfs/dir/foo: 1 extent found    ---> an extent
$ dd if=/dev/zero of=/mnt/btrfs/dir/foo bs=4K count=1 seek=5 conv=notrunc,nocreat; sync
$ filefrag /mnt/btrfs/dir/foo
/mnt/btrfs/dir/foo: 3 extents found   ---> with nocow, btrfs breaks the extent into three parts

The new created file should not only inherit the NODATACOW flag, but also
honor NODATASUM flag, because we must do COW on a file extent with checksum.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    3 +--
 fs/btrfs/ioctl.c |    3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b2c3514..9bce6e9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4720,8 +4720,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if (S_ISREG(mode)) {
 		if (btrfs_test_opt(root, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
-		if (btrfs_test_opt(root, NODATACOW) ||
-		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
+		if (btrfs_test_opt(root, NODATACOW))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 	}
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 00ddf22..7390b25 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -141,7 +141,8 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 	}
 
 	if (flags & BTRFS_INODE_NODATACOW)
-		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
+					 BTRFS_INODE_NODATASUM;
 
 	btrfs_update_iflags(inode);
 }
-- 
1.7.7.6

