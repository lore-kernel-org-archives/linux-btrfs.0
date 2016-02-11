Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56821 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcBKRtK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:49:10 -0500
Received: from localhost
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 12 Feb 2016 03:49:07 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 8561D3578056
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:49:06 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1BHmwnE29425898
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:49:06 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1BHmXKf021206
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:48:34 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V15 04/15] Btrfs: subpage-blocksize: Define extent_buffer_head.
Date: Thu, 11 Feb 2016 23:17:42 +0530
Message-Id: <1455212873-14829-5-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to handle multiple extent buffers per page, first we need to create a
way to handle all the extent buffers that are attached to a page.

This patch creates a new data structure 'struct extent_buffer_head', and moves
fields that are common to all extent buffers from 'struct extent buffer' to
'struct extent_buffer_head'

Also, this patch moves EXTENT_BUFFER_TREE_REF, EXTENT_BUFFER_DUMMY and
EXTENT_BUFFER_IN_TREE flags from extent_buffer->ebflags  to
extent_buffer_head->bflags.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/backref.c           |   2 +-
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |   6 +-
 fs/btrfs/disk-io.c           |  78 +++---
 fs/btrfs/extent-tree.c       |   6 +-
 fs/btrfs/extent_io.c         | 588 ++++++++++++++++++++++++++++---------------
 fs/btrfs/extent_io.h         |  63 +++--
 fs/btrfs/root-tree.c         |   2 +-
 fs/btrfs/volumes.c           |   2 +-
 include/trace/events/btrfs.h |   2 +-
 10 files changed, 493 insertions(+), 258 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b90cd37..4d3d3e8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1426,7 +1426,7 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
 		if (eb != eb_in) {
-			atomic_inc(&eb->refs);
+			atomic_inc(&eb_head(eb)->refs);
 			btrfs_tree_read_lock(eb);
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		}
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f5ef7d1..aa590a9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -159,7 +159,7 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
 		 * the inc_not_zero dance and if it doesn't work then
 		 * synchronize_rcu and try again.
 		 */
-		if (atomic_inc_not_zero(&eb->refs)) {
+		if (atomic_inc_not_zero(&eb_head(eb)->refs)) {
 			rcu_read_unlock();
 			break;
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 42ab582..34f53ac 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2433,14 +2433,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
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
index 26ef141..9cfbcc3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -375,10 +375,9 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		ret = 0;
 		goto out;
 	}
-	btrfs_err_rl(eb->fs_info,
+	btrfs_err_rl(eb_head(eb)->fs_info,
 		"parent transid verify failed on %llu wanted %llu found %llu",
-			eb->start,
-			parent_transid, btrfs_header_generation(eb));
+		eb->start, parent_transid, btrfs_header_generation(eb));
 	ret = 1;
 
 	/*
@@ -452,7 +451,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	int mirror_num = 0;
 	int failed_mirror = 0;
 
-	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags);
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	while (1) {
 		ret = read_extent_buffer_pages(io_tree, eb, start,
@@ -471,7 +470,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		 * there is no reason to read the other copies, they won't be
 		 * any less wrong.
 		 */
-		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
+		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags))
 			break;
 
 		num_copies = btrfs_num_copies(root->fs_info,
@@ -510,7 +509,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	struct extent_buffer *eb;
 
 	eb = (struct extent_buffer *)page->private;
-	if (page != eb->pages[0])
+	if (page != eb_head(eb)->pages[0])
 		return 0;
 	found_start = btrfs_header_bytenr(eb);
 	if (WARN_ON(found_start != start || !PageUptodate(page)))
@@ -624,26 +623,26 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 */
 	extent_buffer_get(eb);
 
-	reads_done = atomic_dec_and_test(&eb->io_pages);
+	reads_done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
 	if (!reads_done)
 		goto err;
 
 	eb->read_mirror = mirror;
-	if (test_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags)) {
 		ret = -EIO;
 		goto err;
 	}
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		btrfs_err_rl(eb->fs_info, "bad tree block start %llu %llu",
-			       found_start, eb->start);
+		btrfs_err_rl(eb_head(eb)->fs_info, "bad tree block start %llu %llu",
+			found_start, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root->fs_info, eb)) {
-		btrfs_err_rl(eb->fs_info, "bad fsid on block %llu",
-			       eb->start);
+		btrfs_err_rl(eb_head(eb)->fs_info, "bad fsid on block %llu",
+			eb->start);
 		ret = -EIO;
 		goto err;
 	}
@@ -670,7 +669,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 * return -EIO.
 	 */
 	if (found_level == 0 && check_leaf(root, eb)) {
-		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+		set_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags);
 		ret = -EIO;
 	}
 
@@ -678,7 +677,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		set_extent_buffer_uptodate(eb);
 err:
 	if (reads_done &&
-	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
+	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
 		btree_readahead_hook(root, eb, eb->start, ret);
 
 	if (ret) {
@@ -687,7 +686,7 @@ err:
 		 * again, we have to make sure it has something
 		 * to decrement
 		 */
-		atomic_inc(&eb->io_pages);
+		atomic_inc(&eb_head(eb)->io_bvecs);
 		clear_extent_buffer_uptodate(eb);
 	}
 	free_extent_buffer(eb);
@@ -701,10 +700,10 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 
 	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
+	set_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags);
 	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb->io_pages);
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
+	atomic_dec(&eb_head(eb)->io_bvecs);
+	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
 		btree_readahead_hook(root, eb, eb->start, -EIO);
 	return -EIO;	/* we fixed nothing */
 }
