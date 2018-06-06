Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932134AbeFFHlx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 03:41:53 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35C34AF0B
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 07:41:52 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Get rid of the confusing btrfs_file_extent_inline_len()
Date: Wed,  6 Jun 2018 15:41:49 +0800
Message-Id: <20180606074149.5020-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We used to call btrfs_file_extent_inline_len() to get the uncompressed
data size of an inlined extent.

However this function is hiding evil, for compressed extent, it has no
choice but to directly read out ram_bytes from btrfs_file_extent_item.
While for uncompressed extent, it uses item size to calculate the real
data size, and ignoring ram_bytes at all.

In fact, for corrupted ram_bytes, due to above behavior kernel
btrfs_print_leaf() can't even print correct ram_bytes to expose the bug.

Since we have tree-checker to verify all EXTENT_DATA, such mismatch can
be detected pretty easily, thus we can trust ram_bytes without the evil
btrfs_file_extent_inline_len().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h             | 26 --------------------------
 fs/btrfs/file-item.c         |  2 +-
 fs/btrfs/file.c              |  3 +--
 fs/btrfs/inode.c             | 12 ++++++------
 fs/btrfs/print-tree.c        |  4 ++--
 fs/btrfs/send.c              | 17 +++++++----------
 fs/btrfs/tree-log.c          | 12 ++++--------
 include/trace/events/btrfs.h |  2 +-
 8 files changed, 22 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2771cc56a622..70ff1a5b28f6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2427,32 +2427,6 @@ static inline u32 btrfs_file_extent_inline_item_len(
 	return btrfs_item_size(eb, e) - BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
-/* this returns the number of file bytes represented by the inline item.
- * If an item is compressed, this is the uncompressed size
- */
-static inline u32 btrfs_file_extent_inline_len(const struct extent_buffer *eb,
-					int slot,
-					const struct btrfs_file_extent_item *fi)
-{
-	struct btrfs_map_token token;
-
-	btrfs_init_map_token(&token);
-	/*
-	 * return the space used on disk if this item isn't
-	 * compressed or encoded
-	 */
-	if (btrfs_token_file_extent_compression(eb, fi, &token) == 0 &&
-	    btrfs_token_file_extent_encryption(eb, fi, &token) == 0 &&
-	    btrfs_token_file_extent_other_encoding(eb, fi, &token) == 0) {
-		return btrfs_file_extent_inline_item_len(eb,
-							 btrfs_item_nr(slot));
-	}
-
-	/* otherwise use the ram bytes field */
-	return btrfs_token_file_extent_ram_bytes(eb, fi, &token);
-}
-
-
 /* btrfs_dev_stats_item */
 static inline u64 btrfs_dev_stats_value(const struct extent_buffer *eb,
 					const struct btrfs_dev_stats_item *ptr,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index f9dd6d1836a3..8c3cd7072caf 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -942,7 +942,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			btrfs_file_extent_num_bytes(leaf, fi);
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
-		size = btrfs_file_extent_inline_len(leaf, slot, fi);
+		size = btrfs_file_extent_ram_bytes(leaf, fi);
 		extent_end = ALIGN(extent_start + size,
 				   fs_info->sectorsize);
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f660ba1e5e58..38557cba812c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -833,8 +833,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				btrfs_file_extent_num_bytes(leaf, fi);
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = key.offset +
-				btrfs_file_extent_inline_len(leaf,
-						     path->slots[0], fi);
+				btrfs_file_extent_ram_bytes(leaf, fi);
 		} else {
 			/* can't happen */
 			BUG();
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..32b59cf2fb3a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1437,8 +1437,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			nocow = 1;
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = found_key.offset +
-				btrfs_file_extent_inline_len(leaf,
-						     path->slots[0], fi);
+				btrfs_file_extent_ram_bytes(leaf, fi);
 			extent_end = ALIGN(extent_end,
 					   fs_info->sectorsize);
 		} else {
@@ -4543,8 +4542,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 					BTRFS_I(inode), leaf, fi,
 					found_key.offset);
 			} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-				item_end += btrfs_file_extent_inline_len(leaf,
-							 path->slots[0], fi);
+				item_end += btrfs_file_extent_ram_bytes(leaf,
+									fi);
 
 				trace_btrfs_truncate_show_fi_inline(
 					BTRFS_I(inode), leaf, fi, path->slots[0],
@@ -6979,7 +6978,8 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 						       extent_start);
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
-		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
+
+		size = btrfs_file_extent_ram_bytes(leaf, item);
 		extent_end = ALIGN(extent_start + size,
 				   fs_info->sectorsize);
 
@@ -7030,7 +7030,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		if (new_inline)
 			goto out;
 
