From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix eof while discarding extents
Date: Sun, 8 Apr 2012 18:43:44 +0800
Message-ID: <1333881824-23836-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <daniel@quora.org>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We miscalculate the length of extents we're discarding, and it leads to
an eof of device.

Reported-by: Daniel Blueman <daniel@quora.org>
Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a872b48..759d024 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3833,6 +3833,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		int sub_stripes = 0;
 		u64 stripes_per_dev = 0;
 		u32 remaining_stripes = 0;
+		u32 last_stripe = 0;
 
 		if (map->type &
 		    (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID10)) {
@@ -3846,6 +3847,8 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 						      stripe_nr_orig,
 						      factor,
 						      &remaining_stripes);
+			div_u64_rem(stripe_nr_end - 1, factor, &last_stripe);
+			last_stripe *= sub_stripes;
 		}
 
 		for (i = 0; i < num_stripes; i++) {
@@ -3858,16 +3861,29 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 					 BTRFS_BLOCK_GROUP_RAID10)) {
 				bbio->stripes[i].length = stripes_per_dev *
 							  map->stripe_len;
+
 				if (i / sub_stripes < remaining_stripes)
 					bbio->stripes[i].length +=
 						map->stripe_len;
+
+				/*
+				 * Special for the first stripe and
+				 * the last stripe:
+				 *
+				 * |-------|...|-------|
+				 *     |----------|
+				 *    off     end_off
+				 */
 				if (i < sub_stripes)
 					bbio->stripes[i].length -=
 						stripe_offset;
-				if ((i / sub_stripes + 1) %
-				    sub_stripes == remaining_stripes)
+
+				if (stripe_index >= last_stripe &&
+				    stripe_index <= (last_stripe +
+						     sub_stripes - 1))
 					bbio->stripes[i].length -=
 						stripe_end_offset;
+
 				if (i == sub_stripes - 1)
 					stripe_offset = 0;
 			} else
-- 
1.6.5.2

