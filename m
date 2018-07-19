Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:41971 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbeGSPdr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:47 -0400
Received: by mail-qt0-f194.google.com with SMTP id e19-v6so7401234qtp.8
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:16 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 06/22] btrfs: check if free bgs for commit
Date: Thu, 19 Jul 2018 10:49:50 -0400
Message-Id: <20180719145006.17532-6-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

may_commit_transaction will skip committing the transaction if we don't
have enough pinned space or if we're trying to find space for a SYSTEM
chunk.  However if we have pending free block groups in this transaction
we still want to commit as we may be able to allocate a chunk to make
our reservation.  So instead of just returning ENOSPC, check if we have
free block groups pending, and if so commit the transaction to allow us
to use that free space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 77f6f6bff36e..523bc197c40b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4897,6 +4897,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	struct btrfs_trans_handle *trans;
 	u64 bytes;
 	u64 reclaim_bytes = 0;
+	bool do_commit = true;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	if (trans)
@@ -4924,8 +4925,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	 * See if there is some space in the delayed insertion reservation for
 	 * this reservation.
 	 */
-	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
+	if (space_info != delayed_rsv->space_info) {
+		do_commit = false;
+		goto commit;
+	}
 
 	spin_lock(&delayed_rsv->lock);
 	reclaim_bytes += delayed_rsv->reserved;
@@ -4939,15 +4942,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	bytes -= reclaim_bytes;
 
 	if (percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes) < 0) {
-		return -ENOSPC;
-	}
-
+				   bytes) < 0)
+		do_commit = false;
 commit:
 	trans = btrfs_join_transaction(fs_info->extent_root);
 	if (IS_ERR(trans))
 		return -ENOSPC;
 
+	if (!do_commit &&
+	    !test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags)) {
+		btrfs_end_transaction(trans);
+		return -ENOSPC;
+	}
 	return btrfs_commit_transaction(trans);
 }
 
-- 
2.14.3