@@ -1062,13 +1061,24 @@ static int btree_set_page_dirty(struct page *page)
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
+
+	eb = (struct extent_buffer *)page->private;
+	BUG_ON(!atomic_read(&(eb_head(eb)->refs)));
+
+	btrfs_assert_tree_locked(&ebh->eb);
 #endif
 	return __set_page_dirty_nobuffers(page);
 }
@@ -1109,7 +1119,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 	if (!buf)
 		return 0;
 
-	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
+	set_bit(EXTENT_BUFFER_READAHEAD, &buf->ebflags);
 
 	ret = read_extent_buffer_pages(io_tree, buf, 0, WAIT_PAGE_LOCK,
 				       btree_get_extent, mirror_num);
@@ -1118,7 +1128,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 		return ret;
 	}
 
-	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
+	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags)) {
 		free_extent_buffer(buf);
 		return -EIO;
 	} else if (extent_buffer_uptodate(buf)) {
@@ -1146,14 +1156,16 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 
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
@@ -1183,7 +1195,8 @@ void clean_tree_block(struct btrfs_trans_handle *trans,
 	    fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
-		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
+		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
+						&buf->ebflags)) {
 			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
 					     -buf->len,
 					     fs_info->dirty_metadata_batch);
@@ -3933,7 +3946,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic)
 {
 	int ret;
-	struct inode *btree_inode = buf->pages[0]->mapping->host;
+	struct inode *btree_inode = eb_head(buf)->pages[0]->mapping->host;
 
 	ret = extent_buffer_uptodate(buf);
 	if (!ret)
@@ -3958,10 +3971,10 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	 * enabled.  Normal people shouldn't be marking dummy buffers as dirty
 	 * outside of the sanity tests.
 	 */
-	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
+	if (unlikely(test_bit(EXTENT_BUFFER_HEAD_DUMMY, &eb_head(buf)->bflags)))
 		return;
 #endif
-	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	root = BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
 	btrfs_assert_tree_locked(buf);
 	if (transid != root->fs_info->generation)
 		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
@@ -4015,7 +4028,8 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
 
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 {
-	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	struct btrfs_root *root =
+			BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
 	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
@@ -4350,7 +4364,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 			wait_on_extent_buffer_writeback(eb);
 
 			if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
-					       &eb->bflags))
+					       &eb->ebflags))
 				clear_extent_buffer_dirty(eb);
 			free_extent_buffer_stale(eb);
 		}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7..8cc71ba 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6843,7 +6843,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 
-		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
+		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->ebflags));
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE, 0);
@@ -6861,7 +6861,7 @@ out:
 	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
 	 * anymore.
 	 */
-	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags);
 }
 
 /* Can return -ENOMEM */
@@ -7901,7 +7901,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
 	clean_tree_block(trans, root->fs_info, buf);
-	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_STALE, &buf->ebflags);
 
 	btrfs_set_lock_blocking(buf);
 	set_extent_buffer_uptodate(buf);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index da54e49..d5f0814 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -22,6 +22,7 @@
 #include "backref.h"
 
 static struct kmem_cache *extent_state_cache;
+static struct kmem_cache *extent_buffer_head_cache;
 static struct kmem_cache *extent_buffer_cache;
 static struct bio_set *btrfs_bioset;
 
@@ -61,6 +62,7 @@ void btrfs_leak_debug_check(void)
 {
 	struct extent_state *state;
 	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh;
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
@@ -73,12 +75,17 @@ void btrfs_leak_debug_check(void)
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
 
@@ -167,11 +174,17 @@ int __init extent_io_init(void)
 	if (!extent_state_cache)
 		return -ENOMEM;
 
+	extent_buffer_head_cache = kmem_cache_create("btrfs_extent_buffer_head",
+			sizeof(struct extent_buffer_head), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!extent_buffer_head_cache)
+		goto free_state_cache;
+
 	extent_buffer_cache = kmem_cache_create("btrfs_extent_buffer",
 			sizeof(struct extent_buffer), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_buffer_cache)
-		goto free_state_cache;
+		goto free_buffer_head_cache;
 
 	btrfs_bioset = bioset_create(BIO_POOL_SIZE,
 				     offsetof(struct btrfs_io_bio, bio));
@@ -191,6 +204,10 @@ free_buffer_cache:
 	kmem_cache_destroy(extent_buffer_cache);
 	extent_buffer_cache = NULL;
 
+free_buffer_head_cache:
+	kmem_cache_destroy(extent_buffer_head_cache);
+	extent_buffer_head_cache = NULL;
+
 free_state_cache:
 	kmem_cache_destroy(extent_state_cache);
 	extent_state_cache = NULL;
@@ -2153,7 +2170,7 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 		return -EROFS;
 
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = eb->pages[i];
+		struct page *p = eb_head(eb)->pages[i];
 
 		ret = repair_io_failure(root->fs_info->btree_inode, start,
 					PAGE_CACHE_SIZE, start, p,
@@ -3672,8 +3689,8 @@ done_unlocked:
 
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_WRITEBACK,
-		       TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&eb->ebflags, EXTENT_BUFFER_WRITEBACK,
+		    TASK_UNINTERRUPTIBLE);
 }
 
 static noinline_for_stack int
