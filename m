From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: tag pages for writeback in sync
Date: Fri, 15 Jul 2011 17:26:38 -0400
Message-ID: <1310765198-10077-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Everybody else does this, we need to do it too.  If we're syncing, we need to
tag the pages we're going to write for writeback so we don't end up writing the
same stuff over and over again if somebody is constantly redirtying our file.
This will keep us from having latencies with heavy sync workloads.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9a43a96..9db9b0b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2516,6 +2516,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
+	int tag;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
@@ -2526,11 +2527,16 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		scanned = 1;
 	}
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		tag = PAGECACHE_TAG_TOWRITE;
+	else
+		tag = PAGECACHE_TAG_DIRTY;
 retry:
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		tag_pages_for_writeback(mapping, index, end);
 	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			      PAGECACHE_TAG_DIRTY, min(end - index,
-				  (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
 		scanned = 1;
-- 
1.7.5.2

