Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41813 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726696AbeHDPzC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 11:55:02 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 4C4FE4B66A09
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 21:54:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/5] btrfs: use a separate variable to store the num_bytes of the qgroup_reserve
Date: Sat, 4 Aug 2018 21:54:03 +0800
Message-ID: <20180804135403.14356-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180804131057.9967-3-lufq.fnst@cn.fujitsu.com>
References: <20180804131057.9967-3-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After btrfs_qgroup_reserve_meta_prealloc(), num_bytes will be assigned
again by btrfs_calc_trans_metadata_size(). Therefore, once block_rsv
fails, we cannot properly free the num_bytes of the previous
qgroup_reserve.

Delete the comment for the qgroup_reserved that does not exist and add a
comment about use_global_rsv.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
Changelog:
v1->v2: break the line that exceed 80 char

 fs/btrfs/extent-tree.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index de6f75f5547b..2d9074295d7f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5800,7 +5800,7 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
  * root: the root of the parent directory
  * rsv: block reservation
  * items: the number of items that we need do reservation
- * qgroup_reserved: used to return the reserved size in qgroup
+ * use_global_rsv: allow fallback to the global block reservation
  *
  * This function is used to reserve the space for snapshot/subvolume
  * creation and deletion. Those operations are different with the
@@ -5810,10 +5810,10 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
  * the space reservation mechanism in start_transaction().
  */
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
-				     struct btrfs_block_rsv *rsv,
-				     int items,
+				     struct btrfs_block_rsv *rsv, int items,
 				     bool use_global_rsv)
 {
+	u64 qgroup_num_bytes = 0;
 	u64 num_bytes;
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -5821,12 +5821,11 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 		/* One for parent inode, two for dir entries */
-		num_bytes = 3 * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+		qgroup_num_bytes = 3 * fs_info->nodesize;
+		ret = btrfs_qgroup_reserve_meta_prealloc(root,
+				qgroup_num_bytes, true);
 		if (ret)
 			return ret;
-	} else {
-		num_bytes = 0;
 	}
 
 	num_bytes = btrfs_calc_trans_metadata_size(fs_info, items);
@@ -5838,8 +5837,8 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (ret == -ENOSPC && use_global_rsv)
 		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes, 1);
 
-	if (ret && num_bytes)
-		btrfs_qgroup_free_meta_prealloc(root, num_bytes);
+	if (ret && qgroup_num_bytes)
+		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
 
 	return ret;
 }
-- 
2.18.0



