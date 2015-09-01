Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16852 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755214AbbIAIwb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 04:52:31 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t818qKqe027669
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 16:52:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 12/14] btrfs: qgroup: Use new metadata reservation.
Date: Tue, 1 Sep 2015 16:50:25 +0800
Message-ID: <1441097425-8919-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we have the new metadata reservation functions, use them to replace
the old btrfs_qgroup_reserve() call for metadata.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++--------
 fs/btrfs/transaction.c | 34 ++++++----------------------------
 fs/btrfs/transaction.h |  1 -
 3 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4d9b01b..ce78410 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5244,7 +5244,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (root->fs_info->quota_enabled) {
 		/* One for parent inode, two for dir entries */
 		num_bytes = 3 * root->nodesize;
-		ret = btrfs_qgroup_reserve(root, num_bytes);
+		ret = btrfs_qgroup_reserve_meta(root, num_bytes);
 		if (ret)
 			return ret;
 	} else {
@@ -5262,10 +5262,8 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (ret == -ENOSPC && use_global_rsv)
 		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes);
 
-	if (ret) {
-		if (*qgroup_reserved)
-			btrfs_qgroup_free(root, *qgroup_reserved);
-	}
+	if (ret && *qgroup_reserved)
+		btrfs_qgroup_free_meta(root, *qgroup_reserved);
 
 	return ret;
 }
@@ -5426,15 +5424,15 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	spin_unlock(&BTRFS_I(inode)->lock);
 
 	if (root->fs_info->quota_enabled) {
-		ret = btrfs_qgroup_reserve(root, nr_extents * root->nodesize);
+		ret = btrfs_qgroup_reserve_meta(root,
+				nr_extents * root->nodesize);
 		if (ret)
 			goto out_fail;
 	}
 
 	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
 	if (unlikely(ret)) {
-		if (root->fs_info->quota_enabled)
-			btrfs_qgroup_free(root, nr_extents * root->nodesize);
+		btrfs_qgroup_free_meta(root, nr_extents * root->nodesize);
 		goto out_fail;
 	}
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c0f18e7..e9656b4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -444,13 +444,10 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 	 * the appropriate flushing if need be.
 	 */
 	if (num_items > 0 && root != root->fs_info->chunk_root) {
-		if (root->fs_info->quota_enabled &&
-		    is_fstree(root->root_key.objectid)) {
-			qgroup_reserved = num_items * root->nodesize;
-			ret = btrfs_qgroup_reserve(root, qgroup_reserved);
-			if (ret)
-				return ERR_PTR(ret);
-		}
+		qgroup_reserved = num_items * root->nodesize;
+		ret = btrfs_qgroup_reserve_meta(root, qgroup_reserved);
+		if (ret)
+			return ERR_PTR(ret);
 
 		num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
 		/*
@@ -519,7 +516,6 @@ again:
 	h->block_rsv = NULL;
 	h->orig_rsv = NULL;
 	h->aborted = 0;
-	h->qgroup_reserved = 0;
 	h->delayed_ref_elem.seq = 0;
 	h->type = type;
 	h->allocating_chunk = false;
@@ -544,7 +540,6 @@ again:
 		h->bytes_reserved = num_bytes;
 		h->reloc_reserved = reloc_reserved;
 	}
-	h->qgroup_reserved = qgroup_reserved;
 
 got_it:
 	btrfs_record_root_in_trans(h, root);
@@ -562,8 +557,7 @@ alloc_fail:
 		btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
 					num_bytes);
 reserve_fail:
-	if (qgroup_reserved)
-		btrfs_qgroup_free(root, qgroup_reserved);
+	btrfs_qgroup_free_meta(root, qgroup_reserved);
 	return ERR_PTR(ret);
 }
 
@@ -780,15 +774,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			must_run_delayed_refs = 2;
 	}
 
-	if (trans->qgroup_reserved) {
-		/*
-		 * the same root has to be passed here between start_transaction
-		 * and end_transaction. Subvolume quota depends on this.
-		 */
-		btrfs_qgroup_free(trans->root, trans->qgroup_reserved);
-		trans->qgroup_reserved = 0;
-	}
-
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 
@@ -1203,6 +1188,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			spin_lock(&fs_info->fs_roots_radix_lock);
 			if (err)
 				break;
+			btrfs_qgroup_free_meta_all(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
@@ -1811,10 +1797,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
-	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
-		trans->qgroup_reserved = 0;
-	}
 
 	cur_trans = trans->transaction;
 
@@ -2163,10 +2145,6 @@ cleanup_transaction:
 	btrfs_trans_release_metadata(trans, root);
 	btrfs_trans_release_chunk_metadata(trans);
 	trans->block_rsv = NULL;
-	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
-		trans->qgroup_reserved = 0;
-	}
 	btrfs_warn(root->fs_info, "Skipping commit of aborted transaction.");
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index eb09c20..f46e311 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -103,7 +103,6 @@ struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
 	u64 chunk_bytes_reserved;
-	u64 qgroup_reserved;
 	unsigned long use_count;
 	unsigned long blocks_reserved;
 	unsigned long blocks_used;
-- 
2.5.1

