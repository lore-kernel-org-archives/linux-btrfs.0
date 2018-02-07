Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754377AbeBGP4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7FDF8ADCE
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:05 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/14] btrfs: Remove root argument of cleanup_transaction
Date: Wed,  7 Feb 2018 17:55:46 +0200
Message-Id: <1518018950-31456-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only thing the passed root is used for is:
1. get a reference to the fs_info and to
2. call trace_btrfs_transaction_commit.

We can achieve 1) by simply referring to the fs_info from passed trans
object. As far as 2) is concerned cleanup_transaction is called from
only one place and the 'root' argument passed is the one from the trans
handle. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 354143e6d440..b8fd9fe8a9c1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1866,10 +1866,9 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 }
 
 
-static void cleanup_transaction(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, int err)
+static void cleanup_transaction(struct btrfs_trans_handle *trans, int err)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	DEFINE_WAIT(wait);
 
@@ -1909,7 +1908,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 	btrfs_put_transaction(cur_trans);
 	btrfs_put_transaction(cur_trans);
 
-	trace_btrfs_transaction_commit(root);
+	trace_btrfs_transaction_commit(trans->root);
 
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
@@ -2330,7 +2329,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
-	cleanup_transaction(trans, trans->root, ret);
+	cleanup_transaction(trans, ret);
 
 	return ret;
 }
-- 
2.7.4

