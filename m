From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set no_trans_join after trying to expand the transaction
Date: Tue, 14 Jun 2011 16:25:39 -0400
Message-ID: <1308083139-23734-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, jaschut@sandia.gov
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We can lockup if we try to allow new writers join the transaction and we have
flushoncommit set or have a pending snapshot.  This is because we set
no_trans_join and then loop around and try to wait for ordered extents again.
The problem is the ordered endio stuff needs to join the transaction, which it
can't do because no_trans_join is set.  So instead wait until after this loop to
set no_trans_join and then make sure to wait for num_writers == 1 in case
anybody got started in between us exiting the loop and setting no_trans_join.
This could easily be reproduced by mounting -o flushoncommit and running xfstest
13.  It cannot be reproduced with this patch.  Thanks,

Reported-by: Jim Schutt <jaschut@sandia.gov>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8754997..d0f1c07 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1239,12 +1239,20 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			schedule_timeout(1);
 
 		finish_wait(&cur_trans->writer_wait, &wait);
-		spin_lock(&root->fs_info->trans_lock);
-		root->fs_info->trans_no_join = 1;
-		spin_unlock(&root->fs_info->trans_lock);
 	} while (atomic_read(&cur_trans->num_writers) > 1 ||
 		 (should_grow && cur_trans->num_joined != joined));
 
+	/*
+	 * Ok now we need to make sure to block out any other joins while we
+	 * commit the transaction.  We could have started a join before setting
+	 * no_join so make sure to wait for num_writers to == 1 again.
+	 */
+	spin_lock(&root->fs_info->trans_lock);
+	root->fs_info->trans_no_join = 1;
+	spin_unlock(&root->fs_info->trans_lock);
+	wait_event(cur_trans->writer_wait,
+		   atomic_read(&cur_trans->num_writers) == 1);
+
 	ret = create_pending_snapshots(trans, root->fs_info);
 	BUG_ON(ret);
 
-- 
1.7.5.2

