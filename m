Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43542 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752492AbcAGBIt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id D21454092567
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 10/16] btrfs: dedup: Inband in-memory only de-duplication implement
Date: Thu, 7 Jan 2016 09:08:11 +0800
Message-ID: <1452128897-5433-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Core implement for inband de-duplication.
It reuse the async_cow_start() facility to calculate dedup hash.
And use dedup hash to do inband de-duplication at extent level.

The work flow is as below:
1) Run delalloc range for an inode
2) Calculate hash for the delalloc range at the unit of dedup_bs
3) For hash match(duplicated) case, just increase source extent ref
   and insert file extent.
   For hash mismatch case, go through the normal cow_file_range()
   fallback, and add hash into dedup_tree.
   Compress for hash miss case is not supported yet.

Current implement restore all dedup hash in memory rb-tree, with LRU
behavior to control the limit.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
v3:
  Fix a wrong page parameter for cow_file_range().
  Fix a memory leak.
  Move dedup_add() to run_delayed_ref() to fix an abort transaction.
---
 fs/btrfs/extent-tree.c |   6 +
 fs/btrfs/extent_io.c   |  30 ++---
 fs/btrfs/extent_io.h   |  15 +++
 fs/btrfs/inode.c       | 305 +++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 331 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a2e4c2b..8eb8d85 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6677,6 +6677,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
+			ret = btrfs_dedup_del(trans, root, bytenr);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, extent_root,
+							ret);
+				goto out;
+			}
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, extent_root, ret);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 33a01ea..b7a6612 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2549,7 +2549,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_writepage(struct bio *bio)
+void end_bio_extent_writepage(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	u64 start;
@@ -2813,8 +2813,8 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 
 
-static int __must_check submit_one_bio(int rw, struct bio *bio,
-				       int mirror_num, unsigned long bio_flags)
+int __must_check submit_one_bio(int rw, struct bio *bio,
+				int mirror_num, unsigned long bio_flags)
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -2851,18 +2851,18 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
 
 }
 
