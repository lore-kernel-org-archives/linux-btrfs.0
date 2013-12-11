Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:46973 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3LKXkq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:40:46 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Wed, 11 Dec 2013 16:40:45 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 628A91FF001A
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:21 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08026.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBBLcoqV9961848
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 22:38:50 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBBNeiEi030668
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:44 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/7] btrfs: subpagesize-blocksize: Define extent_buffer_head
Date: Wed, 11 Dec 2013 17:38:36 -0600
Message-Id: <1386805122-23972-2-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to handle multiple extent buffers per page, first we
need to create a way to handle all the extent buffers that
are attached to a page.

This patch creates a new data structure eb_head, and moves
fields that are common to all extent buffers in a page from
extent buffer to eb_head.

This also adds changes that are needed to handle multiple
extent buffers per page case.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/btrfs/backref.c           |   6 +-
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |   6 +-
 fs/btrfs/disk-io.c           | 109 +++++++----
 fs/btrfs/extent-tree.c       |   6 +-
 fs/btrfs/extent_io.c         | 429 +++++++++++++++++++++++++++----------------
 fs/btrfs/extent_io.h         |  55 ++++--
 fs/btrfs/volumes.c           |   2 +-
 include/trace/events/btrfs.h |   2 +-
 9 files changed, 390 insertions(+), 227 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3775947..af1943f 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1283,7 +1283,7 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
 		if (eb != eb_in) {
-			atomic_inc(&eb->refs);
+			atomic_inc(&eb_head(eb)->refs);
 			btrfs_tree_read_lock(eb);
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		}
@@ -1616,7 +1616,7 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 		slot = path->slots[0];
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
-		atomic_inc(&eb->refs);
+		atomic_inc(&eb_head(eb)->refs);
 		btrfs_tree_read_lock(eb);
 		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		btrfs_release_path(path);
@@ -1676,7 +1676,7 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 		slot = path->slots[0];
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
-		atomic_inc(&eb->refs);
+		atomic_inc(&eb_head(eb)->refs);
 
 		btrfs_tree_read_lock(eb);
 		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 316136b..611b27e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -170,7 +170,7 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
 		 * the inc_not_zero dance and if it doesn't work then
 		 * synchronize_rcu and try again.
 		 */
-		if (atomic_inc_not_zero(&eb->refs)) {
+		if (atomic_inc_not_zero(&eb_head(eb)->refs)) {
 			rcu_read_unlock();
 			break;
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 54ab861..02de448 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2106,14 +2106,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
 {									\
-	type *p = page_address(eb->pages[0]);				\
+	type *p = page_address(eb_head(eb)->pages[0]) +			\
+				(eb->start & (PAGE_CACHE_SIZE -1));	\
 	u##bits res = le##bits##_to_cpu(p->member);			\
 	return res;							\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    u##bits val)			\
 {									\
-	type *p = page_address(eb->pages[0]);				\
+	type *p = page_address(eb_head(eb)->pages[0]) +			\
+				(eb->start & (PAGE_CACHE_SIZE -1));	\
 	p->member = cpu_to_le##bits(val);				\
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8072cfa..ca1526d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -411,7 +411,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	int mirror_num = 0;
 	int failed_mirror = 0;
 
-	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_CORRUPT, &eb_head(eb)->bflags);
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	while (1) {
 		ret = read_extent_buffer_pages(io_tree, eb, start,
@@ -430,7 +430,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		 * there is no reason to read the other copies, they won't be
 		 * any less wrong.
 		 */
-		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
+		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb_head(eb)->bflags))
 			break;
 
 		num_copies = btrfs_num_copies(root->fs_info,
@@ -440,7 +440,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 
 		if (!failed_mirror) {
 			failed = 1;
-			failed_mirror = eb->read_mirror;
+			failed_mirror = eb_head(eb)->read_mirror;
 		}
 
 		mirror_num++;
@@ -465,19 +465,22 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
 	struct extent_io_tree *tree;
-	u64 start = page_offset(page);
 	u64 found_start;
 	struct extent_buffer *eb;
+	struct extent_buffer_head *eb_head;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-	eb = (struct extent_buffer *)page->private;
-	if (page != eb->pages[0])
+	eb_head = (struct extent_buffer_head *)page->private;
+	if (page != eb_head->pages[0])
 		return 0;
-	found_start = btrfs_header_bytenr(eb);
-	if (WARN_ON(found_start != start || !PageUptodate(page)))
+	if (WARN_ON(!PageUptodate(page)))
 		return 0;
-	csum_tree_block(root, eb, 0);
+	for (eb = &eb_head->extent_buf[0]; eb->start; eb++) {
+		found_start = btrfs_header_bytenr(eb);
+		if (found_start == eb->start)
+			csum_tree_block(root, eb, 0);
+	}
 	return 0;
 }
 
@@ -575,25 +578,34 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	int ret = 0;
-	int reads_done;
+	int reads_done = 0;
+	struct extent_buffer_head *eb_head;
 
 	if (!page->private)
 		goto out;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	eb = (struct extent_buffer *)page->private;
+	eb_head = (struct extent_buffer_head *)page->private;
+
+	/* Get the eb corresponding to this IO */
+	eb = eb_head->io_eb;
+	if (!eb) {
+		ret = -EIO;
+		goto err;
+	}
+	eb_head->io_eb = NULL;
 
 	/* the pending IO might have been the only thing that kept this buffer
 	 * in memory.  Make sure we have a ref for all this other checks
 	 */
 	extent_buffer_get(eb);
 
-	reads_done = atomic_dec_and_test(&eb->io_pages);
+	reads_done = atomic_dec_and_test(&eb_head->io_pages);
 	if (!reads_done)
 		goto err;
 
-	eb->read_mirror = mirror;
-	if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
+	eb_head->read_mirror = mirror;
+	if (test_bit(EXTENT_BUFFER_IOERR, &eb_head->bflags)) {
 		ret = -EIO;
 		goto err;
 	}
@@ -635,7 +647,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 * return -EIO.
 	 */
 	if (found_level == 0 && check_leaf(root, eb)) {
-		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+		set_bit(EXTENT_BUFFER_CORRUPT, &eb_head->bflags);
 		ret = -EIO;
 	}
 
@@ -643,7 +655,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		set_extent_buffer_uptodate(eb);
 err:
 	if (reads_done &&
-	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
+	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb_head->bflags))
 		btree_readahead_hook(root, eb, eb->start, ret);
 
 	if (ret) {
@@ -652,7 +664,7 @@ err:
 		 * again, we have to make sure it has something
 		 * to decrement
 		 */
-		atomic_inc(&eb->io_pages);
+		atomic_inc(&eb_head->io_pages);
 		clear_extent_buffer_uptodate(eb);
 	}
 	free_extent_buffer(eb);
@@ -662,15 +674,22 @@ out:
 
 static int btree_io_failed_hook(struct page *page, int failed_mirror)
 {
+	struct extent_buffer_head *eb_head
+			=  (struct extent_buffer_head *)page->private;
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 
-	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb->io_pages);
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
+	set_bit(EXTENT_BUFFER_IOERR, &eb_head->bflags);
+	eb_head->read_mirror = failed_mirror;
+	atomic_dec(&eb_head->io_pages);
+	/* Get the eb corresponding to this IO */
+	eb = eb_head->io_eb;
+	if (!eb)
+		goto out;
+	eb_head->io_eb = NULL;
+	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb_head->bflags))
 		btree_readahead_hook(root, eb, eb->start, -EIO);
