Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54028 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932250AbbDQSVg (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 17 Apr 2015 14:21:36 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] Btrfs: fix data loss after concurrent fsyncs for files in the same subvol
Date: Fri, 17 Apr 2015 19:20:46 +0100
Message-Id: <1429294846-9021-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1429289031-1088-1-git-send-email-fdmanana@suse.com>
References: <1429289031-1088-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have concurrent fsync calls against files living in the same subvolume,
we have some time window where we don't add the collected ordered extents
to the running transaction's list of ordered extents and return success to
userspace. This can result in data loss if the ordered extents complete after
the current transaction commits and a power failure happens after the current
transaction commits and before the next one commits.

A sequence of steps that lead to this:

        CPU 0                                                         CPU 1

btrfs_sync_file(inode A)                               btrfs_sync_file(inode B)
  btrfs_log_inode_parent()                               btrfs_log_inode_parent()

    start_log_trans()
      lock root->log_mutex
      ctx->log_transid = root->log_transid = N
      unlock root->log_mutex

                                                           start_log_trans()
                                                             lock root->log_mutex
                                                             ctx->log_transid = root->log_transid = N
                                                             unlock root->log_mutex

    btrfs_log_inode()                                          btrfs_log_inode()
      btrfs_get_logged_extents()                                 btrfs_get_logged_extents()
         --> gets orderede extent A                                -> gets ordered extent B
             into local list logged_list                              into local list logged_list
      write items into the log tree                              write items into the log tree
      btrfs_submit_logged_extents(&logged_list)
        --> splices logged_list into
            log_root->logged_list[N % 2]
            (N == log_root->log_transid)

  btrfs_sync_log()
    lock root->log_mutex

    atomic_set(&root->log_commit[N % 2], 1)
      (N == ctx->log_transid)

    btrfs_write_marked_extents()

    root->log_transid++
      --> becomes N + 1
    log_root->log_transid = root->log_transid

    unlock root->log_mutex

                                                                 btrfs_submit_logged_extents(&logged_list)
                                                                   --> splices logged_list into
                                                                       log_root->logged_list[(N + 1) % 2]
                                                                       (N + 1 == log_root->log_transid)

                                                       btrfs_sync_log()
                                                         lock root->log_mutex

                                                         atomic_read(&root->log_commit[N % 2]) == 1
                                                           (N == ctx->log_transid)

                                                           wait on root->log_commit_wait[N % 2]
                                                           (where N == ctx->log_transid) for
                                                           atomic_read(&root->log_commit[N % 2] == 0
                                                           and root->log_transid_committed == N

    btrfs_wait_marked_extents()
    btrfs_wait_logged_extents()
      --> adds ordered extents from
          log_root->logged_list[N % 2] to
          the trans->ordered list
          (N == ctx->log_transid)
    write_ctree_super()

    lock root->log_mutex
    root->log_transid_committed++;
      --> becomes N
    unlock root->log_mutex
    wake_up(&root->log_commit_wait[N % 2])
      (N == ctx->log_transid)

  btrfs_sync_file(inode A) returns 0 to userspace

                                                         wakes up from root->log_commit_wait[N % 2]
                                                         returns 0 from btrfs_sync_log() immediately
                                                       btrfs_sync_file(inode B) returns 0 to userspace

                        some time later current transaction commit starts
                          waits for ordered extent A to complete
                        transaction commit finishes

                        ********* power failure ************

                        ordered extent B completes (updates subvol and csum trees)

Fix this by ensuring that we add the collected ordered extents into the
current transaction's ordered list if when syncing the log we return early
because we found our log transaction was already committed or we end up
waiting for a matching log transaction commit that is ongoing to complete.

CC: <stable@vger.kernel.org>  # 3.18+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Add the ordered extents to the transaction even if ctx->log_ret is
    non-zero, to avoid leaking ordered extents in that case.

 fs/btrfs/ordered-data.c | 3 ++-
 fs/btrfs/tree-log.c     | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 72b6f0d..7005eb7 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -509,7 +509,8 @@ void btrfs_wait_logged_extents(struct btrfs_trans_handle *trans,
 		wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
 						   &ordered->flags));
 
-		list_add_tail(&ordered->trans_list, &trans->ordered);
+		if (list_empty(&ordered->trans_list))
+			list_add_tail(&ordered->trans_list, &trans->ordered);
 		spin_lock_irq(&log->log_extents_lock[index]);
 	}
 	spin_unlock_irq(&log->log_extents_lock[index]);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2fd95a7..7dd88e6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2635,6 +2635,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	log_transid = ctx->log_transid;
 	if (root->log_transid_committed >= log_transid) {
 		mutex_unlock(&root->log_mutex);
+		btrfs_wait_logged_extents(trans, log, log_transid);
 		return ctx->log_ret;
 	}
 
@@ -2642,6 +2643,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (atomic_read(&root->log_commit[index1])) {
 		wait_log_commit(trans, root, log_transid);
 		mutex_unlock(&root->log_mutex);
+		btrfs_wait_logged_extents(trans, log, log_transid);
 		return ctx->log_ret;
 	}
 	ASSERT(log_transid == root->log_transid);
-- 
2.1.3

