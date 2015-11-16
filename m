Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57271 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbKPHJJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:09:09 -0500
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 12:39:07 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id D4667E0087
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:31 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG78wYL4260328
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:00 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG78vTV027391
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:58 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [RFC PATCH V12 13/14] Btrfs: subpagesize-blocksize: Fix file defragmentation code
Date: Mon, 16 Nov 2015 12:38:40 +0530
Message-Id: <1447657721-10025-14-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit gets file defragmentation code to work in subpagesize-blocksize
scenario. It does this by keeping track of page offsets that mark block
boundaries and passing them as arguments to the functions that implement the
defragmentation logic.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 194 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 132 insertions(+), 62 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7375cf2..b261b57 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -882,12 +882,13 @@ out_unlock:
 static int check_defrag_in_cache(struct inode *inode, u64 offset, u32 thresh)
 {
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map *em = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	u64 end;
 
 	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, offset, PAGE_CACHE_SIZE);
+	em = lookup_extent_mapping(em_tree, offset, root->sectorsize);
 	read_unlock(&em_tree->lock);
 
 	if (em) {
@@ -977,7 +978,7 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start)
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em;
-	u64 len = PAGE_CACHE_SIZE;
+	u64 len = BTRFS_I(inode)->root->sectorsize;
 
 	/*
 	 * hopefully we have this extent in the tree already, try without
@@ -1096,15 +1097,18 @@ out:
  * before calling this.
  */
 static int cluster_pages_for_defrag(struct inode *inode,
-				    struct page **pages,
-				    unsigned long start_index,
-				    unsigned long num_pages)
+				struct page **pages,
+				unsigned long start_index,
+				size_t pg_offset,
+				unsigned long num_blks)
 {
-	unsigned long file_end;
 	u64 isize = i_size_read(inode);
+	u64 start_blk;
+	u64 end_blk;
 	u64 page_start;
 	u64 page_end;
 	u64 page_cnt;
+	u64 blk_cnt;
 	int ret;
 	int i;
 	int i_done;
@@ -1113,20 +1117,25 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct extent_io_tree *tree;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
-	file_end = (isize - 1) >> PAGE_CACHE_SHIFT;
-	if (!isize || start_index > file_end)
+	start_blk = (start_index << PAGE_CACHE_SHIFT) + pg_offset;
+	start_blk >>= inode->i_blkbits;
+	end_blk = (isize - 1) >> inode->i_blkbits;
+	if (!isize || start_blk > end_blk)
 		return 0;
 
-	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
+	blk_cnt = min_t(u64, (u64)num_blks, (u64)end_blk - start_blk + 1);
 
 	ret = btrfs_delalloc_reserve_space(inode,
-			start_index << PAGE_CACHE_SHIFT,
-			page_cnt << PAGE_CACHE_SHIFT);
+					start_blk << inode->i_blkbits,
+					blk_cnt << inode->i_blkbits);
 	if (ret)
 		return ret;
 	i_done = 0;
 	tree = &BTRFS_I(inode)->io_tree;
 
+	page_cnt = DIV_ROUND_UP(pg_offset + (blk_cnt << inode->i_blkbits),
+				PAGE_CACHE_SIZE);
+
 	/* step one, lock all the pages */
 	for (i = 0; i < page_cnt; i++) {
 		struct page *page;
@@ -1137,12 +1146,21 @@ again:
 			break;
 
 		page_start = page_offset(page);
-		page_end = page_start + PAGE_CACHE_SIZE - 1;
+		if (i == 0)
+			page_start += pg_offset;
+
+		if (i == page_cnt - 1) {
+			page_end = (start_index << PAGE_CACHE_SHIFT) + pg_offset;
+			page_end += (blk_cnt << inode->i_blkbits) - 1;
+		} else {
+			page_end = page_offset(page) + PAGE_CACHE_SIZE - 1;
+		}
+
 		while (1) {
 			lock_extent_bits(tree, page_start, page_end,
 					 0, &cached_state);
-			ordered = btrfs_lookup_ordered_extent(inode,
-							      page_start);
+			ordered = btrfs_lookup_ordered_range(inode, page_start,
+							page_end - page_start + 1);
 			unlock_extent_cached(tree, page_start, page_end,
 					     &cached_state, GFP_NOFS);
 			if (!ordered)
@@ -1181,7 +1199,7 @@ again:
 		}
 
 		pages[i] = page;
-		i_done++;
+		i_done += (page_end - page_start + 1) >> inode->i_blkbits;
 	}
 	if (!i_done || ret)
 		goto out;