@@ -3691,7 +3708,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		btrfs_tree_lock(eb);
 	}
 
-	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags)) {
 		btrfs_tree_unlock(eb);
 		if (!epd->sync_io)
 			return 0;
@@ -3702,7 +3719,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		while (1) {
 			wait_on_extent_buffer_writeback(eb);
 			btrfs_tree_lock(eb);
-			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
+			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags))
 				break;
 			btrfs_tree_unlock(eb);
 		}
@@ -3713,17 +3730,17 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 	 * under IO since we can end up having no IO bits set for a short period
 	 * of time.
 	 */
-	spin_lock(&eb->refs_lock);
-	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
-		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
-		spin_unlock(&eb->refs_lock);
+	spin_lock(&eb_head(eb)->refs_lock);
+	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags)) {
+		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags);
+		spin_unlock(&eb_head(eb)->refs_lock);
 		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
 		__percpu_counter_add(&fs_info->dirty_metadata_bytes,
 				     -eb->len,
 				     fs_info->dirty_metadata_batch);
 		ret = 1;
 	} else {
-		spin_unlock(&eb->refs_lock);
+		spin_unlock(&eb_head(eb)->refs_lock);
 	}
 
 	btrfs_tree_unlock(eb);
@@ -3733,7 +3750,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = eb->pages[i];
+		struct page *p = eb_head(eb)->pages[i];
 
 		if (!trylock_page(p)) {
 			if (!flush) {
@@ -3749,18 +3766,19 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags);
 	smp_mb__after_atomic();
-	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
+	wake_up_bit(&eb->ebflags, EXTENT_BUFFER_WRITEBACK);
 }
 
 static void set_btree_ioerr(struct page *page)
 {
 	struct extent_buffer *eb = (struct extent_buffer *)page->private;
-	struct btrfs_inode *btree_ino = BTRFS_I(eb->fs_info->btree_inode);
+	struct extent_buffer_head *ebh = eb_head(eb);
+	struct btrfs_inode *btree_ino = BTRFS_I(ebh->fs_info->btree_inode);
 
 	SetPageError(page);
-	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
+	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags))
 		return;
 
 	/*
@@ -3827,10 +3845,10 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
-		done = atomic_dec_and_test(&eb->io_pages);
+		done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
 
 		if (bio->bi_error ||
-		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
+		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags)) {
 			ClearPageUptodate(page);
 			set_btree_ioerr(page);
 		}
@@ -3859,14 +3877,14 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
 	int ret = 0;
 
-	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
-	atomic_set(&eb->io_pages, num_pages);
+	atomic_set(&eb_head(eb)->io_bvecs, num_pages);
 	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 		bio_flags = EXTENT_BIO_TREE_LOG;
 
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = eb->pages[i];
+		struct page *p = eb_head(eb)->pages[i];
 
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
@@ -3878,7 +3896,8 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		if (ret) {
 			set_btree_ioerr(p);
 			end_page_writeback(p);
-			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
+			if (atomic_sub_and_test(num_pages - i,
+							&eb_head(eb)->io_bvecs))
 				end_extent_buffer_writeback(eb);
 			ret = -EIO;
 			break;
@@ -3890,7 +3909,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 
 	if (unlikely(ret)) {
 		for (; i < num_pages; i++) {
-			struct page *p = eb->pages[i];
+			struct page *p = eb_head(eb)->pages[i];
 			clear_page_dirty_for_io(p);
 			unlock_page(p);
 		}
@@ -3978,7 +3997,7 @@ retry:
 				continue;
 			}
 
-			ret = atomic_inc_not_zero(&eb->refs);
+			ret = atomic_inc_not_zero(&eb_head(eb)->refs);
 			spin_unlock(&mapping->private_lock);
 			if (!ret)
 				continue;
@@ -4656,17 +4675,36 @@ out:
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
+		kmem_cache_free(extent_buffer_cache, eb);
+		eb = next_eb;
+	}
+
+	kmem_cache_free(extent_buffer_head_cache, ebh);
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
+			|| test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags)) {
+			dirty_or_writeback = 1;
+			break;
+		}
+	}
+
+	return (atomic_read(&ebh->io_bvecs) || dirty_or_writeback);
 }
 
 /*
@@ -4676,7 +4714,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 {
 	unsigned long index;
 	struct page *page;
-	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+	struct extent_buffer_head *ebh = eb_head(eb);
+	int mapped = !test_bit(EXTENT_BUFFER_HEAD_DUMMY, &ebh->bflags);
 
 	BUG_ON(extent_buffer_under_io(eb));
 
@@ -4685,8 +4724,11 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 		return;
 
 	do {
+		struct extent_buffer *e;
+
 		index--;
-		page = eb->pages[index];
+
+		page = ebh->pages[index];
 		if (!page)
 			continue;
 		if (mapped)
@@ -4699,8 +4741,10 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 		 * this eb.
 		 */
 		if (PagePrivate(page) &&
-		    page->private == (unsigned long)eb) {
-			BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+		    page->private == (unsigned long)(&ebh->eb)) {
+			for (e = &ebh->eb; !e; e = e->eb_next)
+				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY,
+							&e->ebflags));
 			BUG_ON(PageDirty(page));
 			BUG_ON(PageWriteback(page));
 			/*
@@ -4727,20 +4771,18 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 {
 	btrfs_release_extent_buffer_page(eb);
-	__free_extent_buffer(eb);
+	__free_extent_buffer(eb_head(eb));
 }
 
-static struct extent_buffer *
-__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
-		      unsigned long len)
+static void __init_extent_buffer(struct extent_buffer *eb,
+				struct extent_buffer_head *ebh,
+				u64 start,
+				unsigned long len)
 {
-	struct extent_buffer *eb = NULL;
-
-	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
 	eb->start = start;
 	eb->len = len;
-	eb->fs_info = fs_info;
-	eb->bflags = 0;
+	eb->ebh = ebh;
+	eb->eb_next = NULL;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
 	atomic_set(&eb->read_locks, 0);
@@ -4751,12 +4793,27 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
+}
 
-	btrfs_leak_debug_add(&eb->leak_list, &buffers);
+static struct extent_buffer *
+__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
+		      unsigned long len)
+{
+	struct extent_buffer_head *ebh = NULL;
+	struct extent_buffer *cur_eb, *prev_eb;
+	struct extent_buffer *eb = NULL;
+	int i;
+
+	ebh = kmem_cache_zalloc(extent_buffer_head_cache, GFP_NOFS|__GFP_NOFAIL);
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
@@ -4765,7 +4822,44 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 		> MAX_INLINE_EXTENT_BUFFER_SIZE);
 	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
 
+	if (len < PAGE_CACHE_SIZE) {
+		int ebs_per_page = PAGE_CACHE_SIZE / len;
+		u64 st = start & ~(PAGE_CACHE_SIZE - 1);
+
+		prev_eb = NULL;
+		cur_eb = &ebh->eb;
+		for (i = 0; i < ebs_per_page; i++, st += len) {
+			if (prev_eb) {
+				cur_eb = kmem_cache_zalloc(extent_buffer_cache,
+							GFP_NOFS|__GFP_NOFAIL);
+				if (cur_eb == NULL)
+					goto out;
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
+
+out:
+	cur_eb = ebh->eb.eb_next;
+	while (cur_eb) {
+		prev_eb = cur_eb;
+		cur_eb = cur_eb->eb_next;
+		kmem_cache_free(extent_buffer_cache, prev_eb);
+	}
+
+	kmem_cache_free(extent_buffer_head_cache, ebh);
+
+	return NULL;
 }
 
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
@@ -4775,7 +4869,8 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	struct extent_buffer *new;
 	unsigned long num_pages = num_extent_pages(src->start, src->len);
 
-	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
+	new = __alloc_extent_buffer(eb_head(src)->fs_info, src->start,
+				src->len);
 	if (new == NULL)
 		return NULL;
 
@@ -4785,15 +4880,25 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
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
 
+	/*
+	 * copy_extent_buffer() now checks for the presence of
+	 * EXTENT_BUFFER_UPTODATE flag (instead of the page's
+	 * PG_Uptodate flag) in dst extent buffer. Hence we set
+	 * EXTENT_BUFFER_UPTODATE bit before copy_extent_buffer()
+	 * is invoked. It is safe since this is the only function
+	 * that has a reference to the just allocated dummy extent
+	 * buffer.
+	 */
+	set_bit(EXTENT_BUFFER_UPTODATE, &new->ebflags);
+	set_bit(EXTENT_BUFFER_HEAD_DUMMY, &eb_head(new)->bflags);
+
 	copy_extent_buffer(new, src, 0, 0, src->len);
