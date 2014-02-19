Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaBSMAH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 07:00:07 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1JBQFlG026060
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 19:26:32 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs: cancel scrub on transaction abortion
Date: Wed, 19 Feb 2014 19:24:18 +0800
Message-Id: <1392809059-22319-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392809059-22319-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392809059-22319-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fail to commit transaction, we'd better
cancel scrub operations.

Suggested-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 84da666..79a4186 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1580,6 +1580,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
+	btrfs_scrub_cancel(root->fs_info);
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 }
-- 
1.8.3.1

