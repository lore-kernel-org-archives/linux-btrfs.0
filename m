Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35231 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752419AbdKXEKS (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 23 Nov 2017 23:10:18 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs: extent-tree: Use round up to replace align macro
Date: Fri, 24 Nov 2017 12:10:08 +0800
Message-Id: <20171124041008.32656-3-wqu@suse.com>
In-Reply-To: <20171124041008.32656-1-wqu@suse.com>
References: <20171124041008.32656-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To save reader seconds before checking if it's rounding up or down.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c  | 10 +++++-----
 fs/btrfs/extent_io.c    |  8 ++++----
 fs/btrfs/file-item.c    |  4 ++--
 fs/btrfs/file.c         |  6 +++---
 fs/btrfs/inode-map.c    |  4 ++--
 fs/btrfs/inode.c        | 38 +++++++++++++++++++-------------------
 fs/btrfs/ioctl.c        | 12 ++++++------
 fs/btrfs/ordered-data.c |  2 +-
 fs/btrfs/send.c         | 12 ++++++------
 fs/btrfs/tree-log.c     | 14 +++++++-------
 10 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 84868f29a666..66a4370c37f9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2064,7 +2064,7 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 {
 	int j, ret = 0;
 	u64 bytes_left, end;
-	u64 aligned_start = ALIGN(start, BI_SECTOR_SIZE);
+	u64 aligned_start = round_up(start, BI_SECTOR_SIZE);
 
 	if (WARN_ON(start != aligned_start)) {
 		len -= aligned_start - start;
@@ -4290,7 +4290,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 	int have_pinned_space;
 
 	/* make sure bytes are sectorsize aligned */
-	bytes = ALIGN(bytes, fs_info->sectorsize);
+	bytes = round_up(bytes, fs_info->sectorsize);
 
 	if (btrfs_is_free_space_inode(inode)) {
 		need_commit = 0;
@@ -6089,7 +6089,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	if (delalloc_lock)
 		mutex_lock(&inode->delalloc_mutex);
 
-	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
+	num_bytes = round_up(num_bytes, fs_info->sectorsize);
 
 	spin_lock(&inode->lock);
 	nr_extents = count_max_extents(num_bytes);
@@ -6219,7 +6219,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	u64 to_free = 0;
 	unsigned dropped;
 
-	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
+	num_bytes = round_up(num_bytes, fs_info->sectorsize);
 	spin_lock(&inode->lock);
 	dropped = drop_outstanding_extent(inode, num_bytes);
 
@@ -7875,7 +7875,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			goto loop;
 		}
 checks:
-		search_start = ALIGN(offset, fs_info->stripesize);
+		search_start = round_up(offset, fs_info->stripesize);
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5cf8be481a88..209f011863f4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2965,7 +2965,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
 		cur_end = min(extent_map_end(em) - 1, end);
-		iosize = ALIGN(iosize, blocksize);
+		iosize = round_up(iosize, blocksize);
 		if (this_bio_flag & EXTENT_BIO_COMPRESSED) {
 			disk_io_size = em->block_len;
 			sector = to_sector(em->block_start);
@@ -3388,7 +3388,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		BUG_ON(em_end <= cur);
 		BUG_ON(end < cur);
 		iosize = min(em_end - cur, end - cur + 1);
-		iosize = ALIGN(iosize, blocksize);
+		iosize = round_up(iosize, blocksize);
 		sector = to_sector(em->block_start + extent_offset);
 		bdev = em->bdev;
 		block_start = em->block_start;
@@ -4219,7 +4219,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 	u64 end = start + PAGE_SIZE - 1;
 	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
 
-	start += ALIGN(offset, blocksize);
+	start += round_up(offset, blocksize);
 	if (start > end)
 		return 0;
 
@@ -4336,7 +4336,7 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 		len = last - offset;
 		if (len == 0)
 			break;
-		len = ALIGN(len, sectorsize);
+		len = round_up(len, sectorsize);
 		em = get_extent(BTRFS_I(inode), NULL, 0, offset, len, 0);
 		if (IS_ERR_OR_NULL(em))
 			return em;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index df17cdced256..7a75ada7a96a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -956,8 +956,8 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
 		size = btrfs_file_extent_inline_len(leaf, slot, fi);
-		extent_end = ALIGN(extent_start + size,
-				   fs_info->sectorsize);
+		extent_end = round_up(extent_start + size,
+				      fs_info->sectorsize);
 	}
 
 	em->ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index aafcc785f840..d1b4ccab4094 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -937,8 +937,8 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			    extent_type == BTRFS_FILE_EXTENT_INLINE) {
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
-				extent_end = ALIGN(extent_end,
-						   fs_info->sectorsize);
+				extent_end = round_up(extent_end,
+						      fs_info->sectorsize);
 			} else if (update_refs && disk_bytenr > 0) {
 				ret = btrfs_free_extent(trans, fs_info,
 						disk_bytenr, num_bytes, 0,
@@ -2929,7 +2929,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 		}
 		last_byte = min(extent_map_end(em), alloc_end);
 		actual_end = min_t(u64, extent_map_end(em), offset + len);
-		last_byte = ALIGN(last_byte, blocksize);
+		last_byte = round_up(last_byte, blocksize);
 		if (em->block_start == EXTENT_MAP_HOLE ||
 		    (cur_offset >= inode->i_size &&
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d02019747d00..9487e5c92cb2 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -313,7 +313,7 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 	 */
 	max_ino = info->bytes - 1;
 
-	max_bitmaps = ALIGN(max_ino, INODES_PER_BITMAP) / INODES_PER_BITMAP;
+	max_bitmaps = round_up(max_ino, INODES_PER_BITMAP) / INODES_PER_BITMAP;
 	if (max_bitmaps <= ctl->total_bitmaps) {
 		ctl->extents_thresh = 0;
 		return;
@@ -486,7 +486,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 
 	spin_lock(&ctl->tree_lock);
 	prealloc = sizeof(struct btrfs_free_space) * ctl->free_extents;
-	prealloc = ALIGN(prealloc, PAGE_SIZE);
+	prealloc = round_up(prealloc, PAGE_SIZE);
 	prealloc += ctl->total_bitmaps * PAGE_SIZE;
 	spin_unlock(&ctl->tree_lock);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a8eb49e2c10..0704b393ea63 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -287,7 +287,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	u64 isize = i_size_read(inode);
 	u64 actual_end = min(end + 1, isize);
 	u64 inline_len = actual_end - start;
-	u64 aligned_end = ALIGN(end, fs_info->sectorsize);
+	u64 aligned_end = round_up(end, fs_info->sectorsize);
 	u64 data_len = inline_len;
 	int ret;
 	struct btrfs_path *path;
@@ -508,7 +508,7 @@ static noinline void compress_file_range(struct inode *inode,
 
 	total_compressed = min_t(unsigned long, total_compressed,
 			BTRFS_MAX_UNCOMPRESSED);
-	num_bytes = ALIGN(end - start + 1, blocksize);
+	num_bytes = round_up(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	total_in = 0;
 	ret = 0;
@@ -616,14 +616,14 @@ static noinline void compress_file_range(struct inode *inode,
 		 * up to a block size boundary so the allocator does sane
 		 * things
 		 */
-		total_compressed = ALIGN(total_compressed, blocksize);
+		total_compressed = round_up(total_compressed, blocksize);
 
 		/*
 		 * one last check to make sure the compression is really a
 		 * win, compare the page count read with the blocks on disk,
 		 * compression must free at least one sector size
 		 */
-		total_in = ALIGN(total_in, PAGE_SIZE);
+		total_in = round_up(total_in, PAGE_SIZE);
 		if (total_compressed + blocksize <= total_in) {
 			num_bytes = total_in;
 			*num_added += 1;
@@ -971,7 +971,7 @@ static noinline int cow_file_range(struct inode *inode,
 		goto out_unlock;
 	}
 
-	num_bytes = ALIGN(end - start + 1, blocksize);
+	num_bytes = round_up(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	disk_num_bytes = num_bytes;
 
@@ -1423,8 +1423,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			extent_end = found_key.offset +
 				btrfs_file_extent_inline_len(leaf,
 						     path->slots[0], fi);
-			extent_end = ALIGN(extent_end,
-					   fs_info->sectorsize);
+			extent_end = round_up(extent_end,
+					      fs_info->sectorsize);
 		} else {
 			BUG_ON(1);
 		}
@@ -4388,7 +4388,7 @@ static int truncate_inline_extent(struct inode *inode,
 
 	if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE) {
 		loff_t offset = new_size;
-		loff_t page_end = ALIGN(offset, PAGE_SIZE);
+		loff_t page_end = round_up(offset, PAGE_SIZE);
 
 		/*
 		 * Zero out the remaining of the last page of our inline extent,
@@ -4477,8 +4477,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 */
 	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
 	    root == fs_info->tree_root)
-		btrfs_drop_extent_cache(BTRFS_I(inode), ALIGN(new_size,
-					fs_info->sectorsize),
+		btrfs_drop_extent_cache(BTRFS_I(inode),
+					round_up(new_size, fs_info->sectorsize),
 					(u64)-1, 0);
 
 	/*
@@ -4584,7 +4584,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			if (!del_item) {
 				u64 orig_num_bytes =
 					btrfs_file_extent_num_bytes(leaf, fi);
-				extent_num_bytes = ALIGN(new_size -
+				extent_num_bytes = round_up(new_size -
 						found_key.offset,
 						fs_info->sectorsize);
 				btrfs_set_file_extent_num_bytes(leaf, fi,
@@ -4948,8 +4948,8 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	u64 hole_start = ALIGN(oldsize, fs_info->sectorsize);
-	u64 block_end = ALIGN(size, fs_info->sectorsize);
+	u64 hole_start = round_up(oldsize, fs_info->sectorsize);
+	u64 block_end = round_up(size, fs_info->sectorsize);
 	u64 last_byte;
 	u64 cur_offset;
 	u64 hole_size;
@@ -4992,7 +4992,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			break;
 		}
 		last_byte = min(extent_map_end(em), block_end);
-		last_byte = ALIGN(last_byte, fs_info->sectorsize);
+		last_byte = round_up(last_byte, fs_info->sectorsize);
 		if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
 			struct extent_map *hole_em;
 			hole_size = last_byte - cur_offset;
@@ -7070,8 +7070,8 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
 		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
-		extent_end = ALIGN(extent_start + size,
-				   fs_info->sectorsize);
+		extent_end = round_up(extent_start + size,
+				      fs_info->sectorsize);
 
 		trace_btrfs_get_extent_show_fi_inline(inode, leaf, item,
 						      path->slots[0],
@@ -7125,7 +7125,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		copy_size = min_t(u64, PAGE_SIZE - pg_offset,
 				  size - extent_offset);
 		em->start = extent_start + extent_offset;
-		em->len = ALIGN(copy_size, fs_info->sectorsize);
+		em->len = round_up(copy_size, fs_info->sectorsize);
 		em->orig_block_len = em->len;
 		em->orig_start = em->start;
 		ptr = btrfs_file_extent_inline_start(item) + extent_offset;
@@ -9697,8 +9697,8 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 	spin_lock(&BTRFS_I(inode)->lock);
 	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
-	stat->blocks = to_sector(ALIGN(inode_get_bytes(inode), blocksize) +
-				 ALIGN(delalloc_bytes, blocksize));
+	stat->blocks = to_sector(round_up(inode_get_bytes(inode), blocksize) +
+				 round_up(delalloc_bytes, blocksize));
 	return 0;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6c7a49faf4e0..1fdfe328f018 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3088,7 +3088,7 @@ static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
 
 	/* if we extend to eof, continue to block boundary */
 	if (off + len == inode->i_size)
-		*plen = len = ALIGN(inode->i_size, bs) - off;
+		*plen = len = round_up(inode->i_size, bs) - off;
 
 	/* Check that we are block aligned - btrfs_clone() requires this */
 	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs))
@@ -3375,8 +3375,8 @@ static int clone_copy_inline_extent(struct inode *dst,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(dst->i_sb);
 	struct btrfs_root *root = BTRFS_I(dst)->root;
-	const u64 aligned_end = ALIGN(new_key->offset + datal,
-				      fs_info->sectorsize);
+	const u64 aligned_end = round_up(new_key->offset + datal,
+					 fs_info->sectorsize);
 	int ret;
 	struct btrfs_key key;
 
@@ -3768,8 +3768,8 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
 
-			last_dest_end = ALIGN(new_key.offset + datal,
-					      fs_info->sectorsize);
+			last_dest_end = round_up(new_key.offset + datal,
+						 fs_info->sectorsize);
 			ret = clone_finish_inode_update(trans, inode,
 							last_dest_end,
 							destoff, olen,
@@ -3878,7 +3878,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 		olen = len = src->i_size - off;
 	/* if we extend to eof, continue to block boundary */
 	if (off + len == src->i_size)
-		len = ALIGN(src->i_size, bs) - off;
+		len = round_up(src->i_size, bs) - off;
 
 	if (len == 0) {
 		ret = 0;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a3aca495e33e..f02fd8c008e3 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -978,7 +978,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				     ordered->file_offset +
 				     ordered->truncated_len);
 	} else {
-		offset = ALIGN(offset, btrfs_inode_sectorsize(inode));
+		offset = round_up(offset, btrfs_inode_sectorsize(inode));
 	}
 	disk_i_size = BTRFS_I(inode)->disk_i_size;
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 8fd195cfe81b..4a8a13888c76 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5403,8 +5403,8 @@ static int get_last_extent(struct send_ctx *sctx, u64 offset)
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
 		u64 size = btrfs_file_extent_inline_len(path->nodes[0],
 							path->slots[0], fi);
-		extent_end = ALIGN(key.offset + size,
-				   sctx->send_root->fs_info->sectorsize);
+		extent_end = round_up(key.offset + size,
+				      sctx->send_root->fs_info->sectorsize);
 	} else {
 		extent_end = key.offset +
 			btrfs_file_extent_num_bytes(path->nodes[0], fi);
@@ -5467,8 +5467,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		    BTRFS_FILE_EXTENT_INLINE) {
 			u64 size = btrfs_file_extent_inline_len(leaf, slot, fi);
 
-			extent_end = ALIGN(key.offset + size,
-					   root->fs_info->sectorsize);
+			extent_end = round_up(key.offset + size,
+					      root->fs_info->sectorsize);
 		} else {
 			extent_end = key.offset +
 				btrfs_file_extent_num_bytes(leaf, fi);
@@ -5513,8 +5513,8 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
 		u64 size = btrfs_file_extent_inline_len(path->nodes[0],
 							path->slots[0], fi);
-		extent_end = ALIGN(key->offset + size,
-				   sctx->send_root->fs_info->sectorsize);
+		extent_end = round_up(key->offset + size,
+				      sctx->send_root->fs_info->sectorsize);
 	} else {
 		extent_end = key->offset +
 			btrfs_file_extent_num_bytes(path->nodes[0], fi);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c800d067fcbf..a0403f36ef44 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -613,8 +613,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size = btrfs_file_extent_inline_len(eb, slot, item);
 		nbytes = btrfs_file_extent_ram_bytes(eb, item);
-		extent_end = ALIGN(start + size,
-				   fs_info->sectorsize);
+		extent_end = round_up(start + size,
+				      fs_info->sectorsize);
 	} else {
 		ret = 0;
 		goto out;
@@ -3824,8 +3824,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			len = btrfs_file_extent_inline_len(src,
 							   src_path->slots[0],
 							   extent);
-			*last_extent = ALIGN(key.offset + len,
-					     fs_info->sectorsize);
+			*last_extent = round_up(key.offset + len,
+						fs_info->sectorsize);
 		} else {
 			len = btrfs_file_extent_num_bytes(src, extent);
 			*last_extent = key.offset + len;
@@ -3888,8 +3888,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		if (btrfs_file_extent_type(src, extent) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
 			len = btrfs_file_extent_inline_len(src, i, extent);
-			extent_end = ALIGN(key.offset + len,
-					   fs_info->sectorsize);
+			extent_end = round_up(key.offset + len,
+					      fs_info->sectorsize);
 		} else {
 			len = btrfs_file_extent_num_bytes(src, extent);
 			extent_end = key.offset + len;
@@ -4476,7 +4476,7 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 	if (hole_size == 0)
 		return 0;
 
-	hole_size = ALIGN(hole_size, fs_info->sectorsize);
+	hole_size = round_up(hole_size, fs_info->sectorsize);
 	ret = btrfs_insert_file_extent(trans, log, ino, hole_start, 0, 0,
 				       hole_size, 0, hole_size, 0, 0, 0);
 	return ret;
-- 
2.15.0