+out:
 	return -EIO;	/* we fixed nothing */
 }
 
@@ -1021,14 +1040,20 @@ static void btree_invalidatepage(struct page *page, unsigned int offset,
 static int btree_set_page_dirty(struct page *page)
 {
 #ifdef DEBUG
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
+	int i, dirty = 0;
 
 	BUG_ON(!PagePrivate(page));
-	eb = (struct extent_buffer *)page->private;
-	BUG_ON(!eb);
-	BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-	BUG_ON(!atomic_read(&eb->refs));
-	btrfs_assert_tree_locked(eb);
+	ebh = (struct extent_buffer_head *)page->private;
+	BUG_ON(!ebh);
+	for (i = 0; i < MAX_EXTENT_BUFFERS_PER_PAGE && !dirty; i++) {
+		eb = &ebh->extent_buf[i];
+		dirty = test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
+	}
+	BUG_ON(dirty);
+	BUG_ON(!atomic_read(&ebh->refs));
+	btrfs_assert_tree_locked(&ebh->extent_buf[0]);
 #endif
 	return __set_page_dirty_nobuffers(page);
 }
@@ -1072,7 +1097,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	if (!buf)
 		return 0;
 
-	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
+	set_bit(EXTENT_BUFFER_READAHEAD, &eb_head(buf)->bflags);
 
 	ret = read_extent_buffer_pages(io_tree, buf, 0, WAIT_PAGE_LOCK,
 				       btree_get_extent, mirror_num);
@@ -1081,7 +1106,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 		return ret;
 	}
 
-	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
+	if (test_bit(EXTENT_BUFFER_CORRUPT, &eb_head(buf)->bflags)) {
 		free_extent_buffer(buf);
 		return -EIO;
 	} else if (extent_buffer_uptodate(buf)) {
@@ -1115,14 +1140,16 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 
 int btrfs_write_tree_block(struct extent_buffer *buf)
 {
-	return filemap_fdatawrite_range(buf->pages[0]->mapping, buf->start,
+	return filemap_fdatawrite_range(eb_head(buf)->pages[0]->mapping,
+					buf->start,
 					buf->start + buf->len - 1);
 }
 
 int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
 {
-	return filemap_fdatawait_range(buf->pages[0]->mapping,
-				       buf->start, buf->start + buf->len - 1);
+	return filemap_fdatawait_range(eb_head(buf)->pages[0]->mapping,
+					buf->start,
+					buf->start + buf->len - 1);
 }
 
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
@@ -1153,7 +1180,8 @@ void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	    fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
-		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
+		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
+						&buf->ebflags)) {
 			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
 					     -buf->len,
 					     fs_info->dirty_metadata_batch);
@@ -2613,7 +2641,8 @@ int open_ctree(struct super_block *sb,
 					   btrfs_super_chunk_root(disk_super),
 					   blocksize, generation);
 	if (!chunk_root->node ||
-	    !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
+	    !test_bit(EXTENT_BUFFER_UPTODATE,
+					&eb_head(chunk_root->node)->bflags)) {
 		printk(KERN_WARNING "btrfs: failed to read chunk root on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
@@ -2652,7 +2681,8 @@ retry_root_backup:
 					  btrfs_super_root(disk_super),
 					  blocksize, generation);
 	if (!tree_root->node ||
-	    !test_bit(EXTENT_BUFFER_UPTODATE, &tree_root->node->bflags)) {
+	    !test_bit(EXTENT_BUFFER_UPTODATE,
+					&eb_head(tree_root->node)->bflags)) {
 		printk(KERN_WARNING "btrfs: failed to read tree root on %s\n",
 		       sb->s_id);
 
@@ -3619,7 +3649,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic)
 {
 	int ret;
-	struct inode *btree_inode = buf->pages[0]->mapping->host;
+	struct inode *btree_inode = eb_head(buf)->pages[0]->mapping->host;
 
 	ret = extent_buffer_uptodate(buf);
 	if (!ret)
@@ -3652,7 +3682,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
 		return;
 #endif
-	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	root = BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
 	btrfs_assert_tree_locked(buf);
 	if (transid != root->fs_info->generation)
 		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
@@ -3701,7 +3731,8 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
 
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 {
-	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	struct btrfs_root *root =
+			BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
 	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
@@ -3938,7 +3969,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 			wait_on_extent_buffer_writeback(eb);
 
 			if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
-					       &eb->bflags))
+					       &eb->ebflags))
 				clear_extent_buffer_dirty(eb);
 			free_extent_buffer_stale(eb);
 		}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 45d98d0..79cf87f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6019,7 +6019,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 
