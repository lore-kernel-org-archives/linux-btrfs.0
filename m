Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55978 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaIUS4K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 14:56:10 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 22 Sep 2014 04:56:09 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 5B3943578048
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:56:06 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s8LIbvfN15794386
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:37:57 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s8LIu5D4017795
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:56:05 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V7 12/16] Btrfs: subpagesize-blocksize: Search for all ordered extents that could span across a page.
Date: Mon, 22 Sep 2014 00:25:26 +0530
Message-Id: <1411325730-21817-13-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1411325730-21817-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1411325730-21817-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 3c33944..8ea21c1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3027,7 +3027,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 	while (1) {
 		lock_extent(tree, start, end);
-		ordered = btrfs_lookup_ordered_extent(inode, start);
+		ordered = btrfs_lookup_ordered_range(inode, start,
+						PAGE_CACHE_SIZE);
 		if (!ordered)
 			break;
 		unlock_extent(tree, start, end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 23ce9ff..91c5580 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1821,7 +1821,7 @@ again:
 	if (PagePrivate2(page))
 		goto out;
 
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_CACHE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
 				     page_end, &cached_state, GFP_NOFS);
@@ -7724,7 +7724,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 
 	if (!inode_evicting)
 		lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_CACHE_SIZE);
 	if (ordered) {
 		/*
 		 * IO on this page will never be started, so we need
@@ -7849,7 +7849,7 @@ again:
 	 * we can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish
 	 */
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
-- 
2.1.0

