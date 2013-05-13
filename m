Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3EMPMb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:12:31 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH 2/5] Btrfs: don't use global block reservation for inode cache truncation
Date: Mon, 13 May 2013 21:55:09 +0800
Message-Id: <1368453312-7027-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is very likely that there are lots of subvolumes/snapshots in the filesystem,
so if we use global block reservation to do inode cache truncation, we may hog
all the free space that is reserved in global rsv. So it is better that we do
the free space reservation for inode cache truncation by ourselves.

Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c      |  5 +++++
 fs/btrfs/free-space-cache.c | 39 +++++++++++++++++++--------------------
 fs/btrfs/free-space-cache.h |  2 ++
 fs/btrfs/inode-map.c        |  5 +++--
 fs/btrfs/relocation.c       |  5 +++++
 5 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2305b5c..43afa77 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3109,6 +3109,11 @@ again:
 	WARN_ON(ret);
 
 	if (i_size_read(inode) > 0) {
+		ret = btrfs_check_trunc_cache_free_space(root,
+					&root->fs_info->global_block_rsv);
+		if (ret)
+			goto out_put;
+
 		ret = btrfs_truncate_free_space_cache(root, trans, path,
 						      inode);
 		if (ret)
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ecca6c7..a1948f4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -197,30 +197,32 @@ int create_free_space_inode(struct btrfs_root *root,
 					 block_group->key.objectid);
 }
 
-int btrfs_truncate_free_space_cache(struct btrfs_root *root,
-				    struct btrfs_trans_handle *trans,
-				    struct btrfs_path *path,
-				    struct inode *inode)
+int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
+				       struct btrfs_block_rsv *rsv)
 {
-	struct btrfs_block_rsv *rsv;
 	u64 needed_bytes;
-	loff_t oldsize;
-	int ret = 0;
-
-	rsv = trans->block_rsv;
-	trans->block_rsv = &root->fs_info->global_block_rsv;
+	int ret;
 
 	/* 1 for slack space, 1 for updating the inode */
 	needed_bytes = btrfs_calc_trunc_metadata_size(root, 1) +
 		btrfs_calc_trans_metadata_size(root, 1);
 
-	spin_lock(&trans->block_rsv->lock);
-	if (trans->block_rsv->reserved < needed_bytes) {
-		spin_unlock(&trans->block_rsv->lock);
-		trans->block_rsv = rsv;
-		return -ENOSPC;
-	}
-	spin_unlock(&trans->block_rsv->lock);
+	spin_lock(&rsv->lock);
+	if (rsv->reserved < needed_bytes)
+		ret = -ENOSPC;
+	else
+		ret = 0;
+	spin_unlock(&rsv->lock);
+	return 0;
+}
+
+int btrfs_truncate_free_space_cache(struct btrfs_root *root,
+				    struct btrfs_trans_handle *trans,
+				    struct btrfs_path *path,
+				    struct inode *inode)
+{
+	loff_t oldsize;
+	int ret = 0;
 
 	oldsize = i_size_read(inode);
 	btrfs_i_size_write(inode, 0);
@@ -232,9 +234,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	 */
 	ret = btrfs_truncate_inode_items(trans, root, inode,
 					 0, BTRFS_EXTENT_DATA_KEY);
-
 	if (ret) {
-		trans->block_rsv = rsv;
 		btrfs_abort_transaction(trans, root, ret);
 		return ret;
 	}
@@ -242,7 +242,6 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	ret = btrfs_update_inode(trans, root, inode);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
-	trans->block_rsv = rsv;
 
 	return ret;
 }
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 4dc17d8..8b7f19f 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -54,6 +54,8 @@ int create_free_space_inode(struct btrfs_root *root,
 			    struct btrfs_block_group_cache *block_group,
 			    struct btrfs_path *path);
 
+int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
+				       struct btrfs_block_rsv *rsv);
 int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_trans_handle *trans,
 				    struct btrfs_path *path,
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 9818d4a..2c66ddb 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -429,11 +429,12 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	num_bytes = trans->bytes_reserved;
 	/*
 	 * 1 item for inode item insertion if need
-	 * 3 items for inode item update (in the worst case)
+	 * 4 items for inode item update (in the worst case)
+	 * 1 items for slack space if we need do truncation
 	 * 1 item for free space object
 	 * 3 items for pre-allocation
 	 */
-	trans->bytes_reserved = btrfs_calc_trans_metadata_size(root, 8);
+	trans->bytes_reserved = btrfs_calc_trans_metadata_size(root, 10);
 	ret = btrfs_block_rsv_add(root, trans->block_rsv,
 				  trans->bytes_reserved,
 				  BTRFS_RESERVE_NO_FLUSH);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 704a1b8..f823711 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3350,6 +3350,11 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
 	}
 
 truncate:
+	ret = btrfs_check_trunc_cache_free_space(root,
+						 &fs_info->global_block_rsv);
+	if (ret)
+		goto out;
+
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-- 
1.8.0.1

