Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42399 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521AbbATJHr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 04:07:47 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH RFC v2 2/5] btrfs: Add btrfs_start_transaction_freeze() to start transaction in btrfs_freeze()
Date: Tue, 20 Jan 2015 17:05:34 +0800
Message-ID: <1421744737-16586-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs_start_transaction_freeze() function.

This is needed for btrfs_freeze() to handle the pending changes.
If there is no running transaction when btrfs_freeze() is called,
btrfs_freeze() needs to start a transaction to handle the pending
changes, and it can't initial a sb_start_intwrite() call.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 8 ++++++++
 fs/btrfs/transaction.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e88b59d..13a2b67 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -570,6 +570,14 @@ struct btrfs_trans_handle *btrfs_start_transaction_lflush(
 				 BTRFS_RESERVE_FLUSH_LIMIT);
 }
 
+/* Only used in btrfs_freeze() */
+struct btrfs_trans_handle *btrfs_start_transaction_freeze(
+					struct btrfs_root *root, int num_items)
+{
+	return start_transaction(root, num_items, __TRANS_START,
+				 BTRFS_RESERVE_FLUSH_ALL);
+}
+
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_JOIN, 0);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 00ed29c..49bd7eb 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -140,6 +140,8 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
 struct btrfs_trans_handle *btrfs_start_transaction_lflush(
 					struct btrfs_root *root, int num_items);
+struct btrfs_trans_handle *btrfs_start_transaction_freeze(
+					struct btrfs_root *root, int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
-- 
2.2.2

