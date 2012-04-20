From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: end writeback on pages before finishing ordered extents
Date: Fri, 20 Apr 2012 17:16:29 -0400
Message-ID: <1334956589-10638-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So we have a slight deadlock issue where somebody will be trying to make an
allocation while holding a tree lock and then be forced to wait while we
flush out data.  Well our flushers will then try to finish the ordered io
and get stuck on this lock and we will deadlock.  The thing is we don't
really need the pages to finish the ordered IO, so instead do the normal
data end io stuff in the interrupt context and end page writeback as soon as
possible, and then if the ordered extent is finished, schedule that to be
finished later on.  I had to add a bio flag so that the end io function
knows wether it is already in a thread or not so it knows wether it can make
allocations or not.  Also this doesn't happen for O_DIRECT, which I think is
ok but worst case scenario we can fix everybody to just shove ordered extent
completion off on a helper thread.  I ran this through xfstests and it
seemed to work, but its super dangerous so testing is highly encouraged.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/compression.c      |   12 ++++---
 fs/btrfs/disk-io.c          |   71 ++++++++++++++++++++++++++-----------------
 fs/btrfs/disk-io.h          |    2 +-
 fs/btrfs/extent_io.c        |   23 +++++++-------
 fs/btrfs/extent_io.h        |    8 ++++-
 fs/btrfs/free-space-cache.c |    4 +--
 fs/btrfs/inode.c            |   68 ++++++++++++++++++++++++++++++-----------
 fs/btrfs/ordered-data.c     |   51 ++++++++++++++++++-------------
 fs/btrfs/ordered-data.h     |    2 +
 include/linux/blk_types.h   |    2 +
 10 files changed, 154 insertions(+), 89 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d11afa67..9def84a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -270,6 +270,7 @@ static void end_compressed_bio_write(struct bio *bio, int err)
 	struct inode *inode;
 	struct page *page;
 	unsigned long index;
+	int async = test_bit(BIO_ASYNC_ENDIO, &bio->bi_flags);
 
 	if (err)
 		cb->errors = 1;
@@ -289,7 +290,7 @@ static void end_compressed_bio_write(struct bio *bio, int err)
 	tree->ops->writepage_end_io_hook(cb->compressed_pages[0],
 					 cb->start,
 					 cb->start + cb->len - 1,
-					 NULL, 1);
+					 NULL, 1, async);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb->start, cb->len);
@@ -390,7 +391,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			 * freed before we're done setting it up
 			 */
 			atomic_inc(&cb->pending_bios);
-			ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+			ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0, 1);
 			BUG_ON(ret); /* -ENOMEM */
 
 			if (!skip_sum) {
@@ -419,7 +420,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	}
 	bio_get(bio);
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0, 1);
 	BUG_ON(ret); /* -ENOMEM */
 
 	if (!skip_sum) {
@@ -660,7 +661,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		    PAGE_CACHE_SIZE) {
 			bio_get(comp_bio);
 
-			ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
+			ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0,
+						  1);
 			BUG_ON(ret); /* -ENOMEM */
 
 			/*
@@ -696,7 +698,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	}
 	bio_get(comp_bio);
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
+	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0, 1);
 	BUG_ON(ret); /* -ENOMEM */
 
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index eff59fa..21cb62e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -46,7 +46,6 @@
 #include "check-integrity.h"
 
 static struct extent_io_ops btree_extent_io_ops;
-static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
@@ -74,6 +73,7 @@ struct end_io_wq {
 	struct btrfs_fs_info *info;
 	int error;
 	int metadata;
+	int noasync;
 	struct list_head list;
 	struct btrfs_work work;
 };
@@ -658,6 +658,32 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	return -EIO;	/* we fixed nothing */
 }
 
