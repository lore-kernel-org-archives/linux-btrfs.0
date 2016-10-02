Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39207 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751802AbcJBNZh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNC6U053107
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:36 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25txvnxdsy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:36 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:35 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 07/19] Btrfs: subpage-blocksize: Use kmalloc()-ed memory to hold metadata blocks
Date: Sun,  2 Oct 2016 18:54:16 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-8-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For subpage-blocksizes this commit uses kmalloc()-ed memory to buffer
metadata blocks in memory.

When reading/writing metadata blocks, We now track the first extent
buffer using bio->bi_private. With kmalloc()-ed memory we cannot use
page->private. Hence when writing dirty extent buffers in
subpage-blocksize scenario, this commit forces each bio to contain a
single extent buffer. For the non subpage-blocksize scenario we continue
to track the corresponding extent buffer using page->private and hence a
single write bio will continue to have more than one dirty extent
buffer.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h                 |   6 +-
 fs/btrfs/disk-io.c               |  27 +++---
 fs/btrfs/extent_io.c             | 204 +++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.h             |   8 +-
 fs/btrfs/tests/extent-io-tests.c |   4 +-
 5 files changed, 158 insertions(+), 91 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b9ee7cf..745284c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1491,14 +1491,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
 {									\
-	type *p = page_address(eb->pages[0]);				\
+	type *p = (type *)((u8 *)page_address(eb->pages[0])		\
+			+ eb->pg_offset);				\
 	u##bits res = le##bits##_to_cpu(p->member);			\
 	return res;							\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    u##bits val)			\
 {									\
-	type *p = page_address(eb->pages[0]);				\
+	type *p = (type *)((u8 *)page_address(eb->pages[0])		\
+			+ eb->pg_offset);				\
 	p->member = cpu_to_le##bits(val);				\
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9ff48a7..5663481 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -448,13 +448,10 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
  * we only fill in the checksum field in the first page of a multi-page block
  */
 
-static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
+static int csum_dirty_buffer(struct btrfs_fs_info *fs_info,
+			struct extent_buffer *eb)
 {
-	struct extent_buffer *eb;
 
-	eb = (struct extent_buffer *)page->private;
-	if (page != eb->pages[0])
-		return 0;
 	ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
 			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
 
@@ -557,11 +554,10 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	int ret = 0;
 	int reads_done;
 
-	if (!page->private)
+	eb = (io_bio->bio).bi_private;
+	if (!eb)
 		goto out;
 
-	eb = (struct extent_buffer *)page->private;
-
 	/* the pending IO might have been the only thing that kept this buffer
 	 * in memory.  Make sure we have a ref for all this other checks
 	 */
@@ -646,11 +642,11 @@ out:
 	return ret;
 }
 
-static int btree_io_failed_hook(struct page *page, int failed_mirror)
+static int btree_io_failed_hook(struct page *page, void *private,
+				int failed_mirror)
 {
-	struct extent_buffer *eb;
+	struct extent_buffer *eb = private;
 
-	eb = (struct extent_buffer *)page->private;
 	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = failed_mirror;
 	atomic_dec(&eb->io_pages);
@@ -829,11 +825,18 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 static int btree_csum_one_bio(struct btrfs_fs_info *fs_info, struct bio *bio)
 {
+	struct extent_buffer *eb = bio->bi_private;
 	struct bio_vec *bvec;
 	int i, ret = 0;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		ret = csum_dirty_buffer(fs_info, bvec->bv_page);
+		if (eb->len >= PAGE_SIZE)
+			eb = (struct extent_buffer *)(bvec->bv_page->private);
+
+		if (bvec->bv_page != eb->pages[0])
+			continue;
+
+		ret = csum_dirty_buffer(fs_info, eb);
 		if (ret)
 			break;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6cac61f..8ace367 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2817,18 +2817,17 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 
 
-static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
-				       unsigned long bio_flags)
+static int __must_check submit_one_bio(struct bio *bio,
+				struct extent_io_tree *tree, int mirror_num,
+				unsigned long bio_flags)
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct page *page = bvec->bv_page;
-	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
 	start = page_offset(page) + bvec->bv_offset;
 
-	bio->bi_private = NULL;
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
@@ -2864,7 +2863,8 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 			      int mirror_num,
 			      unsigned long prev_bio_flags,
 			      unsigned long bio_flags,
-			      bool force_bio_submit)
+			      bool force_bio_submit,
+			      void *private)
 {
 	int ret = 0;
 	struct bio *bio;
@@ -2883,7 +2883,8 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 		    force_bio_submit ||
 		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
-			ret = submit_one_bio(bio, mirror_num, prev_bio_flags);
+			ret = submit_one_bio(bio, tree, mirror_num,
+					prev_bio_flags);
 			if (ret < 0) {
 				*bio_ret = NULL;
 				return ret;
@@ -2903,7 +2904,7 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
-	bio->bi_private = tree;
+	bio->bi_private = private;
 	bio_set_op_attrs(bio, op, op_flags);
 	if (wbc) {
 		wbc_init_bio(wbc, bio);
@@ -2913,7 +2914,7 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 	if (bio_ret)
 		*bio_ret = bio;
 	else
-		ret = submit_one_bio(bio, mirror_num, bio_flags);
+		ret = submit_one_bio(bio, tree, mirror_num, bio_flags);
 
 	return ret;
 }
@@ -3211,7 +3212,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
 					 this_bio_flag,
-					 force_bio_submit);
+					 force_bio_submit, NULL);
 		if (!ret) {
 			nr++;
 			*bio_flags = this_bio_flag;
@@ -3346,7 +3347,7 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
 				      &bio_flags, 0);
 	if (bio)
-		ret = submit_one_bio(bio, mirror_num, bio_flags);
+		ret = submit_one_bio(bio, tree, mirror_num, bio_flags);
 	return ret;
 }
 
