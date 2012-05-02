From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: finish ordered extents in their own thread
Date: Wed,  2 May 2012 14:00:15 -0400
Message-ID: <1335981615-14793-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We noticed that the ordered extent completion doesn't really rely on having
a page and that it could be done independantly of ending the writeback on a
page.  This patch makes us not do the threaded endio stuff for normal
buffered writes and direct writes so we can end page writeback as soon as
possible (in irq context) and only start threads to do the ordered work when
it is actually done.  Compression needs to be reworked some to take
advantage of this as well, but atm it has to do a find_get_page in its endio
handler so it must be done in its own thread.  This makes direct writes
quite a bit faster.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c          |   12 ---
 fs/btrfs/extent_io.c        |   15 +---
 fs/btrfs/extent_io.h        |    5 +-
 fs/btrfs/free-space-cache.c |    4 +-
 fs/btrfs/inode.c            |  177 ++++++++++++++++++------------------------
 fs/btrfs/ordered-data.c     |  104 +++++++++++++------------
 fs/btrfs/ordered-data.h     |   13 +++-
 7 files changed, 147 insertions(+), 183 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d0c969b..c6756864 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3663,17 +3663,6 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 	return 0;
 }
 
-static int btree_writepage_io_failed_hook(struct bio *bio, struct page *page,
-					  u64 start, u64 end,
-					  struct extent_state *state)
-{
-	struct super_block *sb = page->mapping->host->i_sb;
-	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	btrfs_error(fs_info, -EIO,
-		    "Error occured while writing out btree at %llu", start);
-	return -EIO;
-}
-
 static struct extent_io_ops btree_extent_io_ops = {
 	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
@@ -3681,5 +3670,4 @@ static struct extent_io_ops btree_extent_io_ops = {
 	.submit_bio_hook = btree_submit_bio_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
-	.writepage_io_failed_hook = btree_writepage_io_failed_hook,
 };
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 836fc37..7af9343 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1172,9 +1172,8 @@ int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
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
@@ -2221,17 +2220,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 			uptodate = 0;
 	}
 
-	if (!uptodate && tree->ops &&
-	    tree->ops->writepage_io_failed_hook) {
-		ret = tree->ops->writepage_io_failed_hook(NULL, page,
-						 start, end, NULL);
-		/* Writeback already completed */
-		if (ret == 0)
-			return 1;
-	}
-
 	if (!uptodate) {
-		clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
 		ClearPageUptodate(page);
 		SetPageError(page);
 	}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b516c3b..4d8124b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -75,9 +75,6 @@ struct extent_io_ops {
 			      unsigned long bio_flags);
 	int (*readpage_io_hook)(struct page *page, u64 start, u64 end);
 	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
-	int (*writepage_io_failed_hook)(struct bio *bio, struct page *page,
-					u64 start, u64 end,
-				       struct extent_state *state);
 	int (*readpage_end_io_hook)(struct page *page, u64 start, u64 end,
 				    struct extent_state *state, int mirror);
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
@@ -225,6 +222,8 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   struct extent_state **cached_state, gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
+int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
+			  struct extent_state **cached_state, gfp_t mask);
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 202008e..cecf8df 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -972,9 +972,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		goto out;
 
 
-	ret = filemap_write_and_wait(inode->i_mapping);
-	if (ret)
-		goto out;
+	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
 	key.offset = offset;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c74bb40..54ae3df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -89,7 +89,7 @@ static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
 
 static int btrfs_setsize(struct inode *inode, loff_t newsize);
 static int btrfs_truncate(struct inode *inode);
-static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end);
+static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
@@ -1572,11 +1572,11 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	if (btrfs_is_free_space_inode(root, inode))
 		metadata = 2;
 
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
-	if (ret)
-		return ret;
-
 	if (!(rw & REQ_WRITE)) {
+		ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
+		if (ret)
+			return ret;
+
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
 			return btrfs_submit_compressed_read(inode, bio,
 						    mirror_num, bio_flags);
@@ -1815,25 +1815,24 @@ out:
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
 
+	if (test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags)) {
+		ret = -EIO;
+		goto out;
+	}
+
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list)); /* Logic error */
 		ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
