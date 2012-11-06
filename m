Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:25391 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 30.22 OK)
	with ESMTP id X03d73oA6Asmyc for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/26] Btrfs: Pass fs_info to btrfs_num_copies() instead of mapping_tree
Date: Tue,  6 Nov 2012 17:38:26 +0100
Message-Id: <0d2de30c21d1830b974dd0c323e8a8ea5b5f312d.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

This is required for the device replace procedure in a later step.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 12 ++++++------
 fs/btrfs/disk-io.c         |  2 +-
 fs/btrfs/extent_io.c       | 11 +++++------
 fs/btrfs/volumes.c         |  3 ++-
 fs/btrfs/volumes.h         |  2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 5a3e45d..58dfac1 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -723,7 +723,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 		}
 
 		num_copies =
-		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -903,7 +903,7 @@ static int btrfsic_process_superblock_dev_mirror(
 		}
 
 		num_copies =
-		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -1287,7 +1287,7 @@ static int btrfsic_create_link_to_next_block(
 	*next_blockp = NULL;
 	if (0 == *num_copiesp) {
 		*num_copiesp =
-		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -1489,7 +1489,7 @@ static int btrfsic_handle_extent_data(
 			chunk_len = num_bytes;
 
 		num_copies =
-		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->datablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -2463,7 +2463,7 @@ static int btrfsic_process_written_superblock(
 		}
 
 		num_copies =
-		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, BTRFS_SUPER_INFO_SIZE);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -2960,7 +2960,7 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 	struct btrfsic_block_data_ctx block_ctx;
 	int match = 0;
 
-	num_copies = btrfs_num_copies(&state->root->fs_info->mapping_tree,
+	num_copies = btrfs_num_copies(state->root->fs_info,
 				      bytenr, state->metablock_size);
 
 	for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0643159..f4b2733 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -387,7 +387,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
 			break;
 
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+		num_copies = btrfs_num_copies(root->fs_info,
 					      eb->start, eb->len);
 		if (num_copies == 1)
 			break;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 472873a..a18f5c9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2046,10 +2046,10 @@ static int clean_io_failure(u64 start, struct page *page)
 	spin_unlock(&BTRFS_I(inode)->io_tree.lock);
 
 	if (state && state->start == failrec->start) {
-		map_tree = &BTRFS_I(inode)->root->fs_info->mapping_tree;
-		num_copies = btrfs_num_copies(map_tree, failrec->logical,
-						failrec->len);
+		num_copies = btrfs_num_copies(BTRFS_I(inode)->root->fs_info,
+					      failrec->logical, failrec->len);
 		if (num_copies > 1)  {
+			map_tree = &BTRFS_I(inode)->root->fs_info->mapping_tree;
 			ret = repair_io_failure(map_tree, start, failrec->len,
 						failrec->logical, page,
 						failrec->failed_mirror);
@@ -2159,9 +2159,8 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		 * clean_io_failure() clean all those errors at once.
 		 */
 	}
-	num_copies = btrfs_num_copies(
-			      &BTRFS_I(inode)->root->fs_info->mapping_tree,
-			      failrec->logical, failrec->len);
+	num_copies = btrfs_num_copies(BTRFS_I(inode)->root->fs_info,
+				      failrec->logical, failrec->len);
 	if (num_copies == 1) {
 		/*
 		 * we only have a single copy of the data, so don't bother with
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bcd3097..133582b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3790,8 +3790,9 @@ void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
 	}
 }
 
-int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
+int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 {
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
 	struct extent_map_tree *em_tree = &map_tree->map_tree;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 657bb12..35ea442 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -278,7 +278,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
 void btrfs_cleanup_fs_uuids(void);
-int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
+int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
-- 
1.8.0

