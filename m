From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 08/11] Btrfs: simplfy calculation of stripe length for discard
 operation
Date: Wed, 11 Jan 2012 13:54:42 +0800
Message-ID: <4F0D2422.1060401@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs raid, while discarding a range of space, we'll need to know
the start offset and length to discard for each device, and it's done
in btrfs_map_block().

However the calculation is a bit complex for raid0 and raid10, so I
reimplement it based on a fact that:

        dev1          dev2           dev3    (raid0)
        -----------------------------------
        s0 s3 s6      s1 s4 s7       s2 s5

Each device has (total_stripes / nr_dev) stripes, or plus one.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |   95 +++++++++++++++++-----------------------------------
 1 files changed, 31 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 540fdd2..563ef65 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3024,80 +3024,47 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	atomic_set(&bbio->error, 0);
 
 	if (rw & REQ_DISCARD) {
+		int factor = 0;
+		int sub_stripes = 0;
+		u64 stripes_per_dev = 0;
+		u32 remaining_stripes = 0;
+
+		if (map->type &
+		    (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID10)) {
+			if (map->type & BTRFS_BLOCK_GROUP_RAID0)
+				sub_stripes = 1;
+			else
+				sub_stripes = map->sub_stripes;
+
+			factor = map->num_stripes / sub_stripes;
+			stripes_per_dev = div_u64_rem(stripe_nr_end -
+						      stripe_nr_orig,
+						      factor,
+						      &remaining_stripes);
+		}
+
 		for (i = 0; i < num_stripes; i++) {
 			bbio->stripes[i].physical =
 				map->stripes[stripe_index].physical +
 				stripe_offset + stripe_nr * map->stripe_len;
 			bbio->stripes[i].dev = map->stripes[stripe_index].dev;
 
-			if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
-				u64 stripes;
-				u32 last_stripe = 0;
-				int j;
-
-				div_u64_rem(stripe_nr_end - 1,
-					    map->num_stripes,
-					    &last_stripe);
-
-				for (j = 0; j < map->num_stripes; j++) {
-					u32 test;
-
-					div_u64_rem(stripe_nr_end - 1 - j,
-						    map->num_stripes, &test);
-					if (test == stripe_index)
-						break;
-				}
-				stripes = stripe_nr_end - 1 - j;
-				do_div(stripes, map->num_stripes);
-				bbio->stripes[i].length = map->stripe_len *
-					(stripes - stripe_nr + 1);
-
-				if (i == 0) {
+			if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
+					 BTRFS_BLOCK_GROUP_RAID10)) {
+				bbio->stripes[i].length = stripes_per_dev *
+							  map->stripe_len;
+				if (i / sub_stripes < remaining_stripes)
+					bbio->stripes[i].length +=
+						map->stripe_len;
+				if (i < sub_stripes)
 					bbio->stripes[i].length -=
 						stripe_offset;
-					stripe_offset = 0;
-				}
-				if (stripe_index == last_stripe)
-					bbio->stripes[i].length -=
-						stripe_end_offset;
-			} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
-				u64 stripes;
-				int j;
-				int factor = map->num_stripes /
-					     map->sub_stripes;
-				u32 last_stripe = 0;
-
-				div_u64_rem(stripe_nr_end - 1,
-					    factor, &last_stripe);
-				last_stripe *= map->sub_stripes;
-
-				for (j = 0; j < factor; j++) {
-					u32 test;
-
-					div_u64_rem(stripe_nr_end - 1 - j,
-						    factor, &test);
-
-					if (test ==
-					    stripe_index / map->sub_stripes)
-						break;
-				}
-				stripes = stripe_nr_end - 1 - j;
-				do_div(stripes, factor);
-				bbio->stripes[i].length = map->stripe_len *
-					(stripes - stripe_nr + 1);
-
-				if (i < map->sub_stripes) {
-					bbio->stripes[i].length -=
-						stripe_offset;
-					if (i == map->sub_stripes - 1)
-						stripe_offset = 0;
-				}
-				if (stripe_index >= last_stripe &&
-				    stripe_index <= (last_stripe +
-						     map->sub_stripes - 1)) {
+				if ((i / sub_stripes + 1) %
+				    sub_stripes == remaining_stripes)
 					bbio->stripes[i].length -=
 						stripe_end_offset;
-				}
+				if (i == sub_stripes - 1)
+					stripe_offset = 0;
 			} else
 				bbio->stripes[i].length = *length;
 
-- 
1.7.3.1
