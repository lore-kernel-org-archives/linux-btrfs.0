Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39228 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933186AbbDQQyc (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 17 Apr 2015 12:54:32 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: don't attach unnecessary extents to transaction on fsync
Date: Fri, 17 Apr 2015 17:53:48 +0100
Message-Id: <1429289628-2091-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to attach ordered extents that have completed to the current
transaction. Doing so only makes us hold memory for longer than necessary
and delaying the iput of the inode until the transaction is committed (for
each created ordered extent we do an igrab and then schedule an asynchronous
iput when the ordered extent's reference count drops to 0), preventing the
inode from being evictable until the transaction commits.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

This applies on top of my previous patch titled:
"Btrfs: fix data loss after concurrent fsyncs for files in the same subvol"

 fs/btrfs/ordered-data.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 7005eb7..51c75f7 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -509,8 +509,24 @@ void btrfs_wait_logged_extents(struct btrfs_trans_handle *trans,
 		wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
 						   &ordered->flags));
 
-		if (list_empty(&ordered->trans_list))
-			list_add_tail(&ordered->trans_list, &trans->ordered);
+		/*
+		 * If our ordered extent completed it means it updated the
+		 * fs/subvol and csum trees already, so no need to make the
+		 * current transaction's commit wait for it, as we end up
+		 * holding memory unnecessarily and delaying the inode's iput
+		 * until the transaction commit (we schedule an iput for the
+		 * inode when the ordered extent's refcount drops to 0), which
+		 * prevents it from being evictable until the transaction
+		 * commits.
+		 */
+		if (list_empty(&ordered->trans_list)) {
+			if (test_bit(BTRFS_ORDERED_COMPLETE, &ordered->flags))
+				btrfs_put_ordered_extent(ordered);
+			else
+				list_add_tail(&ordered->trans_list,
+					      &trans->ordered);
+		}
+
 		spin_lock_irq(&log->log_extents_lock[index]);
 	}
 	spin_unlock_irq(&log->log_extents_lock[index]);
-- 
2.1.3

