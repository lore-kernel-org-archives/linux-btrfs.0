Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29120 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdKBGDy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 02:03:54 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA263rGP017979
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 06:03:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA263rYo001107
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 06:03:53 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA263rWh007361
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 06:03:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: cleanup btrfs_async_submit_limit to return the final limit value
Date: Thu,  2 Nov 2017 14:03:53 +0800
Message-Id: <20171102060353.7103-1-anand.jain@oracle.com>
In-Reply-To: <20171031125946.26844-1-anand.jain@oracle.com>
References: <20171031125946.26844-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We feedback IO progress when it falls below 2/3 times of the limit
obtained from btrfs_async_submit_limit(), and creates a wait for the
write process and makes progress during the async submission.

In general device/transport q depth is 256 and, btrfs_async_submit_limit()
returns 256 times per device which originally was introduced by [1]. But
256 at the device level is for all types of IOs (R/W sync/async) and so
may be it was possible that entire of 256 could have occupied by async
writes and, so later patch [2] took only 2/3 times of 256 which seemed to
work well.

 [1]
 cb03c743c648
 Btrfs: Change the congestion functions to meter the number of async submits as well

 [2]
 4854ddd0ed0a
 Btrfs: Wait for kernel threads to make progress during async submission

This patch is a cleanup patch, no functional changes. And now as we are taking
only 2/3 of limit (256), so btrfs_async_submit_limit() will return 170 itself.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
IMO:
1. If the pdflush issue is fixed, we should go back to bdi congestion method,
as block layer is more appropriate and accurate to tell when the device is
congested. Device q depth 256 is very generic.
2. Consider RAID1 devices at different speed (SSD and iscsi LUN) not too sure
if this approach would lead to the FS layer IO performance  throttle at the
speed of the lowest ? wonder how to reliably test it.

 fs/btrfs/disk-io.c | 6 ++++--
 fs/btrfs/volumes.c | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab849037b..12702e292007 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -861,7 +861,10 @@ unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
 	unsigned long limit = min_t(unsigned long,
 				    info->thread_pool_size,
 				    info->fs_devices->open_devices);
-	return 256 * limit;
+	/*
+	 * limit:170 is computed as 2/3 * 256.
+	 */
+	return 170 * limit;
 }
 
 static void run_one_async_start(struct btrfs_work *work)
@@ -887,7 +890,6 @@ static void run_one_async_done(struct btrfs_work *work)
 	fs_info = async->fs_info;
 
 	limit = btrfs_async_submit_limit(fs_info);
-	limit = limit * 2 / 3;
 
 	/*
 	 * atomic_dec_return implies a barrier for waitqueue_active
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d1d8aa226bff..8044790c5de6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -382,7 +382,6 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 
 	bdi = device->bdev->bd_bdi;
 	limit = btrfs_async_submit_limit(fs_info);
-	limit = limit * 2 / 3;
 
 loop:
 	spin_lock(&device->io_lock);
-- 
2.13.1

