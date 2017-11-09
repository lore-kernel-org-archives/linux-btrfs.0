Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16677 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdKIPpb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 10:45:31 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA9FjVmC005985
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjUq0024273
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:31 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA9FjUiV006731
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: move check for device generation to the last
Date: Thu,  9 Nov 2017 23:45:25 +0800
Message-Id: <20171109154526.23181-4-anand.jain@oracle.com>
In-Reply-To: <20171109154526.23181-1-anand.jain@oracle.com>
References: <20171109154526.23181-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes. This helps to move the entire section into
a new function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ea6e542cb09d..0857b580014d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1004,9 +1004,6 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			goto error_brelse;
 
 		device->generation = btrfs_super_generation(disk_super);
-		if (!latest_dev ||
-		    device->generation > latest_dev->generation)
-			latest_dev = device;
 
 		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
 			device->writeable = 0;
@@ -1033,6 +1030,11 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 				 &fs_devices->alloc_list);
 		}
 		brelse(bh);
+
+		if (!latest_dev ||
+		    device->generation > latest_dev->generation)
+			latest_dev = device;
+
 		continue;
 
 error_brelse:
-- 
2.13.1

