Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17719 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbdKLK4q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 05:56:46 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vACAujvw029405
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Nov 2017 10:56:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vACAujLP010283
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Nov 2017 10:56:45 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vACAui1s023749
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Nov 2017 10:56:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: handle dynamically reappearing missing device
Date: Sun, 12 Nov 2017 18:56:50 +0800
Message-Id: <20171112105650.3248-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the device is not present at the time of (-o degrade) mount
the mount context will create a dummy missing struct btrfs_device.
Later this device may reappear after the FS is mounted. So this
patch handles that case by going through the open_device steps
which this device missed and finally adds to the device alloc list.

So now with this patch, to bring back the missing device user can run,

   btrfs dev scan <path-of-missing-device>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
This patch needs:
 [PATCH 0/4]  factor __btrfs_open_devices()

 fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d24e966ee29f..e7dd996831f2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -769,8 +769,47 @@ static noinline int device_list_add(const char *path,
 		rcu_string_free(device->name);
 		rcu_assign_pointer(device->name, name);
 		if (device->missing) {
-			fs_devices->missing_devices--;
-			device->missing = 0;
+			int ret;
+			struct btrfs_fs_info *fs_info = fs_devices->fs_info;
+			fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
+
+			if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING)
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
+			ret = btrfs_open_one_device(fs_devices, device, fmode,
+							fs_info->bdev_holder);
+			if (!ret) {
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
+				fs_devices->total_rw_bytes += device->total_bytes;
+				atomic64_add(device->total_bytes -
+						device->bytes_used,
+						&fs_info->free_chunk_space);
+			}
+			device->in_fs_metadata = 1;
+			mutex_unlock(&fs_devices->fs_info->chunk_mutex);
+			mutex_unlock(&fs_devices->device_list_mutex);
 		}
 	}
 
-- 
2.13.1

