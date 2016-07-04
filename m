Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1099 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296AbcGDEfU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:35:20 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644XoVj141366
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:35:19 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23x77whj0k-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:35:19 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:35:18 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 04/19] Btrfs: subpage-blocksize: Define extent_buffer_head
Date: Mon,  4 Jul 2016 10:04:24 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-5-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to handle multiple extent buffers per page, first we need to create a
way to handle all the extent buffers that are attached to a page.

This patch creates a new data structure 'struct extent_buffer_head', and moves
fields that are common to all extent buffers from 'struct extent_buffer' to
'struct extent_buffer_head'

Also, this patch moves EXTENT_BUFFER_TREE_REF, EXTENT_BUFFER_DUMMY and
EXTENT_BUFFER_IN_TREE flags from extent_buffer->ebflags  to
extent_buffer_head->bflags.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c                       |   4 +-
 fs/btrfs/ctree.h                       |   6 +-
 fs/btrfs/disk-io.c                     |  72 ++--
 fs/btrfs/extent-tree.c                 |   6 +-
 fs/btrfs/extent_io.c                   | 602 ++++++++++++++++++++++-----------
 fs/btrfs/extent_io.h                   |  63 ++--
 fs/btrfs/root-tree.c                   |   2 +-
 fs/btrfs/super.c                       |   9 +-
 fs/btrfs/tests/btrfs-tests.c           |  12 +-
 fs/btrfs/tests/extent-io-tests.c       |   5 +-
 fs/btrfs/tests/free-space-tree-tests.c |  79 +++--
 fs/btrfs/volumes.c                     |   2 +-
 include/trace/events/btrfs.h           |   2 +-
 13 files changed, 557 insertions(+), 307 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e8a3ac6..4e35a21 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -160,7 +160,7 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
 		 * the inc_not_zero dance and if it doesn't work then
 		 * synchronize_rcu and try again.
 		 */
-		if (atomic_inc_not_zero(&eb->refs)) {
+		if (atomic_inc_not_zero(&eb_head(eb)->refs)) {
 			rcu_read_unlock();
 			break;
 		}
@@ -1772,7 +1772,7 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 	int err;
 
 	if (low > high) {
-		btrfs_err(eb->fs_info,
+		btrfs_err(eb_head(eb)->fs_info,
 		 "%s: low (%d) < high (%d) eb %llu owner %llu level %d",
 			  __func__, low, high, eb->start,
 			  btrfs_header_owner(eb), btrfs_header_level(eb));
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cc65e9b..893bedb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1475,14 +1475,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
 {									\
-	type *p = page_address(eb->pages[0]);				\
+	type *p = page_address(eb_head(eb)->pages[0]) +			\
+				(eb->start & (PAGE_SIZE -1));	\
 	u##bits res = le##bits##_to_cpu(p->member);			\
 	return res;							\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    u##bits val)			\
 {									\
-	type *p = page_address(eb->pages[0]);				\
+	type *p = page_address(eb_head(eb)->pages[0]) +			\
+				(eb->start & (PAGE_SIZE -1));	\
 	p->member = cpu_to_le##bits(val);				\
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 685c81a..299f353 100644
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
@@ -635,12 +634,12 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
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
@@ -679,7 +678,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 * return -EIO.
 	 */
 	if (found_level == 0 && check_leaf(root, eb)) {
-		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+		set_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags);
 		ret = -EIO;
 	}
 
@@ -687,7 +686,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		set_extent_buffer_uptodate(eb);
 err:
 	if (reads_done &&
-	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
+	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
 		btree_readahead_hook(fs_info, eb, eb->start, ret);
 
 	if (ret) {
@@ -696,7 +695,7 @@ err:
 		 * again, we have to make sure it has something
 		 * to decrement
 		 */
-		atomic_inc(&eb->io_pages);
+		atomic_inc(&eb_head(eb)->io_bvecs);
 		clear_extent_buffer_uptodate(eb);
 	}
 	free_extent_buffer(eb);
@@ -709,11 +708,11 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	struct extent_buffer *eb;
 
 	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
+	set_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags);
 	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb->io_pages);
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-		btree_readahead_hook(eb->fs_info, eb, eb->start, -EIO);
+	atomic_dec(&eb_head(eb)->io_bvecs);
+	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
+		btree_readahead_hook(eb_head(eb)->fs_info, eb, eb->start, -EIO);
 	return -EIO;	/* we fixed nothing */
 }
 
@@ -1070,13 +1069,24 @@ static int btree_set_page_dirty(struct page *page)
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
@@ -1117,7 +1127,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 	if (IS_ERR(buf))
 		return 0;
 
-	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
+	set_bit(EXTENT_BUFFER_READAHEAD, &buf->ebflags);
 
 	ret = read_extent_buffer_pages(io_tree, buf, 0, WAIT_PAGE_LOCK,
 				       btree_get_extent, mirror_num);
@@ -1126,7 +1136,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 		return ret;
 	}
 
-	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
+	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags)) {
 		free_extent_buffer(buf);
 		return -EIO;
 	} else if (extent_buffer_uptodate(buf)) {
@@ -1155,14 +1165,16 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 
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
@@ -1192,7 +1204,8 @@ void clean_tree_block(struct btrfs_trans_handle *trans,
 	    fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
-		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
+		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
+						&buf->ebflags)) {
 			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
 					     -buf->len,
 					     fs_info->dirty_metadata_batch);
