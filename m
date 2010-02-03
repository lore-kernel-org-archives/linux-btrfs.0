From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: cache the extent state everywhere we possibly can V2
Date: Wed, 3 Feb 2010 14:33:23 -0500
Message-ID: <20100203193322.GB4395@localhost.localdomain>
References: <20100203190354.GA4395@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100203190354.GA4395@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

This patch just goes through and fixes everybody that does

lock_extent()
blah
unlock_extent()

to use

lock_extent_bits()
blah
unlock_extent_cached()

and pass around a extent_state so we only have to do the searches once per
function.  This gives me about a 3 mb/s boots on my random write test.  I have
not converted some things, like the relocation and ioctl's, since they aren't
heavily used and the relocation stuff is in the middle of being re-written.  I
also changed the clear_extent_bit() to only unset the cached state if we are
clearing EXTENT_LOCKED and related stuff, so we can do things like this

lock_extent_bits()
clear delalloc bits
unlock_extent_cached()

without losing our cached state.  I tested this thoroughly and turned on
LEAK_DEBUG to make sure we weren't leaking extent states, everything worked out
fine.

V2: fixed verify_parent_transid to use the cached state for
extent_buffer_uptodate and clear_extent_buffer_uptodate

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 +-
 fs/btrfs/disk-io.c     |   15 ++++---
 fs/btrfs/extent-tree.c |   11 +++--
 fs/btrfs/extent_io.c   |   61 ++++++++++++++++----------
 fs/btrfs/extent_io.h   |   10 +++-
 fs/btrfs/file.c        |   23 ++++++----
 fs/btrfs/inode.c       |  111 ++++++++++++++++++++++++++++++------------------
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/relocation.c  |    2 +-
 9 files changed, 148 insertions(+), 90 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bf04876..0f2db97 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2309,7 +2309,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
-int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end);
+int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
+			      struct extent_state **cached_state);
 int btrfs_writepages(struct address_space *mapping,
 		     struct writeback_control *wbc);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ce093f..94debaf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -263,13 +263,15 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 static int verify_parent_transid(struct extent_io_tree *io_tree,
 				 struct extent_buffer *eb, u64 parent_transid)
 {
+	struct extent_state *cached_state = NULL;
 	int ret;
 
 	if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
 		return 0;
 
-	lock_extent(io_tree, eb->start, eb->start + eb->len - 1, GFP_NOFS);
-	if (extent_buffer_uptodate(io_tree, eb) &&
+	lock_extent_bits(io_tree, eb->start, eb->start + eb->len - 1,
+			 0, &cached_state, GFP_NOFS);
+	if (extent_buffer_uptodate(io_tree, eb, cached_state) &&
 	    btrfs_header_generation(eb) == parent_transid) {
 		ret = 0;
 		goto out;
@@ -282,10 +284,10 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		       (unsigned long long)btrfs_header_generation(eb));
 	}
 	ret = 1;
-	clear_extent_buffer_uptodate(io_tree, eb);
+	clear_extent_buffer_uptodate(io_tree, eb, &cached_state);
 out:
-	unlock_extent(io_tree, eb->start, eb->start + eb->len - 1,
-		      GFP_NOFS);
+	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
+			     &cached_state, GFP_NOFS);
 	return ret;
 }
 
@@ -2436,7 +2438,8 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid)
 	int ret;
 	struct inode *btree_inode = buf->first_page->mapping->host;
 
