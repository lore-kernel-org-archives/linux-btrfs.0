From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 15/65] btrfs: set_range_writeback should return void
Date: Mon, 03 Oct 2011 23:22:45 -0400
Message-ID: <20111004032301.643053456@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
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
@@ -1060,7 +1060,7 @@ int unlock_extent(struct extent_io_tree
 /*
  * helper function to set both pages and extents in the tree writeback
  */
-static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
+static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
@@ -1068,12 +1068,14 @@ static int set_range_writeback(struct ex
 
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