@@ -3966,7 +3979,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic)
 {
 	int ret;
-	struct inode *btree_inode = buf->pages[0]->mapping->host;
+	struct inode *btree_inode = eb_head(buf)->pages[0]->mapping->host;
 
 	ret = extent_buffer_uptodate(buf);
 	if (!ret)
@@ -3991,10 +4004,10 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
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
@@ -4048,7 +4061,8 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
 
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 {
-	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	struct btrfs_root *root =
+			BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
 	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
@@ -4395,7 +4409,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 			wait_on_extent_buffer_writeback(eb);
 
 			if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
-					       &eb->bflags))
+					       &eb->ebflags))
 				clear_extent_buffer_dirty(eb);
 			free_extent_buffer_stale(eb);
 		}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9c7d0df..51e514c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7175,7 +7175,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 
-		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
+		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->ebflags));
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE, 0);
@@ -7193,7 +7193,7 @@ out:
 	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
 	 * anymore.
 	 */
-	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags);
 }
 
 /* Can return -ENOMEM */
@@ -8234,7 +8234,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
 	clean_tree_block(trans, root->fs_info, buf);
-	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
+	clear_bit(EXTENT_BUFFER_STALE, &buf->ebflags);
 
 	btrfs_set_lock_blocking(buf);
 	set_extent_buffer_uptodate(buf);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f7d035b..080baf7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -23,6 +23,7 @@
 #include "transaction.h"
 
 static struct kmem_cache *extent_state_cache;
+static struct kmem_cache *extent_buffer_head_cache;
 static struct kmem_cache *extent_buffer_cache;
 static struct kmem_cache *page_private_cache;
 static struct bio_set *btrfs_bioset;
@@ -63,6 +64,7 @@ void btrfs_leak_debug_check(void)
 {
 	struct extent_state *state;
 	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh;
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
@@ -75,12 +77,17 @@ void btrfs_leak_debug_check(void)
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
 
@@ -169,11 +176,17 @@ int __init extent_io_init(void)
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
 
 	page_private_cache = kmem_cache_create("btrfs_page_private",
 			sizeof(struct btrfs_page_private), 0,
@@ -203,6 +216,10 @@ free_buffer_cache:
 	kmem_cache_destroy(extent_buffer_cache);
 	extent_buffer_cache = NULL;
 
+free_buffer_head_cache:
+	kmem_cache_destroy(extent_buffer_head_cache);
+	extent_buffer_head_cache = NULL;
+
 free_state_cache:
 	kmem_cache_destroy(extent_state_cache);
 	extent_state_cache = NULL;
@@ -2187,7 +2204,7 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 		return -EROFS;
 
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = eb->pages[i];
+		struct page *p = eb_head(eb)->pages[i];
 
 		ret = repair_io_failure(root->fs_info->btree_inode, start,
 					PAGE_SIZE, start, p,
@@ -3702,8 +3719,8 @@ done_unlocked:
 
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_WRITEBACK,
-		       TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&eb->ebflags, EXTENT_BUFFER_WRITEBACK,
+		    TASK_UNINTERRUPTIBLE);
 }
 
 static noinline_for_stack int
@@ -3721,7 +3738,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		btrfs_tree_lock(eb);
 	}
 
