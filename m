Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab3EOHsr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:47 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 14/17] Btrfs: don't flush the delalloc inodes in the while loop if flushoncommit is set
Date: Wed, 15 May 2013 15:48:28 +0800
Message-Id: <1368604111-25073-15-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is unnecessary to flush the delalloc inodes again and again because
we don't care the dirty pages which are introduced after the flush, and
they will be flush in the transaction commit.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fd319b2..265db57 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1518,16 +1518,8 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root)
 {
-	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
 	int ret;
 
-	if (flush_on_commit) {
-		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 1);
-		if (ret)
-			return ret;
-		btrfs_wait_all_ordered_extents(root->fs_info, 1);
-	}
-
 	ret = btrfs_run_delayed_items(trans, root);
 	if (ret)
 		return ret;
@@ -1551,6 +1543,19 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
+{
+	if (btrfs_test_opt(fs_info->tree_root, FLUSHONCOMMIT))
+		return btrfs_start_all_delalloc_inodes(fs_info, 1);
+	return 0;
+}
+
+static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
+{
+	if (btrfs_test_opt(fs_info->tree_root, FLUSHONCOMMIT))
+		btrfs_wait_all_ordered_extents(fs_info, 1);
+}
+
 /*
  * btrfs_transaction state sequence:
  *    in_commit = 0, blocked = 0  (initial)
@@ -1654,6 +1659,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	extwriter_counter_dec(cur_trans, trans->type);
 
+	ret = btrfs_start_delalloc_flush(root->fs_info);
+	if (ret)
+		goto cleanup_transaction;
+
 	if (!btrfs_test_opt(root, SSD) &&
 	    (now < cur_trans->start_time || now - cur_trans->start_time < 1))
 		should_grow = 1;
@@ -1683,6 +1692,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto cleanup_transaction;
 
+	btrfs_wait_delalloc_flush(root->fs_info);
 	/*
 	 * Ok now we need to make sure to block out any other joins while we
 	 * commit the transaction.  We could have started a join before setting
-- 
1.8.1.4

