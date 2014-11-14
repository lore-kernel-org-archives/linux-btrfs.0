Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:32798 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965653AbaKNPja (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 10:39:30 -0500
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sat, 15 Nov 2014 01:39:28 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 07FBC2CE8059
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:39:26 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAEFfBDq39452896
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:41:19 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAEFcqYO021189
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:38:53 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, aneesh.kumar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com,
        steve.capper@linaro.org, Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V9 04/17] Btrfs: subpagesize-blocksize: Define extent_buffer_head.
Date: Fri, 14 Nov 2014 21:08:06 +0530
Message-Id: <1415979499-15821-5-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Chandra Seetharaman <sekharan@us.ibm.com>

In order to handle multiple extent buffers per page, first we need to create a
way to handle all the extent buffers that are attached to a page.

This patch creates a new data structure 'struct extent_buffer_head', and moves
fields that are common to all extent buffers in a page from 'struct extent
buffer' to 'struct extent_buffer_head'

Also, this patch moves EXTENT_BUFFER_TREE_REF, EXTENT_BUFFER_DUMMY and
EXTENT_BUFFER_IN_TREE flags from extent_buffer->ebflags  to
extent_buffer_head->bflags.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/backref.c           |   2 +-
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |   6 +-
 fs/btrfs/disk-io.c           |  46 ++++--
 fs/btrfs/extent-tree.c       |   6 +-
 fs/btrfs/extent_io.c         | 373 +++++++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.h         |  47 ++++--
 fs/btrfs/volumes.c           |   2 +-
 include/trace/events/btrfs.h |   2 +-
 9 files changed, 328 insertions(+), 158 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 54a201d..1d3d5d6 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1305,7 +1305,7 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
 		if (eb != eb_in) {
-			atomic_inc(&eb->refs);
+			atomic_inc(&eb_head(eb)->refs);
 			btrfs_tree_read_lock(eb);
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		}
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 44ee5d2..693b541 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -169,7 +169,7 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
 		 * the inc_not_zero dance and if it doesn't work then
 		 * synchronize_rcu and try again.
 		 */
-		if (atomic_inc_not_zero(&eb->refs)) {
+		if (atomic_inc_not_zero(&eb_head(eb)->refs)) {
 			rcu_read_unlock();
 			break;
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e29b61..5b7b7ca 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2215,14 +2215,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
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
index d0ed9e6..3a79833 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1030,13 +1030,21 @@ static int btree_set_page_dirty(struct page *page)
 {
 #ifdef DEBUG
 	struct extent_buffer *eb;
+	int i, dirty = 0;
 
 	BUG_ON(!PagePrivate(page));
 	eb = (struct extent_buffer *)page->private;
 	BUG_ON(!eb);
-	BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-	BUG_ON(!atomic_read(&eb->refs));
-	btrfs_assert_tree_locked(eb);
+
+	do {
+		dirty = test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
+		if (dirty)
+			break;
+	} while ((eb = eb->eb_next) != NULL);
+
+	BUG_ON(!dirty);
+	BUG_ON(!atomic_read(&(eb_head(eb)->refs)));
+	btrfs_assert_tree_locked(&ebh->eb);
 #endif
 	return __set_page_dirty_nobuffers(page);
 }
@@ -1080,7 +1088,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	if (!buf)
 		return 0;
 
-	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
+	set_bit(EXTENT_BUFFER_READAHEAD, &buf->ebflags);
 
 	ret = read_extent_buffer_pages(io_tree, buf, 0, WAIT_PAGE_LOCK,
 				       btree_get_extent, mirror_num);
@@ -1089,7 +1097,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 		return ret;
 	}
 
-	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
+	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags)) {
 		free_extent_buffer(buf);
 		return -EIO;
 	} else if (extent_buffer_uptodate(buf)) {
@@ -1120,14 +1128,16 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 
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
@@ -1158,7 +1168,8 @@ void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	    fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
-		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
+		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
+						&buf->ebflags)) {
 			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
 					     -buf->len,
 					     fs_info->dirty_metadata_batch);
