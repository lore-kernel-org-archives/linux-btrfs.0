Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60606 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730848AbeGMTCm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 15:02:42 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C315BAD32
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 18:46:50 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: add support for 4-copy replication (raid1c4)
Date: Fri, 13 Jul 2018 20:46:32 +0200
Message-Id: <276429d82103a30f9a94a7f3d55a2c33bfcd6bfc.1531503452.git.dsterba@suse.com>
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>
References: <cover.1531503452.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new block group profile to store 4 copies in a simliar way that
current RAID1 does. The profile name is temporary and may change in the
future.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c          |  3 +++
 fs/btrfs/scrub.c                |  3 ++-
 fs/btrfs/super.c                |  3 +++
 fs/btrfs/volumes.c              | 28 ++++++++++++++++++++++++++--
 fs/btrfs/volumes.h              |  2 ++
 include/uapi/linux/btrfs.h      |  1 +
 include/uapi/linux/btrfs_tree.h |  3 +++
 7 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 47f929dcc3d4..ac7ec7a274d9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7528,6 +7528,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		    u64 extra = BTRFS_BLOCK_GROUP_DUP |
 				BTRFS_BLOCK_GROUP_RAID1 |
 				BTRFS_BLOCK_GROUP_RAID1C3 |
+				BTRFS_BLOCK_GROUP_RAID1C4 |
 				BTRFS_BLOCK_GROUP_RAID5 |
 				BTRFS_BLOCK_GROUP_RAID6 |
 				BTRFS_BLOCK_GROUP_RAID10;
@@ -9332,6 +9333,7 @@ static u64 update_block_group_flags(struct btrfs_fs_info *fs_info, u64 flags)
 	num_devices = fs_info->fs_devices->rw_devices;
 
 	ASSERT(!(flags & BTRFS_BLOCK_GROUP_RAID1C3));
+	ASSERT(!(flags & BTRFS_BLOCK_GROUP_RAID1C4));
 
 	stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
@@ -10147,6 +10149,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		      (BTRFS_BLOCK_GROUP_RAID10 |
 		       BTRFS_BLOCK_GROUP_RAID1 |
 		       BTRFS_BLOCK_GROUP_RAID1C3 |
+		       BTRFS_BLOCK_GROUP_RAID1C4 |
 		       BTRFS_BLOCK_GROUP_RAID5 |
 		       BTRFS_BLOCK_GROUP_RAID6 |
 		       BTRFS_BLOCK_GROUP_DUP)))
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e9355759f2ec..2cb97a895dfb 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3389,7 +3389,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		increment = map->stripe_len * factor;
 		mirror_num = num % map->sub_stripes + 1;
 	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
-				BTRFS_BLOCK_GROUP_RAID1C3)) {
+				BTRFS_BLOCK_GROUP_RAID1C3 |
+				BTRFS_BLOCK_GROUP_RAID1C4)) {
 		increment = map->stripe_len;
 		mirror_num = num % map->num_stripes + 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 86e6aa5ef788..997d19c669ab 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1980,6 +1980,9 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	} else if (type & BTRFS_BLOCK_GROUP_RAID1C3) {
 		min_stripes = 3;
 		num_stripes = 3;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID1C4) {
+		min_stripes = 4;
+		num_stripes = 4;
 	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
 		min_stripes = 4;
 		num_stripes = 4;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0920b31e999d..62a8d8844dd4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -128,6 +128,18 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID1C3,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID1C3_MIN_NOT_MET,
 	},
+	[BTRFS_RAID_RAID1C4] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 4,
+		.tolerated_failures = 3,
+		.devs_increment	= 4,
+		.ncopies	= 4,
+		.raid_name	= "raid1c4",
+		.bg_flag	= BTRFS_BLOCK_GROUP_RAID1C4,
+		.mindev_error	= BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
+	},
 };
 
 const char *get_raid_name(enum btrfs_raid_types type)
