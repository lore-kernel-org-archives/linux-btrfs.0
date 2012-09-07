Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932670Ab2IGHnq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Sep 2012 03:43:46 -0400
Message-ID: <5049A5A4.5020103@cn.fujitsu.com>
Date: Fri, 07 Sep 2012 15:43:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V5 07/12] Btrfs: fix corrupted metadata in the snapshot
References: <504874D8.60001@cn.fujitsu.com> <20120906130914.GA18438@localhost.localdomain> <504965A3.3050402@cn.fujitsu.com>
In-Reply-To: <504965A3.3050402@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we delete a inode, we will remove all the delayed items including delayed
inode update, and then truncate all the relative metadata. If there is lots of
metadata, we will end the current transaction, and start a new transaction to
truncate the left metadata. In this way, we will leave a inode item that its
link counter is > 0, and also may leave some directory index items in fs/file tree
after the current transaction ends. In other words, the metadata in this fs/file tree
is inconsistent. If we create a snapshot for this tree now, we will find a inode with
corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
because its link counter is not 0.

We fix this problem by updating the inode item before the current transaction ends.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v4 -> v5:
- change the method which is used to fix enospc problem of the inode update

Changelog v1 -> v4:
- Update the comment of the truncation in the btrfs_evict_inode()
- Fix enospc problem of the inode update
---
 fs/btrfs/inode.c       |   20 ++++++++++----------
 fs/btrfs/transaction.c |   29 +++++++++++++++++++++--------
 fs/btrfs/transaction.h |    2 ++
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d494c11..b69779d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3772,21 +3772,17 @@ void btrfs_evict_inode(struct inode *inode)
 		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
 	}
+
 	rsv->size = min_size;
 	global_rsv = &root->fs_info->global_block_rsv;
 
 	btrfs_i_size_write(inode, 0);
 
 	/*
-	 * This is a bit simpler than btrfs_truncate since
-	 *
-	 * 1) We've already reserved our space for our orphan item in the
-	 *    unlink.
-	 * 2) We're going to delete the inode item, so we don't need to update
-	 *    it at all.
-	 *
-	 * So we just need to reserve some slack space in case we add bytes when
-	 * doing the truncate.
+	 * This is a bit simpler than btrfs_truncate since we've already
+	 * reserved our space for our orphan item in the unlink, so we just
+	 * need to reserve some slack space in case we add bytes and update
+	 * inode item when doing the truncate.
 	 */
 	while (1) {
 		ret = btrfs_block_rsv_refill_noflush(root, rsv, min_size);
@@ -3807,7 +3803,7 @@ void btrfs_evict_inode(struct inode *inode)
 			goto no_delete;
 		}
 
-		trans = btrfs_start_transaction(root, 0);
+		trans = btrfs_start_transaction_noflush(root, 1);
 		if (IS_ERR(trans)) {
 			btrfs_orphan_del(NULL, inode);
 			btrfs_free_block_rsv(root, rsv);
@@ -3820,6 +3816,10 @@ void btrfs_evict_inode(struct inode *inode)
 		if (ret != -EAGAIN)
 			break;
 
+		trans->block_rsv = &root->fs_info->trans_block_rsv;
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8bd2511..6ea5d2d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -290,7 +290,8 @@ static int may_wait_transaction(struct btrfs_root *root, int type)
 }
 
 static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
-						    u64 num_items, int type)
+						    u64 num_items, int type,
+						    int noflush)
 {
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
@@ -324,9 +325,14 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 		}
 
 		num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
-		ret = btrfs_block_rsv_add(root,
-					  &root->fs_info->trans_block_rsv,
-					  num_bytes);
+		if (noflush)
+			ret = btrfs_block_rsv_add_noflush(root,
+						&root->fs_info->trans_block_rsv,
+						num_bytes);
+		else
+			ret = btrfs_block_rsv_add(root,
+						&root->fs_info->trans_block_rsv,
+						num_bytes);
 		if (ret)
 			return ERR_PTR(ret);
 	}
@@ -390,21 +396,28 @@ got_it:
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items)
 {
-	return start_transaction(root, num_items, TRANS_START);
+	return start_transaction(root, num_items, TRANS_START, 0);
 }
+
+struct btrfs_trans_handle *btrfs_start_transaction_noflush(
+					struct btrfs_root *root, int num_items)
+{
+	return start_transaction(root, num_items, TRANS_START, 1);
+}
+
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 {
-	return start_transaction(root, 0, TRANS_JOIN);
+	return start_transaction(root, 0, TRANS_JOIN, 0);
 }
 
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root)
 {
-	return start_transaction(root, 0, TRANS_JOIN_NOLOCK);
+	return start_transaction(root, 0, TRANS_JOIN_NOLOCK, 0);
 }
 
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root)
 {
-	return start_transaction(root, 0, TRANS_USERSPACE);
+	return start_transaction(root, 0, TRANS_USERSPACE, 0);
 }
 
 /* wait for a transaction commit to be fully complete */
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e8b8416..06c4929 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -96,6 +96,8 @@ int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
+struct btrfs_trans_handle *btrfs_start_transaction_noflush(
+					struct btrfs_root *root, int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
-- 
1.7.6.5
