From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 19/99] btrfs: lock_extent can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:52 -0500
Message-ID: <20111124004222.019406000@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 All of the callers of lock_extent call it with gfp_t == GFP_NOFS.

 This patch simplifies the call sites by calling clear_extent_bit with
 GFP_NOFS from lock_extent itself.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/compression.c      |    2 +-
 fs/btrfs/disk-io.c          |    2 +-
 fs/btrfs/extent_io.c        |   19 ++++++++++---------
 fs/btrfs/extent_io.h        |    4 ++--
 fs/btrfs/file.c             |    7 +++----
 fs/btrfs/free-space-cache.c |    2 +-
 fs/btrfs/inode.c            |   27 +++++++++++----------------
 fs/btrfs/ioctl.c            |    7 +++----
 fs/btrfs/relocation.c       |    8 ++++----
 9 files changed, 36 insertions(+), 42 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -497,7 +497,7 @@ static noinline int add_ra_bio_pages(str
 		 * sure they map to this compressed extent on disk.
 		 */
 		set_page_extent_mapped(page);
-		lock_extent(tree, last_offset, end, GFP_NOFS);
+		lock_extent(tree, last_offset, end);
 		read_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, last_offset,
 					   PAGE_CACHE_SIZE);
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -331,7 +331,7 @@ static int verify_parent_transid(struct
 		return 0;
 
 	lock_extent_bits(io_tree, eb->start, eb->start + eb->len - 1,
-			 0, &cached_state, GFP_NOFS);
+			 0, &cached_state);
 	if (extent_buffer_uptodate(io_tree, eb, cached_state) &&
 	    btrfs_header_generation(eb) == parent_transid) {
 		ret = 0;
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1239,15 +1239,16 @@ static void clear_extent_uptodate(struct
  * us if waiting is desired.
  */
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, struct extent_state **cached_state, gfp_t mask)
+		     int bits, struct extent_state **cached_state)
 {
 	int err;
 	u64 failed_start;
 	while (1) {
 		err = set_extent_bit_excl(tree, start, end,
 					  EXTENT_LOCKED | bits, EXTENT_LOCKED,
-					  &failed_start, cached_state, mask);
-		if (err == -EEXIST && (mask & __GFP_WAIT)) {
+					  &failed_start, cached_state,
+					  GFP_NOFS);
+		if (err == -EEXIST) {
 			wait_extent_bit(tree, failed_start, end, EXTENT_LOCKED);
 			start = failed_start;
 		} else {
@@ -1258,9 +1259,9 @@ int lock_extent_bits(struct extent_io_tr
 	return err;
 }
 
-int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
+int lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	return lock_extent_bits(tree, start, end, 0, NULL, mask);
+	return lock_extent_bits(tree, start, end, 0, NULL);
 }
 
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
@@ -1593,7 +1594,7 @@ again:
 
 	/* step three, lock the state bits for the whole range */
 	lock_extent_bits(tree, delalloc_start, delalloc_end,
-			 0, &cached_state, GFP_NOFS);
+			 0, &cached_state);
 
 	/* then test to make sure it is all still delalloc */
 	ret = test_range_bit(tree, delalloc_start, delalloc_end,
@@ -2584,7 +2585,7 @@ static int __extent_read_full_page(struc
 
 	end = page_end;
 	while (1) {
-		lock_extent(tree, start, end, GFP_NOFS);
+		lock_extent(tree, start, end);
 		ordered = btrfs_lookup_ordered_extent(inode, start);
 		if (!ordered)
 			break;
@@ -3287,7 +3288,7 @@ int extent_invalidatepage(struct extent_
 	if (start > end)
 		return 0;
 
-	lock_extent_bits(tree, start, end, 0, &cached_state, GFP_NOFS);
+	lock_extent_bits(tree, start, end, 0, &cached_state);
 	wait_on_page_writeback(page);
 	clear_extent_bit(tree, start, end,
 			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
@@ -3503,7 +3504,7 @@ int extent_fiemap(struct inode *inode, s
 	}
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
-			 &cached_state, GFP_NOFS);
+			 &cached_state);
 
 	em = get_extent_skip_holes(inode, start, last_for_get_extent,
 				   get_extent);
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -180,9 +180,9 @@ int try_release_extent_buffer(struct ext
 int try_release_extent_state(struct extent_map_tree *map,
 			     struct extent_io_tree *tree, struct page *page,
 			     gfp_t mask);
-int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
+int lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, struct extent_state **cached, gfp_t mask);
+		     int bits, struct extent_state **cached);
 void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int __must_check unlock_extent_cached_atomic(struct extent_io_tree *tree,
 					     u64 start, u64 end,
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1101,8 +1101,7 @@ again:
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
-				 start_pos, last_pos - 1, 0, &cached_state,
-				 GFP_NOFS);
+				 start_pos, last_pos - 1, 0, &cached_state);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    last_pos - 1);
 		if (ordered &&
@@ -1618,7 +1617,7 @@ static long btrfs_fallocate(struct file
 		 * transaction
 		 */
 		lock_extent_bits(&BTRFS_I(inode)->io_tree, alloc_start,
-				 locked_end, 0, &cached_state, GFP_NOFS);
+				 locked_end, 0, &cached_state);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    alloc_end - 1);
 		if (ordered &&
@@ -1730,7 +1729,7 @@ static int find_desired_extent(struct in
 		return -ENXIO;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, 0,
-			 &cached_state, GFP_NOFS);
+			 &cached_state);
 
 	/*
 	 * Delalloc is such a pain.  If we have a hole and we have pending
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -862,7 +862,7 @@ int __btrfs_write_out_cache(struct btrfs
 	io_ctl_prepare_pages(&io_ctl, inode, 0);
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
-			 0, &cached_state, GFP_NOFS);
+			 0, &cached_state);
 
 	/*
 	 * When searching for pinned extents, we need to start at our start
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -596,7 +596,7 @@ retry:
 
 			lock_extent(io_tree, async_extent->start,
 					 async_extent->start +
-					 async_extent->ram_size - 1, GFP_NOFS);
+					 async_extent->ram_size - 1);
 
 			/* allocate blocks */
 			ret = cow_file_range(inode, async_cow->locked_page,
@@ -624,8 +624,7 @@ retry:
 		}
 
 		lock_extent(io_tree, async_extent->start,
-			    async_extent->start + async_extent->ram_size - 1,
-			    GFP_NOFS);
+			    async_extent->start + async_extent->ram_size - 1);
 
 		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
