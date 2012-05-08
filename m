From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] Btrfs: use ALIGN macro instead of open-coded expression
Date: Tue,  8 May 2012 16:16:24 +0800
Message-ID: <1336464984-30746-1-git-send-email-yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
	Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

According to section 'Find open-coded helpers or macros' at
https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas, here
in the patch we use ALIGN macro to do the alignment.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 fs/btrfs/extent-tree.c |    4 ++--
 fs/btrfs/extent_io.c   |    9 ++++-----
 fs/btrfs/inode.c       |   15 +++++----------
 fs/btrfs/volumes.c     |    3 +--
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 49fd7b6..9161dca 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3280,7 +3280,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	int ret = 0, committed = 0, alloc_chunk = 1;
 
 	/* make sure bytes are sectorsize aligned */
-	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	bytes = ALIGN(bytes, root->sectorsize);
 
 	if (root == root->fs_info->tree_root ||
 	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID) {
@@ -3377,7 +3377,7 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	struct btrfs_space_info *data_sinfo;
 
 	/* make sure bytes are sectorsize aligned */
-	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	bytes = ALIGN(bytes, root->sectorsize);
 
 	data_sinfo = BTRFS_I(inode)->space_info;
 	spin_lock(&data_sinfo->lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c9018a0..b1bc411 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2653,7 +2653,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
 		cur_end = min(extent_map_end(em) - 1, end);
-		iosize = (iosize + blocksize - 1) & ~((u64)blocksize - 1);
+		iosize = ALIGN(iosize, blocksize);
 		if (this_bio_flag & EXTENT_BIO_COMPRESSED) {
 			disk_io_size = em->block_len;
 			sector = em->block_start >> 9;
@@ -2950,7 +2950,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		BUG_ON(extent_map_end(em) <= cur);
 		BUG_ON(end < cur);
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
-		iosize = (iosize + blocksize - 1) & ~((u64)blocksize - 1);
+		iosize = ALIGN(iosize, blocksize);
 		sector = (em->block_start + extent_offset) >> 9;
 		bdev = em->bdev;
 		block_start = em->block_start;
@@ -3580,7 +3580,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
 
-	start += (offset + blocksize - 1) & ~(blocksize - 1);
+	start += ALIGN(offset, blocksize);
 	if (start > end)
 		return 0;
 
@@ -3688,7 +3688,6 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 						u64 last,
 						get_extent_t *get_extent)
 {
-	u64 sectorsize = BTRFS_I(inode)->root->sectorsize;
 	struct extent_map *em;
 	u64 len;
 
@@ -3699,7 +3698,7 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 		len = last - offset;
 		if (len == 0)
 			break;
-		len = (len + sectorsize - 1) & ~(sectorsize - 1);
+		len = ALIGN(len, BTRFS_I(inode)->root->sectorsize);
 		em = get_extent(inode, NULL, 0, offset, len, 0);
 		if (IS_ERR_OR_NULL(em))
 			return em;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61b16c6..af5d6a9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -228,8 +228,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 	u64 isize = i_size_read(inode);
 	u64 actual_end = min(end + 1, isize);
 	u64 inline_len = actual_end - start;
-	u64 aligned_end = (end + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
+	u64 aligned_end = ALIGN(end, root->sectorsize);
 	u64 hint_byte;
 	u64 data_len = inline_len;
 	int ret;
@@ -483,15 +482,13 @@ cont:
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
@@ -5194,8 +5191,7 @@ again:
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
 		size = btrfs_file_extent_inline_len(leaf, item);
-		extent_end = (extent_start + size + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
+		extent_end = ALIGN(extent_start + size, root->sectorsize);
 	}
 
 	if (start >= extent_end) {
@@ -5265,8 +5261,7 @@ again:
 		copy_size = min_t(u64, PAGE_CACHE_SIZE - pg_offset,
 				size - extent_offset);
 		em->start = extent_start + extent_offset;
-		em->len = (copy_size + root->sectorsize - 1) &
-			~((u64)root->sectorsize - 1);
+		em->len = ALIGN(copy_size, root->sectorsize);
 		em->orig_start = EXTENT_MAP_INLINE;
 		if (compress_type) {
 			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1411b99..e09aab3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3761,8 +3761,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
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
1.7.7.6