-	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
-	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
 
 	return new;
 }
@@ -4812,19 +4917,19 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
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
+	set_bit(EXTENT_BUFFER_HEAD_DUMMY, &eb_head(eb)->bflags);
 
 	return eb;
 err:
 	for (; i > 0; i--)
-		__free_page(eb->pages[i - 1]);
-	__free_extent_buffer(eb);
+		__free_page(eb_head(eb)->pages[i - 1]);
+	__free_extent_buffer(eb_head(eb));
 	return NULL;
 }
 
@@ -4869,14 +4974,16 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
 	 * So bump the ref count first, then set the bit.  If someone
 	 * beat us to it, drop the ref we added.
 	 */
-	refs = atomic_read(&eb->refs);
-	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
+	refs = atomic_read(&eb_head(eb)->refs);
+	if (refs >= 2 && test_bit(EXTENT_BUFFER_HEAD_TREE_REF,
+					&eb_head(eb)->bflags))
 		return;
 
-	spin_lock(&eb->refs_lock);
-	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_inc(&eb->refs);
-	spin_unlock(&eb->refs_lock);
+	spin_lock(&eb_head(eb)->refs_lock);
+	if (!test_and_set_bit(EXTENT_BUFFER_HEAD_TREE_REF,
+				&eb_head(eb)->bflags))
+		atomic_inc(&eb_head(eb)->refs);
+	spin_unlock(&eb_head(eb)->refs_lock);
 }
 
 static void mark_extent_buffer_accessed(struct extent_buffer *eb,
@@ -4888,44 +4995,67 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb,
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = eb->pages[i];
+		struct page *p = eb_head(eb)->pages[i];
 
 		if (p != accessed)
 			mark_page_accessed(p);
 	}
 }
 