@@ -3591,7 +3592,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 					 page, sector, iosize, pg_offset,
 					 bdev, &epd->bio, max_nr,
 					 end_bio_extent_writepage,
-					 0, 0, 0, false);
+					 0, 0, 0, false, NULL);
 		if (ret)
 			SetPageError(page);
 
@@ -3774,9 +3775,8 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 	}
 }
 
-static void set_btree_ioerr(struct page *page)
+static void set_btree_ioerr(struct extent_buffer *eb)
 {
-	struct extent_buffer *eb = (struct extent_buffer *)page->private;
 	struct btrfs_fs_info *fs_info = eb->eb_info->fs_info;
 
 	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
@@ -3837,19 +3837,23 @@ static void set_btree_ioerr(struct page *page)
 static void end_bio_extent_buffer_writepage(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	struct extent_buffer *eb;
+	struct extent_buffer *eb = bio->bi_private;
+	u32 nodesize = eb->len;
 	int i, done;
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		eb = (struct extent_buffer *)page->private;
-		BUG_ON(!eb);
+		if (nodesize >= PAGE_SIZE) {
+			eb = (struct extent_buffer *)page->private;
+			BUG_ON(!eb);
+		}
+
 		done = atomic_dec_and_test(&eb->io_pages);
 
 		if (bio->bi_error ||
 		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
-			set_btree_ioerr(page);
+			set_btree_ioerr(eb);
 
 		account_metadata_end_writeback(page,
 					       &eb->eb_info->fs_info->bdi);
@@ -3871,6 +3875,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	u64 offset = eb->start;
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
+	size_t len;
 	int write_flags = (epd->sync_io ? WRITE_SYNC : 0) | REQ_META;
 	int ret = 0;
 
@@ -3880,27 +3885,33 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 		bio_flags = EXTENT_BIO_TREE_LOG;
 
+	len = min_t(size_t, eb->len, PAGE_SIZE);
+
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
 
 		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
-					 p, offset >> 9, PAGE_SIZE, 0, bdev,
-					 &epd->bio, -1,
+					 p, offset >> 9, len, eb->pg_offset,
+					 bdev, &epd->bio, -1,
 					 end_bio_extent_buffer_writepage,
-					 0, epd->bio_flags, bio_flags, false);
+					 0, epd->bio_flags, bio_flags, false,
+					 eb);
 		epd->bio_flags = bio_flags;
 		if (ret) {
-			set_btree_ioerr(p);
+			set_btree_ioerr(eb);
 			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
 				end_extent_buffer_writeback(eb);
 			ret = -EIO;
 			break;
 		}
 		account_metadata_writeback(p, &fs_info->bdi);
-		offset += PAGE_SIZE;
+		offset += len;
 		update_nr_written(p, wbc, 1);
 	}
 
