Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35163 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdBCBuR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 20:50:17 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] Btrfs: create helper for processing bits on contiguous pages
Date: Thu,  2 Feb 2017 17:49:22 -0800
Message-Id: <1486086563-25543-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This introduces a new helper which can be used to process pages bits.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d5f3edb..2ef2d05 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1726,28 +1726,22 @@ STATIC u64 find_lock_delalloc_range(struct inode *inode,
 	return found;
 }
 
-void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 u64 delalloc_end, struct page *locked_page,
-				 unsigned clear_bits,
-				 unsigned long page_ops)
+static void __process_pages_contig(struct address_space *mapping,
+				   struct page *locked_page,
+				   pgoff_t start_index, pgoff_t end_index,
+				   unsigned long page_ops)
 {
-	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
-	int ret;
+	unsigned long nr_pages = end_index - start_index + 1;
+	pgoff_t index = start_index;
 	struct page *pages[16];
-	unsigned long index = start >> PAGE_SHIFT;
-	unsigned long end_index = end >> PAGE_SHIFT;
-	unsigned long nr_pages = end_index - index + 1;
+	unsigned ret;
 	int i;
 
-	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
-	if (page_ops == 0)
-		return;
-
 	if ((page_ops & PAGE_SET_ERROR) && nr_pages > 0)
-		mapping_set_error(inode->i_mapping, -EIO);
+		mapping_set_error(mapping, -EIO);
 
 	while (nr_pages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
+		ret = find_get_pages_contig(mapping, index,
 				     min_t(unsigned long,
 				     nr_pages, ARRAY_SIZE(pages)), pages);
 		for (i = 0; i < ret; i++) {
@@ -1777,6 +1771,19 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 	}
 }
 
+void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
+				 u64 delalloc_end, struct page *locked_page,
+				 unsigned clear_bits,
+				 unsigned long page_ops)
+{
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, clear_bits, 1, 0,
+			 NULL, GFP_NOFS);
+
+	__process_pages_contig(inode->i_mapping, locked_page,
+			       start >> PAGE_SHIFT, end >> PAGE_SHIFT,
+			       page_ops);
+}
+
 /*
  * count the number of bytes in the tree that have a given bit(s)
  * set.  This can be fairly slow, except for EXTENT_DIRTY which is
-- 
2.5.5

