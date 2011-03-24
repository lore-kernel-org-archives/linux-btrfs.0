From: Li Dongyang <lidongyang@novell.com>
Subject: [PATCH V4 2/4] Btrfs: make btrfs_map_block() return entire free extent for each device of RAID0/1/10/DUP
Date: Thu, 24 Mar 2011 18:24:26 +0800
Message-ID: <1300962268-12774-3-git-send-email-lidongyang@novell.com>
References: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_map_block() will only return a single stripe length, but we want the
full extent be mapped to each disk when we are trimming the extent,
so we add length to btrfs_bio_stripe and fill it if we are mapping for REQ_DISCARD.

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/btrfs/volumes.c |  150 ++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/volumes.h |    1 +
 2 files changed, 129 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dd13eb8..e81cce6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2962,7 +2962,10 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	u64 offset;
 	u64 stripe_offset;
+	u64 stripe_end_offset;
 	u64 stripe_nr;
+	u64 stripe_nr_orig;
+	u64 stripe_nr_end;
 	int stripes_allocated = 8;
 	int stripes_required = 1;
 	int stripe_index;
@@ -2971,7 +2974,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	int max_errors = 0;
 	struct btrfs_multi_bio *multi = NULL;
 
-	if (multi_ret && !(rw & REQ_WRITE))
+	if (multi_ret && !(rw & (REQ_WRITE | REQ_DISCARD)))
 		stripes_allocated = 1;
 again:
 	if (multi_ret) {
@@ -3017,7 +3020,15 @@ again:
 			max_errors = 1;
 		}
 	}
-	if (multi_ret && (rw & REQ_WRITE) &&
+	if (rw & REQ_DISCARD) {
+		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
+				 BTRFS_BLOCK_GROUP_RAID1 |
+				 BTRFS_BLOCK_GROUP_DUP |
+				 BTRFS_BLOCK_GROUP_RAID10)) {
+			stripes_required = map->num_stripes;
+		}
+	}
+	if (multi_ret && (rw & (REQ_WRITE | REQ_DISCARD)) &&
 	    stripes_allocated < stripes_required) {
 		stripes_allocated = map->num_stripes;
 		free_extent_map(em);
@@ -3037,12 +3048,15 @@ again:
 	/* stripe_offset is the offset of this block in its stripe*/
 	stripe_offset = offset - stripe_offset;
 
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-			 BTRFS_BLOCK_GROUP_RAID10 |
-			 BTRFS_BLOCK_GROUP_DUP)) {
+	if (rw & REQ_DISCARD)
+		*length = min_t(u64, em->len - offset, *length);
+	else if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
+			      BTRFS_BLOCK_GROUP_RAID1 |
+			      BTRFS_BLOCK_GROUP_RAID10 |
+			      BTRFS_BLOCK_GROUP_DUP)) {
 		/* we limit the length of each bio to what fits in a stripe */
 		*length = min_t(u64, em->len - offset,
-			      map->stripe_len - stripe_offset);
+				map->stripe_len - stripe_offset);
 	} else {
 		*length = em->len - offset;
 	}
@@ -3052,8 +3066,19 @@ again:
 
 	num_stripes = 1;
 	stripe_index = 0;
-	if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (unplug_page || (rw & REQ_WRITE))
+	stripe_nr_orig = stripe_nr;
+	stripe_nr_end = (offset + *length + map->stripe_len - 1) &
+			(~(map->stripe_len - 1));
+	do_div(stripe_nr_end, map->stripe_len);
+	stripe_end_offset = stripe_nr_end * map->stripe_len -
+			    (offset + *length);
+	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
+		if (rw & REQ_DISCARD)
+			num_stripes = min_t(u64, map->num_stripes,
+					    stripe_nr_end - stripe_nr_orig);
+		stripe_index = do_div(stripe_nr, map->num_stripes);
+	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
+		if (unplug_page || (rw & (REQ_WRITE | REQ_DISCARD)))
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -3064,7 +3089,7 @@ again:
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (rw & REQ_WRITE)
+		if (rw & (REQ_WRITE | REQ_DISCARD))
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -3077,6 +3102,10 @@ again:
 
 		if (unplug_page || (rw & REQ_WRITE))
 			num_stripes = map->sub_stripes;
