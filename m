From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 12/99] btrfs: clear_extent_dirty can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:45 -0500
Message-ID: <20111124004221.208632024@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 All of the callers of clear_extent_dirty call it with gfp_t == GFP_NOFS.

 This patch simplifies the call sites by calling clear_extent_bit with
 GFP_NOFS from clear_extent_dirty itself.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_io.c   |    5 ++---
 fs/btrfs/extent_io.h   |    3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3370,7 +3370,7 @@ static int btrfs_destroy_pinned_extent(s
 							 end + 1 - start,
 							 NULL);
 
-		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		clear_extent_dirty(unpin, start, end);
 		btrfs_error_unpin_extent_range(root, start, end);
 		cond_resched();
 	}
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4602,7 +4602,7 @@ int btrfs_finish_extent_commit(struct bt
 			ret = btrfs_discard_extent(root, start,
 						   end + 1 - start, NULL);
 
-		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		clear_extent_dirty(unpin, start, end);
 		unpin_extent_range(root, start, end);
 		cond_resched();
 	}
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1174,11 +1174,10 @@ int set_extent_delalloc(struct extent_io
 			      0, NULL, cached_state, mask);
 }
 
-void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-		       gfp_t mask)
+void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	clear_extent_bit(tree, start, end, EXTENT_DIRTY | EXTENT_DELALLOC |
-			 EXTENT_DO_ACCOUNTING, 0, 0, NULL, mask);
+			 EXTENT_DO_ACCOUNTING, 0, 0, NULL, GFP_NOFS);
 }
 
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -226,8 +226,7 @@ int set_extent_new(struct extent_io_tree
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask);
-void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-			gfp_t mask);
+void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,


