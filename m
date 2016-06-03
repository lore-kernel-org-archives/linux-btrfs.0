Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25688 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbcFCTHH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 15:07:07 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v2] Btrfs: fix eb memory leak due to readpage failure
Date: Fri,  3 Jun 2016 12:08:38 -0700
Message-Id: <1464980918-8365-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

eb->io_pages is set in read_extent_buffer_pages().

In case of readpage failure, for pages that have been added to bio,
it calls bio_endio and later readpage_io_failed_hook() does the work.

When this eb's page (couldn't be the 1st page) fails to add itself to bio
due to failure in merge_bio(), it cannot decrease eb->io_pages via bio_endio,
 and ends up with a memory leak eventually.

This lets __do_readpage propagate errors to callers and adds the
 'atomic_dec(&eb->io_pages)'.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2:
  - Move 'dec io_pages' to the caller so that we're consistent with
    write_one_eb()

 fs/btrfs/extent_io.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d247fc0..0309388 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2869,6 +2869,7 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
  * into the tree that are removed when the IO is done (by the end_io
  * handlers)
  * XXX JDM: This needs looking at to ensure proper page locking
+ * return 0 on success, otherwise return error
  */
 static int __do_readpage(struct extent_io_tree *tree,
 			 struct page *page,
@@ -2890,7 +2891,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 	sector_t sector;
 	struct extent_map *em;
 	struct block_device *bdev;
-	int ret;
+	int ret = 0;
 	int nr = 0;
 	size_t pg_offset = 0;
 	size_t iosize;
@@ -3081,7 +3082,7 @@ out:
 			SetPageUptodate(page);
 		unlock_page(page);
 	}
-	return 0;
+	return ret;
 }
 
 static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
@@ -5204,8 +5205,17 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 						      get_extent, &bio,
 						      mirror_num, &bio_flags,
 						      READ | REQ_META);
-			if (err)
+			if (err) {
 				ret = err;
+				/*
+				 * We use &bio in above __extent_read_full_page,
+				 * so we ensure that if it returns error, the
+				 * current page fails to add itself to bio.
+				 *
+				 * We must dec io_pages by ourselves.
+				 */
+				atomic_dec(&eb->io_pages);
+			}
 		} else {
 			unlock_page(page);
 		}
-- 
2.5.5

