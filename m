From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 20/66] btrfs: check_page_uptodate should return void
Date: Mon, 24 Oct 2011 21:02:56 -0400
Message-ID: <20111025010852.863654138@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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


