Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab3LMKIc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 05:08:32 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBDA8S6F008938
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 18:08:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs: remove btrfs_end_transaction_dmeta()
Date: Fri, 13 Dec 2013 18:09:39 +0800
Message-Id: <1386929381-3483-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
References: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 2 +-
 fs/btrfs/transaction.c   | 6 ------
 fs/btrfs/transaction.h   | 2 --
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5229106..7d55443 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1302,7 +1302,7 @@ again:
 	__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
 
 	trans->block_rsv = block_rsv;
-	btrfs_end_transaction_dmeta(trans, root);
+	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty_nodelay(root);
 
 release_path:
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c6a872a..df919b4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -788,12 +788,6 @@ int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 	return __btrfs_end_transaction(trans, root, 1);
 }
 
-int btrfs_end_transaction_dmeta(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root)
-{
-	return __btrfs_end_transaction(trans, root, 1);
-}
-
 /*
  * when btree blocks are allocated, they have some corresponding bits set for
  * them in one of two extent_io trees.  This is used to make sure all of
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7657d11..d05b601 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -154,8 +154,6 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   int wait_for_unblock);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root);
-int btrfs_end_transaction_dmeta(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root);
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 void btrfs_throttle(struct btrfs_root *root);
-- 
1.8.3.1

