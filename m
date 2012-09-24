Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54813 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2IXAr2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 20:47:28 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so591587pad.19
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Sep 2012 17:47:28 -0700 (PDT)
Message-ID: <505FAD9B.7010006@gmail.com>
Date: Mon, 24 Sep 2012 08:47:23 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 3/4] Btrfs: remove unnecessary cur_trans set before goto loop
 in join_transaction
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the big loop, cur_trans will be set fs_info->running_transaction
before it's used. And after kmem_cache_free it and goto loop, it will
be setup again. No need to setup it immediately after freed.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/transaction.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 469a8b6..675d813 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -98,7 +98,6 @@ loop:
 		 * to redo the trans_no_join checks above
 		 */
 		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
-		cur_trans = fs_info->running_transaction;
 		goto loop;
 	} else if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 		spin_unlock(&fs_info->trans_lock);
-- 
1.7.1

