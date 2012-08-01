Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49142 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2HAVBq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Aug 2012 17:01:46 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id wGWBtDUCgw7hihww (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 15:01:42 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC] [PATCH] Btrfs: manage metadata cache ourselves
Date: Wed, 1 Aug 2012 17:06:45 -0400
Message-ID: <1343855205-25043-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

===================================
PLEASE REVIEW AND TEST THIS CAREFULLY

I've dug this patch out of the bin and cleaned it up but who knows what kind of
crust I've missed.  This makes the create empty files until the file system is
full run 5 minutes faster on my hardware so it's a pretty awesome improvement,
plus it lets us get rid of a lot of complexity.  I think it works pretty well,
and I've been going through and widdling it down, but now I need somebody
*cough*Dave*cough* to go through it with a fine toothed comb and point out all
the stupid mistakes I've made.

===================================
This patch moves the management of the metadata cache from pagecache to our own
internal caching which can choose to evict things based on what is no longer in
use.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c         |    5 +-
 fs/btrfs/ctree.h         |   14 +-
 fs/btrfs/delayed-inode.c |    1 -
 fs/btrfs/disk-io.c       |  984 +++++++++++++++++++++++-----------------------
 fs/btrfs/disk-io.h       |    4 -
 fs/btrfs/extent-tree.c   |    2 +-
 fs/btrfs/extent_io.c     |  980 ++++++++++++++-------------------------------
 fs/btrfs/extent_io.h     |   81 +++-
 fs/btrfs/relocation.c    |    5 -
 fs/btrfs/super.c         |    4 +-
 fs/btrfs/transaction.c   |   75 ++--
 fs/btrfs/transaction.h   |    2 +
 fs/btrfs/tree-log.c      |   44 ++-
 fs/btrfs/volumes.c       |    2 +-
 14 files changed, 948 insertions(+), 1255 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9d7621f..de2ac48 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -147,7 +147,10 @@ noinline void btrfs_release_path(struct btrfs_path *p)
 			btrfs_tree_unlock_rw(p->nodes[i], p->locks[i]);
 			p->locks[i] = 0;
 		}
-		free_extent_buffer(p->nodes[i]);
+		if (unlikely(p->search_commit_root))
+			free_extent_buffer_stale(p->nodes[i]);
+		else
+			free_extent_buffer(p->nodes[i]);
 		p->nodes[i] = NULL;
 	}
 }
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index adb1cd7..704a345 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1158,6 +1158,14 @@ struct btrfs_fs_info {
 	spinlock_t fs_roots_radix_lock;
 	struct radix_tree_root fs_roots_radix;
 
+	/* eb caching stuff */
+	spinlock_t eb_tree_lock;
+	spinlock_t eb_lru_lock;
+	struct list_head eb_lru;
+	int eb_lru_nr;
+	struct radix_tree_root eb_tree;
+	struct shrinker eb_shrinker;
+
 	/* block group cache stuff */
 	spinlock_t block_group_cache_lock;
 	struct rb_root block_group_cache_tree;
@@ -1210,13 +1218,13 @@ struct btrfs_fs_info {
 	struct btrfs_super_block *super_for_commit;
 	struct block_device *__bdev;
 	struct super_block *sb;
-	struct inode *btree_inode;
 	struct backing_dev_info bdi;
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
+	struct mutex metadata_flusher_mutex;
 	/*
 	 * this protects the ordered operations list only while we are
 	 * processing all of the entries on it.  This way we make
@@ -1263,6 +1271,7 @@ struct btrfs_fs_info {
 	atomic_t nr_async_bios;
 	atomic_t async_delalloc_pages;
 	atomic_t open_ioctl_trans;
+	atomic_t dirty_ebs;
 
 	/*
 	 * this is used by the balancing code to wait for all the pending
@@ -1312,6 +1321,9 @@ struct btrfs_fs_info {
 	struct btrfs_workers submit_workers;
 	struct btrfs_workers caching_workers;
 	struct btrfs_workers readahead_workers;
+	struct btrfs_workers eb_writeback_worker;
+	struct btrfs_work eb_writeback_work;
+	u64 writeback_index;
 
 	/*
 	 * fixup workers take dirty pages that didn't properly go through
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 335605c..0018a32 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1320,7 +1320,6 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 
 	trans->block_rsv = block_rsv;
 	btrfs_end_transaction_dmeta(trans, root);
-	__btrfs_btree_balance_dirty(root, nr);
 free_path:
 	btrfs_free_path(path);
 out:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 502b20c..adf277e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -46,7 +46,6 @@
 #include "check-integrity.h"
 #include "rcu-string.h"
 
-static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
@@ -86,6 +85,7 @@ struct end_io_wq {
  */
 struct async_submit_bio {
 	struct inode *inode;
+	struct btrfs_root *root;
 	struct bio *bio;
 	struct list_head list;
 	extent_submit_bio_hook_t *submit_bio_start;
@@ -181,66 +181,6 @@ void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb,
 
 #endif
 
-/*
- * extents on the btree inode are pretty simple, there's one extent
- * that covers the entire device
- */
-static struct extent_map *btree_get_extent(struct inode *inode,
-		struct page *page, size_t pg_offset, u64 start, u64 len,
-		int create)
-{
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct extent_map *em;
-	int ret;
-
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, start, len);
-	if (em) {
-		em->bdev =
-			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
-		read_unlock(&em_tree->lock);
-		goto out;
-	}
-	read_unlock(&em_tree->lock);
-
-	em = alloc_extent_map();
-	if (!em) {
-		em = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-	em->start = 0;
-	em->len = (u64)-1;
-	em->block_len = (u64)-1;
-	em->block_start = 0;
-	em->bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
-
-	write_lock(&em_tree->lock);
-	ret = add_extent_mapping(em_tree, em);
-	if (ret == -EEXIST) {
-		u64 failed_start = em->start;
-		u64 failed_len = em->len;
-
-		free_extent_map(em);
-		em = lookup_extent_mapping(em_tree, start, len);
-		if (em) {
-			ret = 0;
-		} else {
-			em = lookup_extent_mapping(em_tree, failed_start,
-						   failed_len);
-			ret = -EIO;
-		}
-	} else if (ret) {
-		free_extent_map(em);
-		em = NULL;
-	}
-	write_unlock(&em_tree->lock);
-
-	if (ret)
-		em = ERR_PTR(ret);
-out:
-	return em;
-}
-
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
 {
 	return crc32c(seed, data, len);
@@ -323,11 +263,9 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
  * detect blocks that either didn't get written at all or got written
  * in the wrong place.
  */
-static int verify_parent_transid(struct extent_io_tree *io_tree,
-				 struct extent_buffer *eb, u64 parent_transid,
+static int verify_parent_transid(struct extent_buffer *eb, u64 parent_transid,
 				 int atomic)
 {
-	struct extent_state *cached_state = NULL;
 	int ret;
 
 	if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
@@ -336,8 +274,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 	if (atomic)
 		return -EAGAIN;
 
-	lock_extent_bits(io_tree, eb->start, eb->start + eb->len - 1,
-			 0, &cached_state);
+	extent_buffer_iolock(eb);
 	if (extent_buffer_uptodate(eb) &&
 	    btrfs_header_generation(eb) == parent_transid) {
 		ret = 0;
@@ -351,8 +288,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 	ret = 1;
 	clear_extent_buffer_uptodate(eb);
 out:
-	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
-			     &cached_state, GFP_NOFS);
+	extent_buffer_iounlock(eb);
 	return ret;
 }
 
@@ -364,7 +300,6 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 					  struct extent_buffer *eb,
 					  u64 start, u64 parent_transid)
 {
-	struct extent_io_tree *io_tree;
 	int failed = 0;
 	int ret;
 	int num_copies = 0;
@@ -372,14 +307,10 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	int failed_mirror = 0;
 
 	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
-	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	while (1) {
-		ret = read_extent_buffer_pages(io_tree, eb, start,
-					       WAIT_COMPLETE,
-					       btree_get_extent, mirror_num);
-		if (!ret && !verify_parent_transid(io_tree, eb,
-						   parent_transid, 0))
-			break;
+		ret = read_extent_buffer_pages(eb, WAIT_COMPLETE, mirror_num);
+		if (!ret && !verify_parent_transid(eb, parent_transid, 0))
+			return ret;
 
 		/*
 		 * This buffer's crc is fine, but its contents are corrupted, so
@@ -420,33 +351,60 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 
 static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
-	struct extent_io_tree *tree;
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 found_start;
 	struct extent_buffer *eb;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
+	if (!page->private) {
+		WARN_ON(1);
+		goto out;
+	}
 
 	eb = (struct extent_buffer *)page->private;
 	if (page != eb->pages[0])
-		return 0;
+		goto out;
+
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != start) {
 		WARN_ON(1);
-		return 0;
-	}
-	if (eb->pages[0] != page) {
-		WARN_ON(1);
-		return 0;
-	}
-	if (!PageUptodate(page)) {
-		WARN_ON(1);
-		return 0;
+		goto out;
 	}
 	csum_tree_block(root, eb, 0);
+out:
 	return 0;
 }
 
+static void eb_write_endio(struct bio *bio, int err)
+{
+	struct bio_vec *bvec = bio->bi_io_vec;
+	int bio_index = 0;
+	int uptodate = err == 0;
+	struct extent_buffer *eb, *prev_eb = NULL;
+
+	while (bio_index < bio->bi_vcnt) {
+		eb = (struct extent_buffer *)bvec->bv_page->private;
+		if (!uptodate) {
+			clear_extent_buffer_uptodate(eb);
+			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+			WARN_ON(1);
+		}
+
+		if (atomic_dec_and_test(&eb->io_pages)) {
+			clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
+			extent_buffer_iounlock(eb);
+		}
+
+		if (prev_eb != eb)
+			free_extent_buffer(prev_eb);
+		prev_eb = eb;
+		bio_index++;
+		bvec++;
+	}
+
+	free_extent_buffer(prev_eb);
+	bio_put(bio);
+}
+
 static int check_tree_block_fsid(struct btrfs_root *root,
 				 struct extent_buffer *eb)
 {
@@ -533,65 +491,13 @@ static noinline int check_leaf(struct btrfs_root *root,
 	return 0;
 }
 
-struct extent_buffer *find_eb_for_page(struct extent_io_tree *tree,
-				       struct page *page, int max_walk)
-{
-	struct extent_buffer *eb;
-	u64 start = page_offset(page);
-	u64 target = start;
-	u64 min_start;
-
-	if (start < max_walk)
-		min_start = 0;
-	else
-		min_start = start - max_walk;
-
-	while (start >= min_start) {
-		eb = find_extent_buffer(tree, start, 0);
-		if (eb) {
-			/*
-			 * we found an extent buffer and it contains our page
-			 * horray!
-			 */
-			if (eb->start <= target &&
-			    eb->start + eb->len > target)
-				return eb;
-
-			/* we found an extent buffer that wasn't for us */
-			free_extent_buffer(eb);
-			return NULL;
-		}
-		if (start == 0)
-			break;
-		start -= PAGE_CACHE_SIZE;
-	}
-	return NULL;
-}
-
-static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
-			       struct extent_state *state, int mirror)
+static void process_eb_read(struct extent_buffer *eb, int mirror)
 {
-	struct extent_io_tree *tree;
 	u64 found_start;
 	int found_level;
-	struct extent_buffer *eb;
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
-	int ret = 0;
-	int reads_done;
-
-	if (!page->private)
-		goto out;
-
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	eb = (struct extent_buffer *)page->private;
-
-	/* the pending IO might have been the only thing that kept this buffer
-	 * in memory.  Make sure we have a ref for all this other checks
-	 */
-	extent_buffer_get(eb);
+	int ret = -EIO;
 
-	reads_done = atomic_dec_and_test(&eb->io_pages);
-	if (!reads_done)
+	if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags))
 		goto err;
 
 	eb->read_mirror = mirror;
@@ -606,13 +512,11 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       "%llu %llu\n",
 			       (unsigned long long)found_start,
 			       (unsigned long long)eb->start);
-		ret = -EIO;
 		goto err;
 	}
-	if (check_tree_block_fsid(root, eb)) {
+	if (check_tree_block_fsid(eb->root, eb)) {
 		printk_ratelimited(KERN_INFO "btrfs bad fsid on block %llu\n",
 			       (unsigned long long)eb->start);
-		ret = -EIO;
 		goto err;
 	}
 	found_level = btrfs_header_level(eb);
@@ -620,48 +524,70 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
 				       eb, found_level);
 