@@ -1193,55 +1211,76 @@ again:
 	 * so now we have a nice long stream of locked
 	 * and up to date pages, lets wait on them
 	 */
-	for (i = 0; i < i_done; i++)
+	page_cnt = DIV_ROUND_UP(pg_offset + (i_done << inode->i_blkbits),
+				PAGE_CACHE_SIZE);
+	for (i = 0; i < page_cnt; i++)
 		wait_on_page_writeback(pages[i]);
 
-	page_start = page_offset(pages[0]);
-	page_end = page_offset(pages[i_done - 1]) + PAGE_CACHE_SIZE;
+	page_start = page_offset(pages[0]) + pg_offset;
+	page_end = page_start + (i_done << inode->i_blkbits) - 1;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree,
-			 page_start, page_end - 1, 0, &cached_state);
+			 page_start, page_end, 0, &cached_state);
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
-			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
+			  page_end, EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
 			  &cached_state, GFP_NOFS);
 
-	if (i_done != page_cnt) {
+	if (i_done != blk_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents++;
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode,
-				start_index << PAGE_CACHE_SHIFT,
-				(page_cnt - i_done) << PAGE_CACHE_SHIFT);
+					start_blk << inode->i_blkbits,
+					(blk_cnt - i_done) << inode->i_blkbits);
 	}
 
 
-	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
+	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			  &cached_state, GFP_NOFS);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-			     page_start, page_end - 1, &cached_state,
+			     page_start, page_end, &cached_state,
 			     GFP_NOFS);
 
-	for (i = 0; i < i_done; i++) {
+	for (i = 0; i < page_cnt; i++) {
 		clear_page_dirty_for_io(pages[i]);
 		ClearPageChecked(pages[i]);
 		set_page_extent_mapped(pages[i]);
+
+		page_start = page_offset(pages[i]);
+		if (i == 0)
+			page_start += pg_offset;
+
+		if (i == page_cnt - 1) {
+			page_end = page_offset(pages[0]) + pg_offset;
+			page_end += (i_done << inode->i_blkbits) - 1;
+		} else {
+			page_end = page_offset(pages[i]) + PAGE_CACHE_SIZE - 1;
+		}
+
+		set_page_blks_state(pages[i],
+				1 << BLK_STATE_UPTODATE | 1 << BLK_STATE_DIRTY,
+				page_start, page_end);
 		set_page_dirty(pages[i]);
 		unlock_page(pages[i]);
 		page_cache_release(pages[i]);
 	}
 	return i_done;
 out:
-	for (i = 0; i < i_done; i++) {
-		unlock_page(pages[i]);
-		page_cache_release(pages[i]);
+	if (i_done) {
+		page_cnt = DIV_ROUND_UP(pg_offset + (i_done << inode->i_blkbits),
+					PAGE_CACHE_SIZE);
+		for (i = 0; i < page_cnt; i++) {
+			unlock_page(pages[i]);
+			page_cache_release(pages[i]);
+		}
 	}
+
 	btrfs_delalloc_release_space(inode,
-			start_index << PAGE_CACHE_SHIFT,
-			page_cnt << PAGE_CACHE_SHIFT);
+				start_blk << inode->i_blkbits,
+				blk_cnt << inode->i_blkbits);
 	return ret;
-
 }
 
 int btrfs_defrag_file(struct inode *inode, struct file *file,
@@ -1250,19 +1289,24 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct file_ra_state *ra = NULL;
+	unsigned long first_off, last_off;
+	unsigned long first_block, last_block;
 	unsigned long last_index;
 	u64 isize = i_size_read(inode);
 	u64 last_len = 0;
 	u64 skip = 0;
 	u64 defrag_end = 0;
 	u64 newer_off = range->start;
+	u64 start;
+	u64 page_cnt;
 	unsigned long i;
 	unsigned long ra_index = 0;
+	size_t pg_offset;
 	int ret;
 	int defrag_count = 0;
 	int compress_type = BTRFS_COMPRESS_ZLIB;
 	u32 extent_thresh = range->extent_thresh;
-	unsigned long max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
+	unsigned long max_cluster = (256 * 1024) >> inode->i_blkbits;
 	unsigned long cluster = max_cluster;
 	u64 new_align = ~((u64)128 * 1024 - 1);
 	struct page **pages = NULL;
@@ -1296,8 +1340,14 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		ra = &file->f_ra;
 	}
 
