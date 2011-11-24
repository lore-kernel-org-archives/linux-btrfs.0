From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 22/99] btrfs: set_extent_delalloc can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:55 -0500
Message-ID: <20111124004222.366381392@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that all of the callers of set_extent_delalloc use GFP_NOFS, we can
 drop the gfp_t argument entirely and allow set_extent_delalloc to always
 pass GFP_NOFS.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    4 ++--
 fs/btrfs/extent_io.h |    2 +-
 fs/btrfs/inode.c     |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1191,10 +1191,10 @@ void clear_extent_bits(struct extent_io_
 }
 
 void set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
-			 struct extent_state **cached_state, gfp_t mask)
+			 struct extent_state **cached_state)
 {
 	set_extent_bit(tree, start, end, EXTENT_DELALLOC | EXTENT_UPTODATE,
-		       NULL, cached_state, mask);
+		       NULL, cached_state, GFP_NOFS);
 }
 
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -242,7 +242,7 @@ void clear_extent_dirty(struct extent_io
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);
 void set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
-			 struct extent_state **cached_state, gfp_t mask);
+			 struct extent_state **cached_state);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1535,7 +1535,7 @@ void btrfs_set_extent_delalloc(struct in
 	if ((end & (PAGE_CACHE_SIZE - 1)) == 0)
 		WARN_ON(1);
 	set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-			    cached_state, GFP_NOFS);
+			    cached_state);
 }
 
 /* see btrfs_writepage_start_hook for details on why this is required */