-		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
+		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->ebflags));
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE);
@@ -6036,7 +6036,7 @@ out:
 	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
 	 * anymore.
 	 */
-	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_CORRUPT, &eb_head(buf)->bflags);
 	btrfs_put_block_group(cache);
 }
 
@@ -6910,7 +6910,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
 	clean_tree_block(trans, root, buf);
-	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_STALE, &eb_head(buf)->bflags);
 
 	btrfs_set_lock_blocking(buf);
 	btrfs_set_buffer_uptodate(buf);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ff43802..a1a849b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -54,8 +54,10 @@ void btrfs_leak_debug_del(struct list_head *entry)
 static inline
 void btrfs_leak_debug_check(void)
 {
+	int i;
 	struct extent_state *state;
 	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh;
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
@@ -68,12 +70,17 @@ void btrfs_leak_debug_check(void)
 	}
 
 	while (!list_empty(&buffers)) {
-		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
-		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
-		       "refs %d\n",
-		       eb->start, eb->len, atomic_read(&eb->refs));
-		list_del(&eb->leak_list);
-		kmem_cache_free(extent_buffer_cache, eb);
+		ebh = list_entry(buffers.next, struct extent_buffer_head, leak_list);
+		printk(KERN_ERR "btrfs buffer leak ");
+		for (i = 0; i < MAX_EXTENT_BUFFERS_PER_PAGE; i++) {
+			eb = &ebh->extent_buf[i];
+			if (!eb->start)
+				break;
+			printk(KERN_ERR "eb %p %llu:%lu ", eb, eb->start, eb->len);
+		}
+		printk(KERN_ERR "refs %d\n", atomic_read(&ebh->refs));
+		list_del(&ebh->leak_list);
+		kmem_cache_free(extent_buffer_cache, ebh);
 	}
 }
 
@@ -136,7 +143,7 @@ int __init extent_io_init(void)
 		return -ENOMEM;
 
 	extent_buffer_cache = kmem_cache_create("btrfs_extent_buffer",
-			sizeof(struct extent_buffer), 0,
+			sizeof(struct extent_buffer_head), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_buffer_cache)
 		goto free_state_cache;
@@ -2023,7 +2030,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num)
 {
-	u64 start = eb->start;
+	u64 start = eb_head(eb)->extent_buf[0].start;
 	unsigned long i, num_pages = num_extent_pages(eb->start, eb->len);
 	int ret = 0;
 
@@ -2680,15 +2687,15 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	return ret;
 }
 
-static void attach_extent_buffer_page(struct extent_buffer *eb,
+static void attach_extent_buffer_page(struct extent_buffer_head *ebh,
 				      struct page *page)
 {
 	if (!PagePrivate(page)) {
 		SetPagePrivate(page);
 		page_cache_get(page);
-		set_page_private(page, (unsigned long)eb);
+		set_page_private(page, (unsigned long)ebh);
 	} else {
-		WARN_ON(page->private != (unsigned long)eb);
+		WARN_ON(page->private != (unsigned long)ebh);
 	}
 }
 
@@ -3327,17 +3334,19 @@ static int eb_wait(void *word)
 
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	wait_on_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK, eb_wait,
+	wait_on_bit(&eb_head(eb)->bflags, EXTENT_BUFFER_WRITEBACK, eb_wait,
 		    TASK_UNINTERRUPTIBLE);
 }
 
-static int lock_extent_buffer_for_io(struct extent_buffer *eb,
+static int lock_extent_buffer_for_io(struct extent_buffer_head *ebh,
 				     struct btrfs_fs_info *fs_info,
 				     struct extent_page_data *epd)
 {
 	unsigned long i, num_pages;
 	int flush = 0;
+	bool dirty = false, dirty_arr[MAX_EXTENT_BUFFERS_PER_PAGE];
 	int ret = 0;
+	struct extent_buffer *eb = &ebh->extent_buf[0], *ebtemp;
 
 	if (!btrfs_try_tree_write_lock(eb)) {
 		flush = 1;
@@ -3345,7 +3354,7 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 		btrfs_tree_lock(eb);
 	}
 
-	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_WRITEBACK, &ebh->bflags)) {
 		btrfs_tree_unlock(eb);
 		if (!epd->sync_io)
 			return 0;
@@ -3356,7 +3365,7 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 		while (1) {
 			wait_on_extent_buffer_writeback(eb);
 			btrfs_tree_lock(eb);
-			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
+			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &ebh->bflags))
 				break;
 			btrfs_tree_unlock(eb);
 		}
@@ -3367,17 +3376,27 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 	 * under IO since we can end up having no IO bits set for a short period
 	 * of time.
 	 */
-	spin_lock(&eb->refs_lock);
-	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
-		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
-		spin_unlock(&eb->refs_lock);
-		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-		__percpu_counter_add(&fs_info->dirty_metadata_bytes,
-				     -eb->len,
+	spin_lock(&ebh->refs_lock);
+	for (i = 0; i < MAX_EXTENT_BUFFERS_PER_PAGE; i++) {
+		ebtemp = &ebh->extent_buf[i];
+		dirty_arr[i] |= test_and_clear_bit(EXTENT_BUFFER_DIRTY, &ebtemp->ebflags);
+		dirty = dirty || dirty_arr[i];
+	}
+	if (dirty) {
+		set_bit(EXTENT_BUFFER_WRITEBACK, &ebh->bflags);
+		spin_unlock(&ebh->refs_lock);
+		for (i = 0; i < MAX_EXTENT_BUFFERS_PER_PAGE; i++) {
+			if (dirty_arr[i] == false)
+				continue;
+			ebtemp = &ebh->extent_buf[i];
+			btrfs_set_header_flag(ebtemp, BTRFS_HEADER_FLAG_WRITTEN);
+			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
+				     -ebtemp->len,
 				     fs_info->dirty_metadata_batch);
+		}
 		ret = 1;
 	} else {
-		spin_unlock(&eb->refs_lock);
+		spin_unlock(&ebh->refs_lock);
 	}
 
 	btrfs_tree_unlock(eb);
