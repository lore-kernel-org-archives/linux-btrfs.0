From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 15/99] btrfs: try_lock_extent can drop gfp_t argumetn
Date: Wed, 23 Nov 2011 19:35:48 -0500
Message-ID: <20111124004221.554946617@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 All of the callers of try_lock_extent call it with gfp_t == GFP_NOFS.

 This patch simplifies the call sites by calling clear_extent_bit with
 GFP_NOFS from try_lock_extent itself.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c  |   22 ++++++----------------
 fs/btrfs/extent_io.h  |    4 ++--
 fs/btrfs/relocation.c |    3 +--
 3 files changed, 9 insertions(+), 20 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1238,28 +1238,18 @@ int lock_extent(struct extent_io_tree *t
 	return lock_extent_bits(tree, start, end, 0, NULL, mask);
 }
 
-int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
-		    gfp_t mask)
+int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	int err;
 	u64 failed_start;
 
 	err = set_extent_bit(tree, start, end, EXTENT_LOCKED, EXTENT_LOCKED,
-			     &failed_start, NULL, mask);
+			     &failed_start, NULL, GFP_NOFS);
 	if (err == -EEXIST) {
-		if (failed_start > start) {
-			if (mask & __GFP_WAIT)
-				clear_extent_bit(tree, start, failed_start - 1,
-						 EXTENT_LOCKED, 1, 0, NULL,
-						 mask);
-			else {
-				err = clear_extent_bit_atomic(tree, start,
-						failed_start - 1,
-						EXTENT_LOCKED, 1, 0,
-						NULL, mask);
-				BUG_ON(err < 0);
-			}
-		}
+		if (failed_start > start)
+			clear_extent_bit(tree, start, failed_start - 1,
+					 EXTENT_LOCKED, 1, 0, NULL,
+					 GFP_NOFS);
 		return 0;
 	}
 	return 1;
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -191,8 +191,8 @@ int __must_check unlock_extent_cached_at
 					     struct extent_state **cached);
 void unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			  struct extent_state **cached);
-int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
-		    gfp_t mask);
+int __must_check try_lock_extent(struct extent_io_tree *tree, u64 start,
+				 u64 end);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent, int mirror_num);
 int __init extent_io_init(void);
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1596,8 +1596,7 @@ int replace_file_extents(struct btrfs_tr
 				WARN_ON(!IS_ALIGNED(end, root->sectorsize));
 				end--;
 				ret = try_lock_extent(&BTRFS_I(inode)->io_tree,
-						      key.offset, end,
-						      GFP_NOFS);
+						      key.offset, end);
 				if (!ret)
 					continue;
 


