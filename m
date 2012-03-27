From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 01/10] Btrfs: show useful info in space reservation tracepoint
Date: Tue, 27 Mar 2012 14:44:29 +0800
Message-ID: <1332830678-3992-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

o For space info, the type of space info is useful for debug.
o For transaction handle, its transid is useful.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   29 ++++++++++-------------------
 fs/btrfs/inode-map.c   |    6 ++----
 fs/btrfs/transaction.c |    3 +--
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 37e0a80..f3d367a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3312,8 +3312,7 @@ commit_trans:
 	}
 	data_sinfo->bytes_may_use += bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
-				      (u64)(unsigned long)data_sinfo,
-				      bytes, 1);
+				      data_sinfo->flags, bytes, 1);
 	spin_unlock(&data_sinfo->lock);
 
 	return 0;
@@ -3334,8 +3333,7 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	spin_lock(&data_sinfo->lock);
 	data_sinfo->bytes_may_use -= bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
-				      (u64)(unsigned long)data_sinfo,
-				      bytes, 0);
+				      data_sinfo->flags, bytes, 0);
 	spin_unlock(&data_sinfo->lock);
 }
 
@@ -3700,9 +3698,7 @@ again:
 		if (used + orig_bytes <= space_info->total_bytes) {
 			space_info->bytes_may_use += orig_bytes;
 			trace_btrfs_space_reservation(root->fs_info,
-					      "space_info",
-					      (u64)(unsigned long)space_info,
-					      orig_bytes, 1);
+				"space_info", space_info->flags, orig_bytes, 1);
 			ret = 0;
 		} else {
 			/*
@@ -3771,9 +3767,7 @@ again:
 		if (used + num_bytes < space_info->total_bytes + avail) {
 			space_info->bytes_may_use += orig_bytes;
 			trace_btrfs_space_reservation(root->fs_info,
-					      "space_info",
-					      (u64)(unsigned long)space_info,
-					      orig_bytes, 1);
+				"space_info", space_info->flags, orig_bytes, 1);
 			ret = 0;
 		} else {
 			wait_ordered = true;
@@ -3918,8 +3912,7 @@ static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 			spin_lock(&space_info->lock);
 			space_info->bytes_may_use -= num_bytes;
 			trace_btrfs_space_reservation(fs_info, "space_info",
-					      (u64)(unsigned long)space_info,
-					      num_bytes, 0);
+					space_info->flags, num_bytes, 0);
 			space_info->reservation_progress++;
 			spin_unlock(&space_info->lock);
 		}
@@ -4137,14 +4130,14 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 		block_rsv->reserved += num_bytes;
 		sinfo->bytes_may_use += num_bytes;
 		trace_btrfs_space_reservation(fs_info, "space_info",
-				      (u64)(unsigned long)sinfo, num_bytes, 1);
+				      sinfo->flags, num_bytes, 1);
 	}
 
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
 		sinfo->bytes_may_use -= num_bytes;
 		trace_btrfs_space_reservation(fs_info, "space_info",
-				      (u64)(unsigned long)sinfo, num_bytes, 0);
+				      sinfo->flags, num_bytes, 0);
 		sinfo->reservation_progress++;
 		block_rsv->reserved = block_rsv->size;
 		block_rsv->full = 1;
@@ -4198,8 +4191,7 @@ void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 		return;
 
 	trace_btrfs_space_reservation(root->fs_info, "transaction",
-				      (u64)(unsigned long)trans,
-				      trans->bytes_reserved, 0);
+				      trans->transid, trans->bytes_reserved, 0);
 	btrfs_block_rsv_release(root, trans->block_rsv, trans->bytes_reserved);
 	trans->bytes_reserved = 0;
 }
@@ -4716,9 +4708,8 @@ static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 			space_info->bytes_reserved += num_bytes;
 			if (reserve == RESERVE_ALLOC) {
 				trace_btrfs_space_reservation(cache->fs_info,
-					      "space_info",
-					      (u64)(unsigned long)space_info,
-					      num_bytes, 0);
+						"space_info", space_info->flags,
+						num_bytes, 0);
 				space_info->bytes_may_use -= num_bytes;
 			}
 		}
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index ee15d88..ad16df1 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -439,8 +439,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	if (ret)
 		goto out;
 	trace_btrfs_space_reservation(root->fs_info, "ino_cache",
-				      (u64)(unsigned long)trans,
-				      trans->bytes_reserved, 1);
+				      trans->transid, trans->bytes_reserved, 1);
 again:
 	inode = lookup_free_ino_inode(root, path);
 	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
@@ -502,8 +501,7 @@ out_put:
 	iput(inode);
 out_release:
 	trace_btrfs_space_reservation(root->fs_info, "ino_cache",
-				      (u64)(unsigned long)trans,
-				      trans->bytes_reserved, 0);
+				      trans->transid, trans->bytes_reserved, 0);
 	btrfs_block_rsv_release(root, trans->block_rsv, trans->bytes_reserved);
 out:
 	trans->block_rsv = rsv;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04b77e3..ca65079 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -327,8 +327,7 @@ again:
 
 	if (num_bytes) {
 		trace_btrfs_space_reservation(root->fs_info, "transaction",
-					      (u64)(unsigned long)h,
-					      num_bytes, 1);
+					      h->transid, num_bytes, 1);
 		h->block_rsv = &root->fs_info->trans_block_rsv;
 		h->bytes_reserved = num_bytes;
 	}
-- 
1.6.5.2

