Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58704 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752773AbeDLC1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2Q1w2170954
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:45 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2h6kgtj0uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RiL9004119
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:44 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RibT006861
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/15] btrfs: cleanup btrfs_rm_device() use cur_devices
Date: Thu, 12 Apr 2018 10:29:31 +0800
Message-Id: <20180412022938.8257-9-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of de-referencing the device->fs_devices use cur_devices
which points to the same fs_devices.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index db077c505fe0..29799d39554a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1987,20 +1987,25 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	 * (super_copy) should hold the device list mutex.
 	 */
 
+	/*
+	 * In normal cases the cur_devices == fs_devices. But in case
+	 * of deleting a seed device, the cur_devices should point to
+	 * its own fs_devices listed under the fs_devices->seed.
+	 */
 	cur_devices = device->fs_devices;
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_del_rcu(&device->dev_list);
 
-	device->fs_devices->num_devices--;
-	device->fs_devices->total_devices--;
+	cur_devices->num_devices--;
+	cur_devices->total_devices--;
 
 	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
-		device->fs_devices->missing_devices--;
+		cur_devices->missing_devices--;
 
 	btrfs_assign_next_active_device(fs_info, device, NULL);
 
 	if (device->bdev) {
-		device->fs_devices->open_devices--;
+		cur_devices->open_devices--;
 		/* remove sysfs entry */
 		btrfs_sysfs_rm_device_link(fs_devices, device);
 	}
-- 
2.7.0

