From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 25/99] btrfs: set_extent_bit can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:58 -0500
Message-ID: <20111124004222.714080404@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that all of the callers of set_extent_bit use GFP_NOFS and
 all callers of set_extent_bit_atomic use GFP_ATOMIC, we can
 drop the gfp_t argument to both.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   35 +++++++++++++++--------------------
 fs/btrfs/extent_io.h |    9 +++------
 fs/btrfs/inode.c     |    2 +-
 3 files changed, 19 insertions(+), 27 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -960,30 +960,28 @@ search_again:
 
 int set_extent_bit_atomic(struct extent_io_tree *tree, u64 start, u64 end,
 			  int bits, u64 *failed_start,
-			  struct extent_state **cached_state, gfp_t mask)
+			  struct extent_state **cached_state)
 {
-	WARN_ON(mask & __GFP_WAIT);
 	return __set_extent_bit(tree, start, end, bits, 0, failed_start,
-				cached_state, mask);
+				cached_state, GFP_ATOMIC);
 }
 
 void set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
-		    u64 *failed_start, struct extent_state **cached_state,
-		    gfp_t mask)
+		    u64 *failed_start, struct extent_state **cached_state)
 {
 	int ret;
-	WARN_ON(!(mask & __GFP_WAIT));
+	might_sleep();
 	ret = __set_extent_bit(tree, start, end, bits, 0,
-			       failed_start, cached_state, mask);
+			       failed_start, cached_state, GFP_NOFS);
 	BUG_ON(ret < 0);
 }
 
 int set_extent_bit_excl(struct extent_io_tree *tree, u64 start, u64 end,
 			int bits, int exclusive_bits, u64 *failed_start,
-			struct extent_state **cached_state, gfp_t mask)
+			struct extent_state **cached_state)
 {
 	return __set_extent_bit(tree, start, end, bits, exclusive_bits,
-				failed_start, cached_state, mask);
+				failed_start, cached_state, GFP_NOFS);
 }
 
 /**
@@ -1174,12 +1172,12 @@ search_again:
 /* wrappers around set/clear extent bit */
 void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL, NULL, GFP_NOFS);
+	set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL, NULL);
 }
 
 void set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 {
-	set_extent_bit(tree, start, end, bits, NULL, NULL, GFP_NOFS);
+	set_extent_bit(tree, start, end, bits, NULL, NULL);
 }
 
 void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1199,7 +1197,7 @@ void set_extent_delalloc(struct extent_i
 			 struct extent_state **cached_state)
 {
 	set_extent_bit(tree, start, end, EXTENT_DELALLOC | EXTENT_UPTODATE,
-		       NULL, cached_state, GFP_NOFS);
+		       NULL, cached_state);
 }
 
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
@@ -1210,21 +1208,20 @@ void clear_extent_dirty(struct extent_io
 
 void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	set_extent_bit(tree, start, end, EXTENT_NEW, NULL, NULL, GFP_NOFS);
+	set_extent_bit(tree, start, end, EXTENT_NEW, NULL, NULL);
 }
 
 int set_extent_uptodate_atomic(struct extent_io_tree *tree, u64 start, u64 end,
 			       struct extent_state **cached_state)
 {
 	return set_extent_bit_atomic(tree, start, end, EXTENT_UPTODATE, NULL,
-				     cached_state, GFP_ATOMIC);
+				     cached_state);
 }
 
 void set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached_state)
 {
-	set_extent_bit(tree, start, end, EXTENT_UPTODATE, NULL, cached_state,
-		       GFP_NOFS);
+	set_extent_bit(tree, start, end, EXTENT_UPTODATE, NULL, cached_state);
 }
 
 static void clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
@@ -1246,8 +1243,7 @@ int lock_extent_bits(struct extent_io_tr
 	while (1) {
 		err = set_extent_bit_excl(tree, start, end,
 					  EXTENT_LOCKED | bits, EXTENT_LOCKED,
-					  &failed_start, cached_state,
-					  GFP_NOFS);
+					  &failed_start, cached_state);
 		if (err == -EEXIST) {
 			wait_extent_bit(tree, failed_start, end, EXTENT_LOCKED);
 			start = failed_start;
@@ -1270,8 +1266,7 @@ int try_lock_extent(struct extent_io_tre
 	u64 failed_start;
 
 	err = set_extent_bit_excl(tree, start, end, EXTENT_LOCKED,
-				  EXTENT_LOCKED, &failed_start, NULL,
-				  GFP_NOFS);
+				  EXTENT_LOCKED, &failed_start, NULL);
 	if (err == -EEXIST) {
 		if (failed_start > start)
 			clear_extent_bit(tree, start, failed_start - 1,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -220,15 +220,12 @@ void set_extent_bits(struct extent_io_tr
 int __must_check set_extent_bit_excl(struct extent_io_tree *tree, u64 start,
 				     u64 end, int bits, int exclusive_bits,
 				     u64 *failed_start,
-				     struct extent_state **cached_state,
-				     gfp_t mask);
+				     struct extent_state **cached_state);
 int __must_check set_extent_bit_atomic(struct extent_io_tree *tree, u64 start,
 				       u64 end, int bits, u64 *failed_start,
-				       struct extent_state **cached_state,
-				       gfp_t mask);
+				       struct extent_state **cached_state);
 void set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
-		    u64 *failed_start, struct extent_state **cached_state,
-		    gfp_t mask);
+		    u64 *failed_start, struct extent_state **cached_state);
 int __must_check set_extent_uptodate_atomic(struct extent_io_tree *tree,
 					    u64 start, u64 end,
 					    struct extent_state **cached_state);
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6083,7 +6083,7 @@ static ssize_t btrfs_direct_IO(int rw, s
 	if (writing) {
 		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
 		set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-			       EXTENT_DELALLOC, NULL, &cached_state, GFP_NOFS);
+			       EXTENT_DELALLOC, NULL, &cached_state);
 	}
 
 	free_extent_state(cached_state);


