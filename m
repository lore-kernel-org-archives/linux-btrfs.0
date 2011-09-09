From: jeffm@suse.com
Subject: [patch v3 06/23] btrfs: Push up unlock_extent errors to callers
Date: Thu, 08 Sep 2011 20:22:46 -0400
Message-ID: <20110909002730.830461543@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The previous patch pushed the clear_extent_bit error handling up a level,
 which included unlock_extent and unlock_extent_cache.

 This patch pushes the BUG_ON up into the callers of those functions.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/btrfs/compression.c      |    9 ++--
 fs/btrfs/disk-io.c          |    7 +--
 fs/btrfs/extent_io.c        |   52 +++++++++++++----------
 fs/btrfs/file.c             |   35 ++++++++-------
 fs/btrfs/free-space-cache.c |   15 ++++--
 fs/btrfs/inode.c            |   98 ++++++++++++++++++++++++++------------------
 fs/btrfs/ioctl.c            |   26 +++++++----
 fs/btrfs/relocation.c       |   24 +++++++---
 8 files changed, 160 insertions(+), 106 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -507,7 +507,8 @@ static noinline int add_ra_bio_pages(str
 		    (last_offset + PAGE_CACHE_SIZE > extent_map_end(em)) ||
 		    (em->block_start >> 9) != cb->orig_bio->bi_sector) {
 			free_extent_map(em);
-			unlock_extent(tree, last_offset, end, GFP_NOFS);
+			ret = unlock_extent(tree, last_offset, end, GFP_NOFS);
+			BUG_ON(ret < 0);
 			unlock_page(page);
 			page_cache_release(page);
 			break;
@@ -535,7 +536,8 @@ static noinline int add_ra_bio_pages(str
 			nr_pages++;
 			page_cache_release(page);
 		} else {
-			unlock_extent(tree, last_offset, end, GFP_NOFS);
+			ret = unlock_extent(tree, last_offset, end, GFP_NOFS);
+			BUG_ON(ret < 0);
 			unlock_page(page);
 			page_cache_release(page);
 			break;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -326,7 +326,7 @@ static int verify_parent_transid(struct
 				 struct extent_buffer *eb, u64 parent_transid)
 {
 	struct extent_state *cached_state = NULL;
-	int ret;
+	int ret, err;
 
 	if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
 		return 0;
@@ -347,8 +347,9 @@ static int verify_parent_transid(struct
 	ret = 1;
 	clear_extent_buffer_uptodate(io_tree, eb, &cached_state);
 out:
-	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
-			     &cached_state, GFP_NOFS);
+	err = unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
+				   &cached_state, GFP_NOFS);
+	BUG_ON(err < 0);
 	return ret;
 }
 
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1053,18 +1053,14 @@ int try_lock_extent(struct extent_io_tre
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask)
 {
-	int ret = clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0,
-				   cached, mask);
-	BUG_ON(ret < 0);
-	return ret;
+	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
+				mask);
 }
 
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 {
-	int ret =  clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
-				    mask);
-	BUG_ON(ret < 0);
-	return ret;
+	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
+				mask);
 }
 
 /*
@@ -1369,8 +1365,9 @@ again:
 	ret = test_range_bit(tree, delalloc_start, delalloc_end,
 			     EXTENT_DELALLOC, 1, cached_state);
 	if (!ret) {
-		unlock_extent_cached(tree, delalloc_start, delalloc_end,
-				     &cached_state, GFP_NOFS);
+		ret = unlock_extent_cached(tree, delalloc_start, delalloc_end,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		__unlock_for_delalloc(inode, locked_page,
 			      delalloc_start, delalloc_end);
 		cond_resched();
@@ -1807,7 +1804,9 @@ static void end_bio_extent_readpage(stru
 						  GFP_ATOMIC);
 			BUG_ON(ret < 0);
 		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+		ret = unlock_extent_cached(tree, start, end,
+					   &cached, GFP_ATOMIC);
+		BUG_ON(ret < 0);
 
 		if (whole_page) {
 			if (uptodate) {
@@ -2001,7 +2000,8 @@ static int __extent_read_full_page(struc
 		ordered = btrfs_lookup_ordered_extent(inode, start);
 		if (!ordered)
 			break;
-		unlock_extent(tree, start, end, GFP_NOFS);
+		ret = unlock_extent(tree, start, end, GFP_NOFS);
+		BUG_ON(ret < 0);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 	}
@@ -2031,15 +2031,17 @@ static int __extent_read_full_page(struc
 			ret = set_extent_uptodate(tree, cur, cur + iosize - 1,
 						  &cached, GFP_NOFS);
 			BUG_ON(ret < 0);
-			unlock_extent_cached(tree, cur, cur + iosize - 1,
-					     &cached, GFP_NOFS);
+			ret = unlock_extent_cached(tree, cur, cur + iosize - 1,
+						   &cached, GFP_NOFS);
+			BUG_ON(ret < 0);
 			break;
 		}
 		em = get_extent(inode, page, pg_offset, cur,
 				end - cur + 1, 0);
 		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
-			unlock_extent(tree, cur, end, GFP_NOFS);
+			ret = unlock_extent(tree, cur, end, GFP_NOFS);
+			BUG_ON(ret < 0);
 			break;
 		}
 		extent_offset = cur - em->start;
@@ -2082,8 +2084,9 @@ static int __extent_read_full_page(struc
 			ret = set_extent_uptodate(tree, cur, cur + iosize - 1,
 						  &cached, GFP_NOFS);
 			BUG_ON(ret < 0);
-			unlock_extent_cached(tree, cur, cur + iosize - 1,
-			                     &cached, GFP_NOFS);
+			ret = unlock_extent_cached(tree, cur, cur + iosize - 1,
+						   &cached, GFP_NOFS);
+			BUG_ON(ret < 0);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2092,7 +2095,9 @@ static int __extent_read_full_page(struc
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
 			check_page_uptodate(tree, page);
-			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
+			ret = unlock_extent(tree, cur, cur + iosize - 1,
+					    GFP_NOFS);
+			BUG_ON(ret < 0);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2102,7 +2107,9 @@ static int __extent_read_full_page(struc
 		 */
 		if (block_start == EXTENT_MAP_INLINE) {
 			SetPageError(page);
-			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
+			ret = unlock_extent(tree, cur, cur + iosize - 1,
+					    GFP_NOFS);
+			BUG_ON(ret < 0);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2829,7 +2836,7 @@ static struct extent_map *get_extent_ski
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent)
 {
-	int ret = 0;
+	int ret = 0, err;
 	u64 off = start;
 	u64 max = start + len;
 	u32 flags = 0;
@@ -2989,8 +2996,9 @@ int extent_fiemap(struct inode *inode, s
 out_free:
 	free_extent_map(em);
 out:
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len,
-			     &cached_state, GFP_NOFS);
+	err = unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len,
+				   &cached_state, GFP_NOFS);
+	BUG_ON(err < 0);
 	return ret;
 }
 
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1114,9 +1114,10 @@ again:
 		    ordered->file_offset + ordered->len > start_pos &&
 		    ordered->file_offset < last_pos) {
 			btrfs_put_ordered_extent(ordered);
-			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     start_pos, last_pos - 1,
-					     &cached_state, GFP_NOFS);
+			err = unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+						   start_pos, last_pos - 1,
+						   &cached_state, GFP_NOFS);
+			BUG_ON(err < 0);
 			for (i = 0; i < num_pages; i++) {
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
@@ -1134,9 +1135,10 @@ again:
 				      EXTENT_DO_ACCOUNTING, 0, 0,
 				      &cached_state, GFP_NOFS);
 		BUG_ON(err < 0);
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-				     start_pos, last_pos - 1, &cached_state,
-				     GFP_NOFS);
+		err = unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+					   start_pos, last_pos - 1,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 	}
 	for (i = 0; i < num_pages; i++) {
 		clear_page_dirty_for_io(pages[i]);
@@ -1577,7 +1579,7 @@ static long btrfs_fallocate(struct file
 	u64 locked_end;
 	u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
 	struct extent_map *em;
-	int ret;
+	int ret, err;
 
 	alloc_start = offset & ~mask;
 	alloc_end =  (offset + len + mask) & ~mask;
@@ -1624,9 +1626,10 @@ static long btrfs_fallocate(struct file
 		    ordered->file_offset + ordered->len > alloc_start &&
 		    ordered->file_offset < alloc_end) {
 			btrfs_put_ordered_extent(ordered);
-			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     alloc_start, locked_end,
-					     &cached_state, GFP_NOFS);
+			ret = unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+						   alloc_start, locked_end,
+						   &cached_state, GFP_NOFS);
+			BUG_ON(ret < 0);
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -1668,8 +1671,9 @@ static long btrfs_fallocate(struct file
 			break;
 		}
 	}
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
-			     &cached_state, GFP_NOFS);
+	err = unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start,
+				   locked_end, &cached_state, GFP_NOFS);
+	BUG_ON(err < 0);
 
 	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
 out:
