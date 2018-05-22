Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59486 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbeEVJ14 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 05:27:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4M9Km1I044257
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:27:55 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2j2ck9fmmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:27:55 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4M9RslV020755
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:27:54 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4M9Rr6A012801
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:27:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: drop uuid_mutex in close_fs_devices()
Date: Tue, 22 May 2018 17:30:25 +0800
Message-Id: <20180522093025.12125-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

close_fs_devices() closes devices of a given fsid, and it is limited
to all the devices of a fsid, so we don't have to hold the global
uuid_mutex, instead we need the device_list_mutex as the device state is
being changed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Add comment why we don't need uuid_mutex when touching seed.

 fs/btrfs/volumes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b1e5ac419ca8..f4afd2e78e92 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1025,7 +1025,6 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 					device->uuid);
 	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
 
-	/* Safe because we are under uuid_mutex */
 	if (device->name) {
 		name = rcu_string_strdup(device->name->str, GFP_NOFS);
 		BUG_ON(!name); /* -ENOMEM */
@@ -1043,10 +1042,12 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 
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
@@ -1080,14 +1081,17 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	struct btrfs_fs_devices *seed_devices = NULL;
 	int ret;
 
-	mutex_lock(&uuid_mutex);
 	ret = close_fs_devices(fs_devices);
 	if (!fs_devices->opened) {
 		seed_devices = fs_devices->seed;
 		fs_devices->seed = NULL;
 	}
-	mutex_unlock(&uuid_mutex);
 
+	/*
+	 * As fs_devices::seed is a cloned (and then opned) local copy,
+	 * of the actual seed fs_uuids::fs_devices. So we don't need the
+	 * uuid_mutex.
+	 */
 	while (seed_devices) {
 		fs_devices = seed_devices;
 		seed_devices = fs_devices->seed;
-- 
2.7.0

