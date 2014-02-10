Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46282 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaBJJhf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 04:37:35 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1A9bYD8022774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 09:37:35 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1A9bXsn029752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 09:37:33 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s1A9bWiD018966
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 09:37:33 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: avoid warning bomb of btrfs_invalidate_inodes
Date: Mon, 10 Feb 2014 17:37:25 +0800
Message-Id: <1392025045-26201-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <52C8A9F7.6080701@fb.com>
References: <52C8A9F7.6080701@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So after transaction is aborted, we need to cleanup inode resources by
calling btrfs_invalidate_inodes(), and btrfs_invalidate_inodes() hopes
roots' refs to be zero in old times and sets a WARN_ON(), however, this
is not always true within cleaning up transaction, so we get to detect
transaction abortion and not warn at all.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Follow Josef's advice, ie. in case of aborting transaction, we no more warn.

 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af34d0..e876c1e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4920,7 +4920,8 @@ void btrfs_invalidate_inodes(struct btrfs_root *root)
 	struct inode *inode;
 	u64 objectid = 0;
 
-	WARN_ON(btrfs_root_refs(&root->root_item) != 0);
+	if (!test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
+		WARN_ON(btrfs_root_refs(&root->root_item) != 0);
 
 	spin_lock(&root->inode_lock);
 again:
-- 
1.8.1.4

