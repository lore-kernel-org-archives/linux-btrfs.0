From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 42/99] btrfs: check_page_writeback should return void
Date: Wed, 23 Nov 2011 19:36:15 -0500
Message-ID: <20111124004224.679869000@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
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
@@ -1829,11 +1829,10 @@ static void check_page_locked(struct ext
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
 
 /*



