Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53011 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751802AbcJBN0C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:26:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DND3v060720
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:26:01 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25t99m4q4u-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:26:01 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:26:00 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 14/19] Btrfs: subpage-blocksize: Fix file defragmentation code
Date: Sun,  2 Oct 2016 18:54:23 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-15-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit gets file defragmentation code to work in subpage-blocksize
scenario. It does this by keeping track of page offsets that mark block
boundaries and passing them as arguments to the functions that implement
the defragmentation logic.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 198 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 136 insertions(+), 62 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a222bad..4077fc1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -902,12 +902,13 @@ out_unlock:
 static int check_defrag_in_cache(struct inode *inode, u64 offset, u32 thresh)
 {
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map *em = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	u64 end;
 
 	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, offset, PAGE_SIZE);
+	em = lookup_extent_mapping(em_tree, offset, root->sectorsize);
 	read_unlock(&em_tree->lock);
 
 	if (em) {
@@ -997,7 +998,7 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start)
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em;
-	u64 len = PAGE_SIZE;
+	u64 len = BTRFS_I(inode)->root->sectorsize;
 
 	/*
 	 * hopefully we have this extent in the tree already, try without
@@ -1116,37 +1117,47 @@ out:
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
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_io_tree *tree;
+	struct btrfs_root *root;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
-	file_end = (isize - 1) >> PAGE_SHIFT;
-	if (!isize || start_index > file_end)
+	root = BTRFS_I(inode)->root;
+	start_blk = (start_index << PAGE_SHIFT) + pg_offset;
+	start_blk >>= inode->i_blkbits;
+	end_blk = (isize - 1) >> inode->i_blkbits;
+	if (!isize || start_blk > end_blk)
 		return 0;
 
-	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
+	blk_cnt = min_t(u64, (u64)num_blks, (u64)end_blk - start_blk + 1);
 
 	ret = btrfs_delalloc_reserve_space(inode,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+					start_blk << inode->i_blkbits,
+					blk_cnt << inode->i_blkbits);
 	if (ret)
 		return ret;
 	i_done = 0;
 	tree = &BTRFS_I(inode)->io_tree;
 
+	page_cnt = DIV_ROUND_UP(pg_offset + (blk_cnt << inode->i_blkbits),
+				PAGE_SIZE);
+
 	/* step one, lock all the pages */
 	for (i = 0; i < page_cnt; i++) {
 		struct page *page;
@@ -1157,12 +1168,22 @@ again:
 			break;
 
 		page_start = page_offset(page);
-		page_end = page_start + PAGE_SIZE - 1;
+
+		if (i == 0)
+			page_start += pg_offset;
+
+		if (i == page_cnt - 1) {
+			page_end = (start_index << PAGE_SHIFT) + pg_offset;
+			page_end += (blk_cnt << inode->i_blkbits) - 1;
+		} else {
+			page_end = page_offset(page) + PAGE_SIZE - 1;
+		}
+
 		while (1) {
 			lock_extent_bits(tree, page_start, page_end,
 					 &cached_state);
-			ordered = btrfs_lookup_ordered_extent(inode,
-							      page_start);
+			ordered = btrfs_lookup_ordered_range(inode, page_start,
+							page_end - page_start + 1);
 			unlock_extent_cached(tree, page_start, page_end,
 					     &cached_state, GFP_NOFS);
 			if (!ordered)
@@ -1201,7 +1222,7 @@ again:
 		}
 
 		pages[i] = page;
-		i_done++;
+		i_done += (page_end - page_start + 1) >> inode->i_blkbits;
 	}
 	if (!i_done || ret)
 		goto out;
@@ -1213,55 +1234,77 @@ again:
 	 * so now we have a nice long stream of locked
 	 * and up to date pages, lets wait on them
 	 */
-	for (i = 0; i < i_done; i++)
+	page_cnt = DIV_ROUND_UP(pg_offset + (i_done << inode->i_blkbits),
+				PAGE_SIZE);
+	for (i = 0; i < page_cnt; i++)
 		wait_on_page_writeback(pages[i]);
 