@@ -1569,7 +1568,7 @@ again:
 	page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end, 0,
-			 &cached_state, GFP_NOFS);
+			 &cached_state);
 
 	/* already ordered? We're done */
 	if (PagePrivate2(page))
@@ -1751,7 +1750,7 @@ static int btrfs_finish_ordered_io(struc
 
 	lock_extent_bits(io_tree, ordered_extent->file_offset,
 			 ordered_extent->file_offset + ordered_extent->len - 1,
-			 0, &cached_state, GFP_NOFS);
+			 0, &cached_state);
 
 	if (nolock)
 		trans = btrfs_join_transaction_nolock(root);
@@ -3229,8 +3228,7 @@ again:
 	}
 	wait_on_page_writeback(page);
 
-	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
+	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state);
 	set_page_extent_mapped(page);
 
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
@@ -3299,7 +3297,7 @@ int btrfs_cont_expand(struct inode *inod
 		btrfs_wait_ordered_range(inode, hole_start,
 					 block_end - hole_start);
 		lock_extent_bits(io_tree, hole_start, block_end - 1, 0,
-				 &cached_state, GFP_NOFS);
+				 &cached_state);
 		ordered = btrfs_lookup_ordered_extent(inode, hole_start);
 		if (!ordered)
 			break;
@@ -5646,7 +5644,7 @@ again:
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, ordered->file_offset,
 			 ordered->file_offset + ordered->len - 1, 0,
