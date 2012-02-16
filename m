From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix deadlock on page lock when doing auto-defragment
Date: Thu, 16 Feb 2012 15:01:24 +0800
Message-ID: <4F3CA9C4.3090904@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When I ran xfstests circularly on a auto-defragment btrfs, the deadlock
happened.

Steps to reproduce:
[tty0]
 # export MOUNT_OPTIONS="-o autodefrag"
 # export TEST_DEV=<partition1>
 # export TEST_DIR=<mountpoint1>
 # export SCRATCH_DEV=<partition2>
 # export SCRATCH_MNT=<mountpoint2>
 # while [ 1 ]
 > do
 > ./check 091 127 263
 > sleep 1
 > done
[tty1]
 # while [ 1 ]
 > do
 > echo 3 > /proc/sys/vm/drop_caches
 > done

Several hours later, the test processes will hang on, and the deadlock will
happen on page lock.

The reason is that:
  Auto defrag task		Flush thread			Test task
				btrfs_writepages()
				  add ordered extent
				  (including page 1, 2)
				  set page 1 writeback
				  set page 2 writeback
				endio_fn()
				  end page 2 writeback
								release page 2
lock page 1
alloc and lock page 2
page 2 is not uptodate
  btrfs_readpage()
    start ordered extent()
    btrfs_writepages()
      try  to lock page 1

so deadlock happens.

Fix this bug by unlocking the page which is in writeback, and re-locking it
after the writeback end.

Signed-off-by: Miao Xie <miax@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   53 +++++++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b06a5c..e9bdb8b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -862,6 +862,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	int i_done;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_io_tree *tree;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
 	if (isize == 0)
@@ -872,18 +873,34 @@ static int cluster_pages_for_defrag(struct inode *inode,
 					   num_pages << PAGE_CACHE_SHIFT);
 	if (ret)
 		return ret;
-again:
-	ret = 0;
 	i_done = 0;
+	tree = &BTRFS_I(inode)->io_tree;
 
 	/* step one, lock all the pages */
 	for (i = 0; i < num_pages; i++) {
 		struct page *page;
+again:
 		page = find_or_create_page(inode->i_mapping,
-					    start_index + i, mask);
+					   start_index + i, mask);
 		if (!page)
 			break;
 
+		page_start = page_offset(page);
+		page_end = page_start + PAGE_CACHE_SIZE - 1;
+		while (1) {
+			lock_extent(tree, page_start, page_end, GFP_NOFS);
+			ordered = btrfs_lookup_ordered_extent(inode,
+							      page_start);
+			unlock_extent(tree, page_start, page_end, GFP_NOFS);
+			if (!ordered)
+				break;
+
+			unlock_page(page);
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+			lock_page(page);
+		}
+
 		if (!PageUptodate(page)) {
 			btrfs_readpage(NULL, page);
 			lock_page(page);
@@ -894,15 +911,22 @@ again:
 				break;
 			}
 		}
+
 		isize = i_size_read(inode);
 		file_end = (isize - 1) >> PAGE_CACHE_SHIFT;
-		if (!isize || page->index > file_end ||
-		    page->mapping != inode->i_mapping) {
+		if (!isize || page->index > file_end) {
 			/* whoops, we blew past eof, skip this page */
 			unlock_page(page);
 			page_cache_release(page);
 			break;
 		}
+
+		if (page->mapping != inode->i_mapping) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto again;
+		}
+
 		pages[i] = page;
 		i_done++;
 	}
@@ -925,25 +949,6 @@ again:
 	lock_extent_bits(&BTRFS_I(inode)->io_tree,
 			 page_start, page_end - 1, 0, &cached_state,
 			 GFP_NOFS);
-	ordered = btrfs_lookup_first_ordered_extent(inode, page_end - 1);
-	if (ordered &&
-	    ordered->file_offset + ordered->len > page_start &&
-	    ordered->file_offset < page_end) {
-		btrfs_put_ordered_extent(ordered);
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-				     page_start, page_end - 1,
-				     &cached_state, GFP_NOFS);
-		for (i = 0; i < i_done; i++) {
-			unlock_page(pages[i]);
-			page_cache_release(pages[i]);
-		}
-		btrfs_wait_ordered_range(inode, page_start,
-					 page_end - page_start);
-		goto again;
-	}
-	if (ordered)
-		btrfs_put_ordered_extent(ordered);
-
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
 			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-- 
1.7.6.5
