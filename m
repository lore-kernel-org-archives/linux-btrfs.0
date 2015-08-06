Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37334 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbHFKKt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 06:10:49 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 6 Aug 2015 15:40:46 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id CDF84E005E
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2015 15:44:58 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t76AAgfP3867016
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:40:42 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t76AAbIY020831
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:40:40 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH 06/11] Btrfs: Search for all ordered extents that could span across a page
Date: Thu,  6 Aug 2015 15:40:14 +0530
Message-Id: <1438855819-4328-7-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario it is not sufficient to search using the
first byte of the page to make sure that there are no ordered extents
present across the page. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c |  3 ++-
 fs/btrfs/inode.c     | 25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a3ec2c8..65691a0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3164,7 +3164,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 	while (1) {
 		lock_extent(tree, start, end);
-		ordered = btrfs_lookup_ordered_extent(inode, start);
+		ordered = btrfs_lookup_ordered_range(inode, start,
+						PAGE_CACHE_SIZE);
 		if (!ordered)
 			break;
 		unlock_extent(tree, start, end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b39273b..dad76ef 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1975,7 +1975,8 @@ again:
 	if (PagePrivate2(page))
 		goto out;
 
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+	ordered = btrfs_lookup_ordered_range(inode, page_start,
+					PAGE_CACHE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
 				     page_end, &cached_state, GFP_NOFS);
@@ -8519,6 +8520,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	struct extent_state *cached_state = NULL;
 	u64 page_start = page_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
+	u64 start;
+	u64 end;
 	int inode_evicting = inode->i_state & I_FREEING;
 
 	/*
@@ -8538,14 +8541,18 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 
 	if (!inode_evicting)
 		lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
-	ordered = btrfs_lookup_ordered_extent(inode, page_start);
+again:
+	start = page_start;
+	ordered = btrfs_lookup_ordered_range(inode, start,
+					page_end - start + 1);
 	if (ordered) {
+		end = min(page_end, ordered->file_offset + ordered->len - 1);
 		/*
 		 * IO on this page will never be started, so we need
 		 * to account for any ordered extents now
 		 */
 		if (!inode_evicting)
-			clear_extent_bit(tree, page_start, page_end,
+			clear_extent_bit(tree, start, end,
 					 EXTENT_DIRTY | EXTENT_DELALLOC |
 					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 					 EXTENT_DEFRAG, 1, 0, &cached_state,
@@ -8562,22 +8569,26 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 
 			spin_lock_irq(&tree->lock);
 			set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
-			new_len = page_start - ordered->file_offset;
+			new_len = start - ordered->file_offset;
 			if (new_len < ordered->truncated_len)
 				ordered->truncated_len = new_len;
 			spin_unlock_irq(&tree->lock);
 
 			if (btrfs_dec_test_ordered_pending(inode, &ordered,
-							   page_start,
-							   PAGE_CACHE_SIZE, 1))
+							   start,
+							   end - start + 1, 1))
 				btrfs_finish_ordered_io(ordered);
 		}
 		btrfs_put_ordered_extent(ordered);
 		if (!inode_evicting) {
 			cached_state = NULL;
-			lock_extent_bits(tree, page_start, page_end, 0,
+			lock_extent_bits(tree, start, end, 0,
 					 &cached_state);
 		}
+
+		start = end + 1;
+		if (start < page_end)
+			goto again;
 	}
 
 	if (!inode_evicting) {
-- 
2.1.0

