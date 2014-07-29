Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52232 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaG2LO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:14:27 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 16:44:25 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id D44F9E0044
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:46:07 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6TBGJcU4588018
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:46:19 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6TBEL0i013250
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:22 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V5 10/12] Btrfs: subpagesize-blocksize: fallocate: Work with sectorsized units.
Date: Tue, 29 Jul 2014 16:43:45 +0530
Message-Id: <1406632427-2209-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While at it, this commit changes btrfs_truncate_page() to truncate sectorsized
blocks instead of pages. Hence the function has been renamed to
btrfs_truncate_block().

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/file.c  | 35 ++++++++++++++++++-----------------
 fs/btrfs/inode.c | 48 +++++++++++++++++++++++++-----------------------
 3 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 901ada2..4a93d21 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3721,7 +3721,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len);
-int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
+int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 541e227..abacd5f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2161,6 +2161,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *rsv;
 	struct btrfs_trans_handle *trans;
+	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	u64 lockstart = round_up(offset, BTRFS_I(inode)->root->sectorsize);
 	u64 lockend = round_down(offset + len,
 				 BTRFS_I(inode)->root->sectorsize) - 1;
@@ -2170,8 +2171,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	int ret = 0;
 	int err = 0;
 	int rsv_count;
-	bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
-			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
+	bool same_block = ((offset >> blocksize_bits) ==
+			  ((offset + len - 1) >> blocksize_bits));
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
 
 	ret = btrfs_wait_ordered_range(inode, offset, len);
@@ -2180,32 +2181,32 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	mutex_lock(&inode->i_mutex);
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
-		if (offset < round_up(inode->i_size, PAGE_CACHE_SIZE))
-			ret = btrfs_truncate_page(inode, offset, len, 0);
+	if (same_block && len < root->sectorsize) {
+		if (offset < round_up(inode->i_size, root->sectorsize))
+			ret = btrfs_truncate_block(inode, offset, len, 0);
 		mutex_unlock(&inode->i_mutex);
 		return ret;
 	}
 
-	/* zero back part of the first page */
-	if (offset < round_up(inode->i_size, PAGE_CACHE_SIZE)) {
-		ret = btrfs_truncate_page(inode, offset, 0, 0);
+	/* zero back part of the first block */
+	if (offset < round_up(inode->i_size, root->sectorsize)) {
+		ret = btrfs_truncate_block(inode, offset, 0, 0);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
 			return ret;
 		}
 	}
 
-	/* zero the front end of the last page */
-	if (offset + len < round_up(inode->i_size, PAGE_CACHE_SIZE)) {
-		ret = btrfs_truncate_page(inode, offset + len, 0, 1);
+	/* zero the front end of the last block */
+	if (offset + len < round_up(inode->i_size, root->sectorsize)) {
+		ret = btrfs_truncate_block(inode, offset + len, 0, 1);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
 			return ret;
@@ -2410,10 +2411,10 @@ static long btrfs_fallocate(struct file *file, int mode,
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
index 94526bd..1872725 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4211,7 +4211,7 @@ error:
  * This will find the page for the "from" offset and cow the page and zero the
  * part we want to zero.  This is used with truncate and hole punching.
  */
-int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
+int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front)
 {
 	struct address_space *mapping = inode->i_mapping;
@@ -4222,30 +4222,30 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
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
@@ -4262,12 +4262,12 @@ again:
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
@@ -4276,38 +4276,40 @@ again:
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
@@ -4378,11 +4380,11 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
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
1.8.3.1

