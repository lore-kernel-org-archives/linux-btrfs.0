Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20945 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3CDQ11 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 11:27:27 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r24GRQXo027930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:26 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r24GRPmJ002076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:26 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r24GRPDS021074
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 10:27:25 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] Btrfs: avoid deadlock on transaction waiting list
Date: Tue,  5 Mar 2013 00:25:41 +0800
Message-Id: <1362414341-17306-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only let one trans handle to wait for other handles, otherwise we
will get ABBA issues.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/transaction.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4caa1fa..7cc38ed 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1394,6 +1394,13 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 	btrfs_abort_transaction(trans, root, err);
 
 	spin_lock(&root->fs_info->trans_lock);
+
+	if (list_empty(&cur_trans->list)) {
+		spin_unlock(&root->fs_info->trans_lock);
+		btrfs_end_transaction(trans, root);
+		return;
+	}
+
 	list_del_init(&cur_trans->list);
 	if (cur_trans == root->fs_info->running_transaction) {
 		root->fs_info->trans_no_join = 1;
-- 
1.7.7

