Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50813 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdLTHxr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 02:53:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBK7q6Lh062024
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 07:53:46 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2eykhdg2a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 07:53:46 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBK7rjv0024889
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 07:53:45 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBK7rj6C005418
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 07:53:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5] btrfs: handle dynamically reappearing missing device
Date: Wed, 20 Dec 2017 15:54:18 +0800
Message-Id: <20171220075418.12005-1-anand.jain@oracle.com>
In-Reply-To: <20171220073021.9951-1-anand.jain@oracle.com>
References: <20171220073021.9951-1-anand.jain@oracle.com>
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
Hi David,
  btrfs_open_one_device() fails with errno -16 on kdave misc-next,
  traced it to be holder already occupied. I am yet to narrow down
  further -  after my vacation.
  However this patch is tested to be working fine with the mainline.
Thanks,

This patch needs:
 [PATCH 0/4]  factor __btrfs_open_devices()

v5:
. Fix git picking other changes not related to this. Sorry.
v4:
. Handle open_one_dev failure. And we could fail the scan thread if
fs is mounted and device open fails.
. Fix indent.
. Improve commit log.
. No need to set in_fs_metadata flag as its already set on missing device
. Don't reset the degraded mount option. We need that to be reset only
when scrub / balance confirms that volume is not degraded.
. use btrfs_info
v3:
The check for missing in the device_list_add() is now a another
patch as its not related.
 btrfs: fix inconsistency during missing device rejoin

v2:
Add more comments.
Add more change log.
Add to check if device missing is set, to handle the case
dev open fail and user will rerun the dev scan.

 fs/btrfs/volumes.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9e152e196148..65d10f38dd99 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -826,8 +826,55 @@ static noinline int device_list_add(const char *path,
 		rcu_string_free(device->name);
 		rcu_assign_pointer(device->name, name);
 		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
+			int ret;
+			struct btrfs_fs_info *fs_info = fs_devices->fs_info;
+			fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
+
+			if (btrfs_super_flags(disk_super) &
+			    BTRFS_SUPER_FLAG_SEEDING)
+				fmode &= ~FMODE_WRITE;
+
+			/*
+			 * Missing can be set only when FS is mounted.
+			 * So here its always fs_devices->opened > 0 and most
+			 * of the btrfs_device member are already updated by
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
+						    fs_info->bdev_holder);
+			if (ret) {
+				btrfs_err(fs_info,
+					  "device %s devid %llu failed to join %d\n",
+					  path, devid, ret);
+				goto open_failed;
+			}
+
 			fs_devices->missing_devices--;
 			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
+
+			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
+				     &device->dev_state) &&
+			    !test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
+				      &device->dev_state)) {
+				fs_devices->total_rw_bytes +=
+							device->total_bytes;
+				atomic64_add(device->total_bytes -
+							device->bytes_used,
+					     &fs_info->free_chunk_space);
+			}
+			btrfs_info(fs_info, "device %s devid %llu joined\n",
+				   path, devid);
+
+open_failed:
+			mutex_unlock(&fs_info->chunk_mutex);
+			mutex_unlock(&fs_devices->device_list_mutex);
 		}
 	}
 
-- 
2.7.0

