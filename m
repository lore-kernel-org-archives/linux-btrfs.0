Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:37025 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731969AbeGSPeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:34:09 -0400
Received: by mail-qk0-f196.google.com with SMTP id t79-v6so4399209qke.4
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:38 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 22/22] btrfs: only run delayed refs if we're committing
Date: Thu, 19 Jul 2018 10:50:06 -0400
Message-Id: <20180719145006.17532-22-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed in a giant dbench run that we spent a lot of time on lock
contention while running transaction commit.  This is because dbench
results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
they all run the delayed refs first thing, so they all contend with
each other.  This leads to seconds of 0 throughput.  Change this to only
run the delayed refs if we're the ones committing the transaction.  This
makes the latency go away and we get no more lock contention.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4b171d8a7554..39ff9378b3db 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1919,15 +1919,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	/* make a pass through all the delayed refs we have so far
-	 * any runnings procs may add more while we are here
-	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	cur_trans = trans->transaction;
 
 	/*
@@ -1940,12 +1931,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans);
 
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
 
@@ -2016,6 +2001,17 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		spin_unlock(&fs_info->trans_lock);
 	}
 
+	/*
+	 * We are now the only one in the commit area, we can run delayed refs
+	 * without hitting a bunch of lock contention from a lot of people
+	 * trying to commit the transaction at once.
+	 */
+	ret = btrfs_run_delayed_refs(trans, 0);
+	if (ret) {
+		btrfs_end_transaction(trans);
+		return ret;
+	}
+
 	extwriter_counter_dec(cur_trans, trans->type);
 
 	ret = btrfs_start_delalloc_flush(fs_info);
-- 
2.14.3