@@ -2648,7 +2659,8 @@ int open_ctree(struct super_block *sb,
 					   btrfs_super_chunk_root(disk_super),
 					   blocksize, generation);
 	if (!chunk_root->node ||
-	    !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
+		!test_bit(EXTENT_BUFFER_UPTODATE,
+			&chunk_root->node->ebflags)) {
 		printk(KERN_WARNING "BTRFS: failed to read chunk root on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
@@ -2687,7 +2699,8 @@ retry_root_backup:
 					  btrfs_super_root(disk_super),
 					  blocksize, generation);
 	if (!tree_root->node ||
-	    !test_bit(EXTENT_BUFFER_UPTODATE, &tree_root->node->bflags)) {
+		!test_bit(EXTENT_BUFFER_UPTODATE,
+			&tree_root->node->ebflags)) {
 		printk(KERN_WARNING "BTRFS: failed to read tree root on %s\n",
 		       sb->s_id);
 
@@ -3713,7 +3726,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic)
 {
 	int ret;
-	struct inode *btree_inode = buf->pages[0]->mapping->host;
+	struct inode *btree_inode = eb_head(buf)->pages[0]->mapping->host;
 
 	ret = extent_buffer_uptodate(buf);
 	if (!ret)
@@ -3743,10 +3756,10 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	 * enabled.  Normal people shouldn't be marking dummy buffers as dirty
 	 * outside of the sanity tests.
 	 */
-	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
+	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb_head(buf)->bflags)))
 		return;
 #endif
-	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	root = BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
 	btrfs_assert_tree_locked(buf);
 	if (transid != root->fs_info->generation)
 		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
@@ -3801,7 +3814,8 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
 
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 {
-	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	struct btrfs_root *root =
+			BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
 	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
@@ -4011,7 +4025,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 			wait_on_extent_buffer_writeback(eb);
 
 			if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
-					       &eb->bflags))
+					       &eb->ebflags))
 				clear_extent_buffer_dirty(eb);
 			free_extent_buffer_stale(eb);
 		}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 102ed31..fbcad82 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6209,7 +6209,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 
-		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
+		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->ebflags));
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE, 0);
@@ -6226,7 +6226,7 @@ out:
 	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
 	 * anymore.
 	 */
-	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags);
 	btrfs_put_block_group(cache);
 }
 
@@ -7212,7 +7212,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
 	clean_tree_block(trans, root, buf);
-	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_STALE, &buf->ebflags);
 
 	btrfs_set_lock_blocking(buf);
 	btrfs_set_buffer_uptodate(buf);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7229c4d..7a923b7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -56,6 +56,7 @@ void btrfs_leak_debug_check(void)
 {
 	struct extent_state *state;
 	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh;
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
@@ -68,12 +69,17 @@ void btrfs_leak_debug_check(void)
 	}
 
 	while (!list_empty(&buffers)) {
-		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
-		printk(KERN_ERR "BTRFS: buffer leak start %llu len %lu "
-		       "refs %d\n",
-		       eb->start, eb->len, atomic_read(&eb->refs));
-		list_del(&eb->leak_list);
-		kmem_cache_free(extent_buffer_cache, eb);
+		ebh = list_entry(buffers.next, struct extent_buffer_head, leak_list);
+		printk(KERN_ERR "btrfs buffer leak ");
+
+		eb = &ebh->eb;
+		do {
+			printk(KERN_ERR "eb %p %llu:%lu ", eb, eb->start, eb->len);
+		} while ((eb = eb->eb_next) != NULL);
+
+		printk(KERN_ERR "refs %d\n", atomic_read(&ebh->refs));
+		list_del(&ebh->leak_list);
+		kmem_cache_free(extent_buffer_cache, ebh);
 	}
 }
 
