From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 20/99] btrfs: set_extent_dirty can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:53 -0500
Message-ID: <20111124004222.134769361@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that all of the callers of set_extent_dirty use GFP_NOFS, we can
 drop the gfp_t argument entirely and allow set_extent_dirty to always
 pass GFP_NOFS.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    9 ++++-----
 fs/btrfs/extent_io.c   |    5 ++---
 fs/btrfs/extent_io.h   |    3 +--
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4363,8 +4363,7 @@ static int update_block_group(struct btr
 			spin_unlock(&cache->space_info->lock);
 
 			set_extent_dirty(info->pinned_extents,
-					 bytenr, bytenr + num_bytes - 1,
-					 GFP_NOFS | __GFP_NOFAIL);
+					 bytenr, bytenr + num_bytes - 1);
 		}
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -4404,7 +4403,7 @@ static int pin_down_extent(struct btrfs_
 	spin_unlock(&cache->space_info->lock);
 
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
-			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
+			 bytenr + num_bytes - 1);
 	return 0;
 }
 
@@ -5866,13 +5865,13 @@ struct extent_buffer *btrfs_init_new_buf
 		 */
 		if (root->log_transid % 2 == 0)
 			set_extent_dirty(&root->dirty_log_pages, buf->start,
-					buf->start + buf->len - 1, GFP_NOFS);
+					buf->start + buf->len - 1);
 		else
 			set_extent_new(&root->dirty_log_pages, buf->start,
 					buf->start + buf->len - 1, GFP_NOFS);
 	} else {
 		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
-			 buf->start + buf->len - 1, GFP_NOFS);
+			 buf->start + buf->len - 1);
 	}
 	trans->blocks_used++;
 	/* this returns a buffer locked for blocking */
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1167,10 +1167,9 @@ search_again:
 }
 
 /* wrappers around set/clear extent bit */
-void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-		      gfp_t mask)
+void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL, NULL, mask);
+	set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL, NULL, GFP_NOFS);
 }
 
 void set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -237,8 +237,7 @@ void set_extent_uptodate(struct extent_i
 			 struct extent_state **cached_state, gfp_t mask);
 void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		    gfp_t mask);
-void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-		      gfp_t mask);
+void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);