-	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags)) {
 		btrfs_tree_unlock(eb);
 		if (!epd->sync_io)
 			return 0;
@@ -3732,7 +3749,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		while (1) {
 			wait_on_extent_buffer_writeback(eb);
 			btrfs_tree_lock(eb);
-			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
+			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags))
 				break;
 			btrfs_tree_unlock(eb);
 		}
@@ -3743,17 +3760,17 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
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
@@ -3763,7 +3780,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = eb->pages[i];
+		struct page *p = eb_head(eb)->pages[i];
 
 		if (!trylock_page(p)) {
 			if (!flush) {
@@ -3779,18 +3796,19 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 
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
@@ -3857,10 +3875,10 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 
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
@@ -3889,14 +3907,14 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
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
@@ -3908,7 +3926,8 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		if (ret) {
 			set_btree_ioerr(p);
 			end_page_writeback(p);
-			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
+			if (atomic_sub_and_test(num_pages - i,
+							&eb_head(eb)->io_bvecs))
 				end_extent_buffer_writeback(eb);
 			ret = -EIO;
 			break;
@@ -3920,7 +3939,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 
 	if (unlikely(ret)) {
 		for (; i < num_pages; i++) {
-			struct page *p = eb->pages[i];
+			struct page *p = eb_head(eb)->pages[i];
 			clear_page_dirty_for_io(p);
 			unlock_page(p);
 		}
@@ -4008,7 +4027,7 @@ retry:
 				continue;
 			}
 
-			ret = atomic_inc_not_zero(&eb->refs);
+			ret = atomic_inc_not_zero(&eb_head(eb)->refs);
 			spin_unlock(&mapping->private_lock);
 			if (!ret)
 				continue;
@@ -4726,17 +4745,36 @@ out:
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
@@ -4746,7 +4784,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 {
 	unsigned long index;
 	struct page *page;
-	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+	struct extent_buffer_head *ebh = eb_head(eb);
+	int mapped = !test_bit(EXTENT_BUFFER_HEAD_DUMMY, &ebh->bflags);
 
 	BUG_ON(extent_buffer_under_io(eb));
 
@@ -4755,8 +4794,11 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
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
@@ -4769,8 +4811,10 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
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
@@ -4797,20 +4841,18 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
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
@@ -4821,12 +4863,27 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
+}
+
+static struct extent_buffer *
+__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
+		      unsigned long len)
+{
+	struct extent_buffer_head *ebh = NULL;
+	struct extent_buffer *cur_eb, *prev_eb;
+	struct extent_buffer *eb = NULL;
+	int i;
 
-	btrfs_leak_debug_add(&eb->leak_list, &buffers);
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
@@ -4835,7 +4892,44 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 		> MAX_INLINE_EXTENT_BUFFER_SIZE);
 	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
 
+	if (len < PAGE_SIZE) {
+		int ebs_per_page = PAGE_SIZE / len;
+		u64 st = start & ~(PAGE_SIZE - 1);
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
@@ -4845,7 +4939,8 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	struct extent_buffer *new;
 	unsigned long num_pages = num_extent_pages(src->start, src->len);
 
-	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
+	new = __alloc_extent_buffer(eb_head(src)->fs_info, src->start,
+				src->len);
 	if (new == NULL)
 		return NULL;
 
@@ -4855,15 +4950,25 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
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
@@ -4882,19 +4987,19 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
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
 
@@ -4939,14 +5044,16 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
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
@@ -4958,44 +5065,67 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb,
 
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
-			       start >> PAGE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
+	ebh = radix_tree_lookup(&fs_info->buffer_radix,
+				start >> PAGE_SHIFT);
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
 
@@ -5015,14 +5145,13 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	eb = alloc_dummy_extent_buffer(fs_info, start, nodesize);
 	if (!eb)
 		return NULL;
-	eb->fs_info = fs_info;
 again:
 	ret = radix_tree_preload(GFP_NOFS);
 	if (ret)
 		goto free_eb;
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
-				start >> PAGE_SHIFT, eb);
+				start >> PAGE_SHIFT, eb_head(eb));
 	spin_unlock(&fs_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
@@ -5033,7 +5162,7 @@ again:
 			goto again;
 	}
 	check_buffer_tree_ref(eb);
-	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
+	set_bit(EXTENT_BUFFER_HEAD_IN_TREE, &eb_head(eb)->bflags);
 
 	/*
 	 * We will free dummy extent buffer's if they come into
@@ -5041,7 +5170,7 @@ again:
 	 * want the buffers to stay in memory until we're done with them, so
 	 * bump the ref count again.
 	 */
-	atomic_inc(&eb->refs);
+	atomic_inc(&eb_head(eb)->refs);
 	return eb;
 free_eb:
 	btrfs_release_extent_buffer(eb);
@@ -5056,7 +5185,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
 	unsigned long index = start >> PAGE_SHIFT;
-	struct extent_buffer *eb;
+	struct extent_buffer *eb, *cur_eb;
 	struct extent_buffer *exists = NULL;
 	struct page *p;
 	struct address_space *mapping = fs_info->btree_inode->i_mapping;
@@ -5093,12 +5222,18 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			 * overwrite page->private.
 			 */
 			exists = (struct extent_buffer *)p->private;
-			if (atomic_inc_not_zero(&exists->refs)) {
+			if (atomic_inc_not_zero(&eb_head(exists)->refs)) {
 				spin_unlock(&mapping->private_lock);
 				unlock_page(p);
 				put_page(p);
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
 
@@ -5110,10 +5245,11 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			WARN_ON(PageDirty(p));
 			put_page(p);
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
 
@@ -5122,8 +5258,12 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
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
 	ret = radix_tree_preload(GFP_NOFS);
 	if (ret) {
@@ -5133,7 +5273,7 @@ again:
 
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
-				start >> PAGE_SHIFT, eb);
+				start >> PAGE_SHIFT, eb_head(eb));
 	spin_unlock(&fs_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
@@ -5145,7 +5285,7 @@ again:
 	}
 	/* add one reference for the tree */
 	check_buffer_tree_ref(eb);
-	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
+	set_bit(EXTENT_BUFFER_HEAD_IN_TREE, &eb_head(eb)->bflags);
 
 	/*
 	 * there is a race where release page may have
@@ -5156,20 +5296,20 @@ again:
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
@@ -5178,92 +5318,111 @@ free_eb:
 
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
-					  eb->start >> PAGE_SHIFT);
+					ebh->eb.start >> PAGE_SHIFT);
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
+						&ebh->bflags))) {
+			__free_extent_buffer(ebh);
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
@@ -5274,8 +5433,11 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 
+	if (eb->len < PAGE_SIZE && !page_ebs_clean(eb_head(eb)))
+		return;
+
 	for (i = 0; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		if (!PageDirty(page))
 			continue;
 
@@ -5293,7 +5455,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 		ClearPageError(page);
 		unlock_page(page);
 	}
-	WARN_ON(atomic_read(&eb->refs) == 0);
+	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
 }
 
 int set_extent_buffer_dirty(struct extent_buffer *eb)
@@ -5304,14 +5466,14 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 
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
 
@@ -5321,10 +5483,10 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
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
@@ -5332,21 +5494,41 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 
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
+	if (eb->len < PAGE_SIZE) {
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
@@ -5365,7 +5547,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
 
-	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags))
 		return 0;
 
 	if (start) {
@@ -5378,7 +5560,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = start_i; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		if (wait == WAIT_NONE) {
 			if (!trylock_page(page))
 				goto unlock_exit;
@@ -5393,15 +5575,15 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
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
@@ -5415,9 +5597,9 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 				 * so we ensure that if it returns error, the
 				 * current page fails to add itself to bio.
 				 *
-				 * We must dec io_pages by ourselves.
+				 * We must dec io_bvecs by ourselves.
 				 */
-				atomic_dec(&eb->io_pages);
+				atomic_dec(&eb_head(eb)->io_bvecs);
 			}
 		} else {
 			unlock_page(page);
@@ -5435,7 +5617,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		return ret;
 
 	for (i = start_i; i < num_pages; i++) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		wait_on_page_locked(page);
 		if (!PageUptodate(page))
 			ret = -EIO;
@@ -5446,7 +5628,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 unlock_exit:
 	i = start_i;
 	while (locked_pages > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 		i++;
 		unlock_page(page);
 		locked_pages--;
@@ -5472,7 +5654,7 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	offset = (start_offset + start) & (PAGE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, (PAGE_SIZE - offset));
 		kaddr = page_address(page);
@@ -5504,7 +5686,7 @@ int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dstv,
 	offset = (start_offset + start) & (PAGE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, (PAGE_SIZE - offset));
 		kaddr = page_address(page);
@@ -5558,7 +5740,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 		return -EINVAL;
 	}
 
-	p = eb->pages[i];
+	p = eb_head(eb)->pages[i];
 	kaddr = page_address(p);
 	*map = kaddr + offset;
 	*map_len = PAGE_SIZE - offset;
@@ -5584,7 +5766,7 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 	offset = (start_offset + start) & (PAGE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, (PAGE_SIZE - offset));
 
@@ -5614,12 +5796,12 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
 
 	offset = (start_offset + start) & (PAGE_SIZE - 1);
 
 	while (len > 0) {
-		page = eb->pages[i];
-		WARN_ON(!PageUptodate(page));
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, PAGE_SIZE - offset);
 		kaddr = page_address(page);
@@ -5647,9 +5829,10 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 
 	offset = (start_offset + start) & (PAGE_SIZE - 1);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
+
 	while (len > 0) {
-		page = eb->pages[i];
-		WARN_ON(!PageUptodate(page));
+		page = eb_head(eb)->pages[i];
 
 		cur = min(len, PAGE_SIZE - offset);
 		kaddr = page_address(page);
@@ -5678,9 +5861,10 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	offset = (start_offset + dst_offset) &
 		(PAGE_SIZE - 1);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &dst->ebflags));
