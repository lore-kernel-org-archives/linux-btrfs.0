Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52364 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756254AbeAROBk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:01:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0IE1dmN010554
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:39 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fjvet0519-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:39 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0IE1dfj024687
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:39 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0IE1d7I003745
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 14:01:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: get device pointer from device_list_add()
Date: Thu, 18 Jan 2018 22:02:35 +0800
Message-Id: <20180118140236.25349-4-anand.jain@oracle.com>
In-Reply-To: <20180118140236.25349-1-anand.jain@oracle.com>
References: <20180118140236.25349-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of pointer to btrfs_fs_devices as an arg in device_list_add()
better to get pointer to btrfs_device as return value, then we have
both, pointer to btrfs_device and btrfs_fs_devices. btrfs_device is
needed to handle reappearing missing device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 66e5dada2d74..d93ee0b91ad9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -726,12 +726,11 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
  * Add new device to list of registered devices
  *
  * Returns:
- * 0   - device already known or newly added
- * < 0 - error
+ * device pointer which was just added or updated when successful
+ * error pointer when failed
  */
-static noinline int device_list_add(const char *path,
-			   struct btrfs_super_block *disk_super,
-			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
+static noinline struct btrfs_device *device_list_add(const char *path,
+			   struct btrfs_super_block *disk_super, u64 devid)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
@@ -742,7 +741,7 @@ static noinline int device_list_add(const char *path,
 	if (!fs_devices) {
 		fs_devices = alloc_fs_devices(disk_super->fsid);
 		if (IS_ERR(fs_devices))
-			return PTR_ERR(fs_devices);
+			return ERR_PTR(PTR_ERR(fs_devices));
 
 		list_add(&fs_devices->list, &fs_uuids);
 
@@ -754,19 +753,19 @@ static noinline int device_list_add(const char *path,
 
 	if (!device) {
 		if (fs_devices->opened)
-			return -EBUSY;
+			return ERR_PTR(-EBUSY);
 
 		device = btrfs_alloc_device(NULL, &devid,
 					    disk_super->dev_item.uuid);
 		if (IS_ERR(device)) {
 			/* we can safely leave the fs_devices entry around */
-			return PTR_ERR(device);
+			return device;
 		}
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name) {
 			free_device(device);
-			return -ENOMEM;
+			return ERR_PTR(-ENOMEM);
 		}
 		rcu_assign_pointer(device->name, name);
 
@@ -820,12 +819,12 @@ static noinline int device_list_add(const char *path,
 			 * with larger generation number or the last-in if
 			 * generation are equal.
 			 */
-			return -EEXIST;
+			return ERR_PTR(-EEXIST);
 		}
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
-			return -ENOMEM;
+			return ERR_PTR(-ENOMEM);
 		rcu_string_free(device->name);
 		rcu_assign_pointer(device->name, name);
 		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
@@ -845,9 +844,7 @@ static noinline int device_list_add(const char *path,
 
 	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
 
-	*fs_devices_ret = fs_devices;
-
-	return 0;
+	return device;
 }
 
 static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
@@ -1182,9 +1179,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_super_block *disk_super;
+	struct btrfs_device *device;
 	struct block_device *bdev;
 	struct page *page;
-	int ret;
+	int ret = 0;
 	u64 devid;
 	u64 bytenr;
 
@@ -1209,8 +1207,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 
 	mutex_lock(&uuid_mutex);
-	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
+	device = device_list_add(path, disk_super, devid);
 	mutex_unlock(&uuid_mutex);
+	if (IS_ERR(device))
+		ret = PTR_ERR(device);
+
+	*fs_devices_ret = device->fs_devices;
 
 	btrfs_release_disk_super(page);
 
-- 
2.7.0

