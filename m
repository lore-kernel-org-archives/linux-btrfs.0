Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:36726 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbeHNU6T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 16:58:19 -0400
Received: by mail-pl0-f65.google.com with SMTP id e11-v6so8634374plb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2018 11:10:00 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH] Btrfs: clean up scrub is_dev_replace parameter
Date: Tue, 14 Aug 2018 11:09:52 -0700
Message-Id: <340268ad4d290b780616010ae3a75347723ebf10.1534270161.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

struct scrub_ctx has an ->is_dev_replace member, so there's no point in
passing around is_dev_replace where sctx is available.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/scrub.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6702896cdb8f..276c67c3da2e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3342,8 +3342,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct map_lookup *map,
 					   struct btrfs_device *scrub_dev,
-					   int num, u64 base, u64 length,
-					   int is_dev_replace)
+					   int num, u64 base, u64 length)
 {
 	struct btrfs_path *path, *ppath;
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
@@ -3619,7 +3618,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			extent_physical = extent_logical - logical + physical;
 			extent_dev = scrub_dev;
 			extent_mirror_num = mirror_num;
-			if (is_dev_replace)
+			if (sctx->is_dev_replace)
 				scrub_remap_extent(fs_info, extent_logical,
 						   extent_len, &extent_physical,
 						   &extent_dev,
@@ -3717,8 +3716,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 					  struct btrfs_device *scrub_dev,
 					  u64 chunk_offset, u64 length,
 					  u64 dev_offset,
-					  struct btrfs_block_group_cache *cache,
-					  int is_dev_replace)
+					  struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
@@ -3755,8 +3753,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 		if (map->stripes[i].dev->bdev == scrub_dev->bdev &&
 		    map->stripes[i].physical == dev_offset) {
 			ret = scrub_stripe(sctx, map, scrub_dev, i,
-					   chunk_offset, length,
-					   is_dev_replace);
+					   chunk_offset, length);
 			if (ret)
 				goto out;
 		}
@@ -3769,8 +3766,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 
 static noinline_for_stack
 int scrub_enumerate_chunks(struct scrub_ctx *sctx,
-			   struct btrfs_device *scrub_dev, u64 start, u64 end,
-			   int is_dev_replace)
+			   struct btrfs_device *scrub_dev, u64 start, u64 end)
 {
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
@@ -3864,7 +3860,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 */
 		scrub_pause_on(fs_info);
 		ret = btrfs_inc_block_group_ro(fs_info, cache);
-		if (!ret && is_dev_replace) {
+		if (!ret && sctx->is_dev_replace) {
 			/*
 			 * If we are doing a device replace wait for any tasks
 			 * that started dellaloc right before we set the block
@@ -3929,7 +3925,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		dev_replace->item_needs_writeback = 1;
 		btrfs_dev_replace_write_unlock(&fs_info->dev_replace);
 		ret = scrub_chunk(sctx, scrub_dev, chunk_offset, length,
-				  found_key.offset, cache, is_dev_replace);
+				  found_key.offset, cache);
 
 		/*
 		 * flush, submit all pending read and write bios, afterwards
@@ -3997,7 +3993,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
-		if (is_dev_replace &&
+		if (sctx->is_dev_replace &&
 		    atomic64_read(&dev_replace->num_write_errors) > 0) {
 			ret = -EIO;
 			break;
@@ -4231,8 +4227,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	}
 
 	if (!ret)
-		ret = scrub_enumerate_chunks(sctx, dev, start, end,
-					     is_dev_replace);
+		ret = scrub_enumerate_chunks(sctx, dev, start, end);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
-- 
2.18.0
