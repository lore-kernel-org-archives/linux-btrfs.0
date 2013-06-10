Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37367 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3FJUuk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 16:50:40 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C349E9A0363
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:50:39 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 8l43J5QycrnKDvdG (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:50:39 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: stop waiting on current trans if we aborted
Date: Mon, 10 Jun 2013 16:50:36 -0400
Message-ID: <1370897436-8205-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit a hang when run_delayed_refs returned an error in the beginning of
btrfs_commit_transaction.  If we decide we need to commit the transaction in
btrfs_end_transaction we'll set BLOCKED and start to commit, but if we get an
error this early on we'll just exit without committing.  This is fine, except
that anybody else who tried to start a transaction will sit in
wait_current_trans() since we're set to BLOCKED and we never set it to something
else and woke people up.  To fix this we want to check for trans->aborted
everywhere we wait for the transaction state to change, and make
btrfs_abort_transaction() wake up any waiters there may be.  All the callers
will notice that the transaction has aborted and exit out properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c       |    3 +++
 fs/btrfs/transaction.c |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 14d2be0..8eb6191 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -265,6 +265,9 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 		return;
 	}
 	ACCESS_ONCE(trans->transaction->aborted) = errno;
+	/* Wake up anybody who may be waiting on this transaction */
+	wake_up(&root->fs_info->transaction_wait);
+	wake_up(&root->fs_info->transaction_blocked_wait);
 	__btrfs_std_error(root->fs_info, function, line, errno, NULL);
 }
 /*
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8c8b800..c11b7ef 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -302,7 +302,8 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 static inline int is_transaction_blocked(struct btrfs_transaction *trans)
 {
 	return (trans->state >= TRANS_STATE_BLOCKED &&
-		trans->state < TRANS_STATE_UNBLOCKED);
+		trans->state < TRANS_STATE_UNBLOCKED &&
+		!trans->aborted);
 }
 
 /* wait for commit against the current transaction to become unblocked
@@ -320,7 +321,8 @@ static void wait_current_trans(struct btrfs_root *root)
 		spin_unlock(&root->fs_info->trans_lock);
 
 		wait_event(root->fs_info->transaction_wait,
-			   cur_trans->state >= TRANS_STATE_UNBLOCKED);
+			   cur_trans->state >= TRANS_STATE_UNBLOCKED ||
+			   cur_trans->aborted);
 		put_transaction(cur_trans);
 	} else {
 		spin_unlock(&root->fs_info->trans_lock);
@@ -1392,7 +1394,8 @@ static void wait_current_trans_commit_start(struct btrfs_root *root,
 					    struct btrfs_transaction *trans)
 {
 	wait_event(root->fs_info->transaction_blocked_wait,
-		   trans->state >= TRANS_STATE_COMMIT_START);
+		   trans->state >= TRANS_STATE_COMMIT_START ||
+		   trans->aborted);
 }
 
 /*
@@ -1403,7 +1406,8 @@ static void wait_current_trans_commit_start_and_unblock(struct btrfs_root *root,
 					 struct btrfs_transaction *trans)
 {
 	wait_event(root->fs_info->transaction_wait,
-		   trans->state >= TRANS_STATE_UNBLOCKED);
+		   trans->state >= TRANS_STATE_UNBLOCKED ||
+		   trans->aborted);
 }
 
 /*
-- 
1.7.7.6

