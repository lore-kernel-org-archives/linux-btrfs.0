Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46775 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbeIKW6u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:58:50 -0400
Received: by mail-qk1-f196.google.com with SMTP id j7-v6so17311471qkd.13
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:24 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 07/36] btrfs: check if free bgs for commit
Date: Tue, 11 Sep 2018 13:57:38 -0400
Message-Id: <20180911175807.26181-8-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
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
 fs/btrfs/extent-tree.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7168e2476944..a3baa16d456f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4830,10 +4830,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	if (!bytes)
 		return 0;
 
-	/* See if there is enough pinned space to make this reservation */
-	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
+	trans = btrfs_join_transaction(fs_info->extent_root);
+	if (IS_ERR(trans))
+		return -ENOSPC;
+
+	/*
+	 * See if there is enough pinned space to make this reservation, or if
+	 * we have bg's that are going to be freed, allowing us to possibly do a
+	 * chunk allocation the next loop through.
+	 */
+	if (test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags) ||
+	    __percpu_counter_compare(&space_info->total_bytes_pinned, bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
 		goto commit;
 
 	/*
@@ -4841,7 +4849,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	 * this reservation.
 	 */
 	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
+		goto enospc;
 
 	spin_lock(&delayed_rsv->lock);
 	reclaim_bytes += delayed_rsv->reserved;
@@ -4855,17 +4863,14 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	bytes -= reclaim_bytes;
 
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
-		return -ENOSPC;
-	}
-
+				     bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0)
+		goto enospc;
 commit:
-	trans = btrfs_join_transaction(fs_info->extent_root);
-	if (IS_ERR(trans))
-		return -ENOSPC;
-
 	return btrfs_commit_transaction(trans);
+enospc:
+	btrfs_end_transaction(trans);
+	return -ENOSPC;
 }
 
 /*
-- 
2.14.3
