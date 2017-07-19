Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53463 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751548AbdGSHsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 03:48:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17502ABE9
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jul 2017 07:48:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Remove unused parameters from volume.c functions
Date: Wed, 19 Jul 2017 10:48:42 +0300
Message-Id: <1500450522-22086-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170718160917.GX2866@twin.jikos.cz>
References: <20170718160917.GX2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This also adjusts the respective callers in other files. Those were found with
-Wunused-parameter.

btrfs_full_stripe_len's mapping_tree - introduced by
53b381b3abeb ("Btrfs: RAID5 and RAID6") but it was never really used even in
that commit

btrfs_is_parity_mirror's mirror_num - same as above

chunk_drange_filter's chunk_offset - introduced by 94e60d5a5c4b ("Btrfs: devid
subset filter") and never used.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 4 +---
 fs/btrfs/extent_io.c   | 2 +-
 fs/btrfs/volumes.c     | 7 ++-----
 fs/btrfs/volumes.h     | 3 +--
 4 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f8aa512e9de5..a53441ffce71 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
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

