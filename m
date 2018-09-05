Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:60350 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbeIEFmn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 01:42:43 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove redundant btrfs_trans_release_metadata"
Date: Wed,  5 Sep 2018 09:14:50 +0800
Message-Id: <1536110090-100798-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_end_transaction() has done the metadata release twice,
probably because it used to process delayed refs in between, but now
that we don't process delayed refs any more, the 2nd release is always
a noop.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/transaction.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bb1b9f526e98..94b036a74d11 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -826,12 +826,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	btrfs_trans_release_metadata(trans);
-	trans->block_rsv = NULL;
-
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
-
 	trans->delayed_ref_updates = 0;
 	if (!trans->sync) {
 		must_run_delayed_refs =
-- 
1.8.3.1
