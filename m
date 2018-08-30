Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40278 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbeH3Vqf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:35 -0400
Received: by mail-qt0-f195.google.com with SMTP id h4-v6so11301781qtj.7
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:43:19 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n63-v6sm4291938qkd.80.2018.08.30.10.43.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:43:18 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 28/35] btrfs: call btrfs_create_pending_block_groups unconditionally
Date: Thu, 30 Aug 2018 13:42:18 -0400
Message-Id: <20180830174225.2200-29-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first thing we do is loop through the list, this

if (!list_empty())
	btrfs_create_pending_block_groups();

thing is just wasted space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/transaction.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 031d2b11ddee..90f267f4dd0f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2970,8 +2970,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	}
 
 	if (run_all) {
-		if (!list_empty(&trans->new_bgs))
-			btrfs_create_pending_block_groups(trans);
+		btrfs_create_pending_block_groups(trans);
 
 		spin_lock(&delayed_refs->lock);
 		node = rb_first(&delayed_refs->href_root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2bb19e2ded5e..89d14f135837 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -839,8 +839,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	btrfs_trans_release_chunk_metadata(trans);
 
@@ -1927,8 +1926,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	cur_trans->delayed_refs.flushing = 1;
 	smp_wmb();
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
-- 
2.14.3
