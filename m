Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730017AbeGMTCk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 15:02:40 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 567F5AD0C
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 18:46:49 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: add support for 3-copy replication (raid1c3)
Date: Fri, 13 Jul 2018 20:46:31 +0200
Message-Id: <7b570d84f5232322564e49f88990b733234c372c.1531503452.git.dsterba@suse.com>
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>
References: <cover.1531503452.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new block group profile to store 3 copies in a simliar way that
current RAID1 does. The profile name is temporary and may change in the
future.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c          |  6 +++++
 fs/btrfs/relocation.c           |  1 +
 fs/btrfs/scrub.c                |  3 ++-
 fs/btrfs/super.c                |  3 +++
 fs/btrfs/volumes.c              | 40 ++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h              |  2 ++
 include/uapi/linux/btrfs.h      |  3 ++-
 include/uapi/linux/btrfs_tree.h |  3 +++
 8 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4ffa64e288da..47f929dcc3d4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7527,6 +7527,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		if (!block_group_bits(block_group, flags)) {
 		    u64 extra = BTRFS_BLOCK_GROUP_DUP |
 				BTRFS_BLOCK_GROUP_RAID1 |
+				BTRFS_BLOCK_GROUP_RAID1C3 |
 				BTRFS_BLOCK_GROUP_RAID5 |
 				BTRFS_BLOCK_GROUP_RAID6 |
 				BTRFS_BLOCK_GROUP_RAID10;
@@ -9330,6 +9331,8 @@ static u64 update_block_group_flags(struct btrfs_fs_info *fs_info, u64 flags)
 
 	num_devices = fs_info->fs_devices->rw_devices;
 
+	ASSERT(!(flags & BTRFS_BLOCK_GROUP_RAID1C3));
+
 	stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
 		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
@@ -9647,6 +9650,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 		min_free >>= 1;
 	} else if (index == BTRFS_RAID_RAID1) {
 		dev_min = 2;
+	} else if (index == BTRFS_RAID_RAID1C3) {
+		dev_min = 3;
 	} else if (index == BTRFS_RAID_DUP) {
 		/* Multiply by 2 */
 		min_free <<= 1;
@@ -10141,6 +10146,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		if (!(get_alloc_profile(info, space_info->flags) &
 		      (BTRFS_BLOCK_GROUP_RAID10 |
 		       BTRFS_BLOCK_GROUP_RAID1 |
+		       BTRFS_BLOCK_GROUP_RAID1C3 |
 		       BTRFS_BLOCK_GROUP_RAID5 |
 		       BTRFS_BLOCK_GROUP_RAID6 |
 		       BTRFS_BLOCK_GROUP_DUP)))
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 879b76fa881a..fea9e7e96b87 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4339,6 +4339,7 @@ static void describe_relocation(struct btrfs_fs_info *fs_info,
 		DESCRIBE_FLAG(METADATA, "metadata");
 		DESCRIBE_FLAG(RAID0,    "raid0");
 		DESCRIBE_FLAG(RAID1,    "raid1");
+		DESCRIBE_FLAG(RAID1C3,  "raid1c3");
 		DESCRIBE_FLAG(DUP,      "dup");
 		DESCRIBE_FLAG(RAID10,   "raid10");
 		DESCRIBE_FLAG(RAID5,    "raid5");
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 572306036477..e9355759f2ec 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3388,7 +3388,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		offset = map->stripe_len * (num / map->sub_stripes);
 		increment = map->stripe_len * factor;
 		mirror_num = num % map->sub_stripes + 1;
-	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
+	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+				BTRFS_BLOCK_GROUP_RAID1C3)) {
 		increment = map->stripe_len;
 		mirror_num = num % map->num_stripes + 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4f646b66cc06..86e6aa5ef788 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1977,6 +1977,9 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
 		min_stripes = 2;
 		num_stripes = 2;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID1C3) {
+		min_stripes = 3;
+		num_stripes = 3;
 	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
 		min_stripes = 4;
 		num_stripes = 4;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 45635f4d78c8..0920b31e999d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -116,6 +116,18 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID6,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
 	},
+	[BTRFS_RAID_RAID1C3] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 3,
+		.tolerated_failures = 2,
+		.devs_increment	= 3,
+		.ncopies	= 3,
+		.raid_name	= "raid1c3",
+		.bg_flag	= BTRFS_BLOCK_GROUP_RAID1C3,
+		.mindev_error	= BTRFS_ERROR_DEV_RAID1C3_MIN_NOT_MET,
+	},
 };
 
 const char *get_raid_name(enum btrfs_raid_types type)
