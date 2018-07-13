Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730017AbeGMTCh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 15:02:37 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7829AD0C
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 18:46:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: add support for raid1c3 and raid1c4
Date: Fri, 13 Jul 2018 20:46:29 +0200
Message-Id: <20180713184639.14244-1-dsterba@suse.com>
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>
References: <cover.1531503452.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ ./mkfs.btrfs -m raid1c4 -d raid1c3 /dev/sd[abcd]

Label:              (null)
UUID:               f1f988ab-6750-4bc2-957b-98a4ebe98631
Node size:          16384
Sector size:        4096
Filesystem size:    8.00GiB
Block group profiles:
  Data:             RAID1C3         273.06MiB
  Metadata:         RAID1C4         204.75MiB
  System:           RAID1C4           8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata, extraid
Number of devices:  4
Devices:
   ID        SIZE  PATH
    1     2.00GiB  /dev/sda
    2     2.00GiB  /dev/sdb
    3     2.00GiB  /dev/sdc
    4     2.00GiB  /dev/sdd

Signed-off-by: David Sterba <dsterba@suse.com>
---
 chunk-recover.c           |  4 ++++
 cmds-balance.c            |  4 ++++
 cmds-fi-usage.c           |  8 +++++++
 cmds-inspect-dump-super.c |  3 ++-
 ctree.h                   |  8 +++++++
 extent-tree.c             |  4 ++++
 fsfeatures.c              |  6 +++++
 ioctl.h                   |  3 ++-
 mkfs/main.c               | 11 ++++++++-
 print-tree.c              |  6 +++++
 utils.c                   | 13 +++++++++--
 volumes.c                 | 48 +++++++++++++++++++++++++++++++++++++--
 volumes.h                 |  4 ++++
 13 files changed, 115 insertions(+), 7 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 1d30db51d8ed..661a3bcb4f92 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1569,6 +1569,10 @@ static int calc_num_stripes(u64 type)
 	else if (type & (BTRFS_BLOCK_GROUP_RAID1 |
 			 BTRFS_BLOCK_GROUP_DUP))
 		return 2;
+	else if (type & (BTRFS_BLOCK_GROUP_RAID1C3))
+		return 3;
+	else if (type & (BTRFS_BLOCK_GROUP_RAID1C4))
+		return 4;
 	else
 		return 1;
 }
diff --git a/cmds-balance.c b/cmds-balance.c
index 6cc26c358f95..dab8cec5d105 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -46,6 +46,10 @@ static int parse_one_profile(const char *profile, u64 *flags)
 		*flags |= BTRFS_BLOCK_GROUP_RAID0;
 	} else if (!strcmp(profile, "raid1")) {
 		*flags |= BTRFS_BLOCK_GROUP_RAID1;
+	} else if (!strcmp(profile, "raid1c3")) {
+		*flags |= BTRFS_BLOCK_GROUP_RAID1C3;
+	} else if (!strcmp(profile, "raid1c4")) {
+		*flags |= BTRFS_BLOCK_GROUP_RAID1C4;
 	} else if (!strcmp(profile, "raid10")) {
 		*flags |= BTRFS_BLOCK_GROUP_RAID10;
 	} else if (!strcmp(profile, "raid5")) {
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index dca2e8d0365f..4e4a415f0d7c 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -373,6 +373,10 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 			ratio = 1;
 		else if (flags & BTRFS_BLOCK_GROUP_RAID1)
 			ratio = 2;
+		else if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
+			ratio = 3;
+		else if (flags & BTRFS_BLOCK_GROUP_RAID1C4)
+			ratio = 4;
 		else if (flags & BTRFS_BLOCK_GROUP_RAID5)
 			ratio = 0;
 		else if (flags & BTRFS_BLOCK_GROUP_RAID6)
@@ -653,6 +657,10 @@ static u64 calc_chunk_size(struct chunk_info *ci)
 		return ci->size / ci->num_stripes;
 	else if (ci->type & BTRFS_BLOCK_GROUP_RAID1)
 		return ci->size ;
+	else if (ci->type & BTRFS_BLOCK_GROUP_RAID1C3)
+		return ci->size;
+	else if (ci->type & BTRFS_BLOCK_GROUP_RAID1C4)
+		return ci->size;
 	else if (ci->type & BTRFS_BLOCK_GROUP_DUP)
 		return ci->size ;
 	else if (ci->type & BTRFS_BLOCK_GROUP_RAID5)
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index e965267c5d96..6984386dbec4 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -228,7 +228,8 @@ static struct readable_flag_entry incompat_flags_array[] = {
 	DEF_INCOMPAT_FLAG_ENTRY(EXTENDED_IREF),
 	DEF_INCOMPAT_FLAG_ENTRY(RAID56),
 	DEF_INCOMPAT_FLAG_ENTRY(SKINNY_METADATA),
-	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES)
+	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES),
+	DEF_INCOMPAT_FLAG_ENTRY(EXTENDED_RAID),
 };
 static const int incompat_flags_num = sizeof(incompat_flags_array) /
 				      sizeof(struct readable_flag_entry);
