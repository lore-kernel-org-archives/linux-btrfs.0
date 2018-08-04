Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25772 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728434AbeHDPLy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 11:11:54 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id AD70D4B66A09
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 21:11:05 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs: switch update_size to bool in both of btrfs_block_rsv_migrate and btrfs_rsv_add_bytes
Date: Sat, 4 Aug 2018 21:10:55 +0800
Message-ID: <20180804131057.9967-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using true and false here is more semantic than using 0 and 1.

No functional change.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h         |  2 +-
 fs/btrfs/delayed-inode.c |  4 ++--
 fs/btrfs/extent-tree.c   | 16 ++++++++--------
 fs/btrfs/file.c          |  4 ++--
 fs/btrfs/inode.c         |  6 +++---
 fs/btrfs/relocation.c    |  2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 318be7864072..4e8a41ef683c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2770,7 +2770,7 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 			   enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 			    struct btrfs_block_rsv *dst_rsv, u64 num_bytes,
-			    int update_size);
+			    bool update_size);
 int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_rsv *dest, u64 num_bytes,
 			     int min_factor);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index f51b509f2d9b..584cb103955e 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -559,7 +559,7 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 	 * reserved space when starting a transaction.  So no need to reserve
 	 * qgroup space here.
 	 */
-	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
+	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, true);
 	if (!ret) {
 		trace_btrfs_space_reservation(fs_info, "delayed_item",
 					      item->key.objectid,
@@ -647,7 +647,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 		return ret;
 	}
 
-	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
+	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, true);
 	if (!ret) {
 		trace_btrfs_space_reservation(fs_info, "delayed_inode",
 					      btrfs_ino(inode), num_bytes, 1);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b009ae964cc..4fb20f77d6b1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5284,7 +5284,7 @@ static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
 }
 
 static void block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
-				u64 num_bytes, int update_size)
+				u64 num_bytes, bool update_size)
 {
 	spin_lock(&block_rsv->lock);
 	block_rsv->reserved += num_bytes;
@@ -5316,7 +5316,7 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 		global_rsv->full = 0;
 	spin_unlock(&global_rsv->lock);
 
-	block_rsv_add_bytes(dest, num_bytes, 1);
+	block_rsv_add_bytes(dest, num_bytes, true);
 	return 0;
 }
 
@@ -5479,7 +5479,7 @@ static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src,
 			    struct btrfs_block_rsv *dst, u64 num_bytes,
-			    int update_size)
+			    bool update_size)
 {
 	int ret;
 
@@ -5540,7 +5540,7 @@ int btrfs_block_rsv_add(struct btrfs_root *root,
 
 	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
 	if (!ret) {
-		block_rsv_add_bytes(block_rsv, num_bytes, 1);
+		block_rsv_add_bytes(block_rsv, num_bytes, true);
 		return 0;
 	}
 
@@ -5587,7 +5587,7 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 
 	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
 	if (!ret) {
-		block_rsv_add_bytes(block_rsv, num_bytes, 0);
+		block_rsv_add_bytes(block_rsv, num_bytes, false);
 		return 0;
 	}
 
@@ -5629,7 +5629,7 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 		return ret;
 	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
 	if (!ret) {
-		block_rsv_add_bytes(block_rsv, num_bytes, 0);
+		block_rsv_add_bytes(block_rsv, num_bytes, false);
 		trace_btrfs_space_reservation(root->fs_info, "delalloc",
 					      btrfs_ino(inode), num_bytes, 1);
 
@@ -5834,7 +5834,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				  BTRFS_RESERVE_FLUSH_ALL);
 
 	if (ret == -ENOSPC && use_global_rsv)
-		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes, 1);
+		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes, true);
 
 	if (ret && qgroup_num_bytes)
 		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
@@ -8214,7 +8214,7 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
 			    struct btrfs_block_rsv *block_rsv, u32 blocksize)
 {
-	block_rsv_add_bytes(block_rsv, blocksize, 0);
+	block_rsv_add_bytes(block_rsv, blocksize, false);
 	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0, NULL);
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2be00e873e92..d254cf94545f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2544,7 +2544,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	}
 
 	ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv, rsv,
-				      min_size, 0);
+				      min_size, false);
 	BUG_ON(ret);
 	trans->block_rsv = rsv;
 
@@ -2594,7 +2594,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv,
-					      rsv, min_size, 0);
+					      rsv, min_size, false);
 		BUG_ON(ret);	/* shouldn't happen */
 		trans->block_rsv = rsv;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a7d9691a681f..a86d2f4effc6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5351,7 +5351,7 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		 * it.
 		 */
 		if (!btrfs_check_space_for_delayed_refs(trans, fs_info) &&
-		    !btrfs_block_rsv_migrate(global_rsv, rsv, min_size, 0))
+		    !btrfs_block_rsv_migrate(global_rsv, rsv, min_size, false))
 			return trans;
 
 		/* If not, commit and try again. */
@@ -9045,7 +9045,7 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 
 	/* Migrate the slack space for the truncate to our reserve */
 	ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv, rsv,
-				      min_size, 0);
+				      min_size, false);
 	BUG_ON(ret);
 
 	/*
@@ -9082,7 +9082,7 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 
 		btrfs_block_rsv_release(fs_info, rsv, -1);
 		ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv,
-					      rsv, min_size, 0);
+					      rsv, min_size, false);
 		BUG_ON(ret);	/* shouldn't happen */
 		trans->block_rsv = rsv;
 	}
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8783a1776540..995a28a724ce 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4669,7 +4669,7 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 	if (rc->merge_reloc_tree) {
 		ret = btrfs_block_rsv_migrate(&pending->block_rsv,
 					      rc->block_rsv,
-					      rc->nodes_relocated, 1);
+					      rc->nodes_relocated, true);
 		if (ret)
 			return ret;
 	}
-- 
2.18.0



