Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36190 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdJIDIG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 23:08:06 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v99385J3019759
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v99385VI031697
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:05 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v99384mf014362
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:04 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs: fix EIO misuse to report missing degraded option
Date: Mon,  9 Oct 2017 11:07:44 +0800
Message-Id: <20171009030746.16680-2-anand.jain@oracle.com>
In-Reply-To: <20171009030746.16680-1-anand.jain@oracle.com>
References: <20171009030746.16680-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

EIO is only for the IO failure to the device, avoid it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: This patch is renamed from
     [PATCH 1/2] btrfs: fix read_one_chunk() return error code

 fs/btrfs/volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2f500a32089e..844ae25cff9e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6448,7 +6448,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
 			btrfs_report_missing_device(fs_info, devid, uuid);
-			return -EIO;
+			return -ENOENT;
 		}
 		if (!map->stripes[i].dev) {
 			map->stripes[i].dev =
@@ -6581,7 +6581,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid, dev_uuid);
-			return -EIO;
+			return -ENOENT;
 		}
 
 		device = add_missing_dev(fs_devices, devid, dev_uuid);
@@ -6592,7 +6592,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 		if (!device->bdev) {
 			btrfs_report_missing_device(fs_info, devid, dev_uuid);
 			if (!btrfs_test_opt(fs_info, DEGRADED))
-				return -EIO;
+				return -ENOENT;
 		}
 
 		if(!device->bdev && !device->missing) {
-- 
2.7.0

