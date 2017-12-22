Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:45121 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752356AbdLVGTQ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 22 Dec 2017 01:19:16 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per inode qgroup rsv
Date: Fri, 22 Dec 2017 14:18:47 +0800
Message-Id: <20171222061847.13158-11-wqu@suse.com>
In-Reply-To: <20171222061847.13158-1-wqu@suse.com>
References: <20171222061847.13158-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike reservation calculation used in inode rsv for metadata, qgroup
doesn't really need to care things like csum size or extent usage for
whole tree COW.

Qgroup care more about net change of extent usage.
That's to say, if we're going to insert one file extent, it will mostly
find its place in CoWed tree block, leaving no change in extent usage.
Or cause leaf split, result one new net extent, increasing qgroup number
by nodesize.
(Or even more rare case, increase the tree level, increasing qgroup
number by 2 * nodesize)

So here instead of using the way overkilled calculation for extent
allocator, which cares more about accurate and no error, qgroup doesn't
need that over-calculated reservation.

This patch will maintain 2 new members in btrfs_block_rsv structure for
qgroup, using much smaller calculation for qgroup rsv, reducing false
EDQUOT.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       | 18 +++++++++++++++++
 fs/btrfs/extent-tree.c | 55 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0c58f92c2d44..97783ba91e00 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -467,6 +467,24 @@ struct btrfs_block_rsv {
 	unsigned short full;
 	unsigned short type;
 	unsigned short failfast;
+
+	/*
+	 * Qgroup equivalent for @size @reserved
+	 *
+	 * Unlike normal normal @size/@reserved for inode rsv,
+	 * qgroup doesn't care about things like csum size nor how many tree
+	 * blocks it will need to reserve.
+	 *
+	 * Qgroup cares more about *NET* change of extent usage.
+	 * So for ONE newly inserted file extent, in worst case it will cause
+	 * leaf split and level increase, nodesize for each file extent
+	 * is already way overkilled.
+	 *
+	 * In short, qgroup_size/reserved is the up limit of possible needed
+	 * qgroup metadata reservation.
+	 */
+	u64 qgroup_rsv_size;
+	u64 qgroup_rsv_reserved;
 };
 
 /*
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 986660f301de..9d579c7bcf7f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5565,14 +5565,18 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 
 static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 				    struct btrfs_block_rsv *block_rsv,
-				    struct btrfs_block_rsv *dest, u64 num_bytes)
+				    struct btrfs_block_rsv *dest, u64 num_bytes,
+				    u64 *qgroup_to_release_ret)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
+	u64 qgroup_to_release = 0;
 	u64 ret;
 
 	spin_lock(&block_rsv->lock);
-	if (num_bytes == (u64)-1)
+	if (num_bytes == (u64)-1) {
 		num_bytes = block_rsv->size;
+		qgroup_to_release = block_rsv->qgroup_rsv_size;
+	}
 	block_rsv->size -= num_bytes;
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
@@ -5581,6 +5585,12 @@ static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 	} else {
 		num_bytes = 0;
 	}
+	if (block_rsv->qgroup_rsv_reserved >= block_rsv->qgroup_rsv_size) {
+		qgroup_to_release = block_rsv->qgroup_rsv_reserved -
+				    block_rsv->qgroup_rsv_size;
+		block_rsv->qgroup_rsv_reserved = block_rsv->qgroup_rsv_size;
+	} else
+		qgroup_to_release = 0;
 	spin_unlock(&block_rsv->lock);
 
 	ret = num_bytes;
@@ -5603,6 +5613,8 @@ static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 			space_info_add_old_bytes(fs_info, space_info,
 						 num_bytes);
 	}
+	if (qgroup_to_release_ret)
+		*qgroup_to_release_ret = qgroup_to_release;
 	return ret;
 }
 
@@ -5744,17 +5756,21 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 num_bytes = 0;
+	u64 qgroup_num_bytes = 0;
 	int ret = -ENOSPC;
 
 	spin_lock(&block_rsv->lock);
 	if (block_rsv->reserved < block_rsv->size)
 		num_bytes = block_rsv->size - block_rsv->reserved;
+	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
+		qgroup_num_bytes = block_rsv->qgroup_rsv_size -
+				   block_rsv->qgroup_rsv_reserved;
 	spin_unlock(&block_rsv->lock);
 
 	if (num_bytes == 0)
 		return 0;
 
-	ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, true);
 	if (ret)
 		return ret;
 	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
@@ -5762,7 +5778,13 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 		block_rsv_add_bytes(block_rsv, num_bytes, 0);
 		trace_btrfs_space_reservation(root->fs_info, "delalloc",
 					      btrfs_ino(inode), num_bytes, 1);
-	}
+
+		/* Don't forget to increase qgroup_rsv_reserved */
+		spin_lock(&block_rsv->lock);
+		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
+		spin_unlock(&block_rsv->lock);
+	} else
+		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
 	return ret;
 }
 
