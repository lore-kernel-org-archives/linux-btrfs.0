Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38407 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbbI3KUA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:20:00 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 15:49:57 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 698B91258019
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 15:49:29 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UAJqGe62455916
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 15:49:52 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UAInh4012200
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 15:48:51 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [RFC PATCH V4 04/13] Btrfs: fallocate: Work with sectorsized blocks
Date: Wed, 30 Sep 2015 15:48:20 +0530
Message-Id: <1443608309-30154-5-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While at it, this commit changes btrfs_truncate_page() to truncate sectorsized
blocks instead of pages. Hence the function has been renamed to
btrfs_truncate_block().

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/file.c  | 47 +++++++++++++++++++++++++----------------------
 fs/btrfs/inode.c | 52 +++++++++++++++++++++++++++-------------------------
 3 files changed, 53 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..99a0fff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3893,7 +3893,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len);
-int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
+int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 12ce401..360d56d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2280,23 +2280,26 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	u64 tail_len;
 	u64 orig_start = offset;
 	u64 cur_offset;
+	unsigned char blocksize_bits;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 	u64 drop_end;
 	int ret = 0;
 	int err = 0;
 	int rsv_count;
-	bool same_page;
+	bool same_block;
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
 	u64 ino_size;
-	bool truncated_page = false;
+	bool truncated_block = false;
 	bool updated_inode = false;
 
+	blocksize_bits = inode->i_blkbits;
+
 	ret = btrfs_wait_ordered_range(inode, offset, len);
 	if (ret)
 		return ret;
 
 	mutex_lock(&inode->i_mutex);
-	ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
+	ino_size = round_up(inode->i_size, root->sectorsize);
 	ret = find_first_non_hole(inode, &offset, &len);
 	if (ret < 0)
 		goto out_only_mutex;
@@ -2309,31 +2312,30 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	lockstart = round_up(offset, BTRFS_I(inode)->root->sectorsize);
 	lockend = round_down(offset + len,
 			     BTRFS_I(inode)->root->sectorsize) - 1;
-	same_page = ((offset >> PAGE_CACHE_SHIFT) ==
-		    ((offset + len - 1) >> PAGE_CACHE_SHIFT));
-
+	same_block = ((offset >> blocksize_bits)
+		== ((offset + len - 1) >> blocksize_bits));
 	/*
-	 * We needn't truncate any page which is beyond the end of the file
+	 * We needn't truncate any block which is beyond the end of the file
 	 * because we are sure there is no data there.
 	 */
 	/*
-	 * Only do this if we are in the same page and we aren't doing the
-	 * entire page.
+	 * Only do this if we are in the same block and we aren't doing the
+	 * entire block.
 	 */
