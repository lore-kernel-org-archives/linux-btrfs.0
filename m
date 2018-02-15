Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34374 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbeBOFBA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 00:01:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1F4vWRG108799
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 05:00:59 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2g53cx01aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 05:00:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1F50w0s019143
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 05:00:58 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1F50w96028698
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 05:00:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND] btrfs: delete function btrfs_close_extra_devices()
Date: Thu, 15 Feb 2018 13:02:24 +0800
Message-Id: <20180215050224.21158-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_close_extra_devices() is not exactly about just closing the opened
devices, but its also about free-ing the stale devices which may have
scanned into the btrfs_fs_devices::dev_list. The way it picks devices to
be freed is by going through the btrfs_fs_devices::dev_list and its seed
devices, and finding for devices which do not have the flag
BTRFS_DEV_STATE_IN_FS_METADATA nor if it is part of the replace target.

However, in the first place the way devices are scanned and added to the
btrfs_fs_devices::dev_list have changed for a long time now. During scan
when it finds matching fsid+uuid+devid it would add the device to
btrfs_fs_devices::dev_list. A matched device with higher generation number
overwrites the device with lower generation number during.

Further, the stale devices containing the stale fsid are removed at the
time of the scan itself.

So there isn't any opportunity that btrfs_close_extra_devices() can free
the stale device within the fsid which is being mounted.

Further about the btrfs_fs_devices::latest_bdev that
the btrfs_close_extra_devices() function assigns, is already assigned by
the function __btrfs_open_devices().

So as this function has no effect, delete it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 13 -----------
 fs/btrfs/volumes.c | 63 ------------------------------------------------------
 fs/btrfs/volumes.h |  1 -
 3 files changed, 77 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c412ad1f103b..74ee8a250b8a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2756,17 +2756,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_tree_roots;
 	}
 
-	/*
-	 * keep the device that is marked to be the target device for the
-	 * dev_replace procedure
-	 */
-	btrfs_close_extra_devices(fs_devices, 0);
-
-	if (!fs_devices->latest_bdev) {
-		btrfs_err(fs_info, "failed to read devices");
-		goto fail_tree_roots;
-	}
-
 retry_root_backup:
 	generation = btrfs_super_generation(disk_super);
 
@@ -2823,8 +2812,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_block_groups;
 	}
 
-	btrfs_close_extra_devices(fs_devices, 1);
-
 	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
 	if (ret) {
 		btrfs_err(fs_info, "failed to init sysfs fsid interface: %d",
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9bdc1cd849f2..23658876497c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -896,69 +896,6 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	return ERR_PTR(-ENOMEM);
 }
 
-void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
-{
-	struct btrfs_device *device, *next;
-	struct btrfs_device *latest_dev = NULL;
-
-	mutex_lock(&uuid_mutex);
-again:
-	/* This is the initialized path, it is safe to release the devices. */
-	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
-		if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-							&device->dev_state)) {
-			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-			     &device->dev_state) &&
-			     (!latest_dev ||
-			      device->generation > latest_dev->generation)) {
-				latest_dev = device;
-			}
-			continue;
-		}
-
-		if (device->devid == BTRFS_DEV_REPLACE_DEVID) {
-			/*
-			 * In the first step, keep the device which has
-			 * the correct fsid and the devid that is used
-			 * for the dev_replace procedure.
-			 * In the second step, the dev_replace state is
-			 * read from the device tree and it is known
-			 * whether the procedure is really active or
-			 * not, which means whether this device is
-			 * used or whether it should be removed.
-			 */
-			if (step == 0 || test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-						  &device->dev_state)) {
-				continue;
-			}
-		}
-		if (device->bdev) {
-			blkdev_put(device->bdev, device->mode);
-			device->bdev = NULL;
-			fs_devices->open_devices--;
-		}
-		if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
-			list_del_init(&device->dev_alloc_list);
-			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
-			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-				      &device->dev_state))
-				fs_devices->rw_devices--;
-		}
-		list_del_init(&device->dev_list);
-		fs_devices->num_devices--;
-		free_device(device);
-	}
-
-	if (fs_devices->seed) {
-		fs_devices = fs_devices->seed;
-		goto again;
-	}
-
-	fs_devices->latest_bdev = latest_dev->bdev;
-
-	mutex_unlock(&uuid_mutex);
-}
-
 static void free_device_rcu(struct rcu_head *head)
 {
 	struct btrfs_device *device;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 182bfdce22b9..c8d74589426c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -429,7 +429,6 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *device, struct btrfs_device *this_dev);
 int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
-- 
2.15.0

