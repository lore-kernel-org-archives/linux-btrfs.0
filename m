Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab3BZIKC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 03:10:02 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dave@jikos.cz>
Subject: [PATCH] btrfs: cleanup for open-coded alignment
Date: Tue, 26 Feb 2013 16:10:22 +0800
Message-Id: <1361866222-5746-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Though most of the btrfs codes are using ALIGN macro for page alignment,
there are still some codes using open-coded alignment like the
following:
------
        u64 mask = ((u64)root->stripesize - 1);
        u64 ret = (val + mask) & ~mask;
------
Or even hidden one:
------
        num_bytes = (end - start + blocksize) & ~(blocksize - 1);
------

Sometimes these open-coded alignment is not so easy to understand for
newbie like me.

This commit changes the open-coded alignment to the ALIGN macro for a
better readability.

Also there is a previous patch from David Sterba with similar changes,
but the patch is for 3.2 kernel and seems not merged.
http://www.spinics.net/lists/linux-btrfs/msg12747.html

Cc: David Sterba <dave@jikos.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  7 +++----
 fs/btrfs/extent_io.c   |  8 ++++----
 fs/btrfs/file.c        |  3 +--
 fs/btrfs/inode.c       | 37 +++++++++++++++----------------------
 fs/btrfs/tree-log.c    |  3 +--
 fs/btrfs/volumes.c     |  3 +--
 6 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 61da9d0..6af2ef6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3357,7 +3357,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	int ret = 0, committed = 0, alloc_chunk = 1;
 
 	/* make sure bytes are sectorsize aligned */