diff --git a/ctree.h b/ctree.h
index 04a77550c715..f49d11e3d178 100644
--- a/ctree.h
+++ b/ctree.h
@@ -489,6 +489,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_EXTENDED_RAID	(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 
@@ -509,6 +510,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
+	 BTRFS_FEATURE_INCOMPAT_EXTENDED_RAID |		\
 	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
 
 /*
@@ -958,6 +960,8 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
 #define BTRFS_BLOCK_GROUP_RAID5    	(1ULL << 7)
 #define BTRFS_BLOCK_GROUP_RAID6    	(1ULL << 8)
+#define BTRFS_BLOCK_GROUP_RAID1C3    	(1ULL << 9)
+#define BTRFS_BLOCK_GROUP_RAID1C4    	(1ULL << 10)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 
 enum btrfs_raid_types {
@@ -968,6 +972,8 @@ enum btrfs_raid_types {
 	BTRFS_RAID_SINGLE,
 	BTRFS_RAID_RAID5,
 	BTRFS_RAID_RAID6,
+	BTRFS_RAID_RAID1C3,
+	BTRFS_RAID_RAID1C4,
 	BTRFS_NR_RAID_TYPES
 };
 
@@ -979,6 +985,8 @@ enum btrfs_raid_types {
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
 					 BTRFS_BLOCK_GROUP_RAID5 |   \
 					 BTRFS_BLOCK_GROUP_RAID6 |   \
+					 BTRFS_BLOCK_GROUP_RAID1C3 | \
+					 BTRFS_BLOCK_GROUP_RAID1C4 | \
 					 BTRFS_BLOCK_GROUP_DUP |     \
 					 BTRFS_BLOCK_GROUP_RAID10)
 
diff --git a/extent-tree.c b/extent-tree.c
index 0643815bd41c..836cd4e9c088 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1848,6 +1848,8 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
 	u64 extra_flags = flags & (BTRFS_BLOCK_GROUP_RAID0 |
 				   BTRFS_BLOCK_GROUP_RAID1 |
+				   BTRFS_BLOCK_GROUP_RAID1C3 |
+				   BTRFS_BLOCK_GROUP_RAID1C4 |
 				   BTRFS_BLOCK_GROUP_RAID10 |
 				   BTRFS_BLOCK_GROUP_RAID5 |
 				   BTRFS_BLOCK_GROUP_RAID6 |
@@ -3629,6 +3631,8 @@ static u64 get_dev_extent_len(struct map_lookup *map)
 	case 0: /* Single */
 	case BTRFS_BLOCK_GROUP_DUP:
 	case BTRFS_BLOCK_GROUP_RAID1:
+	case BTRFS_BLOCK_GROUP_RAID1C3:
+	case BTRFS_BLOCK_GROUP_RAID1C4:
 		div = 1;
 		break;
 	case BTRFS_BLOCK_GROUP_RAID5:
diff --git a/fsfeatures.c b/fsfeatures.c
index 7d85d60f1277..50547bad8db2 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -86,6 +86,12 @@ static const struct btrfs_fs_feature {
 		VERSION_TO_STRING2(4,0),
 		NULL, 0,
 		"no explicit hole extents for files" },
+	{ "extraid", BTRFS_FEATURE_INCOMPAT_EXTENDED_RAID,
+		"extended_raid",
+		VERSION_TO_STRING2(4,17),
+		NULL, 0,
+		NULL, 0,
+		"extended raid features: raid1c3, raid1c4" },
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
diff --git a/ioctl.h b/ioctl.h
index 709e996f401c..ae8f60515533 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -682,7 +682,8 @@ enum btrfs_err_code {
 	BTRFS_ERROR_DEV_TGT_REPLACE,
 	BTRFS_ERROR_DEV_MISSING_NOT_FOUND,
 	BTRFS_ERROR_DEV_ONLY_WRITABLE,
-	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
+	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS,
+	BTRFS_ERROR_DEV_RAID1c3_MIN_NOT_MET,
 };
 
 /* An error code to error string mapping for the kernel
diff --git a/mkfs/main.c b/mkfs/main.c
index b76462a735cf..099b38bbc80c 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -346,7 +346,7 @@ static void print_usage(int ret)
 	printf("Usage: mkfs.btrfs [options] dev [ dev ... ]\n");
 	printf("Options:\n");
 	printf("  allocation profiles:\n");
-	printf("\t-d|--data PROFILE       data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
+	printf("\t-d|--data PROFILE       data profile, raid0, raid1, raid1c3, raid1c4, raid5, raid6, raid10, dup or single\n");
 	printf("\t-m|--metadata PROFILE   metadata profile, values like for data profile\n");
 	printf("\t-M|--mixed              mix metadata and data together\n");
 	printf("  features:\n");
@@ -377,6 +377,10 @@ static u64 parse_profile(const char *s)
 		return BTRFS_BLOCK_GROUP_RAID0;
 	} else if (strcasecmp(s, "raid1") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID1;
+	} else if (strcasecmp(s, "raid1c3") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID1C3;
+	} else if (strcasecmp(s, "raid1c4") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID1C4;
 	} else if (strcasecmp(s, "raid5") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID5;
 	} else if (strcasecmp(s, "raid6") == 0) {
@@ -958,6 +962,11 @@ int main(int argc, char **argv)
 		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
 	}
 
+	if ((data_profile | metadata_profile) &
+	    (BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1C4)) {
+		features |= BTRFS_FEATURE_INCOMPAT_EXTENDED_RAID;
+	}
+
 	if (btrfs_check_nodesize(nodesize, sectorsize,
 				 features))
 		goto error;
diff --git a/print-tree.c b/print-tree.c
index a09ecfbb28f0..f816a851ea65 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -163,6 +163,12 @@ static void bg_flags_to_str(u64 flags, char *ret)
 	case BTRFS_BLOCK_GROUP_RAID1:
 		strcat(ret, "|RAID1");
 		break;
+	case BTRFS_BLOCK_GROUP_RAID1C3:
+		strcat(ret, "|RAID1C3");
+		break;
+	case BTRFS_BLOCK_GROUP_RAID1C4:
+		strcat(ret, "|RAID1C4");
+		break;
 	case BTRFS_BLOCK_GROUP_DUP:
 		strcat(ret, "|DUP");
 		break;
diff --git a/utils.c b/utils.c
index d4395b1f32f8..4e942cff40d0 100644
--- a/utils.c
+++ b/utils.c
@@ -1884,8 +1884,10 @@ static int group_profile_devs_min(u64 flag)
 	case BTRFS_BLOCK_GROUP_RAID5:
 		return 2;
 	case BTRFS_BLOCK_GROUP_RAID6:
+	case BTRFS_BLOCK_GROUP_RAID1C3:
 		return 3;
 	case BTRFS_BLOCK_GROUP_RAID10:
+	case BTRFS_BLOCK_GROUP_RAID1C4:
 		return 4;
 	default:
 		return -1;
@@ -1901,9 +1903,9 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	switch (dev_cnt) {
 	default:
 	case 4:
-		allowed |= BTRFS_BLOCK_GROUP_RAID10;
+		allowed |= BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_RAID1C4;
 	case 3:
-		allowed |= BTRFS_BLOCK_GROUP_RAID6;
+		allowed |= BTRFS_BLOCK_GROUP_RAID6 | BTRFS_BLOCK_GROUP_RAID1C3;
 	case 2:
 		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
 			BTRFS_BLOCK_GROUP_RAID5;
@@ -1955,7 +1957,10 @@ int group_profile_max_safe_loss(u64 flags)
 	case BTRFS_BLOCK_GROUP_RAID10:
 		return 1;
 	case BTRFS_BLOCK_GROUP_RAID6:
+	case BTRFS_BLOCK_GROUP_RAID1C3:
 		return 2;
+	case BTRFS_BLOCK_GROUP_RAID1C4:
+		return 3;
 	default:
 		return -1;
 	}
@@ -2170,6 +2175,10 @@ const char* btrfs_group_profile_str(u64 flag)
 		return "RAID0";
 	case BTRFS_BLOCK_GROUP_RAID1:
 		return "RAID1";
+	case BTRFS_BLOCK_GROUP_RAID1C3:
+		return "RAID1C3";
+	case BTRFS_BLOCK_GROUP_RAID1C4:
+		return "RAID1C4";
 	case BTRFS_BLOCK_GROUP_RAID5:
 		return "RAID5";
 	case BTRFS_BLOCK_GROUP_RAID6:
diff --git a/volumes.c b/volumes.c
index 24eb3e8b2578..ae571da95094 100644
--- a/volumes.c
+++ b/volumes.c
@@ -94,6 +94,24 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 3,
 	},
+	[BTRFS_RAID_RAID1C3] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 3,
+		.tolerated_failures = 2,
+		.devs_increment	= 3,
+		.ncopies	= 3,
+	},
+	[BTRFS_RAID_RAID1C4] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 4,
+		.tolerated_failures = 3,
+		.devs_increment	= 4,
+		.ncopies	= 4,
+	},
 };
 
 struct stripe {
@@ -795,6 +813,8 @@ static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
 {
 	if (type & (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP))
 		return calc_size;
+	else if (type & (BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1C4))
+		return calc_size;
 	else if (type & BTRFS_BLOCK_GROUP_RAID10)
 		return calc_size * (num_stripes / sub_stripes);
 	else if (type & BTRFS_BLOCK_GROUP_RAID5)
@@ -971,6 +991,20 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			return -ENOSPC;
 		min_stripes = 2;
 	}
+	if (type & BTRFS_BLOCK_GROUP_RAID1C3) {
+		num_stripes = min_t(u64, 3,
+				  btrfs_super_num_devices(info->super_copy));
+		if (num_stripes < 3)
+			return -ENOSPC;
+		min_stripes = 3;
+	}
+	if (type & BTRFS_BLOCK_GROUP_RAID1C4) {
+		num_stripes = min_t(u64, 4,
+				  btrfs_super_num_devices(info->super_copy));
+		if (num_stripes < 4)
+			return -ENOSPC;
+		min_stripes = 4;
+	}
 	if (type & BTRFS_BLOCK_GROUP_DUP) {
 		num_stripes = 2;
 		min_stripes = 2;
@@ -1315,7 +1349,8 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	}
 	map = container_of(ce, struct map_lookup, ce);
 
-	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
+	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1C4))
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
@@ -1511,6 +1546,8 @@ int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	if (rw == WRITE) {
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+				 BTRFS_BLOCK_GROUP_RAID1C3 |
+				 BTRFS_BLOCK_GROUP_RAID1C4 |
 				 BTRFS_BLOCK_GROUP_DUP)) {
 			stripes_required = map->num_stripes;
 		} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
@@ -1553,6 +1590,7 @@ int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	stripe_offset = offset - stripe_offset;
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1C4 |
 			 BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
 			 BTRFS_BLOCK_GROUP_RAID10 |
 			 BTRFS_BLOCK_GROUP_DUP)) {
@@ -1568,7 +1606,9 @@ int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	multi->num_stripes = 1;
 	stripe_index = 0;
-	if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
+	if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_RAID1C3 |
+			 BTRFS_BLOCK_GROUP_RAID1C4)) {
 		if (rw == WRITE)
 			multi->num_stripes = map->num_stripes;
 		else if (mirror_num)
@@ -1838,6 +1878,8 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	if ((type & BTRFS_BLOCK_GROUP_RAID10 && (sub_stripes != 2 ||
 		  !IS_ALIGNED(num_stripes, sub_stripes))) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1C3 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1C4 && num_stripes < 4) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
 	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
@@ -2391,6 +2433,8 @@ u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
 	switch (profile) {
 	case 0: /* Single profile */
 	case BTRFS_BLOCK_GROUP_RAID1:
+	case BTRFS_BLOCK_GROUP_RAID1C3:
+	case BTRFS_BLOCK_GROUP_RAID1C4:
 	case BTRFS_BLOCK_GROUP_DUP:
 		stripe_len = chunk_len;
 		break;
diff --git a/volumes.h b/volumes.h
index b4ea93f0bec3..6f74aee998e3 100644
--- a/volumes.h
+++ b/volumes.h
@@ -126,6 +126,10 @@ static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
 		return BTRFS_RAID_RAID10;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
 		return BTRFS_RAID_RAID1;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
+		return BTRFS_RAID_RAID1C3;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1C4)
+		return BTRFS_RAID_RAID1C4;
 	else if (flags & BTRFS_BLOCK_GROUP_DUP)
 		return BTRFS_RAID_DUP;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
-- 
2.18.0