@@ -144,7 +150,7 @@ int __init extent_io_init(void)
 		return -ENOMEM;
 
 	extent_buffer_cache = kmem_cache_create("btrfs_extent_buffer",
-			sizeof(struct extent_buffer), 0,
+			sizeof(struct extent_buffer_head), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_buffer_cache)
 		goto free_state_cache;
@@ -3416,7 +3422,7 @@ static int eb_wait(void *word)
 
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	wait_on_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK, eb_wait,
+	wait_on_bit(&eb->ebflags, EXTENT_BUFFER_WRITEBACK, eb_wait,
 		    TASK_UNINTERRUPTIBLE);
 }
 
@@ -4341,29 +4347,47 @@ out:
 	return ret;
 }
 
-static void __free_extent_buffer(struct extent_buffer *eb)
+static void __free_extent_buffer(struct extent_buffer_head *ebh)
 {
-	btrfs_leak_debug_del(&eb->leak_list);
-	kmem_cache_free(extent_buffer_cache, eb);
+	struct extent_buffer *eb, *next_eb;
+
+	btrfs_leak_debug_del(&ebh->leak_list);
+
+	eb = ebh->eb.eb_next;
+	while (eb) {
+		next_eb = eb->eb_next;
+		kfree(eb);
+		eb = next_eb;
+	}
+
+	kmem_cache_free(extent_buffer_cache, ebh);
 }
 
 int extent_buffer_under_io(struct extent_buffer *eb)
 {
-	return (atomic_read(&eb->io_pages) ||
-		test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
-		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+	struct extent_buffer_head *ebh = eb->ebh;
+	int dirty_or_writeback = 0;
+
+	for (eb = &ebh->eb; eb; eb = eb->eb_next) {
+		if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags)
+			|| test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags))
+			dirty_or_writeback = 1;
+	}
+
+	return (atomic_read(&ebh->io_bvecs) || dirty_or_writeback);
 }
 
 /*
  * Helper for releasing extent buffer page.
  */
 static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
-						unsigned long start_idx)
+					unsigned long start_idx)
 {
 	unsigned long index;
 	unsigned long num_pages;
 	struct page *page;
-	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+	struct extent_buffer_head *ebh = eb_head(eb);
+	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &ebh->bflags);
 
 	BUG_ON(extent_buffer_under_io(eb));
 
