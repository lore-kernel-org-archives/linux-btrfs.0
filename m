Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39242 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIUS4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 14:56:07 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 22 Sep 2014 04:56:06 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 19EFA3578048
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:56:04 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s8LIvUaL35717126
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:57:30 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s8LIu3NH017780
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:56:03 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V7 11/16] Btrfs: subpagesize-blocksize: btrfs_page_mkwrite: Reserve space in sectorsized units.
Date: Mon, 22 Sep 2014 00:25:25 +0530
Message-Id: <1411325730-21817-12-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1411325730-21817-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1411325730-21817-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 7ad7d0f..23ce9ff 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7812,26 +7812,23 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
@@ -7862,6 +7859,19 @@ again:
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
@@ -7874,7 +7884,8 @@ again:
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+	ret = btrfs_set_extent_delalloc(inode, page_start,
+					page_start + delalloc_size - 1,
 					&cached_state);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
@@ -7913,8 +7924,8 @@ out_unlock:
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
2.1.0

