Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:45253 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbeGSPdv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:51 -0400
Received: by mail-qt0-f193.google.com with SMTP id y5-v6so7395642qti.12
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 09/22] btrfs: release metadata before running delayed refs
Date: Thu, 19 Jul 2018 10:49:53 -0400
Message-Id: <20180719145006.17532-9-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want to release the unused reservation we have since it refills the
delayed refs reserve, which will make everything go smoother when
running the delayed refs if we're short on our reservation.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 337397f99c95..4b171d8a7554 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1916,6 +1916,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		return ret;
 	}
 
+	btrfs_trans_release_metadata(trans);
+	trans->block_rsv = NULL;
+
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
 	 */
@@ -1925,9 +1928,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		return ret;
 	}
 
-	btrfs_trans_release_metadata(trans);
-	trans->block_rsv = NULL;
-
 	cur_trans = trans->transaction;
 
 	/*
-- 
2.14.3

