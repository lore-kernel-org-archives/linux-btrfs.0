Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62263 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AVKtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 05:49:24 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0MAnLMF019349
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 18:49:22 +0800
Message-ID: <50FE6ED9.6060402@cn.fujitsu.com>
Date: Tue, 22 Jan 2013 18:50:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs: check the return value of btrfs_run_ordered_operations()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to check the return value of btrfs_run_ordered_operations() when
flushing all the pending stuffs, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 34c5b7b..80adf07 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1441,9 +1441,9 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 	 * it here and no for sure that nothing new will be added
 	 * to the list
 	 */
-	btrfs_run_ordered_operations(root, 1);
+	ret = btrfs_run_ordered_operations(root, 1);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.6.5.2
