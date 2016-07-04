Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43561 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbcGDEf2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:35:28 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644XhNR138456
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:35:28 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23x6ghjtsa-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:35:27 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:35:24 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 06/19] Btrfs: subpage-blocksize: Write only dirty extent buffers belonging to a page
Date: Mon,  4 Jul 2016 10:04:26 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-7-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the subpage-blocksize scenario, this patch adds the ability to write
a single extent buffer to the disk.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c   |  32 +++---
 fs/btrfs/extent_io.c | 277 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 242 insertions(+), 67 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b09d3e3..2d9e86b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -504,28 +504,30 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 
 static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 {
-	u64 start = page_offset(page);
-	u64 found_start;
 	struct extent_buffer *eb;
+	u64 found_start;
+	int ret;
 
 	eb = (struct extent_buffer *)page->private;
 	if (page != eb_head(eb)->pages[0])
 		return 0;
 
-	found_start = btrfs_header_bytenr(eb);
-	/*
-	 * Please do not consolidate these warnings into a single if.
-	 * It is useful to know what went wrong.
-	 */
-	if (WARN_ON(found_start != start))
-		return -EUCLEAN;
-	if (WARN_ON(!PageUptodate(page)))
-		return -EUCLEAN;
-
-	ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
-			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
+	do {
+		if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags))
+			continue;
+		if (WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags)))
+			continue;
+		found_start = btrfs_header_bytenr(eb);
+		if (WARN_ON(found_start != eb->start))
+			return 0;
+		ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
+				btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
+		ret = csum_tree_block(fs_info, eb, 0);
+		if (ret)
+			return ret;
+	} while ((eb = eb->eb_next) != NULL);
 
-	return csum_tree_block(fs_info, eb, 0);
+	return 0;
 }
 
 static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a425f90..2b5fc13 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3724,29 +3724,49 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 		    TASK_UNINTERRUPTIBLE);
 }
 
-static noinline_for_stack int
-lock_extent_buffer_for_io(struct extent_buffer *eb,
-			  struct btrfs_fs_info *fs_info,
-			  struct extent_page_data *epd)
+static void lock_extent_buffer_pages(struct extent_buffer_head *ebh,
+				struct extent_page_data *epd)
 {
+	struct extent_buffer *eb = &ebh->eb;
 	unsigned long i, num_pages;
-	int flush = 0;
+
+	num_pages = num_extent_pages(eb->start, eb->len);
+	for (i = 0; i < num_pages; i++) {
+		struct page *p = ebh->pages[i];
+		if (!trylock_page(p)) {
+			flush_write_bio(epd);
+			lock_page(p);
+		}
+	}
+
+	return;
+}
+
+static int noinline_for_stack
+lock_extent_buffer_for_io(struct extent_buffer *eb,
+			struct btrfs_fs_info *fs_info,
+			struct extent_page_data *epd)
+{
+	int dirty;
 	int ret = 0;
 
 	if (!btrfs_try_tree_write_lock(eb)) {
-		flush = 1;
 		flush_write_bio(epd);
 		btrfs_tree_lock(eb);
 	}
 
 	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags)) {
+		dirty = test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
 		btrfs_tree_unlock(eb);
-		if (!epd->sync_io)
-			return 0;
-		if (!flush) {
-			flush_write_bio(epd);
-			flush = 1;
+		if (!epd->sync_io) {
+			if (!dirty)
+				return 1;
+			else
+				return 2;
 		}
+
+		flush_write_bio(epd);
+
 		while (1) {
 			wait_on_extent_buffer_writeback(eb);
 			btrfs_tree_lock(eb);
@@ -3769,29 +3789,14 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		__percpu_counter_add(&fs_info->dirty_metadata_bytes,
 				     -eb->len,
 				     fs_info->dirty_metadata_batch);
-		ret = 1;
+		ret = 0;
 	} else {
 		spin_unlock(&eb_head(eb)->refs_lock);
+		ret = 1;
 	}
 
 	btrfs_tree_unlock(eb);
 
-	if (!ret)
-		return ret;
-
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++) {
-		struct page *p = eb_head(eb)->pages[i];
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
 	return ret;
 }
 
@@ -3876,9 +3881,8 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 	wake_up_bit(&eb->ebflags, EXTENT_BUFFER_WRITEBACK);
 }
 