-	ret = extent_buffer_uptodate(&BTRFS_I(btree_inode)->io_tree, buf);
+	ret = extent_buffer_uptodate(&BTRFS_I(btree_inode)->io_tree, buf,
+				     NULL);
 	if (!ret)
 		return ret;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a46d05c..12a2d23 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6558,6 +6558,7 @@ static noinline int invalidate_extent_cache(struct btrfs_root *root,
 	struct btrfs_key key;
 	struct inode *inode = NULL;
 	struct btrfs_file_extent_item *fi;
+	struct extent_state *cached_state = NULL;
 	u64 num_bytes;
 	u64 skip_objectid = 0;
 	u32 nritems;
@@ -6586,12 +6587,14 @@ static noinline int invalidate_extent_cache(struct btrfs_root *root,
 		}
 		num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
 
-		lock_extent(&BTRFS_I(inode)->io_tree, key.offset,
-			    key.offset + num_bytes - 1, GFP_NOFS);
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, key.offset,
+				 key.offset + num_bytes - 1, 0, &cached_state,
+				 GFP_NOFS);
 		btrfs_drop_extent_cache(inode, key.offset,
 					key.offset + num_bytes - 1, 1);
-		unlock_extent(&BTRFS_I(inode)->io_tree, key.offset,
-			      key.offset + num_bytes - 1, GFP_NOFS);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, key.offset,
+				     key.offset + num_bytes - 1, &cached_state,
+				     GFP_NOFS);
 		cond_resched();
 	}
 	iput(inode);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1376611..a392577 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -513,7 +513,10 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	u64 last_end;
 	int err;
 	int set = 0;
+	int clear = 0;
 
