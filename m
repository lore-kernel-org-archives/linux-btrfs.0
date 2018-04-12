Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752755AbeDLC1s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2RlTX042825
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:47 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2h6pn4srrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RkTt027218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:46 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3C2RkuJ024846
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:46 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/15] btrfs: drop uuid_mutex in btrfs_free_extra_devids()
Date: Thu, 12 Apr 2018 10:29:33 +0800
Message-Id: <20180412022938.8257-11-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_extra_devids() frees the orphan fsid::devid but its search is
limited to btrfs_fs_devices::devices, so we dont need uuid_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8996a1df9a21..85948ef12ecf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -897,7 +897,6 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 	struct btrfs_device *device, *next;
 	struct btrfs_device *latest_dev = NULL;
 
-	mutex_lock(&uuid_mutex);
 again:
 	/* This is the initialized path, it is safe to release the devices. */
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
@@ -951,8 +950,6 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 	}
 
 	fs_devices->latest_bdev = latest_dev->bdev;
-
-	mutex_unlock(&uuid_mutex);
 }
 
 static void free_device_rcu(struct rcu_head *head)
-- 
2.7.0

