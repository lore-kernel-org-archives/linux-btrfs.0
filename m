Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2IXArA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 20:47:00 -0400
Received: by pbbrr4 with SMTP id rr4so6141595pbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Sep 2012 17:46:59 -0700 (PDT)
Message-ID: <505FAD76.8030502@gmail.com>
Date: Mon, 24 Sep 2012 08:46:46 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 1/4] Btrfs: cleanup: return the ret value of __btrfs_end_transaction
 directly in btrfs_end_transaction_
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to use specific var to record the return value of
__btrfs_end_transaction and check if it is not zero.
Just return the result directly as btrfs_end_transaction_dmeta.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/transaction.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 27c2600..8fcc501 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -602,34 +602,19 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root)
 {
-	int ret;
-
-	ret = __btrfs_end_transaction(trans, root, 0, 1);
-	if (ret)
-		return ret;
-	return 0;
+	return __btrfs_end_transaction(trans, root, 0, 1);
 }
 
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root)
 {
-	int ret;
-
-	ret = __btrfs_end_transaction(trans, root, 1, 1);
-	if (ret)
-		return ret;
-	return 0;
+	return __btrfs_end_transaction(trans, root, 1, 1);
 }
 
 int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root)
 {
-	int ret;
-
-	ret = __btrfs_end_transaction(trans, root, 0, 0);
-	if (ret)
-		return ret;
-	return 0;
+	return __btrfs_end_transaction(trans, root, 0, 0);
 }
 
 int btrfs_end_transaction_dmeta(struct btrfs_trans_handle *trans,
-- 
1.7.1

