Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39399 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaIKJpk (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 11 Sep 2014 05:45:40 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs: add missing compression property remove in btrfs_ioctl_setflags
Date: Thu, 11 Sep 2014 11:44:49 +0100
Message-Id: <1410432289-21745-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1410361824-12676-1-git-send-email-fdmanana@suse.com>
References: <1410361824-12676-1-git-send-email-fdmanana@suse.com>
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

V2: Ensure BTRFS_INODE_NOCOMPRESS isn't set (unless the bit FS_NOCOMP_FL is set).

 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a010c44..a46c169 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -332,6 +332,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 			goto out_drop;
 
 	} else {
+		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
+		if (ret && ret != -ENODATA)
+			goto out_drop;
 		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
-- 
1.9.1

