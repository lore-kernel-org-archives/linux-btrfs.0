Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50468 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbFIMJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 08:09:39 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 9 Jun 2015 22:09:37 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 12F9C2BB0047
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2015 22:09:34 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t59C9ONY58196166
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 22:09:33 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t59C90of000792
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 22:09:01 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, chandan@mykolab.com
Subject: [PATCH] Btrfs: btrfs_defrag_file: Fix ra_index computation.
Date: Tue,  9 Jun 2015 17:38:32 +0530
Message-Id: <1433851712-22175-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Read-ahead is done for the pages in the range [ra_index, ra_index + cluster -
1]. So the next read-ahead should be starting from the page at index 'ra_index
+ cluster' (unless we deemed that the extent at 'ra_index + cluster' as
non-defraggable) rather than from the page at index 'ra_index +
max_cluster'. This patch fixes this. I did run the xfstests suite to make sure
that the code does not regress.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ca5d968..3ddd74a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1368,7 +1368,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			ra_index = max(i, ra_index);
 			btrfs_force_ra(inode->i_mapping, ra, file, ra_index,
 				       cluster);
-			ra_index += max_cluster;
+			ra_index += cluster;
 		}
 
 		mutex_lock(&inode->i_mutex);
-- 
2.1.0

