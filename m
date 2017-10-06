Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22319 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdJFKFF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 06:05:05 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v96A543I019115
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 6 Oct 2017 10:05:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v96A53s0024455
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 6 Oct 2017 10:05:04 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v96A53Df014027
        for <linux-btrfs@vger.kernel.org>; Fri, 6 Oct 2017 10:05:03 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: clean up btrfs_report_missing_device() usage
Date: Fri,  6 Oct 2017 18:04:43 +0800
Message-Id: <20171006100443.20007-2-anand.jain@oracle.com>
In-Reply-To: <20171006100443.20007-1-anand.jain@oracle.com>
References: <20171006100443.20007-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes the following changes..
When -o degraded flag is not set and one of the device
is missing then we should log an error instead of warning.
So move the check for DEGRADED flag into the same function
and rename it. Also does code cleanup around this, including
making this function as static. And to print warning, just
open code it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 41 +++++++++++++++++++++++------------------
 fs/btrfs/volumes.h |  3 ---
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4b659b6ef4c..317d6d1b58d0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6377,6 +6377,22 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static int check_report_degraded(struct btrfs_fs_info *fs_info,
+					u64 devid, u8 *uuid, int warn)
+{
+	if (!btrfs_test_opt(fs_info, DEGRADED)) {
+		btrfs_err_rl(fs_info, "devid %llu uuid %pU is missing",
+				devid, uuid);
+		return 1;
+	}
+
+	if (warn)
+		btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing",
+				devid, uuid);
+	return 0;
+}
+
+
 static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
@@ -6445,9 +6461,8 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 		map->stripes[i].dev = btrfs_find_device(fs_info, devid,
 							uuid, NULL);
 		if (!map->stripes[i].dev &&
-		    !btrfs_test_opt(fs_info, DEGRADED)) {
+			check_report_degraded(fs_info, devid, uuid, 0)) {
 			free_extent_map(em);
-			btrfs_report_missing_device(fs_info, devid, uuid);
 			return -EINVAL;
 		}
 		if (!map->stripes[i].dev) {
@@ -6461,7 +6476,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 					devid, PTR_ERR(map->stripes[i].dev));
 				return PTR_ERR(map->stripes[i].dev);
 			}
-			btrfs_report_missing_device(fs_info, devid, uuid);
+			check_report_degraded(fs_info, devid, uuid, 1);
 		}
 		map->stripes[i].dev->in_fs_metadata = 1;
 	}
@@ -6579,21 +6594,17 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 
 	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
 	if (!device) {
-		if (!btrfs_test_opt(fs_info, DEGRADED)) {
-			btrfs_report_missing_device(fs_info, devid, dev_uuid);
+		if (check_report_degraded(fs_info, devid, dev_uuid, 0))
 			return -EINVAL;
-		}
 
 		device = add_missing_dev(fs_devices, devid, dev_uuid);
 		if (IS_ERR(device))
 			return PTR_ERR(device);
-		btrfs_report_missing_device(fs_info, devid, dev_uuid);
+		check_report_degraded(fs_info, devid, dev_uuid, 1);
 	} else {
-		if (!device->bdev) {
-			btrfs_report_missing_device(fs_info, devid, dev_uuid);
-			if (!btrfs_test_opt(fs_info, DEGRADED))
-				return -EIO;
-		}
+		if (!device->bdev &&
+			check_report_degraded(fs_info, devid, dev_uuid, 1))
+			return -EINVAL;
 
 		if(!device->bdev && !device->missing) {
 			/*
@@ -6759,12 +6770,6 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 	return -EIO;
 }
 
-void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
-				 u8 *uuid)
-{
-	btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing", devid, uuid);
-}
-
 /*
  * Check if all chunks in the fs are OK for read-write degraded mount
  *
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6c807a1c0531..e40b6f207533 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -541,7 +541,4 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 
 bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
-void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
-				 u8 *uuid);
-
 #endif
-- 
2.13.1

