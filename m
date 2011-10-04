From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 20/65] btrfs: check_page_locked should return void
Date: Mon, 03 Oct 2011 23:22:50 -0400
Message-ID: <20111004032302.217031446@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 check_page_locked has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1630,14 +1630,12 @@ static void check_page_uptodate(struct e
  * helper function to unlock a page if all the extents in the tree
  * for that page are unlocked
  */
-static int check_page_locked(struct extent_io_tree *tree,
-			     struct page *page)
+static void check_page_locked(struct extent_io_tree *tree, struct page *page)
 {
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (!test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL))
 		unlock_page(page);
-	return 0;
 }
 
 /*


