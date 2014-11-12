Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41688 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaKLISi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 03:18:38 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Nov 2014 18:18:37 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id D77092CE8066
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:35 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAC8KUU433620144
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:20:30 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAC8IYdx009012
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:35 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, steve.capper@linaro.org
Subject: [RFC PATCH V8 09/16] Btrfs: subpagesize-blocksize: __extent_writepage: Write only dirty blocks of a page.
Date: Wed, 12 Nov 2014 13:47:41 +0530
Message-Id: <1415780268-2017-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code now loops across 'ordered extents' instead of 'extent maps' to figure
out the dirty blocks of the page to be submitted for a write operation.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 74 ++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f9db1be..3c33944 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3186,18 +3186,18 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 				 int write_flags, int *nr_ret)
 {
 	struct extent_io_tree *tree = epd->tree;
+	struct btrfs_ordered_extent *ordered;
 	u64 start = page_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
 	u64 cur = start;
 	u64 extent_offset;
-	u64 block_start;
+	u64 extent_end;
 	u64 iosize;
 	sector_t sector;
 	struct extent_state *cached_state = NULL;
-	struct extent_map *em;
 	struct block_device *bdev;
-	size_t pg_offset = 0;
+	size_t pg_offset;
 	size_t blocksize;
 	int ret = 0;
 	int nr = 0;
@@ -3237,59 +3237,46 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	blocksize = inode->i_sb->s_blocksize;
 
 	while (cur <= end) {
-		u64 em_end;
 		if (cur >= i_size) {
 			if (tree->ops && tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, cur,
 							 page_end, NULL, 1);
 			break;
 		}
-		em = epd->get_extent(inode, page, pg_offset, cur,
-				     end - cur + 1, 1);
-		if (IS_ERR_OR_NULL(em)) {
-			SetPageError(page);
-			ret = PTR_ERR_OR_ZERO(em);
-			break;
-		}
 
-		extent_offset = cur - em->start;
-		em_end = extent_map_end(em);
-		BUG_ON(em_end <= cur);
+		ordered = btrfs_lookup_ordered_extent(inode, cur);
+		if (!ordered) {
+			cur += blocksize;
+			continue;
+ 		}
+
+		pg_offset = cur & (PAGE_CACHE_SIZE - 1);
+
+		extent_offset = cur - ordered->file_offset;
+		extent_end = ordered->file_offset + ordered->len;
+		extent_end = (extent_end < ordered->file_offset) ? -1 : extent_end;
+		BUG_ON(extent_end <= cur);
 		BUG_ON(end < cur);
-		iosize = min(em_end - cur, end - cur + 1);
+		iosize = min(extent_end - cur, end - cur + 1);
 		iosize = ALIGN(iosize, blocksize);
-		sector = (em->block_start + extent_offset) >> 9;
-		bdev = em->bdev;
-		block_start = em->block_start;
-		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
-		free_extent_map(em);
-		em = NULL;
+
+		sector = (ordered->start + extent_offset) >> 9;
+		bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
+		compressed = test_bit(BTRFS_ORDERED_COMPRESSED, &ordered->flags);
+		btrfs_put_ordered_extent(ordered);
+		ordered = NULL;
 
 		/*
 		 * compressed and inline extents are written through other
 		 * paths in the FS
 		 */
-		if (compressed || block_start == EXTENT_MAP_HOLE ||
-		    block_start == EXTENT_MAP_INLINE) {
-			/*
-			 * end_io notification does not happen here for
-			 * compressed extents
-			 */
-			if (!compressed && tree->ops &&
-			    tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, cur,
-							 cur + iosize - 1,
-							 NULL, 1);
-			else if (compressed) {
-				/* we don't want to end_page_writeback on
-				 * a compressed extent.  this happens
-				 * elsewhere
-				 */
-				nr++;
-			}
-
+		if (compressed) {
+			/* we don't want to end_page_writeback on
+			 * a compressed extent.  this happens
+			 * elsewhere
+ 			 */
+			nr++;
 			cur += iosize;
-			pg_offset += iosize;
 			continue;
 		}
 
@@ -3320,7 +3307,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 				SetPageError(page);
 		}
 		cur = cur + iosize;
-		pg_offset += iosize;
 		nr++;
 	}
 done:
@@ -3348,7 +3334,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	int ret;
 	int nr = 0;
-	size_t pg_offset = 0;
+	size_t pg_offset;
 	loff_t i_size = i_size_read(inode);
 	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
 	int write_flags;
@@ -3383,8 +3369,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		flush_dcache_page(page);
 	}
 
-	pg_offset = 0;
-
 	set_page_extent_mapped(page);
 
 	ret = writepage_delalloc(inode, page, wbc, epd, start, &nr_written);
-- 
2.1.0

