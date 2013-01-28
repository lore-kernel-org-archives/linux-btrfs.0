Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9380 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756911Ab3A1Mfl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 07:35:41 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0SCZcAP007409
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 20:35:38 +0800
Message-ID: <510670C6.5030908@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 20:36:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: fix missing release of the space/qgroup reservation
 in start_transaction()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we fail to start a transaction, we need to release the reserved free space
and qgroup space, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 87fac9a..194d0b5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -333,12 +333,14 @@ start_transaction(struct btrfs_root *root, u64 num_items, int type,
 					  &root->fs_info->trans_block_rsv,
 					  num_bytes, flush);
 		if (ret)
-			return ERR_PTR(ret);
+			goto reserve_fail;
 	}
 again:
 	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
-	if (!h)
-		return ERR_PTR(-ENOMEM);
+	if (!h) {
+		ret = -ENOMEM;
+		goto alloc_fail;
+	}
 
 	/*
 	 * If we are JOIN_NOLOCK we're already committing a transaction and
@@ -365,11 +367,7 @@ again:
 	if (ret < 0) {
 		/* We must get the transaction if we are JOIN_NOLOCK. */
 		BUG_ON(type == TRANS_JOIN_NOLOCK);
-
-		if (type < TRANS_JOIN_NOLOCK)
-			sb_end_intwrite(root->fs_info->sb);
-		kmem_cache_free(btrfs_trans_handle_cachep, h);
-		return ERR_PTR(ret);
+		goto join_fail;
 	}
 
 	cur_trans = root->fs_info->running_transaction;
@@ -410,6 +408,19 @@ got_it:
 	if (!current->journal_info && type != TRANS_USERSPACE)
 		current->journal_info = h;
 	return h;
+
+join_fail:
+	if (type < TRANS_JOIN_NOLOCK)
+		sb_end_intwrite(root->fs_info->sb);
+	kmem_cache_free(btrfs_trans_handle_cachep, h);
+alloc_fail:
+	if (num_bytes)
+		btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
+					num_bytes);
+reserve_fail:
+	if (qgroup_reserved)
+		btrfs_qgroup_free(root, qgroup_reserved);
+	return ERR_PTR(ret);
 }
 
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
-- 
1.6.5.2
