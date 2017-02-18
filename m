Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43300 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdBRB3X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 20:29:23 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/7] Btrfs: helper for ops that requires full stripe
Date: Fri, 17 Feb 2017 17:28:20 -0800
Message-Id: <1487381301-865-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a helper to show directly whether ops require full stripe.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bcd44eb..4a334a9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5640,6 +5640,11 @@ static void handle_ops_on_dev_replace(enum btrfs_map_op op,
 	*bbio_ret = bbio;
 }
 
+static bool need_full_stripe(enum btrfs_map_op op)
+{
+	return (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS);
+}
+
 static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			     enum btrfs_map_op op,
 			     u64 logical, u64 *length,
@@ -5742,8 +5747,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
-	    op != BTRFS_MAP_WRITE && op != BTRFS_MAP_GET_READ_MIRRORS &&
-	    dev_replace->tgtdev != NULL) {
+	    !need_full_stripe(op) && dev_replace->tgtdev != NULL) {
 		ret = get_extra_mirror_from_replace(fs_info, logical, *length,
 						    dev_replace->srcdev->devid,
 						    &mirror_num,
@@ -5876,10 +5880,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		bbio->tgtdev_map = (int *)(bbio->stripes + num_alloc_stripes);
 
 	/* build raid_map */
-	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK &&
-	    need_raid_map &&
-	    ((op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS) ||
-	    mirror_num > 1)) {
+	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK && need_raid_map &&
+	    (need_full_stripe(op) || mirror_num > 1)) {
 		u64 tmp;
 		unsigned rot;
 
@@ -5914,14 +5916,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		stripe_index++;
 	}
 
-	if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
+	if (need_full_stripe(op))
 		max_errors = btrfs_chunk_max_errors(map);
 
 	if (bbio->raid_map)
 		sort_parity_stripes(bbio, num_stripes);
 
 	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL &&
-	    (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)) {
+	    need_full_stripe(op)) {
 		handle_ops_on_dev_replace(op, &bbio, dev_replace, &num_stripes,
 					  &max_errors);
 	}
-- 
2.5.5

