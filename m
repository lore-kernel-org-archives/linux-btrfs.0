Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26288 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2IKOfk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 10:35:40 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH v3] Btrfs: fix a bug of per-file nocow
Date: Tue, 11 Sep 2012 22:33:50 +0800
Message-Id: <1347374030-5832-1-git-send-email-bo.li.liu@oracle.com>
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
v3: fix my stupid finger error.

 fs/btrfs/inode.c |    3 +--
 fs/btrfs/ioctl.c |    5 ++++-
 2 files changed, 5 insertions(+), 3 deletions(-)

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
index 00ddf22..6c867ec 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -140,8 +140,11 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 		BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
 	}
 
-	if (flags & BTRFS_INODE_NODATACOW)
+	if (flags & BTRFS_INODE_NODATACOW) {
 		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
+		if (S_ISREG(inode->i_mode))
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
+	}
 
 	btrfs_update_iflags(inode);
 }
-- 
1.7.7.6