@@ -3401,30 +3420,30 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 	return ret;
 }
 
-static void end_extent_buffer_writeback(struct extent_buffer *eb)
+static void end_extent_buffer_writeback(struct extent_buffer_head *ebh)
 {
-	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_WRITEBACK, &ebh->bflags);
 	smp_mb__after_clear_bit();
-	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
+	wake_up_bit(&ebh->bflags, EXTENT_BUFFER_WRITEBACK);
 }
 
 static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 {
 	int uptodate = err == 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh;
 	int done;
 
 	do {
 		struct page *page = bvec->bv_page;
 
 		bvec--;
-		eb = (struct extent_buffer *)page->private;
-		BUG_ON(!eb);
-		done = atomic_dec_and_test(&eb->io_pages);
+		ebh = (struct extent_buffer_head *)page->private;
+		BUG_ON(!ebh);
+		done = atomic_dec_and_test(&ebh->io_pages);
 
-		if (!uptodate || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
-			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+		if (!uptodate || test_bit(EXTENT_BUFFER_IOERR, &ebh->bflags)) {
+			set_bit(EXTENT_BUFFER_IOERR, &ebh->bflags);
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
@@ -3434,7 +3453,7 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 		if (!done)
 			continue;
 
-		end_extent_buffer_writeback(eb);
+		end_extent_buffer_writeback(ebh);
 	} while (bvec >= bio->bi_io_vec);
 
 	bio_put(bio);
@@ -3447,15 +3466,15 @@ static int write_one_eb(struct extent_buffer *eb,
 			struct extent_page_data *epd)
 {
 	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
-	u64 offset = eb->start;
+	u64 offset = eb->start & ~(PAGE_CACHE_SIZE - 1);
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
 	int ret = 0;
 
-	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_IOERR, &eb_head(eb)->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
-	atomic_set(&eb->io_pages, num_pages);
+	atomic_set(&eb_head(eb)->io_pages, num_pages);
 	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 		bio_flags = EXTENT_BIO_TREE_LOG;
 
@@ -3464,16 +3483,17 @@ static int write_one_eb(struct extent_buffer *eb,
 
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
-		ret = submit_extent_page(rw, eb->tree, p, offset >> 9,
+		ret = submit_extent_page(rw, eb_head(eb)->tree, p, offset >> 9,
 					 PAGE_CACHE_SIZE, 0, bdev, &epd->bio,
 					 -1, end_bio_extent_buffer_writepage,
 					 0, epd->bio_flags, bio_flags);
 		epd->bio_flags = bio_flags;
 		if (ret) {
-			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+			set_bit(EXTENT_BUFFER_IOERR, &eb_head(eb)->bflags);
 			SetPageError(p);
-			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
-				end_extent_buffer_writeback(eb);
+			if (atomic_sub_and_test(num_pages - i,
+							&eb_head(eb)->io_pages))
+				end_extent_buffer_writeback(eb_head(eb));
 			ret = -EIO;
 			break;
 		}
@@ -3497,7 +3517,8 @@ int btree_write_cache_pages(struct address_space *mapping,
 {
 	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
 	struct btrfs_fs_info *fs_info = BTRFS_I(mapping->host)->root->fs_info;
-	struct extent_buffer *eb, *prev_eb = NULL;
+	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh, *prev_ebh = NULL;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
@@ -3554,30 +3575,31 @@ retry:
 				continue;
 			}
 
-			eb = (struct extent_buffer *)page->private;
+			ebh = (struct extent_buffer_head *)page->private;
 
 			/*
 			 * Shouldn't happen and normally this would be a BUG_ON
 			 * but no sense in crashing the users box for something
 			 * we can survive anyway.
 			 */
-			if (WARN_ON(!eb)) {
+			if (WARN_ON(!ebh)) {
 				spin_unlock(&mapping->private_lock);
 				continue;
 			}
 
-			if (eb == prev_eb) {
+			if (ebh == prev_ebh) {
 				spin_unlock(&mapping->private_lock);
 				continue;
 			}
 
-			ret = atomic_inc_not_zero(&eb->refs);
+			ret = atomic_inc_not_zero(&ebh->refs);
 			spin_unlock(&mapping->private_lock);
 			if (!ret)
 				continue;
 
-			prev_eb = eb;
-			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
+			eb = &ebh->extent_buf[0];
+			prev_ebh = ebh;
+			ret = lock_extent_buffer_for_io(ebh, fs_info, &epd);
 			if (!ret) {
 				free_extent_buffer(eb);
 				continue;
@@ -4257,17 +4279,23 @@ out:
 	return ret;
 }
 
-static void __free_extent_buffer(struct extent_buffer *eb)
+static void __free_extent_buffer(struct extent_buffer_head *ebh)
 {
-	btrfs_leak_debug_del(&eb->leak_list);
-	kmem_cache_free(extent_buffer_cache, eb);
+	btrfs_leak_debug_del(&ebh->leak_list);
+	kmem_cache_free(extent_buffer_cache, ebh);
 }
 
-static int extent_buffer_under_io(struct extent_buffer *eb)
+static int extent_buffer_under_io(struct extent_buffer_head *ebh)
 {
-	return (atomic_read(&eb->io_pages) ||
-		test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
-		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+	int i, dirty = 0;
+	struct extent_buffer *eb;
+
+	for (i = 0; i < MAX_EXTENT_BUFFERS_PER_PAGE && !dirty; i++) {
+		eb = &ebh->extent_buf[i];
+		dirty = test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
+	}
+	return (dirty || atomic_read(&ebh->io_pages) ||
+		test_bit(EXTENT_BUFFER_WRITEBACK, &ebh->bflags));
 }
 
 /*
@@ -4279,9 +4307,10 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 	unsigned long index;
 	unsigned long num_pages;
 	struct page *page;
-	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+	struct extent_buffer_head *ebh = eb_head(eb);
+	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &ebh->bflags);
 
-	BUG_ON(extent_buffer_under_io(eb));
+	BUG_ON(extent_buffer_under_io(ebh));
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	index = start_idx + num_pages;
@@ -4301,8 +4330,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 			 * this eb.
 			 */
 			if (PagePrivate(page) &&
-			    page->private == (unsigned long)eb) {
-				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+			    page->private == (unsigned long)ebh) {
+				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags));
 				BUG_ON(PageDirty(page));
 				BUG_ON(PageWriteback(page));
 				/*
@@ -4330,23 +4359,14 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 {
 	btrfs_release_extent_buffer_page(eb, 0);
-	__free_extent_buffer(eb);
+	__free_extent_buffer(eb_head(eb));
 }
 
-static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
-						   u64 start,
-						   unsigned long len,
-						   gfp_t mask)
+static void __init_extent_buffer(struct extent_buffer *eb, u64 start,
+				unsigned long len)
 {
-	struct extent_buffer *eb = NULL;
-
-	eb = kmem_cache_zalloc(extent_buffer_cache, mask);
-	if (eb == NULL)
-		return NULL;
 	eb->start = start;
 	eb->len = len;
-	eb->tree = tree;
-	eb->bflags = 0;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
 	atomic_set(&eb->read_locks, 0);
@@ -4357,12 +4377,27 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
+}
+
+static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
+						   u64 start,
+						   unsigned long len,
+						   gfp_t mask)
+{
+	struct extent_buffer_head *ebh = NULL;
+	struct extent_buffer *eb = NULL;
+	int i, index = -1;
 
-	btrfs_leak_debug_add(&eb->leak_list, &buffers);
+	ebh = kmem_cache_zalloc(extent_buffer_cache, mask);
+	if (ebh == NULL)
+		return NULL;
+	ebh->tree = tree;
+	ebh->bflags = 0;
+	btrfs_leak_debug_add(&ebh->leak_list, &buffers);
 
-	spin_lock_init(&eb->refs_lock);
-	atomic_set(&eb->refs, 1);
-	atomic_set(&eb->io_pages, 0);
+	spin_lock_init(&ebh->refs_lock);
+	atomic_set(&ebh->refs, 1);
+	atomic_set(&ebh->io_pages, 0);
 
 	/*
 	 * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
@@ -4371,6 +4406,34 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		> MAX_INLINE_EXTENT_BUFFER_SIZE);
 	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
 
+	if (len < PAGE_CACHE_SIZE) {
+		u64 st = start & ~(PAGE_CACHE_SIZE - 1);
+		unsigned long totlen = 0;
+		/*
+		 * Make sure we have enough room to fit extent buffers
+		 * that belong a single page in a single extent_buffer_head.
+		 * If this BUG_ON is tripped, then it means either the
+		 * blocksize, i.e len, is too small or we need to increase
+		 * MAX_EXTENT_BUFFERS_PER_PAGE.
+		 */
+		BUG_ON(len * MAX_EXTENT_BUFFERS_PER_PAGE < PAGE_CACHE_SIZE);
+
+		for (i = 0; i < MAX_EXTENT_BUFFERS_PER_PAGE
+				&& totlen < PAGE_CACHE_SIZE ;
+				i++, st += len, totlen += len) {
+			__init_extent_buffer(&ebh->extent_buf[i], st, len);
+			if (st == start) {
+				index = i;
+				eb = &ebh->extent_buf[i];
+			}
+
+		}
+		BUG_ON(!eb);
+	} else {
+		eb = &ebh->extent_buf[0];
+		__init_extent_buffer(eb, start, len);
+	}
+
 	return eb;
 }
 
@@ -4391,15 +4454,15 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 			btrfs_release_extent_buffer(new);
 			return NULL;
 		}
-		attach_extent_buffer_page(new, p);
+		attach_extent_buffer_page(eb_head(new), p);
 		WARN_ON(PageDirty(p));
 		SetPageUptodate(p);
-		new->pages[i] = p;
+		eb_head(new)->pages[i] = p;
 	}
 
 	copy_extent_buffer(new, src, 0, 0, src->len);
-	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
-	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
+	set_bit(EXTENT_BUFFER_UPTODATE, &eb_head(new)->bflags);
+	set_bit(EXTENT_BUFFER_DUMMY, &eb_head(new)->bflags);
 
 	return new;
 }
@@ -4415,19 +4478,19 @@ struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
 		return NULL;
 
 	for (i = 0; i < num_pages; i++) {
-		eb->pages[i] = alloc_page(GFP_NOFS);
-		if (!eb->pages[i])
+		eb_head(eb)->pages[i] = alloc_page(GFP_NOFS);
+		if (!eb_head(eb)->pages[i])
 			goto err;
 	}
 	set_extent_buffer_uptodate(eb);
 	btrfs_set_header_nritems(eb, 0);
-	set_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+	set_bit(EXTENT_BUFFER_DUMMY, &eb_head(eb)->bflags);
 
 	return eb;
 err:
 	for (; i > 0; i--)
-		__free_page(eb->pages[i - 1]);
-	__free_extent_buffer(eb);
+		__free_page(eb_head(eb)->pages[i - 1]);
+	__free_extent_buffer(eb_head(eb));
 	return NULL;
 }
 
@@ -4454,14 +4517,15 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
 	 * So bump the ref count first, then set the bit.  If someone
 	 * beat us to it, drop the ref we added.
 	 */
-	refs = atomic_read(&eb->refs);
-	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
+	refs = atomic_read(&eb_head(eb)->refs);
+	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF,
+						&eb_head(eb)->bflags))
 		return;
 
-	spin_lock(&eb->refs_lock);
-	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_inc(&eb->refs);
-	spin_unlock(&eb->refs_lock);
+	spin_lock(&eb_head(eb)->refs_lock);
+	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb_head(eb)->bflags))
+		atomic_inc(&eb_head(eb)->refs);
+	spin_unlock(&eb_head(eb)->refs_lock);
 }
 
 static void mark_extent_buffer_accessed(struct extent_buffer *eb)
