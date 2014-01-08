Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ae0-f53.auone-net.jp ([106.187.230.53]:33131 "EHLO
	dmta02.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755605AbaAHLIB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 06:08:01 -0500
Date: Wed, 8 Jan 2014 19:46:19 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: Return EXDEV for cross file system snapshot
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <52cd2c7c00011d8a00004f4e0000743e400004e23b8c@amlmta033.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

EXDEV seems an appropriate error if an operation fails bacause it
crosses file system boundaries.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21da576..15d35cb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1544,7 +1544,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		if (src_inode->i_sb != file_inode(file)->i_sb) {
 			printk(KERN_INFO "btrfs: Snapshot src from "
 			       "another FS\n");
-			ret = -EINVAL;
+			ret = -EXDEV;
 		} else {
 			ret = btrfs_mksubvol(&file->f_path, name, namelen,
 					     BTRFS_I(src_inode)->root,
-- 
1.8.5.2

