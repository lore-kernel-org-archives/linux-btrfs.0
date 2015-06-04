Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:34440 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbFDGmE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 02:42:04 -0400
Message-ID: <556FF288.4060603@huawei.com>
Date: Thu, 4 Jun 2015 14:39:04 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <jbacik@fb.com>, <clm@fb.com>, <dsterba@suse.cz>, <fabf@skynet.be>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] fs/btrfs: use general inode_set_flags() instead of set_mask_bits()
References: <5534BC29.9010004@huawei.com>
In-Reply-To: <5534BC29.9010004@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use general inode_set_flags() instead of set_mask_bits() according to
commit 5f16f3225b062 ("ext4: atomically set inode->i_flags in
ext4_set_inode_flags()").

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/btrfs/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 74609b9..728b487 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -149,9 +149,8 @@ void btrfs_update_iflags(struct inode *inode)
 	if (ip->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;

-	set_mask_bits(&inode->i_flags,
-		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
-		      new_fl);
+	inode_set_flags(inode, new_fl,
+		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC);
 }

 /*
-- 
1.9.1


.