-	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	bytes = ALIGN(bytes, root->sectorsize);
 
 	if (root == root->fs_info->tree_root ||
 	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID) {
@@ -3452,7 +3452,7 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	struct btrfs_space_info *data_sinfo;
 
 	/* make sure bytes are sectorsize aligned */
-	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	bytes = ALIGN(bytes, root->sectorsize);
 
 	data_sinfo = root->fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
@@ -5455,8 +5455,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 static u64 stripe_align(struct btrfs_root *root, u64 val)
 {
-	u64 mask = ((u64)root->stripesize - 1);
-	u64 ret = (val + mask) & ~mask;
+	u64 ret = ALIGN(val, root->stripesize);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1b319df..17fa84b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2682,7 +2682,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
 		cur_end = min(extent_map_end(em) - 1, end);
-		iosize = (iosize + blocksize - 1) & ~((u64)blocksize - 1);
+		iosize = ALIGN(iosize, blocksize);
 		if (this_bio_flag & EXTENT_BIO_COMPRESSED) {
 			disk_io_size = em->block_len;
 			sector = em->block_start >> 9;
@@ -2982,7 +2982,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		BUG_ON(extent_map_end(em) <= cur);
 		BUG_ON(end < cur);
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
-		iosize = (iosize + blocksize - 1) & ~((u64)blocksize - 1);
+		iosize = ALIGN(iosize, blocksize);
 		sector = (em->block_start + extent_offset) >> 9;
 		bdev = em->bdev;
 		block_start = em->block_start;
@@ -3678,7 +3678,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
 
-	start += (offset + blocksize - 1) & ~(blocksize - 1);
+	start += ALIGN(offset, blocksize);
 	if (start > end)
 		return 0;
 
@@ -3797,7 +3797,7 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 		len = last - offset;
 		if (len == 0)
 			break;
-		len = (len + sectorsize - 1) & ~(sectorsize - 1);
+		len = ALIGN(len, sectorsize);
 		em = get_extent(inode, NULL, 0, offset, len, 0);
 		if (IS_ERR_OR_NULL(em))
 			return em;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b06d289..81d6271 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -505,8 +505,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	loff_t isize = i_size_read(inode);
 
 	start_pos = pos & ~((u64)root->sectorsize - 1);
-	num_bytes = (write_bytes + pos - start_pos +
-		    root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	num_bytes = ALIGN(write_bytes + pos - start_pos, root->sectorsize);
 
 	end_of_last_block = start_pos + num_bytes - 1;
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca7ace7..bde8f08 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -231,8 +231,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 	u64 isize = i_size_read(inode);
 	u64 actual_end = min(end + 1, isize);
 	u64 inline_len = actual_end - start;
-	u64 aligned_end = (end + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
+	u64 aligned_end = ALIGN(end, root->sectorsize);
 	u64 data_len = inline_len;
 	int ret;
 
@@ -389,7 +388,7 @@ again:
 	 * a compressed extent to 128k.
 	 */
 	total_compressed = min(total_compressed, max_uncompressed);
-	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
+	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	total_in = 0;
 	ret = 0;
@@ -488,15 +487,13 @@ cont:
 		 * up to a block size boundary so the allocator does sane
 		 * things
 		 */
-		total_compressed = (total_compressed + blocksize - 1) &
-			~(blocksize - 1);
+		total_compressed = ALIGN(total_compressed, blocksize);
 
 		/*
 		 * one last check to make sure the compression is really a
 		 * win, compare the page count read with the blocks on disk
 		 */
-		total_in = (total_in + PAGE_CACHE_SIZE - 1) &
-			~(PAGE_CACHE_SIZE - 1);
+		total_in = ALIGN(total_in, PAGE_CACHE_SIZE);
 		if (total_compressed >= total_in) {
 			will_compress = 0;
 		} else {
@@ -834,7 +831,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 
 	BUG_ON(btrfs_is_free_space_inode(inode));
 
-	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
+	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	disk_num_bytes = num_bytes;
 
@@ -3304,7 +3301,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 extent_num_bytes = 0;
 	u64 extent_offset = 0;
 	u64 item_end = 0;
-	u64 mask = root->sectorsize - 1;
 	u32 found_type = (u8)-1;
 	int found_extent;
 	int del_item;
@@ -3328,7 +3324,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 * extent just the way it is.
 	 */
 	if (root->ref_cows || root == root->fs_info->tree_root)
-		btrfs_drop_extent_cache(inode, (new_size + mask) & (~mask), (u64)-1, 0);
+		btrfs_drop_extent_cache(inode, ALIGN(new_size,
+					root->sectorsize), (u64)-1, 0);
 
 	/*
 	 * This function is also used to drop the items in the log tree before
@@ -3407,10 +3404,9 @@ search_again:
 			if (!del_item) {
 				u64 orig_num_bytes =
 					btrfs_file_extent_num_bytes(leaf, fi);
-				extent_num_bytes = new_size -
-					found_key.offset + root->sectorsize - 1;
-				extent_num_bytes = extent_num_bytes &
-					~((u64)root->sectorsize - 1);
+				extent_num_bytes = ALIGN(new_size -
+						found_key.offset,
+						root->sectorsize);
 				btrfs_set_file_extent_num_bytes(leaf, fi,
 							 extent_num_bytes);
 				num_dec = (orig_num_bytes -
@@ -3646,9 +3642,8 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	u64 mask = root->sectorsize - 1;
-	u64 hole_start = (oldsize + mask) & ~mask;
-	u64 block_end = (size + mask) & ~mask;
+	u64 hole_start = ALIGN(oldsize, root->sectorsize);
+	u64 block_end = ALIGN(size, root->sectorsize);
 	u64 last_byte;
 	u64 cur_offset;
 	u64 hole_size;
@@ -3681,7 +3676,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			break;
 		}
 		last_byte = min(extent_map_end(em), block_end);
-		last_byte = (last_byte + mask) & ~mask;
+		last_byte = ALIGN(last_byte , root->sectorsize);
 		if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
 			struct extent_map *hole_em;
 			hole_size = last_byte - cur_offset;
@@ -5410,8 +5405,7 @@ again:
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
 		size = btrfs_file_extent_inline_len(leaf, item);
-		extent_end = (extent_start + size + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
+		extent_end = ALIGN(extent_start + size, root->sectorsize);
 	}
 
 	if (start >= extent_end) {
@@ -5483,8 +5477,7 @@ again:
 		copy_size = min_t(u64, PAGE_CACHE_SIZE - pg_offset,
 				size - extent_offset);
 		em->start = extent_start + extent_offset;
-		em->len = (copy_size + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
+		em->len = ALIGN(copy_size, root->sectorsize);
 		em->orig_block_len = em->len;
 		em->orig_start = em->start;
 		if (compress_type) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9027bb1..7a8a6f1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -485,7 +485,6 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				      struct btrfs_key *key)
 {
 	int found_type;
-	u64 mask = root->sectorsize - 1;
 	u64 extent_end;
 	u64 start = key->offset;
 	u64 saved_nbytes;
@@ -502,7 +501,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		extent_end = start + btrfs_file_extent_num_bytes(eb, item);
 	else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size = btrfs_file_extent_inline_len(eb, item);
-		extent_end = (start + size + mask) & ~mask;
+		extent_end = ALIGN(start + size, root->sectorsize);
 	} else {
 		ret = 0;
 		goto out;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5349e17..a0cc823 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4279,8 +4279,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	num_stripes = 1;
 	stripe_index = 0;
 	stripe_nr_orig = stripe_nr;
-	stripe_nr_end = (offset + *length + map->stripe_len - 1) &
-			(~(map->stripe_len - 1));
+	stripe_nr_end = ALIGN(offset + *length, map->stripe_len);
 	do_div(stripe_nr_end, map->stripe_len);
 	stripe_end_offset = stripe_nr_end * map->stripe_len -
 			    (offset + *length);
-- 
1.8.1.4

