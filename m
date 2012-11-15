Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48784 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2KOINz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 03:13:55 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAF8Dqh2018274
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 16:13:52 +0800
Message-ID: <50A4A453.3050901@cn.fujitsu.com>
Date: Thu, 15 Nov 2012 16:14:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: cleanup unnecessary clear when freeing a transaction
 or a trans handle
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We clear the transaction object and the trans handle when they are about to be
freed, it is unnecessary, cleanup it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d9a9a70..9930888 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -39,7 +39,6 @@ void put_transaction(struct btrfs_transaction *transaction)
 	if (atomic_dec_and_test(&transaction->use_count)) {
 		BUG_ON(!list_empty(&transaction->list));
 		WARN_ON(transaction->delayed_refs.root.rb_node);
-		memset(transaction, 0, sizeof(*transaction));
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
 	}
 }
@@ -644,7 +643,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	}
 	assert_qgroups_uptodate(trans);
 
-	memset(trans, 0, sizeof(*trans));
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 	return err;
 }
-- 
1.7.11.7