@@ -3336,6 +3348,8 @@ static int chunk_drange_filter(struct extent_buffer *leaf,
 	if (btrfs_chunk_type(leaf, chunk) & (BTRFS_BLOCK_GROUP_DUP |
 	     BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)) {
 		factor = num_stripes / 2;
+	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID1C3) {
+		factor = num_stripes / 3;
 	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID5) {
 		factor = num_stripes - 1;
 	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID6) {
@@ -3822,7 +3836,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	if (num_devices > 1)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
 	if (num_devices > 2)
-		allowed |= BTRFS_BLOCK_GROUP_RAID5;
+		allowed |= BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID1C3;
 	if (num_devices > 3)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID10 |
 			    BTRFS_BLOCK_GROUP_RAID6);
@@ -3856,6 +3870,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 
 	/* allow to reduce meta or sys integrity only if force set */
 	allowed = BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
+			BTRFS_BLOCK_GROUP_RAID1C3 |
 			BTRFS_BLOCK_GROUP_RAID10 |
 			BTRFS_BLOCK_GROUP_RAID5 |
 			BTRFS_BLOCK_GROUP_RAID6;
@@ -4787,8 +4802,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
 	     btrfs_cmp_device_info, NULL);
 
-	/* round down to number of usable stripes */
-	ndevs = round_down(ndevs, devs_increment);
+	/*
+	 * Round down to number of usable stripes, devs_increment can be any
+	 * number so we can't use round_down()
+	 */
+	ndevs -= ndevs % devs_increment;
 
 	if (ndevs < devs_min) {
 		ret = -ENOSPC;
@@ -5075,6 +5093,8 @@ static inline int btrfs_chunk_max_errors(struct map_lookup *map)
 			 BTRFS_BLOCK_GROUP_RAID5 |
 			 BTRFS_BLOCK_GROUP_DUP)) {
 		max_errors = 1;
+	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1C3) {
+		max_errors = 2;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
 		max_errors = 2;
 	} else {
@@ -5163,7 +5183,8 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		return 1;
 
 	map = em->map_lookup;
-	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
+	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_RAID1C3))
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
@@ -5237,7 +5258,9 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	struct btrfs_device *srcdev;
 
 	ASSERT((map->type &
-		 (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)));
+		 (BTRFS_BLOCK_GROUP_RAID1 |
+		  BTRFS_BLOCK_GROUP_RAID1C3 |
+		  BTRFS_BLOCK_GROUP_RAID10)));
 
 	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		num_stripes = map->sub_stripes;
@@ -5427,6 +5450,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 		div_u64_rem(stripe_nr_end - 1, factor, &last_stripe);
 		last_stripe *= sub_stripes;
 	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+				BTRFS_BLOCK_GROUP_RAID1C3 |
 				BTRFS_BLOCK_GROUP_DUP)) {
 		num_stripes = map->num_stripes;
 	} else {
@@ -5792,7 +5816,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 				&stripe_index);
 		if (!need_full_stripe(op))
 			mirror_num = 1;
-	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
+	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+				BTRFS_BLOCK_GROUP_RAID1C3)) {
 		if (need_full_stripe(op))
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
@@ -6441,6 +6466,7 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	}
 	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1C3 && num_stripes < 3) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
 	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
@@ -7389,5 +7415,7 @@ int btrfs_bg_type_to_factor(u64 flags)
 	if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
 		     BTRFS_BLOCK_GROUP_RAID10))
 		return 2;
+	if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
+		return 3;
 	return 1;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c7b9ad9733ea..5be624896dad 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -537,6 +537,8 @@ static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
 		return BTRFS_RAID_RAID10;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
 		return BTRFS_RAID_RAID1;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
+		return BTRFS_RAID_RAID1C3;
 	else if (flags & BTRFS_BLOCK_GROUP_DUP)
 		return BTRFS_RAID_DUP;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..137952d3375d 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -825,7 +825,8 @@ enum btrfs_err_code {
 	BTRFS_ERROR_DEV_TGT_REPLACE,
 	BTRFS_ERROR_DEV_MISSING_NOT_FOUND,
 	BTRFS_ERROR_DEV_ONLY_WRITABLE,
-	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
+	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS,
+	BTRFS_ERROR_DEV_RAID1C3_MIN_NOT_MET,
 };
 
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index aff1356c2bb8..fa75b63dd928 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -836,6 +836,7 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
 #define BTRFS_BLOCK_GROUP_RAID5         (1ULL << 7)
 #define BTRFS_BLOCK_GROUP_RAID6         (1ULL << 8)
+#define BTRFS_BLOCK_GROUP_RAID1C3       (1ULL << 9)
 #define BTRFS_BLOCK_GROUP_RESERVED	(BTRFS_AVAIL_ALLOC_BIT_SINGLE | \
 					 BTRFS_SPACE_INFO_GLOBAL_RSV)
 
@@ -847,6 +848,7 @@ enum btrfs_raid_types {
 	BTRFS_RAID_SINGLE,
 	BTRFS_RAID_RAID5,
 	BTRFS_RAID_RAID6,
+	BTRFS_RAID_RAID1C3,
 	BTRFS_NR_RAID_TYPES
 };
 
@@ -856,6 +858,7 @@ enum btrfs_raid_types {
 
 #define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
+					 BTRFS_BLOCK_GROUP_RAID1C3 | \
 					 BTRFS_BLOCK_GROUP_RAID5 |   \
 					 BTRFS_BLOCK_GROUP_RAID6 |   \
 					 BTRFS_BLOCK_GROUP_DUP |     \
-- 
2.18.0

