Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53640 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaFXO3u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 10:29:50 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 24 Jun 2014 19:59:48 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 5532F1258056
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:17 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5OEU0B057671932
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 20:00:00 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5OEThdr023631
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:44 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH V3 9/9] Btrfs: subpagesize-blocksize: __extent_writepage: Write only dirty blocks of a page.
Date: Tue, 24 Jun 2014 19:59:08 +0530
Message-Id: <1403620148-28774-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code now loops across 'ordered extents' instead of 'extent maps' to figure
out the dirty blocks of the page to be submitted for a write operation.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 66 +++++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 24c148c..9130c93 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3191,19 +3191,19 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
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
 	u64 unlock_start = start;
 	sector_t sector;
 	struct extent_state *cached_state = NULL;
-	struct extent_map *em;
 	struct block_device *bdev;
 	int ret;
 	int nr = 0;
@@ -3247,7 +3247,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		kunmap_atomic(userpage);
 		flush_dcache_page(page);
 	}
-	pg_offset = 0;
 
 	set_page_extent_mapped(page);
 
@@ -3366,59 +3365,49 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			unlock_start = page_end + 1;
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
+			unlock_extent(tree, unlock_start, unlock_start + blocksize - 1);
+			unlock_start += blocksize;
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
+		if (compressed) {
 			unlock_extent(tree, unlock_start, cur + iosize - 1);
-			/*
-			 * end_io notification does not happen here for
-			 * compressed extents
+			/* we don't want to end_page_writeback on
+			 * a compressed extent.  this happens
+			 * elsewhere
 			 */
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
+			nr++;
 			cur += iosize;
-			pg_offset += iosize;
 			unlock_start = cur;
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
 
@@ -3449,7 +3438,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 				SetPageError(page);
 		}
 		cur = cur + iosize;
-		pg_offset += iosize;
 		nr++;
 	}
 done:
-- 
1.8.3.1

