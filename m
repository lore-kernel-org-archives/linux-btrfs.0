Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36167 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab3BLWKn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 17:10:43 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AA6D77C0416
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 15:10:42 -0700 (MST)
Date: Tue, 12 Feb 2013 17:10:40 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <miaox@cn.fujitsu.com>
Subject: [RFC] fix async ordered operations flush deadlock
Message-ID: <20130212221040.GA1247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

So btrfs_commit_transaction does this

ret = btrfs_run_ordered_operations(root, 0);

which async flushes all inodes on the ordered operations list.  The problem with
this is that we wait for this flushing to finish, so we end up with this

Task 1				Task 2			Task 3

start transaction
				set trans_no_join
				wait forever
commit
btrfs_run_ordered_operations
	async flush inode				cow_file_range
								join_transaction
								wait forever
	wait forever

Task1 is waiting for the flushint to finish, task 2 is waiting for task 1 to
give up its num_writers, and task 3 is waiting to join the transaction.  This
used to work fine because the flushing was done inline so we just took on the
current journal info of the guy who managed to race in and get a ref on the
transaction, but now we've gotten rid of that by doing it async.  Here is a
basic bullshit patch that just moves the flushing below the "is somebody else
committing right now?" logic which will hopefully fix the problem, but it's a
shit patch but its 5:10 and I need to go make Liam dinner.  I'll try to think of
a better solution between now and tomorrow, but I'm open to suggestions.
Thanks,

Josef


diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 49c79b3..8c50495 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1480,13 +1480,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	int should_grow = 0;
 	unsigned long now = get_seconds();
 
-	ret = btrfs_run_ordered_operations(root, 0);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		btrfs_end_transaction(trans, root);
-		return ret;
-	}
-
 	/* Stop the commit early if ->aborted is set */
 	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
@@ -1541,6 +1534,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	spin_unlock(&cur_trans->commit_lock);
 	wake_up(&root->fs_info->transaction_blocked_wait);
 
+	ret = btrfs_run_ordered_operations(root, 0);
+	if (ret)
+		goto cleanup_transaction;
+
 	spin_lock(&root->fs_info->trans_lock);
 	if (cur_trans->list.prev != &root->fs_info->trans_list) {
 		prev_trans = list_entry(cur_trans->list.prev,
