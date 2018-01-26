Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbeAZDBj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 22:01:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q2utq5177338
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 03:01:38 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fqursg1dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 03:01:38 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q31b8V023122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 03:01:37 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0Q31aSx014200
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 03:01:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: delete function btrfs_close_extra_devices()
Date: Fri, 26 Jan 2018 11:02:48 +0800
Message-Id: <20180126030248.9689-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_close_extra_devices() is not exactly about just closing the opened
devices, but its about free-ing the stale devices which may have scanned
into the given fsid which is being mounted.

The way it picks devices to be freeed is by going through the
btrfs_fs_devices::dev_list and finding devices which aren't set with the
BTRFS_DEV_STATE_IN_FS_METADATA flag and also not part of the replace
target. Also do the samething with seed devices as well.

However the devices are added to the btrfs_fs_devices::dev_list is
by fsid+uuid+devid, so only those devices which belong to the respective
fsid will be added to the btrfs_fs_devices::dev_list.
If there are devices with the matching fsid+uuid+devid but with lower
generation number (such as a replace src device) then it gets
overwritten by the device with higher generation number in the list.
So there isn't any opportunity that btrfs_close_extra_devices() can free
the stale device for a given fsid.

The stale devices are actually outside of the given fsid which are in
fact are handled by btrfs_free_stale_devices() well before
btrfs_close_extra_devices() is called.

The btrfs_fs_devices::latest_bdev is also assigned by the
__btrfs_open_devices() and is based on the generation number again.

So this patch deletes btrfs_close_extra_devices() function and its calls
as there is no use of it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 13 -----------
 fs/btrfs/volumes.c | 63 ------------------------------------------------------
 fs/btrfs/volumes.h |  1 -
 3 files changed, 77 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ed095202942f..d36b5e41875c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2766,17 +2766,6 @@ int open_ctree(struct super_block *sb,
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
 
@@ -2833,8 +2822,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_block_groups;
 	}
 
-	btrfs_close_extra_devices(fs_devices, 1);
-
 	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
 	if (ret) {
 		btrfs_err(fs_info, "failed to init sysfs fsid interface: %d",
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 64071db7d8ab..4d090d2897c0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -894,69 +894,6 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
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
index d473a7fc328d..8d6384d1fa83 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -431,7 +431,6 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *device, struct btrfs_device *this_dev);
 int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
-- 
2.15.0