-static void set_btree_ioerr(struct page *page)
+static void set_btree_ioerr(struct extent_buffer *eb, struct page *page)
 {
-	struct extent_buffer *eb = (struct extent_buffer *)page->private;
 	struct extent_buffer_head *ebh = eb_head(eb);
 	struct btrfs_inode *btree_ino = BTRFS_I(ebh->fs_info->btree_inode);
 
@@ -3939,7 +3943,8 @@ static void set_btree_ioerr(struct page *page)
 	}
 }
 
-static void end_bio_extent_buffer_writepage(struct bio *bio)
+
+static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	struct extent_buffer *eb;
@@ -3947,15 +3952,58 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
+		u64 start, end;
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
+
+		do {
+			if (!(eb->start >= start
+					&& (eb->start + eb->len) <= (end + 1))) {
+				continue;
+			}
+
+			done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
+
+			if (bio->bi_error
+				|| test_bit(EXTENT_BUFFER_WRITE_ERR,
+					&eb->ebflags)) {
+				ClearPageUptodate(page);
+				set_btree_ioerr(eb, page);
+			}
+
+			if (done)
+				end_page_writeback(page);
+
+			end_extent_buffer_writeback(eb);
+
+		} while ((eb = eb->eb_next) != NULL);
+
+	}
+
+	bio_put(bio);
+}
+
+static void end_bio_regular_ebh_writepage(struct bio *bio)
+{
+	struct extent_buffer *eb;
+	struct bio_vec *bvec;
+	int i, done;
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
+
+		eb = (struct extent_buffer *)page->private;
+		BUG_ON(!eb);
+
 		done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
 
 		if (bio->bi_error ||
 		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags)) {
 			ClearPageUptodate(page);
-			set_btree_ioerr(page);
+			set_btree_ioerr(eb, page);
 		}
 
 		end_page_writeback(page);
@@ -3969,14 +4017,17 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 	bio_put(bio);
 }
 
-static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
-			struct btrfs_fs_info *fs_info,
-			struct writeback_control *wbc,
-			struct extent_page_data *epd)
+
+static noinline_for_stack int
+write_regular_ebh(struct extent_buffer_head *ebh,
+		struct btrfs_fs_info *fs_info,
+		struct writeback_control *wbc,
+		struct extent_page_data *epd)
 {
 	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
 	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
-	u64 offset = eb->start;
+	struct extent_buffer *eb = &ebh->eb;
+	u64 offset = eb->start & ~(PAGE_SIZE - 1);
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
@@ -3995,11 +4046,11 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		set_page_writeback(p);
 		ret = submit_extent_page(rw, tree, wbc, p, offset >> 9,
 					 PAGE_SIZE, 0, bdev, &epd->bio,
-					 -1, end_bio_extent_buffer_writepage,
-					 0, epd->bio_flags, bio_flags, false);
+					-1, end_bio_regular_ebh_writepage,
+					0, epd->bio_flags, bio_flags, false);
 		epd->bio_flags = bio_flags;
 		if (ret) {
-			set_btree_ioerr(p);
+			set_btree_ioerr(eb, p);
 			end_page_writeback(p);
 			if (atomic_sub_and_test(num_pages - i,
 							&eb_head(eb)->io_bvecs))
@@ -4023,12 +4074,84 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	return ret;
 }
 
