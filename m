Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37053 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbbHFKLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 06:11:49 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 6 Aug 2015 15:41:46 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id E4F801258064
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2015 15:44:52 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t76ABf6p63373536
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:41:42 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t76AAa2k020741
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:40:40 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH 05/11] Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units
Date: Thu,  6 Aug 2015 15:40:13 +0530
Message-Id: <1438855819-4328-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, if i_size occurs in a block which is not
the last block in the page, then the space to be reserved should be calculated
appropriately.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index afb8d2b..b39273b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8626,11 +8626,24 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	loff_t size;
 	int ret;
 	int reserved = 0;
+	u64 reserved_space;
 	u64 page_start;
 	u64 page_end;
+	u64 end;
+
+	reserved_space = PAGE_CACHE_SIZE;
 
 	sb_start_pagefault(inode->i_sb);
-	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+
+	/*
+	  Reserving delalloc space after obtaining the page lock can lead to
+	  deadlock. For example, if a dirty page is locked by this function
+	  and the call to btrfs_delalloc_reserve_space() ends up triggering
+	  dirty page write out, then the btrfs_writepage() function could
+	  end up waiting indefinitely to get a lock on the page currently
+	  being processed by btrfs_page_mkwrite() function.
+	 */
+	ret  = btrfs_delalloc_reserve_space(inode, reserved_space);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
 		reserved = 1;
@@ -8651,6 +8664,7 @@ again:
 	size = i_size_read(inode);
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_CACHE_SIZE - 1;
+	end = page_end;
 
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_start >= size)) {
@@ -8666,7 +8680,7 @@ again:
 	 * we can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish
 	 */
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
@@ -8676,6 +8690,18 @@ again:
 		goto again;
 	}
 
+	if (page->index == ((size - 1) >> PAGE_CACHE_SHIFT)) {
+		reserved_space = round_up(size - page_start, root->sectorsize);
+		if (reserved_space < PAGE_CACHE_SIZE) {
+			end = page_start + reserved_space - 1;
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->outstanding_extents++;
+			spin_unlock(&BTRFS_I(inode)->lock);
+			btrfs_delalloc_release_space(inode,
+						PAGE_CACHE_SIZE - reserved_space);
+		}
+	}
+
 	/*
 	 * XXX - page_mkwrite gets called every time the page is dirtied, even
 	 * if it was already dirty, so for space accounting reasons we need to
@@ -8683,12 +8709,12 @@ again:
 	 * is probably a better way to do this, but for now keep consistent with
 	 * prepare_pages in the normal write path.
 	 */
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+	ret = btrfs_set_extent_delalloc(inode, page_start, end,
 					&cached_state);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
@@ -8727,7 +8753,7 @@ out_unlock:
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+	btrfs_delalloc_release_space(inode, reserved_space);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
-- 
2.1.0

