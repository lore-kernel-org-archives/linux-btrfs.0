Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36179 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbKPHJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:09:14 -0500
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 12:39:12 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id E5FE8E00A3
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:35 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG78v7h51249380
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:58 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG78uIl027294
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:57 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [RFC PATCH V12 05/14] Btrfs: subpagesize-blocksize: Read tree blocks whose size is < PAGE_SIZE.
Date: Mon, 16 Nov 2015 12:38:32 +0530
Message-Id: <1447657721-10025-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the case of subpagesize-blocksize, this patch makes it possible to read
only a single metadata block from the disk instead of all the metadata blocks
that map into a page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c   |  62 +++++++++++++++++----------
 fs/btrfs/disk-io.h   |   3 ++
 fs/btrfs/extent_io.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 153 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3742ae6..5ba6e38 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -595,28 +595,41 @@ static noinline int check_leaf(struct btrfs_root *root,
 	return 0;
 }
 
-static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
-				      u64 phy_offset, struct page *page,
-				      u64 start, u64 end, int mirror)
+int verify_extent_buffer_read(struct btrfs_io_bio *io_bio,
+			struct page *page,
+			u64 start, u64 end, int mirror)
 {
-	u64 found_start;
-	int found_level;
+	struct address_space *mapping = (io_bio->bio).bi_io_vec->bv_page->mapping;
+	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
-	int ret = 0;
+	unsigned long num_pages;
+	unsigned long i;
+	u64 found_start;
+	int found_level;
 	int reads_done;
+	int ret = 0;
 
 	if (!page->private)
 		goto out;
 
 	eb = (struct extent_buffer *)page->private;
+	do {
+		if ((eb->start <= start) && (eb->start + eb->len - 1 > start))
+			break;
+	} while ((eb = eb->eb_next) != NULL);
+
+	ASSERT(eb);
+
+	ebh = eb_head(eb);
 
 	/* the pending IO might have been the only thing that kept this buffer
 	 * in memory.  Make sure we have a ref for all this other checks
 	 */
 	extent_buffer_get(eb);
 
-	reads_done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
+	reads_done = atomic_dec_and_test(&ebh->io_bvecs);
 	if (!reads_done)
 		goto err;
 
@@ -682,24 +695,31 @@ err:
 		atomic_inc(&eb_head(eb)->io_bvecs);
 		clear_extent_buffer_uptodate(eb);
 	}
+
+	/*
+	  We never read more than one extent buffer from a page at a time.
+	  So unlocking the page here should be fine.
+	 */
+	if (reads_done) {
+		num_pages = num_extent_pages(eb->start, eb->len);
+		for (i = 0; i < num_pages; i++) {
+			page = eb_head(eb)->pages[i];
+			unlock_page(page);
+		}
+
+		/*
+		  We don't need to add a check to see if
+		  extent_io_tree->track_uptodate is set or not, Since
+		  this function only deals with extent buffers.
+		*/
+		unlock_extent(tree, eb->start, eb->start + eb->len - 1);
+	}
+
 	free_extent_buffer(eb);
 out:
 	return ret;
 }
 
-static int btree_io_failed_hook(struct page *page, int failed_mirror)
-{
-	struct extent_buffer *eb;
-	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
-
-	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags);
-	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb_head(eb)->io_bvecs);
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
-		btree_readahead_hook(root, eb, eb->start, -EIO);
-	return -EIO;	/* we fixed nothing */
-}
 
 static void end_workqueue_bio(struct bio *bio)
 {
@@ -4424,8 +4444,6 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 }
 
 static const struct extent_io_ops btree_extent_io_ops = {
-	.readpage_end_io_hook = btree_readpage_end_io_hook,
-	.readpage_io_failed_hook = btree_io_failed_hook,
 	.submit_bio_hook = btree_submit_bio_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index adeb318..e7695e4 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -113,6 +113,9 @@ static inline void btrfs_put_fs_root(struct btrfs_root *root)
 		kfree(root);
 }
 
+int verify_extent_buffer_read(struct btrfs_io_bio *io_bio,
+			struct page *page,
+			u64 start, u64 end, int mirror);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 496a92c..4cea13a 100644
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
@@ -2271,7 +2272,7 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 		struct page *p = eb_head(eb)->pages[i];
 
 		ret = repair_io_failure(root->fs_info->btree_inode, start,
-					PAGE_CACHE_SIZE, start, p,
+					eb->len, start, p,
 					start - page_offset(p), mirror_num);
 		if (ret)
 			break;
