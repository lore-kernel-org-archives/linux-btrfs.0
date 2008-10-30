From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 2/4] Fix booked extent race v2
Date: Fri, 31 Oct 2008 01:02:25 +0800
Message-ID: <4909E8A1.1050101@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, ukernel@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When dropping middle part of an extent, btrfs_drop_extents truncates
the extent at first, then inserts a booked extent. Since truncation
and insertion can't be done atomically, there is a small period that
the booked extent isn't in the tree. This causes problem for functions
that search the tree for file extent item. The way to fix this is lock
the range of the booked extent before truncation.

Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/extent_io.c 3/fs/btrfs/extent_io.c
--- 2/fs/btrfs/extent_io.c	2008-10-30 13:32:41.000000000 +0800
+++ 3/fs/btrfs/extent_io.c	2008-10-30 13:33:51.000000000 +0800
@@ -946,8 +946,12 @@ int try_lock_extent(struct extent_io_tre
 
 	err = set_extent_bit(tree, start, end, EXTENT_LOCKED, 1,
 			     &failed_start, mask);
-	if (err == -EEXIST)
+	if (err == -EEXIST) {
+		if (failed_start > start)
+			clear_extent_bit(tree, start, failed_start - 1,
+					 EXTENT_LOCKED, 1, 0, mask);
 		return 0;
+	}
 	return 1;
 }
 EXPORT_SYMBOL(try_lock_extent);
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2008-10-30 07:22:02.000000000 +0800
+++ 3/fs/btrfs/extent-tree.c	2008-10-30 15:22:16.000000000 +0800
@@ -3373,11 +3373,13 @@ static int noinline relocate_data_extent
 	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
 	struct extent_map_tree *em_tree = &BTRFS_I(reloc_inode)->extent_tree;
 	struct extent_map *em;
+	u64 start = extent_key->objectid - offset;
+	u64 end = start + extent_key->offset - 1;
 
 	em = alloc_extent_map(GFP_NOFS);
 	BUG_ON(!em || IS_ERR(em));
 
-	em->start = extent_key->objectid - offset;
+	em->start = start;
 	em->len = extent_key->offset;
 	em->block_len = extent_key->offset;
 	em->block_start = extent_key->objectid;
@@ -3385,7 +3387,7 @@ static int noinline relocate_data_extent
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 	/* setup extent map to cheat btrfs_readpage */
-	mutex_lock(&BTRFS_I(reloc_inode)->extent_mutex);
+	lock_extent(&BTRFS_I(reloc_inode)->io_tree, start, end, GFP_NOFS);
 	while (1) {
 		int ret;
 		spin_lock(&em_tree->lock);
@@ -3395,13 +3397,11 @@ static int noinline relocate_data_extent
 			free_extent_map(em);
 			break;
 		}
-		btrfs_drop_extent_cache(reloc_inode, em->start,
-					em->start + em->len - 1, 0);
+		btrfs_drop_extent_cache(reloc_inode, start, end, 0);
 	}
-	mutex_unlock(&BTRFS_I(reloc_inode)->extent_mutex);
+	unlock_extent(&BTRFS_I(reloc_inode)->io_tree, start, end, GFP_NOFS);
 
-	return relocate_inode_pages(reloc_inode, extent_key->objectid - offset,
-				    extent_key->offset);
+	return relocate_inode_pages(reloc_inode, start, extent_key->offset);
 }
 
 struct btrfs_ref_path {
@@ -3825,7 +3825,6 @@ next:
 			 * the file extent item was modified by someone
 			 * before the extent got locked.
 			 */
-			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
 				      lock_end, GFP_NOFS);
 			extent_locked = 0;
@@ -3890,8 +3889,12 @@ next:
 			lock_start = key.offset;
 			lock_end = lock_start + num_bytes - 1;
 		} else {
-			BUG_ON(lock_start != key.offset);
-			BUG_ON(lock_end - lock_start + 1 < num_bytes);
+			if (lock_start > key.offset ||
+			    lock_end + 1 < key.offset + num_bytes) {
+				unlock_extent(&BTRFS_I(inode)->io_tree,
+					      lock_start, lock_end, GFP_NOFS);
+				extent_locked = 0;
+			}
 		}
 
 		if (!inode) {
@@ -3945,7 +3948,6 @@ next:
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
 
-			mutex_lock(&BTRFS_I(inode)->extent_mutex);
 			extent_locked = 1;
 			continue;
 		}
@@ -4067,7 +4069,6 @@ next:
 		}
 
 		if (extent_locked) {
-			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
 				      lock_end, GFP_NOFS);
 			extent_locked = 0;
@@ -4085,7 +4086,6 @@ out:
 	if (inode) {
 		mutex_unlock(&inode->i_mutex);
 		if (extent_locked) {
-			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
 				      lock_end, GFP_NOFS);
 		}
@@ -4174,10 +4174,8 @@ static int noinline invalidate_extent_ca
 
 		lock_extent(&BTRFS_I(inode)->io_tree, key.offset,
 			    key.offset + num_bytes - 1, GFP_NOFS);
