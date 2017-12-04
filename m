Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752830AbdLDHOh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 02:14:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB47CAJa048773
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 07:14:37 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2ekpeua7jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 07:14:36 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB47EZUZ029899
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 07:14:36 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB47EZAm013925
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 07:14:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: handle dynamically reappearing missing device
Date: Mon,  4 Dec 2017 15:15:00 +0800
Message-Id: <20171204071500.22034-1-anand.jain@oracle.com>
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
dev open fail and user will rerun the dev scan

v3:
Reword comments in the code.
The device missing check added in v2, is sent as a separate patch
  [patch] btrfs: fix inconsistency during missing device rejoin

 fs/btrfs/volumes.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ac0c4eb5107f..04164337ac69 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -760,8 +760,61 @@ static noinline int device_list_add(const char *path,
 		rcu_string_free(device->name);
 		rcu_assign_pointer(device->name, name);
 		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
-			fs_devices->missing_devices--;
-			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
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
+			 * As of now do not fail the dev scan thread for the
+			 * reason that btrfs_open_one_device() fails and keep
+			 * the legacy dev scan requisites as it is.
+			 * And reset missing only if open is successful, as
+			 * user can rerun dev scan after fixing the device
+			 * for which the device open (below) failed.
+			 */
+			ret = btrfs_open_one_device(fs_devices, device, fmode,
+							fs_info->bdev_holder);
+			if (!ret) {
+				fs_devices->missing_devices--;
+				clear_bit(BTRFS_DEV_STATE_MISSING,
+							&device->dev_state);
+				btrfs_clear_opt(fs_info->mount_opt, DEGRADED);
+				btrfs_warn(fs_info,
+					"BTRFS: device %s devid %llu joined\n",
+					path, devid);
+			}
+
+			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
+							&device->dev_state) &&
+				!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+							&device->dev_state)) {
+				fs_devices->total_rw_bytes +=
+							device->total_bytes;
+				atomic64_add(device->total_bytes -
+						device->bytes_used,
+						&fs_info->free_chunk_space);
+			}
+			set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+							&device->dev_state);
+			mutex_unlock(&fs_info->chunk_mutex);
+			mutex_unlock(&fs_devices->device_list_mutex);
 		}
 	}
 
-- 
2.15.0