-	ret = csum_tree_block(root, eb, 1);
-	if (ret) {
-		ret = -EIO;
+	if (csum_tree_block(eb->root, eb, 1))
 		goto err;
-	}
 
 	/*
 	 * If this is a leaf block and it is corrupt, set the corrupt bit so
 	 * that we don't try and read the other copies of this block, just
 	 * return -EIO.
 	 */
-	if (found_level == 0 && check_leaf(root, eb)) {
+	if (found_level == 0 && check_leaf(eb->root, eb))
 		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
-		ret = -EIO;
-	}
+	else
+		ret = 0;
 
 	if (!ret)
 		set_extent_buffer_uptodate(eb);
 err:
+	/*
+	 * We have to check to make sure that we don't have IOERR set since this
+	 * eb could have been split up between multiple bios and one of the
+	 * other ones may have failed.
+	 */
+	if (!ret && !test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
+		set_extent_buffer_uptodate(eb);
+	} else if (ret) {
+		clear_extent_buffer_uptodate(eb);
+		set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	}
+
 	if (test_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)) {
 		clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags);
-		btree_readahead_hook(root, eb, eb->start, ret);
+		btree_readahead_hook(eb->root, eb, eb->start, ret);
 	}
 
-	if (ret)
-		clear_extent_buffer_uptodate(eb);
-	free_extent_buffer(eb);
-out:
-	return ret;
+	extent_buffer_iounlock(eb);
 }
 
-static int btree_io_failed_hook(struct page *page, int failed_mirror)
+static void eb_read_endio(struct bio *bio, int err)
 {
-	struct extent_buffer *eb;
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+	struct extent_buffer *eb, *prev_eb = NULL;
+	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct bio_vec *bvec = bio->bi_io_vec;
+	int bio_index = 0;
 
-	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->read_mirror = failed_mirror;
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-		btree_readahead_hook(root, eb, eb->start, -EIO);
-	return -EIO;	/* we fixed nothing */
+	if (err)
+		uptodate = 0;
+
+	eb = bio->bi_private;
+
+	while (bio_index < bio->bi_vcnt) {
+		eb = (struct extent_buffer *)bvec->bv_page->private;
+		if (!uptodate)
+			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+		if (atomic_dec_and_test(&eb->io_pages))
+			process_eb_read(eb, (int)(unsigned long)bio->bi_bdev);
+
+		if (prev_eb != eb)
+			free_extent_buffer(prev_eb);
+		prev_eb = eb;
+		bvec++;
+		bio_index++;
+	}
+
+	free_extent_buffer(prev_eb);
+	bio_put(bio);
 }
 
 static void end_workqueue_bio(struct bio *bio, int err)
@@ -831,10 +757,12 @@ static int btree_csum_one_bio(struct bio *bio)
 	int bio_index = 0;
 	struct btrfs_root *root;
 	int ret = 0;
+	struct extent_buffer *eb;
 
 	WARN_ON(bio->bi_vcnt <= 0);
 	while (bio_index < bio->bi_vcnt) {
-		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
+		eb = (struct extent_buffer *)bvec->bv_page->private;
+		root = eb->root;
 		ret = csum_dirty_buffer(root, bvec->bv_page);
 		if (ret)
 			break;
@@ -844,176 +772,407 @@ static int btree_csum_one_bio(struct bio *bio)
 	return ret;
 }
 
-static int __btree_submit_bio_start(struct inode *inode, int rw,
-				    struct bio *bio, int mirror_num,
-				    unsigned long bio_flags,
-				    u64 bio_offset)
+static void __btree_submit_bio_start(struct btrfs_work *work)
 {
+	struct async_submit_bio *async;
+	int ret;
+
+	async = container_of(work, struct async_submit_bio, work);
 	/*
 	 * when we're called for a write, we're already in the async
 	 * submission context.  Just jump into btrfs_map_bio
 	 */
-	return btree_csum_one_bio(bio);
+	ret = btree_csum_one_bio(async->bio);
+	if (ret)
+		async->error = ret;
 }
 
-static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
-				 int mirror_num, unsigned long bio_flags,
-				 u64 bio_offset)
+static void __btree_submit_bio_done(struct btrfs_work *work)
 {
+	struct async_submit_bio *async;
+	struct btrfs_fs_info *fs_info;
+	int limit;
+	int ret;
+
+	async = container_of(work, struct async_submit_bio, work);
+	fs_info = async->root->fs_info;
+
+	limit = btrfs_async_submit_limit(fs_info);
+	limit = limit * 2 / 3;
+
+	atomic_dec(&fs_info->nr_async_submits);
+
+	if (atomic_read(&fs_info->nr_async_submits) < limit &&
+	    waitqueue_active(&fs_info->async_submit_wait))
+		wake_up(&fs_info->async_submit_wait);
+
+	if (async->error) {
+		bio_endio(async->bio, async->error);
+		return;
+	}
+
 	/*
 	 * when we're called for a write, we're already in the async
 	 * submission context.  Just jump into btrfs_map_bio
 	 */
-	return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 1);
+	ret = btrfs_map_bio(async->root, async->rw, async->bio,
+			    async->mirror_num, 1);
+	if (ret)
+		bio_endio(async->bio, ret);
 }
 
-static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
-				 int mirror_num, unsigned long bio_flags,
-				 u64 bio_offset)
+int btrfs_wq_btree_submit_bio(struct btrfs_root *root, int rw,
+			      struct bio *bio, int mirror_num)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct async_submit_bio *async;
+
+	async = kmalloc(sizeof(*async), GFP_NOFS);
+	if (!async)
+		return -ENOMEM;
+
+	async->root = root;
+	async->rw = rw;
+	async->bio = bio;
+	async->mirror_num = mirror_num;
+	async->error = 0;
+
+	async->work.func = __btree_submit_bio_start;
+	async->work.ordered_func = __btree_submit_bio_done;
+	async->work.ordered_free = run_one_async_free;
+
+	async->work.flags = 0;
+
+	atomic_inc(&fs_info->nr_async_submits);
+
+	if (rw & REQ_SYNC)
+		btrfs_set_work_high_prio(&async->work);
+
+	btrfs_queue_worker(&fs_info->workers, &async->work);
+
+	while (atomic_read(&fs_info->async_submit_draining) &&
+	      atomic_read(&fs_info->nr_async_submits)) {
+		wait_event(fs_info->async_submit_wait,
+			   (atomic_read(&fs_info->nr_async_submits) == 0));
+	}
+
+	return 0;
+}
+
+static int btree_submit_bio(struct btrfs_root *root, int rw, struct bio *bio,
+			    int mirror_num)
 {
 	int ret;
 
-	if (!(rw & REQ_WRITE)) {
+	bio_get(bio);
+
+	/*
+	 * We can possibly free our EB in our endio handler, so instead of
+	 * making every spin lock we touch in the free path irq safe just do all
+	 * of our endio work in helper threads.  It may be worth it at some
+	 * point to have a delayed free sort of thing like the delayed iput
+	 * stuff in order to allow writes to be completed in irq context, but
+	 * for now lets be lazy.
+	 */
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 1);
+	if (ret)
+		return ret;
 
+	if (!(rw & REQ_WRITE)) {
 		/*
 		 * called for a read, do the setup so that checksum validation
 		 * can happen in the async kernel threads
 		 */
-		ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info,
-					  bio, 1);
-		if (ret)
-			return ret;
-		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
-				     mirror_num, 0);
+		ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
+	} else {
+		/*
+		 * kthread helpers are used to submit writes so that
+		 * checksumming can happen in parallel across all CPUs
+		 */
+		ret = btrfs_wq_btree_submit_bio(root, rw, bio, mirror_num);
 	}
 
-	/*
-	 * kthread helpers are used to submit writes so that checksumming
-	 * can happen in parallel across all CPUs
-	 */
-	return btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-				   inode, rw, bio, mirror_num, 0,
-				   bio_offset,
-				   __btree_submit_bio_start,
-				   __btree_submit_bio_done);
+	if (bio_flagged(bio, BIO_EOPNOTSUPP))
+		ret = -EOPNOTSUPP;
+	bio_put(bio);
+	return ret;
 }
 
-#ifdef CONFIG_MIGRATION
-static int btree_migratepage(struct address_space *mapping,
-			struct page *newpage, struct page *page,
-			enum migrate_mode mode)
+static struct bio *eb_setup_bio(struct extent_buffer *eb,
+				bio_end_io_t end_io_func, u64 start,
+				int single_bio)
 {
-	/*
-	 * we can't safely write a btree page from here,
-	 * we haven't done the locking hook
-	 */
-	if (PageDirty(page))
-		return -EAGAIN;
-	/*
-	 * Buffers may be managed in a filesystem specific way.
-	 * We must have no buffers or drop them.
-	 */
-	if (page_has_private(page) &&
-	    !try_to_release_page(page, GFP_KERNEL))
-		return -EAGAIN;
-	return migrate_page(mapping, newpage, page, mode);
+	struct block_device *bdev = eb->root->fs_info->fs_devices->latest_bdev;
+	struct bio *bio;
+	int nr_vecs = bio_get_nr_vecs(bdev);
+
+	if (single_bio)
+		nr_vecs = min_t(int, nr_vecs,
+				num_extent_pages(eb->start, eb->len));
+
+	bio = btrfs_bio_alloc(bdev, start >> 9, nr_vecs,
+			      GFP_NOFS | __GFP_HIGH);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
+
+	bio->bi_end_io = end_io_func;
+	bio->bi_private = eb;
+	return bio;
 }
-#endif
 
+int merge_bio(struct btrfs_root *root, size_t size, struct bio *bio)
+{
+	struct btrfs_mapping_tree *map_tree;
+	u64 logical = (u64)bio->bi_sector << 9;
+	u64 length = 0;
+	u64 map_length;
+	int ret;
+
+	length = bio->bi_size;
+	map_tree = &root->fs_info->mapping_tree;
+	map_length = length;
+	ret = btrfs_map_block(map_tree, READ, logical,
+			      &map_length, NULL, 0);
 
-static int btree_writepages(struct address_space *mapping,
-			    struct writeback_control *wbc)
+	if (map_length < length + size)
+		return 1;
+	return ret;
+}
+/*
+ * This will handle unlocking the eb if there is an error.
+ */
+static int submit_extent_buffer(int rw, struct extent_buffer *eb,
+				bio_end_io_t end_io_func, struct bio **bio_ret,
+				int mirror_num)
 {
-	struct extent_io_tree *tree;
-	tree = &BTRFS_I(mapping->host)->io_tree;
-	if (wbc->sync_mode == WB_SYNC_NONE) {
-		struct btrfs_root *root = BTRFS_I(mapping->host)->root;
-		u64 num_dirty;
-		unsigned long thresh = 32 * 1024 * 1024;
+	struct btrfs_root *root = eb->root;
+	struct bio *bio = NULL;
+	struct page *page;
+	u64 start = eb->start;
+	unsigned long num_pages;
+	unsigned long i;
+	size_t page_size = PAGE_CACHE_SIZE;
+	int submitted = 0;
+	int need_ref = 1;
+	int ret = 0;
+	int single_bio = (bio_ret) ? 0 : 1;
+
+	num_pages = num_extent_pages(eb->start, eb->len);
+	atomic_set(&eb->io_pages, (int)num_pages);
+	for (i = 0; i < num_pages; i++) {
+		int new = 0;
+
+		if (!bio && bio_ret && *bio_ret)
+			bio = *bio_ret;
+new_bio:
+		if (!bio) {
+			new = 1;
+			need_ref = 1;
+			bio = eb_setup_bio(eb, end_io_func, start, single_bio);
+			if (IS_ERR(bio)) {
+				ret = PTR_ERR(bio);
+				bio = NULL;
+				set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+
+				/*
+				 * Set submitted to 0 if we take away the last
+				 * of the io pages so the eb gets unlocked
+				 */
+				if (atomic_sub_and_test((int)(num_pages - i),
+							&eb->io_pages))
+					submitted = 0;
+				break;
+			}
+		}
 
-		if (wbc->for_kupdate)
-			return 0;
+		page = extent_buffer_page(eb, i);
+		if ((!new && merge_bio(root, page_size, bio)) ||
+		    bio_add_page(bio, page, page_size, 0) < page_size) {
+			ret = btree_submit_bio(root, rw, bio, mirror_num);
+			bio = NULL;
+			submitted++;
+			goto new_bio;
+		}
 
-		/* this is a bit racy, but that's ok */
-		num_dirty = root->fs_info->dirty_metadata_bytes;
-		if (num_dirty < thresh)
-			return 0;
+		/* We need a ref on the eb anytime it is added to a bio */
+		if (need_ref) {
+			extent_buffer_get(eb);
+			need_ref = 0;
+		}
+		start += page_size;
 	}
-	return btree_write_cache_pages(mapping, wbc);
+
+	if (bio_ret)
+		*bio_ret = bio;
+	else
+		ret = btree_submit_bio(root, rw, bio, mirror_num);
+
+	if (ret && !submitted) {
+		clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
+		extent_buffer_iounlock(eb);
+	}
+
+	return ret;
 }
 
-static int btree_readpage(struct file *file, struct page *page)
+int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
+			     int mirror_num)
 {
-	struct extent_io_tree *tree;
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	return extent_read_full_page(tree, page, btree_get_extent, 0);
+	int ret = 0;
+	int rw = (wait == WAIT_COMPLETE) ? READ_SYNC : READ;
+
+	if (extent_buffer_uptodate(eb))
+		return 0;
+
+	if (!extent_buffer_tryiolock(eb)) {
+		if (wait == WAIT_NONE)
+			return 0;
+		extent_buffer_iolock(eb);
+	}
+
+	if (extent_buffer_uptodate(eb)) {
+		extent_buffer_iounlock(eb);
+		goto out;
+	}
+
+	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	ret = submit_extent_buffer(rw, eb, eb_read_endio, NULL, mirror_num);
+	if (ret || wait != WAIT_COMPLETE)
+		return ret;
+
+	wait_on_extent_buffer(eb);
+	if (!extent_buffer_uptodate(eb))
+		ret = -EIO;
+out:
+	return ret;
 }
 