@@ -4373,6 +4397,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 		return;
 
 	do {
+		struct extent_buffer *e;
+
 		index--;
 		page = extent_buffer_page(eb, index);
 		if (page && mapped) {
@@ -4385,8 +4411,10 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 			 * this eb.
 			 */
 			if (PagePrivate(page) &&
-			    page->private == (unsigned long)eb) {
-				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+				page->private == (unsigned long)(&ebh->eb)) {
+				for (e = &ebh->eb; !e; e = e->eb_next)
+					BUG_ON(test_bit(EXTENT_BUFFER_DIRTY,
+								&e->ebflags));
 				BUG_ON(PageDirty(page));
 				BUG_ON(PageWriteback(page));
 				/*
@@ -4414,22 +4442,18 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 {
 	btrfs_release_extent_buffer_page(eb, 0);
-	__free_extent_buffer(eb);
+	__free_extent_buffer(eb_head(eb));
 }
 
-static struct extent_buffer *
-__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
-		      unsigned long len, gfp_t mask)
+static void __init_extent_buffer(struct extent_buffer *eb,
+				struct extent_buffer_head *ebh,
+				u64 start,
+				unsigned long len)
 {
-	struct extent_buffer *eb = NULL;
-
-	eb = kmem_cache_zalloc(extent_buffer_cache, mask);
-	if (eb == NULL)
-		return NULL;
 	eb->start = start;
 	eb->len = len;
-	eb->fs_info = fs_info;
-	eb->bflags = 0;
+	eb->ebh = ebh;
+	eb->eb_next = NULL;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
 	atomic_set(&eb->read_locks, 0);
@@ -4440,12 +4464,26 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
+}
+
+static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
+						u64 start, unsigned long len,
+						gfp_t mask)
+{
+	struct extent_buffer_head *ebh = NULL;
+	struct extent_buffer *eb = NULL;
+	int i;
 
-	btrfs_leak_debug_add(&eb->leak_list, &buffers);
+	ebh = kmem_cache_zalloc(extent_buffer_cache, mask);
+	if (ebh == NULL)
+		return NULL;
+	ebh->fs_info = fs_info;
+	ebh->bflags = 0;
+	btrfs_leak_debug_add(&ebh->leak_list, &buffers);
 
-	spin_lock_init(&eb->refs_lock);
-	atomic_set(&eb->refs, 1);
-	atomic_set(&eb->io_pages, 0);
+	spin_lock_init(&ebh->refs_lock);
+	atomic_set(&ebh->refs, 1);
+	atomic_set(&ebh->io_bvecs, 0);
 
 	/*
 	 * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
@@ -4454,6 +4492,29 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 		> MAX_INLINE_EXTENT_BUFFER_SIZE);
 	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
 
+	if (len < PAGE_CACHE_SIZE) {
+		struct extent_buffer *cur_eb, *prev_eb;
+		int ebs_per_page = PAGE_CACHE_SIZE / len;
+		u64 st = start & ~(PAGE_CACHE_SIZE - 1);
+
+		prev_eb = NULL;
+		cur_eb = &ebh->eb;
+		for (i = 0; i < ebs_per_page; i++, st += len) {
+			if (prev_eb) {
+				cur_eb = kzalloc(sizeof(*eb), mask);
+				prev_eb->eb_next = cur_eb;
+			}
+			__init_extent_buffer(cur_eb, ebh, st, len);
+			prev_eb = cur_eb;
+			if (st == start)
+				eb = cur_eb;
+		}
+		BUG_ON(!eb);
+	} else {
+		eb = &ebh->eb;
+		__init_extent_buffer(eb, ebh, start, len);
+	}
+
 	return eb;
 }
 
@@ -4474,15 +4535,16 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 			btrfs_release_extent_buffer(new);
 			return NULL;
 		}
-		attach_extent_buffer_page(new, p);
+		attach_extent_buffer_page(&(eb_head(new)->eb), p);
 		WARN_ON(PageDirty(p));
 		SetPageUptodate(p);
-		new->pages[i] = p;
+		eb_head(new)->pages[i] = p;
 	}
 
+	set_bit(EXTENT_BUFFER_UPTODATE, &new->ebflags);
+	set_bit(EXTENT_BUFFER_DUMMY, &eb_head(new)->bflags);
+
 	copy_extent_buffer(new, src, 0, 0, src->len);
-	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
-	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
 
 	return new;
 }
@@ -4498,19 +4560,19 @@ struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
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
 
@@ -4537,14 +4599,15 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
 	 * So bump the ref count first, then set the bit.  If someone
 	 * beat us to it, drop the ref we added.
 	 */
-	refs = atomic_read(&eb->refs);
-	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
+	refs = atomic_read(&eb_head(eb)->refs);
+	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF,
+					&eb_head(eb)->bflags))
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
 
 static void mark_extent_buffer_accessed(struct extent_buffer *eb,
@@ -4565,15 +4628,24 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb,
 struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 					 u64 start)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 
 	rcu_read_lock();
-	eb = radix_tree_lookup(&fs_info->buffer_radix,
-			       start >> PAGE_CACHE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
+	ebh = radix_tree_lookup(&fs_info->buffer_radix,
+				start >> PAGE_CACHE_SHIFT);
+	if (ebh && atomic_inc_not_zero(&ebh->refs)) {
 		rcu_read_unlock();
-		mark_extent_buffer_accessed(eb, NULL);
-		return eb;
+
+		eb = &ebh->eb;
+		do {
+			if (eb->start == start) {
+				mark_extent_buffer_accessed(eb, NULL);
+				return eb;
+			}
+		} while ((eb = eb->eb_next) != NULL);
+
+		BUG();
 	}
 	rcu_read_unlock();
 
@@ -4633,7 +4705,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
-	struct extent_buffer *eb;
+	struct extent_buffer *eb, *cur_eb;
 	struct extent_buffer *exists = NULL;
 	struct page *p;
 	struct address_space *mapping = fs_info->btree_inode->i_mapping;
@@ -4663,12 +4735,18 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			 * overwrite page->private.
 			 */
 			exists = (struct extent_buffer *)p->private;
-			if (atomic_inc_not_zero(&exists->refs)) {
+			if (atomic_inc_not_zero(&eb_head(exists)->refs)) {
 				spin_unlock(&mapping->private_lock);
 				unlock_page(p);
 				page_cache_release(p);
-				mark_extent_buffer_accessed(exists, p);
-				goto free_eb;
+				do {
+					if (exists->start == start) {
+						mark_extent_buffer_accessed(exists, p);
+						goto free_eb;
+					}
+				} while ((exists = exists->eb_next) != NULL);
+
+				BUG();
 			}
 
 			/*
@@ -4679,10 +4757,11 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			WARN_ON(PageDirty(p));
 			page_cache_release(p);
 		}
-		attach_extent_buffer_page(eb, p);
+		attach_extent_buffer_page(&(eb_head(eb)->eb), p);
 		spin_unlock(&mapping->private_lock);
 		WARN_ON(PageDirty(p));
-		eb->pages[i] = p;
+		mark_page_accessed(p);
+		eb_head(eb)->pages[i] = p;
 		if (!PageUptodate(p))
 			uptodate = 0;
 
@@ -4691,16 +4770,22 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		 * and why we unlock later
 		 */
 	}
-	if (uptodate)
-		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	if (uptodate) {
+		cur_eb = &(eb_head(eb)->eb);
+		do {
+			set_bit(EXTENT_BUFFER_UPTODATE, &cur_eb->ebflags);
+		} while ((cur_eb = cur_eb->eb_next) != NULL);
+	}
 again:
 	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
-	if (ret)
+	if (ret) {
+		exists = NULL;
 		goto free_eb;
+	}
 
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
-				start >> PAGE_CACHE_SHIFT, eb);
+				start >> PAGE_CACHE_SHIFT, eb_head(eb));
 	spin_unlock(&fs_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
@@ -4712,7 +4797,7 @@ again:
 	}
 	/* add one reference for the tree */
 	check_buffer_tree_ref(eb);