@@ -1889,12 +1888,10 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 				   ordered_extent->file_offset,
 				   ordered_extent->len);
 	}
-	unlock_extent_cached(io_tree, ordered_extent->file_offset,
-			     ordered_extent->file_offset +
-			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
+
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, root, ret);
-		goto out;
+		goto out_unlock;
 	}
 
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
@@ -1905,10 +1902,14 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		ret = btrfs_update_inode_fallback(trans, root, inode);
 		if (ret) { /* -ENOMEM or corruption */
 			btrfs_abort_transaction(trans, root, ret);
-			goto out;
+			goto out_unlock;
 		}
 	}
 	ret = 0;
+out_unlock:
+	unlock_extent_cached(io_tree, ordered_extent->file_offset,
+			     ordered_extent->file_offset +
+			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
 	if (root != root->fs_info->tree_root)
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
@@ -1919,26 +1920,57 @@ out:
 			btrfs_end_transaction(trans, root);
 	}
 
+	if (ret)
+		clear_extent_uptodate(io_tree, ordered_extent->file_offset,
+				      ordered_extent->file_offset +
+				      ordered_extent->len - 1, NULL, GFP_NOFS);
+
+	/*
+	 * This needs to be dont to make sure anybody waiting knows we are done
+	 * upating everything for this ordered extent.
+	 */
+	btrfs_remove_ordered_extent(inode, ordered_extent);
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
 	btrfs_put_ordered_extent(ordered_extent);
 
-	return 0;
-out_unlock:
-	unlock_extent_cached(io_tree, ordered_extent->file_offset,
-			     ordered_extent->file_offset +
-			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
-	goto out;
+	return ret;
+}
+
+static void finish_ordered_fn(struct btrfs_work *work)
+{
+	struct btrfs_ordered_extent *ordered_extent;
+	ordered_extent = container_of(work, struct btrfs_ordered_extent, work);
+	btrfs_finish_ordered_io(ordered_extent);
 }
 
 static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
+	struct inode *inode = page->mapping->host;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_ordered_extent *ordered_extent = NULL;
+	struct btrfs_workers *workers;
+
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
 	ClearPagePrivate2(page);