+	if (!ret && len < PAGE_SIZE)
+		flush_write_bio(epd);
+
 	return ret;
 }
 
@@ -3964,7 +3975,7 @@ repeat:
 	}
 	rcu_read_unlock();
 	if (ret)
-		*index = (ebs[ret - 1]->start >> PAGE_SHIFT) + 1;
+		*index = ebs[ret - 1]->start + 1;
 	return ret;
 }
 
@@ -3997,8 +4008,8 @@ static int btree_write_cache_pages(struct btrfs_fs_info *fs_info,
 		index = eb_info->writeback_index; /* Start from prev offset */
 		end = -1;
 	} else {
-		index = wbc->range_start >> PAGE_SHIFT;
-		end = wbc->range_end >> PAGE_SHIFT;
+		index = wbc->range_start;
+		end = wbc->range_end;
 		scanned = 1;
 	}
 	if (wbc->sync_mode == WB_SYNC_ALL)
@@ -4097,19 +4108,18 @@ int btree_write_range(struct btrfs_fs_info *fs_info, u64 start, u64 end)
 int btree_wait_range(struct btrfs_fs_info *fs_info, u64 start, u64 end)
 {
 	struct extent_buffer *ebs[EBVEC_SIZE];
-	pgoff_t index = start >> PAGE_SHIFT;
-	pgoff_t end_index = end >> PAGE_SHIFT;
 	unsigned nr_ebs;
 	int ret = 0;
 
 	if (end < start)
 		return ret;
 
-	while ((index <= end) &&
-	       (nr_ebs = eb_lookup_tag(fs_info->eb_info, ebs, &index,
+	while ((start <= end) &&
+		(nr_ebs = eb_lookup_tag(fs_info->eb_info, ebs,
+				       (pgoff_t *)&start,
 				       PAGECACHE_TAG_WRITEBACK,
-				       min(end_index - index,
-					   (pgoff_t)EBVEC_SIZE-1) + 1)) != 0) {
+				       min_t(u64, end - start,
+					     EBVEC_SIZE-1) + 1)) != 0) {
 		unsigned i;
 
 		for (i = 0; i < nr_ebs; i++) {
@@ -4296,7 +4306,7 @@ static void flush_epd_write_bio(struct extent_page_data *epd)
 		bio_set_op_attrs(epd->bio, REQ_OP_WRITE,
 				 epd->sync_io ? WRITE_SYNC : 0);
 
-		ret = submit_one_bio(epd->bio, 0, epd->bio_flags);
+		ret = submit_one_bio(epd->bio, epd->tree, 0, epd->bio_flags);
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
@@ -4436,7 +4446,7 @@ int extent_readpages(struct extent_io_tree *tree,
 
 	BUG_ON(!list_empty(pages));
 	if (bio)
-		return submit_one_bio(bio, 0, bio_flags);
+		return submit_one_bio(bio, tree, 0, bio_flags);
 	return 0;
 }
 
@@ -4818,6 +4828,12 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 		return;
 
 	ASSERT(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+
+	if (test_bit(EXTENT_BUFFER_MEM, &eb->bflags)) {
+		kfree(eb->addr);
+		return;
+	}
+
 	do {
 		index--;
 		page = eb->pages[index];
@@ -4925,12 +4941,35 @@ struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_eb_info *eb_info,
 	if (!eb)
 		return NULL;
 
+	if (len < PAGE_SIZE) {
+		eb->addr = kmalloc(len, GFP_NOFS);
+		if (!eb->addr)
+			goto err;
+
+		if (((unsigned long)(eb->addr + len - 1) & PAGE_MASK) !=
+		    ((unsigned long)eb->addr & PAGE_MASK)) {
+			/* eb->addr spans two pages - use alloc_page instead */
+			kfree(eb->addr);
+			eb->addr = NULL;
+			goto use_alloc_page;
+		}
+
+		set_bit(EXTENT_BUFFER_MEM, &eb->bflags);
+		eb->pg_offset = offset_in_page(eb->addr);
+		eb->pages[0] = virt_to_page(eb->addr);
+		goto init_eb;
+	}
+
+use_alloc_page:
+
 	for (i = 0; i < num_pages; i++) {
 		eb->pages[i] = alloc_page(GFP_NOFS);
 		if (!eb->pages[i])
 			goto err;
 		attach_extent_buffer_page(eb, eb->pages[i]);
 	}
+
+init_eb:
 	set_extent_buffer_uptodate(eb);
 	btrfs_set_header_nritems(eb, 0);
 	set_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
@@ -4996,8 +5035,7 @@ struct extent_buffer *find_extent_buffer(struct btrfs_eb_info *eb_info,
 	struct extent_buffer *eb;
 
 	rcu_read_lock();
-	eb = radix_tree_lookup(&eb_info->buffer_radix,
-			       start >> PAGE_SHIFT);
+	eb = radix_tree_lookup(&eb_info->buffer_radix, start);
 	if (eb && atomic_inc_not_zero(&eb->refs)) {
 		rcu_read_unlock();
 		/*
@@ -5046,8 +5084,7 @@ again:
 	if (ret)
 		goto free_eb;
 	spin_lock_irq(&eb_info->buffer_lock);
-	ret = radix_tree_insert(&eb_info->buffer_radix,
-				start >> PAGE_SHIFT, eb);
+	ret = radix_tree_insert(&eb_info->buffer_radix, start, eb);
 	spin_unlock_irq(&eb_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
@@ -5102,6 +5139,29 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (!eb)
 		return ERR_PTR(-ENOMEM);
 
+	if (len < PAGE_SIZE) {
+		eb->addr = kmalloc(len, GFP_NOFS);
+		if (!eb->addr) {
+			exists = ERR_PTR(-ENOMEM);
+			goto free_eb;
+		}
+
+		if (((unsigned long)(eb->addr + len - 1) & PAGE_MASK) !=
+		    ((unsigned long)eb->addr & PAGE_MASK)) {
+			/* eb->addr spans two pages - use alloc_page instead */
+			kfree(eb->addr);
+			eb->addr = NULL;
+			goto use_alloc_page;
+		}
+
+		set_bit(EXTENT_BUFFER_MEM, &eb->bflags);
+		eb->pg_offset = offset_in_page(eb->addr);
+		eb->pages[0] = virt_to_page(eb->addr);
+		goto insert_into_tree;
+	}
+
+use_alloc_page:
+
 	for (i = 0; i < num_pages; i++) {
 		p = alloc_page(GFP_NOFS|__GFP_NOFAIL);
 		if (!p) {
@@ -5124,7 +5184,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		attach_extent_buffer_page(eb, p);
 		eb->pages[i] = p;
 	}
-again:
+insert_into_tree:
 	ret = radix_tree_preload(GFP_NOFS);
 	if (ret) {
 		exists = ERR_PTR(ret);
@@ -5132,8 +5192,7 @@ again:
 	}
 
 	spin_lock_irq(&eb_info->buffer_lock);
-	ret = radix_tree_insert(&eb_info->buffer_radix,
-				start >> PAGE_SHIFT, eb);
+	ret = radix_tree_insert(&eb_info->buffer_radix, start, eb);
 	spin_unlock_irq(&eb_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
@@ -5141,7 +5200,7 @@ again:
 		if (exists)
 			goto free_eb;
 		else
-			goto again;
+			goto insert_into_tree;
 	}
 	/* add one reference for the tree */
 	check_buffer_tree_ref(eb);
@@ -5412,7 +5471,9 @@ int extent_buffer_uptodate(struct extent_buffer *eb)
 static void end_bio_extent_buffer_readpage(struct bio *bio)
 {
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
-	struct extent_io_tree *tree = NULL;
+	struct extent_buffer *eb = bio->bi_private;
+	struct btrfs_eb_info *eb_info = eb->eb_info;
+	struct extent_io_tree *tree = &eb_info->io_tree;
 	struct bio_vec *bvec;
 	u64 unlock_start = 0, unlock_len = 0;
 	int mirror_num = io_bio->mirror_num;
@@ -5421,16 +5482,7 @@ static void end_bio_extent_buffer_readpage(struct bio *bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
-		struct btrfs_eb_info *eb_info;
-		struct extent_buffer *eb;
-
-		eb = (struct extent_buffer *)page->private;
-		if (WARN_ON(!eb))
-			continue;
 
-		eb_info = eb->eb_info;
-		if (!tree)
-			tree = &eb_info->io_tree;
 		if (uptodate) {
 			/*
 			 * btree_readpage_end_io_hook doesn't care about
@@ -5454,7 +5506,8 @@ static void end_bio_extent_buffer_readpage(struct bio *bio)
 				}
 				clean_io_failure(eb_info->fs_info,
 						 &eb_info->io_failure_tree,
-						 tree, start, page, 0, 0);
+						 tree, start, page, 0,
+						 eb->pg_offset);
 			}
 		}
 		/*
@@ -5464,11 +5517,12 @@ static void end_bio_extent_buffer_readpage(struct bio *bio)
 		 * anything.
 		 */
 		if (!uptodate)
-			tree->ops->readpage_io_failed_hook(page, mirror_num);
+			tree->ops->readpage_io_failed_hook(page, eb,
+							mirror_num);
 
 		if (unlock_start == 0) {
 			unlock_start = eb->start;
-			unlock_len = PAGE_SIZE;
+			unlock_len = min(eb->len, PAGE_SIZE);
 		} else {
 			unlock_len += PAGE_SIZE;
 		}
@@ -5493,6 +5547,7 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
 	u64 unlock_start = 0, unlock_len = 0;
 	unsigned long i;
 	struct page *page;
+	size_t len;
 	int err;
 	int ret = 0;
 	unsigned long num_pages;
@@ -5515,10 +5570,13 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
 	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = 0;
 	atomic_set(&eb->io_pages, num_pages);
+
+	len = min_t(size_t, eb->len, PAGE_SIZE);
+
 	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 		if (ret) {
-			unlock_len += PAGE_SIZE;
+			unlock_len += len;
 			if (atomic_dec_and_test(&eb->io_pages)) {
 				clear_bit(EXTENT_BUFFER_READING, &eb->bflags);
 				smp_mb__after_atomic();
@@ -5528,10 +5586,10 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
 		}
 
 		err = submit_extent_page(REQ_OP_READ, REQ_META, io_tree, NULL,
-					 page, offset >> 9, PAGE_SIZE, 0, bdev,
-					 &bio, -1,
+					 page, offset >> 9, len, eb->pg_offset,
+					 bdev, &bio, -1,
 					 end_bio_extent_buffer_readpage,
-					 mirror_num, 0, 0, false);
+					 mirror_num, 0, 0, false, eb);
 		if (err) {
 			ret = err;
 			/*
@@ -5548,13 +5606,13 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
 				wake_up_bit(&eb->bflags, EXTENT_BUFFER_READING);
 			}
 			unlock_start = offset;
-			unlock_len = PAGE_SIZE;
+			unlock_len = len;
 		}
-		offset += PAGE_SIZE;
+		offset += len;
 	}
 
 	if (bio) {
-		err = submit_one_bio(bio, mirror_num, 0);
+		err = submit_one_bio(bio, io_tree, mirror_num, 0);
 		if (err)
 			return err;
 	}
@@ -5581,7 +5639,7 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	struct page *page;
 	char *kaddr;
 	char *dst = (char *)dstv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = eb->pg_offset;
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 
 	WARN_ON(start > eb->len);
@@ -5612,7 +5670,7 @@ int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dstv,
 	struct page *page;
 	char *kaddr;
 	char __user *dst = (char __user *)dstv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = eb->pg_offset;
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 	int ret = 0;
 
@@ -5650,10 +5708,10 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 			       unsigned long *map_start,
 			       unsigned long *map_len)
 {
-	size_t offset = start & (PAGE_SIZE - 1);
+	size_t offset;
 	char *kaddr;
 	struct page *p;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = eb->pg_offset;
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 	unsigned long end_i = (start_offset + start + min_len - 1) >>
 		PAGE_SHIFT;
@@ -5679,7 +5737,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	p = eb->pages[i];
 	kaddr = page_address(p);
 	*map = kaddr + offset;
-	*map_len = PAGE_SIZE - offset;
+	*map_len = (eb->len >= PAGE_SIZE) ? PAGE_SIZE - offset : eb->len;
 	return 0;
 }
 
@@ -5692,7 +5750,7 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 	struct page *page;
 	char *kaddr;
 	char *ptr = (char *)ptrv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = eb->pg_offset;
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 	int ret = 0;
 
@@ -5727,7 +5785,7 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 	struct page *page;
 	char *kaddr;
 	char *src = (char *)srcv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = eb->pg_offset;
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 
 	WARN_ON(start > eb->len);
@@ -5756,7 +5814,7 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 	size_t offset;
 	struct page *page;
 	char *kaddr;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = eb->pg_offset;
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 
 	WARN_ON(start > eb->len);
@@ -5786,7 +5844,7 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	size_t offset;
 	struct page *page;
 	char *kaddr;
-	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = dst->pg_offset;
 	unsigned long i = (start_offset + dst_offset) >> PAGE_SHIFT;
 
 	WARN_ON(src->len != dst_len);
@@ -5839,7 +5897,7 @@ static inline void eb_bitmap_offset(struct extent_buffer *eb,
 				    unsigned long *page_index,
 				    size_t *page_offset)
 {
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = eb->pg_offset;
 	size_t byte_offset = BIT_BYTE(nr);
 	size_t offset;
 
@@ -5987,7 +6045,7 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	size_t cur;
 	size_t dst_off_in_page;
 	size_t src_off_in_page;
-	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = dst->pg_offset;
 	unsigned long dst_i;
 	unsigned long src_i;
 
@@ -6035,7 +6093,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	size_t src_off_in_page;
 	unsigned long dst_end = dst_offset + len - 1;
 	unsigned long src_end = src_offset + len - 1;
-	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = dst->pg_offset;
 	unsigned long dst_i;
 	unsigned long src_i;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e7a0462..6a02343 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -45,6 +45,7 @@
 #define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
 #define EXTENT_BUFFER_MIXED_PAGES 12	/* the pages span multiple zones or numa nodes. */
 #define EXTENT_BUFFER_READING 13 /* currently reading this eb. */
+#define EXTENT_BUFFER_MEM 14
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define PAGE_UNLOCK		(1 << 0)
@@ -138,7 +139,8 @@ struct extent_io_ops {
 	int (*merge_bio_hook)(struct page *page, unsigned long offset,
 			      size_t size, struct bio *bio,
 			      unsigned long bio_flags);
-	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
+	int (*readpage_io_failed_hook)(struct page *page, void *private,
+				int failed_mirror);
 	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
@@ -234,6 +236,8 @@ struct extent_buffer {
 	 */
 	wait_queue_head_t read_lock_wq;
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
+	void *addr;
+	unsigned int pg_offset;
 #ifdef CONFIG_BTRFS_DEBUG
 	struct list_head leak_list;
 #endif
@@ -454,7 +458,7 @@ static inline void extent_buffer_get(struct extent_buffer *eb)
 
 static inline unsigned long eb_index(struct extent_buffer *eb)
 {
-	return eb->start >> PAGE_SHIFT;
+	return eb->start;
 }
 
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 45524f1..b85a57e 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -379,7 +379,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	 * In ppc64, sectorsize can be 64K, thus 4 * 64K will be larger than
 	 * BTRFS_MAX_METADATA_BLOCKSIZE.
 	 */
-	len = (sectorsize < BTRFS_MAX_METADATA_BLOCKSIZE)
+	len = ((sectorsize * 4) <= BTRFS_MAX_METADATA_BLOCKSIZE)
 		? sectorsize * 4 : sectorsize;
 
 	bitmap = kmalloc(len, GFP_KERNEL);
@@ -401,7 +401,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 
 	/* Do it over again with an extent buffer which isn't page-aligned. */
 	free_extent_buffer(eb);
-	eb = alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
+	eb = alloc_dummy_extent_buffer(NULL, PAGE_SIZE / 2, len);
 	if (!eb) {
 		test_msg("Couldn't allocate test extent buffer\n");
 		kfree(bitmap);
-- 
2.5.5

