Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51084 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965343AbaGPOrq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 10:47:46 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 17 Jul 2014 00:47:45 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 6D0EA2CE8055
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:43 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6GEUt0965732852
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:30:55 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6GElg5r007655
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:43 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V4 09/12] Btrfs: subpagesize-blocksize: __extent_writepage: Write only dirty blocks of a page.
Date: Wed, 16 Jul 2014 20:16:07 +0530
Message-Id: <1405521970-8119-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1405521970-8119-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1405521970-8119-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code now loops across 'ordered extents' instead of 'extent maps' to figure
out the dirty blocks of the page to be submitted for a write operation.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 68 +++++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 873c28f..1f35e99 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3189,22 +3189,22 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	struct inode *inode = page->mapping->host;
 	struct extent_page_data *epd = data;
 	struct extent_io_tree *tree = epd->tree;
+	struct btrfs_ordered_extent *ordered;
 	u64 start = page_offset(page);
 	u64 delalloc_start;
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
 	u64 cur = start;
 	u64 extent_offset;
+	u64 extent_end;
 	u64 last_byte = i_size_read(inode);
-	u64 block_start;
 	u64 iosize;
 	sector_t sector;
 	struct extent_state *cached_state = NULL;
-	struct extent_map *em;
 	struct block_device *bdev;
 	int ret;
 	int nr = 0;
-	size_t pg_offset = 0;
+	size_t pg_offset;
 	size_t blocksize;
 	loff_t i_size = i_size_read(inode);
 	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
@@ -3244,7 +3244,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		kunmap_atomic(userpage);
 		flush_dcache_page(page);
 	}
-	pg_offset = 0;
 
 	set_page_extent_mapped(page);
 
@@ -3355,57 +3354,45 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 							 page_end, NULL, 1);
 			break;
 		}
-		em = epd->get_extent(inode, page, pg_offset, cur,
-				     end - cur + 1, 1);
-		if (IS_ERR_OR_NULL(em)) {
-			SetPageError(page);
-			break;
+
+		ordered = btrfs_lookup_ordered_extent(inode, cur);
+		if (!ordered) {
+			cur += blocksize;
+			continue;
 		}
 
-		extent_offset = cur - em->start;
-		BUG_ON(extent_map_end(em) <= cur);
+		pg_offset = cur & (PAGE_CACHE_SIZE - 1);
+
+		extent_offset = cur - ordered->file_offset;
+		extent_end = ordered->file_offset + ordered->len;
+		extent_end = (extent_end < ordered->file_offset) ? -1 : extent_end;
+		BUG_ON(extent_end <= cur);
 		BUG_ON(end < cur);
-		iosize = min(extent_map_end(em) - cur, end - cur + 1);
+		iosize = min(extent_end - cur, end - cur + 1);
 		iosize = ALIGN(iosize, blocksize);
-		sector = (em->block_start + extent_offset) >> 9;
-		bdev = em->bdev;
-		block_start = em->block_start;
-		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
-		free_extent_map(em);
-		em = NULL;
-
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
+
 		/* leave this out until we have a page_mkwrite call */
 		if (0 && !test_range_bit(tree, cur, cur + iosize - 1,
 				   EXTENT_DIRTY, 0, NULL)) {
 			cur = cur + iosize;
-			pg_offset += iosize;
 			continue;
 		}
 
@@ -3436,7 +3423,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 				SetPageError(page);
 		}
 		cur = cur + iosize;
-		pg_offset += iosize;
 		nr++;
 	}
 done:
-- 
1.8.3.1

