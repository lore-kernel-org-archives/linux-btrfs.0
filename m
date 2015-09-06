Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34242 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbbIFJZq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Sep 2015 05:25:46 -0400
Date: Sun, 6 Sep 2015 12:25:27 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, 00moses.alexander00@gmail.com
Subject: [PATCH] btrfs: memset cur_trans->delayed_refs to zero
Message-ID: <20150906122527.GA21685@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use memset() to null out the btrfs_delayed_ref_root of
btrfs_transaction instead of setting all the members to 0 by hand.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/transaction.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8f259b3..faccc1b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -224,15 +224,7 @@ loop:
 	cur_trans->start_time = get_seconds();
 	cur_trans->dirty_bg_run = 0;
 
-	cur_trans->delayed_refs.href_root = RB_ROOT;
-	cur_trans->delayed_refs.dirty_extent_root = RB_ROOT;
-	atomic_set(&cur_trans->delayed_refs.num_entries, 0);
-	cur_trans->delayed_refs.num_heads_ready = 0;
-	cur_trans->delayed_refs.pending_csums = 0;
-	cur_trans->delayed_refs.num_heads = 0;
-	cur_trans->delayed_refs.flushing = 0;
-	cur_trans->delayed_refs.run_delayed_start = 0;
-	cur_trans->delayed_refs.qgroup_to_skip = 0;
+	memset(&cur_trans->delayed_refs, 0, sizeof(cur_trans->delayed_refs));
 
 	/*
 	 * although the tree mod log is per file system and not per transaction,
-- 
2.5.1

