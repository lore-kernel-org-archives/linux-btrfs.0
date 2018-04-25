Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbeDYKad (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 06:30:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3PAPh8t110996
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:30:32 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2hfw9adwem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:30:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3PAUV0B023996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:30:31 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3PAUVgQ022950
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:30:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: kill btrfs_raid_mindev_error[]
Date: Wed, 25 Apr 2018 18:32:33 +0800
Message-Id: <20180425103233.8214-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new member struct btrfs_raid_attr::mindev_error so that
btrfs_raid_array[] can maintain the error code to return if the
minimum numnber of devices required condition is not met while
trying to delete a device in the given raid. And so we can
kill btrfs_raid_mindev_error[].

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 24 ++++++++----------------
 fs/btrfs/volumes.h |  2 +-
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index de3eea8b393e..14efa98b7183 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -54,6 +54,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.ncopies	= 2,
 		.raid_name	= "raid10",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID10,
+		.mindev_error	= BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
 	},
 	[BTRFS_RAID_RAID1] = {
 		.sub_stripes	= 1,
@@ -65,6 +66,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.ncopies	= 2,
 		.raid_name	= "raid1",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID1,
+		.mindev_error	= BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
 	},
 	[BTRFS_RAID_DUP] = {
 		.sub_stripes	= 1,
@@ -76,6 +78,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.ncopies	= 2,
 		.raid_name	= "dup",
 		.bg_flag	= BTRFS_BLOCK_GROUP_DUP,
+		.mindev_error	= 0,
 	},
 	[BTRFS_RAID_RAID0] = {
 		.sub_stripes	= 1,
@@ -87,6 +90,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.ncopies	= 1,
 		.raid_name	= "raid0",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID0,
+		.mindev_error	= 0,
 	},
 	[BTRFS_RAID_SINGLE] = {
 		.sub_stripes	= 1,
@@ -98,6 +102,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.ncopies	= 1,
 		.raid_name	= "single",
 		.bg_flag	= 0,
+		.mindev_error	= 0,
 	},
 	[BTRFS_RAID_RAID5] = {
 		.sub_stripes	= 1,
@@ -109,6 +114,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.ncopies	= 2,
 		.raid_name	= "raid5",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID5,
+		.mindev_error	= BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
 	},
 	[BTRFS_RAID_RAID6] = {
 		.sub_stripes	= 1,
@@ -120,6 +126,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.ncopies	= 3,
 		.raid_name	= "raid6",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID6,
+		.mindev_error	= BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
 	},
 };
 
@@ -131,21 +138,6 @@ const char *get_raid_name(enum btrfs_raid_types type)
 	return btrfs_raid_array[type].raid_name;
 }
 
-/*
- * Table to convert BTRFS_RAID_* to the error code if minimum number of devices
- * condition is not met. Zero means there's no corresponding
- * BTRFS_ERROR_DEV_*_NOT_MET value.
- */
-const int btrfs_raid_mindev_error[BTRFS_NR_RAID_TYPES] = {
-	[BTRFS_RAID_RAID10] = BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
-	[BTRFS_RAID_RAID1]  = BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
-	[BTRFS_RAID_DUP]    = 0,
-	[BTRFS_RAID_RAID0]  = 0,
-	[BTRFS_RAID_SINGLE] = 0,
-	[BTRFS_RAID_RAID5]  = BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
-	[BTRFS_RAID_RAID6]  = BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
-};
-
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info);
 static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
@@ -1899,7 +1891,7 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
 			continue;
 
 		if (num_devices < btrfs_raid_array[i].devs_min) {
-			int ret = btrfs_raid_mindev_error[i];
+			int ret = btrfs_raid_array[i].mindev_error;
 
 			if (ret)
 				return ret;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8417cb7059f6..8070a734877a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -344,10 +344,10 @@ struct btrfs_raid_attr {
 	int ncopies;		/* how many copies to data has */
 	char *raid_name;	/* name of the raid */
 	u64 bg_flag;		/* block group flag of the raid */
+	int mindev_error;	/* error code if min devs requisite is unmet */
 };
 
 extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES];
-extern const int btrfs_raid_mindev_error[BTRFS_NR_RAID_TYPES];
 
 struct map_lookup {
 	u64 type;
-- 
2.15.0

