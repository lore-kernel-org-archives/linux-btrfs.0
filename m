From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 4/4] Add fallocate support
Date: Mon, 27 Oct 2008 22:42:38 +0800
Message-ID: <4905D35E.50107@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yanzheng@21cn.com
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch adds fallocate support.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 4/fs/btrfs/ctree.h 5/fs/btrfs/ctree.h
--- 4/fs/btrfs/ctree.h	2008-10-27 16:34:27.000000000 +0800
+++ 5/fs/btrfs/ctree.h	2008-10-27 21:51:20.000000000 +0800
@@ -455,6 +455,7 @@ struct btrfs_root_item {
 
 #define BTRFS_FILE_EXTENT_REG 0
 #define BTRFS_FILE_EXTENT_INLINE 1
+#define BTRFS_FILE_EXTENT_PREALLOC 2
 
 struct btrfs_file_extent_item {
 	__le64 generation;
@@ -830,6 +831,7 @@ struct btrfs_root {
 #define BTRFS_INODE_NODATASUM		(1 << 0)
 #define BTRFS_INODE_NODATACOW		(1 << 1)
 #define BTRFS_INODE_READONLY		(1 << 2)
+#define BTRFS_INODE_PREALLOC		(1 << 3)
 #define btrfs_clear_flag(inode, flag)	(BTRFS_I(inode)->flags &= \
 					 ~BTRFS_INODE_##flag)
 #define btrfs_set_flag(inode, flag)	(BTRFS_I(inode)->flags |= \
@@ -1861,6 +1863,9 @@ extern struct file_operations btrfs_file
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode,
 		       u64 start, u64 end, u64 inline_limit, u64 *hint_block);
+int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct inode *inode, u64 start, u64 end);
 int btrfs_release_file(struct inode *inode, struct file *file);
 
 /* tree-defrag.c */
diff -urp 4/fs/btrfs/extent_io.c 5/fs/btrfs/extent_io.c
--- 4/fs/btrfs/extent_io.c	2008-10-27 16:31:54.000000000 +0800
+++ 5/fs/btrfs/extent_io.c	2008-10-27 21:51:20.000000000 +0800
@@ -1817,6 +1817,8 @@ printk("2bad mapping end %Lu cur %Lu\n",
 		sector = (em->block_start + extent_offset) >> 9;
 		bdev = em->bdev;
 		block_start = em->block_start;
+		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+			block_start = EXTENT_MAP_HOLE;
 		free_extent_map(em);
 		em = NULL;
 
@@ -2535,14 +2537,18 @@ sector_t extent_bmap(struct address_spac
 	struct inode *inode = mapping->host;
 	u64 start = iblock << inode->i_blkbits;
 	sector_t sector = 0;
+	size_t blksize = (1 << inode->i_blkbits);
 	struct extent_map *em;
 
-	em = get_extent(inode, NULL, 0, start, (1 << inode->i_blkbits), 0);
+	lock_extent(&BTRFS_I(inode)->io_tree, start, start + blksize - 1,
+		    GFP_NOFS);
+	em = get_extent(inode, NULL, 0, start, blksize, 0);
+	unlock_extent(&BTRFS_I(inode)->io_tree, start, start + blksize - 1,
+		      GFP_NOFS);
 	if (!em || IS_ERR(em))
 		return 0;
 
-	if (em->block_start == EXTENT_MAP_INLINE ||
-	    em->block_start == EXTENT_MAP_HOLE)
+	if (em->block_start > EXTENT_MAP_LAST_BYTE)
 		goto out;
 
 	sector = (em->block_start + start - em->start) >> inode->i_blkbits;
diff -urp 4/fs/btrfs/extent_map.h 5/fs/btrfs/extent_map.h
--- 4/fs/btrfs/extent_map.h	2008-10-27 16:31:51.000000000 +0800
+++ 5/fs/btrfs/extent_map.h	2008-10-27 21:51:20.000000000 +0800
@@ -11,6 +11,7 @@
 /* bits for the flags field */
 #define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
 #define EXTENT_FLAG_VACANCY 1 /* no file extent item found */
+#define EXTENT_FLAG_PREALLOC 2 /* pre-allocated extent */
 
 struct extent_map {
 	struct rb_node rb_node;
diff -urp 4/fs/btrfs/extent-tree.c 5/fs/btrfs/extent-tree.c
--- 4/fs/btrfs/extent-tree.c	2008-10-27 21:12:49.000000000 +0800
+++ 5/fs/btrfs/extent-tree.c	2008-10-27 21:51:20.000000000 +0800
@@ -3415,9 +3415,7 @@ walk_down:
 next:
 		level--;
 		btrfs_release_path(extent_root, path);
-		if (need_resched()) {
-			cond_resched();
-		}
+		cond_resched();
 	}
 	/* reached lowest level */
 	ret = 1;
@@ -3528,9 +3526,7 @@ found:
 		}
 
 		btrfs_release_path(extent_root, path);
-		if (need_resched()) {
-			cond_resched();
-		}
+		cond_resched();
 	}
 	/* reached max tree level, but no tree root found. */
 	BUG();
@@ -3693,6 +3689,7 @@ static int noinline replace_one_extent(s
 	u32 nritems;
 	int nr_scaned = 0;
 	int extent_locked = 0;
+	int extent_type;
 	int ret;
 
 	memcpy(&key, leaf_key, sizeof(key));
@@ -3765,8 +3762,9 @@ next:
 		}
 		fi = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_file_extent_item);
