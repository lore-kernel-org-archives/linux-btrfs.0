From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 36/99] btrfs: set_range_writeback should return void
Date: Wed, 23 Nov 2011 19:36:09 -0500
Message-ID: <20111124004223.986519243@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 set_range_writeback has no error conditions and should return void.
 Its callers already ignore the error code anyway.

 There are internal error conditions but they are fatal and will cause
 a panic.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1253,7 +1253,7 @@ int unlock_extent(struct extent_io_tree
 /*
  * helper function to set both pages and extents in the tree writeback
  */
-static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
+static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
@@ -1261,12 +1261,14 @@ static int set_range_writeback(struct ex
 
 	while (index <= end_index) {
 		page = find_get_page(tree->mapping, index);
-		BUG_ON(!page);
+		if (!page)
+			btrfs_panic(tree_fs_info(tree), -ENOENT,
+				    "Page not found in extent io tree at "
+				    "offset %llu", index << PAGE_CACHE_SHIFT);
 		set_page_writeback(page);
 		page_cache_release(page);
 		index++;
 	}
-	return 0;
 }
 
 /* find the first state struct with 'bits' set after 'start', and



