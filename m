Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f180.google.com ([209.85.222.180]:40179 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:30 -0400
Received: by mail-qk1-f180.google.com with SMTP id c126-v6so17335154qkd.7
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:59:04 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 29/36] btrfs: call btrfs_create_pending_block_groups unconditionally
Date: Tue, 11 Sep 2018 13:58:00 -0400
Message-Id: <20180911175807.26181-30-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first thing we do is loop through the list, this

if (!list_empty())
	btrfs_create_pending_block_groups();

thing is just wasted space.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/transaction.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7c04168516ed..20fed467468e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2978,8 +2978,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	}
 
 	if (run_all) {
-		if (!list_empty(&trans->new_bgs))
-			btrfs_create_pending_block_groups(trans);
+		btrfs_create_pending_block_groups(trans);
 
 		spin_lock(&delayed_refs->lock);
 		node = rb_first(&delayed_refs->href_root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 39a2bddb0b29..46ca775a709e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -846,8 +846,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	btrfs_trans_release_chunk_metadata(trans);
 
@@ -1934,8 +1933,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	cur_trans->delayed_refs.flushing = 1;
 	smp_wmb();
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
-- 
2.14.3