+static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
+					struct btrfs_fs_info *fs_info,
+					struct writeback_control *wbc,
+					struct extent_page_data *epd,
+					unsigned long ebs_to_write)
+{
+	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
+	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
+	struct extent_buffer *eb;
+	struct page *p;
+	u64 offset;
+	unsigned long i;
+	unsigned long bio_flags = 0;
+	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
+	int ret = 0, err = 0;
+
+	eb = &ebh->eb;
+	p = ebh->pages[0];
+	clear_page_dirty_for_io(p);
+	set_page_writeback(p);
+	i = 0;
+	do {
+		if (!test_bit(i++, &ebs_to_write))
+			continue;
+
+		clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags);
+		atomic_inc(&eb_head(eb)->io_bvecs);
+
+		if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
+			bio_flags = EXTENT_BIO_TREE_LOG;
+
+		offset = eb->start - page_offset(p);
+
+		ret = submit_extent_page(rw, tree, wbc, p, eb->start >> 9,
+					eb->len, offset,
+					bdev, &epd->bio, -1,
+					end_bio_subpagesize_blocksize_ebh_writepage,
+					0, epd->bio_flags, bio_flags, false);
+		epd->bio_flags = bio_flags;
+		if (ret) {
+			set_btree_ioerr(eb, p);
+			atomic_dec(&eb_head(eb)->io_bvecs);
+			end_extent_buffer_writeback(eb);
+			err = -EIO;
+		}
+	} while ((eb = eb->eb_next) != NULL);
+
+	if (!err) {
+		update_nr_written(p, wbc, 1);
+	}
+
+	unlock_page(p);
+
+	return ret;
+}
+
+static void redirty_extent_buffer_pages_for_writepage(struct extent_buffer *eb,
+						struct writeback_control *wbc)
+{
+	unsigned long i, num_pages;
+	struct page *p;
+
+	num_pages = num_extent_pages(eb->start, eb->len);
+	for (i = 0; i < num_pages; i++) {
+		p = eb_head(eb)->pages[i];
+		redirty_page_for_writepage(wbc, p);
+	}
+
+	return;
+}
+
 int btree_write_cache_pages(struct address_space *mapping,
-				   struct writeback_control *wbc)
+			struct writeback_control *wbc)
 {
 	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
 	struct btrfs_fs_info *fs_info = BTRFS_I(mapping->host)->root->fs_info;
-	struct extent_buffer *eb, *prev_eb = NULL;
+	struct extent_buffer *eb;
+	struct extent_buffer_head *ebh, *prev_ebh = NULL;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = tree,
@@ -4039,6 +4162,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 	int ret = 0;
 	int done = 0;
 	int nr_to_write_done = 0;
+	unsigned long ebs_to_write, dirty_ebs;
 	struct pagevec pvec;
 	int nr_pages;
 	pgoff_t index;
@@ -4065,7 +4189,7 @@ retry:
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
+		unsigned i, j;
 
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
@@ -4097,30 +4221,79 @@ retry:
 				continue;
 			}
 
-			if (eb == prev_eb) {
+			ebh = eb_head(eb);
+			if (ebh == prev_ebh) {
 				spin_unlock(&mapping->private_lock);
 				continue;
 			}
 
-			ret = atomic_inc_not_zero(&eb_head(eb)->refs);
+			ret = atomic_inc_not_zero(&ebh->refs);
 			spin_unlock(&mapping->private_lock);
 			if (!ret)
 				continue;
 
-			prev_eb = eb;
-			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
-			if (!ret) {
-				free_extent_buffer(eb);
+			prev_ebh = ebh;
+
+			j = 0;
+			ebs_to_write = dirty_ebs = 0;
+			eb = &ebh->eb;
+			do {
+				BUG_ON(j >= BITS_PER_LONG);
+
+				ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
+				switch (ret) {
+				case 0:
+					/*
+					  EXTENT_BUFFER_DIRTY was set and we were able to
+					  clear it.
+					*/
+					set_bit(j, &ebs_to_write);
+					break;
+				case 2:
+					/*
+					  EXTENT_BUFFER_DIRTY was set, but we were unable
+					  to clear EXTENT_BUFFER_WRITEBACK that was set
+					  before we got the extent buffer locked.
+					 */
+					set_bit(j, &dirty_ebs);
+				default:
+					/*
+					  EXTENT_BUFFER_DIRTY wasn't set.
+					 */
+					break;
+				}
+				++j;
+			} while ((eb = eb->eb_next) != NULL);
+
+			ret = 0;
+
+			if (!ebs_to_write) {
+				free_extent_buffer(&ebh->eb);
 				continue;
 			}
 
-			ret = write_one_eb(eb, fs_info, wbc, &epd);
+			/*
+			  Now that we know that atleast one of the extent buffer
+			  belonging to the extent buffer head must be written to
+			  the disk, lock the extent_buffer_head's pages.
+			 */
+			lock_extent_buffer_pages(ebh, &epd);
+
+			if (ebh->eb.len < PAGE_SIZE) {
+				ret = write_subpagesize_blocksize_ebh(ebh, fs_info, wbc, &epd, ebs_to_write);
+				if (dirty_ebs) {
+					redirty_extent_buffer_pages_for_writepage(&ebh->eb, wbc);
+				}
+			} else {
+				ret = write_regular_ebh(ebh, fs_info, wbc, &epd);
+			}
+
 			if (ret) {
 				done = 1;
-				free_extent_buffer(eb);
+				free_extent_buffer(&ebh->eb);
 				break;
 			}
-			free_extent_buffer(eb);
+			free_extent_buffer(&ebh->eb);
 
 			/*
 			 * the filesystem may choose to bump up nr_to_write.
-- 
2.5.5