+/*
+ * called by the kthread helper functions to finally call the bio end_io
+ * functions.  This is where read checksum verification actually happens
+ */
+static void end_data_write_io(struct end_io_wq *end_io_wq)
+{
+	struct bio *bio;
+	int error;
+
+	bio = end_io_wq->bio;
+
+	error = end_io_wq->error;
+	bio->bi_private = end_io_wq->private;
+	bio->bi_end_io = end_io_wq->end_io;
+	kfree(end_io_wq);
+	bio_endio(bio, error);
+}
+
+static void end_workqueue_fn(struct btrfs_work *work)
+{
+	struct end_io_wq *end_io_wq;
+
+	end_io_wq = container_of(work, struct end_io_wq, work);
+	end_data_write_io(end_io_wq);
+}
+
 static void end_workqueue_bio(struct bio *bio, int err)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
@@ -669,15 +695,23 @@ static void end_workqueue_bio(struct bio *bio, int err)
 	end_io_wq->work.flags = 0;
 
 	if (bio->bi_rw & REQ_WRITE) {
-		if (end_io_wq->metadata == 1)
+		if (end_io_wq->metadata == 1) {
 			btrfs_queue_worker(&fs_info->endio_meta_write_workers,
 					   &end_io_wq->work);
-		else if (end_io_wq->metadata == 2)
+		} else if (end_io_wq->metadata == 2) {
+			set_bit(BIO_ASYNC_ENDIO, &bio->bi_flags);
 			btrfs_queue_worker(&fs_info->endio_freespace_worker,
 					   &end_io_wq->work);
-		else
+		} else if (err || !end_io_wq->noasync) {
+			/* Indicate we are ending this io asynchronously so we
+			 * know it's ok to make allocations and such.
+			 */
+			set_bit(BIO_ASYNC_ENDIO, &bio->bi_flags);
 			btrfs_queue_worker(&fs_info->endio_write_workers,
 					   &end_io_wq->work);
+		} else {
+			end_data_write_io(end_io_wq);
+		}
 	} else {
 		if (end_io_wq->metadata)
 			btrfs_queue_worker(&fs_info->endio_meta_workers,
@@ -694,9 +728,11 @@ static void end_workqueue_bio(struct bio *bio, int err)
  * 0 - if data
  * 1 - if normal metadta
  * 2 - if writing to the free space cache area
+ *
+ * set noasync if you can handle finishing your endio in interrupt context.
  */
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
-			int metadata)
+			int metadata, int noasync)
 {
 	struct end_io_wq *end_io_wq;
 	end_io_wq = kmalloc(sizeof(*end_io_wq), GFP_NOFS);
@@ -709,6 +745,7 @@ int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 	end_io_wq->error = 0;
 	end_io_wq->bio = bio;
 	end_io_wq->metadata = metadata;
+	end_io_wq->noasync = noasync;
 
 	bio->bi_private = end_io_wq;
 	bio->bi_end_io = end_workqueue_bio;
@@ -874,7 +911,7 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		 * can happen in the async kernel threads
 		 */
 		ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info,
-					  bio, 1);
+					  bio, 1, 0);
 		if (ret)
 			return ret;
 		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
@@ -1500,28 +1537,6 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 	return 0;
 }
 
-/*
- * called by the kthread helper functions to finally call the bio end_io
- * functions.  This is where read checksum verification actually happens
- */
-static void end_workqueue_fn(struct btrfs_work *work)
-{
-	struct bio *bio;
-	struct end_io_wq *end_io_wq;
-	struct btrfs_fs_info *fs_info;
-	int error;
-
-	end_io_wq = container_of(work, struct end_io_wq, work);
-	bio = end_io_wq->bio;
-	fs_info = end_io_wq->info;
-
-	error = end_io_wq->error;
-	bio->bi_private = end_io_wq->private;
-	bio->bi_end_io = end_io_wq->end_io;
-	kfree(end_io_wq);
-	bio_endio(bio, error);
-}
-
 static int cleaner_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index a7ace1a..719a288 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -72,7 +72,7 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
