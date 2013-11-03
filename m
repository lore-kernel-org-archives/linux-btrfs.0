Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50506 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3KCPYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 10:24:42 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rA3FOfI8017022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 3 Nov 2013 15:24:42 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA3FOfxl027677
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 3 Nov 2013 15:24:41 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA3FOeAm008617
	for <linux-btrfs@vger.kernel.org>; Sun, 3 Nov 2013 15:24:41 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: avoid heavy operations in btrfs_commit_super
Date: Sun,  3 Nov 2013 23:24:34 +0800
Message-Id: <1383492274-30311-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'git blame' history shows that, the old transaction commit code has to do
twice to ensure roots are updated and we have to flush metadata and super block
manually, however, right now all of these can be handled well inside
the transaction commit code without extra efforts.

And the error handling part remains same with the current code, -- 'return to
caller once we get error'.

This saves us a transaction commit and a flush of super block, which are both
heavy operations according to ftrace output analysis.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..d6728c3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3542,25 +3542,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret)
-		return ret;
-	/* run commit again to drop the original snapshot */
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret)
-		return ret;
-	ret = btrfs_write_and_wait_transaction(NULL, root);
-	if (ret) {
-		btrfs_error(root->fs_info, ret,
-			    "Failed to sync btree inode to disk.");
-		return ret;
-	}
-
-	ret = write_ctree_super(NULL, root, 0);
-	return ret;
+	return btrfs_commit_transaction(trans, root);
 }
 
 int close_ctree(struct btrfs_root *root)
-- 
1.8.2.1