-		if ((btrfs_file_extent_type(leaf, fi) !=
-		     BTRFS_FILE_EXTENT_REG) ||
+		extent_type = btrfs_file_extent_type(leaf, fi);
+		if ((extent_type != BTRFS_FILE_EXTENT_REG &&
+		     extent_type != BTRFS_FILE_EXTENT_PREALLOC) ||
 		    (btrfs_file_extent_disk_bytenr(leaf, fi) !=
 		     extent_key->objectid)) {
 			path->slots[0]++;
diff -urp 4/fs/btrfs/file.c 5/fs/btrfs/file.c
--- 4/fs/btrfs/file.c	2008-10-27 16:31:54.000000000 +0800
+++ 5/fs/btrfs/file.c	2008-10-27 21:51:20.000000000 +0800
@@ -604,7 +604,8 @@ next_slot:
 			extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
 			found_type = btrfs_file_extent_type(leaf, extent);
-			if (found_type == BTRFS_FILE_EXTENT_REG) {
+			if (found_type == BTRFS_FILE_EXTENT_REG ||
+			    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 				extent_end =
 				     btrfs_file_extent_disk_bytenr(leaf,
 								   extent);
@@ -810,6 +811,236 @@ out:
 	return ret;
 }
 
+static int extent_mergeable(struct extent_buffer *leaf, int slot,
+			    u64 objectid, u64 bytenr, u64 *start, u64 *end)
+{
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 extent_end;
+
+	if (slot < 0 || slot >= btrfs_header_nritems(leaf))
+		return 0;
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
+		return 0;
+
+	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG ||
+	    btrfs_file_extent_disk_bytenr(leaf, fi) != bytenr)
+		return 0;
+
+	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
+	if ((*start && *start != key.offset) || (*end && *end != extent_end))
+		return 0;
+
+	*start = key.offset;
+	*end = extent_end;
+	return 1;
+}
+
+/*
+ * Mark extent in the range start - end as written.
+ *
+ * This changes extent type from 'pre-allocated' to 'regular'. If only
+ * part of extent is marked as written, the extent will be split into
+ * two or three.
+ */
+int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct inode *inode, u64 start, u64 end)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 bytenr;
+	u64 num_bytes;
+	u64 extent_end;
+	u64 extent_offset;
+	u64 other_start;
+	u64 other_end;
+	u64 split = start;
+	u64 locked_end = end;
+	int extent_type;
+	int split_end = 1;
+	int ret;
+
+	btrfs_drop_extent_cache(inode, start, end - 1, 0);
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+again:
+	key.objectid = inode->i_ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	if (split == start)
+		key.offset = split;
+	else
+		key.offset = split - 1;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0 && path->slots[0] > 0)
+		path->slots[0]--;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	BUG_ON(key.objectid != inode->i_ino ||
+	       key.type != BTRFS_EXTENT_DATA_KEY);
+	fi = btrfs_item_ptr(leaf, path->slots[0],
+			    struct btrfs_file_extent_item);
+	extent_type = btrfs_file_extent_type(leaf, fi);
+	BUG_ON(extent_type != BTRFS_FILE_EXTENT_PREALLOC);
+	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
+	BUG_ON(key.offset > start || extent_end < end);
+
+	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+	num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+	extent_offset = btrfs_file_extent_offset(leaf, fi);
+
+	if (key.offset == start)
+		split = end;
+
+	if (key.offset == start && extent_end == end) {
+		int del_nr = 0;
+		int del_slot = 0;
+		u64 leaf_owner = btrfs_header_owner(leaf);
+		u64 leaf_gen = btrfs_header_generation(leaf);
+		other_start = end;
+		other_end = 0;
+		if (extent_mergeable(leaf, path->slots[0] + 1, inode->i_ino,
+				     bytenr, &other_start, &other_end)) {
+			extent_end = other_end;
+			del_slot = path->slots[0] + 1;
+			del_nr++;
+			ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
+						leaf->start, leaf_owner,
+						leaf_gen, inode->i_ino, 0);
+			BUG_ON(ret);
+		}
+		other_start = 0;
+		other_end = start;
+		if (extent_mergeable(leaf, path->slots[0] - 1, inode->i_ino,
+				     bytenr, &other_start, &other_end)) {
+			key.offset = other_start;
+			del_slot = path->slots[0];
+			del_nr++;
+			ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
+						leaf->start, leaf_owner,
+						leaf_gen, inode->i_ino, 0);
+			BUG_ON(ret);
+		}
+		split_end = 0;
+		if (del_nr == 0) {
+			btrfs_set_file_extent_type(leaf, fi,
+						   BTRFS_FILE_EXTENT_REG);
+			goto done;
+		}
+
+		fi = btrfs_item_ptr(leaf, del_slot - 1,
+				    struct btrfs_file_extent_item);
+		btrfs_set_file_extent_type(leaf, fi, BTRFS_FILE_EXTENT_REG);
+		btrfs_set_file_extent_num_bytes(leaf, fi,
+						extent_end - key.offset);
+		btrfs_mark_buffer_dirty(leaf);
+
+		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
+		BUG_ON(ret);
+		goto done;
+	} else if (split == start) {
+		if (locked_end < extent_end) {
+			ret = try_lock_extent(&BTRFS_I(inode)->io_tree,
+					locked_end, extent_end - 1, GFP_NOFS);
+			if (!ret) {
+				btrfs_release_path(root, path);
+				lock_extent(&BTRFS_I(inode)->io_tree,
+					locked_end, extent_end - 1, GFP_NOFS);
+				locked_end = extent_end;
+				goto again;
+			}
+			locked_end = extent_end;
+		}
+		btrfs_set_file_extent_num_bytes(leaf, fi, split - key.offset);
+		extent_offset += split - key.offset;
+	} else  {
+		BUG_ON(key.offset != start);
+		btrfs_set_file_extent_offset(leaf, fi, extent_offset +
+					     split - key.offset);
+		btrfs_set_file_extent_num_bytes(leaf, fi, extent_end - split);
+		key.offset = split;
+		btrfs_set_item_key_safe(trans, root, path, &key);
+		extent_end = split;
+	}
+
+	if (extent_end == end) {
+		split_end = 0;
+		extent_type = BTRFS_FILE_EXTENT_REG;
+	}
+	if (extent_end == end && split == start) {
+		other_start = end;
+		other_end = 0;
+		if (extent_mergeable(leaf, path->slots[0] + 1, inode->i_ino,
+				     bytenr, &other_start, &other_end)) {
+			path->slots[0]++;
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			key.offset = split;
+			btrfs_set_item_key_safe(trans, root, path, &key);
+			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							other_end - split);
+			goto done;
+		}
+	}
+	if (extent_end == end && split == end) {
+		other_start = 0;
+		other_end = start;
+		if (extent_mergeable(leaf, path->slots[0] - 1 , inode->i_ino,
+				     bytenr, &other_start, &other_end)) {
+			path->slots[0]--;
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi, extent_end -
+							other_start);
+			goto done;
+		}
+	}
+
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+
+	key.offset = start;
+	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*fi));
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+	fi = btrfs_item_ptr(leaf, path->slots[0],
+			    struct btrfs_file_extent_item);
+	btrfs_set_file_extent_generation(leaf, fi, trans->transid);
+	btrfs_set_file_extent_type(leaf, fi, extent_type);
+	btrfs_set_file_extent_disk_bytenr(leaf, fi, bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, fi, num_bytes);
+	btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+	btrfs_set_file_extent_num_bytes(leaf, fi, extent_end - key.offset);
+
+	ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
+				   leaf->start, root->root_key.objectid,
+				   trans->transid, inode->i_ino);
+	BUG_ON(ret);
+done:
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+	if (split_end && split == start) {
+		split = end;
+		goto again;
+	}
+	if (locked_end > end) {
+		unlock_extent(&BTRFS_I(inode)->io_tree, end, locked_end - 1,
+			      GFP_NOFS);
+	}
+	btrfs_free_path(path);
+	return 0;
+}
+
 /*
  * this gets pages into the page cache and locks them down, it also properly
  * waits for data=ordered extents to finish before allowing the pages to be
diff -urp 4/fs/btrfs/inode.c 5/fs/btrfs/inode.c
--- 4/fs/btrfs/inode.c	2008-10-27 21:26:31.000000000 +0800
+++ 5/fs/btrfs/inode.c	2008-10-27 21:57:39.000000000 +0800
@@ -37,6 +37,7 @@
 #include <linux/version.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/falloc.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -199,7 +200,8 @@ out:
  * If no cow copies or snapshots exist, we write directly to the existing
  * blocks on disk
  */