-	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
+	set_bit(EXTENT_BUFFER_IN_TREE, &eb_head(eb)->bflags);
 
 	/*
 	 * there is a race where release page may have
@@ -4723,108 +4808,125 @@ again:
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
 	return exists;
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
-		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags)) {
-			struct btrfs_fs_info *fs_info = eb->fs_info;
+	WARN_ON(atomic_read(&ebh->refs) == 0);
+	if (atomic_dec_and_test(&ebh->refs)) {
+		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &ebh->bflags)) {
+			struct btrfs_fs_info *fs_info = ebh->fs_info;
 
-			spin_unlock(&eb->refs_lock);
+			spin_unlock(&ebh->refs_lock);
 
 			spin_lock(&fs_info->buffer_lock);
 			radix_tree_delete(&fs_info->buffer_radix,
-					  eb->start >> PAGE_CACHE_SHIFT);
+					ebh->eb.start >> PAGE_CACHE_SHIFT);
 			spin_unlock(&fs_info->buffer_lock);
 		} else {
-			spin_unlock(&eb->refs_lock);
+			spin_unlock(&ebh->refs_lock);
 		}
 
 		/* Should be safe to release our pages at this point */
-		btrfs_release_extent_buffer_page(eb, 0);
-		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
+		btrfs_release_extent_buffer_page(&ebh->eb, 0);
+		call_rcu(&ebh->rcu_head, btrfs_release_extent_buffer_rcu);
 		return 1;
 	}
