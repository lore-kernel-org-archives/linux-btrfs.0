Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53587 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbbI3K3v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:29:51 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 20:29:49 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 7076C357804F
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:46 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UATRBv32768146
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:35 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UATDhE023607
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:14 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V5 05/13] Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units
Date: Wed, 30 Sep 2015 15:58:24 +0530
Message-Id: <1443608912-31667-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 5301d4e..5e6052d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8659,11 +8659,24 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
@@ -8684,6 +8697,7 @@ again:
 	size = i_size_read(inode);
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_CACHE_SIZE - 1;
+	end = page_end;
 
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_start >= size)) {
@@ -8699,7 +8713,7 @@ again:
 	 * we can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish
 	 */
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
@@ -8709,6 +8723,18 @@ again:
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
@@ -8716,12 +8742,12 @@ again:
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
@@ -8760,7 +8786,7 @@ out_unlock:
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

