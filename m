Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49460 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbbJ1IKs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 04:10:48 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 28 Oct 2015 13:40:45 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id EDC6D394005B
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:40:41 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9S8AcFG21561448
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:40:39 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9S8Aapt003486
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:40:38 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V8 05/13] Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units
Date: Wed, 28 Oct 2015 13:40:19 +0530
Message-Id: <1446019827-685-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1446019827-685-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1446019827-685-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, if i_size occurs in a block which is not
the last block in the page, then the space to be reserved should be calculated
appropriately.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a54dad6..f3f0d91 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8772,15 +8772,28 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_CACHE_SIZE - 1;
+	end = page_end;
 
+	/*
+	 * Reserving delalloc space after obtaining the page lock can lead to
+	 * deadlock. For example, if a dirty page is locked by this function
+	 * and the call to btrfs_delalloc_reserve_space() ends up triggering
+	 * dirty page write out, then the btrfs_writepage() function could
+	 * end up waiting indefinitely to get a lock on the page currently
+	 * being processed by btrfs_page_mkwrite() function.
+	 */
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
-					   PAGE_CACHE_SIZE);
+					   reserved_space);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
 		reserved = 1;
@@ -8814,7 +8827,7 @@ again:
 	 * we can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish
 	 */
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
@@ -8824,6 +8837,18 @@ again:
 		goto again;
 	}
 
+	if (page->index == ((size - 1) >> PAGE_CACHE_SHIFT)) {
+		reserved_space = round_up(size - page_start, root->sectorsize);
+		if (reserved_space < PAGE_CACHE_SIZE) {
+			end = page_start + reserved_space - 1;
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->outstanding_extents++;
+			spin_unlock(&BTRFS_I(inode)->lock);
+			btrfs_delalloc_release_space(inode, page_start,
+						PAGE_CACHE_SIZE - reserved_space);
+		}
+	}
+
 	/*
 	 * XXX - page_mkwrite gets called every time the page is dirtied, even
 	 * if it was already dirty, so for space accounting reasons we need to
@@ -8831,12 +8856,12 @@ again:
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
@@ -8875,7 +8900,7 @@ out_unlock:
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, page_start, PAGE_CACHE_SIZE);
+	btrfs_delalloc_release_space(inode, page_start, reserved_space);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
-- 
2.1.0

