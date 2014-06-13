Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33546 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaFME0h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 00:26:37 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, wangsl.fnst@cn.fujitsu.com
Subject: [PATCH 1/2 v3 RESEND] Btrfs: device_list_add() should not update list when mounted
Date: Fri, 13 Jun 2014 12:26:20 +0800
Message-Id: <1402633581-19265-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

device_list_add() is called when user runs btrfs dev scan, which would add
any btrfs device into the btrfs_fs_devices list.

Now think of a mounted btrfs. And a new device which contains the a SB
from the mounted btrfs devices.

In this situation when user runs btrfs dev scan, the current code would
just replace existing device with the new device.

Which is to note that old device is neither closed nor gracefully
removed from the btrfs.

The FS is still operational with the old bdev however the device name
is the btrfs_device is new which is provided by the btrfs dev scan.

reproducer:

devmgt[1] detach /dev/sdc

replace the missing disk /dev/sdc

btrfs rep start -f 1 /dev/sde /btrfs
Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120
        Total devices 2 FS bytes used 32.00KiB
        devid    1 size 958.94MiB used 115.88MiB path /dev/sde
        devid    2 size 958.94MiB used 103.88MiB path /dev/sdd

make /dev/sdc to reappear

devmgt attach host2

btrfs dev scan

btrfs fi show -m
Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120^M
        Total devices 2 FS bytes used 32.00KiB^M
        devid    1 size 958.94MiB used 115.88MiB path /dev/sdc <- Wrong.
        devid    2 size 958.94MiB used 103.88MiB path /dev/sdd

since /dev/sdc has been replaced with /dev/sde, the /dev/sdc shouldn't be
part of the btrfs-fsid when it reappears. If user want it to be part of it
then sys admin should be using btrfs device add instead.

[1] github.com/anajain/devmgt.git

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: simpler commit and comment message
v1->v2: remove '---' in commit messages which conflict with git am

 fs/btrfs/volumes.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bb2cd66..56822f0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -472,6 +472,7 @@ static noinline int device_list_add(const char *path,
 		device = __find_device(&fs_devices->devices, devid,
 				       disk_super->dev_item.uuid);
 	}
+
 	if (!device) {
 		if (fs_devices->opened)
 			return -EBUSY;
@@ -497,6 +498,32 @@ static noinline int device_list_add(const char *path,
 
 		device->fs_devices = fs_devices;
 	} else if (!device->name || strcmp(device->name->str, path)) {
+		/*
+		 * When FS is already mounted.
+		 * 1. If you are here and if the device->name is NULL that means
+		 *    this device was missing at time of FS mount.
+		 * 2. If you are here and if the device->name is different from 'path'
+		 *    that means either
+		 *      a. The same device disappeared and reappeared with different
+		 *         name. or
+		 *      b. The missing-disk-which-was-replaced, has reappeared now.
+		 *
+		 *  We must allow 1 and 2a above. But 2b would be a spurious and
+		 *  unintentional.
+		 *  Further in case of 1 and 2a above, the disk at 'path' would have
+		 *  missed some transaction when it was away and in case of 2a
+		 *  the stale bdev has to be updated as well.
+		 *  2b must not be allowed at all time.
+		 */
+
+		/*
+		 * As of now don't allow update to btrfs_fs_device through the
+		 * btrfs dev scan cli, after FS has been mounted.
+		 */
+
+		if (fs_devices->opened)
+			return -EBUSY;
+
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
 			return -ENOMEM;
-- 
1.8.5.3