+static int extent_buffer_head_stale(struct extent_buffer_head *ebh)
+{
+	struct extent_buffer *eb = &ebh->eb;
+
+	do {
+		if (test_bit(EXTENT_BUFFER_STALE, &eb->ebflags))
+			return 1;
+	} while ((eb = eb->eb_next) != NULL);
+
+	return 0;
+}
+
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
 		/*
-		 * Lock our eb's refs_lock to avoid races with
-		 * free_extent_buffer. When we get our eb it might be flagged
-		 * with EXTENT_BUFFER_STALE and another task running
-		 * free_extent_buffer might have seen that flag set,
-		 * eb->refs == 2, that the buffer isn't under IO (dirty and
-		 * writeback flags not set) and it's still in the tree (flag
-		 * EXTENT_BUFFER_TREE_REF set), therefore being in the process
-		 * of decrementing the extent buffer's reference count twice.
-		 * So here we could race and increment the eb's reference count,
-		 * clear its stale flag, mark it as dirty and drop our reference
-		 * before the other task finishes executing free_extent_buffer,
-		 * which would later result in an attempt to free an extent
-		 * buffer that is dirty.
+		 * Lock our ebh's refs_lock to avoid races with
+		 * free_extent_buffer. When we get our eb it might be
+		 * flagged with EXTENT_BUFFER_STALE and another task
+		 * running free_extent_buffer might have seen that
+		 * flag set, ebh->refs == 2, that the buffer isn't
+		 * under IO (dirty and writeback flags not set) and
+		 * it's still in the tree (flag
+		 * EXTENT_BUFFER_HEAD_TREE_REF set), therefore being
+		 * in the process of decrementing the extent buffer's
+		 * reference count twice.  So here we could race and
+		 * increment the ebh's reference count, clear its
+		 * stale flag, mark it as dirty and drop our reference
+		 * before the other task finishes executing
+		 * free_extent_buffer, which would later result in an
+		 * attempt to free an extent buffer head (along with
+		 * its extent buffers) that has a dirty extent buffer.
 		 */
-		if (test_bit(EXTENT_BUFFER_STALE, &eb->bflags)) {
-			spin_lock(&eb->refs_lock);
-			spin_unlock(&eb->refs_lock);
-		}
-		mark_extent_buffer_accessed(eb, NULL);
-		return eb;
+		eb = &ebh->eb;
+		do {
+			if (eb->start == start) {
+				if (extent_buffer_head_stale(ebh)) {
+					spin_lock(&ebh->refs_lock);
+					spin_unlock(&ebh->refs_lock);
+				}
+				mark_extent_buffer_accessed(eb, NULL);
+				return eb;
+			}
+		} while ((eb = eb->eb_next) != NULL);
+
+		BUG();
 	}
 	rcu_read_unlock();
 
@@ -4963,7 +5093,7 @@ again:
 			goto again;
 	}
 	check_buffer_tree_ref(eb);
-	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
+	set_bit(EXTENT_BUFFER_HEAD_IN_TREE, &eb->bflags);
 
 	/*
 	 * We will free dummy extent buffer's if they come into
@@ -4986,7 +5116,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
-	struct extent_buffer *eb;
+	struct extent_buffer *eb, *cur_eb;
 	struct extent_buffer *exists = NULL;
 	struct page *p;
 	struct address_space *mapping = fs_info->btree_inode->i_mapping;
@@ -5016,12 +5146,18 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
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
 			exists = NULL;
 
@@ -5033,10 +5169,11 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
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
 
@@ -5045,16 +5182,22 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
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
@@ -5066,7 +5209,7 @@ again:
 	}
 	/* add one reference for the tree */
 	check_buffer_tree_ref(eb);
-	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
+	set_bit(EXTENT_BUFFER_HEAD_IN_TREE, &eb_head(eb)->bflags);
 
 	/*
 	 * there is a race where release page may have
@@ -5077,20 +5220,20 @@ again:
 	 * after the extent buffer is in the radix tree so
 	 * it doesn't get lost
 	 */
-	SetPageChecked(eb->pages[0]);
+	SetPageChecked(eb_head(eb)->pages[0]);
 	for (i = 1; i < num_pages; i++) {
-		p = eb->pages[i];
+		p = eb_head(eb)->pages[i];
 		ClearPageChecked(p);
 		unlock_page(p);
 	}
-	unlock_page(eb->pages[0]);
+	unlock_page(eb_head(eb)->pages[0]);
 	return eb;
 
 free_eb:
