Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([125.16.236.2]:56247 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbcDZN2Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:28:16 -0400
Received: from localhost
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 26 Apr 2016 18:58:13 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3QDSCs721102934
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:12 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3QDS8mE009983
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:10 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com
Subject: [PATCH V18 13/18] Btrfs: subpage-blocksize: Fix file defragmentation code
Date: Tue, 26 Apr 2016 18:57:12 +0530
Message-Id: <1461677237-7703-14-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit gets file defragmentation code to work in subpage-blocksize
scenario. It does this by keeping track of page offsets that mark block
boundaries and passing them as arguments to the functions that implement
the defragmentation logic.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 193 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 132 insertions(+), 61 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5a23806..bf79dbc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -893,12 +893,13 @@ out_unlock:
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
@@ -988,7 +989,7 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start)
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em;
-	u64 len = PAGE_SIZE;
+	u64 len = BTRFS_I(inode)->root->sectorsize;
 
 	/*
 	 * hopefully we have this extent in the tree already, try without
@@ -1107,15 +1108,18 @@ out:
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
@@ -1124,20 +1128,25 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct extent_io_tree *tree;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
-	file_end = (isize - 1) >> PAGE_SHIFT;
-	if (!isize || start_index > file_end)
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
@@ -1148,12 +1157,22 @@ again:
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
@@ -1192,7 +1211,7 @@ again:
 		}
 
 		pages[i] = page;
-		i_done++;
+		i_done += (page_end - page_start + 1) >> inode->i_blkbits;
 	}
 	if (!i_done || ret)
 		goto out;
@@ -1204,55 +1223,76 @@ again:
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
+			page_end = page_offset(pages[i]) + PAGE_SIZE - 1;
+		}
+
+		set_page_blks_state(pages[i],
+				1 << BLK_STATE_UPTODATE | 1 << BLK_STATE_DIRTY,
+				page_start, page_end);
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
@@ -1261,19 +1301,24 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
@@ -1307,8 +1352,14 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
@@ -1316,12 +1367,15 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
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
@@ -1331,14 +1385,20 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
@@ -1362,39 +1422,50 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
@@ -1408,29 +1479,29 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
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
2.1.0

