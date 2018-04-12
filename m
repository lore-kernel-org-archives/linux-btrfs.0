Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbeDLC1o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2Qomb042329
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:43 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2h6pn4srrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RhIm026977
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:43 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RhXr021327
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/15] btrfs: cleanup btrfs_rm_device() promote fs_devices pointer
Date: Thu, 12 Apr 2018 10:29:30 +0800
Message-Id: <20180412022938.8257-8-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function uses fs_info::fs_devices number of time, however we declare
and use it only at the end, instead do it in the beginning of the function
and use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5714cdaf9c03..db077c505fe0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1918,12 +1918,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_devices;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u64 num_devices;
 	int ret = 0;
 
 	mutex_lock(&uuid_mutex);
 
-	num_devices = fs_info->fs_devices->num_devices;
+	num_devices = fs_devices->num_devices;
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
 		WARN_ON(num_devices < 1);
@@ -1987,7 +1988,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	 */
 
 	cur_devices = device->fs_devices;
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
@@ -2001,12 +2002,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
 		/* remove sysfs entry */
-		btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
+		btrfs_sysfs_rm_device_link(fs_devices, device);
 	}
 
 	num_devices = btrfs_super_num_devices(fs_info->super_copy) - 1;
 	btrfs_set_super_num_devices(fs_info->super_copy, num_devices);
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 
 	/*
 	 * at this point, the device is zero sized and detached from
@@ -2020,8 +2021,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	call_rcu(&device->rcu, free_device_rcu);
 
 	if (cur_devices->open_devices == 0) {
-		struct btrfs_fs_devices *fs_devices;
-		fs_devices = fs_info->fs_devices;
 		while (fs_devices) {
 			if (fs_devices->seed == cur_devices) {
 				fs_devices->seed = cur_devices->seed;
@@ -2042,7 +2041,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
 		list_add(&device->dev_alloc_list,
-			 &fs_info->fs_devices->alloc_list);
+			 &fs_devices->alloc_list);
 		device->fs_devices->rw_devices++;
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
-- 
2.7.0