@@ -4481,13 +4545,22 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 		u64 start)
 {
 	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh;
+	int i = 0;
 
 	rcu_read_lock();
-	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
+	ebh = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	if (ebh && atomic_inc_not_zero(&ebh->refs)) {
 		rcu_read_unlock();
-		mark_extent_buffer_accessed(eb);
-		return eb;
+
+		do {
+			eb = &ebh->extent_buf[i++];
+			if (eb->start == start) {
+				mark_extent_buffer_accessed(eb);
+				return eb;
+			}
+		} while (i < MAX_EXTENT_BUFFERS_PER_PAGE);
+		BUG();
 	}
 	rcu_read_unlock();
 
@@ -4500,8 +4573,8 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
-	struct extent_buffer *eb;
-	struct extent_buffer *exists = NULL;
+	struct extent_buffer *eb, *old_eb = NULL;
+	struct extent_buffer_head *exists = NULL;
 	struct page *p;
 	struct address_space *mapping = tree->mapping;
 	int uptodate = 1;
@@ -4530,13 +4603,20 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 			 * we can just return that one, else we know we can just
 			 * overwrite page->private.
 			 */
-			exists = (struct extent_buffer *)p->private;
+			exists = (struct extent_buffer_head *)p->private;
 			if (atomic_inc_not_zero(&exists->refs)) {
+				int j = 0;
 				spin_unlock(&mapping->private_lock);
 				unlock_page(p);
 				page_cache_release(p);
-				mark_extent_buffer_accessed(exists);
-				goto free_eb;
+				do {
+					old_eb = &exists->extent_buf[j++];
+					if (old_eb->start == start) {
+						mark_extent_buffer_accessed(old_eb);
+						goto free_eb;
+					}
+				} while (j < MAX_EXTENT_BUFFERS_PER_PAGE);
+				BUG();
 			}
 
 			/*
@@ -4547,11 +4627,11 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 			WARN_ON(PageDirty(p));
 			page_cache_release(p);
 		}
-		attach_extent_buffer_page(eb, p);
+		attach_extent_buffer_page(eb_head(eb), p);
 		spin_unlock(&mapping->private_lock);
 		WARN_ON(PageDirty(p));
 		mark_page_accessed(p);
-		eb->pages[i] = p;
+		eb_head(eb)->pages[i] = p;
 		if (!PageUptodate(p))
 			uptodate = 0;
 
@@ -4561,19 +4641,20 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 		 */
 	}
 	if (uptodate)
