Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbbBYSYt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:49 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 564A5AAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:24:48 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 05/11] btrfs: replace remaining do_div calls with div_u64 variants
Date: Wed, 25 Feb 2015 19:24:47 +0100
Message-Id: <e3444596baf5b188d41687275760545b4101d600.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Switch to div_u64_rem that does type checking and has more obvious
semantics than do_div.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c      |  2 +-
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/scrub.c            |  4 ++--
 fs/btrfs/volumes.c          | 29 ++++++++++++++++-------------
 4 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4ccc3397c644..5840afe5e5f9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8670,7 +8670,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		min_free <<= 1;
 	} else if (index == BTRFS_RAID_RAID0) {
 		dev_min = fs_devices->rw_devices;
-		do_div(min_free, dev_min);
+		min_free = div64_u64(min_free, dev_min);
 	}
 
 	/* We need to do this so that we can look at pending chunks */
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 16cc62b87ba5..63219ba3a6c1 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1673,7 +1673,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 		 */
 		if (*bytes >= align) {
 			tmp = entry->offset - ctl->start + align - 1;
-			do_div(tmp, align);
+			tmp = div64_u64(tmp, align);
 			tmp = tmp * align + ctl->start;
 			align_off = tmp - entry->offset;
 		} else {
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 07be15d4ce7b..4cdf739c7a47 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2329,7 +2329,7 @@ static inline void __scrub_mark_bitmap(struct scrub_parity *sparity,
 	}
 
 	start -= sparity->logic_start;
-	offset = (int)do_div(start, sparity->stripe_len);
+	start = div_u64_rem(start, sparity->stripe_len, &offset);
 	offset /= sectorsize;
 	nsectors = (int)len / sectorsize;
 
@@ -2628,7 +2628,7 @@ static int get_raid56_logic_offset(u64 physical, int num,
 		stripe_nr = div_u64(stripe_nr, nr_data_stripes(map));
 
 		/* Work out the disk rotation on this stripe-set */
-		rot = do_div(stripe_nr, map->num_stripes);
+		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes, &rot);
 		/* calculate which stripe this data locates */
 		rot += i;
 		stripe_index = rot % map->num_stripes;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 446e4b24fc14..b7755924bc7f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4994,7 +4994,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	 * stripe_nr counts the total number of stripes we have to stride
 	 * to get to this block
 	 */
-	do_div(stripe_nr, stripe_len);
+	stripe_nr = div64_u64(stripe_nr, stripe_len);
 
 	stripe_offset = stripe_nr * stripe_len;
 	BUG_ON(offset < stripe_offset);
@@ -5010,7 +5010,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		/* allow a write of a full stripe, but make sure we don't
 		 * allow straddling of stripes
 		 */
-		do_div(raid56_full_stripe_start, full_stripe_len);
+		raid56_full_stripe_start = div64_u64(raid56_full_stripe_start,
+				full_stripe_len);
 		raid56_full_stripe_start *= full_stripe_len;
 	}
 
@@ -5143,7 +5144,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		if (rw & REQ_DISCARD)
 			num_stripes = min_t(u64, map->num_stripes,
 					    stripe_nr_end - stripe_nr_orig);
-		stripe_index = do_div(stripe_nr, map->num_stripes);
+		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
+				&stripe_index);
 		if (!(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)))
 			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
@@ -5171,7 +5173,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
 		int factor = map->num_stripes / map->sub_stripes;
 
-		stripe_index = do_div(stripe_nr, factor);
+		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 		stripe_index *= map->sub_stripes;
 
 		if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
@@ -5215,25 +5217,27 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			 * Mirror #2 is RAID5 parity block.
 			 * Mirror #3 is RAID6 Q block.
 			 */
-			stripe_index = do_div(stripe_nr, nr_data_stripes(map));
+			stripe_nr = div_u64_rem(stripe_nr,
+					nr_data_stripes(map), &stripe_index);
 			if (mirror_num > 1)
 				stripe_index = nr_data_stripes(map) +
 						mirror_num - 2;
 
 			/* We distribute the parity blocks across stripes */
-			tmp = stripe_nr + stripe_index;
-			stripe_index = do_div(tmp, map->num_stripes);
+			div_u64_rem(stripe_nr + stripe_index, map->num_stripes,
+					&stripe_index);
 			if (!(rw & (REQ_WRITE | REQ_DISCARD |
 				    REQ_GET_READ_MIRRORS)) && mirror_num <= 1)
 				mirror_num = 1;
 		}
 	} else {
 		/*
-		 * after this do_div call, stripe_nr is the number of stripes
-		 * on this device we have to walk to find the data, and
-		 * stripe_index is the number of our device in the stripe array
+		 * after this, stripe_nr is the number of stripes on this
+		 * device we have to walk to find the data, and stripe_index is
+		 * the number of our device in the stripe array
 		 */
-		stripe_index = do_div(stripe_nr, map->num_stripes);
+		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
+				&stripe_index);
 		mirror_num = stripe_index + 1;
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
@@ -5268,8 +5272,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				 sizeof(int) * tgtdev_indexes);
 
 		/* Work out the disk rotation on this stripe-set */
-		tmp = stripe_nr;
-		rot = do_div(tmp, num_stripes);
+		div_u64_rem(stripe_nr, num_stripes, &rot);
 
 		/* Fill in the logical address of each stripe */
 		tmp = stripe_nr * nr_data_stripes(map);
-- 
2.1.3

