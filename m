Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42032 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbeAVGaF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 01:30:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0M6RSFx054258
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:04 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2fna5e055u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0M6U4pl020422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:04 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0M6U4Fq016216
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:04 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2.1 2/2] btrfs: optimize move uuid_mutex closer to the critical section
Date: Mon, 22 Jan 2018 14:31:08 +0800
Message-Id: <20180122063108.12826-2-anand.jain@oracle.com>
In-Reply-To: <20180122063108.12826-1-anand.jain@oracle.com>
References: <20180122063108.12826-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move uuid_mutex closer to the exclusion section.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
v2->v2.1: updated the v2 reroll log below.
v1->v2:
 Add received reviewed-by. Thxs.
 Fix conflict on top of kdave misc-next.

 fs/btrfs/volumes.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 001894782d84..d9166737c747 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1197,13 +1197,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
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
 
 	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
 		ret = -EINVAL;
@@ -1214,7 +1211,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
 
+	mutex_lock(&uuid_mutex);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
+	if (ret >= 0 && fs_devices_ret)
+		(*fs_devices_ret)->total_devices = total_devices;
+	mutex_unlock(&uuid_mutex);
+
 	if (ret > 0) {
 		if (disk_super->label[0])
 			pr_info("BTRFS: device label %s ", disk_super->label);
@@ -1224,15 +1226,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
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