-	spin_unlock(&eb->refs_lock);
+	spin_unlock(&ebh->refs_lock);
 
 	return 0;
 }
 
 void free_extent_buffer(struct extent_buffer *eb)
 {
+	struct extent_buffer_head *ebh;
 	int refs;
 	int old;
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
+	if (atomic_read(&ebh->refs) == 2 &&
+	    test_bit(EXTENT_BUFFER_STALE, &eb->ebflags) &&
 	    !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
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
 
-	if (atomic_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
-	release_extent_buffer(eb);
+	set_bit(EXTENT_BUFFER_STALE, &eb->ebflags);
+	if (atomic_read(&ebh->refs) == 2 && !extent_buffer_under_io(eb) &&
+	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &ebh->bflags))
+		atomic_dec(&ebh->refs);
+
+	release_extent_buffer(ebh);
+}
+
+static int page_ebs_clean(struct extent_buffer_head *ebh)
+{
+	struct extent_buffer *eb = &ebh->eb;;
+
+	do {
+		if (test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags))
+			return 0;
+	} while ((eb = eb->eb_next) != NULL);
+
+	return 1;
 }
 
 void clear_extent_buffer_dirty(struct extent_buffer *eb)
@@ -4835,6 +4937,9 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 
+	if (eb->len < PAGE_CACHE_SIZE && !page_ebs_clean(eb_head(eb)))
+		return;
+
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (!PageDirty(page))
@@ -4854,7 +4959,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 		ClearPageError(page);
 		unlock_page(page);
 	}
-	WARN_ON(atomic_read(&eb->refs) == 0);
+	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
 }
 
 int set_extent_buffer_dirty(struct extent_buffer *eb)
@@ -4865,11 +4970,11 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 
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
@@ -4882,7 +4987,9 @@ int clear_extent_buffer_uptodate(struct extent_buffer *eb)
 	struct page *page;
 	unsigned long num_pages;
 
-	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	if (!eb || !eb_head(eb))
+		return 0;
+	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
@@ -4894,22 +5001,43 @@ int clear_extent_buffer_uptodate(struct extent_buffer *eb)
 
 int set_extent_buffer_uptodate(struct extent_buffer *eb)
 {
+	struct extent_buffer_head *ebh;
 	unsigned long i;
 	struct page *page;
 	unsigned long num_pages;
+	int uptodate;
 
-	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
-		SetPageUptodate(page);
+	ebh = eb->ebh;
+
+	set_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
+	if (eb->len < PAGE_CACHE_SIZE) {
+		eb = &(eb_head(eb)->eb);
+		uptodate = 1;
+		do {
+			if (!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags)) {
+				uptodate = 0;
+				break;
+			}
+		} while ((eb = eb->eb_next) != NULL);
+
+		if (uptodate) {
+			page = extent_buffer_page(&ebh->eb, 0);
+			SetPageUptodate(page);
+		}
+	} else {
+		num_pages = num_extent_pages(eb->start, eb->len);
+		for (i = 0; i < num_pages; i++) {
+			page = extent_buffer_page(eb, i);
+			SetPageUptodate(page);
+		}
 	}
+
 	return 0;
 }
 
 int extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
 }
 
 int read_extent_buffer_pages(struct extent_io_tree *tree,
@@ -5163,12 +5291,12 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
 
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
-		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
 		kaddr = page_address(page);
@@ -5196,9 +5324,10 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
+
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
-		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
 		kaddr = page_address(page);
@@ -5227,9 +5356,10 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	offset = (start_offset + dst_offset) &
 		(PAGE_CACHE_SIZE - 1);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &dst->ebflags));
