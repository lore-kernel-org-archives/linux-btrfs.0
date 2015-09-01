Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42571 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbbIBHv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 03:51:27 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t810XlIp023763
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 08:34:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 12/14] btrfs: qgroup: Use new metadata reservation.
Date: Tue,  1 Sep 2015 08:31:52 +0800
Message-Id: <1441067515-21105-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we have the new metadata reservation functions, use them to replace
the old btrfs_qgroup_reserve() call for metadata.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++--------
 fs/btrfs/transaction.c | 15 ++++++---------
 2 files changed, 12 insertions(+), 17 deletions(-)

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
index c0f18e7..5b6fccd 100644
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
@@ -562,8 +559,7 @@ alloc_fail:
 		btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
 					num_bytes);
 reserve_fail:
-	if (qgroup_reserved)
-		btrfs_qgroup_free(root, qgroup_reserved);
+	btrfs_qgroup_free_meta(root, qgroup_reserved);
 	return ERR_PTR(ret);
 }
 
@@ -1203,6 +1199,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			spin_lock(&fs_info->fs_roots_radix_lock);
 			if (err)
 				break;
+			btrfs_qgroup_free_meta_all(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.5.0

