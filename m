Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752839AbdLOHjq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 02:39:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF7bbKK097132
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:45 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2eva2hr11s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:45 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBF7diS2013565
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:44 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBF7diDl029048
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: optimize move uuid_mutex closer to the critical section
Date: Fri, 15 Dec 2017 15:40:15 +0800
Message-Id: <20171215074016.26461-2-anand.jain@oracle.com>
In-Reply-To: <20171215074016.26461-1-anand.jain@oracle.com>
References: <20171215074016.26461-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move uuid_mutex closer to the exclusion section.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a81574dba124..a7eb9b42cd92 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1187,13 +1187,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	 */
 	bytenr = btrfs_sb_offset(0);
 	flags |= FMODE_EXCL;
-	mutex_lock(&uuid_mutex);
 
 	bdev = blkdev_get_by_path(path, flags, holder);
-	if (IS_ERR(bdev)) {
-		ret = PTR_ERR(bdev);
-		goto error;
-	}
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 
 	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
 		goto error_bdev_put;
@@ -1202,7 +1199,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
 
+	mutex_lock(&uuid_mutex);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
+	if (ret >= 0 && fs_devices_ret)
+		(*fs_devices_ret)->total_devices = total_devices;
+	mutex_unlock(&uuid_mutex);
+
 	if (ret > 0) {
 		if (disk_super->label[0]) {
 			pr_info("BTRFS: device label %s ", disk_super->label);
@@ -1213,15 +1215,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		pr_cont("devid %llu transid %llu %s\n", devid, transid, path);
 		ret = 0;
 	}
-	if (!ret && fs_devices_ret)
-		(*fs_devices_ret)->total_devices = total_devices;
 
 	btrfs_release_disk_super(page);
 
 error_bdev_put:
 	blkdev_put(bdev, flags);
-error:
-	mutex_unlock(&uuid_mutex);
+
 	return ret;
 }
 
-- 
2.7.0