+
 	while (len > 0) {
-		page = dst->pages[i];
-		WARN_ON(!PageUptodate(page));
+		page = eb_head(dst)->pages[i];
 
 		cur = min(len, (unsigned long)(PAGE_SIZE - offset));
 
@@ -5753,9 +5937,10 @@ int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
 	unsigned long i;
 	size_t offset;
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
+
 	eb_bitmap_offset(eb, start, nr, &i, &offset);
-	page = eb->pages[i];
-	WARN_ON(!PageUptodate(page));
+	page = eb_head(eb)->pages[i];
 	kaddr = page_address(page);
 	return 1U & (kaddr[offset] >> (nr & (BITS_PER_BYTE - 1)));
 }
@@ -5778,9 +5963,10 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
 	int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
 	unsigned int mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
+
 	eb_bitmap_offset(eb, start, pos, &i, &offset);
-	page = eb->pages[i];
-	WARN_ON(!PageUptodate(page));
+	page = eb_head(eb)->pages[i];
 	kaddr = page_address(page);
 
 	while (len >= bits_to_set) {
@@ -5790,7 +5976,7 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
 		mask_to_set = ~0U;
 		if (++offset >= PAGE_SIZE && len > 0) {
 			offset = 0;
-			page = eb->pages[++i];
+			page = eb_head(eb)->pages[++i];
 			WARN_ON(!PageUptodate(page));
 			kaddr = page_address(page);
 		}
@@ -5820,9 +6006,10 @@ void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
 	int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
 	unsigned int mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
 
+	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
+
 	eb_bitmap_offset(eb, start, pos, &i, &offset);
-	page = eb->pages[i];
-	WARN_ON(!PageUptodate(page));
+	page = eb_head(eb)->pages[i];
 	kaddr = page_address(page);
 
 	while (len >= bits_to_clear) {
@@ -5832,7 +6019,7 @@ void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
 		mask_to_clear = ~0U;
 		if (++offset >= PAGE_SIZE && len > 0) {
 			offset = 0;
-			page = eb->pages[++i];
+			page = eb_head(eb)->pages[++i];
 			WARN_ON(!PageUptodate(page));
 			kaddr = page_address(page);
 		}
@@ -5882,13 +6069,13 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
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
@@ -5908,8 +6095,9 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		cur = min_t(unsigned long, cur,
 			(unsigned long)(PAGE_SIZE - dst_off_in_page));
 
-		copy_pages(dst->pages[dst_i], dst->pages[src_i],
-			   dst_off_in_page, src_off_in_page, cur);
+		copy_pages(eb_head(dst)->pages[dst_i],
+			eb_head(dst)->pages[src_i],
+			dst_off_in_page, src_off_in_page, cur);
 
 		src_offset += cur;
 		dst_offset += cur;
@@ -5930,13 +6118,15 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
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
@@ -5954,9 +6144,10 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
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
@@ -5966,6 +6157,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
 int try_release_extent_buffer(struct page *page)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 
 	/*
@@ -5981,14 +6173,15 @@ int try_release_extent_buffer(struct page *page)
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
@@ -5998,10 +6191,11 @@ int try_release_extent_buffer(struct page *page)
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
index c08a8ab..9f073a1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -31,18 +31,20 @@
 #define EXTENT_BIO_TREE_LOG 2
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
@@ -180,17 +182,17 @@ struct extent_state {
 
 #define INLINE_EXTENT_BUFFER_PAGES 16
 #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_SIZE)
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
@@ -203,6 +205,8 @@ struct extent_buffer {
 	/* >= 0 if eb belongs to a log tree, -1 otherwise */
 	short log_index;
 
+	pid_t lock_owner;
+
 	/* protects write locks */
 	rwlock_t lock;
 
@@ -215,7 +219,20 @@ struct extent_buffer {
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
@@ -243,6 +260,14 @@ static inline int extent_compress_type(unsigned long bio_flags)
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
@@ -436,7 +461,7 @@ static inline unsigned long num_extent_pages(u64 start, u64 len)
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
-	atomic_inc(&eb->refs);
+	atomic_inc(&eb_head(eb)->refs);
 }
 
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index f1c3086..090fbd8 100644
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
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ee56b0e..cba92e6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2324,13 +2324,20 @@ static int btrfs_run_sanity_tests(void)
 	int ret, i;
 	u32 sectorsize, nodesize;
 	u32 test_sectorsize[] = {
-		PAGE_SIZE,
+		4096,
+		8192,
+		16384,
+		32768,
+		65536,
 	};
 	ret = btrfs_init_test_fs();
 	if (ret)
 		return ret;
+
 	for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
 		sectorsize = test_sectorsize[i];
+		if (sectorsize > PAGE_SIZE)
+			break;
 		for (nodesize = sectorsize;
 		     nodesize <= BTRFS_MAX_METADATA_BLOCKSIZE;
 		     nodesize <<= 1) {
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 02223f3..87174d8 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -138,19 +138,19 @@ static void btrfs_free_dummy_fs_info(struct btrfs_fs_info *fs_info)
 
 	spin_lock(&fs_info->buffer_lock);
 	radix_tree_for_each_slot(slot, &fs_info->buffer_radix, &iter, 0) {
-		struct extent_buffer *eb;
+		struct extent_buffer_head *ebh;
 
-		eb = radix_tree_deref_slot_protected(slot, &fs_info->buffer_lock);
-		if (!eb)
+		ebh = radix_tree_deref_slot_protected(slot, &fs_info->buffer_lock);
+		if (!ebh)
 			continue;
 		/* Shouldn't happen but that kind of thinking creates CVE's */
-		if (radix_tree_exception(eb)) {
-			if (radix_tree_deref_retry(eb))
+		if (radix_tree_exception(ebh)) {
+			if (radix_tree_deref_retry(ebh))
 				slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
 		spin_unlock(&fs_info->buffer_lock);
-		free_extent_buffer_stale(eb);
+		free_extent_buffer_stale(&ebh->eb);
 		spin_lock(&fs_info->buffer_lock);
 	}
 	spin_unlock(&fs_info->buffer_lock);
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d19ab03..6f3ea83 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -375,11 +375,12 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 
 	test_msg("Running extent buffer bitmap tests\n");
 
+
 	/*
 	 * In ppc64, sectorsize can be 64K, thus 4 * 64K will be larger than
 	 * BTRFS_MAX_METADATA_BLOCKSIZE.
 	 */
-	len = (sectorsize < BTRFS_MAX_METADATA_BLOCKSIZE)
+	len = ((sectorsize * 4) <= BTRFS_MAX_METADATA_BLOCKSIZE)
 		? sectorsize * 4 : sectorsize;
 
 	bitmap = kmalloc(len, GFP_KERNEL);
@@ -401,7 +402,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 
 	/* Do it over again with an extent buffer which isn't page-aligned. */
 	free_extent_buffer(eb);
-	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
+	eb = __alloc_dummy_extent_buffer(NULL, PAGE_SIZE / 2, len);
 	if (!eb) {
 		test_msg("Couldn't allocate test extent buffer\n");
 		kfree(bitmap);
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index aac5070..2f3d05d 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -31,7 +31,7 @@ struct free_space_extent {
  * The test cases align their operations to this in order to hit some of the
  * edge cases in the bitmap code.
  */
-#define BITMAP_RANGE (BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE)
+#define BITMAP_RANGE(sectorsize) (BTRFS_FREE_SPACE_BITMAP_BITS * (sectorsize))
 
 static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 				      struct btrfs_fs_info *fs_info,
@@ -203,14 +203,15 @@ static int test_remove_beginning(struct btrfs_trans_handle *trans,
 				 struct btrfs_block_group_cache *cache,
 				 struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid + BITMAP_RANGE,
-			cache->key.offset - BITMAP_RANGE},
+		{cache->key.objectid + bitmap_range,
+			cache->key.offset - bitmap_range},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
-					    cache->key.objectid, BITMAP_RANGE);
+					    cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -226,15 +227,16 @@ static int test_remove_end(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, cache->key.offset - BITMAP_RANGE},
+		{cache->key.objectid, cache->key.offset - bitmap_range},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
 					    cache->key.objectid +
-					    cache->key.offset - BITMAP_RANGE,
-					    BITMAP_RANGE);
+					    cache->key.offset - bitmap_range,
+					    bitmap_range);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -249,16 +251,17 @@ static int test_remove_middle(struct btrfs_trans_handle *trans,
 			      struct btrfs_block_group_cache *cache,
 			      struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, BITMAP_RANGE},
-		{cache->key.objectid + 2 * BITMAP_RANGE,
-			cache->key.offset - 2 * BITMAP_RANGE},
+		{cache->key.objectid, bitmap_range},
+		{cache->key.objectid + 2 * bitmap_range,
+			cache->key.offset - 2 * bitmap_range},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
-					    cache->key.objectid + BITMAP_RANGE,
-					    BITMAP_RANGE);
+					    cache->key.objectid + bitmap_range,
+					    bitmap_range);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -273,8 +276,9 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, 2 * BITMAP_RANGE},
+		{cache->key.objectid, 2 * bitmap_range},
 	};
 	int ret;
 
