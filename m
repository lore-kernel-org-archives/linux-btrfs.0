Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38147 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbdJIDII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 23:08:08 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v993873k028220
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v99386er005253
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:07 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v99386w9014411
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:06 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] btrfs: fix use of error or warning for missing device
Date: Mon,  9 Oct 2017 11:07:46 +0800
Message-Id: <20171009030746.16680-4-anand.jain@oracle.com>
In-Reply-To: <20171009030746.16680-1-anand.jain@oracle.com>
References: <20171009030746.16680-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When device is missing without the -o degraded option then
its an error so report it as an error instead of warning.
And when -o degraded option is provided, log the missing
device as warning.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Rename from
    [PATCH 2/2] btrfs: clean up btrfs_report_missing_device() usage
    Also drop the idea of moving the DEGRADED option checking
    into the function btrfs_report_missing_device() and further
    renaming it to check_report_degraded(). If its such a thing
    is good idea it can be added on top of this patch. Thxs.
 fs/btrfs/volumes.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6a041bef112c..c76a81938766 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6378,9 +6378,14 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 }
 
 static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
-						u64 devid, u8 *uuid)
+					u64 devid, u8 *uuid, int error)
 {
-	btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing", devid, uuid);
+	if (error)
+		btrfs_err_rl(fs_info, "devid %llu uuid %pU is missing",
+			      devid, uuid);
+	else
+		btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing",
+			      devid, uuid);
 }
 
 static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
@@ -6453,7 +6458,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 		if (!map->stripes[i].dev &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
-			btrfs_report_missing_device(fs_info, devid, uuid);
+			btrfs_report_missing_device(fs_info, devid, uuid, 1);
 			return -ENOENT;
 		}
 		if (!map->stripes[i].dev) {
@@ -6467,7 +6472,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 					devid, PTR_ERR(map->stripes[i].dev));
 				return PTR_ERR(map->stripes[i].dev);
 			}
-			btrfs_report_missing_device(fs_info, devid, uuid);
+			btrfs_report_missing_device(fs_info, devid, uuid, 0);
 		}
 		map->stripes[i].dev->in_fs_metadata = 1;
 	}
@@ -6586,19 +6591,24 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
-			btrfs_report_missing_device(fs_info, devid, dev_uuid);
+			btrfs_report_missing_device(fs_info, devid,
+							dev_uuid, 1);
 			return -ENOENT;
 		}
 
 		device = add_missing_dev(fs_devices, devid, dev_uuid);
 		if (IS_ERR(device))
 			return PTR_ERR(device);
-		btrfs_report_missing_device(fs_info, devid, dev_uuid);
+		btrfs_report_missing_device(fs_info, devid, dev_uuid, 0);
 	} else {
 		if (!device->bdev) {
-			btrfs_report_missing_device(fs_info, devid, dev_uuid);
-			if (!btrfs_test_opt(fs_info, DEGRADED))
+			if (!btrfs_test_opt(fs_info, DEGRADED)) {
+				btrfs_report_missing_device(fs_info,
+						devid, dev_uuid, 1);
 				return -ENOENT;
+			}
+			btrfs_report_missing_device(fs_info, devid,
+							dev_uuid, 0);
 		}
 
 		if(!device->bdev && !device->missing) {
-- 
2.7.0

