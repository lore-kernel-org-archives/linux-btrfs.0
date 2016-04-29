Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JUb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EEAD6AD78
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/16] btrfs: sink gfp parameter to set_extent_bits
Date: Fri, 29 Apr 2016 11:20:17 +0200
Message-Id: <ceeb0ae7bf42a3deaaaee981d2da02e5d3ad2b0f.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass GFP_NOFS.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/extent_io.c   | 5 ++---
 fs/btrfs/extent_io.h   | 4 ++--
 fs/btrfs/file-item.c   | 2 +-
 fs/btrfs/relocation.c  | 4 ++--
 fs/btrfs/scrub.c       | 2 +-
 6 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 84e060eb0de8..0cfddbe8abba 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -231,9 +231,9 @@ static int add_excluded_extent(struct btrfs_root *root,
 {
 	u64 end = start + num_bytes - 1;
 	set_extent_bits(&root->fs_info->freed_extents[0],
-			start, end, EXTENT_UPTODATE, GFP_NOFS);
+			start, end, EXTENT_UPTODATE);
 	set_extent_bits(&root->fs_info->freed_extents[1],
-			start, end, EXTENT_UPTODATE, GFP_NOFS);
+			start, end, EXTENT_UPTODATE);
 	return 0;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d247fc0eea19..3b53d217066c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2232,13 +2232,12 @@ int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 
 		/* set the bits in the private failure tree */
 		ret = set_extent_bits(failure_tree, start, end,
-					EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
+					EXTENT_LOCKED | EXTENT_DIRTY);
 		if (ret >= 0)
 			ret = set_state_failrec(failure_tree, start, failrec);
 		/* set the bits in the inode's tree */
 		if (ret >= 0)
-			ret = set_extent_bits(tree, start, end, EXTENT_DAMAGED,
-						GFP_NOFS);
+			ret = set_extent_bits(tree, start, end, EXTENT_DAMAGED);
 		if (ret < 0) {
 			kfree(failrec);
 			return ret;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b5e0ade90e88..447c6e6ff88c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -259,9 +259,9 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   struct extent_state **cached_state, gfp_t mask);
 
 static inline int set_extent_bits(struct extent_io_tree *tree, u64 start,
-		u64 end, unsigned bits, gfp_t mask)
+		u64 end, unsigned bits)
 {
-	return set_extent_bit(tree, start, end, bits, NULL, NULL, mask);
+	return set_extent_bit(tree, start, end, bits, NULL, NULL, GFP_NOFS);
 }
 
 static inline int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 7a7d6e253cfc..62a81ee13a5f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -248,7 +248,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 					set_extent_bits(io_tree, offset,
 						offset + root->sectorsize - 1,
-						EXTENT_NODATASUM, GFP_NOFS);
+						EXTENT_NODATASUM);
 				} else {
 					btrfs_info(BTRFS_I(inode)->root->fs_info,
 						   "no csum found for inode %llu start %llu",
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 08ef890deca6..78cbfb530de6 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2814,7 +2814,7 @@ static void mark_block_processed(struct reloc_control *rc,
 				 u64 bytenr, u32 blocksize)
 {
 	set_extent_bits(&rc->processed_blocks, bytenr, bytenr + blocksize - 1,
-			EXTENT_DIRTY, GFP_NOFS);
+			EXTENT_DIRTY);
 }
 
 static void __mark_block_processed(struct reloc_control *rc,
@@ -3182,7 +3182,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		    page_start + offset == cluster->boundary[nr]) {
 			set_extent_bits(&BTRFS_I(inode)->io_tree,
 					page_start, page_end,
-					EXTENT_BOUNDARY, GFP_NOFS);
+					EXTENT_BOUNDARY);
 			nr++;
 		}
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4678f03e878e..9d24375eed1f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -745,7 +745,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 		 * sure we read the bad mirror.
 		 */
 		ret = set_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
-					EXTENT_DAMAGED, GFP_NOFS);
+					EXTENT_DAMAGED);
 		if (ret) {
 			/* set_extent_bits should give proper error */
 			WARN_ON(ret > 0);
-- 
2.7.1

