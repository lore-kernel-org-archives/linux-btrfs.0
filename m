Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JUe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4262EAD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/16] btrfs: sink gfp parameter to clear_extent_bits
Date: Fri, 29 Apr 2016 11:20:20 +0200
Message-Id: <91166212e0ffbb4db50aa8a238548e967008b33d.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Callers pass GFP_NOFS and GFP_KERNEL. No need to pass the flags around.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c               | 2 +-
 fs/btrfs/extent-tree.c           | 8 ++++----
 fs/btrfs/extent_io.c             | 4 ++--
 fs/btrfs/extent_io.h             | 5 +++--
 fs/btrfs/inode.c                 | 3 +--
 fs/btrfs/relocation.c            | 3 +--
 fs/btrfs/scrub.c                 | 2 +-
 fs/btrfs/tests/extent-io-tests.c | 2 +-
 fs/btrfs/tree-log.c              | 2 +-
 9 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4e47849d7427..3bc88b4b0032 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4357,7 +4357,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 		if (ret)
 			break;
 
-		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
+		clear_extent_bits(dirty_pages, start, end, mark);
 		while (start <= end) {
 			eb = btrfs_find_tree_block(root->fs_info, start);
 			start += root->nodesize;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0cfddbe8abba..b1c6d7634e88 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -246,9 +246,9 @@ static void free_excluded_extents(struct btrfs_root *root,
 	end = start + cache->key.offset - 1;
 
 	clear_extent_bits(&root->fs_info->freed_extents[0],
-			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+			  start, end, EXTENT_UPTODATE);
 	clear_extent_bits(&root->fs_info->freed_extents[1],
-			  start, end, EXTENT_UPTODATE, GFP_NOFS);
+			  start, end, EXTENT_UPTODATE);
 }
 
 static int exclude_super_stripes(struct btrfs_root *root,
@@ -10526,14 +10526,14 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		 */
 		mutex_lock(&fs_info->unused_bg_unpin_mutex);
 		ret = clear_extent_bits(&fs_info->freed_extents[0], start, end,
-				  EXTENT_DIRTY, GFP_NOFS);
+				  EXTENT_DIRTY);
 		if (ret) {
 			mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 			btrfs_dec_block_group_ro(root, block_group);
 			goto end_trans;
 		}
 		ret = clear_extent_bits(&fs_info->freed_extents[1], start, end,
-				  EXTENT_DIRTY, GFP_NOFS);
+				  EXTENT_DIRTY);
 		if (ret) {
 			mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 			btrfs_dec_block_group_ro(root, block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3b53d217066c..2946c1522870 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1975,13 +1975,13 @@ int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 	set_state_failrec(failure_tree, rec->start, NULL);
 	ret = clear_extent_bits(failure_tree, rec->start,
 				rec->start + rec->len - 1,
-				EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
+				EXTENT_LOCKED | EXTENT_DIRTY);
 	if (ret)
 		err = ret;
 
 	ret = clear_extent_bits(&BTRFS_I(inode)->io_tree, rec->start,
 				rec->start + rec->len - 1,
-				EXTENT_DAMAGED, GFP_NOFS);
+				EXTENT_DAMAGED);
 	if (ret && !err)
 		err = ret;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 447c6e6ff88c..90c5c8176162 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -241,14 +241,15 @@ static inline int unlock_extent_cached(struct extent_io_tree *tree, u64 start,
 }
 
 static inline int clear_extent_bits(struct extent_io_tree *tree, u64 start,
-		u64 end, unsigned bits, gfp_t mask)
+		u64 end, unsigned bits)
 {
 	int wake = 0;
 
 	if (bits & EXTENT_LOCKED)
 		wake = 1;
 
-	return clear_extent_bit(tree, start, end, bits, wake, 0, NULL, mask);
+	return clear_extent_bit(tree, start, end, bits, wake, 0, NULL,
+			GFP_NOFS);
 }
 
 int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2aaba58b4856..d37997f4eb98 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3103,8 +3103,7 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
 	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
-		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM,
-				  GFP_NOFS);
+		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM);
 		return 0;
 	}
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 78cbfb530de6..bd5ea1a8a9f1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4059,8 +4059,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	}
 
 	btrfs_release_path(path);
-	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY,
-			  GFP_NOFS);
+	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY);
 
 	if (trans) {
 		btrfs_end_transaction_throttle(trans, rc->extent_root);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9d24375eed1f..841dae874a21 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -763,7 +763,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 						end, EXTENT_DAMAGED, 0, NULL);
 		if (!corrected)
 			clear_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
-						EXTENT_DAMAGED, GFP_NOFS);
+						EXTENT_DAMAGED);
 	}
 
 out:
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 70948b13bc81..88e28e5d2c38 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -262,7 +262,7 @@ static int test_find_delalloc(void)
 	}
 	ret = 0;
 out_bits:
-	clear_extent_bits(&tmp, 0, total_dirty - 1, (unsigned)-1, GFP_KERNEL);
+	clear_extent_bits(&tmp, 0, total_dirty - 1, (unsigned)-1);
 out:
 	if (locked_page)
 		put_page(locked_page);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 517d0ccb351e..a111e275ab9e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3001,7 +3001,7 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 			break;
 
 		clear_extent_bits(&log->dirty_log_pages, start, end,
-				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
+				  EXTENT_DIRTY | EXTENT_NEW);
 	}
 
 	/*
-- 
2.7.1

