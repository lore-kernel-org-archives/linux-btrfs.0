From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 17/99] btrfs: set_extent_bit: split exclusive mode out
Date: Wed, 23 Nov 2011 19:35:50 -0500
Message-ID: <20111124004221.787468992@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 There are many callers of set_extent_bit but the exclusive_bits argument
 is only used by lock_extent and try_lock_extent.

 This patch eliminates the exclusive_bits argument from set_extent_bit and
 creates a new set_extent_bit_excl for use from the locking functions.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   44 +++++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h |    7 ++++++-
 fs/btrfs/inode.c     |    2 +-
 3 files changed, 38 insertions(+), 15 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -757,9 +757,10 @@ static void uncache_state(struct extent_
  * [start, end] is inclusive This takes the tree lock.
  */
 
-int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int exclusive_bits, u64 *failed_start,
-		   struct extent_state **cached_state, gfp_t mask)
+static int __must_check
+__set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		 int bits, int exclusive_bits, u64 *failed_start,
+		 struct extent_state **cached_state, gfp_t mask)
 {
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
@@ -952,6 +953,22 @@ search_again:
 	goto again;
 }
 
+int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
+		   u64 *failed_start, struct extent_state **cached_state,
+		   gfp_t mask)
+{
+	return __set_extent_bit(tree, start, end, bits, 0,
+				failed_start, cached_state, mask);
+}
+
+int set_extent_bit_excl(struct extent_io_tree *tree, u64 start, u64 end,
+			int bits, int exclusive_bits, u64 *failed_start,
+			struct extent_state **cached_state, gfp_t mask)
+{
+	return __set_extent_bit(tree, start, end, bits, exclusive_bits,
+				failed_start, cached_state, mask);
+}
+
 /**
  * convert_extent - convert all bits in a given range from one bit to another
  * @tree:	the io tree to search
@@ -1141,14 +1158,14 @@ search_again:
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_DIRTY, 0, NULL,
+	return set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL,
 			      NULL, mask);
 }
 
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, bits, 0, NULL,
+	return set_extent_bit(tree, start, end, bits, NULL,
 			      NULL, mask);
 }
 
@@ -1170,7 +1187,7 @@ int set_extent_delalloc(struct extent_io
 {
 	return set_extent_bit(tree, start, end,
 			      EXTENT_DELALLOC | EXTENT_UPTODATE,
-			      0, NULL, cached_state, mask);
+			      NULL, cached_state, mask);
 }
 
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
@@ -1182,14 +1199,14 @@ void clear_extent_dirty(struct extent_io
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_NEW, 0, NULL,
+	return set_extent_bit(tree, start, end, EXTENT_NEW, NULL,
 			      NULL, mask);
 }
 
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_UPTODATE, 0,
+	return set_extent_bit(tree, start, end, EXTENT_UPTODATE,
 			      NULL, cached_state, mask);
 }
 
@@ -1210,9 +1227,9 @@ int lock_extent_bits(struct extent_io_tr
 	int err;
 	u64 failed_start;
 	while (1) {
-		err = set_extent_bit(tree, start, end, EXTENT_LOCKED | bits,
-				     EXTENT_LOCKED, &failed_start,
-				     cached_state, mask);
+		err = set_extent_bit_excl(tree, start, end,
+					  EXTENT_LOCKED | bits, EXTENT_LOCKED,
+					  &failed_start, cached_state, mask);
 		if (err == -EEXIST && (mask & __GFP_WAIT)) {
 			wait_extent_bit(tree, failed_start, end, EXTENT_LOCKED);
 			start = failed_start;
@@ -1234,8 +1251,9 @@ int try_lock_extent(struct extent_io_tre
 	int err;
 	u64 failed_start;
 
-	err = set_extent_bit(tree, start, end, EXTENT_LOCKED, EXTENT_LOCKED,
-			     &failed_start, NULL, GFP_NOFS);
+	err = set_extent_bit_excl(tree, start, end, EXTENT_LOCKED,
+				  EXTENT_LOCKED, &failed_start, NULL,
+				  GFP_NOFS);
 	if (err == -EEXIST) {
 		if (failed_start > start)
 			clear_extent_bit(tree, start, failed_start - 1,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -222,8 +222,13 @@ int __must_check __set_extent_bit(struct
		      struct extent_state **cached);
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
		    int bits, gfp_t mask);
+int __must_check set_extent_bit_excl(struct extent_io_tree *tree, u64 start,
+				     u64 end, int bits, int exclusive_bits,
+				     u64 *failed_start,
+				     struct extent_state **cached_state,
+				     gfp_t mask);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int exclusive_bits, u64 *failed_start,
+		   int bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6091,7 +6091,7 @@ static ssize_t btrfs_direct_IO(int rw, s
 	if (writing) {
 		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
 		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     EXTENT_DELALLOC, 0, NULL, &cached_state,
+				     EXTENT_DELALLOC, NULL, &cached_state,
 				     GFP_NOFS);
 		if (ret) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,


