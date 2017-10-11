Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19543 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdJKEfJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 00:35:09 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9B4Z8dp009584
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 04:35:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9B4Z75O029786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 04:35:08 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9B4Z7pM005704
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 04:35:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2.1 1/4] btrfs: add_missing_dev() should return the actual error
Date: Wed, 11 Oct 2017 12:34:50 +0800
Message-Id: <20171011043450.18983-1-anand.jain@oracle.com>
In-Reply-To: <20171011005229.GB3283@lim.localdomain>
References: <20171011005229.GB3283@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_missing_dev() can return device pointer so that IS_ERR/
PTR_ERR can be used to check for the actual error occurred
in the function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

---
 fs/btrfs/volumes.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..1fb98c2ab9c0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6249,7 +6249,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
 
 	device = btrfs_alloc_device(NULL, &devid, dev_uuid);
 	if (IS_ERR(device))
-		return NULL;
+		return device;
 
 	list_add(&device->dev_list, &fs_devices->devices);
 	device->fs_devices = fs_devices;
@@ -6454,9 +6454,12 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			map->stripes[i].dev =
 				add_missing_dev(fs_info->fs_devices, devid,
 						uuid);
-			if (!map->stripes[i].dev) {
+			if (IS_ERR(map->stripes[i].dev)) {
 				free_extent_map(em);
-				return -EIO;
+				btrfs_err(fs_info,
+					"failed to init missing dev %llu %ld",
+					devid, PTR_ERR(map->stripes[i].dev));
+				return PTR_ERR(map->stripes[i].dev);
 			}
 			btrfs_report_missing_device(fs_info, devid, uuid);
 		}
@@ -6582,8 +6585,12 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 		}
 
 		device = add_missing_dev(fs_devices, devid, dev_uuid);
-		if (!device)
-			return -ENOMEM;
+		if (IS_ERR(device)) {
+			btrfs_err(fs_info,
+				"failed to add missing dev %llu %ld",
+				devid, PTR_ERR(device));
+			return PTR_ERR(device);
+		}
 		btrfs_report_missing_device(fs_info, devid, dev_uuid);
 	} else {
 		if (!device->bdev) {
-- 
2.13.1