+	if (bits & (EXTENT_IOBITS | EXTENT_BOUNDARY))
+		clear = 1;
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
@@ -524,14 +527,20 @@ again:
 	spin_lock(&tree->lock);
 	if (cached_state) {
 		cached = *cached_state;
-		*cached_state = NULL;
-		cached_state = NULL;
+
+		if (clear) {
+			*cached_state = NULL;
+			cached_state = NULL;
+		}
+
 		if (cached && cached->tree && cached->start == start) {
-			atomic_dec(&cached->refs);
+			if (clear)
+				atomic_dec(&cached->refs);
 			state = cached;
 			goto hit_next;
 		}
-		free_extent_state(cached);
+		if (clear)
+			free_extent_state(cached);
 	}
 	/*
 	 * this search will find the extents that end after
@@ -946,11 +955,11 @@ int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
-		     gfp_t mask)
+			struct extent_state **cached_state, gfp_t mask)
 {
 	return set_extent_bit(tree, start, end,
 			      EXTENT_DELALLOC | EXTENT_DIRTY | EXTENT_UPTODATE,
-			      0, NULL, NULL, mask);
+			      0, NULL, cached_state, mask);
 }
 
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
@@ -984,10 +993,11 @@ int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
-				 u64 end, gfp_t mask)
+				 u64 end, struct extent_state **cached_state,
+				 gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
-				NULL, mask);
+				cached_state, mask);
 }
 
 int wait_on_extent_writeback(struct extent_io_tree *tree, u64 start, u64 end)
@@ -1727,7 +1737,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		}
 
 		if (!uptodate) {
-			clear_extent_uptodate(tree, start, end, GFP_NOFS);
+			clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
@@ -2709,6 +2719,7 @@ int extent_readpages(struct extent_io_tree *tree,
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset)
 {
+	struct extent_state *cached_state = NULL;
 	u64 start = ((u64)page->index << PAGE_CACHE_SHIFT);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
@@ -2717,12 +2728,12 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 	if (start > end)
 		return 0;
 
-	lock_extent(tree, start, end, GFP_NOFS);
+	lock_extent_bits(tree, start, end, 0, &cached_state, GFP_NOFS);
 	wait_on_page_writeback(page);
 	clear_extent_bit(tree, start, end,
 			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
 			 EXTENT_DO_ACCOUNTING,
-			 1, 1, NULL, GFP_NOFS);
+			 1, 1, &cached_state, GFP_NOFS);
 	return 0;
 }
 
@@ -2925,16 +2936,17 @@ sector_t extent_bmap(struct address_space *mapping, sector_t iblock,
 		get_extent_t *get_extent)
 {
 	struct inode *inode = mapping->host;
+	struct extent_state *cached_state = NULL;
 	u64 start = iblock << inode->i_blkbits;
 	sector_t sector = 0;
 	size_t blksize = (1 << inode->i_blkbits);
 	struct extent_map *em;
 
-	lock_extent(&BTRFS_I(inode)->io_tree, start, start + blksize - 1,
-		    GFP_NOFS);
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + blksize - 1,
+			 0, &cached_state, GFP_NOFS);
 	em = get_extent(inode, NULL, 0, start, blksize, 0);
-	unlock_extent(&BTRFS_I(inode)->io_tree, start, start + blksize - 1,
-		      GFP_NOFS);
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start,
+			     start + blksize - 1, &cached_state, GFP_NOFS);
 	if (!em || IS_ERR(em))
 		return 0;
 
@@ -2956,6 +2968,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	u32 flags = 0;
 	u64 disko = 0;
 	struct extent_map *em = NULL;
+	struct extent_state *cached_state = NULL;
 	int end = 0;
 	u64 em_start = 0, em_len = 0;
 	unsigned long emflags;
@@ -2964,8 +2977,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (len == 0)
 		return -EINVAL;
 
-	lock_extent(&BTRFS_I(inode)->io_tree, start, start + len,
-		GFP_NOFS);
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
+			 &cached_state, GFP_NOFS);
 	em = get_extent(inode, NULL, 0, off, max - off, 0);
 	if (!em)
 		goto out;
@@ -3028,8 +3041,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 out_free:
 	free_extent_map(em);
 out:
-	unlock_extent(&BTRFS_I(inode)->io_tree, start, start + len,
-			GFP_NOFS);
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len,
+			     &cached_state, GFP_NOFS);
 	return ret;
 }
 
@@ -3286,7 +3299,8 @@ int set_extent_buffer_dirty(struct extent_io_tree *tree,
 }
 
 int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
-				struct extent_buffer *eb)
+				struct extent_buffer *eb,
+				struct extent_state **cached_state)
 {
 	unsigned long i;
 	struct page *page;
@@ -3296,7 +3310,7 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 
 	clear_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
-			      GFP_NOFS);
+			      cached_state, GFP_NOFS);
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (page)
@@ -3356,7 +3370,8 @@ int extent_range_uptodate(struct extent_io_tree *tree,
 }
 
 int extent_buffer_uptodate(struct extent_io_tree *tree,
-			   struct extent_buffer *eb)
+			   struct extent_buffer *eb,
+			   struct extent_state *cached_state)
 {
 	int ret = 0;
 	unsigned long num_pages;
@@ -3368,7 +3383,7 @@ int extent_buffer_uptodate(struct extent_io_tree *tree,
 		return 1;
 
 	ret = test_range_bit(tree, eb->start, eb->start + eb->len - 1,
-			   EXTENT_UPTODATE, 1, NULL);
+			   EXTENT_UPTODATE, 1, cached_state);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c8c129b..981cde5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -164,6 +164,8 @@ int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		     int bits, struct extent_state **cached, gfp_t mask);
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
+int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
+			 struct extent_state **cached, gfp_t mask);
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 		    gfp_t mask);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
@@ -197,7 +199,7 @@ int clear_extent_ordered(struct extent_io_tree *tree, u64 start, u64 end,
 int clear_extent_ordered_metadata(struct extent_io_tree *tree, u64 start,
 				  u64 end, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
-		     gfp_t mask);
+			struct extent_state **cached_state, gfp_t mask);
 int set_extent_ordered(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
@@ -282,9 +284,11 @@ int test_extent_buffer_dirty(struct extent_io_tree *tree,
 int set_extent_buffer_uptodate(struct extent_io_tree *tree,
 			       struct extent_buffer *eb);
 int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
-				struct extent_buffer *eb);
+				struct extent_buffer *eb,
+				struct extent_state **cached_state);
 int extent_buffer_uptodate(struct extent_io_tree *tree,
-			   struct extent_buffer *eb);
+			   struct extent_buffer *eb,
+			   struct extent_state *cached_state);
 int map_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 		      unsigned long min_len, char **token, char **map,
 		      unsigned long *map_start,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ae96fda..c0c462f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -123,7 +123,8 @@ static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
 		    root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
 	end_of_last_block = start_pos + num_bytes - 1;
-	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block);
+	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
+					NULL);
 	if (err)
 		return err;
 
@@ -751,6 +752,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 			 loff_t pos, unsigned long first_index,
 			 unsigned long last_index, size_t write_bytes)
 {
+	struct extent_state *cached_state = NULL;
 	int i;
 	unsigned long index = pos >> PAGE_CACHE_SHIFT;
 	struct inode *inode = fdentry(file)->d_inode;
@@ -779,16 +781,18 @@ again:
 	}
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent(&BTRFS_I(inode)->io_tree,
-			    start_pos, last_pos - 1, GFP_NOFS);
+		lock_extent_bits(&BTRFS_I(inode)->io_tree,
+				 start_pos, last_pos - 1, 0, &cached_state,
+				 GFP_NOFS);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    last_pos - 1);
 		if (ordered &&
 		    ordered->file_offset + ordered->len > start_pos &&
 		    ordered->file_offset < last_pos) {
 			btrfs_put_ordered_extent(ordered);
-			unlock_extent(&BTRFS_I(inode)->io_tree,
-				      start_pos, last_pos - 1, GFP_NOFS);
+			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+					     start_pos, last_pos - 1,
+					     &cached_state, GFP_NOFS);
 			for (i = 0; i < num_pages; i++) {
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
@@ -800,12 +804,13 @@ again:
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 
-		clear_extent_bits(&BTRFS_I(inode)->io_tree, start_pos,
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
 				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-				  EXTENT_DO_ACCOUNTING,
+				  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
 				  GFP_NOFS);
-		unlock_extent(&BTRFS_I(inode)->io_tree,
-			      start_pos, last_pos - 1, GFP_NOFS);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+				     start_pos, last_pos - 1, &cached_state,
+				     GFP_NOFS);
 	}
 	for (i = 0; i < num_pages; i++) {
 		clear_page_dirty_for_io(pages[i]);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 26574d8..bc7e4d9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -569,8 +569,8 @@ retry:
 			unsigned long nr_written = 0;
 
 			lock_extent(io_tree, async_extent->start,
-				    async_extent->start +
-				    async_extent->ram_size - 1, GFP_NOFS);
+					 async_extent->start +
+					 async_extent->ram_size - 1, GFP_NOFS);
 
 			/* allocate blocks */
 			ret = cow_file_range(inode, async_cow->locked_page,
@@ -1506,12 +1506,13 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end)
+int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
+			      struct extent_state **cached_state)
 {
 	if ((end & (PAGE_CACHE_SIZE - 1)) == 0)
 		WARN_ON(1);
 	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				   GFP_NOFS);
