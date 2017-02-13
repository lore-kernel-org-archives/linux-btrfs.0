Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34750 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdBMXnX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 18:43:23 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: use helper to get used bytes of space_info
Date: Mon, 13 Feb 2017 15:42:21 -0800
Message-Id: <1487029341-12911-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This uses a helper instead of open code around used byte of space_info
everywhere.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 097fa4a..b2b0b82 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4118,6 +4118,15 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 	return ret;
 }
 
+static u64 btrfs_space_info_used(struct btrfs_space_info *s_info,
+				 bool may_used_included)
+{
+	ASSERT(s_info);
+	return s_info->bytes_used + s_info->bytes_reserved +
+		s_info->bytes_pinned + s_info->bytes_readonly +
+		((may_used_included) ? s_info->bytes_may_use : 0);
+}
+
 int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
@@ -4143,9 +4152,7 @@ int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
 again:
 	/* make sure we have enough space to handle the data first */
 	spin_lock(&data_sinfo->lock);
-	used = data_sinfo->bytes_used + data_sinfo->bytes_reserved +
-		data_sinfo->bytes_pinned + data_sinfo->bytes_readonly +
-		data_sinfo->bytes_may_use;
+	used = btrfs_space_info_used(data_sinfo, true);
 
 	if (used + bytes > data_sinfo->total_bytes) {
 		struct btrfs_trans_handle *trans;
@@ -4420,9 +4427,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 
 	info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
 	spin_lock(&info->lock);
-	left = info->total_bytes - info->bytes_used - info->bytes_pinned -
-		info->bytes_reserved - info->bytes_readonly -
-		info->bytes_may_use;
+	left = info->total_bytes - btrfs_space_info_used(info, true);
 	spin_unlock(&info->lock);
 
 	num_devs = get_profile_num_devs(fs_info, type);
@@ -4605,8 +4610,7 @@ static int can_overcommit(struct btrfs_root *root,
 		return 0;
 
 	profile = btrfs_get_alloc_profile(root, 0);
-	used = space_info->bytes_used + space_info->bytes_reserved +
-		space_info->bytes_pinned + space_info->bytes_readonly;
+	used = btrfs_space_info_used(space_info, false);
 
 	/*
 	 * We only want to allow over committing if we have lots of actual space
@@ -5105,6 +5109,7 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+
 /**
  * reserve_metadata_bytes - try to reserve bytes from the block_rsv's space
  * @root - the root we're allocating for
@@ -5134,9 +5139,7 @@ static int __reserve_metadata_bytes(struct btrfs_root *root,
 
 	spin_lock(&space_info->lock);
 	ret = -ENOSPC;
-	used = space_info->bytes_used + space_info->bytes_reserved +
-		space_info->bytes_pinned + space_info->bytes_readonly +
-		space_info->bytes_may_use;
+	used = btrfs_space_info_used(space_info, true);
 
 	/*
 	 * If we have enough space then hooray, make our reservation and carry
@@ -5629,9 +5632,7 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	block_rsv->size = min_t(u64, num_bytes, SZ_512M);
 
 	if (block_rsv->reserved < block_rsv->size) {
-		num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
-			sinfo->bytes_reserved + sinfo->bytes_readonly +
-			sinfo->bytes_may_use;
+		num_bytes = btrfs_space_info_used(sinfo, true);
 		if (sinfo->total_bytes > num_bytes) {
 			num_bytes = sinfo->total_bytes - num_bytes;
 			num_bytes = min(num_bytes,
@@ -7906,9 +7907,8 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
 	spin_lock(&info->lock);
 	btrfs_info(fs_info, "space_info %llu has %llu free, is %sfull",
 		   info->flags,
-		   info->total_bytes - info->bytes_used - info->bytes_pinned -
-		   info->bytes_reserved - info->bytes_readonly -
-		   info->bytes_may_use, (info->full) ? "" : "not ");
+		   info->total_bytes - btrfs_space_info_used(info, true),
+		   (info->full) ? "" : "not ");
 	btrfs_info(fs_info,
 		"space_info total=%llu, used=%llu, pinned=%llu, reserved=%llu, may_use=%llu, readonly=%llu",
 		info->total_bytes, info->bytes_used, info->bytes_pinned,
@@ -9344,8 +9344,7 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
 		    cache->bytes_super - btrfs_block_group_used(&cache->item);
 
-	if (sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned +
-	    sinfo->bytes_may_use + sinfo->bytes_readonly + num_bytes +
+	if (btrfs_space_info_used(sinfo, true) + num_bytes +
 	    min_allocable_bytes <= sinfo->total_bytes) {
 		sinfo->bytes_readonly += num_bytes;
 		cache->ro++;
@@ -9555,9 +9554,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 	 * all of the extents from this block group.  If we can, we're good
 	 */
 	if ((space_info->total_bytes != block_group->key.offset) &&
-	    (space_info->bytes_used + space_info->bytes_reserved +
-	     space_info->bytes_pinned + space_info->bytes_readonly +
-	     min_free < space_info->total_bytes)) {
+	    (btrfs_space_info_used(space_info, false) + min_free <
+	     space_info->total_bytes)) {
 		spin_unlock(&space_info->lock);
 		goto out;
 	}
-- 
2.5.5