-	pages = kmalloc_array(max_cluster, sizeof(struct page *),
-			GFP_NOFS);
+	/*
+	  In subpagesize-blocksize scenario the first of "max_cluster" blocks
+	  may start on a non-zero page offset. In such scenarios we need one
+	  page more than what would be needed in the case where the first block
+	  maps to first block of a page.
+	*/
+	page_cnt = (max_cluster >> (PAGE_CACHE_SHIFT - inode->i_blkbits)) + 1;
+	pages = kmalloc_array(page_cnt, sizeof(struct page *), GFP_NOFS);
 	if (!pages) {
 		ret = -ENOMEM;
 		goto out_ra;
@@ -1305,12 +1355,15 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 	/* find the last page to defrag */
 	if (range->start + range->len > range->start) {
-		last_index = min_t(u64, isize - 1,
-			 range->start + range->len - 1) >> PAGE_CACHE_SHIFT;
+		last_off = min_t(u64, isize - 1, range->start + range->len - 1);
 	} else {
-		last_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		last_off = isize - 1;
 	}
 
+	last_off = round_up(last_off, root->sectorsize) - 1;
+	last_block = last_off >> inode->i_blkbits;
+	last_index = last_off >> PAGE_CACHE_SHIFT;
+
 	if (newer_than) {
 		ret = find_new_extents(root, inode, newer_than,
 				       &newer_off, 64 * 1024);
@@ -1320,14 +1373,20 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			 * we always align our defrag to help keep
 			 * the extents in the file evenly spaced
 			 */
-			i = (newer_off & new_align) >> PAGE_CACHE_SHIFT;
+			first_off = newer_off & new_align;
 		} else
 			goto out_ra;
 	} else {
-		i = range->start >> PAGE_CACHE_SHIFT;
+		first_off = range->start;
 	}
+
+	first_off = round_down(first_off, root->sectorsize);
+	first_block = first_off >> inode->i_blkbits;
+	i = first_off >> PAGE_CACHE_SHIFT;
+	pg_offset = first_off & (PAGE_CACHE_SIZE - 1);
+
 	if (!max_to_defrag)
