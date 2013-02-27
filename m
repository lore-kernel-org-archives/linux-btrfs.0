Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27979 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953Ab3B0NaB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:30:01 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1RDU0Go005127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 13:30:01 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1RDU07l009501
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 13:30:00 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1RDU0qO017358
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 07:30:00 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix NULL pointer after aborting a transaction
Date: Wed, 27 Feb 2013 21:28:25 +0800
Message-Id: <1361971705-8933-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1361971705-8933-1-git-send-email-bo.li.liu@oracle.com>
References: <1361971705-8933-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While doing cleanup work on an aborted transaction, we've set
the global running transaction pointer to NULL _before_ waiting all
other transaction handles to finish, so others'd hit NULL pointer
crash when referencing the global running transaction pointer.

This first sets a hint to avoid new transaction handle joining, then
waits other existing handles to abort or finish so that we can safely
set the above global pointer to NULL.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/transaction.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5878bb4..4caa1fa 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1387,6 +1387,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, int err)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
+	DEFINE_WAIT(wait);
 
 	WARN_ON(trans->use_count > 1);
 
@@ -1395,8 +1396,13 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 	spin_lock(&root->fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
 	if (cur_trans == root->fs_info->running_transaction) {
+		root->fs_info->trans_no_join = 1;
+		spin_unlock(&root->fs_info->trans_lock);
+		wait_event(cur_trans->writer_wait,
+			   atomic_read(&cur_trans->num_writers) == 1);
+
+		spin_lock(&root->fs_info->trans_lock);
 		root->fs_info->running_transaction = NULL;
-		root->fs_info->trans_no_join = 0;
 	}
 	spin_unlock(&root->fs_info->trans_lock);
 
-- 
1.7.7

