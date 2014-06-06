Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43346 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaFFOgI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 10:36:08 -0400
Received: by mail-wi0-f172.google.com with SMTP id ho1so1097157wib.11
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 07:36:06 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: make fsync work after cloning into a file
Date: Fri,  6 Jun 2014 16:35:52 +0100
Message-Id: <1402068952-10018-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1402027551-9737-1-git-send-email-fdmanana@gmail.com>
References: <1402027551-9737-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When cloning into a file, we were correctly replacing the extent
items in the target range and removing the extent maps. However
we weren't replacing the extent maps with new ones that point to
the new extents - as a consequence, an incremental fsync (when the
inode doesn't have the full sync flag) was a NOOP, since it relies
on the existence of extent maps in the modified list of the inode's
extent map tree, which was empty. Therefore add new extent maps to
reflect the target clone range.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Factored out needed code from inode.c:btrfs_get_extent() into a
    separate function so that it can be reused by the cloning code,
    avoiding some duplicated and non-trivial logic when populating
    an extent map from a file extent item.

 fs/btrfs/ctree.h     |  5 ++++
 fs/btrfs/file-item.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/inode.c     | 41 +++----------------------------
 fs/btrfs/ioctl.c     | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 143 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index af523d6..a668fd9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3749,6 +3749,11 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
+void btrfs_extent_item_to_extent_map(struct inode *inode,
+				     const struct btrfs_path *path,
+				     struct btrfs_file_extent_item *fi,
+				     struct extent_map *em);
+
 /* inode.c */
 struct btrfs_delalloc_work {
 	struct inode *inode;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 609d56b..f8f2436 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -885,3 +885,71 @@ out:
 fail_unlock:
 	goto out;
 }
+
+void btrfs_extent_item_to_extent_map(struct inode *inode,
+				     const struct btrfs_path *path,
+				     struct btrfs_file_extent_item *fi,
+				     struct extent_map *em)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_buffer *leaf = path->nodes[0];
+	const int slot = path->slots[0];
+	struct btrfs_key key;
+	u64 extent_start, extent_end;
+	u64 bytenr;
+	u8 type = btrfs_file_extent_type(leaf, fi);
+
+	em->bdev = root->fs_info->fs_devices->latest_bdev;
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	extent_start = key.offset;
+
+	if (type == BTRFS_FILE_EXTENT_REG ||
+	    type == BTRFS_FILE_EXTENT_PREALLOC) {
+		extent_end = extent_start +
+			btrfs_file_extent_num_bytes(leaf, fi);
+	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
+		size_t size;
+		size = btrfs_file_extent_inline_len(leaf, slot, fi);
+		extent_end = ALIGN(extent_start + size, root->sectorsize);
+	}
+
+	em->ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+	em->compress_type = btrfs_file_extent_compression(leaf, fi);
+	if (em->compress_type != BTRFS_COMPRESS_NONE)
+		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+
+	if (type == BTRFS_FILE_EXTENT_REG ||
+	    type == BTRFS_FILE_EXTENT_PREALLOC) {
+		em->start = extent_start;
+		em->len = extent_end - extent_start;
+		em->orig_start = extent_start -
+			btrfs_file_extent_offset(leaf, fi);
+		em->orig_block_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		if (bytenr == 0) {
+			em->block_start = EXTENT_MAP_HOLE;
+			return;
+		}
+		if (em->compress_type != BTRFS_COMPRESS_NONE) {
+			em->block_start = bytenr;
+			em->block_len = em->orig_block_len;
+		} else {
+			bytenr += btrfs_file_extent_offset(leaf, fi);
+			em->block_start = bytenr;
+			em->block_len = em->len;
+			if (type == BTRFS_FILE_EXTENT_PREALLOC)
+				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
+		}
+	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
+		em->block_start = EXTENT_MAP_INLINE;
+		em->start = extent_start;
+		em->orig_start = EXTENT_MAP_HOLE;
+		em->len = extent_end - extent_start;
+		em->block_len = (u64)-1;
+	} else {
+		btrfs_err(root->fs_info,
+			  "unknown file extent item type %d, inode %llu, offset %llu, root %llu",
+			  type, btrfs_ino(inode), extent_start,
+			  root->root_key.objectid);
+	}
+}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 477e64a..7671cd9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6129,7 +6129,6 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 {
 	int ret;
 	int err = 0;
-	u64 bytenr;
 	u64 extent_start = 0;
 	u64 extent_end = 0;
 	u64 objectid = btrfs_ino(inode);
@@ -6143,7 +6142,6 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_trans_handle *trans = NULL;
-	int compress_type;
 
 again:
 	read_lock(&em_tree->lock);
@@ -6217,7 +6215,6 @@ again:
 
 	found_type = btrfs_file_extent_type(leaf, item);
 	extent_start = found_key.offset;
-	compress_type = btrfs_file_extent_compression(leaf, item);
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		extent_end = extent_start +
@@ -6252,32 +6249,10 @@ next:
 		goto not_found_em;
 	}
 