@@ -3350,6 +3362,8 @@ static int chunk_drange_filter(struct extent_buffer *leaf,
 		factor = num_stripes / 2;
 	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID1C3) {
 		factor = num_stripes / 3;
+	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID1C4) {
+		factor = num_stripes / 4;
 	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID5) {
 		factor = num_stripes - 1;
 	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID6) {
@@ -3839,6 +3853,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		allowed |= BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID1C3;
 	if (num_devices > 3)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID10 |
+			    BTRFS_BLOCK_GROUP_RAID1C4 |
 			    BTRFS_BLOCK_GROUP_RAID6);
 	if (validate_convert_profile(&bctl->data, allowed)) {
 		int index = btrfs_bg_flags_to_raid_index(bctl->data.target);
@@ -3871,6 +3886,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	/* allow to reduce meta or sys integrity only if force set */
 	allowed = BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
 			BTRFS_BLOCK_GROUP_RAID1C3 |
+			BTRFS_BLOCK_GROUP_RAID1C4 |
 			BTRFS_BLOCK_GROUP_RAID10 |
 			BTRFS_BLOCK_GROUP_RAID5 |
 			BTRFS_BLOCK_GROUP_RAID6;
@@ -5095,6 +5111,8 @@ static inline int btrfs_chunk_max_errors(struct map_lookup *map)
 		max_errors = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1C3) {
 		max_errors = 2;
+	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1C4) {
+		max_errors = 3;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
 		max_errors = 2;
 	} else {
@@ -5184,7 +5202,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 
 	map = em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
-			 BTRFS_BLOCK_GROUP_RAID1C3))
+			 BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1C4))
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
@@ -5260,6 +5278,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	ASSERT((map->type &
 		 (BTRFS_BLOCK_GROUP_RAID1 |
 		  BTRFS_BLOCK_GROUP_RAID1C3 |
+		  BTRFS_BLOCK_GROUP_RAID1C4 |
 		  BTRFS_BLOCK_GROUP_RAID10)));
 
 	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
@@ -5451,6 +5470,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 		last_stripe *= sub_stripes;
 	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
 				BTRFS_BLOCK_GROUP_RAID1C3 |
+				BTRFS_BLOCK_GROUP_RAID1C4 |
 				BTRFS_BLOCK_GROUP_DUP)) {
 		num_stripes = map->num_stripes;
 	} else {
@@ -5817,7 +5837,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		if (!need_full_stripe(op))
 			mirror_num = 1;
 	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
-				BTRFS_BLOCK_GROUP_RAID1C3)) {
+				BTRFS_BLOCK_GROUP_RAID1C3 |
+				BTRFS_BLOCK_GROUP_RAID1C4)) {
 		if (need_full_stripe(op))
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
@@ -6467,6 +6488,7 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID1C3 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1C4 && num_stripes < 4) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
 	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
@@ -7417,5 +7439,7 @@ int btrfs_bg_type_to_factor(u64 flags)
 		return 2;
 	if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
 		return 3;
+	if (flags & BTRFS_BLOCK_GROUP_RAID1C4)
+		return 4;
 	return 1;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5be624896dad..9c71d6ef7791 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -539,6 +539,8 @@ static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
 		return BTRFS_RAID_RAID1;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
 		return BTRFS_RAID_RAID1C3;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1C4)
+		return BTRFS_RAID_RAID1C4;
 	else if (flags & BTRFS_BLOCK_GROUP_DUP)
 		return BTRFS_RAID_DUP;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 137952d3375d..229ef2e135ac 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -827,6 +827,7 @@ enum btrfs_err_code {
 	BTRFS_ERROR_DEV_ONLY_WRITABLE,
 	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS,
 	BTRFS_ERROR_DEV_RAID1C3_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
 };
 
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index fa75b63dd928..ce0443115982 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -837,6 +837,7 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID5         (1ULL << 7)
 #define BTRFS_BLOCK_GROUP_RAID6         (1ULL << 8)
 #define BTRFS_BLOCK_GROUP_RAID1C3       (1ULL << 9)
+#define BTRFS_BLOCK_GROUP_RAID1C4       (1ULL << 10)
 #define BTRFS_BLOCK_GROUP_RESERVED	(BTRFS_AVAIL_ALLOC_BIT_SINGLE | \
 					 BTRFS_SPACE_INFO_GLOBAL_RSV)
 
@@ -849,6 +850,7 @@ enum btrfs_raid_types {
 	BTRFS_RAID_RAID5,
 	BTRFS_RAID_RAID6,
 	BTRFS_RAID_RAID1C3,
+	BTRFS_RAID_RAID1C4,
 	BTRFS_NR_RAID_TYPES
 };
 
@@ -859,6 +861,7 @@ enum btrfs_raid_types {
 #define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
 					 BTRFS_BLOCK_GROUP_RAID1C3 | \
+					 BTRFS_BLOCK_GROUP_RAID1C4 | \
 					 BTRFS_BLOCK_GROUP_RAID5 |   \
 					 BTRFS_BLOCK_GROUP_RAID6 |   \
 					 BTRFS_BLOCK_GROUP_DUP |     \
-- 
2.18.0

