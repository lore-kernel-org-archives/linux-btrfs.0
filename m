Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:59499 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbcAUK10 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 05:27:26 -0500
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 21 Jan 2016 20:27:23 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id A7C7C2CE8054
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:21 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0LARDFa38928634
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:21 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0LAQmTr014808
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:26:49 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH V10 12/12] Btrfs: btrfs_ioctl_clone: Truncate complete page after performing clone operation
Date: Thu, 21 Jan 2016 15:56:04 +0530
Message-Id: <1453371964-4917-13-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, the "destination offset" argument passed to
the btrfs_ioctl_clone() can be aligned to sectorsize but may not be
necessarily aligned to the machine's page size. In such cases,
truncate_inode_pages_range() ends up zeroing out the partial page and future
read operations will return incorrect data. Hence this commit explicitly
rounds down the "destination offset" to the machine's page size.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8bbecda..4e11059 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3914,8 +3914,9 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	 * Truncate page cache pages so that future reads will see the cloned
 	 * data immediately and not the previous data.
 	 */
-	truncate_inode_pages_range(&inode->i_data, destoff,
-				   PAGE_CACHE_ALIGN(destoff + len) - 1);
+	truncate_inode_pages_range(&inode->i_data,
+				round_down(destoff, PAGE_CACHE_SIZE),
+				round_up(destoff + len, PAGE_CACHE_SIZE) - 1);
 out_unlock:
 	if (!same_inode)
 		btrfs_double_inode_unlock(src, inode);
-- 
2.1.0

