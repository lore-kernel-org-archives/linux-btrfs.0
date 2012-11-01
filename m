Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:56519 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab2KATYx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 15:24:53 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id iicjiddEBy8HNotY (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 13:24:52 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use radix tree tagging to keep track of dirty ebs
Date: Thu, 1 Nov 2012 15:30:41 -0400
Message-ID: <1351798241-5004-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently we set dirty bits in the transactions dirty eb's in order to know
what we have to write out on transaction commit.  This means for every eb we
allocate we have to allocate the corresponding extent state in the dirty
pages tree.  We also only change this tree on commit, so we could end up
looking at ranges that we've already written.  By using the radix tagging we
can avoid the memory allocation altogether, which is a step we need in order
to non-blocking COW's.  This also clears the radix tag when we write dirty
eb's, so if we write buffers because of memory pressure we won't come back
and do all the checking at transaction commit.  This ran with my fs_mark
billion files test and didn't regress in performance, and it passed xfstests
without issues.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c     |   87 ++++++++------------------
 fs/btrfs/extent-tree.c |    9 ++-
 fs/btrfs/extent_io.c   |  160 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.h   |    7 ++
 fs/btrfs/transaction.c |   19 +-----
 fs/btrfs/transaction.h |    1 -
 6 files changed, 197 insertions(+), 86 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0643159..305bf35 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -61,9 +61,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
 static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
-static int btrfs_destroy_marked_extents(struct btrfs_root *root,
-					struct extent_io_tree *dirty_pages,
-					int mark);
+static int btrfs_destroy_marked_extents(struct btrfs_root *root);
 static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 				       struct extent_io_tree *pinned_extents);
 
@@ -3263,7 +3261,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 	ret = btrfs_commit_transaction(trans, root);
 	if (ret)
 		return ret;
-	ret = btrfs_write_and_wait_transaction(NULL, root);
+	ret = filemap_write_and_wait(root->fs_info->btree_inode->i_mapping);
 	if (ret) {
 		btrfs_error(root->fs_info, ret,
 			    "Failed to sync btree inode to disk.");
@@ -3650,61 +3648,34 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 	spin_unlock(&root->fs_info->delalloc_lock);
 }
 
-static int btrfs_destroy_marked_extents(struct btrfs_root *root,
-					struct extent_io_tree *dirty_pages,
-					int mark)
+static int btrfs_destroy_marked_extents(struct btrfs_root *root)
 {
-	int ret;
-	struct page *page;
 	struct inode *btree_inode = root->fs_info->btree_inode;
-	struct extent_buffer *eb;
-	u64 start = 0;
-	u64 end;
-	u64 offset;
-	unsigned long index;
+	struct extent_io_tree *tree = &BTRFS_I(btree_inode)->io_tree;
+	struct radix_tree_iter iter;
+	void **slot;
+	int mark = PAGECACHE_TAG_DIRTY;
 
-	while (1) {
-		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
-					    mark, NULL);
-		if (ret)
-			break;
+again:
+	spin_lock_irq(&tree->buffer_lock);
+	radix_tree_for_each_tagged(slot, &tree->buffer, &iter, 0, mark) {
+		struct extent_buffer *eb;
 
-		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
-		while (start <= end) {
-			index = start >> PAGE_CACHE_SHIFT;
-			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
-			page = find_get_page(btree_inode->i_mapping, index);
-			if (!page)
-				continue;
-			offset = page_offset(page);
-
-			spin_lock(&dirty_pages->buffer_lock);
-			eb = radix_tree_lookup(
-			     &(&BTRFS_I(page->mapping->host)->io_tree)->buffer,
-					       offset >> PAGE_CACHE_SHIFT);
-			spin_unlock(&dirty_pages->buffer_lock);
-			if (eb)
-				ret = test_and_clear_bit(EXTENT_BUFFER_DIRTY,
-							 &eb->bflags);
-			if (PageWriteback(page))
-				end_page_writeback(page);
-
-			lock_page(page);
-			if (PageDirty(page)) {
-				clear_page_dirty_for_io(page);
-				spin_lock_irq(&page->mapping->tree_lock);
-				radix_tree_tag_clear(&page->mapping->page_tree,
-							page_index(page),
-							PAGECACHE_TAG_DIRTY);
-				spin_unlock_irq(&page->mapping->tree_lock);
-			}
+		eb = radix_tree_deref_slot(slot);
 
-			unlock_page(page);
-			page_cache_release(page);
-		}
+		clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
+		clear_extent_buffer_dirty(eb);
+		radix_tree_tag_clear(&tree->buffer,
+				     eb->start >> PAGE_CACHE_SHIFT, mark);
 	}
+	spin_unlock_irq(&tree->buffer_lock);
 
-	return ret;
+	if (mark == PAGECACHE_TAG_DIRTY) {
+		mark = PAGECACHE_TAG_TOWRITE;
+		goto again;
+	}
+
+	return 0;
 }
 
 static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