-	return btrfs_finish_ordered_io(page->mapping->host, start, end);
+	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
+					    end - start + 1, uptodate))
+		return 0;
+
+	ordered_extent->work.func = finish_ordered_fn;
+	ordered_extent->work.flags = 0;
+
+	if (btrfs_is_free_space_inode(root, inode))
+		workers = &root->fs_info->endio_freespace_worker;
+	else
+		workers = &root->fs_info->endio_write_workers;
+	btrfs_queue_worker(workers, &ordered_extent->work);
+
+	return 0;
 }
 
 /*
@@ -5881,9 +5913,7 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
 	struct btrfs_ordered_extent *ordered = NULL;
-	struct extent_state *cached_state = NULL;
 	u64 ordered_offset = dip->logical_offset;
 	u64 ordered_bytes = dip->bytes;
 	int ret;
@@ -5893,73 +5923,14 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
 again:
 	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
 						   &ordered_offset,
-						   ordered_bytes);
+						   ordered_bytes, !err);
 	if (!ret)
 		goto out_test;
 
-	BUG_ON(!ordered);
-
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans)) {
-		err = -ENOMEM;
-		goto out;
-	}
-	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
-
-	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
-		ret = btrfs_ordered_update_i_size(inode, 0, ordered);
-		if (!ret)
-			err = btrfs_update_inode_fallback(trans, root, inode);
-		goto out;
-	}
-
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, ordered->file_offset,
-			 ordered->file_offset + ordered->len - 1, 0,
-			 &cached_state);
-
-	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags)) {
-		ret = btrfs_mark_extent_written(trans, inode,
-						ordered->file_offset,
-						ordered->file_offset +
-						ordered->len);
-		if (ret) {
-			err = ret;
-			goto out_unlock;
-		}
-	} else {
-		ret = insert_reserved_file_extent(trans, inode,
-						  ordered->file_offset,
-						  ordered->start,
-						  ordered->disk_len,
-						  ordered->len,
-						  ordered->len,
-						  0, 0, 0,
-						  BTRFS_FILE_EXTENT_REG);
-		unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
-				   ordered->file_offset, ordered->len);
-		if (ret) {
-			err = ret;
-			WARN_ON(1);
-			goto out_unlock;
-		}
-	}
-
-	add_pending_csums(trans, inode, ordered->file_offset, &ordered->list);
-	ret = btrfs_ordered_update_i_size(inode, 0, ordered);
-	if (!ret || !test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags))
-		btrfs_update_inode_fallback(trans, root, inode);
-	ret = 0;
-out_unlock:
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, ordered->file_offset,
-			     ordered->file_offset + ordered->len - 1,
-			     &cached_state, GFP_NOFS);
-out:
-	btrfs_delalloc_release_metadata(inode, ordered->len);
-	btrfs_end_transaction(trans, root);
-	ordered_offset = ordered->file_offset + ordered->len;
-	btrfs_put_ordered_extent(ordered);
-	btrfs_put_ordered_extent(ordered);
-
+	ordered->work.func = finish_ordered_fn;
+	ordered->work.flags = 0;
+	btrfs_queue_worker(&root->fs_info->endio_write_workers,
+			   &ordered->work);
 out_test:
 	/*
 	 * our bio might span multiple ordered extents.  If we haven't
@@ -5968,12 +5939,12 @@ out_test:
 	if (ordered_offset < dip->logical_offset + dip->bytes) {
 		ordered_bytes = dip->logical_offset + dip->bytes -
 			ordered_offset;
+		ordered = NULL;
 		goto again;
 	}
 out_done:
 	bio->bi_private = dip->private;
 
-	kfree(dip->csums);
 	kfree(dip);
 
 	/* If we had an error make sure to clear the uptodate flag */
@@ -6041,9 +6012,12 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 	int ret;
 
 	bio_get(bio);
-	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
-	if (ret)
-		goto err;
+
+	if (!write) {
+		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+		if (ret)
+			goto err;
+	}
 
 	if (skip_sum)
 		goto map;
@@ -6463,13 +6437,13 @@ static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 
 static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 {
+	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	u64 page_start = page_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
 
-
 	/*
 	 * we have the page locked, so new writeback can't start,
 	 * and the dirty bit won't be cleared while we are here.
@@ -6479,13 +6453,13 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 	 */
 	wait_on_page_writeback(page);
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	tree = &BTRFS_I(inode)->io_tree;
 	if (offset) {
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
 	lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
-	ordered = btrfs_lookup_ordered_extent(page->mapping->host,
+	ordered = btrfs_lookup_ordered_extent(inode,
 					   page_offset(page));
 	if (ordered) {
 		/*
@@ -6500,9 +6474,10 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
 		 */
-		if (TestClearPagePrivate2(page)) {
-			btrfs_finish_ordered_io(page->mapping->host,
-						page_start, page_end);
+		if (TestClearPagePrivate2(page) &&
+		    btrfs_dec_test_ordered_pending(inode, &ordered, page_start,
+						   PAGE_CACHE_SIZE, 1)) {
+			btrfs_finish_ordered_io(ordered);
 		}
 		btrfs_put_ordered_extent(ordered);
 		cached_state = NULL;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 9565c02..a7691c1 100644
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
@@ -283,18 +283,19 @@ void btrfs_add_ordered_sum(struct inode *inode,
  */
 int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
-				   u64 *file_offset, u64 io_size)
+				   u64 *file_offset, u64 io_size, int uptodate)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry = NULL;
 	int ret;
+	unsigned long flags;
 	u64 dec_end;
 	u64 dec_start;
 	u64 to_dec;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irqsave(&tree->lock, flags);
 	node = tree_search(tree, *file_offset);
 	if (!node) {
 		ret = 1;
@@ -323,6 +324,9 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 		       (unsigned long long)to_dec);
 	}
 	entry->bytes_left -= to_dec;
+	if (!uptodate)
+		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
+
 	if (entry->bytes_left == 0)
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
 	else
@@ -332,7 +336,7 @@ out:
 		*cached = entry;
 		atomic_inc(&entry->refs);
 	}
-	spin_unlock(&tree->lock);
+	spin_unlock_irqrestore(&tree->lock, flags);
 	return ret == 0;
 }
 
@@ -347,15 +351,21 @@ out:
  */
 int btrfs_dec_test_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
-				   u64 file_offset, u64 io_size)
+				   u64 file_offset, u64 io_size, int uptodate)
 {
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
+		goto have_entry;
+	}
+
 	node = tree_search(tree, file_offset);
 	if (!node) {
 		ret = 1;
@@ -363,6 +373,7 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 	}
 
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
+have_entry:
 	if (!offset_in_entry(entry, file_offset)) {
 		ret = 1;
 		goto out;
@@ -374,6 +385,9 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 		       (unsigned long long)io_size);
 	}
 	entry->bytes_left -= io_size;
