Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:35147 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2HXWo2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 18:44:28 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 006C980079
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 15:44:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id CB62480079
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 15:44:27 -0700 (PDT)
Date: Fri, 24 Aug 2012 15:44:27 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: pass lockdep rwsem metadata to async commit
 transaction
Message-ID: <alpine.DEB.2.00.1208241439490.26910@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The freeze rwsem is taken by sb_start_intwrite() and dropped during the
commit_ or end_transaction().  In the async case, that happens in a worker
thread.  Tell lockdep the calling thread is releasing ownership of the
rwsem and the async thread is picking it up.

Josef and I worked out a more complicated solution that made the async 
commit thread join and potentially get a later transaction, but it failed 
my initial smoke test and Dave pointed out that XFS avoids the issue by 
just telling lockdep what's up.  This is much simpler.  XFS does the same
thing in fs/xfs/xfs_aops.c.

Signed-off-by: Sage Weil <sage@inktank.com>
---
 fs/btrfs/transaction.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

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
1.7.9

