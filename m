Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44413 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaG2LOX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:14:23 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 16:44:21 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 09260E004B
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:46:05 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6TBEER448824506
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:14 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6TBEIaA013009
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:19 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V5 05/12] Btrfs: subpagesize-blocksize: Read tree blocks whose size is <PAGE_CACHE_SIZE.
Date: Tue, 29 Jul 2014 16:43:40 +0530
Message-Id: <1406632427-2209-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the case of subpagesize-blocksize, this patch makes it possible to read
only a single metadata block from the disk instead of all the metadata blocks
that map into a page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c   |  45 ++++++++---------
 fs/btrfs/disk-io.h   |   3 ++
 fs/btrfs/extent_io.c | 135 +++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 137 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bda2157..b2c4e9d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -413,7 +413,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	int mirror_num = 0;
 	int failed_mirror = 0;
 
-	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags);
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	while (1) {
 		ret = read_extent_buffer_pages(io_tree, eb, start,
@@ -432,7 +432,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		 * there is no reason to read the other copies, they won't be
 		 * any less wrong.
 		 */
-		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
+		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags))
 			break;
 
 		num_copies = btrfs_num_copies(root->fs_info,
@@ -564,12 +564,13 @@ static noinline int check_leaf(struct btrfs_root *root,
 	return 0;
 }
 
-static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
-				      u64 phy_offset, struct page *page,
-				      u64 start, u64 end, int mirror)
+int verify_extent_buffer_read(struct btrfs_io_bio *io_bio,
+			struct page *page,
+			u64 start, u64 end, int mirror)
 {
 	u64 found_start;
 	int found_level;
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	int ret = 0;
@@ -579,18 +580,26 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		goto out;
 
 	eb = (struct extent_buffer *)page->private;
+	do {
+		if ((eb->start <= start) && (eb->start + eb->len - 1 > start))
+			break;
+	} while ((eb = eb->eb_next) != NULL);
+
+	BUG_ON(!eb);
+
+	ebh = eb_head(eb);
 
 	/* the pending IO might have been the only thing that kept this buffer
 	 * in memory.  Make sure we have a ref for all this other checks
 	 */
 	extent_buffer_get(eb);
 
-	reads_done = atomic_dec_and_test(&eb->io_pages);
+	reads_done = atomic_dec_and_test(&ebh->io_bvecs);
 	if (!reads_done)
 		goto err;
 
 	eb->read_mirror = mirror;
-	if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_IOERR, &eb->ebflags)) {
 		ret = -EIO;
 		goto err;
 	}
@@ -632,7 +641,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 * return -EIO.
 	 */
 	if (found_level == 0 && check_leaf(root, eb)) {
-		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+		set_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags);
 		ret = -EIO;
 	}
 
@@ -640,7 +649,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		set_extent_buffer_uptodate(eb);
 err:
 	if (reads_done &&
-	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
+	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
 		btree_readahead_hook(root, eb, eb->start, ret);
 
 	if (ret) {
@@ -649,7 +658,7 @@ err:
 		 * again, we have to make sure it has something
 		 * to decrement
 		 */
-		atomic_inc(&eb->io_pages);
+		atomic_inc(&eb_head(eb)->io_bvecs);
 		clear_extent_buffer_uptodate(eb);
 	}
 	free_extent_buffer(eb);
@@ -657,20 +666,6 @@ out:
 	return ret;
 }
 
-static int btree_io_failed_hook(struct page *page, int failed_mirror)
-{
-	struct extent_buffer *eb;
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
-
-	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb->io_pages);
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-		btree_readahead_hook(root, eb, eb->start, -EIO);
-	return -EIO;	/* we fixed nothing */
-}
-
 static void end_workqueue_bio(struct bio *bio, int err)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
@@ -4109,8 +4104,6 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 }
 
 static struct extent_io_ops btree_extent_io_ops = {
-	.readpage_end_io_hook = btree_readpage_end_io_hook,
-	.readpage_io_failed_hook = btree_io_failed_hook,
 	.submit_bio_hook = btree_submit_bio_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 53059df..678a09b 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -110,6 +110,9 @@ static inline void btrfs_put_fs_root(struct btrfs_root *root)
 		kfree(root);
 }
 
+int verify_extent_buffer_read(struct btrfs_io_bio *io_bio,
+			struct page *page,
+			u64 start, u64 end, int mirror);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fa7a024..58511f3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -14,6 +14,7 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "ctree.h"
+#include "disk-io.h"
 #include "btrfs_inode.h"
 #include "volumes.h"
 #include "check-integrity.h"