-		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+		set_bit(EXTENT_BUFFER_UPTODATE, &eb_head(eb)->bflags);
 again:
 	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
 	if (ret)
 		goto free_eb;
 
 	spin_lock(&tree->buffer_lock);
-	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
+	ret = radix_tree_insert(&tree->buffer,
+				start >> PAGE_CACHE_SHIFT, eb_head(eb));
 	spin_unlock(&tree->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
-		exists = find_extent_buffer(tree, start);
-		if (exists)
+		old_eb = find_extent_buffer(tree, start);
+		if (old_eb)
 			goto free_eb;
 		else
 			goto again;
@@ -4590,58 +4671,58 @@ again:
 	 * after the extent buffer is in the radix tree so
 	 * it doesn't get lost
 	 */
-	SetPageChecked(eb->pages[0]);
+	SetPageChecked(eb_head(eb)->pages[0]);
 	for (i = 1; i < num_pages; i++) {
 		p = extent_buffer_page(eb, i);
 		ClearPageChecked(p);
 		unlock_page(p);
 	}
-	unlock_page(eb->pages[0]);
+	unlock_page(eb_head(eb)->pages[0]);
 	return eb;
 
 free_eb:
 	for (i = 0; i < num_pages; i++) {
-		if (eb->pages[i])
-			unlock_page(eb->pages[i]);
+		if (eb_head(eb)->pages[i])
+			unlock_page(eb_head(eb)->pages[i]);
 	}
 
-	WARN_ON(!atomic_dec_and_test(&eb->refs));
+	WARN_ON(!atomic_dec_and_test(&eb_head(eb)->refs));
 	btrfs_release_extent_buffer(eb);
-	return exists;
+	return old_eb;
 }
 
 static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 {
-	struct extent_buffer *eb =
-			container_of(head, struct extent_buffer, rcu_head);
+	struct extent_buffer_head *ebh =
+			container_of(head, struct extent_buffer_head, rcu_head);
 
-	__free_extent_buffer(eb);
+	__free_extent_buffer(ebh);
 }
 
 /* Expects to have eb->eb_lock already held */
-static int release_extent_buffer(struct extent_buffer *eb)
+static int release_extent_buffer(struct extent_buffer_head *ebh)
 {
-	WARN_ON(atomic_read(&eb->refs) == 0);
-	if (atomic_dec_and_test(&eb->refs)) {
-		if (test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags)) {
-			spin_unlock(&eb->refs_lock);
+	WARN_ON(atomic_read(&ebh->refs) == 0);
+	if (atomic_dec_and_test(&ebh->refs)) {
+		if (test_bit(EXTENT_BUFFER_DUMMY, &ebh->bflags)) {
+			spin_unlock(&ebh->refs_lock);
 		} else {
-			struct extent_io_tree *tree = eb->tree;
+			struct extent_io_tree *tree = ebh->tree;
 
-			spin_unlock(&eb->refs_lock);
+			spin_unlock(&ebh->refs_lock);
 
 			spin_lock(&tree->buffer_lock);
 			radix_tree_delete(&tree->buffer,
-					  eb->start >> PAGE_CACHE_SHIFT);
+				ebh->extent_buf[0].start >> PAGE_CACHE_SHIFT);
 			spin_unlock(&tree->buffer_lock);
 		}
 
 		/* Should be safe to release our pages at this point */
-		btrfs_release_extent_buffer_page(eb, 0);
-		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
+		btrfs_release_extent_buffer_page(&ebh->extent_buf[0], 0);
+		call_rcu(&ebh->rcu_head, btrfs_release_extent_buffer_rcu);
 		return 1;
 	}
-	spin_unlock(&eb->refs_lock);
+	spin_unlock(&ebh->refs_lock);
 
 	return 0;
 }
