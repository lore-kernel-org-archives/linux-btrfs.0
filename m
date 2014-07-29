Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43182 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaG2LO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:14:27 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 16:44:25 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 7FDB5394005B
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:23 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6TBEjr92752930
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:45 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6TBEMuA013314
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:23 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V5 12/12] Btrfs: subpagesize-blocksize: Search for all ordered extents that could span across a page.
Date: Tue, 29 Jul 2014 16:43:47 +0530
Message-Id: <1406632427-2209-13-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario it is not sufficient to search using the
first byte of the page to make sure that there are no ordered extents
present across the page. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 3 ++-
 fs/btrfs/inode.c     | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f938a5c..84924c8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3066,7 +3066,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 	while (1) {
 		lock_extent(tree, start, end);
-		ordered = btrfs_lookup_ordered_extent(inode, start);
+		ordered = btrfs_lookup_ordered_range(inode, start,
+						PAGE_CACHE_SIZE);
 		if (!ordered)
 			break;
 		unlock_extent(tree, start, end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d7a3ca7..b710837 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1784,7 +1784,7 @@ again:
 	if (PagePrivate2(page))
 		goto out;
 
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_CACHE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
 				     page_end, &cached_state, GFP_NOFS);
@@ -7610,7 +7610,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 
 	if (!inode_evicting)
 		lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_CACHE_SIZE);
 	if (ordered) {
 		/*
 		 * IO on this page will never be started, so we need
@@ -7735,7 +7735,7 @@ again:
 	 * we can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish
 	 */
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
-- 
1.8.3.1

