From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 01/12] btrfs: rename variables clashing with global function names
Date: Fri, 22 Apr 2011 11:41:07 +0200
Message-ID: <2a63a84a5cca26ea0faeded6e873ae2518f1ca72.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

reported by gcc -Wshadow:
page_index, page_offset, new_inode, dev_name

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/compression.c |   42 +++++++++++++++++++++---------------------
 fs/btrfs/compression.h |    2 +-
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent_io.c   |   28 ++++++++++++++--------------
 fs/btrfs/extent_io.h   |    2 +-
 fs/btrfs/inode.c       |   24 ++++++++++++------------
 fs/btrfs/super.c       |    4 ++--
 8 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 41d1d7c..d4cd0f0 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -332,7 +332,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	struct compressed_bio *cb;
 	unsigned long bytes_left;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	int page_index = 0;
+	int pg_index = 0;
 	struct page *page;
 	u64 first_byte = disk_start;
 	struct block_device *bdev;
@@ -366,8 +366,8 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 	/* create and submit bios for the compressed pages */
 	bytes_left = compressed_len;
-	for (page_index = 0; page_index < cb->nr_pages; page_index++) {
-		page = compressed_pages[page_index];
+	for (pg_index = 0; pg_index < cb->nr_pages; pg_index++) {
+		page = compressed_pages[pg_index];
 		page->mapping = inode->i_mapping;
 		if (bio->bi_size)
 			ret = io_tree->ops->merge_bio_hook(page, 0,
@@ -432,7 +432,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 				     struct compressed_bio *cb)
 {
 	unsigned long end_index;
-	unsigned long page_index;
+	unsigned long pg_index;
 	u64 last_offset;
 	u64 isize = i_size_read(inode);
 	int ret;
@@ -456,13 +456,13 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	end_index = (i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT;
 
 	while (last_offset < compressed_end) {
-		page_index = last_offset >> PAGE_CACHE_SHIFT;
+		pg_index = last_offset >> PAGE_CACHE_SHIFT;
 
-		if (page_index > end_index)
+		if (pg_index > end_index)
 			break;
 
 		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->page_tree, page_index);
+		page = radix_tree_lookup(&mapping->page_tree, pg_index);
 		rcu_read_unlock();
 		if (page) {
 			misses++;
@@ -476,7 +476,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		if (!page)
 			break;
 
-		if (add_to_page_cache_lru(page, mapping, page_index,
+		if (add_to_page_cache_lru(page, mapping, pg_index,
 								GFP_NOFS)) {
 			page_cache_release(page);
 			goto next;
@@ -560,7 +560,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	unsigned long uncompressed_len = bio->bi_vcnt * PAGE_CACHE_SIZE;
 	unsigned long compressed_len;
 	unsigned long nr_pages;
-	unsigned long page_index;
+	unsigned long pg_index;
 	struct page *page;
 	struct block_device *bdev;
 	struct bio *comp_bio;
@@ -613,10 +613,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
-	for (page_index = 0; page_index < nr_pages; page_index++) {
-		cb->compressed_pages[page_index] = alloc_page(GFP_NOFS |
+	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
+		cb->compressed_pages[pg_index] = alloc_page(GFP_NOFS |
 							      __GFP_HIGHMEM);
-		if (!cb->compressed_pages[page_index])
+		if (!cb->compressed_pages[pg_index])
 			goto fail2;
 	}
 	cb->nr_pages = nr_pages;
@@ -634,8 +634,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	comp_bio->bi_end_io = end_compressed_bio_read;
 	atomic_inc(&cb->pending_bios);
 
-	for (page_index = 0; page_index < nr_pages; page_index++) {
-		page = cb->compressed_pages[page_index];
+	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
+		page = cb->compressed_pages[pg_index];
 		page->mapping = inode->i_mapping;
 		page->index = em_start >> PAGE_CACHE_SHIFT;
 
@@ -702,8 +702,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	return 0;
 
 fail2:
-	for (page_index = 0; page_index < nr_pages; page_index++)
-		free_page((unsigned long)cb->compressed_pages[page_index]);
+	for (pg_index = 0; pg_index < nr_pages; pg_index++)
+		free_page((unsigned long)cb->compressed_pages[pg_index]);
 
 	kfree(cb->compressed_pages);
 fail1:
@@ -945,7 +945,7 @@ void btrfs_exit_compress(void)
 int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 			      unsigned long total_out, u64 disk_start,
 			      struct bio_vec *bvec, int vcnt,
-			      unsigned long *page_index,
+			      unsigned long *pg_index,
 			      unsigned long *pg_offset)
 {
 	unsigned long buf_offset;
@@ -954,7 +954,7 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 	unsigned long working_bytes = total_out - buf_start;
 	unsigned long bytes;
 	char *kaddr;
-	struct page *page_out = bvec[*page_index].bv_page;
+	struct page *page_out = bvec[*pg_index].bv_page;
 
 	/*
 	 * start byte is the first byte of the page we're currently
@@ -995,11 +995,11 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 
 		/* check if we need to pick another page */
 		if (*pg_offset == PAGE_CACHE_SIZE) {
-			(*page_index)++;
-			if (*page_index >= vcnt)
+			(*pg_index)++;
+			if (*pg_index >= vcnt)
 				return 0;
 
-			page_out = bvec[*page_index].bv_page;
+			page_out = bvec[*pg_index].bv_page;
 			*pg_offset = 0;
 			start_byte = page_offset(page_out) - disk_start;
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 5100017..a12059f 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -37,7 +37,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 			      unsigned long total_out, u64 disk_start,
 			      struct bio_vec *bvec, int vcnt,
-			      unsigned long *page_index,
+			      unsigned long *pg_index,
 			      unsigned long *pg_offset);
 
 int btrfs_submit_compressed_write(struct inode *inode, u64 start,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2e61fe1..45d9678 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2534,7 +2534,7 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 int btrfs_commit_write(struct file *file, struct page *page,
 		       unsigned from, unsigned to);
 struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
-				    size_t page_offset, u64 start, u64 end,
+				    size_t pg_offset, u64 start, u64 end,
 				    int create);
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 68c84c8..8f07c86 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -137,7 +137,7 @@ static const char *btrfs_eb_name[BTRFS_MAX_LEVEL + 1] = {
  * that covers the entire device
  */
 static struct extent_map *btree_get_extent(struct inode *inode,
-		struct page *page, size_t page_offset, u64 start, u64 len,
+		struct page *page, size_t pg_offset, u64 start, u64 len,
 		int create)
 {
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3151386..5fc8f37 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2007,7 +2007,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	struct btrfs_ordered_extent *ordered;
 	int ret;
 	int nr = 0;
-	size_t page_offset = 0;
+	size_t pg_offset = 0;
 	size_t iosize;
 	size_t disk_io_size;
 	size_t blocksize = inode->i_sb->s_blocksize;
@@ -2043,9 +2043,9 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			char *userpage;
 			struct extent_state *cached = NULL;
 
-			iosize = PAGE_CACHE_SIZE - page_offset;
+			iosize = PAGE_CACHE_SIZE - pg_offset;
 			userpage = kmap_atomic(page, KM_USER0);
-			memset(userpage + page_offset, 0, iosize);
+			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage, KM_USER0);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
@@ -2054,7 +2054,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 					     &cached, GFP_NOFS);
 			break;
 		}
-		em = get_extent(inode, page, page_offset, cur,
+		em = get_extent(inode, page, pg_offset, cur,
 				end - cur + 1, 0);
 		if (IS_ERR(em) || !em) {
 			SetPageError(page);
@@ -2094,7 +2094,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			struct extent_state *cached = NULL;
 
 			userpage = kmap_atomic(page, KM_USER0);
-			memset(userpage + page_offset, 0, iosize);
+			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage, KM_USER0);
 
@@ -2103,7 +2103,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
 			                     &cached, GFP_NOFS);
 			cur = cur + iosize;
-			page_offset += iosize;
+			pg_offset += iosize;
 			continue;
 		}
 		/* the get_extent function already copied into the page */
@@ -2112,7 +2112,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			check_page_uptodate(tree, page);
 			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
 			cur = cur + iosize;
-			page_offset += iosize;
+			pg_offset += iosize;
 			continue;
 		}
 		/* we have an inline extent but it didn't get marked up
@@ -2122,7 +2122,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			SetPageError(page);
 			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
 			cur = cur + iosize;
-			page_offset += iosize;
+			pg_offset += iosize;
 			continue;
 		}
 
@@ -2135,7 +2135,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			unsigned long pnr = (last_byte >> PAGE_CACHE_SHIFT) + 1;
 			pnr -= page->index;
 			ret = submit_extent_page(READ, tree, page,
-					 sector, disk_io_size, page_offset,
+					 sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
@@ -2146,7 +2146,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		if (ret)
 			SetPageError(page);
 		cur = cur + iosize;
-		page_offset += iosize;
+		pg_offset += iosize;
 	}
 	if (!nr) {
 		if (!PageError(page))
@@ -2751,7 +2751,7 @@ int extent_prepare_write(struct extent_io_tree *tree,
 	u64 cur_end;
 	struct extent_map *em;
 	unsigned blocksize = 1 << inode->i_blkbits;
-	size_t page_offset = 0;
+	size_t pg_offset = 0;
 	size_t block_off_start;
 	size_t block_off_end;
 	int err = 0;
@@ -2767,7 +2767,7 @@ int extent_prepare_write(struct extent_io_tree *tree,
 
 	lock_extent(tree, page_start, page_end, GFP_NOFS);
 	while (block_start <= block_end) {
-		em = get_extent(inode, page, page_offset, block_start,
+		em = get_extent(inode, page, pg_offset, block_start,
 				block_end - block_start + 1, 1);
 		if (IS_ERR(em) || !em)
 			goto err;
@@ -2811,7 +2811,7 @@ int extent_prepare_write(struct extent_io_tree *tree,
 				       block_start + iosize - 1,
 				       EXTENT_LOCKED, 0, NULL, NULL, GFP_NOFS);
 			ret = submit_extent_page(READ, tree, page,
-					 sector, iosize, page_offset, em->bdev,
+					 sector, iosize, pg_offset, em->bdev,
 					 NULL, 1,
 					 end_bio_extent_preparewrite, 0,
 					 0, 0);
@@ -2828,7 +2828,7 @@ int extent_prepare_write(struct extent_io_tree *tree,
 					     &cached, GFP_NOFS);
 			block_start = cur_end + 1;
 		}
-		page_offset = block_start & (PAGE_CACHE_SIZE - 1);
+		pg_offset = block_start & (PAGE_CACHE_SIZE - 1);
 		free_extent_map(em);
 	}
 	if (iocount) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index af2d717..b9ce2f7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -164,7 +164,7 @@ static inline struct extent_state *extent_state_next(struct extent_state *state)
 
 typedef struct extent_map *(get_extent_t)(struct inode *inode,
 					  struct page *page,
-					  size_t page_offset,
+					  size_t pg_offset,
 					  u64 start, u64 len,
 					  int create);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fcd66b6..b9a98d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6980,7 +6980,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(old_dir)->root;
 	struct btrfs_root *dest = BTRFS_I(new_dir)->root;
-	struct inode *new_inode = new_dentry->d_inode;
+	struct inode *newinode = new_dentry->d_inode;
 	struct inode *old_inode = old_dentry->d_inode;
 	struct timespec ctime = CURRENT_TIME;
 	u64 index = 0;
@@ -6995,18 +6995,18 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -EXDEV;
 
 	if (old_inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
-	    (new_inode && new_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID))
+	    (newinode && newinode->i_ino == BTRFS_FIRST_FREE_OBJECTID))
 		return -ENOTEMPTY;
 
-	if (S_ISDIR(old_inode->i_mode) && new_inode &&
-	    new_inode->i_size > BTRFS_EMPTY_DIR_SIZE)
+	if (S_ISDIR(old_inode->i_mode) && newinode &&
+	    newinode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
 	/*
 	 * we're using rename to replace one file with another.
 	 * and the replacement file is large.  Start IO on it now so
 	 * we don't add too much work to the end of the transaction
 	 */
-	if (new_inode && S_ISREG(old_inode->i_mode) && new_inode->i_size &&
+	if (newinode && S_ISREG(old_inode->i_mode) && newinode->i_size &&
 	    old_inode->i_size > BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT)
 		filemap_flush(old_inode->i_mapping);
 
@@ -7060,7 +7060,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * make sure the inode gets flushed if it is replacing
 	 * something.
 	 */
-	if (new_inode && new_inode->i_size &&
+	if (newinode && newinode->i_size &&
 	    old_inode && S_ISREG(old_inode->i_mode)) {
 		btrfs_add_ordered_operation(trans, root, old_inode);
 	}
@@ -7087,16 +7087,16 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 	BUG_ON(ret);
 
-	if (new_inode) {
-		new_inode->i_ctime = CURRENT_TIME;
-		if (unlikely(new_inode->i_ino ==
+	if (newinode) {
+		newinode->i_ctime = CURRENT_TIME;
+		if (unlikely(newinode->i_ino ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-			root_objectid = BTRFS_I(new_inode)->location.objectid;
+			root_objectid = BTRFS_I(newinode)->location.objectid;
 			ret = btrfs_unlink_subvol(trans, dest, new_dir,
 						root_objectid,
 						new_dentry->d_name.name,
 						new_dentry->d_name.len);
-			BUG_ON(new_inode->i_nlink == 0);
+			BUG_ON(newinode->i_nlink == 0);
 		} else {
 			ret = btrfs_unlink_inode(trans, dest, new_dir,
 						 new_dentry->d_inode,
@@ -7104,7 +7104,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						 new_dentry->d_name.len);
 		}
 		BUG_ON(ret);
-		if (new_inode->i_nlink == 0) {
+		if (newinode->i_nlink == 0) {
 			ret = btrfs_orphan_add(trans, new_dentry->d_inode);
 			BUG_ON(ret);
 		}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0ac712e..3e285216 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -739,7 +739,7 @@ static int btrfs_set_super(struct super_block *s, void *data)
  *	  for multiple device setup.  Make sure to keep it in sync.
  */
 static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
-		const char *dev_name, void *data)
+		const char *device_name, void *data)
 {
 	struct block_device *bdev = NULL;
 	struct super_block *s;
@@ -762,7 +762,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	if (error)
 		return ERR_PTR(error);
 
-	error = btrfs_scan_one_device(dev_name, mode, fs_type, &fs_devices);
+	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
 	if (error)
 		goto error_free_subvol_name;
 
-- 
1.7.5.rc3

