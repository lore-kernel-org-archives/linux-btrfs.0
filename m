Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57242 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbbKPHH0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:07:26 -0500
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 17:07:24 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 70D382BB003F
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:07:22 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG77DXd64028894
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:07:22 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG76msB030883
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:49 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V9 10/12] Btrfs: Fix block size returned to user space
Date: Mon, 16 Nov 2015 12:35:30 +0530
Message-Id: <1447657532-9393-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_getattr() returns PAGE_CACHE_SIZE as the block size. Since
generic_fillattr() already does the right thing (by obtaining block size
from inode->i_blkbits), just remove the statement from btrfs_getattr.

Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5fe6c8d..812be32 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9308,7 +9308,6 @@ static int btrfs_getattr(struct vfsmount *mnt,
 
 	generic_fillattr(inode, stat);
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
-	stat->blksize = PAGE_CACHE_SIZE;
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	delalloc_bytes = BTRFS_I(inode)->delalloc_bytes;
-- 
2.1.0