@@ -3865,6 +3866,74 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 	return ret;
 }
 
+static void end_bio_extent_buffer_readpage(struct bio *bio)
+{
+	struct address_space *mapping = bio->bi_io_vec->bv_page->mapping;
+	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct extent_buffer *eb;
+	struct btrfs_root *root;
+	struct bio_vec *bvec;
+	struct page *page;
+	int uptodate = !bio->bi_error;
+	u64 start;
+	u64 end;
+	int mirror;
+	int ret;
+	int i;
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		page = bvec->bv_page;
+		root = BTRFS_I(page->mapping->host)->root;
+
+		start = page_offset(page) + bvec->bv_offset;
+		end = start + bvec->bv_len - 1;
+
+		if (!page->private) {
+			unlock_page(page);
+			unlock_extent(tree, start, end);
+			continue;
+		}
+
+		eb = (struct extent_buffer *)page->private;
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
+			set_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags);
+			eb->read_mirror = mirror;
+			atomic_dec(&eb_head(eb)->io_bvecs);
+			if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD,
+						&eb->ebflags))
+				btree_readahead_hook(root, eb, eb->start,
+						-EIO);
+			ClearPageUptodate(page);
+			SetPageError(page);
+		}
+	}
+
+	bio_put(bio);
+}
+
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
 {
 	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags);
@@ -5557,6 +5626,9 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, u64 start, int wait,
 			     get_extent_t *get_extent, int mirror_num)
 {
+	struct inode *inode = tree->mapping->host;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct extent_state *cached_state = NULL;
 	unsigned long i;
 	unsigned long start_i;
 	struct page *page;
@@ -5584,10 +5656,17 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	for (i = start_i; i < num_pages; i++) {
 		page = eb_head(eb)->pages[i];
 		if (wait == WAIT_NONE) {
-			if (!trylock_page(page))
+			if (!trylock_page(page)) {
 				goto unlock_exit;
+			} else {
+				if (PageWriteback(page)) {
+					unlock_page(page);
+					goto unlock_exit;
+				}
+			}
 		} else {
 			lock_page(page);
+			wait_on_page_writeback(page);
 		}
 		locked_pages++;
 		if (!PageUptodate(page)) {
@@ -5608,10 +5687,32 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		page = eb_head(eb)->pages[i];
 		if (!PageUptodate(page)) {
 			ClearPageError(page);
-			err = __extent_read_full_page(tree, page,
-						      get_extent, &bio,
-						      mirror_num, &bio_flags,
-						      READ | REQ_META);
+			if (eb->len < PAGE_CACHE_SIZE) {
+				lock_extent_bits(tree, eb->start, eb->start + eb->len - 1, 0,
+							&cached_state);
+				err = submit_extent_page(READ | REQ_META, tree,
+							NULL, page,
+							eb->start >> 9, eb->len,
+							eb->start - page_offset(page),
+							fs_info->fs_devices->latest_bdev,
+							&bio, -1,
+							end_bio_extent_buffer_readpage,
+							mirror_num, bio_flags,
+							bio_flags, false);
+			} else {
+				lock_extent_bits(tree, page_offset(page),
+						page_offset(page) + PAGE_CACHE_SIZE - 1,
+						0, &cached_state);
+				err = submit_extent_page(READ | REQ_META, tree,
+							NULL, page,
+							page_offset(page) >> 9,
+							PAGE_CACHE_SIZE, 0,
+							fs_info->fs_devices->latest_bdev,
+							&bio, -1,
+							end_bio_extent_buffer_readpage,
+							mirror_num, bio_flags,
+							bio_flags, false);
+			}
 			if (err)
 				ret = err;
 		} else {
@@ -5632,10 +5733,11 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	for (i = start_i; i < num_pages; i++) {
 		page = eb_head(eb)->pages[i];
 		wait_on_page_locked(page);
-		if (!PageUptodate(page))
-			ret = -EIO;
 	}
 
+	if (!extent_buffer_uptodate(eb))
+		ret = -EIO;
+
 	return ret;
 
 unlock_exit:
-- 
2.1.0