@@ -287,15 +291,15 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -310,8 +314,9 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid + BITMAP_RANGE, 2 * BITMAP_RANGE},
+		{cache->key.objectid + bitmap_range, 2 * bitmap_range},
 	};
 	int ret;
 
@@ -324,16 +329,16 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -348,8 +353,9 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, 3 * BITMAP_RANGE},
+		{cache->key.objectid, 3 * bitmap_range},
 	};
 	int ret;
 
@@ -362,23 +368,23 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -393,10 +399,11 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, BITMAP_RANGE},
-		{cache->key.objectid + 2 * BITMAP_RANGE, BITMAP_RANGE},
-		{cache->key.objectid + 4 * BITMAP_RANGE, BITMAP_RANGE},
+		{cache->key.objectid, bitmap_range},
+		{cache->key.objectid + 2 * bitmap_range, bitmap_range},
+		{cache->key.objectid + 4 * bitmap_range, bitmap_range},
 	};
 	int ret;
 
@@ -409,23 +416,23 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 4 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 4 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -479,7 +486,7 @@ static int run_test(test_func_t test_func, int bitmaps,
 	btrfs_set_header_nritems(root->node, 0);
 	root->alloc_bytenr += 2 * nodesize;
 
-	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE, sectorsize);
+	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE(sectorsize), sectorsize);
 	if (!cache) {
 		test_msg("Couldn't allocate dummy block group cache\n");
 		ret = -ENOMEM;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2f631b5..986c2d8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6624,7 +6624,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	 * to silence the warning eg. on PowerPC 64.
 	 */
 	if (PAGE_SIZE > BTRFS_SUPER_INFO_SIZE)
-		SetPageUptodate(sb->pages[0]);
+		SetPageUptodate(eb_head(sb)->pages[0]);
 
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e030d6f..1a4793e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -765,7 +765,7 @@ TRACE_EVENT(btrfs_cow_block,
 	TP_fast_assign_btrfs(root->fs_info,
 		__entry->root_objectid	= root->root_key.objectid;
 		__entry->buf_start	= buf->start;
-		__entry->refs		= atomic_read(&buf->refs);
+		__entry->refs		= atomic_read(&eb_head(buf)->refs);
 		__entry->cow_start	= cow->start;
 		__entry->buf_level	= btrfs_header_level(buf);
 		__entry->cow_level	= btrfs_header_level(cow);
-- 
2.5.5