+	if (!uptodate)
+		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
+
 	if (entry->bytes_left == 0)
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
 	else
@@ -383,7 +397,7 @@ out:
 		*cached = entry;
 		atomic_inc(&entry->refs);
 	}
-	spin_unlock(&tree->lock);
+	spin_unlock_irqrestore(&tree->lock, flags);
 	return ret == 0;
 }
 
@@ -399,6 +413,8 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 	trace_btrfs_ordered_extent_put(entry->inode, entry);
 
 	if (atomic_dec_and_test(&entry->refs)) {
+		if (entry->inode)
+			btrfs_add_delayed_iput(entry->inode);
 		while (!list_empty(&entry->list)) {
 			cur = entry->list.next;
 			sum = list_entry(cur, struct btrfs_ordered_sum, list);
@@ -411,21 +427,22 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 
 /*
  * remove an ordered extent from the tree.  No references are dropped
- * and you must wake_up entry->wait.  You must hold the tree lock
- * while you call this function.
+ * and waiters are woken up.
  */
-static void __btrfs_remove_ordered_extent(struct inode *inode,
-					  struct btrfs_ordered_extent *entry)
+void btrfs_remove_ordered_extent(struct inode *inode,
+				 struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct rb_node *node;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
+	spin_lock_irq(&tree->lock);
 	node = &entry->rb_node;
 	rb_erase(node, &tree->tree);
 	tree->last = NULL;
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
+	spin_unlock_irq(&tree->lock);
 
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
@@ -442,21 +459,6 @@ static void __btrfs_remove_ordered_extent(struct inode *inode,
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-}
-
-/*
- * remove an ordered extent from the tree.  No references are dropped
- * but any waiters are woken.
- */
-void btrfs_remove_ordered_extent(struct inode *inode,
-				 struct btrfs_ordered_extent *entry)
-{
-	struct btrfs_ordered_inode_tree *tree;
-
-	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
-	__btrfs_remove_ordered_extent(inode, entry);
-	spin_unlock(&tree->lock);
 	wake_up(&entry->wait);
 }
 
@@ -663,7 +665,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node)
 		goto out;
@@ -674,7 +676,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	if (entry)
 		atomic_inc(&entry->refs);
 out:
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	return entry;
 }
 
@@ -690,7 +692,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node) {
 		node = tree_search(tree, file_offset + len);
@@ -715,7 +717,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 out:
 	if (entry)
 		atomic_inc(&entry->refs);
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	return entry;
 }
 
@@ -731,7 +733,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node)
 		goto out;
