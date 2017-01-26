Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33086 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752061AbdAZBHW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 20:07:22 -0500
Received: by mail-pg0-f46.google.com with SMTP id 204so68811421pge.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 17:07:22 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 2/3] Btrfs: disable xattr operations on subvolume directories
Date: Wed, 25 Jan 2017 17:06:39 -0800
Message-Id: <807c4c0c54fe611c4d0fb399aee36e241e2c6846.1485392101.git.osandov@fb.com>
In-Reply-To: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
References: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
In-Reply-To: <cover.1485392101.git.osandov@fb.com>
References: <cover.1485392101.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

When you snapshot a subvolume containing a subvolume, you get a
placeholder directory where the subvolume would be. These directory
inodes have ->i_ops set to btrfs_dir_ro_inode_operations. Previously,
these i_ops didn't include the xattr operation callbacks. The conversion
to xattr_handlers missed this case, leading to bogus attempts to set
xattrs on these inodes. This manifested itself as failures when running
delayed inodes.

To fix this, clear IOP_XATTR in ->i_opflags on these inodes.

Fixes: 6c6ef9f26e59 ("xattr: Stop calling {get,set,remove}xattr inode operations")
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Reported-by: Chris Murphy <lists@colorremedies.com>
Tested-by: Chris Murphy <lists@colorremedies.com>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ae3989c22718..924f3583a04d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5707,6 +5707,7 @@ static struct inode *new_simple_dir(struct super_block *s,
 
 	inode->i_ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID;
 	inode->i_op = &btrfs_dir_ro_inode_operations;
+	inode->i_opflags &= ~IOP_XATTR;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
 	inode->i_mtime = current_time(inode);
-- 
2.11.0

