Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752755AbeDLC14 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2QRK5042143
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:55 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2h6pn4srrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:55 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rs9b001710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:54 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rrqp021367
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/15] btrfs: cleanup btrfs_destroy_dev_replace_tgtdev() localize btrfs_fs_devices
Date: Thu, 12 Apr 2018 10:29:38 +0800
Message-Id: <20180412022938.8257-16-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Declare a local btrfs_fs_devices pointer to access the same, as there are
more than one access to the pointer.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1f694083c15f..d5f8f9a81536 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2119,21 +2119,23 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *tgtdev)
 {
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+
 	WARN_ON(!tgtdev);
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev);
+	btrfs_sysfs_rm_device_link(fs_devices, tgtdev);
 
 	if (tgtdev->bdev)
-		fs_info->fs_devices->open_devices--;
+		fs_devices->open_devices--;
 
-	fs_info->fs_devices->num_devices--;
+	fs_devices->num_devices--;
 
 	btrfs_assign_next_active_device(fs_info, tgtdev, NULL);
 
 	list_del_rcu(&tgtdev->dev_list);
 
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 
 	/*
 	 * The update_dev_time() with in btrfs_scratch_superblocks()
-- 
2.7.0