-static int submit_extent_page(int rw, struct extent_io_tree *tree,
-			      struct writeback_control *wbc,
-			      struct page *page, sector_t sector,
-			      size_t size, unsigned long offset,
-			      struct block_device *bdev,
-			      struct bio **bio_ret,
-			      unsigned long max_pages,
-			      bio_end_io_t end_io_func,
-			      int mirror_num,
-			      unsigned long prev_bio_flags,
-			      unsigned long bio_flags,
-			      bool force_bio_submit)
+int submit_extent_page(int rw, struct extent_io_tree *tree,
+			struct writeback_control *wbc,
+			struct page *page, sector_t sector,
+			size_t size, unsigned long offset,
+			struct block_device *bdev,
+			struct bio **bio_ret,
+			unsigned long max_pages,
+			bio_end_io_t end_io_func,
+			int mirror_num,
+			unsigned long prev_bio_flags,
+			unsigned long bio_flags,
+			bool force_bio_submit)
 {
 	int ret = 0;
 	struct bio *bio;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index f4c1ae1..ae17832 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -360,6 +360,21 @@ int clean_io_failure(struct inode *inode, u64 start, struct page *page,
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
+int submit_extent_page(int rw, struct extent_io_tree *tree,
+		       struct writeback_control *wbc,
+		       struct page *page, sector_t sector,
+		       size_t size, unsigned long offset,
+		       struct block_device *bdev,
+		       struct bio **bio_ret,
+		       unsigned long max_pages,
+		       bio_end_io_t end_io_func,
+		       int mirror_num,
+		       unsigned long prev_bio_flags,
+		       unsigned long bio_flags,
+		       bool force_bio_submit);
+int __must_check submit_one_bio(int rw, struct bio *bio,
+				int mirror_num, unsigned long bio_flags);
+void end_bio_extent_writepage(struct bio *bio);
 
 /*
  * When IO fails, either with EIO or csum verification fails, we
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 832a733..c75e7ab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,6 +60,7 @@
 #include "hash.h"
 #include "props.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -666,6 +667,255 @@ static void free_async_extent_pages(struct async_extent *async_extent)
 }
 
 /*
+ * Run dedup for delalloc range
+ * Will calculate the hash for the range.
+ */
+static noinline int
+run_delalloc_dedup(struct inode *inode, struct page *locked_page, u64 start,
+		   u64 end, struct async_cow *async_cow)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct bio *bio = NULL;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+	struct extent_map *em;
+	struct page *page = NULL;
+	struct block_device *bdev;
+	struct btrfs_key ins;
+	u64 blocksize = root->sectorsize;
+	u64 num_bytes;
+	u64 cur_alloc_size;
+	u64 cur_end;
+	u64 alloc_hint = 0;
+	u64 iosize;
+	int found = 0;
+	int type = 0;
+	sector_t sector;
+	int ret = 0;
+	struct extent_state *cached_state = NULL;
+	struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
+	u64 dedup_bs = dedup_info->blocksize;
+	u16 hash_type = dedup_info->hash_type;
+	struct btrfs_dedup_hash *hash = NULL;
+
+	WARN_ON(btrfs_is_free_space_inode(inode));
+
+	num_bytes = ALIGN(end - start + 1, blocksize);
+	num_bytes = max(blocksize, num_bytes);
+
+	hash = btrfs_dedup_alloc_hash(hash_type);
+	if (!hash) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
+
+	while (num_bytes > 0) {
+		unsigned long op = 0;
+
+		/* page has been locked by caller */
+		page = find_get_page(inode->i_mapping,
+				     start >> PAGE_CACHE_SHIFT);
+		WARN_ON(!page);	/* page should be here */
+
+		/* already ordered? */
+		if (PagePrivate2(page))
+			goto submit;
+
+		/* too small data, go for normal path */
+		if (num_bytes < dedup_bs) {
+			int page_started = 0;
+			unsigned long nr_written = 0;
+
+			cur_end = start + num_bytes - 1;
+
+			/* Now locked_page is not dirty. */
+			if (page_offset(locked_page) >= start &&
+			    page_offset(locked_page) <= cur_end) {
+				__set_page_dirty_nobuffers(locked_page);
+			}
+
+			lock_extent(tree, start, cur_end);
+
+			/* allocate blocks */
+			ret = cow_file_range(inode, page, start, cur_end,
+					     &page_started, &nr_written, 0);
+
+			if (!page_started && !ret)
+				extent_write_locked_range(tree, inode, start,
+						cur_end, btrfs_get_extent,
+						WB_SYNC_ALL);
+			else if (ret)
+				unlock_page(page);
+
+			if (ret)
+				SetPageError(page);
+
+			page_cache_release(page);
+			page = NULL;
+
+			num_bytes = 0;
+			start += num_bytes;
+			cond_resched();
+			continue;
+		}
+
+		cur_alloc_size = min_t(u64, num_bytes, dedup_bs);
+		WARN_ON(cur_alloc_size < dedup_bs);	/* shouldn't happen */
+		cur_end = start + cur_alloc_size - 1;
+
+		/* see comments in compress_file_range */
+		extent_range_clear_dirty_for_io(inode, start, cur_end);
+
+		ret = btrfs_dedup_calc_hash(root, inode, start, hash);
+		if (ret < 0)
+			goto out_unlock;
+
+		found = btrfs_dedup_search(inode, start, hash);
+
+		if (found == 0) {
+			/* Dedup hash miss, normal routine */
+			ret = btrfs_reserve_extent(root, cur_alloc_size,
+					   cur_alloc_size, 0, alloc_hint,
+					   &ins, 1, 1);
+			if (ret < 0)
+				goto out_unlock;
+		} else {
+			/* Dedup hash hit, only insert file extent */
+			ins.objectid = hash->bytenr;
+			ins.offset = hash->num_bytes;
+		}
+
+		lock_extent(tree, start, cur_end);
+
+		em = alloc_extent_map();
+		if (!em) {
+			ret = -ENOMEM;
+			goto out_reserve;
+		}
+		em->start = start;
+		em->orig_start = em->start;
+		em->len = cur_alloc_size;
+		em->mod_start = em->start;
+		em->mod_len = em->len;
+
+		em->block_start = ins.objectid;
+		em->block_len = ins.offset;
+		em->orig_block_len = ins.offset;
+		em->bdev = root->fs_info->fs_devices->latest_bdev;
+		set_bit(EXTENT_FLAG_PINNED, &em->flags);
+		em->generation = -1;
+
+		while (1) {
+			write_lock(&em_tree->lock);
+			ret = add_extent_mapping(em_tree, em, 1);
+			write_unlock(&em_tree->lock);
+			if (ret != -EEXIST) {
+				free_extent_map(em);
+				break;
+			}
+			btrfs_drop_extent_cache(inode, start, cur_end, 0);
+		}
+		if (ret)
+			goto out_reserve;
+
+		ret = btrfs_add_ordered_extent_dedup(inode, start, ins.objectid,
+						     cur_alloc_size, ins.offset,
+						     type, hash);
+		if (ret)
+			goto out_reserve;
+
+		/*
+		 * Do set the Private2 bit so we know this page was properly
+		 * setup for writepage
+		 */
+		op |= PAGE_SET_PRIVATE2 | PAGE_SET_WRITEBACK | PAGE_CLEAR_DIRTY;
+		extent_clear_unlock_delalloc(inode, start, cur_end,
+					     NULL,
+					     EXTENT_LOCKED | EXTENT_DELALLOC,
+					     op);
+
+submit:
+		iosize = blocksize;
+
+		if (found == 0) {
+			em = btrfs_get_extent(inode, page, 0, start, blocksize,
+					      1);
+			if (IS_ERR(em)) {
+				/* btrfs_get_extent will not return NULL */
+				ret = PTR_ERR(em);
+				goto out_reserve;
+			}
+
+			sector = (em->block_start + start - em->start) >> 9;
+			bdev = em->bdev;
+			free_extent_map(em);
+			em = NULL;
+
+			/* TODO: rw can be WRTIE_SYNC */
+			ret = submit_extent_page(WRITE, tree, NULL, page,
+						 sector, iosize, 0,
+						 bdev, &bio,
+						 0, /* max_nr is no used */
+						 end_bio_extent_writepage,
+						 0, 0, 0, 0);
+			if (ret)
+				break;
+		} else {
+			end_extent_writepage(page, 0, start,
+					     start + iosize - 1);
+			/* we need to do this ourselves because we skip IO */
+			end_page_writeback(page);
+
+			/* Don't forget to free qgroup reserved space */
+			btrfs_qgroup_free_data(inode, start, cur_alloc_size);
+		}
+
+		unlock_page(page);
+		page_cache_release(page);
+		page = NULL;
+
+		num_bytes -= blocksize;
+		alloc_hint = ins.objectid + blocksize;
+		start += blocksize;
+		cond_resched();
+	}
+
+out_unlock:
+	if (bio) {
+		if (ret)
+			bio_put(bio);
+		else
+			ret = submit_one_bio(WRITE, bio, 0, 0);
+		bio = NULL;
+	}
+
+	if (ret && page)
+		SetPageError(page);
+	if (page) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
+out:
+	if (ret && num_bytes > 0)
+		extent_clear_unlock_delalloc(inode,
+			     start, start + num_bytes - 1, NULL,
+			     EXTENT_DELALLOC | EXTENT_LOCKED | EXTENT_DEFRAG,
+			     PAGE_UNLOCK | PAGE_SET_WRITEBACK |
+			     PAGE_END_WRITEBACK | PAGE_CLEAR_DIRTY);
+
+	free_extent_state(cached_state);
+	return ret;
+
+out_reserve:
+	if (found == 0)
+		btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
+	goto out_unlock;
+}
+
+/*
  * phase two of compressed writeback.  This is the ordered portion
  * of the code, which only gets called in the order the work was
  * queued.  We walk all the async extents created by compress_file_range
@@ -1077,11 +1327,19 @@ static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
+	int ret = 0;
 	async_cow = container_of(work, struct async_cow, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
+	if (inode_need_compress(async_cow->inode))
+		compress_file_range(async_cow->inode, async_cow->locked_page,
+				    async_cow->start, async_cow->end, async_cow,
+				    &num_added);
+	else
+		ret = run_delalloc_dedup(async_cow->inode,
+				async_cow->locked_page, async_cow->start,
+				async_cow->end, async_cow);
+	WARN_ON(ret);
+
 	if (num_added == 0) {
 		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
@@ -1531,6 +1789,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 {
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1538,7 +1798,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode)) {
+	} else if (!inode_need_compress(inode) && !dedup_info) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
 	} else {
@@ -2069,7 +2329,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 disk_bytenr, u64 disk_num_bytes,
 				       u64 num_bytes, u64 ram_bytes,
 				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+				       u16 other_encoding, int extent_type,
+				       struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -2131,10 +2392,33 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
+
+	/* For hash hit case, the memory is not used any more */
+	if (hash && hash->bytenr) {
+		kfree(hash);
+		hash = NULL;
+	} else if (!hash || hash->bytenr == 0) {
+		/*
+		 * Only for no-dedup or hash miss case, we need to increase
+		 * extent reference
+		 * For hash hit case, reference is already increased
+		 */
+		if (hash) {
+			hash->bytenr = ins.objectid;
+			hash->num_bytes = ins.offset;
+		}
+
+		ret = btrfs_alloc_reserved_file_extent(trans, root,
 					root->root_key.objectid,
 					btrfs_ino(inode), file_pos,
-					ram_bytes, &ins, NULL);
+					ram_bytes, &ins, hash);
+	}
+
+	if (ret < 0)
+		goto out_qgroup;
+
+out_qgroup:
+
 	/*
 	 * Release the reserved range from inode dirty range map, as it is
 	 * already moved into delayed_ref_head
@@ -2918,7 +3202,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->disk_len,
 						logical_len, logical_len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->hash);
 		if (!ret)
 			btrfs_release_delalloc_bytes(root,
 						     ordered_extent->start,
@@ -2978,7 +3263,6 @@ out:
 						   ordered_extent->disk_len, 1);
 	}
 
-
 	/*
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
@@ -9784,7 +10068,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
 						  ins.offset, 0, 0, 0,
-						  BTRFS_FILE_EXTENT_PREALLOC);
+						  BTRFS_FILE_EXTENT_PREALLOC,
+						  NULL);
 		if (ret) {
 			btrfs_free_reserved_extent(root, ins.objectid,
 						   ins.offset, 0);
-- 
2.6.4