-	page_start = page_offset(pages[0]);
-	page_end = page_offset(pages[i_done - 1]) + PAGE_SIZE;
+	page_start = page_offset(pages[0]) + pg_offset;
+	page_end = page_start + (i_done << inode->i_blkbits) - 1;
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree,
-			 page_start, page_end - 1, &cached_state);
+			page_start, page_end, &cached_state);
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
-				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT);
+					start_blk << inode->i_blkbits,
+					(blk_cnt - i_done) << inode->i_blkbits);
 	}
 
 
-	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
-			  &cached_state);
+	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end,
+			&cached_state);
 
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
+			page_end = page_offset(pages[i]) + PAGE_SIZE - 1;
+		}
+
+		if (root->sectorsize < PAGE_SIZE)
+			set_page_blks_state(pages[i],
+					1 << BLK_STATE_UPTODATE | 1 << BLK_STATE_DIRTY,
+					page_start, page_end);
 		set_page_dirty(pages[i]);
 		unlock_page(pages[i]);
 		put_page(pages[i]);
 	}
 	return i_done;
 out:
-	for (i = 0; i < i_done; i++) {
-		unlock_page(pages[i]);
-		put_page(pages[i]);
+	if (i_done) {
+		page_cnt = DIV_ROUND_UP(pg_offset + (i_done << inode->i_blkbits),
+					PAGE_SIZE);
+		for (i = 0; i < page_cnt; i++) {
+			unlock_page(pages[i]);
+			put_page(pages[i]);
+		}
 	}
+
 	btrfs_delalloc_release_space(inode,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+				start_blk << inode->i_blkbits,
+				blk_cnt << inode->i_blkbits);
 	return ret;
-
 }
 
 int btrfs_defrag_file(struct inode *inode, struct file *file,
@@ -1270,19 +1313,24 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
-	unsigned long max_cluster = SZ_256K >> PAGE_SHIFT;
+	unsigned long max_cluster = SZ_256K >> inode->i_blkbits;
 	unsigned long cluster = max_cluster;
 	u64 new_align = ~((u64)SZ_128K - 1);
 	struct page **pages = NULL;
@@ -1316,8 +1364,14 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		ra = &file->f_ra;
 	}
 
-	pages = kmalloc_array(max_cluster, sizeof(struct page *),
-			GFP_NOFS);
+	/*
+         * In subpage-blocksize scenario the first of "max_cluster" blocks
+	 * may start on a non-zero page offset. In such scenarios we need one
+	 * page more than what would be needed in the case where the first block
+	 * maps to first block of a page.
+         */
+	page_cnt = (max_cluster >> (PAGE_SHIFT - inode->i_blkbits)) + 1;
+	pages = kmalloc_array(page_cnt, sizeof(struct page *), GFP_NOFS);
 	if (!pages) {
 		ret = -ENOMEM;
 		goto out_ra;
@@ -1325,12 +1379,15 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 	/* find the last page to defrag */
 	if (range->start + range->len > range->start) {
-		last_index = min_t(u64, isize - 1,
-			 range->start + range->len - 1) >> PAGE_SHIFT;
+		last_off = min_t(u64, isize - 1, range->start + range->len - 1);
 	} else {
-		last_index = (isize - 1) >> PAGE_SHIFT;
+		last_off = isize - 1;
 	}
 
+	last_off = round_up(last_off, root->sectorsize) - 1;
+	last_block = last_off >> inode->i_blkbits;
+	last_index = last_off >> PAGE_SHIFT;
+
 	if (newer_than) {
 		ret = find_new_extents(root, inode, newer_than,
 				       &newer_off, SZ_64K);
@@ -1340,14 +1397,20 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			 * we always align our defrag to help keep
 			 * the extents in the file evenly spaced
 			 */
-			i = (newer_off & new_align) >> PAGE_SHIFT;
+			first_off = newer_off & new_align;
 		} else
 			goto out_ra;
 	} else {
-		i = range->start >> PAGE_SHIFT;
+		first_off = range->start;
 	}
