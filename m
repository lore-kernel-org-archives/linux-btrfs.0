Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:48893 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbbDTInh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 04:43:37 -0400
Message-ID: <5534BC29.9010004@huawei.com>
Date: Mon, 20 Apr 2015 16:43:21 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <jbacik@fb.com>, <clm@fb.com>, <dsterba@suse.cz>, <fabf@skynet.be>
CC: "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: [PATCH] fs/btrfs: use inode_set_flags() instead of set_mask_bits()
References: <1429518517-29275-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1429518517-29275-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use inode_set_flags() instead of set_mask_bits() according to
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