+				   cached_state, GFP_NOFS);
 }
 
 /* see btrfs_writepage_start_hook for details on why this is required */
@@ -1524,6 +1525,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 {
 	struct btrfs_writepage_fixup *fixup;
 	struct btrfs_ordered_extent *ordered;
+	struct extent_state *cached_state = NULL;
 	struct page *page;
 	struct inode *inode;
 	u64 page_start;
@@ -1542,7 +1544,8 @@ again:
 	page_start = page_offset(page);
 	page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
 
-	lock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end, GFP_NOFS);
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end, 0,
+			 &cached_state, GFP_NOFS);
 
 	/* already ordered? We're done */
 	if (PagePrivate2(page))
@@ -1550,17 +1553,18 @@ again:
 
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
-		unlock_extent(&BTRFS_I(inode)->io_tree, page_start,
-			      page_end, GFP_NOFS);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
+				     page_end, &cached_state, GFP_NOFS);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		goto again;
 	}
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end);
+	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
 	ClearPageChecked(page);
 out:
-	unlock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end, GFP_NOFS);
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
+			     &cached_state, GFP_NOFS);
 out_page:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1689,6 +1693,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_state *cached_state = NULL;
 	int compressed = 0;
 	int ret;
 
@@ -1710,9 +1715,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		goto out;
 	}
 
