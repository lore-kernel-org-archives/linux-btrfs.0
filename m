Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48575 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3L3HvX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 02:51:23 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBU7pM1D012895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 07:51:23 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBU7pMFZ012720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 07:51:22 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBU7pMxQ021580
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 07:51:22 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use WARN_ON_ONCE instead for btrfs_invalidate_inodes
Date: Mon, 30 Dec 2013 15:51:14 +0800
Message-Id: <1388389874-29141-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So after transaction is aborted, we need to cleanup inode resources by
calling btrfs_invalidate_inodes(), and btrfs_invalidate_inodes() hopes
roots' refs to be zero in old times and sets a WARN_ON(), however, this
is not always true within cleaning up transaction, so WARN_ON_ONCE() is
better, and we won't get another syslog message bomb.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1a7744..ef7f6af 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4761,7 +4761,7 @@ void btrfs_invalidate_inodes(struct btrfs_root *root)
 	struct inode *inode;
 	u64 objectid = 0;
 
-	WARN_ON(btrfs_root_refs(&root->root_item) != 0);
+	WARN_ON_ONCE(btrfs_root_refs(&root->root_item) != 0);
 
 	spin_lock(&root->inode_lock);
 again:
-- 
1.8.2.1

