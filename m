Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759949Ab2FAN4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jun 2012 09:56:02 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q51Du1aR030213
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:56:01 -0400
Received: from localhost.localdomain.com (vpn-9-98.rdu.redhat.com [10.11.9.98])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q51Dtwnl031587
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:56:01 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] Btrfs: abort the transaction if the commit fails
Date: Fri,  1 Jun 2012 09:55:53 -0400
Message-Id: <1338558955-4944-6-git-send-email-josef@redhat.com>
In-Reply-To: <1338558955-4944-1-git-send-email-josef@redhat.com>
References: <1338558955-4944-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a transaction commit fails we don't abort it so we don't set an error on
the file system.  This patch fixes that by actually calling the abort stuff
and then adding a check for a fs error in the transaction start stuff to
make sure it is caught properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4e6f63e..ead64e1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -99,6 +99,10 @@ loop:
 		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
 		cur_trans = root->fs_info->running_transaction;
 		goto loop;
+	} else if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		spin_unlock(&root->fs_info->trans_lock);
+		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
+		return -EROFS;
 	}
 
 	atomic_set(&cur_trans->num_writers, 1);
@@ -1197,12 +1201,14 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 
 
 static void cleanup_transaction(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root)
+				struct btrfs_root *root, int err)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 
 	WARN_ON(trans->use_count > 1);
 
+	btrfs_abort_transaction(trans, root, err);
+
 	spin_lock(&root->fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
 	if (cur_trans == root->fs_info->running_transaction) {
@@ -1514,7 +1520,7 @@ cleanup_transaction:
 //	WARN_ON(1);
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
-	cleanup_transaction(trans, root);
+	cleanup_transaction(trans, root, ret);
 
 	return ret;
 }
-- 
1.7.7.6

