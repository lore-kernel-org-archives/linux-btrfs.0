Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18823 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3CGJWs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 04:22:48 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r279MlML008807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Mar 2013 09:22:48 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r279MkCF008369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Mar 2013 09:22:47 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r279Mk7N009672
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Mar 2013 03:22:46 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix warning when creating snapshots
Date: Thu,  7 Mar 2013 17:21:11 +0800
Message-Id: <1362648071-20785-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Creating snapshot passes extent_root to commit its transaction,
but it can lead to the warning of checking root for quota in
the __btrfs_end_transaction() when someone else is committing
the current transaction.  Since we've recorded the needed root
in trans_handle, just use it to get rid of the warning.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/transaction.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f11c2e0..5c10871 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -626,14 +626,14 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
-	/*
-	 * the same root has to be passed to start_transaction and
-	 * end_transaction. Subvolume quota depends on this.
-	 */
 	WARN_ON(trans->root != root);
 
 	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		/*
+		 * the same root has to be passed here between start_transaction
+		 * and end_transaction. Subvolume quota depends on this.
+		 */
+		btrfs_qgroup_free(trans->root, trans->qgroup_reserved);
 		trans->qgroup_reserved = 0;
 	}
 
-- 
1.7.7.6

