Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36781 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeH3Vp7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:45:59 -0400
Received: by mail-qt0-f196.google.com with SMTP id t5-v6so11316797qtn.3
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:43 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p23-v6sm5027360qtf.6.2018.08.30.10.42.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:42 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/35] btrfs: release metadata before running delayed refs
Date: Thu, 30 Aug 2018 13:41:58 -0400
Message-Id: <20180830174225.2200-9-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
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
index 99741254e27e..ebb0c0405598 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1915,6 +1915,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		return ret;
 	}
 
+	btrfs_trans_release_metadata(trans);
+	trans->block_rsv = NULL;
+
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
 	 */
@@ -1924,9 +1927,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		return ret;
 	}
 
-	btrfs_trans_release_metadata(trans);
-	trans->block_rsv = NULL;
-
 	cur_trans = trans->transaction;
 
 	/*
-- 
2.14.3
