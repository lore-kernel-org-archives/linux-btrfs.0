Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35222 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbIMLaB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Sep 2015 07:30:01 -0400
Date: Sun, 13 Sep 2015 14:29:41 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, 00moses.alexander00@gmail.com
Subject: [PATCH 1/2] btrfs: avoid passing int param to start_transaction
 which takes u64
Message-ID: <20150913142941.GA7154@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8f259b3..8a83acd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -570,7 +570,7 @@ reserve_fail:
 }
 
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
-						   int num_items)
+						   u64 num_items)
 {
 	return start_transaction(root, num_items, TRANS_START,
 				 BTRFS_RESERVE_FLUSH_ALL);
-- 
2.5.1

