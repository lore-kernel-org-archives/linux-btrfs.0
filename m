Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759929Ab2FAN4B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jun 2012 09:56:01 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q51Du1e7032265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:56:01 -0400
Received: from localhost.localdomain.com (vpn-9-98.rdu.redhat.com [10.11.9.98])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q51Dtwnk031587
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:56:01 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] Btrfs: wake up transaction waiters when aborting a transaction
Date: Fri,  1 Jun 2012 09:55:52 -0400
Message-Id: <1338558955-4944-5-git-send-email-josef@redhat.com>
In-Reply-To: <1338558955-4944-1-git-send-email-josef@redhat.com>
References: <1338558955-4944-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was getting lots of hung tasks and a NULL pointer dereference because we
are not cleaning up the transaction properly when it aborts.  First we need
to reset the running_transaction to NULL so we don't get a bad dereference
for any start_transaction callers after this.  Also we cannot rely on
waitqueue_active() since it's just a list_empty(), so just call wake_up()
directly since that will do the barrier for us and such.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c     |    9 +++------
 fs/btrfs/transaction.c |    4 ++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0224c25..050db9b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3584,16 +3584,13 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	/* FIXME: cleanup wait for commit */
 	cur_trans->in_commit = 1;
 	cur_trans->blocked = 1;
-	if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
-		wake_up(&root->fs_info->transaction_blocked_wait);
+	wake_up(&root->fs_info->transaction_blocked_wait);
 
 	cur_trans->blocked = 0;
-	if (waitqueue_active(&root->fs_info->transaction_wait))
-		wake_up(&root->fs_info->transaction_wait);
+	wake_up(&root->fs_info->transaction_wait);
 
 	cur_trans->commit_done = 1;
-	if (waitqueue_active(&cur_trans->commit_wait))
-		wake_up(&cur_trans->commit_wait);
+	wake_up(&cur_trans->commit_wait);
 
 	btrfs_destroy_pending_snapshots(cur_trans);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7aed0e8..4e6f63e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1205,6 +1205,10 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 
 	spin_lock(&root->fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
+	if (cur_trans == root->fs_info->running_transaction) {
+		root->fs_info->running_transaction = NULL;
+		root->fs_info->trans_no_join = 0;
+	}
 	spin_unlock(&root->fs_info->trans_lock);
 
 	btrfs_cleanup_one_transaction(trans->transaction, root);
-- 
1.7.7.6

