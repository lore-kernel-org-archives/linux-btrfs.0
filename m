Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59597 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750966AbdGMIht (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 04:37:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7EB15AC2F
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 08:37:47 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Remove unused parameters from volume.c functions
Date: Thu, 13 Jul 2017 11:37:42 +0300
Message-Id: <1499935063-24401-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1499935063-24401-1-git-send-email-nborisov@suse.com>
References: <1499935063-24401-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This also adjusts the respective callers in other files. Those were found with
-Wunused-parameter.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 6 ++----
 fs/btrfs/extent_io.c   | 2 +-
 fs/btrfs/volumes.c     | 7 ++-----
 fs/btrfs/volumes.h     | 3 +--
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f8aa512e9de5..d57f1f161fa2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5819,7 +5819,7 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	 */
 	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
-	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode), 
+	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),
 			num_bytes, 1);
 	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 }
@@ -9948,9 +9948,7 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
 
 	cache->sectorsize = fs_info->sectorsize;
 	cache->fs_info = fs_info;
-	cache->full_stripe_len = btrfs_full_stripe_len(fs_info,
-						       &fs_info->mapping_tree,
-						       start);
+	cache->full_stripe_len = btrfs_full_stripe_len(fs_info, start);
 	set_free_space_tree_thresholds(cache);
 
 	atomic_set(&cache->count, 1);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2e6f69908303..a6a71629190e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1997,7 +1997,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	 * read repair operation.
 	 */
 	btrfs_bio_counter_inc_blocked(fs_info);
-	if (btrfs_is_parity_mirror(fs_info, logical, length, mirror_num)) {
+	if (btrfs_is_parity_mirror(fs_info, logical, length)) {
 		/*
 		 * Note that we don't use BTRFS_MAP_WRITE because it's supposed
 		 * to update all raid stripes, but here we just want to correct
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9a38cbf233a1..171a8e79332f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3311,7 +3311,6 @@ static int chunk_devid_filter(struct extent_buffer *leaf,
 /* [pstart, pend) */
 static int chunk_drange_filter(struct extent_buffer *leaf,
 			       struct btrfs_chunk *chunk,
-			       u64 chunk_offset,
 			       struct btrfs_balance_args *bargs)
 {
 	struct btrfs_stripe *stripe;
@@ -3438,7 +3437,7 @@ static int should_balance_chunk(struct btrfs_fs_info *fs_info,
 
 	/* drange filter, makes sense only with devid filter */
 	if ((bargs->flags & BTRFS_BALANCE_ARGS_DRANGE) &&
-	    chunk_drange_filter(leaf, chunk, chunk_offset, bargs)) {
+	    chunk_drange_filter(leaf, chunk, bargs)) {
 		return 0;
 	}
 
@@ -5166,7 +5165,6 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 }
 
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
-				    struct btrfs_mapping_tree *map_tree,
 				    u64 logical)
 {
 	struct extent_map *em;
@@ -5184,8 +5182,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	return len;
 }
 
-int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
-			   u64 logical, u64 len, int mirror_num)
+int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6f45fd60d15a..706ca5c2e974 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -481,9 +481,8 @@ void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 					      struct btrfs_device *tgtdev);
 void btrfs_scratch_superblocks(struct block_device *bdev, const char *device_path);
 int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
-			   u64 logical, u64 len, int mirror_num);
+			   u64 logical, u64 len);
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
-				    struct btrfs_mapping_tree *map_tree,
 				    u64 logical);
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info,
-- 
2.7.4

