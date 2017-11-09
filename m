Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36705 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdKIPp1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 10:45:27 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA9FjQ3g028531
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjQBN000982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:26 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA9FjQAs011485
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:26 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: set fs_devices->seed directly
Date: Thu,  9 Nov 2017 23:45:23 +0800
Message-Id: <20171109154526.23181-2-anand.jain@oracle.com>
In-Reply-To: <20171109154526.23181-1-anand.jain@oracle.com>
References: <20171109154526.23181-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is in preparation to move a section of code in __btrfs_open_devices()
into a new function so that it can be reused. As we set seeding if any of
the device is having SB flag BTRFS_SUPER_FLAG_SEEDING, so do it in the
device list loop itself. No functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b39737568c22..ab2f349ee293 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -978,7 +978,6 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	struct buffer_head *bh;
 	struct btrfs_super_block *disk_super;
 	u64 devid;
-	int seeding = 1;
 	int ret = 0;
 
 	flags |= FMODE_EXCL;
@@ -1010,9 +1009,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
 		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
 			device->writeable = 0;
+			fs_devices->seeding = 1;
 		} else {
 			device->writeable = !bdev_read_only(bdev);
-			seeding = 0;
 		}
 
 		q = bdev_get_queue(bdev);
@@ -1044,7 +1043,6 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		ret = -EINVAL;
 		goto out;
 	}
-	fs_devices->seeding = seeding;
 	fs_devices->opened = 1;
 	fs_devices->latest_bdev = latest_dev->bdev;
 	fs_devices->total_rw_bytes = 0;
-- 
2.13.1

