Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41967 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3DNOJR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Apr 2013 10:09:17 -0400
Received: by mail-pb0-f49.google.com with SMTP id um15so2108642pbc.36
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Apr 2013 07:09:17 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup to remove reduplicate code in transaction.c
Date: Sun, 14 Apr 2013 22:08:49 +0800
Message-Id: <1365948529-8259-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c4a1531..a8e3c36 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -708,23 +708,13 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root)
 {
-	int ret;
-
-	ret = __btrfs_end_transaction(trans, root, 0);
-	if (ret)
-		return ret;
-	return 0;
+	return __btrfs_end_transaction(trans, root, 0);
 }
 
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root)
 {
-	int ret;
-
-	ret = __btrfs_end_transaction(trans, root, 1);
-	if (ret)
-		return ret;
-	return 0;
+	return __btrfs_end_transaction(trans, root, 1);
 }
 
 int btrfs_end_transaction_dmeta(struct btrfs_trans_handle *trans,
-- 
1.7.11.7

