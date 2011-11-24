From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 16/99] btrfs: clear_extent_bit can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:49 -0500
Message-ID: <20111124004221.671419421@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that all of the callers of clear_extent_bit use with GFP_ATOMIC or
 GFP_NOFS, we can drop the gfp_t argument entirely and allow
 clear_extent_bit to always pass GFP_NOFS and clear_extent_bit_atomic to
 always pass GFP_ATOMIC.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c        |   43 +++++++++++++++++++------------------------
 fs/btrfs/extent_io.h        |    5 ++---
 fs/btrfs/file.c             |    3 +--
 fs/btrfs/free-space-cache.c |    5 ++---
 fs/btrfs/inode.c            |   20 +++++++++-----------
 fs/btrfs/ioctl.c            |    3 +--
 6 files changed, 34 insertions(+), 45 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -636,23 +636,22 @@ search_again:
  */
 void clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		      int bits, int wake, int delete,
-		      struct extent_state **cached_state, gfp_t mask)
+		      struct extent_state **cached_state)
 {
 	int ret;
-	WARN_ON(!(mask & __GFP_WAIT));
+	might_sleep();
 	ret = __clear_extent_bit(tree, start, end, bits, wake, delete,
-				 cached_state, mask);
+				 cached_state, GFP_NOFS);
 	BUG_ON(ret < 0);
 }
 
 static int __must_check
 clear_extent_bit_atomic(struct extent_io_tree *tree, u64 start,
			u64 end, int bits, int wake, int delete,
-			struct extent_state **cached_state, gfp_t mask)
+			struct extent_state **cached_state)
 {
-	WARN_ON(mask & __GFP_WAIT);
 	return __clear_extent_bit(tree, start, end, bits, wake, delete,
-				  cached_state, mask);
+				  cached_state, GFP_ATOMIC);
 }
 
 static int wait_on_state(struct extent_io_tree *tree,
@@ -1157,7 +1156,7 @@ int clear_extent_bits_atomic(struct exte
 void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits)
 {
-	clear_extent_bit(tree, start, end, bits, 0, 0, NULL, GFP_NOFS);
+	clear_extent_bit(tree, start, end, bits, 0, 0, NULL);
 }
 
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1178,7 +1177,7 @@ int clear_extent_dirty_atomic(struct ext
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	clear_extent_bit(tree, start, end, EXTENT_DIRTY | EXTENT_DELALLOC |
-			 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
+			 EXTENT_DO_ACCOUNTING, 0, 0, NULL);
 }
 
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1206,7 +1204,7 @@ static void clear_extent_uptodate(struct
 				  u64 end, struct extent_state **cached_state)
 {
 	clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
-			 cached_state, GFP_NOFS);
+			 cached_state);
 }
 
 /*
@@ -1248,8 +1246,7 @@ int try_lock_extent(struct extent_io_tre
 	if (err == -EEXIST) {
 		if (failed_start > start)
 			clear_extent_bit(tree, start, failed_start - 1,
-					 EXTENT_LOCKED, 1, 0, NULL,
-					 GFP_NOFS);
+					 EXTENT_LOCKED, 1, 0, NULL);
 		return 0;
 	}
 	return 1;
@@ -1258,20 +1255,19 @@ int try_lock_extent(struct extent_io_tre
 void unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			  struct extent_state **cached)
 {
-	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
-			 GFP_NOFS);
+	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached);
 }
 
 int unlock_extent_cached_atomic(struct extent_io_tree *tree, u64 start,
 				u64 end, struct extent_state **cached)
 {
 	return clear_extent_bit_atomic(tree, start, end, EXTENT_LOCKED, 1, 0,
-				       cached, GFP_ATOMIC);
+				       cached);
 }
 
 void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL, GFP_NOFS);
+	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL);
 }
 
 /*
@@ -1617,7 +1612,7 @@ void extent_clear_unlock_delalloc(struct
 	if (op & EXTENT_CLEAR_DELALLOC)
 		clear_bits |= EXTENT_DELALLOC;
 
-	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
+	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL);
 	if (!(op & (EXTENT_CLEAR_UNLOCK_PAGE | EXTENT_CLEAR_DIRTY |
 		    EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK |
 		    EXTENT_SET_PRIVATE2)))
@@ -3277,7 +3272,7 @@ int extent_invalidatepage(struct extent_
 	clear_extent_bit(tree, start, end,
 			 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
 			 EXTENT_DO_ACCOUNTING,
-			 1, 1, &cached_state, GFP_NOFS);
+			 1, 1, &cached_state);
 	return 0;
 }
 
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -213,7 +213,7 @@ void clear_extent_bits(struct extent_io_
		       int bits);
 void clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		      int bits, int wake, int delete,
-		      struct extent_state **cached, gfp_t mask);
+		      struct extent_state **cached);
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1129,8 +1129,7 @@ again:
 
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
 				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-				  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-				  GFP_NOFS);
+				  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 				     start_pos, last_pos - 1, &cached_state);
 	}
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -974,8 +974,7 @@ int __btrfs_write_out_cache(struct btrfs
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret < 0) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
-				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL,
-				 GFP_NOFS);
+				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL);
 		goto out;
 	}
 	leaf = path->nodes[0];
@@ -989,7 +988,7 @@ int __btrfs_write_out_cache(struct btrfs
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0,
 					 inode->i_size - 1,
 					 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0,
-					 NULL, GFP_NOFS);
+					 NULL);
 			btrfs_release_path(path);
 			goto out;
 		}
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -965,7 +965,7 @@ static int cow_file_range_async(struct i
 	int limit = 10 * 1024 * 1042;
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
-			 1, 0, NULL, GFP_NOFS);
+			 1, 0, NULL);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		BUG_ON(!async_cow);
@@ -3246,7 +3246,7 @@ again:
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
-			  0, 0, &cached_state, GFP_NOFS);
+			  0, 0, &cached_state);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
@@ -5526,7 +5526,7 @@ must_cow:
 unlock:
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, start + len - 1,
 			  EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DIRTY, 1,
-			  0, NULL, GFP_NOFS);
+			  0, NULL);
 map:
 	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
 		inode->i_blkbits;
@@ -6096,7 +6096,7 @@ static ssize_t btrfs_direct_IO(int rw, s
 		if (ret) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 					 lockend, EXTENT_LOCKED | write_bits,
-					 1, 0, &cached_state, GFP_NOFS);
+					 1, 0, &cached_state);
 			goto out;
 		}
 	}
@@ -6112,8 +6112,7 @@ static ssize_t btrfs_direct_IO(int rw, s
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
 			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
-			      &cached_state, GFP_NOFS);
+			      EXTENT_LOCKED | write_bits, 1, 0, &cached_state);
 	} else if (ret >= 0 && ret < iov_length(iov, nr_segs)) {
 		/*
 		 * We're falling back to buffered, unlock the section we didn't
@@ -6121,8 +6120,7 @@ static ssize_t btrfs_direct_IO(int rw, s
 		 */
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
 			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
-			      &cached_state, GFP_NOFS);
+			      EXTENT_LOCKED | write_bits, 1, 0, &cached_state);
 	}
 out:
 	free_extent_state(cached_state);
@@ -6233,7 +6231,7 @@ static void btrfs_invalidatepage(struct
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
-				 &cached_state, GFP_NOFS);
+				 &cached_state);
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
@@ -6249,7 +6247,7 @@ static void btrfs_invalidatepage(struct
 	}
 	clear_extent_bit(tree, page_start, page_end,
 		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
+		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
@@ -6340,7 +6338,7 @@ again:
 	 */
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
-			  0, 0, &cached_state, GFP_NOFS);
+			  0, 0, &cached_state);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -936,8 +936,7 @@ again:
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
 			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-			  GFP_NOFS);
+			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state);
 
 	if (i_done != num_pages) {
 		spin_lock(&BTRFS_I(inode)->lock);


