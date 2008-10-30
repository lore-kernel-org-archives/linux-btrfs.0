From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 1/4] update hole handling v2
Date: Fri, 31 Oct 2008 01:02:08 +0800
Message-ID: <4909E890.6080600@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, ukernel@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch splits the hole insertion code out of btrfs_setattr
into btrfs_cont_expand and updates btrfs_get_extent to properly
handle the case that file extent items are not continuous.

Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2008-10-30 07:22:02.000000000 +0800
+++ 2/fs/btrfs/ctree.h	2008-10-30 13:06:26.000000000 +0800
@@ -1908,6 +1908,7 @@ int btrfs_update_inode(struct btrfs_tran
 int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
 int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 void btrfs_orphan_cleanup(struct btrfs_root *root);
+int btrfs_cont_expand(struct inode *inode, loff_t size);
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
diff -urp 1/fs/btrfs/extent_map.h 2/fs/btrfs/extent_map.h
--- 1/fs/btrfs/extent_map.h	2008-10-30 07:22:02.000000000 +0800
+++ 2/fs/btrfs/extent_map.h	2008-10-30 13:24:55.000000000 +0800
@@ -11,6 +11,7 @@
 /* bits for the flags field */
 #define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
 #define EXTENT_FLAG_COMPRESSED 1
+#define EXTENT_FLAG_VACANCY 2 /* no file extent item found */
 
 struct extent_map {
 	struct rb_node rb_node;
diff -urp 1/fs/btrfs/file.c 2/fs/btrfs/file.c
--- 1/fs/btrfs/file.c	2008-10-30 07:22:02.000000000 +0800
+++ 2/fs/btrfs/file.c	2008-10-30 13:27:18.000000000 +0800
@@ -142,40 +142,6 @@ static int noinline dirty_and_release_pa
 	}
 	set_extent_uptodate(io_tree, start_pos, end_of_last_block, GFP_NOFS);
 
-	/* FIXME...EIEIO, ENOSPC and more */
-	/* insert any holes we need to create */
-	if (isize < start_pos) {
-		u64 last_pos_in_file;
-		u64 hole_size;
-		u64 mask = root->sectorsize - 1;
-		last_pos_in_file = (isize + mask) & ~mask;
-		hole_size = (start_pos - last_pos_in_file + mask) & ~mask;
-		if (hole_size > 0) {
-			btrfs_wait_ordered_range(inode, last_pos_in_file,
-						 last_pos_in_file + hole_size);
-			mutex_lock(&BTRFS_I(inode)->extent_mutex);
-			err = btrfs_drop_extents(trans, root, inode,
-						 last_pos_in_file,
-						 last_pos_in_file + hole_size,
-						 last_pos_in_file,
-						 &hint_byte);
-			if (err)
-				goto failed;
-
-			err = btrfs_insert_file_extent(trans, root,
-						       inode->i_ino,
-						       last_pos_in_file,
-						       0, 0, hole_size, 0,
-						       hole_size, 0, 0, 0);
-			btrfs_drop_extent_cache(inode, last_pos_in_file,
-					last_pos_in_file + hole_size - 1, 0);
-			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
-			btrfs_check_file(root, inode);
-		}
-		if (err)
-			goto failed;
-	}
-
 	/* check for reserved extents on each page, we don't want
 	 * to reset the delalloc bit on things that already have
 	 * extents reserved.
@@ -191,7 +157,6 @@ static int noinline dirty_and_release_pa
 		i_size_write(inode, end_pos);
 		btrfs_update_inode(trans, root, inode);
 	}
-failed:
 	err = btrfs_end_transaction(trans, root);
 out_unlock:
 	unlock_extent(io_tree, start_pos, end_of_last_block, GFP_NOFS);
@@ -697,6 +662,12 @@ static int noinline prepare_pages(struct
 	start_pos = pos & ~((u64)root->sectorsize - 1);
 	last_pos = ((u64)index + num_pages) << PAGE_CACHE_SHIFT;
 
+	if (start_pos > inode->i_size) {
+		err = btrfs_cont_expand(inode, start_pos);
+		if (err)
+			return err;
+	}
+
 	memset(pages, 0, num_pages * sizeof(struct page *));
 again:
 	for (i = 0; i < num_pages; i++) {
diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
--- 1/fs/btrfs/inode.c	2008-10-30 15:24:19.000000000 +0800
+++ 2/fs/btrfs/inode.c	2008-10-30 15:48:22.000000000 +0800
@@ -2295,81 +2295,91 @@ out:
 	return ret;
 }
 
-static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
+int btrfs_cont_expand(struct inode *inode, loff_t size)
 {
-	struct inode *inode = dentry->d_inode;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_map *em;
+	u64 mask = root->sectorsize - 1;
+	u64 hole_start = (inode->i_size + mask) & ~mask;
+	u64 block_end = (size + mask) & ~mask;
+	u64 last_byte;
+	u64 cur_offset;
+	u64 hole_size;
 	int err;
 
-	err = inode_change_ok(inode, attr);
+	if (size <= hole_start)
+		return 0;
+
+	err = btrfs_check_free_space(root, 1, 0);
 	if (err)
 		return err;
 
-	if (S_ISREG(inode->i_mode) &&
-	    attr->ia_valid & ATTR_SIZE && attr->ia_size > inode->i_size) {
-		struct btrfs_trans_handle *trans;
-		struct btrfs_root *root = BTRFS_I(inode)->root;
-		struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-
-		u64 mask = root->sectorsize - 1;
-		u64 hole_start = (inode->i_size + mask) & ~mask;
-		u64 block_end = (attr->ia_size + mask) & ~mask;
-		u64 hole_size;
-		u64 alloc_hint = 0;
-
-		if (attr->ia_size <= hole_start)
-			goto out;
-
-		err = btrfs_check_free_space(root, 1, 0);
-		if (err)
-			goto fail;
-
-		btrfs_truncate_page(inode->i_mapping, inode->i_size);
+	btrfs_truncate_page(inode->i_mapping, inode->i_size);
 
-		hole_size = block_end - hole_start;
-		while(1) {
-			struct btrfs_ordered_extent *ordered;
-			btrfs_wait_ordered_range(inode, hole_start, hole_size);
-
-			lock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
-			ordered = btrfs_lookup_ordered_extent(inode, hole_start);
-			if (ordered) {
-				unlock_extent(io_tree, hole_start,
-					      block_end - 1, GFP_NOFS);
-				btrfs_put_ordered_extent(ordered);
-			} else {
-				break;
-			}
-		}
+	while (1) {
+		struct btrfs_ordered_extent *ordered;
+		btrfs_wait_ordered_range(inode, hole_start,
+					 block_end - hole_start);
+		lock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
+		ordered = btrfs_lookup_ordered_extent(inode, hole_start);
+		if (!ordered)
+			break;
+		unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
+		btrfs_put_ordered_extent(ordered);
+	}
 
-		trans = btrfs_start_transaction(root, 1);
-		btrfs_set_trans_block_group(trans, inode);
-		mutex_lock(&BTRFS_I(inode)->extent_mutex);
-		err = btrfs_drop_extents(trans, root, inode,
-					 hole_start, block_end, hole_start,
-					 &alloc_hint);
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_trans_block_group(trans, inode);
 
-		if (alloc_hint != EXTENT_MAP_INLINE) {
+	cur_offset = hole_start;
+	while (1) {
+		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
+				block_end - cur_offset, 0);
+		BUG_ON(IS_ERR(em) || !em);
+		last_byte = min(extent_map_end(em), block_end);
+		last_byte = (last_byte + mask) & ~mask;
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+			hole_size = last_byte - cur_offset;
 			err = btrfs_insert_file_extent(trans, root,
-						       inode->i_ino,
-						       hole_start, 0, 0,
-						       hole_size, 0, hole_size,
-						       0, 0, 0);
+					inode->i_ino, cur_offset, 0,
+					0, hole_size, 0, hole_size,
+					0, 0, 0);
 			btrfs_drop_extent_cache(inode, hole_start,
-						(u64)-1, 0);
-			btrfs_check_file(root, inode);
+					last_byte - 1, 0);
 		}
-		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
-		btrfs_end_transaction(trans, root);
-		unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
+		free_extent_map(em);
+		cur_offset = last_byte;
+		if (err || cur_offset >= block_end)
+			break;
+	}
+
+	btrfs_end_transaction(trans, root);
+	unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
+	return err;
+}
+
+static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	int err;
+
+	err = inode_change_ok(inode, attr);
+	if (err)
+		return err;
+
+	if (S_ISREG(inode->i_mode) &&
+	    attr->ia_valid & ATTR_SIZE && attr->ia_size > inode->i_size) {
+		err = btrfs_cont_expand(inode, attr->ia_size);
 		if (err)
 			return err;
 	}
-out:
+
 	err = inode_setattr(inode, attr);
 
 	if (!err && ((attr->ia_valid & ATTR_MODE)))
 		err = btrfs_acl_chmod(inode);
-fail:
 	return err;
 }
 
@@ -3455,27 +3465,44 @@ again:
 	if (found_type == BTRFS_FILE_EXTENT_REG) {
 		extent_end = extent_start +
 		       btrfs_file_extent_num_bytes(leaf, item);
-		err = 0;
-		if (start < extent_start || start >= extent_end) {
-			em->start = start;
-			if (start < extent_start) {
-				if (start + len <= extent_start)
-					goto not_found;
-				em->len = extent_end - extent_start;
-			} else {
-				em->len = len;
+	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
+		size_t size;
+		size = btrfs_file_extent_inline_len(leaf, item);
+		extent_end = (extent_start + size + root->sectorsize - 1) &
+			~((u64)root->sectorsize - 1);
+	}
+
+	if (start >= extent_end) {
+		path->slots[0]++;
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				err = ret;
+				goto out;
 			}
-			goto not_found_em;
+			if (ret > 0)
+				goto not_found;
+			leaf = path->nodes[0];
 		}
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.objectid != objectid ||
+		    found_key.type != BTRFS_EXTENT_DATA_KEY)
+			goto not_found;
+		if (start + len <= found_key.offset)
+			goto not_found;
+		em->start = start;
+		em->len = found_key.offset - start;
+		goto not_found_em;
+	}
+
+	if (found_type == BTRFS_FILE_EXTENT_REG) {
+		em->start = extent_start;
+		em->len = extent_end - extent_start;
 		bytenr = btrfs_file_extent_disk_bytenr(leaf, item);
 		if (bytenr == 0) {
-			em->start = extent_start;
-			em->len = extent_end - extent_start;
 			em->block_start = EXTENT_MAP_HOLE;
 			goto insert;
 		}
-		em->start = extent_start;
-		em->len = extent_end - extent_start;
 		if (compressed) {
 			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 			em->block_start = bytenr;
@@ -3488,38 +3515,21 @@ again:
 		}
 		goto insert;
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
-		u64 page_start;
 		unsigned long ptr;
 		char *map;
 		size_t size;
 		size_t extent_offset;
 		size_t copy_size;
 
-		size = btrfs_file_extent_inline_len(leaf, item);
-		extent_end = (extent_start + size + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
-		if (start < extent_start || start >= extent_end) {
-			em->start = start;
-			if (start < extent_start) {
-				if (start + len <= extent_start)
-					goto not_found;
-				em->len = extent_end - extent_start;
-			} else {
-				em->len = len;
-			}
-			goto not_found_em;
-		}
 		em->block_start = EXTENT_MAP_INLINE;
-
 		if (!page || create) {
 			em->start = extent_start;
-			em->len = (size + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
+			em->len = extent_end - extent_start;
 			goto out;
 		}
 
-		page_start = page_offset(page) + pg_offset;
-		extent_offset = page_start - extent_start;
+		size = btrfs_file_extent_inline_len(leaf, item);
+		extent_offset = page_offset(page) + pg_offset - extent_start;
 		copy_size = min_t(u64, PAGE_CACHE_SIZE - pg_offset,
 				size - extent_offset);
 		em->start = extent_start + extent_offset;
@@ -3569,6 +3579,7 @@ not_found:
 	em->len = len;
 not_found_em:
 	em->block_start = EXTENT_MAP_HOLE;
+	set_bit(EXTENT_FLAG_VACANCY, &em->flags);
 insert:
 	btrfs_release_path(root, path);
 	if (em->start > start || extent_map_end(em) <= start) {

