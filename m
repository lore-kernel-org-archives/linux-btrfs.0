Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36992 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3I0Ueh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 16:34:37 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 782C49A06B2
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 14:34:37 -0600 (MDT)
Received: from CAS1.int.fusionio.com ([10.101.1.40]) by mx1.fusionio.com with ESMTP id Nn8kjspJBzmXiYLB (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 14:34:36 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup transaction on abort
Date: Fri, 27 Sep 2013 16:34:34 -0400
Message-ID: <1380314074-28804-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we abort not during a transaction commit we won't clean up anything until we
unmount.  Unfortunately if we abort in the middle of writing out an ordered
extent we won't clean it up and if somebody is waiting on that ordered extent
they will wait forever.  To fix this just make the transaction kthread call the
cleanup transaction stuff if it notices theres an error, and make
btrfs_end_transaction wake up the transaction kthread if there is an error.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c     | 3 +++
 fs/btrfs/transaction.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 39427d8..f38211f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1799,6 +1799,9 @@ sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
+		if (unlikely(test_bit(BTRFS_FS_STATE_ERROR,
+				      &root->fs_info->fs_state)))
+			btrfs_cleanup_transaction(root);
 		if (!try_to_freeze()) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop() &&
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2fa7017..72d2b67 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -744,8 +744,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		btrfs_run_delayed_iputs(root);
 
 	if (trans->aborted ||
-	    test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
+	    test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state)) {
+		wake_up_process(info->transaction_kthread);
 		err = -EIO;
+	}
 	assert_qgroups_uptodate(trans);
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-- 
1.8.3.1

