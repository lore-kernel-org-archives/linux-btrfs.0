From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 10/99] btrfs: Split unlock_extent_cached into sleeping and atomic versions
Date: Wed, 23 Nov 2011 19:35:43 -0500
Message-ID: <20111124004220.975651811@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 There are 28 callers of unlock_extent_cached that call it with GFP_NOFS
 and only 1 that calls it with GFP_ATOMIC (the bio_endio callback).

 Since unlock_extent_cached is a simple wrapper around clear_extent_bit,
 we can create a new unlock_extent_cached_atomic to handle the atomic case
 and let unlock_extent_cached return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/btrfs/extent_io.c |   19 ++++++++++++++-----
 fs/btrfs/extent_io.h |    8 ++++++--
 2 files changed, 20 insertions(+), 7 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1259,11 +1259,18 @@ int try_lock_extent(struct extent_io_tre
 	return 1;
 }
 
-int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
-			 struct extent_state **cached, gfp_t mask)
+void unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
+			  struct extent_state **cached, gfp_t mask)
 {
-	return __clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0,
-				  cached, mask);
+	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached, mask);
+}
+
+int unlock_extent_cached_atomic(struct extent_io_tree *tree, u64 start,
+				u64 end, struct extent_state **cached,
+				gfp_t mask)
+{
+	return clear_extent_bit_atomic(tree, start, end, EXTENT_LOCKED, 1, 0,
+				       cached, mask);
 }
 
 void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
@@ -2368,7 +2375,9 @@ static void end_bio_extent_readpage(stru
 			set_extent_uptodate(tree, start, end, &cached,
 					    GFP_ATOMIC);
 		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+		ret = unlock_extent_cached_atomic(tree, start, end,
+						  &cached, GFP_ATOMIC);
+		BUG_ON(ret < 0);
 
 		if (whole_page) {
 			if (uptodate) {
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -184,8 +184,12 @@ int lock_extent(struct extent_io_tree *t
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		     int bits, struct extent_state **cached, gfp_t mask);
 void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
-int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
-			 struct extent_state **cached, gfp_t mask);
+int __must_check unlock_extent_cached_atomic(struct extent_io_tree *tree,
+					     u64 start, u64 end,
+					     struct extent_state **cached,
+					     gfp_t mask);
+void unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
+			  struct extent_state **cached, gfp_t mask);
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 		    gfp_t mask);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,


