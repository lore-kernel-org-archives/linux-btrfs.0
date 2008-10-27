From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 2/4] Fix booked extent race
Date: Mon, 27 Oct 2008 21:36:51 +0800
Message-ID: <4905C3F3.6060707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yanzheng@21cn.com
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
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
--- 2/fs/btrfs/extent_io.c	2008-10-27 10:37:40.000000000 +0800
+++ 3/fs/btrfs/extent_io.c	2008-10-27 16:31:54.000000000 +0800
@@ -945,8 +945,12 @@ int try_lock_extent(struct extent_io_tre
 
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
--- 2/fs/btrfs/extent-tree.c	2008-10-27 15:32:39.000000000 +0800
+++ 3/fs/btrfs/extent-tree.c	2008-10-27 16:31:54.000000000 +0800
@@ -3373,18 +3373,20 @@ static int noinline relocate_data_extent
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
 	em->block_start = extent_key->objectid;
 	em->bdev = root->fs_info->fs_devices->latest_bdev;
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
 	/* setup extent map to cheat btrfs_readpage */
-	mutex_lock(&BTRFS_I(reloc_inode)->extent_mutex);
+	lock_extent(&BTRFS_I(reloc_inode)->io_tree, start, end, GFP_NOFS);
 	while (1) {
 		int ret;
 		spin_lock(&em_tree->lock);
@@ -3394,13 +3396,11 @@ static int noinline relocate_data_extent
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
@@ -3815,7 +3815,6 @@ next:
 			 * the file extent item was modified by someone
 			 * before the extent got locked.
 			 */
-			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
 				      lock_end, GFP_NOFS);
 			extent_locked = 0;
@@ -3880,8 +3879,12 @@ next:
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
@@ -3935,7 +3938,6 @@ next:
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
 
-			mutex_lock(&BTRFS_I(inode)->extent_mutex);
 			extent_locked = 1;
 			continue;
 		}
@@ -4045,7 +4047,6 @@ next:
 		}
 
 		if (extent_locked) {
-			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
 				      lock_end, GFP_NOFS);
 			extent_locked = 0;
@@ -4063,7 +4064,6 @@ out:
 	if (inode) {
 		mutex_unlock(&inode->i_mutex);
 		if (extent_locked) {
-			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 			unlock_extent(&BTRFS_I(inode)->io_tree, lock_start,
 				      lock_end, GFP_NOFS);
 		}
@@ -4152,10 +4152,8 @@ static int noinline invalidate_extent_ca
 
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
--- 2/fs/btrfs/file.c	2008-10-27 15:37:19.000000000 +0800
+++ 3/fs/btrfs/file.c	2008-10-27 16:31:54.000000000 +0800
@@ -316,7 +316,6 @@ static int noinline dirty_and_release_pa
 		/* step one, delete the existing extents in this range */
 		aligned_end = (pos + write_bytes + root->sectorsize - 1) &
 			~((u64)root->sectorsize - 1);
-		mutex_lock(&BTRFS_I(inode)->extent_mutex);
 		err = btrfs_drop_extents(trans, root, inode, start_pos,
 					 aligned_end, aligned_end, &hint_byte);
 		if (err)
@@ -328,7 +327,6 @@ static int noinline dirty_and_release_pa
 					   inline_size, pages, 0, num_pages);
 		btrfs_drop_extent_cache(inode, start_pos, aligned_end - 1, 0);
 		BUG_ON(err);
-		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 		/*
 		 * an ugly way to do all the prop accounting around
@@ -533,15 +531,16 @@ out:
  * inline_limit is used to tell this code which offsets in the file to keep
  * if they contain inline extents.
  */
-int noinline btrfs_drop_extents(struct btrfs_trans_handle *trans,
+int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode,
 		       u64 start, u64 end, u64 inline_limit, u64 *hint_byte)
 {
-	u64 extent_end = 0;
+	u64 extent_end;
 	u64 search_start = start;
 	u64 leaf_start;
 	u64 root_gen;
 	u64 root_owner;
+	u64 locked_end = end;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *extent;
 	struct btrfs_path *path;
@@ -580,6 +579,7 @@ next_slot:
 		bookend = 0;
 		found_extent = 0;
 		found_inline = 0;
+		extent_end = 0;
 		leaf_start = 0;
 		root_gen = 0;
 		root_owner = 0;
@@ -642,11 +642,6 @@ next_slot:
 			goto next_slot;
 		}
 
-		if (found_inline) {
-			u64 mask = root->sectorsize - 1;
-			search_start = (extent_end + mask) & ~mask;
-		} else
-			search_start = extent_end;
 		if (end <= extent_end && start >= key.offset && found_inline) {
 			*hint_byte = EXTENT_MAP_INLINE;
 			goto out;
@@ -665,6 +660,26 @@ next_slot:
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
@@ -787,6 +802,10 @@ next_slot:
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
--- 2/fs/btrfs/inode.c	2008-10-27 21:22:39.000000000 +0800
+++ 3/fs/btrfs/inode.c	2008-10-27 21:25:18.000000000 +0800
@@ -145,9 +145,7 @@ static int cow_file_range(struct inode *
 		goto out;
 
 	BUG_ON(num_bytes > btrfs_super_total_bytes(&root->fs_info->super_copy));
-	mutex_lock(&BTRFS_I(inode)->extent_mutex);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
-	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 	while(num_bytes > 0) {
 		cur_alloc_size = min(num_bytes, root->fs_info->max_extent);
@@ -163,7 +161,6 @@ static int cow_file_range(struct inode *
 		em->len = ins.offset;
 		em->block_start = ins.objectid;
 		em->bdev = root->fs_info->fs_devices->latest_bdev;
-		mutex_lock(&BTRFS_I(inode)->extent_mutex);
 		set_bit(EXTENT_FLAG_PINNED, &em->flags);
 		while(1) {
 			spin_lock(&em_tree->lock);
@@ -176,7 +173,6 @@ static int cow_file_range(struct inode *
 			btrfs_drop_extent_cache(inode, start,
 						start + ins.offset - 1, 0);
 		}
-		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 		cur_alloc_size = ins.offset;
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
@@ -609,8 +605,6 @@ static int btrfs_finish_ordered_io(struc
 
 	INIT_LIST_HEAD(&list);
 
-	mutex_lock(&BTRFS_I(inode)->extent_mutex);
-
 	ret = btrfs_drop_extents(trans, root, inode,
 				 ordered_extent->file_offset,
 				 ordered_extent->file_offset +
@@ -641,7 +635,6 @@ static int btrfs_finish_ordered_io(struc
 	btrfs_drop_extent_cache(inode, ordered_extent->file_offset,
 				ordered_extent->file_offset +
 				ordered_extent->len - 1, 0);
-	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 	ins.objectid = ordered_extent->start;
 	ins.offset = ordered_extent->len;