-static int btree_releasepage(struct page *page, gfp_t gfp_flags)
+/* Returns 1 if we can write this eb out, 0 if not */
+int write_iolock_eb(struct extent_buffer *eb, int wait)
 {
-	if (PageWriteback(page) || PageDirty(page))
-		return 0;
+	int ret = 0;
+
+	if (!extent_buffer_tryiolock(eb)) {
+		if (wait == WAIT_NONE)
+			return ret;
+		extent_buffer_iolock(eb);
+	}
+
+	/* We'd like to avoid taking the tree lock if at all possible */
+	if (!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
+		goto out;
+
+	btrfs_tree_lock(eb);
+
 	/*
-	 * We need to mask out eg. __GFP_HIGHMEM and __GFP_DMA32 as we're doing
-	 * slab allocation from alloc_extent_state down the callchain where
-	 * it'd hit a BUG_ON as those flags are not allowed.
+	 * We need this to make sure that if a buffer is written out in a
+	 * transaction and then we need to modify it in the same transaction
+	 * again we know that we need to re-cow it.
 	 */
-	gfp_flags &= ~GFP_SLAB_BUG_MASK;
+	if (clear_extent_buffer_dirty(eb)) {
+		struct btrfs_fs_info *fs_info = eb->root->fs_info;
+
+		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
+		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
+		spin_lock(&fs_info->delalloc_lock);
+		if (fs_info->dirty_metadata_bytes >= eb->len)
+			fs_info->dirty_metadata_bytes -= eb->len;
+		else
+			WARN_ON(1);
+		spin_unlock(&fs_info->delalloc_lock);
+		ret = 1;
+	}
+
+	btrfs_tree_unlock(eb);
+out:
+	if (!ret)
+		extent_buffer_iounlock(eb);
 
-	return try_release_extent_buffer(page, gfp_flags);
+	return ret;
 }
 
-static void btree_invalidatepage(struct page *page, unsigned long offset)
+int write_one_extent_buffer(struct extent_buffer *eb, int wait, int mirror_num)
 {
-	struct extent_io_tree *tree;
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	extent_invalidatepage(tree, page, offset);
-	btree_releasepage(page, GFP_NOFS);
-	if (PagePrivate(page)) {
-		printk(KERN_WARNING "btrfs warning page private not zero "
-		       "on page %llu\n", (unsigned long long)page_offset(page));
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		page_cache_release(page);
-	}
+	int rw = (wait == WAIT_COMPLETE) ? WRITE_SYNC : WRITE;
+	int ret = 0;
+
+	if (!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
+		return 0;
+
+	if (!write_iolock_eb(eb, wait))
+		return 0;
+
+	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	ret = submit_extent_buffer(rw, eb, eb_write_endio, NULL, mirror_num);
+
+	if (ret || wait != WAIT_COMPLETE)
+		return ret;
+
+	wait_on_extent_buffer(eb);
+	if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags))
+		ret = -EIO;
+
+	return ret;
 }
 
-static int btree_set_page_dirty(struct page *page)
+int write_extent_buffer_range(struct btrfs_root *root, u64 start,
+			      u64 end, int wait)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *eb;
+	struct bio *bio = NULL;
+	int rw = WRITE_SYNC;
+	int ret = 0;
+	int submit;
 
-	BUG_ON(!PagePrivate(page));
-	eb = (struct extent_buffer *)page->private;
-	BUG_ON(!eb);
-	BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-	BUG_ON(!atomic_read(&eb->refs));
-	btrfs_assert_tree_locked(eb);
-	return __set_page_dirty_nobuffers(page);
-}
-
-static const struct address_space_operations btree_aops = {
-	.readpage	= btree_readpage,
-	.writepages	= btree_writepages,
-	.releasepage	= btree_releasepage,
-	.invalidatepage = btree_invalidatepage,
-#ifdef CONFIG_MIGRATION
-	.migratepage	= btree_migratepage,
-#endif
-	.set_page_dirty = btree_set_page_dirty,
-};
+	while (start < end && !ret) {
+		submit = 0;
+
+		eb = find_extent_buffer_no_ref(fs_info, start);
+		if (!eb) {
+			start += PAGE_CACHE_SIZE;
+			if (bio) {
+				ret = btree_submit_bio(root, rw, bio, 0);
+				bio = NULL;
+			}
+			continue;
+		}
+
+		if (eb->root != eb->root->fs_info->extent_root)
+			set_bit(EXTENT_BUFFER_REFERENCED, &eb->bflags);
+		if (!write_iolock_eb(eb, wait)) {
+			submit = 1;
+			goto next;
+		}
+
+		clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+		ret = submit_extent_buffer(rw, eb, eb_write_endio, &bio, 0);
+next:
+		if (submit && bio) {
+			ret = btree_submit_bio(root, rw, bio, 0);
+			bio = NULL;
+		}
+		start = eb->start + eb->len;
+		free_extent_buffer(eb);
+		cond_resched();
+	}
+
+	if (bio)
+		ret = btree_submit_bio(root, rw, bio, 0);
+
+	return ret;
+}
 
 int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 u64 parent_transid)
 {
 	struct extent_buffer *buf = NULL;
-	struct inode *btree_inode = root->fs_info->btree_inode;
 	int ret = 0;
 
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!buf)
 		return 0;
-	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
-				 buf, 0, WAIT_NONE, btree_get_extent, 0);
+	read_extent_buffer_pages(buf, WAIT_NONE, 0);
 	free_extent_buffer(buf);
 	return ret;
 }
@@ -1022,8 +1181,6 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 int mirror_num, struct extent_buffer **eb)
 {
 	struct extent_buffer *buf = NULL;
-	struct inode *btree_inode = root->fs_info->btree_inode;
-	struct extent_io_tree *io_tree = &BTRFS_I(btree_inode)->io_tree;
 	int ret;
 
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
@@ -1032,8 +1189,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 
 	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
 
-	ret = read_extent_buffer_pages(io_tree, buf, 0, WAIT_PAGE_LOCK,
-				       btree_get_extent, mirror_num);
+	ret = read_extent_buffer_pages(buf, WAIT_PAGE_LOCK, mirror_num);
 	if (ret) {
 		free_extent_buffer(buf);
 		return ret;
@@ -1053,37 +1209,16 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize)
 {
-	struct inode *btree_inode = root->fs_info->btree_inode;
-	struct extent_buffer *eb;
-	eb = find_extent_buffer(&BTRFS_I(btree_inode)->io_tree,
-				bytenr, blocksize);
-	return eb;
+	return find_extent_buffer(root->fs_info, bytenr);
 }
 
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						 u64 bytenr, u32 blocksize)
 {
-	struct inode *btree_inode = root->fs_info->btree_inode;
-	struct extent_buffer *eb;
-
-	eb = alloc_extent_buffer(&BTRFS_I(btree_inode)->io_tree,
-				 bytenr, blocksize);
-	return eb;
+	return alloc_extent_buffer(root, bytenr, blocksize);
 }
 
 
-int btrfs_write_tree_block(struct extent_buffer *buf)
-{
-	return filemap_fdatawrite_range(buf->pages[0]->mapping, buf->start,
-					buf->start + buf->len - 1);
-}
-
-int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
-{
-	return filemap_fdatawait_range(buf->pages[0]->mapping,
-				       buf->start, buf->start + buf->len - 1);
-}
-
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid)
 {
@@ -1106,7 +1241,7 @@ void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	    root->fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
 
-		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
+		if (clear_extent_buffer_dirty(buf)) {
 			spin_lock(&root->fs_info->delalloc_lock);
 			if (root->fs_info->dirty_metadata_bytes >= buf->len)
 				root->fs_info->dirty_metadata_bytes -= buf->len;
@@ -1120,10 +1255,6 @@ void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			}
 			spin_unlock(&root->fs_info->delalloc_lock);
 		}
-
-		/* ugh, clear_extent_buffer_dirty needs to lock the page */
-		btrfs_set_lock_blocking(buf);
-		clear_extent_buffer_dirty(buf);
 	}
 }
 
@@ -1170,8 +1301,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->log_batch = 0;
 	root->log_transid = 0;
 	root->last_log_commit = 0;
-	extent_io_tree_init(&root->dirty_log_pages,
-			     fs_info->btree_inode->i_mapping);
+	extent_io_tree_init(&root->dirty_log_pages, NULL);
 
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
@@ -1983,15 +2113,8 @@ int open_ctree(struct super_block *sb,
 		goto fail_srcu;
 	}
 
-	fs_info->btree_inode = new_inode(sb);
-	if (!fs_info->btree_inode) {
-		err = -ENOMEM;
-		goto fail_bdi;
-	}
-
-	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
-
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
+	INIT_RADIX_TREE(&fs_info->eb_tree, GFP_ATOMIC);
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
 	INIT_LIST_HEAD(&fs_info->delayed_iputs);
@@ -1999,6 +2122,7 @@ int open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->delalloc_inodes);
 	INIT_LIST_HEAD(&fs_info->ordered_operations);
 	INIT_LIST_HEAD(&fs_info->caching_block_groups);
+	INIT_LIST_HEAD(&fs_info->eb_lru);
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->trans_lock);
 	spin_lock_init(&fs_info->ref_cache_lock);
@@ -2008,6 +2132,8 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->free_chunk_lock);
 	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
+	spin_lock_init(&fs_info->eb_tree_lock);
+	spin_lock_init(&fs_info->eb_lru_lock);
 	mutex_init(&fs_info->reloc_mutex);
 
 	init_completion(&fs_info->kobj_unregister);
