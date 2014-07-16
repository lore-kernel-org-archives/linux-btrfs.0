Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44637 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965321AbaGPOrv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 10:47:51 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 17 Jul 2014 00:47:49 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 0ECF9357805B
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:48 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6GEV0f660424314
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:31:00 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6GElleA007736
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:47 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V4 11/12] Btrfs: subpagesize-blocksize: btrfs_page_mkwrite: Reserve space in sectorsized units.
Date: Wed, 16 Jul 2014 20:16:09 +0530
Message-Id: <1405521970-8119-12-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1405521970-8119-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1405521970-8119-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index a9c7bc8..3255568 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7690,26 +7690,23 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
@@ -7740,6 +7737,19 @@ again:
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
@@ -7752,7 +7762,8 @@ again:
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+	ret = btrfs_set_extent_delalloc(inode, page_start,
+					page_start + delalloc_size - 1,
 					&cached_state);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
@@ -7791,8 +7802,8 @@ out_unlock:
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

