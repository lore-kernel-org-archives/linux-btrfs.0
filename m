Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42101 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782Ab2HWLDB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 07:03:01 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7NB2wbU014075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 11:02:59 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7NB2vxE009419
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 11:02:58 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7NB2vQM022147
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 06:02:57 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: use flag EXTENT_DEFRAG for snapshot-aware defrag
Date: Thu, 23 Aug 2012 19:01:33 +0800
Message-Id: <1345719694-21250-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're going to use this flag EXTENT_DEFRAG to indicate which range
belongs to
defragment so that we can implement snapshow-aware defrag:

We set the EXTENT_DEFRAG flag when dirtying the extents that need
defragmented, so later on writeback thread can differentiate between
normal writeback and writeback started by defragmentation.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c        |   11 +++++++++--
 fs/btrfs/extent_io.h        |   29 ++++++++++++++---------------
 fs/btrfs/file.c             |    4 ++--
 fs/btrfs/free-space-cache.c |    7 ++++---
 fs/btrfs/inode.c            |   20 ++++++++++++--------
 fs/btrfs/ioctl.c            |    8 ++++----
 6 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bb25e89..f03ceff 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1143,6 +1143,14 @@ int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
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
@@ -3700,8 +3708,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			}
 			if (!test_range_bit(tree, em->start,
 					    extent_map_end(em) - 1,
-					    EXTENT_LOCKED | EXTENT_WRITEBACK,
-					    0, NULL)) {
+					    EXTENT_LOCKED, 0, NULL)) {
 				remove_extent_mapping(map, em);
 				/* once for the rb tree */
 				free_extent_map(em);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..d9dee94 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -5,21 +5,18 @@
 
 /* bits for the extent state */
 #define EXTENT_DIRTY 1
-#define EXTENT_WRITEBACK (1 << 1)
-#define EXTENT_UPTODATE (1 << 2)
-#define EXTENT_LOCKED (1 << 3)
-#define EXTENT_NEW (1 << 4)
-#define EXTENT_DELALLOC (1 << 5)
-#define EXTENT_DEFRAG (1 << 6)
-#define EXTENT_DEFRAG_DONE (1 << 7)
-#define EXTENT_BUFFER_FILLED (1 << 8)
-#define EXTENT_BOUNDARY (1 << 9)
-#define EXTENT_NODATASUM (1 << 10)
-#define EXTENT_DO_ACCOUNTING (1 << 11)
-#define EXTENT_FIRST_DELALLOC (1 << 12)
-#define EXTENT_NEED_WAIT (1 << 13)
-#define EXTENT_DAMAGED (1 << 14)
-#define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
+#define EXTENT_UPTODATE (1 << 1)
+#define EXTENT_LOCKED (1 << 2)
+#define EXTENT_NEW (1 << 3)
+#define EXTENT_DELALLOC (1 << 4)
+#define EXTENT_DEFRAG (1 << 5)
+#define EXTENT_BOUNDARY (1 << 6)
+#define EXTENT_NODATASUM (1 << 7)
+#define EXTENT_DO_ACCOUNTING (1 << 8)
+#define EXTENT_FIRST_DELALLOC (1 << 9)
+#define EXTENT_NEED_WAIT (1 << 10)
+#define EXTENT_DAMAGED (1 << 11)
+#define EXTENT_IOBITS (EXTENT_LOCKED)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
 /*
@@ -235,6 +232,8 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
+int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
+		      struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9aa01ec..c172868 100644
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
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6b10acf..53ff2da 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1023,7 +1023,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret < 0) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
-				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL,
+				 EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DEFRAG,
+				 0, 0, NULL,
 				 GFP_NOFS);
 		goto out;
 	}
@@ -1037,8 +1038,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		    found_key.offset != offset) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, 0,
 					 inode->i_size - 1,
-					 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0,
-					 NULL, GFP_NOFS);
+					 EXTENT_DIRTY | EXTENT_DELALLOC |
+					 EXTENT_DEFRAG, 0, 0, NULL, GFP_NOFS);
 			btrfs_release_path(path);
 			goto out;
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ea6a4ee..85bc35f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3529,7 +3529,8 @@ again:
 	}
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  EXTENT_DIRTY | EXTENT_DELALLOC |
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
@@ -5996,7 +5997,8 @@ unlock:
 	if (lockstart < lockend) {
 		if (create && len < lockend - lockstart) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockstart + len - 1, unlock_bits, 1, 0,
+					 lockstart + len - 1,
+					 unlock_bits | EXTENT_DEFRAG, 1, 0,
 					 &cached_state, GFP_NOFS);
 			/*
 			 * Beside unlock, we also need to cleanup reserved space
@@ -6004,8 +6006,8 @@ unlock:
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
@@ -6570,8 +6572,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
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
@@ -6587,7 +6589,8 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 	}
 	clear_extent_bit(tree, page_start, page_end,
 		 EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
-		 EXTENT_DO_ACCOUNTING, 1, 1, &cached_state, GFP_NOFS);
+		 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
+		 &cached_state, GFP_NOFS);
 	__btrfs_releasepage(page, GFP_NOFS);
 
 	ClearPageChecked(page);
@@ -6683,7 +6686,8 @@ again:
 	 * prepare_pages in the normal write path.
 	 */
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
+			  EXTENT_DIRTY | EXTENT_DELALLOC |
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a1fbca0..9449b84 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1022,8 +1022,8 @@ again:
 			 page_start, page_end - 1, 0, &cached_state);
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
 			  page_end - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
-			  EXTENT_DO_ACCOUNTING, 0, 0, &cached_state,
-			  GFP_NOFS);
+			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
+			  &cached_state, GFP_NOFS);
 
 	if (i_done != page_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -1034,8 +1034,8 @@ again:
 	}
 
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
-				  &cached_state);
+	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
+			  &cached_state, GFP_NOFS);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
-- 
1.7.7.6