@@ -4650,48 +4731,52 @@ void free_extent_buffer(struct extent_buffer *eb)
 {
 	int refs;
 	int old;
+	struct extent_buffer_head *ebh;
 	if (!eb)
 		return;
 
+	ebh = eb_head(eb);
 	while (1) {
-		refs = atomic_read(&eb->refs);
+		refs = atomic_read(&ebh->refs);
 		if (refs <= 3)
 			break;
-		old = atomic_cmpxchg(&eb->refs, refs, refs - 1);
+		old = atomic_cmpxchg(&ebh->refs, refs, refs - 1);
 		if (old == refs)
 			return;
 	}
 
-	spin_lock(&eb->refs_lock);
-	if (atomic_read(&eb->refs) == 2 &&
-	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
-		atomic_dec(&eb->refs);
+	spin_lock(&ebh->refs_lock);
+	if (atomic_read(&ebh->refs) == 2 &&
+	    test_bit(EXTENT_BUFFER_DUMMY, &ebh->bflags))
+		atomic_dec(&ebh->refs);
 
-	if (atomic_read(&eb->refs) == 2 &&
-	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
-	    !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
+	if (atomic_read(&ebh->refs) == 2 &&
+	    test_bit(EXTENT_BUFFER_STALE, &ebh->bflags) &&
+	    !extent_buffer_under_io(ebh) &&
+	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &ebh->bflags))
+		atomic_dec(&ebh->refs);
 
 	/*
 	 * I know this is terrible, but it's temporary until we stop tracking
 	 * the uptodate bits and such for the extent buffers.
 	 */
-	release_extent_buffer(eb);
+	release_extent_buffer(ebh);
 }
 
 void free_extent_buffer_stale(struct extent_buffer *eb)
 {
+	struct extent_buffer_head *ebh;
 	if (!eb)
 		return;
 
-	spin_lock(&eb->refs_lock);
-	set_bit(EXTENT_BUFFER_STALE, &eb->bflags);
+	ebh = eb_head(eb);
+	spin_lock(&ebh->refs_lock);
+	set_bit(EXTENT_BUFFER_STALE, &ebh->bflags);
 
-	if (atomic_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
-	release_extent_buffer(eb);
+	if (atomic_read(&ebh->refs) == 2 && !extent_buffer_under_io(ebh) &&
+	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &ebh->bflags))
+		atomic_dec(&ebh->refs);
+	release_extent_buffer(ebh);
 }
 
 void clear_extent_buffer_dirty(struct extent_buffer *eb)
@@ -4721,7 +4806,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 		ClearPageError(page);
 		unlock_page(page);
 	}
-	WARN_ON(atomic_read(&eb->refs) == 0);
+	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
 }
 
 int set_extent_buffer_dirty(struct extent_buffer *eb)
@@ -4732,11 +4817,11 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 
 	check_buffer_tree_ref(eb);
 
-	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
+	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
 
 	num_pages = num_extent_pages(eb->start, eb->len);
-	WARN_ON(atomic_read(&eb->refs) == 0);
-	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
+	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
+	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb_head(eb)->bflags));
 
 	for (i = 0; i < num_pages; i++)
 		set_page_dirty(extent_buffer_page(eb, i));
@@ -4749,7 +4834,9 @@ int clear_extent_buffer_uptodate(struct extent_buffer *eb)
 	struct page *page;
 	unsigned long num_pages;
 
-	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	if (!eb || !eb_head(eb))
+		return 0;
+	clear_bit(EXTENT_BUFFER_UPTODATE, &eb_head(eb)->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
@@ -4765,7 +4852,7 @@ int set_extent_buffer_uptodate(struct extent_buffer *eb)
 	struct page *page;
 	unsigned long num_pages;
 
-	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	set_bit(EXTENT_BUFFER_UPTODATE, &eb_head(eb)->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
@@ -4776,7 +4863,7 @@ int set_extent_buffer_uptodate(struct extent_buffer *eb)
 
 int extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	return test_bit(EXTENT_BUFFER_UPTODATE, &eb_head(eb)->bflags);
 }
 
 int read_extent_buffer_pages(struct extent_io_tree *tree,
@@ -4794,8 +4881,9 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	unsigned long num_reads = 0;
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
+	struct extent_buffer_head *ebh = eb_head(eb);
 
-	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+	if (test_bit(EXTENT_BUFFER_UPTODATE, &ebh->bflags))
 		return 0;
 
 	if (start) {
@@ -4806,6 +4894,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		start_i = 0;
 	}
 
+recheck:
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
@@ -4823,13 +4912,26 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	}
 	if (all_uptodate) {
 		if (start_i == 0)
-			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+			set_bit(EXTENT_BUFFER_UPTODATE, &ebh->bflags);
 		goto unlock_exit;
 	}
 
-	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->read_mirror = 0;
-	atomic_set(&eb->io_pages, num_reads);
+	if (eb_head(eb)->io_eb) {
+		all_uptodate = 1;
+		i = start_i;
+		while (locked_pages > 0) {
+			page = extent_buffer_page(eb, i);
+			i++;
+			unlock_page(page);
+			locked_pages--;
+		}
+		goto recheck;
+	}
+	BUG_ON(eb_head(eb)->io_eb);
+	eb_head(eb)->io_eb = eb;
+	clear_bit(EXTENT_BUFFER_IOERR, &ebh->bflags);
+	ebh->read_mirror = 0;
+	atomic_set(&ebh->io_pages, num_reads);
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (!PageUptodate(page)) {
@@ -5196,7 +5298,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
 int try_release_extent_buffer(struct page *page)
 {
-	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh;
 
 	/*
 	 * We need to make sure noboody is attaching this page to an eb right
@@ -5208,17 +5310,17 @@ int try_release_extent_buffer(struct page *page)
 		return 1;
 	}
 
-	eb = (struct extent_buffer *)page->private;
-	BUG_ON(!eb);
+	ebh = (struct extent_buffer_head *)page->private;
+	BUG_ON(!ebh);
 
 	/*
 	 * This is a little awful but should be ok, we need to make sure that
 	 * the eb doesn't disappear out from under us while we're looking at
 	 * this page.
 	 */
-	spin_lock(&eb->refs_lock);
-	if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
-		spin_unlock(&eb->refs_lock);
+	spin_lock(&ebh->refs_lock);
+	if (atomic_read(&ebh->refs) != 1 || extent_buffer_under_io(ebh)) {
+		spin_unlock(&ebh->refs_lock);
 		spin_unlock(&page->mapping->private_lock);
 		return 0;
 	}
@@ -5228,10 +5330,11 @@ int try_release_extent_buffer(struct page *page)
 	 * If tree ref isn't set then we know the ref on this eb is a real ref,
 	 * so just return, this page will likely be freed soon anyway.
 	 */
-	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
-		spin_unlock(&eb->refs_lock);
+	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &ebh->bflags)) {
+		spin_unlock(&ebh->refs_lock);
 		return 0;
 	}
 
-	return release_extent_buffer(eb);
+	return release_extent_buffer(ebh);
 }
