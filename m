From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 21/65] btrfs: check_page_writeback should return void
Date: Mon, 03 Oct 2011 23:22:51 -0400
Message-ID: <20111004032302.331690987@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 check_page_writeback has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1641,11 +1641,10 @@ static void check_page_locked(struct ext
  * helper function to end page writeback if all the extents
  * in the tree for that page are done with writeback
  */
-static int check_page_writeback(struct extent_io_tree *tree,
-			     struct page *page)
+static void check_page_writeback(struct extent_io_tree *tree,
+				 struct page *page)
 {
 	end_page_writeback(page);
-	return 0;
 }
 
 /* lots and lots of room for performance fixes in the end_bio funcs */