-static int run_delalloc_nocow(struct inode *inode, u64 start, u64 end)
+static int run_delalloc_nocow(struct inode *inode, u64 start, u64 end,
+			      int force)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
@@ -268,7 +270,8 @@ next_slot:
 				    struct btrfs_file_extent_item);
 		extent_type = btrfs_file_extent_type(leaf, fi);
 
-		if (extent_type == BTRFS_FILE_EXTENT_REG) {
+		if (extent_type == BTRFS_FILE_EXTENT_REG ||
+		    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 			struct btrfs_block_group_cache *block_group;
 			disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 			extent_end = found_key.offset +
@@ -277,8 +280,11 @@ next_slot:
 				path->slots[0]++;
 				goto next_slot;
 			}
-			if (disk_bytenr == 0 ||
-			    btrfs_cross_ref_exist(trans, root, disk_bytenr))
+			if (disk_bytenr == 0)
+				goto out_check;
+			if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
+				goto out_check;
+			if (btrfs_cross_ref_exist(trans, root, disk_bytenr))
 				goto out_check;
 			block_group = btrfs_lookup_block_group(root->fs_info,
 							       disk_bytenr);
@@ -319,9 +325,32 @@ out_check:
 		}
 
 		disk_bytenr += cur_offset - found_key.offset;