-		max_to_defrag = last_index - i + 1;
+		max_to_defrag = last_block - first_block + 1;
 
 	/*
 	 * make writeback starts from i, so the defrag range can be
@@ -1337,7 +1396,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		inode->i_mapping->writeback_index = i;
 
 	while (i <= last_index && defrag_count < max_to_defrag &&
-	       (i < DIV_ROUND_UP(i_size_read(inode), PAGE_CACHE_SIZE))) {
+		(i < DIV_ROUND_UP(i_size_read(inode), PAGE_CACHE_SIZE))) {
 		/*
 		 * make sure we stop running if someone unmounts
 		 * the FS
@@ -1351,39 +1410,50 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			break;
 		}
 
-		if (!should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
-					 extent_thresh, &last_len, &skip,
-					 &defrag_end, range->flags &
-					 BTRFS_DEFRAG_RANGE_COMPRESS)) {
+		start = pg_offset + ((u64)i << PAGE_CACHE_SHIFT);
+		if (!should_defrag_range(inode, start,
+					extent_thresh, &last_len, &skip,
+					&defrag_end, range->flags &
+					BTRFS_DEFRAG_RANGE_COMPRESS)) {
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
 			 * bump our counter by the suggested amount
 			 */
-			next = DIV_ROUND_UP(skip, PAGE_CACHE_SIZE);
-			i = max(i + 1, next);
+			next = max(skip, start + root->sectorsize);
+			next >>= inode->i_blkbits;
+
+			first_off = next << inode->i_blkbits;
+			i = first_off >> PAGE_CACHE_SHIFT;
+			pg_offset = first_off & (PAGE_CACHE_SIZE - 1);
 			continue;
 		}
 
 		if (!newer_than) {
-			cluster = (PAGE_CACHE_ALIGN(defrag_end) >>
-				   PAGE_CACHE_SHIFT) - i;
+			cluster = (defrag_end >> inode->i_blkbits)
+				- (start >> inode->i_blkbits);
+
 			cluster = min(cluster, max_cluster);
 		} else {
 			cluster = max_cluster;
 		}
 
-		if (i + cluster > ra_index) {
+		page_cnt = pg_offset + (cluster << inode->i_blkbits) - 1;
+		page_cnt = DIV_ROUND_UP(page_cnt, PAGE_CACHE_SIZE);
+		if (i + page_cnt > ra_index) {
 			ra_index = max(i, ra_index);
 			btrfs_force_ra(inode->i_mapping, ra, file, ra_index,
-				       cluster);
-			ra_index += cluster;
+				       page_cnt);
+			ra_index += DIV_ROUND_UP(pg_offset +
+						(cluster << inode->i_blkbits),
+						PAGE_CACHE_SIZE);
 		}
 
 		mutex_lock(&inode->i_mutex);
 		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
 			BTRFS_I(inode)->force_compress = compress_type;
-		ret = cluster_pages_for_defrag(inode, pages, i, cluster);
+		ret = cluster_pages_for_defrag(inode, pages, i, pg_offset,
+					cluster);
 		if (ret < 0) {
 			mutex_unlock(&inode->i_mutex);
 			goto out_ra;
@@ -1397,30 +1467,30 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			if (newer_off == (u64)-1)
 				break;
 
-			if (ret > 0)
-				i += ret;
-
 			newer_off = max(newer_off + 1,
-					(u64)i << PAGE_CACHE_SHIFT);
+					start + (ret << inode->i_blkbits));
 
 			ret = find_new_extents(root, inode,
 					       newer_than, &newer_off,
 					       64 * 1024);
 			if (!ret) {
 				range->start = newer_off;
-				i = (newer_off & new_align) >> PAGE_CACHE_SHIFT;
+				first_off = newer_off & new_align;
 			} else {
 				break;
 			}
 		} else {
 			if (ret > 0) {
-				i += ret;
-				last_len += ret << PAGE_CACHE_SHIFT;
+				first_off = start + (ret << inode->i_blkbits);
+				last_len += ret << inode->i_blkbits;
 			} else {
-				i++;
+				first_off = start + root->sectorsize;
 				last_len = 0;
 			}
 		}
+		first_off = round_down(first_off, root->sectorsize);
+		i = first_off >> PAGE_CACHE_SHIFT;
+		pg_offset = first_off & (PAGE_CACHE_SIZE - 1);
 	}
 
 	if ((range->flags & BTRFS_DEFRAG_RANGE_START_IO)) {
-- 
2.1.0

