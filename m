Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbeDLC1v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2QBoo099059
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:51 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2h6ny3hwhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:51 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RoMa001620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:50 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RohP006973
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/15] btrfs: drop uuid_mutex in close_fs_devices()
Date: Thu, 12 Apr 2018 10:29:35 +0800
Message-Id: <20180412022938.8257-13-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

close_fs_devices() closes devices of a given fsid, and it is limited
to all the devices of a fsid, so we don't have to hold the global
uuid_mutex, instead we need the device_list_mutex as the device state is
being changed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dfebf8f29916..4c29214e0c18 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -995,7 +995,6 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 					device->uuid);
 	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
 
-	/* Safe because we are under uuid_mutex */
 	if (device->name) {
 		name = rcu_string_strdup(device->name->str, GFP_NOFS);
 		BUG_ON(!name); /* -ENOMEM */
@@ -1013,10 +1012,12 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 
 	INIT_LIST_HEAD(&pending_put);
 
-	if (--fs_devices->opened > 0)
+	mutex_lock(&fs_devices->device_list_mutex);
+	if (--fs_devices->opened > 0) {
+		mutex_unlock(&fs_devices->device_list_mutex);
 		return 0;
+	}
 
-	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
 		btrfs_prepare_close_one_device(device);
 		list_add(&device->dev_list, &pending_put);
@@ -1050,13 +1051,11 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	struct btrfs_fs_devices *seed_devices = NULL;
 	int ret;
 
-	mutex_lock(&uuid_mutex);
 	ret = close_fs_devices(fs_devices);
 	if (!fs_devices->opened) {
 		seed_devices = fs_devices->seed;
 		fs_devices->seed = NULL;
 	}
-	mutex_unlock(&uuid_mutex);
 
 	while (seed_devices) {
 		fs_devices = seed_devices;
-- 
2.7.0