-			int metadata);
+			int metadata, int noasync);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 			int rw, struct bio *bio, int mirror_num,
 			unsigned long bio_flags, u64 bio_offset,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7c501d3..6317ae8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1170,9 +1170,8 @@ int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			      cached_state, mask);
 }
 
-static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
-				 u64 end, struct extent_state **cached_state,
-				 gfp_t mask)
+int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
+			  struct extent_state **cached_state, gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
 				cached_state, mask);
@@ -2200,7 +2199,8 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 
 /* lots and lots of room for performance fixes in the end_bio funcs */
 
-int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
+int end_extent_writepage(struct page *page, int err, u64 start, u64 end,
+			 int async)
 {
 	int uptodate = (err == 0);
 	struct extent_io_tree *tree;
@@ -2210,7 +2210,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 
 	if (tree->ops && tree->ops->writepage_end_io_hook) {
 		ret = tree->ops->writepage_end_io_hook(page, start,
-					       end, NULL, uptodate);
+					       end, NULL, uptodate, async);
 		if (ret)
 			uptodate = 0;
 	}
@@ -2225,6 +2225,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	}
 
 	if (!uptodate) {
+		BUG_ON(!async); /* Logic error */
 		clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
 		ClearPageUptodate(page);
 		SetPageError(page);
@@ -2248,7 +2249,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 	u64 start;
 	u64 end;
 	int whole_page;
-
+	int async = test_bit(BIO_ASYNC_ENDIO, &bio->bi_flags);
 	do {
 		struct page *page = bvec->bv_page;
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
@@ -2265,7 +2266,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
 
-		if (end_extent_writepage(page, err, start, end))
+		if (end_extent_writepage(page, err, start, end, async))
 			continue;
 
 		if (whole_page)
@@ -2919,7 +2920,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	if (last_byte <= start) {
 		if (tree->ops && tree->ops->writepage_end_io_hook)
 			tree->ops->writepage_end_io_hook(page, start,
-							 page_end, NULL, 1);
+							 page_end, NULL, 1, 1);
 		goto done;
 	}
 
@@ -2929,7 +2930,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		if (cur >= last_byte) {
 			if (tree->ops && tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, cur,
-							 page_end, NULL, 1);
+							 page_end, NULL, 1, 1);
 			break;
 		}
 		em = epd->get_extent(inode, page, pg_offset, cur,
@@ -2965,7 +2966,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			    tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, cur,
 							 cur + iosize - 1,
-							 NULL, 1);
+							 NULL, 1, 1);
 			else if (compressed) {
 				/* we don't want to end_page_writeback on
 				 * a compressed extent.  this happens
@@ -3501,7 +3502,7 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 			if (tree->ops && tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, start,
 						 start + PAGE_CACHE_SIZE - 1,
-						 NULL, 1);
+						 NULL, 1, 1);
 			unlock_page(page);
 		}
 		page_cache_release(page);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b516c3b..2b411d8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -81,7 +81,8 @@ struct extent_io_ops {
 	int (*readpage_end_io_hook)(struct page *page, u64 start, u64 end,
 				    struct extent_state *state, int mirror);
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
-				      struct extent_state *state, int uptodate);
+				      struct extent_state *state, int uptodate,
+				      int async);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
 			     int *bits);
 	void (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
@@ -225,6 +226,8 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   struct extent_state **cached_state, gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
+int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
+			  struct extent_state **cached_state, gfp_t mask);
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
@@ -325,7 +328,8 @@ struct btrfs_mapping_tree;
 int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 			u64 length, u64 logical, struct page *page,
 			int mirror_num);
-int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
+int end_extent_writepage(struct page *page, int err, u64 start, u64 end,
+			 int async);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
 #endif
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index baaa518..a99adbd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -972,9 +972,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		goto out;
 
 
-	ret = filemap_write_and_wait(inode->i_mapping);
-	if (ret)
-		goto out;
+	btrfs_wait_ordered_range(inode, 0, -1);
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
 	key.offset = offset;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 77c2b03..4db2ab8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -89,7 +89,6 @@ static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
 
 static int btrfs_setsize(struct inode *inode, loff_t newsize);
 static int btrfs_truncate(struct inode *inode);
-static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end);
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
@@ -1572,7 +1571,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	if (btrfs_is_free_space_inode(root, inode))
 		metadata = 2;
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata, 1);
 	if (ret)
 		return ret;
 
@@ -1678,7 +1677,7 @@ again:
 	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
-		end_extent_writepage(page, ret, page_start, page_end);
+		end_extent_writepage(page, ret, page_start, page_end, 1);
 		ClearPageChecked(page);
 		goto out;
 	 }
@@ -1815,23 +1814,17 @@ out:
  * an ordered extent if the range of bytes in the file it covers are
  * fully written.
  */
-static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
+static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 {
+	struct inode *inode = ordered_extent->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans = NULL;
-	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
 	int compress_type = 0;
 	int ret;
 	bool nolock;
 
-	ret = btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
-					     end - start + 1);
-	if (!ret)
-		return 0;
-	BUG_ON(!ordered_extent); /* Logic error */
-
 	nolock = btrfs_is_free_space_inode(root, inode);
 
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
@@ -1932,13 +1925,50 @@ out_unlock:
 	goto out;
 }
 
