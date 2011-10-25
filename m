From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 06/66] btrfs: lock_extent error push-up
Date: Mon, 24 Oct 2011 21:02:42 -0400
Message-ID: <20111025010851.251420296@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 lock_extent, try_lock_extent, and lock_extent_bits can't currently fail
 because errors are caught via BUG_ON.

 This patch pushes the error handling up to callers, which currently
 only handle them via BUG_ON themselves.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/compression.c      |    3 +-
 fs/btrfs/disk-io.c          |    5 ++-
 fs/btrfs/extent_io.c        |   20 ++++++++-----
 fs/btrfs/extent_io.h        |    8 +++--
 fs/btrfs/file.c             |   17 ++++++-----
 fs/btrfs/free-space-cache.c |    6 ++--
 fs/btrfs/inode.c            |   66 ++++++++++++++++++++++++++------------------
 fs/btrfs/ioctl.c            |   16 ++++++----
 fs/btrfs/relocation.c       |   18 ++++++++----
 9 files changed, 99 insertions(+), 60 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -496,7 +496,8 @@ static noinline int add_ra_bio_pages(str
 		 * sure they map to this compressed extent on disk.
 		 */
 		set_page_extent_mapped(page);
-		lock_extent(tree, last_offset, end, GFP_NOFS);
+		ret = lock_extent(tree, last_offset, end, GFP_NOFS);
+		BUG_ON(ret < 0);
 		read_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, last_offset,
 					   PAGE_CACHE_SIZE);
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -331,8 +331,9 @@ static int verify_parent_transid(struct
 	if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
 		return 0;
 
-	lock_extent_bits(io_tree, eb->start, eb->start + eb->len - 1,
-			 0, &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(io_tree, eb->start, eb->start + eb->len - 1,
+			       0, &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 	if (extent_buffer_uptodate(io_tree, eb, cached_state) &&
 	    btrfs_header_generation(eb) == parent_transid) {
 		ret = 0;
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1200,7 +1200,6 @@ int lock_extent_bits(struct extent_io_tr
 		}
 		WARN_ON(start > end);
 	}
-	BUG_ON(err < 0);
 	return err;
 }
 
@@ -1222,8 +1221,8 @@ int try_lock_extent(struct extent_io_tre
 			clear_extent_bit(tree, start, failed_start - 1,
 					 EXTENT_LOCKED, 1, 0, NULL, mask);
 		return 0;
-	}
-	BUG_ON(err < 0);
+	} else if (err < 0)
+		return err;
 	return 1;
 }
 
@@ -1534,8 +1533,9 @@ again:
 	BUG_ON(ret);
 
 	/* step three, lock the state bits for the whole range */