@@ -2027,6 +2153,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->nr_async_bios, 0);
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->tree_mod_seq, 0);
+	atomic_set(&fs_info->dirty_ebs, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
 	fs_info->metadata_ratio = 0;
@@ -2034,6 +2161,11 @@ int open_ctree(struct super_block *sb,
 	fs_info->trans_no_join = 0;
 	fs_info->free_chunk_space = 0;
 	fs_info->tree_mod_log = RB_ROOT;
+	fs_info->eb_lru_nr = 0;
+	fs_info->eb_shrinker.seeks = 1;
+	fs_info->eb_shrinker.shrink = shrink_ebs;
+	fs_info->eb_writeback_work.flags = 0;
+	fs_info->writeback_index = 0;
 
 	init_waitqueue_head(&fs_info->tree_mod_seq_wait);
 
@@ -2078,39 +2210,11 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(4096);
 	sb->s_bdi = &fs_info->bdi;
 
-	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
-	set_nlink(fs_info->btree_inode, 1);
-	/*
-	 * we set the i_size on the btree inode to the max possible int.
-	 * the real end of the address space is determined by all of
-	 * the devices in the system
-	 */
-	fs_info->btree_inode->i_size = OFFSET_MAX;
-	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
-	fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
-
-	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
-	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
-			     fs_info->btree_inode->i_mapping);
-	BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
-	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
-
-	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
-
-	BTRFS_I(fs_info->btree_inode)->root = tree_root;
-	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
-	       sizeof(struct btrfs_key));
-	set_bit(BTRFS_INODE_DUMMY,
-		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
-	insert_inode_hash(fs_info->btree_inode);
-
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree = RB_ROOT;
 
-	extent_io_tree_init(&fs_info->freed_extents[0],
-			     fs_info->btree_inode->i_mapping);
-	extent_io_tree_init(&fs_info->freed_extents[1],
-			     fs_info->btree_inode->i_mapping);
+	extent_io_tree_init(&fs_info->freed_extents[0], NULL);
+	extent_io_tree_init(&fs_info->freed_extents[1], NULL);
 	fs_info->pinned_extents = &fs_info->freed_extents[0];
 	fs_info->do_barriers = 1;
 
@@ -2121,6 +2225,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->volume_mutex);
+	mutex_init(&fs_info->metadata_flusher_mutex);
 	init_rwsem(&fs_info->extent_commit_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
@@ -2314,6 +2419,10 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
+	btrfs_init_workers(&fs_info->eb_writeback_worker, "meta-writeback",
+			   1, &fs_info->generic_worker);
+
+	fs_info->eb_writeback_worker.idle_thresh = 2;
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -2326,6 +2435,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->endio_meta_write_workers.idle_thresh = 2;
 	fs_info->readahead_workers.idle_thresh = 2;
 
+	register_shrinker(&fs_info->eb_shrinker);
+
 	/*
 	 * btrfs_start_workers can really only fail because of ENOMEM so just
 	 * return -ENOMEM if any of these fail.
@@ -2343,6 +2454,7 @@ int open_ctree(struct super_block *sb,
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
+	ret |= btrfs_start_workers(&fs_info->eb_writeback_worker);
 	if (ret) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
@@ -2632,13 +2744,6 @@ fail_trans_kthread:
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
-	/*
-	 * make sure we're done with the btree inode before we stop our
-	 * kthreads
-	 */
-	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
-
 fail_block_groups:
 	btrfs_free_block_groups(fs_info);
 
@@ -2646,6 +2751,7 @@ fail_tree_roots:
 	free_root_pointers(fs_info, 1);
 
 fail_sb_buffer:
+	unregister_shrinker(&fs_info->eb_shrinker);
 	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_stop_workers(&fs_info->readahead_workers);
 	btrfs_stop_workers(&fs_info->fixup_workers);
@@ -2659,13 +2765,11 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
+	btrfs_stop_workers(&fs_info->eb_writeback_worker);
 fail_alloc:
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
-	iput(fs_info->btree_inode);
-fail_bdi:
 	bdi_destroy(&fs_info->bdi);
 fail_srcu:
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
@@ -3255,8 +3359,6 @@ int close_ctree(struct btrfs_root *root)
 
 	del_fs_roots(fs_info);
 
-	iput(fs_info->btree_inode);
-
 	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
@@ -3270,6 +3372,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
+	btrfs_stop_workers(&fs_info->eb_writeback_worker);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
@@ -3278,6 +3381,8 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+	unregister_shrinker(&fs_info->eb_shrinker);
+	btrfs_destroy_eb_cache(fs_info);
 
 	bdi_destroy(&fs_info->bdi);
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
@@ -3289,141 +3394,51 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic)
 {
 	int ret;
-	struct inode *btree_inode = buf->pages[0]->mapping->host;
 
 	ret = extent_buffer_uptodate(buf);
 	if (!ret)
 		return ret;
 
-	ret = verify_parent_transid(&BTRFS_I(btree_inode)->io_tree, buf,
-				    parent_transid, atomic);
-	if (ret == -EAGAIN)
-		return ret;
+	ret = verify_parent_transid(buf, parent_transid, atomic);
 	return !ret;
 }
 
-int btrfs_set_buffer_uptodate(struct extent_buffer *buf)
-{
-	return set_extent_buffer_uptodate(buf);
-}
-
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 {
-	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
+	struct btrfs_fs_info *fs_info = buf->root->fs_info;
 	u64 transid = btrfs_header_generation(buf);
 	int was_dirty;
 
 	btrfs_assert_tree_locked(buf);
-	if (transid != root->fs_info->generation) {
+	if (transid != fs_info->generation) {
 		printk(KERN_CRIT "btrfs transid mismatch buffer %llu, "
 		       "found %llu running %llu\n",
 			(unsigned long long)buf->start,
 			(unsigned long long)transid,
-			(unsigned long long)root->fs_info->generation);
+			(unsigned long long)fs_info->generation);
 		WARN_ON(1);
 	}
 	was_dirty = set_extent_buffer_dirty(buf);
 	if (!was_dirty) {
-		spin_lock(&root->fs_info->delalloc_lock);
-		root->fs_info->dirty_metadata_bytes += buf->len;
-		spin_unlock(&root->fs_info->delalloc_lock);
+		spin_lock(&fs_info->delalloc_lock);
+		fs_info->dirty_metadata_bytes += buf->len;
+		spin_unlock(&fs_info->delalloc_lock);
 	}
 }
 
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 {
-	/*
-	 * looks as though older kernels can get into trouble with
-	 * this code, they end up stuck in balance_dirty_pages forever
-	 */
-	u64 num_dirty;
-	unsigned long thresh = 32 * 1024 * 1024;
-
 	if (current->flags & PF_MEMALLOC)
 		return;
 
 	btrfs_balance_delayed_items(root);
-
-	num_dirty = root->fs_info->dirty_metadata_bytes;
-
-	if (num_dirty > thresh) {
-		balance_dirty_pages_ratelimited_nr(
-				   root->fs_info->btree_inode->i_mapping, 1);
-	}
-	return;
-}
-
-void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
-{
-	/*
-	 * looks as though older kernels can get into trouble with
-	 * this code, they end up stuck in balance_dirty_pages forever
-	 */
-	u64 num_dirty;
-	unsigned long thresh = 32 * 1024 * 1024;
-
-	if (current->flags & PF_MEMALLOC)
-		return;
-
-	num_dirty = root->fs_info->dirty_metadata_bytes;
-
-	if (num_dirty > thresh) {
-		balance_dirty_pages_ratelimited_nr(
-				   root->fs_info->btree_inode->i_mapping, 1);
-	}
-	return;
 }
 
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 {
-	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
-	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
-}
-
-int btree_lock_page_hook(struct page *page, void *data,
-				void (*flush_fn)(void *))
-{
-	struct inode *inode = page->mapping->host;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_buffer *eb;
+	struct btrfs_root *root = buf->root;
 
-	/*
-	 * We culled this eb but the page is still hanging out on the mapping,
-	 * carry on.
-	 */
-	if (!PagePrivate(page))
-		goto out;
-
-	eb = (struct extent_buffer *)page->private;
-	if (!eb) {
-		WARN_ON(1);
-		goto out;
-	}
-	if (page != eb->pages[0])
-		goto out;
-
-	if (!btrfs_try_tree_write_lock(eb)) {
-		flush_fn(data);
-		btrfs_tree_lock(eb);
-	}
-	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-
-	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
-		spin_lock(&root->fs_info->delalloc_lock);
-		if (root->fs_info->dirty_metadata_bytes >= eb->len)
-			root->fs_info->dirty_metadata_bytes -= eb->len;
-		else
-			WARN_ON(1);
-		spin_unlock(&root->fs_info->delalloc_lock);
-	}
-
-	btrfs_tree_unlock(eb);
-out:
-	if (!trylock_page(page)) {
-		flush_fn(data);
-		lock_page(page);
-	}
-	return 0;
+	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
@@ -3629,13 +3644,9 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					int mark)
 {
 	int ret;
-	struct page *page;
-	struct inode *btree_inode = root->fs_info->btree_inode;
 	struct extent_buffer *eb;
 	u64 start = 0;
 	u64 end;
-	u64 offset;
-	unsigned long index;
 
 	while (1) {
 		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
@@ -3645,36 +3656,14 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 
 		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
 		while (start <= end) {
-			index = start >> PAGE_CACHE_SHIFT;
-			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
-			page = find_get_page(btree_inode->i_mapping, index);
-			if (!page)
+			eb = find_extent_buffer_no_ref(root->fs_info, start);
+			if (!eb) {
+				start += 1 << PAGE_CACHE_SHIFT;
 				continue;
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
 			}
-
-			unlock_page(page);
-			page_cache_release(page);
+			clear_extent_buffer_dirty(eb);
+			wait_on_extent_buffer(eb);
+			free_extent_buffer(eb);
 		}
 	}
 
@@ -3826,12 +3815,3 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 	return 0;
 }
-
-static struct extent_io_ops btree_extent_io_ops = {
-	.write_cache_pages_lock_hook = btree_lock_page_hook,
-	.readpage_end_io_hook = btree_readpage_end_io_hook,
-	.readpage_io_failed_hook = btree_io_failed_hook,
-	.submit_bio_hook = btree_submit_bio_hook,
-	/* note we're sharing with inode.c for the merge bio hook */
-	.merge_bio_hook = btrfs_merge_bio_hook,
-};
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 95e147e..c430ae6 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -63,12 +63,10 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location);
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
-void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
 void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
-int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
@@ -80,8 +78,6 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 			extent_submit_bio_hook_t *submit_bio_start,
 			extent_submit_bio_hook_t *submit_bio_done);
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
-int btrfs_write_tree_block(struct extent_buffer *buf);
-int btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 45c69c4..cbfcedc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6271,7 +6271,7 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
 
 	btrfs_set_lock_blocking(buf);
-	btrfs_set_buffer_uptodate(buf);
+	set_extent_buffer_uptodate(buf);
 
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
 		/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 45c81bb..6cbd8b0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -12,6 +12,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/ratelimit.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "compat.h"
@@ -21,6 +22,7 @@
 #include "check-integrity.h"
 #include "locking.h"
 #include "rcu-string.h"
+#include "transaction.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -35,6 +37,9 @@ static DEFINE_SPINLOCK(leak_lock);
 
 #define BUFFER_LRU_MAX 64
 
+static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head);
+static int release_extent_buffer(struct extent_buffer *eb);
+
 struct tree_entry {
 	u64 start;
 	u64 end;
@@ -69,7 +74,6 @@ int __init extent_io_init(void)
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_state_cache)
 		return -ENOMEM;
-
 	extent_buffer_cache = kmem_cache_create("extent_buffers",
 			sizeof(struct extent_buffer), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
@@ -3035,284 +3039,6 @@ done_unlocked:
 	return 0;
 }
 