-	WARN_ON(!atomic_dec_and_test(&eb->refs));
+	WARN_ON(!atomic_dec_and_test(&eb_head(eb)->refs));
 	for (i = 0; i < num_pages; i++) {
-		if (eb->pages[i])
-			unlock_page(eb->pages[i]);
+		if (eb_head(eb)->pages[i])
+			unlock_page(eb_head(eb)->pages[i]);
 	}
 
 	btrfs_release_extent_buffer(eb);
@@ -5099,92 +5242,111 @@ free_eb:
 
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
+		if (test_and_clear_bit(EXTENT_BUFFER_HEAD_IN_TREE,
+					&ebh->bflags)) {
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
-		btrfs_release_extent_buffer_page(eb);
+		btrfs_release_extent_buffer_page(&ebh->eb);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-		if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))) {
-			__free_extent_buffer(eb);
+		if (unlikely(test_bit(EXTENT_BUFFER_HEAD_DUMMY,
+						&eb_head(buf)->bflags))) {
+			__free_extent_buffer(eb_head(eb));
 			return 1;
 		}
 #endif
-		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
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
+	    test_bit(EXTENT_BUFFER_HEAD_DUMMY, &ebh->bflags))
+		atomic_dec(&ebh->refs);
 
-	if (atomic_read(&eb->refs) == 2 &&
-	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
+	if (atomic_read(&ebh->refs) == 2 &&
+	    test_bit(EXTENT_BUFFER_STALE, &eb->ebflags) &&
 	    !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
+	    test_and_clear_bit(EXTENT_BUFFER_HEAD_TREE_REF, &ebh->bflags))
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
+
+	set_bit(EXTENT_BUFFER_STALE, &eb->ebflags);
+	if (atomic_read(&ebh->refs) == 2 && !extent_buffer_under_io(eb) &&
+	    test_and_clear_bit(EXTENT_BUFFER_HEAD_TREE_REF, &ebh->bflags))
+		atomic_dec(&ebh->refs);
 
-	if (atomic_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
-	release_extent_buffer(eb);
+	release_extent_buffer(ebh);
+}
+
+static int page_ebs_clean(struct extent_buffer_head *ebh)
+{
+	struct extent_buffer *eb = &ebh->eb;
+
+	do {
+		if (test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags))
+			return 0;
+	} while ((eb = eb->eb_next) != NULL);
+
+	return 1;
 }
 
 void clear_extent_buffer_dirty(struct extent_buffer *eb)
@@ -5195,8 +5357,11 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 
+	if (eb->len < PAGE_CACHE_SIZE && !page_ebs_clean(eb_head(eb)))
+		return;
+
 	for (i = 0; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		if (!PageDirty(page))
 			continue;
 
@@ -5214,7 +5379,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 		ClearPageError(page);
 		unlock_page(page);
 	}
-	WARN_ON(atomic_read(&eb->refs) == 0);
+	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
 }
 
 int set_extent_buffer_dirty(struct extent_buffer *eb)
@@ -5225,14 +5390,14 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 
 	check_buffer_tree_ref(eb);
 
-	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
+	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
 
 	num_pages = num_extent_pages(eb->start, eb->len);
-	WARN_ON(atomic_read(&eb->refs) == 0);
-	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
+	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
+	WARN_ON(!test_bit(EXTENT_BUFFER_HEAD_TREE_REF, &eb_head(eb)->bflags));
 
 	for (i = 0; i < num_pages; i++)
-		set_page_dirty(eb->pages[i]);
+		set_page_dirty(eb_head(eb)->pages[i]);
 	return was_dirty;
 }
 
@@ -5242,10 +5407,10 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 	struct page *page;
 	unsigned long num_pages;
 
-	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		if (page)
 			ClearPageUptodate(page);
 	}
@@ -5253,21 +5418,41 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 
 void set_extent_buffer_uptodate(struct extent_buffer *eb)
 {
+	struct extent_buffer_head *ebh;
 	unsigned long i;
 	struct page *page;
 	unsigned long num_pages;
+	int uptodate;
 
-	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		page = eb->pages[i];
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
+			page = ebh->pages[0];
+			SetPageUptodate(page);
+		}
+	} else {
+		num_pages = num_extent_pages(eb->start, eb->len);
+		for (i = 0; i < num_pages; i++) {
+			page = ebh->pages[i];
+			SetPageUptodate(page);
+		}
 	}
 }
 
 int extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
 }
 
 int read_extent_buffer_pages(struct extent_io_tree *tree,
@@ -5286,7 +5471,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
 
-	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags))
 		return 0;
 
 	if (start) {
@@ -5299,7 +5484,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = start_i; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		if (wait == WAIT_NONE) {
 			if (!trylock_page(page))
 				goto unlock_exit;
@@ -5314,15 +5499,15 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	}
 	if (all_uptodate) {
 		if (start_i == 0)
-			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+			set_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
 		goto unlock_exit;
 	}
 
-	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags);
 	eb->read_mirror = 0;