+		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
+			em = alloc_extent_map(GFP_NOFS);
+			em->start = cur_offset;
+			em->len = min(end + 1, extent_end) - cur_offset;
+			em->block_start = disk_bytenr;
+			em->bdev = root->fs_info->fs_devices->latest_bdev;
+			set_bit(EXTENT_FLAG_PINNED, &em->flags);
+			while (1) {
+				spin_lock(&em_tree->lock);
+				ret = add_extent_mapping(em_tree, em);
+				spin_unlock(&em_tree->lock);
+				if (ret != -EEXIST) {
+					free_extent_map(em);
+					break;
+				}
+				btrfs_drop_extent_cache(inode, em->start,
+						em->start + em->len - 1, 0);
+			}
+			type = BTRFS_ORDERED_PREALLOC;
+		} else {
+			type = BTRFS_ORDERED_NOCOW;
+		}
+
 		ret = btrfs_add_ordered_extent(inode, cur_offset, disk_bytenr,
 					min(end + 1, extent_end) - cur_offset,
-					BTRFS_ORDERED_NOCOW);
+					type);
 		cur_offset = extent_end;
 		if (cur_offset > end)
 			break;
@@ -351,7 +380,9 @@ static int run_delalloc_range(struct ino
 
 	if (btrfs_test_opt(root, NODATACOW) ||
 	    btrfs_test_flag(inode, NODATACOW))
-		ret = run_delalloc_nocow(inode, start, end);
+		ret = run_delalloc_nocow(inode, start, end, 1);
+	else if (btrfs_test_flag(inode, PREALLOC))
+		ret = run_delalloc_nocow(inode, start, end, 0);
 	else
 		ret = cow_file_range(inode, start, end);
 
@@ -603,53 +634,27 @@ int btrfs_writepage_start_hook(struct pa
 	return -EAGAIN;
 }
 
-/* as ordered data IO finishes, this gets called so we can finish
- * an ordered extent if the range of bytes in the file it covers are
- * fully written.
- */
-static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
+static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
+				       struct inode *inode, u64 file_pos,
+				       u64 bytenr, u64 num_bytes, int type)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_ordered_extent *ordered_extent;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_file_extent_item *extent_item;
-	struct btrfs_path *path = NULL;
+	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	u64 alloc_hint = 0;
-	struct list_head list;
 	struct btrfs_key ins;