-static int eb_wait(void *word)
-{
-	io_schedule();
-	return 0;
-}
-
-static void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
-{
-	wait_on_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK, eb_wait,
-		    TASK_UNINTERRUPTIBLE);
-}
-
-static int lock_extent_buffer_for_io(struct extent_buffer *eb,
-				     struct btrfs_fs_info *fs_info,
-				     struct extent_page_data *epd)
-{
-	unsigned long i, num_pages;
-	int flush = 0;
-	int ret = 0;
-
-	if (!btrfs_try_tree_write_lock(eb)) {
-		flush = 1;
-		flush_write_bio(epd);
-		btrfs_tree_lock(eb);
-	}
-
-	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
-		btrfs_tree_unlock(eb);
-		if (!epd->sync_io)
-			return 0;
-		if (!flush) {
-			flush_write_bio(epd);
-			flush = 1;
-		}
-		while (1) {
-			wait_on_extent_buffer_writeback(eb);
-			btrfs_tree_lock(eb);
-			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
-				break;
-			btrfs_tree_unlock(eb);
-		}
-	}
-
-	/*
-	 * We need to do this to prevent races in people who check if the eb is
-	 * under IO since we can end up having no IO bits set for a short period
-	 * of time.
-	 */
-	spin_lock(&eb->refs_lock);
-	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
-		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
-		spin_unlock(&eb->refs_lock);
-		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-		spin_lock(&fs_info->delalloc_lock);
-		if (fs_info->dirty_metadata_bytes >= eb->len)
-			fs_info->dirty_metadata_bytes -= eb->len;
-		else
-			WARN_ON(1);
-		spin_unlock(&fs_info->delalloc_lock);
-		ret = 1;
-	} else {
-		spin_unlock(&eb->refs_lock);
-	}
-
-	btrfs_tree_unlock(eb);
-
-	if (!ret)
-		return ret;
-
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		struct page *p = extent_buffer_page(eb, i);
-
-		if (!trylock_page(p)) {
-			if (!flush) {
-				flush_write_bio(epd);
-				flush = 1;
-			}
-			lock_page(p);
-		}
-	}
-
-	return ret;
-}
-
-static void end_extent_buffer_writeback(struct extent_buffer *eb)
-{
-	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
-}
-
-static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
-{
-	int uptodate = err == 0;
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_buffer *eb;
-	int done;
-
-	do {
-		struct page *page = bvec->bv_page;
-
-		bvec--;
-		eb = (struct extent_buffer *)page->private;
-		BUG_ON(!eb);
-		done = atomic_dec_and_test(&eb->io_pages);
-
-		if (!uptodate || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
-			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-			ClearPageUptodate(page);
-			SetPageError(page);
-		}
-
-		end_page_writeback(page);
-
-		if (!done)
-			continue;
-
-		end_extent_buffer_writeback(eb);
-	} while (bvec >= bio->bi_io_vec);
-
-	bio_put(bio);
-
-}
-
-static int write_one_eb(struct extent_buffer *eb,
-			struct btrfs_fs_info *fs_info,
-			struct writeback_control *wbc,
-			struct extent_page_data *epd)
-{
-	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
-	u64 offset = eb->start;
-	unsigned long i, num_pages;
-	int rw = (epd->sync_io ? WRITE_SYNC : WRITE);
-	int ret = 0;
-
-	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
-	atomic_set(&eb->io_pages, num_pages);
-	for (i = 0; i < num_pages; i++) {
-		struct page *p = extent_buffer_page(eb, i);
-
-		clear_page_dirty_for_io(p);
-		set_page_writeback(p);
-		ret = submit_extent_page(rw, eb->tree, p, offset >> 9,
-					 PAGE_CACHE_SIZE, 0, bdev, &epd->bio,
-					 -1, end_bio_extent_buffer_writepage,
-					 0, 0, 0);
-		if (ret) {
-			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-			SetPageError(p);
-			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
-				end_extent_buffer_writeback(eb);
-			ret = -EIO;
-			break;
-		}
-		offset += PAGE_CACHE_SIZE;
-		update_nr_written(p, wbc, 1);
-		unlock_page(p);
-	}
-
-	if (unlikely(ret)) {
-		for (; i < num_pages; i++) {
-			struct page *p = extent_buffer_page(eb, i);
-			unlock_page(p);
-		}
-	}
-
-	return ret;
-}
-
-int btree_write_cache_pages(struct address_space *mapping,
-				   struct writeback_control *wbc)
-{
-	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
-	struct btrfs_fs_info *fs_info = BTRFS_I(mapping->host)->root->fs_info;
-	struct extent_buffer *eb, *prev_eb = NULL;
-	struct extent_page_data epd = {
-		.bio = NULL,
-		.tree = tree,
-		.extent_locked = 0,
-		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
-	};
-	int ret = 0;
-	int done = 0;
-	int nr_to_write_done = 0;
-	struct pagevec pvec;
-	int nr_pages;
-	pgoff_t index;
-	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
-	int tag;
-
-	pagevec_init(&pvec, 0);
-	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
-	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		scanned = 1;
-	}
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		tag = PAGECACHE_TAG_TOWRITE;
-	else
-		tag = PAGECACHE_TAG_DIRTY;
-retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		tag_pages_for_writeback(mapping, index, end);
-	while (!done && !nr_to_write_done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
-
-		scanned = 1;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-
-			if (!PagePrivate(page))
-				continue;
-
-			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
-				break;
-			}
-
-			eb = (struct extent_buffer *)page->private;
-			if (!eb) {
-				WARN_ON(1);
-				continue;
-			}
-
-			if (eb == prev_eb)
-				continue;
-
-			if (!atomic_inc_not_zero(&eb->refs)) {
-				WARN_ON(1);
-				continue;
-			}
-
-			prev_eb = eb;
-			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
-			if (!ret) {
-				free_extent_buffer(eb);
-				continue;
-			}
-
-			ret = write_one_eb(eb, fs_info, wbc, &epd);
-			if (ret) {
-				done = 1;
-				free_extent_buffer(eb);
-				break;
-			}
-			free_extent_buffer(eb);
-
-			/*
-			 * the filesystem may choose to bump up nr_to_write.
-			 * We have to make sure to honor the new nr_to_write
-			 * at any time
-			 */
-			nr_to_write_done = wbc->nr_to_write <= 0;
-		}
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
-	flush_write_bio(&epd);
-	return ret;
-}
-
 /**
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
@@ -3952,7 +3678,7 @@ static void __free_extent_buffer(struct extent_buffer *eb)
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
-static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
+static struct extent_buffer *__alloc_extent_buffer(struct btrfs_root *root,
 						   u64 start,
 						   unsigned long len,
 						   gfp_t mask)
@@ -3967,7 +3693,6 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		return NULL;
 	eb->start = start;
 	eb->len = len;
-	eb->tree = tree;
 	eb->bflags = 0;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
@@ -3977,6 +3702,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	atomic_set(&eb->spinning_readers, 0);
 	atomic_set(&eb->spinning_writers, 0);
 	eb->lock_nested = 0;
+	eb->root = root;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
 
@@ -3986,8 +3712,9 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	spin_unlock_irqrestore(&leak_lock, flags);
 #endif
 	spin_lock_init(&eb->refs_lock);
-	atomic_set(&eb->refs, 1);
+	atomic_set(&eb->refs, 2);
 	atomic_set(&eb->io_pages, 0);
+	INIT_LIST_HEAD(&eb->lru);
 
 	if (len > MAX_INLINE_EXTENT_BUFFER_SIZE) {
 		struct page **pages;
@@ -4088,36 +3815,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 	do {
 		index--;
 		page = extent_buffer_page(eb, index);
-		if (page && mapped) {
-			spin_lock(&page->mapping->private_lock);
-			/*
-			 * We do this since we'll remove the pages after we've
-			 * removed the eb from the radix tree, so we could race
-			 * and have this page now attached to the new eb.  So
-			 * only clear page_private if it's still connected to
-			 * this eb.
-			 */
-			if (PagePrivate(page) &&
-			    page->private == (unsigned long)eb) {
-				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-				BUG_ON(PageDirty(page));
-				BUG_ON(PageWriteback(page));
-				/*
-				 * We need to make sure we haven't be attached
-				 * to a new eb.
-				 */
-				ClearPagePrivate(page);
-				set_page_private(page, 0);
-				/* One for the page private */
-				page_cache_release(page);
-			}
-			spin_unlock(&page->mapping->private_lock);
-
-		}
-		if (page) {
-			/* One for when we alloced the page */
-			page_cache_release(page);
-		}
+		if (page && mapped)
+			__free_page(page);
 	} while (index != start_idx);
 }
 
@@ -4130,186 +3829,102 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 	__free_extent_buffer(eb);
 }
 
-static void check_buffer_tree_ref(struct extent_buffer *eb)
-{
-	/* the ref bit is tricky.  We have to make sure it is set
-	 * if we have the buffer dirty.   Otherwise the
-	 * code to free a buffer can end up dropping a dirty
-	 * page
-	 *
-	 * Once the ref bit is set, it won't go away while the
-	 * buffer is dirty or in writeback, and it also won't
-	 * go away while we have the reference count on the
-	 * eb bumped.
-	 *
-	 * We can't just set the ref bit without bumping the
-	 * ref on the eb because free_extent_buffer might
-	 * see the ref bit and try to clear it.  If this happens
-	 * free_extent_buffer might end up dropping our original
-	 * ref by mistake and freeing the page before we are able
-	 * to add one more ref.
-	 *
-	 * So bump the ref count first, then set the bit.  If someone
-	 * beat us to it, drop the ref we added.
-	 */
-	spin_lock(&eb->refs_lock);
-	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_inc(&eb->refs);
-	spin_unlock(&eb->refs_lock);
-}
-
-static void mark_extent_buffer_accessed(struct extent_buffer *eb)
-{
-	unsigned long num_pages, i;
-
-	check_buffer_tree_ref(eb);
-
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		struct page *p = extent_buffer_page(eb, i);
-		mark_page_accessed(p);
-	}
-}
-
-struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
+struct extent_buffer *alloc_extent_buffer(struct btrfs_root *root,
 					  u64 start, unsigned long len)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
 	unsigned long index = start >> PAGE_CACHE_SHIFT;
 	struct extent_buffer *eb;
 	struct extent_buffer *exists = NULL;
 	struct page *p;
-	struct address_space *mapping = tree->mapping;
-	int uptodate = 1;
 	int ret;
 
 	rcu_read_lock();
-	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	eb = radix_tree_lookup(&fs_info->eb_tree, start >> PAGE_CACHE_SHIFT);
 	if (eb && atomic_inc_not_zero(&eb->refs)) {
+		/*
+		 * This can happen if we free the extent and reallocate
+		 * it for a different root before the eb is evicted
+		 * from the cache.
+		 */
+		if (unlikely(eb->root != root))
+			eb->root = root;
+		set_bit(EXTENT_BUFFER_REFERENCED, &eb->bflags);
 		rcu_read_unlock();
-		mark_extent_buffer_accessed(eb);
 		return eb;
 	}
 	rcu_read_unlock();
 
-	eb = __alloc_extent_buffer(tree, start, len, GFP_NOFS);
+	eb = __alloc_extent_buffer(root, start, len, GFP_NOFS);
 	if (!eb)
 		return NULL;
 
+	set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags);
 	for (i = 0; i < num_pages; i++, index++) {
-		p = find_or_create_page(mapping, index, GFP_NOFS);
+		p = alloc_page(GFP_NOFS);
 		if (!p) {
 			WARN_ON(1);
 			goto free_eb;
 		}
-
-		spin_lock(&mapping->private_lock);
-		if (PagePrivate(p)) {
-			/*
-			 * We could have already allocated an eb for this page
-			 * and attached one so lets see if we can get a ref on
-			 * the existing eb, and if we can we know it's good and
-			 * we can just return that one, else we know we can just
-			 * overwrite page->private.
-			 */
-			exists = (struct extent_buffer *)p->private;
-			if (atomic_inc_not_zero(&exists->refs)) {
-				spin_unlock(&mapping->private_lock);
-				unlock_page(p);
-				page_cache_release(p);
-				mark_extent_buffer_accessed(exists);
-				goto free_eb;
-			}
-
-			/*
-			 * Do this so attach doesn't complain and we need to
-			 * drop the ref the old guy had.
-			 */
-			ClearPagePrivate(p);
-			WARN_ON(PageDirty(p));
-			page_cache_release(p);
-		}
-		attach_extent_buffer_page(eb, p);
-		spin_unlock(&mapping->private_lock);
-		WARN_ON(PageDirty(p));
-		mark_page_accessed(p);
+		set_page_private(p, (unsigned long)eb);
+		p->index = index;
 		eb->pages[i] = p;
-		if (!PageUptodate(p))
-			uptodate = 0;
-
-		/*
-		 * see below about how we avoid a nasty race with release page
-		 * and why we unlock later
-		 */
 	}
-	if (uptodate)
-		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-again:
+
 	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
 	if (ret)
 		goto free_eb;
 