+static void finish_ordered_extent(struct btrfs_work *work)
+{
+	struct btrfs_ordered_extent *ordered_extent;
+	struct extent_io_tree *tree;
+	u64 start, end;
+	int ret;
+
+	ordered_extent = container_of(work, struct btrfs_ordered_extent, work);
+	start = ordered_extent->start;
+	end = ordered_extent->start + ordered_extent->len - 1;
+	tree = &BTRFS_I(ordered_extent->inode)->io_tree;
+
+	ret = btrfs_finish_ordered_io(ordered_extent);
+	if (ret)
+		clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
+}
+
 static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
-				struct extent_state *state, int uptodate)
+				       struct extent_state *state,
+				       int uptodate, int async)
 {
+	struct inode *inode = page->mapping->host;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_ordered_extent *ordered_extent = NULL;
+
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
 	ClearPagePrivate2(page);
-	return btrfs_finish_ordered_io(page->mapping->host, start, end);
+
+	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
+					   end - start + 1))
+		return 0;
+
+	BUG_ON(!ordered_extent);
+	if (async) {
+		return btrfs_finish_ordered_io(ordered_extent);
+	} else {
+		ordered_extent->work.flags = 0;
+		ordered_extent->work.func = finish_ordered_extent;
+		btrfs_queue_worker(&fs_info->endio_write_workers,
+				   &ordered_extent->work);
+	}
+
+	return 0;
 }
 
 /*
@@ -6059,7 +6089,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 	int ret;
 
 	bio_get(bio);
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0, 0);
 	if (ret)
 		goto err;
 
@@ -6481,6 +6511,7 @@ static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 
 static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 {
+	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
@@ -6497,7 +6528,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 	 */
 	wait_on_page_writeback(page);
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	tree = &BTRFS_I(inode)->io_tree;
 	if (offset) {
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
@@ -6518,9 +6549,10 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
 		 */
-		if (TestClearPagePrivate2(page)) {
-			btrfs_finish_ordered_io(page->mapping->host,
-						page_start, page_end);
+		if (TestClearPagePrivate2(page) &&
+		    btrfs_dec_test_ordered_pending(inode, &ordered, page_start,
+						   PAGE_CACHE_SIZE)) {
+			btrfs_finish_ordered_io(ordered);
 		}
 		btrfs_put_ordered_extent(ordered);
 		cached_state = NULL;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index bbf6d0d..4f5467a 100644
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
@@ -212,12 +212,12 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 
 	trace_btrfs_ordered_extent_add(inode, entry);
 
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_insert(&tree->tree, file_offset,
 			   &entry->rb_node);
 	if (node)
 		ordered_data_tree_panic(inode, -EEXIST, file_offset);
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 
 	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
 	list_add_tail(&entry->root_extent_list,
@@ -264,9 +264,9 @@ void btrfs_add_ordered_sum(struct inode *inode,
 	struct btrfs_ordered_inode_tree *tree;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	list_add_tail(&sum->list, &entry->list);
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 }
 
 /*
@@ -294,7 +294,7 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 	u64 to_dec;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, *file_offset);
 	if (!node) {
 		ret = 1;
@@ -332,7 +332,7 @@ out:
 		*cached = entry;
 		atomic_inc(&entry->refs);
 	}
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	return ret == 0;
 }
 
@@ -352,10 +352,16 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry = NULL;
+	unsigned long flags;
 	int ret;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irqsave(&tree->lock, flags);
+	if (cached && *cached) {
+		entry = *cached;
+		goto have_ordered;
+	}
+
 	node = tree_search(tree, file_offset);
 	if (!node) {
 		ret = 1;
@@ -368,6 +374,7 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 		goto out;
 	}
 
+have_ordered:
 	if (io_size > entry->bytes_left) {
 		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
 		       (unsigned long long)entry->bytes_left,
@@ -383,7 +390,7 @@ out:
 		*cached = entry;
 		atomic_inc(&entry->refs);
 	}
-	spin_unlock(&tree->lock);
+	spin_unlock_irqrestore(&tree->lock, flags);
 	return ret == 0;
 }
 
@@ -399,6 +406,8 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 	trace_btrfs_ordered_extent_put(entry->inode, entry);
 
 	if (atomic_dec_and_test(&entry->refs)) {
+		if (entry->inode)
+			btrfs_add_delayed_iput(entry->inode);
 		while (!list_empty(&entry->list)) {
 			cur = entry->list.next;
 			sum = list_entry(cur, struct btrfs_ordered_sum, list);
@@ -454,9 +463,9 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	struct btrfs_ordered_inode_tree *tree;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	__btrfs_remove_ordered_extent(inode, entry);
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	wake_up(&entry->wait);
 }
 
@@ -676,7 +685,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node)
 		goto out;
@@ -687,7 +696,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	if (entry)
 		atomic_inc(&entry->refs);
 out:
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	return entry;
 }
 
@@ -703,7 +712,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node) {
 		node = tree_search(tree, file_offset + len);
@@ -728,7 +737,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 out:
 	if (entry)
 		atomic_inc(&entry->refs);
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	return entry;
 }
 
@@ -744,7 +753,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node)
 		goto out;
@@ -752,7 +761,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
 	atomic_inc(&entry->refs);
 out:
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	return entry;
 }
 
@@ -779,7 +788,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	else
 		offset = ALIGN(offset, BTRFS_I(inode)->root->sectorsize);
 
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	disk_i_size = BTRFS_I(inode)->disk_i_size;
 
 	/* truncate file */
@@ -885,7 +894,7 @@ out:
 	 */
 	if (ordered)
 		__btrfs_remove_ordered_extent(inode, ordered);
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	if (ordered)
 		wake_up(&ordered->wait);
 	return ret;
@@ -912,7 +921,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 	if (!ordered)
 		return 1;
 
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	list_for_each_entry_reverse(ordered_sum, &ordered->list, list) {
 		if (disk_bytenr >= ordered_sum->bytenr) {
 			num_sectors = ordered_sum->len / sectorsize;
@@ -927,7 +936,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 		}
 	}
 out:
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	btrfs_put_ordered_extent(ordered);
 	return ret;
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index c355ad4..5609108 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -113,6 +113,8 @@ struct btrfs_ordered_extent {
 
 	/* a per root list of all the pending ordered extents */
 	struct list_head root_extent_list;
+
+	struct btrfs_work work;
 };
 
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..385154e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -95,6 +95,8 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+#define BIO_ASYNC_ENDIO 12	/* bi_endio is being run outside of the
+				 * interrupt context */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.7.7.6

