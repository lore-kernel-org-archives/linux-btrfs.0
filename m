From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 08/99] btrfs: clear_extent_bit should return void with __GFP_WAIT set
Date: Wed, 23 Nov 2011 19:35:41 -0500
Message-ID: <20111124004220.744045404@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that allocations that are allowed to sleep can't fail,
 clear_extent_bit has no more error conditions and we can assume the
 return value will be 0 and return void to callers.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |  126 +++++++++++++++++++++++++++++----------------------
 fs/btrfs/extent_io.h |   28 +++++------
 2 files changed, 88 insertions(+), 66 deletions(-)

Index: linux-3.0-SLE11-SP2/fs/btrfs/extent_io.c
===================================================================
--- linux-3.0-SLE11-SP2.orig/fs/btrfs/extent_io.c	2011-11-21 14:15:28.000000000 -0500
+++ linux-3.0-SLE11-SP2/fs/btrfs/extent_io.c	2011-11-21 14:22:41.000000000 -0500
@@ -494,10 +494,9 @@ NORET_TYPE void extent_io_tree_panic(str
  * This takes the tree lock, and returns 0 on success and < 0 on error.
  * If (mask & __GFP_WAIT) == 0, there are no error conditions.
  */
-int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, int wake, int delete,
-		     struct extent_state **cached_state,
-		     gfp_t mask)
+static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+			      int bits, int wake, int delete,
+			      struct extent_state **cached_state, gfp_t mask)
 {
 	struct extent_state *state;
 	struct extent_state *cached;
@@ -642,6 +641,31 @@ search_again:
 	goto again;
 }
 
+/*
+ * With __GFP_WAIT set, the memory allocations will wait until they can
+ * be honored. With -ENOMEM out of the way, we don't have errors to return.
+ */
+void clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		      int bits, int wake, int delete,
+		      struct extent_state **cached_state, gfp_t mask)
+{
+	int ret;
+	WARN_ON(!(mask & __GFP_WAIT));
+	ret = __clear_extent_bit(tree, start, end, bits, wake, delete,
+				 cached_state, mask);
+	BUG_ON(ret < 0);
+}
+
+static int __must_check
+clear_extent_bit_atomic(struct extent_io_tree *tree, u64 start,
+			u64 end, int bits, int wake, int delete,
+			struct extent_state **cached_state, gfp_t mask)
+{
+	WARN_ON(mask & __GFP_WAIT);
+	return __clear_extent_bit(tree, start, end, bits, wake, delete,
+				  cached_state, mask);
+}
+
 static int wait_on_state(struct extent_io_tree *tree,
 			 struct extent_state *state)
 		__releases(tree->lock)
@@ -1149,10 +1173,10 @@ int set_extent_bits(struct extent_io_tre
 			      NULL, mask);
 }
 
-int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
+void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		      int bits, gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, bits, 0, 0, NULL, mask);
+	clear_extent_bit(tree, start, end, bits, 0, 0, NULL, mask);
 }
 
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1163,12 +1187,11 @@ int set_extent_delalloc(struct extent_io
 			      0, NULL, cached_state, mask);
 }
 
-int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
+void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end,
-				EXTENT_DIRTY | EXTENT_DELALLOC |
-				EXTENT_DO_ACCOUNTING, 0, 0, NULL, mask);
+	clear_extent_bit(tree, start, end, EXTENT_DIRTY | EXTENT_DELALLOC |
+			 EXTENT_DO_ACCOUNTING, 0, 0, NULL, mask);
 }
 
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1185,12 +1208,12 @@ int set_extent_uptodate(struct extent_io
 			      NULL, cached_state, mask);
 }
 