-	spin_lock(&tree->buffer_lock);
-	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
+again:
+	spin_lock(&fs_info->eb_tree_lock);
+	ret = radix_tree_insert(&fs_info->eb_tree,
+				start >> PAGE_CACHE_SHIFT, eb);
 	if (ret == -EEXIST) {
-		exists = radix_tree_lookup(&tree->buffer,
+		exists = radix_tree_lookup(&fs_info->eb_tree,
 						start >> PAGE_CACHE_SHIFT);
+		/* add one reference for the caller */
 		if (!atomic_inc_not_zero(&exists->refs)) {
-			spin_unlock(&tree->buffer_lock);
+			spin_unlock(&fs_info->eb_tree_lock);
 			radix_tree_preload_end();
-			exists = NULL;
+
+			/*
+			 * We free eb's via rcu, so we need to synchronize the
+			 * rcu here to make sure we don't loop back around and
+			 * find the same thing again over and over.
+			 */
+			synchronize_rcu();
 			goto again;
 		}
-		spin_unlock(&tree->buffer_lock);
+		spin_unlock(&fs_info->eb_tree_lock);
 		radix_tree_preload_end();
-		mark_extent_buffer_accessed(exists);
+		set_bit(EXTENT_BUFFER_REFERENCED, &exists->bflags);
 		goto free_eb;
 	}
-	/* add one reference for the tree */
-	check_buffer_tree_ref(eb);
-	spin_unlock(&tree->buffer_lock);
+
+	spin_unlock(&fs_info->eb_tree_lock);
 	radix_tree_preload_end();
+	set_bit(EXTENT_BUFFER_REFERENCED, &eb->bflags);
 
-	/*
-	 * there is a race where release page may have
-	 * tried to find this extent buffer in the radix
-	 * but failed.  It will tell the VM it is safe to
-	 * reclaim the, and it will clear the page private bit.
-	 * We must make sure to set the page private bit properly
-	 * after the extent buffer is in the radix tree so
-	 * it doesn't get lost
-	 */
-	SetPageChecked(eb->pages[0]);
-	for (i = 1; i < num_pages; i++) {
-		p = extent_buffer_page(eb, i);
-		ClearPageChecked(p);
-		unlock_page(p);
-	}
-	unlock_page(eb->pages[0]);
 	return eb;
 
 free_eb:
-	for (i = 0; i < num_pages; i++) {
-		if (eb->pages[i])
-			unlock_page(eb->pages[i]);
-	}
-
-	WARN_ON(!atomic_dec_and_test(&eb->refs));
 	btrfs_release_extent_buffer(eb);
 	return exists;
 }
 
-struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-					 u64 start, unsigned long len)
+static struct extent_buffer *
+__find_extent_buffer(struct btrfs_fs_info *fs_info, u64 start, int ref)
 {
 	struct extent_buffer *eb;
 
 	rcu_read_lock();
-	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	eb = radix_tree_lookup(&fs_info->eb_tree, start >> PAGE_CACHE_SHIFT);
 	if (eb && atomic_inc_not_zero(&eb->refs)) {
+		if (ref)
+			set_bit(EXTENT_BUFFER_REFERENCED, &eb->bflags);
 		rcu_read_unlock();
-		mark_extent_buffer_accessed(eb);
 		return eb;
 	}
 	rcu_read_unlock();
@@ -4317,35 +3932,63 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 	return NULL;
 }
 
+struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
+					 u64 start)
+{
+	return __find_extent_buffer(fs_info, start, 1);
+}
+
+struct extent_buffer *find_extent_buffer_no_ref(struct btrfs_fs_info *fs_info,
+						u64 start)
+{
+	return __find_extent_buffer(fs_info, start, 0);
+}
+
 static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 {
 	struct extent_buffer *eb =
 			container_of(head, struct extent_buffer, rcu_head);
 
-	__free_extent_buffer(eb);
+	btrfs_release_extent_buffer(eb);
 }
 
-/* Expects to have eb->eb_lock already held */
-static int release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
+static void add_lru(struct extent_buffer *eb)
 {
-	WARN_ON(atomic_read(&eb->refs) == 0);
-	if (atomic_dec_and_test(&eb->refs)) {
-		if (test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags)) {
-			spin_unlock(&eb->refs_lock);
-		} else {
-			struct extent_io_tree *tree = eb->tree;
+	struct btrfs_fs_info *fs_info = eb->root->fs_info;
+
+	spin_lock(&fs_info->eb_lru_lock);
+	if (list_empty(&eb->lru)) {
+		fs_info->eb_lru_nr++;
+		list_add_tail(&eb->lru, &fs_info->eb_lru);
+	}
+	spin_unlock(&fs_info->eb_lru_lock);
+}
 
-			spin_unlock(&eb->refs_lock);
+static void del_lru(struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = eb->root->fs_info;
 
-			spin_lock(&tree->buffer_lock);
-			radix_tree_delete(&tree->buffer,
-					  eb->start >> PAGE_CACHE_SHIFT);
-			spin_unlock(&tree->buffer_lock);
-		}
+	spin_lock(&fs_info->eb_lru_lock);
+	if (!list_empty(&eb->lru)) {
+		list_del_init(&eb->lru);
+		fs_info->eb_lru_nr--;
+	}
+	spin_unlock(&fs_info->eb_lru_lock);
+}
+
+static int release_extent_buffer(struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = eb->root->fs_info;
 
-		/* Should be safe to release our pages at this point */
-		btrfs_release_extent_buffer_page(eb, 0);
+	if (atomic_dec_and_test(&eb->refs)) {
+		del_lru(eb);
+		BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+		spin_unlock(&eb->refs_lock);
 
+		spin_lock(&fs_info->eb_tree_lock);
+		radix_tree_delete(&fs_info->eb_tree,
+				  eb->start >> PAGE_CACHE_SHIFT);
+		spin_unlock(&fs_info->eb_tree_lock);
 		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
 		return 1;
 	}
@@ -4361,124 +4004,253 @@ void free_extent_buffer(struct extent_buffer *eb)
 
 	spin_lock(&eb->refs_lock);
 	if (atomic_read(&eb->refs) == 2 &&
-	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
-		atomic_dec(&eb->refs);
-
-	if (atomic_read(&eb->refs) == 2 &&
-	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
-	    !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
-		atomic_dec(&eb->refs);
+	    !extent_buffer_under_io(eb)) {
+		if (test_and_clear_bit(EXTENT_BUFFER_STALE, &eb->bflags))
+			atomic_dec(&eb->refs);
+		else
+			add_lru(eb);
+	}
 
-	/*
-	 * I know this is terrible, but it's temporary until we stop tracking
-	 * the uptodate bits and such for the extent buffers.
-	 */
-	release_extent_buffer(eb, GFP_ATOMIC);
+	release_extent_buffer(eb);
 }
 
 void free_extent_buffer_stale(struct extent_buffer *eb)
 {
+	struct btrfs_fs_info *fs_info;
+
 	if (!eb)
 		return;
 
+	fs_info = eb->root->fs_info;
 	spin_lock(&eb->refs_lock);
-	set_bit(EXTENT_BUFFER_STALE, &eb->bflags);
-
-	if (atomic_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
-	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
+	if (test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
 		atomic_dec(&eb->refs);
-	release_extent_buffer(eb, GFP_NOFS);
+	release_extent_buffer(eb);
 }
 
-void clear_extent_buffer_dirty(struct extent_buffer *eb)
+static void flush_dirty_ebs_nr(struct btrfs_fs_info *fs_info, int nr)
 {
-	unsigned long i;
-	unsigned long num_pages;
-	struct page *page;
+	struct btrfs_transaction *cur_trans;
+	struct extent_buffer *eb;
+	struct extent_io_tree *dirty_pages;
+	u64 start = fs_info->writeback_index, end = 0;
+	u64 write_batch = nr * (u64)fs_info->extent_root->leafsize;
+	u64 wait_start = 0, wait_end = 0;
+	int err;
+	int looped = 1;
 
-	num_pages = num_extent_pages(eb->start, eb->len);
+	spin_lock(&fs_info->trans_lock);
+	cur_trans = fs_info->running_transaction;
+	if (!cur_trans || cur_trans->blocked) {
+		spin_unlock(&fs_info->trans_lock);
+		btrfs_wait_current_trans(fs_info);
+		return;
+	}
+	atomic_inc(&cur_trans->use_count);
+	spin_unlock(&fs_info->trans_lock);
 
-	for (i = 0; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
-		if (!PageDirty(page))
-			continue;
+	dirty_pages = &cur_trans->dirty_pages;
+again:
+	mutex_lock(&cur_trans->dirty_pages_mutex);
+	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
+				      EXTENT_DIRTY)) {
+		if (!wait_start)
+			wait_start = start;
+
+		end = min(start + write_batch - 1, end);
+		convert_extent_bit(dirty_pages, start, end, EXTENT_NEED_WAIT,
+				   EXTENT_DIRTY, GFP_NOFS);
+		mutex_unlock(&cur_trans->dirty_pages_mutex);
+		err = write_extent_buffer_range(fs_info->extent_root,
+						start, end,
+						WAIT_PAGE_LOCK);
+		mutex_lock(&cur_trans->dirty_pages_mutex);
+		if (err)
+			break;
+		if (end - start + 1 > write_batch)
+			break;
+		write_batch -= (end - start + 1);
+	}
+	mutex_unlock(&cur_trans->dirty_pages_mutex);
 
-		lock_page(page);
-		WARN_ON(!PagePrivate(page));
+	if (write_batch && !looped) {
+		if (end)
+			wait_end = end;
+		start = 0;
+		wait_start = 0;
+		looped = 1;
+		goto again;
+	}
 
-		clear_page_dirty_for_io(page);
-		spin_lock_irq(&page->mapping->tree_lock);
-		if (!PageDirty(page)) {
-			radix_tree_tag_clear(&page->mapping->page_tree,
-						page_index(page),
-						PAGECACHE_TAG_DIRTY);
+	start = wait_start;
+	if (!wait_end)
+		wait_end = end;
+	mutex_lock(&cur_trans->dirty_pages_mutex);
+	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
+				      EXTENT_NEED_WAIT)) {
+		clear_extent_bits(dirty_pages, start, end, EXTENT_NEED_WAIT,
+				  GFP_NOFS);
+		mutex_unlock(&cur_trans->dirty_pages_mutex);
+		while (start < end && start < wait_end) {
+			eb = find_extent_buffer_no_ref(fs_info, start);
+			if (!eb) {
+				start += PAGE_CACHE_SIZE;
+				continue;
+			}
+			wait_on_extent_buffer(eb);
+			start = eb->start + eb->len;
+			free_extent_buffer(eb);
+			cond_resched();
 		}
-		spin_unlock_irq(&page->mapping->tree_lock);
-		ClearPageError(page);
-		unlock_page(page);
+		mutex_lock(&cur_trans->dirty_pages_mutex);
+		if (start >= wait_end)
+			break;
 	}
-	WARN_ON(atomic_read(&eb->refs) == 0);
+	mutex_unlock(&cur_trans->dirty_pages_mutex);
+
+	fs_info->writeback_index = wait_end + 1;
+	put_transaction(cur_trans);
 }
 
-int set_extent_buffer_dirty(struct extent_buffer *eb)
+static void flush_dirty_ebs(struct btrfs_work *work)
 {
-	unsigned long i;
-	unsigned long num_pages;
-	int was_dirty = 0;
+	struct btrfs_fs_info *fs_info = container_of(work,
+						     struct btrfs_fs_info,
+						     eb_writeback_work);
+	flush_dirty_ebs_nr(fs_info, 256);
+}
+
+int shrink_ebs(struct shrinker *shrinker, struct shrink_control *sc)
+{
+	struct btrfs_fs_info *fs_info = container_of(shrinker,
+						     struct btrfs_fs_info,
+						     eb_shrinker);
+	struct extent_buffer *eb;
+	int nr_to_scan = sc->nr_to_scan;
+	int do_io = 0;
+	int kick_io = 1;
 
-	check_buffer_tree_ref(eb);
+	if (!nr_to_scan)
+		goto out;
 
-	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
+	do_io = (sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) ==
+		(__GFP_FS|__GFP_WAIT);
 
-	num_pages = num_extent_pages(eb->start, eb->len);
-	WARN_ON(atomic_read(&eb->refs) == 0);
-	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
+	spin_lock(&fs_info->eb_lru_lock);
+	while (!list_empty(&fs_info->eb_lru) && nr_to_scan > 0) {
+		int free = 1;
 
-	for (i = 0; i < num_pages; i++)
-		set_page_dirty(extent_buffer_page(eb, i));
-	return was_dirty;
+		nr_to_scan--;
+
+		eb = list_first_entry(&fs_info->eb_lru, struct extent_buffer,
+				      lru);
+		if (test_and_clear_bit(EXTENT_BUFFER_REFERENCED,
+				       &eb->bflags)) {
+			list_move_tail(&eb->lru, &fs_info->eb_lru);
+			continue;
+		}
+		list_del_init(&eb->lru);
+		fs_info->eb_lru_nr--;
+		spin_unlock(&fs_info->eb_lru_lock);
+
+		spin_lock(&eb->refs_lock);
+		if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
+			free = 0;
+		} else if (!atomic_dec_and_test(&eb->refs)) {
+			set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags);
+			atomic_inc(&eb->refs);
+			free = 0;
+		}
+		spin_unlock(&eb->refs_lock);
+
+		if (free) {
+			spin_lock(&fs_info->eb_tree_lock);
+			radix_tree_delete(&fs_info->eb_tree,
+					  eb->start >> PAGE_CACHE_SHIFT);
+			spin_unlock(&fs_info->eb_tree_lock);
+			call_rcu(&eb->rcu_head,
+				 btrfs_release_extent_buffer_rcu);
+		}
+		spin_lock(&fs_info->eb_lru_lock);
+	}
+	spin_unlock(&fs_info->eb_lru_lock);
+
+	if (!do_io || nr_to_scan <= 0)
+		goto out;
+
+	flush_dirty_ebs_nr(fs_info, nr_to_scan);
+	kick_io = 0;
+out:
+	if (kick_io) {
+		fs_info->eb_writeback_work.func = flush_dirty_ebs;
+		btrfs_queue_worker(&fs_info->eb_writeback_worker,
+				   &fs_info->eb_writeback_work);
+	}
+
+	return ((fs_info->eb_lru_nr + atomic_read(&fs_info->dirty_ebs)) / 100) * sysctl_vfs_cache_pressure;
 }
 