@@ -3751,8 +3722,7 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 				   struct btrfs_root *root)
 {
 	btrfs_destroy_delayed_refs(cur_trans, root);
-	btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
-				cur_trans->dirty_pages.dirty_bytes);
+	btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv, -1);
 
 	/* FIXME: cleanup wait for commit */
 	cur_trans->in_commit = 1;
@@ -3770,8 +3740,7 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 
 	btrfs_destroy_pending_snapshots(cur_trans);
 
-	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
-				     EXTENT_DIRTY);
+	btrfs_destroy_marked_extents(root);
 	btrfs_destroy_pinned_extent(root,
 				    root->fs_info->pinned_extents);
 
@@ -3805,8 +3774,7 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 		btrfs_destroy_delayed_refs(t, root);
 
 		btrfs_block_rsv_release(root,
-					&root->fs_info->trans_block_rsv,
-					t->dirty_pages.dirty_bytes);
+					&root->fs_info->trans_block_rsv, -1);
 
 		/* FIXME: cleanup wait for commit */
 		t->in_commit = 1;
@@ -3836,8 +3804,7 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 		root->fs_info->running_transaction = NULL;
 		spin_unlock(&root->fs_info->trans_lock);
 
-		btrfs_destroy_marked_extents(root, &t->dirty_pages,
-					     EXTENT_DIRTY);
+		btrfs_destroy_marked_extents(root);
 
 		btrfs_destroy_pinned_extent(root,
 					    root->fs_info->pinned_extents);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b495cb4..1092867 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6223,6 +6223,8 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    u64 bytenr, u32 blocksize,
 					    int level)
 {
+	struct extent_io_tree *tree =
+		&BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	struct extent_buffer *buf;
 
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
@@ -6249,8 +6251,11 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 			set_extent_new(&root->dirty_log_pages, buf->start,
 					buf->start + buf->len - 1, GFP_NOFS);
 	} else {
-		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
-			 buf->start + buf->len - 1, GFP_NOFS);
+		spin_lock_irq(&tree->buffer_lock);
+		radix_tree_tag_set(&tree->buffer,
+				   buf->start >> PAGE_CACHE_SHIFT,
+				   PAGECACHE_TAG_DIRTY);
+		spin_unlock_irq(&tree->buffer_lock);
 	}
 	trans->blocks_used++;
 	/* this returns a buffer locked for blocking */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 472873a..74a387c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3095,6 +3095,7 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 				     struct btrfs_fs_info *fs_info,
 				     struct extent_page_data *epd)
 {
+	struct extent_io_tree *tree = eb->tree;
 	unsigned long i, num_pages;
 	int flush = 0;
 	int ret = 0;
@@ -3143,6 +3144,17 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 		spin_unlock(&eb->refs_lock);
 	}
 
+	spin_lock_irq(&tree->buffer_lock);
+	if (ret)
+		radix_tree_tag_set(&tree->buffer,
+				   eb->start >> PAGE_CACHE_SHIFT,
+				   PAGECACHE_TAG_WRITEBACK);
+	radix_tree_tag_clear(&tree->buffer, eb->start >> PAGE_CACHE_SHIFT,
+			     PAGECACHE_TAG_DIRTY);
+	radix_tree_tag_clear(&tree->buffer, eb->start >> PAGE_CACHE_SHIFT,
+			     PAGECACHE_TAG_TOWRITE);
+	spin_unlock_irq(&tree->buffer_lock);
+
 	btrfs_tree_unlock(eb);
 
 	if (!ret)
@@ -3166,9 +3178,17 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
 {
+	struct extent_io_tree *tree = eb->tree;
+	unsigned long flags;
+
 	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
+
+	spin_lock_irqsave(&tree->buffer_lock, flags);
+	radix_tree_tag_clear(&tree->buffer, eb->start >> PAGE_CACHE_SHIFT,
+			     PAGECACHE_TAG_WRITEBACK);
+	spin_unlock_irqrestore(&tree->buffer_lock, flags);
 }
 
 static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