-static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
-				 u64 end, struct extent_state **cached_state,
-				 gfp_t mask)
+static void clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
+				  u64 end, struct extent_state **cached_state,
+				  gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
-				cached_state, mask);
+	clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
+			 cached_state, mask);
 }
 
 /*
@@ -1231,9 +1254,19 @@ int try_lock_extent(struct extent_io_tre
 	err = set_extent_bit(tree, start, end, EXTENT_LOCKED, EXTENT_LOCKED,
 			     &failed_start, NULL, mask);
 	if (err == -EEXIST) {
-		if (failed_start > start)
-			clear_extent_bit(tree, start, failed_start - 1,
-					 EXTENT_LOCKED, 1, 0, NULL, mask);
+		if (failed_start > start) {
+			if (mask & __GFP_WAIT)
+				clear_extent_bit(tree, start, failed_start - 1,
+						 EXTENT_LOCKED, 1, 0, NULL,
+						 mask);
+			else {
+				err = clear_extent_bit_atomic(tree, start,
+						failed_start - 1,
+						EXTENT_LOCKED, 1, 0,
+						NULL, mask);
+				BUG_ON(err < 0);
+			}
+		}
 		return 0;
 	}
 	return 1;
@@ -1242,14 +1275,14 @@ int try_lock_extent(struct extent_io_tre
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
-				mask);
+	return __clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0,
+				  cached, mask);
 }
 
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
-				mask);
+	return __clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0,
+				  NULL, mask);
 }
 
 /*
@@ -1567,10 +1600,10 @@ out_failed:
 	return found;
 }
 
-int extent_clear_unlock_delalloc(struct inode *inode,
-				struct extent_io_tree *tree,
-				u64 start, u64 end, struct page *locked_page,
-				unsigned long op)
+void extent_clear_unlock_delalloc(struct inode *inode,
+				  struct extent_io_tree *tree,
+				  u64 start, u64 end, struct page *locked_page,
+				  unsigned long op)
 {
 	int ret;
 	struct page *pages[16];
@@ -1592,7 +1625,7 @@ int extent_clear_unlock_delalloc(struct
 	if (!(op & (EXTENT_CLEAR_UNLOCK_PAGE | EXTENT_CLEAR_DIRTY |
 		    EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK |
 		    EXTENT_SET_PRIVATE2)))
-		return 0;
+		return;
 
 	while (nr_pages > 0) {
 		ret = find_get_pages_contig(inode->i_mapping, index,
@@ -1621,7 +1654,6 @@ int extent_clear_unlock_delalloc(struct
 		index += ret;
 		cond_resched();
 	}
-	return 0;
 }
 
 /*
@@ -1858,30 +1890,21 @@ struct io_failure_record {
 	int in_validation;
 };
 
-static int free_io_failure(struct inode *inode, struct io_failure_record *rec,
+static void free_io_failure(struct inode *inode, struct io_failure_record *rec,
 				int did_repair)
 {
-	int ret;
-	int err = 0;
 	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 
 	set_state_private(failure_tree, rec->start, 0);
-	ret = clear_extent_bits(failure_tree, rec->start,
-				rec->start + rec->len - 1,
-				EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
-	if (ret)
-		err = ret;
+	clear_extent_bits(failure_tree, rec->start, rec->start + rec->len - 1,
+			  EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
 
-	if (did_repair) {
-		ret = clear_extent_bits(&BTRFS_I(inode)->io_tree, rec->start,
-					rec->start + rec->len - 1,
-					EXTENT_DAMAGED, GFP_NOFS);
-		if (ret && !err)
-			err = ret;
-	}
+	if (did_repair)
+		clear_extent_bits(&BTRFS_I(inode)->io_tree, rec->start,
+				  rec->start + rec->len - 1,
+				  EXTENT_DAMAGED, GFP_NOFS);
 
 	kfree(rec);
-	return err;
 }
 
 static void repair_io_failure_callback(struct bio *bio, int err)
@@ -2013,7 +2036,7 @@ static int clean_io_failure(u64 start, s
 
 out:
 	if (!ret)
-		ret = free_io_failure(inode, failrec, did_repair);
+		free_io_failure(inode, failrec, did_repair);
 
 	return ret;
 }
@@ -3284,9 +3307,9 @@ int try_release_extent_state(struct exte
 		 * at this point we can safely clear everything except the
 		 * locked bit and the nodatasum bit
 		 */
-		ret = clear_extent_bit(tree, start, end,
-				 ~(EXTENT_LOCKED | EXTENT_NODATASUM),
-				 0, 0, NULL, mask);
+		ret = __clear_extent_bit(tree, start, end,
+					 ~(EXTENT_LOCKED | EXTENT_NODATASUM),
+					 0, 0, NULL, mask);
 
 		/* if clear_extent_bit failed for enomem reasons,
 		 * we can't allow the release to continue.
@@ -3868,9 +3891,9 @@ static int eb_straddles_pages(struct ext
 	return __eb_straddles_pages(eb->start, eb->len);
 }
 
-int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
-				struct extent_buffer *eb,
-				struct extent_state **cached_state)
+void clear_extent_buffer_uptodate(struct extent_io_tree *tree,
+				  struct extent_buffer *eb,
+				  struct extent_state **cached_state)
 {
 	unsigned long i;
 	struct page *page;
@@ -3888,7 +3911,6 @@ int clear_extent_buffer_uptodate(struct
 		if (page)
 			ClearPageUptodate(page);
 	}
-	return 0;
 }
 
 int set_extent_buffer_uptodate(struct extent_io_tree *tree,
Index: linux-3.0-SLE11-SP2/fs/btrfs/extent_io.h
===================================================================
--- linux-3.0-SLE11-SP2.orig/fs/btrfs/extent_io.h	2011-11-21 14:12:50.000000000 -0500
+++ linux-3.0-SLE11-SP2/fs/btrfs/extent_io.h	2011-11-21 14:21:24.000000000 -0500
@@ -200,11 +200,11 @@ u64 count_range_bits(struct extent_io_tr
 void free_extent_state(struct extent_state *state);
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   int bits, int filled, struct extent_state *cached_state);
-int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		      int bits, gfp_t mask);
-int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, int wake, int delete, struct extent_state **cached,
-		     gfp_t mask);
+void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
+		       int bits, gfp_t mask);
+void clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		      int bits, int wake, int delete,
+		      struct extent_state **cached, gfp_t mask);
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
@@ -216,8 +216,8 @@ int set_extent_new(struct extent_io_tree
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask);
-int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-		       gfp_t mask);
+void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
+			gfp_t mask);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
@@ -292,9 +292,9 @@ int set_extent_buffer_dirty(struct exten
 			     struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_io_tree *tree,
 			       struct extent_buffer *eb);
-int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
-				struct extent_buffer *eb,
-				struct extent_state **cached_state);
+void clear_extent_buffer_uptodate(struct extent_io_tree *tree,
+				  struct extent_buffer *eb,
+				  struct extent_state **cached_state);
 int extent_buffer_uptodate(struct extent_io_tree *tree,
 			   struct extent_buffer *eb,
 			   struct extent_state *cached_state);
@@ -304,10 +304,10 @@ int map_private_extent_buffer(struct ext
 		      unsigned long *map_len);
 int extent_range_uptodate(struct extent_io_tree *tree,
 			  u64 start, u64 end);
-int extent_clear_unlock_delalloc(struct inode *inode,
-				struct extent_io_tree *tree,
-				u64 start, u64 end, struct page *locked_page,
-				unsigned long op);
+void extent_clear_unlock_delalloc(struct inode *inode,
+				  struct extent_io_tree *tree,
+				  u64 start, u64 end, struct page *locked_page,
+				  unsigned long op);
 struct bio *
 btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags);



