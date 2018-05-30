Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13967 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751826AbeE3DAp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 23:00:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 14F5D4B40414
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 11:00:40 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: drop unused parameter qgroup_reserved
Date: Wed, 30 May 2018 11:00:38 +0800
Message-ID: <1527649239-22774-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

Since commit 7775c8184ec0
("btrfs: remove unused parameter from btrfs_subvolume_release_metadata")
parameter qgroup_reserved is not used by caller
of function btrfs_subvolume_reserve_metadata.
So remove it.

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 7 ++-----
 fs/btrfs/inode.c       | 4 +---
 fs/btrfs/ioctl.c       | 5 +----
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 05829a351117..3ff9458f53a6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2767,8 +2767,7 @@ void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
-				     int nitems,
-				     u64 *qgroup_reserved, bool use_global_rsv);
+				     int nitems, bool use_global_rsv);
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fb9d5ad22bf0..25c48aed39f6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5986,7 +5986,6 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int items,
-				     u64 *qgroup_reserved,
 				     bool use_global_rsv)
 {
 	u64 num_bytes;
@@ -6004,8 +6003,6 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 		num_bytes = 0;
 	}
 
-	*qgroup_reserved = num_bytes;
-
 	num_bytes = btrfs_calc_trans_metadata_size(fs_info, items);
 	rsv->space_info = __find_space_info(fs_info,
 					    BTRFS_BLOCK_GROUP_METADATA);
@@ -6015,8 +6012,8 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (ret == -ENOSPC && use_global_rsv)
 		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes, 1);
 
-	if (ret && *qgroup_reserved)
-		btrfs_qgroup_free_meta_prealloc(root, *qgroup_reserved);
+	if (ret && num_bytes)
+		btrfs_qgroup_free_meta_prealloc(root, num_bytes);
 
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ec600f986bfb..b7e49e2fdcbf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4293,7 +4293,6 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_block_rsv block_rsv;
 	u64 root_flags;
-	u64 qgroup_reserved;
 	int ret;
 	int err;
 
@@ -4328,8 +4327,7 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	 * two for dir entries,
 	 * two for root ref/backref.
 	 */
-	err = btrfs_subvolume_reserve_metadata(root, &block_rsv,
-					       5, &qgroup_reserved, true);
+	err = btrfs_subvolume_reserve_metadata(root, &block_rsv, 5, true);
 	if (err)
 		goto out_up_write;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4560f8deefed..326374b664be 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -569,7 +569,6 @@ static noinline int create_subvol(struct inode *dir,
 	u64 objectid;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
-	u64 qgroup_reserved;
 	uuid_le new_uuid;
 
 	root_item = kzalloc(sizeof(*root_item), GFP_KERNEL);
@@ -594,8 +593,7 @@ static noinline int create_subvol(struct inode *dir,
 	 * The same as the snapshot creation, please see the comment
 	 * of create_snapshot().
 	 */
-	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
-					       8, &qgroup_reserved, false);
+	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 8, false);
 	if (ret)
 		goto fail_free;
 
@@ -803,7 +801,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	 */
 	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
 					&pending_snapshot->block_rsv, 8,
-					&pending_snapshot->qgroup_reserved,
 					false);
 	if (ret)
 		goto dec_and_free;
-- 
2.17.0



