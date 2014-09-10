Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47940 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaIJOLW (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 10 Sep 2014 10:11:22 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: add missing compression property remove in btrfs_ioctl_setflags
Date: Wed, 10 Sep 2014 16:10:24 +0100
Message-Id: <1410361824-12676-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The behaviour of a 'chattr -c' consists of getting the current flags,
clearing the FS_COMPR_FL bit and then sending the result to the set
flags ioctl - this means the bit FS_NOCOMP_FL isn't set in the flags
passed to the ioctl. This results in the compression property not being
cleared from the inode - it was cleared only if the bit FS_NOCOMP_FL
was set in the received flags.

Reproducer:

    $ mkfs.btrfs -f /dev/sdd
    $ mount /dev/sdd /mnt && cd /mnt
    $ mkdir a
    $ chattr +c a
    $ touch a/file
    $ lsattr a/file
    --------c------- a/file
    $ chattr -c a
    $ touch a/file2
    $ lsattr a/file2
    --------c------- a/file2
    $ lsattr -d a
    ---------------- a

Reported-by: Andreas Schneider <asn@cryptomilk.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a010c44..8e6950c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -333,6 +333,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	} else {
 		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
+		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
+		if (ret && ret != -ENODATA)
+			goto out_drop;
 	}
 
 	trans = btrfs_start_transaction(root, 1);
-- 
1.9.1

