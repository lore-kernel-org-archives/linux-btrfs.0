Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19919 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2IQKA7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 06:00:59 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz
Subject: [PATCH 1/2 v3] Btrfs: use flag EXTENT_DEFRAG for snapshot-aware defrag
Date: Mon, 17 Sep 2012 17:58:55 +0800
Message-Id: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're going to use this flag EXTENT_DEFRAG to indicate which range
belongs to defragment so that we can implement snapshow-aware defrag:

We set the EXTENT_DEFRAG flag when dirtying the extents that need
defragmented, so later on writeback thread can differentiate between
normal writeback and writeback started by defragmentation.

This patch is used for the latter one.

Originally patch by Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c |    8 ++++++++
 fs/btrfs/extent_io.h |    2 ++
 fs/btrfs/file.c      |    4 ++--
 fs/btrfs/inode.c     |   20 ++++++++++++--------
 fs/btrfs/ioctl.c     |    8 ++++----
 5 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c87847..604e404 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1144,6 +1144,14 @@ int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			      NULL, cached_state, mask);
 }
 
+int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
+		      struct extent_state **cached_state, gfp_t mask)
+{
+	return set_extent_bit(tree, start, end,
+			      EXTENT_DELALLOC | EXTENT_UPTODATE | EXTENT_DEFRAG,
+			      NULL, cached_state, mask);
+}
+
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..512f8da 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -235,6 +235,8 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
+int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
+		      struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5caf285..226690a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1173,8 +1173,8 @@ again:
 
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
 				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-				  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-				  GFP_NOFS);
+				  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
+				  0, 0, &cached_state, GFP_NOFS);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 				     start_pos, last_pos - 1, &cached_state,
 				     GFP_NOFS);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b2c3514..55857eb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3531,7 +3531,8 @@ again:
 	}
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  EXTENT_DIRTY | EXTENT_DELALLOC |
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
@@ -5998,7 +5999,8 @@ unlock:
 	if (lockstart < lockend) {
 		if (create && len < lockend - lockstart) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockstart + len - 1, unlock_bits, 1, 0,
+					 lockstart + len - 1,
+					 unlock_bits | EXTENT_DEFRAG, 1, 0,
 					 &cached_state, GFP_NOFS);
 			/*
 			 * Beside unlock, we also need to cleanup reserved space
@@ -6006,8 +6008,8 @@ unlock:
 			 */
 			clear_extent_bit(&BTRFS_I(inode)->io_tree,
 					 lockstart + len, lockend,
-					 unlock_bits | EXTENT_DO_ACCOUNTING,
-					 1, 0, NULL, GFP_NOFS);
+					 unlock_bits | EXTENT_DO_ACCOUNTING |
+					 EXTENT_DEFRAG, 1, 0, NULL, GFP_NOFS);
 		} else {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 					 lockend, unlock_bits, 1, 0,
@@ -6572,8 +6574,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		 */
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING, 1, 0,
-				 &cached_state, GFP_NOFS);
+				 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
+				 EXTENT_DEFRAG, 1, 0, &cached_state, GFP_NOFS);
 		/*
 		 * whoever cleared the private bit is responsible
 		 * for the finish_ordered_io
@@ -6589,7 +6591,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 	}
 	clear_extent_bit(tree, page_start, page_end,
 		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
+		 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
+		 &cached_state, GFP_NOFS);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
@@ -6686,7 +6689,8 @@ again:
 	 * prepare_pages in the normal write path.
 	 */
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  EXTENT_DIRTY | EXTENT_DELALLOC |
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 00ddf22..db91f77 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1027,8 +1027,8 @@ again:
 			 page_start, page_end - 1, 0, &cached_state);
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
 			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-			  GFP_NOFS);
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
+			  &cached_state, GFP_NOFS);
 
 	if (i_done != page_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -1039,8 +1039,8 @@ again:
 	}
 
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
-				  &cached_state);
+	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
+			  &cached_state, GFP_NOFS);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
-- 
1.7.7.6