@@ -2120,7 +2121,7 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
-		ret = repair_io_failure(root->fs_info, start, PAGE_CACHE_SIZE,
+		ret = repair_io_failure(root->fs_info, start, eb->len,
 					start, p, mirror_num);
 		if (ret)
 			break;
@@ -3463,17 +3464,88 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
+static void end_bio_extent_buffer_readpage(struct bio *bio, int err)
+{
+	struct address_space *mapping = bio->bi_io_vec->bv_page->mapping;
+	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec = bio->bi_io_vec;
+	struct extent_buffer *eb;
+	struct page *page = bvec->bv_page;
+	struct btrfs_root *root;
+	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	u64 start;
+	u64 end;
+	int mirror;
+	int ret;
 
-		if (!trylock_page(p)) {
-			if (!flush) {
-				flush_write_bio(epd);
-				flush = 1;
-			}
-			lock_page(p);
+	root = BTRFS_I(page->mapping->host)->root;
+
+	if (err)
+		uptodate = 0;
+
+	do {
+		page = bvec->bv_page;
+
+		if (!page->private) {
+			SetPageUptodate(page);
+			goto unlock;
 		}
-	}
 
-	return ret;
+		eb = (struct extent_buffer *)page->private;
+
+		start = io_bio->start_offset;
+		end = start + io_bio->len - 1;
+
+		do {
+			/*
+			  read_extent_buffer_pages() does not start
+			  I/O on PG_uptodate pages. Hence the bio may
+			  map only part of the extent buffer.
+			 */
+			if ((eb->start <= start) && (eb->start + eb->len - 1 > start))
+				break;
+		} while ((eb = eb->eb_next) != NULL);
+
+		BUG_ON(!eb);
+
+		mirror = io_bio->mirror_num;
+
+		if (uptodate) {
+			ret = verify_extent_buffer_read(io_bio, page, start,
+							end, mirror);
+			if (ret)
+				uptodate = 0;
+		}
+
+		if (!uptodate) {
+			set_bit(EXTENT_BUFFER_IOERR, &eb->ebflags);
+			eb->read_mirror = mirror;
+			atomic_dec(&eb_head(eb)->io_bvecs);
+			if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD,
+						&eb->ebflags))
+				btree_readahead_hook(root, eb, eb->start,
+						-EIO);
+			ClearPageUptodate(page);
+			SetPageError(page);
+			goto unlock;
+		}
+
+unlock:
+		unlock_page(page);
+		++bvec;
+	} while (bvec <= bvec_end);
+
+	/*
+	  We don't need to add a check to see if
+	  extent_io_tree->track_uptodate is set or not, Since
+	  this function only deals with extent buffers.
+	 */
+	unlock_extent(tree, io_bio->start_offset,
+		io_bio->start_offset + io_bio->len - 1);
+
+	bio_put(bio);
 }
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
@@ -4976,6 +5048,9 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, u64 start, int wait,
 			     get_extent_t *get_extent, int mirror_num)
 {
+	struct inode *inode = tree->mapping->host;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct extent_state *cached_state = NULL;
 	unsigned long i;
 	unsigned long start_i;
 	struct page *page;
@@ -4988,7 +5063,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
 
-	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags))
 		return 0;
 
 	if (start) {
@@ -5016,21 +5091,34 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	}
 	if (all_uptodate) {
 		if (start_i == 0)
-			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+			set_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
 		goto unlock_exit;
 	}
 
-	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_IOERR, &eb->ebflags);
 	eb->read_mirror = 0;
-	atomic_set(&eb->io_pages, num_reads);
+	atomic_set(&eb_head(eb)->io_bvecs, num_reads);
+	lock_extent_bits(tree, eb->start, eb->start + eb->len - 1, 0,
+			&cached_state);
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (!PageUptodate(page)) {
 			ClearPageError(page);
-			err = __extent_read_full_page(tree, page,
-						      get_extent, &bio,
-						      mirror_num, &bio_flags,
-						      READ | REQ_META);
+			if (eb->len < PAGE_CACHE_SIZE) {
+				err = submit_extent_page(READ | REQ_META, tree,
+							page, eb->start >> 9,
+							eb->len, eb->start - page_offset(page),
+							fs_info->fs_devices->latest_bdev,
+							&bio, -1, end_bio_extent_buffer_readpage,
+							mirror_num, bio_flags, bio_flags);
+			} else {
+				err = submit_extent_page(READ | REQ_META, tree,
+							page, page_offset(page) >> 9,
+							PAGE_CACHE_SIZE, 0,
+							fs_info->fs_devices->latest_bdev,
+							&bio, -1, end_bio_extent_buffer_readpage,
+							mirror_num, bio_flags, bio_flags);
+			}
 			if (err)
 				ret = err;
 		} else {
@@ -5048,11 +5136,18 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	if (ret || wait != WAIT_COMPLETE)
 		return ret;
 
-	for (i = start_i; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
+	if (eb->len < PAGE_CACHE_SIZE) {
+		page = extent_buffer_page(eb, 0);
 		wait_on_page_locked(page);
-		if (!PageUptodate(page))
+		if (!extent_buffer_uptodate(eb))
 			ret = -EIO;
+	} else {
+		for (i = start_i; i < num_pages; i++) {
+			page = extent_buffer_page(eb, i);
+			wait_on_page_locked(page);
+			if (!PageUptodate(page))
+				ret = -EIO;
+		}
 	}
 
 	return ret;
-- 
1.8.3.1