+		else if (rw & REQ_DISCARD)
+			num_stripes = min_t(u64, map->sub_stripes *
+					    (stripe_nr_end - stripe_nr_orig),
+					    map->num_stripes);
 		else if (mirror_num)
 			stripe_index += mirror_num - 1;
 		else {
@@ -3094,24 +3123,101 @@ again:
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
 
-	for (i = 0; i < num_stripes; i++) {
-		if (unplug_page) {
-			struct btrfs_device *device;
-			struct backing_dev_info *bdi;
-
-			device = map->stripes[stripe_index].dev;
-			if (device->bdev) {
-				bdi = blk_get_backing_dev_info(device->bdev);
-				if (bdi->unplug_io_fn)
-					bdi->unplug_io_fn(bdi, unplug_page);
-			}
-		} else {
+	if (rw & REQ_DISCARD) {
+		for (i = 0; i < num_stripes; i++) {
 			multi->stripes[i].physical =
 				map->stripes[stripe_index].physical +
 				stripe_offset + stripe_nr * map->stripe_len;
 			multi->stripes[i].dev = map->stripes[stripe_index].dev;
+
+			if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
+				u64 stripes;
+				int last_stripe = (stripe_nr_end - 1) %
+					map->num_stripes;
+				int j;
+
+				for (j = 0; j < map->num_stripes; j++) {
+					if ((stripe_nr_end - 1 - j) %
+					      map->num_stripes == stripe_index)
+						break;
+				}
+				stripes = stripe_nr_end - 1 - j;
+				do_div(stripes, map->num_stripes);
+				multi->stripes[i].length = map->stripe_len *
+					(stripes - stripe_nr + 1);
+
+				if (i == 0) {
+					multi->stripes[i].length -=
+						stripe_offset;
+					stripe_offset = 0;
+				}
+				if (stripe_index == last_stripe)
+					multi->stripes[i].length -=
+						stripe_end_offset;
+			} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
+				u64 stripes;
+				int j;
+				int factor = map->num_stripes /
+					     map->sub_stripes;
+				int last_stripe = (stripe_nr_end - 1) % factor;
+				last_stripe *= map->sub_stripes;
+
+				for (j = 0; j < factor; j++) {
+					if ((stripe_nr_end - 1 - j) % factor ==
+					    stripe_index / map->sub_stripes)
+						break;
+				}
+				stripes = stripe_nr_end - 1 - j;
+				do_div(stripes, factor);
+				multi->stripes[i].length = map->stripe_len *
+					(stripes - stripe_nr + 1);
+
+				if (i < map->sub_stripes) {
+					multi->stripes[i].length -=
+						stripe_offset;
+					if (i == map->sub_stripes - 1)
+						stripe_offset = 0;
+				}
+				if (stripe_index >= last_stripe &&
+				    stripe_index <= (last_stripe +
+						     map->sub_stripes - 1)) {
+					multi->stripes[i].length -=
+						stripe_end_offset;
+				}
+			} else
+				multi->stripes[i].length = *length;
+
+			stripe_index++;
+			if (stripe_index == map->num_stripes) {
+				/* This could only happen for RAID0/10 */
+				stripe_index = 0;
+				stripe_nr++;
+			}
+		}
+	} else {
+		for (i = 0; i < num_stripes; i++) {
+			if (unplug_page) {
+				struct btrfs_device *device;
+				struct backing_dev_info *bdi;
+
+				device = map->stripes[stripe_index].dev;
+				if (device->bdev) {
+					bdi = blk_get_backing_dev_info(device->
+								       bdev);
+					if (bdi->unplug_io_fn)
+						bdi->unplug_io_fn(bdi,
+								  unplug_page);
+				}
+			} else {
+				multi->stripes[i].physical =
+					map->stripes[stripe_index].physical +
+					stripe_offset +
+					stripe_nr * map->stripe_len;
+				multi->stripes[i].dev =
+					map->stripes[stripe_index].dev;
+			}
+			stripe_index++;
 		}
-		stripe_index++;
 	}
 	if (multi_ret) {
 		*multi_ret = multi;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7fb59d4..5ae2569 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -126,6 +126,7 @@ struct btrfs_fs_devices {
 struct btrfs_bio_stripe {
 	struct btrfs_device *dev;
 	u64 physical;
+	u64 length; /* only used for discard mappings */
 };
 
 struct btrfs_multi_bio {
-- 
1.7.4.1