-			 &cached_state, GFP_NOFS);
+			 &cached_state);
 
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags)) {
 		ret = btrfs_mark_extent_written(trans, inode,
@@ -6061,7 +6059,7 @@ static ssize_t btrfs_direct_IO(int rw, s
 
 	while (1) {
 		lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				 0, &cached_state, GFP_NOFS);
+				 0, &cached_state);
 		/*
 		 * We're concerned with the entire range that we're going to be
 		 * doing DIO to, so we need to make sure theres no ordered
@@ -6206,8 +6204,7 @@ static void btrfs_invalidatepage(struct
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
-	lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
+	lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
 	ordered = btrfs_lookup_ordered_extent(page->mapping->host,
 					   page_offset(page));
 	if (ordered) {
@@ -6229,8 +6226,7 @@ static void btrfs_invalidatepage(struct
 		}
 		btrfs_put_ordered_extent(ordered);
 		cached_state = NULL;
-		lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-				 GFP_NOFS);
+		lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
 	}
 	clear_extent_bit(tree, page_start, page_end,
 		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
@@ -6298,8 +6294,7 @@ again:
 	}
 	wait_on_page_writeback(page);
 
-	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
+	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state);
 	set_page_extent_mapped(page);
 
 	/*
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -788,7 +788,7 @@ static int should_defrag_range(struct in
 
 	if (!em) {
 		/* get the big lock and read metadata off disk */
-		lock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+		lock_extent(io_tree, start, start + len - 1);
 		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
 		unlock_extent(io_tree, start, start + len - 1);
 
@@ -913,8 +913,7 @@ again:
 	page_end = page_offset(pages[i_done - 1]) + PAGE_CACHE_SIZE;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree,
-			 page_start, page_end - 1, 0, &cached_state,
-			 GFP_NOFS);
+			 page_start, page_end - 1, 0, &cached_state);
 	ordered = btrfs_lookup_first_ordered_extent(inode, page_end - 1);
 	if (ordered &&
 	    ordered->file_offset + ordered->len > page_start &&
@@ -2273,7 +2272,7 @@ static noinline long btrfs_ioctl_clone(s
 	   another, and lock file content */
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+		lock_extent(&BTRFS_I(src)->io_tree, off, off+len);
 		ordered = btrfs_lookup_first_ordered_extent(src, off+len);
 		if (!ordered &&
 		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off+len,
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1972,7 +1972,7 @@ static int invalidate_extent_cache(struc
 		}
 
 		/* the lock_extent waits for readpage to complete */
-		lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		lock_extent(&BTRFS_I(inode)->io_tree, start, end);
 		btrfs_drop_extent_cache(inode, start, end, 1);
 		unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 	}
@@ -2878,7 +2878,7 @@ int prealloc_file_extent_cluster(struct
 		else
 			end = cluster->end - offset;
 
-		lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		lock_extent(&BTRFS_I(inode)->io_tree, start, end);
 		num_bytes = end + 1 - start;
 		ret = btrfs_prealloc_file_range(inode, 0, start,
 						num_bytes, num_bytes,
@@ -2915,7 +2915,7 @@ int setup_extent_mapping(struct inode *i
 	em->bdev = root->fs_info->fs_devices->latest_bdev;
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
-	lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	lock_extent(&BTRFS_I(inode)->io_tree, start, end);
 	while (1) {
 		write_lock(&em_tree->lock);
 		ret = add_extent_mapping(em_tree, em);
@@ -3007,7 +3007,7 @@ static int relocate_file_extent_cluster(
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
 
 		lock_extent(&BTRFS_I(inode)->io_tree,
-			    page_start, page_end, GFP_NOFS);
+			    page_start, page_end);
 
 		set_page_extent_mapped(page);
 


