Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:43162 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2H3W0W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 18:26:22 -0400
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>
Subject: [PATCH 1/3] Btrfs: pass lockdep rwsem metadata to async commit transaction
Date: Thu, 30 Aug 2012 15:26:15 -0700
Message-Id: <1346365577-9405-2-git-send-email-sage@inktank.com>
In-Reply-To: <1346365577-9405-1-git-send-email-sage@inktank.com>
References: <1346365577-9405-1-git-send-email-sage@inktank.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The freeze rwsem is taken by sb_start_intwrite() and dropped during the
commit_ or end_transaction().  In the async case, that happens in a worker
thread.  Tell lockdep the calling thread is releasing ownership of the
rwsem and the async thread is picking it up.

XFS plays the same trick in fs/xfs/xfs_aops.c.

Signed-off-by: Sage Weil <sage@inktank.com>
---
 fs/btrfs/transaction.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 17be3de..efc41a5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1228,6 +1228,14 @@ static void do_async_commit(struct work_struct *work)
 	struct btrfs_async_commit *ac =
 		container_of(work, struct btrfs_async_commit, work.work);
 
+	/*
+	 * We've got freeze protection passed with the transaction.
+	 * Tell lockdep about it.
+	 */
+	rwsem_acquire_read(
+		&ac->root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
+		0, 1, _THIS_IP_);
+
 	btrfs_commit_transaction(ac->newtrans, ac->root);
 	kfree(ac);
 }
@@ -1257,6 +1265,14 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	atomic_inc(&cur_trans->use_count);
 
 	btrfs_end_transaction(trans, root);
+
+	/*
+	 * Tell lockdep we've released the freeze rwsem, since the
+	 * async commit thread will be the one to unlock it.
+	 */
+	rwsem_release(&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
+		      1, _THIS_IP_);
+
 	schedule_delayed_work(&ac->work, 0);
 
 	/* wait for transaction to start and unblock */
-- 
1.7.9.5

