Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53644 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbeDYJwl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 05:52:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3P9pVWJ163285
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 09:52:40 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hftty5xsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 09:52:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3P9qd5R006376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 09:52:39 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3P9qc4o009368
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 09:52:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: kill btrfs_raid_group[]
Date: Wed, 25 Apr 2018 17:54:50 +0800
Message-Id: <20180425095450.3634-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new member struct btrfs_raid_attr::bg_flag so that
btrfs_raid_array[] can maintain the bit map flag of the raid type,
and so we can kill btrfs_raid_group[].

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/volumes.c     | 19 ++++++++-----------
 fs/btrfs/volumes.h     |  2 +-
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b62559dfb053..2fa063c3ccec 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3525,7 +3525,7 @@ int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
 	for (raid_type = 0; raid_type < BTRFS_NR_RAID_TYPES; raid_type++) {
 		if (raid_type == BTRFS_RAID_SINGLE)
 			continue;
-		if (!(flags & btrfs_raid_group[raid_type]))
+		if (!(flags & btrfs_raid_array[raid_type].bg_flag))
 			continue;
 		min_tolerated = min(min_tolerated,
 				    btrfs_raid_array[raid_type].
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4742734a73d7..19b4e24854ca 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4178,7 +4178,7 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_fs_info *fs_info, u64 flags)
 	/* First, mask out the RAID levels which aren't possible */
 	for (raid_type = 0; raid_type < BTRFS_NR_RAID_TYPES; raid_type++) {
 		if (num_devices >= btrfs_raid_array[raid_type].devs_min)
-			allowed |= btrfs_raid_group[raid_type];
+			allowed |= btrfs_raid_array[raid_type].bg_flag;
 	}
 	allowed &= flags;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5bb18ad6433d..de3eea8b393e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -53,6 +53,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 2,
 		.ncopies	= 2,
 		.raid_name	= "raid10",
+		.bg_flag	= BTRFS_BLOCK_GROUP_RAID10,
 	},
 	[BTRFS_RAID_RAID1] = {
 		.sub_stripes	= 1,
@@ -63,6 +64,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 2,
 		.ncopies	= 2,
 		.raid_name	= "raid1",
+		.bg_flag	= BTRFS_BLOCK_GROUP_RAID1,
 	},
 	[BTRFS_RAID_DUP] = {
 		.sub_stripes	= 1,
@@ -73,6 +75,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 2,
 		.raid_name	= "dup",
+		.bg_flag	= BTRFS_BLOCK_GROUP_DUP,
 	},
 	[BTRFS_RAID_RAID0] = {
 		.sub_stripes	= 1,
@@ -83,6 +86,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 1,
 		.raid_name	= "raid0",
+		.bg_flag	= BTRFS_BLOCK_GROUP_RAID0,
 	},
 	[BTRFS_RAID_SINGLE] = {
 		.sub_stripes	= 1,
@@ -93,6 +97,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 1,
 		.raid_name	= "single",
+		.bg_flag	= 0,
 	},
 	[BTRFS_RAID_RAID5] = {
 		.sub_stripes	= 1,
@@ -103,6 +108,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 2,
 		.raid_name	= "raid5",
+		.bg_flag	= BTRFS_BLOCK_GROUP_RAID5,
 	},
 	[BTRFS_RAID_RAID6] = {
 		.sub_stripes	= 1,
@@ -113,6 +119,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 3,
 		.raid_name	= "raid6",
+		.bg_flag	= BTRFS_BLOCK_GROUP_RAID6,
 	},
 };
 
@@ -124,16 +131,6 @@ const char *get_raid_name(enum btrfs_raid_types type)
 	return btrfs_raid_array[type].raid_name;
 }
 
-const u64 btrfs_raid_group[BTRFS_NR_RAID_TYPES] = {
-	[BTRFS_RAID_RAID10] = BTRFS_BLOCK_GROUP_RAID10,
-	[BTRFS_RAID_RAID1]  = BTRFS_BLOCK_GROUP_RAID1,
-	[BTRFS_RAID_DUP]    = BTRFS_BLOCK_GROUP_DUP,
-	[BTRFS_RAID_RAID0]  = BTRFS_BLOCK_GROUP_RAID0,
-	[BTRFS_RAID_SINGLE] = 0,
-	[BTRFS_RAID_RAID5]  = BTRFS_BLOCK_GROUP_RAID5,
-	[BTRFS_RAID_RAID6]  = BTRFS_BLOCK_GROUP_RAID6,
-};
-
 /*
  * Table to convert BTRFS_RAID_* to the error code if minimum number of devices
  * condition is not met. Zero means there's no corresponding
@@ -1898,7 +1895,7 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
 	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
-		if (!(all_avail & btrfs_raid_group[i]))
+		if (!(all_avail & btrfs_raid_array[i].bg_flag))
 			continue;
 
 		if (num_devices < btrfs_raid_array[i].devs_min) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2acd32ce1573..8417cb7059f6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -343,11 +343,11 @@ struct btrfs_raid_attr {
 	int devs_increment;	/* ndevs has to be a multiple of this */
 	int ncopies;		/* how many copies to data has */
 	char *raid_name;	/* name of the raid */
+	u64 bg_flag;		/* block group flag of the raid */
 };
 
 extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES];
 extern const int btrfs_raid_mindev_error[BTRFS_NR_RAID_TYPES];
-extern const u64 btrfs_raid_group[BTRFS_NR_RAID_TYPES];
 
 struct map_lookup {
 	u64 type;
-- 
2.15.0