-	atomic_set(&eb->io_pages, num_reads);
+	atomic_set(&eb_head(eb)->io_bvecs, num_reads);
 	for (i = start_i; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		if (!PageUptodate(page)) {
 			ClearPageError(page);
 			err = __extent_read_full_page(tree, page,
@@ -5347,7 +5532,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		return ret;
 
 	for (i = start_i; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		wait_on_page_locked(page);
 		if (!PageUptodate(page))
 			ret = -EIO;
@@ -5358,7 +5543,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 unlock_exit:
 	i = start_i;
 	while (locked_pages > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		i++;
 		unlock_page(page);
 		locked_pages--;
@@ -5384,7 +5569,7 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 		kaddr = page_address(page);
@@ -5416,7 +5601,7 @@ int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dstv,
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 		kaddr = page_address(page);
@@ -5465,7 +5650,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 		return -EINVAL;
 	}
 
-	p = eb->pages[i];
+	p = eb_head(eb)->pages[i];
 	kaddr = page_address(p);
 	*map = kaddr + offset;
 	*map_len = PAGE_CACHE_SIZE - offset;
@@ -5491,7 +5676,7 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 
@@ -5521,12 +5706,12 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
 
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
-		WARN_ON(!PageUptodate(page));
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
 		kaddr = page_address(page);
@@ -5554,9 +5739,10 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
+
 	while (len > 0) {
-		page = eb->pages[i];
-		WARN_ON(!PageUptodate(page));
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
 		kaddr = page_address(page);
@@ -5585,9 +5771,10 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	offset = (start_offset + dst_offset) &
 		(PAGE_CACHE_SIZE - 1);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &dst->ebflags));
+
 	while (len > 0) {
-		page = dst->pages[i];
-		WARN_ON(!PageUptodate(page));
+		page = eb_head(dst)->pages[i];
 
 		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
 
@@ -5661,7 +5848,7 @@ int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
 	size_t offset;
 
 	eb_bitmap_offset(eb, start, nr, &i, &offset);
-	page = eb->pages[i];
+	page = eb_head(eb)->pages[i];
 	WARN_ON(!PageUptodate(page));
 	kaddr = page_address(page);
 	return 1U & (kaddr[offset] >> (nr & (BITS_PER_BYTE - 1)));
@@ -5686,7 +5873,7 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
 	unsigned int mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
 
 	eb_bitmap_offset(eb, start, pos, &i, &offset);
-	page = eb->pages[i];
+	page = eb_head(eb)->pages[i];
 	WARN_ON(!PageUptodate(page));
 	kaddr = page_address(page);
 
@@ -5697,7 +5884,7 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
 		mask_to_set = ~0U;
 		if (++offset >= PAGE_CACHE_SIZE && len > 0) {
 			offset = 0;
-			page = eb->pages[++i];
+			page = eb_head(eb)->pages[++i];
 			WARN_ON(!PageUptodate(page));
 			kaddr = page_address(page);
 		}
@@ -5728,7 +5915,7 @@ void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
 	unsigned int mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
 
 	eb_bitmap_offset(eb, start, pos, &i, &offset);
-	page = eb->pages[i];
+	page = eb_head(eb)->pages[i];
 	WARN_ON(!PageUptodate(page));
 	kaddr = page_address(page);
 
@@ -5739,7 +5926,7 @@ void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
 		mask_to_clear = ~0U;
 		if (++offset >= PAGE_CACHE_SIZE && len > 0) {
 			offset = 0;
-			page = eb->pages[++i];
+			page = eb_head(eb)->pages[++i];
 			WARN_ON(!PageUptodate(page));
 			kaddr = page_address(page);
 		}
@@ -5789,13 +5976,13 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		btrfs_err(dst->fs_info,
+		btrfs_err(eb_head(dst)->fs_info,
 			"memmove bogus src_offset %lu move "
 		       "len %lu dst len %lu", src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		btrfs_err(dst->fs_info,
+		btrfs_err(eb_head(dst)->fs_info,
 			"memmove bogus dst_offset %lu move "
 		       "len %lu dst len %lu", dst_offset, len, dst->len);
 		BUG_ON(1);
@@ -5815,8 +6002,9 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		cur = min_t(unsigned long, cur,
 			(unsigned long)(PAGE_CACHE_SIZE - dst_off_in_page));
 
-		copy_pages(dst->pages[dst_i], dst->pages[src_i],
-			   dst_off_in_page, src_off_in_page, cur);
+		copy_pages(eb_head(dst)->pages[dst_i],
+			eb_head(dst)->pages[src_i],
+			dst_off_in_page, src_off_in_page, cur);
 
 		src_offset += cur;
 		dst_offset += cur;
@@ -5837,13 +6025,15 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		btrfs_err(dst->fs_info, "memmove bogus src_offset %lu move "
-		       "len %lu len %lu", src_offset, len, dst->len);
+		btrfs_err(eb_head(dst)->fs_info,
+			"memmove bogus src_offset %lu move len %lu len %lu",
+			src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		btrfs_err(dst->fs_info, "memmove bogus dst_offset %lu move "
-		       "len %lu len %lu", dst_offset, len, dst->len);
+		btrfs_err(eb_head(dst)->fs_info,
+			"memmove bogus dst_offset %lu move len %lu len %lu",
+			dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset < src_offset) {
@@ -5861,9 +6051,10 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
 		cur = min_t(unsigned long, len, src_off_in_page + 1);
 		cur = min(cur, dst_off_in_page + 1);
-		copy_pages(dst->pages[dst_i], dst->pages[src_i],
-			   dst_off_in_page - cur + 1,
-			   src_off_in_page - cur + 1, cur);
+		copy_pages(eb_head(dst)->pages[dst_i],
+			eb_head(dst)->pages[src_i],
+			dst_off_in_page - cur + 1,
+			src_off_in_page - cur + 1, cur);
 
 		dst_end -= cur;
 		src_end -= cur;
@@ -5873,6 +6064,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
 int try_release_extent_buffer(struct page *page)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 
 	/*
@@ -5888,14 +6080,15 @@ int try_release_extent_buffer(struct page *page)
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
@@ -5905,10 +6098,11 @@ int try_release_extent_buffer(struct page *page)
 	 * If tree ref isn't set then we know the ref on this eb is a real ref,
 	 * so just return, this page will likely be freed soon anyway.
 	 */
-	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
-		spin_unlock(&eb->refs_lock);
+	if (!test_and_clear_bit(EXTENT_BUFFER_HEAD_TREE_REF, &ebh->bflags)) {
+		spin_unlock(&ebh->refs_lock);
 		return 0;
 	}
 
-	return release_extent_buffer(eb);
+	return release_extent_buffer(ebh);
 }
+
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e7d377f..a9c81cf 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -32,18 +32,20 @@
 #define EXTENT_BIO_PARENT_LOCKED 4
 #define EXTENT_BIO_FLAG_SHIFT 16
 
-/* these are bit numbers for test/set bit */
+/* these are bit numbers for test/set bit on extent buffer head */
+#define EXTENT_BUFFER_HEAD_TREE_REF 0
+#define EXTENT_BUFFER_HEAD_DUMMY 1
+#define EXTENT_BUFFER_HEAD_IN_TREE 2
+
+/* these are bit numbers for test/set bit on extent buffer */
 #define EXTENT_BUFFER_UPTODATE 0
-#define EXTENT_BUFFER_DIRTY 2
-#define EXTENT_BUFFER_CORRUPT 3
-#define EXTENT_BUFFER_READAHEAD 4	/* this got triggered by readahead */
-#define EXTENT_BUFFER_TREE_REF 5
-#define EXTENT_BUFFER_STALE 6
-#define EXTENT_BUFFER_WRITEBACK 7
-#define EXTENT_BUFFER_READ_ERR 8        /* read IO error */
-#define EXTENT_BUFFER_DUMMY 9
-#define EXTENT_BUFFER_IN_TREE 10
-#define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
+#define EXTENT_BUFFER_DIRTY 1
+#define EXTENT_BUFFER_CORRUPT 2
+#define EXTENT_BUFFER_READAHEAD 3	/* this got triggered by readahead */
+#define EXTENT_BUFFER_STALE 4
+#define EXTENT_BUFFER_WRITEBACK 5
+#define EXTENT_BUFFER_READ_ERR 6        /* read IO error */
+#define EXTENT_BUFFER_WRITE_ERR 7    /* write IO error */
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define PAGE_UNLOCK		(1 << 0)
@@ -175,17 +177,17 @@ struct extent_state {
 
 #define INLINE_EXTENT_BUFFER_PAGES 16
 #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_CACHE_SIZE)
+
+/* Forward declaration */
+struct extent_buffer_head;
+
 struct extent_buffer {
 	u64 start;
 	unsigned long len;
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
@@ -198,6 +200,8 @@ struct extent_buffer {
 	/* >= 0 if eb belongs to a log tree, -1 otherwise */
 	short log_index;
 
+	pid_t lock_owner;
+
 	/* protects write locks */
 	rwlock_t lock;
 
@@ -210,7 +214,20 @@ struct extent_buffer {
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
@@ -238,6 +255,14 @@ static inline int extent_compress_type(unsigned long bio_flags)
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
@@ -435,7 +460,7 @@ static inline unsigned long num_extent_pages(u64 start, u64 len)
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
-	atomic_inc(&eb->refs);
+	atomic_inc(&eb_head(eb)->refs);
 }
 
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 7cf8509..ddf4dc4 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -45,7 +45,7 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 	if (!need_reset && btrfs_root_generation(item)
 		!= btrfs_root_generation_v2(item)) {
 		if (btrfs_root_generation_v2(item) != 0) {
-			btrfs_warn(eb->fs_info,
+			btrfs_warn(eb_head(eb)->fs_info,
 					"mismatching "
 					"generation and generation_v2 "
 					"found in root item. This root "
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335..fba90b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6523,7 +6523,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	 * to silence the warning eg. on PowerPC 64.
 	 */
 	if (PAGE_CACHE_SIZE > BTRFS_SUPER_INFO_SIZE)
-		SetPageUptodate(sb->pages[0]);
+		SetPageUptodate(eb_head(sb)->pages[0]);
 
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d866f21..3f9227e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -700,7 +700,7 @@ TRACE_EVENT(btrfs_cow_block,
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

