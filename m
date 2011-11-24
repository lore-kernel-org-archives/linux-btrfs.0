From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 24/99] btrfs: set_extent_uptodate can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:57 -0500
Message-ID: <20111124004222.598496904@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that all of the callers of set_extent_uptodate use GFP_NOFS or
 GFP_ATOMIC, we can drop the gfp_t argument entirely and allow
 set_extent_uptodate to always pass GFP_NOFS to set_extent_bit or
 GFP_ATOMIC to set_extent_bit_atomic.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are uptodate callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   16 ++++++++--------
 fs/btrfs/extent_io.h |    5 ++---
 fs/btrfs/inode.c     |    2 +-
 3 files changed, 11 insertions(+), 12 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1214,17 +1214,17 @@ void set_extent_new(struct extent_io_tre
 }
 
 int set_extent_uptodate_atomic(struct extent_io_tree *tree, u64 start, u64 end,
-			       struct extent_state **cached_state, gfp_t mask)
+			       struct extent_state **cached_state)
 {
 	return set_extent_bit_atomic(tree, start, end, EXTENT_UPTODATE, NULL,
-				     cached_state, mask);
+				     cached_state, GFP_ATOMIC);
 }
 
 void set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
-			 struct extent_state **cached_state, gfp_t mask)
+			 struct extent_state **cached_state)
 {
 	set_extent_bit(tree, start, end, EXTENT_UPTODATE, NULL, cached_state,
-		       mask);
+		       GFP_NOFS);
 }
 
 static void clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
@@ -2391,7 +2391,7 @@ static void end_bio_extent_readpage(stru
 
 		if (uptodate) {
 			ret = set_extent_uptodate_atomic(tree, start, end,
-							 &cached, GFP_ATOMIC);
+							 &cached);
 			BUG_ON(ret < 0);
 		}
 		ret = unlock_extent_cached_atomic(tree, start, end, &cached);
@@ -2617,7 +2617,7 @@ static int __extent_read_full_page(struc
 			flush_dcache_page(page);
 			kunmap_atomic(userpage, KM_USER0);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+					    &cached);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
 					     &cached);
 			break;
@@ -2667,7 +2667,7 @@ static int __extent_read_full_page(struc
 			kunmap_atomic(userpage, KM_USER0);
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+					    &cached);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
 			                     &cached);
 			cur = cur + iosize;
@@ -3937,7 +3937,7 @@ int set_extent_buffer_uptodate(struct ex
 
 	if (eb_straddles_pages(eb))
 		set_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
-				    NULL, GFP_NOFS);
+				    NULL);
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if ((i == 0 && (eb->start & (PAGE_CACHE_SIZE - 1))) ||
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -231,10 +231,9 @@ void set_extent_bit(struct extent_io_tre
 		    gfp_t mask);
 int __must_check set_extent_uptodate_atomic(struct extent_io_tree *tree,
 					    u64 start, u64 end,
-					    struct extent_state **cached_state,
-					    gfp_t mask);
+					    struct extent_state **cached_state);
 void set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
-			 struct extent_state **cached_state, gfp_t mask);
+			 struct extent_state **cached_state);
 void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end);
 void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5021,7 +5021,7 @@ again:
 			btrfs_mark_buffer_dirty(leaf);
 		}
 		set_extent_uptodate(io_tree, em->start,
-				    extent_map_end(em) - 1, NULL, GFP_NOFS);
+				    extent_map_end(em) - 1, NULL);
 		goto insert;
 	} else {
 		printk(KERN_ERR "btrfs unknown found_type %d\n", found_type);