@@ -3241,7 +3261,8 @@ static int write_one_eb(struct extent_buffer *eb,
 			break;
 		}
 		offset += PAGE_CACHE_SIZE;
-		update_nr_written(p, wbc, 1);
+		if (wbc)
+			update_nr_written(p, wbc, 1);
 		unlock_page(p);
 	}
 
@@ -3255,6 +3276,131 @@ static int write_one_eb(struct extent_buffer *eb,
 	return ret;
 }
 
+int btree_tag_dirty_ebs(struct extent_io_tree *tree)
+{
+#define TAG_BATCH 4096
+	pgoff_t start = 0, end = -1;
+	unsigned long tagged;
+
+	do {
+		spin_lock_irq(&tree->buffer_lock);
+		tagged = radix_tree_range_tag_if_tagged(&tree->buffer,
+							&start, end, TAG_BATCH,
+							PAGECACHE_TAG_DIRTY,
+							PAGECACHE_TAG_TOWRITE);
+		spin_unlock_irq(&tree->buffer_lock);
+		cond_resched();
+	} while (tagged >= TAG_BATCH && start);
+
+	return 0;
+}
+
+/* Shamelessly ripped off from find_get_pages_tag */
+unsigned btree_lookup_tag(struct extent_io_tree *tree, pgoff_t *index,
+			  unsigned int nr_ebs, struct extent_buffer **ebs,
+			  int mark)
+{
+	struct radix_tree_iter iter;
+	struct extent_buffer *eb;
+	void **slot;
+	int ret = 0;
+
+	rcu_read_lock();
+restart:
+	radix_tree_for_each_tagged(slot, &tree->buffer, &iter, *index, mark) {
+repeat:
+		eb = radix_tree_deref_slot(slot);
+		if (unlikely(!eb))
+			continue;
+
+		if (radix_tree_exception(eb)) {
+			if (radix_tree_deref_retry(eb))
+				goto restart;
+			BUG();
+		}
+
+		if (!atomic_inc_not_zero(&eb->refs))
+			goto repeat;
+
+		if (unlikely(eb != *slot)) {
+			free_extent_buffer(eb);
+			goto repeat;
+		}
+
+		ebs[ret] = eb;
+		if (++ret == nr_ebs)
+			break;
+	}
+	rcu_read_unlock();
+
+	if (ret) {
+		eb = ebs[ret - 1];
+		*index = (eb->start + eb->len) >> PAGE_CACHE_SHIFT;
+	}
+
+	return ret;
+}
+
+void btree_wait_writeback(struct extent_io_tree *tree)
+{
+	struct extent_buffer *ebs[16];
+	pgoff_t index = 0;
+	unsigned nr_ebs;
+
+	while ((nr_ebs = btree_lookup_tag(tree, &index, 16, ebs,
+					  PAGECACHE_TAG_WRITEBACK))) {
+		unsigned i;
+		for (i = 0; i < nr_ebs; i++) {
+			struct extent_buffer *eb = ebs[i];
+			wait_on_extent_buffer_writeback(eb);
+			free_extent_buffer(eb);
+		}
+		cond_resched();
+	}
+}
+
+int btree_write_tagged_ebs(struct btrfs_fs_info *fs_info)
+{
+	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
+	struct extent_buffer *ebs[16];
+	struct extent_page_data epd = {
+		.bio = NULL,
+		.tree = tree,
+		.extent_locked = 0,
+		.sync_io = 1,
+		.bio_flags = 0,
+	};
+	pgoff_t index = 0;
+	unsigned nr_ebs;
+	int done = 0;
+	int ret;
+
+	while (!done &&
+	       (nr_ebs = btree_lookup_tag(tree, &index, 16, ebs,
+					  PAGECACHE_TAG_TOWRITE))) {
+		unsigned i;
+		for (i = 0; i < nr_ebs; i++) {
+			struct extent_buffer *eb = ebs[i];
+
+			if (!lock_extent_buffer_for_io(eb, fs_info, &epd)) {
+				free_extent_buffer(eb);
+				continue;
+			}
+
+			ret = write_one_eb(eb, fs_info, NULL, &epd);
+			if (ret) {
+				done = 1;
+				free_extent_buffer(eb);
+				break;
+			}
+			free_extent_buffer(eb);
+		}
+		cond_resched();
+	}
+	flush_write_bio(&epd);
+	return ret;
+}
+
 int btree_write_cache_pages(struct address_space *mapping,
 				   struct writeback_control *wbc)
 {
@@ -4304,25 +4450,25 @@ again:
 	if (ret)
 		goto free_eb;
 
-	spin_lock(&tree->buffer_lock);
+	spin_lock_irq(&tree->buffer_lock);
 	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
 	if (ret == -EEXIST) {
 		exists = radix_tree_lookup(&tree->buffer,
 						start >> PAGE_CACHE_SHIFT);
 		if (!atomic_inc_not_zero(&exists->refs)) {
-			spin_unlock(&tree->buffer_lock);
+			spin_unlock_irq(&tree->buffer_lock);
 			radix_tree_preload_end();
 			exists = NULL;
 			goto again;
 		}
-		spin_unlock(&tree->buffer_lock);
+		spin_unlock_irq(&tree->buffer_lock);
 		radix_tree_preload_end();
 		mark_extent_buffer_accessed(exists);
 		goto free_eb;
 	}
 	/* add one reference for the tree */
 	check_buffer_tree_ref(eb);
-	spin_unlock(&tree->buffer_lock);
+	spin_unlock_irq(&tree->buffer_lock);
 	radix_tree_preload_end();
 
 	/*
@@ -4391,10 +4537,10 @@ static int release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
 
 			spin_unlock(&eb->refs_lock);
 
-			spin_lock(&tree->buffer_lock);
+			spin_lock_irq(&tree->buffer_lock);
 			radix_tree_delete(&tree->buffer,
 					  eb->start >> PAGE_CACHE_SHIFT);
-			spin_unlock(&tree->buffer_lock);
+			spin_unlock_irq(&tree->buffer_lock);
 		}
 
 		/* Should be safe to release our pages at this point */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 711d12b..8f38601 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -61,6 +61,7 @@
 
 struct extent_state;
 struct btrfs_root;
+struct btrfs_fs_info;
 
 typedef	int (extent_submit_bio_hook_t)(struct inode *inode, int rw,
 				       struct bio *bio, int mirror_num,
@@ -345,4 +346,10 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
+int btree_write_tagged_ebs(struct btrfs_fs_info *fs_info);
+void btree_wait_writeback(struct extent_io_tree *tree);
+unsigned btree_lookup_tag(struct extent_io_tree *tree, pgoff_t *index,
+			  unsigned int nr_ebs, struct extent_buffer **ebs,
+			  int mark);
+int btree_tag_dirty_ebs(struct extent_io_tree *tree);
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 259f74e..b52a3fe 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -162,8 +162,6 @@ loop:
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
-	extent_io_tree_init(&cur_trans->dirty_pages,
-			     fs_info->btree_inode->i_mapping);
 	fs_info->generation++;
 	cur_trans->transid = fs_info->generation;
 	fs_info->running_transaction = cur_trans;
@@ -756,19 +754,6 @@ int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 	return 0;
 }
 
-int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root)
-{
-	if (!trans || !trans->transaction) {
-		struct inode *btree_inode;
-		btree_inode = root->fs_info->btree_inode;
-		return filemap_write_and_wait(btree_inode->i_mapping);
-	}
-	return btrfs_write_and_wait_marked_extents(root,
-					   &trans->transaction->dirty_pages,
-					   EXTENT_DIRTY);
-}
-
 /*
  * this is used to update the root pointer in the tree of tree roots.
  *
@@ -1664,6 +1649,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	memcpy(root->fs_info->super_for_commit, root->fs_info->super_copy,
 	       sizeof(*root->fs_info->super_copy));
 
+	btree_tag_dirty_ebs(&BTRFS_I(root->fs_info->btree_inode)->io_tree);
 	trans->transaction->blocked = 0;
 	spin_lock(&root->fs_info->trans_lock);
 	root->fs_info->running_transaction = NULL;
@@ -1673,7 +1659,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	wake_up(&root->fs_info->transaction_wait);
 
-	ret = btrfs_write_and_wait_transaction(trans, root);
+	ret = btree_write_tagged_ebs(root->fs_info);
+	btree_wait_writeback(&BTRFS_I(root->fs_info->btree_inode)->io_tree);
 	if (ret) {
 		btrfs_error(root->fs_info, ret,
 			    "Error while writing out transaction.");
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 0e8aa1e..68fcd9a 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -38,7 +38,6 @@ struct btrfs_transaction {
 	int commit_done;
 	int blocked;
 	struct list_head list;
-	struct extent_io_tree dirty_pages;
 	unsigned long start_time;
 	wait_queue_head_t writer_wait;
 	wait_queue_head_t commit_wait;
-- 
1.7.7.6

