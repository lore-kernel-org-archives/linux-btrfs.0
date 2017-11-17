Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50972 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756005AbdKQMgY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 07:36:24 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAHCaM8Y002490
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 12:36:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAHCaLYh016132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 12:36:21 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAHCaL1O022379
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 12:36:21 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2] btrfs: handle dynamically reappearing missing device
Date: Fri, 17 Nov 2017 20:36:14 +0800
Message-Id: <20171117123614.11822-1-anand.jain@oracle.com>
In-Reply-To: <20171112105650.3248-1-anand.jain@oracle.com>
References: <20171112105650.3248-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the device is not present at the time of (-o degrade) mount,
the mount context will create a dummy missing struct btrfs_device.
Later this device may reappear after the FS is mounted and
then device is included in the device list but it missed the
open_device part. So this patch handles that case by going
through the open_device steps which this device missed and finally
adds to the device alloc list.

So now with this patch, to bring back the missing device user can run,

   btrfs dev scan <path-of-missing-device>

Without this kernel patch, even though 'btrfs fi show' and 'btrfs
dev ready' would tell you that missing device has reappeared
successfully but actually in kernel FS layer it didn't.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
This patch needs:
 [PATCH 0/4]  factor __btrfs_open_devices()

v2:
Add more comments.
Add more change log.
Add to check if device missing is set, to handle the case
dev open fail and user will rerun the dev scan.

 fs/btrfs/volumes.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5bd73edc2602..b3224baa6db4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -725,7 +725,9 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-	} else if (!device->name || strcmp(device->name->str, path)) {
+	} else if (!device->name ||
+			strcmp(device->name->str, path) ||
+			device->missing) {
 		/*
 		 * When FS is already mounted.
 		 * 1. If you are here and if the device->name is NULL that
@@ -769,8 +771,63 @@ static noinline int device_list_add(const char *path,
 		rcu_string_free(device->name);
 		rcu_assign_pointer(device->name, name);
 		if (device->missing) {
-			fs_devices->missing_devices--;
-			device->missing = 0;
+			int ret;
+			struct btrfs_fs_info *fs_info = fs_devices->fs_info;
+			fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
+
+			if (btrfs_super_flags(disk_super) &
+					BTRFS_SUPER_FLAG_SEEDING)
+				fmode &= ~FMODE_WRITE;
+
+			/*
+			 * Missing can be set only when FS is mounted.
+			 * So here its always fs_devices->opened > 0 and most
+			 * of the struct device members are already updated by
+			 * the mount process even if this device was missing, so
+			 * now follow the normal open device procedure for this
+			 * device. The scrub will take care of filling the
+			 * missing stripes for raid56 and balance for raid1 and
+			 * raid10.
+			 */
+			ASSERT(fs_devices->opened);
+			mutex_lock(&fs_devices->device_list_mutex);
+			mutex_lock(&fs_info->chunk_mutex);
+			/*
+			 * By not failing for the reason that
+			 * btrfs_open_one_device() could fail, it will
+			 * keep the original behaviors as it is for now.
+			 * That's fix me for later.
+			 */
+			ret = btrfs_open_one_device(fs_devices, device, fmode,
+							fs_info->bdev_holder);
+			if (!ret) {
+				/*
+				 * Making sure missing is set to 0
+				 * only when bdev != NULL is as expected
+				 * at most of the places in the code.
+				 * Further, what if user fixes the
+				 * dev and reruns the dev scan, then again
+				 * we need to come here to reset missing.
+				 */
+				fs_devices->missing_devices--;
+				device->missing = 0;
+				btrfs_clear_opt(fs_info->mount_opt, DEGRADED);
+				btrfs_warn(fs_info,
+					"BTRFS: device %s devid %llu uuid %pU joined\n",
+					path, devid, device->uuid);
+			}
+
+			if (device->writeable &&
+					!device->is_tgtdev_for_dev_replace) {
+				fs_devices->total_rw_bytes +=
+							device->total_bytes;
+				atomic64_add(device->total_bytes -
+						device->bytes_used,
+						&fs_info->free_chunk_space);
+			}
+			device->in_fs_metadata = 1;
+			mutex_unlock(&fs_info->chunk_mutex);
+			mutex_unlock(&fs_devices->device_list_mutex);
 		}
 	}
 
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
