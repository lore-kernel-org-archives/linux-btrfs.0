Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60402 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab2ITHwG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 03:52:06 -0400
Message-ID: <505ACB1F.1060603@cn.fujitsu.com>
Date: Thu, 20 Sep 2012 15:51:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: add a type field for the transaction handle
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch add a type field into the transaction handle structure,
in this way, we needn't implement various end-transaction functions
and can make the code more simple and readable.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is based on btrfs-next tree.
---
 fs/btrfs/inode.c       |   19 ++++---------------
 fs/btrfs/transaction.c |   29 ++++++-----------------------
 fs/btrfs/transaction.h |   15 +++++++++++----
 3 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 212dc3a..6c117d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1364,11 +1364,7 @@ out_check:
 	}
 
 error:
-	if (nolock) {
-		err = btrfs_end_transaction_nolock(trans, root);
-	} else {
-		err = btrfs_end_transaction(trans, root);
-	}
+	err = btrfs_end_transaction(trans, root);
 	if (!ret)
 		ret = err;
 
@@ -1958,12 +1954,8 @@ out_unlock:
 out:
 	if (root != root->fs_info->tree_root)
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
-	if (trans) {
-		if (nolock)
-			btrfs_end_transaction_nolock(trans, root);
-		else
-			btrfs_end_transaction(trans, root);
-	}
+	if (trans)
+		btrfs_end_transaction(trans, root);
 
 	if (ret)
 		clear_extent_uptodate(io_tree, ordered_extent->file_offset,
@@ -4470,10 +4462,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
-		if (nolock)
-			ret = btrfs_end_transaction_nolock(trans, root);
-		else
-			ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans, root);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9bf9f6f..5eb4adf 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -267,14 +267,6 @@ static void wait_current_trans(struct btrfs_root *root)
 	}
 }
 
-enum btrfs_trans_type {
-	TRANS_START,
-	TRANS_JOIN,
-	TRANS_USERSPACE,
-	TRANS_JOIN_NOLOCK,
-	TRANS_JOIN_FREEZE,
-};
-
 static int may_wait_transaction(struct btrfs_root *root, int type)
 {
 	if (root->fs_info->log_root_recovering)
@@ -388,6 +380,7 @@ again:
 	h->aborted = 0;
 	h->qgroup_reserved = qgroup_reserved;
 	h->delayed_ref_elem.seq = 0;
+	h->type = type;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
 
 	smp_mb();
@@ -539,11 +532,12 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 }
 
 static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, int throttle, int lock)
+			  struct btrfs_root *root, int throttle)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *info = root->fs_info;
 	int count = 0;
+	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
 
 	if (--trans->use_count) {
@@ -638,7 +632,7 @@ int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	ret = __btrfs_end_transaction(trans, root, 0, 1);
+	ret = __btrfs_end_transaction(trans, root, 0);
 	if (ret)
 		return ret;
 	return 0;
@@ -649,18 +643,7 @@ int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	ret = __btrfs_end_transaction(trans, root, 1, 1);
-	if (ret)
-		return ret;
-	return 0;
-}
-
-int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root)
-{
-	int ret;
-
-	ret = __btrfs_end_transaction(trans, root, 0, 0);
+	ret = __btrfs_end_transaction(trans, root, 1);
 	if (ret)
 		return ret;
 	return 0;
@@ -669,7 +652,7 @@ int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
 int btrfs_end_transaction_dmeta(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root)
 {
-	return __btrfs_end_transaction(trans, root, 1, 1);
+	return __btrfs_end_transaction(trans, root, 1);
 }
 
 /*
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7a551d3..1052397 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -47,6 +47,14 @@ struct btrfs_transaction {
 	int aborted;
 };
 
+enum btrfs_trans_type {
+	TRANS_START,
+	TRANS_JOIN,
+	TRANS_USERSPACE,
+	TRANS_JOIN_NOLOCK,
+	TRANS_JOIN_FREEZE,
+};
+
 struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
@@ -58,8 +66,9 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
-	int aborted;
-	int adding_csums;
+	short aborted;
+	short adding_csums;
+	enum btrfs_trans_type type;
 	/*
 	 * this root is only needed to validate that the root passed to
 	 * start_transaction is the same as the one passed to end_transaction.
@@ -92,8 +101,6 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
-int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
 struct btrfs_trans_handle *btrfs_start_transaction_noflush(
-- 
1.7.6.5