-	if (same_page && len < PAGE_CACHE_SIZE) {
+	if (same_block && len < root->sectorsize) {
 		if (offset < ino_size) {
-			truncated_page = true;
-			ret = btrfs_truncate_page(inode, offset, len, 0);
+			truncated_block = true;
+			ret = btrfs_truncate_block(inode, offset, len, 0);
 		} else {
 			ret = 0;
 		}
 		goto out_only_mutex;
 	}
 
-	/* zero back part of the first page */
+	/* zero back part of the first block */
 	if (offset < ino_size) {
-		truncated_page = true;
-		ret = btrfs_truncate_page(inode, offset, 0, 0);
+		truncated_block = true;
+		ret = btrfs_truncate_block(inode, offset, 0, 0);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
 			return ret;
@@ -2368,9 +2370,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		if (!ret) {
 			/* zero the front end of the last page */
 			if (tail_start + tail_len < ino_size) {
-				truncated_page = true;
-				ret = btrfs_truncate_page(inode,
-						tail_start + tail_len, 0, 1);
+				truncated_block = true;
+				ret = btrfs_truncate_block(inode,
+							tail_start + tail_len,
+							0, 1);
 				if (ret)
 					goto out_only_mutex;
 			}
@@ -2537,7 +2540,7 @@ out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			     &cached_state, GFP_NOFS);
 out_only_mutex:
-	if (!updated_inode && truncated_page && !ret && !err) {
+	if (!updated_inode && truncated_block && !ret && !err) {
 		/*
 		 * If we only end up zeroing part of a page, we still need to
 		 * update the inode item, so that all the time fields are
@@ -2605,10 +2608,10 @@ static long btrfs_fallocate(struct file *file, int mode,
 	} else {
 		/*
 		 * If we are fallocating from the end of the file onward we
-		 * need to zero out the end of the page if i_size lands in the
-		 * middle of a page.
+		 * need to zero out the end of the block if i_size lands in the
+		 * middle of a block.
 		 */
-		ret = btrfs_truncate_page(inode, inode->i_size, 0, 0);
+		ret = btrfs_truncate_block(inode, inode->i_size, 0, 0);
 		if (ret)
 			goto out;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5a47731..5301d4e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4540,17 +4540,17 @@ error:
 }
 
 /*
- * btrfs_truncate_page - read, zero a chunk and write a page
+ * btrfs_truncate_block - read, zero a chunk and write a block
  * @inode - inode that we're zeroing
  * @from - the offset to start zeroing
  * @len - the length to zero, 0 to zero the entire range respective to the
  *	offset
  * @front - zero up to the offset instead of from the offset on
  *
- * This will find the page for the "from" offset and cow the page and zero the
+ * This will find the block for the "from" offset and cow the block and zero the
  * part we want to zero.  This is used with truncate and hole punching.
  */
-int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
+int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front)
 {
 	struct address_space *mapping = inode->i_mapping;
@@ -4561,30 +4561,30 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
 	char *kaddr;
 	u32 blocksize = root->sectorsize;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned offset = from & (blocksize - 1);
 	struct page *page;
 	gfp_t mask = btrfs_alloc_write_mask(mapping);
 	int ret = 0;
-	u64 page_start;
-	u64 page_end;
+	u64 block_start;
+	u64 block_end;
 
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
-	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret = btrfs_delalloc_reserve_space(inode, blocksize);
 	if (ret)
 		goto out;
 
 again:
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
-		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+		btrfs_delalloc_release_space(inode, blocksize);
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	page_start = page_offset(page);
-	page_end = page_start + PAGE_CACHE_SIZE - 1;
+	block_start = round_down(from, blocksize);
+	block_end = block_start + blocksize - 1;
 
 	if (!PageUptodate(page)) {
 		ret = btrfs_readpage(NULL, page);
@@ -4601,12 +4601,12 @@ again:
 	}
 	wait_on_page_writeback(page);
 
-	lock_extent_bits(io_tree, page_start, page_end, 0, &cached_state);
+	lock_extent_bits(io_tree, block_start, block_end, 0, &cached_state);
 	set_page_extent_mapped(page);
 
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_extent(inode, block_start);
 	if (ordered) {
-		unlock_extent_cached(io_tree, page_start, page_end,
+		unlock_extent_cached(io_tree, block_start, block_end,
 				     &cached_state, GFP_NOFS);
 		unlock_page(page);
 		page_cache_release(page);
@@ -4615,38 +4615,40 @@ again:
 		goto again;
 	}
 
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, block_start, block_end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+	ret = btrfs_set_extent_delalloc(inode, block_start, block_end,
 					&cached_state);
 	if (ret) {
-		unlock_extent_cached(io_tree, page_start, page_end,
+		unlock_extent_cached(io_tree, block_start, block_end,
 				     &cached_state, GFP_NOFS);
 		goto out_unlock;
 	}
 
-	if (offset != PAGE_CACHE_SIZE) {
+	if (offset != blocksize) {
 		if (!len)
-			len = PAGE_CACHE_SIZE - offset;
+			len = blocksize - offset;
 		kaddr = kmap(page);
 		if (front)
-			memset(kaddr, 0, offset);
+			memset(kaddr + (block_start - page_offset(page)),
+				0, offset);
 		else
-			memset(kaddr + offset, 0, len);
+			memset(kaddr + (block_start - page_offset(page)) +  offset,
+				0, len);
 		flush_dcache_page(page);
 		kunmap(page);
 	}
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	unlock_extent_cached(io_tree, page_start, page_end, &cached_state,
+	unlock_extent_cached(io_tree, block_start, block_end, &cached_state,
 			     GFP_NOFS);
 
 out_unlock:
 	if (ret)
-		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+		btrfs_delalloc_release_space(inode, blocksize);
 	unlock_page(page);
 	page_cache_release(page);
 out:
@@ -4717,11 +4719,11 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 	int err = 0;
 
 	/*
-	 * If our size started in the middle of a page we need to zero out the
-	 * rest of the page before we expand the i_size, otherwise we could
+	 * If our size started in the middle of a block we need to zero out the
+	 * rest of the block before we expand the i_size, otherwise we could
 	 * expose stale data.
 	 */
-	err = btrfs_truncate_page(inode, oldsize, 0, 0);
+	err = btrfs_truncate_block(inode, oldsize, 0, 0);
 	if (err)
 		return err;
 
-- 
2.1.0

