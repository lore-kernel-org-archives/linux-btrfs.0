From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 09/10] Btrfs: use PagePrivate2 to check ordered data
Date: Tue, 27 Mar 2012 14:44:37 +0800
Message-ID: <1332830678-3992-10-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If a page has PagePrivate2 flag, it still remains as ordered data,
so we can check this flag directly instead of looking up an ordered
extent.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   45 +++++++++++++++------------------------------
 1 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7f5018d..bacf441 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6345,8 +6345,6 @@ static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 {
 	struct extent_io_tree *tree;
-	struct btrfs_ordered_extent *ordered;
-	struct extent_state *cached_state = NULL;
 	u64 page_start = page_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
 
@@ -6365,35 +6363,22 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
-	lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
-	ordered = btrfs_lookup_ordered_extent(page->mapping->host,
-					   page_offset(page));
-	if (ordered) {
-		/*
-		 * IO on this page will never be started, so we need
-		 * to account for any ordered extents now
-		 */
-		clear_extent_bit(tree, page_start, page_end,
-				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
-				 &cached_state, GFP_NOFS);
-		/*
-		 * whoever cleared the private bit is responsible
-		 * for the finish_ordered_io
-		 */
-		if (TestClearPagePrivate2(page)) {
-			btrfs_finish_ordered_io(page->mapping->host,
-						page_start, page_end);
-		}
-		btrfs_put_ordered_extent(ordered);
-		cached_state = NULL;
-		lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-				 GFP_NOFS);
-	}
+	/*
+	 * IO on this page will never be started, so we need
+	 * to account for any ordered extents now
+	 */
 	clear_extent_bit(tree, page_start, page_end,
-		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
+			 EXTENT_DIRTY | EXTENT_DELALLOC |
+			 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 1,
+			 NULL, GFP_NOFS);
+	/*
+	 * whoever cleared the private bit is responsible
+	 * for the finish_ordered_io
+	 */
+	if (TestClearPagePrivate2(page)) {
+		btrfs_finish_ordered_io(page->mapping->host,
+					page_start, page_end);
+	}
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
-- 
1.6.5.2