-		mutex_lock(&BTRFS_I(inode)->extent_mutex);
 		btrfs_drop_extent_cache(inode, key.offset,
 					key.offset + num_bytes - 1, 1);
-		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 		unlock_extent(&BTRFS_I(inode)->io_tree, key.offset,
 			      key.offset + num_bytes - 1, GFP_NOFS);
 		cond_resched();
diff -urp 2/fs/btrfs/file.c 3/fs/btrfs/file.c
--- 2/fs/btrfs/file.c	2008-10-30 13:27:18.000000000 +0800
+++ 3/fs/btrfs/file.c	2008-10-30 13:39:28.000000000 +0800
@@ -364,6 +364,7 @@ int noinline btrfs_drop_extents(struct b
 		       u64 start, u64 end, u64 inline_limit, u64 *hint_byte)
 {
 	u64 extent_end = 0;
+	u64 locked_end = end;
 	u64 search_start = start;
 	u64 leaf_start;
 	u64 ram_bytes = 0;
@@ -479,12 +480,6 @@ next_slot:
 			goto next_slot;
 		}
 
-		if (found_inline) {
-			u64 mask = root->sectorsize - 1;
-			search_start = (extent_end + mask) & ~mask;
-		} else
-			search_start = extent_end;
-
 		if (end <= extent_end && start >= key.offset && found_inline)
 			*hint_byte = EXTENT_MAP_INLINE;
 
@@ -501,6 +496,26 @@ next_slot:
 			if (found_inline && start <= key.offset)
 				keep = 1;
 		}
+
+		if (bookend && found_extent && locked_end < extent_end) {
+			ret = try_lock_extent(&BTRFS_I(inode)->io_tree,
+					locked_end, extent_end - 1, GFP_NOFS);
+			if (!ret) {
+				btrfs_release_path(root, path);
+				lock_extent(&BTRFS_I(inode)->io_tree,
+					locked_end, extent_end - 1, GFP_NOFS);
+				locked_end = extent_end;
+				continue;
+			}
+			locked_end = extent_end;
+		}
+
+		if (found_inline) {
+			u64 mask = root->sectorsize - 1;
+			search_start = (extent_end + mask) & ~mask;
+		} else
+			search_start = extent_end;
+
 		/* truncate existing extent */
 		if (start > key.offset) {
 			u64 new_num;
@@ -638,6 +653,10 @@ next_slot:
 	}
 out:
 	btrfs_free_path(path);
+	if (locked_end > end) {
+		unlock_extent(&BTRFS_I(inode)->io_tree, end, locked_end - 1,
+			      GFP_NOFS);
+	}
 	btrfs_check_file(root, inode);
 	return ret;
 }
diff -urp 2/fs/btrfs/inode.c 3/fs/btrfs/inode.c
--- 2/fs/btrfs/inode.c	2008-10-30 15:48:22.000000000 +0800
+++ 3/fs/btrfs/inode.c	2008-10-30 15:48:35.000000000 +0800
@@ -246,7 +246,6 @@ static int cow_file_range_inline(struct 
 		return 1;
 	}
 
-	mutex_lock(&BTRFS_I(inode)->extent_mutex);
 	ret = btrfs_drop_extents(trans, root, inode, start,
 				 aligned_end, aligned_end, &hint_byte);
 	BUG_ON(ret);
@@ -258,7 +257,6 @@ static int cow_file_range_inline(struct 
 				   compressed_pages);
 	BUG_ON(ret);
 	btrfs_drop_extent_cache(inode, start, aligned_end, 0);
-	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 	return 0;
 }
 
@@ -437,9 +435,7 @@ again:
 	BUG_ON(disk_num_bytes >
 	       btrfs_super_total_bytes(&root->fs_info->super_copy));
 
-	mutex_lock(&BTRFS_I(inode)->extent_mutex);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
-	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 	while(disk_num_bytes > 0) {
 		unsigned long min_bytes;
@@ -477,8 +473,6 @@ again:
 		em->block_start = ins.objectid;
 		em->block_len = ins.offset;
 		em->bdev = root->fs_info->fs_devices->latest_bdev;
-
-		mutex_lock(&BTRFS_I(inode)->extent_mutex);
 		set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 		if (will_compress)
@@ -495,7 +489,6 @@ again:
 			btrfs_drop_extent_cache(inode, start,
 						start + ram_size - 1, 0);
 		}
-		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 		cur_alloc_size = ins.offset;
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
@@ -1015,8 +1008,6 @@ static int btrfs_finish_ordered_io(struc
 
 	INIT_LIST_HEAD(&list);
 
-	mutex_lock(&BTRFS_I(inode)->extent_mutex);
-
 	ret = btrfs_drop_extents(trans, root, inode,
 				 ordered_extent->file_offset,
 				 ordered_extent->file_offset +
@@ -1058,7 +1049,6 @@ static int btrfs_finish_ordered_io(struc
 	btrfs_drop_extent_cache(inode, ordered_extent->file_offset,
 				ordered_extent->file_offset +
 				ordered_extent->len - 1, 0);
-	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 	ins.objectid = ordered_extent->start;
 	ins.offset = ordered_extent->disk_len;