-static int range_straddles_pages(u64 start, u64 len)
+void btrfs_destroy_eb_cache(struct btrfs_fs_info *fs_info)
 {
-	if (len < PAGE_CACHE_SIZE)
-		return 1;
-	if (start & (PAGE_CACHE_SIZE - 1))
-		return 1;
-	if ((start + len) & (PAGE_CACHE_SIZE - 1))
+	struct extent_buffer *eb;
+	int count = 0;
+
+	synchronize_rcu();
+	spin_lock(&fs_info->eb_lru_lock);
+	while (!list_empty(&fs_info->eb_lru)) {
+		eb = list_first_entry(&fs_info->eb_lru, struct extent_buffer,
+				      lru);
+		list_del_init(&eb->lru);
+		spin_unlock(&fs_info->eb_lru_lock);
+		BUG_ON(atomic_read(&eb->refs) > 1);
+		btrfs_release_extent_buffer(eb);
+		count++;
+	}
+	spin_unlock(&fs_info->eb_lru_lock);
+}
+
+int clear_extent_buffer_dirty(struct extent_buffer *eb)
+{
+	WARN_ON(in_interrupt());
+	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+		free_extent_buffer(eb);
+		atomic_dec(&eb->root->fs_info->dirty_ebs);
 		return 1;
+	}
 	return 0;
 }
 
-int clear_extent_buffer_uptodate(struct extent_buffer *eb)
+int set_extent_buffer_dirty(struct extent_buffer *eb)
 {
-	unsigned long i;
-	struct page *page;
-	unsigned long num_pages;
-
-	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
-		if (page)
-			ClearPageUptodate(page);
+	WARN_ON(in_interrupt());
+	if (!test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+		del_lru(eb);
+		/* We hold a ref on this buffer until it's written out */
+		extent_buffer_get(eb);
+		atomic_inc(&eb->root->fs_info->dirty_ebs);
+		return 0;
 	}
-	return 0;
+	return 1;
 }
 
-int set_extent_buffer_uptodate(struct extent_buffer *eb)
+void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	unsigned long i;
-	struct page *page;
-	unsigned long num_pages;
+	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+}
 
+void set_extent_buffer_uptodate(struct extent_buffer *eb)
+{
 	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
-		SetPageUptodate(page);
-	}
+}
+
+static int range_straddles_pages(u64 start, u64 len)
+{
+	if (len < PAGE_CACHE_SIZE)
+		return 1;
+	if (start & (PAGE_CACHE_SIZE - 1))
+		return 1;
+	if ((start + len) & (PAGE_CACHE_SIZE - 1))
+		return 1;
 	return 0;
 }
 
@@ -4518,100 +4290,6 @@ int extent_buffer_uptodate(struct extent_buffer *eb)
 	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 }
 
-int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, u64 start, int wait,
-			     get_extent_t *get_extent, int mirror_num)
-{
-	unsigned long i;
-	unsigned long start_i;
-	struct page *page;
-	int err;
-	int ret = 0;
-	int locked_pages = 0;
-	int all_uptodate = 1;
-	unsigned long num_pages;
-	unsigned long num_reads = 0;
-	struct bio *bio = NULL;
-	unsigned long bio_flags = 0;
-
-	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
-		return 0;
-
-	if (start) {
-		WARN_ON(start < eb->start);
-		start_i = (start >> PAGE_CACHE_SHIFT) -
-			(eb->start >> PAGE_CACHE_SHIFT);
-	} else {
-		start_i = 0;
-	}
-
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = start_i; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
-		if (wait == WAIT_NONE) {
-			if (!trylock_page(page))
-				goto unlock_exit;
-		} else {
-			lock_page(page);
-		}
-		locked_pages++;
-		if (!PageUptodate(page)) {
-			num_reads++;
-			all_uptodate = 0;
-		}
-	}
-	if (all_uptodate) {
-		if (start_i == 0)
-			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-		goto unlock_exit;
-	}
-
-	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->read_mirror = 0;
-	atomic_set(&eb->io_pages, num_reads);
-	for (i = start_i; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
-		if (!PageUptodate(page)) {
-			ClearPageError(page);
-			err = __extent_read_full_page(tree, page,
-						      get_extent, &bio,
-						      mirror_num, &bio_flags);
-			if (err)
-				ret = err;
-		} else {
-			unlock_page(page);
-		}
-	}
-
-	if (bio) {
-		err = submit_one_bio(READ, bio, mirror_num, bio_flags);
-		if (err)
-			return err;
-	}
-
-	if (ret || wait != WAIT_COMPLETE)
-		return ret;
-
-	for (i = start_i; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
-		wait_on_page_locked(page);
-		if (!PageUptodate(page))
-			ret = -EIO;
-	}
-
-	return ret;
-
-unlock_exit:
-	i = start_i;
-	while (locked_pages > 0) {
-		page = extent_buffer_page(eb, i);
-		i++;
-		unlock_page(page);
-		locked_pages--;
-	}
-	return ret;
-}
-
 void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 			unsigned long start,
 			unsigned long len)
@@ -4736,7 +4414,6 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
-		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
 		kaddr = page_address(page);
@@ -4764,9 +4441,9 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 
 	offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
 
+	WARN_ON(!extent_buffer_uptodate(eb));
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
-		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
 		kaddr = page_address(page);
@@ -4795,9 +4472,9 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	offset = (start_offset + dst_offset) &
 		((unsigned long)PAGE_CACHE_SIZE - 1);
 
+	WARN_ON(!extent_buffer_uptodate(dst));
 	while (len > 0) {
 		page = extent_buffer_page(dst, i);
-		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
 
@@ -4948,48 +4625,3 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		len -= cur;
 	}
 }
-
-int try_release_extent_buffer(struct page *page, gfp_t mask)
-{
-	struct extent_buffer *eb;
-
-	/*
-	 * We need to make sure noboody is attaching this page to an eb right
-	 * now.
-	 */
-	spin_lock(&page->mapping->private_lock);
-	if (!PagePrivate(page)) {
-		spin_unlock(&page->mapping->private_lock);
-		return 1;
-	}
-
-	eb = (struct extent_buffer *)page->private;
-	BUG_ON(!eb);
-
-	/*
-	 * This is a little awful but should be ok, we need to make sure that
-	 * the eb doesn't disappear out from under us while we're looking at
-	 * this page.
-	 */
-	spin_lock(&eb->refs_lock);
-	if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
-		spin_unlock(&eb->refs_lock);
-		spin_unlock(&page->mapping->private_lock);
-		return 0;
-	}
-	spin_unlock(&page->mapping->private_lock);
-
-	if ((mask & GFP_NOFS) == GFP_NOFS)
-		mask = GFP_NOFS;
-
-	/*
-	 * If tree ref isn't set then we know the ref on this eb is a real ref,
-	 * so just return, this page will likely be freed soon anyway.
-	 */
-	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
-		spin_unlock(&eb->refs_lock);
-		return 0;
-	}
-
-	return release_extent_buffer(eb, mask);
-}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..7264d8b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -40,6 +40,8 @@
 #define EXTENT_BUFFER_WRITEBACK 7
 #define EXTENT_BUFFER_IOERR 8
 #define EXTENT_BUFFER_DUMMY 9
+#define EXTENT_BUFFER_IOLOCK 10
+#define EXTENT_BUFFER_REFERENCED 11
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
@@ -129,12 +131,13 @@ struct extent_buffer {
 	unsigned long map_start;
 	unsigned long map_len;
 	unsigned long bflags;
-	struct extent_io_tree *tree;
+	struct btrfs_root *root;
 	spinlock_t refs_lock;
 	atomic_t refs;
 	atomic_t io_pages;
 	int read_mirror;
 	struct list_head leak_list;
+	struct list_head lru;
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
 
@@ -175,7 +178,48 @@ static inline int extent_compress_type(unsigned long bio_flags)
 	return bio_flags >> EXTENT_BIO_FLAG_SHIFT;
 }
 
+static inline int extent_buffer_tryiolock(struct extent_buffer *eb)
+{
+	return likely(!test_and_set_bit_lock(EXTENT_BUFFER_IOLOCK,
+					     &eb->bflags));
+}
+
+static int sleep_eb(void *word)
+{
+	io_schedule();
+	return 0;
+}
+
+static inline void wait_on_extent_buffer(struct extent_buffer *eb)
+{
+	might_sleep();
+	if (test_bit(EXTENT_BUFFER_IOLOCK, &eb->bflags))
+		wait_on_bit(&eb->bflags, EXTENT_BUFFER_IOLOCK, sleep_eb,
+			    TASK_UNINTERRUPTIBLE);
+}
+
+static inline void extent_buffer_iolock(struct extent_buffer *eb)
+{
+	might_sleep();
+	if (!extent_buffer_tryiolock(eb))
+		wait_on_bit_lock(&eb->bflags, EXTENT_BUFFER_IOLOCK, sleep_eb,
+				 TASK_UNINTERRUPTIBLE);
+}
+
+static inline void extent_buffer_iounlock(struct extent_buffer *eb)
+{
+	clear_bit_unlock(EXTENT_BUFFER_IOLOCK, &eb->bflags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&eb->bflags, EXTENT_BUFFER_IOLOCK);
+}
+
+static inline void extent_buffer_get(struct extent_buffer *eb)
+{
+	BUG_ON(!atomic_inc_not_zero(&eb->refs));
+}
+
 struct extent_map_tree;
+struct btrfs_fs_info;
 
 typedef struct extent_map *(get_extent_t)(struct inode *inode,
 					  struct page *page,
@@ -188,7 +232,8 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 int try_release_extent_mapping(struct extent_map_tree *map,
 			       struct extent_io_tree *tree, struct page *page,
 			       gfp_t mask);
-int try_release_extent_buffer(struct page *page, gfp_t mask);
+int try_release_extent_buffer(struct btrfs_fs_info *fs_info,
+			      struct extent_buffer *eb);
 int try_release_extent_state(struct extent_map_tree *map,
 			     struct extent_io_tree *tree, struct page *page,
 			     gfp_t mask);
@@ -263,28 +308,32 @@ int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
 void set_page_extent_mapped(struct page *page);
 
-struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
+struct extent_buffer *alloc_extent_buffer(struct btrfs_root *root,
 					  u64 start, unsigned long len);
 struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len);
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
-struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-					 u64 start, unsigned long len);
 void free_extent_buffer(struct extent_buffer *eb);
 void free_extent_buffer_stale(struct extent_buffer *eb);
+struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
+					 u64 start);
+struct extent_buffer *find_extent_buffer_no_ref(struct btrfs_fs_info *fs_info,
+						u64 start);
+void free_extent_buffer(struct extent_buffer *eb);
+void free_extent_buffer_stale(struct extent_buffer *eb);
+int shrink_ebs(struct shrinker *shrinker, struct shrink_control *sc);
+void btrfs_destroy_eb_cache(struct btrfs_fs_info *fs_info);
 #define WAIT_NONE	0
 #define WAIT_COMPLETE	1
 #define WAIT_PAGE_LOCK	2
