Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33955 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaKLISm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 03:18:42 -0500
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Nov 2014 18:18:41 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 09B15357806C
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:38 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAC8INMq37355620
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:23 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAC8Iaum009055
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:37 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, steve.capper@linaro.org
Subject: [RFC PATCH V8 10/16] Btrfs: subpagesize-blocksize: fallocate: Work with sectorsized units.
Date: Wed, 12 Nov 2014 13:47:42 +0530
Message-Id: <1415780268-2017-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While at it, this commit changes btrfs_truncate_page() to truncate sectorsized
blocks instead of pages. Hence the function has been renamed to
btrfs_truncate_block().

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/file.c  | 41 ++++++++++++++++++++++-------------------
 fs/btrfs/inode.c | 48 +++++++++++++++++++++++++-----------------------
 3 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b7b7ca..59779dc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3815,7 +3815,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct inode *dir, u64 objectid,
 			const char *name, int name_len);
-int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
+int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front);
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 444819d..b1e0d27 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2200,21 +2200,24 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
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
 
+	blocksize_bits = inode->i_sb->s_blocksize_bits;
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
@@ -2224,29 +2227,28 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
-	lockstart = round_up(offset , BTRFS_I(inode)->root->sectorsize);
+	lockstart = round_up(offset, BTRFS_I(inode)->root->sectorsize);
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
 		if (offset < ino_size)
-			ret = btrfs_truncate_page(inode, offset, len, 0);
+			ret = btrfs_truncate_block(inode, offset, len, 0);
 		goto out_only_mutex;
 	}
 
-	/* zero back part of the first page */
+	/* zero back part of the first block */
 	if (offset < ino_size) {
-		ret = btrfs_truncate_page(inode, offset, 0, 0);
+		ret = btrfs_truncate_block(inode, offset, 0, 0);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
 			return ret;
@@ -2281,11 +2283,12 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		if (!ret) {
 			/* zero the front end of the last page */
 			if (tail_start + tail_len < ino_size) {
-				ret = btrfs_truncate_page(inode,
-						tail_start + tail_len, 0, 1);
+				ret = btrfs_truncate_block(inode,
+							tail_start + tail_len,
+							0, 1);
 				if (ret)
 					goto out_only_mutex;
-				}
+			}
 		}
 	}
 
@@ -2506,10 +2509,10 @@ static long btrfs_fallocate(struct file *file, int mode,
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
index ae5d459..7ad7d0f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4273,7 +4273,7 @@ error:
  * This will find the page for the "from" offset and cow the page and zero the
  * part we want to zero.  This is used with truncate and hole punching.
  */
-int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
+int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			int front)
 {
 	struct address_space *mapping = inode->i_mapping;
@@ -4284,30 +4284,30 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
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
@@ -4324,12 +4324,12 @@ again:
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
@@ -4338,38 +4338,40 @@ again:
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
@@ -4440,11 +4442,11 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
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