+	u64 hint;
 	int ret;
 
-	ret = btrfs_dec_test_ordered_pending(inode, start, end - start + 1);
-	if (!ret)
-		return 0;
-
-	trans = btrfs_join_transaction(root, 1);
-
-	ordered_extent = btrfs_lookup_ordered_extent(inode, start);
-	BUG_ON(!ordered_extent);
-	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
-		goto nocow;
-
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	lock_extent(io_tree, ordered_extent->file_offset,
-		    ordered_extent->file_offset + ordered_extent->len - 1,
-		    GFP_NOFS);
-
-	INIT_LIST_HEAD(&list);
-
-	ret = btrfs_drop_extents(trans, root, inode,
-				 ordered_extent->file_offset,
-				 ordered_extent->file_offset +
-				 ordered_extent->len,
-				 ordered_extent->file_offset, &alloc_hint);
+	ret = btrfs_drop_extents(trans, root, inode, file_pos,
+				 file_pos + num_bytes, file_pos, &hint);
 	BUG_ON(ret);
 
 	ins.objectid = inode->i_ino;
-	ins.offset = ordered_extent->file_offset;
+	ins.offset = file_pos;
 	ins.type = BTRFS_EXTENT_DATA_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &ins,
 				      sizeof(*extent_item));
@@ -658,30 +663,70 @@ static int btrfs_finish_ordered_io(struc
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_file_extent_item);
 	btrfs_set_file_extent_generation(leaf, extent_item, trans->transid);
-	btrfs_set_file_extent_type(leaf, extent_item, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_file_extent_disk_bytenr(leaf, extent_item,
-					  ordered_extent->start);
-	btrfs_set_file_extent_disk_num_bytes(leaf, extent_item,
-					     ordered_extent->len);
+	btrfs_set_file_extent_type(leaf, extent_item, type);
+	btrfs_set_file_extent_disk_bytenr(leaf, extent_item, bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, extent_item, num_bytes);
 	btrfs_set_file_extent_offset(leaf, extent_item, 0);
-	btrfs_set_file_extent_num_bytes(leaf, extent_item,
-					ordered_extent->len);
+	btrfs_set_file_extent_num_bytes(leaf, extent_item, num_bytes);
 	btrfs_mark_buffer_dirty(leaf);
 
-	btrfs_drop_extent_cache(inode, ordered_extent->file_offset,
-				ordered_extent->file_offset +
-				ordered_extent->len - 1, 0);
+	btrfs_drop_extent_cache(inode, file_pos, file_pos + num_bytes - 1, 0);
 
-	ins.objectid = ordered_extent->start;
-	ins.offset = ordered_extent->len;
+	ins.objectid = bytenr;
+	ins.offset = num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 	ret = btrfs_alloc_reserved_extent(trans, root, leaf->start,
 					  root->root_key.objectid,
 					  trans->transid, inode->i_ino, &ins);
 	BUG_ON(ret);
-	btrfs_release_path(root, path);
 
-	inode_add_bytes(inode, ordered_extent->len);
+	btrfs_free_path(path);
+	return 0;
+}
+
+/* as ordered data IO finishes, this gets called so we can finish
+ * an ordered extent if the range of bytes in the file it covers are
+ * fully written.
+ */
+static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_ordered_extent *ordered_extent;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	int ret;
+
+	ret = btrfs_dec_test_ordered_pending(inode, start, end - start + 1);
+	if (!ret)
+		return 0;
+
+	trans = btrfs_join_transaction(root, 1);
+
+	ordered_extent = btrfs_lookup_ordered_extent(inode, start);
+	BUG_ON(!ordered_extent);
+	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
+		goto nocow;
+
+	lock_extent(io_tree, ordered_extent->file_offset,
+		    ordered_extent->file_offset + ordered_extent->len - 1,
+		    GFP_NOFS);
+
+	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
+		ret = btrfs_mark_extent_written(trans, root, inode,
+					ordered_extent->file_offset,
+					ordered_extent->file_offset +
+					ordered_extent->len);
+		BUG_ON(ret);
+	} else {
+		ret = insert_reserved_file_extent(trans, inode,
+						ordered_extent->file_offset,
+						ordered_extent->start,
+						ordered_extent->len,
+						BTRFS_FILE_EXTENT_REG);
+		BUG_ON(ret);
+		inode_add_bytes(inode, ordered_extent->len);
+	}
+
 	unlock_extent(io_tree, ordered_extent->file_offset,
 		    ordered_extent->file_offset + ordered_extent->len - 1,
 		    GFP_NOFS);
