From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: complete page writeback before doing ordered extents
Date: Mon, 23 Apr 2012 13:33:44 -0400
Message-ID: <1335202424-7135-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We can deadlock waiting for pages to end writeback because we are doing an
allocation while hold a tree lock since the ordered extent stuff will
require tree locks.  A quick easy way to fix this is to end page writeback
before we do our ordered io stuff, which works fine since we don't really
need the page for this to work.  Eventually we want to make this work happen
as soon as the io is completed and then push the ordered extent stuff off to
a worker thread, but at this stage we need this deadlock fixed with changing
as little as possible.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/compression.c  |    3 +--
 fs/btrfs/extent_io.c    |   27 +++++++++++----------------
 fs/btrfs/ordered-data.c |    4 +++-
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d11afa67..6a456d4 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -286,13 +286,12 @@ static void end_compressed_bio_write(struct bio *bio, int err)
 	inode = cb->inode;
 	tree = &BTRFS_I(inode)->io_tree;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
+	end_compressed_writeback(inode, cb->start, cb->len);
 	tree->ops->writepage_end_io_hook(cb->compressed_pages[0],
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL, 1);
 	cb->compressed_pages[0]->mapping = NULL;
-
-	end_compressed_writeback(inode, cb->start, cb->len);
 	/* note, our inode could be gone now */
 
 	/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7c501d3..308c1c2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1806,16 +1806,6 @@ static void check_page_locked(struct extent_io_tree *tree, struct page *page)
 }
 
 /*
- * helper function to end page writeback if all the extents
- * in the tree for that page are done with writeback
- */
-static void check_page_writeback(struct extent_io_tree *tree,
-				 struct page *page)
-{
-	end_page_writeback(page);
-}
-
-/*
  * When IO fails, either with EIO or csum verification fails, we
  * try other mirrors that might have a good copy of the data.  This
  * io_failure_record is used to record state as we go through all the
@@ -2206,6 +2196,13 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	struct extent_io_tree *tree;
 	int ret;
 
+	/*
+	 * Don't want the page disappearing out from under us after we clear
+	 * writeback.
+	 */
+	page_cache_get(page);
+	end_page_writeback(page);
+
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
 	if (tree->ops && tree->ops->writepage_end_io_hook) {
@@ -2220,8 +2217,10 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 		ret = tree->ops->writepage_io_failed_hook(NULL, page,
 						 start, end, NULL);
 		/* Writeback already completed */
-		if (ret == 0)
+		if (ret == 0) {
+			page_cache_release(page);
 			return 1;
+		}
 	}
 
 	if (!uptodate) {
@@ -2229,6 +2228,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 		ClearPageUptodate(page);
 		SetPageError(page);
 	}
+	page_cache_release(page);
 	return 0;
 }
 
@@ -2267,11 +2267,6 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 
 		if (end_extent_writepage(page, err, start, end))
 			continue;
-
-		if (whole_page)
-			end_page_writeback(page);
-		else
-			check_page_writeback(tree, page);
 	} while (bvec >= bio->bi_io_vec);
 
 	bio_put(bio);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index bbf6d0d..acfb360 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -196,7 +196,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->len = len;
 	entry->disk_len = disk_len;
 	entry->bytes_left = len;
-	entry->inode = inode;
+	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
@@ -399,6 +399,8 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 	trace_btrfs_ordered_extent_put(entry->inode, entry);
 
 	if (atomic_dec_and_test(&entry->refs)) {
+		if (entry->inode)
+			btrfs_add_delayed_iput(entry->inode);
 		while (!list_empty(&entry->list)) {
 			cur = entry->list.next;
 			sum = list_entry(cur, struct btrfs_ordered_sum, list);
-- 
1.7.7.6