-	em->ram_bytes = btrfs_file_extent_ram_bytes(leaf, item);
+	btrfs_extent_item_to_extent_map(inode, path, item, em);
+
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
-		em->start = extent_start;
-		em->len = extent_end - extent_start;
-		em->orig_start = extent_start -
-				 btrfs_file_extent_offset(leaf, item);
-		em->orig_block_len = btrfs_file_extent_disk_num_bytes(leaf,
-								      item);
-		bytenr = btrfs_file_extent_disk_bytenr(leaf, item);
-		if (bytenr == 0) {
-			em->block_start = EXTENT_MAP_HOLE;
-			goto insert;
-		}
-		if (compress_type != BTRFS_COMPRESS_NONE) {
-			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
-			em->compress_type = compress_type;
-			em->block_start = bytenr;
-			em->block_len = em->orig_block_len;
-		} else {
-			bytenr += btrfs_file_extent_offset(leaf, item);
-			em->block_start = bytenr;
-			em->block_len = em->len;
-			if (found_type == BTRFS_FILE_EXTENT_PREALLOC)
-				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
-		}
 		goto insert;
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		unsigned long ptr;
@@ -6286,12 +6261,8 @@ next:
 		size_t extent_offset;
 		size_t copy_size;
 
-		em->block_start = EXTENT_MAP_INLINE;
-		if (!page || create) {
-			em->start = extent_start;
-			em->len = extent_end - extent_start;
+		if (!page || create)
 			goto out;
-		}
 
 		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
 		extent_offset = page_offset(page) + pg_offset - extent_start;
@@ -6301,10 +6272,6 @@ next:
 		em->len = ALIGN(copy_size, root->sectorsize);
 		em->orig_block_len = em->len;
 		em->orig_start = em->start;
-		if (compress_type) {
-			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
-			em->compress_type = compress_type;
-		}
 		ptr = btrfs_file_extent_inline_start(item) + extent_offset;
 		if (create == 0 && !PageUptodate(page)) {
 			if (btrfs_file_extent_compression(leaf, item) !=
@@ -6351,8 +6318,6 @@ next:
 		set_extent_uptodate(io_tree, em->start,
 				    extent_map_end(em) - 1, NULL, GFP_NOFS);
 		goto insert;
-	} else {
-		WARN(1, KERN_ERR "btrfs unknown found_type %d\n", found_type);
 	}
 not_found:
 	em->start = start;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 44dcfd0..04216b6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3043,6 +3043,57 @@ out:
 	return ret;
 }
 
+static void clone_update_extent_map(struct inode *inode,
+				    const struct btrfs_trans_handle *trans,
+				    const struct btrfs_path *path,
+				    const struct btrfs_key *key,
+				    struct btrfs_file_extent_item *fi,
+				    const u64 hole_offset,
+				    const u64 hole_len)
+{
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map *em;
+	int ret;
+
+	em = alloc_extent_map();
+	if (!em) {
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			&BTRFS_I(inode)->runtime_flags);
+		return;
+	}
+
+	if (fi) {
+		btrfs_extent_item_to_extent_map(inode, path, fi, em);
+		em->generation = -1;
+	} else {
+		em->start = hole_offset;
+		em->len = hole_len;
+		em->ram_bytes = em->len;
+		em->orig_start = hole_offset;
+		em->block_start = EXTENT_MAP_HOLE;
+		em->block_len = 0;
+		em->orig_block_len = 0;
+		em->compress_type = BTRFS_COMPRESS_NONE;
+		em->generation = trans->transid;
+	}
+
+	while (1) {
+		write_lock(&em_tree->lock);
+		ret = add_extent_mapping(em_tree, em, 1);
+		write_unlock(&em_tree->lock);
+		if (ret != -EEXIST) {
+			free_extent_map(em);
+			break;
+		}
+		btrfs_drop_extent_cache(inode, em->start,
+					em->start + em->len - 1, 0);
+	}
+
+	if (unlikely(ret))
+		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			&BTRFS_I(inode)->runtime_flags);
+}
+
 /**
  * btrfs_clone() - clone a range from inode file to another
  *
@@ -3361,8 +3412,19 @@ process_slot:
 					    btrfs_item_ptr_offset(leaf, slot),
 					    size);
 				inode_add_bytes(inode, datal);
+				extent = btrfs_item_ptr(leaf, slot,
+						struct btrfs_file_extent_item);
 			}
 
+			/* If we have an implicit hole (NO_HOLES feature). */
+			if (drop_start < new_key.offset)
+				clone_update_extent_map(inode, trans,
+						path, NULL, NULL, drop_start,
+						new_key.offset - drop_start);
+
+			clone_update_extent_map(inode, trans, path,
+						&new_key, extent, 0, 0);
+
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
 
@@ -3406,6 +3468,11 @@ process_slot:
 		}
 		ret = clone_finish_inode_update(trans, inode, destoff + len,
 						destoff, olen);
+		if (ret)
+			goto out;
+		clone_update_extent_map(inode, trans,
+					path, NULL, NULL, last_dest_end,
+					destoff + len - last_dest_end);
 	}
 
 out:
-- 
1.9.1

