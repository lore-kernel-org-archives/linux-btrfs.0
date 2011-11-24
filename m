From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 40/99] btrfs: check_page_uptodate should return void
Date: Wed, 23 Nov 2011 19:36:13 -0500
Message-ID: <20111124004224.449351118@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 check_page_uptodate has no error conditions and should return void. Its
 callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1805,14 +1805,12 @@ int test_range_bit(struct extent_io_tree
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static int check_page_uptodate(struct extent_io_tree *tree,
-			       struct page *page)
+static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 {
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
 		SetPageUptodate(page);
-	return 0;
 }
 
 /*