@@ -701,8 +746,6 @@ nocow:
 	btrfs_put_ordered_extent(ordered_extent);
 
 	btrfs_end_transaction(trans, root);
-	if (path)
-		btrfs_free_path(path);
 	return 0;
 }
 
@@ -3020,7 +3063,8 @@ again:
 
 	found_type = btrfs_file_extent_type(leaf, item);
 	extent_start = found_key.offset;
-	if (found_type == BTRFS_FILE_EXTENT_REG) {
+	if (found_type == BTRFS_FILE_EXTENT_REG ||
+	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		extent_end = extent_start +
 		       btrfs_file_extent_num_bytes(leaf, item);
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
@@ -3054,7 +3098,8 @@ again:
 		goto not_found_em;
 	}
 
-	if (found_type == BTRFS_FILE_EXTENT_REG) {
+	if (found_type == BTRFS_FILE_EXTENT_REG ||
+	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		em->start = extent_start;
 		em->len = extent_end - extent_start;
 		bytenr = btrfs_file_extent_disk_bytenr(leaf, item);
@@ -3062,6 +3107,8 @@ again:
 			em->block_start = EXTENT_MAP_HOLE;
 			goto insert;
 		}
+		if (found_type == BTRFS_FILE_EXTENT_PREALLOC)
+			set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		bytenr += btrfs_file_extent_offset(leaf, item);
 		em->block_start = bytenr;
 		goto insert;
@@ -3483,6 +3530,7 @@ int btrfs_create_subvol_root(struct btrf
 	if (error)
 		return error;
 
+	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
 	return 0;
 }
@@ -3844,6 +3892,129 @@ out_fail:
 	return err;
 }
 
+static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
+			       u64 alloc_hint, int mode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_key ins;
+	u64 alloc_size;
+	u64 cur_offset = start;
+	u64 num_bytes = end - start;
+	int ret = 0;
+
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);
+	btrfs_set_trans_block_group(trans, inode);
+
+	while (num_bytes > 0) {
+		alloc_size = min(num_bytes, root->fs_info->max_extent);
+		ret = btrfs_reserve_extent(trans, root, alloc_size,
+					   root->sectorsize, 0, alloc_hint,
+					   (u64)-1, &ins, 1);
+		if (ret) {
+			WARN_ON(1);
+			goto out;
+		}
+		ret = insert_reserved_file_extent(trans, inode, cur_offset,
+						  ins.objectid, ins.offset,
+						  BTRFS_FILE_EXTENT_PREALLOC);
+		BUG_ON(ret);
+		inode_add_bytes(inode, ins.offset);
+		num_bytes -= ins.offset;
+		cur_offset += ins.offset;
+		alloc_hint = ins.objectid + ins.offset;
+	}
+out:
+	if (cur_offset > start) {
+		inode->i_ctime = CURRENT_TIME;
+		btrfs_set_flag(inode, PREALLOC);
+		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+		    cur_offset > i_size_read(inode))
+			btrfs_i_size_write(inode, cur_offset);
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+	}
+
+	btrfs_end_transaction(trans, root);
+	return ret;
+}
+
+static long btrfs_fallocate(struct inode *inode, int mode,
+			    loff_t offset, loff_t len)
+{
+	u64 cur_offset;
+	u64 last_byte;
+	u64 alloc_start;
+	u64 alloc_end;
+	u64 alloc_hint = 0;
+	u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
+	struct extent_map *em;
+	int ret;
+
+	alloc_start = offset & ~mask;
+	alloc_end =  (offset + len + mask) & ~mask;
+
+	mutex_lock(&inode->i_mutex);
+	if (alloc_start > inode->i_size) {
+		ret = btrfs_cont_expand(inode, alloc_start);
+		if (ret)
+			goto out;
+	}
+
+	while (1) {
+		struct btrfs_ordered_extent *ordered;
+		lock_extent(&BTRFS_I(inode)->io_tree, alloc_start,
+			    alloc_end - 1, GFP_NOFS);
+		ordered = btrfs_lookup_first_ordered_extent(inode,
+							    alloc_end - 1);
+		if (ordered &&
+		    ordered->file_offset + ordered->len > alloc_start &&
+		    ordered->file_offset < alloc_end) {
+			btrfs_put_ordered_extent(ordered);
+			unlock_extent(&BTRFS_I(inode)->io_tree,
+				      alloc_start, alloc_end - 1, GFP_NOFS);
+			btrfs_wait_ordered_range(inode, alloc_start,
+						 alloc_end - alloc_start);
+		} else {
+			if (ordered)
+				btrfs_put_ordered_extent(ordered);
+			break;
+		}
+	}
+
+	cur_offset = alloc_start;
+	while (1) {
+		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
+				      alloc_end - cur_offset, 0);
+		BUG_ON(IS_ERR(em) || !em);
+		last_byte = min(extent_map_end(em), alloc_end);
+		last_byte = (last_byte + mask) & ~mask;
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			ret = prealloc_file_range(inode, cur_offset,
+					last_byte, alloc_hint, mode);
+			if (ret < 0) {
+				free_extent_map(em);
+				break;
+			}
+		}
+		if (em->block_start <= EXTENT_MAP_LAST_BYTE)
+			alloc_hint = em->block_start;
+		free_extent_map(em);
+
+		cur_offset = last_byte;
+		if (cur_offset >= alloc_end) {
+			ret = 0;
+			break;
+		}
+	}
+	unlock_extent(&BTRFS_I(inode)->io_tree, alloc_start, alloc_end - 1,
+		      GFP_NOFS);
+out:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
 static int btrfs_set_page_dirty(struct page *page)
 {
 	return __set_page_dirty_nobuffers(page);
@@ -3930,6 +4101,7 @@ static struct inode_operations btrfs_fil
 	.listxattr      = btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
+	.fallocate	= btrfs_fallocate,
 };
 static struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
