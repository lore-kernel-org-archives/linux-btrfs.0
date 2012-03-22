From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 17/35] btrfs: split extent_state ops
Date: Wed, 21 Mar 2012 21:11:21 -0400
Message-ID: <20120322011135.373316482@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 set_extent_bit can do exclusive locking but only when called by lock_extent*,

 Drop the exclusive bits argument except when called by lock_extent.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   36 +++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h |    2 +-
 fs/btrfs/inode.c     |    2 +-
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0112c02..ffa7cc3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -721,9 +721,10 @@ static void uncache_state(struct extent_state **cached_ptr)
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
@@ -917,6 +918,15 @@ search_again:
 	goto again;
 }
 
+int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
+		   u64 *failed_start, struct extent_state **cached_state,
+		   gfp_t mask)
+{
+	return __set_extent_bit(tree, start, end, bits, 0, failed_start,
+				cached_state, mask);
+}
+
+
 /**
  * convert_extent - convert all bits in a given range from one bit to another
  * @tree:	the io tree to search
@@ -1111,14 +1121,14 @@ search_again:
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
 
@@ -1133,7 +1143,7 @@ int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 {
 	return set_extent_bit(tree, start, end,
 			      EXTENT_DELALLOC | EXTENT_UPTODATE,
-			      0, NULL, cached_state, mask);
+			      NULL, cached_state, mask);
 }
 
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1147,7 +1157,7 @@ int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_NEW, 0, NULL,
+	return set_extent_bit(tree, start, end, EXTENT_NEW, NULL,
 			      NULL, mask);
 }
 
@@ -1155,7 +1165,7 @@ int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask)
 {
 	return set_extent_bit(tree, start, end, EXTENT_UPTODATE, 0,
-			      NULL, cached_state, mask);
+			      cached_state, mask);
 }
 
 static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
@@ -1176,9 +1186,9 @@ int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 	int err;
 	u64 failed_start;
 	while (1) {
-		err = set_extent_bit(tree, start, end, EXTENT_LOCKED | bits,
-				     EXTENT_LOCKED, &failed_start,
-				     cached_state, GFP_NOFS);
+		err = __set_extent_bit(tree, start, end, EXTENT_LOCKED | bits,
+				       EXTENT_LOCKED, &failed_start,
+				       cached_state, GFP_NOFS);
 		if (err == -EEXIST) {
 			wait_extent_bit(tree, failed_start, end, EXTENT_LOCKED);
 			start = failed_start;
@@ -1199,8 +1209,8 @@ int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 	int err;
 	u64 failed_start;
 
-	err = set_extent_bit(tree, start, end, EXTENT_LOCKED, EXTENT_LOCKED,
-			     &failed_start, NULL, GFP_NOFS);
+	err = __set_extent_bit(tree, start, end, EXTENT_LOCKED, EXTENT_LOCKED,
+			       &failed_start, NULL, GFP_NOFS);
 	if (err == -EEXIST) {
 		if (failed_start > start)
 			clear_extent_bit(tree, start, failed_start - 1,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 439e183..3a171c2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -209,7 +209,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int exclusive_bits, u64 *failed_start,
+		   int bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d16bf3f..593a2c3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6233,7 +6233,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	if (writing) {
 		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
 		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     EXTENT_DELALLOC, 0, NULL, &cached_state,
+				     EXTENT_DELALLOC, NULL, &cached_state,
 				     GFP_NOFS);
 		if (ret) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-- 
1.7.9