+
 	while (len > 0) {
 		page = extent_buffer_page(dst, i);
-		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
 
@@ -5366,6 +5496,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
 int try_release_extent_buffer(struct page *page)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 
 	/*
@@ -5381,14 +5512,15 @@ int try_release_extent_buffer(struct page *page)
 	eb = (struct extent_buffer *)page->private;
 	BUG_ON(!eb);
 
+	ebh = eb->ebh;
 	/*
 	 * This is a little awful but should be ok, we need to make sure that
 	 * the eb doesn't disappear out from under us while we're looking at
 	 * this page.
 	 */
-	spin_lock(&eb->refs_lock);
-	if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
-		spin_unlock(&eb->refs_lock);
+	spin_lock(&ebh->refs_lock);
+	if (atomic_read(&ebh->refs) != 1 || extent_buffer_under_io(eb)) {
+		spin_unlock(&ebh->refs_lock);
 		spin_unlock(&page->mapping->private_lock);
 		return 0;
 	}
@@ -5398,10 +5530,11 @@ int try_release_extent_buffer(struct page *page)
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
index ccc264e..840e9a0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -123,19 +123,17 @@ struct extent_state {
 
 #define INLINE_EXTENT_BUFFER_PAGES 16
 #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_CACHE_SIZE)
+
+/* Forward declaration */
+struct extent_buffer_head;
+
 struct extent_buffer {
 	u64 start;
 	unsigned long len;
-	unsigned long map_start;
-	unsigned long map_len;
-	unsigned long bflags;
-	struct btrfs_fs_info *fs_info;
-	spinlock_t refs_lock;
-	atomic_t refs;
-	atomic_t io_pages;
+	unsigned long ebflags;
+	struct extent_buffer_head *ebh;
+	struct extent_buffer *eb_next;
 	int read_mirror;
-	struct rcu_head rcu_head;
-	pid_t lock_owner;
 
 	/* count of read lock holders on the extent buffer */
 	atomic_t write_locks;
@@ -146,6 +144,8 @@ struct extent_buffer {
 	atomic_t spinning_writers;
 	int lock_nested;
 
+	pid_t lock_owner;
+
 	/* protects write locks */
 	rwlock_t lock;
 
@@ -158,7 +158,20 @@ struct extent_buffer {
 	 * to unlock
 	 */
 	wait_queue_head_t read_lock_wq;
+	wait_queue_head_t lock_wq;
+};
+
+struct extent_buffer_head {
+	unsigned long bflags;
+	struct btrfs_fs_info *fs_info;
+	spinlock_t refs_lock;
+	atomic_t refs;
+	atomic_t io_bvecs;
+	struct rcu_head rcu_head;
+
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
+
+	struct extent_buffer eb;
 #ifdef CONFIG_BTRFS_DEBUG
 	struct list_head leak_list;
 #endif
@@ -175,6 +188,14 @@ static inline int extent_compress_type(unsigned long bio_flags)
 	return bio_flags >> EXTENT_BIO_FLAG_SHIFT;
 }
 
+/*
+ * return the extent_buffer_head that contains the extent buffer provided.
+ */
+static inline struct extent_buffer_head *eb_head(struct extent_buffer *eb)
+{
+	return eb->ebh;
+
+}
 struct extent_map_tree;
 
 typedef struct extent_map *(get_extent_t)(struct inode *inode,
@@ -286,15 +307,15 @@ static inline unsigned long num_extent_pages(u64 start, u64 len)
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
index 6cb82f6..99bafcb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6060,7 +6060,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	 * to silence the warning eg. on PowerPC 64.
 	 */
 	if (PAGE_CACHE_SIZE > BTRFS_SUPER_INFO_SIZE)
-		SetPageUptodate(sb->pages[0]);
+		SetPageUptodate(eb_head(sb)->pages[0]);
 
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4ee4e30..2dc966e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -697,7 +697,7 @@ TRACE_EVENT(btrfs_cow_block,
 	TP_fast_assign(
 		__entry->root_objectid	= root->root_key.objectid;
 		__entry->buf_start	= buf->start;
-		__entry->refs		= atomic_read(&buf->refs);
+		__entry->refs		= atomic_read(&eb_head(buf)->refs);
 		__entry->cow_start	= cow->start;
 		__entry->buf_level	= btrfs_header_level(buf);
 		__entry->cow_level	= btrfs_header_level(cow);
-- 
2.1.0

