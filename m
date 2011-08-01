From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't call writepages from within write_full_page
Date: Mon,  1 Aug 2011 14:44:03 -0400
Message-ID: <1312224243-16454-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When doing a writepage we call writepages to try and write out any other dirty
pages in the area.  This could cause problems where we commit a transaction and
then have somebody else dirtying metadata in the area as we could end up writing
out a lot more than we care about, which could cause latency on anybody who is
waiting for the transaction to completely finish committing.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e16dcbf..6e72b50 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2550,7 +2550,6 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 			  struct writeback_control *wbc)
 {
 	int ret;
-	struct address_space *mapping = page->mapping;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
@@ -2558,17 +2557,9 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
-	struct writeback_control wbc_writepages = {
-		.sync_mode	= wbc->sync_mode,
-		.nr_to_write	= 64,
-		.range_start	= page_offset(page) + PAGE_CACHE_SIZE,
-		.range_end	= (loff_t)-1,
-	};
 
 	ret = __extent_writepage(page, wbc, &epd);
 
-	extent_write_cache_pages(tree, mapping, &wbc_writepages,
-				 __extent_writepage, &epd, flush_write_bio);
 	flush_epd_write_bio(&epd);
 	return ret;
 }
-- 
1.7.5.2

