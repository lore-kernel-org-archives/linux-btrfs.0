Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57766 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990AbbHIPLC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Aug 2015 11:11:02 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 10 Aug 2015 01:11:01 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 2CCFD2BB005C
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:59 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t79FAoPx20906054
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:58 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t79FAPKo009479
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:26 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V3 10/11] Btrfs: Fix block size returned to user space
Date: Sun,  9 Aug 2015 20:39:31 +0530
Message-Id: <1439132972-24321-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1439132972-24321-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1439132972-24321-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 99288ff..a34e5f7 100644
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

