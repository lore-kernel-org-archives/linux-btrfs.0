Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22669 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdJaM7o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 08:59:44 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9VCxhub007499
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 12:59:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9VCxhqh001323
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 12:59:43 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9VCxhD9016925
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 12:59:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: cleanup btrfs_async_submit_limit to return the final limit value
Date: Tue, 31 Oct 2017 20:59:46 +0800
Message-Id: <20171031125946.26844-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_async_submit_limit() would return the q depth to be 256, however
when we are using it we are making it 2/3 times of it. So instead let
the function return the final computed value.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 6 ++++--
 fs/btrfs/volumes.c | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab849037b..e58bbc2a68a5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -861,7 +861,10 @@ unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
 	unsigned long limit = min_t(unsigned long,
 				    info->thread_pool_size,
 				    info->fs_devices->open_devices);
-	return 256 * limit;
+	/*
+	 * As of now limit is computed as 2/3 * 256.
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

