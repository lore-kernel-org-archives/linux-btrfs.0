Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab2EaPOi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 11:14:38 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VFEcPc021531
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 11:14:38 -0400
Received: from localhost.localdomain.com (vpn-8-248.rdu.redhat.com [10.11.8.248])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4VFEbnA020580
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 11:14:37 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make sure to unblock the transaction when cleaning it up
Date: Thu, 31 May 2012 11:14:37 -0400
Message-Id: <1338477277-5793-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a transaction aborts we can get stuck in places where tasks are waiting
for the transaction to become unblocked.  So we need to unblock the
transaction and wake up any waiters so they can exit properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7aed0e8..1715afb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1204,9 +1204,16 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 	WARN_ON(trans->use_count > 1);
 
 	spin_lock(&root->fs_info->trans_lock);
+	cur_trans->blocked = 0;
 	list_del_init(&cur_trans->list);
+	if (root->fs_info->running_transaction == cur_trans) {
+		root->fs_info->running_transaction = NULL;
+		root->fs_info->trans_no_join = 0;
+	}
 	spin_unlock(&root->fs_info->trans_lock);
 
+	wake_up(&root->fs_info->transaction_wait);
+
 	btrfs_cleanup_one_transaction(trans->transaction, root);
 
 	put_transaction(cur_trans);
-- 
1.7.7.6

