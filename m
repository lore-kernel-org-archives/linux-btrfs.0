From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: delalloc for page dirtied out-of-band in fixup worker
Date: Fri, 27 Jan 2012 11:30:44 -0500
Message-ID: <4F22D134.4010505@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We encountered an issue that was easily observable on s/390 systems but
could really happen anywhere. The timing just seemed to hit reliably
on s/390 with limited memory.

The gist is that when an unexpected set_page_dirty() happened, we'd
run into the BUG() in btrfs_writepage_fixup_worker since it wasn't
properly set up for delalloc.

This patch does the following:
- Performs the missing delalloc in the fixup worker
- Allow the start hook to return -EBUSY which informs __extent_writepage
  that it should mark the page skipped and not to redirty it. This is
  required since the fixup worker can fail with -ENOSPC and the page
  will have already been redirtied. That causes an Oops in
  drop_outstanding_extents later. Retrying the fixup worker could
  lead to an infinite loop. Deferring the page redirty also saves us
  some cycles since the page would be stuck in a resubmit-redirty loop
  until the fixup worker completes. It's not harmful, just wasteful.
- If the fixup worker fails, we mark the page and mapping as errored,
  and end the writeback, similar to what we would do had the page
  actually been submitted to writeback.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   65 +++++++++++++++++++++++++++++++--------------------
 fs/btrfs/extent_io.h |    1 
 fs/btrfs/inode.c     |   13 ++++++++--
 3 files changed, 52 insertions(+), 27 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2161,6 +2161,38 @@ static int bio_readpage_error(struct bio
 
 /* lots and lots of room for performance fixes in the end_bio funcs */
 
+int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
+{
+	int uptodate = (err == 0);
+	struct extent_io_tree *tree;
+	int ret;
+
+	tree = &BTRFS_I(page->mapping->host)->io_tree;
+
+	if (tree->ops && tree->ops->writepage_end_io_hook) {
+		ret = tree->ops->writepage_end_io_hook(page, start,
+					       end, NULL, uptodate);
+		if (ret)
+			uptodate = 0;
+	}
+
+	if (!uptodate && tree->ops &&
+	    tree->ops->writepage_io_failed_hook) {
+		ret = tree->ops->writepage_io_failed_hook(NULL, page,
+						 start, end, NULL);
+		/* Writeback already completed */
+		if (ret == 0)
+			return 1;
+	}
+
+	if (!uptodate) {
+		clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
+		ClearPageUptodate(page);
+		SetPageError(page);
+	}
+	return 0;
+}
+
 /*
  * after a writepage IO is done, we need to:
  * clear the uptodate bits on error
@@ -2172,13 +2204,11 @@ static int bio_readpage_error(struct bio
  */
 static void end_bio_extent_writepage(struct bio *bio, int err)
 {
-	int uptodate = err == 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
 	int whole_page;
-	int ret;
 
 	do {
 		struct page *page = bvec->bv_page;
@@ -2195,28 +2225,9 @@ static void end_bio_extent_writepage(str
 
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
-		if (tree->ops && tree->ops->writepage_end_io_hook) {
-			ret = tree->ops->writepage_end_io_hook(page, start,
-						       end, NULL, uptodate);
-			if (ret)
-				uptodate = 0;
-		}
 
-		if (!uptodate && tree->ops &&
-		    tree->ops->writepage_io_failed_hook) {
-			ret = tree->ops->writepage_io_failed_hook(bio, page,
-							 start, end, NULL);
-			if (ret == 0) {
-				uptodate = (err == 0);
-				continue;
-			}
-		}
-
-		if (!uptodate) {
-			clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
-			ClearPageUptodate(page);
-			SetPageError(page);
-		}
+		if (end_extent_writepage(page, err, start, end))
+			continue;
 
 		if (whole_page)
 			end_page_writeback(page);
@@ -2818,8 +2829,12 @@ static int __extent_writepage(struct pag
 	if (tree->ops && tree->ops->writepage_start_hook) {
 		ret = tree->ops->writepage_start_hook(page, start,
 						      page_end);
-		if (ret == -EAGAIN) {
-			redirty_page_for_writepage(wbc, page);
+		if (ret) {
+			/* Fixup worker will requeue */
+			if (ret == -EBUSY)
+				wbc->pages_skipped++;
+			else
+				redirty_page_for_writepage(wbc, page);
 			update_nr_written(page, wbc, nr_written);
 			unlock_page(page);
 			ret = 0;
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -319,4 +319,5 @@ struct btrfs_mapping_tree;
 int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 			u64 length, u64 logical, struct page *page,
 			int mirror_num);
+int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 #endif
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1555,6 +1555,7 @@ static void btrfs_writepage_fixup_worker
 	struct inode *inode;
 	u64 page_start;
 	u64 page_end;
+	int ret;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
@@ -1585,9 +1586,17 @@ again:
 		goto again;
 	}
 
-	BUG();
+	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	if (ret) {
+		mapping_set_error(page->mapping, ret);
+		end_extent_writepage(page, ret, page_start, page_end);
+		ClearPageChecked(page);
+		goto out;
+	 }
+
 	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
 	ClearPageChecked(page);
+	set_page_dirty(page);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			     &cached_state, GFP_NOFS);
@@ -1630,7 +1639,7 @@ static int btrfs_writepage_start_hook(st
 	fixup->work.func = btrfs_writepage_fixup_worker;
 	fixup->page = page;
 	btrfs_queue_worker(&root->fs_info->fixup_workers, &fixup->work);
-	return -EAGAIN;
+	return -EBUSY;
 }
 
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
-- 
Jeff Mahoney
SUSE Labs