+
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 19620c5..b56de28 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -124,19 +124,12 @@ struct extent_state {
 
 #define INLINE_EXTENT_BUFFER_PAGES 16
 #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_CACHE_SIZE)
+#define MAX_EXTENT_BUFFERS_PER_PAGE 16
+
 struct extent_buffer {
 	u64 start;
 	unsigned long len;
-	unsigned long map_start;
-	unsigned long map_len;
-	unsigned long bflags;
-	struct extent_io_tree *tree;
-	spinlock_t refs_lock;
-	atomic_t refs;
-	atomic_t io_pages;
-	int read_mirror;
-	struct rcu_head rcu_head;
-	pid_t lock_owner;
+	unsigned long ebflags;
 
 	/* count of read lock holders on the extent buffer */
 	atomic_t write_locks;
@@ -147,6 +140,8 @@ struct extent_buffer {
 	atomic_t spinning_writers;
 	int lock_nested;
 
+	pid_t lock_owner;
+
 	/* protects write locks */
 	rwlock_t lock;
 
@@ -160,7 +155,21 @@ struct extent_buffer {
 	 */
 	wait_queue_head_t read_lock_wq;
 	wait_queue_head_t lock_wq;
+};
+
+struct extent_buffer_head {
+	unsigned long bflags;
+	struct extent_io_tree *tree;
+	spinlock_t refs_lock;
+	atomic_t refs;
+	atomic_t io_pages;
+	int read_mirror;
+	struct rcu_head rcu_head;
+
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
+
+	struct extent_buffer extent_buf[MAX_EXTENT_BUFFERS_PER_PAGE];
+	struct extent_buffer *io_eb; /* eb that submitted the current I/O */
 #ifdef CONFIG_BTRFS_DEBUG
 	struct list_head leak_list;
 #endif
@@ -177,6 +186,24 @@ static inline int extent_compress_type(unsigned long bio_flags)
 	return bio_flags >> EXTENT_BIO_FLAG_SHIFT;
 }
 
+/*
+ * return the extent_buffer_head that contains the extent buffer provided.
+ */
+static inline struct extent_buffer_head *eb_head(struct extent_buffer *eb)
+{
+	int start, index;
+	struct extent_buffer_head *ebh;
+	struct extent_buffer *eb_base;
+
+	BUG_ON(!eb);
+	start = eb->start & (PAGE_CACHE_SIZE - 1);
+	index = start >> (ffs(eb->len) - 1);
+	eb_base = eb - index;
+	ebh = (struct extent_buffer_head *)
+		((char *) eb_base - offsetof(struct extent_buffer_head, extent_buf));
+	return ebh;
+
+}
 struct extent_map_tree;
 
 typedef struct extent_map *(get_extent_t)(struct inode *inode,
@@ -288,15 +315,15 @@ static inline unsigned long num_extent_pages(u64 start, u64 len)
 		(start >> PAGE_CACHE_SHIFT);
 }
 
-static inline struct page *extent_buffer_page(struct extent_buffer *eb,
-					      unsigned long i)
+static inline struct page *extent_buffer_page(
+			struct extent_buffer *eb, unsigned long i)
 {
-	return eb->pages[i];
+	return eb_head(eb)->pages[i];
 }
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
-	atomic_inc(&eb->refs);
+	atomic_inc(&eb_head(eb)->refs);
 }
 
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 92303f4..37b2698 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5921,7 +5921,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	 * to silence the warning eg. on PowerPC 64.
 	 */
 	if (PAGE_CACHE_SIZE > BTRFS_SUPER_INFO_SIZE)
-		SetPageUptodate(sb->pages[0]);
+		SetPageUptodate(eb_head(sb)->pages[0]);
 
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4832d75..ceb194f 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -694,7 +694,7 @@ TRACE_EVENT(btrfs_cow_block,
 	TP_fast_assign(
 		__entry->root_objectid	= root->root_key.objectid;
 		__entry->buf_start	= buf->start;
-		__entry->refs		= atomic_read(&buf->refs);
+		__entry->refs		= atomic_read(&eb_head(buf)->refs);
 		__entry->cow_start	= cow->start;
 		__entry->buf_level	= btrfs_header_level(buf);
 		__entry->cow_level	= btrfs_header_level(cow);
-- 
1.7.12.4

