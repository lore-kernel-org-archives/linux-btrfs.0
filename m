Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752294AbcLBFHt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:49 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C9CD2ABC3
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:47 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 05/18] btrfs: struct btrfsic_state->root should be an fs_info
Date: Fri,  2 Dec 2016 00:07:25 -0500
Message-Id: <1480655258-15400-6-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The root member is never used except for obtaining an fs_info pointer.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/check-integrity.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 86f681f..270da67 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -254,7 +254,7 @@ struct btrfsic_state {
 	struct list_head all_blocks_list;
 	struct btrfsic_block_hashtable block_hashtable;
 	struct btrfsic_block_link_hashtable block_link_hashtable;
-	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
 	u64 max_superblock_generation;
 	struct btrfsic_block *latest_superblock;
 	u32 metablock_size;
@@ -717,7 +717,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 		}
 
 		num_copies =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
@@ -888,7 +888,7 @@ static int btrfsic_process_superblock_dev_mirror(
 		}
 
 		num_copies =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
@@ -1263,7 +1263,7 @@ static int btrfsic_create_link_to_next_block(
 	*next_blockp = NULL;
 	if (0 == *num_copiesp) {
 		*num_copiesp =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
@@ -1457,7 +1457,7 @@ static int btrfsic_handle_extent_data(
 			chunk_len = num_bytes;
 
 		num_copies =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, state->datablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
@@ -1539,7 +1539,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	struct btrfs_device *device;
 
 	length = len;
-	ret = btrfs_map_block(state->root->fs_info, BTRFS_MAP_READ,
+	ret = btrfs_map_block(state->fs_info, BTRFS_MAP_READ,
 			      bytenr, &length, &multi, mirror_num);
 
 	if (ret) {
@@ -1741,7 +1741,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 	num_pages = state->metablock_size >> PAGE_SHIFT;
 	h = (struct btrfs_header *)datav[0];
 
-	if (memcmp(h->fsid, state->root->fs_info->fsid, BTRFS_UUID_SIZE))
+	if (memcmp(h->fsid, state->fs_info->fsid, BTRFS_UUID_SIZE))
 		return 1;
 
 	for (i = 0; i < num_pages; i++) {
@@ -2276,7 +2276,7 @@ static int btrfsic_process_written_superblock(
 		}
 
 		num_copies =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, BTRFS_SUPER_INFO_SIZE);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
@@ -2705,7 +2705,7 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 	struct btrfsic_block_data_ctx block_ctx;
 	int match = 0;
 
-	num_copies = btrfs_num_copies(state->root->fs_info,
+	num_copies = btrfs_num_copies(state->fs_info,
 				      bytenr, state->metablock_size);
 
 	for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
@@ -2936,7 +2936,7 @@ int btrfsic_mount(struct btrfs_root *root,
 		btrfsic_is_initialized = 1;
 	}
 	mutex_lock(&btrfsic_mutex);
-	state->root = root;
+	state->fs_info = root->fs_info;
 	state->print_mask = print_mask;
 	state->include_extent_data = including_extent_data;
 	state->csum_size = 0;
-- 
2.7.1

