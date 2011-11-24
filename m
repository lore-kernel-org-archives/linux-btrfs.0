From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 11/99] btrfs: unlock_extent can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:44 -0500
Message-ID: <20111124004221.092524198@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 All of the callers of unlock_extent call it with gfp_t == GFP_NOFS.

 This patch simplifies the call sites by calling clear_extent_bit with
 GFP_NOFS from unlock_extent itself.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/compression.c      |    4 ++--
 fs/btrfs/disk-io.c          |    2 +-
 fs/btrfs/extent_io.c        |   33 ++++++++++++++++-----------------
 fs/btrfs/extent_io.h        |    7 +++----
 fs/btrfs/file.c             |   13 ++++++-------
 fs/btrfs/free-space-cache.c |    4 ++--
 fs/btrfs/inode.c            |   36 +++++++++++++++++-------------------
 fs/btrfs/ioctl.c            |   11 +++++------
 fs/btrfs/relocation.c       |   11 +++++------
 9 files changed, 57 insertions(+), 64 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -507,7 +507,7 @@ static noinline int add_ra_bio_pages(str
 		    (last_offset + PAGE_CACHE_SIZE > extent_map_end(em)) ||
 		    (em->block_start >> 9) != cb->orig_bio->bi_sector) {
 			free_extent_map(em);
-			unlock_extent(tree, last_offset, end, GFP_NOFS);
+			unlock_extent(tree, last_offset, end);
 			unlock_page(page);
 			page_cache_release(page);
 			break;
@@ -535,7 +535,7 @@ static noinline int add_ra_bio_pages(str
 			nr_pages++;
 			page_cache_release(page);
 		} else {
-			unlock_extent(tree, last_offset, end, GFP_NOFS);
+			unlock_extent(tree, last_offset, end);
 			unlock_page(page);
 			page_cache_release(page);
 			break;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -346,7 +346,7 @@ static int verify_parent_transid(struct
 	clear_extent_buffer_uptodate(io_tree, eb, &cached_state);
 out:
 	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 	return ret;
 }
 
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1260,22 +1260,22 @@ int try_lock_extent(struct extent_io_tre
 }
 
 void unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
-			  struct extent_state **cached, gfp_t mask)
+			  struct extent_state **cached)
 {
-	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached, mask);
+	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
+			 GFP_NOFS);
 }
 
 int unlock_extent_cached_atomic(struct extent_io_tree *tree, u64 start,
-				u64 end, struct extent_state **cached,
-				gfp_t mask)
+				u64 end, struct extent_state **cached)
 {
 	return clear_extent_bit_atomic(tree, start, end, EXTENT_LOCKED, 1, 0,
-				       cached, mask);
+				       cached, GFP_ATOMIC);
 }
 
-void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
+void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL, mask);
+	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL, GFP_NOFS);
 }
 
 /*
@@ -1580,7 +1580,7 @@ again:
 			     EXTENT_DELALLOC, 1, cached_state);
 	if (!ret) {
 		unlock_extent_cached(tree, delalloc_start, delalloc_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		__unlock_for_delalloc(inode, locked_page,
 			      delalloc_start, delalloc_end);
 		cond_resched();
@@ -2375,8 +2375,7 @@ static void end_bio_extent_readpage(stru
 			set_extent_uptodate(tree, start, end, &cached,
 					    GFP_ATOMIC);
 		}
-		ret = unlock_extent_cached_atomic(tree, start, end,
-						  &cached, GFP_ATOMIC);
+		ret = unlock_extent_cached_atomic(tree, start, end, &cached);
 		BUG_ON(ret < 0);
 
 		if (whole_page) {
@@ -2571,7 +2570,7 @@ static int __extent_read_full_page(struc
 		ordered = btrfs_lookup_ordered_extent(inode, start);
 		if (!ordered)
 			break;
-		unlock_extent(tree, start, end, GFP_NOFS);
+		unlock_extent(tree, start, end);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 	}
@@ -2601,14 +2600,14 @@ static int __extent_read_full_page(struc
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
-					     &cached, GFP_NOFS);
+					     &cached);
 			break;
 		}
 		em = get_extent(inode, page, pg_offset, cur,
 				end - cur + 1, 0);
 		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
-			unlock_extent(tree, cur, end, GFP_NOFS);
+			unlock_extent(tree, cur, end);
 			break;
 		}
 		extent_offset = cur - em->start;
@@ -2651,7 +2650,7 @@ static int __extent_read_full_page(struc
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
-			                     &cached, GFP_NOFS);
+			                     &cached);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2660,7 +2659,7 @@ static int __extent_read_full_page(struc
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
 			check_page_uptodate(tree, page);
-			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
+			unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2670,7 +2669,7 @@ static int __extent_read_full_page(struc
 		 */
 		if (block_start == EXTENT_MAP_INLINE) {
 			SetPageError(page);
-			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
+			unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -3573,7 +3572,7 @@ out_free:
 	free_extent_map(em);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 	return ret;
 }
 
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -183,13 +183,12 @@ int try_release_extent_state(struct exte
 int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		     int bits, struct extent_state **cached, gfp_t mask);
