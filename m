From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 21/99] btrfs: set_extent_bits can drop gfp_t argument
Date: Wed, 23 Nov 2011 19:35:54 -0500
Message-ID: <20111124004222.250620092@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that all of the callers of set_extent_bits use GFP_NOFS, we can
 drop the gfp_t argument entirely and allow set_extent_bits to always
 pass GFP_NOFS.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    4 ++--
 fs/btrfs/extent_io.c   |    9 ++++-----
 fs/btrfs/extent_io.h   |    2 +-
 fs/btrfs/file-item.c   |    2 +-
 fs/btrfs/relocation.c  |    4 ++--
 fs/btrfs/scrub.c       |    2 +-
 6 files changed, 11 insertions(+), 12 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -211,9 +211,9 @@ static int add_excluded_extent(struct bt
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
 
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1172,10 +1172,9 @@ void set_extent_dirty(struct extent_io_t
 	set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL, NULL, GFP_NOFS);
 }
 
-void set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, gfp_t mask)
+void set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 {
-	set_extent_bit(tree, start, end, bits, NULL, NULL, mask);
+	set_extent_bit(tree, start, end, bits, NULL, NULL, GFP_NOFS);
 }
 
 void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
@@ -2125,7 +2124,7 @@ static int bio_readpage_error(struct bio
 
 		/* set the bits in the private failure tree */
 		set_extent_bits(failure_tree, start, end,
-				EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
+				EXTENT_LOCKED | EXTENT_DIRTY);
 		ret = set_state_private(failure_tree, start,
 					(u64)(unsigned long)failrec);
 		if (ret < 0) {
@@ -2133,7 +2132,7 @@ static int bio_readpage_error(struct bio
 			return ret;
 		}
 		/* set the bits in the inode's tree */
-		set_extent_bits(tree, start, end, EXTENT_DAMAGED, GFP_NOFS);
+		set_extent_bits(tree, start, end, EXTENT_DAMAGED);
 	} else {
 		failrec = (struct io_failure_record *)(unsigned long)private;
 		pr_debug("bio_readpage_error: (found) logical=%llu, "
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -216,7 +216,7 @@ void clear_extent_bit(struct extent_io_t
 		      int bits, int wake, int delete,
 		      struct extent_state **cached);
 void set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, gfp_t mask);
+		     int bits);
 int __must_check set_extent_bit_excl(struct extent_io_tree *tree, u64 start,
 				     u64 end, int bits, int exclusive_bits,
 				     u64 *failed_start,
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -214,7 +214,7 @@ static int __btrfs_lookup_bio_sums(struc
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 					set_extent_bits(io_tree, offset,
 						offset + bvec->bv_len - 1,
-						EXTENT_NODATASUM, GFP_NOFS);
+						EXTENT_NODATASUM);
 				} else {
 					printk(KERN_INFO "btrfs no csum found "
 					       "for inode %llu start %llu\n",
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2645,7 +2645,7 @@ static void mark_block_processed(struct
 				 u64 bytenr, u32 blocksize)
 {
 	set_extent_bits(&rc->processed_blocks, bytenr, bytenr + blocksize - 1,
-			EXTENT_DIRTY, GFP_NOFS);
+			EXTENT_DIRTY);
 }
 
 static void __mark_block_processed(struct reloc_control *rc,
@@ -3015,7 +3015,7 @@ static int relocate_file_extent_cluster(
 		    page_start + offset == cluster->boundary[nr]) {
 			set_extent_bits(&BTRFS_I(inode)->io_tree,
 					page_start, page_end,
-					EXTENT_BOUNDARY, GFP_NOFS);
+					EXTENT_BOUNDARY);
 			nr++;
 		}
 
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -425,7 +425,7 @@ static int scrub_fixup_readpage(u64 inum
 		 * sure we read the bad mirror.
 		 */
 		set_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
-				EXTENT_DAMAGED, GFP_NOFS);
+				EXTENT_DAMAGED);
 
 		ret = extent_read_full_page(&BTRFS_I(inode)->io_tree, page,
 						btrfs_get_extent,


