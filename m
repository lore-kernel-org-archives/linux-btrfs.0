From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 14/99] btrfs: clear_extent_bits can drop gfp_t argumetn
Date: Wed, 23 Nov 2011 19:35:47 -0500
Message-ID: <20111124004221.439441188@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 All of the callers of clear_extent_bits call it with gfp_t == GFP_NOFS.

 This patch simplifies the call sites by calling clear_extent_bit with
 GFP_NOFS from clear_extent_bits itself.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |    4 ++--
 fs/btrfs/extent_io.c   |   12 ++++++------
 fs/btrfs/extent_io.h   |    5 ++++-
 fs/btrfs/inode.c       |    3 +--
 fs/btrfs/relocation.c  |    3 +--
 fs/btrfs/scrub.c       |    2 +-
 fs/btrfs/transaction.c |    2 +-
 fs/btrfs/tree-log.c    |    2 +-
 9 files changed, 18 insertions(+), 17 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3309,7 +3309,7 @@ static int btrfs_destroy_marked_extents(
 		if (ret)
 			break;
 
-		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
+		clear_extent_bits(dirty_pages, start, end, mark);
 		while (start <= end) {
 			index = start >> PAGE_CACHE_SHIFT;
 			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -226,9 +226,9 @@ static void free_excluded_extents(struct
 	end = start + cache->key.offset - 1;
 
 	clear_extent_bits(&root->fs_info->freed_extents[0],
-			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+			  start, end, EXTENT_UPTODATE);
 	clear_extent_bits(&root->fs_info->freed_extents[1],
-			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+			  start, end, EXTENT_UPTODATE);
 }
 
 static int exclude_super_stripes(struct btrfs_root *root,
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1154,9 +1154,9 @@ int set_extent_bits(struct extent_io_tre
 }
 
 void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		      int bits, gfp_t mask)
+		       int bits)
 {
-	clear_extent_bit(tree, start, end, bits, 0, 0, NULL, mask);
+	clear_extent_bit(tree, start, end, bits, 0, 0, NULL, GFP_NOFS);
 }
 
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1903,12 +1903,12 @@ static void free_io_failure(struct inode
 
 	set_state_private(failure_tree, rec->start, 0);
 	clear_extent_bits(failure_tree, rec->start, rec->start + rec->len - 1,
-			  EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
+			  EXTENT_LOCKED | EXTENT_DIRTY);
 
 	if (did_repair)
 		clear_extent_bits(&BTRFS_I(inode)->io_tree, rec->start,
 				  rec->start + rec->len - 1,
-				  EXTENT_DAMAGED, GFP_NOFS);
+				  EXTENT_DAMAGED);
 
 	kfree(rec);
 }
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -205,7 +205,7 @@ u64 count_range_bits(struct extent_io_tr
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   int bits, int filled, struct extent_state *cached_state);
 void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, gfp_t mask);
+		       int bits);
 void clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
		      int bits, int wake, int delete,
		      struct extent_state **cached, gfp_t mask);
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1851,8 +1851,7 @@ static int btrfs_readpage_end_io_hook(st
 
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
 	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
-		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM,
-				  GFP_NOFS);
+		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM);
 		return 0;
 	}
 
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3842,8 +3842,7 @@ restart:
 	}
 
 	btrfs_release_path(path);
-	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY,
-			  GFP_NOFS);
+	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY);
 
 	if (trans) {
 		nr = trans->blocks_used;
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -443,7 +443,7 @@ static int scrub_fixup_readpage(u64 inum
 						end, EXTENT_DAMAGED, 0, NULL);
 		if (!corrected)
 			clear_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
-						EXTENT_DAMAGED, GFP_NOFS);
+					  EXTENT_DAMAGED);
 	}
 
 out:
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -612,7 +612,7 @@ int btrfs_wait_marked_extents(struct btr
 
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
 				      EXTENT_NEED_WAIT)) {
-		clear_extent_bits(dirty_pages, start, end, EXTENT_NEED_WAIT, GFP_NOFS);
+		clear_extent_bits(dirty_pages, start, end, EXTENT_NEED_WAIT);
 		err = filemap_fdatawait_range(mapping, start, end);
 		if (err)
 			werr = err;
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2180,7 +2180,7 @@ static void free_log_tree(struct btrfs_t
 			break;
 
 		clear_extent_bits(&log->dirty_log_pages, start, end,
-				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
+				  EXTENT_DIRTY | EXTENT_NEW);
 	}
 
 	free_extent_buffer(log->node);