-void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
+void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int __must_check unlock_extent_cached_atomic(struct extent_io_tree *tree,
 					     u64 start, u64 end,
-					     struct extent_state **cached,
-					     gfp_t mask);
+					     struct extent_state **cached);
 void unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
-			  struct extent_state **cached, gfp_t mask);
+			  struct extent_state **cached);
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 		    gfp_t mask);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1115,7 +1115,7 @@ again:
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     start_pos, last_pos - 1,
-					     &cached_state, GFP_NOFS);
+					     &cached_state);
 			for (i = 0; i < num_pages; i++) {
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
@@ -1132,8 +1132,7 @@ again:
 				  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
 				  GFP_NOFS);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-				     start_pos, last_pos - 1, &cached_state,
-				     GFP_NOFS);
+				     start_pos, last_pos - 1, &cached_state);
 	}
 	for (i = 0; i < num_pages; i++) {
 		clear_page_dirty_for_io(pages[i]);
@@ -1633,7 +1632,7 @@ static long btrfs_fallocate(struct file
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     alloc_start, locked_end,
-					     &cached_state, GFP_NOFS);
+					     &cached_state);
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -1705,8 +1704,8 @@ static long btrfs_fallocate(struct file
 			break;
 		}
 	}
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
-			     &cached_state, GFP_NOFS);
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start,
+			     locked_end, &cached_state);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
@@ -1819,7 +1818,7 @@ static int find_desired_extent(struct in
 		*offset = min(*offset, inode->i_size);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 	return ret;
 }
 
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -957,7 +957,7 @@ int __btrfs_write_out_cache(struct btrfs
 				0, i_size_read(inode), &cached_state);
 	io_ctl_drop_pages(&io_ctl);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
-			     i_size_read(inode) - 1, &cached_state, GFP_NOFS);
+			     i_size_read(inode) - 1, &cached_state);
 
 	if (ret)
 		goto out;
@@ -1022,7 +1022,7 @@ out_nospc:
 	}
 	io_ctl_drop_pages(&io_ctl);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
-			     i_size_read(inode) - 1, &cached_state, GFP_NOFS);
+			     i_size_read(inode) - 1, &cached_state);
 	goto out;
 }
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -648,7 +648,7 @@ retry:
 			async_extent->pages = NULL;
 			unlock_extent(io_tree, async_extent->start,
 				      async_extent->start +
-				      async_extent->ram_size - 1, GFP_NOFS);
+				      async_extent->ram_size - 1);
 			goto retry;
 		}
 
@@ -1578,7 +1578,7 @@ again:
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
-				     page_end, &cached_state, GFP_NOFS);
+				     page_end, &cached_state);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		goto again;
@@ -1589,7 +1589,7 @@ again:
 	ClearPageChecked(page);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 out_page:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1786,7 +1786,7 @@ static int btrfs_finish_ordered_io(struc
 	}
 	unlock_extent_cached(io_tree, ordered_extent->file_offset,
 			     ordered_extent->file_offset +
-			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
+			     ordered_extent->len - 1, &cached_state);
 
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
@@ -3237,7 +3237,7 @@ again:
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		unlock_page(page);
 		page_cache_release(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
@@ -3253,7 +3253,7 @@ again:
 					&cached_state);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		goto out_unlock;
 	}
 
@@ -3266,8 +3266,7 @@ again:
 	}
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	unlock_extent_cached(io_tree, page_start, page_end, &cached_state,
-			     GFP_NOFS);
+	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
 out_unlock:
 	if (ret)
@@ -3312,7 +3311,7 @@ int btrfs_cont_expand(struct inode *inod
 		if (!ordered)
 			break;
 		unlock_extent_cached(io_tree, hole_start, block_end - 1,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		btrfs_put_ordered_extent(ordered);
 	}
 
@@ -3363,8 +3362,7 @@ int btrfs_cont_expand(struct inode *inod
 	}
 
 	free_extent_map(em);
-	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state,
-			     GFP_NOFS);
+	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state);
 	return err;
 }
 