@@ -1688,7 +1692,7 @@ static int find_desired_extent(struct in
 	u64 orig_start = *offset;
 	u64 len = i_size_read(inode);
 	u64 last_end = 0;
-	int ret = 0;
+	int ret = 0, err;
 
 	lockend = max_t(u64, root->sectorsize, lockend);
 	if (lockend <= lockstart)
@@ -1784,8 +1788,9 @@ static int find_desired_extent(struct in
 	if (!ret)
 		*offset = min(*offset, inode->i_size);
 out:
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-			     &cached_state, GFP_NOFS);
+	err = unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+				   &cached_state, GFP_NOFS);
+	BUG_ON(err < 0);
 	return ret;
 }
 
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -549,7 +549,7 @@ int __btrfs_write_out_cache(struct btrfs
 	int index = 0, num_pages = 0;
 	int entries = 0;
 	int bitmaps = 0;
-	int ret = -1;
+	int ret = -1, err;
 	bool next_page = false;
 	bool out_of_space = false;
 
@@ -760,9 +760,10 @@ int __btrfs_write_out_cache(struct btrfs
 
 	if (out_of_space) {
 		btrfs_drop_pages(pages, num_pages);
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
-				     i_size_read(inode) - 1, &cached_state,
-				     GFP_NOFS);
+		err = unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
+					   i_size_read(inode) - 1,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 		ret = 0;
 		goto out;
 	}
@@ -782,8 +783,10 @@ int __btrfs_write_out_cache(struct btrfs
 	ret = btrfs_dirty_pages(root, inode, pages, num_pages, 0,
 					    bytes, &cached_state);
 	btrfs_drop_pages(pages, num_pages);
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
-			     i_size_read(inode) - 1, &cached_state, GFP_NOFS);
+	err = unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
+				   i_size_read(inode) - 1,
+				   &cached_state, GFP_NOFS);
+	BUG_ON(err < 0);
 
 	if (ret) {
 		ret = 0;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -643,9 +643,11 @@ retry:
 			kfree(async_extent->pages);
 			async_extent->nr_pages = 0;
 			async_extent->pages = NULL;
-			unlock_extent(io_tree, async_extent->start,
-				      async_extent->start +
-				      async_extent->ram_size - 1, GFP_NOFS);
+			ret = unlock_extent(io_tree, async_extent->start,
+					    async_extent->start +
+					    async_extent->ram_size - 1,
+					    GFP_NOFS);
+			BUG_ON(ret < 0);
 			goto retry;
 		}
 