@@ -5784,20 +5806,23 @@ void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 released = 0;
+	u64 qgroup_to_release = 0;
 
 	/*
 	 * Since we statically set the block_rsv->size we just want to say we
 	 * are releasing 0 bytes, and then we'll just get the reservation over
 	 * the size free'd.
 	 */
-	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0);
+	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0,
+					   &qgroup_to_release);
 	if (released > 0)
 		trace_btrfs_space_reservation(fs_info, "delalloc",
 					      btrfs_ino(inode), released, 0);
 	if (qgroup_free)
-		btrfs_qgroup_free_meta_prealloc(inode->root, released);
+		btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release);
 	else
-		btrfs_qgroup_convert_reserved_meta(inode->root, released);
+		btrfs_qgroup_convert_reserved_meta(inode->root,
+						   qgroup_to_release);
 }
 
 void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
@@ -5809,7 +5834,7 @@ void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 	if (global_rsv == block_rsv ||
 	    block_rsv->space_info != global_rsv->space_info)
 		global_rsv = NULL;
-	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes);
+	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes, NULL);
 }
 
 static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
@@ -5889,7 +5914,7 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,
-				(u64)-1);
+				(u64)-1, NULL);
 	WARN_ON(fs_info->trans_block_rsv.size > 0);
 	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
 	WARN_ON(fs_info->chunk_block_rsv.size > 0);
@@ -5931,7 +5956,7 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
 	WARN_ON_ONCE(!list_empty(&trans->new_bgs));
 
 	block_rsv_release_bytes(fs_info, &fs_info->chunk_block_rsv, NULL,
-				trans->chunk_bytes_reserved);
+				trans->chunk_bytes_reserved, NULL);
 	trans->chunk_bytes_reserved = 0;
 }
 
@@ -6036,6 +6061,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 reserve_size = 0;
+	u64 qgroup_rsv_size = 0;
 	u64 csum_leaves;
 	unsigned outstanding_extents;
 
@@ -6048,9 +6074,16 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 						 inode->csum_bytes);
 	reserve_size += btrfs_calc_trans_metadata_size(fs_info,
 						       csum_leaves);
+	/*
+	 * For qgroup rsv, the calculation is very simple:
+	 * nodesize for each outstanding extent.
+	 * This is already overkilled under most case.
+	 */
+	qgroup_rsv_size = outstanding_extents * fs_info->nodesize;
 
 	spin_lock(&block_rsv->lock);
 	block_rsv->size = reserve_size;
+	block_rsv->qgroup_rsv_size = qgroup_rsv_size;
 	spin_unlock(&block_rsv->lock);
 }
 
@@ -8405,7 +8438,7 @@ static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
 			    struct btrfs_block_rsv *block_rsv, u32 blocksize)
 {
 	block_rsv_add_bytes(block_rsv, blocksize, 0);
-	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0);
+	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0, NULL);
 }
 
 /*
-- 
2.15.1

