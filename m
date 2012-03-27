From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 04/10] Btrfs: fix the mismatch of page->mapping
Date: Tue, 27 Mar 2012 14:44:32 +0800
Message-ID: <1332830678-3992-5-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

commit 600a45e1d5e376f679ff9ecc4ce9452710a6d27c
(Btrfs: fix deadlock on page lock when doing auto-defragment)
fixes the deadlock on page, but it also introduces another bug.

A page may have been truncated after unlock & lock.
So we need to find it again to get the right one.

And since we've held i_mutex lock, inode size remains unchanged and
we can drop isize overflow checks.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0acc828..81faa78 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -856,6 +856,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	u64 isize = i_size_read(inode);
 	u64 page_start;
 	u64 page_end;
+	u64 page_cnt;
 	int ret;
 	int i;
 	int i_done;
@@ -864,19 +865,21 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct extent_io_tree *tree;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
-	if (isize == 0)
-		return 0;
 	file_end = (isize - 1) >> PAGE_CACHE_SHIFT;
+	if (!isize || start_index > file_end)
+		return 0;
+
+	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(inode,
-					   num_pages << PAGE_CACHE_SHIFT);
+					   page_cnt << PAGE_CACHE_SHIFT);
 	if (ret)
 		return ret;
 	i_done = 0;
 	tree = &BTRFS_I(inode)->io_tree;
 
 	/* step one, lock all the pages */
-	for (i = 0; i < num_pages; i++) {
+	for (i = 0; i < page_cnt; i++) {
 		struct page *page;
 again:
 		page = find_or_create_page(inode->i_mapping,
@@ -898,6 +901,15 @@ again:
 			btrfs_start_ordered_extent(inode, ordered, 1);
 			btrfs_put_ordered_extent(ordered);
 			lock_page(page);
+			/*
+			 * we unlocked the page above, so we need check if
+			 * it was released or not.
+			 */
+			if (page->mapping != inode->i_mapping) {
+				unlock_page(page);
+				page_cache_release(page);
+				goto again;
+			}
 		}
 
 		if (!PageUptodate(page)) {
@@ -911,15 +923,6 @@ again:
 			}
 		}
 
-		isize = i_size_read(inode);
-		file_end = (isize - 1) >> PAGE_CACHE_SHIFT;
-		if (!isize || page->index > file_end) {
-			/* whoops, we blew past eof, skip this page */
-			unlock_page(page);
-			page_cache_release(page);
-			break;
-		}
-
 		if (page->mapping != inode->i_mapping) {
 			unlock_page(page);
 			page_cache_release(page);
@@ -953,12 +956,12 @@ again:
 			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
 			  GFP_NOFS);
 
-	if (i_done != num_pages) {
+	if (i_done != page_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents++;
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode,
-				     (num_pages - i_done) << PAGE_CACHE_SHIFT);
+				     (page_cnt - i_done) << PAGE_CACHE_SHIFT);
 	}
 
 
@@ -983,7 +986,7 @@ out:
 		unlock_page(pages[i]);
 		page_cache_release(pages[i]);
 	}
-	btrfs_delalloc_release_space(inode, num_pages << PAGE_CACHE_SHIFT);
+	btrfs_delalloc_release_space(inode, page_cnt << PAGE_CACHE_SHIFT);
 	return ret;
 
 }
-- 
1.6.5.2