-		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
+		size = btrfs_file_extent_ram_bytes(leaf, item);
 		extent_offset = page_offset(page) + pg_offset - extent_start;
 		copy_size = min_t(u64, PAGE_SIZE - pg_offset,
 				  size - extent_offset);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 21a831d3d087..29c9f2514fad 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -247,8 +247,8 @@ void btrfs_print_leaf(struct extent_buffer *l)
 					    struct btrfs_file_extent_item);
 			if (btrfs_file_extent_type(l, fi) ==
 			    BTRFS_FILE_EXTENT_INLINE) {
-				pr_info("\t\tinline extent data size %u\n",
-				       btrfs_file_extent_inline_len(l, i, fi));
+				pr_info("\t\tinline extent data size %llu\n",
+				       btrfs_file_extent_ram_bytes(l, fi));
 				break;
 			}
 			pr_info("\t\textent data disk bytenr %llu nr %llu\n",
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c0074d2d7d6d..3164ae207473 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1499,7 +1499,7 @@ static int read_symlink(struct btrfs_root *root,
 	BUG_ON(compression);
 
 	off = btrfs_file_extent_inline_start(ei);
-	len = btrfs_file_extent_inline_len(path->nodes[0], path->slots[0], ei);
+	len = btrfs_file_extent_ram_bytes(path->nodes[0], ei);
 
 	ret = fs_path_add_from_extent_buffer(dest, path->nodes[0], off, len);
 
@@ -5148,7 +5148,7 @@ static int clone_range(struct send_ctx *sctx,
 		ei = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 		type = btrfs_file_extent_type(leaf, ei);
 		if (type == BTRFS_FILE_EXTENT_INLINE) {
-			ext_len = btrfs_file_extent_inline_len(leaf, slot, ei);
+			ext_len = btrfs_file_extent_ram_bytes(leaf, ei);
 			ext_len = PAGE_ALIGN(ext_len);
 		} else {
 			ext_len = btrfs_file_extent_num_bytes(leaf, ei);
@@ -5224,8 +5224,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 			struct btrfs_file_extent_item);
 	type = btrfs_file_extent_type(path->nodes[0], ei);
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
-		len = btrfs_file_extent_inline_len(path->nodes[0],
-						   path->slots[0], ei);
+		len = btrfs_file_extent_ram_bytes(path->nodes[0], ei);
 		/*
 		 * it is possible the inline item won't cover the whole page,
 		 * but there may be items after this page.  Make
@@ -5363,7 +5362,7 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 		}
 
 		if (right_type == BTRFS_FILE_EXTENT_INLINE) {
-			right_len = btrfs_file_extent_inline_len(eb, slot, ei);
+			right_len = btrfs_file_extent_ram_bytes(eb, ei);
 			right_len = PAGE_ALIGN(right_len);
 		} else {
 			right_len = btrfs_file_extent_num_bytes(eb, ei);
@@ -5484,8 +5483,7 @@ static int get_last_extent(struct send_ctx *sctx, u64 offset)
 			    struct btrfs_file_extent_item);
 	type = btrfs_file_extent_type(path->nodes[0], fi);
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
-		u64 size = btrfs_file_extent_inline_len(path->nodes[0],
-							path->slots[0], fi);
+		u64 size = btrfs_file_extent_ram_bytes(path->nodes[0], fi);
 		extent_end = ALIGN(key.offset + size,
 				   sctx->send_root->fs_info->sectorsize);
 	} else {
@@ -5548,7 +5546,7 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 		if (btrfs_file_extent_type(leaf, fi) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			u64 size = btrfs_file_extent_inline_len(leaf, slot, fi);
+			u64 size = btrfs_file_extent_ram_bytes(leaf, fi);
 
 			extent_end = ALIGN(key.offset + size,
 					   root->fs_info->sectorsize);
@@ -5594,8 +5592,7 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 			    struct btrfs_file_extent_item);
 	type = btrfs_file_extent_type(path->nodes[0], fi);
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
-		u64 size = btrfs_file_extent_inline_len(path->nodes[0],
-							path->slots[0], fi);
+		u64 size = btrfs_file_extent_ram_bytes(path->nodes[0], fi);
 		extent_end = ALIGN(key->offset + size,
 				   sctx->send_root->fs_info->sectorsize);
 	} else {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 43758e30aa7a..a5a5916bc1d3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -600,7 +600,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		if (btrfs_file_extent_disk_bytenr(eb, item) == 0)
 			nbytes = 0;
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
-		size = btrfs_file_extent_inline_len(eb, slot, item);
+		size = btrfs_file_extent_ram_bytes(eb, item);
 		nbytes = btrfs_file_extent_ram_bytes(eb, item);
 		extent_end = ALIGN(start + size,
 				   fs_info->sectorsize);
@@ -3941,9 +3941,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 					struct btrfs_file_extent_item);
 		if (btrfs_file_extent_type(src, extent) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_inline_len(src,
-							   src_path->slots[0],
-							   extent);
+			len = btrfs_file_extent_ram_bytes(src, extent);
 			*last_extent = ALIGN(key.offset + len,
 					     fs_info->sectorsize);
 		} else {
@@ -4008,7 +4006,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		extent = btrfs_item_ptr(src, i, struct btrfs_file_extent_item);
 		if (btrfs_file_extent_type(src, extent) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_inline_len(src, i, extent);
+			len = btrfs_file_extent_ram_bytes(src, extent);
 			extent_end = ALIGN(key.offset + len,
 					   fs_info->sectorsize);
 		} else {
@@ -4629,9 +4627,7 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 
 		if (btrfs_file_extent_type(leaf, extent) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_inline_len(leaf,
-							   path->slots[0],
-							   extent);
+			len = btrfs_file_extent_ram_bytes(leaf, extent);
 			ASSERT(len == i_size ||
 			       (len == fs_info->sectorsize &&
 				btrfs_file_extent_compression(leaf, extent) !=
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 965c650a5273..8012f975ae13 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -372,7 +372,7 @@ DECLARE_EVENT_CLASS(
 		__entry->extent_type	= btrfs_file_extent_type(l, fi);
 		__entry->compression	= btrfs_file_extent_compression(l, fi);
 		__entry->extent_start	= start;
-		__entry->extent_end	= (start + btrfs_file_extent_inline_len(l, slot, fi));
+		__entry->extent_end	= (start + btrfs_file_extent_ram_bytes(l, fi));
 	),
 
 	TP_printk_btrfs(
-- 
2.17.1