-	lock_extent(io_tree, ordered_extent->file_offset,
-		    ordered_extent->file_offset + ordered_extent->len - 1,
-		    GFP_NOFS);
+	lock_extent_bits(io_tree, ordered_extent->file_offset,
+			 ordered_extent->file_offset + ordered_extent->len - 1,
+			 0, &cached_state, GFP_NOFS);
 
 	trans = btrfs_join_transaction(root, 1);
 
@@ -1739,9 +1744,10 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 				   ordered_extent->len);
 		BUG_ON(ret);
 	}
-	unlock_extent(io_tree, ordered_extent->file_offset,
-		    ordered_extent->file_offset + ordered_extent->len - 1,
-		    GFP_NOFS);
+	unlock_extent_cached(io_tree, ordered_extent->file_offset,
+			     ordered_extent->file_offset +
+			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
+
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
 
@@ -3078,6 +3084,7 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
+	struct extent_state *cached_state = NULL;
 	char *kaddr;
 	u32 blocksize = root->sectorsize;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
@@ -3124,12 +3131,14 @@ again:
 	}
 	wait_on_page_writeback(page);
 
-	lock_extent(io_tree, page_start, page_end, GFP_NOFS);
+	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
+			 GFP_NOFS);
 	set_page_extent_mapped(page);
 
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
-		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+		unlock_extent_cached(io_tree, page_start, page_end,
+				     &cached_state, GFP_NOFS);
 		unlock_page(page);
 		page_cache_release(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
@@ -3137,13 +3146,15 @@ again:
 		goto again;
 	}
 
-	clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
-			  GFP_NOFS);
+			  0, 0, &cached_state, GFP_NOFS);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+					&cached_state);
 	if (ret) {
-		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+		unlock_extent_cached(io_tree, page_start, page_end,
+				     &cached_state, GFP_NOFS);
 		goto out_unlock;
 	}
 
@@ -3156,7 +3167,8 @@ again:
 	}
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+	unlock_extent_cached(io_tree, page_start, page_end, &cached_state,
+			     GFP_NOFS);
 
 out_unlock:
 	if (ret)
@@ -3174,6 +3186,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em;
+	struct extent_state *cached_state = NULL;
 	u64 mask = root->sectorsize - 1;
 	u64 hole_start = (inode->i_size + mask) & ~mask;
 	u64 block_end = (size + mask) & ~mask;
@@ -3189,11 +3202,13 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 		struct btrfs_ordered_extent *ordered;
 		btrfs_wait_ordered_range(inode, hole_start,
 					 block_end - hole_start);
-		lock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
+		lock_extent_bits(io_tree, hole_start, block_end - 1, 0,
+				 &cached_state, GFP_NOFS);
 		ordered = btrfs_lookup_ordered_extent(inode, hole_start);
 		if (!ordered)
 			break;
-		unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
+		unlock_extent_cached(io_tree, hole_start, block_end - 1,
+				     &cached_state, GFP_NOFS);
 		btrfs_put_ordered_extent(ordered);
 	}
 
@@ -3238,7 +3253,8 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 			break;
 	}
 
-	unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
+	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state,
+			     GFP_NOFS);
 	return err;
 }
 
