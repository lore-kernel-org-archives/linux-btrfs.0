Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17707 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2HVDOs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 23:14:48 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7M3EkFn002866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2012 03:14:47 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7M3EkEN000996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2012 03:14:46 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7M3Ek0u011891
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2012 22:14:46 -0500
From: bo.li.liu@oracle.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix ordered extent leak when failing to start a transaction
Date: Wed, 22 Aug 2012 11:13:25 +0800
Message-Id: <1345605205-18685-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <bo.li.liu@oracle.com>

We cannot just return error before freeing ordered extent and releasing reserved
space when we fail to start a transacion.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7131fac..f6c43ff 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1883,8 +1883,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 				trans = btrfs_join_transaction_nolock(root);
 			else
 				trans = btrfs_join_transaction(root);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				trans = NULL;
+				goto out;
+			}
 			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 			ret = btrfs_update_inode_fallback(trans, root, inode);
 			if (ret) /* -ENOMEM or corruption */
-- 
1.7.7.6