+
+	first_off = round_down(first_off, root->sectorsize);
+	first_block = first_off >> inode->i_blkbits;
+	i = first_off >> PAGE_SHIFT;
+	pg_offset = first_off & (PAGE_SIZE - 1);
+
 	if (!max_to_defrag)
-		max_to_defrag = last_index - i + 1;
+		max_to_defrag = last_block - first_block + 1;
 
 	/*
 	 * make writeback starts from i, so the defrag range can be
@@ -1371,39 +1434,50 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			break;
 		}
 
-		if (!should_defrag_range(inode, (u64)i << PAGE_SHIFT,
-					 extent_thresh, &last_len, &skip,
-					 &defrag_end, range->flags &
-					 BTRFS_DEFRAG_RANGE_COMPRESS)) {
+		start = pg_offset + ((u64)i << PAGE_SHIFT);
+		if (!should_defrag_range(inode, start,
+					extent_thresh, &last_len, &skip,
+					&defrag_end, range->flags &
+					BTRFS_DEFRAG_RANGE_COMPRESS)) {
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
 			 * bump our counter by the suggested amount
 			 */
-			next = DIV_ROUND_UP(skip, PAGE_SIZE);
-			i = max(i + 1, next);
+			next = max(skip, start + root->sectorsize);
+			next >>= inode->i_blkbits;
+
+			first_off = next << inode->i_blkbits;
+			i = first_off >> PAGE_SHIFT;
+			pg_offset = first_off & (PAGE_SIZE - 1);
 			continue;
 		}
 
 		if (!newer_than) {
-			cluster = (PAGE_ALIGN(defrag_end) >>
-				   PAGE_SHIFT) - i;
+			cluster = (defrag_end >> inode->i_blkbits)
+				- (start >> inode->i_blkbits);
+
 			cluster = min(cluster, max_cluster);
 		} else {
 			cluster = max_cluster;
 		}
 
-		if (i + cluster > ra_index) {
+		page_cnt = pg_offset + (cluster << inode->i_blkbits) - 1;
+		page_cnt = DIV_ROUND_UP(page_cnt, PAGE_SIZE);
+		if (i + page_cnt > ra_index) {
 			ra_index = max(i, ra_index);
 			btrfs_force_ra(inode->i_mapping, ra, file, ra_index,
-				       cluster);
-			ra_index += cluster;
+				       page_cnt);
+			ra_index += DIV_ROUND_UP(pg_offset +
+						(cluster << inode->i_blkbits),
+						PAGE_SIZE);
 		}
 
 		inode_lock(inode);
 		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
 			BTRFS_I(inode)->force_compress = compress_type;
-		ret = cluster_pages_for_defrag(inode, pages, i, cluster);
+		ret = cluster_pages_for_defrag(inode, pages, i, pg_offset,
+					cluster);
 		if (ret < 0) {
 			inode_unlock(inode);
 			goto out_ra;
@@ -1418,29 +1492,29 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			if (newer_off == (u64)-1)
 				break;
 
-			if (ret > 0)
-				i += ret;
-
 			newer_off = max(newer_off + 1,
-					(u64)i << PAGE_SHIFT);
+					start + (ret << inode->i_blkbits));
 
 			ret = find_new_extents(root, inode, newer_than,
 					       &newer_off, SZ_64K);
 			if (!ret) {
 				range->start = newer_off;
-				i = (newer_off & new_align) >> PAGE_SHIFT;
+				first_off = newer_off & new_align;
 			} else {
 				break;
 			}
 		} else {
 			if (ret > 0) {
-				i += ret;
-				last_len += ret << PAGE_SHIFT;
+				first_off = start + (ret << inode->i_blkbits);
+				last_len += ret << inode->i_blkbits;
 			} else {
-				i++;
+				first_off = start + root->sectorsize;
 				last_len = 0;
 			}
 		}
+		first_off = round_down(first_off, root->sectorsize);
+		i = first_off >> PAGE_SHIFT;
+		pg_offset = first_off & (PAGE_SIZE - 1);
 	}
 
 	if ((range->flags & BTRFS_DEFRAG_RANGE_START_IO)) {
-- 
2.5.5

