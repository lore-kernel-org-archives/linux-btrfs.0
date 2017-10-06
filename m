Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22299 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdJFKFD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 06:05:03 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v96A52Hv019088
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 6 Oct 2017 10:05:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v96A52it024277
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 6 Oct 2017 10:05:02 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v96A52YV029430
        for <linux-btrfs@vger.kernel.org>; Fri, 6 Oct 2017 10:05:02 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix read_one_chunk() return error code
Date: Fri,  6 Oct 2017 18:04:42 +0800
Message-Id: <20171006100443.20007-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

EIO is for IO (RW) failures, use correct error return
codes at two locations with in read_one_chunk(). Also
adds a small cleanup.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 17 ++++++++++-------
 fs/btrfs/volumes.h |  3 +--
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..f4b659b6ef4c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6249,7 +6249,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
 
 	device = btrfs_alloc_device(NULL, &devid, dev_uuid);
 	if (IS_ERR(device))
-		return NULL;
+		return device;
 
 	list_add(&device->dev_list, &fs_devices->devices);
 	device->fs_devices = fs_devices;
@@ -6448,15 +6448,18 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
 			btrfs_report_missing_device(fs_info, devid, uuid);
-			return -EIO;
+			return -EINVAL;
 		}
 		if (!map->stripes[i].dev) {
 			map->stripes[i].dev =
 				add_missing_dev(fs_info->fs_devices, devid,
 						uuid);
-			if (!map->stripes[i].dev) {
+			if (IS_ERR(map->stripes[i].dev)) {
 				free_extent_map(em);
-				return -EIO;
+				btrfs_err(fs_info,
+				"failed to init missing dev %llu %ld",
+					devid, PTR_ERR(map->stripes[i].dev));
+				return PTR_ERR(map->stripes[i].dev);
 			}
 			btrfs_report_missing_device(fs_info, devid, uuid);
 		}
@@ -6578,12 +6581,12 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid, dev_uuid);
-			return -EIO;
+			return -EINVAL;
 		}
 
 		device = add_missing_dev(fs_devices, devid, dev_uuid);
-		if (!device)
-			return -ENOMEM;
+		if (IS_ERR(device))
+			return PTR_ERR(device);
 		btrfs_report_missing_device(fs_info, devid, dev_uuid);
 	} else {
 		if (!device->bdev) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6108fdfec67f..6c807a1c0531 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -432,8 +432,7 @@ int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
 					 const char *devpath,
 					 struct btrfs_device **device);
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
-					const u64 *devid,
-					const u8 *uuid);
+					const u64 *devid, const u8 *uuid);
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		    const char *device_path, u64 devid);
 void btrfs_cleanup_fs_uuids(void);
-- 
2.13.1

