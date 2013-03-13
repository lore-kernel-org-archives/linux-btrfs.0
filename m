Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32338 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab3CMNou (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 09:44:50 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH V2] Btrfs: fix warning when creating snapshots
Date: Wed, 13 Mar 2013 21:43:03 +0800
Message-Id: <1363182183-12676-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Creating snapshot passes extent_root to commit its transaction,
but it can lead to the warning of checking root for quota in
the __btrfs_end_transaction() when someone else is committing
the current transaction.  Since we've recorded the needed root
in trans_handle, just use it to get rid of the warning.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: fix stupid finger error, I didn't remove the WARN_ON line.

Josef,

Could you please replace the one in btrfs-next with this one?  Thanks,

 fs/btrfs/transaction.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fedede1..c4a1531 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -626,14 +626,13 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
-	/*
-	 * the same root has to be passed to start_transaction and
-	 * end_transaction. Subvolume quota depends on this.
-	 */
-	WARN_ON(trans->root != root);
 
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

