Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45925 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeH3Vpz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:45:55 -0400
Received: by mail-qk1-f194.google.com with SMTP id z125-v6so22674qkb.12
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:40 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m12-v6sm4390881qkl.54.2018.08.30.10.42.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:38 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/35] btrfs: check if free bgs for commit
Date: Thu, 30 Aug 2018 13:41:56 -0400
Message-Id: <20180830174225.2200-7-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
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
index 6e7f350754d2..80615a579b18 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4804,6 +4804,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	struct btrfs_trans_handle *trans;
 	u64 bytes;
 	u64 reclaim_bytes = 0;
+	bool do_commit = true;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	if (trans)
@@ -4832,8 +4833,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
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
@@ -4848,15 +4851,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
 				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
-		return -ENOSPC;
-	}
-
+				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0)
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