@@ -1578,8 +1580,10 @@ again:
 
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
-				     page_end, &cached_state, GFP_NOFS);
+		ret = unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+					   page_start, page_end,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		goto again;
@@ -1591,8 +1595,9 @@ again:
 	BUG_ON(ret < 0);
 	ClearPageChecked(page);
 out:
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			     &cached_state, GFP_NOFS);
+	ret = unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
+				   page_end, &cached_state, GFP_NOFS);
+	BUG_ON(ret < 0);
 out_page:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1789,9 +1794,11 @@ static int btrfs_finish_ordered_io(struc
 				   ordered_extent->len);
 		BUG_ON(ret);
 	}
-	unlock_extent_cached(io_tree, ordered_extent->file_offset,
-			     ordered_extent->file_offset +
-			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
+	ret = unlock_extent_cached(io_tree, ordered_extent->file_offset,
+				   ordered_extent->file_offset +
+				   ordered_extent->len - 1, &cached_state,
+				   GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
@@ -3387,7 +3394,7 @@ static int btrfs_truncate_page(struct ad
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
 	struct page *page;
-	int ret = 0;
+	int ret = 0, err;
 	u64 page_start;
 	u64 page_end;
 
@@ -3430,8 +3437,9 @@ again:
 
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
-		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+		ret = unlock_extent_cached(io_tree, page_start, page_end,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		unlock_page(page);
 		page_cache_release(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
@@ -3448,8 +3456,9 @@ again:
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
 	if (ret) {
-		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+		err = unlock_extent_cached(io_tree, page_start, page_end,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 		goto out_unlock;
 	}
 
@@ -3462,8 +3471,9 @@ again:
 	}
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	unlock_extent_cached(io_tree, page_start, page_end, &cached_state,
-			     GFP_NOFS);
+	err = unlock_extent_cached(io_tree, page_start, page_end,
+				   &cached_state, GFP_NOFS);
+	BUG_ON(err < 0);
 
 out_unlock:
 	if (ret)
@@ -3493,7 +3503,7 @@ int btrfs_cont_expand(struct inode *inod
 	u64 last_byte;
 	u64 cur_offset;
 	u64 hole_size;
-	int err = 0;
+	int err = 0, err2;
 
 	if (size <= hole_start)
 		return 0;
@@ -3508,8 +3518,9 @@ int btrfs_cont_expand(struct inode *inod
 		ordered = btrfs_lookup_ordered_extent(inode, hole_start);
 		if (!ordered)
 			break;
-		unlock_extent_cached(io_tree, hole_start, block_end - 1,
-				     &cached_state, GFP_NOFS);
+		err2 = unlock_extent_cached(io_tree, hole_start, block_end - 1,
+					    &cached_state, GFP_NOFS);
+		BUG_ON(err2 < 0);
 		btrfs_put_ordered_extent(ordered);
 	}
 
@@ -3556,8 +3567,9 @@ int btrfs_cont_expand(struct inode *inod
 	}
 
 	free_extent_map(em);
-	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state,
-			     GFP_NOFS);
+	err2 = unlock_extent_cached(io_tree, hole_start, block_end - 1,
+				    &cached_state, GFP_NOFS);
+	BUG_ON(err2 < 0);
 	return err;
 }
 
@@ -5624,8 +5636,9 @@ static int btrfs_get_blocks_direct(struc
 			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
 		free_extent_map(em);
 		/* DIO will do one hole at a time, so just unlock a sector */
-		unlock_extent(&BTRFS_I(inode)->io_tree, start,
-			      start + root->sectorsize - 1, GFP_NOFS);
+		ret = unlock_extent(&BTRFS_I(inode)->io_tree, start,
+				    start + root->sectorsize - 1, GFP_NOFS);
+		BUG_ON(ret < 0);
 		return 0;
 	}
 
@@ -5727,6 +5740,7 @@ struct btrfs_dio_private {
 
 static void btrfs_endio_direct_read(struct bio *bio, int err)
 {
+	int ret;
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
@@ -5767,8 +5781,9 @@ static void btrfs_endio_direct_read(stru
 		bvec++;
 	} while (bvec <= bvec_end);
 
-	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
-		      dip->logical_offset + dip->bytes - 1, GFP_NOFS);
+	ret = unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
+			    dip->logical_offset + dip->bytes - 1, GFP_NOFS);
+	BUG_ON(ret < 0);
 	bio->bi_private = dip->private;
 
 	kfree(dip->csums);
@@ -5790,7 +5805,7 @@ static void btrfs_endio_direct_write(str
 	struct extent_state *cached_state = NULL;
 	u64 ordered_offset = dip->logical_offset;
 	u64 ordered_bytes = dip->bytes;
-	int ret;
+	int ret, ret2;
 
 	if (err)
 		goto out_done;
@@ -5856,9 +5871,11 @@ again:
 		btrfs_update_inode(trans, root, inode);
 	ret = 0;
 out_unlock:
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, ordered->file_offset,
-			     ordered->file_offset + ordered->len - 1,
-			     &cached_state, GFP_NOFS);
+	ret2 = unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+				    ordered->file_offset,
+				    ordered->file_offset + ordered->len - 1,
+				    &cached_state, GFP_NOFS);
+	BUG_ON(ret2 < 0);
 out:
 	btrfs_delalloc_release_metadata(inode, ordered->len);
 	btrfs_end_transaction(trans, root);
@@ -6247,8 +6264,9 @@ static ssize_t btrfs_direct_IO(int rw, s
 						     lockend - lockstart + 1);
 		if (!ordered)
 			break;
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     &cached_state, GFP_NOFS);
+		ret = unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
+					   lockend, &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 		cond_resched();
@@ -6468,7 +6486,7 @@ int btrfs_page_mkwrite(struct vm_area_st
 	char *kaddr;
 	unsigned long zero_start;
 	loff_t size;
-	int ret;
+	int ret, err;
 	u64 page_start;
 	u64 page_end;
 
@@ -6506,8 +6524,9 @@ again:
 	 */
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
-		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+		err = unlock_extent_cached(io_tree, page_start, page_end,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
@@ -6530,8 +6549,9 @@ again:
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
 	if (ret) {
-		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+		err = unlock_extent_cached(io_tree, page_start, page_end,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(err < 0);
 		ret = VM_FAULT_SIGBUS;
 		goto out_unlock;
 	}
@@ -6556,7 +6576,9 @@ again:
 	BTRFS_I(inode)->last_trans = root->fs_info->generation;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 
-	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
+	err = unlock_extent_cached(io_tree, page_start, page_end,
+				   &cached_state, GFP_NOFS);
+	BUG_ON(err < 0);
 
 out_unlock:
 	if (!ret)
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -781,7 +781,8 @@ static int should_defrag_range(struct in
 		err = lock_extent(io_tree, start, start + len - 1, GFP_NOFS);
 		BUG_ON(err < 0);
 		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
-		unlock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+		err = unlock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+		BUG_ON(err < 0);
 
 		if (IS_ERR(em))
 			return 0;
@@ -912,9 +913,10 @@ again:
 	    ordered->file_offset + ordered->len > page_start &&
 	    ordered->file_offset < page_end) {
 		btrfs_put_ordered_extent(ordered);
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-				     page_start, page_end - 1,
-				     &cached_state, GFP_NOFS);
+		ret = unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+					   page_start, page_end - 1,
+					   &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		for (i = 0; i < i_done; i++) {
 			unlock_page(pages[i]);
 			page_cache_release(pages[i]);
@@ -945,9 +947,10 @@ again:
 					&cached_state);
 	BUG_ON(ret < 0);
 
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-			     page_start, page_end - 1, &cached_state,
-			     GFP_NOFS);
+	ret = unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+				   page_start, page_end - 1, &cached_state,
+				   GFP_NOFS);
+	BUG_ON(ret < 0);
 
 	for (i = 0; i < i_done; i++) {
 		clear_page_dirty_for_io(pages[i]);
@@ -2139,7 +2142,7 @@ static noinline long btrfs_ioctl_clone(s
 	struct btrfs_key key;
 	u32 nritems;
 	int slot;
-	int ret;
+	int ret, err;
 	u64 len = olen;
 	u64 bs = root->fs_info->sb->s_blocksize;
 	u64 hint_byte;
@@ -2236,7 +2239,9 @@ static noinline long btrfs_ioctl_clone(s
 		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off+len,
 				   EXTENT_DELALLOC, 0, NULL))
 			break;
-		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+		ret = unlock_extent(&BTRFS_I(src)->io_tree, off,
+				    off+len, GFP_NOFS);
+		BUG_ON(ret < 0);
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 		btrfs_wait_ordered_range(src, off, len);
@@ -2443,7 +2448,8 @@ next:
 	ret = 0;
 out:
 	btrfs_release_path(path);
-	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+	err = unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+	BUG_ON(err < 0);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
 	mutex_unlock(&inode->i_mutex);
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1583,8 +1583,9 @@ int replace_file_extents(struct btrfs_tr
 
 				btrfs_drop_extent_cache(inode, key.offset, end,
 							1);
-				unlock_extent(&BTRFS_I(inode)->io_tree,
-					      key.offset, end, GFP_NOFS);
+				ret = unlock_extent(&BTRFS_I(inode)->io_tree,
+						    key.offset, end, GFP_NOFS);
+				BUG_ON(ret < 0);
 			}
 		}
 
@@ -1958,7 +1959,9 @@ static int invalidate_extent_cache(struc
 				  GFP_NOFS);
 		BUG_ON(ret < 0);
 		btrfs_drop_extent_cache(inode, start, end, 1);
-		unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		ret = unlock_extent(&BTRFS_I(inode)->io_tree, start, end,
+				    GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 	return 0;
 }
@@ -2860,6 +2863,7 @@ int prealloc_file_extent_cluster(struct
 		goto out;
 
 	while (nr < cluster->nr) {
+		int err;
 		start = cluster->boundary[nr] - offset;
 		if (nr + 1 < cluster->nr)
 			end = cluster->boundary[nr + 1] - 1 - offset;
@@ -2873,7 +2877,9 @@ int prealloc_file_extent_cluster(struct
 		ret = btrfs_prealloc_file_range(inode, 0, start,
 						num_bytes, num_bytes,
 						end + 1, &alloc_hint);
-		unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		err = unlock_extent(&BTRFS_I(inode)->io_tree, start, end,
+				    GFP_NOFS);
+		BUG_ON(err < 0);
 		if (ret)
 			break;
 		nr++;
@@ -2892,7 +2898,7 @@ int setup_extent_mapping(struct inode *i
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_map *em;
-	int ret = 0;
+	int ret = 0, err;
 
 	em = alloc_extent_map();
 	if (!em)
@@ -2917,7 +2923,8 @@ int setup_extent_mapping(struct inode *i
 		}
 		btrfs_drop_extent_cache(inode, start, end, 0);
 	}
-	unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	err = unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	BUG_ON(err < 0);
 	return ret;
 }
 
@@ -3016,8 +3023,9 @@ static int relocate_file_extent_cluster(
 		BUG_ON(ret < 0);
 		set_page_dirty(page);
 
-		unlock_extent(&BTRFS_I(inode)->io_tree,
-			      page_start, page_end, GFP_NOFS);
+		ret = unlock_extent(&BTRFS_I(inode)->io_tree,
+				    page_start, page_end, GFP_NOFS);
+		BUG_ON(ret < 0);
 		unlock_page(page);
 		page_cache_release(page);
 


