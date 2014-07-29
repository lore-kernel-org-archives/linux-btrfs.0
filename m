Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43181 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaG2LO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:14:27 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 16:44:25 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id BCB50394004C
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:22 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6TBEH8w44171466
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:17 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6TBELeM013286
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:22 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V5 11/12] Btrfs: subpagesize-blocksize: btrfs_page_mkwrite: Reserve space in sectorsized units.
Date: Tue, 29 Jul 2014 16:43:46 +0530
Message-Id: <1406632427-2209-12-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, if i_size occurs in a block which is not
the last block in the page, then the space to be reserved should be calculated
appropriately.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1872725..d7a3ca7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7698,26 +7698,23 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	loff_t size;
 	int ret;
 	int reserved = 0;
+	u64 delalloc_size;
 	u64 page_start;
 	u64 page_end;
 
 	sb_start_pagefault(inode->i_sb);
-	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
-	if (!ret) {
-		ret = file_update_time(vma->vm_file);
-		reserved = 1;
-	}
+
+	ret = file_update_time(vma->vm_file);
 	if (ret) {
 		if (ret == -ENOMEM)
 			ret = VM_FAULT_OOM;
 		else /* -ENOSPC, -EIO, etc */
 			ret = VM_FAULT_SIGBUS;
-		if (reserved)
-			goto out;
-		goto out_noreserve;
+		goto out;
 	}
 
 	ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
+
 again:
 	lock_page(page);
 	size = i_size_read(inode);
@@ -7748,6 +7745,19 @@ again:
 		goto again;
 	}
 
+	if (page->index == ((size - 1) >> PAGE_CACHE_SHIFT))
+		delalloc_size = round_up(size - page_start, root->sectorsize);
+	else
+		delalloc_size = PAGE_CACHE_SIZE;
+
+	ret = btrfs_delalloc_reserve_space(inode, delalloc_size);
+	if (ret) {
+		/* -ENOSPC */
+		ret = VM_FAULT_SIGBUS;
+		goto out_unlock;
+	}
+	reserved = 1;
+
 	/*
 	 * XXX - page_mkwrite gets called every time the page is dirtied, even
 	 * if it was already dirty, so for space accounting reasons we need to
@@ -7760,7 +7770,8 @@ again:
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+	ret = btrfs_set_extent_delalloc(inode, page_start,
+					page_start + delalloc_size - 1,
 					&cached_state);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
@@ -7799,8 +7810,8 @@ out_unlock:
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
-out_noreserve:
+	if (reserved)
+		btrfs_delalloc_release_space(inode, delalloc_size);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
-- 
1.8.3.1

