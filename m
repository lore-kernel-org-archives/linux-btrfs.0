Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:42494 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbeH3Vqi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:38 -0400
Received: by mail-qt0-f194.google.com with SMTP id z8-v6so11280964qto.9
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:43:22 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n8-v6sm4758731qtk.38.2018.08.30.10.43.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:43:21 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 30/35] btrfs: cleanup pending bgs on transaction abort
Date: Thu, 30 Aug 2018 13:42:20 -0400
Message-Id: <20180830174225.2200-31-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We may abort the transaction during a commit and not have a chance to
run the pending bgs stuff, which will leave block groups on our list and
cause us accounting issues and leaked memory.  Fix this by running the
pending bgs when we cleanup a transaction.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 89d14f135837..0f39a0d302d3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2273,6 +2273,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_scrub_continue(fs_info);
 cleanup_transaction:
 	btrfs_trans_release_metadata(trans);
+	btrfs_create_pending_block_groups(trans);
 	btrfs_trans_release_chunk_metadata(trans);
 	trans->block_rsv = NULL;
 	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
-- 
2.14.3
