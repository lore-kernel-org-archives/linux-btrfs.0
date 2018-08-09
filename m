Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46215 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeHIUcY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:24 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 15/17] btrfs: reset zones of unused block groups
Date: Fri, 10 Aug 2018 03:04:48 +0900
Message-Id: <20180809180450.5091-16-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For an HMZONED volume, a block group maps to a zone of the device. For
deleted unused block groups, the zone of the block group can be reset to
rewind the zone write pointer at the start of the zone.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/extent-tree.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a5f5935315c8..26989f6fe591 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2025,6 +2025,25 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 				ASSERT(btrfs_test_opt(fs_info, DEGRADED));
 				continue;
 			}
+
+			if (clear == BTRFS_CLEAR_OP_DISCARD &&
+			    btrfs_dev_is_sequential(stripe->dev,
+						    stripe->physical) &&
+			    stripe->length == stripe->dev->zone_size) {
+				ret = blkdev_reset_zones(stripe->dev->bdev,
+							 stripe->physical >> 9,
+							 stripe->length >> 9,
+							 GFP_NOFS);
+				if (ret)
+					discarded_bytes += stripe->length;
+				else
+					break;
+				set_bit(stripe->physical >>
+						stripe->dev->zone_size_shift,
+					stripe->dev->empty_zones);
+				continue;
+			}
+
 			req_q = bdev_get_queue(stripe->dev->bdev);
 			if (clear == BTRFS_CLEAR_OP_DISCARD &&
 			    !blk_queue_discard(req_q))
@@ -10958,7 +10977,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		spin_unlock(&space_info->lock);
 
 		/* DISCARD can flip during remount */
-		trimming = btrfs_test_opt(fs_info, DISCARD);
+		trimming = btrfs_test_opt(fs_info, DISCARD) ||
+				btrfs_fs_incompat(fs_info, HMZONED);
 
 		/* Implicit trim during transaction commit. */
 		if (trimming)
-- 
2.18.0

