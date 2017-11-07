Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50927 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753198AbdKGCRs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 21:17:48 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA72Hl8J018694
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 02:17:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA72HlaN017052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 02:17:47 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA72Hl7q017818
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Nov 2017 02:17:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: cleanup btrfs_async_submit_limit to return the final limit value
Date: Tue,  7 Nov 2017 10:17:49 +0800
Message-Id: <20171107021749.15788-1-anand.jain@oracle.com>
In-Reply-To: <20171031125946.26844-1-anand.jain@oracle.com>
References: <20171031125946.26844-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We feedback IO progress when it falls below the 2/3 times of the limit
obtained from btrfs_async_submit_limit() so to creates a wait for the
write process and make uncontested progress during the async submission.

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
only 2/3 of limit (256), so btrfs_async_submit_limit() will return 256 * 2/3.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: add more change log.
v3: don't compute 256 * 2/3. I didn't know compiler will do it anyway,
    thats nice. So keeping that open coded. And comment removed.

 fs/btrfs/disk-io.c | 4 ++--
 fs/btrfs/volumes.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab849037b..6e27259e965b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -861,7 +861,8 @@ unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
 	unsigned long limit = min_t(unsigned long,
 				    info->thread_pool_size,
 				    info->fs_devices->open_devices);
-	return 256 * limit;
+
+	return (256 * 2/3) * limit;
 }
 
 static void run_one_async_start(struct btrfs_work *work)
@@ -887,7 +888,6 @@ static void run_one_async_done(struct btrfs_work *work)
 	fs_info = async->fs_info;
 
 	limit = btrfs_async_submit_limit(fs_info);
-	limit = limit * 2 / 3;
 
 	/*
 	 * atomic_dec_return implies a barrier for waitqueue_active
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b39737568c22..61cefa37b56a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -376,7 +376,6 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 
 	bdi = device->bdev->bd_bdi;
 	limit = btrfs_async_submit_limit(fs_info);
-	limit = limit * 2 / 3;
 
 loop:
 	spin_lock(&device->io_lock);
-- 
2.13.1