-	lock_extent_bits(tree, delalloc_start, delalloc_end,
-			 0, &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(tree, delalloc_start, delalloc_end,
+			       0, &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	/* then test to make sure it is all still delalloc */
 	ret = test_range_bit(tree, delalloc_start, delalloc_end,
@@ -2164,7 +2164,8 @@ static int __extent_read_full_page(struc
 
 	end = page_end;
 	while (1) {
-		lock_extent(tree, start, end, GFP_NOFS);
+		ret = lock_extent(tree, start, end, GFP_NOFS);
+		BUG_ON(ret < 0);
 		ordered = btrfs_lookup_ordered_extent(inode, start);
 		if (!ordered)
 			break;
@@ -2854,12 +2855,14 @@ int extent_invalidatepage(struct extent_
 	u64 start = ((u64)page->index << PAGE_CACHE_SHIFT);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
+	int ret;
 
 	start += (offset + blocksize - 1) & ~(blocksize - 1);
 	if (start > end)
 		return 0;
 
-	lock_extent_bits(tree, start, end, 0, &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(tree, start, end, 0, &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 	wait_on_page_writeback(page);
 	clear_extent_bit(tree, start, end,
 			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
@@ -3069,8 +3072,9 @@ int extent_fiemap(struct inode *inode, s
 		last_for_get_extent = isize;
 	}
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
+	ret = lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
 			 &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	em = get_extent_skip_holes(inode, off, last_for_get_extent,
 				   get_extent);
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -177,14 +177,16 @@ int try_release_extent_buffer(struct ext
 int try_release_extent_state(struct extent_map_tree *map,
 			     struct extent_io_tree *tree, struct page *page,
 			     gfp_t mask);
-int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
+int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
+		__must_check;
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, struct extent_state **cached, gfp_t mask);
+		     int bits, struct extent_state **cached, gfp_t mask)
+		     __must_check;
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask);
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
-		    gfp_t mask);
+		    gfp_t mask) __must_check;
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent);
 int __init extent_io_init(void);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1104,9 +1104,10 @@ again:
 	err = 0;
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent_bits(&BTRFS_I(inode)->io_tree,
-				 start_pos, last_pos - 1, 0, &cached_state,
-				 GFP_NOFS);
+		err = lock_extent_bits(&BTRFS_I(inode)->io_tree,
+				       start_pos, last_pos - 1, 0,
+				       &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    last_pos - 1);
 		if (ordered &&
@@ -1623,8 +1624,9 @@ static long btrfs_fallocate(struct file
 		/* the extent lock is ordered inside the running
 		 * transaction
 		 */
-		lock_extent_bits(&BTRFS_I(inode)->io_tree, alloc_start,
-				 locked_end, 0, &cached_state, GFP_NOFS);
+		ret = lock_extent_bits(&BTRFS_I(inode)->io_tree, alloc_start,
+				       locked_end, 0, &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    alloc_end - 1);
 		if (ordered &&
@@ -1735,8 +1737,9 @@ static int find_desired_extent(struct in
 	if (inode->i_size == 0)
 		return -ENXIO;
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, 0,
-			 &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, 0,
+			       &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	/*
 	 * Delalloc is such a pain.  If we have a hole and we have pending
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -850,8 +850,10 @@ int __btrfs_write_out_cache(struct btrfs
 	/* Lock all pages first so we can lock the extent safely. */
 	io_ctl_prepare_pages(&io_ctl, inode, 0);
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
-			 0, &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(&BTRFS_I(inode)->io_tree, 0,
+			       i_size_read(inode) - 1, 0, &cached_state,
+			       GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	/*
 	 * When searching for pinned extents, we need to start at our start
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -588,9 +588,11 @@ retry:
 			int page_started = 0;
 			unsigned long nr_written = 0;
 
-			lock_extent(io_tree, async_extent->start,
-					 async_extent->start +
-					 async_extent->ram_size - 1, GFP_NOFS);
+			ret = lock_extent(io_tree, async_extent->start,
+					  async_extent->start +
+					  async_extent->ram_size - 1,
+					  GFP_NOFS);
+			BUG_ON(ret < 0);
 
 			/* allocate blocks */
 			ret = cow_file_range(inode, async_cow->locked_page,
@@ -617,9 +619,10 @@ retry:
 			continue;
 		}
 
-		lock_extent(io_tree, async_extent->start,
-			    async_extent->start + async_extent->ram_size - 1,
-			    GFP_NOFS);
+		ret = lock_extent(io_tree, async_extent->start,
+				  async_extent->start +
+				  async_extent->ram_size - 1, GFP_NOFS);
+		BUG_ON(ret < 0);
 
 		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
@@ -1563,8 +1566,9 @@ again:
 	page_start = page_offset(page);
 	page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end, 0,
-			 &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
+			       0, &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	/* already ordered? We're done */
 	if (PagePrivate2(page))
@@ -1746,9 +1750,11 @@ static int btrfs_finish_ordered_io(struc
 		goto out;
 	}
 
-	lock_extent_bits(io_tree, ordered_extent->file_offset,
-			 ordered_extent->file_offset + ordered_extent->len - 1,
-			 0, &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(io_tree, ordered_extent->file_offset,
+			       ordered_extent->file_offset +
+			       ordered_extent->len - 1,
+			       0, &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	if (nolock)
 		trans = btrfs_join_transaction_nolock(root);
@@ -3343,8 +3349,9 @@ again:
 	}
 	wait_on_page_writeback(page);
 
-	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
+	ret = lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
+			       GFP_NOFS);
+	BUG_ON(ret < 0);
 	set_page_extent_mapped(page);
 
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
@@ -3419,8 +3426,9 @@ int btrfs_cont_expand(struct inode *inod
 		struct btrfs_ordered_extent *ordered;
 		btrfs_wait_ordered_range(inode, hole_start,
 					 block_end - hole_start);
-		lock_extent_bits(io_tree, hole_start, block_end - 1, 0,
-				 &cached_state, GFP_NOFS);
+		err = lock_extent_bits(io_tree, hole_start, block_end - 1, 0,
+				       &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 		ordered = btrfs_lookup_ordered_extent(inode, hole_start);
 		if (!ordered)
 			break;
@@ -5779,9 +5787,10 @@ again:
 		goto out;
 	}
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, ordered->file_offset,
-			 ordered->file_offset + ordered->len - 1, 0,
-			 &cached_state, GFP_NOFS);
+	ret = lock_extent_bits(&BTRFS_I(inode)->io_tree, ordered->file_offset,
+			       ordered->file_offset + ordered->len - 1, 0,
+			       &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags)) {
 		ret = btrfs_mark_extent_written(trans, inode,
@@ -6195,8 +6204,9 @@ static ssize_t btrfs_direct_IO(int rw, s
 	}
 
 	while (1) {
-		lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				 0, &cached_state, GFP_NOFS);
+		ret = lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart,
+				       lockend, 0, &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		/*
 		 * We're concerned with the entire range that we're going to be
 		 * doing DIO to, so we need to make sure theres no ordered
@@ -6335,6 +6345,7 @@ static void btrfs_invalidatepage(struct
 	struct extent_state *cached_state = NULL;
 	u64 page_start = page_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
+	int ret;
 
 
 	/*
@@ -6351,8 +6362,9 @@ static void btrfs_invalidatepage(struct
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
-	lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
+	ret = lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
+			       GFP_NOFS);
+	BUG_ON(ret < 0);
 	ordered = btrfs_lookup_ordered_extent(page->mapping->host,
 					   page_offset(page));
 	if (ordered) {
@@ -6374,8 +6386,9 @@ static void btrfs_invalidatepage(struct
 		}
 		btrfs_put_ordered_extent(ordered);
 		cached_state = NULL;
-		lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-				 GFP_NOFS);
+		ret = lock_extent_bits(tree, page_start, page_end,
+				       0, &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 	clear_extent_bit(tree, page_start, page_end,
 		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
@@ -6443,8 +6456,9 @@ again:
 	}
 	wait_on_page_writeback(page);
 
-	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
+	ret = lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state,
+			       GFP_NOFS);
+	BUG_ON(ret < 0);
 	set_page_extent_mapped(page);
 
 	/*
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -762,7 +762,7 @@ static int should_defrag_range(struct in
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	int ret = 1;
+	int ret = 1, err;
 
 	/*
 	 * make sure that once we start defragging and extent, we keep on
@@ -783,7 +783,8 @@ static int should_defrag_range(struct in
 
 	if (!em) {
 		/* get the big lock and read metadata off disk */
-		lock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+		err = lock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+		BUG_ON(err < 0);
 		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
 		unlock_extent(io_tree, start, start + len - 1, GFP_NOFS);
 
@@ -908,9 +909,10 @@ again:
 	page_start = page_offset(pages[0]);
 	page_end = page_offset(pages[i_done - 1]) + PAGE_CACHE_SIZE;
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree,
-			 page_start, page_end - 1, 0, &cached_state,
-			 GFP_NOFS);
+	ret = lock_extent_bits(&BTRFS_I(inode)->io_tree,
+			       page_start, page_end - 1, 0, &cached_state,
+			       GFP_NOFS);
+	BUG_ON(ret < 0);
 	ordered = btrfs_lookup_first_ordered_extent(inode, page_end - 1);
 	if (ordered &&
 	    ordered->file_offset + ordered->len > page_start &&
@@ -2246,7 +2248,9 @@ static noinline long btrfs_ioctl_clone(s
 	   another, and lock file content */
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+		ret = lock_extent(&BTRFS_I(src)->io_tree, off, off+len,
+				  GFP_NOFS);
+		BUG_ON(ret < 0);
 		ordered = btrfs_lookup_first_ordered_extent(src, off+len);
 		if (!ordered &&
 		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off+len,
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1596,6 +1596,7 @@ int replace_file_extents(struct btrfs_tr
 				ret = try_lock_extent(&BTRFS_I(inode)->io_tree,
 						      key.offset, end,
 						      GFP_NOFS);
+				BUG_ON(ret < 0);
 				if (!ret)
 					continue;
 
@@ -1918,6 +1919,7 @@ static int invalidate_extent_cache(struc
 	u64 objectid;
 	u64 start, end;
 	u64 ino;
+	int ret;
 
 	objectid = min_key->objectid;
 	while (1) {
@@ -1971,7 +1973,9 @@ static int invalidate_extent_cache(struc
 		}
 
 		/* the lock_extent waits for readpage to complete */
-		lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		ret = lock_extent(&BTRFS_I(inode)->io_tree, start, end,
+				  GFP_NOFS);
+		BUG_ON(ret < 0);
 		btrfs_drop_extent_cache(inode, start, end, 1);
 		unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
 	}
@@ -2882,7 +2886,9 @@ int prealloc_file_extent_cluster(struct
 		else
 			end = cluster->end - offset;
 
-		lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		ret = lock_extent(&BTRFS_I(inode)->io_tree, start,
+				  end, GFP_NOFS);
+		BUG_ON(ret < 0);
 		num_bytes = end + 1 - start;
 		ret = btrfs_prealloc_file_range(inode, 0, start,
 						num_bytes, num_bytes,
@@ -2919,7 +2925,8 @@ int setup_extent_mapping(struct inode *i
 	em->bdev = root->fs_info->fs_devices->latest_bdev;
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
-	lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	ret = lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	BUG_ON(ret < 0);
 	while (1) {
 		write_lock(&em_tree->lock);
 		ret = add_extent_mapping(em_tree, em);
@@ -3010,8 +3017,9 @@ static int relocate_file_extent_cluster(
 		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
 
-		lock_extent(&BTRFS_I(inode)->io_tree,
-			    page_start, page_end, GFP_NOFS);
+		ret = lock_extent(&BTRFS_I(inode)->io_tree,
+				  page_start, page_end, GFP_NOFS);
+		BUG_ON(ret < 0);
 
 		set_page_extent_mapped(page);
 