-int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, u64 start, int wait,
-			     get_extent_t *get_extent, int mirror_num);
+int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
+			     int mirror_num);
+int write_one_extent_buffer(struct extent_buffer *eb, int wait,
+			    int mirror_num);
+int write_extent_buffer_range(struct btrfs_root *root, u64 start,
+			      u64 end, int wait);
 unsigned long num_extent_pages(u64 start, u64 len);
 struct page *extent_buffer_page(struct extent_buffer *eb, unsigned long i);
 
-static inline void extent_buffer_get(struct extent_buffer *eb)
-{
-	atomic_inc(&eb->refs);
-}
-
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 			  unsigned long start,
 			  unsigned long len);
@@ -303,10 +352,10 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
 void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
-void clear_extent_buffer_dirty(struct extent_buffer *eb);
+int clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
-int set_extent_buffer_uptodate(struct extent_buffer *eb);
-int clear_extent_buffer_uptodate(struct extent_buffer *eb);
+void set_extent_buffer_uptodate(struct extent_buffer *eb);
+void clear_extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_uptodate(struct extent_buffer *eb);
 int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 		      unsigned long min_len, char **map,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c5dbd91..0c8a18e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4085,11 +4085,6 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		}
 	}
 
-	filemap_write_and_wait_range(fs_info->btree_inode->i_mapping,
-				     rc->block_group->key.objectid,
-				     rc->block_group->key.objectid +
-				     rc->block_group->key.offset - 1);
-
 	WARN_ON(rc->block_group->pinned > 0);
 	WARN_ON(rc->block_group->reserved > 0);
 	WARN_ON(btrfs_block_group_used(&rc->block_group->item) > 0);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fa61ef5..fe928d9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -817,10 +817,8 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
 	trace_btrfs_sync_fs(wait);
 
-	if (!wait) {
-		filemap_flush(fs_info->btree_inode->i_mapping);
+	if (!wait)
 		return 0;
-	}
 
 	btrfs_wait_ordered_extents(root, 0, 0);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7208ada..1c8ad1f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -107,6 +107,7 @@ loop:
 	}
 
 	atomic_set(&cur_trans->num_writers, 1);
+
 	cur_trans->num_joined = 0;
 	init_waitqueue_head(&cur_trans->writer_wait);
 	init_waitqueue_head(&cur_trans->commit_wait);
@@ -149,8 +150,8 @@ loop:
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
-	extent_io_tree_init(&cur_trans->dirty_pages,
-			     fs_info->btree_inode->i_mapping);
+	extent_io_tree_init(&cur_trans->dirty_pages, NULL);
+	mutex_init(&cur_trans->dirty_pages_mutex);
 	fs_info->generation++;
 	cur_trans->transid = fs_info->generation;
 	fs_info->running_transaction = cur_trans;
@@ -249,21 +250,21 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
  * when this is done, it is safe to start a new transaction, but the current
  * transaction might not be fully on disk.
  */
-static void wait_current_trans(struct btrfs_root *root)
+void btrfs_wait_current_trans(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_transaction *cur_trans;
 
-	spin_lock(&root->fs_info->trans_lock);
-	cur_trans = root->fs_info->running_transaction;
+	spin_lock(&fs_info->trans_lock);
+	cur_trans = fs_info->running_transaction;
 	if (cur_trans && cur_trans->blocked) {
 		atomic_inc(&cur_trans->use_count);
-		spin_unlock(&root->fs_info->trans_lock);
+		spin_unlock(&fs_info->trans_lock);
 
-		wait_event(root->fs_info->transaction_wait,
+		wait_event(fs_info->transaction_wait,
 			   !cur_trans->blocked);
 		put_transaction(cur_trans);
 	} else {
-		spin_unlock(&root->fs_info->trans_lock);
+		spin_unlock(&fs_info->trans_lock);
 	}
 }
 
@@ -336,12 +337,12 @@ again:
 		return ERR_PTR(-ENOMEM);
 
 	if (may_wait_transaction(root, type))
-		wait_current_trans(root);
+		btrfs_wait_current_trans(root->fs_info);
 
 	do {
 		ret = join_transaction(root, type == TRANS_JOIN_NOLOCK);
 		if (ret == -EBUSY)
-			wait_current_trans(root);
+			btrfs_wait_current_trans(root->fs_info);
 	} while (ret == -EBUSY);
 
 	if (ret < 0) {
@@ -468,7 +469,7 @@ out:
 void btrfs_throttle(struct btrfs_root *root)
 {
 	if (!atomic_read(&root->fs_info->open_ioctl_trans))
-		wait_current_trans(root);
+		btrfs_wait_current_trans(root->fs_info);
 }
 
 static int should_end_transaction(struct btrfs_trans_handle *trans,
@@ -643,7 +644,6 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 {
 	int err = 0;
 	int werr = 0;
-	struct address_space *mapping = root->fs_info->btree_inode->i_mapping;
 	u64 start = 0;
 	u64 end;
 
@@ -651,11 +651,9 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 				      mark)) {
 		convert_extent_bit(dirty_pages, start, end, EXTENT_NEED_WAIT, mark,
 				   GFP_NOFS);
-		err = filemap_fdatawrite_range(mapping, start, end);
+		err = write_extent_buffer_range(root, start, end, WAIT_PAGE_LOCK);
 		if (err)
-			werr = err;
-		cond_resched();
-		start = end + 1;
+			break;
 	}
 	if (err)
 		werr = err;
@@ -672,23 +670,33 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 			      struct extent_io_tree *dirty_pages, int mark)
 {
 	int err = 0;
-	int werr = 0;
-	struct address_space *mapping = root->fs_info->btree_inode->i_mapping;
 	u64 start = 0;
 	u64 end;
 
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
 				      EXTENT_NEED_WAIT)) {
 		clear_extent_bits(dirty_pages, start, end, EXTENT_NEED_WAIT, GFP_NOFS);
-		err = filemap_fdatawait_range(mapping, start, end);
-		if (err)
-			werr = err;
-		cond_resched();
-		start = end + 1;
+		while (start < end) {
+			struct extent_buffer *eb;
+
+			eb = find_extent_buffer_no_ref(root->fs_info, start);
+			if (!eb) {
+				/*
+				 * This could happen if the eb got free'd up
+				 * after it was written out by the shrinker.
+				 */
+				start += PAGE_CACHE_SIZE;
+				continue;
+			}
+			wait_on_extent_buffer(eb);
+			if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags))
+				err = -EIO;
+			start = eb->start + eb->len;
+			free_extent_buffer(eb);
+			cond_resched();
+		}
 	}
-	if (err)
-		werr = err;
-	return werr;
+	return err;
 }
 
 /*
@@ -715,14 +723,17 @@ int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root)
 {
-	if (!trans || !trans->transaction) {
-		struct inode *btree_inode;
-		btree_inode = root->fs_info->btree_inode;
-		return filemap_write_and_wait(btree_inode->i_mapping);
-	}
-	return btrfs_write_and_wait_marked_extents(root,
+	int ret;
+
+	if (!trans || !trans->transaction)
+		return 0;
+
+	mutex_lock(&trans->transaction->dirty_pages_mutex);
+	ret = btrfs_write_and_wait_marked_extents(root,
 					   &trans->transaction->dirty_pages,
 					   EXTENT_DIRTY);
+	mutex_unlock(&trans->transaction->dirty_pages_mutex);
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e8b8416..4ee0c3a 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -38,6 +38,7 @@ struct btrfs_transaction {
 	int commit_done;
 	int blocked;
 	struct list_head list;
+	struct mutex dirty_pages_mutex;
 	struct extent_io_tree dirty_pages;
 	unsigned long start_time;
 	wait_queue_head_t writer_wait;
@@ -100,6 +101,7 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
+void btrfs_wait_current_trans(struct btrfs_fs_info *fs_info);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86670f..02dbee7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -274,16 +274,21 @@ static int process_one_buffer(struct btrfs_root *log,
 			      struct extent_buffer *eb,
 			      struct walk_control *wc, u64 gen)
 {
+	int wait = WAIT_PAGE_LOCK;
+
 	if (wc->pin)
 		btrfs_pin_extent_for_log_replay(wc->trans,
 						log->fs_info->extent_root,
 						eb->start, eb->len);
 
 	if (btrfs_buffer_uptodate(eb, gen, 0)) {
-		if (wc->write)
-			btrfs_write_tree_block(eb);
-		if (wc->wait)
-			btrfs_wait_tree_block_writeback(eb);
+		if (wc->write) {
+			if (wc->wait)
+				wait = WAIT_COMPLETE;
+			write_one_extent_buffer(eb, wait, 0);
+		} else if (wc->wait) {
+			wait_on_extent_buffer(eb);
+		}
 	}
 	return 0;
 }
@@ -1766,16 +1771,18 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 				btrfs_tree_lock(next);
 				btrfs_set_lock_blocking(next);
 				clean_tree_block(trans, root, next);
-				btrfs_wait_tree_block_writeback(next);
+				wait_on_extent_buffer(next);
 				btrfs_tree_unlock(next);
 
 				WARN_ON(root_owner !=
 					BTRFS_TREE_LOG_OBJECTID);
 				ret = btrfs_free_and_pin_reserved_extent(root,
 							 bytenr, blocksize);
-				BUG_ON(ret); /* -ENOMEM or logic errors */
+				BUG_ON(ret);
+				free_extent_buffer_stale(next);
+			} else {
+				free_extent_buffer(next);
 			}
-			free_extent_buffer(next);
 			continue;
 		}
 		ret = btrfs_read_buffer(next, ptr_gen);
@@ -1785,8 +1792,12 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 		}
 
 		WARN_ON(*level <= 0);
-		if (path->nodes[*level-1])
-			free_extent_buffer(path->nodes[*level-1]);
+		if (path->nodes[*level-1]) {
+			if (wc->free)
+				free_extent_buffer_stale(path->nodes[*level-1]);
+			else
+				free_extent_buffer(path->nodes[*level-1]);
+		}
 		path->nodes[*level-1] = next;
 		*level = btrfs_header_level(next);
 		path->slots[*level] = 0;
@@ -1839,7 +1850,7 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				btrfs_tree_lock(next);
 				btrfs_set_lock_blocking(next);
 				clean_tree_block(trans, root, next);
-				btrfs_wait_tree_block_writeback(next);
+				wait_on_extent_buffer(next);
 				btrfs_tree_unlock(next);
 
 				WARN_ON(root_owner != BTRFS_TREE_LOG_OBJECTID);
@@ -1847,8 +1858,10 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len);
 				BUG_ON(ret);
+				free_extent_buffer_stale(path->nodes[*level]);
+			} else {
+				free_extent_buffer(path->nodes[*level]);
 			}
-			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
 			*level = i + 1;
 		}
@@ -1913,7 +1926,7 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 			btrfs_tree_lock(next);
 			btrfs_set_lock_blocking(next);
 			clean_tree_block(trans, log, next);
-			btrfs_wait_tree_block_writeback(next);
+			wait_on_extent_buffer(next);
 			btrfs_tree_unlock(next);
 
 			WARN_ON(log->root_key.objectid !=
@@ -1927,7 +1940,10 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 out:
 	for (i = 0; i <= orig_level; i++) {
 		if (path->nodes[i]) {
-			free_extent_buffer(path->nodes[i]);
+			if (wc->free)
+				free_extent_buffer_stale(path->nodes[i]);
+			else
+				free_extent_buffer(path->nodes[i]);
 			path->nodes[i] = NULL;
 		}
 	}
@@ -2217,7 +2233,7 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
 	}
 
-	free_extent_buffer(log->node);
+	free_extent_buffer_stale(log->node);
 	kfree(log);
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b8708f9..6c84c1b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4558,7 +4558,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 					  BTRFS_SUPER_INFO_SIZE);
 	if (!sb)
 		return -ENOMEM;
-	btrfs_set_buffer_uptodate(sb);
+	set_extent_buffer_uptodate(sb);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, sb, 0);
 	/*
 	 * The sb extent buffer is artifical and just used to read the system array.
-- 
1.7.7.6