diff -urp 4/fs/btrfs/ioctl.c 5/fs/btrfs/ioctl.c
--- 4/fs/btrfs/ioctl.c	2008-10-27 16:31:48.000000000 +0800
+++ 5/fs/btrfs/ioctl.c	2008-10-27 21:51:20.000000000 +0800
@@ -723,7 +723,8 @@ long btrfs_ioctl_clone(struct file *file
 			extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
 			found_type = btrfs_file_extent_type(leaf, extent);
-			if (found_type == BTRFS_FILE_EXTENT_REG) {
+			if (found_type == BTRFS_FILE_EXTENT_REG ||
+			    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 				u64 ds = btrfs_file_extent_disk_bytenr(leaf,
 								       extent);
 				u64 dl = btrfs_file_extent_disk_num_bytes(leaf,
diff -urp 4/fs/btrfs/ordered-data.c 5/fs/btrfs/ordered-data.c
--- 4/fs/btrfs/ordered-data.c	2008-10-27 16:37:28.000000000 +0800
+++ 5/fs/btrfs/ordered-data.c	2008-10-27 21:51:20.000000000 +0800
@@ -182,7 +182,7 @@ int btrfs_add_ordered_extent(struct inod
 	entry->len = len;
 	entry->inode = inode;
 
-	if (type == BTRFS_ORDERED_NOCOW)
+	if (type == BTRFS_ORDERED_NOCOW || type == BTRFS_ORDERED_PREALLOC)
 		set_bit(type, &entry->flags);
 
 	/* one ref for the tree */
@@ -339,7 +339,8 @@ int btrfs_wait_ordered_extents(struct bt
 		ordered = list_entry(cur, struct btrfs_ordered_extent,
 				     root_extent_list);
 		if (nocow_only &&
-		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
+		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags) &&
+		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags)) {
 			list_move(&ordered->root_extent_list,
 				  &root->fs_info->ordered_extents);
 			cond_resched_lock(&root->fs_info->ordered_extent_lock);
diff -urp 4/fs/btrfs/ordered-data.h 5/fs/btrfs/ordered-data.h
--- 4/fs/btrfs/ordered-data.h	2008-10-27 16:37:41.000000000 +0800
+++ 5/fs/btrfs/ordered-data.h	2008-10-27 21:51:20.000000000 +0800
@@ -66,6 +66,8 @@ struct btrfs_ordered_sum {
 
 #define BTRFS_ORDERED_NOCOW 2 /* set when we want to write in place */
 
+#define BTRFS_ORDERED_PREALLOC 3 /* set when writing to prealloced extent */
+
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
diff -urp 4/fs/btrfs/transaction.c 5/fs/btrfs/transaction.c
--- 4/fs/btrfs/transaction.c	2008-10-27 16:34:27.000000000 +0800
+++ 5/fs/btrfs/transaction.c	2008-10-27 21:51:20.000000000 +0800
@@ -488,6 +488,10 @@ int btrfs_add_dead_root(struct btrfs_roo
 	dirty->root = root;
 	dirty->latest_root = latest;
 
+	spin_lock(&root->list_lock);
+	list_add(&dirty->root->dead_list, &latest->dead_list);
+	spin_unlock(&root->list_lock);
+
 	mutex_lock(&root->fs_info->trans_mutex);
 	list_add(&dirty->list, &latest->fs_info->dead_roots);
 	mutex_unlock(&root->fs_info->trans_mutex);
diff -urp 4/fs/btrfs/tree-log.c 5/fs/btrfs/tree-log.c
--- 4/fs/btrfs/tree-log.c	2008-10-27 16:31:48.000000000 +0800
+++ 5/fs/btrfs/tree-log.c	2008-10-27 21:51:20.000000000 +0800
@@ -442,7 +442,8 @@ insert:
 
 		fi = (struct btrfs_file_extent_item *)dst_ptr;
 		extent_type = btrfs_file_extent_type(path->nodes[0], fi);
-		if (extent_type == BTRFS_FILE_EXTENT_REG) {
+		if (extent_type == BTRFS_FILE_EXTENT_REG ||
+		    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 			struct btrfs_key ins;
 			ins.objectid = btrfs_file_extent_disk_bytenr(
 							path->nodes[0], fi);
@@ -538,7 +539,8 @@ static noinline int replay_one_extent(st
 	item = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
 	found_type = btrfs_file_extent_type(eb, item);
 
-	if (found_type == BTRFS_FILE_EXTENT_REG)
+	if (found_type == BTRFS_FILE_EXTENT_REG ||
+	    found_type == BTRFS_FILE_EXTENT_PREALLOC)
 		extent_end = start + btrfs_file_extent_num_bytes(eb, item);
 	else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size = btrfs_file_extent_inline_len(eb,
@@ -563,7 +565,9 @@ static noinline int replay_one_extent(st
 	ret = btrfs_lookup_file_extent(trans, root, path, inode->i_ino,
 				       start, 0);
 
-	if (ret == 0 && found_type == BTRFS_FILE_EXTENT_REG) {
+	if (ret == 0 &&
+	    (found_type == BTRFS_FILE_EXTENT_REG ||
+	     found_type == BTRFS_FILE_EXTENT_PREALLOC)) {
 		struct btrfs_file_extent_item cmp1;
 		struct btrfs_file_extent_item cmp2;
 		struct btrfs_file_extent_item *existing;
@@ -2523,7 +2527,8 @@ static noinline int copy_items(struct bt
 						struct btrfs_file_extent_item);
 
 			found_type = btrfs_file_extent_type(src, extent);
-			if (found_type == BTRFS_FILE_EXTENT_REG) {
+			if (found_type == BTRFS_FILE_EXTENT_REG ||
+			    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 				u64 ds = btrfs_file_extent_disk_bytenr(src,
 								   extent);
 				u64 dl = btrfs_file_extent_disk_num_bytes(src,
