From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 7/8] Make fallocate(2) more ENOSPC friendly
Date: Mon, 02 Nov 2009 17:20:28 +0800
Message-ID: <4AEEA45C.8030804@oracle.com>
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
diff -urp 6/fs/btrfs/inode.c 7/fs/btrfs/inode.c
--- 6/fs/btrfs/inode.c	2009-11-02 10:47:16.106890431 +0800
+++ 7/fs/btrfs/inode.c	2009-11-02 10:54:43.797890307 +0800
@@ -5578,10 +5633,10 @@ out_fail:
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
@@ -5592,17 +5647,23 @@ static int prealloc_file_range(struct bt
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
@@ -5611,22 +5672,25 @@ static int prealloc_file_range(struct bt
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
+		
+		btrfs_end_transaction(trans, root);
+		btrfs_unreserve_metadata_space(root, 3);
 	}
-
 	return ret;
 }
 
@@ -5641,8 +5705,6 @@ static long btrfs_fallocate(struct inode
 	u64 locked_end;
 	u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
 	struct extent_map *em;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root;
 	int ret;
 
 	alloc_start = offset & ~mask;
@@ -5661,9 +5723,7 @@ static long btrfs_fallocate(struct inode
 			goto out;
 	}
 
-	root = BTRFS_I(inode)->root;
-
-	ret = btrfs_check_data_free_space(root, inode,
+	ret = btrfs_check_data_free_space(BTRFS_I(inode)->root, inode,
 					  alloc_end - alloc_start);
 	if (ret)
 		goto out;
@@ -5672,12 +5732,6 @@ static long btrfs_fallocate(struct inode
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
@@ -5691,8 +5745,6 @@ static long btrfs_fallocate(struct inode
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent(&BTRFS_I(inode)->io_tree,
 				      alloc_start, locked_end, GFP_NOFS);
-			btrfs_end_transaction(trans, BTRFS_I(inode)->root);
-
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -5713,9 +5765,12 @@ static long btrfs_fallocate(struct inode
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
@@ -5734,9 +5789,8 @@ static long btrfs_fallocate(struct inode
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
