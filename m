From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 23/99] btrfs: set_extent_new can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:56 -0500
Message-ID: <20111124004222.482825916@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that all of the callers of set_extent_new use GFP_NOFS, we can
 drop the gfp_t argument entirely and allow set_extent_new to always
 pass GFP_NOFS.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_io.c   |    5 ++---
 fs/btrfs/extent_io.h   |    3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5868,7 +5868,7 @@ struct extent_buffer *btrfs_init_new_buf
 					buf->start + buf->len - 1);
 		else
 			set_extent_new(&root->dirty_log_pages, buf->start,
-					buf->start + buf->len - 1, GFP_NOFS);
+					buf->start + buf->len - 1);
 	} else {
 		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
 			 buf->start + buf->len - 1);
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1203,10 +1203,9 @@ void clear_extent_dirty(struct extent_io
 			 EXTENT_DO_ACCOUNTING, 0, 0, NULL);
 }
 
-void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
-		    gfp_t mask)
+void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	set_extent_bit(tree, start, end, EXTENT_NEW, NULL, NULL, mask);
+	set_extent_bit(tree, start, end, EXTENT_NEW, NULL, NULL, GFP_NOFS);
 }
 
 int set_extent_uptodate_atomic(struct extent_io_tree *tree, u64 start, u64 end,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -235,8 +235,7 @@ int __must_check set_extent_uptodate_ato
 					    gfp_t mask);
 void set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached_state, gfp_t mask);
-void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
-		    gfp_t mask);
+void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end);
 void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,