@@ -5463,7 +5461,7 @@ static int btrfs_get_blocks_direct(struc
 		free_extent_map(em);
 		/* DIO will do one hole at a time, so just unlock a sector */
 		unlock_extent(&BTRFS_I(inode)->io_tree, start,
-			      start + root->sectorsize - 1, GFP_NOFS);
+			      start + root->sectorsize - 1);
 		return 0;
 	}
 
@@ -5604,7 +5602,7 @@ static void btrfs_endio_direct_read(stru
 	} while (bvec <= bvec_end);
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
-		      dip->logical_offset + dip->bytes - 1, GFP_NOFS);
+		      dip->logical_offset + dip->bytes - 1);
 	bio->bi_private = dip->private;
 
 	kfree(dip->csums);
@@ -5692,7 +5690,7 @@ again:
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, ordered->file_offset,
 			     ordered->file_offset + ordered->len - 1,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 out:
 	btrfs_delalloc_release_metadata(inode, ordered->len);
 	btrfs_end_transaction(trans, root);
@@ -6080,8 +6078,8 @@ static ssize_t btrfs_direct_IO(int rw, s
 						     lockend - lockstart + 1);
 		if (!ordered)
 			break;
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     &cached_state, GFP_NOFS);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, &cached_state);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 		cond_resched();
@@ -6327,7 +6325,7 @@ again:
 	ordered = btrfs_lookup_ordered_extent(inode, page_start);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
@@ -6349,7 +6347,7 @@ again:
 					&cached_state);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		ret = VM_FAULT_SIGBUS;
 		goto out_unlock;
 	}
@@ -6374,7 +6372,7 @@ again:
 	BTRFS_I(inode)->last_trans = root->fs_info->generation;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 
-	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
+	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
 out_unlock:
 	if (!ret)
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -790,7 +790,7 @@ static int should_defrag_range(struct in
 		/* get the big lock and read metadata off disk */
 		lock_extent(io_tree, start, start + len - 1, GFP_NOFS);
 		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
-		unlock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+		unlock_extent(io_tree, start, start + len - 1);
 
 		if (IS_ERR(em))
 			return 0;
@@ -922,7 +922,7 @@ again:
 		btrfs_put_ordered_extent(ordered);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 				     page_start, page_end - 1,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		for (i = 0; i < i_done; i++) {
 			unlock_page(pages[i]);
 			page_cache_release(pages[i]);
@@ -952,8 +952,7 @@ again:
 				  &cached_state);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-			     page_start, page_end - 1, &cached_state,
-			     GFP_NOFS);
+			     page_start, page_end - 1, &cached_state);
 
 	for (i = 0; i < i_done; i++) {
 		clear_page_dirty_for_io(pages[i]);
@@ -2281,7 +2280,7 @@ static noinline long btrfs_ioctl_clone(s
 		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off+len,
 				   EXTENT_DELALLOC, 0, NULL))
 			break;
-		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len);
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 		btrfs_wait_ordered_range(src, off, len);
@@ -2500,7 +2499,7 @@ next:
 	ret = 0;
 out:
 	btrfs_release_path(path);
-	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
 	mutex_unlock(&inode->i_mutex);
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1604,7 +1604,7 @@ int replace_file_extents(struct btrfs_tr
 				btrfs_drop_extent_cache(inode, key.offset, end,
 							1);
 				unlock_extent(&BTRFS_I(inode)->io_tree,
-					      key.offset, end, GFP_NOFS);
+					      key.offset, end);
 			}
 		}
 
@@ -1975,7 +1975,7 @@ static int invalidate_extent_cache(struc
 		/* the lock_extent waits for readpage to complete */
 		lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
 		btrfs_drop_extent_cache(inode, start, end, 1);
-		unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 	}
 	return 0;
 }
@@ -2884,7 +2884,7 @@ int prealloc_file_extent_cluster(struct
 		ret = btrfs_prealloc_file_range(inode, 0, start,
 						num_bytes, num_bytes,
 						end + 1, &alloc_hint);
-		unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 		if (ret)
 			break;
 		nr++;
@@ -2927,7 +2927,7 @@ int setup_extent_mapping(struct inode *i
 		}
 		btrfs_drop_extent_cache(inode, start, end, 0);
 	}
-	unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+	unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 	return ret;
 }
 
@@ -3023,8 +3023,7 @@ static int relocate_file_extent_cluster(
 		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
 		set_page_dirty(page);
 
-		unlock_extent(&BTRFS_I(inode)->io_tree,
-			      page_start, page_end, GFP_NOFS);
+		unlock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
 		unlock_page(page);
 		page_cache_release(page);
 