@@ -4973,6 +4989,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 {
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
+	struct extent_state *cached_state = NULL;
 	u64 page_start = page_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
 
@@ -4991,7 +5008,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
-	lock_extent(tree, page_start, page_end, GFP_NOFS);
+	lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
+			 GFP_NOFS);
 	ordered = btrfs_lookup_ordered_extent(page->mapping->host,
 					   page_offset(page));
 	if (ordered) {
@@ -5002,7 +5020,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
-				 NULL, GFP_NOFS);
+				 &cached_state, GFP_NOFS);
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
@@ -5012,11 +5030,13 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 						page_start, page_end);
 		}
 		btrfs_put_ordered_extent(ordered);
-		lock_extent(tree, page_start, page_end, GFP_NOFS);
+		cached_state = NULL;
+		lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
+				 GFP_NOFS);
 	}
 	clear_extent_bit(tree, page_start, page_end,
 		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, NULL, GFP_NOFS);
+		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
@@ -5049,6 +5069,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
+	struct extent_state *cached_state = NULL;
 	char *kaddr;
 	unsigned long zero_start;
 	loff_t size;
@@ -5087,7 +5108,8 @@ again:
 	}
 	wait_on_page_writeback(page);
 
-	lock_extent(io_tree, page_start, page_end, GFP_NOFS);
+	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
+			 GFP_NOFS);
 	set_page_extent_mapped(page);
 
 	/*
@@ -5096,7 +5118,8 @@ again:
 	 */
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
-		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+		unlock_extent_cached(io_tree, page_start, page_end,
+				     &cached_state, GFP_NOFS);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
@@ -5110,13 +5133,15 @@ again:
 	 * is probably a better way to do this, but for now keep consistent with
 	 * prepare_pages in the normal write path.
 	 */
-	clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
-			  GFP_NOFS);
+			  0, 0, &cached_state, GFP_NOFS);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+					&cached_state);
 	if (ret) {
-		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+		unlock_extent_cached(io_tree, page_start, page_end,
+				     &cached_state, GFP_NOFS);
 		ret = VM_FAULT_SIGBUS;
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
 		goto out_unlock;
@@ -5142,7 +5167,7 @@ again:
 	BTRFS_I(inode)->last_trans = root->fs_info->generation;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 
-	unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
 
 out_unlock:
 	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
@@ -5814,6 +5839,7 @@ stop_trans:
 static long btrfs_fallocate(struct inode *inode, int mode,
 			    loff_t offset, loff_t len)
 {
+	struct extent_state *cached_state = NULL;
 	u64 cur_offset;
 	u64 last_byte;
 	u64 alloc_start;
@@ -5852,16 +5878,17 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 		/* the extent lock is ordered inside the running
 		 * transaction
 		 */
-		lock_extent(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
-			    GFP_NOFS);
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, alloc_start,
+				 locked_end, 0, &cached_state, GFP_NOFS);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    alloc_end - 1);
 		if (ordered &&
 		    ordered->file_offset + ordered->len > alloc_start &&
 		    ordered->file_offset < alloc_end) {
 			btrfs_put_ordered_extent(ordered);
-			unlock_extent(&BTRFS_I(inode)->io_tree,
-				      alloc_start, locked_end, GFP_NOFS);
+			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+					     alloc_start, locked_end,
+					     &cached_state, GFP_NOFS);
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -5903,8 +5930,8 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 			break;
 		}
 	}
-	unlock_extent(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
-		      GFP_NOFS);
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
+			     &cached_state, GFP_NOFS);
 
 	btrfs_free_reserved_data_space(BTRFS_I(inode)->root, inode,
 				       alloc_end - alloc_start);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 645a179..31c6117 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -538,7 +538,7 @@ again:
 		 */
 		clear_page_dirty_for_io(page);
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end);
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
 		set_page_dirty(page);
 		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
 		unlock_page(page);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a7410fc..78f368e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2659,7 +2659,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 					EXTENT_BOUNDARY, GFP_NOFS);
 			nr++;
 		}
-		btrfs_set_extent_delalloc(inode, page_start, page_end);
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
 
 		set_page_dirty(page);
 		dirty_page++;
-- 
1.6.6