@@ -739,7 +741,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
 	atomic_inc(&entry->refs);
 out:
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	return entry;
 }
 
@@ -765,7 +767,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	else
 		offset = ALIGN(offset, BTRFS_I(inode)->root->sectorsize);
 
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	disk_i_size = BTRFS_I(inode)->disk_i_size;
 
 	/* truncate file */
@@ -803,15 +805,18 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 		}
 		node = prev;
 	}
-	while (node) {
+	for (; node; node = rb_prev(node)) {
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
+
+		/* We treat this entry as if it doesnt exist */
+		if (test_bit(BTRFS_ORDERED_UPDATED_ISIZE, &test->flags))
+			continue;
 		if (test->file_offset + test->len <= disk_i_size)
 			break;
 		if (test->file_offset >= i_size)
 			break;
 		if (test->file_offset >= disk_i_size)
 			goto out;
-		node = rb_prev(node);
 	}
 	new_i_size = min_t(u64, offset, i_size);
 
@@ -836,7 +841,8 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 		 * between our ordered extent and the next one.
 		 */
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-		if (test->file_offset > offset)
+		if (!test_bit(BTRFS_ORDERED_UPDATED_ISIZE, &test->flags) &&
+		    test->file_offset > offset)
 			i_size_test = test->file_offset;
 	} else {
 		i_size_test = i_size;
@@ -853,15 +859,15 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	ret = 0;
 out:
 	/*
-	 * we need to remove the ordered extent with the tree lock held
-	 * so that other people calling this function don't find our fully
-	 * processed ordered entry and skip updating the i_size
+	 * We need to do this because we can't remove ordered extents until
+	 * after the i_disk_size has been updated and then the inode has been
+	 * updated to reflect the change, so we need to tell anybody who finds
+	 * this ordered extent that we've already done all the real work, we
+	 * just haven't completed all the other work.
 	 */
 	if (ordered)
-		__btrfs_remove_ordered_extent(inode, ordered);
-	spin_unlock(&tree->lock);
-	if (ordered)
-		wake_up(&ordered->wait);
+		set_bit(BTRFS_ORDERED_UPDATED_ISIZE, &ordered->flags);
+	spin_unlock_irq(&tree->lock);
 	return ret;
 }
 
@@ -886,7 +892,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 	if (!ordered)
 		return 1;
 
-	spin_lock(&tree->lock);
+	spin_lock_irq(&tree->lock);
 	list_for_each_entry_reverse(ordered_sum, &ordered->list, list) {
 		if (disk_bytenr >= ordered_sum->bytenr) {
 			num_sectors = ordered_sum->len / sectorsize;
@@ -901,7 +907,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 		}
 	}
 out:
-	spin_unlock(&tree->lock);
+	spin_unlock_irq(&tree->lock);
 	btrfs_put_ordered_extent(ordered);
 	return ret;
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index c355ad4..e03c560 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -74,6 +74,12 @@ struct btrfs_ordered_sum {
 
 #define BTRFS_ORDERED_DIRECT 5 /* set when we're doing DIO with this extent */
 
+#define BTRFS_ORDERED_IOERR 6 /* We had an io error when writing this out */
+
+#define BTRFS_ORDERED_UPDATED_ISIZE 7 /* indicates wether this ordered extent
+				       * has done its due diligence in updating
+				       * the isize. */
+
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
@@ -113,6 +119,8 @@ struct btrfs_ordered_extent {
 
 	/* a per root list of all the pending ordered extents */
 	struct list_head root_extent_list;
+
+	struct btrfs_work work;
 };
 
 
@@ -143,10 +151,11 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry);
 int btrfs_dec_test_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
-				   u64 file_offset, u64 io_size);
+				   u64 file_offset, u64 io_size, int uptodate);
 int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
-				   u64 *file_offset, u64 io_size);
+				   u64 *file_offset, u64 io_size,
+				   int uptodate);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
-- 
1.7.7.6

