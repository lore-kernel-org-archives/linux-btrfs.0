Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbcFXWPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4DD59ADDF
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 19/31] btrfs: struct btrfsic_state->root should be an fs_info
Date: Fri, 24 Jun 2016 18:15:12 -0400
Message-Id: <1466806524-27508-20-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The root member is never used except for obtaining an fs_info pointer.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/check-integrity.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7706c8d..656e6fa 100644
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
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -891,7 +891,7 @@ static int btrfsic_process_superblock_dev_mirror(
 		}
 
 		num_copies =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -1272,7 +1272,7 @@ static int btrfsic_create_link_to_next_block(
 	*next_blockp = NULL;
 	if (0 == *num_copiesp) {
 		*num_copiesp =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -1474,7 +1474,7 @@ static int btrfsic_handle_extent_data(
 			chunk_len = num_bytes;
 
 		num_copies =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, state->datablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -1565,7 +1565,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	struct btrfs_device *device;
 
 	length = len;
-	ret = btrfs_map_block(state->root->fs_info, READ,
+	ret = btrfs_map_block(state->fs_info, READ,
 			      bytenr, &length, &multi, mirror_num);
 
 	if (ret) {
@@ -1774,7 +1774,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 	num_pages = state->metablock_size >> PAGE_SHIFT;
 	h = (struct btrfs_header *)datav[0];
 
-	if (memcmp(h->fsid, state->root->fs_info->fsid, BTRFS_UUID_SIZE))
+	if (memcmp(h->fsid, state->fs_info->fsid, BTRFS_UUID_SIZE))
 		return 1;
 
 	for (i = 0; i < num_pages; i++) {
@@ -2342,7 +2342,7 @@ static int btrfsic_process_written_superblock(
 		}
 
 		num_copies =
-		    btrfs_num_copies(state->root->fs_info,
+		    btrfs_num_copies(state->fs_info,
 				     next_bytenr, BTRFS_SUPER_INFO_SIZE);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
@@ -2802,7 +2802,7 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 	struct btrfsic_block_data_ctx block_ctx;
 	int match = 0;
 
-	num_copies = btrfs_num_copies(state->root->fs_info,
+	num_copies = btrfs_num_copies(state->fs_info,
 				      bytenr, state->metablock_size);
 
 	for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
@@ -3064,7 +3064,7 @@ int btrfsic_mount(struct btrfs_root *root,
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

