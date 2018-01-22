Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbeAVNax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 08:30:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0MDUO9i022067
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:52 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2fngw88052-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:52 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0MDUpIP023697
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:51 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0MDUp34004602
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: move pr_info into device_list_add
Date: Mon, 22 Jan 2018 21:29:40 +0800
Message-Id: <20180122132943.14729-2-anand.jain@oracle.com>
In-Reply-To: <20180122132943.14729-1-anand.jain@oracle.com>
References: <20180122132943.14729-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 60999ca4b403 ("btrfs: make device scan less noisy")
adds return value 1 to device_list_add(), so that parent function can
call pr_info only when new device is added. Move the pr_info() part
into device_list_add() so that this function can be kept simple.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9e743d289dfd..3a272ae7f32d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -729,8 +729,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
  * Add new device to list of registered devices
  *
  * Returns:
- * 1   - first time device is seen
- * 0   - device already known
+ * 0   - device already known or newly added
  * < 0 - error
  */
 static noinline int device_list_add(const char *path,
@@ -740,7 +739,6 @@ static noinline int device_list_add(const char *path,
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
 	struct rcu_string *name;
-	int ret = 0;
 	u64 found_transid = btrfs_super_generation(disk_super);
 
 	fs_devices = find_fsid(disk_super->fsid);
@@ -780,9 +778,16 @@ static noinline int device_list_add(const char *path,
 		fs_devices->num_devices++;
 		mutex_unlock(&fs_devices->device_list_mutex);
 
-		ret = 1;
 		device->fs_devices = fs_devices;
 		btrfs_free_stale_devices(path, device);
+
+		if (disk_super->label[0])
+			pr_info("BTRFS: device label %s devid %llu transid %llu %s\n",
+				disk_super->label, devid, found_transid, path);
+		else
+			pr_info("BTRFS: device fsid %pU devid %llu transid %llu %s\n",
+				disk_super->fsid, devid, found_transid, path);
+
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
@@ -843,7 +848,7 @@ static noinline int device_list_add(const char *path,
 
 	*fs_devices_ret = fs_devices;
 
-	return ret;
+	return 0;
 }
 
 static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
@@ -1182,7 +1187,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct page *page;
 	int ret;
 	u64 devid;
-	u64 transid;
 	u64 total_devices;
 	u64 bytenr;
 
@@ -1205,25 +1209,14 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	}
 
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
-	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
 
 	mutex_lock(&uuid_mutex);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
-	if (ret >= 0 && fs_devices_ret)
+	if (!ret && fs_devices_ret)
 		(*fs_devices_ret)->total_devices = total_devices;
 	mutex_unlock(&uuid_mutex);
 
-	if (ret > 0) {
-		if (disk_super->label[0])
-			pr_info("BTRFS: device label %s ", disk_super->label);
-		else
-			pr_info("BTRFS: device fsid %pU ", disk_super->fsid);
-
-		pr_cont("devid %llu transid %llu %s\n", devid, transid, path);
-		ret = 0;
-	}
-
 	btrfs_release_disk_super(page);
 
 error_bdev_put:
-- 
2.7.0

