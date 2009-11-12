From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 07/12] Btrfs: Make fallocate(2) more ENOSPC friendly
Date: Thu, 12 Nov 2009 17:34:52 +0800
Message-ID: <4AFBD6BC.3080104@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fallocate(2) may allocate large number of file extents, so it's not
good to do it in a single transaction. This patch make fallocate(2)
start a new transaction for each file extents it allocates.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---
 fs/btrfs/inode.c |   65 ++++++++++++++++++++++++++---------------------------
 1 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 75a6647..f60cd94 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5659,10 +5659,10 @@ out_fail:
 	return err;
 }
 
-static int prealloc_file_range(struct btrfs_trans_handle *trans,
-			       struct inode *inode, u64 start, u64 end,
+static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
 			       u64 alloc_hint, int mode)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 alloc_size;
@@ -5673,17 +5673,23 @@ static int prealloc_file_range(struct btrfs_trans_handle *trans,
 	while (num_bytes > 0) {
 		alloc_size = min(num_bytes, root->fs_info->max_extent);
 
-		ret = btrfs_reserve_metadata_space(root, 1);
-		if (ret)
-			goto out;
-
 		ret = btrfs_reserve_extent(trans, root, alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
 		if (ret) {
 			WARN_ON(1);
-			goto out;
+			break;
+		}
+
+		ret = btrfs_reserve_metadata_space(root, 3);
+		if (ret) {
+			btrfs_free_reserved_extent(root, ins.objectid,
+						   ins.offset);
+			break;
 		}
+
+		trans = btrfs_start_transaction(root, 1);
+
 		ret = insert_reserved_file_extent(trans, inode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
@@ -5692,22 +5698,25 @@ static int prealloc_file_range(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 		btrfs_drop_extent_cache(inode, cur_offset,
 					cur_offset + ins.offset -1, 0);
+
 		num_bytes -= ins.offset;
 		cur_offset += ins.offset;
 		alloc_hint = ins.objectid + ins.offset;
-		btrfs_unreserve_metadata_space(root, 1);
-	}
-out:
-	if (cur_offset > start) {
+
 		inode->i_ctime = CURRENT_TIME;
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-		    cur_offset > i_size_read(inode))
-			btrfs_i_size_write(inode, cur_offset);
+		    cur_offset > inode->i_size) {
+			i_size_write(inode, cur_offset);
+			btrfs_ordered_update_i_size(inode, cur_offset, NULL);
+		}
+
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
-	}
 
+		btrfs_end_transaction(trans, root);
+		btrfs_unreserve_metadata_space(root, 3);
+	}
 	return ret;
 }
 
@@ -5722,8 +5731,6 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	u64 locked_end;
 	u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
 	struct extent_map *em;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root;
 	int ret;
 
 	alloc_start = offset & ~mask;
@@ -5742,9 +5749,7 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 			goto out;
 	}
 
-	root = BTRFS_I(inode)->root;
-
-	ret = btrfs_check_data_free_space(root, inode,
+	ret = btrfs_check_data_free_space(BTRFS_I(inode)->root, inode,
 					  alloc_end - alloc_start);
 	if (ret)
 		goto out;
@@ -5753,12 +5758,6 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
 
-		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
-		if (!trans) {
-			ret = -EIO;
-			goto out_free;
-		}
-
 		/* the extent lock is ordered inside the running
 		 * transaction
 		 */
@@ -5772,8 +5771,6 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent(&BTRFS_I(inode)->io_tree,
 				      alloc_start, locked_end, GFP_NOFS);
-			btrfs_end_transaction(trans, BTRFS_I(inode)->root);
-
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -5794,9 +5791,12 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 		BUG_ON(IS_ERR(em) || !em);
 		last_byte = min(extent_map_end(em), alloc_end);
 		last_byte = (last_byte + mask) & ~mask;
-		if (em->block_start == EXTENT_MAP_HOLE) {
-			ret = prealloc_file_range(trans, inode, cur_offset,
-						last_byte, alloc_hint, mode);
+		if (em->block_start == EXTENT_MAP_HOLE ||
+		    (cur_offset >= inode->i_size &&
+		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
+			ret = prealloc_file_range(inode,
+						  cur_offset, last_byte,
+						  alloc_hint, mode);
 			if (ret < 0) {
 				free_extent_map(em);
 				break;
@@ -5815,9 +5815,8 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	unlock_extent(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 		      GFP_NOFS);
 
-	btrfs_end_transaction(trans, BTRFS_I(inode)->root);
-out_free:
-	btrfs_free_reserved_data_space(root, inode, alloc_end - alloc_start);
+	btrfs_free_reserved_data_space(BTRFS_I(inode)->root, inode,
+				       alloc_end - alloc_start);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
-- 
1.6.2.5

