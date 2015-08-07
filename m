Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35034 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbbHGHHg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 03:07:36 -0400
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 7 Aug 2015 17:07:33 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 4873C2BB005D
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 17:07:32 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7777J5Y61145216
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 17:07:27 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7776xfS032268
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 17:07:00 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com,
        quwenruo@cn.fujitsu.com
Subject: [PATCH V2 10/11] Btrfs: Fix block size returned to user space
Date: Fri,  7 Aug 2015 12:35:57 +0530
Message-Id: <1438931158-20888-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1438931158-20888-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1438931158-20888-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_getattr() returns PAGE_CACHE_SIZE as the block size. Since
generic_fillattr() already does the right thing (by obtaining block size
from inode->i_blkbits), just remove the statement from btrfs_getattr.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index daf2462..ea7d9f1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9164,7 +9164,6 @@ static int btrfs_getattr(struct vfsmount *mnt,
 
 	generic_fillattr(inode, stat);
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
-	stat->blksize = PAGE_CACHE_SIZE;
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	delalloc_bytes = BTRFS_I(inode)->delalloc_bytes;
-- 
2.1.0

