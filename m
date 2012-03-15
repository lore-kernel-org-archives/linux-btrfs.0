From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 5/5] Btrfs: avoid splitting state when truncating pagecache
Date: Thu, 15 Mar 2012 17:12:17 +0800
Message-ID: <1331802737-29454-6-git-send-email-liubo2009@cn.fujitsu.com>
References: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

o   While we're invalidating a page, we hold the page lock, so lock_extent
    is not needed.

o   When we're truncating pagecache in both evict and truncate_freespace,
    after waiting pages' writeback flag, it is ensured that no IO comes in,
    so we can safely clear the range's state.  And this way we can avoid
    splitting state and reduce the write locks of extent state tree.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    5 +++++
 fs/btrfs/inode.c            |   15 +++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b30242f..b062b82 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -217,6 +217,11 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	}
 	spin_unlock(&trans->block_rsv->lock);
 
+	filemap_fdatawait(inode->i_mapping);
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
+			EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			1, 1, NULL, GFP_NOFS);
+
 	oldsize = i_size_read(inode);
 	btrfs_i_size_write(inode, 0);
 	truncate_pagecache(inode, oldsize, 0);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e9c4d6c..9077966 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3501,6 +3501,10 @@ void btrfs_evict_inode(struct inode *inode)
 
 	trace_btrfs_inode_evict(inode);
 
+	filemap_fdatawait(inode->i_mapping);
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
+			EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			1, 1, NULL, GFP_NOFS);
 	truncate_inode_pages(&inode->i_data, 0);
 	if (inode->i_nlink && (btrfs_root_refs(&root->root_item) != 0 ||
 			       btrfs_is_free_space_inode(root, inode)))
@@ -6339,7 +6343,6 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 {
 	struct extent_io_tree *tree;
 	struct btrfs_ordered_extent *ordered;
-	struct extent_state *cached_state = NULL;
 	u64 page_start = page_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
 
@@ -6358,8 +6361,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
-	lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-			 GFP_NOFS);
+
 	ordered = btrfs_lookup_ordered_extent(page->mapping->host,
 					   page_offset(page));
 	if (ordered) {
@@ -6370,7 +6372,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
-				 &cached_state, GFP_NOFS);
+				 NULL, GFP_NOFS);
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
@@ -6380,13 +6382,10 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 						page_start, page_end);
 		}
 		btrfs_put_ordered_extent(ordered);
-		cached_state = NULL;
-		lock_extent_bits(tree, page_start, page_end, 0, &cached_state,
-				 GFP_NOFS);
 	}
 	clear_extent_bit(tree, page_start, page_end,
 		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
+		 EXTENT_DO_ACCOUNTING, 1, 1, NULL, GFP_NOFS);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
-- 
1.6.5.2

